import 'package:equatable/equatable.dart';
import '../../../../core/errors/error_messages.dart';
import 'direccion.dart';

/// Value Object que representa un cliente de la granja.
///
/// Inmutable y sin identidad propia.
/// Usado en VentaPedido para almacenar datos del comprador.
class Cliente extends Equatable {
  const Cliente({
    required this.nombre,
    required this.identificacion,
    required this.contacto,
    required this.direccion,
    this.correo,
    this.tipoDocumento = 'DNI',
    this.notas,
  });

  /// Nombre completo o razón social del cliente.
  final String nombre;

  /// Número de documento de identidad o RUC.
  final String identificacion;

  /// Tipo de documento (DNI, RUC, CE, Pasaporte).
  final String tipoDocumento;

  /// Número de teléfono o celular de contacto.
  final String contacto;

  /// Correo electrónico (opcional).
  final String? correo;

  /// Dirección física del cliente.
  final Direccion direccion;

  /// Notas adicionales sobre el cliente.
  final String? notas;

  @override
  List<Object?> get props => [
    nombre,
    identificacion,
    tipoDocumento,
    contacto,
    correo,
    direccion,
    notas,
  ];

  /// Crea una copia con campos modificados.
  Cliente copyWith({
    String? nombre,
    String? identificacion,
    String? tipoDocumento,
    String? contacto,
    String? correo,
    Direccion? direccion,
    String? notas,
  }) {
    return Cliente(
      nombre: nombre ?? this.nombre,
      identificacion: identificacion ?? this.identificacion,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      contacto: contacto ?? this.contacto,
      correo: correo ?? this.correo,
      direccion: direccion ?? this.direccion,
      notas: notas ?? this.notas,
    );
  }

  /// Convierte a Map para serialización.
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'identificacion': identificacion,
      'tipoDocumento': tipoDocumento,
      'contacto': contacto,
      if (correo != null) 'correo': correo,
      'direccion': direccion.toJson(),
      if (notas != null) 'notas': notas,
    };
  }

  /// Crea desde Map (deserialización).
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombre: json['nombre'] as String,
      identificacion: json['identificacion'] as String,
      tipoDocumento: json['tipoDocumento'] as String? ?? 'DNI',
      contacto: json['contacto'] as String,
      correo: json['correo'] as String?,
      direccion: Direccion.fromJson(json['direccion'] as Map<String, dynamic>),
      notas: json['notas'] as String?,
    );
  }

  /// Cliente vacío por defecto.
  factory Cliente.empty() {
    return Cliente(
      nombre: '',
      identificacion: '',
      contacto: '',
      direccion: Direccion.empty(),
    );
  }

  /// Verifica si el cliente está completo (campos obligatorios).
  bool get esCompleto {
    return nombre.isNotEmpty &&
        identificacion.isNotEmpty &&
        contacto.isNotEmpty &&
        direccion.esCompleta;
  }

  /// Verifica si tiene correo electrónico.
  bool get tieneCorreo => correo != null && correo!.isNotEmpty;

  /// Verifica si es persona natural (DNI, CE, Pasaporte).
  bool get esPersonaNatural {
    return tipoDocumento.toUpperCase() == 'DNI' ||
        tipoDocumento.toUpperCase() == 'CE' ||
        tipoDocumento.toUpperCase() == 'PASAPORTE';
  }

  /// Verifica si es persona jurídica (RUC).
  bool get esPersonaJuridica => tipoDocumento.toUpperCase() == 'RUC';

  /// Formatea el documento con su tipo.
  String get documentoFormateado {
    return '$tipoDocumento: $identificacion';
  }

  /// Información de contacto formateada.
  String get contactoFormateado {
    if (tieneCorreo) {
      return '$contacto / $correo';
    }
    return contacto;
  }

  @override
  String toString() => '$nombre ($documentoFormateado)';

  /// Valida el cliente.
  String? validar() {
    if (nombre.isEmpty) {
      return ErrorMessages.get('CLIENTE_NOMBRE_REQUIRED');
    }
    if (nombre.length < 3) {
      return ErrorMessages.get('CLIENTE_NOMBRE_MIN_LENGTH');
    }
    if (identificacion.isEmpty) {
      return ErrorMessages.get('CLIENTE_ID_REQUIRED');
    }

    if (tipoDocumento.toUpperCase() == 'DNI' && identificacion.length != 8) {
      return ErrorMessages.get('CLIENTE_DNI_FORMAT');
    }
    if (tipoDocumento.toUpperCase() == 'RUC' && identificacion.length != 11) {
      return ErrorMessages.get('CLIENTE_RUC_FORMAT');
    }

    if (contacto.isEmpty) {
      return ErrorMessages.get('CLIENTE_CONTACTO_REQUIRED');
    }
    if (contacto.length < 6) {
      return ErrorMessages.get('CLIENTE_CONTACTO_MIN_LENGTH');
    }

    if (correo != null && correo!.isNotEmpty) {
      if (!_esCorreoValido(correo!)) {
        return ErrorMessages.get('CLIENTE_EMAIL_INVALID');
      }
    }

    final errorDireccion = direccion.validar();
    if (errorDireccion != null) {
      return ErrorMessages.format('PREFIX_DIRECCION', {
        'detail': errorDireccion,
      });
    }

    return null;
  }

  /// Verifica si el cliente es válido.
  bool get esValido => validar() == null;

  bool _esCorreoValido(String correo) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(correo);
  }
}
