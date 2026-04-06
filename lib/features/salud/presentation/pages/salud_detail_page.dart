/// Página de detalle de un registro de salud.
///
/// Muestra información completa del registro de salud con diseño moderno:
/// - Header con estado (En tratamiento/Cerrado)
/// - Ubicación (Granja + Lote)
/// - Información del diagnóstico
/// - Información de tratamiento
/// - Información de registro
/// - Acciones (Cerrar tratamiento, Eliminar)
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_states.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../application/providers/salud_provider.dart';
import '../../domain/entities/salud_registro.dart';

/// Página de detalle de registro de salud.
class SaludDetailPage extends ConsumerStatefulWidget {
  const SaludDetailPage({super.key, required this.registroId});

  final String registroId;

  @override
  ConsumerState<SaludDetailPage> createState() => _SaludDetailPageState();
}

class _SaludDetailPageState extends ConsumerState<SaludDetailPage> {
  S get l => S.of(context);

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final registroAsync = ref.watch(saludByIdProvider(widget.registroId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.saludDetailTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          registroAsync.when(
            data: (registro) => registro != null
                ? PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                    color: theme.colorScheme.surface,
                    elevation: 3,
                    offset: const Offset(0, 40),
                    tooltip: l.commonMoreOptions,
                    onSelected: (value) => _onMenuSelected(value, registro),
                    itemBuilder: (context) => [
                      if (registro.estaAbierto)
                        PopupMenuItem(
                          value: 'cerrar',
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                            title: Text(l.saludDetailCloseTreatment),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: ListTile(
                          leading: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
                          title: Text(
                            l.commonDelete,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: registroAsync.when(
        data: (registro) {
          if (registro == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.healing_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.gapBase,
                  Text(l.saludRecordNotFound),
                  AppSpacing.gapBase,
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(l.commonBack),
                  ),
                ],
              ),
            );
          }
          return _buildContent(theme, registro);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          message: l.saludLoadError,
          onRetry: () => ref.invalidate(saludByIdProvider(widget.registroId)),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, SaludRegistro registro) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado
          _buildHeaderCard(theme, registro),
          AppSpacing.gapXl,

          // Ubicación (Granja + Lote)
          _buildUbicacionCard(theme, registro),
          AppSpacing.gapBase,

          // Información del diagnóstico
          _buildDiagnosticoCard(theme, registro),
          AppSpacing.gapBase,

          // Información de tratamiento
          if (registro.tratamiento != null ||
              registro.medicamentos != null ||
              registro.dosis != null ||
              registro.duracionDias != null ||
              registro.veterinario != null) ...[
            _buildTratamientoCard(theme, registro),
            AppSpacing.gapBase,
          ],

          // Información de Registro
          _buildRegistroCard(theme, registro),
          AppSpacing.gapBase,

          // Botón de acción principal si está abierto
          if (registro.estaAbierto) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _cerrarTratamiento(registro),
                icon: const Icon(Icons.check_circle),
                label: Text(l.saludDetailCloseTreatment),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                ),
              ),
            ),
            AppSpacing.gapBase,
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme, SaludRegistro registro) {
    final l = S.of(context);
    Color statusColor;
    String statusText;

    if (registro.estaCerrado) {
      statusColor = AppColors.success;
      statusText = l.saludDetailStatusClosed;
    } else {
      statusColor = AppColors.warning;
      statusText = l.saludDetailStatusInTreatment;
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Punto de color del estado
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        registro.diagnostico,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.gapXxxs,
                      Text(
                        'Fecha: ${_dateFormat.format(registro.fecha)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de estado
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (registro.fechaCierre != null) ...[
              AppSpacing.gapBase,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allSm,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_available,
                          size: 18,
                          color: AppColors.success,
                        ),
                        AppSpacing.hGapSm,
                        Text(
                          l.closedOnDate(
                            _dateFormat.format(registro.fechaCierre!),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (registro.resultado != null &&
                        registro.resultado!.isNotEmpty) ...[
                      AppSpacing.gapSm,
                      Text(
                        'Resultado: ${registro.resultado}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUbicacionCard(ThemeData theme, SaludRegistro registro) {
    final l = S.of(context);
    final granjaAsync = ref.watch(granjaByIdProvider(registro.granjaId));
    final loteAsync = ref.watch(loteByIdProvider(registro.loteId));

    final granjaNombre = granjaAsync.maybeWhen(
      data: (granja) => granja?.nombre ?? l.commonFarmNotFound,
      orElse: () => l.commonLoading,
    );

    final loteNombre = loteAsync.maybeWhen(
      data: (lote) => lote?.nombre ?? l.commonBatchNotFound,
      orElse: () => l.commonLoading,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.commonLocation,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(theme, l.commonFarm, granjaNombre),
                _buildInfoRow(theme, l.commonBatch, loteNombre),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticoCard(ThemeData theme, SaludRegistro registro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            S.of(context).saludDiagnosis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  theme,
                  S.of(context).saludDiagnosis,
                  registro.diagnostico,
                ),
                _buildInfoRow(
                  theme,
                  S.of(context).commonDate,
                  _dateFormat.format(registro.fecha),
                ),
                if (registro.sintomas != null &&
                    registro.sintomas!.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text(
                    S.of(context).saludSymptoms,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    registro.sintomas!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (registro.observaciones != null &&
                    registro.observaciones!.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text(
                    S.of(context).commonObservations,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    registro.observaciones!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTratamientoCard(ThemeData theme, SaludRegistro registro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            S.of(context).saludTreatment,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (registro.tratamiento != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).saludTreatment,
                    registro.tratamiento!,
                  ),
                if (registro.medicamentos != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).saludMedications,
                    registro.medicamentos!,
                  ),
                if (registro.dosis != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).saludDose,
                    registro.dosis!,
                  ),
                if (registro.duracionDias != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).saludDuration,
                    S
                        .of(context)
                        .commonDurationDays(registro.duracionDias.toString()),
                  ),
                if (registro.veterinario != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).saludVeterinarian,
                    registro.veterinario!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistroCard(ThemeData theme, SaludRegistro registro) {
    final usuariosAsync = ref.watch(usuariosGranjaProvider(registro.granjaId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            S.of(context).commonRegistrationInfo,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: usuariosAsync.when(
              data: (usuarios) {
                final registrador = usuarios
                    .where((u) => u.usuarioId == registro.registradoPor)
                    .firstOrNull;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      theme,
                      S.of(context).commonRegisteredBy,
                      registrador?.nombreCompleto ?? S.of(context).commonUser,
                    ),
                    if (registrador != null)
                      _buildInfoRow(
                        theme,
                        S.of(context).commonRole,
                        registrador.rol.localizedDisplayName(S.of(context)),
                      ),
                    _buildInfoRow(
                      theme,
                      S.of(context).commonRegistrationDate,
                      _formatDateTimePretty(registro.fechaCreacion),
                    ),
                    if (registro.ultimaActualizacion != registro.fechaCreacion)
                      _buildInfoRow(
                        theme,
                        S.of(context).commonLastUpdate,
                        _formatDateTimePretty(registro.ultimaActualizacion),
                      ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    theme,
                    S.of(context).saludRegisteredBy,
                    registro.registradoPor,
                  ),
                  _buildInfoRow(
                    theme,
                    S.of(context).commonRegistrationDate,
                    _formatDateTimePretty(registro.fechaCreacion),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTimePretty(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat.yMMMMd(locale).format(date);
    final hora = date.hour.toString().padLeft(2, '0');
    final minuto = date.minute.toString().padLeft(2, '0');
    return '$dateStr • $hora:$minuto';
  }

  void _onMenuSelected(String value, SaludRegistro registro) {
    switch (value) {
      case 'cerrar':
        _cerrarTratamiento(registro);
        break;
      case 'eliminar':
        _confirmarEliminar(registro);
        break;
    }
  }

  Future<void> _cerrarTratamiento(SaludRegistro registro) async {
    unawaited(HapticFeedback.lightImpact());

    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => _CerrarTratamientoDialog(registro: registro),
    );

    if (resultado == null || !mounted) return;

    try {
      final notifier = ref.read(saludNotifierProvider.notifier);
      await notifier.cerrarRegistroSalud(
        registro.id,
        fechaCierre: resultado['fechaCierre'] as DateTime,
        resultado: resultado['resultado'] as String?,
      );

      if (!mounted) return;
      AppSnackBar.success(context, message: S.of(context).treatClosedSuccess);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).treatCloseError,
        detail: e.toString(),
      );
    }
  }

  Future<void> _confirmarEliminar(SaludRegistro registro) async {
    unawaited(HapticFeedback.lightImpact());

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).saludDeleteTitle,
      message: S.of(context).saludDeleteConfirmMsg(registro.diagnostico),
      type: AppDialogType.danger,
    );

    if (confirmed != true || !mounted) return;

    try {
      final notifier = ref.read(saludNotifierProvider.notifier);
      await notifier.eliminarRegistro(registro.id);

      if (!mounted) return;
      AppSnackBar.success(context, message: S.of(context).saludDeletedSuccess);
      context.pop();
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).saludDeleteError,
        detail: e.toString(),
      );
    }
  }
}

/// Dialog para cerrar tratamiento
class _CerrarTratamientoDialog extends StatefulWidget {
  const _CerrarTratamientoDialog({required this.registro});

  final SaludRegistro registro;

  @override
  State<_CerrarTratamientoDialog> createState() =>
      _CerrarTratamientoDialogState();
}

class _CerrarTratamientoDialogState extends State<_CerrarTratamientoDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime _fechaCierre = DateTime.now();
  String _resultado = '';
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).saludCloseTreatment,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              AppSpacing.gapXl,

              // Fecha de cierre
              Text(
                S.of(context).saludCloseDate,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.gapSm,
              InkWell(
                onTap: _selectFecha,
                borderRadius: AppRadius.allSm,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      AppSpacing.hGapMd,
                      Text(
                        _dateFormat.format(_fechaCierre),
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapBase,

              // Resultado
              TextFormField(
                decoration: _inputDecoration(
                  S.of(context).saludResultOptional,
                  hintText: S.of(context).saludDescribeResult,
                ),
                maxLines: 3,
                onChanged: (value) => _resultado = value,
              ),
              AppSpacing.gapXl,

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allSm,
                        ),
                      ),
                      child: Text(S.of(context).commonCancel),
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: FilledButton(
                      onPressed: _confirmar,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allSm,
                        ),
                      ),
                      child: Text(S.of(context).commonConfirm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: AppRadius.allSm),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: BorderSide(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  Future<void> _selectFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaCierre,
      firstDate: widget.registro.fecha,
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() => _fechaCierre = fecha);
    }
  }

  void _confirmar() {
    Navigator.pop(context, {
      'fechaCierre': _fechaCierre,
      'resultado': _resultado.isEmpty ? null : _resultado,
    });
  }
}
