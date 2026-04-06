/// Página de chat para consultas con el veterinario virtual IA.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../l10n/app_localizations.dart';
import '../../application/providers/veterinario_providers.dart';
import '../../application/services/contexto_builder.dart';
import '../../domain/entities/entities.dart';
import '../widgets/mensaje_burbuja_widget.dart';

class ChatConsultaPage extends ConsumerStatefulWidget {
  const ChatConsultaPage({
    required this.tipo,
    required this.contexto,
    super.key,
  });

  final TipoConsulta tipo;
  final ContextoGranja contexto;

  @override
  ConsumerState<ChatConsultaPage> createState() => _ChatConsultaPageState();
}

class _ChatConsultaPageState extends ConsumerState<ChatConsultaPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final _picker = ImagePicker();
  final _speech = stt.SpeechToText();

  Uint8List? _imagenSeleccionada;
  String? _imagenMimeType;
  bool _escuchando = false;
  bool _speechDisponible = false;
  bool _inputFocused = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _inputFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _initSpeech() async {
    _speechDisponible = await _speech.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _speech.stop();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final params = (
      tipo: widget.tipo,
      contexto: widget.contexto,
      locale: locale,
    );
    final state = ref.watch(chatConsultaProvider(params));

    // Scroll al fondo cuando hay nuevos mensajes o respuesta parcial
    _scrollToBottom();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _tituloConsulta(l, widget.tipo),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount:
                  state.mensajes.length +
                  (state.enviando ? 1 : 0) +
                  (state.error != null ? 1 : 0),
              itemBuilder: (context, index) {
                // Mensajes normales
                if (index < state.mensajes.length) {
                  return MensajeBurbujaWidget(mensaje: state.mensajes[index]);
                }

                // Indicador de typing / respuesta parcial
                if (state.enviando && index == state.mensajes.length) {
                  return TypingIndicatorWidget(
                    textoParcial: state.respuestaParcial,
                    statusText: _statusText(l, state.estadoProcesamiento),
                  );
                }

                // Error
                if (state.error != null) {
                  return _ErrorWidget(
                    error: state.error!,
                    onRetry: () {
                      // Re-enviar último mensaje del usuario
                      final ultimoMensajeUsuario = state.mensajes.lastWhere(
                        (m) => m.rol == RolMensaje.usuario,
                        orElse: () => MensajeChat(
                          rol: RolMensaje.usuario,
                          texto: '',
                          timestamp: DateTime(0),
                        ),
                      );
                      if (ultimoMensajeUsuario.texto.isNotEmpty) {
                        ref
                            .read(chatConsultaProvider(params).notifier)
                            .enviarMensaje(ultimoMensajeUsuario.texto);
                      }
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // --- Input bar estilo Gemini ---
          Container(
            color: theme.colorScheme.surface,
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Vista previa de imagen seleccionada
                if (_imagenSeleccionada != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10, left: 4),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.memory(
                              _imagenSeleccionada!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imagenSeleccionada = null;
                                  _imagenMimeType = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Indicador de escucha
                if (_escuchando)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.graphic_eq_rounded,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l.vetVoiceListening,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Input unificado estilo Gemini
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(28),
                    border: _inputFocused
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 6),
                          // Botón adjuntar (dentro del campo)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _InputBarIcon(
                              icon: Icons.add_rounded,
                              onTap: state.enviando
                                  ? null
                                  : () => _mostrarOpcionesImagen(l),
                              active: !state.enviando,
                            ),
                          ),
                          // Campo de texto
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              maxLines: 5,
                              minLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText: l.vetChatHint,
                                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 14,
                                ),
                              ),
                              onSubmitted: state.enviando
                                  ? null
                                  : (_) => _enviar(params),
                            ),
                          ),
                          // Botón micrófono
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _InputBarIcon(
                              icon: _escuchando
                                  ? Icons.stop_circle_rounded
                                  : Icons.mic_none_rounded,
                              onTap: state.enviando
                                  ? null
                                  : () => _toggleEscuchar(l),
                              active: !state.enviando,
                              activeColor: _escuchando
                                  ? Colors.red.shade400
                                  : null,
                            ),
                          ),
                          // Botón enviar
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, right: 6),
                            child: GestureDetector(
                              onTap: state.enviando
                                  ? null
                                  : () => _enviar(params),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: state.enviando
                                      ? theme.colorScheme.surfaceContainerHigh
                                      : theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 20,
                                  color: state.enviando
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _enviar(
    ({TipoConsulta tipo, ContextoGranja contexto, String locale}) params,
  ) {
    final texto = _controller.text.trim();
    if (texto.isEmpty && _imagenSeleccionada == null) return;

    final textoEnviar = texto.isEmpty && _imagenSeleccionada != null
        ? S.of(context).vetAnalyzeImage
        : texto;

    _controller.clear();

    ref
        .read(chatConsultaProvider(params).notifier)
        .enviarMensaje(
          textoEnviar,
          imagenBytes: _imagenSeleccionada,
          imagenMimeType: _imagenMimeType,
        );

    setState(() {
      _imagenSeleccionada = null;
      _imagenMimeType = null;
    });

    _focusNode.requestFocus();
  }

  Future<void> _mostrarOpcionesImagen(S l) async {
    final theme = Theme.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  l.vetImageAttach,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.vetImageSelectSource,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                // Opciones en row
                Row(
                  children: [
                    // Cámara
                    Expanded(
                      child: _ImageOptionCard(
                        icon: Icons.camera_alt_rounded,
                        label: l.vetFromCamera,
                        iconColor: const Color(0xFF2196F3),
                        backgroundColor: const Color(
                          0xFF2196F3,
                        ).withValues(alpha: 0.1),
                        onTap: () => Navigator.pop(ctx, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Galería
                    Expanded(
                      child: _ImageOptionCard(
                        icon: Icons.photo_library_rounded,
                        label: l.vetFromGallery,
                        iconColor: const Color(0xFFE91E63),
                        backgroundColor: const Color(
                          0xFFE91E63,
                        ).withValues(alpha: 0.1),
                        onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (source == null) return;
    await _seleccionarImagen(source);
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    // Comprimir imagen
    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 800,
      minHeight: 800,
      quality: 75,
    );

    final mimeType = picked.name.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';

    setState(() {
      _imagenSeleccionada = compressed;
      _imagenMimeType = mimeType;
    });
  }

  Future<void> _toggleEscuchar(S l) async {
    if (_escuchando) {
      await _speech.stop();
      setState(() => _escuchando = false);
      return;
    }

    if (!_speechDisponible) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.vetVoiceNotAvailable)));
      return;
    }

    setState(() => _escuchando = true);

    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        if (result.finalResult) {
          setState(() => _escuchando = false);
        }
      },
      localeId: Localizations.localeOf(context).languageCode,
    );
  }

  String? _statusText(S l, EstadoProcesamiento estado) {
    switch (estado) {
      case EstadoProcesamiento.ninguno:
        return null;
      case EstadoProcesamiento.procesando:
        return l.vetStatusProcessing;
      case EstadoProcesamiento.analizandoImagen:
        return l.vetStatusAnalyzingImage;
      case EstadoProcesamiento.generandoRespuesta:
        return l.vetStatusGenerating;
    }
  }

  String _tituloConsulta(S l, TipoConsulta tipo) {
    switch (tipo) {
      case TipoConsulta.diagnosticoSintomas:
        return l.vetDiagnosticoTitle;
      case TipoConsulta.analisisMortalidad:
        return l.vetMortalidadTitle;
      case TipoConsulta.planVacunacion:
        return l.vetVacunacionTitle;
      case TipoConsulta.nutricionAlimentacion:
        return l.vetNutricionTitle;
      case TipoConsulta.condicionesAmbientales:
        return l.vetAmbienteTitle;
      case TipoConsulta.bioseguridad:
        return l.vetBioseguridadTitle;
      case TipoConsulta.consultaGeneral:
        return l.vetGeneralTitle;
    }
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 18,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.vetChatError,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(l.vetChatRetry),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icono circular dentro del input bar estilo Gemini.
class _InputBarIcon extends StatelessWidget {
  const _InputBarIcon({
    required this.icon,
    required this.onTap,
    this.active = true,
    this.activeColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: active ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: active
                ? (activeColor ?? theme.colorScheme.onSurfaceVariant)
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

/// Card de opción de imagen para el bottom sheet.
class _ImageOptionCard extends StatelessWidget {
  const _ImageOptionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
