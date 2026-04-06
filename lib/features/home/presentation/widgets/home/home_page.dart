import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../galpones/application/providers/galpon_providers.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../inventario/application/providers/providers.dart';
import '../../../../lotes/application/providers/lote_providers.dart';
import '../../../../notificaciones/application/providers/notificaciones_providers.dart';
import '../../../../notificaciones/presentation/widgets/notificaciones_badge.dart';
import '../../../../notificaciones/presentation/providers/notificaciones_scheduler_provider.dart';
import '../../../application/providers/actividades_recientes_provider.dart';
import 'home_header.dart';
import 'home_kpis_grid.dart';
import 'home_quick_actions.dart';
import 'home_activities.dart';
import 'veterinario_virtual_fab.dart';
import 'whatsapp_contact_fab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncNotificationScheduler(ref.read(granjaSeleccionadaProvider) != null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(granjaSeleccionadaProvider, (previous, next) {
      if (!mounted) return;
      _syncNotificationScheduler(next != null);
    });

    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      floatingActionButton: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          WhatsAppContactFab(),
          SizedBox(height: 16),
          VeterinarioVirtualFab(),
        ],
      ),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            // Logo de la app
            ClipRRect(
              borderRadius: AppRadius.allSm,
              child: Builder(
                builder: (context) {
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  return Image.asset(
                    AppAssets.logoIcon,
                    width: 36,
                    height: 36,
                    cacheWidth: (36 * dpr).round(),
                    cacheHeight: (36 * dpr).round(),
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.agriculture,
                      size: 36,
                      color: colorScheme.onPrimary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Nombre de la app
            Text(
              'Smart Granja Aves',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        actions: [
          // Botón de notificaciones
          NotificacionesIconButton(
            onPressed: () => context.push(AppRoutes.notificaciones),
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            // Header con saludo y selector de granja
            SliverToBoxAdapter(child: HomeHeader()),
            // KPIs Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  AppSpacing.base,
                  AppSpacing.base,
                  AppSpacing.md,
                ),
                child: HomeKpisGrid(),
              ),
            ),
            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  0,
                  AppSpacing.base,
                  AppSpacing.md,
                ),
                child: HomeQuickActions(),
              ),
            ),
            // Activities
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  0,
                  AppSpacing.base,
                  AppSpacing.xxl,
                ),
                child: HomeActivities(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final granjaSeleccionada = ref.read(granjaSeleccionadaProvider);
    if (granjaSeleccionada == null) return;

    // Invalidar todos los providers para forzar recarga
    ref.invalidate(granjasStreamProvider);
    ref.invalidate(estadisticasGranjasProvider);

    ref.invalidate(lotesStreamProvider(granjaSeleccionada.id));
    ref.invalidate(estadisticasLotesProvider(granjaSeleccionada.id));
    ref.invalidate(galponesStreamProvider(granjaSeleccionada.id));
    ref.invalidate(estadisticasGalponesProvider(granjaSeleccionada.id));
    ref.invalidate(actividadesRecientesSimpleProvider(granjaSeleccionada.id));
    ref.invalidate(notificacionesStreamProvider);
    ref.invalidate(notificacionesNoLeidasStreamProvider);
    ref.invalidate(conteoNotificacionesNoLeidasProvider);
    ref.invalidate(
      inventarioMovimientosGranjaProvider((
        granjaId: granjaSeleccionada.id,
        desde: DateTime.now().subtract(const Duration(days: 7)),
        hasta: null,
        limite: 5,
      )),
    );

    // Esperar un poco para que se actualicen los streams
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _syncNotificationScheduler(bool shouldRun) {
    final scheduler = ref.read(notificacionesSchedulerProvider.notifier);

    if (shouldRun) {
      scheduler.iniciar();
    } else {
      scheduler.detener();
    }
  }
}
