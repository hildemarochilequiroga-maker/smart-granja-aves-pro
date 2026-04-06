#!/usr/bin/env python3
"""Add Portuguese 'pt' map to error_messages.dart"""

import re

PT_MAP = """    'pt': {
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
          'Gerado automaticamente a partir do Inventário. Item: {item}, Quantidade: {cantidad} {unidad}, Preço unitário: \\${precio}',
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
      'ALERT_NUEVO_PEDIDO_MSG': '{cliente} - {cantidad} ovos (\\${monto})',
      'ALERT_PEDIDO_CONFIRMADO': '✅ Pedido confirmado',
      'ALERT_PEDIDO_CONFIRMADO_MSG': '{cliente} - Entrega: {fecha}',
      'ALERT_ENTREGA_HOY': '🚚 Entrega HOJE',
      'ALERT_ENTREGA_MANANA': '🚚 Entrega AMANHÃ',
      'ALERT_PEDIDO_ENTREGADO': '✅ Pedido entregue',
      'ALERT_PEDIDO_ENTREGADO_MSG': '{cliente} - \\${monto}',
      'ALERT_PEDIDO_CANCELADO': '❌ Pedido cancelado',
      'ALERT_PEDIDO_CANCELADO_MSG': '{cliente} - {motivo}',
      'ALERT_PAGO_RECIBIDO': '💰 Pagamento recebido',
      'ALERT_PAGO_MSG': '{cliente} - \\${monto} ({metodo})',
      'ALERT_VENTA_REG': '🛍️ Venda registrada',
      'ALERT_VENTA_REG_MSG': '{cliente} - {cantidad} ovos (\\${monto})',

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
      'ALERT_GASTO_MSG': '\\${monto} - {descripcion}',
      'ALERT_GASTO_INUSUAL': '⚠️ Gasto incomum: {categoria}',
      'ALERT_GASTO_INUSUAL_MSG': '\\${monto} ({porcentaje}% acima da média)',
      'ALERT_PRESUPUESTO_SUPERADO': '🚨 Orçamento excedido: {categoria}',
      'ALERT_PRESUPUESTO_MSG':
          '\\${gastoAcum}/\\${presupuesto} (excesso: \\${exceso})',

      // Alertas service - reportes y sistema
      'ALERT_RESUMEN_SEMANAL': '📊 Resumo semanal',
      'ALERT_RESUMEN_SEMANAL_MSG':
          'Receitas: \\${ingresos} | Despesas: \\${gastos} | {tipo}: \\${utilidad}',
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
    },"""

FILE_PATH = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\core\errors\error_messages.dart'

with open(FILE_PATH, 'r', encoding='utf-8') as f:
    content = f.read()

# Find the closing of the 'en' map and insert before `  };`
# The file ends with:
#     },
#   };
# }
# We need to insert after the 'en' map's `    },` and before `  };`

# Find the last occurrence of "    }," which closes the 'en' map
marker = "'ERR_NO_INSPECTION_IN_PROGRESS': 'No inspection in progress',\n    },"
if marker not in content:
    print("ERROR: Could not find insertion marker")
    exit(1)

new_content = content.replace(
    marker,
    marker + "\n" + PT_MAP
)

with open(FILE_PATH, 'w', encoding='utf-8') as f:
    f.write(new_content)

# Count PT keys
pt_keys = new_content.count("'pt': {")
print(f"PT map added successfully")
# Count entries
import re
pt_section = new_content.split("'pt': {")[1].split("    },")[0]
entries = len(re.findall(r"'[A-Z_]+(?:_[A-Z0-9_]+)*':", pt_section))
print(f"PT entries: {entries}")
