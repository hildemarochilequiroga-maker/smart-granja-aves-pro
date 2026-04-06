import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/value_objects/cliente.dart';
import '../../domain/value_objects/direccion.dart';
import '../../domain/enums/tipo_producto_venta.dart';
import '../../domain/enums/clasificacion_huevo.dart';
import '../../domain/enums/unidad_venta_pollinaza.dart';

/// Modelo de datos para [VentaProducto] que maneja la serialización/deserialización con Firestore
class VentaProductoModel {
  /// Convierte una entidad [VentaProducto] a un Map para Firestore
  static Map<String, dynamic> toFirestore(VentaProducto venta) {
    final Map<String, dynamic> data = {
      'loteId': venta.loteId,
      'granjaId': venta.granjaId,
      'fechaVenta': Timestamp.fromDate(venta.fechaVenta),
      'tipoProducto': venta.tipoProducto.name,
      'estado': venta.estado.name,
      'registradoPor': venta.registradoPor,
      'fechaRegistro': Timestamp.fromDate(venta.fechaRegistro),
      'cliente': _clienteToMap(venta.cliente),
      'observaciones': venta.observaciones,
      'numeroGuia': venta.numeroGuia,
      'descuentoPorcentaje': venta.descuentoPorcentaje,
    };

    // Campos específicos según tipo de producto
    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
        data.addAll({
          'cantidadAves': venta.cantidadAves,
          'pesoPromedioKg': venta.pesoPromedioKg,
          'precioKg': venta.precioKg,
          'pesajesJabas': venta.pesajesJabas
              ?.map((j) => {'cantidadAves': j.cantidadAves, 'pesoKg': j.pesoKg})
              .toList(),
        });
        break;

      case TipoProductoVenta.huevos:
        data.addAll({
          'huevosPorClasificacion': venta.huevosPorClasificacion?.map(
            (clasificacion, cantidad) => MapEntry(clasificacion.name, cantidad),
          ),
          'preciosPorDocena': venta.preciosPorDocena?.map(
            (clasificacion, precio) => MapEntry(clasificacion.name, precio),
          ),
        });
        break;

      case TipoProductoVenta.pollinaza:
        data.addAll({
          'cantidadPollinaza': venta.cantidadPollinaza,
          'unidadPollinaza': venta.unidadPollinaza?.name,
          'precioUnitarioPollinaza': venta.precioUnitarioPollinaza,
        });
        break;

      case TipoProductoVenta.avesFaenadas:
        data.addAll({
          'cantidadAves': venta.cantidadAves,
          'pesoPromedioKg': venta.pesoPromedioKg,
          'precioKg': venta.precioKg,
          'pesoVivo': venta.pesoVivo,
          'pesoFaenado': venta.pesoFaenado,
          'rendimientoCanal': venta.rendimientoCanal,
        });
        break;

      case TipoProductoVenta.avesDescarte:
        data.addAll({
          'cantidadAves': venta.cantidadAves,
          'pesoPromedioKg': venta.pesoPromedioKg,
          'precioKg': venta.precioKg,
        });
        break;
    }

    // Campos opcionales
    if (venta.fechaActualizacion != null) {
      data['fechaActualizacion'] = Timestamp.fromDate(
        venta.fechaActualizacion!,
      );
    }
    if (venta.impuestoIVA != null) {
      data['impuestoIVA'] = venta.impuestoIVA;
    }
    if (venta.numeroFactura != null) {
      data['numeroFactura'] = venta.numeroFactura;
    }
    if (venta.fechaEntrega != null) {
      data['fechaEntrega'] = Timestamp.fromDate(venta.fechaEntrega!);
    }
    if (venta.direccionEntrega != null) {
      data['direccionEntrega'] = venta.direccionEntrega;
    }
    if (venta.transportista != null) {
      data['transportista'] = venta.transportista;
    }

    return data;
  }

  /// Convierte un documento de Firestore a una entidad [VentaProducto]
  ///
  /// Lanza [StateError] si el documento no tiene datos.
  static VentaProducto fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(ErrorMessages.format('ERR_DOC_NO_DATA', {'id': doc.id}));
    }
    final tipoProducto = TipoProductoVenta.values.firstWhere(
      (t) => t.name == data['tipoProducto'],
      orElse: () => TipoProductoVenta.avesVivas,
    );

    // Crear Cliente desde el mapa
    final clienteMap = data['cliente'] as Map<String, dynamic>? ?? {};
    final direccionMap = clienteMap['direccion'] as Map<String, dynamic>? ?? {};

    final cliente = Cliente(
      nombre: clienteMap['nombre'] as String? ?? '',
      identificacion: clienteMap['identificacion'] as String? ?? '',
      contacto: clienteMap['contacto'] as String? ?? '',
      direccion: Direccion(
        calle: direccionMap['calle'] as String? ?? '',
        ciudad: direccionMap['ciudad'] as String? ?? '',
        departamento: direccionMap['departamento'] as String? ?? '',
        numero: direccionMap['numero'] as String?,
        distrito: direccionMap['distrito'] as String?,
        codigoPostal: direccionMap['codigoPostal'] as String?,
        referencia: direccionMap['referencia'] as String?,
      ),
      correo: clienteMap['correo'] as String?,
      tipoDocumento: clienteMap['tipoDocumento'] as String? ?? 'DNI',
      notas: clienteMap['notas'] as String?,
    );

    // Datos base comunes a todos los tipos
    final registradoPor = data['registradoPor'] as String;
    final descuentoPorcentaje =
        (data['descuentoPorcentaje'] as num?)?.toDouble() ?? 0.0;
    final observaciones = data['observaciones'] as String?;
    final numeroGuia = data['numeroGuia'] as String?;

    // Campos opcionales de entrega
    final fechaEntrega = data['fechaEntrega'] != null
        ? (data['fechaEntrega'] as Timestamp).toDate()
        : null;
    final direccionEntrega = data['direccionEntrega'] as String?;
    final transportista = data['transportista'] as String?;

    // Crear entidad según tipo de producto
    switch (tipoProducto) {
      case TipoProductoVenta.avesVivas:
        return VentaProducto.avesVivas(
          id: doc.id,
          loteId: data['loteId'] as String,
          granjaId: data['granjaId'] as String,
          cliente: cliente,
          cantidadAves: data['cantidadAves'] as int,
          pesoPromedioKg: (data['pesoPromedioKg'] as num).toDouble(),
          precioKg: (data['precioKg'] as num).toDouble(),
          registradoPor: registradoPor,
          pesajesJabas: (data['pesajesJabas'] as List<dynamic>?)
              ?.map(
                (j) => PesajeJaba(
                  cantidadAves: j['cantidadAves'] as int,
                  pesoKg: (j['pesoKg'] as num).toDouble(),
                ),
              )
              .toList(),
          descuentoPorcentaje: descuentoPorcentaje,
          numeroGuia: numeroGuia,
          observaciones: observaciones,
          fechaEntrega: fechaEntrega,
          direccionEntrega: direccionEntrega,
          transportista: transportista,
        );

      case TipoProductoVenta.huevos:
        final huevosMap =
            data['huevosPorClasificacion'] as Map<String, dynamic>?;
        final huevosPorClasificacion = huevosMap?.map(
          (key, value) => MapEntry(
            ClasificacionHuevo.values.firstWhere(
              (c) => c.name == key,
              orElse: () => ClasificacionHuevo.mediano,
            ),
            value as int,
          ),
        );

        final preciosMap = data['preciosPorDocena'] as Map<String, dynamic>?;
        final preciosPorDocena = preciosMap?.map(
          (key, value) => MapEntry(
            ClasificacionHuevo.values.firstWhere(
              (c) => c.name == key,
              orElse: () => ClasificacionHuevo.mediano,
            ),
            (value as num).toDouble(),
          ),
        );

        return VentaProducto.huevos(
          id: doc.id,
          loteId: data['loteId'] as String,
          granjaId: data['granjaId'] as String,
          cliente: cliente,
          huevosPorClasificacion: huevosPorClasificacion ?? {},
          preciosPorDocena: preciosPorDocena ?? {},
          registradoPor: registradoPor,
          descuentoPorcentaje: descuentoPorcentaje,
          observaciones: observaciones,
          fechaEntrega: fechaEntrega,
          direccionEntrega: direccionEntrega,
          transportista: transportista,
        );

      case TipoProductoVenta.pollinaza:
        return VentaProducto.pollinaza(
          id: doc.id,
          loteId: data['loteId'] as String,
          granjaId: data['granjaId'] as String,
          cliente: cliente,
          cantidadPollinaza: (data['cantidadPollinaza'] as num).toDouble(),
          unidadPollinaza: UnidadVentaPollinaza.values.firstWhere(
            (u) => u.name == data['unidadPollinaza'],
            orElse: () => UnidadVentaPollinaza.bulto,
          ),
          precioUnitarioPollinaza: (data['precioUnitarioPollinaza'] as num)
              .toDouble(),
          registradoPor: registradoPor,
          descuentoPorcentaje: descuentoPorcentaje,
          observaciones: observaciones,
          fechaEntrega: fechaEntrega,
          direccionEntrega: direccionEntrega,
          transportista: transportista,
        );

      case TipoProductoVenta.avesFaenadas:
        return VentaProducto.avesFaenadas(
          id: doc.id,
          loteId: data['loteId'] as String,
          granjaId: data['granjaId'] as String,
          cliente: cliente,
          cantidadAves: data['cantidadAves'] as int,
          pesoFaenado: (data['pesoFaenado'] as num?)?.toDouble() ?? 0.0,
          precioKg: (data['precioKg'] as num).toDouble(),
          registradoPor: registradoPor,
          pesoVivo: (data['pesoVivo'] as num?)?.toDouble(),
          rendimientoCanal: (data['rendimientoCanal'] as num?)?.toDouble(),
          descuentoPorcentaje: descuentoPorcentaje,
          numeroGuia: numeroGuia,
          observaciones: observaciones,
          fechaEntrega: fechaEntrega,
          direccionEntrega: direccionEntrega,
          transportista: transportista,
        );

      case TipoProductoVenta.avesDescarte:
        return VentaProducto.avesDescarte(
          id: doc.id,
          loteId: data['loteId'] as String,
          granjaId: data['granjaId'] as String,
          cliente: cliente,
          cantidadAves: data['cantidadAves'] as int,
          pesoPromedioKg: (data['pesoPromedioKg'] as num).toDouble(),
          precioKg: (data['precioKg'] as num).toDouble(),
          registradoPor: registradoPor,
          descuentoPorcentaje: descuentoPorcentaje,
          numeroGuia: numeroGuia,
          observaciones: observaciones,
          fechaEntrega: fechaEntrega,
          direccionEntrega: direccionEntrega,
          transportista: transportista,
        );
    }
  }

  /// Convierte Cliente a Map para Firestore
  static Map<String, dynamic> _clienteToMap(Cliente cliente) {
    return {
      'nombre': cliente.nombre,
      'identificacion': cliente.identificacion,
      'contacto': cliente.contacto,
      'correo': cliente.correo,
      'direccion': {
        'calle': cliente.direccion.calle,
        'numero': cliente.direccion.numero,
        'distrito': cliente.direccion.distrito,
        'ciudad': cliente.direccion.ciudad,
        'departamento': cliente.direccion.departamento,
        'codigoPostal': cliente.direccion.codigoPostal,
        'referencia': cliente.direccion.referencia,
      },
      'tipoDocumento': cliente.tipoDocumento,
      'notas': cliente.notas,
    };
  }
}
