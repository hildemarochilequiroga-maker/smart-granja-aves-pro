import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/value_objects/cliente.dart';
import '../../domain/value_objects/direccion.dart';

/// Widget para ingresar los datos del cliente en el formulario de venta.
///
/// Incluye validación en tiempo real y feedback visual.
/// Estilo basado en GranjaFormField con errores inline.
class ClienteStep extends StatefulWidget {
  final Cliente? clienteInicial;
  final ValueChanged<Cliente> onClienteChanged;
  final bool autoValidate;

  const ClienteStep({
    super.key,
    this.clienteInicial,
    required this.onClienteChanged,
    this.autoValidate = false,
  });

  @override
  State<ClienteStep> createState() => _ClienteStepState();
}

class _ClienteStepState extends State<ClienteStep> {
  late TextEditingController _nombreController;
  late TextEditingController _identificacionController;
  late TextEditingController _contactoController;
  String _tipoDocumento = 'DNI';

  // Errores inline
  String? _nombreError;
  String? _identificacionError;
  String? _contactoError;

  // Tracking de campos tocados
  bool _nombreTouched = false;
  bool _identificacionTouched = false;
  bool _contactoTouched = false;

  @override
  void initState() {
    super.initState();
    final cliente = widget.clienteInicial;
    _nombreController = TextEditingController(text: cliente?.nombre ?? '');
    _identificacionController = TextEditingController(
      text: cliente?.identificacion ?? '',
    );
    _contactoController = TextEditingController(text: cliente?.contacto ?? '');
    if (cliente != null) {
      _tipoDocumento = cliente.tipoDocumento;
    }
  }

  @override
  void didUpdateWidget(ClienteStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cuando autoValidate cambia a true, forzar validación de todos los campos
    if (widget.autoValidate && !oldWidget.autoValidate) {
      _forceValidateAll();
    }
  }

  void _forceValidateAll() {
    setState(() {
      _nombreTouched = true;
      _identificacionTouched = true;
      _contactoTouched = true;
    });
    _validateField('nombre');
    _validateField('identificacion');
    _validateField('contacto');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _identificacionController.dispose();
    _contactoController.dispose();
    super.dispose();
  }

  void _validateField(String field) {
    setState(() {
      switch (field) {
        case 'nombre':
          if (_nombreTouched) {
            if (_nombreController.text.trim().isEmpty) {
              _nombreError = S.of(context).ventaClientNameRequired;
            } else if (_nombreController.text.trim().length < 3) {
              _nombreError = S.of(context).ventaClientNameMinLength;
            } else {
              _nombreError = null;
            }
          }
          break;
        case 'identificacion':
          if (_identificacionTouched) {
            final idLength = _tipoDocumento == 'DNI'
                ? 8
                : _tipoDocumento == 'RUC'
                ? 11
                : 6;
            if (_identificacionController.text.isEmpty) {
              _identificacionError = S.of(context).ventaClientDocumentRequired;
            } else if (_identificacionController.text.length < idLength) {
              _identificacionError = _tipoDocumento == 'DNI'
                  ? S.of(context).ventaClientDniLength
                  : _tipoDocumento == 'RUC'
                  ? S.of(context).ventaClientRucLength
                  : S.of(context).ventaClientDocumentInvalid;
            } else {
              _identificacionError = null;
            }
          }
          break;
        case 'contacto':
          if (_contactoTouched) {
            if (_contactoController.text.isEmpty) {
              _contactoError = S.of(context).ventaClientPhoneRequired;
            } else if (_contactoController.text.length < 9) {
              _contactoError = S.of(context).ventaClientPhoneLength;
            } else {
              _contactoError = null;
            }
          }
          break;
      }
    });
    _tryNotifyClient();
  }

  void _tryNotifyClient() {
    // Validar todos los campos silenciosamente
    final nombreValid = _nombreController.text.trim().length >= 3;
    final idLength = _tipoDocumento == 'DNI'
        ? 8
        : _tipoDocumento == 'RUC'
        ? 11
        : 6;
    final identificacionValid =
        _identificacionController.text.length >= idLength;
    final contactoValid = _contactoController.text.length >= 9;

    // Solo notificar si todos los campos son válidos
    if (nombreValid && identificacionValid && contactoValid) {
      try {
        final cliente = Cliente(
          nombre: _nombreController.text.trim(),
          identificacion: _identificacionController.text,
          tipoDocumento: _tipoDocumento,
          contacto: _contactoController.text,
          correo: null,
          direccion: const Direccion(
            calle: '',
            ciudad: '',
            departamento: '',
            referencia: null,
          ),
        );
        widget.onClienteChanged(cliente);
      } on Exception {
        // Validación fallida
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).ventaStepClientTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).ventaClientBuyerInfo,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Nombre completo
          _buildFormField(
            controller: _nombreController,
            label: S.of(context).ventaClientName,
            fieldName: 'nombre',
            hint: S.of(context).ventaClientNameHint,
            isRequired: true,
            textCapitalization: TextCapitalization.words,
            error: _nombreError,
          ),
          const SizedBox(height: AppSpacing.base),

          // Tipo de documento
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).ventaClientDocType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _tipoDocumento,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.allSm,
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.allSm,
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'DNI',
                    child: Text(S.of(context).salesDni),
                  ),
                  DropdownMenuItem(
                    value: 'RUC',
                    child: Text(S.of(context).salesRuc),
                  ),
                  DropdownMenuItem(
                    value: 'CE',
                    child: Text(S.of(context).salesForeignCard),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _tipoDocumento = value;
                      _identificacionController.clear();
                      _identificacionError = null;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // Número de documento
          _buildFormField(
            controller: _identificacionController,
            label: S.of(context).ventaClientDocument,
            fieldName: 'identificacion',
            hint: _tipoDocumento == 'DNI'
                ? S.of(context).clientDocHint8
                : _tipoDocumento == 'RUC'
                ? S.of(context).clientDocHint11
                : S.of(context).clientDocHintGeneral,
            isRequired: true,
            keyboardType: TextInputType.number,
            maxLength: _tipoDocumento == 'DNI'
                ? 8
                : _tipoDocumento == 'RUC'
                ? 11
                : 15,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            error: _identificacionError,
          ),
          const SizedBox(height: AppSpacing.base),

          // Teléfono
          _buildFormField(
            controller: _contactoController,
            label: S.of(context).ventaClientPhone,
            fieldName: 'contacto',
            hint: S.of(context).ventaClientPhoneHint,
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 9,
            error: _contactoError,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String fieldName,
    String? hint,
    bool isRequired = false,
    TextInputType? keyboardType,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? error,
  }) {
    final theme = Theme.of(context);
    final labelText = isRequired ? '$label *' : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label encima del campo
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Campo de texto con Focus para detectar cuando pierde el foco
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Marcar como tocado cuando pierde el foco
              setState(() {
                switch (fieldName) {
                  case 'nombre':
                    _nombreTouched = true;
                    break;
                  case 'identificacion':
                    _identificacionTouched = true;
                    break;
                  case 'contacto':
                    _contactoTouched = true;
                    break;
                }
              });
              _validateField(fieldName);
            }
          },
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.normal,
              ),
              counterText: '',
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: error != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: error != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: error != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (_) {
              // Marcar como tocado y validar en tiempo real
              setState(() {
                switch (fieldName) {
                  case 'nombre':
                    _nombreTouched = true;
                    break;
                  case 'identificacion':
                    _identificacionTouched = true;
                    break;
                  case 'contacto':
                    _contactoTouched = true;
                    break;
                }
              });
              _validateField(fieldName);
            },
          ),
        ),
        // Error inline
        if (error != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            error,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
