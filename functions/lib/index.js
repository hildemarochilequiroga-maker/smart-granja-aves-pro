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
exports.verificarAlertasPeriodicas = exports.onColaboradorAgregado = exports.onInvitacionCreada = exports.onMortalidadRegistrada = exports.verificarVencimientos = exports.onInventarioUpdate = exports.onPlayNotification = exports.validarCompraPlay = void 0;
exports.getDestinatariosGranja = getDestinatariosGranja;
const admin = __importStar(require("firebase-admin"));
const firebase_functions_1 = require("firebase-functions");
const firestore_1 = require("firebase-functions/v2/firestore");
const scheduler_1 = require("firebase-functions/v2/scheduler");
// Inicializar Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();
// Suscripciones: validación de compras Play (callable) + RTDN (Pub/Sub).
var suscripciones_1 = require("./suscripciones");
Object.defineProperty(exports, "validarCompraPlay", { enumerable: true, get: function () { return suscripciones_1.validarCompraPlay; } });
Object.defineProperty(exports, "onPlayNotification", { enumerable: true, get: function () { return suscripciones_1.onPlayNotification; } });
// Credenciales de WhatsApp (opcionales): se leen del entorno en runtime.
// Si no están configuradas, el envío por WhatsApp se omite con un warning,
// permitiendo desplegar el resto de funciones sin bloquear por el secreto.
const whatsappAccessToken = {
    value: () => { var _a; return ((_a = process.env.WHATSAPP_ACCESS_TOKEN) !== null && _a !== void 0 ? _a : "").trim(); },
};
const whatsappPhoneNumberId = {
    value: () => { var _a; return ((_a = process.env.WHATSAPP_PHONE_NUMBER_ID) !== null && _a !== void 0 ? _a : "").trim(); },
};
const whatsappTemplateMortalidad = {
    value: () => { var _a; return ((_a = process.env.WHATSAPP_TEMPLATE_MORTALIDAD) !== null && _a !== void 0 ? _a : "").trim(); },
};
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
        // Obtener usuarios a notificar (owner, admin, manager) desde la
        // colección correcta `granja_usuarios` (ver getDestinatariosGranja).
        const destinatarios = await getDestinatariosGranja(granjaId);
        const notificaciones = [];
        for (const usuarioId of destinatarios) {
            const notificacion = {
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
            notificaciones.push(crearNotificacionYEnviarPush(usuarioId, notificacion));
        }
        const results = await Promise.allSettled(notificaciones);
        const fallidos = results.filter(r => r.status === "rejected").length;
        if (fallidos > 0) {
            firebase_functions_1.logger.warn(`⚠️ ${fallidos}/${results.length} notificaciones de stock bajo fallaron`);
        }
        firebase_functions_1.logger.info(`✅ Notificaciones de stock bajo enviadas: ${destinatarios.length}`);
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
        // Obtener usuarios a notificar (owner/admin) desde `granja_usuarios`.
        const destinatarios = await getDestinatariosGranja(granjaId, [
            "owner",
            "admin",
        ]);
        if (destinatarios.length === 0)
            continue;
        // Batch notifications per granja to avoid timeout on sequential awaits
        const batchPromises = [];
        for (const itemDoc of items.docs) {
            const item = itemDoc.data();
            const fechaVenc = item.fechaVencimiento.toDate();
            const diasRestantes = Math.ceil((fechaVenc.getTime() - ahora.getTime()) / (1000 * 60 * 60 * 24));
            for (const usuarioId of destinatarios) {
                const notificacion = {
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
                batchPromises.push(crearNotificacionYEnviarPush(usuarioId, notificacion));
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
exports.onMortalidadRegistrada = (0, firestore_1.onDocumentCreated)({
    document: "lotes/{loteId}/mortalidad/{mortalidadId}",
}, async (event) => {
    var _a, _b, _c, _d;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const { loteId, mortalidadId } = event.params;
    const mortalidad = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!mortalidad)
        return;
    const granjaId = toText(mortalidad.granjaId);
    if (!granjaId) {
        firebase_functions_1.logger.warn(`Registro de mortalidad sin granjaId: ${loteId}/${mortalidadId}`);
        return;
    }
    const loteDoc = await db.collection("lotes").doc(loteId).get();
    if (!loteDoc.exists) {
        firebase_functions_1.logger.warn(`Lote no encontrado para mortalidad: ${loteId}`);
        return;
    }
    const lote = (_b = loteDoc.data()) !== null && _b !== void 0 ? _b : {};
    const cantidadMuertos = toNumber(mortalidad.cantidad, toNumber(mortalidad.cantidadMuertos));
    const cantidadInicial = toNumber(lote.cantidadInicial);
    const mortalidadAcumulada = toNumber(lote.mortalidadAcumulada, cantidadMuertos);
    const porcentaje = cantidadInicial > 0
        ? (mortalidadAcumulada / cantidadInicial) * 100
        : 0;
    firebase_functions_1.logger.info(`Mortalidad registrada: acumulado ${porcentaje.toFixed(1)}%`);
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
    const granjaName = (_d = (_c = granjaDoc.data()) === null || _c === void 0 ? void 0 : _c.nombre) !== null && _d !== void 0 ? _d : "Granja";
    const causa = toText(mortalidad.causa, "No especificada");
    const fecha = formatFirestoreDate(mortalidad.fecha);
    const registradoPor = toText(mortalidad.nombreUsuario, "Usuario");
    firebase_functions_1.logger.info(`Mortalidad registrada: ${cantidadMuertos} aves en ${loteNombre} (${granjaName})`);
    if (colaboradores.empty) {
        firebase_functions_1.logger.warn(`No hay responsables activos para granja ${granjaId}`);
        return;
    }
    // Mensaje de la notificación push/in-app.
    const tituloPush = `⚠️ Mortalidad en ${loteNombre}`;
    const mensajePush = `${cantidadMuertos} ave(s) en ${granjaName}. ` +
        `Acumulado: ${porcentaje.toFixed(1)}%. Causa: ${causa}.`;
    const envios = [];
    for (const colabDoc of colaboradores.docs) {
        const colab = colabDoc.data();
        if (!colab.usuarioId)
            continue;
        // 1) Notificación push + in-app al celular de cada responsable.
        const notificacion = {
            usuarioId: colab.usuarioId,
            tipo: "mortalidad_alta",
            titulo: tituloPush,
            mensaje: mensajePush,
            fechaCreacion: admin.firestore.Timestamp.now(),
            granjaId,
            granjaName,
            data: {
                loteId,
                mortalidadId,
                cantidadMuertos: String(cantidadMuertos),
                porcentaje: porcentaje.toFixed(1),
                registradoPor,
            },
            leida: false,
            prioridad: "alta",
            accionUrl: `/lotes/${loteId}`,
        };
        envios.push(crearNotificacionYEnviarPush(colab.usuarioId, notificacion));
        // 2) Salida WhatsApp (se omite sola si no está configurada).
        envios.push(enviarWhatsAppMortalidad({
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
        }));
    }
    const results = await Promise.allSettled(envios);
    const fallidos = results.filter(r => r.status === "rejected").length;
    if (fallidos > 0) {
        firebase_functions_1.logger.warn(`${fallidos}/${results.length} salidas de mortalidad fallaron`);
    }
    firebase_functions_1.logger.info(`Salidas de mortalidad procesadas: ${results.length}`);
});
// =============================================================================
// HELPERS: Salida WhatsApp de mortalidad
// =============================================================================
async function enviarWhatsAppMortalidad(params) {
    var _a;
    const usuarioDoc = await db.collection("usuarios").doc(params.usuarioId).get();
    const usuario = usuarioDoc.data();
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
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "skipped", reason: "whatsapp_no_configurado" }));
        return;
    }
    if (!usuario) {
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "skipped", reason: "usuario_no_encontrado" }));
        return;
    }
    if (!tieneWhatsAppHabilitado(usuario)) {
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "skipped", reason: "whatsapp_no_habilitado" }));
        return;
    }
    const telefono = normalizarTelefonoWhatsApp(toText(usuario.telefonoWhatsApp) || toText(usuario.telefono));
    if (!telefono) {
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "skipped", reason: "telefono_whatsapp_invalido" }));
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
    await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "pending", to: telefono, template: whatsappTemplateMortalidad.value(), parameters }));
    try {
        const result = await enviarPlantillaWhatsApp(telefono, parameters);
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: result.ok ? "sent" : "failed", to: telefono, template: whatsappTemplateMortalidad.value(), messageId: (_a = result.messageId) !== null && _a !== void 0 ? _a : null, graphStatus: result.status, graphResponse: result.response, sentAt: result.ok ? admin.firestore.FieldValue.serverTimestamp() : null }));
    }
    catch (error) {
        await guardarSalidaWhatsApp(salidaId, Object.assign(Object.assign({}, baseSalida), { status: "failed", to: telefono, template: whatsappTemplateMortalidad.value(), error: error instanceof Error ? error.message : String(error) }));
        firebase_functions_1.logger.error(`Error enviando WhatsApp de mortalidad a ${params.usuarioId}`, error);
    }
}
async function guardarSalidaWhatsApp(salidaId, data) {
    await db.collection("whatsapp_mensajes").doc(salidaId).set(data, {
        merge: true,
    });
}
async function enviarPlantillaWhatsApp(to, texts) {
    var _a, _b;
    const accessToken = whatsappAccessToken.value().trim();
    const phoneNumberId = whatsappPhoneNumberId.value().trim();
    const templateName = whatsappTemplateMortalidad.value().trim();
    if (!accessToken || !phoneNumberId || !templateName) {
        throw new Error("Secrets de WhatsApp incompletos");
    }
    const payload = {
        messaging_product: "whatsapp",
        to,
        type: "template",
        template: {
            name: templateName,
            language: {
                code: (_a = process.env.WHATSAPP_TEMPLATE_LANGUAGE) !== null && _a !== void 0 ? _a : "es",
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
    const graphVersion = (_b = process.env.WHATSAPP_GRAPH_VERSION) !== null && _b !== void 0 ? _b : "v20.0";
    const response = await fetch(`https://graph.facebook.com/${graphVersion}/${phoneNumberId}/messages`, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
    });
    const raw = await response.text();
    const parsed = parseJson(raw);
    return {
        ok: response.ok,
        status: response.status,
        response: parsed !== null && parsed !== void 0 ? parsed : raw,
        messageId: obtenerWhatsAppMessageId(parsed),
    };
}
function tieneWhatsAppHabilitado(usuario) {
    var _a, _b;
    const metadataOptIn = ((_a = usuario.metadata) === null || _a === void 0 ? void 0 : _a.whatsappOptIn) === true;
    const preferenciasOptIn = ((_b = usuario.notificaciones) === null || _b === void 0 ? void 0 : _b.whatsapp) === true;
    return usuario.whatsappOptIn === true ||
        usuario.notificacionesWhatsApp === true ||
        metadataOptIn ||
        preferenciasOptIn;
}
function normalizarTelefonoWhatsApp(value) {
    const digits = value.replace(/\D/g, "");
    if (!digits)
        return null;
    const normalized = digits.startsWith("00") ? digits.substring(2) : digits;
    if (normalized.length === 9 && normalized.startsWith("9")) {
        return `51${normalized}`;
    }
    if (normalized.length >= 10 && normalized.length <= 15) {
        return normalized;
    }
    return null;
}
function nombreParaWhatsApp(usuario) {
    const nombreCompleto = toText(usuario.nombreCompleto);
    if (nombreCompleto)
        return nombreCompleto;
    const nombre = [toText(usuario.nombre), toText(usuario.apellido)]
        .filter(Boolean)
        .join(" ")
        .trim();
    return nombre || "usuario";
}
function toNumber(value, fallback = 0) {
    if (typeof value === "number" && Number.isFinite(value))
        return value;
    if (typeof value === "string") {
        const parsed = Number(value);
        if (Number.isFinite(parsed))
            return parsed;
    }
    return fallback;
}
function toText(value, fallback = "") {
    if (typeof value === "string" && value.trim())
        return value.trim();
    if (typeof value === "number" && Number.isFinite(value))
        return value.toString();
    return fallback;
}
function formatFirestoreDate(value) {
    if (value instanceof admin.firestore.Timestamp) {
        return value.toDate().toLocaleDateString("es-PE");
    }
    if (value instanceof Date) {
        return value.toLocaleDateString("es-PE");
    }
    return new Date().toLocaleDateString("es-PE");
}
function parseJson(raw) {
    try {
        return JSON.parse(raw);
    }
    catch (_a) {
        return null;
    }
}
function obtenerWhatsAppMessageId(response) {
    if (!response || typeof response !== "object")
        return undefined;
    const messages = response.messages;
    if (!Array.isArray(messages) || messages.length === 0)
        return undefined;
    const first = messages[0];
    if (!first || typeof first !== "object")
        return undefined;
    const id = first.id;
    return typeof id === "string" ? id : undefined;
}
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
// Escucha la colección TOP-LEVEL `granja_usuarios` (docId `{granjaId}_{uid}`),
// que es donde la app crea las membresías. Antes escuchaba la subcolección
// `granjas/{id}/colaboradores`, que la app NUNCA escribe → el trigger jamás
// se disparaba.
exports.onColaboradorAgregado = (0, firestore_1.onDocumentCreated)("granja_usuarios/{membresiaId}", async (event) => {
    var _a, _b, _c, _d, _e, _f;
    if (await isAlreadyProcessed(event.id)) {
        firebase_functions_1.logger.info(`Evento duplicado ignorado: ${event.id}`);
        return;
    }
    const colaborador = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!colaborador)
        return;
    // granjaId/usuarioId vienen como campos del documento top-level.
    const granjaId = colaborador.granjaId;
    const nuevoUsuarioId = colaborador.usuarioId;
    const rol = colaborador.rol;
    if (!granjaId || !nuevoUsuarioId || !rol)
        return;
    // No notificar al owner original
    if (rol === "owner")
        return;
    // Lecturas en paralelo: datos del nuevo usuario, granja y owners destino.
    const [usuarioDoc, granjaDoc, owners] = await Promise.all([
        db.collection("usuarios").doc(nuevoUsuarioId).get(),
        db.collection("granjas").doc(granjaId).get(),
        getDestinatariosGranja(granjaId, ["owner", "admin"]),
    ]);
    const nombreColaborador = (_c = (_b = usuarioDoc.data()) === null || _b === void 0 ? void 0 : _b.nombreCompleto) !== null && _c !== void 0 ? _c : "Nuevo usuario";
    const granjaName = (_e = (_d = granjaDoc.data()) === null || _d === void 0 ? void 0 : _d.nombre) !== null && _e !== void 0 ? _e : "Granja";
    const rolLabels = {
        admin: "Administrador",
        manager: "Encargado",
        operator: "Operador",
        viewer: "Observador",
    };
    for (const ownerId of owners) {
        // No notificar si el destinatario es el mismo que se agregó
        if (ownerId === nuevoUsuarioId)
            continue;
        const notificacion = {
            usuarioId: ownerId,
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
        await crearNotificacionYEnviarPush(ownerId, notificacion);
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
exports.verificarAlertasPeriodicas = (0, scheduler_1.onSchedule)({ schedule: "every 30 minutes", timeZone: "America/Bogota" }, async (event) => {
    var _a, _b;
    const scheduleKey = `schedule_alertas_${event.scheduleTime}`;
    if (await isAlreadyProcessed(scheduleKey)) {
        firebase_functions_1.logger.info(`Ejecución periódica duplicada ignorada: ${scheduleKey}`);
        return;
    }
    firebase_functions_1.logger.info("🕐 Iniciando verificación periódica de alertas...");
    const granjas = await db.collection("granjas").get();
    for (const granjaDoc of granjas.docs) {
        const granjaId = granjaDoc.id;
        const granjaName = (_b = (_a = granjaDoc.data()) === null || _a === void 0 ? void 0 : _a.nombre) !== null && _b !== void 0 ? _b : "Granja";
        try {
            await verificarVacunacionesProximas(granjaId, granjaName);
        }
        catch (error) {
            firebase_functions_1.logger.error(`Error verificando alertas de ${granjaId}:`, error);
        }
    }
    firebase_functions_1.logger.info("✅ Verificación periódica de alertas completada");
});
/**
 * Recordatorio de vacunaciones programadas que caen dentro de las próximas 48h
 * y aún no se han aplicado. Envía push + in-app a los responsables de la
 * granja. Idempotente: usa un dedupe key por vacunación+día para no repetir.
 */
async function verificarVacunacionesProximas(granjaId, granjaName) {
    const ahora = admin.firestore.Timestamp.now();
    const en48h = admin.firestore.Timestamp.fromMillis(ahora.toMillis() + 48 * 60 * 60 * 1000);
    const snap = await db
        .collection("vacunaciones")
        .where("granjaId", "==", granjaId)
        .where("aplicada", "==", false)
        .where("fechaProgramada", ">=", ahora)
        .where("fechaProgramada", "<=", en48h)
        .limit(50)
        .get();
    if (snap.empty)
        return;
    const destinatarios = await getDestinatariosGranja(granjaId);
    if (destinatarios.length === 0)
        return;
    for (const doc of snap.docs) {
        const vac = doc.data();
        const nombreVacuna = toText(vac.nombreVacuna, "Vacuna");
        const loteId = toText(vac.loteId);
        const fecha = formatFirestoreDate(vac.fechaProgramada);
        // Dedupe: una sola alerta por vacunación y día.
        const hoy = new Date().toISOString().slice(0, 10);
        const dedupeKey = `vac_prox_${doc.id}_${hoy}`;
        if (await isAlreadyProcessed(dedupeKey))
            continue;
        const envios = destinatarios.map((usuarioId) => {
            const notificacion = {
                usuarioId,
                // Tipo existente en el enum del cliente (TipoNotificacion.vacunacionManana).
                tipo: "vacunacion_manana",
                titulo: `💉 Vacunación próxima en ${granjaName}`,
                mensaje: `${nombreVacuna} programada para ${fecha}.`,
                fechaCreacion: admin.firestore.Timestamp.now(),
                granjaId,
                granjaName,
                data: { vacunacionId: doc.id, loteId, nombreVacuna },
                leida: false,
                prioridad: "alta",
                accionUrl: loteId ? `/lotes/${loteId}` : "/salud",
            };
            return crearNotificacionYEnviarPush(usuarioId, notificacion);
        });
        await Promise.allSettled(envios);
        firebase_functions_1.logger.info(`Recordatorio de vacunación ${nombreVacuna} enviado a ` +
            `${destinatarios.length} responsable(s) de ${granjaName}`);
    }
}
/**
 * Obtiene los usuarioIds destinatarios (owner/admin/manager activos) de una
 * granja desde la colección correcta `granja_usuarios`. Usar esto en lugar de
 * `granjas/{id}/colaboradores` para que las notificaciones server-side lleguen.
 */
async function getDestinatariosGranja(granjaId, roles = ["owner", "admin", "manager"]) {
    const snap = await db
        .collection("granja_usuarios")
        .where("granjaId", "==", granjaId)
        .where("activo", "==", true)
        .where("rol", "in", roles)
        .get();
    return snap.docs.map((d) => d.data().usuarioId);
}
//# sourceMappingURL=index.js.map