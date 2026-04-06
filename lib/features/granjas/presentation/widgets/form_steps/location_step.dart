/// Step 2: Ubicación de la Granja
/// Selección jerárquica País → Departamento → Ciudad + Dirección
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/value_objects/location_data.dart';
import '../granja_form_field.dart';

/// Step de ubicación con dropdowns jerárquicos
class LocationStep extends StatefulWidget {
  const LocationStep({
    super.key,
    required this.direccionController,
    required this.paisController,
    required this.departamentoController,
    required this.ciudadController,
    required this.referenciaController,
    required this.latitudController,
    required this.longitudController,
    this.onLocationSelected,
    this.autoValidate = false,
  });

  final TextEditingController direccionController;
  final TextEditingController paisController;
  final TextEditingController departamentoController;
  final TextEditingController ciudadController;
  final TextEditingController referenciaController;
  final TextEditingController latitudController;
  final TextEditingController longitudController;
  final void Function(double lat, double lng)? onLocationSelected;
  final bool autoValidate;

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  String? _selectedCountry;
  String? _selectedRegion;
  String? _selectedCity;
  bool _isLoadingRegions = false;
  bool _isLoadingCities = false;

  List<String> _availableRegions = [];
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    // Restaurar país previo o pre-seleccionar Perú
    final savedCountry = widget.paisController.text.isNotEmpty
        ? widget.paisController.text
        : 'Perú';
    _selectedCountry = savedCountry;
    widget.paisController.text = savedCountry;
    _availableRegions = LocationData.getRegionsForCountry(savedCountry);

    // Cargar valores previos si existen
    if (widget.departamentoController.text.isNotEmpty) {
      _selectedRegion = widget.departamentoController.text;
      _availableCities = LocationData.getCitiesForRegion(
        _selectedRegion!,
        _selectedCountry,
      );
    }
    if (widget.ciudadController.text.isNotEmpty) {
      _selectedCity = widget.ciudadController.text;
    }
  }

  void _onCountryChanged(String? country) {
    setState(() {
      _isLoadingRegions = true;
      _selectedCountry = country;
      _selectedRegion = null;
      _selectedCity = null;
      widget.paisController.text = country ?? '';
      widget.departamentoController.clear();
      widget.ciudadController.clear();
      _availableCities = [];
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _availableRegions = LocationData.getRegionsForCountry(country ?? '');
          _isLoadingRegions = false;
        });
      }
    });
  }

  void _onRegionChanged(String? region) {
    setState(() {
      _isLoadingCities = true;
      _selectedRegion = region;
      _selectedCity = null;
      widget.departamentoController.text = region ?? '';
      widget.ciudadController.clear();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _availableCities = LocationData.getCitiesForRegion(
            region ?? '',
            _selectedCountry,
          );
          _isLoadingCities = false;
        });
      }
    });
  }

  void _onCityChanged(String? city) {
    setState(() {
      _selectedCity = city;
      widget.ciudadController.text = city ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l.commonLocation,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.farmExactLocation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // País
          _buildDropdownField(
            value: _selectedCountry,
            label: l.farmSelectCountry,
            items: LocationData.countries,
            onChanged: _onCountryChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l.farmSelectCountry;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Departamento / Estado
          _isLoadingRegions
              ? _buildSkeletonLoader()
              : _buildDropdownField(
                  value: _selectedRegion,
                  label: LocationData.getRegionLabel(_selectedCountry ?? ''),
                  items: _availableRegions,
                  onChanged: _availableRegions.isEmpty
                      ? null
                      : _onRegionChanged,
                  hint: _availableRegions.isEmpty
                      ? l.commonFirstSelect(
                          LocationData.getRegionLabel(
                            _selectedCountry ?? '',
                          ).toLowerCase(),
                        )
                      : l.commonSelect(
                          LocationData.getRegionLabel(
                            _selectedCountry ?? '',
                          ).toLowerCase(),
                        ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l.commonSelect(
                        LocationData.getRegionLabel(
                          _selectedCountry ?? '',
                        ).toLowerCase(),
                      );
                    }
                    return null;
                  },
                ),
          AppSpacing.gapBase,

          // Ciudad / Municipio
          _isLoadingCities
              ? _buildSkeletonLoader()
              : _buildDropdownField(
                  value: _selectedCity,
                  label: LocationData.getCityLabel(_selectedCountry ?? ''),
                  items: _availableCities,
                  onChanged: _availableCities.isEmpty ? null : _onCityChanged,
                  hint: _availableCities.isEmpty
                      ? l.commonFirstSelect(
                          LocationData.getRegionLabel(
                            _selectedCountry ?? '',
                          ).toLowerCase(),
                        )
                      : l.commonSelect(
                          LocationData.getCityLabel(
                            _selectedCountry ?? '',
                          ).toLowerCase(),
                        ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l.commonSelect(
                        LocationData.getCityLabel(
                          _selectedCountry ?? '',
                        ).toLowerCase(),
                      );
                    }
                    return null;
                  },
                ),
          AppSpacing.gapBase,

          // Dirección
          GranjaFormField(
            controller: widget.direccionController,
            label: l.farmAddress,
            hint: l.farmAddressHint,
            required: true,
            maxLines: 2,
            maxLength: 200,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autovalidateMode: widget.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.farmEnterAddress;
              }
              if (value.trim().length < 10) {
                return l.farmAddressMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Referencia
          GranjaFormField(
            controller: widget.referenciaController,
            label: l.farmReferenceOptional,
            hint: l.farmReferenceHint,
            maxLines: 2,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
          AppSpacing.gapXl,

          // Card informativa
          _buildInfoCard(),
          AppSpacing.gapBase,

          // Coordenadas GPS (expandible)
          _buildCoordinatesSection(),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?)? onChanged,
    String? hint,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label encima del campo (estilo Wialon)
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        // Dropdown
        DropdownButtonFormField<String>(
          initialValue: value,
          autovalidateMode: widget.autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint ?? S.of(context).commonSelect(label),
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              height: 1.2,
            ),
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Placeholder label
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: AppRadius.allXs,
          ),
        ),
        AppSpacing.gapSm,
        // Skeleton del campo
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.allSm,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).farmPreciseLocation,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).farmLocationHelp,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatesSection() {
    final theme = Theme.of(context);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          S.of(context).farmGpsCoordinatesOptional,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          AppSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: GranjaFormField(
                  controller: widget.latitudController,
                  label: S.of(context).farmLatitude,
                  hint: S.of(context).farmLatitudeHint,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: (value) => _validateCoordinate(value),
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: GranjaFormField(
                  controller: widget.longitudController,
                  label: S.of(context).farmLongitude,
                  hint: S.of(context).farmLongitudeHint,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: (value) =>
                      _validateCoordinate(value, isLongitude: true),
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
        ],
      ),
    );
  }

  String? _validateCoordinate(String? value, {bool isLongitude = false}) {
    if (value == null || value.isEmpty) return null;
    try {
      final coord = double.parse(value);
      final maxValue = isLongitude ? 180.0 : 90.0;
      final minValue = -maxValue;

      if (coord < minValue || coord > maxValue) {
        return S
            .of(context)
            .commonMustBeBetween(minValue.toString(), maxValue.toString());
      }
    } on Exception {
      return S.of(context).commonMustBeValidNumber;
    }
    return null;
  }
}
