import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/formatters.dart';

const _kCurrencyKey = 'app_currency';

/// Moneda soportada por la aplicación.
enum AppCurrency {
  pen('PEN', 'S/', 'es_PE', '🇵🇪'),
  usd('USD', '\$', 'en_US', '🇺🇸'),
  ars('ARS', '\$', 'es_AR', '🇦🇷'),
  cop('COP', '\$', 'es_CO', '🇨🇴'),
  mxn('MXN', '\$', 'es_MX', '🇲🇽'),
  ves('VES', 'Bs.', 'es_VE', '🇻🇪'),
  brl('BRL', 'R\$', 'pt_BR', '🇧🇷'),
  bob('BOB', 'Bs', 'es_BO', '🇧🇴'),
  clp('CLP', '\$', 'es_CL', '🇨🇱'),
  eur('EUR', '€', 'es_ES', '🇪🇺');

  const AppCurrency(this.code, this.symbol, this.locale, this.flag);

  /// Código ISO 4217 (e.g. 'PEN', 'USD').
  final String code;

  /// Símbolo de la moneda (e.g. 'S/', '$').
  final String symbol;

  /// Locale para formateo numérico (e.g. 'es_PE').
  final String locale;

  /// Emoji de bandera.
  final String flag;

  /// Nombre legible de la moneda.
  String get displayName {
    return switch (this) {
      AppCurrency.pen => 'Sol peruano (S/)',
      AppCurrency.usd => 'Dólar estadounidense (\$)',
      AppCurrency.ars => 'Peso argentino (\$)',
      AppCurrency.cop => 'Peso colombiano (\$)',
      AppCurrency.mxn => 'Peso mexicano (\$)',
      AppCurrency.ves => 'Bolívar venezolano (Bs.)',
      AppCurrency.brl => 'Real brasileño (R\$)',
      AppCurrency.bob => 'Boliviano (Bs)',
      AppCurrency.clp => 'Peso chileno (\$)',
      AppCurrency.eur => 'Euro (€)',
    };
  }

  /// Busca una moneda por su código ISO.
  static AppCurrency fromCode(String code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => AppCurrency.pen,
    );
  }
}

/// Provider que gestiona la moneda seleccionada.
final currencyProvider = StateNotifierProvider<CurrencyNotifier, AppCurrency>((
  ref,
) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<AppCurrency> {
  CurrencyNotifier() : super(AppCurrency.pen) {
    _loadSavedCurrency();
  }

  Future<void> _loadSavedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kCurrencyKey);
    if (code != null) {
      final currency = AppCurrency.fromCode(code);
      state = currency;
      Formatters.updateCurrency(currency.symbol, currency.locale);
    }
  }

  Future<void> setCurrency(AppCurrency currency) async {
    state = currency;
    Formatters.updateCurrency(currency.symbol, currency.locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrencyKey, currency.code);
  }
}
