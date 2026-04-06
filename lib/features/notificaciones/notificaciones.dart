/// Feature de notificaciones.
///
/// Exporta todos los componentes públicos del feature.
/// Incluye 77 tipos de notificaciones organizadas por categoría.
library;

// Domain
export 'domain/entities/notificacion.dart';
export 'domain/enums/tipo_notificacion.dart';
export 'domain/enums/prioridad_notificacion.dart';

// Application
export 'application/services/notification_service.dart';
export 'application/services/alertas_service.dart';
export 'application/providers/notificaciones_providers.dart';

// Infrastructure
export 'infrastructure/repositories/notificaciones_repository.dart';

// Presentation
export 'presentation/pages/notificaciones_page.dart';
export 'presentation/widgets/notificacion_tile.dart';
export 'presentation/widgets/notificaciones_badge.dart';
export 'presentation/widgets/notificaciones_empty.dart';
export 'presentation/providers/notificaciones_scheduler_provider.dart';
