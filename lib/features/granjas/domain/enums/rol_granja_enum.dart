library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Enumeración de roles disponibles en una granja
enum RolGranja {
  owner, // Propietario original
  admin, // Administrador
  manager, // Gestor operativo
  operator, // Operario de campo
  viewer; // Visualizador

  /// Nombre legible del rol
  String get displayName {
    final locale = Formatters.currentLocale;
    switch (this) {
      case RolGranja.owner:
        return switch (locale) { 'es' => 'Propietario', 'pt' => 'Proprietário', _ => 'Owner' };
      case RolGranja.admin:
        return switch (locale) { 'es' => 'Administrador', 'pt' => 'Administrador', _ => 'Administrator' };
      case RolGranja.manager:
        return switch (locale) { 'es' => 'Gestor', 'pt' => 'Gestor', _ => 'Manager' };
      case RolGranja.operator:
        return switch (locale) { 'es' => 'Operario', 'pt' => 'Operário', _ => 'Operator' };
      case RolGranja.viewer:
        return switch (locale) { 'es' => 'Visualizador', 'pt' => 'Visualizador', _ => 'Viewer' };
    }
  }

  /// Descripción del rol
  String get descripcion {
    final locale = Formatters.currentLocale;
    switch (this) {
      case RolGranja.owner:
        return switch (locale) { 'es' => 'Control total, puede eliminar la granja', 'pt' => 'Controle total, pode excluir a granja', _ => 'Full control, can delete the farm' };
      case RolGranja.admin:
        return switch (locale) { 'es' => 'Control total excepto eliminar', 'pt' => 'Controle total exceto excluir', _ => 'Full control except deletion' };
      case RolGranja.manager:
        return switch (locale) { 'es' => 'Gestión de registros e invitaciones', 'pt' => 'Gestão de registros e convites', _ => 'Record and invitation management' };
      case RolGranja.operator:
        return switch (locale) { 'es' => 'Solo puede crear registros', 'pt' => 'Só pode criar registros', _ => 'Can only create records' };
      case RolGranja.viewer:
        return switch (locale) { 'es' => 'Solo lectura', 'pt' => 'Somente leitura', _ => 'Read only' };
    }
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) {
    return switch (this) {
      RolGranja.owner => l.enumRolGranjaOwner,
      RolGranja.admin => l.enumRolGranjaAdmin,
      RolGranja.manager => l.enumRolGranjaManager,
      RolGranja.operator => l.enumRolGranjaOperator,
      RolGranja.viewer => l.enumRolGranjaViewer,
    };
  }

  /// Descripción localizada para UI con AppLocalizations.
  String localizedDescripcion(S l) {
    return switch (this) {
      RolGranja.owner => l.enumRolGranjaDescOwner,
      RolGranja.admin => l.enumRolGranjaDescAdmin,
      RolGranja.manager => l.enumRolGranjaDescManager,
      RolGranja.operator => l.enumRolGranjaDescOperator,
      RolGranja.viewer => l.enumRolGranjaDescViewer,
    };
  }

  /// Convierte string a enum
  static RolGranja fromString(String value) {
    return RolGranja.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RolGranja.viewer,
    );
  }

  // ==================== PERMISOS ====================

  /// Puede invitar usuarios (owner, admin, manager)
  bool get canInviteUsers =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede cambiar roles de otros usuarios (solo owner y admin)
  bool get canChangeRoles => this == RolGranja.owner || this == RolGranja.admin;

  /// Puede remover usuarios (solo owner y admin)
  bool get canRemoveUsers => this == RolGranja.owner || this == RolGranja.admin;

  /// Puede editar datos de la granja (nombre, ubicación, etc)
  bool get canEditGranja => this == RolGranja.owner || this == RolGranja.admin;

  /// Puede eliminar la granja (solo owner)
  bool get canDeleteGranja => this == RolGranja.owner;

  /// Puede crear registros (producción, peso, consumo, mortalidad, etc)
  bool get canCreateRecords =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager ||
      this == RolGranja.operator;

  /// Puede editar registros existentes
  bool get canEditRecords =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede eliminar registros
  bool get canDeleteRecords =>
      this == RolGranja.owner || this == RolGranja.admin;

  /// Puede ver reportes y análisis
  bool get canViewReports =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager ||
      this == RolGranja.operator;

  /// Puede exportar datos (CSV, PDF, etc)
  bool get canExportData =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede listar y ver colaboradores
  bool get canListColaboradores =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede crear lotes
  bool get canCreateLotes =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede editar lotes
  bool get canEditLotes =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede eliminar lotes
  bool get canDeleteLotes => this == RolGranja.owner || this == RolGranja.admin;

  /// Puede crear galpones
  bool get canCreateGalpones =>
      this == RolGranja.owner || this == RolGranja.admin;

  /// Puede editar galpones
  bool get canEditGalpones =>
      this == RolGranja.owner || this == RolGranja.admin;

  /// Puede eliminar galpones
  bool get canDeleteGalpones =>
      this == RolGranja.owner || this == RolGranja.admin;

  /// Puede gestionar inventario
  bool get canManageInventario =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager;

  /// Puede registrar ventas
  bool get canCreateVentas =>
      this == RolGranja.owner ||
      this == RolGranja.admin ||
      this == RolGranja.manager ||
      this == RolGranja.operator;

  /// Puede ver configuración de la granja
  bool get canViewConfig => this == RolGranja.owner || this == RolGranja.admin;
}
