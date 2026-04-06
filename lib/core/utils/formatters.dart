library;

import 'package:intl/intl.dart';

/// Utilidades para formateo con soporte multi-idioma.
class Formatters {
  const Formatters._();

  // ============================================================================
  // LOCALE MANAGEMENT
  // ============================================================================
  static String _currentLocale = 'es';
  static final Map<String, DateFormat> _dateCache = {};
  static final Map<String, NumberFormat> _numCache = {};

  // ============================================================================
  // CURRENCY MANAGEMENT
  // ============================================================================
  static String _currencySymbol = 'S/';
  static String _currencyLocale = 'es_PE';

  /// Símbolo de moneda activo (e.g. 'S/', '$', '€').
  static String get currencySymbol => _currencySymbol;

  /// Locale numérico de la moneda (e.g. 'es_PE', 'en_US').
  static String get currencyLocale => _currencyLocale;

  /// Locale activo (e.g. 'es', 'en').
  static String get currentLocale => _currentLocale;

  /// Actualiza el locale y limpia caches de formateo.
  static void updateLocale(String locale) {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      _dateCache.clear();
      _numCache.clear();
    }
  }

  /// Actualiza la moneda y limpia caches numéricos.
  static void updateCurrency(String symbol, String locale) {
    if (_currencySymbol != symbol || _currencyLocale != locale) {
      _currencySymbol = symbol;
      _currencyLocale = locale;
      _numCache.clear();
    }
  }

  static DateFormat _dateFmt(String key, String pattern, [String? locale]) {
    final loc = locale ?? _currentLocale;
    final k = '${key}_$loc';
    return _dateCache.putIfAbsent(k, () => DateFormat(pattern, loc));
  }

  static NumberFormat _numFmt(String key, NumberFormat Function() factory) {
    final k = '${key}_$_currentLocale';
    return _numCache.putIfAbsent(k, factory);
  }

  // ============================================================================
  // PATRONES DE FECHA CON LITERALES DEPENDIENTES DEL IDIOMA
  // ============================================================================
  static const _longPatterns = {
    'es': "EEEE, d 'de' MMMM 'de' yyyy",
    'en': 'EEEE, MMMM d, yyyy',
    'pt': "EEEE, d 'de' MMMM 'de' yyyy",
  };
  static const _fechaCompletaPatterns = {
    'es': "EEEE, d 'de' MMMM yyyy",
    'en': 'EEEE, MMMM d, yyyy',
    'pt': "EEEE, d 'de' MMMM yyyy",
  };
  static const _fechaCompleta24hPatterns = {
    'es': "dd 'de' MMMM yyyy, HH:mm",
    'en': 'MMMM dd, yyyy, HH:mm',
    'pt': "dd 'de' MMMM yyyy, HH:mm",
  };
  static const _fechaDeMesPatterns = {
    'es': "dd 'de' MMMM, yyyy",
    'en': 'MMMM dd, yyyy',
    'pt': "dd 'de' MMMM, yyyy",
  };

  // ============================================================================
  // FORMATEADORES SIN LOCALE (no usan nombres de mes/día)
  // ============================================================================
  static final _fmtDDMMYYYY = DateFormat('dd/MM/yyyy');
  static final _fmtHHmm = DateFormat('HH:mm');
  static final _fmtDateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final _fmtApi = DateFormat('yyyy-MM-dd');

  // ============================================================================
  // FORMATEADORES CON LOCALE (getters con cache)
  // ============================================================================

  /// "lunes, 5 de enero 2024" / "Monday, January 5, 2024"
  static DateFormat get fechaCompletaEs => _dateFmt(
    'fechaCompleta',
    _fechaCompletaPatterns[_currentLocale] ?? _fechaCompletaPatterns['es']!,
  );

  /// "lunes, 5 enero 2024" / "Monday, 5 January 2024"
  static DateFormat get fechaLargaEs =>
      _dateFmt('fechaLarga', 'EEEE, d MMMM yyyy');

  /// "lunes, 5 enero" / "Monday, 5 January"
  static DateFormat get fechaDiaMesEs =>
      _dateFmt('fechaDiaMes', 'EEEE, d MMMM');

  /// "lunes 5 enero, 2024" / "Monday 5 January, 2024"
  static DateFormat get fechaConComaEs =>
      _dateFmt('fechaConComa', 'EEEE d MMMM, yyyy');

  /// "05 ene 2024" / "05 Jan 2024"
  static DateFormat get fechaCorta => _dateFmt('fechaCorta', 'dd MMM yyyy');

  /// "05/01/2024"
  static DateFormat get fechaDDMMYYYY => _fmtDDMMYYYY;

  /// "05/01/24"
  static DateFormat get fechaDDMMYY => _dateFmt('fechaDDMMYY', 'dd/MM/yy');

  /// "05/01"
  static DateFormat get fechaDDMM => _dateFmt('fechaDDMM', 'dd/MM');

  /// "05/01 14:30"
  static DateFormat get fechaDDMMHHmm =>
      _dateFmt('fechaDDMMHHmm', 'dd/MM HH:mm');

  /// "05/01/2024 14:30"
  static DateFormat get fechaDDMMYYYYHHmm => _fmtDateTime;

  /// "05 de enero 2024, 14:30" / "January 05, 2024, 14:30"
  static DateFormat get fechaCompleta24hEs => _dateFmt(
    'fechaCompleta24h',
    _fechaCompleta24hPatterns[_currentLocale] ??
        _fechaCompleta24hPatterns['es']!,
  );

  /// "hh:mm a" (12h)
  static DateFormat get hora12Es => _dateFmt('hora12', 'hh:mm a');

  /// "14:30" (24h)
  static DateFormat get hora24 => _fmtHHmm;

  /// "HH:mm" con locale
  static DateFormat get hora24Es => _dateFmt('hora24Es', 'HH:mm');

  /// Solo día "5"
  static DateFormat get diaEs => _dateFmt('dia', 'd');

  /// Solo mes "enero" / "January"
  static DateFormat get mesEs => _dateFmt('mes', 'MMMM');

  /// Solo año "2024"
  static DateFormat get anioEs => _dateFmt('anio', 'yyyy');

  /// Moneda con formato local
  static String get _intlLocaleCompact {
    switch (_currentLocale) {
      case 'es':
        return 'es_ES';
      case 'pt':
        return 'pt_BR';
      default:
        return 'en_US';
    }
  }

  /// Moneda con formato del locale seleccionado
  static NumberFormat get moneda =>
      _numFmt('moneda', () => NumberFormat('#,##0.00', _currencyLocale));

  /// Formatea valor con símbolo de moneda del usuario.
  /// Ejemplo: "S/ 1,234.56", "$ 1,234.56", "€ 1,234.56"
  static String currencyValue(num? value, {int decimals = 2}) {
    if (value == null) return '';
    return '$_currencySymbol ${moneda.format(value)}';
  }

  /// Solo el símbolo con espacio: "S/ ", "$ ", etc.
  static String get currencyPrefix => '$_currencySymbol ';

  /// Número con separador de miles
  static NumberFormat get numeroMiles =>
      _numFmt('numeroMiles', () => NumberFormat('#,###', _intlLocaleCompact));

  /// "dd de MMMM, yyyy" / "MMMM dd, yyyy" — for detail utils
  static DateFormat get fechaDeMes => _dateFmt(
    'fechaDeMes',
    _fechaDeMesPatterns[_currentLocale] ?? _fechaDeMesPatterns['es']!,
  );

  // ============================================================================
  // FECHAS (métodos helper que usan las instancias cacheadas)
  // ============================================================================

  /// Formatea fecha: 01/01/2024
  static String date(DateTime? date) {
    if (date == null) return '';
    return _fmtDDMMYYYY.format(date);
  }

  /// Formatea hora: 14:30
  static String time(DateTime? date) {
    if (date == null) return '';
    return _fmtHHmm.format(date);
  }

  /// Formatea fecha y hora: 01/01/2024 14:30
  static String dateTime(DateTime? date) {
    if (date == null) return '';
    return _fmtDateTime.format(date);
  }

  /// Formatea fecha larga: Lunes, 1 de enero de 2024 / Monday, January 1, 2024
  static String dateLong(DateTime? date) {
    if (date == null) return '';
    return _dateFmt(
      'long',
      _longPatterns[_currentLocale] ?? _longPatterns['es']!,
    ).format(date);
  }

  /// Formatea fecha corta: 1 ene 2024 / Jan 1, 2024
  static String dateShort(DateTime? date) {
    if (date == null) return '';
    return _dateFmt('short', 'd MMM yyyy').format(date);
  }

  /// Formatea fecha para API: 2024-01-01
  static String dateApi(DateTime? date) {
    if (date == null) return '';
    return _fmtApi.format(date);
  }

  /// Formatea fecha relativa: Hoy, Ayer, hace X dias
  static String dateRelative(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return switch (_currentLocale) {
        'es' => 'Hoy',
        'pt' => 'Hoje',
        _ => 'Today',
      };
    }
    if (difference == 1) {
      return switch (_currentLocale) {
        'es' => 'Ayer',
        'pt' => 'Ontem',
        _ => 'Yesterday',
      };
    }
    if (difference == -1) {
      return switch (_currentLocale) {
        'es' => 'Mañana',
        'pt' => 'Amanhã',
        _ => 'Tomorrow',
      };
    }
    if (difference > 0 && difference < 7) {
      return switch (_currentLocale) {
        'es' => 'Hace $difference días',
        'pt' => 'Há $difference dias',
        _ => '$difference days ago',
      };
    }
    if (difference < 0 && difference > -7) {
      return switch (_currentLocale) {
        'es' => 'En ${-difference} días',
        'pt' => 'Em ${-difference} dias',
        _ => 'In ${-difference} days',
      };
    }

    return Formatters.date(date);
  }

  // ============================================================================
  // NUMEROS
  // ============================================================================

  /// Formatea numero con separadores de miles
  static String number(num? value, {int decimals = 0}) {
    if (value == null) return '';
    return NumberFormat.decimalPattern(
      _intlLocaleCompact,
    ).format(decimals == 0 ? value.round() : value);
  }

  /// Formatea como moneda (usando NumberFormat.currency de intl)
  static String currency(num? value, {String? symbol, int decimals = 2}) {
    if (value == null) return '';
    return NumberFormat.currency(
      symbol: symbol ?? _currencySymbol,
      decimalDigits: decimals,
      locale: _currencyLocale,
    ).format(value);
  }

  /// Formatea como porcentaje
  static String percentage(num? value, {int decimals = 1}) {
    if (value == null) return '';
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Formatea numero compacto: 1K, 1M
  static String compact(num? value) {
    if (value == null) return '';
    return NumberFormat.compact(locale: _intlLocaleCompact).format(value);
  }

  /// Formatea peso (kg o g)
  static String weight(num? grams, {bool autoUnit = true}) {
    if (grams == null) return '';

    if (autoUnit && grams >= 1000) {
      return '${(grams / 1000).toStringAsFixed(2)} kg';
    }
    return '${grams.toStringAsFixed(0)} g';
  }

  /// Formatea temperatura
  static String temperature(num? value, {String unit = 'C'}) {
    if (value == null) return '';
    return '${value.toStringAsFixed(1)} °$unit';
  }

  /// Formatea humedad
  static String humidity(num? value) {
    if (value == null) return '';
    return '${value.toStringAsFixed(1)}%';
  }

  // ============================================================================
  // TEXTO
  // ============================================================================

  /// Capitaliza primera letra
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Capitaliza cada palabra
  static String titleCase(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }

  /// Trunca texto con ellipsis
  static String truncate(String? text, int maxLength) {
    if (text == null) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Enmascara email
  static String maskEmail(String? email) {
    if (email == null || !email.contains('@')) return '';

    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];

    final maskedName = name.length > 2
        ? '${name.substring(0, 2)}${'*' * (name.length - 2)}'
        : name;

    return '$maskedName@$domain';
  }

  /// Enmascara telefono
  static String maskPhone(String? phone) {
    if (phone == null || phone.length < 4) return '';
    return '****${phone.substring(phone.length - 4)}';
  }

  // ============================================================================
  // UNIDADES
  // ============================================================================

  /// Formatea con unidad
  static String withUnit(num? value, String unit, {int decimals = 0}) {
    if (value == null) return '';
    return '${value.toStringAsFixed(decimals)} $unit';
  }

  /// Formatea cantidad de aves
  static String aves(int? count) {
    if (count == null) return '';
    return switch (_currentLocale) {
      'es' => '$count ${count == 1 ? 'ave' : 'aves'}',
      'pt' => '$count ${count == 1 ? 'ave' : 'aves'}',
      _ => '$count ${count == 1 ? 'bird' : 'birds'}',
    };
  }

  /// Formatea dias
  static String dias(int? count) {
    if (count == null) return '';
    return switch (_currentLocale) {
      'es' => '$count ${count == 1 ? 'día' : 'días'}',
      'pt' => '$count ${count == 1 ? 'dia' : 'dias'}',
      _ => '$count ${count == 1 ? 'day' : 'days'}',
    };
  }
}
