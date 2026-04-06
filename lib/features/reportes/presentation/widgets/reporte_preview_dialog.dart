/// Diálogo de vista previa de reporte PDF.
library;

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Diálogo para previsualizar y compartir/descargar el PDF generado.
class ReportePreviewDialog extends StatelessWidget {
  const ReportePreviewDialog({
    super.key,
    required this.pdfBytes,
    required this.nombreReporte,
  });

  final Uint8List pdfBytes;
  final String nombreReporte;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.base),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: const BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.white,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).reportGenerated,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nombreReporte,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Vista previa del PDF
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: PdfPreview(
              build: (format) => pdfBytes,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              pdfFileName: _generarNombreArchivo(context),
            ),
          ),

          // Botones de acción
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _compartir(context),
                    icon: const Icon(Icons.share_rounded),
                    label: Text(S.of(context).commonShare),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: const BorderSide(color: AppColors.success),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _imprimir(context),
                    icon: const Icon(Icons.print_rounded),
                    label: Text(S.of(context).reportPrint),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _generarNombreArchivo(BuildContext context) {
    final fecha = DateTime.now();
    final fechaStr =
        '${fecha.year}${fecha.month.toString().padLeft(2, '0')}${fecha.day.toString().padLeft(2, '0')}';
    final horaStr =
        '${fecha.hour.toString().padLeft(2, '0')}${fecha.minute.toString().padLeft(2, '0')}${fecha.second.toString().padLeft(2, '0')}';
    final nombreLimpio = nombreReporte
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    return '${S.of(context).reportFilePrefix}_${nombreLimpio}_${fechaStr}_$horaStr.pdf';
  }

  Future<void> _compartir(BuildContext context) async {
    File? tempFile;
    final nombreArchivo = _generarNombreArchivo(context);
    try {
      // Guardar archivo temporal
      final tempDir = await getTemporaryDirectory();
      tempFile = File('${tempDir.path}/$nombreArchivo');
      await tempFile.writeAsBytes(pdfBytes);

      // Compartir
      if (!context.mounted) return;
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        subject: nombreReporte,
        text: S.of(context).reportShareText,
      );
    } on Exception catch (e) {
      if (context.mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).reportShareError,
          detail: ErrorHandler.getUserFriendlyMessage(e),
        );
      }
    } finally {
      // Limpiar archivo temporal
      try {
        await tempFile?.delete();
      } catch (_) {}
    }
  }

  Future<void> _imprimir(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: _generarNombreArchivo(context),
      );
    } on Exception catch (e) {
      if (context.mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).reportPrintError,
          detail: ErrorHandler.getUserFriendlyMessage(e),
        );
      }
    }
  }
}
