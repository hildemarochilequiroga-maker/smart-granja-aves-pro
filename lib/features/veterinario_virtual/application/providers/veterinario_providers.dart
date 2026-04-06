/// Providers de Riverpod para el veterinario virtual.
library;

import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../services/contexto_builder.dart';
import '../services/veterinario_ai_service.dart';

/// Estado de procesamiento para mostrar mensajes contextuales.
enum EstadoProcesamiento {
  ninguno,
  procesando,
  analizandoImagen,
  generandoRespuesta,
}

/// Estado de una consulta de chat activa.
class ChatConsultaState {
  const ChatConsultaState({
    required this.tipo,
    required this.contexto,
    required this.mensajes,
    this.sesion,
    this.enviando = false,
    this.error,
    this.respuestaParcial = '',
    this.estadoProcesamiento = EstadoProcesamiento.ninguno,
  });

  final TipoConsulta tipo;
  final ContextoGranja contexto;
  final List<MensajeChat> mensajes;
  final ChatSession? sesion;
  final bool enviando;
  final String? error;
  final String respuestaParcial;
  final EstadoProcesamiento estadoProcesamiento;

  ChatConsultaState copyWith({
    List<MensajeChat>? mensajes,
    ChatSession? sesion,
    bool? enviando,
    String? error,
    String? respuestaParcial,
    EstadoProcesamiento? estadoProcesamiento,
  }) {
    return ChatConsultaState(
      tipo: tipo,
      contexto: contexto,
      mensajes: mensajes ?? this.mensajes,
      sesion: sesion ?? this.sesion,
      enviando: enviando ?? this.enviando,
      error: error,
      respuestaParcial: respuestaParcial ?? this.respuestaParcial,
      estadoProcesamiento: estadoProcesamiento ?? this.estadoProcesamiento,
    );
  }
}

/// Notifier que maneja el estado del chat.
class ChatConsultaNotifier extends StateNotifier<ChatConsultaState> {
  ChatConsultaNotifier(
    TipoConsulta tipo,
    ContextoGranja contexto, {
    this.locale = 'es',
  }) : super(
         ChatConsultaState(
           tipo: tipo,
           contexto: contexto,
           mensajes: [
             MensajeChat(
               rol: RolMensaje.asistente,
               texto: ContextoBuilder.mensajeBienvenida(
                 tipo,
                 contexto,
                 locale: locale,
               ),
               timestamp: DateTime.now(),
             ),
           ],
         ),
       );

  final String locale;
  ChatSession? _sesion;
  Timer? _uiTimer;

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  /// Envía un mensaje del usuario y recibe la respuesta por streaming.
  Future<void> enviarMensaje(
    String texto, {
    Uint8List? imagenBytes,
    String? imagenMimeType,
  }) async {
    if (state.enviando || texto.trim().isEmpty) return;

    final tieneImagen = imagenBytes != null && imagenMimeType != null;

    // Agregar mensaje del usuario
    final mensajeUsuario = MensajeChat(
      rol: RolMensaje.usuario,
      texto: texto.trim(),
      timestamp: DateTime.now(),
      imagenBytes: imagenBytes,
      imagenMimeType: imagenMimeType,
    );

    state = state.copyWith(
      mensajes: [...state.mensajes, mensajeUsuario],
      enviando: true,
      error: null,
      respuestaParcial: '',
      estadoProcesamiento: tieneImagen
          ? EstadoProcesamiento.analizandoImagen
          : EstadoProcesamiento.procesando,
    );

    try {
      // Inicializar sesión si es la primera vez
      _sesion ??= VeterinarioAiService.crearSesion(
        state.tipo,
        state.contexto,
        locale: locale,
      );

      // Enviar mensaje con streaming fluido
      final buffer = StringBuffer();
      var lastUpdate = '';

      // Timer que actualiza la UI a ~20fps para streaming fluido
      _uiTimer?.cancel();
      _uiTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        final current = buffer.toString();
        if (current != lastUpdate && mounted) {
          lastUpdate = current;
          state = state.copyWith(
            respuestaParcial: current,
            enviando: true,
            estadoProcesamiento: EstadoProcesamiento.generandoRespuesta,
          );
        }
      });

      await for (final chunk in VeterinarioAiService.enviarMensajeStream(
        _sesion!,
        texto.trim(),
        imagenBytes: imagenBytes,
        imagenMimeType: imagenMimeType,
      )) {
        buffer.write(chunk);
        if (!mounted) return;
      }

      _uiTimer?.cancel();

      // Agregar respuesta completa
      final respuesta = buffer.toString();
      if (!mounted) return;

      if (respuesta.isNotEmpty) {
        final mensajeAsistente = MensajeChat(
          rol: RolMensaje.asistente,
          texto: respuesta,
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          mensajes: [...state.mensajes, mensajeAsistente],
          sesion: _sesion,
          enviando: false,
          respuestaParcial: '',
          estadoProcesamiento: EstadoProcesamiento.ninguno,
        );
      } else {
        // Respuesta vacía del modelo
        state = state.copyWith(
          enviando: false,
          error: 'No se recibió respuesta del modelo. Verifica tu conexión.',
          respuestaParcial: '',
          estadoProcesamiento: EstadoProcesamiento.ninguno,
        );
      }
    } on Exception catch (e) {
      _uiTimer?.cancel();
      debugPrint('VeterinarioAI error: $e');
      if (!mounted) return;
      state = state.copyWith(
        enviando: false,
        error: e.toString(),
        respuestaParcial: '',
        estadoProcesamiento: EstadoProcesamiento.ninguno,
      );
    }
  }
}

/// Provider family parametrizado por tipo de consulta, contexto y locale.
///
/// Se usa `.autoDispose` para limpiar cuando el usuario sale del chat.
final chatConsultaProvider = StateNotifierProvider.autoDispose
    .family<
      ChatConsultaNotifier,
      ChatConsultaState,
      ({TipoConsulta tipo, ContextoGranja contexto, String locale})
    >((ref, params) {
      return ChatConsultaNotifier(
        params.tipo,
        params.contexto,
        locale: params.locale,
      );
    });
