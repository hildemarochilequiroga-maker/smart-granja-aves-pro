/// Mensaje individual dentro de una consulta de chat.
library;

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Rol del autor del mensaje.
enum RolMensaje { usuario, asistente }

class MensajeChat extends Equatable {
  const MensajeChat({
    required this.rol,
    required this.texto,
    required this.timestamp,
    this.imagenBytes,
    this.imagenMimeType,
  });

  final RolMensaje rol;
  final String texto;
  final DateTime timestamp;

  /// Bytes de la imagen adjunta (nulo si el mensaje es solo texto).
  final Uint8List? imagenBytes;

  /// Tipo MIME de la imagen (p.ej. 'image/jpeg').
  final String? imagenMimeType;

  bool get tieneImagen => imagenBytes != null;

  @override
  List<Object?> get props => [
    rol,
    texto,
    timestamp,
    imagenBytes,
    imagenMimeType,
  ];
}
