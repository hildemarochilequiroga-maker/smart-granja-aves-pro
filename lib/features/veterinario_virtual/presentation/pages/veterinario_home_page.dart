/// Página principal del Veterinario Virtual con las opciones de consulta.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../application/services/contexto_builder.dart';
import '../../domain/entities/tipo_consulta.dart';
import '../widgets/opcion_consulta_card.dart';

class VeterinarioHomePage extends StatelessWidget {
  const VeterinarioHomePage({this.lote, super.key});

  final Lote? lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.vetVirtualTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.info.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.vetVirtualSubtitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lote != null
                      ? l.vetVirtualContextoLote(
                          lote!.codigo,
                          lote!.tipoAve.name,
                        )
                      : l.vetVirtualSinContexto,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section title
          Text(
            l.vetVirtualEligeConsulta,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Grid de opciones
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
            children: _buildOpciones(context, l),
          ),

          const SizedBox(height: 16),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
            ),
            child: Text(
              l.vetVirtualDisclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOpciones(BuildContext context, S l) {
    final opciones = [
      (
        tipo: TipoConsulta.diagnosticoSintomas,
        icono: Icons.medical_services_outlined,
        titulo: l.vetDiagnosticoTitle,
        desc: l.vetDiagnosticoDesc,
        color: AppColors.error,
      ),
      (
        tipo: TipoConsulta.analisisMortalidad,
        icono: Icons.analytics_outlined,
        titulo: l.vetMortalidadTitle,
        desc: l.vetMortalidadDesc,
        color: AppColors.amber,
      ),
      (
        tipo: TipoConsulta.planVacunacion,
        icono: Icons.vaccines_outlined,
        titulo: l.vetVacunacionTitle,
        desc: l.vetVacunacionDesc,
        color: AppColors.info,
      ),
      (
        tipo: TipoConsulta.nutricionAlimentacion,
        icono: Icons.restaurant_outlined,
        titulo: l.vetNutricionTitle,
        desc: l.vetNutricionDesc,
        color: AppColors.success,
      ),
      (
        tipo: TipoConsulta.condicionesAmbientales,
        icono: Icons.thermostat_outlined,
        titulo: l.vetAmbienteTitle,
        desc: l.vetAmbienteDesc,
        color: Colors.deepOrange,
      ),
      (
        tipo: TipoConsulta.bioseguridad,
        icono: Icons.shield_outlined,
        titulo: l.vetBioseguridadTitle,
        desc: l.vetBioseguridadDesc,
        color: Colors.teal,
      ),
      (
        tipo: TipoConsulta.consultaGeneral,
        icono: Icons.chat_outlined,
        titulo: l.vetGeneralTitle,
        desc: l.vetGeneralDesc,
        color: AppColors.primary,
      ),
    ];

    return opciones
        .map(
          (op) => OpcionConsultaCard(
            icono: op.icono,
            titulo: op.titulo,
            descripcion: op.desc,
            color: op.color,
            onTap: () => _abrirChat(context, op.tipo),
          ),
        )
        .toList();
  }

  void _abrirChat(BuildContext context, TipoConsulta tipo) {
    final contexto = ContextoGranja(lote: lote);

    context.push(
      AppRoutes.veterinarioChat,
      extra: (tipo: tipo, contexto: contexto),
    );
  }
}
