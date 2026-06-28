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

// Suscripciones: validación de compras Play (callable) + RTDN (Pub/Sub).
export { validarCompraPlay, onPlayNotification } from "./suscripciones";

// Credenciales de WhatsApp (opcionales): se leen del entorno en runtime.
// Si no están configuradas, el envío por WhatsApp se omite con un warning,
// permitiendo desplegar el resto de funciones sin bloquear por el secreto.
const whatsappAccessToken = {
  value: () => (process.env.WHATSAPP_ACCESS_TOKEN ?? "").trim(),
};
const whatsappPhoneNumberId = {
  value: () => (process.env.WHATSAPP_PHONE_NUMBER_ID ?? "").trim(),
};
const whatsappTemplateMortalidad = {
  value: () => (process.env.WHATSAPP_TEMPLATE_MORTALIDAD ?? "").trim(),
};

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

interface UsuarioData {
  nombre?: string;
  apellido?: string;
  nombreCompleto?: string;
  telefono?: string;
  telefonoWhatsApp?: string;
  activo?: boolean;
  whatsappOptIn?: boolean;
  notificacionesWhatsApp?: boolean;
  metadata?: Record<string, unknown>;
  notificaciones?: Record<string, unknown>;
}

interface WhatsAppTemplateParameter {
  type: "text";
  text: string;
}

interface WhatsAppTemplateComponent {
  type: "body";
  parameters: WhatsAppTemplateParameter[];
}

interface WhatsAppTemplateMessage {
  messaging_product: "whatsapp";
  to: string;
  type: "template";
  template: {
    name: string;
    language: {
      code: string;
    };
    components: WhatsAppTemplateComponent[];
  };
}

interface WhatsAppSendResult {
  ok: boolean;
  status: number;
  response: unknown;
  messageId?: string;
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

      // Obtener usuarios a notificar (owner, admin, manager) desde la
      // colección correcta `granja_usuarios` (ver getDestinatariosGranja).
      const destinatarios = await getDestinatariosGranja(granjaId);

      const notificaciones: Promise<void>[] = [];

      for (const usuarioId of destinatarios) {
        const notificacion: NotificacionData = {
          usuarioId: usuarioId,
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
          crearNotificacionYEnviarPush(usuarioId, notificacion)
        );
      }

      const results = await Promise.allSettled(notificaciones);
      const fallidos = results.filter(r => r.status === "rejected").length;
      if (fallidos > 0) {
        logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de stock bajo fallaron`);
      }
      logger.info(`✅ Notificaciones de stock bajo enviadas: ${destinatarios.length}`);
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

      // Obtener usuarios a notificar (owner/admin) desde `granja_usuarios`.
      const destinatarios = await getDestinatariosGranja(granjaId, [
        "owner",
        "admin",
      ]);
      if (destinatarios.length === 0) continue;

      // Batch notifications per granja to avoid timeout on sequential awaits
      const batchPromises: Promise<void>[] = [];

      for (const itemDoc of items.docs) {
        const item = itemDoc.data();
        const fechaVenc = (item.fechaVencimiento as admin.firestore.Timestamp).toDate();
        const diasRestantes = Math.ceil(
          (fechaVenc.getTime() - ahora.getTime()) / (1000 * 60 * 60 * 24)
        );

        for (const usuarioId of destinatarios) {
          const notificacion: NotificacionData = {
            usuarioId: usuarioId,
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
            crearNotificacionYEnviarPush(usuarioId, notificacion)
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
  {
    document: "lotes/{loteId}/mortalidad/{mortalidadId}",
  },
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const { loteId, mortalidadId } = event.params;
    const mortalidad = event.data?.data();

    if (!mortalidad) return;

    const granjaId = toText(mortalidad.granjaId);
    if (!granjaId) {
      logger.warn(`Registro de mortalidad sin granjaId: ${loteId}/${mortalidadId}`);
      return;
    }

    const loteDoc = await db.collection("lotes").doc(loteId).get();
    if (!loteDoc.exists) {
      logger.warn(`Lote no encontrado para mortalidad: ${loteId}`);
      return;
    }

    const lote = loteDoc.data() ?? {};
    const cantidadMuertos = toNumber(
      mortalidad.cantidad,
      toNumber(mortalidad.cantidadMuertos)
    );
    const cantidadInicial = toNumber(lote.cantidadInicial);
    const mortalidadAcumulada = toNumber(
      lote.mortalidadAcumulada,
      cantidadMuertos
    );
    const porcentaje = cantidadInicial > 0
      ? (mortalidadAcumulada / cantidadInicial) * 100
      : 0;

    logger.info(`Mortalidad registrada: acumulado ${porcentaje.toFixed(1)}%`);

    const loteNombre = toText(lote.nombre) || toText(lote.codigo) || "Lote";

    // Parallel reads — granjaDoc and colaboradores are independent
    const [granjaDoc, colaboradores] = await Promise.all([
      db.collection("granjas").doc(granjaId).get(),
      db.collection("granja_usuarios")
        .where("granjaId", "==", granjaId)
        .where("rol", "in", ["owner", "admin", "manager"])
        .where("activo", "==", true)
        .get(),
    ]);
    const granjaName = granjaDoc.data()?.nombre ?? "Granja";
    const causa = toText(mortalidad.causa, "No especificada");
    const fecha = formatFirestoreDate(mortalidad.fecha);
    const registradoPor = toText(mortalidad.nombreUsuario, "Usuario");

    logger.info(
      `Mortalidad registrada: ${cantidadMuertos} aves en ${loteNombre} (${granjaName})`
    );

    if (colaboradores.empty) {
      logger.warn(`No hay responsables activos para granja ${granjaId}`);
      return;
    }

    const envios: Promise<void>[] = [];

    for (const colabDoc of colaboradores.docs) {
      const colab = colabDoc.data() as ColaboradorData;
      if (!colab.usuarioId) continue;

      envios.push(
        enviarWhatsAppMortalidad({
          usuarioId: colab.usuarioId,
          eventId: event.id,
          granjaId,
          granjaName,
          loteId,
          loteNombre,
          mortalidadId,
          cantidadMuertos,
          causa,
          porcentaje,
          registradoPor,
          fecha,
        })
      );
    }

    const results = await Promise.allSettled(envios);
    const fallidos = results.filter(r => r.status === "rejected").length;
    if (fallidos > 0) {
      logger.warn(`${fallidos}/${results.length} salidas WhatsApp de mortalidad fallaron`);
    }
    logger.info(`Salidas WhatsApp de mortalidad procesadas: ${results.length}`);
  }
);

// =============================================================================
// HELPERS: Salida WhatsApp de mortalidad
// =============================================================================

async function enviarWhatsAppMortalidad(params: {
  usuarioId: string;
  eventId: string;
  granjaId: string;
  granjaName: string;
  loteId: string;
  loteNombre: string;
  mortalidadId: string;
  cantidadMuertos: number;
  causa: string;
  porcentaje: number;
  registradoPor: string;
  fecha: string;
}): Promise<void> {
  const usuarioDoc = await db.collection("usuarios").doc(params.usuarioId).get();
  const usuario = usuarioDoc.data() as UsuarioData | undefined;
  const salidaId = `${params.eventId}_${params.usuarioId}`;
  const baseSalida = {
    canal: "whatsapp",
    tipo: "mortalidad_registrada",
    usuarioId: params.usuarioId,
    granjaId: params.granjaId,
    loteId: params.loteId,
    mortalidadId: params.mortalidadId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  // Si las credenciales de WhatsApp no están configuradas en el entorno,
  // se omite el envío de forma limpia (sin error) hasta que se configuren.
  if (!whatsappAccessToken.value() || !whatsappPhoneNumberId.value()) {
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: "skipped",
      reason: "whatsapp_no_configurado",
    });
    return;
  }

  if (!usuario) {
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: "skipped",
      reason: "usuario_no_encontrado",
    });
    return;
  }

  if (!tieneWhatsAppHabilitado(usuario)) {
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: "skipped",
      reason: "whatsapp_no_habilitado",
    });
    return;
  }

  const telefono = normalizarTelefonoWhatsApp(
    toText(usuario.telefonoWhatsApp) || toText(usuario.telefono)
  );

  if (!telefono) {
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: "skipped",
      reason: "telefono_whatsapp_invalido",
    });
    return;
  }

  const nombreUsuario = nombreParaWhatsApp(usuario);
  const parameters = [
    nombreUsuario,
    params.granjaName,
    params.loteNombre,
    params.cantidadMuertos.toString(),
    params.causa,
    `${params.porcentaje.toFixed(1)}%`,
    params.registradoPor,
    params.fecha,
  ];

  await guardarSalidaWhatsApp(salidaId, {
    ...baseSalida,
    status: "pending",
    to: telefono,
    template: whatsappTemplateMortalidad.value(),
    parameters,
  });

  try {
    const result = await enviarPlantillaWhatsApp(telefono, parameters);
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: result.ok ? "sent" : "failed",
      to: telefono,
      template: whatsappTemplateMortalidad.value(),
      messageId: result.messageId ?? null,
      graphStatus: result.status,
      graphResponse: result.response,
      sentAt: result.ok ? admin.firestore.FieldValue.serverTimestamp() : null,
    });
  } catch (error) {
    await guardarSalidaWhatsApp(salidaId, {
      ...baseSalida,
      status: "failed",
      to: telefono,
      template: whatsappTemplateMortalidad.value(),
      error: error instanceof Error ? error.message : String(error),
    });
    logger.error(`Error enviando WhatsApp de mortalidad a ${params.usuarioId}`, error);
  }
}

async function guardarSalidaWhatsApp(
  salidaId: string,
  data: Record<string, unknown>
): Promise<void> {
  await db.collection("whatsapp_mensajes").doc(salidaId).set(data, {
    merge: true,
  });
}

async function enviarPlantillaWhatsApp(
  to: string,
  texts: string[]
): Promise<WhatsAppSendResult> {
  const accessToken = whatsappAccessToken.value().trim();
  const phoneNumberId = whatsappPhoneNumberId.value().trim();
  const templateName = whatsappTemplateMortalidad.value().trim();

  if (!accessToken || !phoneNumberId || !templateName) {
    throw new Error("Secrets de WhatsApp incompletos");
  }

  const payload: WhatsAppTemplateMessage = {
    messaging_product: "whatsapp",
    to,
    type: "template",
    template: {
      name: templateName,
      language: {
        code: process.env.WHATSAPP_TEMPLATE_LANGUAGE ?? "es",
      },
      components: [
        {
          type: "body",
          parameters: texts.map((text) => ({
            type: "text",
            text,
          })),
        },
      ],
    },
  };

  const graphVersion = process.env.WHATSAPP_GRAPH_VERSION ?? "v20.0";
  const response = await fetch(
    `https://graph.facebook.com/${graphVersion}/${phoneNumberId}/messages`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    }
  );
  const raw = await response.text();
  const parsed = parseJson(raw);

  return {
    ok: response.ok,
    status: response.status,
    response: parsed ?? raw,
    messageId: obtenerWhatsAppMessageId(parsed),
  };
}

function tieneWhatsAppHabilitado(usuario: UsuarioData): boolean {
  const metadataOptIn = usuario.metadata?.whatsappOptIn === true;
  const preferenciasOptIn = usuario.notificaciones?.whatsapp === true;
  return usuario.whatsappOptIn === true ||
    usuario.notificacionesWhatsApp === true ||
    metadataOptIn ||
    preferenciasOptIn;
}

function normalizarTelefonoWhatsApp(value: string): string | null {
  const digits = value.replace(/\D/g, "");
  if (!digits) return null;
  const normalized = digits.startsWith("00") ? digits.substring(2) : digits;

  if (normalized.length === 9 && normalized.startsWith("9")) {
    return `51${normalized}`;
  }

  if (normalized.length >= 10 && normalized.length <= 15) {
    return normalized;
  }

  return null;
}

function nombreParaWhatsApp(usuario: UsuarioData): string {
  const nombreCompleto = toText(usuario.nombreCompleto);
  if (nombreCompleto) return nombreCompleto;

  const nombre = [toText(usuario.nombre), toText(usuario.apellido)]
    .filter(Boolean)
    .join(" ")
    .trim();

  return nombre || "usuario";
}

function toNumber(value: unknown, fallback = 0): number {
  if (typeof value === "number" && Number.isFinite(value)) return value;
  if (typeof value === "string") {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) return parsed;
  }
  return fallback;
}

function toText(value: unknown, fallback = ""): string {
  if (typeof value === "string" && value.trim()) return value.trim();
  if (typeof value === "number" && Number.isFinite(value)) return value.toString();
  return fallback;
}

function formatFirestoreDate(value: unknown): string {
  if (value instanceof admin.firestore.Timestamp) {
    return value.toDate().toLocaleDateString("es-PE");
  }

  if (value instanceof Date) {
    return value.toLocaleDateString("es-PE");
  }

  return new Date().toLocaleDateString("es-PE");
}

function parseJson(raw: string): unknown {
  try {
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

function obtenerWhatsAppMessageId(response: unknown): string | undefined {
  if (!response || typeof response !== "object") return undefined;

  const messages = (response as { messages?: unknown }).messages;
  if (!Array.isArray(messages) || messages.length === 0) return undefined;

  const first = messages[0];
  if (!first || typeof first !== "object") return undefined;

  const id = (first as { id?: unknown }).id;
  return typeof id === "string" ? id : undefined;
}

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

// Escucha la colección TOP-LEVEL `granja_usuarios` (docId `{granjaId}_{uid}`),
// que es donde la app crea las membresías. Antes escuchaba la subcolección
// `granjas/{id}/colaboradores`, que la app NUNCA escribe → el trigger jamás
// se disparaba.
export const onColaboradorAgregado = onDocumentCreated(
  "granja_usuarios/{membresiaId}",
  async (event) => {
    if (await isAlreadyProcessed(event.id)) {
      logger.info(`Evento duplicado ignorado: ${event.id}`);
      return;
    }

    const colaborador = event.data?.data();
    if (!colaborador) return;

    // granjaId/usuarioId vienen como campos del documento top-level.
    const granjaId = colaborador.granjaId as string | undefined;
    const nuevoUsuarioId = colaborador.usuarioId as string | undefined;
    const rol = colaborador.rol as string | undefined;
    if (!granjaId || !nuevoUsuarioId || !rol) return;

    // No notificar al owner original
    if (rol === "owner") return;

    // Lecturas en paralelo: datos del nuevo usuario, granja y owners destino.
    const [usuarioDoc, granjaDoc, owners] = await Promise.all([
      db.collection("usuarios").doc(nuevoUsuarioId).get(),
      db.collection("granjas").doc(granjaId).get(),
      getDestinatariosGranja(granjaId, ["owner", "admin"]),
    ]);
    const nombreColaborador = usuarioDoc.data()?.nombreCompleto ?? "Nuevo usuario";
    const granjaName = granjaDoc.data()?.nombre ?? "Granja";

    const rolLabels: Record<string, string> = {
      admin: "Administrador",
      manager: "Encargado",
      operator: "Operador",
      viewer: "Observador",
    };

    for (const ownerId of owners) {
      // No notificar si el destinatario es el mismo que se agregó
      if (ownerId === nuevoUsuarioId) continue;

      const notificacion: NotificacionData = {
        usuarioId: ownerId,
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

      await crearNotificacionYEnviarPush(ownerId, notificacion);
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

// =============================================================================
// SCHEDULED: Verificación periódica de alertas (consolidada, server-side)
// =============================================================================
//
// Solución definitiva al costo del scheduler client-side: estas verificaciones
// corren UNA vez por granja en el servidor, en vez de en cada dispositivo de
// cada usuario. Mientras esta function esté activa, el cliente puede dejar de
// ejecutar `AlertasService.ejecutarVerificacionesProgramadas` (el lock
// distribuido del cliente es solo un puente hasta que esto se despliegue).
//
// Todas las functions de notificación ya leen destinatarios desde
// `granja_usuarios` (vía `getDestinatariosGranja`), que es donde la app
// escribe las membresías.
//
// TODO(server-side): portar desde Dart (AlertasService) las verificaciones
// que aún no tienen function dedicada: lotes próximos a cierre, lotes sin
// registros, vacunaciones programadas, inspecciones pendientes y entregas
// programadas. Cada una: query por granja + dedupe + crearNotificacionYEnviarPush.
export const verificarAlertasPeriodicas = onSchedule(
  { schedule: "every 30 minutes", timeZone: "America/Bogota" },
  async (event) => {
    const scheduleKey = `schedule_alertas_${event.scheduleTime}`;
    if (await isAlreadyProcessed(scheduleKey)) {
      logger.info(`Ejecución periódica duplicada ignorada: ${scheduleKey}`);
      return;
    }

    logger.info("🕐 Iniciando verificación periódica de alertas...");

    const granjas = await db.collection("granjas").get();
    for (const granjaDoc of granjas.docs) {
      const granjaId = granjaDoc.id;
      try {
        // TODO: invocar aquí las verificaciones portadas (ver TODO de arriba).
        // De momento es un esqueleto idempotente listo para extender sin
        // cambiar el wiring del scheduler ni el schedule.
        void granjaId;
      } catch (error) {
        logger.error(`Error verificando alertas de ${granjaId}:`, error);
      }
    }

    logger.info("✅ Verificación periódica de alertas completada");
  }
);

/**
 * Obtiene los usuarioIds destinatarios (owner/admin/manager activos) de una
 * granja desde la colección correcta `granja_usuarios`. Usar esto en lugar de
 * `granjas/{id}/colaboradores` para que las notificaciones server-side lleguen.
 */
export async function getDestinatariosGranja(
  granjaId: string,
  roles: string[] = ["owner", "admin", "manager"]
): Promise<string[]> {
  const snap = await db
    .collection("granja_usuarios")
    .where("granjaId", "==", granjaId)
    .where("activo", "==", true)
    .where("rol", "in", roles)
    .get();
  return snap.docs.map((d) => d.data().usuarioId as string);
}
