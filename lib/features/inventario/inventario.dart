/// Feature de Inventario - Gestión de stock de items de la granja.
///
/// Este feature permite gestionar el inventario de:
/// - Alimentos (concentrados, granos, etc.)
/// - Medicamentos
/// - Vacunas
/// - Equipos
/// - Insumos generales
/// - Productos de limpieza
///
/// Incluye funcionalidades para:
/// - Registro de items con stock mínimo
/// - Control de entradas y salidas
/// - Alertas de stock bajo y vencimientos
/// - Integración con Costos, Consumo y Salud
library;

export 'domain/domain.dart';
export 'infrastructure/infrastructure.dart';
export 'application/application.dart';
export 'presentation/presentation.dart';
