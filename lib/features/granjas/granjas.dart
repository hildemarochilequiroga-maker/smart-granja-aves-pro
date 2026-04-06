/// Feature Granjas - Gestión completa de granjas avícolas
///
/// Esta feature proporciona funcionalidad completa para:
/// - CRUD de granjas (crear, leer, actualizar, eliminar)
/// - Gestión de estados (activo, inactivo, mantenimiento)
/// - Búsqueda y filtrado de granjas
/// - Estadísticas y reportes
/// - Umbrales ambientales
/// - Geolocalización
///
/// Arquitectura:
/// - Domain: Entidades, Value Objects, Repositorio, Use Cases
/// - Infrastructure: Modelos, Datasources (Firebase/Local), Implementación del Repositorio
/// - Application: Estados y Providers (Riverpod)
/// - Presentation: Páginas y Widgets
library;

export 'application/application.dart';
export 'domain/domain.dart';
export 'infrastructure/infrastructure.dart';
export 'presentation/presentation.dart';
