/// Dashboard completo de lote con registros e historiales.
///
/// Pantalla principal que integra toda la información del lote:
/// - KPIs principales
/// - Gráficos de rendimiento
/// - Registros recientes
/// - Acciones rápidas
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/enums.dart';
import '../widgets/dashboard/mortalidad_tab_widget.dart';
import '../widgets/dashboard/peso_tab_widget.dart';
import '../widgets/dashboard/consumo_tab_widget.dart';
import '../widgets/dashboard/produccion_tab_widget.dart';
import 'historial_mortalidad_page.dart';
import 'historial_peso_page.dart';
import 'historial_consumo_page.dart';
import 'historial_produccion_page.dart';

/// Dashboard completo del lote.
class LoteDashboardPage extends ConsumerWidget {
  const LoteDashboardPage({
    super.key,
    required this.granjaId,
    required this.loteId,
  });

  final String granjaId;
  final String loteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loteAsync = ref.watch(loteByIdProvider(loteId));

    return loteAsync.when(
      data: (lote) {
        if (lote == null) {
          return _buildNotFoundView(context);
        }
        return _LoteDashboardView(lote: lote, granjaId: granjaId);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).commonError)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.base),
              Text(S.of(context).commonErrorWithDetail(error.toString())),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => ref.invalidate(loteByIdProvider(loteId)),
                icon: const Icon(Icons.refresh),
                label: Text(S.of(context).commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).batchNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.base),
            Text(S.of(context).batchNotFound, style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(S.of(context).commonBack),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== VISTA PRINCIPAL ====================

class _LoteDashboardView extends ConsumerStatefulWidget {
  const _LoteDashboardView({required this.lote, required this.granjaId});

  final Lote lote;
  final String granjaId;

  @override
  ConsumerState<_LoteDashboardView> createState() => _LoteDashboardViewState();
}

class _LoteDashboardViewState extends ConsumerState<_LoteDashboardView> {
  int _currentIndex = 2; // Inicio en Dashboard (centro)

  // GlobalKeys para acceder al estado de los historiales
  final GlobalKey<HistorialMortalidadPageState> _mortalidadKey = GlobalKey();
  final GlobalKey<HistorialPesoPageState> _pesoKey = GlobalKey();
  final GlobalKey<HistorialConsumoPageState> _consumoKey = GlobalKey();
  final GlobalKey<HistorialProduccionPageState> _produccionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color appBarForeground;
    switch (_currentIndex) {
      case 2: // Dashboard — primary (amarillo), texto oscuro
        appBarForeground = colorScheme.onSurface;
      default: // Mortalidad, Peso, Consumo, Producción — fondo de color, texto blanco
        appBarForeground = AppColors.white;
    }
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: _getAppBarColor(),
        elevation: 0,
        foregroundColor: appBarForeground,
        iconTheme: IconThemeData(color: appBarForeground),
        title: Text(
          _getAppBarTitle(),
          style: AppTextStyles.titleMedium.copyWith(
            color: appBarForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: _buildAppBarActions(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0: Mortalidad
          MortalidadTabWidget(lote: widget.lote, pageKey: _mortalidadKey),
          // 1: Peso
          PesoTabWidget(lote: widget.lote, pageKey: _pesoKey),
          // 2: Dashboard (Centro)
          _buildDashboardView(),
          // 3: Consumo
          ConsumoTabWidget(lote: widget.lote, pageKey: _consumoKey),
          // 4: Producción (solo aves de postura)
          if (widget.lote.tipoAve.esPostura)
            ProduccionTabWidget(lote: widget.lote, pageKey: _produccionKey),
        ],
      ),
      bottomNavigationBar: _DashboardNavigationBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        showProduccion: widget.lote.tipoAve.esPostura,
      ),
      floatingActionButton: widget.lote.estaActivo && _currentIndex != 2
          ? _buildFAB()
          : null,
    );
  }

  Widget _buildDashboardView() {
    final theme = Theme.of(context);
    final cantidadActual = widget.lote.avesDisponibles;
    final mortalidadTotal = widget.lote.mortalidadAcumulada;
    final tasaMortalidad =
        (mortalidadTotal / widget.lote.cantidadInicial * 100);
    final edad = widget.lote.edadActualDias;

    // Calcular métricas adicionales
    final ica = widget.lote.indiceConversionAlimenticia;
    final gananciaDiaria = widget.lote.gananciaPesoPromedioDiariaGramos;
    final totalBajas =
        widget.lote.mortalidadAcumulada +
        widget.lote.descartesAcumulados +
        widget.lote.ventasAcumuladas;

    // Detectar alertas
    final alertas = _buildAlertas();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(loteByIdProvider(widget.lote.id));
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        children: [
          // ================================================================
          // CARD PRINCIPAL - Información General del Lote
          // ================================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.allMd,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header con tipo de ave y estado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lote.tipoAve.localizedDisplayName(
                                  S.of(context),
                                ),
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.onPrimary.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                '${_formatEdad(edad)} (${S.of(context).batchAgeDaysValue(edad.toString())})',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
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
                            color: _getEstadoColor(widget.lote.estado),
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Text(
                            widget.lote.estado.localizedDisplayName(
                              S.of(context),
                            ),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Barra de progreso del ciclo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).loteProgressCycle,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${(edad / 45 * 100).clamp(0, 100).toStringAsFixed(0)}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ClipRRect(
                          borderRadius: AppRadius.allXs,
                          child: LinearProgressIndicator(
                            value: (edad / 45).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: AppColors.info.withValues(
                              alpha: 0.15,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              edad >= 45 ? AppColors.warning : AppColors.info,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          edad < 45
                              ? S
                                    .of(context)
                                    .loteDayOfCycle(
                                      edad.toString(),
                                      (45 - edad).toString(),
                                    )
                              : edad == 45
                              ? S.of(context).loteCycleCompleted
                              : S
                                    .of(context)
                                    .loteExtraDays(
                                      edad.toString(),
                                      (edad - 45).toString(),
                                    ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: edad > 45
                                ? AppColors.warning
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Divider(color: theme.colorScheme.outlineVariant, height: 1),

                  // Stats de aves: Ingreso, Vivas, Bajas
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoColumnSimple(
                            theme,
                            label: S.of(context).batchEntryLabel,
                            value: DateFormat(
                              'dd/MM/yy',
                            ).format(widget.lote.fechaIngreso),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        Expanded(
                          child: _buildInfoColumnSimple(
                            theme,
                            label: S.of(context).batchLiveBirds,
                            value: '$cantidadActual',
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        Expanded(
                          child: _buildInfoColumnSimple(
                            theme,
                            label: S.of(context).batchTotalLosses,
                            value: '$totalBajas',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================================================================
          // SECCIÓN DE ALERTAS (si hay)
          // ================================================================
          if (alertas.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: AppRadius.allMd,
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          S.of(context).loteAttention,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...alertas.map(
                      (alerta) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                alerta,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ================================================================
          // BOTÓN GUÍAS DE MANEJO
          // ================================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Card(
              elevation: 2,
              shadowColor: AppColors.amber.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allMd,
                side: const BorderSide(color: AppColors.amber, width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(
                  AppRoutes.loteGuiasManejoById(
                    widget.granjaId,
                    widget.lote.id,
                  ),
                  extra: widget.lote,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).guiasManejoBotonLabel,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              S.of(context).guiasManejoSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ================================================================
          // BOTÓN VETERINARIO VIRTUAL IA
          // ================================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Card(
              elevation: 2,
              shadowColor: Colors.teal.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allMd,
                side: const BorderSide(color: Colors.teal, width: 1.2),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(
                  AppRoutes.veterinarioVirtual,
                  extra: widget.lote,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).vetVirtualBotonLabel,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              S.of(context).vetVirtualSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ================================================================
          // TÍTULO DE KPIs
          // ================================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              S.of(context).loteKeyIndicators,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // ================================================================
          // KPIs - UNA POR FILA (sin iconos, estructura clara)
          // ================================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Mortalidad
                _buildKPICard(
                  theme: theme,
                  title: S.of(context).mortalityTitle,
                  mainValue: '${tasaMortalidad.toStringAsFixed(1)}%',
                  mainLabel: S.of(context).batchInitialFlock,
                  secondaryValue: '$mortalidadTotal',
                  secondaryLabel: S.of(context).batchBirdsLost,
                  referenceValue:
                      '${widget.lote.tipoAve.mortalidadEsperada.toStringAsFixed(0)}%',
                  referenceLabel: S.of(context).batchExpected,
                  accentColor: AppColors.error,
                  status: _getMortalidadTrend(tasaMortalidad),
                  statusColor: _getMortalidadTrendColor(tasaMortalidad),
                  isAlert:
                      tasaMortalidad > widget.lote.tipoAve.mortalidadEsperada,
                ),
                const SizedBox(height: AppSpacing.md),

                // Peso Promedio
                _buildKPICard(
                  theme: theme,
                  title: S.of(context).batchAvgWeight,
                  mainValue: widget.lote.pesoPromedioActual != null
                      ? '${(widget.lote.pesoPromedioActual! * 1000).toStringAsFixed(0)} g'
                      : '-- g',
                  mainLabel: S.of(context).batchCurrentWeight,
                  secondaryValue: gananciaDiaria != null
                      ? '${gananciaDiaria.toStringAsFixed(1)} g'
                      : '-- g',
                  secondaryLabel: S.of(context).batchDailyGain,
                  referenceValue:
                      '${(widget.lote.pesoPromedioObjetivo ?? widget.lote.tipoAve.pesoPromedioVenta * 1000).toStringAsFixed(0)} g',
                  referenceLabel: S.of(context).batchGoal,
                  accentColor: AppColors.warning,
                  status: _getPesoTrend(),
                  statusColor: _getPesoTrendColor(),
                ),
                const SizedBox(height: AppSpacing.md),

                // Consumo de Alimento
                _buildKPICard(
                  theme: theme,
                  title: S.of(context).batchFeedConsumption,
                  mainValue: widget.lote.consumoAcumuladoKg != null
                      ? '${widget.lote.consumoAcumuladoKg!.toStringAsFixed(1)} kg'
                      : '-- kg',
                  mainLabel: S.of(context).batchTotalAccumulated,
                  secondaryValue:
                      widget.lote.consumoAcumuladoKg != null &&
                          cantidadActual > 0
                      ? '${(widget.lote.consumoAcumuladoKg! / cantidadActual * 1000).toStringAsFixed(0)} g'
                      : '-- g',
                  secondaryLabel: S.of(context).batchPerBird,
                  referenceValue:
                      '${widget.lote.tipoAve.consumoDiarioEsperadoG.toStringAsFixed(0)} g',
                  referenceLabel: S.of(context).batchDailyExpectedPerBird,
                  accentColor: AppColors.success,
                  status: _getConsumoTrend(cantidadActual),
                  statusColor: _getConsumoTrendColor(cantidadActual),
                ),
                const SizedBox(height: AppSpacing.md),

                // Conversión Alimenticia (ICA)
                _buildKPICard(
                  theme: theme,
                  title: S.of(context).batchFeedConversionICA,
                  mainValue: ica != null ? ica.toStringAsFixed(2) : '--',
                  mainLabel: S.of(context).batchCurrentIndex,
                  secondaryValue: S.of(context).loteFeedKg,
                  secondaryLabel: S.of(context).batchPerKgWeight,
                  referenceValue: '1.6 - 1.8',
                  referenceLabel: S.of(context).batchOptimalRange,
                  accentColor: AppColors.deepPurple,
                  status: _getICATrend(ica),
                  statusColor: _getICATrendColor(ica),
                ),

                // Producción de huevos (solo para postura)
                if (widget.lote.tipoAve.esPostura) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildKPICard(
                    theme: theme,
                    title: S.of(context).batchEggProduction,
                    mainValue: '${widget.lote.huevosProducidos ?? 0}',
                    mainLabel: S.of(context).batchTotalEggs,
                    secondaryValue: cantidadActual > 0
                        ? ((widget.lote.huevosProducidos ?? 0) / cantidadActual)
                              .toStringAsFixed(1)
                        : '--',
                    secondaryLabel: S.of(context).batchEggsPerBird,
                    referenceValue:
                        '${widget.lote.tipoAve.posturaEsperada.toStringAsFixed(0)}%',
                    referenceLabel: S.of(context).batchExpectedLaying,
                    accentColor: AppColors.info,
                    status: _getProduccionTrend(cantidadActual),
                    statusColor: _getProduccionTrendColor(cantidadActual),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  // ==================== HELPERS PARA DASHBOARD ====================

  /// Construye la columna de información simple (sin icono)
  Widget _buildInfoColumnSimple(
    ThemeData theme, {
    required String label,
    required String value,
    String? subtitle,
    Color? subtitleColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: subtitleColor ?? theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Construye una tarjeta de KPI limpia sin icono
  Widget _buildKPICard({
    required ThemeData theme,
    required String title,
    required String mainValue,
    required String mainLabel,
    required String secondaryValue,
    required String secondaryLabel,
    required String referenceValue,
    required String referenceLabel,
    required Color accentColor,
    String? status,
    Color? statusColor,
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert
            ? accentColor.withValues(alpha: 0.06)
            : theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: isAlert
              ? accentColor.withValues(alpha: 0.25)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Título + Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (status != null && statusColor != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Valores en fila - centrados y misma altura
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Valor principal
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mainValue,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        mainLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Separador
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
                ),
                // Valor secundario
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        secondaryValue,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        secondaryLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Separador
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
                ),
                // Referencia
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        referenceValue,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        referenceLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de alertas
  List<String> _buildAlertas() {
    final alertas = <String>[];
    final tasaMortalidad = widget.lote.porcentajeMortalidad;
    final mortalidadEsperada = widget.lote.tipoAve.mortalidadEsperada;

    // Mortalidad elevada
    if (tasaMortalidad > mortalidadEsperada) {
      alertas.add(
        S
            .of(context)
            .loteMortalityHigh(
              tasaMortalidad.toStringAsFixed(1),
              mortalidadEsperada.toStringAsFixed(0),
            ),
      );
    }

    // Peso bajo
    if (widget.lote.pesoPromedioActual != null) {
      final pesoObjetivo =
          widget.lote.pesoPromedioObjetivo ??
          widget.lote.tipoAve.pesoPromedioVenta;
      final porcentajePeso =
          (widget.lote.pesoPromedioActual! / pesoObjetivo) * 100;
      if (porcentajePeso < 85) {
        alertas.add(
          S
              .of(context)
              .loteWeightBelow((100 - porcentajePeso).toStringAsFixed(0)),
        );
      }
    }

    // Cierre vencido
    if (widget.lote.cierreVencido) {
      final diasVencido = -(widget.lote.diasRestantes ?? 0);
      alertas.add(S.of(context).loteCierreVencido(diasVencido.toString()));
    }

    // Cerca del cierre
    if (widget.lote.cercaDelCierre) {
      alertas.add(
        S.of(context).loteCierreProximo(widget.lote.diasRestantes.toString()),
      );
    }

    // ICA alto
    final ica = widget.lote.indiceConversionAlimenticia;
    if (ica != null && widget.lote.icaDentroLimites == false) {
      alertas.add(S.of(context).loteICAHigh(ica.toStringAsFixed(2)));
    }

    return alertas;
  }

  // ==================== TRENDS PARA ICA Y GANANCIA ====================

  /// Obtiene el indicador de tendencia para el ICA.
  String? _getICATrend(double? ica) {
    if (ica == null) return null;

    // Límites según tipo de ave
    double icaOptimo;
    switch (widget.lote.tipoAve) {
      case TipoAve.polloEngorde:
        icaOptimo = 1.8;
        break;
      default:
        icaOptimo = 2.3;
    }

    if (ica <= icaOptimo) return S.of(context).loteTrendOptimal;
    if (ica <= icaOptimo * 1.1) return S.of(context).loteTrendNormal;
    if (ica <= icaOptimo * 1.2) return S.of(context).loteTrendAlto;
    return S.of(context).loteTrendCritical;
  }

  /// Obtiene el color para el indicador de ICA.
  Color? _getICATrendColor(double? ica) {
    if (ica == null) return null;

    double icaOptimo;
    switch (widget.lote.tipoAve) {
      case TipoAve.polloEngorde:
        icaOptimo = 1.8;
        break;
      default:
        icaOptimo = 2.3;
    }

    if (ica <= icaOptimo) return AppColors.success;
    if (ica <= icaOptimo * 1.1) return AppColors.teal;
    if (ica <= icaOptimo * 1.2) return AppColors.warning;
    return AppColors.error;
  }

  String _formatEdad(int dias) {
    if (dias < 7) return S.of(context).loteFormatDays(dias.toString());
    if (dias < 30) {
      final semanas = (dias / 7).floor();
      return semanas == 1
          ? S.of(context).loteFormatWeek(semanas.toString())
          : S.of(context).loteFormatWeeks(semanas.toString());
    }
    final meses = (dias / 30).floor();
    final semanasRestantes = ((dias % 30) / 7).floor();
    if (semanasRestantes > 0) {
      return meses == 1
          ? S
                .of(context)
                .loteFormatMonthAndWeeksShort(
                  meses.toString(),
                  semanasRestantes.toString(),
                )
          : S
                .of(context)
                .loteFormatMonthsAndWeeksShort(
                  meses.toString(),
                  semanasRestantes.toString(),
                );
    }
    return meses == 1
        ? S.of(context).loteFormatMonth(meses.toString())
        : S.of(context).loteFormatMonths(meses.toString());
  }

  // ==================== MÉTODOS PARA INDICADORES DE KPIs ====================

  /// Obtiene el indicador de tendencia para la mortalidad.
  String _getMortalidadTrend(double tasaMortalidad) {
    final esperada = widget.lote.tipoAve.mortalidadEsperada;
    if (tasaMortalidad <= esperada * 0.5) {
      return S.of(context).loteTrendExcellent;
    }
    if (tasaMortalidad <= esperada) return S.of(context).loteTrendNormal;
    if (tasaMortalidad <= esperada * 1.5) {
      return S.of(context).loteTrendElevated;
    }
    return S.of(context).loteTrendCritica;
  }

  /// Obtiene el color para el indicador de mortalidad.
  Color _getMortalidadTrendColor(double tasaMortalidad) {
    final esperada = widget.lote.tipoAve.mortalidadEsperada;
    if (tasaMortalidad <= esperada * 0.5) return AppColors.success;
    if (tasaMortalidad <= esperada) return AppColors.teal;
    if (tasaMortalidad <= esperada * 1.5) return AppColors.warning;
    return AppColors.error;
  }

  /// Obtiene el indicador de tendencia para el peso.
  String? _getPesoTrend() {
    final pesoActual = widget.lote.pesoPromedioActual;
    if (pesoActual == null) return null;

    final pesoObjetivo =
        widget.lote.pesoPromedioObjetivo ??
        widget.lote.tipoAve.pesoPromedioVenta;
    final porcentaje = (pesoActual / pesoObjetivo) * 100;

    if (porcentaje >= 95 && porcentaje <= 105) {
      return S.of(context).loteTrendOptimal;
    }
    if (porcentaje >= 85) return S.of(context).loteTrendAcceptable;
    if (porcentaje < 85) return S.of(context).loteTrendBajo;
    return S.of(context).loteTrendAlto;
  }

  /// Obtiene el color para el indicador de peso.
  Color? _getPesoTrendColor() {
    final pesoActual = widget.lote.pesoPromedioActual;
    if (pesoActual == null) return null;

    final pesoObjetivo =
        widget.lote.pesoPromedioObjetivo ??
        widget.lote.tipoAve.pesoPromedioVenta;
    final porcentaje = (pesoActual / pesoObjetivo) * 100;

    if (porcentaje >= 95 && porcentaje <= 105) return AppColors.success;
    if (porcentaje >= 85) return AppColors.info;
    if (porcentaje < 85) return AppColors.error;
    return AppColors.warning; // Alto
  }

  /// Obtiene el indicador de tendencia para el consumo.
  String? _getConsumoTrend(int cantidadActual) {
    final consumoAcumulado = widget.lote.consumoAcumuladoKg;
    if (consumoAcumulado == null || cantidadActual <= 0) return null;

    final edad = widget.lote.edadActualDias;
    if (edad <= 0) return null;

    // Consumo diario promedio por ave (g)
    final consumoDiarioPorAve =
        (consumoAcumulado / cantidadActual / edad) * 1000;
    final consumoEsperado = widget.lote.tipoAve.consumoDiarioEsperadoG;

    final porcentaje = (consumoDiarioPorAve / consumoEsperado) * 100;

    if (porcentaje >= 90 && porcentaje <= 110) {
      return S.of(context).loteTrendNormal;
    }
    if (porcentaje < 90) return S.of(context).loteTrendBajo;
    return S.of(context).loteTrendAlto;
  }

  /// Obtiene el color para el indicador de consumo.
  Color? _getConsumoTrendColor(int cantidadActual) {
    final consumoAcumulado = widget.lote.consumoAcumuladoKg;
    if (consumoAcumulado == null || cantidadActual <= 0) return null;

    final edad = widget.lote.edadActualDias;
    if (edad <= 0) return null;

    final consumoDiarioPorAve =
        (consumoAcumulado / cantidadActual / edad) * 1000;
    final consumoEsperado = widget.lote.tipoAve.consumoDiarioEsperadoG;
    final porcentaje = (consumoDiarioPorAve / consumoEsperado) * 100;

    if (porcentaje >= 90 && porcentaje <= 110) return AppColors.success;
    if (porcentaje < 90) {
      return AppColors.info; // Bajo consumo puede ser preocupante
    }
    return AppColors.warning; // Alto consumo
  }

  /// Obtiene el indicador de tendencia para la producción.
  String? _getProduccionTrend(int cantidadActual) {
    final huevos = widget.lote.huevosProducidos;
    if (huevos == null || cantidadActual <= 0) return null;

    final posturaActual = (huevos / cantidadActual) * 100;
    final posturaEsperada = widget.lote.tipoAve.posturaEsperada;

    if (posturaEsperada <= 0) return null;

    final porcentaje = (posturaActual / posturaEsperada) * 100;

    if (porcentaje >= 90) return S.of(context).loteTrendExcellent;
    if (porcentaje >= 75) return S.of(context).loteTrendBuena;
    if (porcentaje >= 50) return S.of(context).loteTrendRegular;
    return S.of(context).loteTrendBaja;
  }

  /// Obtiene el color para el indicador de producción.
  Color? _getProduccionTrendColor(int cantidadActual) {
    final huevos = widget.lote.huevosProducidos;
    if (huevos == null || cantidadActual <= 0) return null;

    final posturaActual = (huevos / cantidadActual) * 100;
    final posturaEsperada = widget.lote.tipoAve.posturaEsperada;

    if (posturaEsperada <= 0) return null;

    final porcentaje = (posturaActual / posturaEsperada) * 100;

    if (porcentaje >= 90) return AppColors.success;
    if (porcentaje >= 75) return AppColors.teal;
    if (porcentaje >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildFAB() {
    switch (_currentIndex) {
      case 0: // Mortalidad
        return FloatingActionButton.extended(
          tooltip: S.of(context).mortalityRegister,
          onPressed: () => context.push(
            AppRoutes.loteRegistrarMortalidadById(
              widget.granjaId,
              widget.lote.id,
            ),
            extra: widget.lote,
          ),
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: Text(S.of(context).batchRegisterMortality),
        );
      case 1: // Peso
        return FloatingActionButton.extended(
          tooltip: S.of(context).batchRegisterWeightTooltip,
          onPressed: () => context.push(
            AppRoutes.loteRegistrarPesoById(widget.granjaId, widget.lote.id),
            extra: widget.lote,
          ),
          backgroundColor: AppColors.warning,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: Text(S.of(context).batchRegisterWeight),
        );
      case 2: // Dashboard
        return FloatingActionButton.extended(
          tooltip: S.of(context).batchOpenRegisterMenu,
          onPressed: () =>
              _showRegistrarMenu(context, widget.lote, widget.granjaId),
          icon: const Icon(Icons.add),
          label: Text(S.of(context).commonRegister),
        );
      case 3: // Consumo
        return FloatingActionButton.extended(
          tooltip: S.of(context).batchFormConsumptionSubtitle,
          onPressed: () => context.push(
            AppRoutes.loteRegistrarConsumoById(widget.granjaId, widget.lote.id),
            extra: widget.lote,
          ),
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: Text(S.of(context).batchRegisterConsumption),
        );
      case 4: // Producción
        return FloatingActionButton.extended(
          tooltip: S.of(context).batchFormProductionInfoSubtitle,
          onPressed: () => context.push(
            AppRoutes.loteRegistrarProduccionById(
              widget.granjaId,
              widget.lote.id,
            ),
            extra: widget.lote,
          ),
          backgroundColor: AppColors.info,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: Text(S.of(context).batchRegisterProduction),
        );
      default:
        return FloatingActionButton.extended(
          tooltip: S.of(context).batchOpenRegisterMenu,
          onPressed: () =>
              _showRegistrarMenu(context, widget.lote, widget.granjaId),
          icon: const Icon(Icons.add),
          label: Text(S.of(context).commonRegister),
        );
    }
  }

  /// Construye las acciones del AppBar según el tab activo
  List<Widget>? _buildAppBarActions() {
    switch (_currentIndex) {
      case 0: // Mortalidad - Botón de filtro
        return [
          IconButton(
            icon: Badge(
              isLabelVisible:
                  _mortalidadKey.currentState?.hayFiltrosActivos ?? false,
              child: const Icon(Icons.filter_list_rounded),
            ),
            tooltip: S.of(context).commonFilter,
            onPressed: () {
              _mortalidadKey.currentState?.showFilterMenu();
            },
          ),
        ];
      case 1: // Peso - Botón de filtro
        return [
          IconButton(
            icon: Badge(
              isLabelVisible: _pesoKey.currentState?.hayFiltrosActivos ?? false,
              child: const Icon(Icons.filter_list_rounded),
            ),
            tooltip: S.of(context).commonFilter,
            onPressed: () {
              _pesoKey.currentState?.showFilterMenu();
            },
          ),
        ];
      case 3: // Consumo - Botón de filtro
        return [
          IconButton(
            icon: Badge(
              isLabelVisible:
                  _consumoKey.currentState?.hayFiltrosActivos ?? false,
              child: const Icon(Icons.filter_list_rounded),
            ),
            tooltip: S.of(context).commonFilter,
            onPressed: () {
              _consumoKey.currentState?.showFilterMenu();
            },
          ),
        ];
      case 4: // Producción - Botón de filtro
        return [
          IconButton(
            icon: Badge(
              isLabelVisible:
                  _produccionKey.currentState?.hayFiltrosActivos ?? false,
              child: const Icon(Icons.filter_list_rounded),
            ),
            tooltip: S.of(context).commonFilter,
            onPressed: () {
              _produccionKey.currentState?.showFilterMenu();
            },
          ),
        ];
      default:
        return null;
    }
  }

  Color _getAppBarColor() {
    switch (_currentIndex) {
      case 0: // Mortalidad
        return AppColors.error;
      case 1: // Peso
        return AppColors.warning;
      case 2: // Dashboard
        return AppColors.primary;
      case 3: // Consumo
        return AppColors.success;
      case 4: // Producción
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return S.of(context).mortalityTitle;
      case 1:
        return S.of(context).weightTitle;
      case 2:
        return widget.lote.nombre ?? widget.lote.codigo;
      case 3:
        return S.of(context).batchConsumption;
      case 4:
        return S.of(context).batchProduction;
      default:
        return widget.lote.nombre ?? widget.lote.codigo;
    }
  }

  Color _getEstadoColor(dynamic estado) {
    final estadoStr = estado.toString().split('.').last;
    switch (estadoStr) {
      case 'activo':
        return AppColors.success;
      case 'cerrado':
        return Theme.of(context).colorScheme.onSurface;
      case 'cuarentena':
        return AppColors.warning;
      case 'vendido':
        return AppColors.info;
      case 'enTransferencia':
        return AppColors.info;
      case 'suspendido':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  void _showRegistrarMenu(BuildContext context, Lote lote, String granjaId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _RegistrarMenuSheet(lote: lote, granjaId: granjaId),
    );
  }
}

// ==================== MENÚ REGISTRAR ====================

class _RegistrarMenuSheet extends StatelessWidget {
  const _RegistrarMenuSheet({required this.lote, required this.granjaId});

  final Lote lote;
  final String granjaId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).loteRegister,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ListTile(
            leading: const Icon(Icons.scale, color: AppColors.warning),
            title: Text(S.of(context).weightTitle),
            subtitle: Text(S.of(context).historialRegisterFirstWeighing),
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarPesoById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant, color: AppColors.success),
            title: Text(S.of(context).batchConsumption),
            subtitle: Text(S.of(context).batchFormConsumptionSubtitle),
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarConsumoById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber, color: AppColors.error),
            title: Text(S.of(context).mortalityTitle),
            subtitle: Text(S.of(context).mortalityRegister),
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarMortalidadById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          if (lote.tipoAve.esPostura)
            ListTile(
              leading: const Icon(Icons.egg, color: AppColors.info),
              title: Text(S.of(context).batchProduction),
              subtitle: Text(S.of(context).batchFormProductionInfoSubtitle),
              onTap: () {
                context.pop();
                context.push(
                  AppRoutes.loteRegistrarProduccionById(granjaId, lote.id),
                  extra: lote,
                );
              },
            ),
        ],
      ),
    );
  }
}

// ==================== NAVIGATION BAR PERSONALIZADO ====================

/// Destinos de navegación del dashboard del lote.
enum _DashboardDestination {
  mortalidad(
    icon: Icons.warning_amber_outlined,
    selectedIcon: Icons.warning_amber,
    labelKey: 'mortalityTitle',
  ),
  peso(
    icon: Icons.scale_outlined,
    selectedIcon: Icons.scale,
    labelKey: 'weightTitle',
  ),
  resumen(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'resumen',
  ),
  consumo(
    icon: Icons.restaurant_outlined,
    selectedIcon: Icons.restaurant,
    labelKey: 'batchConsumption',
  ),
  produccion(
    icon: Icons.egg_outlined,
    selectedIcon: Icons.egg,
    labelKey: 'batchProduction',
  );

  const _DashboardDestination({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;

  String label(BuildContext context) {
    switch (this) {
      case _DashboardDestination.mortalidad:
        return S.of(context).mortalityTitle;
      case _DashboardDestination.peso:
        return S.of(context).weightTitle;
      case _DashboardDestination.resumen:
        return S.of(context).loteDashSummary;
      case _DashboardDestination.consumo:
        return S.of(context).batchConsumption;
      case _DashboardDestination.produccion:
        return S.of(context).batchProduction;
    }
  }
}

/// Navigation Bar personalizado para el dashboard del lote.
class _DashboardNavigationBar extends StatelessWidget {
  const _DashboardNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.showProduccion,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showProduccion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // Filtrar destinos según showProduccion
    final destinations = showProduccion
        ? _DashboardDestination.values
        : _DashboardDestination.values
              .where((d) => d != _DashboardDestination.produccion)
              .toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 4, top: 4),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: destinations.asMap().entries.map((entry) {
                final index = entry.key;
                final destination = entry.value;
                return Expanded(
                  child: _DashboardNavigationItem(
                    destination: destination,
                    isSelected: currentIndex == index,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onDestinationSelected(index);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Item individual de navegación del dashboard.
class _DashboardNavigationItem extends StatefulWidget {
  const _DashboardNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _DashboardDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_DashboardNavigationItem> createState() =>
      _DashboardNavigationItemState();
}

class _DashboardNavigationItemState extends State<_DashboardNavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Color negro oscuro para seleccionado, gris para no seleccionado
    final selectedColor = theme.colorScheme.onSurface;
    final unselectedColor = theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isSelected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxs),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  fontSize: 12,
                  color: widget.isSelected ? selectedColor : unselectedColor,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(
                  widget.destination.label(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
