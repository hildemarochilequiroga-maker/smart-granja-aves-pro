/// Validadores reutilizables para campos de formulario (`TextFormField`).
///
/// Centralizan la lógica repetida de validación inline (requerido, número,
/// rango) en funciones puras `String? Function(String?)`. Los mensajes se
/// pasan ya localizados desde el call site, p. ej.:
///
/// ```dart
/// validator: FieldValidators.required(S.of(context).shedNameIsRequired),
///
/// validator: FieldValidators.numberRange(
///   requiredMessage: l.costoAmountRequired,
///   invalidMessage: l.costoAmountInvalid,
///   min: 0,
/// ),
///
/// validator: FieldValidators.optionalNumberRange(
///   invalidMessage: S.of(context).shedInvalidTempRange,
///   min: 0, max: 50,
/// ),
/// ```
library;

import 'package:flutter/widgets.dart';

/// Colección de validadores de campo reutilizables.
abstract final class FieldValidators {
  const FieldValidators._();

  /// Requerido: el valor no puede ser nulo ni vacío (ignorando espacios).
  static FormFieldValidator<String> required(String message) {
    return (value) =>
        (value == null || value.trim().isEmpty) ? message : null;
  }

  /// Número requerido, opcionalmente dentro de `[min, max]`.
  ///
  /// Devuelve [requiredMessage] si está vacío, o [invalidMessage] si no es un
  /// número válido o queda fuera del rango.
  static FormFieldValidator<String> numberRange({
    required String requiredMessage,
    required String invalidMessage,
    double? min,
    double? max,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return requiredMessage;
      final n = double.tryParse(value.trim().replaceAll(',', '.'));
      if (n == null) return invalidMessage;
      if (min != null && n < min) return invalidMessage;
      if (max != null && n > max) return invalidMessage;
      return null;
    };
  }

  /// Longitud mínima (ignorando espacios). No valida requerido por sí solo;
  /// combínalo con [required] vía [compose] si el campo es obligatorio.
  static FormFieldValidator<String> minLength(String message, int length) {
    return (value) {
      if (value == null) return null;
      return value.trim().length < length ? message : null;
    };
  }

  /// Número estrictamente positivo (> 0) y requerido.
  static FormFieldValidator<String> positiveNumber({
    required String requiredMessage,
    required String invalidMessage,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return requiredMessage;
      final n = double.tryParse(value.trim().replaceAll(',', '.'));
      if (n == null || n <= 0) return invalidMessage;
      return null;
    };
  }

  /// Número opcional: si está vacío es válido; si tiene valor, debe ser un
  /// número dentro de `[min, max]`.
  static FormFieldValidator<String> optionalNumberRange({
    required String invalidMessage,
    double? min,
    double? max,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final n = double.tryParse(value.trim().replaceAll(',', '.'));
      if (n == null) return invalidMessage;
      if (min != null && n < min) return invalidMessage;
      if (max != null && n > max) return invalidMessage;
      return null;
    };
  }

  /// Entero requerido, opcionalmente dentro de `[min, max]`.
  static FormFieldValidator<String> intRange({
    required String requiredMessage,
    required String invalidMessage,
    int? min,
    int? max,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return requiredMessage;
      final n = int.tryParse(value.trim());
      if (n == null) return invalidMessage;
      if (min != null && n < min) return invalidMessage;
      if (max != null && n > max) return invalidMessage;
      return null;
    };
  }

  /// Combina varios validadores; devuelve el primer error encontrado.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
