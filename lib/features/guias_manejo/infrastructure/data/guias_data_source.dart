import '../../domain/entities/guia_semanal.dart';
import '../../../lotes/domain/enums/tipo_ave.dart';
import 'datos_pollo_engorde.dart';
import 'datos_gallina_ponedora.dart';
import 'datos_reproductora_pesada.dart';
import 'datos_reproductora_liviana.dart';
import 'datos_pavo.dart';
import 'datos_codorniz.dart';
import 'datos_pato.dart';
import 'datos_otro.dart';

/// Fuente de datos estática que devuelve la guía semanal según el tipo de ave.
class GuiasDataSource {
  const GuiasDataSource._();

  /// Retorna la lista de guías semanales para el tipo de ave dado.
  static List<GuiaSemanal> obtenerGuias(TipoAve tipoAve) {
    return switch (tipoAve) {
      TipoAve.polloEngorde => datosPolloEngorde,
      TipoAve.gallinaPonedora => datosGallinaPonedora,
      TipoAve.reproductoraPesada => datosReproductoraPesada,
      TipoAve.reproductoraLiviana => datosReproductoraLiviana,
      TipoAve.pavo => datosPavo,
      TipoAve.codorniz => datosCodorniz,
      TipoAve.pato => datosPato,
      TipoAve.otro => datosOtro,
    };
  }

  /// Nombre del manual de referencia para el tipo de ave.
  static String fuenteManual(TipoAve tipoAve) {
    return switch (tipoAve) {
      TipoAve.polloEngorde => 'Cobb 500 / Ross 308 Broiler Management Guide',
      TipoAve.gallinaPonedora =>
        'Hy-Line Brown / Lohmann Brown Management Guide',
      TipoAve.reproductoraPesada =>
        'Cobb 500 Breeder / Ross 308 PS Management Guide',
      TipoAve.reproductoraLiviana => 'Lohmann LSL-Classic Management Guide',
      TipoAve.pavo => 'Nicholas / Hybrid Turkeys Management Guide',
      TipoAve.codorniz => 'Coturnix japonica Production Manual',
      TipoAve.pato => 'Cherry Valley / Pekin Duck Management Guide',
      TipoAve.otro => 'General Poultry Management Reference',
    };
  }
}
