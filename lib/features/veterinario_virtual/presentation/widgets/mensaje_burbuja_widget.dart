/// Widgets de mensaje estilo Gemini para el chat del veterinario virtual.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mensaje_chat.dart';

/// --- MENSAJE DEL USUARIO (pill derecho, estilo Gemini) ---
class _MensajeUsuarioWidget extends StatelessWidget {
  const _MensajeUsuarioWidget({required this.mensaje});

  final MensajeChat mensaje;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(left: 56, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (mensaje.tieneImagen)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    mensaje.imagenBytes!,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (mensaje.texto.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  mensaje.texto,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.45,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// --- MENSAJE DEL ASISTENTE (full-width, sin burbuja, estilo Gemini) ---
class _MensajeAsistenteWidget extends StatelessWidget {
  const _MensajeAsistenteWidget({required this.mensaje});

  final MensajeChat mensaje;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta
          Text(
            l.vetIaLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          // Contenido del mensaje (sin fondo, full-width)
          MarkdownBody(
            data: mensaje.texto,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
              p: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.55,
              ),
              h2: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              h3: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              strong: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              listBullet: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.55,
              ),
              blockSpacing: 10,
            ),
          ),
          const SizedBox(height: 8),
          // Barra de acciones estilo Gemini
          Row(
            children: [
              _ActionIconButton(
                icon: Icons.content_copy_rounded,
                size: 17,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: mensaje.texto));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.vetTextoCopied),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 2),
              _ActionIconButton(
                icon: Icons.thumb_up_outlined,
                size: 17,
                onTap: () {},
              ),
              const SizedBox(width: 2),
              _ActionIconButton(
                icon: Icons.thumb_down_outlined,
                size: 17,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Separador sutil
          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
        ],
      ),
    );
  }
}

/// Botón de acción pequeño estilo Gemini.
class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.onTap,
    this.size = 18,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            icon,
            size: size,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Widget público que despacha entre usuario y asistente.
class MensajeBurbujaWidget extends StatelessWidget {
  const MensajeBurbujaWidget({required this.mensaje, super.key});

  final MensajeChat mensaje;

  @override
  Widget build(BuildContext context) {
    return mensaje.rol == RolMensaje.usuario
        ? _MensajeUsuarioWidget(mensaje: mensaje)
        : _MensajeAsistenteWidget(mensaje: mensaje);
  }
}

/// Indicador de que la IA está escribiendo con estado contextual.
class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({
    this.textoParcial = '',
    this.statusText,
    super.key,
  });

  final String textoParcial;
  final String? statusText;

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta
          Text(
            l.vetIaLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          // Contenido
          widget.textoParcial.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dots animados
                    AnimatedBuilder(
                      animation: _dotController,
                      builder: (context, _) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          final delay = i * 0.25;
                          final value =
                              ((_dotController.value + delay) % 1.0 * 2 - 1)
                                  .abs();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Opacity(
                              opacity: 0.3 + 0.7 * value,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Texto de estado contextual
                    if (widget.statusText != null) ...[
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.statusText!,
                          key: ValueKey(widget.statusText),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : MarkdownBody(
                  data: widget.textoParcial,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.55,
                    ),
                    h2: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    h3: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    strong: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    listBullet: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.55,
                    ),
                    blockSpacing: 10,
                  ),
                ),
        ],
      ),
    );
  }
}
