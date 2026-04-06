/// Página de detalle de un galpón específico.
///
/// Muestra información completa del galpón con diseño moderno:
/// - AppBar básico con acciones
/// - Secciones organizadas con cards
/// - Navegación intuitiva a lotes
/// - Acciones rápidas accesibles
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/application.dart';
import '../../domain/entities/galpon.dart';
import '../widgets/galpon_form_widgets.dart';
import '../widgets/galpon_detail/galpon_detail.dart';

/// Página de detalle de galpón.
class GalponDetailPage extends ConsumerWidget {
  const GalponDetailPage({
    super.key,
    required this.granjaId,
    required this.galponId,
  });

  final String granjaId;
  final String galponId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final galponAsync = ref.watch(galponByIdProvider(galponId));

    return galponAsync.when(
      data: (galpon) {
        if (galpon == null) {
          return _buildNotFoundView(context, theme);
        }
        return _GalponDetailView(galpon: galpon, granjaId: granjaId);
      },
      loading: () => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).commonError)),
        body: GalponErrorWidget(
          mensaje: error.toString(),
          onReintentar: () => ref.invalidate(galponByIdProvider(galponId)),
        ),
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context, ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(S.of(context).shedNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.base),
            Text(S.of(context).shedNotFound, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: () => context.pop(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                ),
                child: Text(S.of(context).commonBack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista principal del detalle de galpón.
class _GalponDetailView extends ConsumerWidget {
  const _GalponDetailView({required this.galpon, required this.granjaId});

  final Galpon galpon;
  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).shedDetails),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push(AppRoutes.galponEditarById(granjaId, galpon.id)),
            tooltip: S.of(context).shedEditTooltip,
          ),
          _buildMenuButton(context, ref, theme),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y estado
            GalponHeader(galpon: galpon),

            const SizedBox(height: AppSpacing.xl),

            // Título Información General
            GalponSectionTitle(title: S.of(context).shedGeneralInfo),
            const SizedBox(height: AppSpacing.md),

            // Información General
            GalponInformacionGeneral(galpon: galpon),

            // Infraestructura (si existe)
            if (_tieneInfraestructura(galpon)) ...[
              const SizedBox(height: AppSpacing.xl),
              GalponSectionTitle(title: S.of(context).shedInfrastructure),
              const SizedBox(height: AppSpacing.md),
              GalponInfraestructuraSection(galpon: galpon),
            ],

            // Sensores (si existe alguno)
            if (_tieneSensores(galpon)) ...[
              const SizedBox(height: AppSpacing.xl),
              GalponSectionTitle(title: S.of(context).shedSensorsEquipment),
              const SizedBox(height: AppSpacing.md),
              GalponSensoresSection(galpon: galpon),
            ],

            // Chips de desinfección y mantenimiento
            if (galpon.ultimaDesinfeccion != null ||
                galpon.proximoMantenimiento != null) ...[
              const SizedBox(height: AppSpacing.xl),
              GalponSectionTitle(title: S.of(context).commonMaintenance),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (galpon.ultimaDesinfeccion != null)
                    GalponDesinfeccionChip(galpon: galpon),
                  if (galpon.proximoMantenimiento != null)
                    GalponMantenimientoChip(galpon: galpon),
                ],
              ),
            ],

            // Descripción/Notas (si existe)
            if (galpon.descripcion != null &&
                galpon.descripcion!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              GalponSectionTitle(title: S.of(context).commonNotes),
              const SizedBox(height: AppSpacing.md),
              GalponDescripcionSection(galpon: galpon),
            ],

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  bool _tieneInfraestructura(Galpon galpon) {
    return galpon.numeroCorrales != null ||
        galpon.sistemaBebederos != null ||
        galpon.sistemaComederos != null ||
        galpon.sistemaVentilacion != null ||
        galpon.sistemaCalefaccion != null ||
        galpon.sistemaIluminacion != null;
  }

  bool _tieneSensores(Galpon galpon) {
    return galpon.tieneBalanza ||
        galpon.sensorTemperatura ||
        galpon.sensorHumedad ||
        galpon.sensorCO2 ||
        galpon.sensorAmoniaco;
  }

  Widget _buildMenuButton(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
      color: theme.colorScheme.surface,
      elevation: 3,
      offset: const Offset(0, 40),
      tooltip: S.of(context).commonMoreOptions,
      onSelected: (value) => GalponDetailHandlers.handleMenuAction(
        context,
        ref,
        galpon,
        granjaId,
        value,
      ),
      itemBuilder: (context) => _buildMenuItems(context, theme),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(
    BuildContext context,
    ThemeData theme,
  ) {
    return [
      PopupMenuItem(
        value: 'cambiar_estado',
        height: 44,
        child: Text(
          S.of(context).shedChangeStatus,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const PopupMenuDivider(height: 8),
      PopupMenuItem(
        value: 'eliminar',
        height: 44,
        child: Text(
          S.of(context).commonDelete,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
  }
}
