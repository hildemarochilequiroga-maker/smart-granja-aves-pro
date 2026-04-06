/// Servicio de notificaciones push con Firebase Cloud Messaging.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/errors/error_messages.dart';

import '../../domain/entities/notificacion.dart';
import '../../domain/enums/tipo_notificacion.dart';
import '../../domain/enums/prioridad_notificacion.dart';

/// Handler para mensajes en background (debe ser top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 Mensaje recibido en background: ${message.messageId}');
}

/// Servicio principal de notificaciones.
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream controller para notificaciones tocadas.
  final _notificationTappedController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotificationTapped =>
      _notificationTappedController.stream;

  /// StreamSubscriptions para FCM handlers
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  /// Token FCM actual.
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Usuario actual ID.
  String? _currentUserId;

  /// Si el servicio está inicializado.
  bool _initialized = false;

  /// Canal de notificaciones para Android.
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'smart_granja_aves_channel',
    'Smart Granja Aves',
    description: ErrorMessages.get('NOTIF_CHANNEL_DESC'),
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  /// Inicializa el servicio de notificaciones.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Solicitar permisos
      await _requestPermissions();

      // Configurar notificaciones locales
      await _setupLocalNotifications();

      // Configurar handlers de FCM
      _setupFCMHandlers();

      // Obtener token
      await _getAndSaveToken();

      _initialized = true;
      debugPrint('✅ NotificationService inicializado');
    } on Exception catch (e) {
      debugPrint('❌ Error inicializando NotificationService: $e');
    }
  }

  /// Solicita permisos de notificaciones.
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    debugPrint('📱 Permisos de notificación: ${settings.authorizationStatus}');

    // iOS foreground presentation options
    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Configura las notificaciones locales.
  Future<void> _setupLocalNotifications() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Crear canal de notificaciones en Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Callback cuando se toca una notificación.
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _notificationTappedController.add(data);
        debugPrint('📲 Notificación tocada: $data');
      } on Exception catch (e) {
        debugPrint('Error procesando payload: $e');
      }
    }
  }

  /// Configura los handlers de Firebase Messaging.
  void _setupFCMHandlers() {
    // Handler en background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handler en foreground
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    // Handler cuando se abre la app desde notificación
    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(_handleMessageOpenedApp);

    // Verificar si la app se abrió desde una notificación
    _checkInitialMessage();

    // Escuchar cambios de token
    _onTokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      _onTokenRefresh,
    );
  }

  /// Maneja mensajes en foreground.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('📨 Mensaje en foreground: ${message.notification?.title}');

    final notification = message.notification;
    final android = message.notification?.android;

    // Mostrar notificación local
    if (notification != null) {
      await _showLocalNotification(
        id: message.hashCode,
        title: notification.title ?? 'Smart Granja Aves',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
        channelId: android?.channelId ?? _channel.id,
      );
    }

    // Guardar en Firestore si tiene datos
    if (message.data.isNotEmpty && _currentUserId != null) {
      await _saveNotificationToFirestore(message);
    }
  }

  /// Maneja cuando la app se abre desde una notificación.
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('📲 App abierta desde notificación: ${message.data}');
    _notificationTappedController.add(message.data);
  }

  /// Verifica si la app se inició desde una notificación.
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 App iniciada desde notificación');
      _notificationTappedController.add(initialMessage.data);
    }
  }

  /// Obtiene y guarda el token FCM.
  Future<void> _getAndSaveToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) debugPrint('🔑 FCM Token: $_fcmToken');
    } on Exception catch (e) {
      if (kDebugMode) debugPrint('Error obteniendo FCM token: $e');
    }
  }

  /// Callback cuando el token se refresca.
  void _onTokenRefresh(String newToken) {
    if (kDebugMode) debugPrint('🔄 FCM Token refrescado');
    _fcmToken = newToken;
    if (_currentUserId != null) {
      saveTokenForUser(_currentUserId!);
    }
  }

  /// Establece el usuario actual y guarda su token.
  Future<void> setCurrentUser(String userId) async {
    _currentUserId = userId;
    if (_fcmToken != null) {
      await saveTokenForUser(userId);
    }
  }

  /// Guarda el token FCM para un usuario.
  Future<void> saveTokenForUser(String userId) async {
    if (_fcmToken == null) return;

    try {
      await _firestore.collection('usuarios').doc(userId).set({
        'fcmTokens': FieldValue.arrayUnion([_fcmToken]),
        'ultimoToken': _fcmToken,
        'ultimaActualizacionToken': FieldValue.serverTimestamp(),
        'plataforma': Platform.isAndroid ? 'android' : 'ios',
      }, SetOptions(merge: true));

      if (kDebugMode) debugPrint('✅ Token guardado para usuario $userId');
    } on Exception catch (e) {
      if (kDebugMode) debugPrint('Error guardando token: $e');
    }
  }

  /// Elimina el token del usuario actual (logout).
  Future<void> removeTokenForUser(String userId) async {
    if (_fcmToken == null) return;

    try {
      await _firestore.collection('usuarios').doc(userId).update({
        'fcmTokens': FieldValue.arrayRemove([_fcmToken]),
      });
      _currentUserId = null;
      if (kDebugMode) debugPrint('✅ Token eliminado para usuario $userId');
    } on Exception catch (e) {
      if (kDebugMode) debugPrint('Error eliminando token: $e');
    }
  }

  /// Muestra una notificación local.
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Guarda una notificación en Firestore.
  Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    if (_currentUserId == null) return;

    try {
      final notificacion = Notificacion(
        id: '',
        usuarioId: _currentUserId!,
        tipo: TipoNotificacion.fromString(message.data['tipo'] ?? 'general'),
        titulo:
            message.notification?.title ??
            ErrorMessages.get('NOTIF_FALLBACK_TITLE'),
        mensaje: message.notification?.body ?? '',
        fechaCreacion: DateTime.now(),
        granjaId: message.data['granjaId'],
        granjaName: message.data['granjaName'],
        data: message.data,
        prioridad: PrioridadNotificacion.fromString(
          message.data['prioridad'] ?? 'normal',
        ),
        accionUrl: message.data['accionUrl'],
      );

      await _firestore
          .collection('usuarios')
          .doc(_currentUserId)
          .collection('notificaciones')
          .add(notificacion.toFirestore());
    } on Exception catch (e) {
      debugPrint('Error guardando notificación: $e');
    }
  }

  /// Crea una notificación local (para alertas internas).
  Future<void> crearNotificacionLocal({
    required String usuarioId,
    required TipoNotificacion tipo,
    required String titulo,
    required String mensaje,
    String? granjaId,
    String? granjaName,
    Map<String, dynamic>? data,
    PrioridadNotificacion prioridad = PrioridadNotificacion.normal,
    String? accionUrl,
  }) async {
    final notificacion = Notificacion(
      id: '',
      usuarioId: usuarioId,
      tipo: tipo,
      titulo: titulo,
      mensaje: mensaje,
      fechaCreacion: DateTime.now(),
      granjaId: granjaId,
      granjaName: granjaName,
      data: data,
      prioridad: prioridad,
      accionUrl: accionUrl,
    );

    try {
      // Guardar en Firestore
      await _firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('notificaciones')
          .add(notificacion.toFirestore());

      // Mostrar notificación local si es el usuario actual
      if (usuarioId == _currentUserId) {
        await _showLocalNotification(
          id: DateTime.now().microsecondsSinceEpoch % 0x7FFFFFFF,
          title: titulo,
          body: mensaje,
          payload: jsonEncode({
            'tipo': tipo.value,
            'granjaId': granjaId,
            'accionUrl': accionUrl,
            ...?data,
          }),
        );
      }
    } on Exception catch (e) {
      debugPrint('Error creando notificación local: $e');
    }
  }

  /// Suscribe al usuario a un topic (granja).
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('📢 Suscrito al topic: $topic');
    } on Exception catch (e) {
      debugPrint('Error suscribiendo a topic: $e');
    }
  }

  /// Desuscribe del topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('🔇 Desuscrito del topic: $topic');
    } on Exception catch (e) {
      debugPrint('Error desuscribiendo de topic: $e');
    }
  }

  /// Limpia recursos.
  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
    _notificationTappedController.close();
    _initialized = false;
  }
}
