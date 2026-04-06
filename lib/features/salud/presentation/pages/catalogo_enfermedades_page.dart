/// Página del catálogo de enfermedades avícolas.
///
/// Muestra todas las enfermedades registradas con:
/// - Barra de búsqueda sticky
/// - Filtros por categoría y gravedad
/// - Cards modernas con imágenes
/// - Diseño similar a granjas_list_page
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../application/providers/catalogo_enfermedades_provider.dart';
import '../../domain/enums/enums.dart';

/// Página principal del catálogo de enfermedades avícolas.
class CatalogoEnfermedadesPage extends ConsumerStatefulWidget {
  const CatalogoEnfermedadesPage({super.key});

  @override
  ConsumerState<CatalogoEnfermedadesPage> createState() =>
      _CatalogoEnfermedadesPageState();
}

class _CatalogoEnfermedadesPageState
    extends ConsumerState<CatalogoEnfermedadesPage> {
  S get l => S.of(context);

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  CategoriaEnfermedad? _categoriaFilter;
  GravedadEnfermedad? _gravedadFilter;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enfermedades = ref.watch(catalogoEnfermedadesProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).diseaseCatalogTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          unawaited(HapticFeedback.mediumImpact());
        },
        color: theme.colorScheme.primary,
        edgeOffset: 130,
        child: CustomScrollView(
          slivers: [
            // Barra de búsqueda sticky
            SliverPersistentHeader(
              pinned: true,
              delegate: _EnfermedadesSearchBarDelegate(
                searchController: _searchController,
                searchQuery: _searchQuery,
                categoriaFilter: _categoriaFilter,
                gravedadFilter: _gravedadFilter,
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                onClearSearch: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  setState(() => _searchQuery = '');
                },
                onCategoriaFilterChanged: (categoria) {
                  HapticFeedback.selectionClick();
                  setState(() => _categoriaFilter = categoria);
                },
                onGravedadFilterChanged: (gravedad) {
                  HapticFeedback.selectionClick();
                  setState(() => _gravedadFilter = gravedad);
                },
              ),
            ),

            // Contenido principal
            Builder(
              builder: (context) {
                final filteredEnfermedades = _filterEnfermedades(enfermedades);

                if (filteredEnfermedades.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(
                      hasFilters:
                          _searchQuery.isNotEmpty ||
                          _categoriaFilter != null ||
                          _gravedadFilter != null,
                      onClearFilters: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _categoriaFilter = null;
                          _gravedadFilter = null;
                        });
                      },
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final enfermedad = filteredEnfermedades[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredEnfermedades.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? 16 : 0,
                          bottom: isLast ? 16 : 12,
                        ),
                        child: _EnfermedadCard(
                          enfermedad: enfermedad,
                          onTap: () => _navegarADetalle(enfermedad),
                        ),
                      );
                    }, childCount: filteredEnfermedades.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<EnfermedadAvicola> _filterEnfermedades(
    List<EnfermedadAvicola> enfermedades,
  ) {
    return enfermedades.where((enfermedad) {
      // Filtro por búsqueda
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesNombre = enfermedad.nombreComun.toLowerCase().contains(
          query,
        );
        final matchesCientifico = enfermedad.nombreCientifico
            .toLowerCase()
            .contains(query);
        final matchesAgente = enfermedad.agenteCausal.toLowerCase().contains(
          query,
        );
        final matchesSintomas = enfermedad.sintomasPrincipales.any(
          (s) => s.toLowerCase().contains(query),
        );

        if (!matchesNombre &&
            !matchesCientifico &&
            !matchesAgente &&
            !matchesSintomas) {
          return false;
        }
      }

      // Filtro por categoría
      if (_categoriaFilter != null &&
          enfermedad.categoria != _categoriaFilter) {
        return false;
      }

      // Filtro por gravedad
      if (_gravedadFilter != null && enfermedad.gravedad != _gravedadFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  void _navegarADetalle(EnfermedadAvicola enfermedad) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleEnfermedadPage(enfermedad: enfermedad),
      ),
    );
  }
}

/// Delegate para la barra de búsqueda sticky
class _EnfermedadesSearchBarDelegate extends SliverPersistentHeaderDelegate {
  const _EnfermedadesSearchBarDelegate({
    required this.searchController,
    required this.searchQuery,
    required this.categoriaFilter,
    required this.gravedadFilter,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onCategoriaFilterChanged,
    required this.onGravedadFilterChanged,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final CategoriaEnfermedad? categoriaFilter;
  final GravedadEnfermedad? gravedadFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<CategoriaEnfermedad?> onCategoriaFilterChanged;
  final ValueChanged<GravedadEnfermedad?> onGravedadFilterChanged;

  @override
  double get minExtent => 110;

  @override
  double get maxExtent => 110;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      alignment: Alignment.topCenter,
      child: AppSearchBar(
        controller: searchController,
        searchQuery: searchQuery,
        hintText: S.of(context).diseaseCatalogSearch,
        onSearchChanged: onSearchChanged,
        onClearSearch: onClearSearch,
        filterBuilder: (theme) => AppFilterTabRow(
          tabs: [
            AppFilterTab(
              label: S.of(context).diseaseCatalogAll,
              isSelected: gravedadFilter == null,
              onTap: () => onGravedadFilterChanged(null),
            ),
            AppFilterTab(
              label: S.of(context).diseaseCatalogCritical,
              isSelected: gravedadFilter == GravedadEnfermedad.critica,
              color: AppColors.purple,
              onTap: () => onGravedadFilterChanged(
                gravedadFilter == GravedadEnfermedad.critica
                    ? null
                    : GravedadEnfermedad.critica,
              ),
            ),
            AppFilterTab(
              label: S.of(context).diseaseCatalogSevere,
              isSelected: gravedadFilter == GravedadEnfermedad.grave,
              color: AppColors.error,
              onTap: () => onGravedadFilterChanged(
                gravedadFilter == GravedadEnfermedad.grave
                    ? null
                    : GravedadEnfermedad.grave,
              ),
            ),
            AppFilterTab(
              label: S.of(context).diseaseCatalogModerate,
              isSelected: gravedadFilter == GravedadEnfermedad.moderada,
              color: AppColors.warning,
              onTap: () => onGravedadFilterChanged(
                gravedadFilter == GravedadEnfermedad.moderada
                    ? null
                    : GravedadEnfermedad.moderada,
              ),
            ),
            AppFilterTab(
              label: S.of(context).diseaseCatalogMild,
              isSelected: gravedadFilter == GravedadEnfermedad.leve,
              color: AppColors.success,
              onTap: () => onGravedadFilterChanged(
                gravedadFilter == GravedadEnfermedad.leve
                    ? null
                    : GravedadEnfermedad.leve,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_EnfermedadesSearchBarDelegate oldDelegate) {
    return searchQuery != oldDelegate.searchQuery ||
        categoriaFilter != oldDelegate.categoriaFilter ||
        gravedadFilter != oldDelegate.gravedadFilter;
  }
}

/// Card de enfermedad con diseño moderno (estilo LoteListCard)
class _EnfermedadCard extends StatelessWidget {
  const _EnfermedadCard({required this.enfermedad, required this.onTap});

  final EnfermedadAvicola enfermedad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gravedadColor = Color(
      int.parse(enfermedad.gravedad.colorHex.replaceFirst('#', '0xFF')),
    );
    final categoriaColor = _getCategoriaColor(enfermedad.categoria);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.allMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allMd,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Nombre + Badge de gravedad
                _buildHeader(theme, gravedadColor, isSmallScreen),
                AppSpacing.gapBase,

                // Sección de imagen/icono
                _buildImageSection(context, theme, categoriaColor, size.width),
                AppSpacing.gapBase,

                // Botón de acción
                _buildActionButton(context, theme),
              ],
            ),
          ),
        ),
      ),
    ).cardEntrance();
  }

  Widget _buildHeader(
    ThemeData theme,
    Color gravedadColor,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // Nombre común
            Expanded(
              child: Text(
                enfermedad.nombreComun,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.hGapSm,
            // Badge de gravedad
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 12,
                vertical: isSmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: gravedadColor,
                borderRadius: AppRadius.allSm,
              ),
              child: Text(
                enfermedad.gravedad.displayName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallScreen ? 10 : 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        AppSpacing.gapXxs,
        // Nombre científico y agente
        Text(
          '${enfermedad.nombreCientifico} • ${enfermedad.agenteCausal}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ThemeData theme,
    Color categoriaColor,
    double screenWidth,
  ) {
    // Altura responsive similar a lotes
    final imageHeight = (screenWidth * 0.35).clamp(140.0, 180.0);

    return Column(
      children: [
        // Contenedor con icono grande
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoriaColor.withValues(alpha: 0.15),
                categoriaColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: AppRadius.allSm,
          ),
          child: Stack(
            children: [
              // Icono de categoría grande
              Center(
                child: Icon(
                  _getCategoriaIcon(enfermedad.categoria),
                  size: imageHeight * 0.5,
                  color: categoriaColor.withValues(alpha: 0.4),
                ),
              ),
              // Badge de notificación obligatoria
              if (enfermedad.esNotificacionObligatoria)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      S.of(context).catalogDiseaseNotifRequired,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              // Badge de vacunable
              if (enfermedad.esPreveniblePorVacuna)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      S.of(context).catalogDiseaseVaccinable,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        AppSpacing.gapMd,
        // Estadísticas debajo de la imagen
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              enfermedad.categoria.displayName,
              S.of(context).commonCategory,
              _getCategoriaIcon(enfermedad.categoria),
              categoriaColor,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${enfermedad.sintomasPrincipales.length}',
              S.of(context).catalogDiseaseSymptoms,
              Icons.medical_information_outlined,
              AppColors.warning,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              enfermedad.gravedad.displayName,
              S.of(context).catalogDiseaseSeverity,
              Icons.warning_amber_rounded,
              Color(
                int.parse(
                  enfermedad.gravedad.colorHex.replaceFirst('#', '0xFF'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapXxxs,
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          elevation: 0,
        ),
        child: Text(
          S.of(context).catalogDiseaseViewDetails,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getCategoriaColor(CategoriaEnfermedad categoria) {
    switch (categoria) {
      case CategoriaEnfermedad.viral:
        return AppColors.error;
      case CategoriaEnfermedad.bacteriana:
        return AppColors.info;
      case CategoriaEnfermedad.parasitaria:
        return AppColors.purple;
      case CategoriaEnfermedad.fungica:
        return AppColors.teal;
      case CategoriaEnfermedad.nutricional:
        return AppColors.warning;
      case CategoriaEnfermedad.metabolica:
        return AppColors.amber;
      case CategoriaEnfermedad.ambiental:
        return AppColors.cyan;
    }
  }

  IconData _getCategoriaIcon(CategoriaEnfermedad categoria) {
    switch (categoria) {
      case CategoriaEnfermedad.viral:
        return Icons.coronavirus;
      case CategoriaEnfermedad.bacteriana:
        return Icons.bug_report;
      case CategoriaEnfermedad.parasitaria:
        return Icons.pest_control;
      case CategoriaEnfermedad.fungica:
        return Icons.grass;
      case CategoriaEnfermedad.nutricional:
        return Icons.restaurant;
      case CategoriaEnfermedad.metabolica:
        return Icons.science;
      case CategoriaEnfermedad.ambiental:
        return Icons.thermostat;
    }
  }
}

/// Estado vacío
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClearFilters});

  final bool hasFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off_rounded : Icons.menu_book_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            AppSpacing.gapBase,
            Text(
              hasFilters
                  ? S.of(context).catalogDiseaseNotFound
                  : S.of(context).catalogDiseaseEmpty,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              hasFilters
                  ? S.of(context).catalogDiseaseSearchHint
                  : S.of(context).catalogDiseaseNone,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              AppSpacing.gapXl,
              FilledButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: Text(S.of(context).diseaseCatalogClearFilters),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Página de detalle de una enfermedad.
class DetalleEnfermedadPage extends StatelessWidget {
  const DetalleEnfermedadPage({super.key, required this.enfermedad});

  final EnfermedadAvicola enfermedad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gravedadColor = Color(
      int.parse(enfermedad.gravedad.colorHex.replaceFirst('#', '0xFF')),
    );
    final categoriaColor = _getCategoriaColor(enfermedad.categoria);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(enfermedad.nombreComun),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y gravedad
            _buildHeaderCard(context, theme, gravedadColor, categoriaColor),
            AppSpacing.gapBase,

            // Badges de alerta
            if (enfermedad.esNotificacionObligatoria ||
                enfermedad.esPreveniblePorVacuna) ...[
              _buildAlertBadges(context, theme),
              AppSpacing.gapBase,
            ],

            // Información General - tabla
            _buildSectionTitle(theme, S.of(context).catalogDiseaseInfoGeneral),
            _buildInfoTable(context, theme, categoriaColor, gravedadColor),
            AppSpacing.gapBase,

            // Transmisión y Diagnóstico - tabla
            _buildSectionTitle(theme, S.of(context).catalogDiseaseTransDiag),
            _buildDiagnosticoTable(context, theme),
            AppSpacing.gapBase,

            // Síntomas Principales
            _buildSectionTitle(theme, S.of(context).catalogDiseaseMainSymptoms),
            _buildNumberedListCard(
              theme,
              enfermedad.sintomasPrincipales,
              AppColors.warning,
            ),
            AppSpacing.gapBase,

            // Lesiones Post-mortem (solo si hay)
            if (enfermedad.lesionesPostmortem.isNotEmpty) ...[
              _buildSectionTitle(theme, S.of(context).catalogDiseasePostmortem),
              _buildBulletListCard(
                theme,
                enfermedad.lesionesPostmortem,
                theme.colorScheme.error,
              ),
              AppSpacing.gapBase,
            ],

            // Tratamiento y Prevención
            _buildSectionTitle(theme, S.of(context).catalogDiseaseTreatPrev),
            _buildCheckListCard(theme, enfermedad.displayTratamientos),

            // Vacuna disponible
            if (enfermedad.esPreveniblePorVacuna) ...[
              AppSpacing.gapBase,
              _buildVacunaCard(context, theme),
            ],

            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ThemeData theme,
    Color gravedadColor,
    Color categoriaColor,
  ) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: categoriaColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: categoriaColor.withValues(alpha: 0.4),
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
                        enfermedad.nombreComun,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.gapXxxs,
                      Text(
                        enfermedad.nombreCientifico,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gravedadColor,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    enfermedad.gravedad.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapBase,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: categoriaColor.withValues(alpha: 0.08),
                borderRadius: AppRadius.allMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).catalogDiseaseCausalAgent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      enfermedad.agenteCausal,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: categoriaColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBadges(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        if (enfermedad.esNotificacionObligatoria)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: AppRadius.allSm,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Text(
              S.of(context).catalogDiseaseNotifOblig,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (enfermedad.esNotificacionObligatoria &&
            enfermedad.esPreveniblePorVacuna)
          AppSpacing.gapSm,
        if (enfermedad.esPreveniblePorVacuna)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              S.of(context).catalogDiseaseVaccinePrevent,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildTableRow(
    ThemeData theme,
    String label,
    String value, {
    bool isLast = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTable(
    BuildContext context,
    ThemeData theme,
    Color categoriaColor,
    Color gravedadColor,
  ) {
    final l = S.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTableRow(
            theme,
            l.commonCategory,
            enfermedad.categoria.displayName,
            valueColor: categoriaColor,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseSeverity,
            enfermedad.gravedad.displayName,
            valueColor: gravedadColor,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseCausalAgent,
            enfermedad.agenteCausal,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseContagious,
            enfermedad.esContagiosa ? l.commonYes : l.commonNo,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseNotification,
            enfermedad.esNotificacionObligatoria ? l.commonYes : l.commonNo,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseVaccineAvail,
            enfermedad.esPreveniblePorVacuna ? l.commonYes : l.commonNo,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticoTable(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTableRow(
            theme,
            l.catalogDiseaseTransmission,
            enfermedad.transmision,
          ),
          _buildTableRow(
            theme,
            l.catalogDiseaseDiagnosis,
            enfermedad.diagnostico,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedListCard(
    ThemeData theme,
    List<String> items,
    Color accentColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: AppRadius.allXs,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        items[index],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBulletListCard(
    ThemeData theme,
    List<String> items,
    Color dotColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      AppSpacing.hGapMd,
                      Expanded(
                        child: Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCheckListCard(ThemeData theme, List<String> items) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outlined,
                        color: AppColors.success,
                        size: 20,
                      ),
                      AppSpacing.hGapMd,
                      Expanded(
                        child: Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildVacunaCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: AppColors.success.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allMd,
          side: BorderSide(color: AppColors.success.withValues(alpha: 0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l.catalogDiseaseVaccineAvail,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.successDark,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapSm,
              Text(
                enfermedad.vacuna ?? l.catalogDiseaseConsultVet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoriaColor(CategoriaEnfermedad categoria) {
    switch (categoria) {
      case CategoriaEnfermedad.viral:
        return AppColors.error;
      case CategoriaEnfermedad.bacteriana:
        return AppColors.info;
      case CategoriaEnfermedad.parasitaria:
        return AppColors.purple;
      case CategoriaEnfermedad.fungica:
        return AppColors.teal;
      case CategoriaEnfermedad.nutricional:
        return AppColors.warning;
      case CategoriaEnfermedad.metabolica:
        return AppColors.amber;
      case CategoriaEnfermedad.ambiental:
        return AppColors.cyan;
    }
  }
}
