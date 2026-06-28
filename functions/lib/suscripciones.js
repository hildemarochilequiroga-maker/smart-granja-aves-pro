"use strict";
/**
 * Suscripciones — validación de compras de Google Play y sincronización del
 * documento `suscripciones/{uid}`.
 *
 * Seguridad: el cliente envía el purchaseToken; el SERVIDOR lo valida contra
 * la Google Play Developer API (Subscriptions v2) y es la ÚNICA pieza que
 * escribe el plan. Nunca se confía en datos del cliente para conceder un plan.
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
var _a, _b;
Object.defineProperty(exports, "__esModule", { value: true });
exports.onPlayNotification = exports.validarCompraPlay = void 0;
const admin = __importStar(require("firebase-admin"));
const firebase_functions_1 = require("firebase-functions");
const https_1 = require("firebase-functions/v2/https");
const pubsub_1 = require("firebase-functions/v2/pubsub");
const db = admin.firestore();
// Nombre del paquete Android (debe coincidir con applicationId).
const PACKAGE_NAME = (_a = process.env.ANDROID_PACKAGE_NAME) !== null && _a !== void 0 ? _a : "com.hilde.smartgranjaavespro";
// Mapeo productId de Play -> plan interno.
const PRODUCT_TO_PLAN = {
    pro_mensual: "pro",
    plus_mensual: "plus",
};
/**
 * Cliente de Android Publisher autenticado vía Application Default Credentials
 * (la service account de la function necesita acceso a la Play Developer API).
 */
async function androidPublisher() {
    // Lazy-load: `googleapis` es pesado y cargarlo a nivel de módulo hace que
    // el análisis de backend de Firebase exceda su timeout de inicialización.
    // Se carga solo cuando realmente se valida una compra.
    const { google } = await Promise.resolve().then(() => __importStar(require("googleapis")));
    const auth = new google.auth.GoogleAuth({
        scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });
    const authClient = await auth.getClient();
    return google.androidpublisher({
        version: "v3",
        auth: authClient,
    });
}
/**
 * Mapea el estado de una suscripción v2 de Google Play a nuestro estado
 * interno. Conservador: cualquier estado no reconocido => expirada.
 */
function mapearEstado(sub) {
    const state = sub.subscriptionState;
    switch (state) {
        case "SUBSCRIPTION_STATE_ACTIVE":
            return "activa";
        case "SUBSCRIPTION_STATE_IN_GRACE_PERIOD":
            return "enGracia";
        case "SUBSCRIPTION_STATE_CANCELED":
            // Cancelada pero puede seguir vigente hasta expiry; el planEfectivo del
            // cliente respeta vigenteHasta.
            return "cancelada";
        case "SUBSCRIPTION_STATE_ON_HOLD":
        case "SUBSCRIPTION_STATE_PAUSED":
            return "suspendida";
        case "SUBSCRIPTION_STATE_EXPIRED":
        default:
            return "expirada";
    }
}
/** Extrae la fecha de expiración (ms epoch -> Date) de la suscripción v2. */
function extraerVigenteHasta(sub) {
    var _a;
    const line = (_a = sub.lineItems) === null || _a === void 0 ? void 0 : _a[0];
    const expiry = line === null || line === void 0 ? void 0 : line.expiryTime;
    if (!expiry)
        return null;
    const d = new Date(expiry);
    return isNaN(d.getTime()) ? null : d;
}
/**
 * Valida un purchaseToken contra Google Play y escribe `suscripciones/{uid}`.
 * Devuelve el plan efectivo resultante.
 */
async function validarYGuardar(params) {
    const { uid, purchaseToken, productId } = params;
    const plan = PRODUCT_TO_PLAN[productId];
    if (!plan) {
        firebase_functions_1.logger.warn(`Producto desconocido: ${productId}`);
        return { valida: false, plan: "gratis", estado: "expirada" };
    }
    const publisher = await androidPublisher();
    const res = await publisher.purchases.subscriptionsv2.get({
        packageName: PACKAGE_NAME,
        token: purchaseToken,
    });
    const sub = res.data;
    const estado = mapearEstado(sub);
    const vigenteHasta = extraerVigenteHasta(sub);
    // Solo concede acceso si el estado lo otorga.
    const otorga = estado === "activa" || estado === "enGracia" || estado === "cancelada";
    const planEfectivo = otorga ? plan : "gratis";
    await db.collection("suscripciones").doc(uid).set({
        usuarioId: uid,
        plan,
        estado,
        origen: "playBilling",
        vigenteHasta: vigenteHasta
            ? admin.firestore.Timestamp.fromDate(vigenteHasta)
            : null,
        playProductId: productId,
        playPurchaseToken: purchaseToken,
        actualizadoEn: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
    firebase_functions_1.logger.info(`Suscripción de ${uid} actualizada: plan=${plan} estado=${estado} ` +
        `efectivo=${planEfectivo}`);
    return { valida: otorga, plan: planEfectivo, estado };
}
/**
 * Callable: el cliente envía { purchaseToken, productId } tras una compra y el
 * servidor valida y persiste. Devuelve { valida, plan }.
 */
exports.validarCompraPlay = (0, https_1.onCall)(async (request) => {
    var _a, _b, _c, _d, _e;
    const uid = (_a = request.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new https_1.HttpsError("unauthenticated", "Requiere autenticación.");
    }
    const purchaseToken = String((_c = (_b = request.data) === null || _b === void 0 ? void 0 : _b.purchaseToken) !== null && _c !== void 0 ? _c : "").trim();
    const productId = String((_e = (_d = request.data) === null || _d === void 0 ? void 0 : _d.productId) !== null && _e !== void 0 ? _e : "").trim();
    if (!purchaseToken || !productId) {
        throw new https_1.HttpsError("invalid-argument", "purchaseToken y productId son obligatorios.");
    }
    try {
        const r = await validarYGuardar({ uid, purchaseToken, productId });
        return { valida: r.valida, plan: r.plan, estado: r.estado };
    }
    catch (e) {
        firebase_functions_1.logger.error("Error validando compra Play", e);
        throw new https_1.HttpsError("internal", "No se pudo validar la compra.");
    }
});
/**
 * Encuentra el uid dueño de un purchaseToken ya conocido (para RTDN, que no
 * trae el uid). Busca el doc `suscripciones` con ese token.
 */
async function uidPorToken(purchaseToken) {
    const snap = await db
        .collection("suscripciones")
        .where("playPurchaseToken", "==", purchaseToken)
        .limit(1)
        .get();
    if (snap.empty)
        return null;
    return snap.docs[0].id;
}
/**
 * Real-Time Developer Notifications (RTDN): Google publica en un topic de
 * Pub/Sub los cambios de estado (renovación, cancelación, gracia, expiración).
 * Aquí re-validamos contra Play y actualizamos el documento, degradando a
 * gratis cuando corresponde.
 *
 * Topic configurable vía env PLAY_RTDN_TOPIC (default: play-rtdn).
 */
exports.onPlayNotification = (0, pubsub_1.onMessagePublished)((_b = process.env.PLAY_RTDN_TOPIC) !== null && _b !== void 0 ? _b : "play-rtdn", async (event) => {
    try {
        const raw = event.data.message.data
            ? Buffer.from(event.data.message.data, "base64").toString("utf8")
            : "{}";
        const payload = JSON.parse(raw);
        const sub = payload.subscriptionNotification;
        if (!sub) {
            // Otros tipos (test, voided) se ignoran de forma segura.
            return;
        }
        const purchaseToken = sub.purchaseToken;
        const productId = sub.subscriptionId;
        if (!purchaseToken || !productId)
            return;
        const uid = await uidPorToken(purchaseToken);
        if (!uid) {
            firebase_functions_1.logger.warn(`RTDN: token sin uid conocido (compra no validada aún): ${productId}`);
            return;
        }
        await validarYGuardar({ uid, purchaseToken, productId });
    }
    catch (e) {
        firebase_functions_1.logger.error("Error procesando RTDN de Play", e);
    }
});
//# sourceMappingURL=suscripciones.js.map