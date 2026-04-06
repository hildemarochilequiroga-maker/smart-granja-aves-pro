import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/core/routes/app_routes.dart';
import 'package:smartgranjaavespro/core/theme/app_colors.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';
import 'package:smartgranjaavespro/core/theme/app_spacing.dart';
import 'package:smartgranjaavespro/core/widgets/app_snackbar.dart';

import '../../../../granjas/application/providers/granja_providers.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granjaActiva = ref.watch(granjaSeleccionadaProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          S.of(context).homeQuickActions,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        // First Row - Vacunación y Catálogo
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.vaccines_rounded,
                label: S.of(context).homeVaccination,
                color: AppColors.teal,
                onTap: () => context.push(AppRoutes.vacunaciones),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.coronavirus_rounded,
                label: S.of(context).homeDiseases,
                color: AppColors.deepPurple,
                onTap: () => context.push(AppRoutes.catalogoEnfermedades),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Second Row - Bioseguridad y Ventas
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.security_rounded,
                label: S.of(context).homeBiosecurity,
                color: AppColors.info,
                onTap: () {
                  if (granjaActiva != null) {
                    context.push(
                      AppRoutes.bioseguridadPorGranja(granjaActiva.id),
                    );
                  } else {
                    AppSnackBar.warning(
                      context,
                      message: S.of(context).homeSelectFarmFirst,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.point_of_sale_rounded,
                label: S.of(context).homeSales,
                color: AppColors.success,
                onTap: () => context.push(AppRoutes.ventas),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Third Row - Costos e Inventario
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.account_balance_wallet_rounded,
                label: S.of(context).homeCosts,
                color: AppColors.warning,
                onTap: () => context.push(AppRoutes.costos),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.inventory_2_rounded,
                label: S.of(context).homeInventory,
                color: AppColors.purple,
                onTap: () => context.push(AppRoutes.inventario),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Fourth Row - Reportes
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.bar_chart_rounded,
                label: S.of(context).reportsTitle,
                color: AppColors.indigo,
                onTap: () => context.push(AppRoutes.reportes),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.local_hospital_rounded,
                label: S.of(context).homeHealth,
                color: AppColors.error,
                onTap: () {
                  if (granjaActiva != null) {
                    context.push(
                      '${AppRoutes.salud}?granjaId=${granjaActiva.id}',
                    );
                  } else {
                    context.push(AppRoutes.salud);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: AppRadius.allMd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 28),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
