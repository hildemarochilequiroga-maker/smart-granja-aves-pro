"use strict";
/**
 * Cloud Functions v2 para Smart Granja Aves Pro
 *
 * Triggers automáticos para notificaciones push
 * con idempotencia y API v2 de Firebase Functions.
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.onColaboradorAgregado = exports.onInvitacionCreada = exports.onMortalidadRegistrada = exports.verificarVencimientos = exports.onInventarioUpdate = void 0;
const admin = __importStar(require("firebase-admin"));
const firebase_functions_1 = require("firebase-functions");
const firestore_1 = require("firebase-functions/v2/firestore");
const scheduler_1 = require("firebase-functions/v2/scheduler");
// Inicializar Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();
// =============================================================================
// IDEMPOTENCY GUARD
// =============================================================================
/**
 * Verifica si un evento ya fue procesado usando transacción atómica.
 * Guarda un registro con TTL de 72h para auto-limpieza
 * (requiere TTL policy en la colección _processedEvents.expireAt).
 */
async function isAlreadyProcessed(eventId) {
    const ref = db.collection("_processedEvents").doc(eventId);
    return db.runTransaction(async (tx) => {
        const doc = await tx.get(ref);
        if (doc.exists)
            return true;
        tx.set(ref, {
            processedAt: admin.firestore.Timestamp.now(),
            expireAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 72 * 60 * 60 * 1000)),
        });
        return false;
    });
}
// =============================================================================
// TRIGGER: Stock Bajo en Inventario
// =============================================================================
exports.onInventarioUpdate = (0, firestore_1.onDocumentUpdated)("granjas/{granjaId}/inventario/{itemId}", async (event) => {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const { granjaId, itemId } = event.params;
    const before = (_a = event.data) === null || _a === void 0 ? void 0 : _a.before.data();
    const after = (_b = event.data) === null || _b === void 0 ? void 0 : _b.after.data();
    if (!before || !after)
        return;
    // Verificar si el stock bajó del mínimo
    const stockAntes = (_c = before.stockActual) !== null && _c !== void 0 ? _c : 0;
    const stockAhora = (_d = after.stockActual) !== null && _d !== void 0 ? _d : 0;
    const stockMinimo = (_e = after.stockMinimo) !== null && _e !== void 0 ? _e : 0;
    const nombreItem = (_f = after.nombre) !== null && _f !== void 0 ? _f : "Producto";
    // Solo notificar cuando cruza el umbral
    if (stockAntes > stockMinimo && stockAhora <= stockMinimo && stockAhora > 0) {
        firebase_functions_1.logger.info(`📦 Stock bajo detectado: ${nombreItem} en granja ${granjaId}`);
        // Obtener nombre de la granja
        const granjaDoc = await db.collection("granjas").doc(granjaId).get();
        const granjaName = (_h = (_g = granjaDoc.data()) === null || _g === void 0 ? void 0 : _g.nombre) !== null && _h !== void 0 ? _h : "Granja";
        // Obtener usuarios a notificar (owner, admin, manager)
        const colaboradores = await db
            .collection("granjas")
            .doc(granjaId)
            .collection("colaboradores")
            .where("rol", "in", ["owner", "admin", "manager"])
            .where("activo", "==", true)
            .get();
        const notificaciones = [];
        for (const colabDoc of colaboradores.docs) {
            const colab = colabDoc.data();
            const notificacion = {
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
            notificaciones.push(crearNotificacionYEnviarPush(colab.usuarioId, notificacion));
        }
        const results = await Promise.allSettled(notificaciones);
        const fallidos = results.filter(r => r.status === "rejected").length;
        if (fallidos > 0) {
            firebase_functions_1.logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de stock bajo fallaron`);
        }
        firebase_functions_1.logger.info(`✅ Notificaciones de stock bajo enviadas: ${colaboradores.size}`);
    }
});
// =============================================================================
// TRIGGER: Productos próximos a vencer (Scheduled - diario)
// =============================================================================
exports.verificarVencimientos = (0, scheduler_1.onSchedule)({ schedule: "every day 08:00", timeZone: "America/Bogota" }, async (event) => {
    var _a;
    // Idempotencia basada en hora de ejecución programada
    const scheduleKey = `schedule_vencimientos_${event.scheduleTime}`;
    if (await isAlreadyProcessed(scheduleKey)) {
        firebase_functions_1.logger.info(`Ejecución programada duplicada ignorada: ${scheduleKey}`);
        return;
    }
    firebase_functions_1.logger.info("🕐 Iniciando verificación de vencimientos...");
    const ahora = new Date();
    const en7Dias = new Date(ahora.getTime() + 7 * 24 * 60 * 60 * 1000);
    // Obtener todas las granjas
    const granjas = await db.collection("granjas").get();
    for (const granjaDoc of granjas.docs) {
        const granjaId = granjaDoc.id;
        const granjaName = (_a = granjaDoc.data().nombre) !== null && _a !== void 0 ? _a : "Granja";
        // Buscar items próximos a vencer
        const items = await db
            .collection("granjas")
            .doc(granjaId)
            .collection("inventario")
            .where("activo", "==", true)
            .where("fechaVencimiento", "<=", admin.firestore.Timestamp.fromDate(en7Dias))
            .where("fechaVencimiento", ">", admin.firestore.Timestamp.fromDate(ahora))
            .get();
        if (items.empty)
            continue;
        // Obtener usuarios a notificar
        const colaboradores = await db
            .collection("granjas")
            .doc(granjaId)
            .collection("colaboradores")
            .where("rol", "in", ["owner", "admin"])
            .where("activo", "==", true)
            .get();
        // Batch notifications per granja to avoid timeout on sequential awaits
        const batchPromises = [];
        for (const itemDoc of items.docs) {
            const item = itemDoc.data();
            const fechaVenc = item.fechaVencimiento.toDate();
            const diasRestantes = Math.ceil((fechaVenc.getTime() - ahora.getTime()) / (1000 * 60 * 60 * 24));
            for (const colabDoc of colaboradores.docs) {
                const colab = colabDoc.data();
                const notificacion = {
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
                batchPromises.push(crearNotificacionYEnviarPush(colab.usuarioId, notificacion));
            }
        }
        // Execute all notifications for this granja in parallel
        const results = await Promise.allSettled(batchPromises);
        const fallidos = results.filter(r => r.status === "rejected").length;
        if (fallidos > 0) {
            firebase_functions_1.logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de vencimiento fallaron en ${granjaName}`);
        }
    }
    firebase_functions_1.logger.info("✅ Verificación de vencimientos completada");
});
// =============================================================================
// TRIGGER: Alta mortalidad registrada
// =============================================================================
exports.onMortalidadRegistrada = (0, firestore_1.onDocumentCreated)("granjas/{granjaId}/lotes/{loteId}/mortalidad/{mortalidadId}", async (event) => {
    var _a, _b, _c, _d, _e;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const { granjaId, loteId } = event.params;
    const mortalidad = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!mortalidad)
        return;
    const cantidadMuertos = (_b = mortalidad.cantidadMuertos) !== null && _b !== void 0 ? _b : 0;
    // Obtener datos del lote
    const loteDoc = await db
        .collection("granjas")
        .doc(granjaId)
        .collection("lotes")
        .doc(loteId)
        .get();
    if (!loteDoc.exists)
        return;
    const lote = loteDoc.data();
    // Use || instead of ?? to also catch 0, preventing division by zero
    const cantidadTotal = lote.cantidadActual || lote.cantidadInicial || 1;
    const porcentaje = (cantidadMuertos / cantidadTotal) * 100;
    // Solo alertar si mortalidad > 2%
    if (porcentaje <= 2)
        return;
    firebase_functions_1.logger.warn(`🚨 Mortalidad alta detectada: ${porcentaje.toFixed(1)}%`);
    const loteNombre = (_c = lote.nombre) !== null && _c !== void 0 ? _c : "Lote";
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
    const granjaName = (_e = (_d = granjaDoc.data()) === null || _d === void 0 ? void 0 : _d.nombre) !== null && _e !== void 0 ? _e : "Granja";
    const notificaciones = [];
    for (const colabDoc of colaboradores.docs) {
        const colab = colabDoc.data();
        const notificacion = {
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
        notificaciones.push(crearNotificacionYEnviarPush(colab.usuarioId, notificacion));
    }
    const results = await Promise.allSettled(notificaciones);
    const fallidos = results.filter(r => r.status === "rejected").length;
    if (fallidos > 0) {
        firebase_functions_1.logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de mortalidad fallaron`);
    }
    firebase_functions_1.logger.info(`✅ Notificaciones de mortalidad enviadas: ${colaboradores.size}`);
});
// =============================================================================
// TRIGGER: Nueva invitación creada
// =============================================================================
exports.onInvitacionCreada = (0, firestore_1.onDocumentCreated)("granjas/{granjaId}/invitaciones/{invitacionId}", async (event) => {
    var _a, _b, _c, _d, _e;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const { granjaId } = event.params;
    const invitacion = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!invitacion)
        return;
    const emailInvitado = invitacion.emailInvitado;
    const invitadoPor = (_b = invitacion.invitadoPorNombre) !== null && _b !== void 0 ? _b : "Alguien";
    // Buscar usuario por email
    const usuariosQuery = await db
        .collection("usuarios")
        .where("email", "==", emailInvitado)
        .limit(1)
        .get();
    if (usuariosQuery.empty) {
        firebase_functions_1.logger.info(`Usuario no registrado: ${emailInvitado}`);
        return;
    }
    const usuarioDoc = usuariosQuery.docs[0];
    const usuarioId = usuarioDoc.id;
    const granjaDoc = await db.collection("granjas").doc(granjaId).get();
    const granjaName = (_d = (_c = granjaDoc.data()) === null || _c === void 0 ? void 0 : _c.nombre) !== null && _d !== void 0 ? _d : "Granja";
    const notificacion = {
        usuarioId: usuarioId,
        tipo: "invitacion_recibida",
        titulo: `🎉 Invitación a ${granjaName}`,
        mensaje: `${invitadoPor} te ha invitado a colaborar`,
        fechaCreacion: admin.firestore.Timestamp.now(),
        granjaId: granjaId,
        granjaName: granjaName,
        data: {
            codigoInvitacion: (_e = invitacion.codigo) !== null && _e !== void 0 ? _e : "",
        },
        leida: false,
        prioridad: "alta",
        accionUrl: "/aceptar-invitacion",
    };
    await crearNotificacionYEnviarPush(usuarioId, notificacion);
    firebase_functions_1.logger.info(`✅ Notificación de invitación enviada a ${emailInvitado}`);
});
// =============================================================================
// TRIGGER: Invitación aceptada
// =============================================================================
exports.onColaboradorAgregado = (0, firestore_1.onDocumentCreated)("granjas/{granjaId}/colaboradores/{colaboradorId}", async (event) => {
    var _a, _b, _c, _d, _e, _f;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const { granjaId } = event.params;
    const colaborador = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!colaborador)
        return;
    // No notificar al owner original
    if (colaborador.rol === "owner")
        return;
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
    const nombreColaborador = (_c = (_b = usuarioDoc.data()) === null || _b === void 0 ? void 0 : _b.nombreCompleto) !== null && _c !== void 0 ? _c : "Nuevo usuario";
    const granjaName = (_e = (_d = granjaDoc.data()) === null || _d === void 0 ? void 0 : _d.nombre) !== null && _e !== void 0 ? _e : "Granja";
    const rolLabels = {
        admin: "Administrador",
        manager: "Encargado",
        operator: "Operador",
        viewer: "Observador",
    };
    for (const ownerDoc of owners.docs) {
        const owner = ownerDoc.data();
        // No notificar si el owner es el mismo que se agregó
        if (owner.usuarioId === nuevoUsuarioId)
            continue;
        const notificacion = {
            usuarioId: owner.usuarioId,
            tipo: "invitacion_aceptada",
            titulo: "👤 Nuevo colaborador",
            mensaje: `${nombreColaborador} se unió como ${(_f = rolLabels[rol]) !== null && _f !== void 0 ? _f : rol} a ${granjaName}`,
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
    firebase_functions_1.logger.info(`✅ Notificación de nuevo colaborador enviada`);
});
// =============================================================================
// FUNCIÓN HELPER: Crear notificación y enviar push
// =============================================================================
async function crearNotificacionYEnviarPush(usuarioId, notificacion) {
    var _a, _b, _c;
    try {
        // Guardar en Firestore
        await db
            .collection("usuarios")
            .doc(usuarioId)
            .collection("notificaciones")
            .add(notificacion);
        // Obtener tokens FCM del usuario
        const usuarioDoc = await db.collection("usuarios").doc(usuarioId).get();
        const fcmTokens = (_a = usuarioDoc.data()) === null || _a === void 0 ? void 0 : _a.fcmTokens;
        if (!fcmTokens || fcmTokens.length === 0) {
            firebase_functions_1.logger.info(`No hay tokens FCM para usuario ${usuarioId}`);
            return;
        }
        // Enviar push notification
        const message = {
            tokens: fcmTokens,
            notification: {
                title: notificacion.titulo,
                body: notificacion.mensaje,
            },
            data: Object.assign({ tipo: notificacion.tipo, granjaId: (_b = notificacion.granjaId) !== null && _b !== void 0 ? _b : "", accionUrl: (_c = notificacion.accionUrl) !== null && _c !== void 0 ? _c : "" }, notificacion.data),
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
        firebase_functions_1.logger.info(`Push enviado: ${response.successCount} éxitos, ${response.failureCount} fallos`);
        // Limpiar tokens inválidos
        if (response.failureCount > 0) {
            const tokensToRemove = [];
            response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                    const error = resp.error;
                    if ((error === null || error === void 0 ? void 0 : error.code) === "messaging/invalid-registration-token" ||
                        (error === null || error === void 0 ? void 0 : error.code) === "messaging/registration-token-not-registered") {
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
                firebase_functions_1.logger.info(`Tokens inválidos eliminados: ${tokensToRemove.length}`);
            }
        }
    }
    catch (error) {
        firebase_functions_1.logger.error(`Error enviando notificación a ${usuarioId}:`, error);
    }
}
//# sourceMappingURL=index.js.map