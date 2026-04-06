/// Widget de shimmer loading para estados de carga de Salud
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';
import 'package:smartgranjaavespro/core/theme/app_spacing.dart';
import 'package:smartgranjaavespro/core/widgets/app_loading.dart';

/// Skeleton para una tarjeta de lista
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Icon placeholder
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: AppRadius.allMd,
                  ),
                ),
                AppSpacing.hGapMd,
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                      AppSpacing.gapXs,
                      Container(
                        width: 80,
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge placeholder
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: AppRadius.allMd,
                  ),
                ),
              ],
            ),
            AppSpacing.gapBase,
            // Content lines
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: AppRadius.allXs,
              ),
            ),
            AppSpacing.gapSm,
            Container(
              width: 200,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: AppRadius.allXs,
              ),
            ),
            AppSpacing.gapMd,
            // Footer row
            Row(
              children: [
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: AppRadius.allXs,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: AppRadius.allSm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton para el resumen de salud
class SkeletonResumenCard extends StatelessWidget {
  const SkeletonResumenCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant,
        borderRadius: AppRadius.allLg,
      ),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: AppRadius.allMd,
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                      AppSpacing.gapXs,
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: AppRadius.allXs,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            // Stats row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: AppRadius.allMd,
                    ),
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: AppRadius.allMd,
                    ),
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: AppRadius.allMd,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que muestra el estado de carga completo de la lista
class SaludLoadingState extends StatelessWidget {
  const SaludLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Skeleton del resumen
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: SkeletonResumenCard(),
          ),
        ),
        // Skeleton de las tarjetas
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: SkeletonCard(),
              ),
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget que muestra el estado de carga completo de vacunaciones
class VacunacionLoadingState extends StatelessWidget {
  const VacunacionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Skeleton del resumen
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: SkeletonResumenCard(),
          ),
        ),
        // Skeleton de las tarjetas
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: SkeletonCard(),
              ),
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}
