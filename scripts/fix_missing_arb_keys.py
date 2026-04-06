import json

keys = [
    # Bioseguridad (5)
    ('bioStepGalpon', 'Galpón', 'Shed'),
    ('bioStepGalponHint', 'Selecciona el galpón a inspeccionar', 'Select the shed to inspect'),
    ('bioStepNoGalpones', 'No hay galpones registrados en esta granja', 'No sheds registered in this farm'),
    ('bioStepSelectLocationHint', 'Selecciona la ubicación para la inspección de bioseguridad', 'Select the location for the biosecurity inspection'),
    ('bioTitle', 'Bioseguridad', 'Biosecurity'),

    # Inventario (16)
    ('invCodeOptional', 'Código / SKU (opcional)', 'Code / SKU (optional)'),
    ('invCurrentStock', 'Stock actual', 'Current stock'),
    ('invDescHerramienta', 'Herramientas, bebederos, comederos y equipos', 'Tools, drinkers, feeders and equipment'),
    ('invDescribeItem', 'Describe brevemente el item', 'Briefly describe the item'),
    ('invInternalCode', 'Código interno o SKU', 'Internal code or SKU'),
    ('invItemNameRequired', 'Nombre del item *', 'Item name *'),
    ('invLocationWarehouse', 'Ubicación / Almacén', 'Location / Warehouse'),
    ('invMaximumStock', 'Stock máximo', 'Maximum stock'),
    ('invMinimumStock', 'Stock mínimo', 'Minimum stock'),
    ('invNameRequired', 'El nombre debe tener al menos 2 caracteres', 'Name must be at least 2 characters'),
    ('invStepStockTitle', 'Stock y Unidades', 'Stock and Units'),
    ('invStockAlertDescription', 'Configura el stock mínimo para recibir alertas cuando el inventario esté bajo.', 'Set the minimum stock to receive alerts when inventory is low.'),
    ('invSupplierBatchNumber', 'Número de lote del proveedor', 'Supplier batch number'),
    ('invSupplierNameLabel', 'Nombre del proveedor', 'Supplier name'),
    ('invWarehouseExample', 'Ej: Bodega principal, Galpón 1', 'E.g.: Main warehouse, Shed 1'),

    # Ventas (34)
    ('ventaAverageWeight', 'Peso promedio', 'Average weight'),
    ('ventaBirdQuantity', 'Cantidad de aves', 'Bird quantity'),
    ('ventaCarcassYield', 'Rendimiento canal', 'Carcass yield'),
    ('ventaClient', 'Cliente', 'Client'),
    ('ventaClientDocument', 'Número de documento *', 'Document number *'),
    ('ventaClientDocumentInvalid', 'Documento inválido', 'Invalid document'),
    ('ventaClientDocumentRequired', 'Ingresa el número de documento', 'Enter the document number'),
    ('ventaDeletedSuccess', 'Venta eliminada correctamente', 'Sale deleted successfully'),
    ('ventaDocument', 'Documento', 'Document'),
    ('ventaEditTooltip', 'Editar venta', 'Edit sale'),
    ('ventaNewSaleTitle', 'Nueva Venta', 'New Sale'),
    ('ventaNotFound', 'Venta no encontrada', 'Sale not found'),
    ('ventaPhone', 'Teléfono', 'Phone'),
    ('ventaProductDescAbono', 'Abono orgánico derivado de la producción avícola', 'Organic fertilizer derived from poultry production'),
    ('ventaProductDescAvesEnPie', 'Venta de aves vivas en pie por kilogramo', 'Sale of live birds by kilogram'),
    ('ventaProductDescAvesFaenadas', 'Aves procesadas y listas para consumo', 'Processed birds ready for consumption'),
    ('ventaProductDescHuevos', 'Venta de huevos por clasificación y docena', 'Sale of eggs by classification and dozen'),
    ('ventaProductDescOtro', 'Aves de descarte u otros productos avícolas', 'Cull birds or other poultry products'),
    ('ventaProductDetails', 'Detalles del producto', 'Product details'),
    ('ventaQuantity', 'Cantidad', 'Quantity'),
    ('ventaReceiptTitle', 'COMPROBANTE DE VENTA', 'SALE RECEIPT'),
    ('ventasFilterTitle', 'Filtrar ventas', 'Filter sales'),
    ('ventaShare', 'Compartir', 'Share'),
    ('ventaSlaughterWeight', 'Peso faenado', 'Slaughter weight'),
    ('ventasProductType', 'Tipo de producto', 'Product type'),
    ('ventaStepClientTitle', 'Datos del Cliente', 'Client Information'),
    ('ventaStepNoFarms', 'No hay granjas disponibles', 'No farms available'),
    ('ventaStepProductQuestion', '¿Qué tipo de producto vendes?', 'What type of product are you selling?'),
    ('ventaStepSelectLocation', 'Selecciona Granja y Lote', 'Select Farm and Batch'),
    ('ventaStepSelectLocationDesc', 'Elige la granja y el lote asociado a esta venta', 'Choose the farm and batch associated with this sale'),
    ('ventaStepSummary', 'Resumen', 'Summary'),
    ('ventaSubtotal', 'Subtotal', 'Subtotal'),
    ('ventaTotalLabel', 'Total', 'Total'),
    ('ventaUnitPrice', 'Precio unitario', 'Unit price'),
]

for arb_path, lang_idx in [
    (r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n\app_es.arb', 1),
    (r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n\app_en.arb', 2),
]:
    with open(arb_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    added = 0
    skipped = 0
    for tup in keys:
        key = tup[0]
        val = tup[lang_idx]
        if key not in data:
            data[key] = val
            # Add metadata for parametrized keys
            if '{' in val:
                params = {}
                import re
                for m in re.finditer(r'\{(\w+)\}', val):
                    params[m.group(1)] = {'type': 'String'}
                data[f'@{key}'] = {'placeholders': params}
            else:
                data[f'@{key}'] = {}
            added += 1
        else:
            skipped += 1

    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write('\n')

    lang = 'ES' if lang_idx == 1 else 'EN'
    print(f'{lang}: Added {added}, Skipped {skipped}')

print('Done!')
