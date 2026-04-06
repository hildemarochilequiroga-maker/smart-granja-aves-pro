/// Test helpers y factories para fixtures reutilizables.
library;

import 'package:smartgranjaavespro/features/auth/domain/entities/entities.dart';
import 'package:smartgranjaavespro/features/galpones/domain/entities/galpon.dart';
import 'package:smartgranjaavespro/features/galpones/domain/enums/enums.dart';
import 'package:smartgranjaavespro/features/granjas/domain/entities/granja.dart';
import 'package:smartgranjaavespro/features/granjas/domain/enums/enums.dart';
import 'package:smartgranjaavespro/features/granjas/domain/value_objects/value_objects.dart';
import 'package:smartgranjaavespro/features/lotes/domain/entities/lote.dart';
import 'package:smartgranjaavespro/features/lotes/domain/enums/enums.dart';
import 'package:smartgranjaavespro/features/inventario/domain/entities/item_inventario.dart';
import 'package:smartgranjaavespro/features/inventario/domain/enums/enums.dart';

// =============================================================================
// FACTORIES — Crean objetos de test con defaults sensatos
// =============================================================================

/// Crea una Granja de test con valores por defecto.
Granja crearGranjaTest({
  String id = 'granja-1',
  String nombre = 'Granja Test',
  EstadoGranja estado = EstadoGranja.activo,
  String propietarioId = 'user-1',
  String propietarioNombre = 'Juan Perez',
  String? ruc,
  String? correo,
  int? capacidadTotalAves,
  double? areaTotalM2,
  int? numeroTotalGalpones,
  String? notas,
  DateTime? ultimaActualizacion,
  Coordenadas? coordenadas,
  UmbralesAmbientales? umbralesAmbientales,
}) {
  return Granja(
    id: id,
    nombre: nombre,
    direccion: const Direccion(calle: 'Av. Test 123', ciudad: 'Lima'),
    propietarioId: propietarioId,
    propietarioNombre: propietarioNombre,
    fechaCreacion: DateTime(2024, 1, 1),
    estado: estado,
    ruc: ruc,
    correo: correo,
    capacidadTotalAves: capacidadTotalAves,
    areaTotalM2: areaTotalM2,
    numeroTotalGalpones: numeroTotalGalpones,
    notas: notas,
    ultimaActualizacion: ultimaActualizacion,
    coordenadas: coordenadas,
    umbralesAmbientales: umbralesAmbientales,
  );
}

/// Crea un Lote de test con valores por defecto.
Lote crearLoteTest({
  String id = 'lote-1',
  String granjaId = 'granja-1',
  String galponId = 'galpon-1',
  String codigo = 'LOT-001',
  TipoAve tipoAve = TipoAve.polloEngorde,
  int cantidadInicial = 1000,
  DateTime? fechaIngreso,
  EstadoLote estado = EstadoLote.activo,
  int edadIngresoDias = 0,
  int? cantidadActual,
  int mortalidadAcumulada = 0,
  int descartesAcumulados = 0,
  int ventasAcumuladas = 0,
  double? pesoPromedioActual,
  double? pesoPromedioObjetivo,
  double? consumoAcumuladoKg,
  int? huevosProducidos,
  DateTime? fechaPrimerHuevo,
  DateTime? fechaCierreEstimada,
  DateTime? fechaCierreReal,
  double? costoAveInicial,
  String? observaciones,
}) {
  return Lote(
    id: id,
    granjaId: granjaId,
    galponId: galponId,
    codigo: codigo,
    tipoAve: tipoAve,
    cantidadInicial: cantidadInicial,
    fechaIngreso:
        fechaIngreso ?? DateTime.now().subtract(const Duration(days: 20)),
    estado: estado,
    edadIngresoDias: edadIngresoDias,
    cantidadActual: cantidadActual,
    mortalidadAcumulada: mortalidadAcumulada,
    descartesAcumulados: descartesAcumulados,
    ventasAcumuladas: ventasAcumuladas,
    pesoPromedioActual: pesoPromedioActual,
    pesoPromedioObjetivo: pesoPromedioObjetivo,
    consumoAcumuladoKg: consumoAcumuladoKg,
    huevosProducidos: huevosProducidos,
    fechaPrimerHuevo: fechaPrimerHuevo,
    fechaCierreEstimada: fechaCierreEstimada,
    fechaCierreReal: fechaCierreReal,
    costoAveInicial: costoAveInicial,
    observaciones: observaciones,
    fechaCreacion: DateTime(2024, 1, 1),
  );
}

/// Crea un ItemInventario de test con valores por defecto.
ItemInventario crearItemInventarioTest({
  String id = 'item-1',
  String granjaId = 'granja-1',
  TipoItem tipo = TipoItem.alimento,
  String nombre = 'Concentrado Inicio',
  double stockActual = 100,
  double stockMinimo = 20,
  double? stockMaximo,
  UnidadMedida unidad = UnidadMedida.kilogramo,
  double? precioUnitario,
  DateTime? fechaVencimiento,
  bool activo = true,
}) {
  return ItemInventario(
    id: id,
    granjaId: granjaId,
    tipo: tipo,
    nombre: nombre,
    stockActual: stockActual,
    stockMinimo: stockMinimo,
    stockMaximo: stockMaximo,
    unidad: unidad,
    precioUnitario: precioUnitario,
    fechaVencimiento: fechaVencimiento,
    activo: activo,
    registradoPor: 'user-1',
    fechaCreacion: DateTime(2024, 1, 1),
  );
}

/// Crea un Galpon de test con valores por defecto.
Galpon crearGalponTest({
  String id = 'galpon-1',
  String granjaId = 'granja-1',
  String codigo = 'GAL-001',
  String nombre = 'Galpón Test',
  TipoGalpon tipo = TipoGalpon.engorde,
  int capacidadMaxima = 5000,
  EstadoGalpon estado = EstadoGalpon.activo,
  double? areaM2 = 500.0,
  int avesActuales = 0,
  String? loteActualId,
  DateTime? proximoMantenimiento,
  DateTime? ultimaDesinfeccion,
  List<String> lotesHistoricos = const [],
}) {
  return Galpon(
    id: id,
    granjaId: granjaId,
    codigo: codigo,
    nombre: nombre,
    tipo: tipo,
    capacidadMaxima: capacidadMaxima,
    fechaCreacion: DateTime(2024, 1, 1),
    estado: estado,
    areaM2: areaM2,
    avesActuales: avesActuales,
    loteActualId: loteActualId,
    proximoMantenimiento: proximoMantenimiento,
    ultimaDesinfeccion: ultimaDesinfeccion,
    lotesHistoricos: lotesHistoricos,
  );
}

/// Crea un Usuario de test con valores por defecto.
Usuario crearUsuarioTest({
  String id = 'user-1',
  String email = 'test@test.com',
  String? nombre = 'Juan',
  String? apellido = 'Perez',
  String? telefono,
  String? fotoUrl,
  bool emailVerificado = true,
  bool activo = true,
  AuthMethod metodoAuth = AuthMethod.email,
  List<String> proveedoresVinculados = const ['password'],
}) {
  return Usuario(
    id: id,
    email: email,
    nombre: nombre,
    apellido: apellido,
    telefono: telefono,
    fotoUrl: fotoUrl,
    emailVerificado: emailVerificado,
    activo: activo,
    metodoAuth: metodoAuth,
    proveedoresVinculados: proveedoresVinculados,
    fechaCreacion: DateTime(2024, 1, 1),
  );
}
