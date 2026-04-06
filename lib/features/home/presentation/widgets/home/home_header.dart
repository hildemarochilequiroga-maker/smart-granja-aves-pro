import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_shadow.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../auth/application/providers/auth_provider.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../granjas/presentation/pages/aceptar_invitacion_granja_page.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(currentUserProvider);
    final granjasAsync = ref.watch(granjasStreamProvider);
    final granjaSeleccionada = ref.watch(granjaSeleccionadaProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.base,
        AppSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row con saludo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getSaludo(context, usuario?.nombreCompleto),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              // Date
              Text(
                _getFormattedDate(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          // Granja selector
          granjasAsync.when(
            data: (granjas) {
              if (granjas.isEmpty) {
                return _buildNoGranjasMessage(context);
              }

              // Si no hay granja seleccionada, seleccionar la primera
              final granja = granjaSeleccionada ?? granjas.first;
              if (granjaSeleccionada == null && granjas.isNotEmpty) {
                // Programar la selección para después del build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(granjaSeleccionadaProvider.notifier).state =
                      granjas.first;
                });
              }

              return _buildGranjaSelector(context, ref, granjas, granja);
            },
            loading: () => _buildGranjaSelectorSkeleton(context),
            error: (_, __) => _buildNoGranjasMessage(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGranjaSelector(
    BuildContext context,
    WidgetRef ref,
    List granjas,
    dynamic granjaActual,
  ) {
    final tieneMultiplesGranjas = granjas.length > 1;

    // Obtener dirección completa
    String direccionCompleta = '';
    if (granjaActual.direccion != null) {
      final dir = granjaActual.direccion;
      final partes = <String>[];
      if (dir.calle != null && dir.calle.isNotEmpty) {
        partes.add(dir.calle);
      }
      if (dir.ciudad != null && dir.ciudad.isNotEmpty) {
        partes.add(dir.ciudad);
      }
      if (dir.departamento != null && dir.departamento.isNotEmpty) {
        partes.add(dir.departamento);
      }
      direccionCompleta = partes.join(', ');
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 0,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        onTap: tieneMultiplesGranjas
            ? () => _mostrarSelectorGranjas(context, ref, granjas, granjaActual)
            : null,
        borderRadius: AppRadius.allMd,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.allMd,
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: AppShadow.sm,
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Info de la granja
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre de la granja
                    Text(
                      granjaActual.nombre ?? S.of(context).commonNoName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Dirección
                    if (direccionCompleta.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        direccionCompleta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Indicador de cambio
              if (tieneMultiplesGranjas) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.unfold_more_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarSelectorGranjas(
    BuildContext context,
    WidgetRef ref,
    List granjas,
    dynamic granjaActual,
  ) {
    final sheetTheme = Theme.of(context);
    final sheetColors = sheetTheme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetColors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: sheetColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Título
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              S.of(context).homeSelectFarm,
              style: sheetTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Opción para unirse con código (primero)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              0,
              AppSpacing.base,
              AppSpacing.md,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _mostrarDialogoUnirseGranja(context);
              },
              borderRadius: AppRadius.allSm,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: sheetColors.surface,
                  borderRadius: AppRadius.allSm,
                  border: Border.all(color: sheetColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).homeHaveCode,
                            style: sheetTheme.textTheme.titleSmall?.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxs),
                          Text(
                            S.of(context).homeJoinFarmWithInvitation,
                            style: sheetTheme.textTheme.bodySmall?.copyWith(
                              color: sheetColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: sheetColors.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista de granjas
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              itemCount: granjas.length,
              itemBuilder: (context, index) {
                final granja = granjas[index];
                final isSelected = granja.id == granjaActual.id;
                final itemTheme = Theme.of(context);
                final itemColors = itemTheme.colorScheme;

                // Obtener dirección completa
                String direccionGranja = '';
                if (granja.direccion != null) {
                  final dir = granja.direccion;
                  final partes = <String>[];
                  if (dir.calle != null && dir.calle.isNotEmpty) {
                    partes.add(dir.calle);
                  }
                  if (dir.ciudad != null && dir.ciudad.isNotEmpty) {
                    partes.add(dir.ciudad);
                  }
                  if (dir.departamento != null && dir.departamento.isNotEmpty) {
                    partes.add(dir.departamento);
                  }
                  direccionGranja = partes.join(', ');
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () {
                      ref.read(granjaSeleccionadaProvider.notifier).state =
                          granja;
                      Navigator.pop(context);
                    },
                    borderRadius: AppRadius.allSm,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? itemColors.surfaceContainerHighest
                            : itemColors.surface,
                        borderRadius: AppRadius.allSm,
                        border: Border.all(
                          color: isSelected
                              ? itemColors.outline
                              : itemColors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  granja.nombre ?? S.of(context).commonNoName,
                                  style: itemTheme.textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (direccionGranja.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    direccionGranja,
                                    style: itemTheme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: itemColors.onSurfaceVariant,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              color: itemColors.onSurface,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.paddingOf(context).bottom + AppSpacing.base,
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoUnirseGranja(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AceptarInvitacionGranjaPage(),
    );
  }

  Widget _buildGranjaSelectorSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.allSm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppRadius.allXs,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 120,
            height: 16,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppRadius.allXs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoGranjasMessage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.allSm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).homeNoFarmsRegistered,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push(AppRoutes.granjaCrear),
              icon: const Icon(Icons.add_rounded),
              label: Text(S.of(context).farmNewFarm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: InkWell(
              onTap: () => _mostrarDialogoUnirseGranja(context),
              child: Text(
                S.of(context).homeHaveInvitationCode,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.info,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSaludo(BuildContext context, String? nombre) {
    final hora = DateTime.now().hour;
    String saludo;
    if (hora < 12) {
      saludo = S.of(context).homeGreetingMorning;
    } else if (hora < 18) {
      saludo = S.of(context).homeGreetingAfternoon;
    } else {
      saludo = S.of(context).homeGreetingEvening;
    }

    if (nombre != null && nombre.isNotEmpty) {
      final primerNombre = nombre.split(' ').first;
      return '$saludo, $primerNombre';
    }
    return saludo;
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return Formatters.fechaDiaMesEs.format(now);
  }
}
