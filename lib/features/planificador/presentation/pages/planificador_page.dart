/// Página del Planificador Avícola — formulario de entrada.
///
/// Pantalla única con scroll donde el usuario configura:
/// tipo de producción, raza, cantidad de aves, ubicación y precio de venta.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../application/providers/planificador_provider.dart';
import '../../domain/entities/plan_avicola.dart';
import '../../domain/enums/raza_ave.dart';
import '../../domain/enums/zona_climatica.dart';
import '../../infrastructure/data/razas_data.dart';

class PlanificadorPage extends ConsumerStatefulWidget {
  const PlanificadorPage({super.key});

  @override
  ConsumerState<PlanificadorPage> createState() => _PlanificadorPageState();
}

class _PlanificadorPageState extends ConsumerState<PlanificadorPage> {
  final _cantidadController = TextEditingController(text: '500');
  final _precioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(planificadorFormProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificador Avícola'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === Encabezado ===
            _buildHeader(theme),
            const SizedBox(height: 24),

            // === Tipo de producción ===
            _buildSectionLabel('Tipo de Producción'),
            const SizedBox(height: 8),
            _buildTipoSelector(form, theme),
            const SizedBox(height: 20),

            // === Raza ===
            _buildSectionLabel(
              form.tipoProduccion == TipoProduccion.engorde
                  ? 'Raza de Engorde'
                  : 'Raza de Ponedora',
            ),
            const SizedBox(height: 8),
            if (form.tipoProduccion == TipoProduccion.engorde)
              _buildRazaEngordeSelector(form, theme)
            else
              _buildRazaPonedoraSelector(form, theme),
            const SizedBox(height: 20),

            // === Cantidad de aves ===
            _buildSectionLabel('Cantidad de Aves'),
            const SizedBox(height: 8),
            _buildCantidadField(theme),
            const SizedBox(height: 20),

            // === Zona climática ===
            _buildSectionLabel('Zona Climática'),
            const SizedBox(height: 8),
            _buildZonaSelector(form, theme),
            const SizedBox(height: 20),

            // === Nivel de automatización ===
            _buildSectionLabel('Nivel de Automatización'),
            const SizedBox(height: 8),
            _buildAutomatizacionSelector(form, theme),
            const SizedBox(height: 20),

            // === Precio de venta ===
            _buildSectionLabel('Precio de Venta (opcional)'),
            const SizedBox(height: 4),
            Text(
              form.tipoProduccion == TipoProduccion.engorde
                  ? 'Referencial: S/ ${PreciosMercadoPeru.polloVivoGranjaKg.toStringAsFixed(2)}/kg'
                  : 'Referencial: S/ ${PreciosMercadoPeru.huevoGranjaKg.toStringAsFixed(2)}/kg',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            _buildPrecioField(theme),
            const SizedBox(height: 32),

            // === Botón generar ===
            _buildGenerarButton(theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGETS
  // ===========================================================================

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.info.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.success,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Planifica tu granja',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Configura los parámetros y obtén un plan completo con '
                  'infraestructura, alimentación, vacunación y proyección financiera.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTipoSelector(PlanificadorFormState form, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _OptionCard(
            icon: Icons.egg_alt_outlined,
            label: 'Pollo Engorde',
            selected: form.tipoProduccion == TipoProduccion.engorde,
            onTap: () => ref
                .read(planificadorFormProvider.notifier)
                .setTipo(TipoProduccion.engorde),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OptionCard(
            icon: Icons.egg_outlined,
            label: 'Gallina Ponedora',
            selected: form.tipoProduccion == TipoProduccion.ponedora,
            onTap: () => ref
                .read(planificadorFormProvider.notifier)
                .setTipo(TipoProduccion.ponedora),
          ),
        ),
      ],
    );
  }

  Widget _buildRazaEngordeSelector(
    PlanificadorFormState form,
    ThemeData theme,
  ) {
    return Column(
      children: RazaEngorde.values.map((raza) {
        final datos = datosRazasEngorde[raza]!;
        return _RazaTile(
          nombre: raza.nombre,
          detalle:
              '${datos.pesoObjetivoKg.toStringAsFixed(1)} kg en ${datos.diasCiclo} días — '
              'CA ${datos.conversionAlimenticia}',
          selected: form.razaEngorde == raza,
          onTap: () =>
              ref.read(planificadorFormProvider.notifier).setRazaEngorde(raza),
        );
      }).toList(),
    );
  }

  Widget _buildRazaPonedoraSelector(
    PlanificadorFormState form,
    ThemeData theme,
  ) {
    return Column(
      children: RazaPonedora.values.map((raza) {
        final datos = datosRazasPonedora[raza]!;
        return _RazaTile(
          nombre: raza.nombre,
          detalle:
              '${datos.huevosAveAlojada80Sem} huevos/80 sem — '
              'Pico ${(datos.picoProduccion * 100).toStringAsFixed(0)}%',
          selected: form.razaPonedora == raza,
          onTap: () =>
              ref.read(planificadorFormProvider.notifier).setRazaPonedora(raza),
        );
      }).toList(),
    );
  }

  Widget _buildCantidadField(ThemeData theme) {
    return TextFormField(
      controller: _cantidadController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: 'Ej: 500',
        prefixIcon: const Icon(Icons.groups_outlined),
        suffixText: 'aves',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ingresa la cantidad';
        final n = int.tryParse(value);
        if (n == null || n < 50) return 'Mínimo 50 aves';
        if (n > 100000) return 'Máximo 100,000 aves';
        return null;
      },
      onChanged: (value) {
        final n = int.tryParse(value);
        if (n != null && n >= 50) {
          ref.read(planificadorFormProvider.notifier).setCantidad(n);
        }
      },
    );
  }

  Widget _buildZonaSelector(PlanificadorFormState form, ThemeData theme) {
    return Row(
      children: ZonaClimatica.values.map((zona) {
        final selected = form.zona == zona;
        final icon = switch (zona) {
          ZonaClimatica.costa => Icons.beach_access_outlined,
          ZonaClimatica.sierra => Icons.terrain_outlined,
          ZonaClimatica.selva => Icons.forest_outlined,
        };
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: zona == ZonaClimatica.costa ? 0 : 6,
              right: zona == ZonaClimatica.selva ? 0 : 6,
            ),
            child: _OptionCard(
              icon: icon,
              label: zona.nombre,
              selected: selected,
              onTap: () =>
                  ref.read(planificadorFormProvider.notifier).setZona(zona),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAutomatizacionSelector(
    PlanificadorFormState form,
    ThemeData theme,
  ) {
    const niveles = NivelAutomatizacion.values;
    const icons = <NivelAutomatizacion, IconData>{
      NivelAutomatizacion.manual: Icons.back_hand_outlined,
      NivelAutomatizacion.semiAutomatico: Icons.tune_outlined,
      NivelAutomatizacion.automatico: Icons.precision_manufacturing_outlined,
    };
    return Row(
      children: niveles.map((nivel) {
        final selected = form.nivelAutomatizacion == nivel;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: nivel == NivelAutomatizacion.manual ? 0 : 6,
              right: nivel == NivelAutomatizacion.automatico ? 0 : 6,
            ),
            child: GestureDetector(
              onTap: () => ref
                  .read(planificadorFormProvider.notifier)
                  .setNivelAutomatizacion(nivel),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.success.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.success
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      icons[nivel],
                      size: 24,
                      color: selected
                          ? AppColors.success
                          : theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nivel.nombre,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selected ? AppColors.success : null,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nivel.descripcion,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 9,
                        color: theme.colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrecioField(ThemeData theme) {
    return TextFormField(
      controller: _precioController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: 'Dejar vacío para usar precio referencial',
        prefixIcon: const Icon(Icons.attach_money),
        prefixText: 'S/ ',
        suffixText: '/kg',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) {
        final precio = double.tryParse(value);
        ref.read(planificadorFormProvider.notifier).setPrecioVenta(precio);
      },
    );
  }

  Widget _buildGenerarButton(ThemeData theme) {
    return AppButton.primary(
      label: 'Generar Plan Completo',
      icon: Icons.auto_awesome,
      onPressed: _generarPlan,
      expanded: true,
      height: 56,
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
    );
  }

  void _generarPlan() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    context.push(AppRoutes.planificadorResultado);
  }
}

// =============================================================================
// WIDGETS AUXILIARES
// =============================================================================

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.success.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.success
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: selected ? AppColors.success : theme.colorScheme.outline,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppColors.success : null,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RazaTile extends StatelessWidget {
  const _RazaTile({
    required this.nombre,
    required this.detalle,
    required this.selected,
    required this.onTap,
  });

  final String nombre;
  final String detalle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.success.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.success
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.success : theme.colorScheme.outline,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detalle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
