#!/usr/bin/env python3
"""Fix Portuguese locale support in all Dart files with isEs / currentLocale binary patterns.

Transforms binary locale (es/en) to ternary (es/pt/en) using switch expressions.

Handles three patterns:
  Pattern A: final isEs = Formatters.currentLocale == 'es'; ... isEs ? 'ES' : 'EN'
  Pattern C: Formatters.currentLocale == 'es' ? 'ES' : 'EN' (inline)
  Pattern B: if (Formatters.currentLocale == 'es') return nombre; switch { case: return 'EN'; }
"""

import re
import os
import sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ============================================================
# COMPREHENSIVE SPANISH → PORTUGUESE TRANSLATION DICTIONARY
# ============================================================
ES_TO_PT = {
    # --- General ---
    'Activo': 'Ativo',
    'Inactivo': 'Inativo',
    'Pendiente': 'Pendente',
    'Otro': 'Outro',
    'Otros': 'Outros',
    'General': 'Geral',

    # --- estado_galpon / tipo_galpon / tipo_evento_galpon ---
    'Mantenimiento': 'Manutenção',
    'Desinfección': 'Desinfecção',
    'Cuarentena': 'Quarentena',
    'Engorde': 'Corte',
    'Postura': 'Postura',
    'Reproductora': 'Reprodutora',
    'Mixto': 'Misto',
    'Galpón operativo': 'Galpão operacional',
    'Galpón en reparación': 'Galpão em reparo',
    'Galpón sin uso': 'Galpão sem uso',
    'Galpón en proceso sanitario': 'Galpão em processo sanitário',
    'Galpón aislado por sanidad': 'Galpão isolado por sanidade',
    'Galpón para producción de carne': 'Galpão para produção de carne',
    'Galpón para producción de huevos': 'Galpão para produção de ovos',
    'Galpón para producción de huevos fértiles': 'Galpão para produção de ovos férteis',
    'Galpón multiuso para diferentes tipos de producción': 'Galpão multiuso para diferentes tipos de produção',
    'Cambio de Estado': 'Mudança de Estado',
    'Creación': 'Criação',
    'Lote Asignado': 'Lote Atribuído',
    'Lote Liberado': 'Lote Liberado',

    # --- galpon_notifiers ---
    'Creando galpón...': 'Criando galpão...',
    'Galpón creado exitosamente': 'Galpão criado com sucesso',
    'Actualizando galpón...': 'Atualizando galpão...',
    'Galpón actualizado exitosamente': 'Galpão atualizado com sucesso',
    'Eliminando galpón...': 'Excluindo galpão...',
    'Galpón eliminado exitosamente': 'Galpão excluído com sucesso',
    'Cambiando estado...': 'Alterando estado...',
    'Asignando lote...': 'Atribuindo lote...',
    'Lote asignado exitosamente': 'Lote atribuído com sucesso',
    'Liberando galpón...': 'Liberando galpão...',
    'Galpón liberado exitosamente': 'Galpão liberado com sucesso',
    'Programando mantenimiento...': 'Programando manutenção...',

    # --- granja_notifiers ---
    'Creando granja...': 'Criando granja...',
    'Granja creada exitosamente': 'Granja criada com sucesso',
    'Actualizando granja...': 'Atualizando granja...',
    'Granja actualizada exitosamente': 'Granja atualizada com sucesso',
    'Eliminando granja...': 'Excluindo granja...',
    'Granja eliminada exitosamente': 'Granja excluída com sucesso',
    'Activando granja...': 'Ativando granja...',
    'Granja activada exitosamente': 'Granja ativada com sucesso',
    'Suspendiendo granja...': 'Suspendendo granja...',
    'Granja suspendida': 'Granja suspensa',
    'Poniendo en mantenimiento...': 'Colocando em manutenção...',
    'Granja en mantenimiento': 'Granja em manutenção',
    'Buscando granjas...': 'Buscando granjas...',

    # --- estado_granja ---
    'Granja en operación': 'Granja em operação',
    'Granja sin operaciones': 'Granja sem operações',
    'Granja en reparación': 'Granja em reparo',

    # --- rol_granja_enum ---
    'Propietario': 'Proprietário',
    'Administrador': 'Administrador',
    'Gestor': 'Gestor',
    'Operario': 'Operário',
    'Visualizador': 'Visualizador',
    'Control total, puede eliminar la granja': 'Controle total, pode excluir a granja',
    'Control total excepto eliminar': 'Controle total exceto excluir',
    'Gestión de registros e invitaciones': 'Gestão de registros e convites',
    'Solo puede crear registros': 'Só pode criar registros',
    'Solo lectura': 'Somente leitura',

    # --- granja_detail_utils ---
    'No especificada': 'Não especificada',
    'aves': 'aves',
    'Ponedora': 'Poedeira',
    'Reproductor': 'Reprodutor',
    'Ave': 'Ave',
    'Activa': 'Ativa',
    'Inactiva': 'Inativa',
    'Operando normalmente': 'Operando normalmente',
    'Operaciones suspendidas': 'Operações suspensas',
    'En proceso de mantenimiento': 'Em processo de manutenção',

    # --- costo_gasto / tipo_gasto ---
    'Lote': 'Lote',
    'Casa': 'Galpão',
    'Administrativa': 'Administrativa',
    'Alimento': 'Ração',
    'Mano de Obra': 'Mão de Obra',
    'Energía': 'Energia',
    'Medicamento': 'Medicamento',
    'Agua': 'Água',
    'Transporte': 'Transporte',
    'Administrativo': 'Administrativo',
    'Depreciación': 'Depreciação',
    'Financiero': 'Financeiro',
    'Concentrados y granos': 'Concentrados e grãos',
    'Salarios y beneficios': 'Salários e benefícios',
    'Electricidad y combustible': 'Eletricidade e combustível',
    'Sanidad animal': 'Sanidade animal',
    'Reparaciones y limpieza': 'Reparos e limpeza',
    'Consumo de agua': 'Consumo de água',
    'Logística y movilización': 'Logística e transporte',
    'Gastos generales': 'Despesas gerais',
    'Desgaste de activos': 'Desgaste de ativos',
    'Intereses y comisiones': 'Juros e comissões',
    'Gastos varios': 'Despesas diversas',
    'Costo de Producción': 'Custo de Produção',
    'Gastos de Personal': 'Despesas de Pessoal',
    'Gastos Operativos': 'Despesas Operacionais',
    'Gastos de Distribución': 'Despesas de Distribuição',
    'Gastos Administrativos': 'Despesas Administrativas',
    'Depreciación y Amortización': 'Depreciação e Amortização',
    'Gastos Financieros': 'Despesas Financeiras',
    'Otros Gastos': 'Outras Despesas',

    # --- tipo_item ---
    'Vacuna': 'Vacina',
    'Equipo': 'Equipamento',
    'Insumo': 'Insumo',
    'Limpieza': 'Limpeza',
    'Concentrados, granos y suplementos': 'Concentrados, grãos e suplementos',
    'Fármacos y productos sanitarios': 'Fármacos e produtos sanitários',
    'Vacunas y biológicos': 'Vacinas e biológicos',
    'Herramientas y maquinaria': 'Ferramentas e maquinário',
    'Material de cama, empaques, etc.': 'Material de cama, embalagens, etc.',
    'Desinfectantes y productos de aseo': 'Desinfetantes e produtos de limpeza',
    'Items varios': 'Itens diversos',

    # --- tipo_movimiento ---
    'Compra': 'Compra',
    'Donación': 'Doação',
    'Devolución': 'Devolução',
    'Ajuste (+)': 'Ajuste (+)',
    'Consumo Lote': 'Consumo Lote',
    'Tratamiento': 'Tratamento',
    'Vacunación': 'Vacinação',
    'Merma': 'Perda',
    'Ajuste (-)': 'Ajuste (-)',
    'Transferencia': 'Transferência',
    'Uso General': 'Uso Geral',
    'Venta': 'Venda',
    'Ingreso por adquisición': 'Entrada por aquisição',
    'Ingreso por donación': 'Entrada por doação',
    'Ingreso por devolución de uso': 'Entrada por devolução de uso',
    'Ajuste de inventario positivo': 'Ajuste de inventário positivo',
    'Salida por alimentación de aves': 'Saída para alimentação de aves',
    'Salida por aplicación de medicamento': 'Saída para aplicação de medicamento',
    'Salida por aplicación de vacuna': 'Saída para aplicação de vacina',
    'Pérdida por deterioro o vencimiento': 'Perda por deterioração ou vencimento',
    'Ajuste de inventario negativo': 'Ajuste de inventário negativo',
    'Traslado a otra ubicación': 'Transferência para outra localização',
    'Salida por uso operativo': 'Saída para uso operacional',
    'Salida por venta de productos': 'Saída por venda de produtos',

    # --- unidad_medida ---
    'Kilogramo': 'Quilograma',
    'Gramo': 'Grama',
    'Libra': 'Libra',
    'Litro': 'Litro',
    'Mililitro': 'Mililitro',
    'Unidad': 'Unidade',
    'Docena': 'Dúzia',
    'Saco': 'Saco',
    'Bulto': 'Fardo',
    'Caja': 'Caixa',
    'Frasco': 'Frasco',
    'Dosis': 'Dose',
    'Ampolla': 'Ampola',
    'Peso': 'Peso',
    'Volumen': 'Volume',
    'Cantidad': 'Quantidade',
    'Empaque': 'Embalagem',
    'Aplicación': 'Aplicação',

    # --- lote_notifiers ---
    'Creando lote...': 'Criando lote...',
    'Lote creado exitosamente': 'Lote criado com sucesso',
    'Actualizando lote...': 'Atualizando lote...',
    'Lote actualizado exitosamente': 'Lote atualizado com sucesso',
    'Eliminando lote...': 'Excluindo lote...',
    'Lote eliminado exitosamente': 'Lote excluído com sucesso',
    'Registrando mortalidad...': 'Registrando mortalidade...',
    'Mortalidad registrada': 'Mortalidade registrada',
    'Registrando descarte...': 'Registrando descarte...',
    'Descarte registrado': 'Descarte registrado',
    'Registrando venta...': 'Registrando venda...',
    'Venta registrada': 'Venda registrada',
    'Actualizando peso...': 'Atualizando peso...',
    'Peso actualizado': 'Peso atualizado',

    # --- galpon_notifiers (with interpolation) ---
    'Estado cambiado a ${nuevoEstado.displayName}': 'Estado alterado para ${nuevoEstado.displayName}',

    # --- galpon_notifiers (missed) ---
    'Mantenimiento programado': 'Manutenção programada',
    'Registrando desinfección...': 'Registrando desinfecção...',
    'Desinfección registrada': 'Desinfecção registrada',

    # --- lote_notifiers (missed) ---
    'Cerrando lote...': 'Fechando lote...',
    'Lote cerrado exitosamente': 'Lote fechado com sucesso',
    'Registrando venta completa...': 'Registrando venda completa...',
    'Lote marcado como vendido': 'Lote marcado como vendido',
    'Transfiriendo lote...': 'Transferindo lote...',
    'Lote transferido exitosamente': 'Lote transferido com sucesso',

    # --- lote_validators (missed) ---
    'Seleccione el tipo de ave': 'Selecione o tipo de ave',
    'Seleccione la fecha de ingreso': 'Selecione a data de entrada',
    'El código es obligatorio': 'O código é obrigatório',
    'Mínimo 3 caracteres': 'Mínimo 3 caracteres',
    'Ingrese una cantidad válida': 'Insira uma quantidade válida',
    'Ya existe otro lote con el código "$codigo"': 'Já existe outro lote com o código "$codigo"',
    'a': 'a',

    # --- lote_validators (single-line strings only) ---
    'La cantidad inicial debe ser al menos 10 aves': 'A quantidade inicial deve ser de pelo menos 10 aves',
    'La cantidad inicial no puede exceder 100,000 aves': 'A quantidade inicial não pode exceder 100.000 aves',
    'La cantidad de mortalidad debe ser mayor a 0': 'A quantidade de mortalidade deve ser maior que 0',
    'El peso debe ser mayor a 0 gramos': 'O peso deve ser maior que 0 gramas',
    'El peso no puede exceder 20,000 gramos (20 kg)': 'O peso não pode exceder 20.000 gramas (20 kg)',
    'La cantidad de alimento debe ser mayor a 0': 'A quantidade de ração deve ser maior que 0',
    'La cantidad de alimento no puede exceder 10,000 kg': 'A quantidade de ração não pode exceder 10.000 kg',
    'Solo los lotes de ponedoras pueden producir huevos': 'Somente os lotes de poedeiras podem produzir ovos',
    'La cantidad de huevos debe ser mayor a 0': 'A quantidade de ovos deve ser maior que 0',
    'La fecha de ingreso no puede ser futura': 'A data de entrada não pode ser futura',
    'La fecha de ingreso parece muy antigua (más de 5 años)': 'A data de entrada parece muito antiga (mais de 5 anos)',
    'La fecha de cierre no puede ser anterior a la fecha de ingreso': 'A data de fechamento não pode ser anterior à data de entrada',
    'La fecha de cierre no puede ser futura': 'A data de fechamento não pode ser futura',

    # --- clasificacion_huevo ---
    'Pequeño': 'Pequeno',
    'Mediano': 'Médio',
    'Grande': 'Grande',
    'Extra Grande': 'Extra Grande',

    # --- estado_lote ---
    'Cerrado': 'Fechado',
    'Vendido': 'Vendido',
    'En Transferencia': 'Em Transferência',
    'Suspendido': 'Suspenso',
    'Lote en producción normal': 'Lote em produção normal',
    'Lote finalizado': 'Lote finalizado',
    'Lote aislado por motivos sanitarios': 'Lote isolado por motivos sanitários',
    'Lote vendido completamente': 'Lote vendido completamente',
    'Lote siendo transferido': 'Lote sendo transferido',
    'Lote temporalmente suspendido': 'Lote temporariamente suspenso',

    # --- tipo_ave (lotes + salud) ---
    'Pollo de Engorde': 'Frango de Corte',
    'Gallina Ponedora': 'Galinha Poedeira',
    'Reproductora Pesada': 'Reprodutora Pesada',
    'Reproductora Liviana': 'Reprodutora Leve',
    'Pavo': 'Peru',
    'Codorniz': 'Codorna',
    'Pato': 'Pato',
    'Rep. Pesada': 'Rep. Pesada',
    'Rep. Liviana': 'Rep. Leve',
    'Gallina Ponedora Comercial': 'Galinha Poedeira Comercial',
    'Pavo de Engorde': 'Peru de Corte',

    # --- prioridad_notificacion ---
    'Baja': 'Baixa',
    'Normal': 'Normal',
    'Alta': 'Alta',
    'Urgente': 'Urgente',

    # --- tipo_notificacion ---
    'Stock Bajo': 'Estoque Baixo',
    'Agotado': 'Esgotado',
    'Próximo a Vencer': 'Próximo ao Vencimento',
    'Vencido': 'Vencido',
    'Reabastecido': 'Reabastecido',
    'Movimiento': 'Movimentação',
    'Mortalidad Registrada': 'Mortalidade Registrada',
    'Mortalidad Alta': 'Mortalidade Alta',
    'Mortalidad Crítica': 'Mortalidade Crítica',
    'Nuevo Lote': 'Novo Lote',
    'Lote Finalizado': 'Lote Finalizado',
    'Peso Bajo': 'Peso Baixo',
    'Cierre Próximo': 'Fechamento Próximo',
    'Conversión Anormal': 'Conversão Anormal',
    'Sin Registros': 'Sem Registros',
    'Producción': 'Produção',
    'Producción Baja': 'Produção Baixa',
    'Caída Producción': 'Queda na Produção',
    'Primer Huevo': 'Primeiro Ovo',
    'Récord': 'Recorde',
    'Meta Alcanzada': 'Meta Alcançada',
    'Vacunación Mañana': 'Vacinação Amanhã',
    'Vacunación Hoy': 'Vacinação Hoje',
    'Vacunación Vencida': 'Vacinação Vencida',
    'Vacunación Aplicada': 'Vacinação Aplicada',
    'Retiro Activo': 'Retirada Ativa',
    'Fin Retiro': 'Fim Retirada',
    'Fin Tratamiento': 'Fim Tratamento',
    'Diagnóstico': 'Diagnóstico',
    'Síntomas Respiratorios': 'Sintomas Respiratórios',
    'Consumo Agua': 'Consumo Água',
    'Consumo Alimento': 'Consumo Ração',
    'Temperatura': 'Temperatura',
    'Humedad': 'Umidade',
    'Enfermedad': 'Doença',
    'Inspección Pendiente': 'Inspeção Pendente',
    'Inspección Hoy': 'Inspeção Hoje',
    'Inspección Vencida': 'Inspeção Vencida',
    'Bioseguridad Crítica': 'Biossegurança Crítica',
    'Bioseguridad Baja': 'Biossegurança Baixa',
    'Inspección OK': 'Inspeção OK',
    'Necropsia': 'Necropsia',
    'Nuevo Pedido': 'Novo Pedido',
    'Pedido Confirmado': 'Pedido Confirmado',
    'Entrega Mañana': 'Entrega Amanhã',
    'Entrega Hoy': 'Entrega Hoje',
    'Entregado': 'Entregue',
    'Cancelado': 'Cancelado',
    'Pago': 'Pagamento',
    'Invitación': 'Convite',
    'Colaborador Nuevo': 'Novo Colaborador',
    'Invitación Rechazada': 'Convite Recusado',
    'Invitación Expirada': 'Convite Expirado',
    'Colaborador Removido': 'Colaborador Removido',
    'Cambio de Rol': 'Mudança de Função',
    'Nuevo Galpón': 'Novo Galpão',
    'Capacidad Máxima': 'Capacidade Máxima',
    'Evento Galpón': 'Evento Galpão',
    'Gasto': 'Despesa',
    'Gasto Inusual': 'Despesa Incomum',
    'Presupuesto': 'Orçamento',
    'Resumen': 'Resumo',
    'Reporte': 'Relatório',
    'Resumen Diario': 'Resumo Diário',
    'Alertas': 'Alertas',
    'Sincronizado': 'Sincronizado',
    'Actualización': 'Atualização',
    'Bienvenida': 'Boas-vindas',

    # --- periodo_reporte ---
    'Última semana': 'Última semana',
    'Último mes': 'Último mês',
    'Último trimestre': 'Último trimestre',
    'Último semestre': 'Último semestre',
    'Último año': 'Último ano',
    'Personalizado': 'Personalizado',

    # --- tipo_reporte ---
    'Producción de Lote': 'Produção de Lote',
    'Mortalidad': 'Mortalidade',
    'Consumo de Alimento': 'Consumo de Ração',
    'Peso y Crecimiento': 'Peso e Crescimento',
    'Costos': 'Custos',
    'Ventas': 'Vendas',
    'Rentabilidad': 'Rentabilidade',
    'Salud': 'Saúde',
    'Inventario': 'Inventário',
    'Resumen Ejecutivo': 'Resumo Executivo',
    'Resumen completo del rendimiento productivo': 'Resumo completo do desempenho produtivo',
    'Análisis detallado de mortalidad y causas': 'Análise detalhada de mortalidade e causas',
    'Análisis de consumo y conversión alimenticia': 'Análise de consumo e conversão alimentar',
    'Evolución de peso y curvas de crecimiento': 'Evolução de peso e curvas de crescimento',
    'Desglose de gastos y costos operativos': 'Detalhamento de despesas e custos operacionais',
    'Resumen de ventas e ingresos': 'Resumo de vendas e receitas',
    'Análisis de utilidad y márgenes': 'Análise de utilidade e margens',
    'Historial de tratamientos y vacunaciones': 'Histórico de tratamentos e vacinações',
    'Estado actual del inventario': 'Estado atual do inventário',
    'Vista consolidada de indicadores clave': 'Visão consolidada de indicadores-chave',
    'PDF': 'PDF',
    'Vista previa': 'Pré-visualização',

    # --- estado_pedido ---
    'Confirmado': 'Confirmado',
    'En Preparación': 'Em Preparação',
    'Listo Despacho': 'Pronto Despacho',
    'En Tránsito': 'Em Trânsito',
    'Devuelto': 'Devolvido',
    'Parcial': 'Parcial',
    'Pedido en espera de confirmación': 'Pedido aguardando confirmação',
    'Pedido aprobado': 'Pedido aprovado',
    'Pedido siendo preparado': 'Pedido sendo preparado',
    'Preparado para envío': 'Preparado para envio',
    'Pedido en camino': 'Pedido a caminho',
    'Pedido completado': 'Pedido completado',
    'Pedido anulado': 'Pedido anulado',
    'Pedido retornado': 'Pedido devolvido',
    'Entrega incompleta': 'Entrega incompleta',

    # --- estado_venta ---
    'Confirmada': 'Confirmada',
    'Lista para Despacho': 'Pronta para Despacho',
    'Entregada': 'Entregue',
    'Facturada': 'Faturada',
    'Cancelada': 'Cancelada',
    'Devuelta': 'Devolvida',
    'Esperando confirmación': 'Aguardando confirmação',
    'Confirmada por el cliente': 'Confirmada pelo cliente',
    'Preparando producto': 'Preparando produto',
    'Lista para entregar': 'Pronta para entrega',
    'En camino al cliente': 'A caminho do cliente',
    'Entregada exitosamente': 'Entregue com sucesso',
    'Factura generada': 'Fatura gerada',
    'Devuelta por el cliente': 'Devolvida pelo cliente',

    # --- tipo_producto_venta ---
    'Aves Vivas': 'Aves Vivas',
    'Huevos': 'Ovos',
    'Pollinaza/Gallinaza': 'Cama de Aviário',
    'Aves Faenadas': 'Aves Abatidas',
    'Aves de Descarte': 'Aves de Descarte',
    'Venta de aves en pie': 'Venda de aves vivas',
    'Venta de huevos por clasificación': 'Venda de ovos por classificação',
    'Subproducto orgánico': 'Subproduto orgânico',
    'Aves procesadas para consumo': 'Aves processadas para consumo',
    'Aves al final del ciclo productivo': 'Aves ao final do ciclo produtivo',

    # --- unidad_venta_pollinaza ---
    'Tonelada': 'Tonelada',
    'Bulto de 50 kg': 'Fardo de 50 kg',
    'Tonelada métrica': 'Tonelada métrica',
}

# ============================================================
# ENGLISH → PORTUGUESE DICT (for Pattern B files)
# ============================================================
EN_TO_PT = {
    # --- CategoriaEnfermedad ---
    'Viral': 'Viral',
    'Bacterial': 'Bacteriana',
    'Parasitic': 'Parasitária',
    'Fungal': 'Fúngica',
    'Nutritional': 'Nutricional',
    'Metabolic': 'Metabólica',
    'Environmental': 'Ambiental',
    'Diseases caused by viruses': 'Doenças causadas por vírus',
    'Diseases caused by bacteria': 'Doenças causadas por bactérias',
    'Diseases caused by parasites': 'Doenças causadas por parasitas',
    'Diseases caused by fungi': 'Doenças causadas por fungos',
    'Nutritional deficiencies': 'Deficiências nutricionais',
    'Metabolic disorders': 'Distúrbios metabólicos',
    'Caused by environmental factors': 'Causadas por fatores ambientais',

    # --- GravedadEnfermedad ---
    'Mild': 'Leve',
    'Moderate': 'Moderada',
    'Severe': 'Grave',
    'Critical': 'Crítica',
    'Low production impact': 'Baixo impacto na produção',
    'Medium production impact': 'Impacto médio na produção',
    'High impact, requires immediate action': 'Alto impacto, requer ação imediata',
    'Health emergency': 'Emergência sanitária',

    # --- EnfermedadAvicola ---
    'Newcastle Disease': 'Doença de Newcastle',
    'Gumboro Disease (IBD)': 'Doença de Gumboro (DIB)',
    "Marek's Disease": 'Doença de Marek',
    'Infectious Bronchitis (IB)': 'Bronquite Infecciosa (BI)',
    'Avian Influenza (HPAI/LPAI)': 'Influenza Aviária (IAAP/IABP)',
    'Infectious Laryngotracheitis (ILT)': 'Laringotraqueíte Infecciosa (LTI)',
    'Fowl Pox': 'Varíola Aviária',
    'Chicken Infectious Anemia (CAV)': 'Anemia Infecciosa das Galinhas (CAV)',
    'Colibacillosis (E. coli)': 'Colibacilose (E. coli)',
    'Salmonellosis': 'Salmonelose',
    'Mycoplasmosis (MG/MS)': 'Micoplasmose (MG/MS)',
    'Fowl Cholera': 'Cólera Aviária',
    'Infectious Coryza': 'Coriza Infecciosa',
    'Clostridium Enteritis': 'Enterite por Clostridium',
    'Coccidiosis': 'Coccidiose',
    'Ascaridiasis': 'Ascaridíase',
    'Aspergillosis': 'Aspergilose',
    'Ascites (Ascitic Syndrome)': 'Ascite (Síndrome Ascítica)',
    'Sudden Death Syndrome': 'Síndrome de Morte Súbita',
    'Vitamin E/Se Deficiency': 'Deficiência de Vitamina E/Se',
    'Rickets (Vit D/Ca/P Deficiency)': 'Raquitismo (Def. Vit D/Ca/P)',

    # --- CategoriaAntimicrobiano ---
    'Critically Important': 'Criticamente Importante',
    'Highly Important': 'Altamente Importante',
    'Important': 'Importante',
    'Unclassified': 'Não Classificado',

    # --- FamiliaAntimicrobiano ---
    'Fluoroquinolones': 'Fluoroquinolonas',
    '3rd/4th Gen Cephalosporins': 'Cefalosporinas 3ª/4ª geração',
    'Macrolides': 'Macrolídeos',
    'Polymyxins (Colistin)': 'Polimixinas (Colistina)',
    'Aminoglycosides': 'Aminoglicosídeos',
    'Penicillins': 'Penicilinas',
    'Tetracyclines': 'Tetraciclinas',
    'Sulfonamides': 'Sulfonamidas',
    'Lincosamides': 'Lincosamidas',
    'Pleuromutilins': 'Pleuromutilinas',
    'Bacitracin': 'Bacitracina',
    'Ionophores': 'Ionóforos',

    # --- MotivoUsoAntimicrobiano ---
    'Treatment': 'Tratamento',
    'Metaphylaxis': 'Metafilaxia',
    'Prophylaxis': 'Profilaxia',
    'Growth Promoter': 'Promotor de Crescimento',
    'Treatment of diagnosed disease': 'Tratamento de doença diagnosticada',
    'Preventive treatment of at-risk group': 'Tratamento preventivo de grupo em risco',
    'Prevention in healthy animals': 'Prevenção em animais saudáveis',
    'Prohibited use in many countries': 'Uso proibido em muitos países',

    # --- EstadoBioseguridad ---
    'Pending': 'Pendente',
    'Compliant': 'Conforme',
    'Non-Compliant': 'Não Conforme',
    'Partial': 'Parcial',
    'N/A': 'N/A',

    # --- CategoriaBioseguridad ---
    'Personnel Access': 'Acesso de Pessoal',
    'Vehicle Access': 'Acesso de Veículos',
    'Cleaning and Disinfection': 'Limpeza e Desinfecção',
    'Pest Control': 'Controle de Pragas',
    'Bird Management': 'Manejo de Aves',
    'Mortality Management': 'Manejo de Mortalidade',
    'Water Quality': 'Qualidade da Água',
    'Feed Management': 'Manejo de Ração',
    'Facilities': 'Instalações',
    'Records': 'Registros',
    'Entry and clothing control': 'Controle de acesso e vestimenta',
    'Vehicle and equipment control': 'Controle de veículos e equipamentos',
    'Hygiene protocols': 'Protocolos de higiene',
    'Rodents, insects, wild birds': 'Roedores, insetos, aves silvestres',
    'Bird handling practices': 'Práticas com as aves',
    'Disposal of dead birds': 'Disposição de aves mortas',
    'Potability and chlorination': 'Potabilidade e cloração',
    'Storage and quality': 'Armazenamento e qualidade',
    'Housing and equipment condition': 'Estado de galpões e equipamentos',
    'Documentation and traceability': 'Documentação e rastreabilidade',

    # --- FrecuenciaInspeccion ---
    'Daily': 'Diária',
    'Weekly': 'Semanal',
    'Biweekly': 'Quinzenal',
    'Monthly': 'Mensal',
    'Quarterly': 'Trimestral',
    'Per Batch': 'Por Lote',

    # --- ViaAdministracion ---
    'Oral': 'Oral',
    'In Water': 'Na Água',
    'In Feed': 'Na Ração',
    'Ocular': 'Ocular',
    'Nasal': 'Nasal',
    'Spray': 'Spray',
    'SC Injection': 'Injeção SC',
    'IM Injection': 'Injeção IM',
    'Wing Web': 'Na Asa',
    'In-Ovo': 'In-Ovo',
    'Topical': 'Tópica',
    'Oral administration': 'Administração por via oral',
    'Dissolved in drinking water': 'Dissolvida na água de bebida',
    'Mixed in feed': 'Misturado na ração',
    'Eye drop': 'Gota no olho',
    'Nasal spray or drop': 'Spray ou gota nasal',
    'Spraying over birds': 'Aspersão sobre as aves',
    'Subcutaneous in neck': 'Subcutânea no pescoço',
    'Intramuscular in breast': 'Intramuscular no peito',
    'Puncture in wing membrane': 'Punção na membrana da asa',
    'Injection in egg': 'Injeção no ovo',
    'External skin application': 'Aplicação externa na pele',

    # --- tipo_ave salud (Pattern B) ---
    'Broiler': 'Frango de Corte',
    'Layer': 'Galinha Poedeira Comercial',
    'Turkey': 'Peru de Corte',

    # --- EstadoEventoSalud (calendario_salud) ---
    'Scheduled': 'Programado',
    'In Progress': 'Em Andamento',
    'Completed': 'Concluído',
    'Cancelled': 'Cancelado',
    'Overdue': 'Vencido',
    'Planned event': 'Evento planejado',
    'Upcoming': 'Próximo',
    'Being executed': 'Sendo executado',
    'Successfully done': 'Concluído com sucesso',
    'Event cancelled': 'Evento cancelado',
    'Not done on time': 'Não realizado a tempo',

    # --- PrioridadEvento (calendario_salud) ---
    'Low': 'Baixa',
    'High': 'Alta',
    'Urgent': 'Urgente',
    'Can be postponed': 'Pode ser adiado',
    'Follow schedule': 'Seguir o cronograma',
    'Priority': 'Prioritário',
    'Immediate action': 'Ação imediata',

    # --- NivelRiesgoBioseguridad (inspeccion_bioseguridad) ---
    'Medium': 'Médio',
    'Optimal compliance': 'Conformidade ótima',
    'Needs improvement': 'Precisa melhorar',
    'Significant risk': 'Risco significativo',
    'Immediate action required': 'Ação imediata necessária',
}

# ============================================================
# FILES LIST
# ============================================================
ALL_FILES = [
    'lib/features/costos/domain/entities/costo_gasto.dart',
    'lib/features/costos/domain/enums/tipo_gasto.dart',
    'lib/features/galpones/application/providers/galpon_notifiers.dart',
    'lib/features/galpones/domain/enums/estado_galpon.dart',
    'lib/features/galpones/domain/enums/tipo_evento_galpon.dart',
    'lib/features/galpones/domain/enums/tipo_galpon.dart',
    'lib/features/granjas/application/providers/granja_notifiers.dart',
    'lib/features/granjas/domain/enums/estado_granja.dart',
    'lib/features/granjas/domain/enums/rol_granja_enum.dart',
    'lib/features/granjas/presentation/widgets/granja_detail/granja_detail_utils.dart',
    'lib/features/inventario/domain/enums/tipo_item.dart',
    'lib/features/inventario/domain/enums/tipo_movimiento.dart',
    'lib/features/inventario/domain/enums/unidad_medida.dart',
    'lib/features/lotes/application/providers/lote_notifiers.dart',
    'lib/features/lotes/application/validators/lote_validators.dart',
    'lib/features/lotes/domain/enums/clasificacion_huevo.dart',
    'lib/features/lotes/domain/enums/estado_lote.dart',
    'lib/features/lotes/domain/enums/tipo_ave.dart',
    'lib/features/notificaciones/domain/enums/prioridad_notificacion.dart',
    'lib/features/notificaciones/domain/enums/tipo_notificacion.dart',
    'lib/features/reportes/domain/enums/formato_reporte.dart',
    'lib/features/reportes/domain/enums/periodo_reporte.dart',
    'lib/features/reportes/domain/enums/tipo_reporte.dart',
    'lib/features/salud/domain/entities/calendario_salud.dart',
    'lib/features/salud/domain/entities/inspeccion_bioseguridad.dart',
    'lib/features/salud/domain/enums/antimicrobiano_enums.dart',
    'lib/features/salud/domain/enums/bioseguridad_enums.dart',
    'lib/features/salud/domain/enums/enfermedad_avicola.dart',
    'lib/features/salud/domain/enums/tipo_ave.dart',
    'lib/features/salud/domain/enums/via_administracion.dart',
    'lib/features/ventas/domain/enums/clasificacion_huevo.dart',
    'lib/features/ventas/domain/enums/estado_pedido.dart',
    'lib/features/ventas/domain/enums/estado_venta.dart',
    'lib/features/ventas/domain/enums/tipo_producto_venta.dart',
    'lib/features/ventas/domain/enums/unidad_venta_pollinaza.dart',
]

# Pattern B files (if-return + old-style switch)
PATTERN_B_FILES = {
    'lib/features/salud/domain/enums/enfermedad_avicola.dart',
    'lib/features/salud/domain/enums/antimicrobiano_enums.dart',
    'lib/features/salud/domain/enums/bioseguridad_enums.dart',
    'lib/features/salud/domain/enums/via_administracion.dart',
    'lib/features/salud/domain/enums/tipo_ave.dart',
    'lib/features/salud/domain/entities/calendario_salud.dart',
    'lib/features/salud/domain/entities/inspeccion_bioseguridad.dart',
}

missing_translations = []
stats = {'files': 0, 'pattern_a': 0, 'pattern_c': 0, 'pattern_b': 0}


def get_pt_es(es_text):
    """Get PT translation from ES text."""
    pt = ES_TO_PT.get(es_text)
    if pt is None:
        missing_translations.append(('ES', es_text))
        return es_text
    return pt


def get_pt_en(en_text):
    """Get PT translation from EN text."""
    pt = EN_TO_PT.get(en_text)
    if pt is None:
        missing_translations.append(('EN', en_text))
        return en_text
    return pt


def escape_for_single_quote(s):
    """Escape single quotes for Dart single-quoted strings."""
    return s.replace("'", r"\'")


def process_file(filepath):
    """Process a single Dart file."""
    full_path = os.path.join(BASE, filepath)
    if not os.path.exists(full_path):
        print(f"  SKIP (not found): {filepath}")
        return False

    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content

    rel = filepath.replace('\\', '/')
    is_pattern_b = rel in PATTERN_B_FILES

    # ---- STEP 1: Pattern A - Replace isEs variable declaration ----
    count_a = content.count("final isEs = Formatters.currentLocale == 'es';")
    if count_a > 0:
        content = content.replace(
            "final isEs = Formatters.currentLocale == 'es';",
            "final locale = Formatters.currentLocale;"
        )
        stats['pattern_a'] += count_a

    # ---- STEP 2: Pattern A - Replace isEs ternaries (single-quoted) ----
    def repl_isEs_single(m):
        es = m.group(1)
        en = m.group(2)
        pt = get_pt_es(es)
        pt_escaped = escape_for_single_quote(pt)
        es_escaped = escape_for_single_quote(es)
        en_escaped = escape_for_single_quote(en)
        return f"switch (locale) {{ 'es' => '{es_escaped}', 'pt' => '{pt_escaped}', _ => '{en_escaped}' }}"

    content = re.sub(
        r"isEs\s*\?\s*'([^']*)'\s*:\s*'([^']*)'",
        repl_isEs_single,
        content
    )

    # ---- STEP 3: Pattern C - Replace inline Formatters ternaries (single-quoted) ----
    def repl_inline_single(m):
        es = m.group(1)
        en = m.group(2)
        pt = get_pt_es(es)
        pt_escaped = escape_for_single_quote(pt)
        es_escaped = escape_for_single_quote(es)
        en_escaped = escape_for_single_quote(en)
        stats['pattern_c'] += 1
        return f"switch (Formatters.currentLocale) {{ 'es' => '{es_escaped}', 'pt' => '{pt_escaped}', _ => '{en_escaped}' }}"

    content = re.sub(
        r"Formatters\.currentLocale\s*==\s*'es'\s*\?\s*'([^']*)'\s*:\s*'([^']*)'",
        repl_inline_single,
        content
    )

    # ---- STEP 4: Pattern B - if-return + switch ----
    if is_pattern_b:
        # Replace: if (Formatters.currentLocale == 'es') return FIELD;
        # With:    final locale = Formatters.currentLocale;\n    if (locale == 'es') return FIELD;
        pattern_b_if = re.compile(
            r"if \(Formatters\.currentLocale == 'es'\) return (\w+);",
        )
        matches_b = pattern_b_if.findall(content)
        if matches_b:
            content = pattern_b_if.sub(
                r"final locale = Formatters.currentLocale;\n    if (locale == 'es') return \1;",
                content
            )
            stats['pattern_b'] += len(matches_b)

        # In switch cases after if(locale == 'es'), add PT ternary to each return
        # Pattern: return 'English text'; or return "English text";
        def repl_case_return_single(m):
            en = m.group(1)
            pt = get_pt_en(en)
            if pt == en:
                return m.group(0)  # no change needed
            pt_escaped = escape_for_single_quote(pt)
            return f"return locale == 'pt' ? '{pt_escaped}' : '{en}';"

        def repl_case_return_double(m):
            en = m.group(1)
            pt = get_pt_en(en)
            if pt == en:
                return m.group(0)
            pt_escaped = escape_for_single_quote(pt)
            return f'return locale == \'pt\' ? \'{pt_escaped}\' : "{en}";'

        # Only apply to single-quoted returns in switch cases (statement form)
        content = re.sub(
            r"return '([^']+)';",
            repl_case_return_single,
            content
        )
        # Double-quoted returns (e.g. "Marek's Disease")
        content = re.sub(
            r'return "([^"]+)";',
            repl_case_return_double,
            content
        )

        # Also handle expression-style switch: Enum.value => 'English',
        # Only transform strings that are in EN_TO_PT to avoid false positives
        def repl_switch_expr_single(m):
            prefix = m.group(1)  # "=> " or "=> \n  "
            en = m.group(2)
            pt = EN_TO_PT.get(en)
            if pt is None or pt == en:
                return m.group(0)
            pt_escaped = escape_for_single_quote(pt)
            return f"{prefix}locale == 'pt' ? '{pt_escaped}' : '{en}'"

        content = re.sub(
            r"(=>\s*)'([^']+)'",
            repl_switch_expr_single,
            content
        )

    if content != original:
        with open(full_path, 'w', encoding='utf-8') as f:
            f.write(content)
        stats['files'] += 1
        return True
    return False


def main():
    print("=" * 60)
    print("Fixing Portuguese locale in Dart enum/entity files")
    print("=" * 60)

    for filepath in ALL_FILES:
        rel = filepath.replace('\\', '/')
        changed = process_file(filepath)
        status = "CHANGED" if changed else "no change"
        print(f"  [{status}] {rel}")

    print()
    print("=" * 60)
    print(f"Files changed: {stats['files']}")
    print(f"Pattern A replacements (isEs variable): {stats['pattern_a']}")
    print(f"Pattern C replacements (inline Formatters): {stats['pattern_c']}")
    print(f"Pattern B replacements (if-return): {stats['pattern_b']}")

    if missing_translations:
        print()
        print(f"⚠ MISSING TRANSLATIONS ({len(missing_translations)}):")
        seen = set()
        for source, text in missing_translations:
            key = (source, text)
            if key not in seen:
                seen.add(key)
                print(f"  [{source}] '{text}'")
    else:
        print("\n✓ All translations found!")

    print("=" * 60)


if __name__ == '__main__':
    main()
