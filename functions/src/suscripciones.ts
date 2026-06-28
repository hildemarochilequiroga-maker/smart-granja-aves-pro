/**
 * Suscripciones — validación de compras de Google Play y sincronización del
 * documento `suscripciones/{uid}`.
 *
 * Seguridad: el cliente envía el purchaseToken; el SERVIDOR lo valida contra
 * la Google Play Developer API (Subscriptions v2) y es la ÚNICA pieza que
 * escribe el plan. Nunca se confía en datos del cliente para conceder un plan.
 */

import * as admin from "firebase-admin";
import { logger } from "firebase-functions";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onMessagePublished } from "firebase-functions/v2/pubsub";
import type { androidpublisher_v3 } from "googleapis";

const db = admin.firestore();

// Nombre del paquete Android (debe coincidir con applicationId).
const PACKAGE_NAME =
  process.env.ANDROID_PACKAGE_NAME ?? "com.hilde.smartgranjaavespro";

// Mapeo productId de Play -> plan interno.
const PRODUCT_TO_PLAN: Record<string, "pro" | "plus"> = {
  pro_mensual: "pro",
  plus_mensual: "plus",
};

type EstadoSuscripcion =
  | "activa"
  | "enGracia"
  | "expirada"
  | "cancelada"
  | "suspendida";

/**
 * Cliente de Android Publisher autenticado vía Application Default Credentials
 * (la service account de la function necesita acceso a la Play Developer API).
 */
async function androidPublisher(): Promise<androidpublisher_v3.Androidpublisher> {
  // Lazy-load: `googleapis` es pesado y cargarlo a nivel de módulo hace que
  // el análisis de backend de Firebase exceda su timeout de inicialización.
  // Se carga solo cuando realmente se valida una compra.
  const { google } = await import("googleapis");
  const auth = new google.auth.GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  const authClient = await auth.getClient();
  return google.androidpublisher({
    version: "v3",
    auth: authClient as never,
  });
}

/**
 * Mapea el estado de una suscripción v2 de Google Play a nuestro estado
 * interno. Conservador: cualquier estado no reconocido => expirada.
 */
function mapearEstado(
  sub: androidpublisher_v3.Schema$SubscriptionPurchaseV2
): EstadoSuscripcion {
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
function extraerVigenteHasta(
  sub: androidpublisher_v3.Schema$SubscriptionPurchaseV2
): Date | null {
  const line = sub.lineItems?.[0];
  const expiry = line?.expiryTime;
  if (!expiry) return null;
  const d = new Date(expiry);
  return isNaN(d.getTime()) ? null : d;
}

/**
 * Valida un purchaseToken contra Google Play y escribe `suscripciones/{uid}`.
 * Devuelve el plan efectivo resultante.
 */
async function validarYGuardar(params: {
  uid: string;
  purchaseToken: string;
  productId: string;
}): Promise<{ valida: boolean; plan: string; estado: EstadoSuscripcion }> {
  const { uid, purchaseToken, productId } = params;

  const plan = PRODUCT_TO_PLAN[productId];
  if (!plan) {
    logger.warn(`Producto desconocido: ${productId}`);
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
  const otorga =
    estado === "activa" || estado === "enGracia" || estado === "cancelada";
  const planEfectivo = otorga ? plan : "gratis";

  await db.collection("suscripciones").doc(uid).set(
    {
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
    },
    { merge: true }
  );

  logger.info(
    `Suscripción de ${uid} actualizada: plan=${plan} estado=${estado} ` +
      `efectivo=${planEfectivo}`
  );

  return { valida: otorga, plan: planEfectivo, estado };
}

/**
 * Callable: el cliente envía { purchaseToken, productId } tras una compra y el
 * servidor valida y persiste. Devuelve { valida, plan }.
 */
export const validarCompraPlay = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Requiere autenticación.");
  }

  const purchaseToken = String(request.data?.purchaseToken ?? "").trim();
  const productId = String(request.data?.productId ?? "").trim();
  if (!purchaseToken || !productId) {
    throw new HttpsError(
      "invalid-argument",
      "purchaseToken y productId son obligatorios."
    );
  }

  try {
    const r = await validarYGuardar({ uid, purchaseToken, productId });
    return { valida: r.valida, plan: r.plan, estado: r.estado };
  } catch (e) {
    logger.error("Error validando compra Play", e);
    throw new HttpsError("internal", "No se pudo validar la compra.");
  }
});

/**
 * Encuentra el uid dueño de un purchaseToken ya conocido (para RTDN, que no
 * trae el uid). Busca el doc `suscripciones` con ese token.
 */
async function uidPorToken(purchaseToken: string): Promise<string | null> {
  const snap = await db
    .collection("suscripciones")
    .where("playPurchaseToken", "==", purchaseToken)
    .limit(1)
    .get();
  if (snap.empty) return null;
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
export const onPlayNotification = onMessagePublished(
  process.env.PLAY_RTDN_TOPIC ?? "play-rtdn",
  async (event) => {
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

      const purchaseToken: string = sub.purchaseToken;
      const productId: string = sub.subscriptionId;
      if (!purchaseToken || !productId) return;

      const uid = await uidPorToken(purchaseToken);
      if (!uid) {
        logger.warn(
          `RTDN: token sin uid conocido (compra no validada aún): ${productId}`
        );
        return;
      }

      await validarYGuardar({ uid, purchaseToken, productId });
    } catch (e) {
      logger.error("Error procesando RTDN de Play", e);
    }
  }
);
