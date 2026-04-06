/// Widgets de skeleton loading para estados de carga
///
/// Proporciona skeletons consistentes para listas de:
/// - Granjas
/// - Galpones
/// - Ventas
/// - Costos
library;

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_loading.dart';

/// Skeleton genérico para tarjetas de lista
class SkeletonListCard extends StatelessWidget {
  const SkeletonListCard({
    super.key,
    this.hasIcon = true,
    this.hasSubtitle = true,
    this.hasBadge = true,
    this.hasFooter = true,
  });

  final bool hasIcon;
  final bool hasSubtitle;
  final bool hasBadge;
  final bool hasFooter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
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
                if (hasIcon) ...[
                  const ShimmerPlaceholder(
                    width: 42,
                    height: 42,
                    borderRadius: 10,
                  ),
                  AppSpacing.hGapMd,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerPlaceholder(width: 120, height: 14),
                      if (hasSubtitle) ...[
                        AppSpacing.gapXs,
                        const ShimmerPlaceholder(width: 80, height: 10),
                      ],
                    ],
                  ),
                ),
                if (hasBadge)
                  const ShimmerPlaceholder(
                    width: 60,
                    height: 24,
                    borderRadius: 12,
                  ),
              ],
            ),
            AppSpacing.gapBase,
            // Content
            const ShimmerPlaceholder(height: 12),
            AppSpacing.gapSm,
            const ShimmerPlaceholder(width: 200, height: 12),
            if (hasFooter) ...[
              AppSpacing.gapMd,
              const Row(
                children: [
                  ShimmerPlaceholder(width: 100, height: 10),
                  Spacer(),
                  ShimmerPlaceholder(width: 60, height: 24, borderRadius: 8),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton para resumen card (gradiente)
class SkeletonResumenCard extends StatelessWidget {
  const SkeletonResumenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: AppRadius.allLg,
      ),
      child: const ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                ShimmerPlaceholder(width: 44, height: 44, borderRadius: 12),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(width: 100, height: 12),
                      SizedBox(height: AppSpacing.xs),
                      ShimmerPlaceholder(width: 150, height: 16),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            // Stats row
            Row(
              children: [
                Expanded(
                  child: ShimmerPlaceholder(height: 70, borderRadius: 12),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ShimmerPlaceholder(height: 70, borderRadius: 12),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ShimmerPlaceholder(height: 70, borderRadius: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado de carga para listas con resumen
class ListLoadingState extends StatelessWidget {
  const ListLoadingState({
    super.key,
    this.showResumen = true,
    this.itemCount = 4,
    this.hasIcon = true,
    this.hasSubtitle = true,
    this.hasBadge = true,
    this.hasFooter = true,
  });

  final bool showResumen;
  final int itemCount;
  final bool hasIcon;
  final bool hasSubtitle;
  final bool hasBadge;
  final bool hasFooter;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        if (showResumen)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppSpacing.base, bottom: AppSpacing.sm),
              child: SkeletonResumenCard(),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.only(top: index == 0 ? AppSpacing.sm : 0, bottom: AppSpacing.md),
                child: SkeletonListCard(
                  hasIcon: hasIcon,
                  hasSubtitle: hasSubtitle,
                  hasBadge: hasBadge,
                  hasFooter: hasFooter,
                ),
              ),
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

/// Estado de carga para listas sin resumen (granjas, galpones)
class SimpleListLoadingState extends StatelessWidget {
  const SimpleListLoadingState({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.base),
      itemCount: itemCount,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.base),
        child: SkeletonListCard(
          hasIcon: true,
          hasSubtitle: true,
          hasBadge: true,
          hasFooter: true,
        ),
      ),
    );
  }
}

/// Sliver de skeleton para usar dentro de CustomScrollView
class SliverSkeletonList extends StatelessWidget {
  const SliverSkeletonList({
    super.key,
    this.itemCount = 5,
    this.hasIcon = true,
    this.hasSubtitle = true,
    this.hasBadge = true,
    this.hasFooter = true,
  });

  final int itemCount;
  final bool hasIcon;
  final bool hasSubtitle;
  final bool hasBadge;
  final bool hasFooter;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.base),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.base),
            child: SkeletonListCard(
              hasIcon: hasIcon,
              hasSubtitle: hasSubtitle,
              hasBadge: hasBadge,
              hasFooter: hasFooter,
            ),
          ),
          childCount: itemCount,
        ),
      ),
    );
  }
}
