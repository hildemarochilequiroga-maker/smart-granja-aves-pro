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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/lote.dart';
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
              AppButton.primary(
                label: S.of(context).commonRetry,
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(loteByIdProvider(loteId)),
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
            AppButton.primary(
              label: S.of(context).commonBack,
              icon: Icons.arrow_back,
              onPressed: () => context.pop(),
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
    return PopScope(
      // En un historial, el back del sistema vuelve al resumen (no sale).
      canPop: _currentIndex == 2,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 2) {
          setState(() => _currentIndex = 2);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          toolbarHeight: 64,
          backgroundColor: _getAppBarColor(),
          elevation: 0,
          foregroundColor: appBarForeground,
          iconTheme: IconThemeData(color: appBarForeground),
          // En un historial: volver al resumen. En el resumen: salir de la página.
          leading: _currentIndex != 2
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _currentIndex = 2),
                )
              : null,
          title: FormTextScale(
            factor: 1.4,
            child: Text(
              _getAppBarTitle(),
              style: AppTextStyles.titleMedium.copyWith(
                color: appBarForeground,
                fontWeight: FontWeight.w600,
              ),
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
        floatingActionButton: widget.lote.estaActivo && _currentIndex != 2
            ? FormTextScale(factor: 1.25, child: _buildFAB())
            : null,
      ),
    );
  }

  Widget _buildDashboardView() {
    final theme = Theme.of(context);
    final mortalidadTotal = widget.lote.mortalidadAcumulada;
    final edad = widget.lote.edadActualDias;

    // Detectar alertas
    final alertas = _buildAlertas();

    return FormTextScale(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(loteByIdProvider(widget.lote.id));
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
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
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.05,
                      ),
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
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.onPrimary.withValues(
                                      alpha: 0.95,
                                    ),
                                    fontWeight: FontWeight.w600,
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
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(color: theme.colorScheme.outlineVariant, height: 1),

                    // Stats de aves: Ingreso, Aves ingresadas
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
                              label: S.of(context).batchEnteredBirds,
                              value: '${widget.lote.cantidadInicial}',
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
            // CARD - Costo por ave (acumulado por ave viva, a hoy)
            // ================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _CostoPorAveCard(
                lote: widget.lote,
                granjaId: widget.granjaId,
              ),
            ),

            // ================================================================
            // SECCIÓN DE ALERTAS (si hay)
            // ================================================================
            if (alertas.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: FormInfoCard(
                  type: InfoCardType.warning,
                  title: S.of(context).loteAttention,
                  description: alertas.join('\n'),
                ),
              ),
            ],

            // Cards "Guía de manejo" y "Guía diaria" ocultas a pedido.
            // Implementación conservada (comentada) por si se reactivan:
            /*
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
            // BOTÓN GUÍA DIARIA INTERACTIVA
            // ================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Card(
                elevation: 2,
                shadowColor: AppColors.success.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.allMd,
                  side: const BorderSide(color: AppColors.success, width: 1.2),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.push(
                    AppRoutes.loteGuiaDiariaById(
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
                                S.of(context).guiaDiariaBotonLabel,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                S.of(context).guiaDiariaBotonSubtitle,
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
            */
            // ================================================================
            // ACCESOS A HISTORIALES (botones con métrica resumida)
            // ================================================================
            _buildAccesoHistorialCard(
              theme: theme,
              title: S.of(context).mortalityTitle,
              value: '$mortalidadTotal ${S.of(context).historialDeadBirds}',
              color: AppColors.error,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _buildAccesoHistorialCard(
              theme: theme,
              title: S.of(context).weightTitle,
              value: widget.lote.pesoPromedioActual != null
                  ? '${(widget.lote.pesoPromedioActual! * 1000).toStringAsFixed(0)} g'
                  : '-- g',
              color: AppColors.warning,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            _buildAccesoHistorialCard(
              theme: theme,
              title: S.of(context).batchConsumption,
              value: widget.lote.consumoAcumuladoKg != null
                  ? '${widget.lote.consumoAcumuladoKg!.toStringAsFixed(1)} kg ${S.of(context).batchTotalAccumulated}'
                  : '-- kg',
              color: AppColors.success,
              onTap: () => setState(() => _currentIndex = 3),
            ),
            if (widget.lote.tipoAve.esPostura)
              _buildAccesoHistorialCard(
                theme: theme,
                title: S.of(context).batchProduction,
                value:
                    '${widget.lote.huevosProducidos ?? 0} ${S.of(context).batchTotalEggs}',
                color: AppColors.info,
                onTap: () => setState(() => _currentIndex = 4),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPERS PARA DASHBOARD ====================

  /// Card de acceso a un historial con su métrica resumida.
  Widget _buildAccesoHistorialCard({
    required ThemeData theme,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        elevation: 2,
        shadowColor: color.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allMd,
          side: BorderSide(color: color, width: 1.2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        return S.of(context).loteDashSummary;
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
      backgroundColor: Colors.transparent,
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
    return AppBottomSheetScaffold(
      title: S.of(context).loteRegister,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSheetOptionTile(
            icon: Icons.scale,
            color: AppColors.warning,
            label: S.of(context).weightTitle,
            subtitle: S.of(context).historialRegisterFirstWeighing,
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarPesoById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          AppSheetOptionTile(
            icon: Icons.restaurant,
            color: AppColors.success,
            label: S.of(context).batchConsumption,
            subtitle: S.of(context).batchFormConsumptionSubtitle,
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarConsumoById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          AppSheetOptionTile(
            icon: Icons.warning_amber,
            color: AppColors.error,
            label: S.of(context).mortalityTitle,
            subtitle: S.of(context).mortalityRegister,
            onTap: () {
              context.pop();
              context.push(
                AppRoutes.loteRegistrarMortalidadById(granjaId, lote.id),
                extra: lote,
              );
            },
          ),
          if (lote.tipoAve.esPostura)
            AppSheetOptionTile(
              icon: Icons.egg,
              color: AppColors.info,
              label: S.of(context).batchProduction,
              subtitle: S.of(context).batchFormProductionInfoSubtitle,
              onTap: () {
                context.pop();
                context.push(
                  AppRoutes.loteRegistrarProduccionById(granjaId, lote.id),
                  extra: lote,
                );
              },
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

/// Card de resumen del costo por ave del lote (versión compacta).
///
/// Muestra solo el costo por ave (sin iconos ni desglose) y, al tocarla, abre
/// [CostoPorAvePage] con el desglose detallado. Consume [costoPorAveProvider].
class _CostoPorAveCard extends ConsumerWidget {
  const _CostoPorAveCard({required this.lote, required this.granjaId});

  final Lote lote;
  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final costoAsync = ref.watch(
      costoPorAveProvider(CostoPorAveParams(loteId: lote.id)),
    );

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        borderRadius: AppRadius.allMd,
        onTap: () => context.push(
          AppRoutes.loteCostoPorAveById(granjaId, lote.id),
          extra: lote,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMd,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).batchCostPerBird,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    costoAsync.when(
                      data: (costo) => Text(
                        costo.sinDatosDeCosto
                            ? S.of(context).batchNoCostData
                            : Formatters.currencyValue(costo.costoPorAveViva),
                        style: costo.sinDatosDeCosto
                            ? theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            : theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                      ),
                      loading: () => Text(
                        '—',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      error: (_, __) => Text(
                        S.of(context).commonErrorLoading,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
    );
  }
}
