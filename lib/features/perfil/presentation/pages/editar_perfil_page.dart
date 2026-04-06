/// Página para editar el perfil del usuario.
///
/// Permite modificar:
/// - Nombre y apellido
/// - Teléfono
/// - Foto de perfil
library;

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../auth/application/state/auth_state.dart';
import '../../../auth/domain/entities/usuario.dart';

/// Página para editar el perfil del usuario.
class EditarPerfilPage extends ConsumerStatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  ConsumerState<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends ConsumerState<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _guardando = false;
  bool _cambiosRealizados = false;
  bool _subiendoFoto = false;
  File? _fotoLocal;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  void _cargarDatosUsuario() {
    final usuario = ref.read(currentUserProvider);
    if (usuario != null) {
      _nombreController.text = usuario.nombre ?? '';
      _apellidoController.text = usuario.apellido ?? '';
      _telefonoController.text = usuario.telefono ?? '';
    }

    // Detectar cambios
    _nombreController.addListener(_onCambio);
    _apellidoController.addListener(_onCambio);
    _telefonoController.addListener(_onCambio);
  }

  void _onCambio() {
    if (!_cambiosRealizados) {
      setState(() => _cambiosRealizados = true);
    }
  }

  @override
  void dispose() {
    // Remover listeners antes de dispose
    _nombreController.removeListener(_onCambio);
    _apellidoController.removeListener(_onCambio);
    _telefonoController.removeListener(_onCambio);

    // Dispose controllers
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final usuario = ref.watch(currentUserProvider);

    return PopScope(
      canPop: !_cambiosRealizados,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _cambiosRealizados) {
          _confirmarSalir();
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Text(l.editProfileTitle),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          actions: [
            if (_cambiosRealizados)
              TextButton(
                onPressed: _guardando ? null : _guardarCambios,
                child: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l.commonSave,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Foto de perfil
                _buildFotoPerfil(theme, usuario),
                AppSpacing.gapXxl,

                // Información personal
                _buildSeccion(
                  theme,
                  titulo: l.editProfilePersonalInfo,
                  children: [
                    _buildCampoTexto(
                      controller: _nombreController,
                      label: l.commonName,
                      icono: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                    ),
                    AppSpacing.gapBase,
                    _buildCampoTexto(
                      controller: _apellidoController,
                      label: l.editProfileLastName,
                      icono: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                    ),
                    AppSpacing.gapBase,
                    _buildCampoTexto(
                      controller: _telefonoController,
                      label: l.commonPhone,
                      icono: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                    ),
                  ],
                ),
                AppSpacing.gapXl,

                // Información de cuenta (solo lectura)
                _buildSeccion(
                  theme,
                  titulo: l.editProfileAccountInfo,
                  children: [
                    _buildInfoItem(
                      theme,
                      icono: Icons.email_outlined,
                      label: l.authEmail,
                      valor: usuario?.email ?? '',
                      verificado: usuario?.emailVerificado ?? false,
                    ),
                    AppSpacing.gapMd,
                    _buildInfoItem(
                      theme,
                      icono: Icons.calendar_today_outlined,
                      label: l.editProfileMemberSince,
                      valor: _formatearFecha(usuario?.fechaCreacion),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFotoPerfil(ThemeData theme, Usuario? usuario) {
    final inicial = usuario?.iniciales ?? 'U';
    final fotoUrl = usuario?.fotoUrl;

    return Center(
      child: Stack(
        children: [
          // Avatar
          GestureDetector(
            onTap: _seleccionarFoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer,
                border: Border.all(color: theme.colorScheme.primary, width: 3),
                image: _fotoLocal != null
                    ? DecorationImage(
                        image: FileImage(_fotoLocal!),
                        fit: BoxFit.cover,
                      )
                    : fotoUrl != null && fotoUrl.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(fotoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: fotoUrl == null && _fotoLocal == null
                  ? Center(
                      child: Text(
                        inicial,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _subiendoFoto
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : null,
            ),
          ),

          // Botón de editar foto
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _seleccionarFoto,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion(
    ThemeData theme, {
    required String titulo,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allLg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          AppSpacing.gapBase,
          ...children,
        ],
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(icono, color: theme.colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme, {
    required IconData icono,
    required String label,
    required String valor,
    bool verificado = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.allMd,
          ),
          child: Icon(
            icono,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.hGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      valor,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (verificado) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return S.of(context).editProfileUnknownDate;
    final l = S.of(context);
    final meses = [
      l.monthJan,
      l.monthFeb,
      l.monthMar,
      l.monthApr,
      l.monthMay,
      l.monthJun,
      l.monthJul,
      l.monthAug,
      l.monthSep,
      l.monthOct,
      l.monthNov,
      l.monthDec,
    ];
    return '${meses[fecha.month - 1]} ${fecha.year}';
  }

  void _seleccionarFoto() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).editProfileChangePhoto,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(S.of(context).editProfileTakePhoto),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(S.of(context).editProfileChooseGallery),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
        imageQuality: (AppConstants.imageQuality * 100).toInt(),
      );

      if (image == null) return;

      // Validar tamaño
      final file = File(image.path);
      final bytes = await file.length();
      if (bytes > AppConstants.maxImageSizeBytes) {
        if (mounted) {
          _mostrarSnackBar(
            S.of(context).editProfileImageTooLarge,
            esExito: false,
          );
        }
        return;
      }

      // Mostrar vista previa local
      setState(() {
        _fotoLocal = file;
        _subiendoFoto = true;
      });

      // Subir foto
      await ref
          .read(authProvider.notifier)
          .actualizarFotoPerfil(rutaArchivo: file.path);

      if (mounted) {
        unawaited(HapticFeedback.mediumImpact());
        _mostrarSnackBar(S.of(context).editProfilePhotoUpdated, esExito: true);
      }
    } on Exception {
      if (mounted) {
        _mostrarSnackBar(S.of(context).editProfilePhotoError, esExito: false);
        // Revertir vista previa local en error
        setState(() => _fotoLocal = null);
      }
    } finally {
      if (mounted) {
        setState(() => _subiendoFoto = false);
      }
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    unawaited(HapticFeedback.lightImpact());

    try {
      await ref
          .read(authProvider.notifier)
          .actualizarPerfil(
            nombre: _nombreController.text.trim(),
            apellido: _apellidoController.text.trim(),
            telefono: _telefonoController.text.trim(),
          );

      final authState = ref.read(authProvider);
      if (authState is AuthError) {
        throw Exception(authState.mensaje);
      }

      if (mounted) {
        unawaited(HapticFeedback.mediumImpact());
        _mostrarSnackBar(
          S.of(context).editProfileUpdatedSuccess,
          esExito: true,
        );
        setState(() => _cambiosRealizados = false);
        context.pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        _mostrarSnackBar(
          S.of(context).editProfileUpdateError(e.toString()),
          esExito: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _confirmarSalir() async {
    final l = S.of(context);
    final salir = await showAppConfirmDialog(
      context: context,
      title: l.editProfileDiscardChanges,
      message: l.editProfileDiscardMessage,
      type: AppDialogType.danger,
      confirmText: l.commonDiscard,
      cancelText: l.commonContinue,
    );

    if (salir == true && mounted) {
      context.pop();
    }
  }

  void _mostrarSnackBar(String mensaje, {required bool esExito}) {
    if (esExito) {
      AppSnackBar.success(context, message: mensaje);
    } else {
      AppSnackBar.error(context, message: mensaje);
    }
  }
}
