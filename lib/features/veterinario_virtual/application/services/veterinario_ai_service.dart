/// Servicio de IA que conecta con Gemini via Firebase AI (Vertex AI).
library;

import 'dart:async';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/tipo_consulta.dart';
import 'contexto_builder.dart';

/// Modelo de Gemini a utilizar.
///
/// gemini-2.5-flash: mejor razonamiento y calidad de respuesta,
/// ideal para análisis veterinario complejo.
const _kModelName = 'gemini-2.5-flash';

/// Servicio que maneja la comunicación con Gemini.
class VeterinarioAiService {
  VeterinarioAiService._();

  static GenerativeModel? _model;

  /// Obtiene el modelo Gemini configurado.
  static GenerativeModel get model {
    _model ??= FirebaseAI.vertexAI().generativeModel(model: _kModelName);
    return _model!;
  }

  /// Crea una sesión de chat con contexto del tipo de consulta.
  static ChatSession crearSesion(
    TipoConsulta tipo,
    ContextoGranja contexto, {
    String locale = 'es',
  }) {
    final systemInstruction = ContextoBuilder.buildSystemInstruction(
      tipo,
      contexto,
      locale: locale,
    );

    final modelConContexto = FirebaseAI.vertexAI().generativeModel(
      model: _kModelName,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topP: 0.92,
        maxOutputTokens: 4096,
      ),
      safetySettings: [
        SafetySetting(
          HarmCategory.harassment,
          HarmBlockThreshold.low,
          HarmBlockMethod.probability,
        ),
        SafetySetting(
          HarmCategory.hateSpeech,
          HarmBlockThreshold.low,
          HarmBlockMethod.probability,
        ),
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.medium,
          HarmBlockMethod.probability,
        ),
        SafetySetting(
          HarmCategory.dangerousContent,
          HarmBlockThreshold.low,
          HarmBlockMethod.probability,
        ),
      ],
    );

    return modelConContexto.startChat();
  }

  /// Envía un mensaje y retorna la respuesta como Stream de texto.
  static Stream<String> enviarMensajeStream(
    ChatSession sesion,
    String mensaje, {
    Uint8List? imagenBytes,
    String? imagenMimeType,
  }) async* {
    final content = _buildContent(
      mensaje,
      imagenBytes: imagenBytes,
      imagenMimeType: imagenMimeType,
    );
    debugPrint('VeterinarioAI: Enviando mensaje a Gemini...');
    final response = sesion.sendMessageStream(content);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null) {
        yield text;
      }
    }
    debugPrint('VeterinarioAI: Stream completado.');
  }

  /// Envía un mensaje y espera la respuesta completa.
  static Future<String> enviarMensaje(
    ChatSession sesion,
    String mensaje, {
    Uint8List? imagenBytes,
    String? imagenMimeType,
  }) async {
    final content = _buildContent(
      mensaje,
      imagenBytes: imagenBytes,
      imagenMimeType: imagenMimeType,
    );
    final response = await sesion.sendMessage(content);
    return response.text ?? '';
  }

  /// Construye el Content adecuado (texto o multimodal con imagen).
  static Content _buildContent(
    String mensaje, {
    Uint8List? imagenBytes,
    String? imagenMimeType,
  }) {
    if (imagenBytes != null && imagenMimeType != null) {
      return Content.multi([
        TextPart(mensaje),
        InlineDataPart(imagenMimeType, imagenBytes),
      ]);
    }
    return Content.text(mensaje);
  }
}
