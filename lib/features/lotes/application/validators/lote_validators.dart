/// Validadores de negocio para lotes.
///
/// Encapsulan las reglas de validación para operaciones de lotes.
library;

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/tipo_ave.dart';

/// Validadores de negocio para lotes.
class LoteValidators {
  /// Valida que la cantidad inicial sea válida.
  static ValidationResult validarCantidadInicial(int cantidad) {
    if (cantidad < 10) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad inicial debe ser al menos 10 aves', 'pt' => 'A quantidade inicial deve ser de pelo menos 10 aves', _ => 'Initial quantity must be at least 10 birds' },
      );
    }

    if (cantidad > 100000) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad inicial no puede exceder 100,000 aves', 'pt' => 'A quantidade inicial não pode exceder 100.000 aves', _ => 'Initial quantity cannot exceed 100,000 birds' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que la cantidad de mortalidad sea válida.
  static ValidationResult validarCantidadMortalidad({
    required int cantidadMortalidad,
    required int cantidadActual,
  }) {
    if (cantidadMortalidad <= 0) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad de mortalidad debe ser mayor a 0', 'pt' => 'A quantidade de mortalidade deve ser maior que 0', _ => 'Mortality count must be greater than 0' },
      );
    }

    if (cantidadMortalidad > cantidadActual) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) {
              'es' => 'La cantidad de mortalidad ($cantidadMortalidad) no puede exceder '
                  'la cantidad actual ($cantidadActual)',
              'pt' => 'A quantidade de mortalidade ($cantidadMortalidad) não pode exceder '
                  'a quantidade atual ($cantidadActual)',
              _ => 'Mortality count ($cantidadMortalidad) cannot exceed '
                  'current count ($cantidadActual)',
            },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que el peso sea válido.
  static ValidationResult validarPeso(double pesoGramos) {
    if (pesoGramos <= 0) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'El peso debe ser mayor a 0 gramos', 'pt' => 'O peso deve ser maior que 0 gramas', _ => 'Weight must be greater than 0 grams' },
      );
    }

    if (pesoGramos > 20000) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'El peso no puede exceder 20,000 gramos (20 kg)', 'pt' => 'O peso não pode exceder 20.000 gramas (20 kg)', _ => 'Weight cannot exceed 20,000 grams (20 kg)' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que el consumo de alimento sea válido.
  static ValidationResult validarConsumo(double consumoKg) {
    if (consumoKg <= 0) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad de alimento debe ser mayor a 0', 'pt' => 'A quantidade de ração deve ser maior que 0', _ => 'Feed amount must be greater than 0' },
      );
    }

    if (consumoKg > 10000) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad de alimento no puede exceder 10,000 kg', 'pt' => 'A quantidade de ração não pode exceder 10.000 kg', _ => 'Feed amount cannot exceed 10,000 kg' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que la producción de huevos sea válida.
  static ValidationResult validarProduccionHuevos({
    required int cantidadHuevos,
    required int cantidadAves,
    required TipoAve tipoAve,
  }) {
    if (!tipoAve.esPonedora) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'Solo los lotes de ponedoras pueden producir huevos', 'pt' => 'Somente os lotes de poedeiras podem produzir ovos', _ => 'Only layer batches can produce eggs' },
      );
    }

    if (cantidadHuevos <= 0) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La cantidad de huevos debe ser mayor a 0', 'pt' => 'A quantidade de ovos deve ser maior que 0', _ => 'Egg count must be greater than 0' },
      );
    }

    // Validar tasa de postura razonable (máximo 120% por posibles reservas)
    final tasaPostura = (cantidadHuevos / cantidadAves) * 100;
    if (tasaPostura > 120) {
      return ValidationResult(
        isValid: false,
        isWarning: true,
        message: switch (Formatters.currentLocale) {
              'es' => 'La tasa de postura del ${tasaPostura.toStringAsFixed(1)}% parece muy alta. '
                  'Verifique los datos.',
              'pt' => 'A taxa de postura de ${tasaPostura.toStringAsFixed(1)}% parece muito alta. '
                  'Verifique os dados.',
              _ => 'The laying rate of ${tasaPostura.toStringAsFixed(1)}% seems very high. '
                  'Please verify the data.',
            },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que la fecha de ingreso sea válida.
  static ValidationResult validarFechaIngreso(DateTime fechaIngreso) {
    if (fechaIngreso.isAfter(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La fecha de ingreso no puede ser futura', 'pt' => 'A data de entrada não pode ser futura', _ => 'Entry date cannot be in the future' },
      );
    }

    // Validar que no sea muy antigua (más de 5 años)
    final cincoAnosAtras = DateTime.now().subtract(const Duration(days: 1825));
    if (fechaIngreso.isBefore(cincoAnosAtras)) {
      return ValidationResult(
        isValid: false,
        isWarning: true,
        message: switch (Formatters.currentLocale) { 'es' => 'La fecha de ingreso parece muy antigua (más de 5 años)', 'pt' => 'A data de entrada parece muito antiga (mais de 5 anos)', _ => 'Entry date seems too old (more than 5 years)' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que la fecha de cierre sea válida.
  static ValidationResult validarFechaCierre({
    required DateTime fechaCierre,
    required DateTime fechaIngreso,
  }) {
    if (fechaCierre.isBefore(fechaIngreso)) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La fecha de cierre no puede ser anterior a la fecha de ingreso', 'pt' => 'A data de fechamento não pode ser anterior à data de entrada', _ => 'Close date cannot be before the entry date' },
      );
    }

    if (fechaCierre.isAfter(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'La fecha de cierre no puede ser futura', 'pt' => 'A data de fechamento não pode ser futura', _ => 'Close date cannot be in the future' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida que el código del lote sea único.
  static ValidationResult validarCodigoUnico({
    required String codigo,
    required List<Lote> lotesExistentes,
    String? loteIdActual,
  }) {
    final existeOtro = lotesExistentes.any(
      (l) => l.codigo == codigo && l.id != loteIdActual,
    );

    if (existeOtro) {
      return ValidationResult(
        isValid: false,
        message: switch (Formatters.currentLocale) { 'es' => 'Ya existe otro lote con el código "$codigo"', 'pt' => 'Já existe outro lote com o código "$codigo"', _ => 'Another batch with code "$codigo" already exists' },
      );
    }

    return const ValidationResult(isValid: true);
  }

  /// Valida un lote completo antes de crear.
  static ValidationResult validarCreacionLote({
    required int cantidadInicial,
    required TipoAve tipoAve,
    required DateTime fechaIngreso,
    String? codigo,
    List<Lote>? lotesExistentes,
  }) {
    // 1. Validar cantidad
    final validacionCantidad = validarCantidadInicial(cantidadInicial);
    if (!validacionCantidad.isValid) return validacionCantidad;

    // 2. Validar fecha
    final validacionFecha = validarFechaIngreso(fechaIngreso);
    if (!validacionFecha.isValid) return validacionFecha;

    // 3. Validar código único si se proporciona
    if (codigo != null && lotesExistentes != null) {
      final validacionCodigo = validarCodigoUnico(
        codigo: codigo,
        lotesExistentes: lotesExistentes,
      );
      if (!validacionCodigo.isValid) return validacionCodigo;
    }

    return const ValidationResult(isValid: true);
  }
}

/// Resultado de una validación.
class ValidationResult {
  final bool isValid;
  final bool isWarning;
  final String? message;

  const ValidationResult({
    required this.isValid,
    this.isWarning = false,
    this.message,
  });

  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  String toString() {
    if (isValid && !isWarning) return 'ValidationResult: Valid';
    if (isWarning) return 'ValidationResult: Warning - $message';
    return 'ValidationResult: Invalid - $message';
  }
}
