/// Paso 3: Resumen del lote.
///
/// Widget modular para mostrar el resumen de la información
/// del lote antes de confirmar la creación.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../domain/enums/enums.dart';
import '../../../../galpones/application/providers/providers.dart';
import '../../../../granjas/application/providers/providers.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Paso 3: Resumen y confirmación del lote
class LoteResumenStep extends ConsumerWidget {
  const LoteResumenStep({
    super.key,
    required this.granjaId,
    required this.codigo,
    required this.tipoAve,
    required this.fechaIngreso,
    required this.cantidadInicial,
    required this.edadIngreso,
    required this.galponId,
    required this.observaciones,
  });

  final String granjaId;
  final String codigo;
  final TipoAve? tipoAve;
  final DateTime? fechaIngreso;
  final int? cantidadInicial;
  final int? edadIngreso;
  final String? galponId;
  final String observaciones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Mostrar edad en días, y opcionalmente en semanas
    String edadTexto = S.of(context).batchFormNotSpecified;
    if (edadIngreso != null && edadIngreso! > 0) {
      edadTexto = S.of(context).loteFormatDays(edadIngreso.toString());
      if (edadIngreso! >= 7) {
        final semanas = (edadIngreso! / 7).floor();
        final diasRestantes = edadIngreso! % 7;
        if (diasRestantes > 0) {
          edadTexto += S
              .of(context)
              .loteResumenWeeksDays(
                semanas.toString(),
                diasRestantes.toString(),
              );
        } else {
          edadTexto += S.of(context).loteResumenWeeksParens(semanas.toString());
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del paso
          Text(
            S.of(context).batchFormStepReview,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batchFormReviewSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Sección: Información Básica
          _buildSectionCard(
            context: context,
            theme: theme,
            title: S.of(context).batchFormStepBasicInfo,
            children: [
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormCode,
                codigo.isNotEmpty ? codigo : S.of(context).batchFormCodeHint,
              ),
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormBirdType,
                tipoAve != null
                    ? tipoAve!.localizedDisplayName(S.of(context))
                    : '-',
              ),
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormEntryDate,
                fechaIngreso != null
                    ? DateFormat('dd/MM/yyyy').format(fechaIngreso!)
                    : '-',
              ),
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormInitialCount,
                cantidadInicial != null
                    ? '${cantidadInicial!} ${S.of(context).batchBirdsLabel}'
                    : '-',
              ),
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormAgeAtEntry,
                edadTexto,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sección: Granja
          _buildSectionCard(
            context: context,
            theme: theme,
            title: S.of(context).batchFormFarm,
            children: [_buildGranjaInfo(context, ref, theme)],
          ),

          const SizedBox(height: 16),

          // Sección: Galpón
          _buildSectionCard(
            context: context,
            theme: theme,
            title: S.of(context).batchFormShed,
            children: [_buildGalponInfo(context, ref, theme)],
          ),

          if (observaciones.isNotEmpty) ...[
            const SizedBox(height: 16),

            // Sección: Observaciones
            _buildSectionCard(
              context: context,
              theme: theme,
              title: S.of(context).batchFormObservations,
              children: [
                Text(
                  observaciones,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, theme, title),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGranjaInfo(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final granjaAsync = ref.watch(granjaByIdProvider(granjaId));

    return granjaAsync.when(
      data: (granja) {
        if (granja == null) {
          return _buildInfoRow(
            context,
            theme,
            S.of(context).batchFormFarm,
            S.of(context).batchFormNotFound,
          );
        }

        // Construir ubicación completa
        final direccionParts = <String>[];
        if (granja.direccion.calle.isNotEmpty) {
          direccionParts.add(granja.direccion.calle);
        }
        if (granja.direccion.ciudad != null &&
            granja.direccion.ciudad!.isNotEmpty) {
          direccionParts.add(granja.direccion.ciudad!);
        }
        if (granja.direccion.departamento != null &&
            granja.direccion.departamento!.isNotEmpty) {
          direccionParts.add(granja.direccion.departamento!);
        }
        final ubicacionCompleta = direccionParts.isNotEmpty
            ? direccionParts.join(', ')
            : S.of(context).batchFormNotSpecified;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              theme,
              S.of(context).batchFormName,
              granja.nombre,
            ),
            _buildInfoRow(
              context,
              theme,
              S.of(context).batchFormLocation,
              ubicacionCompleta,
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => _buildInfoRow(
        context,
        theme,
        S.of(context).batchFormFarm,
        S.of(context).commonError,
      ),
    );
  }

  Widget _buildGalponInfo(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    if (galponId == null) {
      return _buildInfoRow(
        context,
        theme,
        S.of(context).batchFormShed,
        S.of(context).batchFormNotSelected,
      );
    }

    final galponAsync = ref.watch(galponByIdProvider(galponId!));

    return galponAsync.when(
      data: (galpon) {
        if (galpon == null) {
          return _buildInfoRow(
            context,
            theme,
            S.of(context).batchFormShed,
            S.of(context).batchFormNotFound,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              theme,
              S.of(context).batchFormName,
              galpon.nombre,
            ),
            _buildInfoRow(
              context,
              theme,
              S.of(context).batchFormCapacity,
              '${galpon.capacidadMaxima} ${S.of(context).batchBirdsLabel}',
            ),
            if (galpon.areaM2 != null)
              _buildInfoRow(
                context,
                theme,
                S.of(context).batchFormArea,
                '${galpon.areaM2} m²',
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => _buildInfoRow(
        context,
        theme,
        S.of(context).batchFormShed,
        S.of(context).commonError,
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    ThemeData theme,
    String title,
  ) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
