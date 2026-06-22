/// Página de guía diaria interactiva con checklist de tareas.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../application/providers/guia_diaria_provider.dart';
import '../../domain/entities/tarea_diaria.dart';
import '../../domain/enums/categoria_tarea.dart';
import '../../infrastructure/data/vacunacion_data.dart';

class GuiaDiariaPage extends ConsumerWidget {
  const GuiaDiariaPage({required this.lote, super.key});

  final Lote lote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(guiaDiariaProvider(lote));
    final notifier = ref.read(guiaDiariaProvider(lote).notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.guiaDiariaTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          _DayHeader(state: state, lote: lote),
          Expanded(
            child: state.tareas.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l.guiaDiariaSinTareas,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: _buildGroupedTasks(context, state, notifier, l),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedTasks(
    BuildContext context,
    GuiaDiariaState state,
    GuiaDiariaNotifier notifier,
    S l,
  ) {
    final tareas = state.tareas;
    final grouped = <CategoriaTarea, List<TareaDiaria>>{};
    for (final t in tareas) {
      grouped.putIfAbsent(t.categoria, () => []).add(t);
    }

    final widgets = <Widget>[];
    for (final entry in grouped.entries) {
      widgets.add(
        _CategorySection(
          categoria: entry.key,
          tareas: entry.value,
          notifier: notifier,
          l: l,
        ),
      );
    }

    // Próxima vacuna
    final vacunas = obtenerProgramaVacunacion(lote.tipoAve);
    final dia = state.diaActual;
    final proximaVacuna = vacunas.where((v) => v.dia > dia).toList();
    if (proximaVacuna.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _InfoBanner(
            text: l.guiaDiariaProximaVacuna(proximaVacuna.first.dia),
            detail:
                '${proximaVacuna.first.vacuna} — ${proximaVacuna.first.via}',
            color: AppColors.error,
          ),
        ),
      );
    }

    // Próximo pesaje
    final proximoPesaje = ((dia ~/ 7) + 1) * 7;
    if (proximoPesaje <= lote.tipoAve.diasCicloTipico) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _InfoBanner(
            text: l.guiaDiariaProximoPesaje(proximoPesaje),
            color: AppColors.info,
          ),
        ),
      );
    }

    return widgets;
  }
}

// =============================================================================
// HEADER CON DÍA, FECHA Y PROGRESO
// =============================================================================

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.state, required this.lote});

  final GuiaDiariaState state;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final fechaHoy = DateFormat(
      'EEEE d MMMM, yyyy',
      locale,
    ).format(DateTime.now());

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Día de vida + badge Hoy
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.guiaDiariaDia(state.diaActual),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${l.guiaDiariaHoy} — $fechaHoy',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progreso
          Row(
            children: [
              Expanded(
                child: AppProgressBar(
                  value: state.progreso,
                  height: 6,
                  borderRadius: AppRadius.allXs,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: state.progreso >= 1.0
                      ? AppColors.success
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l.guiaDiariaProgreso(
                  state.tareasCompletadas,
                  state.tareasTotal,
                ),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (state.progreso >= 1.0) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.guiaDiariaTodasCompletadas,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// SECCIÓN POR CATEGORÍA
// =============================================================================

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categoria,
    required this.tareas,
    required this.notifier,
    required this.l,
  });

  final CategoriaTarea categoria;
  final List<TareaDiaria> tareas;
  final GuiaDiariaNotifier notifier;
  final S l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorCategoria(categoria);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _categoriaNombre(categoria),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        ...tareas.map((t) => _TareaCard(tarea: t, notifier: notifier)),
      ],
    );
  }

  String _categoriaNombre(CategoriaTarea c) {
    return switch (c) {
      CategoriaTarea.alimentacion => l.guiaDiariaCatAlimentacion,
      CategoriaTarea.agua => l.guiaDiariaCatAgua,
      CategoriaTarea.luz => l.guiaDiariaCatLuz,
      CategoriaTarea.temperatura => l.guiaDiariaCatTemperatura,
      CategoriaTarea.humedad => l.guiaDiariaCatHumedad,
      CategoriaTarea.pesaje => l.guiaDiariaCatPesaje,
      CategoriaTarea.vacunacion => l.guiaDiariaCatVacunacion,
      CategoriaTarea.postura => l.guiaDiariaCatPostura,
      CategoriaTarea.bioseguridad => l.guiaDiariaCatBioseguridad,
      CategoriaTarea.equipos => l.guiaDiariaCatEquipos,
      CategoriaTarea.manejoGeneral => l.guiaDiariaCatManejoGeneral,
    };
  }

  static Color _colorCategoria(CategoriaTarea c) {
    return switch (c) {
      CategoriaTarea.alimentacion => AppColors.success,
      CategoriaTarea.agua => AppColors.info,
      CategoriaTarea.luz => AppColors.amber,
      CategoriaTarea.temperatura => AppColors.error,
      CategoriaTarea.humedad => AppColors.info,
      CategoriaTarea.pesaje => AppColors.secondary,
      CategoriaTarea.vacunacion => AppColors.error,
      CategoriaTarea.postura => AppColors.secondary,
      CategoriaTarea.bioseguridad => AppColors.primaryDark,
      CategoriaTarea.equipos => AppColors.amber,
      CategoriaTarea.manejoGeneral => AppColors.primaryDark,
    };
  }
}

// =============================================================================
// CARD DE TAREA INDIVIDUAL — DISEÑO MEJORADO CON ANIMACIONES
// =============================================================================

class _TareaCard extends StatefulWidget {
  const _TareaCard({required this.tarea, required this.notifier});

  final TareaDiaria tarea;
  final GuiaDiariaNotifier notifier;

  @override
  State<_TareaCard> createState() => _TareaCardState();
}

class _TareaCardState extends State<_TareaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _checkAnim;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.96), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _checkAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_processing) return;
    _processing = true;
    unawaited(HapticFeedback.lightImpact());
    unawaited(_ctrl.forward(from: 0));
    await widget.notifier.toggleTarea(widget.tarea.id);
    if (mounted) {
      _processing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tarea = widget.tarea;
    final completada = tarea.completada;
    final color = _CategorySection._colorCategoria(tarea.categoria);

    final esAlimentoOAgua =
        tarea.categoria == CategoriaTarea.alimentacion ||
        tarea.categoria == CategoriaTarea.agua;
    final tieneValorDestacado = esAlimentoOAgua && tarea.valorNumerico != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: completada
                ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  )
                : theme.colorScheme.surface,
            border: Border.all(
              color: completada
                  ? AppColors.success.withValues(alpha: 0.4)
                  : color.withValues(alpha: 0.15),
              width: completada ? 1.5 : 1,
            ),
            boxShadow: completada
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila principal: checkbox + título + badge estado
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox animado con efecto pop
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: _AnimatedCheckbox(
                            completada: completada,
                            animation: _checkAnim,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Título
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style:
                                (theme.textTheme.bodyLarge ?? const TextStyle())
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: completada
                                          ? theme.colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.6)
                                          : theme.colorScheme.onSurface,
                                    ),
                            child: Text(tarea.titulo),
                          ),
                        ),
                        // Badge "Realizado" con animación de entrada
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.elasticOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: completada
                              ? Container(
                                  key: const ValueKey('realizado'),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    S.of(context).guiaDiariaRealizado,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('vacio')),
                        ),
                      ],
                    ),
                    // Descripción
                    Padding(
                      padding: const EdgeInsets.only(left: 36, top: 4),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: (theme.textTheme.bodySmall ?? const TextStyle())
                            .copyWith(
                              color: completada
                                  ? theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                        child: Text(tarea.descripcion),
                      ),
                    ),
                    // Valor destacado grande (alimentación / agua)
                    if (tieneValorDestacado) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: _ValorDestacado(
                          tarea: tarea,
                          color: color,
                          completada: completada,
                        ),
                      ),
                    ],
                    // Valor numérico no-destacado (otros)
                    if (!tieneValorDestacado &&
                        tarea.valorNumerico != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: _ValorCompacto(
                          tarea: tarea,
                          color: color,
                          completada: completada,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CHECKBOX ANIMADO CON EFECTO POP
// =============================================================================

class _AnimatedCheckbox extends StatelessWidget {
  const _AnimatedCheckbox({required this.completada, required this.animation});

  final bool completada;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: completada ? AppColors.success : Colors.transparent,
        border: Border.all(
          color: completada ? AppColors.success : theme.colorScheme.outline,
          width: 2,
        ),
        shape: BoxShape.circle,
        boxShadow: completada
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: completada
            ? const Icon(
                Icons.check_rounded,
                key: ValueKey('check'),
                size: 16,
                color: Colors.white,
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}

// =============================================================================
// VALOR DESTACADO GRANDE (ALIMENTO / AGUA)
// =============================================================================

class _ValorDestacado extends StatelessWidget {
  const _ValorDestacado({
    required this.tarea,
    required this.color,
    required this.completada,
  });

  final TareaDiaria tarea;
  final Color color;
  final bool completada;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valor = tarea.valorNumerico!;

    // Extraer total del texto de descripción
    final descParts = tarea.descripcion.split('—');
    final totalPart = descParts.length > 1 ? descParts[1].trim() : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: completada
            ? color.withValues(alpha: 0.04)
            : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          // Valor por ave
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${valor.toStringAsFixed(0)} ${tarea.unidad ?? ''}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: completada ? color.withValues(alpha: 0.5) : color,
                ),
              ),
              Text(
                S.of(context).guiaDiariaPorAve,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          if (totalPart != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              width: 1,
              height: 32,
              color: color.withValues(alpha: 0.2),
            ),
            // Total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    totalPart.split('(').first.trim(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: completada ? color.withValues(alpha: 0.5) : color,
                    ),
                  ),
                  Text(
                    S.of(context).guiaDiariaTotal,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// VALOR COMPACTO (OTROS)
// =============================================================================

class _ValorCompacto extends StatelessWidget {
  const _ValorCompacto({
    required this.tarea,
    required this.color,
    required this.completada,
  });

  final TareaDiaria tarea;
  final Color color;
  final bool completada;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valor = tarea.valorNumerico!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${valor >= 1000 ? (valor / 1000).toStringAsFixed(1) : valor.toStringAsFixed(0)} ${tarea.unidad ?? ''}',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: completada ? color.withValues(alpha: 0.5) : color,
        ),
      ),
    );
  }
}

// =============================================================================
// BANNER INFORMATIVO
// =============================================================================

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text, required this.color, this.detail});

  final String text;
  final Color color;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 2),
            Text(
              detail!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
