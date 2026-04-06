library;

/// Feature de autenticación
///
/// Este módulo contiene toda la lógica relacionada con la autenticación
/// de usuarios, incluyendo login, registro, recuperación de contraseña
/// y autenticación social.
///
/// Estructura:
/// - domain: Entidades, repositorios y casos de uso
/// - infrastructure: Implementaciones y datasources
/// - application: Estados y providers
/// - presentation: Páginas y widgets

export 'application/application.dart';
export 'domain/domain.dart';
export 'infrastructure/infrastructure.dart';
export 'presentation/presentation.dart';
