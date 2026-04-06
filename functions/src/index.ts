/**
 * Cloud Functions v2 para Smart Granja Aves Pro
 *
 * Triggers automáticos para notificaciones push
 * con idempotencia y API v2 de Firebase Functions.
 */

import * as admin from "firebase-admin";
import { logger } from "firebase-functions";
import {
  onDocumentUpdated,
  onDocumentCreated,
} from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

// Inicializar Firebase Admin
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// =============================================================================
// INTERFACES
// =============================================================================

interface NotificacionData {
  usuarioId: string;
  tipo: string;
  titulo: string;
  mensaje: string;
  fechaCreacion: admin.firestore.Timestamp;
  granjaId?: string;
  granjaName?: string;
  data?: Record<string, string>;
  leida: boolean;
  prioridad: string;
  accionUrl?: string;
}

interface ColaboradorData {
  usuarioId: string;
  rol: string;
  activo: boolean;
}

// =============================================================================
// IDEMPOTENCY GUARD
// =============================================================================

/**
 * Verifica si un evento ya fue procesado usando transacción atómica.
 * Guarda un registro con TTL de 72h para auto-limpieza
 * (requiere TTL policy en la colección _processedEvents.expireAt).
 */
async function isAlreadyProcessed(eventId: string): Promise<boolean> {
  const ref = db.collection("_processedEvents").doc(eventId);
  return db.runTransaction(async (tx) => {
    const doc = await tx.get(ref);
    if (doc.exists) return true;
    tx.set(ref, {
      processedAt: admin.firestore.Timestamp.now(),
      expireAt: admin.firestore.Timestamp.fromDate(
        new Date(Date.now() + 72 * 60 * 60 * 1000)
      ),
    });
    return false;
  });
}

// =============================================================================
// TRIGGER: Stock Bajo en Inventario
// =============================================================================

export const onInventarioUpdate = onDocumentUpdated(
  "granjas/{granjaId}/inventario/{itemId}",
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const { granjaId, itemId } = event.params;
    const before = event.data?.before.data();
    const after = event.data?.after.data();

    if (!before || !after) return;

    // Verificar si el stock bajó del mínimo
    const stockAntes = before.stockActual ?? 0;
    const stockAhora = after.stockActual ?? 0;
    const stockMinimo = after.stockMinimo ?? 0;
    const nombreItem = after.nombre ?? "Producto";

    // Solo notificar cuando cruza el umbral
    if (stockAntes > stockMinimo && stockAhora <= stockMinimo && stockAhora > 0) {
      logger.info(`📦 Stock bajo detectado: ${nombreItem} en granja ${granjaId}`);

      // Obtener nombre de la granja
      const granjaDoc = await db.collection("granjas").doc(granjaId).get();
      const granjaName = granjaDoc.data()?.nombre ?? "Granja";

      // Obtener usuarios a notificar (owner, admin, manager)
      const colaboradores = await db
        .collection("granjas")
        .doc(granjaId)
        .collection("colaboradores")
        .where("rol", "in", ["owner", "admin", "manager"])
        .where("activo", "==", true)
        .get();

      const notificaciones: Promise<void>[] = [];

      for (const colabDoc of colaboradores.docs) {
        const colab = colabDoc.data() as ColaboradorData;

        const notificacion: NotificacionData = {
          usuarioId: colab.usuarioId,
          tipo: "stock_bajo",
          titulo: `⚠️ Stock bajo: ${nombreItem}`,
          mensaje: `Solo quedan ${stockAhora.toFixed(1)} unidades en ${granjaName}`,
          fechaCreacion: admin.firestore.Timestamp.now(),
          granjaId: granjaId,
          granjaName: granjaName,
          data: {
            itemId: itemId,
            stockActual: stockAhora.toString(),
          },
          leida: false,
          prioridad: "alta",
          accionUrl: `/granjas/${granjaId}/inventario`,
        };

        notificaciones.push(
          crearNotificacionYEnviarPush(colab.usuarioId, notificacion)
        );
      }

      const results = await Promise.allSettled(notificaciones);
      const fallidos = results.filter(r => r.status === "rejected").length;
      if (fallidos > 0) {
        logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de stock bajo fallaron`);
      }
      logger.info(`✅ Notificaciones de stock bajo enviadas: ${colaboradores.size}`);
    }
  }
);

// =============================================================================
// TRIGGER: Productos próximos a vencer (Scheduled - diario)
// =============================================================================

export const verificarVencimientos = onSchedule(
  { schedule: "every day 08:00", timeZone: "America/Bogota" },
  async (event) => {
    // Idempotencia basada en hora de ejecución programada
    const scheduleKey = `schedule_vencimientos_${event.scheduleTime}`;
    if (await isAlreadyProcessed(scheduleKey)) {
      logger.info(`Ejecución programada duplicada ignorada: ${scheduleKey}`);
      return;
    }

    logger.info("🕐 Iniciando verificación de vencimientos...");

    const ahora = new Date();
    const en7Dias = new Date(ahora.getTime() + 7 * 24 * 60 * 60 * 1000);

    // Obtener todas las granjas
    const granjas = await db.collection("granjas").get();

    for (const granjaDoc of granjas.docs) {
      const granjaId = granjaDoc.id;
      const granjaName = granjaDoc.data().nombre ?? "Granja";

      // Buscar items próximos a vencer
      const items = await db
        .collection("granjas")
        .doc(granjaId)
        .collection("inventario")
        .where("activo", "==", true)
        .where("fechaVencimiento", "<=", admin.firestore.Timestamp.fromDate(en7Dias))
        .where("fechaVencimiento", ">", admin.firestore.Timestamp.fromDate(ahora))
        .get();

      if (items.empty) continue;

      // Obtener usuarios a notificar
      const colaboradores = await db
        .collection("granjas")
        .doc(granjaId)
        .collection("colaboradores")
        .where("rol", "in", ["owner", "admin"])
        .where("activo", "==", true)
        .get();

      // Batch notifications per granja to avoid timeout on sequential awaits
      const batchPromises: Promise<void>[] = [];

      for (const itemDoc of items.docs) {
        const item = itemDoc.data();
        const fechaVenc = (item.fechaVencimiento as admin.firestore.Timestamp).toDate();
        const diasRestantes = Math.ceil(
          (fechaVenc.getTime() - ahora.getTime()) / (1000 * 60 * 60 * 24)
        );

        for (const colabDoc of colaboradores.docs) {
          const colab = colabDoc.data() as ColaboradorData;

          const notificacion: NotificacionData = {
            usuarioId: colab.usuarioId,
            tipo: "proximo_vencer",
            titulo: `📅 Próximo a vencer: ${item.nombre}`,
            mensaje: `Vence en ${diasRestantes} días en ${granjaName}`,
            fechaCreacion: admin.firestore.Timestamp.now(),
            granjaId: granjaId,
            granjaName: granjaName,
            data: {
              itemId: itemDoc.id,
              diasRestantes: diasRestantes.toString(),
            },
            leida: false,
            prioridad: diasRestantes <= 3 ? "alta" : "normal",
            accionUrl: `/granjas/${granjaId}/inventario`,
          };

          batchPromises.push(
            crearNotificacionYEnviarPush(colab.usuarioId, notificacion)
          );
        }
      }

      // Execute all notifications for this granja in parallel
      const results = await Promise.allSettled(batchPromises);
      const fallidos = results.filter(r => r.status === "rejected").length;
      if (fallidos > 0) {
        logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de vencimiento fallaron en ${granjaName}`);
      }
    }

    logger.info("✅ Verificación de vencimientos completada");
  }
);

// =============================================================================
// TRIGGER: Alta mortalidad registrada
// =============================================================================

export const onMortalidadRegistrada = onDocumentCreated(
  "granjas/{granjaId}/lotes/{loteId}/mortalidad/{mortalidadId}",
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const { granjaId, loteId } = event.params;
    const mortalidad = event.data?.data();

    if (!mortalidad) return;

    const cantidadMuertos = mortalidad.cantidadMuertos ?? 0;

    // Obtener datos del lote
    const loteDoc = await db
      .collection("granjas")
      .doc(granjaId)
      .collection("lotes")
      .doc(loteId)
      .get();

    if (!loteDoc.exists) return;

    const lote = loteDoc.data()!;
    // Use || instead of ?? to also catch 0, preventing division by zero
    const cantidadTotal = lote.cantidadActual || lote.cantidadInicial || 1;
    const porcentaje = (cantidadMuertos / cantidadTotal) * 100;

    // Solo alertar si mortalidad > 2%
    if (porcentaje <= 2) return;

    logger.warn(`🚨 Mortalidad alta detectada: ${porcentaje.toFixed(1)}%`);

    const loteNombre = lote.nombre ?? "Lote";

    // Parallel reads — granjaDoc and colaboradores are independent
    const [granjaDoc, colaboradores] = await Promise.all([
      db.collection("granjas").doc(granjaId).get(),
      db.collection("granjas")
        .doc(granjaId)
        .collection("colaboradores")
        .where("rol", "in", ["owner", "admin", "manager"])
        .where("activo", "==", true)
        .get(),
    ]);
    const granjaName = granjaDoc.data()?.nombre ?? "Granja";

    const notificaciones: Promise<void>[] = [];

    for (const colabDoc of colaboradores.docs) {
      const colab = colabDoc.data() as ColaboradorData;

      const notificacion: NotificacionData = {
        usuarioId: colab.usuarioId,
        tipo: "mortalidad_alta",
        titulo: `🚨 Mortalidad alta en ${loteNombre}`,
        mensaje: `${porcentaje.toFixed(1)}% de mortalidad (${cantidadMuertos} aves) en ${granjaName}`,
        fechaCreacion: admin.firestore.Timestamp.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        data: {
          loteId: loteId,
          porcentaje: porcentaje.toFixed(1),
        },
        leida: false,
        prioridad: porcentaje > 5 ? "urgente" : "alta",
        accionUrl: `/granjas/${granjaId}/lotes/${loteId}`,
      };

      notificaciones.push(
        crearNotificacionYEnviarPush(colab.usuarioId, notificacion)
      );
    }

    const results = await Promise.allSettled(notificaciones);
    const fallidos = results.filter(r => r.status === "rejected").length;
    if (fallidos > 0) {
      logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de mortalidad fallaron`);
    }
    logger.info(`✅ Notificaciones de mortalidad enviadas: ${colaboradores.size}`);
  }
);

// =============================================================================
// TRIGGER: Nueva invitación creada
// =============================================================================

export const onInvitacionCreada = onDocumentCreated(
  "granjas/{granjaId}/invitaciones/{invitacionId}",
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const { granjaId } = event.params;
    const invitacion = event.data?.data();

    if (!invitacion) return;

    const emailInvitado = invitacion.emailInvitado;
    const invitadoPor = invitacion.invitadoPorNombre ?? "Alguien";

    // Buscar usuario por email
    const usuariosQuery = await db
      .collection("usuarios")
      .where("email", "==", emailInvitado)
      .limit(1)
      .get();

    if (usuariosQuery.empty) {
      logger.info(`Usuario no registrado: ${emailInvitado}`);
      return;
    }

    const usuarioDoc = usuariosQuery.docs[0];
    const usuarioId = usuarioDoc.id;

    const granjaDoc = await db.collection("granjas").doc(granjaId).get();
    const granjaName = granjaDoc.data()?.nombre ?? "Granja";

    const notificacion: NotificacionData = {
      usuarioId: usuarioId,
      tipo: "invitacion_recibida",
      titulo: `🎉 Invitación a ${granjaName}`,
      mensaje: `${invitadoPor} te ha invitado a colaborar`,
      fechaCreacion: admin.firestore.Timestamp.now(),
      granjaId: granjaId,
      granjaName: granjaName,
      data: {
        codigoInvitacion: invitacion.codigo ?? "",
      },
      leida: false,
      prioridad: "alta",
      accionUrl: "/aceptar-invitacion",
    };

    await crearNotificacionYEnviarPush(usuarioId, notificacion);
    logger.info(`✅ Notificación de invitación enviada a ${emailInvitado}`);
  }
);

// =============================================================================
// TRIGGER: Invitación aceptada
// =============================================================================

export const onColaboradorAgregado = onDocumentCreated(
  "granjas/{granjaId}/colaboradores/{colaboradorId}",
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const { granjaId } = event.params;
    const colaborador = event.data?.data();

    if (!colaborador) return;

    // No notificar al owner original
    if (colaborador.rol === "owner") return;

    const nuevoUsuarioId = colaborador.usuarioId;
    const rol = colaborador.rol;

    // Parallel reads — all three queries are independent
    const [usuarioDoc, granjaDoc, owners] = await Promise.all([
      db.collection("usuarios").doc(nuevoUsuarioId).get(),
      db.collection("granjas").doc(granjaId).get(),
      db.collection("granjas")
        .doc(granjaId)
        .collection("colaboradores")
        .where("rol", "==", "owner")
        .where("activo", "==", true)
        .get(),
    ]);
    const nombreColaborador = usuarioDoc.data()?.nombreCompleto ?? "Nuevo usuario";
    const granjaName = granjaDoc.data()?.nombre ?? "Granja";

    const rolLabels: Record<string, string> = {
      admin: "Administrador",
      manager: "Encargado",
      operator: "Operador",
      viewer: "Observador",
    };

    for (const ownerDoc of owners.docs) {
      const owner = ownerDoc.data() as ColaboradorData;

      // No notificar si el owner es el mismo que se agregó
      if (owner.usuarioId === nuevoUsuarioId) continue;

      const notificacion: NotificacionData = {
        usuarioId: owner.usuarioId,
        tipo: "invitacion_aceptada",
        titulo: "👤 Nuevo colaborador",
        mensaje: `${nombreColaborador} se unió como ${rolLabels[rol] ?? rol} a ${granjaName}`,
        fechaCreacion: admin.firestore.Timestamp.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        data: {
          nuevoUsuarioId: nuevoUsuarioId,
          rol: rol,
        },
        leida: false,
        prioridad: "normal",
        accionUrl: `/granjas/${granjaId}/colaboradores`,
      };

      await crearNotificacionYEnviarPush(owner.usuarioId, notificacion);
    }

    logger.info(`✅ Notificación de nuevo colaborador enviada`);
  }
);

// =============================================================================
// FUNCIÓN HELPER: Crear notificación y enviar push
// =============================================================================

async function crearNotificacionYEnviarPush(
  usuarioId: string,
  notificacion: NotificacionData
): Promise<void> {
  try {
    // Guardar en Firestore
    await db
      .collection("usuarios")
      .doc(usuarioId)
      .collection("notificaciones")
      .add(notificacion);

    // Obtener tokens FCM del usuario
    const usuarioDoc = await db.collection("usuarios").doc(usuarioId).get();
    const fcmTokens = usuarioDoc.data()?.fcmTokens as string[] | undefined;

    if (!fcmTokens || fcmTokens.length === 0) {
      logger.info(`No hay tokens FCM para usuario ${usuarioId}`);
      return;
    }

    // Enviar push notification
    const message: admin.messaging.MulticastMessage = {
      tokens: fcmTokens,
      notification: {
        title: notificacion.titulo,
        body: notificacion.mensaje,
      },
      data: {
        tipo: notificacion.tipo,
        granjaId: notificacion.granjaId ?? "",
        accionUrl: notificacion.accionUrl ?? "",
        ...notificacion.data,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "smart_granja_aves_channel",
          priority: "high",
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      apns: {
        payload: {
          aps: {
            alert: {
              title: notificacion.titulo,
              body: notificacion.mensaje,
            },
            sound: "default",
            badge: 1,
          },
        },
      },
    };

    const response = await messaging.sendEachForMulticast(message);
    logger.info(
      `Push enviado: ${response.successCount} éxitos, ${response.failureCount} fallos`
    );

    // Limpiar tokens inválidos
    if (response.failureCount > 0) {
      const tokensToRemove: string[] = [];
      response.responses.forEach((resp: admin.messaging.SendResponse, idx: number) => {
        if (!resp.success) {
          const error = resp.error;
          if (
            error?.code === "messaging/invalid-registration-token" ||
            error?.code === "messaging/registration-token-not-registered"
          ) {
            tokensToRemove.push(fcmTokens[idx]);
          }
        }
      });

      if (tokensToRemove.length > 0) {
        await db
          .collection("usuarios")
          .doc(usuarioId)
          .update({
            fcmTokens: admin.firestore.FieldValue.arrayRemove(...tokensToRemove),
          });
        logger.info(`Tokens inválidos eliminados: ${tokensToRemove.length}`);
      }
    }
  } catch (error) {
    logger.error(`Error enviando notificación a ${usuarioId}:`, error);
  }
}
