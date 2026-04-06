/// Feature de Galpones.
///
/// Este módulo gestiona los galpones de la granja,
/// incluyendo su creación, edición, estado, y operaciones
/// como asignación de lotes, desinfección y mantenimiento.
///
/// ## Arquitectura
///
/// El módulo sigue Clean Architecture con las siguientes capas:
///
/// - **Domain**: Entidades, enums, repositorios y casos de uso
/// - **Infrastructure**: Modelos, datasources y implementaciones
/// - **Application**: Estados, notifiers y providers de Riverpod
/// - **Presentation**: Páginas y widgets de UI
///
/// ## Uso básico
///
/// ```dart
/// import 'package:smartgranjaaves_pro/features/galpones/galpones.dart';
///
/// // En un widget Consumer
/// final galpones = ref.watch(galponesPorGranjaProvider(granjaId));
///
/// // Para crear un galpón
/// ref.read(galponNotifierProvider.notifier).crearGalpon(nuevoGalpon);
/// ```
library;

export 'application/application.dart';
export 'domain/domain.dart';
export 'infrastructure/infrastructure.dart';
export 'presentation/presentation.dart';
