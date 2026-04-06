/// Página de configuración de notificaciones.
///
/// Permite personalizar qué tipos de alertas recibir:
/// - Alertas de mortalidad
/// - Alertas de producción
/// - Alertas de consumo
/// - Recordatorios de vacunación
/// - Alertas de inventario bajo
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';

/// Página de configuración de notificaciones.
class NotificacionesConfigPage extends ConsumerStatefulWidget {
  const NotificacionesConfigPage({super.key});

  @override
  ConsumerState<NotificacionesConfigPage> createState() =>
      _NotificacionesConfigPageState();
}

class _NotificacionesConfigPageState
    extends ConsumerState<NotificacionesConfigPage> {
  // Estados de las notificaciones
  bool _alertaMortalidad = true;
  bool _alertaProduccion = true;
  bool _alertaConsumo = true;
  bool _recordatorioVacunacion = true;
  bool _alertaInventario = true;
  bool _resumenDiario = false;
  bool _resumenSemanal = true;

  // Umbrales
  double _umbralMortalidad = 5.0;
  double _umbralProduccion = 80.0;

  // Valores iniciales para detectar cambios
  late bool _initialAlertaMortalidad;
  late bool _initialAlertaProduccion;
  late bool _initialAlertaConsumo;
  late bool _initialRecordatorioVacunacion;
  late bool _initialAlertaInventario;
  late bool _initialResumenDiario;
  late bool _initialResumenSemanal;
  late double _initialUmbralMortalidad;
  late double _initialUmbralProduccion;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _alertaMortalidad = prefs.getBool('notif_alerta_mortalidad') ?? true;
      _alertaProduccion = prefs.getBool('notif_alerta_produccion') ?? true;
      _alertaConsumo = prefs.getBool('notif_alerta_consumo') ?? true;
      _recordatorioVacunacion =
          prefs.getBool('notif_recordatorio_vacunacion') ?? true;
      _alertaInventario = prefs.getBool('notif_alerta_inventario') ?? true;
      _resumenDiario = prefs.getBool('notif_resumen_diario') ?? false;
      _resumenSemanal = prefs.getBool('notif_resumen_semanal') ?? true;
      _umbralMortalidad = prefs.getDouble('notif_umbral_mortalidad') ?? 5.0;
      _umbralProduccion = prefs.getDouble('notif_umbral_produccion') ?? 80.0;
      _saveInitialValues();
    });
  }

  void _saveInitialValues() {
    _initialAlertaMortalidad = _alertaMortalidad;
    _initialAlertaProduccion = _alertaProduccion;
    _initialAlertaConsumo = _alertaConsumo;
    _initialRecordatorioVacunacion = _recordatorioVacunacion;
    _initialAlertaInventario = _alertaInventario;
    _initialResumenDiario = _resumenDiario;
    _initialResumenSemanal = _resumenSemanal;
    _initialUmbralMortalidad = _umbralMortalidad;
    _initialUmbralProduccion = _umbralProduccion;
  }

  bool get _hasChanges {
    return _alertaMortalidad != _initialAlertaMortalidad ||
        _alertaProduccion != _initialAlertaProduccion ||
        _alertaConsumo != _initialAlertaConsumo ||
        _recordatorioVacunacion != _initialRecordatorioVacunacion ||
        _alertaInventario != _initialAlertaInventario ||
        _resumenDiario != _initialResumenDiario ||
        _resumenSemanal != _initialResumenSemanal ||
        _umbralMortalidad != _initialUmbralMortalidad ||
        _umbralProduccion != _initialUmbralProduccion;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showAppConfirmDialog(
          context: context,
          title: l.commonUnsavedChanges,
          message: l.commonExitWithoutSave,
          type: AppDialogType.warning,
          confirmText: l.commonExit,
        );
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Text(l.settingsNotifications),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            12 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: FilledButton(
            onPressed: _hasChanges ? _guardarConfiguracion : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
            ),
            child: Text(
              l.notifSaveConfig,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sección: Alertas de Producción
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l.notifProductionAlerts,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            _buildSeccion(
              theme,
              children: [
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifHighMortality,
                  subtitulo: l.notifHighMortalitySubtitle(
                    _umbralMortalidad.toInt().toString(),
                  ),
                  icono: Icons.warning_amber_rounded,
                  iconColor: AppColors.error,
                  valor: _alertaMortalidad,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _alertaMortalidad = value);
                  },
                ),
                if (_alertaMortalidad) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSlider(
                      theme,
                      label: l.notifMortalityThreshold,
                      valor: _umbralMortalidad,
                      min: 1,
                      max: 15,
                      sufijo: '%',
                      onChanged: (value) {
                        setState(() => _umbralMortalidad = value);
                      },
                    ),
                  ),
                ],
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifLowProduction,
                  subtitulo: l.notifLowProductionSubtitle(
                    _umbralProduccion.toInt().toString(),
                  ),
                  icono: Icons.trending_down_rounded,
                  iconColor: AppColors.warning,
                  valor: _alertaProduccion,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _alertaProduccion = value);
                  },
                ),
                if (_alertaProduccion) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSlider(
                      theme,
                      label: l.notifProductionThreshold,
                      valor: _umbralProduccion,
                      min: 50,
                      max: 95,
                      sufijo: '%',
                      onChanged: (value) {
                        setState(() => _umbralProduccion = value);
                      },
                    ),
                  ),
                ],
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifAbnormalConsumption,
                  subtitulo: l.notifAbnormalConsumptionSubtitle,
                  icono: Icons.restaurant_rounded,
                  iconColor: AppColors.brown,
                  valor: _alertaConsumo,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _alertaConsumo = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sección: Recordatorios
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l.notifReminders,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            _buildSeccion(
              theme,
              children: [
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifPendingVaccinations,
                  subtitulo: l.notifPendingVaccinationsSubtitle,
                  icono: Icons.vaccines,
                  iconColor: AppColors.info,
                  valor: _recordatorioVacunacion,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _recordatorioVacunacion = value);
                  },
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifLowInventory,
                  subtitulo: l.notifLowInventorySubtitle,
                  icono: Icons.inventory_2_outlined,
                  iconColor: AppColors.purple,
                  valor: _alertaInventario,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _alertaInventario = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sección: Resúmenes
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l.notifSummaries,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            _buildSeccion(
              theme,
              children: [
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifDailySummary,
                  subtitulo: l.notifDailySummarySubtitle,
                  icono: Icons.today,
                  iconColor: AppColors.success,
                  valor: _resumenDiario,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _resumenDiario = value);
                  },
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                _buildAlertaSwitch(
                  theme,
                  titulo: l.notifWeeklySummary,
                  subtitulo: l.notifWeeklySummarySubtitle,
                  icono: Icons.date_range,
                  iconColor: AppColors.cyan,
                  valor: _resumenSemanal,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _resumenSemanal = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccion(ThemeData theme, {required List<Widget> children}) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildAlertaSwitch(
    ThemeData theme, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color iconColor,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!valor),
      borderRadius: AppRadius.allMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.allMd,
              ),
              child: Icon(icono, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: valor,
              onChanged: onChanged,
              activeTrackColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    ThemeData theme, {
    required String label,
    required double valor,
    required double min,
    required double max,
    required String sufijo,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${valor.toInt()}$sufijo',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: valor,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
          activeColor: AppColors.info,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _guardarConfiguracion() async {
    unawaited(HapticFeedback.mediumImpact());

    // Persistir configuración en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool('notif_alerta_mortalidad', _alertaMortalidad),
      prefs.setBool('notif_alerta_produccion', _alertaProduccion),
      prefs.setBool('notif_alerta_consumo', _alertaConsumo),
      prefs.setBool('notif_recordatorio_vacunacion', _recordatorioVacunacion),
      prefs.setBool('notif_alerta_inventario', _alertaInventario),
      prefs.setBool('notif_resumen_diario', _resumenDiario),
      prefs.setBool('notif_resumen_semanal', _resumenSemanal),
      prefs.setDouble('notif_umbral_mortalidad', _umbralMortalidad),
      prefs.setDouble('notif_umbral_produccion', _umbralProduccion),
    ]);

    _saveInitialValues();
    if (!mounted) return;
    setState(() {}); // Actualizar UI para deshabilitar botón

    AppSnackBar.success(context, message: S.of(context).notifConfigSaved);
  }
}
