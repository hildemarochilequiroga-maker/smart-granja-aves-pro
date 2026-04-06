/// Página de detalle de una vacunación.
///
/// Muestra información completa de la vacunación con diseño moderno:
/// - Header con estado (Aplicada/Pendiente/Vencida)
/// - Ubicación (Granja + Lote)
/// - Información de la vacuna
/// - Información de registro
/// - Acciones (Marcar aplicada, Editar, Eliminar)
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_states.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../application/providers/vacunacion_provider.dart';
import '../../domain/entities/vacunacion.dart';

/// Página de detalle de vacunación.
class VacunacionDetailPage extends ConsumerStatefulWidget {
  const VacunacionDetailPage({super.key, required this.vacunacionId});

  final String vacunacionId;

  @override
  ConsumerState<VacunacionDetailPage> createState() =>
      _VacunacionDetailPageState();
}

class _VacunacionDetailPageState extends ConsumerState<VacunacionDetailPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vacunacionAsync = ref.watch(
      vacunacionByIdProvider(widget.vacunacionId),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).vacDetailTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          vacunacionAsync.when(
            data: (vacunacion) => vacunacion != null
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
                    tooltip: S.of(context).commonMoreOptions,
                    onSelected: (value) => _onMenuSelected(value, vacunacion),
                    itemBuilder: (context) => [
                      if (!vacunacion.fueAplicada)
                        PopupMenuItem(
                          value: 'aplicar',
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                            title: Text(S.of(context).vacDetailMenuMarkApplied),
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
                            S.of(context).vacDetailMenuDelete,
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
      body: vacunacionAsync.when(
        data: (vacunacion) {
          if (vacunacion == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vaccines_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.gapBase,
                  Text(S.of(context).vacDetailNotFound),
                  AppSpacing.gapBase,
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(S.of(context).commonBack),
                  ),
                ],
              ),
            );
          }
          return _buildContent(theme, vacunacion);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          message: S.of(context).vacCouldNotLoad,
          onRetry: () =>
              ref.invalidate(vacunacionByIdProvider(widget.vacunacionId)),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, Vacunacion vacunacion) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado
          _buildHeaderCard(theme, vacunacion),
          AppSpacing.gapXl,

          // Ubicación (Granja + Lote)
          _buildUbicacionCard(theme, vacunacion),
          AppSpacing.gapBase,

          // Información de la vacuna
          _buildInfoCard(theme, vacunacion),
          AppSpacing.gapBase,

          // Información de Registro
          _buildRegistroCard(theme, vacunacion),
          AppSpacing.gapBase,

          // Botón de acción principal si está pendiente
          if (!vacunacion.fueAplicada) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _marcarAplicada(vacunacion),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: theme.colorScheme.surface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
                ),
                child: Text(S.of(context).vacDetailMarkAppliedButton),
              ),
            ),
            AppSpacing.gapBase,
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme, Vacunacion vacunacion) {
    Color statusColor;
    String statusText;

    if (vacunacion.fueAplicada) {
      statusColor = AppColors.success;
      statusText = S.of(context).healthApplied;
    } else if (vacunacion.estaVencida) {
      statusColor = AppColors.error;
      statusText = S.of(context).healthExpired;
    } else if (vacunacion.esProxima) {
      statusColor = AppColors.warning;
      statusText = S.of(context).healthUpcoming;
    } else {
      statusColor = AppColors.info;
      statusText = S.of(context).healthPending;
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
                        vacunacion.nombreVacuna,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        S
                            .of(context)
                            .vacScheduledFormat(
                              _dateFormat.format(vacunacion.fechaProgramada),
                            ),
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
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (vacunacion.fechaAplicacion != null) ...[
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_available,
                      size: 18,
                      color: AppColors.success,
                    ),
                    AppSpacing.hGapSm,
                    Text(
                      S
                          .of(context)
                          .vacAppliedOnFormat(
                            _dateFormat.format(vacunacion.fechaAplicacion!),
                          ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUbicacionCard(ThemeData theme, Vacunacion vacunacion) {
    final granjaAsync = ref.watch(granjaByIdProvider(vacunacion.granjaId));
    final loteAsync = ref.watch(loteByIdProvider(vacunacion.loteId));

    final granjaNombre = granjaAsync.maybeWhen(
      data: (granja) => granja?.nombre ?? S.of(context).commonFarmNotFound,
      orElse: () => S.of(context).commonLoading,
    );

    final loteNombre = loteAsync.maybeWhen(
      data: (lote) => lote?.nombre ?? S.of(context).commonBatchNotFound,
      orElse: () => S.of(context).commonLoading,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            S.of(context).vacLocationTitle,
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
                _buildInfoRow(theme, S.of(context).commonFarm, granjaNombre),
                _buildInfoRow(theme, S.of(context).commonBatch, loteNombre),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, Vacunacion vacunacion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            S.of(context).vacInfoTitle,
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
                  S.of(context).vacVaccineLabel,
                  vacunacion.nombreVacuna,
                ),
                _buildInfoRow(
                  theme,
                  S.of(context).vacScheduledDate,
                  _dateFormat.format(vacunacion.fechaProgramada),
                ),
                if (vacunacion.edadAplicacionSemanas != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacAgeApplication,
                    S
                        .of(context)
                        .commonWeeks(
                          vacunacion.edadAplicacionSemanas.toString(),
                        ),
                  ),
                if (vacunacion.dosis != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacDoseLabel,
                    vacunacion.dosis!,
                  ),
                if (vacunacion.via != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacRouteShort,
                    vacunacion.via!,
                  ),
                if (vacunacion.laboratorio != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacLaboratory,
                    vacunacion.laboratorio!,
                  ),
                if (vacunacion.loteVacuna != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacBatchVaccineLabel,
                    vacunacion.loteVacuna!,
                  ),
                if (vacunacion.responsable != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacResponsible,
                    vacunacion.responsable!,
                  ),
                if (vacunacion.proximaAplicacion != null)
                  _buildInfoRow(
                    theme,
                    S.of(context).vacNextApplicationLabel,
                    _dateFormat.format(vacunacion.proximaAplicacion!),
                  ),
                if (vacunacion.observaciones != null &&
                    vacunacion.observaciones!.isNotEmpty)
                  _buildInfoRow(
                    theme,
                    S.of(context).commonObservations,
                    vacunacion.observaciones!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistroCard(ThemeData theme, Vacunacion vacunacion) {
    final usuariosAsync = ref.watch(
      usuariosGranjaProvider(vacunacion.granjaId),
    );

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
                    .where((u) => u.usuarioId == vacunacion.programadoPor)
                    .firstOrNull;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      theme,
                      S.of(context).vacScheduledBy,
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
                      _formatDateTimePretty(vacunacion.fechaCreacion),
                    ),
                    if (vacunacion.ultimaActualizacion !=
                        vacunacion.fechaCreacion)
                      _buildInfoRow(
                        theme,
                        S.of(context).commonLastUpdate,
                        _formatDateTimePretty(vacunacion.ultimaActualizacion),
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
                    S.of(context).vacScheduledBy,
                    vacunacion.programadoPor,
                  ),
                  _buildInfoRow(
                    theme,
                    S.of(context).commonRegistrationDate,
                    _formatDateTimePretty(vacunacion.fechaCreacion),
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
    final formatter = DateFormat(
      'd MMMM yyyy • HH:mm',
      Localizations.localeOf(context).toString(),
    );
    return formatter.format(date);
  }

  void _onMenuSelected(String value, Vacunacion vacunacion) {
    switch (value) {
      case 'aplicar':
        _marcarAplicada(vacunacion);
        break;
      case 'eliminar':
        _confirmarEliminar(vacunacion);
        break;
    }
  }

  Future<void> _marcarAplicada(Vacunacion vacunacion) async {
    unawaited(HapticFeedback.lightImpact());

    final fechaAplicacion = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: vacunacion.fechaProgramada.subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      helpText: S.of(context).vacSelectAppDate,
    );

    if (fechaAplicacion == null || !mounted) return;

    try {
      final notifier = ref.read(vacunacionNotifierProvider.notifier);
      await notifier.marcarComoAplicada(
        vacunacion.id,
        fechaAplicacion: fechaAplicacion,
      );

      if (!mounted) return;
      AppSnackBar.success(context, message: S.of(context).vacMarkedApplied);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).vacDetailMarkError,
        detail: e.toString(),
      );
    }
  }

  Future<void> _confirmarEliminar(Vacunacion vacunacion) async {
    unawaited(HapticFeedback.lightImpact());

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).vacDetailDeleteTitle,
      message: S.of(context).vacDetailDeleteMessage(vacunacion.nombreVacuna),
      type: AppDialogType.danger,
    );

    if (confirmed != true || !mounted) return;

    try {
      final notifier = ref.read(vacunacionNotifierProvider.notifier);
      await notifier.eliminarVacunacion(vacunacion.id);

      if (!mounted) return;
      AppSnackBar.success(context, message: S.of(context).vacDeletedSuccess);
      context.pop();
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).vacDetailDeleteError,
        detail: e.toString(),
      );
    }
  }
}
