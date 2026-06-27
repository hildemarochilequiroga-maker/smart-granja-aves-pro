/// Bottom sheet para editar el perfil del usuario.
///
/// Reemplaza a la antigua pantalla `EditarPerfilPage`. Permite modificar nombre,
/// apellido, teléfono y la foto de perfil (cámara o galería) desde un bottom
/// sheet, con campos al estilo de los formularios de registro (sin íconos de
/// prefijo) y textos a la escala que usamos en el resto de la app.
library;

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../auth/application/state/auth_state.dart';
import '../../../auth/domain/entities/usuario.dart';

/// Muestra el bottom sheet de edición de perfil.
Future<void> mostrarEditarPerfilSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _EditarPerfilSheet(),
  );
}

class _EditarPerfilSheet extends ConsumerStatefulWidget {
  const _EditarPerfilSheet();

  @override
  ConsumerState<_EditarPerfilSheet> createState() => _EditarPerfilSheetState();
}

class _EditarPerfilSheetState extends ConsumerState<_EditarPerfilSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _guardando = false;
  bool _subiendoFoto = false;
  File? _fotoLocal;

  @override
  void initState() {
    super.initState();
    final usuario = ref.read(currentUserProvider);
    if (usuario != null) {
      _nombreController.text = usuario.nombre ?? '';
      _apellidoController.text = usuario.apellido ?? '';
      _telefonoController.text = usuario.telefono ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = S.of(context);
    final usuario = ref.watch(currentUserProvider);

    return FormTextScale(
      factor: 1.2,
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xxl),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: AppRadius.allFull,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Encabezado con título y botón guardar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.editProfileTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildFotoPerfil(theme, usuario),
                          AppSpacing.gapXl,
                          RegistroFormField(
                            controller: _nombreController,
                            label: l.commonName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          AppSpacing.gapBase,
                          RegistroFormField(
                            controller: _apellidoController,
                            label: l.editProfileLastName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          AppSpacing.gapBase,
                          RegistroFormField(
                            controller: _telefonoController,
                            label: l.commonPhone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ],
                          ),
                          AppSpacing.gapBase,
                          // Email (solo lectura)
                          RegistroFormField(
                            initialValue: usuario?.email ?? '',
                            label: l.authEmail,
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Botón guardar fijo
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: AppButton.primary(
                      label: l.commonSave,
                      onPressed: _guardando ? null : _guardarCambios,
                      isLoading: _guardando,
                      expanded: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFotoPerfil(ThemeData theme, Usuario? usuario) {
    final inicial = usuario?.iniciales ?? 'U';
    final fotoUrl = usuario?.fotoUrl;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _seleccionarFoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary,
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
              child: (fotoUrl == null || fotoUrl.isEmpty) && _fotoLocal == null
                  ? Center(
                      child: Text(
                        inicial,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _subiendoFoto
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _seleccionarFoto,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 3),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _seleccionarFoto() {
    HapticFeedback.lightImpact();
    final l = S.of(context);

    showAppBottomSheet<void>(
      context: context,
      title: l.editProfileChangePhoto,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSheetOptionTile(
            icon: Icons.camera_alt_rounded,
            color: AppColors.info,
            label: l.editProfileTakePhoto,
            onTap: () {
              Navigator.pop(ctx);
              _pickAndUploadFoto(ImageSource.camera);
            },
          ),
          AppSheetOptionTile(
            icon: Icons.photo_library_rounded,
            color: AppColors.success,
            label: l.editProfileChooseGallery,
            onTap: () {
              Navigator.pop(ctx);
              _pickAndUploadFoto(ImageSource.gallery);
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
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

      final file = File(image.path);
      final bytes = await file.length();
      if (bytes > AppConstants.maxImageSizeBytes) {
        if (mounted) {
          AppSnackBar.error(
            context,
            message: S.of(context).editProfileImageTooLarge,
          );
        }
        return;
      }

      setState(() {
        _fotoLocal = file;
        _subiendoFoto = true;
      });

      await ref
          .read(authProvider.notifier)
          .actualizarFotoPerfil(rutaArchivo: file.path);

      if (mounted) {
        unawaited(HapticFeedback.mediumImpact());
        AppSnackBar.success(
          context,
          message: S.of(context).editProfilePhotoUpdated,
        );
      }
    } on Exception {
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).editProfilePhotoError,
        );
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
        AppSnackBar.success(
          context,
          message: S.of(context).editProfileUpdatedSuccess,
        );
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.error(
          context,
          message: S.of(context).editProfileUpdateError(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }
}
