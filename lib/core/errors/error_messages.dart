library;

import '../utils/formatters.dart';

/// Centraliza mensajes de error localizados por código.
/// Los exceptions y failures usan este helper para obtener el mensaje
/// en el idioma activo sin necesitar BuildContext.
class ErrorMessages {
  ErrorMessages._();

  /// Retorna el mensaje localizado para el código de error dado.
  static String get(String code) {
    final msgs = _messages[Formatters.currentLocale] ?? _messages['es']!;
    return msgs[code] ?? (_messages['es']![code] ?? code);
  }

  /// Retorna el mensaje localizado con parámetros interpolados.
  /// Uso: ErrorMessages.format('CODE', {'param': 'valor'})
  /// Los placeholders en el mensaje usan formato {param}.
  static String format(String code, Map<String, String> params) {
    var msg = get(code);
    for (final entry in params.entries) {
      msg = msg.replaceAll('{${entry.key}}', entry.value);
    }
    return msg;
  }

  static const _messages = <String, Map<String, String>>{
    'es': {
      // Server
      'SERVER_ERROR': 'Error del servidor',
      'SERVER_ERROR_400': 'Solicitud incorrecta',
      'SERVER_ERROR_401': 'No autorizado',
      'SERVER_ERROR_403': 'Acceso denegado',
      'SERVER_ERROR_404': 'Recurso no encontrado',
      'SERVER_ERROR_409': 'Conflicto en la solicitud',
      'SERVER_ERROR_422': 'Datos no procesables',
      'SERVER_ERROR_429': 'Demasiadas solicitudes',
      'SERVER_ERROR_500': 'Error interno del servidor',
      'SERVER_ERROR_502': 'Error de conexión',
      'SERVER_ERROR_503': 'Servicio no disponible',
      'SERVER_ERROR_504': 'Tiempo de espera agotado',
      'SSL_ERROR': 'Error de certificado SSL',
      'NOT_FOUND': 'Documento no encontrado',
      'ALREADY_EXISTS': 'El documento ya existe',
      'GENERIC_SERVER_ERROR': 'Error en la operación',

      // Cache
      'CACHE_NOT_FOUND': 'Dato no encontrado en cache',
      'CACHE_EXPIRED': 'Dato expirado en cache',
      'CACHE_WRITE_ERROR': 'Error al escribir en cache',

      // Network
      'NO_CONNECTION': 'Sin conexión a internet',
      'TIMEOUT': 'Tiempo de espera agotado',
      'CANCELLED': 'Solicitud cancelada',
      'SERVICE_UNAVAILABLE': 'Servicio no disponible',

      // Auth
      'INVALID_CREDENTIALS': 'Credenciales inválidas',
      'USER_NOT_FOUND': 'Usuario no encontrado',
      'EMAIL_ALREADY_IN_USE': 'El correo ya está en uso',
      'WEAK_PASSWORD': 'La contraseña es muy débil',
      'SESSION_EXPIRED': 'Tu sesión ha expirado',
      'NO_SESSION': 'No hay sesión activa',
      'UNAUTHORIZED': 'No tienes permiso para realizar esta acción',
      'EMAIL_NOT_VERIFIED': 'Verifica tu correo electrónico',
      'INVALID_EMAIL': 'Correo electrónico inválido',
      'USER_DISABLED': 'Usuario deshabilitado',
      'TOO_MANY_REQUESTS': 'Demasiados intentos. Intenta más tarde',
      'AUTH_ERROR': 'Error de autenticación',
      'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          'Ya existe una cuenta con este email',

      // Validation
      'FORMAT_ERROR': 'Error de formato',
      'FIELD_REQUIRED': 'El campo {field} es requerido',
      'FIELD_INVALID': 'El campo {field} es inválido',

      // Firebase
      'FIREBASE_PERMISSION_DENIED':
          'No tienes permiso para realizar esta acción',
      'FIREBASE_UNAVAILABLE': 'Servicio no disponible',
      'FIREBASE_CANCELLED': 'Operación cancelada',
      'FIREBASE_DEADLINE_EXCEEDED': 'Tiempo de espera agotado',
      'FIREBASE_NOT_FOUND': 'Documento no encontrado',
      'FIREBASE_ALREADY_EXISTS': 'El documento ya existe',
      'FIREBASE_ERROR': 'Error de Firebase',

      // Unknown
      'UNKNOWN': 'Ha ocurrido un error inesperado',
      'STORAGE_QUOTA_EXCEEDED': 'Espacio de almacenamiento agotado',

      // Venta validation
      'VENTA_SELECT_LOTE': 'Debe seleccionar un lote',
      'VENTA_SELECT_GRANJA': 'Debe seleccionar una granja',
      'VENTA_SELECT_CLIENTE': 'Debe especificar un cliente',
      'VENTA_AVES_GREATER_ZERO': 'La cantidad de aves debe ser mayor a 0',
      'VENTA_PRECIO_KG_GREATER_ZERO': 'El precio por kg debe ser mayor a 0',
      'VENTA_PESO_FAENADO_GREATER_ZERO': 'El peso faenado debe ser mayor a 0',
      'VENTA_HUEVOS_CLASIFICACION':
          'Debe especificar al menos una clasificación de huevos',
      'VENTA_HUEVOS_PRECIOS':
          'Debe especificar precios para las clasificaciones',
      'VENTA_HUEVOS_TOTAL_GREATER_ZERO':
          'La cantidad total de huevos debe ser mayor a 0',
      'VENTA_POLLINAZA_GREATER_ZERO':
          'La cantidad de pollinaza debe ser mayor a 0',
      'VENTA_PRECIO_UNITARIO_GREATER_ZERO':
          'El precio unitario debe ser mayor a 0',
      'VENTA_NOT_EXISTS': 'La venta no existe',
      'VENTA_CANNOT_MODIFY': 'No se puede modificar una venta {estado}',
      'VENTA_LOTE_ID_REQUIRED': 'El ID del lote es requerido',
      'VENTA_ID_REQUIRED': 'El ID de la venta es requerido',
      'VENTA_CANNOT_DELETE_COMPLETED':
          'No se puede eliminar una venta completada',
      'VENTA_PESO_PROMEDIO_GREATER_ZERO': 'Peso promedio debe ser mayor a 0',

      // Costo validation
      'COSTO_SELECT_GRANJA': 'Debe seleccionar una granja',
      'COSTO_CONCEPTO_REQUIRED': 'El concepto no puede estar vacío',
      'COSTO_MONTO_GREATER_ZERO': 'El monto debe ser mayor a 0',
      'COSTO_REGISTRADO_POR_REQUIRED':
          'Debe especificar quién registra el costo',
      'COSTO_LOTE_ID_REQUIRED': 'El ID del lote es requerido',
      'COSTO_ID_REQUIRED': 'El ID del costo es requerido',
      'COSTO_APROBADOR_REQUIRED': 'Debe especificar quién aprueba',
      'COSTO_NOT_FOUND': 'Costo no encontrado',
      'COSTO_MOTIVO_RECHAZO_REQUIRED': 'Debe especificar el motivo del rechazo',
      'COSTO_GRANJA_ID_REQUIRED': 'El ID de la granja es requerido',
      'COSTO_FECHA_RANGO_INVALIDO':
          'La fecha inicial no puede ser posterior a la final',

      // Granja validation
      'GRANJA_ID_REQUIRED': 'El ID de la granja es obligatorio',
      'GRANJA_NOMBRE_REQUIRED': 'El nombre de la granja es obligatorio',
      'GRANJA_NOMBRE_MIN_LENGTH': 'El nombre debe tener al menos 3 caracteres',
      'GRANJA_PROPIETARIO_REQUIRED': 'El propietario es obligatorio',
      'GRANJA_RUC_INVALID': 'RUC inválido (debe tener 11 dígitos numéricos)',
      'GRANJA_EMAIL_INVALID': 'Correo electrónico inválido',
      'GRANJA_CAPACIDAD_NEGATIVE': 'La capacidad no puede ser negativa',
      'GRANJA_AREA_POSITIVE': 'El área debe ser positiva',
      'GRANJA_GALPONES_NEGATIVE': 'El número de galpones no puede ser negativo',

      // Cliente validation
      'CLIENTE_NOMBRE_REQUIRED': 'El nombre del cliente es obligatorio',
      'CLIENTE_NOMBRE_MIN_LENGTH': 'El nombre debe tener al menos 3 caracteres',
      'CLIENTE_ID_REQUIRED': 'La identificación del cliente es obligatoria',
      'CLIENTE_DNI_FORMAT': 'DNI debe tener 8 dígitos',
      'CLIENTE_RUC_FORMAT': 'RUC debe tener 11 dígitos',
      'CLIENTE_CONTACTO_REQUIRED': 'El contacto del cliente es obligatorio',
      'CLIENTE_CONTACTO_MIN_LENGTH':
          'El contacto debe tener al menos 6 caracteres',
      'CLIENTE_EMAIL_INVALID': 'El formato del correo electrónico es inválido',

      // Lote validation
      'LOTE_GRANJA_ID_REQUIRED': 'El ID de la granja es obligatorio',
      'LOTE_GALPON_ID_REQUIRED': 'El ID del galpón es obligatorio',
      'LOTE_CODIGO_REQUIRED': 'El código del lote es obligatorio',
      'LOTE_CANTIDAD_POSITIVE': 'La cantidad inicial debe ser positiva',
      'LOTE_EDAD_NEGATIVE': 'La edad de ingreso no puede ser negativa',
      'LOTE_MORTALIDAD_NEGATIVE': 'La mortalidad no puede ser negativa',
      'LOTE_DESCARTES_NEGATIVE': 'Los descartes no pueden ser negativos',
      'LOTE_VENTAS_NEGATIVE': 'Las ventas no pueden ser negativas',
      'LOTE_BAJAS_EXCEDEN': 'Las bajas superan la cantidad inicial',
      'LOTE_PESO_POSITIVE': 'El peso promedio debe ser positivo',
      'LOTE_COSTO_NEGATIVE': 'El costo por ave no puede ser negativo',
      'LOTE_CANTIDAD_DEBE_POSITIVA': 'La cantidad debe ser positiva',
      'LOTE_NO_PERMITE_REGISTROS':
          'El lote no permite registros en estado {estado}',
      'LOTE_AVES_INSUFICIENTES':
          'No hay suficientes aves ({disponibles} disponibles)',
      'LOTE_PESO_DEBE_POSITIVO': 'El peso debe ser positivo',
      'LOTE_CONSUMO_NO_PERMITIDO':
          'No se puede registrar consumo en un lote {estado}',
      'LOTE_SOLO_POSTURA': 'Solo los lotes de postura pueden registrar huevos',
      'LOTE_PRODUCCION_NO_PERMITIDA':
          'No se puede registrar producción en un lote {estado}',
      'LOTE_CAMBIO_ESTADO_INVALIDO':
          'No se puede cambiar de {estadoActual} a {estadoNuevo}',
      'LOTE_CIERRE_NORMAL': 'Cierre normal',
      'LOTE_YA_EN_GALPON': 'El lote ya está en ese galpón',

      // Galpón validation
      'GALPON_GRANJA_ID_REQUIRED': 'El ID de la granja es obligatorio',
      'GALPON_CODIGO_REQUIRED': 'El código de galpón es obligatorio',
      'GALPON_NOMBRE_REQUIRED': 'El nombre del galpón es obligatorio',
      'GALPON_CAPACIDAD_POSITIVE': 'La capacidad debe ser positiva',
      'GALPON_AREA_POSITIVE': 'El área debe ser positiva',
      'GALPON_AVES_NEGATIVE': 'La cantidad de aves no puede ser negativa',
      'GALPON_AVES_EXCEDE_CAPACIDAD':
          'La cantidad de aves excede la capacidad máxima',
      'GALPON_DENSIDAD_EXCEDE':
          'Densidad excede el límite recomendado para {tipo}',
      'GALPON_ESTADO_REQUIERE_VACIO':
          'Estado {estado} requiere que el galpón esté vacío',
      'GALPON_CAMBIO_ESTADO_INVALIDO':
          'No se puede cambiar de {estadoActual} a {estadoNuevo}',
      'GALPON_CAMBIO_CON_LOTE_ACTIVO':
          'No se puede cambiar a {estadoNuevo} con un lote activo',
      'GALPON_DESINFECTAR_CON_LOTE':
          'No se puede desinfectar un galpón con lote activo',
      'GALPON_NO_DISPONIBLE':
          'El galpón no está disponible para recibir un lote',
      'GALPON_CAPACIDAD_DEBE_POSITIVA':
          'La cantidad excede la capacidad máxima',

      // Common prefixes
      'PREFIX_DIRECCION': 'Dirección: {detail}',
      'PREFIX_COORDENADAS': 'Coordenadas: {detail}',
      'PREFIX_UMBRALES': 'Umbrales: {detail}',
      'LOTE_VENDIDO_A': 'Vendido a: {comprador}',
      'LOTE_VENDIDO': 'Vendido',

      // Bird type descriptions (fallback for non-UI contexts)
      'BIRD_TYPE_BROILER_DESC': 'Aves criadas para producción de carne',
      'BIRD_TYPE_LAYER_DESC': 'Aves criadas para producción de huevos',
      'BIRD_TYPE_HEAVY_BREEDER_DESC': 'Aves reproductoras de línea pesada',
      'BIRD_TYPE_LIGHT_BREEDER_DESC': 'Aves reproductoras de línea liviana',
      'BIRD_TYPE_TURKEY_DESC': 'Pavos para carne',
      'BIRD_TYPE_QUAIL_DESC': 'Codornices para huevos o carne',
      'BIRD_TYPE_DUCK_DESC': 'Patos para carne',
      'BIRD_TYPE_OTHER_DESC': 'Otro tipo de ave',
      'NOT_RECORDED': 'No registrado',
      'COMMON_BIRDS': 'aves',
      'NOT_SPECIFIED': 'No especificada',
      'DATE_TODAY': 'Hoy',
      'DATE_YESTERDAY': 'Ayer',
      'DATE_DAYS_AGO': 'Hace {count} días',
      'DATE_WEEKS_AGO': 'Hace {count} {unit}',
      'DATE_MONTHS_AGO': 'Hace {count} {unit}',
      'DATE_YEARS_AGO': 'Hace {count} {unit}',
      'UNIT_WEEK': 'semana',
      'UNIT_WEEKS': 'semanas',
      'UNIT_MONTH': 'mes',
      'UNIT_MONTHS': 'meses',
      'UNIT_YEAR': 'año',
      'UNIT_YEARS': 'años',

      // Granja business methods
      'GRANJA_YA_ACTIVA': 'La granja ya está activa',
      'GRANJA_SOLO_SUSPENDER_ACTIVA':
          'Solo se puede suspender una granja activa',
      'GRANJA_SOLO_MANTENIMIENTO_ACTIVA':
          'Solo se puede poner en mantenimiento una granja activa',

      // CostoGasto entity
      'COSTO_CONCEPTO_VACIO': 'El concepto no puede estar vacío',
      'COSTO_MONTO_MAYOR_CERO': 'El monto debe ser mayor a 0',
      'COSTO_AVES_MAYOR_CERO': 'Cantidad de aves debe ser mayor a 0',
      'COSTO_NO_REQUIERE_APROBACION': 'Este gasto no requiere aprobación',
      'COSTO_YA_APROBADO': 'Este gasto ya está aprobado',
      'COSTO_MOTIVO_RECHAZO_VACIO': 'Debe proporcionar un motivo de rechazo',

      // Salud entities
      'SALUD_DIAGNOSTICO_VACIO': 'El diagnóstico no puede estar vacío',
      'SALUD_REGISTRO_CERRADO': 'El registro ya está cerrado',
      'VACUNA_NOMBRE_VACIO': 'El nombre de la vacuna no puede estar vacío',
      'VACUNA_YA_APLICADA': 'La vacuna ya fue aplicada',

      // Lotes usecases
      'LOTE_YA_CERRADO': 'El lote ya está cerrado',
      'LOTE_YA_VENDIDO_UC': 'El lote ya fue vendido',
      'LOTE_FECHA_CIERRE_ANTERIOR_INGRESO':
          'La fecha de cierre no puede ser anterior a la fecha de ingreso',
      'LOTE_FECHA_CIERRE_FUTURA': 'La fecha de cierre no puede ser futura',
      'LOTE_ACTIVO_EN_GALPON': 'Ya existe un lote activo en este galpón',
      'LOTE_PESO_MAYOR_CERO': 'El peso promedio debe ser mayor a 0',
      'LOTE_NO_ELIMINAR_ACTIVO':
          'No se puede eliminar un lote activo. Primero ciérrelo.',
      'LOTE_CANTIDAD_MINIMA': 'La cantidad inicial debe ser al menos 10 aves',

      // Galpones usecases
      'GALPON_SIN_LOTE': 'El galpón no tiene ningún lote asignado.',
      'GALPON_CON_LOTE_NO_ELIMINAR':
          'No se puede eliminar un galpón con un lote asignado. Primero debe liberar el lote.',
      'GALPON_EN_CUARENTENA_NO_ELIMINAR':
          'No se puede eliminar un galpón en cuarentena. Primero debe salir de cuarentena.',
      'GALPON_EN_PROCESO_CONFIRMAR':
          'El galpón está en {estado}. ¿Está seguro de eliminarlo?',
      'GALPON_CODIGO_DUPLICADO':
          'Ya existe un galpón con ese código en esta granja',
      'GALPON_NOMBRE_DUPLICADO':
          'Ya existe un galpón con ese nombre en esta granja',
      'GALPON_TRANSICION_INVALIDA':
          'No se puede cambiar de {estadoActual} a {estadoNuevo}',
      'GALPON_MOTIVO_CUARENTENA': 'Debe especificar el motivo de la cuarentena',
      'GALPON_CON_LOTE_CONTINUAR':
          'El galpón tiene un lote asignado. ¿Desea continuar?',
      'GALPON_INACTIVAR_CON_LOTE':
          'No se puede inactivar un galpón con lote asignado. Primero libere el lote.',
      'GALPON_ACTIVO_PARA_LOTE':
          'El galpón debe estar activo para asignar un lote. Estado actual: {estado}',
      'GALPON_LOTE_YA_ASIGNADO':
          'El galpón ya tiene un lote asignado. Primero debe liberar el lote actual.',
      'GALPON_DESINFECCION_TRANSICION':
          'No se puede registrar desinfección desde el estado {estado}',
      'GALPON_DESINFECCION_CON_LOTE':
          'El galpón tiene un lote asignado. La desinfección debe realizarse sin animales presentes.',
      'GALPON_DESINFECCION_PRODUCTOS':
          'Debe especificar al menos un producto de desinfección',
      'GALPON_MANTENIMIENTO_TRANSICION':
          'No se puede programar mantenimiento desde el estado {estado}',
      'GALPON_MANTENIMIENTO_CON_LOTE':
          'El galpón tiene un lote asignado. Se recomienda liberar el lote antes del mantenimiento.',
      'GALPON_MANTENIMIENTO_FECHA_FUTURA': 'La fecha de inicio debe ser futura',
      'GALPON_MANTENIMIENTO_DESCRIPCION':
          'Debe especificar una descripción del mantenimiento',

      // Granjas usecases
      'GRANJA_NO_ENCONTRADA': 'La granja no existe',
      'GRANJA_NOMBRE_DUPLICADO': 'Ya existe una granja con ese nombre',
      'GRANJA_ACTIVA_NO_ELIMINAR':
          'No se puede eliminar una granja activa. Primero suspéndala.',
      'GRANJA_CON_GALPONES_ACTIVOS':
          'No se puede eliminar la granja porque tiene galpones activos.',
      'GRANJA_CON_LOTES_ACTIVOS':
          'No se puede eliminar la granja porque tiene lotes activos.',

      // Salud usecases
      'VACUNACION_NO_ENCONTRADA': 'La vacunación no existe',
      'VACUNA_EDAD_OBLIGATORIA':
          'La edad de aplicación es obligatoria y debe ser mayor a 0',
      'VACUNA_DOSIS_OBLIGATORIA': 'La dosis es obligatoria',
      'VACUNA_VIA_OBLIGATORIA': 'La vía de aplicación es obligatoria',

      // ServerFailure prefix
      'ERROR_REGISTRAR_COSTO': 'Error al registrar costo',
      'ERROR_ACTUALIZAR_LOTE': 'Error al actualizar lote',
      'ERROR_CERRAR_LOTE': 'Error al cerrar el lote',
      'ERROR_ELIMINAR_LOTE': 'Error al eliminar el lote',
      'ERROR_REGISTRAR_CONSUMO': 'Error al registrar consumo',
      'ERROR_REGISTRAR_PESO': 'Error al registrar peso',
      'ERROR_ACTUALIZAR_GALPON': 'Error al actualizar galpón',
      'ERROR_ASIGNAR_LOTE': 'Error al asignar lote',
      'ERROR_CAMBIAR_ESTADO': 'Error al cambiar estado',
      'ERROR_CREAR_GALPON': 'Error al crear galpón',
      'ERROR_ELIMINAR_GALPON': 'Error al eliminar galpón',
      'ERROR_LIBERAR_GALPON': 'Error al liberar galpón',
      'ERROR_OBTENER_GALPONES': 'Error al obtener galpones',
      'ERROR_REGISTRAR_DESINFECCION': 'Error al registrar desinfección',
      'ERROR_PROGRAMAR_MANTENIMIENTO': 'Error al programar mantenimiento',
      'ERROR_ACTIVAR_GRANJA': 'Error al activar granja',
      'ERROR_BUSCAR_GRANJAS': 'Error al buscar granjas',
      'ERROR_CREAR_GRANJA': 'Error al crear granja',
      'ERROR_OBTENER_DASHBOARD': 'Error al obtener dashboard',
      'ERROR_SUSPENDER_GRANJA': 'Error al suspender granja',
      'ERROR_ACTUALIZAR_GRANJA': 'Error inesperado al actualizar granja',
      'ERROR_ELIMINAR_GRANJA': 'Error inesperado al eliminar granja',
      'ERROR_APLICAR_VACUNA': 'Error al aplicar vacuna',

      // Lotes usecases - registrar pesos
      'LOTE_NO_REGISTRAR_PESO':
          'No se pueden registrar pesos en un lote {estado}',

      // Lotes usecases - additional
      'ERROR_CREAR_LOTE_UC': 'Error inesperado al crear el lote: {detail}',
      'ERROR_OBTENER_ESTADISTICAS': 'Error al obtener estadísticas: {detail}',
      'ERROR_OBTENER_DISPONIBLES':
          'Error al obtener galpones disponibles: {detail}',
      'ERROR_MANTENIMIENTO_GRANJA':
          'Error al poner granja en mantenimiento: {detail}',
      'ERROR_REGISTRAR_MORTALIDAD':
          'Error inesperado al registrar mortalidad: {detail}',
      'ERROR_REGISTRAR_PRODUCCION': 'Error al registrar producción: {detail}',
      'LOTE_NO_EDITAR_CERRADO_VENDIDO':
          'No se puede editar un lote cerrado o vendido',
      'LOTE_NO_REGISTRAR_CONSUMO_UC':
          'No se puede registrar consumo en un lote {estado}',
      'LOTE_CANTIDAD_ALIMENTO_MAYOR_CERO':
          'La cantidad de alimento debe ser mayor a 0',
      'LOTE_NO_REGISTRAR_MORTALIDAD_UC':
          'No se puede registrar mortalidad en un lote con estado {estado}',
      'LOTE_MORTALIDAD_MAYOR_CERO':
          'La cantidad de aves muertas debe ser mayor a 0',
      'LOTE_MORTALIDAD_EXCEDE_CANTIDAD':
          'La cantidad de aves muertas ({cantidad}) excede la cantidad actual del lote ({cantidadActual})',
      'LOTE_SOLO_PONEDORAS_PRODUCCION':
          'Solo los lotes de ponedoras pueden registrar producción de huevos',
      'LOTE_NO_REGISTRAR_PRODUCCION_UC':
          'No se puede registrar producción en un lote {estado}',
      'LOTE_HUEVOS_MAYOR_CERO': 'La cantidad de huevos debe ser mayor a 0',
      'REGISTRO_SALUD_NO_ENCONTRADO': 'El registro de salud no existe',

      // Value objects - lote_finanzas
      'LOTE_FINANZAS_YA_CERRADO': 'El lote ya está cerrado',
      'LOTE_FINANZAS_YA_VENDIDO': 'El lote ya fue vendido',

      // Value objects - lote_produccion
      'LOTE_PROD_PESO_POSITIVO': 'El peso debe ser positivo',
      'LOTE_PROD_CONSUMO_POSITIVO': 'La cantidad de consumo debe ser positiva',
      'LOTE_PROD_HUEVOS_POSITIVO': 'La cantidad de huevos debe ser positiva',

      // Value objects - lote_estadisticas
      'LOTE_EST_MORTALIDAD_POSITIVA':
          'La cantidad de mortalidad debe ser positiva',
      'LOTE_EST_MORTALIDAD_EXCEDE':
          'La cantidad de mortalidad ({cantidad}) no puede exceder la cantidad actual ({cantidadActual})',

      // Entity validation - common
      'VAL_LOTE_ID_REQUIRED': 'El ID del lote es obligatorio',
      'VAL_GRANJA_ID_REQUIRED': 'El ID de la granja es obligatorio',
      'VAL_GALPON_ID_REQUIRED': 'El ID del galpón es obligatorio',
      'VAL_EDAD_NEGATIVA': 'La edad no puede ser negativa',

      // Entity validation - registro_peso
      'REG_PESO_PROMEDIO_MAYOR_CERO': 'El peso promedio debe ser mayor a 0',
      'REG_PESO_AVES_MINIMA': 'Debe pesar al menos 1 ave',
      'REG_PESO_TOTAL_MAYOR_CERO': 'El peso total debe ser mayor a 0',
      'REG_PESO_MINIMO_MAYOR_CERO': 'El peso mínimo debe ser mayor a 0',
      'REG_PESO_MAX_MAYOR_MIN': 'El peso máximo debe ser >= peso mínimo',
      'REG_PESO_MAX_FOTOS': 'Máximo 3 fotos por registro',

      // Entity validation - registro_produccion
      'REG_PROD_HUEVOS_NO_NEGATIVO':
          'Los huevos recolectados no pueden ser negativos',
      'REG_PROD_BUENOS_NO_NEGATIVO':
          'Los huevos buenos no pueden ser negativos',
      'REG_PROD_BUENOS_NO_SUPERAR':
          'Los huevos buenos no pueden superar los recolectados',
      'REG_PROD_AVES_MAYOR_CERO': 'La cantidad de aves debe ser mayor a 0',
      'REG_PROD_MAX_FOTOS': 'Máximo 3 fotos por registro',
      'REG_PROD_PESO_POSITIVO': 'El peso promedio debe ser positivo',

      // Entity validation - registro_consumo
      'REG_CONSUMO_CANTIDAD_MAYOR_CERO': 'La cantidad debe ser mayor a 0',
      'REG_CONSUMO_AVES_MINIMA': 'Debe haber al menos 1 ave',
      'REG_CONSUMO_COSTO_NO_NEGATIVO': 'El costo no puede ser negativo',
      'REG_CONSUMO_USUARIO_REQUIRED': 'El usuario registrador es obligatorio',
      'REG_CONSUMO_NOMBRE_REQUIRED': 'El nombre del usuario es obligatorio',
      'REG_CONSUMO_FECHA_NO_FUTURA': 'La fecha no puede ser futura',

      // Entity validation - registro_mortalidad
      'REG_MORT_CANTIDAD_MAYOR_CERO': 'La cantidad debe ser mayor a 0',
      'REG_MORT_DESCRIPCION_MIN':
          'La descripción debe tener al menos 10 caracteres',
      'REG_MORT_MAX_FOTOS': 'Máximo 5 fotos por registro',
      'REG_MORT_CANTIDAD_EVENTO_INVALIDA':
          'La cantidad antes del evento inválida',
      'REG_MORT_EXCEDE_DISPONIBLES':
          'La cantidad no puede exceder las aves disponibles',

      // Value objects - direccion
      'DIR_CALLE_REQUIRED': 'La calle es obligatoria',
      'DIR_CALLE_MIN_LENGTH': 'La calle debe tener al menos 3 caracteres',
      'DIR_CIUDAD_REQUIRED': 'La ciudad es obligatoria',
      'DIR_DEPARTAMENTO_REQUIRED': 'El departamento es obligatorio',

      // Value objects - umbrales_ambientales
      'UMBRAL_TEMP_MIN_MAYOR_MAX':
          'La temperatura mínima debe ser menor que la máxima',
      'UMBRAL_HUM_MIN_MAYOR_MAX':
          'La humedad mínima debe ser menor que la máxima',
      'UMBRAL_HUM_RANGO': 'La humedad debe estar entre 0 y 100%',
      'UMBRAL_AMONIACO_NEGATIVO': 'El nivel de amoníaco no puede ser negativo',
      'UMBRAL_CO2_NEGATIVO': 'El nivel de CO2 no puede ser negativo',

      // Salud usecases - tratamiento
      'SALUD_DIAGNOSTICO_OBLIGATORIO': 'El diagnóstico es obligatorio',
      'SALUD_TRATAMIENTO_OBLIGATORIO': 'El tratamiento es obligatorio',
      'SALUD_FECHA_NO_FUTURA': 'La fecha de registro no puede ser futura',
      'ERROR_REGISTRAR_TRATAMIENTO': 'Error al registrar tratamiento: {detail}',

      // Salud usecases - vacunación
      'VACUNA_NOMBRE_OBLIGATORIO': 'El nombre de la vacuna es obligatorio',
      'ERROR_PROGRAMAR_VACUNACION': 'Error al programar vacunación: {detail}',

      // Salud usecases - cerrar registro
      'ERROR_CERRAR_REGISTRO_SALUD':
          'Error al cerrar registro de salud: {detail}',

      // Galpones - actualizar duplicados
      'GALPON_CODIGO_DUPLICADO_ACTUALIZAR':
          'Ya existe un galpón con ese código',
      'GALPON_NOMBRE_DUPLICADO_ACTUALIZAR':
          'Ya existe un galpón con ese nombre',

      // Granjas - dashboard
      'GRANJA_NO_ENCONTRADA_DASHBOARD': 'La granja no existe',

      // Value objects - coordenadas
      'COORD_LATITUD_RANGO': 'Latitud debe estar entre -90 y 90',
      'COORD_LONGITUD_RANGO': 'Longitud debe estar entre -180 y 180',

      // Value objects - location phone validation
      'PHONE_START_VENEZUELA': 'El teléfono debe comenzar con 4 o 2',
      'PHONE_START_COLOMBIA': 'El teléfono debe comenzar con 3',
      'PHONE_START_ARGENTINA': 'El teléfono debe comenzar con 1, 2 o 3',
      'PHONE_START_BOLIVIA': 'El teléfono debe comenzar con 6 o 7',
      'PHONE_START_DEFAULT': 'El teléfono debe comenzar con 9',

      // Enum fromJson errors
      'ENUM_INVALID_TIPO_GALPON': 'TipoGalpon inválido: {value}',
      'ENUM_INVALID_ESTADO_GALPON': 'EstadoGalpon inválido: {value}',
      'ENUM_INVALID_ESTADO_GRANJA': 'EstadoGranja inválido: {value}',
      'ENUM_INVALID_CAUSA_MORTALIDAD': 'CausaMortalidad inválido: {value}',

      // Inventario - movimiento asserts
      'MOVIMIENTO_TIPO_ENTRADA': 'El tipo debe ser una entrada',
      'MOVIMIENTO_TIPO_SALIDA': 'El tipo debe ser una salida',

      // Domain data - enfermedad_avicola
      'ENF_NO_ESPECIFICADO': 'No especificado',
      'ENF_CONSULTAR_VETERINARIO': 'Consultar veterinario',
      'ENF_NO_CONTAGIOSA': 'No contagiosa',
      'ENF_DIAG_VIRAL': 'PCR, ELISA, Aislamiento viral',
      'ENF_DIAG_BACTERIANA': 'Cultivo bacteriano, Antibiograma',
      'ENF_DIAG_PARASITARIA': 'Examen coprológico, Necropsia',
      'ENF_DIAG_FUNGICA': 'Cultivo micológico, Histopatología',
      'ENF_DIAG_NUTRICIONAL': 'Análisis de alimento, Evaluación clínica',
      'ENF_DIAG_METABOLICA': 'Análisis bioquímico, Histopatología',
      'ENF_DIAG_AMBIENTAL': 'Evaluación ambiental, Análisis de agua',
      'ENF_TRANS_VIRAL': 'Aerosol, contacto directo, fómites',
      'ENF_TRANS_BACTERIANA': 'Contacto directo, agua, alimento contaminado',
      'ENF_TRANS_PARASITARIA': 'Oral-fecal, vectores intermediarios',
      'ENF_TRANS_FUNGICA': 'Inhalación de esporas, cama contaminada',
      'ENF_TRANS_DEFAULT': 'Variable según condiciones',

      // Auth loading messages
      'AUTH_LOADING_LOGIN': 'Iniciando sesión...',
      'AUTH_LOADING_GOOGLE': 'Conectando con Google...',
      'AUTH_LOADING_APPLE': 'Conectando con Apple...',
      'AUTH_LOADING_REGISTER': 'Creando cuenta...',
      'AUTH_LOADING_LOGOUT': 'Cerrando sesión...',
      'AUTH_LOADING_EMAIL': 'Enviando email...',
      'AUTH_LOADING_PASSWORD': 'Cambiando contraseña...',
      'AUTH_LOADING_PROFILE': 'Actualizando perfil...',
      'AUTH_LOADING_VERIFYING': 'Verificando identidad...',
      'AUTH_LOADING_LINKING': 'Vinculando cuenta de {provider}...',
      'AUTH_SESSION_CLOSED': 'Sesión cerrada',
      'AUTH_NO_PENDING_CREDENTIAL': 'No hay credencial pendiente para vincular',
      'AUTH_PASSWORD_UPDATED': 'Contraseña actualizada correctamente',
      'AUTH_USER_NOT_AUTHENTICATED': 'Usuario no autenticado',

      // Galpon form validation
      'GALPON_FORM_CODIGO_REQUERIDO': 'El código es requerido',
      'GALPON_FORM_CODIGO_MIN': 'El código debe tener al menos 2 caracteres',
      'GALPON_FORM_NOMBRE_REQUERIDO': 'El nombre es requerido',
      'GALPON_FORM_NOMBRE_MIN': 'El nombre debe tener al menos 3 caracteres',
      'GALPON_FORM_TIPO_REQUERIDO': 'El tipo es requerido',
      'GALPON_FORM_CAPACIDAD_POSITIVA': 'La capacidad debe ser mayor a 0',

      // Router errors
      'ROUTER_INVITATION_NOT_FOUND': 'Datos de invitación no encontrados',
      'ROUTER_BATCH_INFO_MISSING': 'No se proporcionó información del lote',

      // Permissions
      'PERM_NO_CHANGE_ROLE': 'No tienes permisos para cambiar roles',
      'PERM_NO_ASSIGN_OWNER': 'No se puede asignar el rol de propietario',
      'PERM_NO_REMOVE_USER': 'No tienes permisos para remover usuarios',

      // Costos provider
      'COSTO_REGISTRADO_OK': 'Gasto registrado exitosamente',
      'COSTO_ACTUALIZADO_OK': 'Gasto actualizado exitosamente',
      'COSTO_ELIMINADO_OK': 'Gasto eliminado exitosamente',
      'ERROR_ACTUALIZAR_COSTO': 'Error al actualizar gasto',
      'ERROR_ELIMINAR_COSTO': 'Error al eliminar gasto',
      'COSTO_APROBADO_OK': 'Gasto aprobado exitosamente',
      'COSTO_RECHAZADO_OK': 'Gasto rechazado',

      // Ventas provider
      'VENTA_REGISTRADA_OK': 'Venta registrada exitosamente',
      'VENTA_ACTUALIZADA_OK': 'Venta actualizada exitosamente',
      'VENTA_ELIMINADA_OK': 'Venta eliminada exitosamente',

      // Actividades recientes - títulos
      'ACT_PRODUCCION_REGISTRADA': 'Producción registrada',
      'ACT_MORTALIDAD_REGISTRADA': 'Mortalidad registrada',
      'ACT_CONSUMO_REGISTRADO': 'Consumo registrado',
      'ACT_PESAJE_REGISTRADO': 'Pesaje registrado',
      'ACT_GASTO_REGISTRADO': 'Gasto registrado',
      'ACT_VENTA_REGISTRADA': 'Venta registrada',
      'ACT_REGISTRO_SALUD': 'Registro de salud',
      'ACT_VACUNACION_APLICADA': 'Vacunación aplicada',
      'ACT_VACUNACION_PROGRAMADA': 'Vacunación programada',
      'ACT_NUEVO_LOTE': 'Nuevo lote',
      'ACT_NECROPSIA_REALIZADA': 'Necropsia realizada',
      'ACT_INSPECCION_BIOSEGURIDAD': 'Inspección bioseguridad',

      // Actividades recientes - subtítulos con formato
      'ACT_SUB_HUEVOS': '{count} huevos',
      'ACT_SUB_AVES': '{count} aves',
      'ACT_SUB_PROMEDIO': '{peso}g promedio',
      'ACT_SUB_LOTE_DETALLE': '{codigo} • {cantidad} aves',
      'ACT_SUB_NECROPSIA': '{numAves} aves • {diagnostico}',
      'ACT_SUB_PUNTAJE': 'Puntaje: {puntaje}% • {inspector}',

      // Actividades recientes - venta tipo labels
      'ACT_VENTA_AVES_VIVAS': 'Aves vivas',
      'ACT_VENTA_AVES_FAENADAS': 'Aves faenadas',
      'ACT_VENTA_AVES_DESCARTE': 'Aves descarte',
      'ACT_VENTA_HUEVOS': 'Huevos',
      'ACT_VENTA_POLLINAZA': 'Pollinaza',

      // Actividades recientes - movimiento títulos
      'ACT_MOV_COMPRA': 'Compra de inventario',
      'ACT_MOV_DONACION': 'Donación recibida',
      'ACT_MOV_CONSUMO_LOTE': 'Consumo de lote',
      'ACT_MOV_TRATAMIENTO': 'Tratamiento aplicado',
      'ACT_MOV_VACUNACION': 'Vacunación',
      'ACT_MOV_AJUSTE_POS': 'Ajuste positivo',
      'ACT_MOV_AJUSTE_NEG': 'Ajuste negativo',
      'ACT_MOV_DEVOLUCION': 'Devolución',
      'ACT_MOV_MERMA': 'Merma',
      'ACT_MOV_TRANSFERENCIA': 'Transferencia',
      'ACT_MOV_USO_GENERAL': 'Uso general',
      'ACT_MOV_VENTA': 'Venta',

      // Actividades recientes - evento galpón títulos
      'ACT_EVT_DESINFECCION': 'Desinfección',
      'ACT_EVT_MANTENIMIENTO': 'Mantenimiento',
      'ACT_EVT_CAMBIO_ESTADO': 'Cambio de estado',
      'ACT_EVT_GALPON_CREADO': 'Galpón creado',
      'ACT_EVT_LOTE_ASIGNADO': 'Lote asignado',
      'ACT_EVT_LOTE_LIBERADO': 'Lote liberado',
      'ACT_EVT_EVENTO': 'Evento',

      // Actividades recientes - fallbacks y formatos
      'ACT_FALLBACK_REGISTRO': 'Registro',
      'ACT_FALLBACK_VACUNA': 'Vacuna',
      'ACT_FALLBACK_EVENTO': 'Evento',
      'ACT_FALLBACK_EN_EVALUACION': 'En evaluación',
      'ACT_FALLBACK_INSPECTOR': 'Inspector',
      'ACT_SUB_INVENTARIO': '{signo}{cantidad} uds',
      'ACT_HUEVOS_CLASIFICACION': '{clasificacion} ({cantidad} uds)',
      'UNIT_AVES': 'aves',
      'UNIT_UNIDADES': 'unidades',
      'UNIT_SACOS': 'sacos',
      'CONCEPTO_MOVIMIENTO': '{tipo}: {item} ({cantidad} {unidad})',

      // Sync status
      'SYNC_PENDING': 'Pendiente',
      'SYNC_LOCAL': 'Local',
      'SYNC_SYNCED': 'Sincronizado',
      'SYNC_TOOLTIP_PENDING': 'Datos pendientes de sincronizar',
      'SYNC_TOOLTIP_CACHE': 'Datos del caché local',
      'SYNC_TOOLTIP_SYNCED': 'Datos sincronizados con el servidor',
      'SYNC_OFFLINE_MODE': 'Modo sin conexión',
      'SYNC_OFFLINE_MSG':
          'Los cambios se guardarán localmente y se sincronizarán cuando vuelvas a conectarte',
      'SYNC_NO_CONNECTION': 'Sin conexión',
      'SYNC_NO_CONNECTION_MSG':
          'No hay conexión a internet. Los datos mostrados pueden no estar actualizados',
      'SYNC_SYNCING': 'Sincronizando',
      'SYNC_SYNCING_MSG': 'Subiendo cambios al servidor...',
      'SYNC_LAST_SYNC': 'Última sincronización: {time}',
      'SYNC_CONNECTED_VIA': 'Conectado vía {type}',
      'SYNC_ALL_SYNCED': 'Todo sincronizado',
      'SYNC_JUST_NOW': 'hace un momento',
      'SYNC_MINUTES_AGO': 'hace {min} min',
      'SYNC_HOURS_AGO': 'hace {hours} horas',
      'SYNC_DAYS_AGO': 'hace {days} días',
      'SYNC_NOW': 'ahora',
      'SYNC_AGO_M': 'hace {min}m',
      'SYNC_AGO_H': 'hace {hours}h',
      'SYNC_AGO_D': 'hace {days}d',

      // Connectivity
      'CONN_MOBILE_DATA': 'Datos móviles',
      'CONN_NO_CONNECTION': 'Sin conexión',
      'CONN_OTHER': 'Otra conexión',

      // Inventory integration motivos
      'MOTIVO_COMPRA_COSTOS': 'Compra registrada desde Costos',
      'MOTIVO_CONSUMO_LOTE': 'Consumo de alimento en lote',
      'MOTIVO_VENTA': 'Venta de {producto}',
      'MOTIVO_FALLBACK_PRODUCTO': 'producto',
      'MOTIVO_TRATAMIENTO': 'Aplicación de tratamiento',
      'MOTIVO_VACUNA': 'Aplicación de vacuna',
      'MOTIVO_DESINFECCION': 'Desinfección de galpón',

      // Inventory cost categories
      'CAT_ALIMENTACION': 'Alimentación',
      'CAT_SANIDAD': 'Sanidad',
      'CAT_EQUIPAMIENTO': 'Equipamiento',
      'CAT_LIMPIEZA': 'Limpieza',
      'CAT_INSUMOS': 'Insumos',
      'CAT_OTROS': 'Otros',
      'CONCEPTO_COMPRA_ITEM': 'Compra de {item} ({cantidad} {unidad})',
      'OBS_AUTO_INVENTARIO':
          'Generado automáticamente desde Inventario. Item: {item}, Cantidad: {cantidad} {unidad}, Precio unitario: \${precio}',
      'OBS_AUTO_MOVIMIENTO':
          'Generado automáticamente desde movimiento de inventario. {motivo}',

      // Tendencias
      'TREND_INCREASING': 'aumentando',
      'TREND_DECREASING': 'disminuyendo',
      'TREND_STABLE': 'estable',

      // Reportes fallback
      'FALLBACK_GALPON': 'Galpón',

      // Accessibility
      'A11Y_FILTER_BY': 'Filtrar por {label}',

      // Causa mortalidad - acciones recomendadas
      'CAUSA_ACT_ENF_1': 'Solicitar diagnóstico veterinario',
      'CAUSA_ACT_ENF_2': 'Aislar aves afectadas',
      'CAUSA_ACT_ENF_3': 'Aplicar tratamiento si está disponible',
      'CAUSA_ACT_ENF_4': 'Aumentar bioseguridad',
      'CAUSA_ACT_ENF_5': 'Revisar programa de vacunación',
      'CAUSA_ACT_ACC_1': 'Inspeccionar instalaciones',
      'CAUSA_ACT_ACC_2': 'Reparar equipos dañados',
      'CAUSA_ACT_ACC_3': 'Revisar densidad de aves',
      'CAUSA_ACT_ACC_4': 'Capacitar personal en manejo',
      'CAUSA_ACT_DES_1': 'Verificar acceso al alimento',
      'CAUSA_ACT_DES_2': 'Revisar calidad del alimento',
      'CAUSA_ACT_DES_3': 'Comprobar funcionamiento de bebederos',
      'CAUSA_ACT_DES_4': 'Ajustar programa nutricional',
      'CAUSA_ACT_EST_1': 'Regular temperatura ambiente',
      'CAUSA_ACT_EST_2': 'Mejorar ventilación',
      'CAUSA_ACT_EST_3': 'Reducir densidad si es necesario',
      'CAUSA_ACT_MET_1': 'Consultar con nutricionista',
      'CAUSA_ACT_MET_2': 'Revisar programa de crecimiento',
      'CAUSA_ACT_MET_3': 'Ajustar formulación del alimento',
      'CAUSA_ACT_DEP_1': 'Reforzar cercos perimetrales',
      'CAUSA_ACT_DEP_2': 'Implementar control de plagas',
      'CAUSA_ACT_DEP_3': 'Instalar mallas de protección',
      'CAUSA_ACT_NORMAL': 'Normal en el proceso productivo',
      'CAUSA_ACT_DESC_1': 'Solicitar necropsia si mortalidad es alta',
      'CAUSA_ACT_DESC_2': 'Aumentar monitoreo del lote',
      'CAUSA_ACT_DESC_3': 'Consultar con veterinario',

      // Causa mortalidad - categorías
      'CAUSA_CAT_SANITARIA': 'Sanitaria',
      'CAUSA_CAT_MANEJO': 'Manejo',
      'CAUSA_CAT_NUTRICIONAL': 'Nutricional',
      'CAUSA_CAT_AMBIENTAL': 'Ambiental',
      'CAUSA_CAT_FISIOLOGICA': 'Fisiológica',
      'CAUSA_CAT_NATURAL': 'Natural',
      'CAUSA_CAT_SIN_CLASIFICAR': 'Sin clasificar',

      // Enfermedad avícola - síntomas (separados por |)
      'ENF_NEWCASTLE_SINT':
          'Problemas respiratorios|Diarrea verdosa|Tortícolis|Parálisis|Caída de postura|Alta mortalidad',
      'ENF_NEWCASTLE_TRAT':
          'Vacunación preventiva|Cuarentena estricta|Sacrificio sanitario en casos severos',
      'ENF_GUMBORO_SINT':
          'Depresión|Diarrea acuosa blanquecina|Plumas erizadas|Inflamación de la bolsa de Fabricio|Inmunosupresión',
      'ENF_GUMBORO_TRAT':
          'Vacunación según programa|Bioseguridad estricta|Control de estrés',
      'ENF_MAREK_SINT':
          'Parálisis de patas y alas|Tumores en órganos|Iris gris (ojo gris)|Pérdida de peso|Muerte súbita',
      'ENF_MAREK_TRAT':
          'Vacunación in-ovo o al día de edad|No hay tratamiento|Eliminación de aves afectadas',
      'ENF_BRONQUITISINFECCIOSA_SINT':
          'Estornudos|Estertores traqueales|Secreción nasal|Caída de postura|Huevos deformes|Problemas renales',
      'ENF_BRONQUITISINFECCIOSA_TRAT':
          'Vacunación múltiple|Ventilación adecuada|Control de amoníaco',
      'ENF_INFLUENZAAVIAR_SINT':
          'Muerte súbita|Edema facial|Cianosis en cresta y barbillas|Hemorragias en patas|Caída drástica de postura|Síntomas nerviosos',
      'ENF_INFLUENZAAVIAR_TRAT':
          'Notificación obligatoria|Sacrificio sanitario|Cuarentena de zona|Bioseguridad máxima',
      'ENF_LARINGOTRAQUEITIS_SINT':
          'Disnea severa|Estiramiento de cuello para respirar|Sangre en la tráquea|Tos con sangre|Alta mortalidad por asfixia',
      'ENF_LARINGOTRAQUEITIS_TRAT':
          'Vacunación preventiva|Aislamiento de aves afectadas|Desinfección rigurosa',
      'ENF_VIRUELAAVIAR_SINT':
          'Nódulos en cresta y barbillas|Lesiones en boca (forma diftérica)|Costras en piel|Dificultad para comer',
      'ENF_VIRUELAAVIAR_TRAT':
          'Vacunación preventiva|Control de mosquitos|Tratamiento de lesiones con antisépticos',
      'ENF_ANEMIINFECCIOSA_SINT':
          'Palidez|Anemia|Hemorragias musculares|Inmunosupresión|Dermatitis gangrenosa',
      'ENF_ANEMIINFECCIOSA_TRAT':
          'Vacunación de reproductoras|Bioseguridad|Control de inmunosupresores',
      'ENF_COLIBACILOSIS_SINT':
          'Septicemia|Perihepatitis|Pericarditis|Aerosaculitis|Onfalitis en pollitos|Celulitis',
      'ENF_COLIBACILOSIS_TRAT':
          'Antibióticos según antibiograma|Mejora de bioseguridad|Control de calidad del agua|Reducción de estrés',
      'ENF_SALMONELOSIS_SINT':
          'Diarrea|Onfalitis|Septicemia en pollitos|Portadores asintomáticos|Caída de postura',
      'ENF_SALMONELOSIS_TRAT':
          'Programa de control obligatorio|Vacunación|Bioseguridad estricta|Monitoreo serológico',
      'ENF_MYCOPLASMOSIS_SINT':
          'Estornudos|Secreción nasal|Estertores|Inflamación de senos nasales|Sinovitis (MS)|Caída de producción',
      'ENF_MYCOPLASMOSIS_TRAT':
          'Antibióticos (tilosina, enrofloxacina)|Vacunación preventiva|Lotes libres de mycoplasma',
      'ENF_COLERAAVIAR_SINT':
          'Muerte súbita|Fiebre alta|Diarrea verdosa|Cianosis en cresta|Artritis|Tortícolis',
      'ENF_COLERAAVIAR_TRAT':
          'Antibióticos (sulfas, tetraciclinas)|Vacunación en zonas endémicas|Eliminación de aves crónicas',
      'ENF_CORIZA_SINT':
          'Inflamación facial|Secreción nasal fétida|Conjuntivitis|Estornudos|Mal olor característico',
      'ENF_CORIZA_TRAT':
          'Antibióticos (sulfas, eritromicina)|Vacunación preventiva|Eliminación de portadores',
      'ENF_CLOSTRIDIOSISNECROTICA_SINT':
          'Muerte súbita|Diarrea oscura|Plumas erizadas|Depresión|Lesiones necróticas en intestino',
      'ENF_CLOSTRIDIOSISNECROTICA_TRAT':
          'Antibióticos (bacitracina, lincomicina)|Control de coccidiosis|Manejo de cama|Aditivos alternativos',
      'ENF_COCCIDIOSIS_SINT':
          'Diarrea sanguinolenta|Plumas erizadas|Depresión|Pérdida de peso|Deshidratación|Alta mortalidad',
      'ENF_COCCIDIOSIS_TRAT':
          'Anticoccidiales en alimento|Vacunas vivas|Manejo de cama seca|Rotación de principios activos',
      'ENF_ASCARIDIASIS_SINT':
          'Pérdida de peso|Palidez|Diarrea|Obstrucción intestinal (casos severos)',
      'ENF_ASCARIDIASIS_TRAT':
          'Desparasitación periódica|Rotación de potreros|Manejo higiénico',
      'ENF_ASPERGILOSIS_SINT':
          'Dificultad respiratoria|Disnea|Nódulos en pulmones|Alta mortalidad en pollitos',
      'ENF_ASPERGILOSIS_TRAT':
          'Eliminar fuentes de hongo|Desinfección de incubadoras|No hay tratamiento efectivo',
      'ENF_ASCITIS_SINT':
          'Abdomen distendido|Líquido abdominal|Cianosis|Dificultad respiratoria|Muerte súbita',
      'ENF_ASCITIS_TRAT':
          'Restricción alimenticia temprana|Control de velocidad de crecimiento|Ventilación adecuada|Altitud (factor de riesgo)',
      'ENF_MUERTESUBITA_SINT':
          'Muerte súbita de aves aparentemente sanas|Aves en posición dorsal|Más común en machos de rápido crecimiento',
      'ENF_MUERTESUBITA_TRAT':
          'Restricción alimenticia|Control de crecimiento|Programas de luz',
      'ENF_DEFICIENCIAVITAMINAE_SINT':
          'Ataxia|Tortícolis|Convulsiones|Parálisis',
      'ENF_DEFICIENCIAVITAMINAE_TRAT':
          'Suplementación de Vitamina E|Antioxidantes en alimento',
      'ENF_RAQUITISMO_SINT':
          'Huesos blandos|Patas dobladas|Pico blando|Cáscaras débiles',
      'ENF_RAQUITISMO_TRAT':
          'Corrección de niveles de Calcio, Fósforo y Vitamina D3|Exposición a luz solar',

      // Provider error messages
      'ERR_LOADING_ALERTS': 'Error al cargar alertas: {e}',
      'ERR_LOADING_INSPECTIONS': 'Error al cargar inspecciones: {e}',
      'ERR_SAVING_INSPECTION': 'Error al guardar inspección: {e}',
      'ERR_LOADING_PROGRAMS': 'Error al cargar programas: {e}',
      'ERR_LOADING_NECROPSIES': 'Error al cargar necropsias: {e}',
      'ERR_LOADING_BATCH_NECROPSIES': 'Error al cargar necropsias del lote: {e}',
      'ERR_REGISTERING_NECROPSY': 'Error al registrar necropsia: {e}',
      'ERR_UPDATING_RESULT': 'Error al actualizar resultado: {e}',
      'ERR_CONFIRMING_DIAGNOSIS': 'Error al confirmar diagnóstico: {e}',
      'ERR_DELETING_NECROPSY': 'Error al eliminar necropsia: {e}',
      'ERR_LOADING_STATISTICS': 'Error al cargar estadísticas: {e}',
      'ERR_LOADING_ANTIMICROBIAL_USES': 'Error al cargar usos de antimicrobianos: {e}',
      'ERR_LOADING_WITHDRAWAL_BATCHES': 'Error al cargar lotes en retiro: {e}',
      'ERR_REGISTERING_ANTIMICROBIAL_USE': 'Error al registrar uso de antimicrobiano: {e}',
      'ERR_GENERATING_REPORT': 'Error al generar reporte: {e}',
      'ERR_UPDATING_USE': 'Error al actualizar uso: {e}',
      'ERR_DELETING_USE': 'Error al eliminar uso: {e}',
      'ERR_LOADING_EVENTS': 'Error al cargar eventos: {e}',
      'ERR_CREATING_EVENT': 'Error al crear evento: {e}',
      'ERR_COMPLETING_EVENT': 'Error al completar evento: {e}',
      'ERR_CANCELING_EVENT': 'Error al cancelar evento: {e}',
      'ERR_RESCHEDULING_EVENT': 'Error al reprogramar evento: {e}',
      'ERR_DELETING_EVENT': 'Error al eliminar evento: {e}',
      'ERR_CREATING_EVENTS_FROM_PROGRAM': 'Error al crear eventos desde programa: {e}',

      // Infrastructure error messages
      'ERR_NO_CONNECTION': 'Sin conexión a internet',
      'ERR_NO_CONNECTION_SYNC': 'Sin conexión para sincronizar',
      'ERR_LOGIN_FAILED': 'No se pudo iniciar sesión',
      'ERR_GOOGLE_LOGIN_CANCELED': 'Inicio de sesión con Google cancelado',
      'ERR_GOOGLE_LOGIN_FAILED': 'No se pudo iniciar sesión con Google',
      'ERR_APPLE_LOGIN_FAILED': 'No se pudo iniciar sesión con Apple',
      'ERR_CREATE_ACCOUNT_FAILED': 'No se pudo crear la cuenta',
      'ERR_FILE_NOT_EXISTS': 'El archivo no existe: {path}',
      'ERR_IMAGE_TOO_LARGE': 'La imagen excede el tamaño máximo (5MB)',
      'ERR_NO_PENDING_CREDENTIAL': 'No hay credencial pendiente para vincular',
      'ERR_LINK_ACCOUNT_FAILED': 'Error al vincular la cuenta',
      'ERR_GOOGLE_ALREADY_LINKED': 'Esta cuenta de Google ya está vinculada a otro usuario',
      'ERR_PROVIDER_ALREADY_LINKED': 'Este proveedor ya está vinculado a tu cuenta',
      'ERR_UNKNOWN': 'Error desconocido',
      'ERR_CREATE_FARM': 'Error al crear granja',
      'ERR_GET_FARM': 'Error al obtener granja',
      'ERR_GET_FARMS': 'Error al obtener granjas',
      'ERR_UPDATE_FARM': 'Error al actualizar granja',
      'ERR_DELETE_FARM': 'Error al eliminar granja',
      'ERR_VERIFY_RUC': 'Error al verificar RUC',
      'ERR_COUNT_FARMS': 'Error al contar granjas',
      'ERR_CANNOT_INVITE_OWNER': 'No se puede invitar con rol de propietario',
      'ERR_NO_INVITE_PERMISSION': 'No tienes permiso para invitar usuarios a esta granja',
      'ERR_INVITATION_NOT_FOUND': 'Invitación no encontrada',
      'ERR_INVITATION_INVALID': 'Invitación no válida o expirada',
      'ERR_ALREADY_MEMBER': 'Ya eres miembro de esta granja',
      'ERR_CANNOT_ACCEPT_OWN': 'No puedes aceptar tu propia invitación',
      'ERR_REMOVE_USER': 'Error al remover usuario de la granja',
      'ERR_FARM_NOT_FOUND': 'Granja no encontrada',
      'ERR_FARM_NOT_EXISTS': 'La granja no existe',
      'ERR_OWNER_CANNOT_LEAVE': 'El propietario no puede abandonar su granja',
      'ERR_LEAVE_FARM': 'Error al abandonar la granja',
      'ERR_CREATE_SHED': 'Error al crear galpón',
      'ERR_GET_SHED': 'Error al obtener galpón',
      'ERR_GET_SHEDS': 'Error al obtener galpones',
      'ERR_UPDATE_SHED': 'Error al actualizar galpón',
      'ERR_DELETE_SHED': 'Error al eliminar galpón',
      'ERR_GET_AVAILABLE_SHEDS': 'Error al obtener galpones disponibles',
      'ERR_SEARCH_SHEDS': 'Error al buscar galpones',
      'ERR_REGISTER_EVENT': 'Error al registrar evento',
      'ERR_GET_EVENTS': 'Error al obtener eventos',
      'ERR_COUNT_SHEDS': 'Error al contar galpones',
      'ERR_CREATE_COST': 'Error al crear costo: {e}',
      'ERR_GET_COST': 'Error al obtener costo: {e}',
      'ERR_GET_COSTS': 'Error al obtener costos: {e}',
      'ERR_UPDATE_COST': 'Error al actualizar costo: {e}',
      'ERR_DELETE_COST': 'Error al eliminar costo: {e}',
      'ERR_GET_COSTS_BY_FARM': 'Error al obtener costos por granja: {e}',
      'ERR_GET_COSTS_BY_BATCH': 'Error al obtener costos por lote: {e}',
      'ERR_GET_COSTS_BY_TYPE': 'Error al obtener costos por tipo: {e}',
      'ERR_GET_PENDING_COSTS': 'Error al obtener costos pendientes: {e}',
      'ERR_GET_COSTS_BY_PERIOD': 'Error al obtener costos por período: {e}',
      'ERR_CREATE_BATCH': 'Error al crear lote: {e}',
      'ERR_UPDATE_BATCH': 'Error al actualizar lote: {e}',
      'ERR_DELETE_BATCH': 'Error al eliminar lote: {e}',
      'ERR_BATCH_OFFLINE': 'Lote no disponible sin conexión',
      'ERR_GET_BATCH': 'Error al obtener lote: {e}',
      'ERR_GET_BATCHES': 'Error al obtener lotes: {e}',
      'ERR_GET_SHED_BATCHES': 'Error al obtener lotes del galpón: {e}',
      'ERR_GET_ACTIVE_BATCHES': 'Error al obtener lotes activos: {e}',
      'ERR_GET_BATCHES_BY_STATE': 'Error al obtener lotes por estado: {e}',
      'ERR_SEARCH': 'Error en búsqueda: {e}',
      'ERR_REGISTER_MORTALITY': 'Error al registrar mortalidad: {e}',
      'ERR_REGISTER_DISCARD': 'Error al registrar descarte: {e}',
      'ERR_REGISTER_SALE': 'Error al registrar venta: {e}',
      'ERR_UPDATE_WEIGHT': 'Error al actualizar peso: {e}',
      'ERR_CHANGE_STATE': 'Error al cambiar estado: {e}',
      'ERR_CLOSE_BATCH': 'Error al cerrar lote: {e}',
      'ERR_MARK_SOLD': 'Error al marcar como vendido: {e}',
      'ERR_TRANSFER_BATCH': 'Error al transferir lote: {e}',
      'ERR_GET_STATS': 'Error al obtener estadísticas: {e}',
      'ERR_COUNT_BY_STATE': 'Error al contar por estado: {e}',
      'ERR_SYNC': 'Error al sincronizar: {e}',
      'ERR_CLEAR_CACHE': 'Error al limpiar cache: {e}',

      // Infraestructura - usuarios granja
      'ERR_NO_CONNECTION_PHOTO': 'No hay conexión a internet. La foto de perfil se actualizará cuando tengas señal.',
      'ERR_GET_FARM_USERS': 'Error al obtener usuarios de la granja',
      'ERR_ASSIGN_USER': 'Error al asignar usuario a la granja',
      'ERR_USER_NOT_FOUND_IN_FARM': 'Usuario no encontrado en la granja',
      'ERR_CHANGE_ROLE': 'Error al cambiar rol del usuario',
      'ERR_TRANSFER_OR_DELETE': 'Debes transferir la propiedad o eliminar la granja',
      'ERR_GET_USER_FARMS': 'Error al obtener granjas del usuario',
      'ERR_CREATE_INVITATION': 'Error al crear invitación',
      'ERR_MARK_INVITATION_USED': 'Error al marcar invitación como usada',
      'ERR_GET_INVITATIONS': 'Error al obtener invitaciones',
      'ERR_SHED_NOT_FOUND': 'Galpón no encontrado',
      'ERR_BATCH_NOT_FOUND': 'Lote no encontrado',
      'ERR_STREAM': 'Error en stream: {e}',

      // Alertas service - inventario
      'ALERT_STOCK_BAJO': '⚠️ Stock bajo: {item}',
      'ALERT_STOCK_BAJO_MSG': 'Solo quedan {cantidad} {unidad}',
      'ALERT_AGOTADO': '🚫 Agotado: {item}',
      'ALERT_AGOTADO_MSG': 'Stock en cero, requiere reabastecimiento urgente',
      'ALERT_VENCIDO': '❌ Vencido: {item}',
      'ALERT_VENCIDO_MSG': 'Este producto venció hace {dias} días',
      'ALERT_PROXIMO_VENCER': '📅 Próximo a vencer: {item}',
      'ALERT_VENCE_HOY': '¡Vence hoy!',
      'ALERT_VENCE_EN_DIAS': 'Vence en {dias} días',
      'ALERT_REABASTECIDO': '✅ Reabastecido: {item}',
      'ALERT_REABASTECIDO_MSG': 'Se agregaron {cantidad} {unidad}',
      'ALERT_MOVIMIENTO': '📦 {tipo}: {item}',
      'ALERT_MOVIMIENTO_MSG': '{cantidad} {unidad}',

      // Alertas service - mortalidad
      'ALERT_MORTALIDAD_CRITICA': '🚨 Mortalidad CRÍTICA: {lote}',
      'ALERT_MORTALIDAD_ALTA': '⚠️ Mortalidad alta: {lote}',
      'ALERT_MORTALIDAD_MSG': '{porcentaje}% ({cantidad} aves)',
      'ALERT_MORTALIDAD_REG': '🐔 Mortalidad registrada: {lote}',
      'ALERT_MORTALIDAD_REG_MSG':
          '{cantidad} aves • Causa: {causa} • Acumulada: {porcentaje}%',

      // Alertas service - lotes
      'ALERT_NUEVO_LOTE': '🐤 Nuevo lote: {lote}',
      'ALERT_NUEVO_LOTE_MSG': '{cantidad} aves en {galpon}',
      'ALERT_LOTE_FINALIZADO': '✅ Lote finalizado: {lote}',
      'ALERT_LOTE_FINALIZADO_MSG': 'Ciclo de {dias} días',
      'ALERT_PESO_BAJO': '⚖️ Peso bajo: {lote}',
      'ALERT_PESO_BAJO_MSG': '{peso}g ({diferencia}% bajo objetivo)',
      'ALERT_CIERRE_PROXIMO': '📆 Cierre próximo: {lote}',
      'ALERT_CIERRE_HOY': '¡Fecha de cierre es hoy!',
      'ALERT_CIERRE_EN_DIAS': 'Cierra en {dias} días',
      'ALERT_CONVERSION_ANORMAL': '📊 Conversión anormal: {lote}',
      'ALERT_CONVERSION_MSG': '{actual} vs {esperado} esperado',
      'ALERT_SIN_REGISTROS': '⚠️ Sin registros: {lote}',
      'ALERT_SIN_REGISTROS_MSG': 'Último registro hace {dias} días',

      // Alertas service - producción
      'ALERT_PRODUCCION': '🥚 Producción: {lote}',
      'ALERT_PRODUCCION_MSG': '{cantidad} huevos ({porcentaje}%)',
      'ALERT_PRODUCCION_BAJA': '📉 Producción baja: {lote}',
      'ALERT_PRODUCCION_BAJA_MSG': '{actual}% vs {esperado}% esperado',
      'ALERT_CAIDA_PRODUCCION': '🔻 Caída de producción: {lote}',
      'ALERT_CAIDA_MSG': 'Bajó {caida}% (de {anterior}% a {actual}%)',
      'ALERT_PRIMER_HUEVO': '🎉 ¡Primer huevo! {lote}',
      'ALERT_PRIMER_HUEVO_MSG': 'A las {semanas} semanas de edad',
      'ALERT_RECORD': '🏆 ¡Récord! {lote}',
      'ALERT_RECORD_MSG': '{cantidad} huevos ({porcentaje}%)',
      'ALERT_META': '🎯 Meta alcanzada: {lote}',
      'ALERT_META_MSG': '{total} huevos (meta: {meta})',

      // Alertas service - vacunaciones
      'ALERT_VAC_VENCIDA': '❌ Vacunación vencida',
      'ALERT_VAC_VENCIDA_MSG': '{vacuna} para {lote} no fue aplicada',
      'ALERT_VAC_HOY': '💉 Vacunación HOY',
      'ALERT_VAC_MANANA': '💉 Vacunación MAÑANA',
      'ALERT_VAC_EN_DIAS': '💉 Vacunación en {dias} días',
      'ALERT_VAC_PARA_LOTE': '{vacuna} para {lote}',
      'ALERT_VAC_COMPLETADA': '✅ Vacunación completada',
      'ALERT_VAC_COMPLETADA_MSG': '{vacuna} aplicada a {aves} aves de {lote}',

      // Alertas service - tratamientos
      'ALERT_TRATAMIENTO': '💊 Tratamiento iniciado: {lote}',
      'ALERT_TRATAMIENTO_MSG': '{tratamiento} por {dias} días',
      'ALERT_TRATAMIENTO_RETIRO': ' ({diasRetiro} días retiro)',
      'ALERT_RETIRO_ACTIVO': '🚫 Retiro activo: {lote}',
      'ALERT_RETIRO_ACTIVO_MSG':
          '{medicamento} - {dias} días restantes. NO comercializar huevos.',
      'ALERT_RETIRO_FIN': '✅ Retiro finalizado: {lote}',
      'ALERT_RETIRO_FIN_MSG': 'Período de retiro de {medicamento} completado',

      // Alertas service - salud
      'ALERT_DIAGNOSTICO': '🏥 Diagnóstico: {lote}',
      'ALERT_DIAGNOSTICO_MSG': '{diagnostico} - Severidad: {severidad}',
      'ALERT_SINTOMAS_RESP': '🫁 Síntomas respiratorios: {lote}',
      'ALERT_SINTOMAS_RESP_MSG': '{sintomas} en {aves} aves',
      'ALERT_CONSUMO_AGUA': '💧 Consumo agua {tipo}: {lote}',
      'ALERT_CONSUMO_AGUA_MSG':
          '{actual}L vs {esperado}L esperado ({diferencia}% {tipo})',
      'ALERT_CONSUMO_ALIMENTO': '🌾 Consumo alimento {tipo}: {lote}',
      'ALERT_CONSUMO_ALIMENTO_MSG':
          '{actual}kg vs {esperado}kg esperado ({diferencia}% {tipo})',
      'ALERT_TEMPERATURA': '🌡️ Temperatura {tipo}: {galpon}',
      'ALERT_TEMPERATURA_MSG': '{actual}°C (rango: {min}-{max}°C)',
      'ALERT_HUMEDAD': '💧 Humedad {tipo}: {galpon}',
      'ALERT_HUMEDAD_MSG': '{actual}% (rango: {min}-{max}%)',
      'ALERT_ENFERMEDAD': '🦠 Enfermedad confirmada: {lote}',
      'ALERT_ENFERMEDAD_MSG': '{enfermedad} detectada en {aves} aves',

      // Alertas service - bioseguridad
      'ALERT_BIOSEG_APROBADA': '✅ Inspección aprobada',
      'ALERT_BIOSEG_OBSERVACIONES': '⚠️ Inspección con observaciones',
      'ALERT_BIOSEG_REPROBADA': '❌ Inspección reprobada',
      'ALERT_BIOSEG_RESULTADO': '{tipo} - Puntaje: {puntaje}%',
      'ALERT_INSP_VENCIDA': '❌ Inspección vencida',
      'ALERT_INSP_HOY': '📋 Inspección HOY',
      'ALERT_INSP_EN_DIAS': '📋 Inspección en {dias} días',
      'ALERT_BIOSEG_CRITICA': '🚨 Bioseguridad CRÍTICA',
      'ALERT_BIOSEG_BAJA': '⚠️ Bioseguridad baja',
      'ALERT_INSP_COMPLETADA': '✅ Inspección completada',

      // Alertas service - necropsia
      'ALERT_NECROPSIA': '🔬 Necropsia: {lote}',
      'ALERT_NECROPSIA_MSG': 'Causa probable: {causa}',

      // Alertas service - comercial
      'ALERT_NUEVO_PEDIDO': '🛒 Nuevo pedido',
      'ALERT_NUEVO_PEDIDO_MSG': '{cliente} - {cantidad} huevos (\${monto})',
      'ALERT_PEDIDO_CONFIRMADO': '✅ Pedido confirmado',
      'ALERT_PEDIDO_CONFIRMADO_MSG': '{cliente} - Entrega: {fecha}',
      'ALERT_ENTREGA_HOY': '🚚 Entrega HOY',
      'ALERT_ENTREGA_MANANA': '🚚 Entrega MAÑANA',
      'ALERT_PEDIDO_ENTREGADO': '✅ Pedido entregado',
      'ALERT_PEDIDO_ENTREGADO_MSG': '{cliente} - \${monto}',
      'ALERT_PEDIDO_CANCELADO': '❌ Pedido cancelado',
      'ALERT_PEDIDO_CANCELADO_MSG': '{cliente} - {motivo}',
      'ALERT_PAGO_RECIBIDO': '💰 Pago recibido',
      'ALERT_PAGO_MSG': '{cliente} - \${monto} ({metodo})',
      'ALERT_VENTA_REG': '🛍️ Venta registrada',
      'ALERT_VENTA_REG_MSG': '{cliente} - {cantidad} huevos (\${monto})',

      // Alertas service - colaboradores
      'ALERT_INVITACION': '🎉 Invitación a {granja}',
      'ALERT_INVITACION_MSG': '{invitadoPor} te ha invitado a colaborar',
      'ALERT_NUEVO_COLAB': '👤 Nuevo colaborador',
      'ALERT_NUEVO_COLAB_MSG': '{nombre} se unió como {rol}',
      'ALERT_INVITACION_RECHAZADA': '❌ Invitación rechazada',
      'ALERT_INVITACION_RECHAZADA_MSG': '{email} rechazó la invitación',
      'ALERT_ACCESO_REVOCADO': '👋 Acceso revocado',
      'ALERT_ACCESO_REVOCADO_MSG': 'Ya no tienes acceso a {granja}',
      'ALERT_COLAB_REMOVIDO': '👋 Colaborador removido',
      'ALERT_COLAB_REMOVIDO_MSG': '{nombre} fue removido de {granja}',
      'ALERT_CAMBIO_ROL': '🔄 Cambio de rol',
      'ALERT_CAMBIO_ROL_MSG':
          'Tu rol cambió de {rolAnterior} a {rolNuevo} en {granja}',

      // Alertas service - galpones
      'ALERT_NUEVO_GALPON': '🏠 Nuevo galpón: {galpon}',
      'ALERT_NUEVO_GALPON_MSG': 'Capacidad: {capacidad} aves',
      'ALERT_MANTENIMIENTO': '🔧 Mantenimiento: {galpon}',
      'ALERT_CAPACIDAD_MAX': '⚠️ Capacidad máxima: {galpon}',
      'ALERT_CAPACIDAD_MAX_MSG': '{actual}/{max} aves',
      'ALERT_EVENTO_GALPON': '📋 {tipo}: {galpon}',

      // Alertas service - costos
      'ALERT_GASTO': '💳 Gasto: {categoria}',
      'ALERT_GASTO_MSG': '\${monto} - {descripcion}',
      'ALERT_GASTO_INUSUAL': '⚠️ Gasto inusual: {categoria}',
      'ALERT_GASTO_INUSUAL_MSG': '\${monto} ({porcentaje}% sobre promedio)',
      'ALERT_PRESUPUESTO_SUPERADO': '🚨 Presupuesto superado: {categoria}',
      'ALERT_PRESUPUESTO_MSG':
          '\${gastoAcum}/\${presupuesto} (exceso: \${exceso})',

      // Alertas service - reportes y sistema
      'ALERT_RESUMEN_SEMANAL': '📊 Resumen semanal',
      'ALERT_RESUMEN_SEMANAL_MSG':
          'Ingresos: \${ingresos} | Gastos: \${gastos} | {tipo}: \${utilidad}',
      'ALERT_UTILIDAD': 'Utilidad',
      'ALERT_PERDIDA': 'Pérdida',
      'ALERT_REPORTE_LISTO': '📄 Reporte listo',
      'ALERT_REPORTE_LISTO_MSG': '{tipo} generado exitosamente',
      'ALERT_RESUMEN_DIA': '📋 Resumen del día',
      'ALERT_RESUMEN_DIA_MSG':
          '🥚 {huevos} | ⚰️ {mortalidad} | 🌾 {alimento}kg | ⚠️ {alertas} alertas',
      'ALERT_ALERTAS_PENDIENTES': '🔔 {cantidad} alertas pendientes',
      'ALERT_SYNC_OK': '☁️ Sincronización completada',
      'ALERT_SYNC_MSG': '{registros} registros sincronizados',
      'ALERT_BIENVENIDO': '👋 ¡Bienvenido {nombre}!',
      'ALERT_BIENVENIDO_MSG':
          'Gracias por usar Smart Granja Aves Pro. Explora las funciones disponibles.',
      'NOTIF_FALLBACK_TITLE': 'Notificación',
      'NOTIF_CHANNEL_DESC': 'Notificaciones de Smart Granja Aves Pro',
      'ALERT_BAJO': 'bajo',
      'ALERT_ALTO': 'alto',
      'ALERT_BAJA': 'baja',
      'ALERT_ALTA': 'alta',

      // Registro reciente cards
      'REG_CARD_PESO_DESC': '{aves} aves pesadas - GDP: {gdp}g/día',
      'REG_CARD_CONSUMO_DESC': '{tipo} - {aves} aves',
      'REG_CARD_MORT_DESC': '{causa} - Impacto: {impacto}%',
      'REG_CARD_MORT_VALOR': '{cantidad} aves',
      'REG_CARD_PROD_DESC': 'Postura: {postura}% - Buenos: {buenos}%',
      'REG_CARD_PROD_VALOR': '{cantidad} huevos',

      // CausaMortalidad display names (sin context)
      'CAUSA_MORT_ENFERMEDAD': 'Enfermedad',
      'CAUSA_MORT_ACCIDENTE': 'Accidente',
      'CAUSA_MORT_DESNUTRICION': 'Desnutrición',
      'CAUSA_MORT_ESTRES': 'Estrés',
      'CAUSA_MORT_METABOLICA': 'Metabólica',
      'CAUSA_MORT_DEPREDACION': 'Depredación',
      'CAUSA_MORT_SACRIFICIO': 'Sacrificio',
      'CAUSA_MORT_VEJEZ': 'Vejez',
      'CAUSA_MORT_DESCONOCIDA': 'Desconocida',

      // Ventas datasource
      'ERR_GET_SALES': 'Error al obtener ventas: {e}',
      'ERR_GET_SALE': 'Error al obtener venta: {e}',
      'ERR_CREATE_SALE': 'Error al crear venta: {e}',
      'ERR_UPDATE_SALE': 'Error al actualizar venta: {e}',
      'ERR_DELETE_SALE': 'Error al eliminar venta: {e}',
      'ERR_CREATE_SALE_PRODUCT': 'Error al registrar venta producto: {e}',
      'ERR_GET_SALE_PRODUCT': 'Error al obtener venta producto: {e}',
      'ERR_GET_SALES_BY_BATCH': 'Error al obtener ventas por lote: {e}',
      'ERR_GET_SALES_BY_FARM': 'Error al obtener ventas por granja: {e}',
      'ERR_GET_ALL_SALES': 'Error al obtener todas las ventas: {e}',
      'ERR_UPDATE_SALE_PRODUCT': 'Error al actualizar venta producto: {e}',
      'ERR_DELETE_SALE_PRODUCT': 'Error al eliminar venta producto: {e}',

      // Calendario salud datasource
      'ERR_GET_HEALTH_EVENTS': 'Error al obtener eventos de salud: {e}',
      'ERR_GET_EVENTS_BY_DATE': 'Error al obtener eventos por fecha: {e}',
      'ERR_GET_EVENTS_BY_BATCH': 'Error al obtener eventos por lote: {e}',
      'ERR_GET_EVENTS_BY_TYPE': 'Error al obtener eventos por tipo: {e}',
      'ERR_GET_PENDING_EVENTS': 'Error al obtener eventos pendientes: {e}',
      'ERR_GET_OVERDUE_EVENTS': 'Error al obtener eventos vencidos: {e}',
      'ERR_GET_UPCOMING_EVENTS': 'Error al obtener eventos próximos: {e}',
      'ERR_UPDATE_HEALTH_EVENT': 'Error al actualizar evento: {e}',

      // Excepciones misceláneas
      'ERR_VACCINATION_NOT_FOUND_AFTER_UPDATE': 'Vacunación no encontrada después de actualizar',
      'ERR_RECORD_NOT_FOUND_AFTER_UPDATE': 'Registro no encontrado después de actualizar',
      'ERR_NECROPSY_NOT_FOUND': 'Necropsia no encontrada',
      'ERR_EVENT_NOT_FOUND': 'Evento no encontrado',
      'ERR_NO_ACTIVE_BATCH': 'No hay lote activo',
      'LABEL_GALPON': 'Galpón',
      'ERR_NO_TREATMENT': 'No hay tratamiento',
      'ERR_NO_EFFECTIVE_TREATMENT': 'No hay tratamiento efectivo',

      // PDF - Metadatos
      'PDF_TITLE_PRODUCTION': 'Reporte de Producción - {code}',
      'PDF_TITLE_EXECUTIVE': 'Reporte Ejecutivo - {farm}',
      'PDF_TITLE_COSTS': 'Reporte de Costos - {farm}',
      'PDF_TITLE_SALES': 'Reporte de Ventas - {farm}',
      'PDF_AUTHOR': 'Smart Granja Aves Pro',
      'PDF_SUBJECT_PRODUCTION': 'Reporte de producción de lote avícola',
      'PDF_SUBJECT_EXECUTIVE': 'Resumen ejecutivo de operaciones avícolas',
      'PDF_SUBJECT_COSTS': 'Análisis de costos operativos',
      'PDF_SUBJECT_SALES': 'Análisis de ventas e ingresos',

      // PDF - Encabezados
      'PDF_HEADER_PRODUCTION': 'REPORTE DE PRODUCCIÓN',
      'PDF_HEADER_EXECUTIVE': 'RESUMEN EJECUTIVO',
      'PDF_HEADER_COSTS': 'REPORTE DE COSTOS',
      'PDF_HEADER_SALES': 'REPORTE DE VENTAS',
      'PDF_LOT_SUBTITLE': 'Lote: {code}',
      'PDF_APP_NAME': 'SMART GRANJA AVES',
      'PDF_PERIOD': 'PERÍODO',
      'PDF_DATE_TO': 'al {date}',

      // PDF - Pie de página
      'PDF_GENERATED_BY': 'Generado: {datetime} por {user}',
      'PDF_PAGE': 'Página {current} de {total}',

      // PDF - Información del lote
      'PDF_LOT_INFO': 'INFORMACIÓN DEL LOTE',
      'PDF_LABEL_CODE': 'Código',
      'PDF_LABEL_BIRD_TYPE': 'Tipo de Ave',
      'PDF_LABEL_SHED': 'Galpón',
      'PDF_LABEL_ENTRY_DATE': 'Fecha Ingreso',
      'PDF_LABEL_CURRENT_AGE': 'Edad Actual',
      'PDF_LABEL_DAYS_IN_FARM': 'Días en Granja',
      'PDF_DAYS_UNIT': '{count} días',

      // PDF - Indicadores de producción
      'PDF_PRODUCTION_INDICATORS': 'INDICADORES DE PRODUCCIÓN',
      'PDF_INITIAL_BIRDS': 'Aves Iniciales',
      'PDF_CURRENT_BIRDS': 'Aves Actuales',
      'PDF_MORTALITY': 'Mortalidad',
      'PDF_MORTALITY_BIRDS': '{count} aves',
      'PDF_AVG_WEIGHT': 'Peso Promedio',
      'PDF_WEIGHT_KG': '{value} kg',
      'PDF_WEIGHT_OBJECTIVE': 'Obj: {value} kg',
      'PDF_TOTAL_CONSUMPTION': 'Consumo Total',
      'PDF_CONVERSION': 'Conversión',
      'PDF_CONVERSION_UNIT': 'kg alim / kg peso',

      // PDF - Resumen financiero
      'PDF_FINANCIAL_SUMMARY': 'RESUMEN FINANCIERO',
      'PDF_BIRD_COST': 'Costo de Aves',
      'PDF_FEED_COST': 'Costo de Alimento',
      'PDF_TOTAL_COSTS': 'Total Costos',
      'PDF_SALES_REVENUE': 'Ingresos por Ventas',
      'PDF_BALANCE': 'BALANCE',

      // PDF - Análisis
      'PDF_HIGH_MORTALITY': '⚠ Mortalidad alta ({pct}%). Se recomienda revisión de condiciones sanitarias.',
      'PDF_GOOD_SURVIVAL': '✓ Excelente índice de supervivencia ({pct}%).',
      'PDF_HIGH_CONVERSION': '⚠ Conversión alimenticia alta ({value}). Revisar calidad de alimento.',
      'PDF_GOOD_CONVERSION': '✓ Excelente conversión alimenticia ({value}).',
      'PDF_WEIGHT_BELOW': '⚠ Peso por debajo del objetivo ({diff}g menos).',
      'PDF_WEIGHT_ABOVE': '✓ Peso por encima del objetivo (+{diff}g).',
      'PDF_NO_OBSERVATIONS': 'Sin observaciones relevantes para este período.',
      'PDF_ANALYSIS_TITLE': 'ANÁLISIS Y OBSERVACIONES',

      // PDF - Ejecutivo KPIs
      'PDF_KEY_INDICATORS': 'INDICADORES CLAVE DE DESEMPEÑO',
      'PDF_ACTIVE_LOTS': 'Lotes Activos',
      'PDF_TOTAL_BIRDS': 'Total Aves',
      'PDF_AVG_MORTALITY': 'Mortalidad Prom.',
      'PDF_AVG_CONVERSION': 'Conv. Promedio',

      // PDF - Tabla de lotes
      'PDF_ACTIVE_LOTS_SUMMARY': 'RESUMEN DE LOTES ACTIVOS',
      'PDF_TABLE_LOT': 'Lote',
      'PDF_TABLE_TYPE': 'Tipo',
      'PDF_TABLE_BIRDS': 'Aves',
      'PDF_TABLE_MORTALITY_PCT': 'Mort.%',
      'PDF_TABLE_WEIGHT_KG': 'Peso kg',
      'PDF_TABLE_CONVERSION': 'Conv.',

      // PDF - Ejecutivo financiero
      'PDF_TOTAL_COSTS_LABEL': 'Costos Totales',
      'PDF_TOTAL_SALES_LABEL': 'Ventas Totales',
      'PDF_NET_PROFIT': 'Utilidad Neta',
      'PDF_PROFIT_MARGIN': 'Margen de Utilidad',

      // PDF - Costos
      'PDF_COSTS_SUMMARY': 'RESUMEN DE COSTOS',
      'PDF_BY_CATEGORY': 'Por Categoría',
      'PDF_COSTS_DETAIL': 'DETALLE DE COSTOS',
      'PDF_TABLE_CATEGORY': 'Categoría',
      'PDF_TABLE_CONCEPT': 'Concepto',
      'PDF_TABLE_AMOUNT': 'Monto',
      'PDF_TABLE_DATE': 'Fecha',
      'PDF_TABLE_SUPPLIER': 'Proveedor',

      // PDF - Ventas
      'PDF_SALES_SUMMARY': 'RESUMEN DE VENTAS',
      'PDF_TOTAL_SALES_KPI': 'Total Ventas',
      'PDF_BY_PRODUCT': 'Por Producto',
      'PDF_SALES_DETAIL': 'DETALLE DE VENTAS',
      'PDF_TABLE_PRODUCT': 'Producto',
      'PDF_TABLE_QUANTITY': 'Cantidad',
      'PDF_TABLE_SUBTOTAL': 'Subtotal',
      'PDF_TABLE_CLIENT': 'Cliente',

      // Inventario
      'ERR_ITEM_NOT_FOUND': 'Item no encontrado',
      'ERR_INSUFFICIENT_STOCK':
          'Stock insuficiente. Disponible: {stock} {unit}',

      // Galpón eventos
      'EVT_SHED_CREATED': 'Galpón creado: {name}',
      'EVT_BATCH_ASSIGNED': 'Lote {id} asignado al galpón',
      'EVT_SHED_RELEASED': 'Galpón liberado del lote {id}',
      'EVT_DISINFECTION_DONE': 'Desinfección realizada',

      // Providers salud
      'ERR_VACCINATION_NOT_FOUND': 'Vacunación no encontrada',
      'ERR_RECORD_NOT_FOUND': 'Registro no encontrado',
      'EVT_VACCINATION_TITLE': 'Vacunación: {name}',
      'EVT_VACCINATION_DESC':
          'Aplicar {name} según programa de vacunación',
      'LABEL_SYSTEM': 'Sistema',

      // Alertas sanitarias
      'ALERT_HIGH_MORTALITY_TITLE': 'Mortalidad Elevada',
      'ALERT_HIGH_MORTALITY_DESC':
          'La mortalidad diaria ({rate}%) supera el umbral de {threshold}%',
      'ALERT_MORTALITY_INDICATOR': 'Mortalidad Diaria',
      'ALERT_MORTALITY_REC':
          'Realizar necropsia inmediata. Verificar agua, alimento y condiciones ambientales.',
      'ALERT_ABNORMAL_TEMP_TITLE': 'Temperatura Anormal',
      'ALERT_ABNORMAL_TEMP_DESC':
          'La temperatura ({temp}°C) está fuera del rango óptimo ({min}°C - {max}°C)',
      'ALERT_TEMP_INDICATOR': 'Temperatura',
      'ALERT_TEMP_REC':
          'Ajustar ventilación y calefacción según sea necesario.',

      // Domain defaults
      'DEFAULT_NO_DESCRIPTION': 'Sin descripción disponible',
      'DEFAULT_MORTALITY_RECORD': 'Registro de mortalidad',
      'GRANJA_MAINTENANCE_NOTE':
          'Granja en mantenimiento el {date}',
      'GRANJA_MAINTENANCE_NOTE_REASON':
          'Granja en mantenimiento el {date} - Motivo: {reason}',

      // StateError / UnimplementedError
      'ERR_DOC_NO_DATA': 'Documento {id} no tiene datos',
      'ERR_UNIMPLEMENTED_VACCINATION_INTEGRATION':
          'Integración con ProgramaVacunacion pendiente',
      'ERR_UNIMPLEMENTED_GRANJA_ID_REQUIRED':
          'Se requiere granjaId para eliminar',

      // Colaboradores
      'ERR_GENERIC_PREFIX': 'Error: {e}',

      // Storage
      'STORAGE_READ_ERROR': 'Error al leer archivo{path}',
      'STORAGE_WRITE_ERROR': 'Error al escribir archivo{path}',
      'STORAGE_DELETE_ERROR': 'Error al eliminar archivo{path}',
      'STORAGE_NOT_FOUND': 'Archivo no encontrado{path}',

      // Bioseguridad
      'ERR_NO_INSPECTION_IN_PROGRESS': 'No hay una inspección en progreso',
    },
    'en': {
      // Server
      'SERVER_ERROR': 'Server error',
      'SERVER_ERROR_400': 'Bad request',
      'SERVER_ERROR_401': 'Unauthorized',
      'SERVER_ERROR_403': 'Access denied',
      'SERVER_ERROR_404': 'Resource not found',
      'SERVER_ERROR_409': 'Request conflict',
      'SERVER_ERROR_422': 'Unprocessable data',
      'SERVER_ERROR_429': 'Too many requests',
      'SERVER_ERROR_500': 'Internal server error',
      'SERVER_ERROR_502': 'Connection error',
      'SERVER_ERROR_503': 'Service unavailable',
      'SERVER_ERROR_504': 'Request timed out',
      'SSL_ERROR': 'SSL certificate error',
      'NOT_FOUND': 'Document not found',
      'ALREADY_EXISTS': 'Document already exists',
      'GENERIC_SERVER_ERROR': 'Operation error',

      // Cache
      'CACHE_NOT_FOUND': 'Data not found in cache',
      'CACHE_EXPIRED': 'Cached data expired',
      'CACHE_WRITE_ERROR': 'Error writing to cache',

      // Network
      'NO_CONNECTION': 'No internet connection',
      'TIMEOUT': 'Request timed out',
      'CANCELLED': 'Request cancelled',
      'SERVICE_UNAVAILABLE': 'Service unavailable',

      // Auth
      'INVALID_CREDENTIALS': 'Invalid credentials',
      'USER_NOT_FOUND': 'User not found',
      'EMAIL_ALREADY_IN_USE': 'Email already in use',
      'WEAK_PASSWORD': 'Password is too weak',
      'SESSION_EXPIRED': 'Your session has expired',
      'NO_SESSION': 'No active session',
      'UNAUTHORIZED': 'You do not have permission to perform this action',
      'EMAIL_NOT_VERIFIED': 'Verify your email',
      'INVALID_EMAIL': 'Invalid email address',
      'USER_DISABLED': 'User disabled',
      'TOO_MANY_REQUESTS': 'Too many attempts. Try again later',
      'AUTH_ERROR': 'Authentication error',
      'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          'An account already exists with this email',

      // Validation
      'FORMAT_ERROR': 'Format error',
      'FIELD_REQUIRED': 'Field {field} is required',
      'FIELD_INVALID': 'Field {field} is invalid',

      // Firebase
      'FIREBASE_PERMISSION_DENIED':
          'You do not have permission to perform this action',
      'FIREBASE_UNAVAILABLE': 'Service unavailable',
      'FIREBASE_CANCELLED': 'Operation cancelled',
      'FIREBASE_DEADLINE_EXCEEDED': 'Request timed out',
      'FIREBASE_NOT_FOUND': 'Document not found',
      'FIREBASE_ALREADY_EXISTS': 'Document already exists',
      'FIREBASE_ERROR': 'Firebase error',

      // Unknown
      'UNKNOWN': 'An unexpected error occurred',
      'STORAGE_QUOTA_EXCEEDED': 'Storage space exhausted',

      // Venta validation
      'VENTA_SELECT_LOTE': 'Must select a batch',
      'VENTA_SELECT_GRANJA': 'Must select a farm',
      'VENTA_SELECT_CLIENTE': 'Must specify a client',
      'VENTA_AVES_GREATER_ZERO': 'Bird quantity must be greater than 0',
      'VENTA_PRECIO_KG_GREATER_ZERO': 'Price per kg must be greater than 0',
      'VENTA_PESO_FAENADO_GREATER_ZERO':
          'Slaughter weight must be greater than 0',
      'VENTA_HUEVOS_CLASIFICACION':
          'Must specify at least one egg classification',
      'VENTA_HUEVOS_PRECIOS': 'Must specify prices for classifications',
      'VENTA_HUEVOS_TOTAL_GREATER_ZERO':
          'Total egg quantity must be greater than 0',
      'VENTA_POLLINAZA_GREATER_ZERO':
          'Poultry litter quantity must be greater than 0',
      'VENTA_PRECIO_UNITARIO_GREATER_ZERO': 'Unit price must be greater than 0',
      'VENTA_NOT_EXISTS': 'Sale does not exist',
      'VENTA_CANNOT_MODIFY': 'Cannot modify a {estado} sale',
      'VENTA_LOTE_ID_REQUIRED': 'Batch ID is required',
      'VENTA_ID_REQUIRED': 'Sale ID is required',
      'VENTA_CANNOT_DELETE_COMPLETED': 'Cannot delete a completed sale',
      'VENTA_PESO_PROMEDIO_GREATER_ZERO':
          'Average weight must be greater than 0',

      // Costo validation
      'COSTO_SELECT_GRANJA': 'Must select a farm',
      'COSTO_CONCEPTO_REQUIRED': 'Concept cannot be empty',
      'COSTO_MONTO_GREATER_ZERO': 'Amount must be greater than 0',
      'COSTO_REGISTRADO_POR_REQUIRED': 'Must specify who registers the cost',
      'COSTO_LOTE_ID_REQUIRED': 'Batch ID is required',
      'COSTO_ID_REQUIRED': 'Cost ID is required',
      'COSTO_APROBADOR_REQUIRED': 'Must specify who approves',
      'COSTO_NOT_FOUND': 'Cost not found',
      'COSTO_MOTIVO_RECHAZO_REQUIRED': 'Must specify rejection reason',
      'COSTO_GRANJA_ID_REQUIRED': 'Farm ID is required',
      'COSTO_FECHA_RANGO_INVALIDO': 'Start date cannot be after end date',

      // Granja validation
      'GRANJA_ID_REQUIRED': 'Farm ID is required',
      'GRANJA_NOMBRE_REQUIRED': 'Farm name is required',
      'GRANJA_NOMBRE_MIN_LENGTH': 'Name must have at least 3 characters',
      'GRANJA_PROPIETARIO_REQUIRED': 'Owner is required',
      'GRANJA_RUC_INVALID': 'Invalid RUC (must have 11 numeric digits)',
      'GRANJA_EMAIL_INVALID': 'Invalid email address',
      'GRANJA_CAPACIDAD_NEGATIVE': 'Capacity cannot be negative',
      'GRANJA_AREA_POSITIVE': 'Area must be positive',
      'GRANJA_GALPONES_NEGATIVE': 'Number of sheds cannot be negative',

      // Cliente validation
      'CLIENTE_NOMBRE_REQUIRED': 'Client name is required',
      'CLIENTE_NOMBRE_MIN_LENGTH': 'Name must have at least 3 characters',
      'CLIENTE_ID_REQUIRED': 'Client identification is required',
      'CLIENTE_DNI_FORMAT': 'DNI must have 8 digits',
      'CLIENTE_RUC_FORMAT': 'RUC must have 11 digits',
      'CLIENTE_CONTACTO_REQUIRED': 'Client contact is required',
      'CLIENTE_CONTACTO_MIN_LENGTH': 'Contact must have at least 6 characters',
      'CLIENTE_EMAIL_INVALID': 'Invalid email format',

      // Lote validation
      'LOTE_GRANJA_ID_REQUIRED': 'Farm ID is required',
      'LOTE_GALPON_ID_REQUIRED': 'Shed ID is required',
      'LOTE_CODIGO_REQUIRED': 'Batch code is required',
      'LOTE_CANTIDAD_POSITIVE': 'Initial quantity must be positive',
      'LOTE_EDAD_NEGATIVE': 'Entry age cannot be negative',
      'LOTE_MORTALIDAD_NEGATIVE': 'Mortality cannot be negative',
      'LOTE_DESCARTES_NEGATIVE': 'Discards cannot be negative',
      'LOTE_VENTAS_NEGATIVE': 'Sales cannot be negative',
      'LOTE_BAJAS_EXCEDEN': 'Losses exceed initial quantity',
      'LOTE_PESO_POSITIVE': 'Average weight must be positive',
      'LOTE_COSTO_NEGATIVE': 'Cost per bird cannot be negative',
      'LOTE_CANTIDAD_DEBE_POSITIVA': 'Quantity must be positive',
      'LOTE_NO_PERMITE_REGISTROS':
          'Batch does not allow records in {estado} status',
      'LOTE_AVES_INSUFICIENTES': 'Not enough birds ({disponibles} available)',
      'LOTE_PESO_DEBE_POSITIVO': 'Weight must be positive',
      'LOTE_CONSUMO_NO_PERMITIDO':
          'Cannot record consumption in a {estado} batch',
      'LOTE_SOLO_POSTURA': 'Only laying batches can record eggs',
      'LOTE_PRODUCCION_NO_PERMITIDA':
          'Cannot record production in a {estado} batch',
      'LOTE_CAMBIO_ESTADO_INVALIDO':
          'Cannot change from {estadoActual} to {estadoNuevo}',
      'LOTE_CIERRE_NORMAL': 'Normal closure',
      'LOTE_YA_EN_GALPON': 'Batch is already in that shed',

      // Galpón validation
      'GALPON_GRANJA_ID_REQUIRED': 'Farm ID is required',
      'GALPON_CODIGO_REQUIRED': 'Shed code is required',
      'GALPON_NOMBRE_REQUIRED': 'Shed name is required',
      'GALPON_CAPACIDAD_POSITIVE': 'Capacity must be positive',
      'GALPON_AREA_POSITIVE': 'Area must be positive',
      'GALPON_AVES_NEGATIVE': 'Bird count cannot be negative',
      'GALPON_AVES_EXCEDE_CAPACIDAD': 'Bird count exceeds maximum capacity',
      'GALPON_DENSIDAD_EXCEDE': 'Density exceeds recommended limit for {tipo}',
      'GALPON_ESTADO_REQUIERE_VACIO':
          '{estado} status requires the shed to be empty',
      'GALPON_CAMBIO_ESTADO_INVALIDO':
          'Cannot change from {estadoActual} to {estadoNuevo}',
      'GALPON_CAMBIO_CON_LOTE_ACTIVO':
          'Cannot change to {estadoNuevo} with an active batch',
      'GALPON_DESINFECTAR_CON_LOTE':
          'Cannot disinfect a shed with an active batch',
      'GALPON_NO_DISPONIBLE': 'Shed is not available to receive a batch',
      'GALPON_CAPACIDAD_DEBE_POSITIVA': 'Quantity exceeds maximum capacity',

      // Common prefixes
      'PREFIX_DIRECCION': 'Address: {detail}',
      'PREFIX_COORDENADAS': 'Coordinates: {detail}',
      'PREFIX_UMBRALES': 'Thresholds: {detail}',
      'LOTE_VENDIDO_A': 'Sold to: {comprador}',
      'LOTE_VENDIDO': 'Sold',

      // Bird type descriptions (fallback for non-UI contexts)
      'BIRD_TYPE_BROILER_DESC': 'Birds raised for meat production',
      'BIRD_TYPE_LAYER_DESC': 'Birds raised for egg production',
      'BIRD_TYPE_HEAVY_BREEDER_DESC': 'Heavy-line breeder birds',
      'BIRD_TYPE_LIGHT_BREEDER_DESC': 'Light-line breeder birds',
      'BIRD_TYPE_TURKEY_DESC': 'Turkeys for meat',
      'BIRD_TYPE_QUAIL_DESC': 'Quail for eggs or meat',
      'BIRD_TYPE_DUCK_DESC': 'Ducks for meat',
      'BIRD_TYPE_OTHER_DESC': 'Other type of bird',
      'NOT_RECORDED': 'Not recorded',
      'COMMON_BIRDS': 'birds',
      'NOT_SPECIFIED': 'Not specified',
      'DATE_TODAY': 'Today',
      'DATE_YESTERDAY': 'Yesterday',
      'DATE_DAYS_AGO': '{count} days ago',
      'DATE_WEEKS_AGO': '{count} {unit} ago',
      'DATE_MONTHS_AGO': '{count} {unit} ago',
      'DATE_YEARS_AGO': '{count} {unit} ago',
      'UNIT_WEEK': 'week',
      'UNIT_WEEKS': 'weeks',
      'UNIT_MONTH': 'month',
      'UNIT_MONTHS': 'months',
      'UNIT_YEAR': 'year',
      'UNIT_YEARS': 'years',

      // Granja business methods
      'GRANJA_YA_ACTIVA': 'The farm is already active',
      'GRANJA_SOLO_SUSPENDER_ACTIVA': 'Only an active farm can be suspended',
      'GRANJA_SOLO_MANTENIMIENTO_ACTIVA':
          'Only an active farm can be set to maintenance',

      // CostoGasto entity
      'COSTO_CONCEPTO_VACIO': 'Concept cannot be empty',
      'COSTO_MONTO_MAYOR_CERO': 'Amount must be greater than 0',
      'COSTO_AVES_MAYOR_CERO': 'Bird count must be greater than 0',
      'COSTO_NO_REQUIERE_APROBACION': 'This expense does not require approval',
      'COSTO_YA_APROBADO': 'This expense is already approved',
      'COSTO_MOTIVO_RECHAZO_VACIO': 'You must provide a rejection reason',

      // Salud entities
      'SALUD_DIAGNOSTICO_VACIO': 'Diagnosis cannot be empty',
      'SALUD_REGISTRO_CERRADO': 'The record is already closed',
      'VACUNA_NOMBRE_VACIO': 'Vaccine name cannot be empty',
      'VACUNA_YA_APLICADA': 'The vaccine has already been applied',

      // Lotes usecases
      'LOTE_YA_CERRADO': 'The batch is already closed',
      'LOTE_YA_VENDIDO_UC': 'The batch has already been sold',
      'LOTE_FECHA_CIERRE_ANTERIOR_INGRESO':
          'The closing date cannot be before the entry date',
      'LOTE_FECHA_CIERRE_FUTURA': 'The closing date cannot be in the future',
      'LOTE_ACTIVO_EN_GALPON': 'There is already an active batch in this house',
      'LOTE_PESO_MAYOR_CERO': 'Average weight must be greater than 0',
      'LOTE_NO_ELIMINAR_ACTIVO':
          'Cannot delete an active batch. Close it first.',
      'LOTE_CANTIDAD_MINIMA': 'Initial quantity must be at least 10 birds',

      // Galpones usecases
      'GALPON_SIN_LOTE': 'The house does not have any assigned batch.',
      'GALPON_CON_LOTE_NO_ELIMINAR':
          'Cannot delete a house with an assigned batch. Release the batch first.',
      'GALPON_EN_CUARENTENA_NO_ELIMINAR':
          'Cannot delete a house in quarantine. It must exit quarantine first.',
      'GALPON_EN_PROCESO_CONFIRMAR':
          'The house is in {estado}. Are you sure you want to delete it?',
      'GALPON_CODIGO_DUPLICADO':
          'A house with that code already exists in this farm',
      'GALPON_NOMBRE_DUPLICADO':
          'A house with that name already exists in this farm',
      'GALPON_TRANSICION_INVALIDA':
          'Cannot change from {estadoActual} to {estadoNuevo}',
      'GALPON_MOTIVO_CUARENTENA': 'You must specify the quarantine reason',
      'GALPON_CON_LOTE_CONTINUAR':
          'The house has an assigned batch. Do you want to continue?',
      'GALPON_INACTIVAR_CON_LOTE':
          'Cannot deactivate a house with an assigned batch. Release the batch first.',
      'GALPON_ACTIVO_PARA_LOTE':
          'The house must be active to assign a batch. Current status: {estado}',
      'GALPON_LOTE_YA_ASIGNADO':
          'The house already has an assigned batch. Release the current batch first.',
      'GALPON_DESINFECCION_TRANSICION':
          'Cannot register disinfection from status {estado}',
      'GALPON_DESINFECCION_CON_LOTE':
          'The house has an assigned batch. Disinfection must be performed without animals present.',
      'GALPON_DESINFECCION_PRODUCTOS':
          'You must specify at least one disinfection product',
      'GALPON_MANTENIMIENTO_TRANSICION':
          'Cannot schedule maintenance from status {estado}',
      'GALPON_MANTENIMIENTO_CON_LOTE':
          'The house has an assigned batch. It is recommended to release the batch before maintenance.',
      'GALPON_MANTENIMIENTO_FECHA_FUTURA':
          'The start date must be in the future',
      'GALPON_MANTENIMIENTO_DESCRIPCION':
          'You must specify a maintenance description',

      // Granjas usecases
      'GRANJA_NO_ENCONTRADA': 'Farm not found',
      'GRANJA_NOMBRE_DUPLICADO': 'A farm with that name already exists',
      'GRANJA_ACTIVA_NO_ELIMINAR':
          'Cannot delete an active farm. Suspend it first.',
      'GRANJA_CON_GALPONES_ACTIVOS':
          'Cannot delete the farm because it has active houses.',
      'GRANJA_CON_LOTES_ACTIVOS':
          'Cannot delete the farm because it has active batches.',

      // Salud usecases
      'VACUNACION_NO_ENCONTRADA': 'Vaccination not found',
      'VACUNA_EDAD_OBLIGATORIA':
          'Application age is required and must be greater than 0',
      'VACUNA_DOSIS_OBLIGATORIA': 'Dose is required',
      'VACUNA_VIA_OBLIGATORIA': 'Application route is required',

      // ServerFailure prefix
      'ERROR_REGISTRAR_COSTO': 'Error registering cost',
      'ERROR_ACTUALIZAR_LOTE': 'Error updating batch',
      'ERROR_CERRAR_LOTE': 'Error closing batch',
      'ERROR_ELIMINAR_LOTE': 'Error deleting batch',
      'ERROR_REGISTRAR_CONSUMO': 'Error registering consumption',
      'ERROR_REGISTRAR_PESO': 'Error registering weight',
      'ERROR_ACTUALIZAR_GALPON': 'Error updating house',
      'ERROR_ASIGNAR_LOTE': 'Error assigning batch',
      'ERROR_CAMBIAR_ESTADO': 'Error changing status',
      'ERROR_CREAR_GALPON': 'Error creating house',
      'ERROR_ELIMINAR_GALPON': 'Error deleting house',
      'ERROR_LIBERAR_GALPON': 'Error releasing house',
      'ERROR_OBTENER_GALPONES': 'Error fetching houses',
      'ERROR_REGISTRAR_DESINFECCION': 'Error registering disinfection',
      'ERROR_PROGRAMAR_MANTENIMIENTO': 'Error scheduling maintenance',
      'ERROR_ACTIVAR_GRANJA': 'Error activating farm',
      'ERROR_BUSCAR_GRANJAS': 'Error searching farms',
      'ERROR_CREAR_GRANJA': 'Error creating farm',
      'ERROR_OBTENER_DASHBOARD': 'Error fetching dashboard',
      'ERROR_SUSPENDER_GRANJA': 'Error suspending farm',
      'ERROR_ACTUALIZAR_GRANJA': 'Unexpected error updating farm',
      'ERROR_ELIMINAR_GRANJA': 'Unexpected error deleting farm',
      'ERROR_APLICAR_VACUNA': 'Error applying vaccine',

      // Lotes usecases - registrar pesos
      'LOTE_NO_REGISTRAR_PESO': 'Cannot register weight for a {estado} batch',

      // Lotes usecases - additional
      'ERROR_CREAR_LOTE_UC': 'Unexpected error creating batch: {detail}',
      'ERROR_OBTENER_ESTADISTICAS': 'Error fetching statistics: {detail}',
      'ERROR_OBTENER_DISPONIBLES': 'Error fetching available houses: {detail}',
      'ERROR_MANTENIMIENTO_GRANJA':
          'Error setting farm to maintenance: {detail}',
      'ERROR_REGISTRAR_MORTALIDAD':
          'Unexpected error registering mortality: {detail}',
      'ERROR_REGISTRAR_PRODUCCION': 'Error registering production: {detail}',
      'LOTE_NO_EDITAR_CERRADO_VENDIDO': 'Cannot edit a closed or sold batch',
      'LOTE_NO_REGISTRAR_CONSUMO_UC':
          'Cannot record consumption in a {estado} batch',
      'LOTE_CANTIDAD_ALIMENTO_MAYOR_CERO':
          'Food quantity must be greater than 0',
      'LOTE_NO_REGISTRAR_MORTALIDAD_UC':
          'Cannot record mortality in a batch with {estado} status',
      'LOTE_MORTALIDAD_MAYOR_CERO': 'Dead bird count must be greater than 0',
      'LOTE_MORTALIDAD_EXCEDE_CANTIDAD':
          'Dead bird count ({cantidad}) exceeds current batch count ({cantidadActual})',
      'LOTE_SOLO_PONEDORAS_PRODUCCION':
          'Only layer batches can register egg production',
      'LOTE_NO_REGISTRAR_PRODUCCION_UC':
          'Cannot register production in a {estado} batch',
      'LOTE_HUEVOS_MAYOR_CERO': 'Egg quantity must be greater than 0',
      'REGISTRO_SALUD_NO_ENCONTRADO': 'Health record not found',

      // Value objects - lote_finanzas
      'LOTE_FINANZAS_YA_CERRADO': 'Batch is already closed',
      'LOTE_FINANZAS_YA_VENDIDO': 'Batch has already been sold',

      // Value objects - lote_produccion
      'LOTE_PROD_PESO_POSITIVO': 'Weight must be positive',
      'LOTE_PROD_CONSUMO_POSITIVO': 'Consumption quantity must be positive',
      'LOTE_PROD_HUEVOS_POSITIVO': 'Egg quantity must be positive',

      // Value objects - lote_estadisticas
      'LOTE_EST_MORTALIDAD_POSITIVA': 'Mortality count must be positive',
      'LOTE_EST_MORTALIDAD_EXCEDE':
          'Mortality count ({cantidad}) cannot exceed current count ({cantidadActual})',

      // Entity validation - common
      'VAL_LOTE_ID_REQUIRED': 'Batch ID is required',
      'VAL_GRANJA_ID_REQUIRED': 'Farm ID is required',
      'VAL_GALPON_ID_REQUIRED': 'House ID is required',
      'VAL_EDAD_NEGATIVA': 'Age cannot be negative',

      // Entity validation - registro_peso
      'REG_PESO_PROMEDIO_MAYOR_CERO': 'Average weight must be greater than 0',
      'REG_PESO_AVES_MINIMA': 'Must weigh at least 1 bird',
      'REG_PESO_TOTAL_MAYOR_CERO': 'Total weight must be greater than 0',
      'REG_PESO_MINIMO_MAYOR_CERO': 'Minimum weight must be greater than 0',
      'REG_PESO_MAX_MAYOR_MIN': 'Maximum weight must be >= minimum weight',
      'REG_PESO_MAX_FOTOS': 'Maximum 3 photos per record',

      // Entity validation - registro_produccion
      'REG_PROD_HUEVOS_NO_NEGATIVO': 'Collected eggs cannot be negative',
      'REG_PROD_BUENOS_NO_NEGATIVO': 'Good eggs cannot be negative',
      'REG_PROD_BUENOS_NO_SUPERAR': 'Good eggs cannot exceed collected eggs',
      'REG_PROD_AVES_MAYOR_CERO': 'Bird count must be greater than 0',
      'REG_PROD_MAX_FOTOS': 'Maximum 3 photos per record',
      'REG_PROD_PESO_POSITIVO': 'Average weight must be positive',

      // Entity validation - registro_consumo
      'REG_CONSUMO_CANTIDAD_MAYOR_CERO': 'Quantity must be greater than 0',
      'REG_CONSUMO_AVES_MINIMA': 'Must have at least 1 bird',
      'REG_CONSUMO_COSTO_NO_NEGATIVO': 'Cost cannot be negative',
      'REG_CONSUMO_USUARIO_REQUIRED': 'Registering user is required',
      'REG_CONSUMO_NOMBRE_REQUIRED': 'User name is required',
      'REG_CONSUMO_FECHA_NO_FUTURA': 'Date cannot be in the future',

      // Entity validation - registro_mortalidad
      'REG_MORT_CANTIDAD_MAYOR_CERO': 'Quantity must be greater than 0',
      'REG_MORT_DESCRIPCION_MIN': 'Description must be at least 10 characters',
      'REG_MORT_MAX_FOTOS': 'Maximum 5 photos per record',
      'REG_MORT_CANTIDAD_EVENTO_INVALIDA': 'Quantity before event is invalid',
      'REG_MORT_EXCEDE_DISPONIBLES': 'Quantity cannot exceed available birds',

      // Value objects - direccion
      'DIR_CALLE_REQUIRED': 'Street is required',
      'DIR_CALLE_MIN_LENGTH': 'Street must be at least 3 characters',
      'DIR_CIUDAD_REQUIRED': 'City is required',
      'DIR_DEPARTAMENTO_REQUIRED': 'Department is required',

      // Value objects - umbrales_ambientales
      'UMBRAL_TEMP_MIN_MAYOR_MAX':
          'Minimum temperature must be less than maximum',
      'UMBRAL_HUM_MIN_MAYOR_MAX': 'Minimum humidity must be less than maximum',
      'UMBRAL_HUM_RANGO': 'Humidity must be between 0 and 100%',
      'UMBRAL_AMONIACO_NEGATIVO': 'Ammonia level cannot be negative',
      'UMBRAL_CO2_NEGATIVO': 'CO2 level cannot be negative',

      // Salud usecases - tratamiento
      'SALUD_DIAGNOSTICO_OBLIGATORIO': 'Diagnosis is required',
      'SALUD_TRATAMIENTO_OBLIGATORIO': 'Treatment is required',
      'SALUD_FECHA_NO_FUTURA': 'Registration date cannot be in the future',
      'ERROR_REGISTRAR_TRATAMIENTO': 'Error registering treatment: {detail}',

      // Salud usecases - vacunación
      'VACUNA_NOMBRE_OBLIGATORIO': 'Vaccine name is required',
      'ERROR_PROGRAMAR_VACUNACION': 'Error scheduling vaccination: {detail}',

      // Salud usecases - cerrar registro
      'ERROR_CERRAR_REGISTRO_SALUD': 'Error closing health record: {detail}',

      // Galpones - actualizar duplicados
      'GALPON_CODIGO_DUPLICADO_ACTUALIZAR':
          'A house with that code already exists',
      'GALPON_NOMBRE_DUPLICADO_ACTUALIZAR':
          'A house with that name already exists',

      // Granjas - dashboard
      'GRANJA_NO_ENCONTRADA_DASHBOARD': 'Farm not found',

      // Value objects - coordenadas
      'COORD_LATITUD_RANGO': 'Latitude must be between -90 and 90',
      'COORD_LONGITUD_RANGO': 'Longitude must be between -180 and 180',

      // Value objects - location phone validation
      'PHONE_START_VENEZUELA': 'Phone must start with 4 or 2',
      'PHONE_START_COLOMBIA': 'Phone must start with 3',
      'PHONE_START_ARGENTINA': 'Phone must start with 1, 2 or 3',
      'PHONE_START_BOLIVIA': 'Phone must start with 6 or 7',
      'PHONE_START_DEFAULT': 'Phone must start with 9',

      // Enum fromJson errors
      'ENUM_INVALID_TIPO_GALPON': 'Invalid TipoGalpon: {value}',
      'ENUM_INVALID_ESTADO_GALPON': 'Invalid EstadoGalpon: {value}',
      'ENUM_INVALID_ESTADO_GRANJA': 'Invalid EstadoGranja: {value}',
      'ENUM_INVALID_CAUSA_MORTALIDAD': 'Invalid CausaMortalidad: {value}',

      // Inventario - movimiento asserts
      'MOVIMIENTO_TIPO_ENTRADA': 'Type must be an entry',
      'MOVIMIENTO_TIPO_SALIDA': 'Type must be an exit',

      // Domain data - enfermedad_avicola
      'ENF_NO_ESPECIFICADO': 'Not specified',
      'ENF_CONSULTAR_VETERINARIO': 'Consult veterinarian',
      'ENF_NO_CONTAGIOSA': 'Not contagious',
      'ENF_DIAG_VIRAL': 'PCR, ELISA, Viral isolation',
      'ENF_DIAG_BACTERIANA': 'Bacterial culture, Antibiogram',
      'ENF_DIAG_PARASITARIA': 'Coprological exam, Necropsy',
      'ENF_DIAG_FUNGICA': 'Mycological culture, Histopathology',
      'ENF_DIAG_NUTRICIONAL': 'Feed analysis, Clinical evaluation',
      'ENF_DIAG_METABOLICA': 'Biochemical analysis, Histopathology',
      'ENF_DIAG_AMBIENTAL': 'Environmental assessment, Water analysis',
      'ENF_TRANS_VIRAL': 'Aerosol, direct contact, fomites',
      'ENF_TRANS_BACTERIANA': 'Direct contact, water, contaminated feed',
      'ENF_TRANS_PARASITARIA': 'Oral-fecal, intermediate vectors',
      'ENF_TRANS_FUNGICA': 'Spore inhalation, contaminated litter',
      'ENF_TRANS_DEFAULT': 'Variable depending on conditions',

      // Auth loading messages
      'AUTH_LOADING_LOGIN': 'Signing in...',
      'AUTH_LOADING_GOOGLE': 'Connecting with Google...',
      'AUTH_LOADING_APPLE': 'Connecting with Apple...',
      'AUTH_LOADING_REGISTER': 'Creating account...',
      'AUTH_LOADING_LOGOUT': 'Signing out...',
      'AUTH_LOADING_EMAIL': 'Sending email...',
      'AUTH_LOADING_PASSWORD': 'Changing password...',
      'AUTH_LOADING_PROFILE': 'Updating profile...',
      'AUTH_LOADING_VERIFYING': 'Verifying identity...',
      'AUTH_LOADING_LINKING': 'Linking {provider} account...',
      'AUTH_SESSION_CLOSED': 'Session closed',
      'AUTH_NO_PENDING_CREDENTIAL': 'No pending credential to link',
      'AUTH_PASSWORD_UPDATED': 'Password updated successfully',
      'AUTH_USER_NOT_AUTHENTICATED': 'User not authenticated',

      // Galpon form validation
      'GALPON_FORM_CODIGO_REQUERIDO': 'Code is required',
      'GALPON_FORM_CODIGO_MIN': 'Code must be at least 2 characters',
      'GALPON_FORM_NOMBRE_REQUERIDO': 'Name is required',
      'GALPON_FORM_NOMBRE_MIN': 'Name must be at least 3 characters',
      'GALPON_FORM_TIPO_REQUERIDO': 'Type is required',
      'GALPON_FORM_CAPACIDAD_POSITIVA': 'Capacity must be greater than 0',

      // Router errors
      'ROUTER_INVITATION_NOT_FOUND': 'Invitation data not found',
      'ROUTER_BATCH_INFO_MISSING': 'Batch information not provided',

      // Permissions
      'PERM_NO_CHANGE_ROLE': 'You do not have permission to change roles',
      'PERM_NO_ASSIGN_OWNER': 'Cannot assign owner role',
      'PERM_NO_REMOVE_USER': 'You do not have permission to remove users',

      // Costos provider
      'COSTO_REGISTRADO_OK': 'Expense registered successfully',
      'COSTO_ACTUALIZADO_OK': 'Expense updated successfully',
      'COSTO_ELIMINADO_OK': 'Expense deleted successfully',
      'ERROR_ACTUALIZAR_COSTO': 'Error updating expense',
      'ERROR_ELIMINAR_COSTO': 'Error deleting expense',
      'COSTO_APROBADO_OK': 'Expense approved successfully',
      'COSTO_RECHAZADO_OK': 'Expense rejected',

      // Ventas provider
      'VENTA_REGISTRADA_OK': 'Sale registered successfully',
      'VENTA_ACTUALIZADA_OK': 'Sale updated successfully',
      'VENTA_ELIMINADA_OK': 'Sale deleted successfully',

      // Recent activities - titles
      'ACT_PRODUCCION_REGISTRADA': 'Production recorded',
      'ACT_MORTALIDAD_REGISTRADA': 'Mortality recorded',
      'ACT_CONSUMO_REGISTRADO': 'Consumption recorded',
      'ACT_PESAJE_REGISTRADO': 'Weighing recorded',
      'ACT_GASTO_REGISTRADO': 'Expense recorded',
      'ACT_VENTA_REGISTRADA': 'Sale recorded',
      'ACT_REGISTRO_SALUD': 'Health record',
      'ACT_VACUNACION_APLICADA': 'Vaccination applied',
      'ACT_VACUNACION_PROGRAMADA': 'Vaccination scheduled',
      'ACT_NUEVO_LOTE': 'New batch',
      'ACT_NECROPSIA_REALIZADA': 'Necropsy performed',
      'ACT_INSPECCION_BIOSEGURIDAD': 'Biosecurity inspection',

      // Recent activities - subtitles with format
      'ACT_SUB_HUEVOS': '{count} eggs',
      'ACT_SUB_AVES': '{count} birds',
      'ACT_SUB_PROMEDIO': '{peso}g average',
      'ACT_SUB_LOTE_DETALLE': '{codigo} • {cantidad} birds',
      'ACT_SUB_NECROPSIA': '{numAves} birds • {diagnostico}',
      'ACT_SUB_PUNTAJE': 'Score: {puntaje}% • {inspector}',

      // Recent activities - sale type labels
      'ACT_VENTA_AVES_VIVAS': 'Live birds',
      'ACT_VENTA_AVES_FAENADAS': 'Slaughtered birds',
      'ACT_VENTA_AVES_DESCARTE': 'Discarded birds',
      'ACT_VENTA_HUEVOS': 'Eggs',
      'ACT_VENTA_POLLINAZA': 'Poultry litter',

      // Recent activities - movement titles
      'ACT_MOV_COMPRA': 'Inventory purchase',
      'ACT_MOV_DONACION': 'Donation received',
      'ACT_MOV_CONSUMO_LOTE': 'Batch consumption',
      'ACT_MOV_TRATAMIENTO': 'Treatment applied',
      'ACT_MOV_VACUNACION': 'Vaccination',
      'ACT_MOV_AJUSTE_POS': 'Positive adjustment',
      'ACT_MOV_AJUSTE_NEG': 'Negative adjustment',
      'ACT_MOV_DEVOLUCION': 'Return',
      'ACT_MOV_MERMA': 'Shrinkage',
      'ACT_MOV_TRANSFERENCIA': 'Transfer',
      'ACT_MOV_USO_GENERAL': 'General use',
      'ACT_MOV_VENTA': 'Sale',

      // Recent activities - barn event titles
      'ACT_EVT_DESINFECCION': 'Disinfection',
      'ACT_EVT_MANTENIMIENTO': 'Maintenance',
      'ACT_EVT_CAMBIO_ESTADO': 'Status change',
      'ACT_EVT_GALPON_CREADO': 'Barn created',
      'ACT_EVT_LOTE_ASIGNADO': 'Batch assigned',
      'ACT_EVT_LOTE_LIBERADO': 'Batch released',
      'ACT_EVT_EVENTO': 'Event',

      // Recent activities - fallbacks and formats
      'ACT_FALLBACK_REGISTRO': 'Record',
      'ACT_FALLBACK_VACUNA': 'Vaccine',
      'ACT_FALLBACK_EVENTO': 'Event',
      'ACT_FALLBACK_EN_EVALUACION': 'Under evaluation',
      'ACT_FALLBACK_INSPECTOR': 'Inspector',
      'ACT_SUB_INVENTARIO': '{signo}{cantidad} units',
      'ACT_HUEVOS_CLASIFICACION': '{clasificacion} ({cantidad} units)',
      'UNIT_AVES': 'birds',
      'UNIT_UNIDADES': 'units',
      'UNIT_SACOS': 'bags',
      'CONCEPTO_MOVIMIENTO': '{tipo}: {item} ({cantidad} {unidad})',

      // Sync status
      'SYNC_PENDING': 'Pending',
      'SYNC_LOCAL': 'Local',
      'SYNC_SYNCED': 'Synced',
      'SYNC_TOOLTIP_PENDING': 'Data pending synchronization',
      'SYNC_TOOLTIP_CACHE': 'Data from local cache',
      'SYNC_TOOLTIP_SYNCED': 'Data synchronized with server',
      'SYNC_OFFLINE_MODE': 'Offline mode',
      'SYNC_OFFLINE_MSG':
          'Changes will be saved locally and synced when you reconnect',
      'SYNC_NO_CONNECTION': 'No connection',
      'SYNC_NO_CONNECTION_MSG':
          'No internet connection. Displayed data may not be up to date',
      'SYNC_SYNCING': 'Syncing',
      'SYNC_SYNCING_MSG': 'Uploading changes to server...',
      'SYNC_LAST_SYNC': 'Last sync: {time}',
      'SYNC_CONNECTED_VIA': 'Connected via {type}',
      'SYNC_ALL_SYNCED': 'All synced',
      'SYNC_JUST_NOW': 'just now',
      'SYNC_MINUTES_AGO': '{min} min ago',
      'SYNC_HOURS_AGO': '{hours} hours ago',
      'SYNC_DAYS_AGO': '{days} days ago',
      'SYNC_NOW': 'now',
      'SYNC_AGO_M': '{min}m ago',
      'SYNC_AGO_H': '{hours}h ago',
      'SYNC_AGO_D': '{days}d ago',

      // Connectivity
      'CONN_MOBILE_DATA': 'Mobile data',
      'CONN_NO_CONNECTION': 'No connection',
      'CONN_OTHER': 'Other connection',

      // Inventory integration motivos
      'MOTIVO_COMPRA_COSTOS': 'Purchase registered from Costs',
      'MOTIVO_CONSUMO_LOTE': 'Feed consumption in batch',
      'MOTIVO_VENTA': 'Sale of {producto}',
      'MOTIVO_FALLBACK_PRODUCTO': 'product',
      'MOTIVO_TRATAMIENTO': 'Treatment application',
      'MOTIVO_VACUNA': 'Vaccine application',
      'MOTIVO_DESINFECCION': 'Barn disinfection',

      // Inventory cost categories
      'CAT_ALIMENTACION': 'Feed',
      'CAT_SANIDAD': 'Health',
      'CAT_EQUIPAMIENTO': 'Equipment',
      'CAT_LIMPIEZA': 'Cleaning',
      'CAT_INSUMOS': 'Supplies',
      'CAT_OTROS': 'Other',
      'CONCEPTO_COMPRA_ITEM': 'Purchase of {item} ({cantidad} {unidad})',
      'OBS_AUTO_INVENTARIO':
          'Auto-generated from Inventory. Item: {item}, Quantity: {cantidad} {unidad}, Unit price: \${precio}',
      'OBS_AUTO_MOVIMIENTO': 'Auto-generated from inventory movement. {motivo}',

      // Trends
      'TREND_INCREASING': 'increasing',
      'TREND_DECREASING': 'decreasing',
      'TREND_STABLE': 'stable',

      // Reports fallback
      'FALLBACK_GALPON': 'Barn',

      // Accessibility
      'A11Y_FILTER_BY': 'Filter by {label}',

      // Causa mortalidad - recommended actions
      'CAUSA_ACT_ENF_1': 'Request veterinary diagnosis',
      'CAUSA_ACT_ENF_2': 'Isolate affected birds',
      'CAUSA_ACT_ENF_3': 'Apply treatment if available',
      'CAUSA_ACT_ENF_4': 'Increase biosecurity',
      'CAUSA_ACT_ENF_5': 'Review vaccination program',
      'CAUSA_ACT_ACC_1': 'Inspect facilities',
      'CAUSA_ACT_ACC_2': 'Repair damaged equipment',
      'CAUSA_ACT_ACC_3': 'Review bird density',
      'CAUSA_ACT_ACC_4': 'Train staff on handling',
      'CAUSA_ACT_DES_1': 'Verify feed access',
      'CAUSA_ACT_DES_2': 'Review feed quality',
      'CAUSA_ACT_DES_3': 'Check waterer operation',
      'CAUSA_ACT_DES_4': 'Adjust nutritional program',
      'CAUSA_ACT_EST_1': 'Regulate ambient temperature',
      'CAUSA_ACT_EST_2': 'Improve ventilation',
      'CAUSA_ACT_EST_3': 'Reduce density if necessary',
      'CAUSA_ACT_MET_1': 'Consult with nutritionist',
      'CAUSA_ACT_MET_2': 'Review growth program',
      'CAUSA_ACT_MET_3': 'Adjust feed formulation',
      'CAUSA_ACT_DEP_1': 'Reinforce perimeter fences',
      'CAUSA_ACT_DEP_2': 'Implement pest control',
      'CAUSA_ACT_DEP_3': 'Install protective netting',
      'CAUSA_ACT_NORMAL': 'Normal in the production process',
      'CAUSA_ACT_DESC_1': 'Request necropsy if mortality is high',
      'CAUSA_ACT_DESC_2': 'Increase flock monitoring',
      'CAUSA_ACT_DESC_3': 'Consult with veterinarian',

      // Causa mortalidad - categories
      'CAUSA_CAT_SANITARIA': 'Sanitary',
      'CAUSA_CAT_MANEJO': 'Management',
      'CAUSA_CAT_NUTRICIONAL': 'Nutritional',
      'CAUSA_CAT_AMBIENTAL': 'Environmental',
      'CAUSA_CAT_FISIOLOGICA': 'Physiological',
      'CAUSA_CAT_NATURAL': 'Natural',
      'CAUSA_CAT_SIN_CLASIFICAR': 'Unclassified',

      // Poultry disease - symptoms and treatments (pipe-separated)
      'ENF_NEWCASTLE_SINT':
          'Respiratory problems|Green diarrhea|Torticollis|Paralysis|Production drop|High mortality',
      'ENF_NEWCASTLE_TRAT':
          'Preventive vaccination|Strict quarantine|Sanitary slaughter in severe cases',
      'ENF_GUMBORO_SINT':
          'Depression|Whitish watery diarrhea|Ruffled feathers|Bursa of Fabricius inflammation|Immunosuppression',
      'ENF_GUMBORO_TRAT':
          'Vaccination per program|Strict biosecurity|Stress control',
      'ENF_MAREK_SINT':
          'Leg and wing paralysis|Organ tumors|Gray iris (gray eye)|Weight loss|Sudden death',
      'ENF_MAREK_TRAT':
          'In-ovo or day-of-age vaccination|No treatment available|Elimination of affected birds',
      'ENF_BRONQUITISINFECCIOSA_SINT':
          'Sneezing|Tracheal rales|Nasal discharge|Production drop|Deformed eggs|Kidney problems',
      'ENF_BRONQUITISINFECCIOSA_TRAT':
          'Multiple vaccination|Adequate ventilation|Ammonia control',
      'ENF_INFLUENZAAVIAR_SINT':
          'Sudden death|Facial edema|Comb and wattle cyanosis|Leg hemorrhages|Drastic production drop|Nervous symptoms',
      'ENF_INFLUENZAAVIAR_TRAT':
          'Mandatory notification|Sanitary slaughter|Zone quarantine|Maximum biosecurity',
      'ENF_LARINGOTRAQUEITIS_SINT':
          'Severe dyspnea|Neck stretching to breathe|Blood in trachea|Bloody cough|High mortality from asphyxia',
      'ENF_LARINGOTRAQUEITIS_TRAT':
          'Preventive vaccination|Isolation of affected birds|Rigorous disinfection',
      'ENF_VIRUELAAVIAR_SINT':
          'Comb and wattle nodules|Mouth lesions (diphtheritic form)|Skin scabs|Difficulty eating',
      'ENF_VIRUELAAVIAR_TRAT':
          'Preventive vaccination|Mosquito control|Lesion treatment with antiseptics',
      'ENF_ANEMIINFECCIOSA_SINT':
          'Paleness|Anemia|Muscle hemorrhages|Immunosuppression|Gangrenous dermatitis',
      'ENF_ANEMIINFECCIOSA_TRAT':
          'Breeder vaccination|Biosecurity|Immunosuppressor control',
      'ENF_COLIBACILOSIS_SINT':
          'Septicemia|Perihepatitis|Pericarditis|Airsacculitis|Chick omphalitis|Cellulitis',
      'ENF_COLIBACILOSIS_TRAT':
          'Antibiotics per antibiogram|Biosecurity improvement|Water quality control|Stress reduction',
      'ENF_SALMONELOSIS_SINT':
          'Diarrhea|Omphalitis|Chick septicemia|Asymptomatic carriers|Production drop',
      'ENF_SALMONELOSIS_TRAT':
          'Mandatory control program|Vaccination|Strict biosecurity|Serological monitoring',
      'ENF_MYCOPLASMOSIS_SINT':
          'Sneezing|Nasal discharge|Rales|Sinus inflammation|Synovitis (MS)|Production drop',
      'ENF_MYCOPLASMOSIS_TRAT':
          'Antibiotics (tylosin, enrofloxacin)|Preventive vaccination|Mycoplasma-free flocks',
      'ENF_COLERAAVIAR_SINT':
          'Sudden death|High fever|Green diarrhea|Comb cyanosis|Arthritis|Torticollis',
      'ENF_COLERAAVIAR_TRAT':
          'Antibiotics (sulfas, tetracyclines)|Vaccination in endemic areas|Elimination of chronic carriers',
      'ENF_CORIZA_SINT':
          'Facial swelling|Fetid nasal discharge|Conjunctivitis|Sneezing|Characteristic foul odor',
      'ENF_CORIZA_TRAT':
          'Antibiotics (sulfas, erythromycin)|Preventive vaccination|Elimination of carriers',
      'ENF_CLOSTRIDIOSISNECROTICA_SINT':
          'Sudden death|Dark diarrhea|Ruffled feathers|Depression|Intestinal necrotic lesions',
      'ENF_CLOSTRIDIOSISNECROTICA_TRAT':
          'Antibiotics (bacitracin, lincomycin)|Coccidiosis control|Litter management|Alternative additives',
      'ENF_COCCIDIOSIS_SINT':
          'Bloody diarrhea|Ruffled feathers|Depression|Weight loss|Dehydration|High mortality',
      'ENF_COCCIDIOSIS_TRAT':
          'Anticoccidials in feed|Live vaccines|Dry litter management|Active ingredient rotation',
      'ENF_ASCARIDIASIS_SINT':
          'Weight loss|Paleness|Diarrhea|Intestinal obstruction (severe cases)',
      'ENF_ASCARIDIASIS_TRAT':
          'Periodic deworming|Paddock rotation|Hygienic management',
      'ENF_ASPERGILOSIS_SINT':
          'Respiratory difficulty|Dyspnea|Lung nodules|High chick mortality',
      'ENF_ASPERGILOSIS_TRAT':
          'Eliminate fungal sources|Incubator disinfection|No effective treatment',
      'ENF_ASCITIS_SINT':
          'Distended abdomen|Abdominal fluid|Cyanosis|Respiratory difficulty|Sudden death',
      'ENF_ASCITIS_TRAT':
          'Early feed restriction|Growth rate control|Adequate ventilation|Altitude (risk factor)',
      'ENF_MUERTESUBITA_SINT':
          'Sudden death of apparently healthy birds|Birds in dorsal position|More common in fast-growing males',
      'ENF_MUERTESUBITA_TRAT':
          'Feed restriction|Growth control|Lighting programs',
      'ENF_DEFICIENCIAVITAMINAE_SINT': 'Ataxia|Torticollis|Seizures|Paralysis',
      'ENF_DEFICIENCIAVITAMINAE_TRAT':
          'Vitamin E supplementation|Antioxidants in feed',
      'ENF_RAQUITISMO_SINT': 'Soft bones|Bent legs|Soft beak|Weak eggshells',
      'ENF_RAQUITISMO_TRAT':
          'Calcium, Phosphorus and Vitamin D3 level correction|Sun exposure',

      // Provider error messages
      'ERR_LOADING_ALERTS': 'Error loading alerts: {e}',
      'ERR_LOADING_INSPECTIONS': 'Error loading inspections: {e}',
      'ERR_SAVING_INSPECTION': 'Error saving inspection: {e}',
      'ERR_LOADING_PROGRAMS': 'Error loading programs: {e}',
      'ERR_LOADING_NECROPSIES': 'Error loading necropsies: {e}',
      'ERR_LOADING_BATCH_NECROPSIES': 'Error loading batch necropsies: {e}',
      'ERR_REGISTERING_NECROPSY': 'Error registering necropsy: {e}',
      'ERR_UPDATING_RESULT': 'Error updating result: {e}',
      'ERR_CONFIRMING_DIAGNOSIS': 'Error confirming diagnosis: {e}',
      'ERR_DELETING_NECROPSY': 'Error deleting necropsy: {e}',
      'ERR_LOADING_STATISTICS': 'Error loading statistics: {e}',
      'ERR_LOADING_ANTIMICROBIAL_USES': 'Error loading antimicrobial uses: {e}',
      'ERR_LOADING_WITHDRAWAL_BATCHES': 'Error loading withdrawal batches: {e}',
      'ERR_REGISTERING_ANTIMICROBIAL_USE': 'Error registering antimicrobial use: {e}',
      'ERR_GENERATING_REPORT': 'Error generating report: {e}',
      'ERR_UPDATING_USE': 'Error updating use: {e}',
      'ERR_DELETING_USE': 'Error deleting use: {e}',
      'ERR_LOADING_EVENTS': 'Error loading events: {e}',
      'ERR_CREATING_EVENT': 'Error creating event: {e}',
      'ERR_COMPLETING_EVENT': 'Error completing event: {e}',
      'ERR_CANCELING_EVENT': 'Error canceling event: {e}',
      'ERR_RESCHEDULING_EVENT': 'Error rescheduling event: {e}',
      'ERR_DELETING_EVENT': 'Error deleting event: {e}',
      'ERR_CREATING_EVENTS_FROM_PROGRAM': 'Error creating events from program: {e}',

      // Infrastructure error messages
      'ERR_NO_CONNECTION': 'No internet connection',
      'ERR_NO_CONNECTION_SYNC': 'No connection to synchronize',
      'ERR_LOGIN_FAILED': 'Could not sign in',
      'ERR_GOOGLE_LOGIN_CANCELED': 'Google sign-in canceled',
      'ERR_GOOGLE_LOGIN_FAILED': 'Could not sign in with Google',
      'ERR_APPLE_LOGIN_FAILED': 'Could not sign in with Apple',
      'ERR_CREATE_ACCOUNT_FAILED': 'Could not create account',
      'ERR_FILE_NOT_EXISTS': 'File does not exist: {path}',
      'ERR_IMAGE_TOO_LARGE': 'Image exceeds maximum size (5MB)',
      'ERR_NO_PENDING_CREDENTIAL': 'No pending credential to link',
      'ERR_LINK_ACCOUNT_FAILED': 'Error linking account',
      'ERR_GOOGLE_ALREADY_LINKED': 'This Google account is already linked to another user',
      'ERR_PROVIDER_ALREADY_LINKED': 'This provider is already linked to your account',
      'ERR_UNKNOWN': 'Unknown error',
      'ERR_CREATE_FARM': 'Error creating farm',
      'ERR_GET_FARM': 'Error getting farm',
      'ERR_GET_FARMS': 'Error getting farms',
      'ERR_UPDATE_FARM': 'Error updating farm',
      'ERR_DELETE_FARM': 'Error deleting farm',
      'ERR_VERIFY_RUC': 'Error verifying RUC',
      'ERR_COUNT_FARMS': 'Error counting farms',
      'ERR_CANNOT_INVITE_OWNER': 'Cannot invite with owner role',
      'ERR_NO_INVITE_PERMISSION': 'You do not have permission to invite users to this farm',
      'ERR_INVITATION_NOT_FOUND': 'Invitation not found',
      'ERR_INVITATION_INVALID': 'Invalid or expired invitation',
      'ERR_ALREADY_MEMBER': 'You are already a member of this farm',
      'ERR_CANNOT_ACCEPT_OWN': 'You cannot accept your own invitation',
      'ERR_REMOVE_USER': 'Error removing user from farm',
      'ERR_FARM_NOT_FOUND': 'Farm not found',
      'ERR_FARM_NOT_EXISTS': 'The farm does not exist',
      'ERR_OWNER_CANNOT_LEAVE': 'The owner cannot leave their farm',
      'ERR_LEAVE_FARM': 'Error leaving farm',
      'ERR_CREATE_SHED': 'Error creating shed',
      'ERR_GET_SHED': 'Error getting shed',
      'ERR_GET_SHEDS': 'Error getting sheds',
      'ERR_UPDATE_SHED': 'Error updating shed',
      'ERR_DELETE_SHED': 'Error deleting shed',
      'ERR_GET_AVAILABLE_SHEDS': 'Error getting available sheds',
      'ERR_SEARCH_SHEDS': 'Error searching sheds',
      'ERR_REGISTER_EVENT': 'Error registering event',
      'ERR_GET_EVENTS': 'Error getting events',
      'ERR_COUNT_SHEDS': 'Error counting sheds',
      'ERR_CREATE_COST': 'Error creating cost: {e}',
      'ERR_GET_COST': 'Error getting cost: {e}',
      'ERR_GET_COSTS': 'Error getting costs: {e}',
      'ERR_UPDATE_COST': 'Error updating cost: {e}',
      'ERR_DELETE_COST': 'Error deleting cost: {e}',
      'ERR_GET_COSTS_BY_FARM': 'Error getting costs by farm: {e}',
      'ERR_GET_COSTS_BY_BATCH': 'Error getting costs by batch: {e}',
      'ERR_GET_COSTS_BY_TYPE': 'Error getting costs by type: {e}',
      'ERR_GET_PENDING_COSTS': 'Error getting pending costs: {e}',
      'ERR_GET_COSTS_BY_PERIOD': 'Error getting costs by period: {e}',
      'ERR_CREATE_BATCH': 'Error creating batch: {e}',
      'ERR_UPDATE_BATCH': 'Error updating batch: {e}',
      'ERR_DELETE_BATCH': 'Error deleting batch: {e}',
      'ERR_BATCH_OFFLINE': 'Batch not available offline',
      'ERR_GET_BATCH': 'Error getting batch: {e}',
      'ERR_GET_BATCHES': 'Error getting batches: {e}',
      'ERR_GET_SHED_BATCHES': 'Error getting shed batches: {e}',
      'ERR_GET_ACTIVE_BATCHES': 'Error getting active batches: {e}',
      'ERR_GET_BATCHES_BY_STATE': 'Error getting batches by state: {e}',
      'ERR_SEARCH': 'Search error: {e}',
      'ERR_REGISTER_MORTALITY': 'Error registering mortality: {e}',
      'ERR_REGISTER_DISCARD': 'Error registering discard: {e}',
      'ERR_REGISTER_SALE': 'Error registering sale: {e}',
      'ERR_UPDATE_WEIGHT': 'Error updating weight: {e}',
      'ERR_CHANGE_STATE': 'Error changing state: {e}',
      'ERR_CLOSE_BATCH': 'Error closing batch: {e}',
      'ERR_MARK_SOLD': 'Error marking as sold: {e}',
      'ERR_TRANSFER_BATCH': 'Error transferring batch: {e}',
      'ERR_GET_STATS': 'Error getting statistics: {e}',
      'ERR_COUNT_BY_STATE': 'Error counting by state: {e}',
      'ERR_SYNC': 'Error synchronizing: {e}',
      'ERR_CLEAR_CACHE': 'Error clearing cache: {e}',

      // Infrastructure - farm users
      'ERR_NO_CONNECTION_PHOTO': 'No internet connection. Profile photo will update when you have signal.',
      'ERR_GET_FARM_USERS': 'Error fetching farm users',
      'ERR_ASSIGN_USER': 'Error assigning user to farm',
      'ERR_USER_NOT_FOUND_IN_FARM': 'User not found in farm',
      'ERR_CHANGE_ROLE': 'Error changing user role',
      'ERR_TRANSFER_OR_DELETE': 'You must transfer ownership or delete the farm',
      'ERR_GET_USER_FARMS': 'Error fetching user farms',
      'ERR_CREATE_INVITATION': 'Error creating invitation',
      'ERR_MARK_INVITATION_USED': 'Error marking invitation as used',
      'ERR_GET_INVITATIONS': 'Error fetching invitations',
      'ERR_SHED_NOT_FOUND': 'Shed not found',
      'ERR_BATCH_NOT_FOUND': 'Batch not found',
      'ERR_STREAM': 'Stream error: {e}',

      // Alert service - inventory
      'ALERT_STOCK_BAJO': '⚠️ Low stock: {item}',
      'ALERT_STOCK_BAJO_MSG': 'Only {cantidad} {unidad} remaining',
      'ALERT_AGOTADO': '🚫 Out of stock: {item}',
      'ALERT_AGOTADO_MSG': 'Stock at zero, urgent restocking needed',
      'ALERT_VENCIDO': '❌ Expired: {item}',
      'ALERT_VENCIDO_MSG': 'This product expired {dias} days ago',
      'ALERT_PROXIMO_VENCER': '📅 Expiring soon: {item}',
      'ALERT_VENCE_HOY': 'Expires today!',
      'ALERT_VENCE_EN_DIAS': 'Expires in {dias} days',
      'ALERT_REABASTECIDO': '✅ Restocked: {item}',
      'ALERT_REABASTECIDO_MSG': '{cantidad} {unidad} added',
      'ALERT_MOVIMIENTO': '📦 {tipo}: {item}',
      'ALERT_MOVIMIENTO_MSG': '{cantidad} {unidad}',

      // Alert service - mortality
      'ALERT_MORTALIDAD_CRITICA': '🚨 CRITICAL mortality: {lote}',
      'ALERT_MORTALIDAD_ALTA': '⚠️ High mortality: {lote}',
      'ALERT_MORTALIDAD_MSG': '{porcentaje}% ({cantidad} birds)',
      'ALERT_MORTALIDAD_REG': '🐔 Mortality recorded: {lote}',
      'ALERT_MORTALIDAD_REG_MSG':
          '{cantidad} birds • Cause: {causa} • Accumulated: {porcentaje}%',

      // Alert service - batches
      'ALERT_NUEVO_LOTE': '🐤 New batch: {lote}',
      'ALERT_NUEVO_LOTE_MSG': '{cantidad} birds in {galpon}',
      'ALERT_LOTE_FINALIZADO': '✅ Batch completed: {lote}',
      'ALERT_LOTE_FINALIZADO_MSG': '{dias}-day cycle',
      'ALERT_PESO_BAJO': '⚖️ Low weight: {lote}',
      'ALERT_PESO_BAJO_MSG': '{peso}g ({diferencia}% below target)',
      'ALERT_CIERRE_PROXIMO': '📆 Closing soon: {lote}',
      'ALERT_CIERRE_HOY': 'Closing date is today!',
      'ALERT_CIERRE_EN_DIAS': 'Closes in {dias} days',
      'ALERT_CONVERSION_ANORMAL': '📊 Abnormal conversion: {lote}',
      'ALERT_CONVERSION_MSG': '{actual} vs {esperado} expected',
      'ALERT_SIN_REGISTROS': '⚠️ No records: {lote}',
      'ALERT_SIN_REGISTROS_MSG': 'Last record {dias} days ago',

      // Alert service - production
      'ALERT_PRODUCCION': '🥚 Production: {lote}',
      'ALERT_PRODUCCION_MSG': '{cantidad} eggs ({porcentaje}%)',
      'ALERT_PRODUCCION_BAJA': '📉 Low production: {lote}',
      'ALERT_PRODUCCION_BAJA_MSG': '{actual}% vs {esperado}% expected',
      'ALERT_CAIDA_PRODUCCION': '🔻 Production drop: {lote}',
      'ALERT_CAIDA_MSG': 'Dropped {caida}% (from {anterior}% to {actual}%)',
      'ALERT_PRIMER_HUEVO': '🎉 First egg! {lote}',
      'ALERT_PRIMER_HUEVO_MSG': 'At {semanas} weeks of age',
      'ALERT_RECORD': '🏆 Record! {lote}',
      'ALERT_RECORD_MSG': '{cantidad} eggs ({porcentaje}%)',
      'ALERT_META': '🎯 Goal reached: {lote}',
      'ALERT_META_MSG': '{total} eggs (goal: {meta})',

      // Alert service - vaccinations
      'ALERT_VAC_VENCIDA': '❌ Vaccination overdue',
      'ALERT_VAC_VENCIDA_MSG': '{vacuna} for {lote} was not applied',
      'ALERT_VAC_HOY': '💉 Vaccination TODAY',
      'ALERT_VAC_MANANA': '💉 Vaccination TOMORROW',
      'ALERT_VAC_EN_DIAS': '💉 Vaccination in {dias} days',
      'ALERT_VAC_PARA_LOTE': '{vacuna} for {lote}',
      'ALERT_VAC_COMPLETADA': '✅ Vaccination completed',
      'ALERT_VAC_COMPLETADA_MSG': '{vacuna} applied to {aves} birds in {lote}',

      // Alert service - treatments
      'ALERT_TRATAMIENTO': '💊 Treatment started: {lote}',
      'ALERT_TRATAMIENTO_MSG': '{tratamiento} for {dias} days',
      'ALERT_TRATAMIENTO_RETIRO': ' ({diasRetiro} days withdrawal)',
      'ALERT_RETIRO_ACTIVO': '🚫 Active withdrawal: {lote}',
      'ALERT_RETIRO_ACTIVO_MSG':
          '{medicamento} - {dias} days remaining. Do NOT market eggs.',
      'ALERT_RETIRO_FIN': '✅ Withdrawal ended: {lote}',
      'ALERT_RETIRO_FIN_MSG': 'Withdrawal period for {medicamento} completed',

      // Alert service - health
      'ALERT_DIAGNOSTICO': '🏥 Diagnosis: {lote}',
      'ALERT_DIAGNOSTICO_MSG': '{diagnostico} - Severity: {severidad}',
      'ALERT_SINTOMAS_RESP': '🫁 Respiratory symptoms: {lote}',
      'ALERT_SINTOMAS_RESP_MSG': '{sintomas} in {aves} birds',
      'ALERT_CONSUMO_AGUA': '💧 Water consumption {tipo}: {lote}',
      'ALERT_CONSUMO_AGUA_MSG':
          '{actual}L vs {esperado}L expected ({diferencia}% {tipo})',
      'ALERT_CONSUMO_ALIMENTO': '🌾 Feed consumption {tipo}: {lote}',
      'ALERT_CONSUMO_ALIMENTO_MSG':
          '{actual}kg vs {esperado}kg expected ({diferencia}% {tipo})',
      'ALERT_TEMPERATURA': '🌡️ Temperature {tipo}: {galpon}',
      'ALERT_TEMPERATURA_MSG': '{actual}°C (range: {min}-{max}°C)',
      'ALERT_HUMEDAD': '💧 Humidity {tipo}: {galpon}',
      'ALERT_HUMEDAD_MSG': '{actual}% (range: {min}-{max}%)',
      'ALERT_ENFERMEDAD': '🦠 Disease confirmed: {lote}',
      'ALERT_ENFERMEDAD_MSG': '{enfermedad} detected in {aves} birds',

      // Alert service - biosecurity
      'ALERT_BIOSEG_APROBADA': '✅ Inspection approved',
      'ALERT_BIOSEG_OBSERVACIONES': '⚠️ Inspection with observations',
      'ALERT_BIOSEG_REPROBADA': '❌ Inspection failed',
      'ALERT_BIOSEG_RESULTADO': '{tipo} - Score: {puntaje}%',
      'ALERT_INSP_VENCIDA': '❌ Inspection overdue',
      'ALERT_INSP_HOY': '📋 Inspection TODAY',
      'ALERT_INSP_EN_DIAS': '📋 Inspection in {dias} days',
      'ALERT_BIOSEG_CRITICA': '🚨 Biosecurity CRITICAL',
      'ALERT_BIOSEG_BAJA': '⚠️ Low biosecurity',
      'ALERT_INSP_COMPLETADA': '✅ Inspection completed',

      // Alert service - necropsy
      'ALERT_NECROPSIA': '🔬 Necropsy: {lote}',
      'ALERT_NECROPSIA_MSG': 'Probable cause: {causa}',

      // Alert service - commercial
      'ALERT_NUEVO_PEDIDO': '🛒 New order',
      'ALERT_NUEVO_PEDIDO_MSG': '{cliente} - {cantidad} eggs (\${monto})',
      'ALERT_PEDIDO_CONFIRMADO': '✅ Order confirmed',
      'ALERT_PEDIDO_CONFIRMADO_MSG': '{cliente} - Delivery: {fecha}',
      'ALERT_ENTREGA_HOY': '🚚 Delivery TODAY',
      'ALERT_ENTREGA_MANANA': '🚚 Delivery TOMORROW',
      'ALERT_PEDIDO_ENTREGADO': '✅ Order delivered',
      'ALERT_PEDIDO_ENTREGADO_MSG': '{cliente} - \${monto}',
      'ALERT_PEDIDO_CANCELADO': '❌ Order cancelled',
      'ALERT_PEDIDO_CANCELADO_MSG': '{cliente} - {motivo}',
      'ALERT_PAGO_RECIBIDO': '💰 Payment received',
      'ALERT_PAGO_MSG': '{cliente} - \${monto} ({metodo})',
      'ALERT_VENTA_REG': '🛍️ Sale recorded',
      'ALERT_VENTA_REG_MSG': '{cliente} - {cantidad} eggs (\${monto})',

      // Alert service - collaborators
      'ALERT_INVITACION': '🎉 Invitation to {granja}',
      'ALERT_INVITACION_MSG': '{invitadoPor} has invited you to collaborate',
      'ALERT_NUEVO_COLAB': '👤 New collaborator',
      'ALERT_NUEVO_COLAB_MSG': '{nombre} joined as {rol}',
      'ALERT_INVITACION_RECHAZADA': '❌ Invitation rejected',
      'ALERT_INVITACION_RECHAZADA_MSG': '{email} rejected the invitation',
      'ALERT_ACCESO_REVOCADO': '👋 Access revoked',
      'ALERT_ACCESO_REVOCADO_MSG': 'You no longer have access to {granja}',
      'ALERT_COLAB_REMOVIDO': '👋 Collaborator removed',
      'ALERT_COLAB_REMOVIDO_MSG': '{nombre} was removed from {granja}',
      'ALERT_CAMBIO_ROL': '🔄 Role change',
      'ALERT_CAMBIO_ROL_MSG':
          'Your role changed from {rolAnterior} to {rolNuevo} in {granja}',

      // Alert service - barns
      'ALERT_NUEVO_GALPON': '🏠 New barn: {galpon}',
      'ALERT_NUEVO_GALPON_MSG': 'Capacity: {capacidad} birds',
      'ALERT_MANTENIMIENTO': '🔧 Maintenance: {galpon}',
      'ALERT_CAPACIDAD_MAX': '⚠️ Max capacity: {galpon}',
      'ALERT_CAPACIDAD_MAX_MSG': '{actual}/{max} birds',
      'ALERT_EVENTO_GALPON': '📋 {tipo}: {galpon}',

      // Alert service - costs
      'ALERT_GASTO': '💳 Expense: {categoria}',
      'ALERT_GASTO_MSG': '\${monto} - {descripcion}',
      'ALERT_GASTO_INUSUAL': '⚠️ Unusual expense: {categoria}',
      'ALERT_GASTO_INUSUAL_MSG': '\${monto} ({porcentaje}% over average)',
      'ALERT_PRESUPUESTO_SUPERADO': '🚨 Budget exceeded: {categoria}',
      'ALERT_PRESUPUESTO_MSG':
          '\${gastoAcum}/\${presupuesto} (excess: \${exceso})',

      // Alert service - reports and system
      'ALERT_RESUMEN_SEMANAL': '📊 Weekly summary',
      'ALERT_RESUMEN_SEMANAL_MSG':
          'Revenue: \${ingresos} | Expenses: \${gastos} | {tipo}: \${utilidad}',
      'ALERT_UTILIDAD': 'Profit',
      'ALERT_PERDIDA': 'Loss',
      'ALERT_REPORTE_LISTO': '📄 Report ready',
      'ALERT_REPORTE_LISTO_MSG': '{tipo} generated successfully',
      'ALERT_RESUMEN_DIA': '📋 Daily summary',
      'ALERT_RESUMEN_DIA_MSG':
          '🥚 {huevos} | ⚰️ {mortalidad} | 🌾 {alimento}kg | ⚠️ {alertas} alerts',
      'ALERT_ALERTAS_PENDIENTES': '🔔 {cantidad} pending alerts',
      'ALERT_SYNC_OK': '☁️ Sync completed',
      'ALERT_SYNC_MSG': '{registros} records synced',
      'ALERT_BIENVENIDO': '👋 Welcome {nombre}!',
      'ALERT_BIENVENIDO_MSG':
          'Thank you for using Smart Granja Aves Pro. Explore the available features.',
      'NOTIF_FALLBACK_TITLE': 'Notification',
      'NOTIF_CHANNEL_DESC': 'Smart Granja Aves Pro notifications',
      'ALERT_BAJO': 'low',
      'ALERT_ALTO': 'high',
      'ALERT_BAJA': 'low',
      'ALERT_ALTA': 'high',

      // Recent record cards
      'REG_CARD_PESO_DESC': '{aves} birds weighed - ADG: {gdp}g/day',
      'REG_CARD_CONSUMO_DESC': '{tipo} - {aves} birds',
      'REG_CARD_MORT_DESC': '{causa} - Impact: {impacto}%',
      'REG_CARD_MORT_VALOR': '{cantidad} birds',
      'REG_CARD_PROD_DESC': 'Lay rate: {postura}% - Good: {buenos}%',
      'REG_CARD_PROD_VALOR': '{cantidad} eggs',

      // CausaMortalidad display names (no context)
      'CAUSA_MORT_ENFERMEDAD': 'Disease',
      'CAUSA_MORT_ACCIDENTE': 'Accident',
      'CAUSA_MORT_DESNUTRICION': 'Malnutrition',
      'CAUSA_MORT_ESTRES': 'Stress',
      'CAUSA_MORT_METABOLICA': 'Metabolic',
      'CAUSA_MORT_DEPREDACION': 'Predation',
      'CAUSA_MORT_SACRIFICIO': 'Slaughter',
      'CAUSA_MORT_VEJEZ': 'Old age',
      'CAUSA_MORT_DESCONOCIDA': 'Unknown',

      // Sales datasource
      'ERR_GET_SALES': 'Error getting sales: {e}',
      'ERR_GET_SALE': 'Error getting sale: {e}',
      'ERR_CREATE_SALE': 'Error creating sale: {e}',
      'ERR_UPDATE_SALE': 'Error updating sale: {e}',
      'ERR_DELETE_SALE': 'Error deleting sale: {e}',
      'ERR_CREATE_SALE_PRODUCT': 'Error registering sale product: {e}',
      'ERR_GET_SALE_PRODUCT': 'Error getting sale product: {e}',
      'ERR_GET_SALES_BY_BATCH': 'Error getting sales by batch: {e}',
      'ERR_GET_SALES_BY_FARM': 'Error getting sales by farm: {e}',
      'ERR_GET_ALL_SALES': 'Error getting all sales: {e}',
      'ERR_UPDATE_SALE_PRODUCT': 'Error updating sale product: {e}',
      'ERR_DELETE_SALE_PRODUCT': 'Error deleting sale product: {e}',

      // Health calendar datasource
      'ERR_GET_HEALTH_EVENTS': 'Error getting health events: {e}',
      'ERR_GET_EVENTS_BY_DATE': 'Error getting events by date: {e}',
      'ERR_GET_EVENTS_BY_BATCH': 'Error getting events by batch: {e}',
      'ERR_GET_EVENTS_BY_TYPE': 'Error getting events by type: {e}',
      'ERR_GET_PENDING_EVENTS': 'Error getting pending events: {e}',
      'ERR_GET_OVERDUE_EVENTS': 'Error getting overdue events: {e}',
      'ERR_GET_UPCOMING_EVENTS': 'Error getting upcoming events: {e}',
      'ERR_UPDATE_HEALTH_EVENT': 'Error updating event: {e}',

      // Miscellaneous exceptions
      'ERR_VACCINATION_NOT_FOUND_AFTER_UPDATE': 'Vaccination not found after update',
      'ERR_RECORD_NOT_FOUND_AFTER_UPDATE': 'Record not found after update',
      'ERR_NECROPSY_NOT_FOUND': 'Necropsy not found',
      'ERR_EVENT_NOT_FOUND': 'Event not found',
      'ERR_NO_ACTIVE_BATCH': 'No active batch',
      'LABEL_GALPON': 'Shed',
      'ERR_NO_TREATMENT': 'No treatment available',
      'ERR_NO_EFFECTIVE_TREATMENT': 'No effective treatment available',

      // PDF - Metadata
      'PDF_TITLE_PRODUCTION': 'Production Report - {code}',
      'PDF_TITLE_EXECUTIVE': 'Executive Report - {farm}',
      'PDF_TITLE_COSTS': 'Cost Report - {farm}',
      'PDF_TITLE_SALES': 'Sales Report - {farm}',
      'PDF_AUTHOR': 'Smart Granja Aves Pro',
      'PDF_SUBJECT_PRODUCTION': 'Poultry batch production report',
      'PDF_SUBJECT_EXECUTIVE': 'Executive summary of poultry operations',
      'PDF_SUBJECT_COSTS': 'Operating cost analysis',
      'PDF_SUBJECT_SALES': 'Sales and income analysis',

      // PDF - Headers
      'PDF_HEADER_PRODUCTION': 'PRODUCTION REPORT',
      'PDF_HEADER_EXECUTIVE': 'EXECUTIVE SUMMARY',
      'PDF_HEADER_COSTS': 'COST REPORT',
      'PDF_HEADER_SALES': 'SALES REPORT',
      'PDF_LOT_SUBTITLE': 'Batch: {code}',
      'PDF_APP_NAME': 'SMART GRANJA AVES',
      'PDF_PERIOD': 'PERIOD',
      'PDF_DATE_TO': 'to {date}',

      // PDF - Footer
      'PDF_GENERATED_BY': 'Generated: {datetime} by {user}',
      'PDF_PAGE': 'Page {current} of {total}',

      // PDF - Lot information
      'PDF_LOT_INFO': 'LOT INFORMATION',
      'PDF_LABEL_CODE': 'Code',
      'PDF_LABEL_BIRD_TYPE': 'Bird Type',
      'PDF_LABEL_SHED': 'Shed',
      'PDF_LABEL_ENTRY_DATE': 'Entry Date',
      'PDF_LABEL_CURRENT_AGE': 'Current Age',
      'PDF_LABEL_DAYS_IN_FARM': 'Days on Farm',
      'PDF_DAYS_UNIT': '{count} days',

      // PDF - Production indicators
      'PDF_PRODUCTION_INDICATORS': 'PRODUCTION INDICATORS',
      'PDF_INITIAL_BIRDS': 'Initial Birds',
      'PDF_CURRENT_BIRDS': 'Current Birds',
      'PDF_MORTALITY': 'Mortality',
      'PDF_MORTALITY_BIRDS': '{count} birds',
      'PDF_AVG_WEIGHT': 'Average Weight',
      'PDF_WEIGHT_KG': '{value} kg',
      'PDF_WEIGHT_OBJECTIVE': 'Target: {value} kg',
      'PDF_TOTAL_CONSUMPTION': 'Total Consumption',
      'PDF_CONVERSION': 'Conversion',
      'PDF_CONVERSION_UNIT': 'kg feed / kg weight',

      // PDF - Financial summary
      'PDF_FINANCIAL_SUMMARY': 'FINANCIAL SUMMARY',
      'PDF_BIRD_COST': 'Bird Cost',
      'PDF_FEED_COST': 'Feed Cost',
      'PDF_TOTAL_COSTS': 'Total Costs',
      'PDF_SALES_REVENUE': 'Sales Revenue',
      'PDF_BALANCE': 'BALANCE',

      // PDF - Analysis
      'PDF_HIGH_MORTALITY': '⚠ High mortality ({pct}%). Sanitary condition review recommended.',
      'PDF_GOOD_SURVIVAL': '✓ Excellent survival rate ({pct}%).',
      'PDF_HIGH_CONVERSION': '⚠ High feed conversion ({value}). Review feed quality.',
      'PDF_GOOD_CONVERSION': '✓ Excellent feed conversion ({value}).',
      'PDF_WEIGHT_BELOW': '⚠ Weight below target ({diff}g less).',
      'PDF_WEIGHT_ABOVE': '✓ Weight above target (+{diff}g).',
      'PDF_NO_OBSERVATIONS': 'No relevant observations for this period.',
      'PDF_ANALYSIS_TITLE': 'ANALYSIS AND OBSERVATIONS',

      // PDF - Executive KPIs
      'PDF_KEY_INDICATORS': 'KEY PERFORMANCE INDICATORS',
      'PDF_ACTIVE_LOTS': 'Active Lots',
      'PDF_TOTAL_BIRDS': 'Total Birds',
      'PDF_AVG_MORTALITY': 'Avg. Mortality',
      'PDF_AVG_CONVERSION': 'Avg. Conversion',

      // PDF - Lots table
      'PDF_ACTIVE_LOTS_SUMMARY': 'ACTIVE LOTS SUMMARY',
      'PDF_TABLE_LOT': 'Lot',
      'PDF_TABLE_TYPE': 'Type',
      'PDF_TABLE_BIRDS': 'Birds',
      'PDF_TABLE_MORTALITY_PCT': 'Mort.%',
      'PDF_TABLE_WEIGHT_KG': 'Weight kg',
      'PDF_TABLE_CONVERSION': 'Conv.',

      // PDF - Executive financial
      'PDF_TOTAL_COSTS_LABEL': 'Total Costs',
      'PDF_TOTAL_SALES_LABEL': 'Total Sales',
      'PDF_NET_PROFIT': 'Net Profit',
      'PDF_PROFIT_MARGIN': 'Profit Margin',

      // PDF - Costs
      'PDF_COSTS_SUMMARY': 'COSTS SUMMARY',
      'PDF_BY_CATEGORY': 'By Category',
      'PDF_COSTS_DETAIL': 'COST DETAILS',
      'PDF_TABLE_CATEGORY': 'Category',
      'PDF_TABLE_CONCEPT': 'Concept',
      'PDF_TABLE_AMOUNT': 'Amount',
      'PDF_TABLE_DATE': 'Date',
      'PDF_TABLE_SUPPLIER': 'Supplier',

      // PDF - Sales
      'PDF_SALES_SUMMARY': 'SALES SUMMARY',
      'PDF_TOTAL_SALES_KPI': 'Total Sales',
      'PDF_BY_PRODUCT': 'By Product',
      'PDF_SALES_DETAIL': 'SALES DETAIL',
      'PDF_TABLE_PRODUCT': 'Product',
      'PDF_TABLE_QUANTITY': 'Quantity',
      'PDF_TABLE_SUBTOTAL': 'Subtotal',
      'PDF_TABLE_CLIENT': 'Client',

      // Inventory
      'ERR_ITEM_NOT_FOUND': 'Item not found',
      'ERR_INSUFFICIENT_STOCK':
          'Insufficient stock. Available: {stock} {unit}',

      // Shed events
      'EVT_SHED_CREATED': 'Shed created: {name}',
      'EVT_BATCH_ASSIGNED': 'Batch {id} assigned to shed',
      'EVT_SHED_RELEASED': 'Shed released from batch {id}',
      'EVT_DISINFECTION_DONE': 'Disinfection completed',

      // Health providers
      'ERR_VACCINATION_NOT_FOUND': 'Vaccination not found',
      'ERR_RECORD_NOT_FOUND': 'Record not found',
      'EVT_VACCINATION_TITLE': 'Vaccination: {name}',
      'EVT_VACCINATION_DESC':
          'Apply {name} according to vaccination program',
      'LABEL_SYSTEM': 'System',

      // Health alerts
      'ALERT_HIGH_MORTALITY_TITLE': 'High Mortality',
      'ALERT_HIGH_MORTALITY_DESC':
          'Daily mortality ({rate}%) exceeds the threshold of {threshold}%',
      'ALERT_MORTALITY_INDICATOR': 'Daily Mortality',
      'ALERT_MORTALITY_REC':
          'Perform immediate necropsy. Check water, feed and environmental conditions.',
      'ALERT_ABNORMAL_TEMP_TITLE': 'Abnormal Temperature',
      'ALERT_ABNORMAL_TEMP_DESC':
          'Temperature ({temp}°C) is outside the optimal range ({min}°C - {max}°C)',
      'ALERT_TEMP_INDICATOR': 'Temperature',
      'ALERT_TEMP_REC':
          'Adjust ventilation and heating as needed.',

      // Domain defaults
      'DEFAULT_NO_DESCRIPTION': 'No description available',
      'DEFAULT_MORTALITY_RECORD': 'Mortality record',
      'GRANJA_MAINTENANCE_NOTE':
          'Farm under maintenance on {date}',
      'GRANJA_MAINTENANCE_NOTE_REASON':
          'Farm under maintenance on {date} - Reason: {reason}',

      // StateError / UnimplementedError
      'ERR_DOC_NO_DATA': 'Document {id} has no data',
      'ERR_UNIMPLEMENTED_VACCINATION_INTEGRATION':
          'Integration with VaccinationProgram pending',
      'ERR_UNIMPLEMENTED_GRANJA_ID_REQUIRED':
          'Farm ID required for deletion',

      // Collaborators
      'ERR_GENERIC_PREFIX': 'Error: {e}',

      // Storage
      'STORAGE_READ_ERROR': 'Error reading file{path}',
      'STORAGE_WRITE_ERROR': 'Error writing file{path}',
      'STORAGE_DELETE_ERROR': 'Error deleting file{path}',
      'STORAGE_NOT_FOUND': 'File not found{path}',

      // Biosecurity
      'ERR_NO_INSPECTION_IN_PROGRESS': 'No inspection in progress',
    },
    'pt': {
      // Server
      'SERVER_ERROR': 'Erro do servidor',
      'SERVER_ERROR_400': 'Requisição incorreta',
      'SERVER_ERROR_401': 'Não autorizado',
      'SERVER_ERROR_403': 'Acesso negado',
      'SERVER_ERROR_404': 'Recurso não encontrado',
      'SERVER_ERROR_409': 'Conflito na requisição',
      'SERVER_ERROR_422': 'Dados não processáveis',
      'SERVER_ERROR_429': 'Muitas requisições',
      'SERVER_ERROR_500': 'Erro interno do servidor',
      'SERVER_ERROR_502': 'Erro de conexão',
      'SERVER_ERROR_503': 'Serviço indisponível',
      'SERVER_ERROR_504': 'Tempo de espera esgotado',
      'SSL_ERROR': 'Erro de certificado SSL',
      'NOT_FOUND': 'Documento não encontrado',
      'ALREADY_EXISTS': 'O documento já existe',
      'GENERIC_SERVER_ERROR': 'Erro na operação',

      // Cache
      'CACHE_NOT_FOUND': 'Dado não encontrado no cache',
      'CACHE_EXPIRED': 'Dado expirado no cache',
      'CACHE_WRITE_ERROR': 'Erro ao gravar no cache',

      // Network
      'NO_CONNECTION': 'Sem conexão com a internet',
      'TIMEOUT': 'Tempo de espera esgotado',
      'CANCELLED': 'Requisição cancelada',
      'SERVICE_UNAVAILABLE': 'Serviço indisponível',

      // Auth
      'INVALID_CREDENTIALS': 'Credenciais inválidas',
      'USER_NOT_FOUND': 'Usuário não encontrado',
      'EMAIL_ALREADY_IN_USE': 'O e-mail já está em uso',
      'WEAK_PASSWORD': 'A senha é muito fraca',
      'SESSION_EXPIRED': 'Sua sessão expirou',
      'NO_SESSION': 'Não há sessão ativa',
      'UNAUTHORIZED': 'Você não tem permissão para realizar esta ação',
      'EMAIL_NOT_VERIFIED': 'Verifique seu e-mail',
      'INVALID_EMAIL': 'E-mail inválido',
      'USER_DISABLED': 'Usuário desativado',
      'TOO_MANY_REQUESTS': 'Muitas tentativas. Tente mais tarde',
      'AUTH_ERROR': 'Erro de autenticação',
      'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          'Já existe uma conta com este e-mail',

      // Validation
      'FORMAT_ERROR': 'Erro de formato',
      'FIELD_REQUIRED': 'O campo {field} é obrigatório',
      'FIELD_INVALID': 'O campo {field} é inválido',

      // Firebase
      'FIREBASE_PERMISSION_DENIED':
          'Você não tem permissão para realizar esta ação',
      'FIREBASE_UNAVAILABLE': 'Serviço indisponível',
      'FIREBASE_CANCELLED': 'Operação cancelada',
      'FIREBASE_DEADLINE_EXCEEDED': 'Tempo de espera esgotado',
      'FIREBASE_NOT_FOUND': 'Documento não encontrado',
      'FIREBASE_ALREADY_EXISTS': 'O documento já existe',
      'FIREBASE_ERROR': 'Erro do Firebase',

      // Unknown
      'UNKNOWN': 'Ocorreu um erro inesperado',
      'STORAGE_QUOTA_EXCEEDED': 'Espaço de armazenamento esgotado',

      // Venta validation
      'VENTA_SELECT_LOTE': 'Deve selecionar um lote',
      'VENTA_SELECT_GRANJA': 'Deve selecionar uma granja',
      'VENTA_SELECT_CLIENTE': 'Deve especificar um cliente',
      'VENTA_AVES_GREATER_ZERO': 'A quantidade de aves deve ser maior que 0',
      'VENTA_PRECIO_KG_GREATER_ZERO': 'O preço por kg deve ser maior que 0',
      'VENTA_PESO_FAENADO_GREATER_ZERO': 'O peso abatido deve ser maior que 0',
      'VENTA_HUEVOS_CLASIFICACION':
          'Deve especificar pelo menos uma classificação de ovos',
      'VENTA_HUEVOS_PRECIOS':
          'Deve especificar preços para as classificações',
      'VENTA_HUEVOS_TOTAL_GREATER_ZERO':
          'A quantidade total de ovos deve ser maior que 0',
      'VENTA_POLLINAZA_GREATER_ZERO':
          'A quantidade de cama de frango deve ser maior que 0',
      'VENTA_PRECIO_UNITARIO_GREATER_ZERO':
          'O preço unitário deve ser maior que 0',
      'VENTA_NOT_EXISTS': 'A venda não existe',
      'VENTA_CANNOT_MODIFY': 'Não é possível modificar uma venda {estado}',
      'VENTA_LOTE_ID_REQUIRED': 'O ID do lote é obrigatório',
      'VENTA_ID_REQUIRED': 'O ID da venda é obrigatório',
      'VENTA_CANNOT_DELETE_COMPLETED':
          'Não é possível excluir uma venda concluída',
      'VENTA_PESO_PROMEDIO_GREATER_ZERO': 'O peso médio deve ser maior que 0',

      // Costo validation
      'COSTO_SELECT_GRANJA': 'Deve selecionar uma granja',
      'COSTO_CONCEPTO_REQUIRED': 'O conceito não pode estar vazio',
      'COSTO_MONTO_GREATER_ZERO': 'O valor deve ser maior que 0',
      'COSTO_REGISTRADO_POR_REQUIRED':
          'Deve especificar quem registra o custo',
      'COSTO_LOTE_ID_REQUIRED': 'O ID do lote é obrigatório',
      'COSTO_ID_REQUIRED': 'O ID do custo é obrigatório',
      'COSTO_APROBADOR_REQUIRED': 'Deve especificar quem aprova',
      'COSTO_NOT_FOUND': 'Custo não encontrado',
      'COSTO_MOTIVO_RECHAZO_REQUIRED': 'Deve especificar o motivo da rejeição',
      'COSTO_GRANJA_ID_REQUIRED': 'O ID da granja é obrigatório',
      'COSTO_FECHA_RANGO_INVALIDO':
          'A data inicial não pode ser posterior à final',

      // Granja validation
      'GRANJA_ID_REQUIRED': 'O ID da granja é obrigatório',
      'GRANJA_NOMBRE_REQUIRED': 'O nome da granja é obrigatório',
      'GRANJA_NOMBRE_MIN_LENGTH': 'O nome deve ter pelo menos 3 caracteres',
      'GRANJA_PROPIETARIO_REQUIRED': 'O proprietário é obrigatório',
      'GRANJA_RUC_INVALID': 'CNPJ inválido (deve ter 14 dígitos numéricos)',
      'GRANJA_EMAIL_INVALID': 'E-mail inválido',
      'GRANJA_CAPACIDAD_NEGATIVE': 'A capacidade não pode ser negativa',
      'GRANJA_AREA_POSITIVE': 'A área deve ser positiva',
      'GRANJA_GALPONES_NEGATIVE': 'O número de galpões não pode ser negativo',

      // Cliente validation
      'CLIENTE_NOMBRE_REQUIRED': 'O nome do cliente é obrigatório',
      'CLIENTE_NOMBRE_MIN_LENGTH': 'O nome deve ter pelo menos 3 caracteres',
      'CLIENTE_ID_REQUIRED': 'A identificação do cliente é obrigatória',
      'CLIENTE_DNI_FORMAT': 'CPF deve ter 11 dígitos',
      'CLIENTE_RUC_FORMAT': 'CNPJ deve ter 14 dígitos',
      'CLIENTE_CONTACTO_REQUIRED': 'O contato do cliente é obrigatório',
      'CLIENTE_CONTACTO_MIN_LENGTH':
          'O contato deve ter pelo menos 6 caracteres',
      'CLIENTE_EMAIL_INVALID': 'O formato do e-mail é inválido',

      // Lote validation
      'LOTE_GRANJA_ID_REQUIRED': 'O ID da granja é obrigatório',
      'LOTE_GALPON_ID_REQUIRED': 'O ID do galpão é obrigatório',
      'LOTE_CODIGO_REQUIRED': 'O código do lote é obrigatório',
      'LOTE_CANTIDAD_POSITIVE': 'A quantidade inicial deve ser positiva',
      'LOTE_EDAD_NEGATIVE': 'A idade de entrada não pode ser negativa',
      'LOTE_MORTALIDAD_NEGATIVE': 'A mortalidade não pode ser negativa',
      'LOTE_DESCARTES_NEGATIVE': 'Os descartes não podem ser negativos',
      'LOTE_VENTAS_NEGATIVE': 'As vendas não podem ser negativas',
      'LOTE_BAJAS_EXCEDEN': 'As perdas superam a quantidade inicial',
      'LOTE_PESO_POSITIVE': 'O peso médio deve ser positivo',
      'LOTE_COSTO_NEGATIVE': 'O custo por ave não pode ser negativo',
      'LOTE_CANTIDAD_DEBE_POSITIVA': 'A quantidade deve ser positiva',
      'LOTE_NO_PERMITE_REGISTROS':
          'O lote não permite registros no estado {estado}',
      'LOTE_AVES_INSUFICIENTES':
          'Não há aves suficientes ({disponibles} disponíveis)',
      'LOTE_PESO_DEBE_POSITIVO': 'O peso deve ser positivo',
      'LOTE_CONSUMO_NO_PERMITIDO':
          'Não é possível registrar consumo em um lote {estado}',
      'LOTE_SOLO_POSTURA': 'Apenas lotes de postura podem registrar ovos',
      'LOTE_PRODUCCION_NO_PERMITIDA':
          'Não é possível registrar produção em um lote {estado}',
      'LOTE_CAMBIO_ESTADO_INVALIDO':
          'Não é possível mudar de {estadoActual} para {estadoNuevo}',
      'LOTE_CIERRE_NORMAL': 'Encerramento normal',
      'LOTE_YA_EN_GALPON': 'O lote já está nesse galpão',

      // Galpón validation
      'GALPON_GRANJA_ID_REQUIRED': 'O ID da granja é obrigatório',
      'GALPON_CODIGO_REQUIRED': 'O código do galpão é obrigatório',
      'GALPON_NOMBRE_REQUIRED': 'O nome do galpão é obrigatório',
      'GALPON_CAPACIDAD_POSITIVE': 'A capacidade deve ser positiva',
      'GALPON_AREA_POSITIVE': 'A área deve ser positiva',
      'GALPON_AVES_NEGATIVE': 'A quantidade de aves não pode ser negativa',
      'GALPON_AVES_EXCEDE_CAPACIDAD':
          'A quantidade de aves excede a capacidade máxima',
      'GALPON_DENSIDAD_EXCEDE':
          'A densidade excede o limite recomendado para {tipo}',
      'GALPON_ESTADO_REQUIERE_VACIO':
          'O estado {estado} requer que o galpão esteja vazio',
      'GALPON_CAMBIO_ESTADO_INVALIDO':
          'Não é possível mudar de {estadoActual} para {estadoNuevo}',
      'GALPON_CAMBIO_CON_LOTE_ACTIVO':
          'Não é possível mudar para {estadoNuevo} com um lote ativo',
      'GALPON_DESINFECTAR_CON_LOTE':
          'Não é possível desinfetar um galpão com lote ativo',
      'GALPON_NO_DISPONIBLE':
          'O galpão não está disponível para receber um lote',
      'GALPON_CAPACIDAD_DEBE_POSITIVA':
          'A quantidade excede a capacidade máxima',

      // Common prefixes
      'PREFIX_DIRECCION': 'Endereço: {detail}',
      'PREFIX_COORDENADAS': 'Coordenadas: {detail}',
      'PREFIX_UMBRALES': 'Limites: {detail}',
      'LOTE_VENDIDO_A': 'Vendido para: {comprador}',
      'LOTE_VENDIDO': 'Vendido',

      // Bird type descriptions (fallback for non-UI contexts)
      'BIRD_TYPE_BROILER_DESC': 'Aves criadas para produção de carne',
      'BIRD_TYPE_LAYER_DESC': 'Aves criadas para produção de ovos',
      'BIRD_TYPE_HEAVY_BREEDER_DESC': 'Aves reprodutoras de linhagem pesada',
      'BIRD_TYPE_LIGHT_BREEDER_DESC': 'Aves reprodutoras de linhagem leve',
      'BIRD_TYPE_TURKEY_DESC': 'Perus para carne',
      'BIRD_TYPE_QUAIL_DESC': 'Codornas para ovos ou carne',
      'BIRD_TYPE_DUCK_DESC': 'Patos para carne',
      'BIRD_TYPE_OTHER_DESC': 'Outro tipo de ave',
      'NOT_RECORDED': 'Não registrado',
      'COMMON_BIRDS': 'aves',
      'NOT_SPECIFIED': 'Não especificada',
      'DATE_TODAY': 'Hoje',
      'DATE_YESTERDAY': 'Ontem',
      'DATE_DAYS_AGO': 'Há {count} dias',
      'DATE_WEEKS_AGO': 'Há {count} {unit}',
      'DATE_MONTHS_AGO': 'Há {count} {unit}',
      'DATE_YEARS_AGO': 'Há {count} {unit}',
      'UNIT_WEEK': 'semana',
      'UNIT_WEEKS': 'semanas',
      'UNIT_MONTH': 'mês',
      'UNIT_MONTHS': 'meses',
      'UNIT_YEAR': 'ano',
      'UNIT_YEARS': 'anos',

      // Granja business methods
      'GRANJA_YA_ACTIVA': 'A granja já está ativa',
      'GRANJA_SOLO_SUSPENDER_ACTIVA':
          'Só é possível suspender uma granja ativa',
      'GRANJA_SOLO_MANTENIMIENTO_ACTIVA':
          'Só é possível colocar em manutenção uma granja ativa',

      // CostoGasto entity
      'COSTO_CONCEPTO_VACIO': 'O conceito não pode estar vazio',
      'COSTO_MONTO_MAYOR_CERO': 'O valor deve ser maior que 0',
      'COSTO_AVES_MAYOR_CERO': 'A quantidade de aves deve ser maior que 0',
      'COSTO_NO_REQUIERE_APROBACION': 'Este gasto não requer aprovação',
      'COSTO_YA_APROBADO': 'Este gasto já está aprovado',
      'COSTO_MOTIVO_RECHAZO_VACIO': 'Deve fornecer um motivo de rejeição',

      // Salud entities
      'SALUD_DIAGNOSTICO_VACIO': 'O diagnóstico não pode estar vazio',
      'SALUD_REGISTRO_CERRADO': 'O registro já está encerrado',
      'VACUNA_NOMBRE_VACIO': 'O nome da vacina não pode estar vazio',
      'VACUNA_YA_APLICADA': 'A vacina já foi aplicada',

      // Lotes usecases
      'LOTE_YA_CERRADO': 'O lote já está encerrado',
      'LOTE_YA_VENDIDO_UC': 'O lote já foi vendido',
      'LOTE_FECHA_CIERRE_ANTERIOR_INGRESO':
          'A data de encerramento não pode ser anterior à data de entrada',
      'LOTE_FECHA_CIERRE_FUTURA': 'A data de encerramento não pode ser futura',
      'LOTE_ACTIVO_EN_GALPON': 'Já existe um lote ativo neste galpão',
      'LOTE_PESO_MAYOR_CERO': 'O peso médio deve ser maior que 0',
      'LOTE_NO_ELIMINAR_ACTIVO':
          'Não é possível excluir um lote ativo. Primeiro encerre-o.',
      'LOTE_CANTIDAD_MINIMA': 'A quantidade inicial deve ser de pelo menos 10 aves',

      // Galpones usecases
      'GALPON_SIN_LOTE': 'O galpão não tem nenhum lote atribuído.',
      'GALPON_CON_LOTE_NO_ELIMINAR':
          'Não é possível excluir um galpão com lote atribuído. Primeiro libere o lote.',
      'GALPON_EN_CUARENTENA_NO_ELIMINAR':
          'Não é possível excluir um galpão em quarentena. Primeiro deve sair da quarentena.',
      'GALPON_EN_PROCESO_CONFIRMAR':
          'O galpão está em {estado}. Tem certeza de que deseja excluí-lo?',
      'GALPON_CODIGO_DUPLICADO':
          'Já existe um galpão com esse código nesta granja',
      'GALPON_NOMBRE_DUPLICADO':
          'Já existe um galpão com esse nome nesta granja',
      'GALPON_TRANSICION_INVALIDA':
          'Não é possível mudar de {estadoActual} para {estadoNuevo}',
      'GALPON_MOTIVO_CUARENTENA': 'Deve especificar o motivo da quarentena',
      'GALPON_CON_LOTE_CONTINUAR':
          'O galpão tem um lote atribuído. Deseja continuar?',
      'GALPON_INACTIVAR_CON_LOTE':
          'Não é possível inativar um galpão com lote atribuído. Primeiro libere o lote.',
      'GALPON_ACTIVO_PARA_LOTE':
          'O galpão deve estar ativo para atribuir um lote. Estado atual: {estado}',
      'GALPON_LOTE_YA_ASIGNADO':
          'O galpão já tem um lote atribuído. Primeiro libere o lote atual.',
      'GALPON_DESINFECCION_TRANSICION':
          'Não é possível registrar desinfecção a partir do estado {estado}',
      'GALPON_DESINFECCION_CON_LOTE':
          'O galpão tem um lote atribuído. A desinfecção deve ser realizada sem animais presentes.',
      'GALPON_DESINFECCION_PRODUCTOS':
          'Deve especificar pelo menos um produto de desinfecção',
      'GALPON_MANTENIMIENTO_TRANSICION':
          'Não é possível programar manutenção a partir do estado {estado}',
      'GALPON_MANTENIMIENTO_CON_LOTE':
          'O galpão tem um lote atribuído. Recomenda-se liberar o lote antes da manutenção.',
      'GALPON_MANTENIMIENTO_FECHA_FUTURA': 'A data de início deve ser futura',
      'GALPON_MANTENIMIENTO_DESCRIPCION':
          'Deve especificar uma descrição da manutenção',

      // Granjas usecases
      'GRANJA_NO_ENCONTRADA': 'A granja não existe',
      'GRANJA_NOMBRE_DUPLICADO': 'Já existe uma granja com esse nome',
      'GRANJA_ACTIVA_NO_ELIMINAR':
          'Não é possível excluir uma granja ativa. Primeiro suspenda-a.',
      'GRANJA_CON_GALPONES_ACTIVOS':
          'Não é possível excluir a granja porque possui galpões ativos.',
      'GRANJA_CON_LOTES_ACTIVOS':
          'Não é possível excluir a granja porque possui lotes ativos.',

      // Salud usecases
      'VACUNACION_NO_ENCONTRADA': 'Vacinação não encontrada',
      'VACUNA_EDAD_OBLIGATORIA':
          'A idade de aplicação é obrigatória e deve ser maior que 0',
      'VACUNA_DOSIS_OBLIGATORIA': 'A dose é obrigatória',
      'VACUNA_VIA_OBLIGATORIA': 'A via de aplicação é obrigatória',

      // ServerFailure prefix
      'ERROR_REGISTRAR_COSTO': 'Erro ao registrar custo',
      'ERROR_ACTUALIZAR_LOTE': 'Erro ao atualizar lote',
      'ERROR_CERRAR_LOTE': 'Erro ao encerrar o lote',
      'ERROR_ELIMINAR_LOTE': 'Erro ao excluir o lote',
      'ERROR_REGISTRAR_CONSUMO': 'Erro ao registrar consumo',
      'ERROR_REGISTRAR_PESO': 'Erro ao registrar peso',
      'ERROR_ACTUALIZAR_GALPON': 'Erro ao atualizar galpão',
      'ERROR_ASIGNAR_LOTE': 'Erro ao atribuir lote',
      'ERROR_CAMBIAR_ESTADO': 'Erro ao alterar estado',
      'ERROR_CREAR_GALPON': 'Erro ao criar galpão',
      'ERROR_ELIMINAR_GALPON': 'Erro ao excluir galpão',
      'ERROR_LIBERAR_GALPON': 'Erro ao liberar galpão',
      'ERROR_OBTENER_GALPONES': 'Erro ao obter galpões',
      'ERROR_REGISTRAR_DESINFECCION': 'Erro ao registrar desinfecção',
      'ERROR_PROGRAMAR_MANTENIMIENTO': 'Erro ao programar manutenção',
      'ERROR_ACTIVAR_GRANJA': 'Erro ao ativar granja',
      'ERROR_BUSCAR_GRANJAS': 'Erro ao buscar granjas',
      'ERROR_CREAR_GRANJA': 'Erro ao criar granja',
      'ERROR_OBTENER_DASHBOARD': 'Erro ao obter dashboard',
      'ERROR_SUSPENDER_GRANJA': 'Erro ao suspender granja',
      'ERROR_ACTUALIZAR_GRANJA': 'Erro inesperado ao atualizar granja',
      'ERROR_ELIMINAR_GRANJA': 'Erro inesperado ao excluir granja',
      'ERROR_APLICAR_VACUNA': 'Erro ao aplicar vacina',

      // Lotes usecases - registrar pesos
      'LOTE_NO_REGISTRAR_PESO':
          'Não é possível registrar pesos em um lote {estado}',

      // Lotes usecases - additional
      'ERROR_CREAR_LOTE_UC': 'Erro inesperado ao criar o lote: {detail}',
      'ERROR_OBTENER_ESTADISTICAS': 'Erro ao obter estatísticas: {detail}',
      'ERROR_OBTENER_DISPONIBLES':
          'Erro ao obter galpões disponíveis: {detail}',
      'ERROR_MANTENIMIENTO_GRANJA':
          'Erro ao colocar granja em manutenção: {detail}',
      'ERROR_REGISTRAR_MORTALIDAD':
          'Erro inesperado ao registrar mortalidade: {detail}',
      'ERROR_REGISTRAR_PRODUCCION': 'Erro ao registrar produção: {detail}',
      'LOTE_NO_EDITAR_CERRADO_VENDIDO':
          'Não é possível editar um lote encerrado ou vendido',
      'LOTE_NO_REGISTRAR_CONSUMO_UC':
          'Não é possível registrar consumo em um lote {estado}',
      'LOTE_CANTIDAD_ALIMENTO_MAYOR_CERO':
          'A quantidade de alimento deve ser maior que 0',
      'LOTE_NO_REGISTRAR_MORTALIDAD_UC':
          'Não é possível registrar mortalidade em um lote com estado {estado}',
      'LOTE_MORTALIDAD_MAYOR_CERO':
          'A quantidade de aves mortas deve ser maior que 0',
      'LOTE_MORTALIDAD_EXCEDE_CANTIDAD':
          'A quantidade de aves mortas ({cantidad}) excede a quantidade atual do lote ({cantidadActual})',
      'LOTE_SOLO_PONEDORAS_PRODUCCION':
          'Apenas lotes de poedeiras podem registrar produção de ovos',
      'LOTE_NO_REGISTRAR_PRODUCCION_UC':
          'Não é possível registrar produção em um lote {estado}',
      'LOTE_HUEVOS_MAYOR_CERO': 'A quantidade de ovos deve ser maior que 0',
      'REGISTRO_SALUD_NO_ENCONTRADO': 'O registro de saúde não existe',

      // Value objects - lote_finanzas
      'LOTE_FINANZAS_YA_CERRADO': 'O lote já está encerrado',
      'LOTE_FINANZAS_YA_VENDIDO': 'O lote já foi vendido',

      // Value objects - lote_produccion
      'LOTE_PROD_PESO_POSITIVO': 'O peso deve ser positivo',
      'LOTE_PROD_CONSUMO_POSITIVO': 'A quantidade de consumo deve ser positiva',
      'LOTE_PROD_HUEVOS_POSITIVO': 'A quantidade de ovos deve ser positiva',

      // Value objects - lote_estadisticas
      'LOTE_EST_MORTALIDAD_POSITIVA':
          'A quantidade de mortalidade deve ser positiva',
      'LOTE_EST_MORTALIDAD_EXCEDE':
          'A quantidade de mortalidade ({cantidad}) não pode exceder a quantidade atual ({cantidadActual})',

      // Entity validation - common
      'VAL_LOTE_ID_REQUIRED': 'O ID do lote é obrigatório',
      'VAL_GRANJA_ID_REQUIRED': 'O ID da granja é obrigatório',
      'VAL_GALPON_ID_REQUIRED': 'O ID do galpão é obrigatório',
      'VAL_EDAD_NEGATIVA': 'A idade não pode ser negativa',

      // Entity validation - registro_peso
      'REG_PESO_PROMEDIO_MAYOR_CERO': 'O peso médio deve ser maior que 0',
      'REG_PESO_AVES_MINIMA': 'Deve pesar pelo menos 1 ave',
      'REG_PESO_TOTAL_MAYOR_CERO': 'O peso total deve ser maior que 0',
      'REG_PESO_MINIMO_MAYOR_CERO': 'O peso mínimo deve ser maior que 0',
      'REG_PESO_MAX_MAYOR_MIN': 'O peso máximo deve ser >= peso mínimo',
      'REG_PESO_MAX_FOTOS': 'Máximo 3 fotos por registro',

      // Entity validation - registro_produccion
      'REG_PROD_HUEVOS_NO_NEGATIVO':
          'Os ovos coletados não podem ser negativos',
      'REG_PROD_BUENOS_NO_NEGATIVO':
          'Os ovos bons não podem ser negativos',
      'REG_PROD_BUENOS_NO_SUPERAR':
          'Os ovos bons não podem superar os coletados',
      'REG_PROD_AVES_MAYOR_CERO': 'A quantidade de aves deve ser maior que 0',
      'REG_PROD_MAX_FOTOS': 'Máximo 3 fotos por registro',
      'REG_PROD_PESO_POSITIVO': 'O peso médio deve ser positivo',

      // Entity validation - registro_consumo
      'REG_CONSUMO_CANTIDAD_MAYOR_CERO': 'A quantidade deve ser maior que 0',
      'REG_CONSUMO_AVES_MINIMA': 'Deve haver pelo menos 1 ave',
      'REG_CONSUMO_COSTO_NO_NEGATIVO': 'O custo não pode ser negativo',
      'REG_CONSUMO_USUARIO_REQUIRED': 'O usuário registrador é obrigatório',
      'REG_CONSUMO_NOMBRE_REQUIRED': 'O nome do usuário é obrigatório',
      'REG_CONSUMO_FECHA_NO_FUTURA': 'A data não pode ser futura',

      // Entity validation - registro_mortalidad
      'REG_MORT_CANTIDAD_MAYOR_CERO': 'A quantidade deve ser maior que 0',
      'REG_MORT_DESCRIPCION_MIN':
          'A descrição deve ter pelo menos 10 caracteres',
      'REG_MORT_MAX_FOTOS': 'Máximo 5 fotos por registro',
      'REG_MORT_CANTIDAD_EVENTO_INVALIDA':
          'A quantidade antes do evento é inválida',
      'REG_MORT_EXCEDE_DISPONIBLES':
          'A quantidade não pode exceder as aves disponíveis',

      // Value objects - direccion
      'DIR_CALLE_REQUIRED': 'A rua é obrigatória',
      'DIR_CALLE_MIN_LENGTH': 'A rua deve ter pelo menos 3 caracteres',
      'DIR_CIUDAD_REQUIRED': 'A cidade é obrigatória',
      'DIR_DEPARTAMENTO_REQUIRED': 'O estado é obrigatório',

      // Value objects - umbrales_ambientales
      'UMBRAL_TEMP_MIN_MAYOR_MAX':
          'A temperatura mínima deve ser menor que a máxima',
      'UMBRAL_HUM_MIN_MAYOR_MAX':
          'A umidade mínima deve ser menor que a máxima',
      'UMBRAL_HUM_RANGO': 'A umidade deve estar entre 0 e 100%',
      'UMBRAL_AMONIACO_NEGATIVO': 'O nível de amônia não pode ser negativo',
      'UMBRAL_CO2_NEGATIVO': 'O nível de CO2 não pode ser negativo',

      // Salud usecases - tratamiento
      'SALUD_DIAGNOSTICO_OBLIGATORIO': 'O diagnóstico é obrigatório',
      'SALUD_TRATAMIENTO_OBLIGATORIO': 'O tratamento é obrigatório',
      'SALUD_FECHA_NO_FUTURA': 'A data de registro não pode ser futura',
      'ERROR_REGISTRAR_TRATAMIENTO': 'Erro ao registrar tratamento: {detail}',

      // Salud usecases - vacunación
      'VACUNA_NOMBRE_OBLIGATORIO': 'O nome da vacina é obrigatório',
      'ERROR_PROGRAMAR_VACUNACION': 'Erro ao programar vacinação: {detail}',

      // Salud usecases - cerrar registro
      'ERROR_CERRAR_REGISTRO_SALUD':
          'Erro ao encerrar registro de saúde: {detail}',

      // Galpones - actualizar duplicados
      'GALPON_CODIGO_DUPLICADO_ACTUALIZAR':
          'Já existe um galpão com esse código',
      'GALPON_NOMBRE_DUPLICADO_ACTUALIZAR':
          'Já existe um galpão com esse nome',

      // Granjas - dashboard
      'GRANJA_NO_ENCONTRADA_DASHBOARD': 'A granja não existe',

      // Value objects - coordenadas
      'COORD_LATITUD_RANGO': 'A latitude deve estar entre -90 e 90',
      'COORD_LONGITUD_RANGO': 'A longitude deve estar entre -180 e 180',

      // Value objects - location phone validation
      'PHONE_START_VENEZUELA': 'O telefone deve começar com 4 ou 2',
      'PHONE_START_COLOMBIA': 'O telefone deve começar com 3',
      'PHONE_START_ARGENTINA': 'O telefone deve começar com 1, 2 ou 3',
      'PHONE_START_BOLIVIA': 'O telefone deve começar com 6 ou 7',
      'PHONE_START_DEFAULT': 'O telefone deve começar com 9',

      // Enum fromJson errors
      'ENUM_INVALID_TIPO_GALPON': 'TipoGalpão inválido: {value}',
      'ENUM_INVALID_ESTADO_GALPON': 'EstadoGalpão inválido: {value}',
      'ENUM_INVALID_ESTADO_GRANJA': 'EstadoGranja inválido: {value}',
      'ENUM_INVALID_CAUSA_MORTALIDAD': 'CausaMortalidade inválida: {value}',

      // Inventario - movimiento asserts
      'MOVIMIENTO_TIPO_ENTRADA': 'O tipo deve ser uma entrada',
      'MOVIMIENTO_TIPO_SALIDA': 'O tipo deve ser uma saída',

      // Domain data - enfermedad_avicola
      'ENF_NO_ESPECIFICADO': 'Não especificado',
      'ENF_CONSULTAR_VETERINARIO': 'Consultar veterinário',
      'ENF_NO_CONTAGIOSA': 'Não contagiosa',
      'ENF_DIAG_VIRAL': 'PCR, ELISA, Isolamento viral',
      'ENF_DIAG_BACTERIANA': 'Cultura bacteriana, Antibiograma',
      'ENF_DIAG_PARASITARIA': 'Exame coprológico, Necropsia',
      'ENF_DIAG_FUNGICA': 'Cultura micológica, Histopatologia',
      'ENF_DIAG_NUTRICIONAL': 'Análise de alimento, Avaliação clínica',
      'ENF_DIAG_METABOLICA': 'Análise bioquímica, Histopatologia',
      'ENF_DIAG_AMBIENTAL': 'Avaliação ambiental, Análise de água',
      'ENF_TRANS_VIRAL': 'Aerossol, contato direto, fômites',
      'ENF_TRANS_BACTERIANA': 'Contato direto, água, alimento contaminado',
      'ENF_TRANS_PARASITARIA': 'Oral-fecal, vetores intermediários',
      'ENF_TRANS_FUNGICA': 'Inalação de esporos, cama contaminada',
      'ENF_TRANS_DEFAULT': 'Variável conforme condições',

      // Auth loading messages
      'AUTH_LOADING_LOGIN': 'Entrando...',
      'AUTH_LOADING_GOOGLE': 'Conectando com o Google...',
      'AUTH_LOADING_APPLE': 'Conectando com a Apple...',
      'AUTH_LOADING_REGISTER': 'Criando conta...',
      'AUTH_LOADING_LOGOUT': 'Saindo...',
      'AUTH_LOADING_EMAIL': 'Enviando e-mail...',
      'AUTH_LOADING_PASSWORD': 'Alterando senha...',
      'AUTH_LOADING_PROFILE': 'Atualizando perfil...',
      'AUTH_LOADING_VERIFYING': 'Verificando identidade...',
      'AUTH_LOADING_LINKING': 'Vinculando conta do {provider}...',
      'AUTH_SESSION_CLOSED': 'Sessão encerrada',
      'AUTH_NO_PENDING_CREDENTIAL': 'Não há credencial pendente para vincular',
      'AUTH_PASSWORD_UPDATED': 'Senha atualizada com sucesso',
      'AUTH_USER_NOT_AUTHENTICATED': 'Usuário não autenticado',

      // Galpon form validation
      'GALPON_FORM_CODIGO_REQUERIDO': 'O código é obrigatório',
      'GALPON_FORM_CODIGO_MIN': 'O código deve ter pelo menos 2 caracteres',
      'GALPON_FORM_NOMBRE_REQUERIDO': 'O nome é obrigatório',
      'GALPON_FORM_NOMBRE_MIN': 'O nome deve ter pelo menos 3 caracteres',
      'GALPON_FORM_TIPO_REQUERIDO': 'O tipo é obrigatório',
      'GALPON_FORM_CAPACIDAD_POSITIVA': 'A capacidade deve ser maior que 0',

      // Router errors
      'ROUTER_INVITATION_NOT_FOUND': 'Dados do convite não encontrados',
      'ROUTER_BATCH_INFO_MISSING': 'Informações do lote não fornecidas',

      // Permissions
      'PERM_NO_CHANGE_ROLE': 'Você não tem permissão para alterar cargos',
      'PERM_NO_ASSIGN_OWNER': 'Não é possível atribuir o cargo de proprietário',
      'PERM_NO_REMOVE_USER': 'Você não tem permissão para remover usuários',

      // Costos provider
      'COSTO_REGISTRADO_OK': 'Gasto registrado com sucesso',
      'COSTO_ACTUALIZADO_OK': 'Gasto atualizado com sucesso',
      'COSTO_ELIMINADO_OK': 'Gasto excluído com sucesso',
      'ERROR_ACTUALIZAR_COSTO': 'Erro ao atualizar gasto',
      'ERROR_ELIMINAR_COSTO': 'Erro ao excluir gasto',
      'COSTO_APROBADO_OK': 'Gasto aprovado com sucesso',
      'COSTO_RECHAZADO_OK': 'Gasto rejeitado',

      // Ventas provider
      'VENTA_REGISTRADA_OK': 'Venda registrada com sucesso',
      'VENTA_ACTUALIZADA_OK': 'Venda atualizada com sucesso',
      'VENTA_ELIMINADA_OK': 'Venda excluída com sucesso',

      // Actividades recientes - títulos
      'ACT_PRODUCCION_REGISTRADA': 'Produção registrada',
      'ACT_MORTALIDAD_REGISTRADA': 'Mortalidade registrada',
      'ACT_CONSUMO_REGISTRADO': 'Consumo registrado',
      'ACT_PESAJE_REGISTRADO': 'Pesagem registrada',
      'ACT_GASTO_REGISTRADO': 'Gasto registrado',
      'ACT_VENTA_REGISTRADA': 'Venda registrada',
      'ACT_REGISTRO_SALUD': 'Registro de saúde',
      'ACT_VACUNACION_APLICADA': 'Vacinação aplicada',
      'ACT_VACUNACION_PROGRAMADA': 'Vacinação programada',
      'ACT_NUEVO_LOTE': 'Novo lote',
      'ACT_NECROPSIA_REALIZADA': 'Necropsia realizada',
      'ACT_INSPECCION_BIOSEGURIDAD': 'Inspeção de biossegurança',

      // Actividades recientes - subtítulos con formato
      'ACT_SUB_HUEVOS': '{count} ovos',
      'ACT_SUB_AVES': '{count} aves',
      'ACT_SUB_PROMEDIO': '{peso}g média',
      'ACT_SUB_LOTE_DETALLE': '{codigo} • {cantidad} aves',
      'ACT_SUB_NECROPSIA': '{numAves} aves • {diagnostico}',
      'ACT_SUB_PUNTAJE': 'Pontuação: {puntaje}% • {inspector}',

      // Actividades recientes - venta tipo labels
      'ACT_VENTA_AVES_VIVAS': 'Aves vivas',
      'ACT_VENTA_AVES_FAENADAS': 'Aves abatidas',
      'ACT_VENTA_AVES_DESCARTE': 'Aves de descarte',
      'ACT_VENTA_HUEVOS': 'Ovos',
      'ACT_VENTA_POLLINAZA': 'Cama de frango',

      // Actividades recientes - movimiento títulos
      'ACT_MOV_COMPRA': 'Compra de inventário',
      'ACT_MOV_DONACION': 'Doação recebida',
      'ACT_MOV_CONSUMO_LOTE': 'Consumo do lote',
      'ACT_MOV_TRATAMIENTO': 'Tratamento aplicado',
      'ACT_MOV_VACUNACION': 'Vacinação',
      'ACT_MOV_AJUSTE_POS': 'Ajuste positivo',
      'ACT_MOV_AJUSTE_NEG': 'Ajuste negativo',
      'ACT_MOV_DEVOLUCION': 'Devolução',
      'ACT_MOV_MERMA': 'Perda',
      'ACT_MOV_TRANSFERENCIA': 'Transferência',
      'ACT_MOV_USO_GENERAL': 'Uso geral',
      'ACT_MOV_VENTA': 'Venda',

      // Actividades recientes - evento galpón títulos
      'ACT_EVT_DESINFECCION': 'Desinfecção',
      'ACT_EVT_MANTENIMIENTO': 'Manutenção',
      'ACT_EVT_CAMBIO_ESTADO': 'Mudança de estado',
      'ACT_EVT_GALPON_CREADO': 'Galpão criado',
      'ACT_EVT_LOTE_ASIGNADO': 'Lote atribuído',
      'ACT_EVT_LOTE_LIBERADO': 'Lote liberado',
      'ACT_EVT_EVENTO': 'Evento',

      // Actividades recientes - fallbacks y formatos
      'ACT_FALLBACK_REGISTRO': 'Registro',
      'ACT_FALLBACK_VACUNA': 'Vacina',
      'ACT_FALLBACK_EVENTO': 'Evento',
      'ACT_FALLBACK_EN_EVALUACION': 'Em avaliação',
      'ACT_FALLBACK_INSPECTOR': 'Inspetor',
      'ACT_SUB_INVENTARIO': '{signo}{cantidad} uds',
      'ACT_HUEVOS_CLASIFICACION': '{clasificacion} ({cantidad} uds)',
      'UNIT_AVES': 'aves',
      'UNIT_UNIDADES': 'unidades',
      'UNIT_SACOS': 'sacos',
      'CONCEPTO_MOVIMIENTO': '{tipo}: {item} ({cantidad} {unidad})',

      // Sync status
      'SYNC_PENDING': 'Pendente',
      'SYNC_LOCAL': 'Local',
      'SYNC_SYNCED': 'Sincronizado',
      'SYNC_TOOLTIP_PENDING': 'Dados pendentes de sincronização',
      'SYNC_TOOLTIP_CACHE': 'Dados do cache local',
      'SYNC_TOOLTIP_SYNCED': 'Dados sincronizados com o servidor',
      'SYNC_OFFLINE_MODE': 'Modo offline',
      'SYNC_OFFLINE_MSG':
          'As alterações serão salvas localmente e sincronizadas quando você se reconectar',
      'SYNC_NO_CONNECTION': 'Sem conexão',
      'SYNC_NO_CONNECTION_MSG':
          'Sem conexão com a internet. Os dados exibidos podem não estar atualizados',
      'SYNC_SYNCING': 'Sincronizando',
      'SYNC_SYNCING_MSG': 'Enviando alterações para o servidor...',
      'SYNC_LAST_SYNC': 'Última sincronização: {time}',
      'SYNC_CONNECTED_VIA': 'Conectado via {type}',
      'SYNC_ALL_SYNCED': 'Tudo sincronizado',
      'SYNC_JUST_NOW': 'agora mesmo',
      'SYNC_MINUTES_AGO': 'há {min} min',
      'SYNC_HOURS_AGO': 'há {hours} horas',
      'SYNC_DAYS_AGO': 'há {days} dias',
      'SYNC_NOW': 'agora',
      'SYNC_AGO_M': 'há {min}m',
      'SYNC_AGO_H': 'há {hours}h',
      'SYNC_AGO_D': 'há {days}d',

      // Connectivity
      'CONN_MOBILE_DATA': 'Dados móveis',
      'CONN_NO_CONNECTION': 'Sem conexão',
      'CONN_OTHER': 'Outra conexão',

      // Inventory integration motivos
      'MOTIVO_COMPRA_COSTOS': 'Compra registrada a partir de Custos',
      'MOTIVO_CONSUMO_LOTE': 'Consumo de alimento no lote',
      'MOTIVO_VENTA': 'Venda de {producto}',
      'MOTIVO_FALLBACK_PRODUCTO': 'produto',
      'MOTIVO_TRATAMIENTO': 'Aplicação de tratamento',
      'MOTIVO_VACUNA': 'Aplicação de vacina',
      'MOTIVO_DESINFECCION': 'Desinfecção do galpão',

      // Inventory cost categories
      'CAT_ALIMENTACION': 'Alimentação',
      'CAT_SANIDAD': 'Sanidade',
      'CAT_EQUIPAMIENTO': 'Equipamento',
      'CAT_LIMPIEZA': 'Limpeza',
      'CAT_INSUMOS': 'Insumos',
      'CAT_OTROS': 'Outros',
      'CONCEPTO_COMPRA_ITEM': 'Compra de {item} ({cantidad} {unidad})',
      'OBS_AUTO_INVENTARIO':
          'Gerado automaticamente a partir do Inventário. Item: {item}, Quantidade: {cantidad} {unidad}, Preço unitário: \${precio}',
      'OBS_AUTO_MOVIMIENTO':
          'Gerado automaticamente a partir de movimentação de inventário. {motivo}',

      // Tendencias
      'TREND_INCREASING': 'aumentando',
      'TREND_DECREASING': 'diminuindo',
      'TREND_STABLE': 'estável',

      // Reportes fallback
      'FALLBACK_GALPON': 'Galpão',

      // Accessibility
      'A11Y_FILTER_BY': 'Filtrar por {label}',

      // Causa mortalidad - acciones recomendadas
      'CAUSA_ACT_ENF_1': 'Solicitar diagnóstico veterinário',
      'CAUSA_ACT_ENF_2': 'Isolar aves afetadas',
      'CAUSA_ACT_ENF_3': 'Aplicar tratamento se disponível',
      'CAUSA_ACT_ENF_4': 'Aumentar biossegurança',
      'CAUSA_ACT_ENF_5': 'Revisar programa de vacinação',
      'CAUSA_ACT_ACC_1': 'Inspecionar instalações',
      'CAUSA_ACT_ACC_2': 'Reparar equipamentos danificados',
      'CAUSA_ACT_ACC_3': 'Revisar densidade de aves',
      'CAUSA_ACT_ACC_4': 'Capacitar pessoal em manejo',
      'CAUSA_ACT_DES_1': 'Verificar acesso ao alimento',
      'CAUSA_ACT_DES_2': 'Revisar qualidade do alimento',
      'CAUSA_ACT_DES_3': 'Verificar funcionamento dos bebedouros',
      'CAUSA_ACT_DES_4': 'Ajustar programa nutricional',
      'CAUSA_ACT_EST_1': 'Regular temperatura ambiente',
      'CAUSA_ACT_EST_2': 'Melhorar ventilação',
      'CAUSA_ACT_EST_3': 'Reduzir densidade se necessário',
      'CAUSA_ACT_MET_1': 'Consultar nutricionista',
      'CAUSA_ACT_MET_2': 'Revisar programa de crescimento',
      'CAUSA_ACT_MET_3': 'Ajustar formulação do alimento',
      'CAUSA_ACT_DEP_1': 'Reforçar cercas perimetrais',
      'CAUSA_ACT_DEP_2': 'Implementar controle de pragas',
      'CAUSA_ACT_DEP_3': 'Instalar telas de proteção',
      'CAUSA_ACT_NORMAL': 'Normal no processo produtivo',
      'CAUSA_ACT_DESC_1': 'Solicitar necropsia se mortalidade for alta',
      'CAUSA_ACT_DESC_2': 'Aumentar monitoramento do lote',
      'CAUSA_ACT_DESC_3': 'Consultar veterinário',

      // Causa mortalidad - categorías
      'CAUSA_CAT_SANITARIA': 'Sanitária',
      'CAUSA_CAT_MANEJO': 'Manejo',
      'CAUSA_CAT_NUTRICIONAL': 'Nutricional',
      'CAUSA_CAT_AMBIENTAL': 'Ambiental',
      'CAUSA_CAT_FISIOLOGICA': 'Fisiológica',
      'CAUSA_CAT_NATURAL': 'Natural',
      'CAUSA_CAT_SIN_CLASIFICAR': 'Sem classificação',

      // Enfermedad avícola - síntomas (separados por |)
      'ENF_NEWCASTLE_SINT':
          'Problemas respiratórios|Diarreia esverdeada|Torcicolo|Paralisia|Queda de postura|Alta mortalidade',
      'ENF_NEWCASTLE_TRAT':
          'Vacinação preventiva|Quarentena rigorosa|Sacrifício sanitário em casos graves',
      'ENF_GUMBORO_SINT':
          'Depressão|Diarreia aquosa esbranquiçada|Penas eriçadas|Inflamação da bolsa de Fabricius|Imunossupressão',
      'ENF_GUMBORO_TRAT':
          'Vacinação conforme programa|Biossegurança rigorosa|Controle de estresse',
      'ENF_MAREK_SINT':
          'Paralisia de patas e asas|Tumores em órgãos|Íris cinza (olho cinza)|Perda de peso|Morte súbita',
      'ENF_MAREK_TRAT':
          'Vacinação in-ovo ou no dia do nascimento|Não há tratamento|Eliminação de aves afetadas',
      'ENF_BRONQUITISINFECCIOSA_SINT':
          'Espirros|Estertores traqueais|Secreção nasal|Queda de postura|Ovos deformados|Problemas renais',
      'ENF_BRONQUITISINFECCIOSA_TRAT':
          'Vacinação múltipla|Ventilação adequada|Controle de amônia',
      'ENF_INFLUENZAAVIAR_SINT':
          'Morte súbita|Edema facial|Cianose na crista e barbela|Hemorragias nas patas|Queda drástica de postura|Sintomas nervosos',
      'ENF_INFLUENZAAVIAR_TRAT':
          'Notificação obrigatória|Sacrifício sanitário|Quarentena da zona|Biossegurança máxima',
      'ENF_LARINGOTRAQUEITIS_SINT':
          'Dispneia severa|Estiramento do pescoço para respirar|Sangue na traqueia|Tosse com sangue|Alta mortalidade por asfixia',
      'ENF_LARINGOTRAQUEITIS_TRAT':
          'Vacinação preventiva|Isolamento das aves afetadas|Desinfecção rigorosa',
      'ENF_VIRUELAAVIAR_SINT':
          'Nódulos na crista e barbela|Lesões na boca (forma diftérica)|Crostas na pele|Dificuldade para comer',
      'ENF_VIRUELAAVIAR_TRAT':
          'Vacinação preventiva|Controle de mosquitos|Tratamento de lesões com antissépticos',
      'ENF_ANEMIINFECCIOSA_SINT':
          'Palidez|Anemia|Hemorragias musculares|Imunossupressão|Dermatite gangrenosa',
      'ENF_ANEMIINFECCIOSA_TRAT':
          'Vacinação de reprodutoras|Biossegurança|Controle de imunossupressores',
      'ENF_COLIBACILOSIS_SINT':
          'Septicemia|Perihepatite|Pericardite|Aerossaculite|Onfalite em pintinhos|Celulite',
      'ENF_COLIBACILOSIS_TRAT':
          'Antibióticos conforme antibiograma|Melhoria da biossegurança|Controle da qualidade da água|Redução do estresse',
      'ENF_SALMONELOSIS_SINT':
          'Diarreia|Onfalite|Septicemia em pintinhos|Portadores assintomáticos|Queda de postura',
      'ENF_SALMONELOSIS_TRAT':
          'Programa de controle obrigatório|Vacinação|Biossegurança rigorosa|Monitoramento sorológico',
      'ENF_MYCOPLASMOSIS_SINT':
          'Espirros|Secreção nasal|Estertores|Inflamação dos seios nasais|Sinovite (MS)|Queda de produção',
      'ENF_MYCOPLASMOSIS_TRAT':
          'Antibióticos (tilosina, enrofloxacina)|Vacinação preventiva|Lotes livres de micoplasma',
      'ENF_COLERAAVIAR_SINT':
          'Morte súbita|Febre alta|Diarreia esverdeada|Cianose na crista|Artrite|Torcicolo',
      'ENF_COLERAAVIAR_TRAT':
          'Antibióticos (sulfas, tetraciclinas)|Vacinação em áreas endêmicas|Eliminação de aves crônicas',
      'ENF_CORIZA_SINT':
          'Inflamação facial|Secreção nasal fétida|Conjuntivite|Espirros|Mau cheiro característico',
      'ENF_CORIZA_TRAT':
          'Antibióticos (sulfas, eritromicina)|Vacinação preventiva|Eliminação de portadores',
      'ENF_CLOSTRIDIOSISNECROTICA_SINT':
          'Morte súbita|Diarreia escura|Penas eriçadas|Depressão|Lesões necróticas no intestino',
      'ENF_CLOSTRIDIOSISNECROTICA_TRAT':
          'Antibióticos (bacitracina, lincomicina)|Controle de coccidiose|Manejo da cama|Aditivos alternativos',
      'ENF_COCCIDIOSIS_SINT':
          'Diarreia sanguinolenta|Penas eriçadas|Depressão|Perda de peso|Desidratação|Alta mortalidade',
      'ENF_COCCIDIOSIS_TRAT':
          'Anticoccidianos na ração|Vacinas vivas|Manejo de cama seca|Rotação de princípios ativos',
      'ENF_ASCARIDIASIS_SINT':
          'Perda de peso|Palidez|Diarreia|Obstrução intestinal (casos graves)',
      'ENF_ASCARIDIASIS_TRAT':
          'Desparasitação periódica|Rotação de piquetes|Manejo higiênico',
      'ENF_ASPERGILOSIS_SINT':
          'Dificuldade respiratória|Dispneia|Nódulos nos pulmões|Alta mortalidade em pintinhos',
      'ENF_ASPERGILOSIS_TRAT':
          'Eliminar fontes de fungo|Desinfecção de incubadoras|Não há tratamento eficaz',
      'ENF_ASCITIS_SINT':
          'Abdômen distendido|Líquido abdominal|Cianose|Dificuldade respiratória|Morte súbita',
      'ENF_ASCITIS_TRAT':
          'Restrição alimentar precoce|Controle da velocidade de crescimento|Ventilação adequada|Altitude (fator de risco)',
      'ENF_MUERTESUBITA_SINT':
          'Morte súbita de aves aparentemente saudáveis|Aves em posição dorsal|Mais comum em machos de crescimento rápido',
      'ENF_MUERTESUBITA_TRAT':
          'Restrição alimentar|Controle de crescimento|Programas de luz',
      'ENF_DEFICIENCIAVITAMINAE_SINT':
          'Ataxia|Torcicolo|Convulsões|Paralisia',
      'ENF_DEFICIENCIAVITAMINAE_TRAT':
          'Suplementação de Vitamina E|Antioxidantes na ração',
      'ENF_RAQUITISMO_SINT':
          'Ossos moles|Patas tortas|Bico mole|Cascas fracas',
      'ENF_RAQUITISMO_TRAT':
          'Correção dos níveis de Cálcio, Fósforo e Vitamina D3|Exposição à luz solar',

      // Provider error messages
      'ERR_LOADING_ALERTS': 'Erro ao carregar alertas: {e}',
      'ERR_LOADING_INSPECTIONS': 'Erro ao carregar inspeções: {e}',
      'ERR_SAVING_INSPECTION': 'Erro ao salvar inspeção: {e}',
      'ERR_LOADING_PROGRAMS': 'Erro ao carregar programas: {e}',
      'ERR_LOADING_NECROPSIES': 'Erro ao carregar necropsias: {e}',
      'ERR_LOADING_BATCH_NECROPSIES': 'Erro ao carregar necropsias do lote: {e}',
      'ERR_REGISTERING_NECROPSY': 'Erro ao registrar necropsia: {e}',
      'ERR_UPDATING_RESULT': 'Erro ao atualizar resultado: {e}',
      'ERR_CONFIRMING_DIAGNOSIS': 'Erro ao confirmar diagnóstico: {e}',
      'ERR_DELETING_NECROPSY': 'Erro ao excluir necropsia: {e}',
      'ERR_LOADING_STATISTICS': 'Erro ao carregar estatísticas: {e}',
      'ERR_LOADING_ANTIMICROBIAL_USES': 'Erro ao carregar usos de antimicrobianos: {e}',
      'ERR_LOADING_WITHDRAWAL_BATCHES': 'Erro ao carregar lotes em carência: {e}',
      'ERR_REGISTERING_ANTIMICROBIAL_USE': 'Erro ao registrar uso de antimicrobiano: {e}',
      'ERR_GENERATING_REPORT': 'Erro ao gerar relatório: {e}',
      'ERR_UPDATING_USE': 'Erro ao atualizar uso: {e}',
      'ERR_DELETING_USE': 'Erro ao excluir uso: {e}',
      'ERR_LOADING_EVENTS': 'Erro ao carregar eventos: {e}',
      'ERR_CREATING_EVENT': 'Erro ao criar evento: {e}',
      'ERR_COMPLETING_EVENT': 'Erro ao concluir evento: {e}',
      'ERR_CANCELING_EVENT': 'Erro ao cancelar evento: {e}',
      'ERR_RESCHEDULING_EVENT': 'Erro ao reprogramar evento: {e}',
      'ERR_DELETING_EVENT': 'Erro ao excluir evento: {e}',
      'ERR_CREATING_EVENTS_FROM_PROGRAM': 'Erro ao criar eventos a partir do programa: {e}',

      // Infrastructure error messages
      'ERR_NO_CONNECTION': 'Sem conexão com a internet',
      'ERR_NO_CONNECTION_SYNC': 'Sem conexão para sincronizar',
      'ERR_LOGIN_FAILED': 'Não foi possível entrar',
      'ERR_GOOGLE_LOGIN_CANCELED': 'Login com o Google cancelado',
      'ERR_GOOGLE_LOGIN_FAILED': 'Não foi possível entrar com o Google',
      'ERR_APPLE_LOGIN_FAILED': 'Não foi possível entrar com a Apple',
      'ERR_CREATE_ACCOUNT_FAILED': 'Não foi possível criar a conta',
      'ERR_FILE_NOT_EXISTS': 'O arquivo não existe: {path}',
      'ERR_IMAGE_TOO_LARGE': 'A imagem excede o tamanho máximo (5MB)',
      'ERR_NO_PENDING_CREDENTIAL': 'Não há credencial pendente para vincular',
      'ERR_LINK_ACCOUNT_FAILED': 'Erro ao vincular a conta',
      'ERR_GOOGLE_ALREADY_LINKED': 'Esta conta do Google já está vinculada a outro usuário',
      'ERR_PROVIDER_ALREADY_LINKED': 'Este provedor já está vinculado à sua conta',
      'ERR_UNKNOWN': 'Erro desconhecido',
      'ERR_CREATE_FARM': 'Erro ao criar granja',
      'ERR_GET_FARM': 'Erro ao obter granja',
      'ERR_GET_FARMS': 'Erro ao obter granjas',
      'ERR_UPDATE_FARM': 'Erro ao atualizar granja',
      'ERR_DELETE_FARM': 'Erro ao excluir granja',
      'ERR_VERIFY_RUC': 'Erro ao verificar CNPJ',
      'ERR_COUNT_FARMS': 'Erro ao contar granjas',
      'ERR_CANNOT_INVITE_OWNER': 'Não é possível convidar com cargo de proprietário',
      'ERR_NO_INVITE_PERMISSION': 'Você não tem permissão para convidar usuários para esta granja',
      'ERR_INVITATION_NOT_FOUND': 'Convite não encontrado',
      'ERR_INVITATION_INVALID': 'Convite inválido ou expirado',
      'ERR_ALREADY_MEMBER': 'Você já é membro desta granja',
      'ERR_CANNOT_ACCEPT_OWN': 'Você não pode aceitar seu próprio convite',
      'ERR_REMOVE_USER': 'Erro ao remover usuário da granja',
      'ERR_FARM_NOT_FOUND': 'Granja não encontrada',
      'ERR_FARM_NOT_EXISTS': 'A granja não existe',
      'ERR_OWNER_CANNOT_LEAVE': 'O proprietário não pode abandonar sua granja',
      'ERR_LEAVE_FARM': 'Erro ao sair da granja',
      'ERR_CREATE_SHED': 'Erro ao criar galpão',
      'ERR_GET_SHED': 'Erro ao obter galpão',
      'ERR_GET_SHEDS': 'Erro ao obter galpões',
      'ERR_UPDATE_SHED': 'Erro ao atualizar galpão',
      'ERR_DELETE_SHED': 'Erro ao excluir galpão',
      'ERR_GET_AVAILABLE_SHEDS': 'Erro ao obter galpões disponíveis',
      'ERR_SEARCH_SHEDS': 'Erro ao buscar galpões',
      'ERR_REGISTER_EVENT': 'Erro ao registrar evento',
      'ERR_GET_EVENTS': 'Erro ao obter eventos',
      'ERR_COUNT_SHEDS': 'Erro ao contar galpões',
      'ERR_CREATE_COST': 'Erro ao criar custo: {e}',
      'ERR_GET_COST': 'Erro ao obter custo: {e}',
      'ERR_GET_COSTS': 'Erro ao obter custos: {e}',
      'ERR_UPDATE_COST': 'Erro ao atualizar custo: {e}',
      'ERR_DELETE_COST': 'Erro ao excluir custo: {e}',
      'ERR_GET_COSTS_BY_FARM': 'Erro ao obter custos por granja: {e}',
      'ERR_GET_COSTS_BY_BATCH': 'Erro ao obter custos por lote: {e}',
      'ERR_GET_COSTS_BY_TYPE': 'Erro ao obter custos por tipo: {e}',
      'ERR_GET_PENDING_COSTS': 'Erro ao obter custos pendentes: {e}',
      'ERR_GET_COSTS_BY_PERIOD': 'Erro ao obter custos por período: {e}',
      'ERR_CREATE_BATCH': 'Erro ao criar lote: {e}',
      'ERR_UPDATE_BATCH': 'Erro ao atualizar lote: {e}',
      'ERR_DELETE_BATCH': 'Erro ao excluir lote: {e}',
      'ERR_BATCH_OFFLINE': 'Lote indisponível sem conexão',
      'ERR_GET_BATCH': 'Erro ao obter lote: {e}',
      'ERR_GET_BATCHES': 'Erro ao obter lotes: {e}',
      'ERR_GET_SHED_BATCHES': 'Erro ao obter lotes do galpão: {e}',
      'ERR_GET_ACTIVE_BATCHES': 'Erro ao obter lotes ativos: {e}',
      'ERR_GET_BATCHES_BY_STATE': 'Erro ao obter lotes por estado: {e}',
      'ERR_SEARCH': 'Erro na busca: {e}',
      'ERR_REGISTER_MORTALITY': 'Erro ao registrar mortalidade: {e}',
      'ERR_REGISTER_DISCARD': 'Erro ao registrar descarte: {e}',
      'ERR_REGISTER_SALE': 'Erro ao registrar venda: {e}',
      'ERR_UPDATE_WEIGHT': 'Erro ao atualizar peso: {e}',
      'ERR_CHANGE_STATE': 'Erro ao alterar estado: {e}',
      'ERR_CLOSE_BATCH': 'Erro ao encerrar lote: {e}',
      'ERR_MARK_SOLD': 'Erro ao marcar como vendido: {e}',
      'ERR_TRANSFER_BATCH': 'Erro ao transferir lote: {e}',
      'ERR_GET_STATS': 'Erro ao obter estatísticas: {e}',
      'ERR_COUNT_BY_STATE': 'Erro ao contar por estado: {e}',
      'ERR_SYNC': 'Erro ao sincronizar: {e}',
      'ERR_CLEAR_CACHE': 'Erro ao limpar cache: {e}',

      // Infraestructura - usuarios granja
      'ERR_NO_CONNECTION_PHOTO': 'Sem conexão com a internet. A foto de perfil será atualizada quando houver sinal.',
      'ERR_GET_FARM_USERS': 'Erro ao obter usuários da granja',
      'ERR_ASSIGN_USER': 'Erro ao atribuir usuário à granja',
      'ERR_USER_NOT_FOUND_IN_FARM': 'Usuário não encontrado na granja',
      'ERR_CHANGE_ROLE': 'Erro ao alterar cargo do usuário',
      'ERR_TRANSFER_OR_DELETE': 'Deve transferir a propriedade ou excluir a granja',
      'ERR_GET_USER_FARMS': 'Erro ao obter granjas do usuário',
      'ERR_CREATE_INVITATION': 'Erro ao criar convite',
      'ERR_MARK_INVITATION_USED': 'Erro ao marcar convite como usado',
      'ERR_GET_INVITATIONS': 'Erro ao obter convites',
      'ERR_SHED_NOT_FOUND': 'Galpão não encontrado',
      'ERR_BATCH_NOT_FOUND': 'Lote não encontrado',
      'ERR_STREAM': 'Erro no stream: {e}',

      // Alertas service - inventario
      'ALERT_STOCK_BAJO': '⚠️ Estoque baixo: {item}',
      'ALERT_STOCK_BAJO_MSG': 'Restam apenas {cantidad} {unidad}',
      'ALERT_AGOTADO': '🚫 Esgotado: {item}',
      'ALERT_AGOTADO_MSG': 'Estoque zerado, reabastecimento urgente necessário',
      'ALERT_VENCIDO': '❌ Vencido: {item}',
      'ALERT_VENCIDO_MSG': 'Este produto venceu há {dias} dias',
      'ALERT_PROXIMO_VENCER': '📅 Próximo do vencimento: {item}',
      'ALERT_VENCE_HOY': 'Vence hoje!',
      'ALERT_VENCE_EN_DIAS': 'Vence em {dias} dias',
      'ALERT_REABASTECIDO': '✅ Reabastecido: {item}',
      'ALERT_REABASTECIDO_MSG': '{cantidad} {unidad} adicionados',
      'ALERT_MOVIMIENTO': '📦 {tipo}: {item}',
      'ALERT_MOVIMIENTO_MSG': '{cantidad} {unidad}',

      // Alertas service - mortalidad
      'ALERT_MORTALIDAD_CRITICA': '🚨 Mortalidade CRÍTICA: {lote}',
      'ALERT_MORTALIDAD_ALTA': '⚠️ Mortalidade alta: {lote}',
      'ALERT_MORTALIDAD_MSG': '{porcentaje}% ({cantidad} aves)',
      'ALERT_MORTALIDAD_REG': '🐔 Mortalidade registrada: {lote}',
      'ALERT_MORTALIDAD_REG_MSG':
          '{cantidad} aves • Causa: {causa} • Acumulada: {porcentaje}%',

      // Alertas service - lotes
      'ALERT_NUEVO_LOTE': '🐤 Novo lote: {lote}',
      'ALERT_NUEVO_LOTE_MSG': '{cantidad} aves em {galpon}',
      'ALERT_LOTE_FINALIZADO': '✅ Lote finalizado: {lote}',
      'ALERT_LOTE_FINALIZADO_MSG': 'Ciclo de {dias} dias',
      'ALERT_PESO_BAJO': '⚖️ Peso baixo: {lote}',
      'ALERT_PESO_BAJO_MSG': '{peso}g ({diferencia}% abaixo do objetivo)',
      'ALERT_CIERRE_PROXIMO': '📆 Encerramento próximo: {lote}',
      'ALERT_CIERRE_HOY': 'A data de encerramento é hoje!',
      'ALERT_CIERRE_EN_DIAS': 'Encerra em {dias} dias',
      'ALERT_CONVERSION_ANORMAL': '📊 Conversão anormal: {lote}',
      'ALERT_CONVERSION_MSG': '{actual} vs {esperado} esperado',
      'ALERT_SIN_REGISTROS': '⚠️ Sem registros: {lote}',
      'ALERT_SIN_REGISTROS_MSG': 'Último registro há {dias} dias',

      // Alertas service - producción
      'ALERT_PRODUCCION': '🥚 Produção: {lote}',
      'ALERT_PRODUCCION_MSG': '{cantidad} ovos ({porcentaje}%)',
      'ALERT_PRODUCCION_BAJA': '📉 Produção baixa: {lote}',
      'ALERT_PRODUCCION_BAJA_MSG': '{actual}% vs {esperado}% esperado',
      'ALERT_CAIDA_PRODUCCION': '🔻 Queda de produção: {lote}',
      'ALERT_CAIDA_MSG': 'Caiu {caida}% (de {anterior}% para {actual}%)',
      'ALERT_PRIMER_HUEVO': '🎉 Primeiro ovo! {lote}',
      'ALERT_PRIMER_HUEVO_MSG': 'Com {semanas} semanas de idade',
      'ALERT_RECORD': '🏆 Recorde! {lote}',
      'ALERT_RECORD_MSG': '{cantidad} ovos ({porcentaje}%)',
      'ALERT_META': '🎯 Meta alcançada: {lote}',
      'ALERT_META_MSG': '{total} ovos (meta: {meta})',

      // Alertas service - vacunaciones
      'ALERT_VAC_VENCIDA': '❌ Vacinação vencida',
      'ALERT_VAC_VENCIDA_MSG': '{vacuna} para {lote} não foi aplicada',
      'ALERT_VAC_HOY': '💉 Vacinação HOJE',
      'ALERT_VAC_MANANA': '💉 Vacinação AMANHÃ',
      'ALERT_VAC_EN_DIAS': '💉 Vacinação em {dias} dias',
      'ALERT_VAC_PARA_LOTE': '{vacuna} para {lote}',
      'ALERT_VAC_COMPLETADA': '✅ Vacinação concluída',
      'ALERT_VAC_COMPLETADA_MSG': '{vacuna} aplicada em {aves} aves de {lote}',

      // Alertas service - tratamientos
      'ALERT_TRATAMIENTO': '💊 Tratamento iniciado: {lote}',
      'ALERT_TRATAMIENTO_MSG': '{tratamiento} por {dias} dias',
      'ALERT_TRATAMIENTO_RETIRO': ' ({diasRetiro} dias de carência)',
      'ALERT_RETIRO_ACTIVO': '🚫 Carência ativa: {lote}',
      'ALERT_RETIRO_ACTIVO_MSG':
          '{medicamento} - {dias} dias restantes. NÃO comercializar ovos.',
      'ALERT_RETIRO_FIN': '✅ Carência finalizada: {lote}',
      'ALERT_RETIRO_FIN_MSG': 'Período de carência de {medicamento} concluído',

      // Alertas service - salud
      'ALERT_DIAGNOSTICO': '🏥 Diagnóstico: {lote}',
      'ALERT_DIAGNOSTICO_MSG': '{diagnostico} - Severidade: {severidad}',
      'ALERT_SINTOMAS_RESP': '🫁 Sintomas respiratórios: {lote}',
      'ALERT_SINTOMAS_RESP_MSG': '{sintomas} em {aves} aves',
      'ALERT_CONSUMO_AGUA': '💧 Consumo de água {tipo}: {lote}',
      'ALERT_CONSUMO_AGUA_MSG':
          '{actual}L vs {esperado}L esperado ({diferencia}% {tipo})',
      'ALERT_CONSUMO_ALIMENTO': '🌾 Consumo de alimento {tipo}: {lote}',
      'ALERT_CONSUMO_ALIMENTO_MSG':
          '{actual}kg vs {esperado}kg esperado ({diferencia}% {tipo})',
      'ALERT_TEMPERATURA': '🌡️ Temperatura {tipo}: {galpon}',
      'ALERT_TEMPERATURA_MSG': '{actual}°C (faixa: {min}-{max}°C)',
      'ALERT_HUMEDAD': '💧 Umidade {tipo}: {galpon}',
      'ALERT_HUMEDAD_MSG': '{actual}% (faixa: {min}-{max}%)',
      'ALERT_ENFERMEDAD': '🦠 Doença confirmada: {lote}',
      'ALERT_ENFERMEDAD_MSG': '{enfermedad} detectada em {aves} aves',

      // Alertas service - bioseguridad
      'ALERT_BIOSEG_APROBADA': '✅ Inspeção aprovada',
      'ALERT_BIOSEG_OBSERVACIONES': '⚠️ Inspeção com observações',
      'ALERT_BIOSEG_REPROBADA': '❌ Inspeção reprovada',
      'ALERT_BIOSEG_RESULTADO': '{tipo} - Pontuação: {puntaje}%',
      'ALERT_INSP_VENCIDA': '❌ Inspeção vencida',
      'ALERT_INSP_HOY': '📋 Inspeção HOJE',
      'ALERT_INSP_EN_DIAS': '📋 Inspeção em {dias} dias',
      'ALERT_BIOSEG_CRITICA': '🚨 Biossegurança CRÍTICA',
      'ALERT_BIOSEG_BAJA': '⚠️ Biossegurança baixa',
      'ALERT_INSP_COMPLETADA': '✅ Inspeção concluída',

      // Alertas service - necropsia
      'ALERT_NECROPSIA': '🔬 Necropsia: {lote}',
      'ALERT_NECROPSIA_MSG': 'Causa provável: {causa}',

      // Alertas service - comercial
      'ALERT_NUEVO_PEDIDO': '🛒 Novo pedido',
      'ALERT_NUEVO_PEDIDO_MSG': '{cliente} - {cantidad} ovos (\${monto})',
      'ALERT_PEDIDO_CONFIRMADO': '✅ Pedido confirmado',
      'ALERT_PEDIDO_CONFIRMADO_MSG': '{cliente} - Entrega: {fecha}',
      'ALERT_ENTREGA_HOY': '🚚 Entrega HOJE',
      'ALERT_ENTREGA_MANANA': '🚚 Entrega AMANHÃ',
      'ALERT_PEDIDO_ENTREGADO': '✅ Pedido entregue',
      'ALERT_PEDIDO_ENTREGADO_MSG': '{cliente} - \${monto}',
      'ALERT_PEDIDO_CANCELADO': '❌ Pedido cancelado',
      'ALERT_PEDIDO_CANCELADO_MSG': '{cliente} - {motivo}',
      'ALERT_PAGO_RECIBIDO': '💰 Pagamento recebido',
      'ALERT_PAGO_MSG': '{cliente} - \${monto} ({metodo})',
      'ALERT_VENTA_REG': '🛍️ Venda registrada',
      'ALERT_VENTA_REG_MSG': '{cliente} - {cantidad} ovos (\${monto})',

      // Alertas service - colaboradores
      'ALERT_INVITACION': '🎉 Convite para {granja}',
      'ALERT_INVITACION_MSG': '{invitadoPor} convidou você para colaborar',
      'ALERT_NUEVO_COLAB': '👤 Novo colaborador',
      'ALERT_NUEVO_COLAB_MSG': '{nombre} entrou como {rol}',
      'ALERT_INVITACION_RECHAZADA': '❌ Convite recusado',
      'ALERT_INVITACION_RECHAZADA_MSG': '{email} recusou o convite',
      'ALERT_ACCESO_REVOCADO': '👋 Acesso revogado',
      'ALERT_ACCESO_REVOCADO_MSG': 'Você não tem mais acesso a {granja}',
      'ALERT_COLAB_REMOVIDO': '👋 Colaborador removido',
      'ALERT_COLAB_REMOVIDO_MSG': '{nombre} foi removido de {granja}',
      'ALERT_CAMBIO_ROL': '🔄 Mudança de cargo',
      'ALERT_CAMBIO_ROL_MSG':
          'Seu cargo mudou de {rolAnterior} para {rolNuevo} em {granja}',

      // Alertas service - galpones
      'ALERT_NUEVO_GALPON': '🏠 Novo galpão: {galpon}',
      'ALERT_NUEVO_GALPON_MSG': 'Capacidade: {capacidad} aves',
      'ALERT_MANTENIMIENTO': '🔧 Manutenção: {galpon}',
      'ALERT_CAPACIDAD_MAX': '⚠️ Capacidade máxima: {galpon}',
      'ALERT_CAPACIDAD_MAX_MSG': '{actual}/{max} aves',
      'ALERT_EVENTO_GALPON': '📋 {tipo}: {galpon}',

      // Alertas service - costos
      'ALERT_GASTO': '💳 Gasto: {categoria}',
      'ALERT_GASTO_MSG': '\${monto} - {descripcion}',
      'ALERT_GASTO_INUSUAL': '⚠️ Gasto incomum: {categoria}',
      'ALERT_GASTO_INUSUAL_MSG': '\${monto} ({porcentaje}% acima da média)',
      'ALERT_PRESUPUESTO_SUPERADO': '🚨 Orçamento excedido: {categoria}',
      'ALERT_PRESUPUESTO_MSG':
          '\${gastoAcum}/\${presupuesto} (excesso: \${exceso})',

      // Alertas service - reportes y sistema
      'ALERT_RESUMEN_SEMANAL': '📊 Resumo semanal',
      'ALERT_RESUMEN_SEMANAL_MSG':
          'Receitas: \${ingresos} | Despesas: \${gastos} | {tipo}: \${utilidad}',
      'ALERT_UTILIDAD': 'Lucro',
      'ALERT_PERDIDA': 'Prejuízo',
      'ALERT_REPORTE_LISTO': '📄 Relatório pronto',
      'ALERT_REPORTE_LISTO_MSG': '{tipo} gerado com sucesso',
      'ALERT_RESUMEN_DIA': '📋 Resumo do dia',
      'ALERT_RESUMEN_DIA_MSG':
          '🥚 {huevos} | ⚰️ {mortalidad} | 🌾 {alimento}kg | ⚠️ {alertas} alertas',
      'ALERT_ALERTAS_PENDIENTES': '🔔 {cantidad} alertas pendentes',
      'ALERT_SYNC_OK': '☁️ Sincronização concluída',
      'ALERT_SYNC_MSG': '{registros} registros sincronizados',
      'ALERT_BIENVENIDO': '👋 Bem-vindo {nombre}!',
      'ALERT_BIENVENIDO_MSG':
          'Obrigado por usar o Smart Granja Aves Pro. Explore as funcionalidades disponíveis.',
      'NOTIF_FALLBACK_TITLE': 'Notificação',
      'NOTIF_CHANNEL_DESC': 'Notificações do Smart Granja Aves Pro',
      'ALERT_BAJO': 'baixo',
      'ALERT_ALTO': 'alto',
      'ALERT_BAJA': 'baixa',
      'ALERT_ALTA': 'alta',

      // Registro reciente cards
      'REG_CARD_PESO_DESC': '{aves} aves pesadas - GPD: {gdp}g/dia',
      'REG_CARD_CONSUMO_DESC': '{tipo} - {aves} aves',
      'REG_CARD_MORT_DESC': '{causa} - Impacto: {impacto}%',
      'REG_CARD_MORT_VALOR': '{cantidad} aves',
      'REG_CARD_PROD_DESC': 'Postura: {postura}% - Bons: {buenos}%',
      'REG_CARD_PROD_VALOR': '{cantidad} ovos',

      // CausaMortalidad display names (sin context)
      'CAUSA_MORT_ENFERMEDAD': 'Doença',
      'CAUSA_MORT_ACCIDENTE': 'Acidente',
      'CAUSA_MORT_DESNUTRICION': 'Desnutrição',
      'CAUSA_MORT_ESTRES': 'Estresse',
      'CAUSA_MORT_METABOLICA': 'Metabólica',
      'CAUSA_MORT_DEPREDACION': 'Predação',
      'CAUSA_MORT_SACRIFICIO': 'Sacrifício',
      'CAUSA_MORT_VEJEZ': 'Velhice',
      'CAUSA_MORT_DESCONOCIDA': 'Desconhecida',

      // Ventas datasource
      'ERR_GET_SALES': 'Erro ao obter vendas: {e}',
      'ERR_GET_SALE': 'Erro ao obter venda: {e}',
      'ERR_CREATE_SALE': 'Erro ao criar venda: {e}',
      'ERR_UPDATE_SALE': 'Erro ao atualizar venda: {e}',
      'ERR_DELETE_SALE': 'Erro ao excluir venda: {e}',
      'ERR_CREATE_SALE_PRODUCT': 'Erro ao registrar venda de produto: {e}',
      'ERR_GET_SALE_PRODUCT': 'Erro ao obter venda de produto: {e}',
      'ERR_GET_SALES_BY_BATCH': 'Erro ao obter vendas por lote: {e}',
      'ERR_GET_SALES_BY_FARM': 'Erro ao obter vendas por granja: {e}',
      'ERR_GET_ALL_SALES': 'Erro ao obter todas as vendas: {e}',
      'ERR_UPDATE_SALE_PRODUCT': 'Erro ao atualizar venda de produto: {e}',
      'ERR_DELETE_SALE_PRODUCT': 'Erro ao excluir venda de produto: {e}',

      // Calendario salud datasource
      'ERR_GET_HEALTH_EVENTS': 'Erro ao obter eventos de saúde: {e}',
      'ERR_GET_EVENTS_BY_DATE': 'Erro ao obter eventos por data: {e}',
      'ERR_GET_EVENTS_BY_BATCH': 'Erro ao obter eventos por lote: {e}',
      'ERR_GET_EVENTS_BY_TYPE': 'Erro ao obter eventos por tipo: {e}',
      'ERR_GET_PENDING_EVENTS': 'Erro ao obter eventos pendentes: {e}',
      'ERR_GET_OVERDUE_EVENTS': 'Erro ao obter eventos vencidos: {e}',
      'ERR_GET_UPCOMING_EVENTS': 'Erro ao obter próximos eventos: {e}',
      'ERR_UPDATE_HEALTH_EVENT': 'Erro ao atualizar evento: {e}',

      // Excepciones misceláneas
      'ERR_VACCINATION_NOT_FOUND_AFTER_UPDATE': 'Vacinação não encontrada após atualização',
      'ERR_RECORD_NOT_FOUND_AFTER_UPDATE': 'Registro não encontrado após atualização',
      'ERR_NECROPSY_NOT_FOUND': 'Necropsia não encontrada',
      'ERR_EVENT_NOT_FOUND': 'Evento não encontrado',
      'ERR_NO_ACTIVE_BATCH': 'Não há lote ativo',
      'LABEL_GALPON': 'Galpão',
      'ERR_NO_TREATMENT': 'Não há tratamento',
      'ERR_NO_EFFECTIVE_TREATMENT': 'Não há tratamento eficaz',

      // PDF - Metadatos
      'PDF_TITLE_PRODUCTION': 'Relatório de Produção - {code}',
      'PDF_TITLE_EXECUTIVE': 'Relatório Executivo - {farm}',
      'PDF_TITLE_COSTS': 'Relatório de Custos - {farm}',
      'PDF_TITLE_SALES': 'Relatório de Vendas - {farm}',
      'PDF_AUTHOR': 'Smart Granja Aves Pro',
      'PDF_SUBJECT_PRODUCTION': 'Relatório de produção de lote avícola',
      'PDF_SUBJECT_EXECUTIVE': 'Resumo executivo das operações avícolas',
      'PDF_SUBJECT_COSTS': 'Análise de custos operacionais',
      'PDF_SUBJECT_SALES': 'Análise de vendas e receitas',

      // PDF - Encabezados
      'PDF_HEADER_PRODUCTION': 'RELATÓRIO DE PRODUÇÃO',
      'PDF_HEADER_EXECUTIVE': 'RESUMO EXECUTIVO',
      'PDF_HEADER_COSTS': 'RELATÓRIO DE CUSTOS',
      'PDF_HEADER_SALES': 'RELATÓRIO DE VENDAS',
      'PDF_LOT_SUBTITLE': 'Lote: {code}',
      'PDF_APP_NAME': 'SMART GRANJA AVES',
      'PDF_PERIOD': 'PERÍODO',
      'PDF_DATE_TO': 'até {date}',

      // PDF - Pie de página
      'PDF_GENERATED_BY': 'Gerado: {datetime} por {user}',
      'PDF_PAGE': 'Página {current} de {total}',

      // PDF - Información del lote
      'PDF_LOT_INFO': 'INFORMAÇÕES DO LOTE',
      'PDF_LABEL_CODE': 'Código',
      'PDF_LABEL_BIRD_TYPE': 'Tipo de Ave',
      'PDF_LABEL_SHED': 'Galpão',
      'PDF_LABEL_ENTRY_DATE': 'Data de Entrada',
      'PDF_LABEL_CURRENT_AGE': 'Idade Atual',
      'PDF_LABEL_DAYS_IN_FARM': 'Dias na Granja',
      'PDF_DAYS_UNIT': '{count} dias',

      // PDF - Indicadores de producción
      'PDF_PRODUCTION_INDICATORS': 'INDICADORES DE PRODUÇÃO',
      'PDF_INITIAL_BIRDS': 'Aves Iniciais',
      'PDF_CURRENT_BIRDS': 'Aves Atuais',
      'PDF_MORTALITY': 'Mortalidade',
      'PDF_MORTALITY_BIRDS': '{count} aves',
      'PDF_AVG_WEIGHT': 'Peso Médio',
      'PDF_WEIGHT_KG': '{value} kg',
      'PDF_WEIGHT_OBJECTIVE': 'Obj: {value} kg',
      'PDF_TOTAL_CONSUMPTION': 'Consumo Total',
      'PDF_CONVERSION': 'Conversão',
      'PDF_CONVERSION_UNIT': 'kg ração / kg peso',

      // PDF - Resumen financiero
      'PDF_FINANCIAL_SUMMARY': 'RESUMO FINANCEIRO',
      'PDF_BIRD_COST': 'Custo das Aves',
      'PDF_FEED_COST': 'Custo de Ração',
      'PDF_TOTAL_COSTS': 'Custos Totais',
      'PDF_SALES_REVENUE': 'Receita de Vendas',
      'PDF_BALANCE': 'SALDO',

      // PDF - Análisis
      'PDF_HIGH_MORTALITY': '⚠ Mortalidade alta ({pct}%). Recomenda-se revisão das condições sanitárias.',
      'PDF_GOOD_SURVIVAL': '✓ Excelente índice de sobrevivência ({pct}%).',
      'PDF_HIGH_CONVERSION': '⚠ Conversão alimentar alta ({value}). Revisar qualidade da ração.',
      'PDF_GOOD_CONVERSION': '✓ Excelente conversão alimentar ({value}).',
      'PDF_WEIGHT_BELOW': '⚠ Peso abaixo do objetivo ({diff}g a menos).',
      'PDF_WEIGHT_ABOVE': '✓ Peso acima do objetivo (+{diff}g).',
      'PDF_NO_OBSERVATIONS': 'Sem observações relevantes para este período.',
      'PDF_ANALYSIS_TITLE': 'ANÁLISE E OBSERVAÇÕES',

      // PDF - Ejecutivo KPIs
      'PDF_KEY_INDICATORS': 'INDICADORES-CHAVE DE DESEMPENHO',
      'PDF_ACTIVE_LOTS': 'Lotes Ativos',
      'PDF_TOTAL_BIRDS': 'Total de Aves',
      'PDF_AVG_MORTALITY': 'Mortalidade Méd.',
      'PDF_AVG_CONVERSION': 'Conv. Média',

      // PDF - Tabla de lotes
      'PDF_ACTIVE_LOTS_SUMMARY': 'RESUMO DOS LOTES ATIVOS',
      'PDF_TABLE_LOT': 'Lote',
      'PDF_TABLE_TYPE': 'Tipo',
      'PDF_TABLE_BIRDS': 'Aves',
      'PDF_TABLE_MORTALITY_PCT': 'Mort.%',
      'PDF_TABLE_WEIGHT_KG': 'Peso kg',
      'PDF_TABLE_CONVERSION': 'Conv.',

      // PDF - Ejecutivo financiero
      'PDF_TOTAL_COSTS_LABEL': 'Custos Totais',
      'PDF_TOTAL_SALES_LABEL': 'Vendas Totais',
      'PDF_NET_PROFIT': 'Lucro Líquido',
      'PDF_PROFIT_MARGIN': 'Margem de Lucro',

      // PDF - Costos
      'PDF_COSTS_SUMMARY': 'RESUMO DE CUSTOS',
      'PDF_BY_CATEGORY': 'Por Categoria',
      'PDF_COSTS_DETAIL': 'DETALHES DOS CUSTOS',
      'PDF_TABLE_CATEGORY': 'Categoria',
      'PDF_TABLE_CONCEPT': 'Conceito',
      'PDF_TABLE_AMOUNT': 'Valor',
      'PDF_TABLE_DATE': 'Data',
      'PDF_TABLE_SUPPLIER': 'Fornecedor',

      // PDF - Ventas
      'PDF_SALES_SUMMARY': 'RESUMO DE VENDAS',
      'PDF_TOTAL_SALES_KPI': 'Total de Vendas',
      'PDF_BY_PRODUCT': 'Por Produto',
      'PDF_SALES_DETAIL': 'DETALHES DAS VENDAS',
      'PDF_TABLE_PRODUCT': 'Produto',
      'PDF_TABLE_QUANTITY': 'Quantidade',
      'PDF_TABLE_SUBTOTAL': 'Subtotal',
      'PDF_TABLE_CLIENT': 'Cliente',

      // Inventario
      'ERR_ITEM_NOT_FOUND': 'Item não encontrado',
      'ERR_INSUFFICIENT_STOCK':
          'Estoque insuficiente. Disponível: {stock} {unit}',

      // Galpón eventos
      'EVT_SHED_CREATED': 'Galpão criado: {name}',
      'EVT_BATCH_ASSIGNED': 'Lote {id} atribuído ao galpão',
      'EVT_SHED_RELEASED': 'Galpão liberado do lote {id}',
      'EVT_DISINFECTION_DONE': 'Desinfecção realizada',

      // Providers salud
      'ERR_VACCINATION_NOT_FOUND': 'Vacinação não encontrada',
      'ERR_RECORD_NOT_FOUND': 'Registro não encontrado',
      'EVT_VACCINATION_TITLE': 'Vacinação: {name}',
      'EVT_VACCINATION_DESC':
          'Aplicar {name} conforme programa de vacinação',
      'LABEL_SYSTEM': 'Sistema',

      // Alertas sanitarias
      'ALERT_HIGH_MORTALITY_TITLE': 'Mortalidade Elevada',
      'ALERT_HIGH_MORTALITY_DESC':
          'A mortalidade diária ({rate}%) supera o limite de {threshold}%',
      'ALERT_MORTALITY_INDICATOR': 'Mortalidade Diária',
      'ALERT_MORTALITY_REC':
          'Realizar necropsia imediata. Verificar água, alimento e condições ambientais.',
      'ALERT_ABNORMAL_TEMP_TITLE': 'Temperatura Anormal',
      'ALERT_ABNORMAL_TEMP_DESC':
          'A temperatura ({temp}°C) está fora da faixa ideal ({min}°C - {max}°C)',
      'ALERT_TEMP_INDICATOR': 'Temperatura',
      'ALERT_TEMP_REC':
          'Ajustar ventilação e aquecimento conforme necessário.',

      // Domain defaults
      'DEFAULT_NO_DESCRIPTION': 'Sem descrição disponível',
      'DEFAULT_MORTALITY_RECORD': 'Registro de mortalidade',
      'GRANJA_MAINTENANCE_NOTE':
          'Granja em manutenção em {date}',
      'GRANJA_MAINTENANCE_NOTE_REASON':
          'Granja em manutenção em {date} - Motivo: {reason}',

      // StateError / UnimplementedError
      'ERR_DOC_NO_DATA': 'Documento {id} não possui dados',
      'ERR_UNIMPLEMENTED_VACCINATION_INTEGRATION':
          'Integração com ProgramaVacinação pendente',
      'ERR_UNIMPLEMENTED_GRANJA_ID_REQUIRED':
          'É necessário granjaId para excluir',

      // Colaboradores
      'ERR_GENERIC_PREFIX': 'Erro: {e}',

      // Storage
      'STORAGE_READ_ERROR': 'Erro ao ler arquivo{path}',
      'STORAGE_WRITE_ERROR': 'Erro ao gravar arquivo{path}',
      'STORAGE_DELETE_ERROR': 'Erro ao excluir arquivo{path}',
      'STORAGE_NOT_FOUND': 'Arquivo não encontrado{path}',

      // Bioseguridad
      'ERR_NO_INSPECTION_IN_PROGRESS': 'Não há inspeção em andamento',
    },
  };
}
