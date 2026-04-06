#!/usr/bin/env python3
"""Add all remaining i18n ARB keys for all features."""
import json
import os

BASE = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n'

def load_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_arb(path, data):
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write('\n')

# All new keys: (key, es_value, en_value)
NEW_KEYS = [
    # ===== LOTES DOMAIN ENUMS =====
    # TipoAve displayName
    ("birdTypeBroiler", "Pollo de Engorde", "Broiler"),
    ("birdTypeLayer", "Gallina Ponedora", "Layer Hen"),
    ("birdTypeHeavyBreeder", "Reproductora Pesada", "Heavy Breeder"),
    ("birdTypeLightBreeder", "Reproductora Liviana", "Light Breeder"),
    ("birdTypeTurkey", "Pavo", "Turkey"),
    ("birdTypeQuail", "Codorniz", "Quail"),
    ("birdTypeDuck", "Pato", "Duck"),
    ("birdTypeOther", "Otro", "Other"),
    # TipoAve nombreCorto
    ("birdTypeShortBroiler", "Engorde", "Broiler"),
    ("birdTypeShortLayer", "Ponedora", "Layer"),
    ("birdTypeShortHeavyBreeder", "Rep. Pesada", "Heavy Br."),
    ("birdTypeShortLightBreeder", "Rep. Liviana", "Light Br."),
    ("birdTypeShortTurkey", "Pavo", "Turkey"),
    ("birdTypeShortQuail", "Codorniz", "Quail"),
    ("birdTypeShortDuck", "Pato", "Duck"),
    ("birdTypeShortOther", "Otro", "Other"),

    # EstadoLote displayName
    ("batchStatusActive", "Activo", "Active"),
    ("batchStatusClosed", "Cerrado", "Closed"),
    ("batchStatusQuarantine", "Cuarentena", "Quarantine"),
    ("batchStatusSold", "Vendido", "Sold"),
    ("batchStatusInTransfer", "En Transferencia", "In Transfer"),
    ("batchStatusSuspended", "Suspendido", "Suspended"),
    # EstadoLote descripcion
    ("batchStatusDescActive", "Lote en producción normal", "Batch in normal production"),
    ("batchStatusDescClosed", "Lote finalizado", "Batch finalized"),
    ("batchStatusDescQuarantine", "Lote aislado por motivos sanitarios", "Batch isolated for sanitary reasons"),
    ("batchStatusDescSold", "Lote vendido completamente", "Batch completely sold"),
    ("batchStatusDescInTransfer", "Lote siendo transferido", "Batch being transferred"),
    ("batchStatusDescSuspended", "Lote temporalmente suspendido", "Batch temporarily suspended"),

    # MetodoPesaje displayName
    ("weighMethodManual", "Manual", "Manual"),
    ("weighMethodIndividualScale", "Báscula Individual", "Individual Scale"),
    ("weighMethodBatchScale", "Báscula de Lote", "Batch Scale"),
    ("weighMethodAutomatic", "Automática", "Automatic"),
    # MetodoPesaje descripcion
    ("weighMethodDescManual", "Manual con báscula", "Manual with scale"),
    ("weighMethodDescIndividualScale", "Báscula individual", "Individual scale"),
    ("weighMethodDescBatchScale", "Báscula de lote", "Batch scale"),
    ("weighMethodDescAutomatic", "Sistema automático", "Automatic system"),
    # MetodoPesaje descripcionDetallada
    ("weighMethodDetailManual", "Pesaje ave por ave con báscula portátil", "Weighing bird by bird with portable scale"),
    ("weighMethodDetailIndividualScale", "Báscula electrónica para una ave", "Electronic scale for one bird"),
    ("weighMethodDetailBatchScale", "Pesaje grupal dividido entre cantidad", "Group weighing divided by quantity"),
    ("weighMethodDetailAutomatic", "Sistema automatizado integrado", "Integrated automated system"),

    # TipoAlimento displayName
    ("feedTypePreStarter", "Pre-iniciador", "Pre-starter"),
    ("feedTypeStarter", "Iniciador", "Starter"),
    ("feedTypeGrower", "Crecimiento", "Grower"),
    ("feedTypeFinisher", "Finalizador", "Finisher"),
    ("feedTypeLayer", "Postura", "Layer"),
    ("feedTypeRearing", "Levante", "Rearing"),
    ("feedTypeMedicated", "Medicado", "Medicated"),
    ("feedTypeConcentrate", "Concentrado", "Concentrate"),
    ("feedTypeOther", "Otro", "Other"),
    # TipoAlimento descripcion
    ("feedTypeDescPreStarter", "Pre-iniciador (0-7 días)", "Pre-starter (0-7 days)"),
    ("feedTypeDescStarter", "Iniciador (8-21 días)", "Starter (8-21 days)"),
    ("feedTypeDescGrower", "Crecimiento (22-35 días)", "Grower (22-35 days)"),
    ("feedTypeDescFinisher", "Finalizador (36+ días)", "Finisher (36+ days)"),
    ("feedTypeDescLayer", "Postura", "Layer"),
    ("feedTypeDescRearing", "Levante", "Rearing"),
    ("feedTypeDescMedicated", "Medicado", "Medicated"),
    ("feedTypeDescConcentrate", "Concentrado", "Concentrate"),
    ("feedTypeDescOther", "Otro", "Other"),
    # TipoAlimento rangoEdadDescripcion
    ("feedAgeRangePreStarter", "0-7 días", "0-7 days"),
    ("feedAgeRangeStarter", "8-21 días", "8-21 days"),
    ("feedAgeRangeGrower", "22-35 días", "22-35 days"),
    ("feedAgeRangeFinisher", "36+ días", "36+ days"),
    ("feedAgeRangeLayer", "Gallinas ponedoras", "Layer hens"),
    ("feedAgeRangeRearing", "Pollitas reemplazo", "Replacement pullets"),
    ("feedAgeRangeMedicated", "Con tratamiento", "Under treatment"),
    ("feedAgeRangeConcentrate", "Suplemento", "Supplement"),
    ("feedAgeRangeOther", "Uso general", "General use"),

    # ClasificacionHuevo
    ("eggClassSmall", "Pequeño", "Small"),
    ("eggClassMedium", "Mediano", "Medium"),
    ("eggClassLarge", "Grande", "Large"),
    ("eggClassExtraLarge", "Extra Grande", "Extra Large"),

    # ===== LOTES APPLICATION =====
    # LoteValidators
    ("validateBatchQuantityMin", "La cantidad inicial debe ser al menos 10 aves", "Initial quantity must be at least 10 birds"),
    ("validateBatchQuantityMax", "La cantidad inicial no puede exceder 100,000 aves", "Initial quantity cannot exceed 100,000 birds"),
    ("validateMortalityMin", "La cantidad de mortalidad debe ser mayor a 0", "Mortality count must be greater than 0"),
    ("validateMortalityExceedsCurrent", "La cantidad de mortalidad ({mortality}) no puede exceder la cantidad actual ({current})", "Mortality count ({mortality}) cannot exceed current count ({current})"),
    ("validateWeightMin", "El peso debe ser mayor a 0 gramos", "Weight must be greater than 0 grams"),
    ("validateWeightMax", "El peso no puede exceder 20,000 gramos (20 kg)", "Weight cannot exceed 20,000 grams (20 kg)"),
    ("validateFeedMin", "La cantidad de alimento debe ser mayor a 0", "Feed amount must be greater than 0"),
    ("validateFeedMax", "La cantidad de alimento no puede exceder 10,000 kg", "Feed amount cannot exceed 10,000 kg"),
    ("validateEggLayerOnly", "Solo los lotes de ponedoras pueden producir huevos", "Only layer batches can produce eggs"),
    ("validateEggMin", "La cantidad de huevos debe ser mayor a 0", "Egg count must be greater than 0"),
    ("validateEggRateHigh", "La tasa de postura del {rate}% parece muy alta. Verifique los datos.", "The laying rate of {rate}% seems very high. Please verify the data."),
    ("validateDateFuture", "La fecha de ingreso no puede ser futura", "Entry date cannot be in the future"),
    ("validateDateTooOld", "La fecha de ingreso parece muy antigua (más de 5 años)", "Entry date seems too old (more than 5 years)"),
    ("validateCloseDateBeforeEntry", "La fecha de cierre no puede ser anterior a la fecha de ingreso", "Close date cannot be before the entry date"),
    ("validateCloseDateFuture", "La fecha de cierre no puede ser futura", "Close date cannot be in the future"),
    ("validateCodeExists", "Ya existe otro lote con el código \"{code}\"", "Another batch with code \"{code}\" already exists"),

    # LoteNotifier loading messages
    ("batchCreating", "Creando lote...", "Creating batch..."),
    ("batchUpdating", "Actualizando lote...", "Updating batch..."),
    ("batchDeleting", "Eliminando lote...", "Deleting batch..."),
    ("batchRecordingMortality", "Registrando mortalidad...", "Recording mortality..."),
    ("batchRecordingDiscard", "Registrando descarte...", "Recording discard..."),
    ("batchRecordingSale", "Registrando venta...", "Recording sale..."),
    ("batchUpdatingWeight", "Actualizando peso...", "Updating weight..."),
    ("batchChangingStatus", "Cambiando estado...", "Changing status..."),
    ("batchClosing", "Cerrando lote...", "Closing batch..."),
    ("batchMarkingSold", "Registrando venta completa...", "Recording full sale..."),
    ("batchTransferring", "Transfiriendo lote...", "Transferring batch..."),
    # LoteNotifier success messages
    ("batchCreatedSuccess", "Lote creado exitosamente", "Batch created successfully"),
    ("batchUpdatedSuccess", "Lote actualizado exitosamente", "Batch updated successfully"),
    ("batchDeletedSuccess", "Lote eliminado exitosamente", "Batch deleted successfully"),
    ("batchMortalityRecorded", "Mortalidad registrada", "Mortality recorded"),
    ("batchDiscardRecorded", "Descarte registrado", "Discard recorded"),
    ("batchSaleRecorded", "Venta registrada", "Sale recorded"),
    ("batchWeightUpdated", "Peso actualizado", "Weight updated"),
    ("batchClosedSuccess", "Lote cerrado exitosamente", "Batch closed successfully"),
    ("batchMarkedSold", "Lote marcado como vendido", "Batch marked as sold"),
    ("batchTransferredSuccess", "Lote transferido exitosamente", "Batch transferred successfully"),
    # LoteFormNotifier validation
    ("validateSelectBirdType", "Seleccione el tipo de ave", "Select bird type"),
    ("validateSelectEntryDate", "Seleccione la fecha de ingreso", "Select entry date"),
    ("validateCodeRequired", "El código es obligatorio", "Code is required"),
    ("validateCodeMinLength", "Mínimo 3 caracteres", "Minimum 3 characters"),
    ("validateQuantityValid", "Ingrese una cantidad válida", "Enter a valid quantity"),

    # ===== VENTAS ENUMS =====
    # TipoProductoVenta
    ("saleProductLiveBirds", "Aves Vivas", "Live Birds"),
    ("saleProductLiveBirdsDesc", "Venta de aves en pie", "Live bird sales"),
    ("saleProductEggs", "Huevos", "Eggs"),
    ("saleProductEggsDesc", "Venta de huevos por clasificación", "Egg sales by classification"),
    ("saleProductManure", "Pollinaza/Gallinaza", "Poultry Manure"),
    ("saleProductManureDesc", "Subproducto orgánico", "Organic by-product"),
    ("saleProductProcessedBirds", "Aves Faenadas", "Processed Birds"),
    ("saleProductProcessedBirdsDesc", "Aves procesadas para consumo", "Birds processed for consumption"),
    ("saleProductCullBirds", "Aves de Descarte", "Cull Birds"),
    ("saleProductCullBirdsDesc", "Aves al final del ciclo productivo", "Birds at end of production cycle"),

    # EstadoVenta
    ("saleStatusPending", "Pendiente", "Pending"),
    ("saleStatusPendingDesc", "Esperando confirmación", "Awaiting confirmation"),
    ("saleStatusConfirmed", "Confirmada", "Confirmed"),
    ("saleStatusConfirmedDesc", "Confirmada por el cliente", "Confirmed by client"),
    ("saleStatusInPreparation", "En Preparación", "In Preparation"),
    ("saleStatusInPreparationDesc", "Preparando producto", "Preparing product"),
    ("saleStatusReadyToShip", "Lista para Despacho", "Ready to Ship"),
    ("saleStatusReadyToShipDesc", "Lista para entregar", "Ready for delivery"),
    ("saleStatusInTransit", "En Tránsito", "In Transit"),
    ("saleStatusInTransitDesc", "En camino al cliente", "On the way to client"),
    ("saleStatusDelivered", "Entregada", "Delivered"),
    ("saleStatusDeliveredDesc", "Entregada exitosamente", "Delivered successfully"),
    ("saleStatusInvoiced", "Facturada", "Invoiced"),
    ("saleStatusInvoicedDesc", "Factura generada", "Invoice generated"),
    ("saleStatusCancelled", "Cancelada", "Cancelled"),
    ("saleStatusCancelledDesc", "Cancelada", "Cancelled"),
    ("saleStatusReturned", "Devuelta", "Returned"),
    ("saleStatusReturnedDesc", "Devuelta por el cliente", "Returned by client"),

    # EstadoPedido
    ("orderStatusPending", "Pendiente", "Pending"),
    ("orderStatusPendingDesc", "Pedido en espera de confirmación", "Order awaiting confirmation"),
    ("orderStatusConfirmed", "Confirmado", "Confirmed"),
    ("orderStatusConfirmedDesc", "Pedido aprobado", "Order approved"),
    ("orderStatusInPreparation", "En Preparación", "In Preparation"),
    ("orderStatusInPreparationDesc", "Pedido siendo preparado", "Order being prepared"),
    ("orderStatusReadyToShip", "Listo Despacho", "Ready to Ship"),
    ("orderStatusReadyToShipDesc", "Preparado para envío", "Ready for shipping"),
    ("orderStatusInTransit", "En Tránsito", "In Transit"),
    ("orderStatusInTransitDesc", "Pedido en camino", "Order on the way"),
    ("orderStatusDelivered", "Entregado", "Delivered"),
    ("orderStatusDeliveredDesc", "Pedido completado", "Order completed"),
    ("orderStatusCancelled", "Cancelado", "Cancelled"),
    ("orderStatusCancelledDesc", "Pedido anulado", "Order voided"),
    ("orderStatusReturned", "Devuelto", "Returned"),
    ("orderStatusReturnedDesc", "Pedido retornado", "Order returned"),
    ("orderStatusPartial", "Parcial", "Partial"),
    ("orderStatusPartialDesc", "Entrega incompleta", "Incomplete delivery"),

    # UnidadVentaPollinaza
    ("saleUnitBag", "Bulto", "Bag"),
    ("saleUnitBagDesc", "Bulto de 50 kg", "50 kg bag"),
    ("saleUnitTon", "Tonelada", "Ton"),
    ("saleUnitTonDesc", "Tonelada métrica", "Metric ton"),
    ("saleUnitKg", "Kilogramo", "Kilogram"),
    ("saleUnitKgDesc", "Kilogramo", "Kilogram"),

    # ClassificacionHuevo ventas
    ("saleEggClassExtraLarge", "Extra Grande", "Extra Large"),
    ("saleEggClassLarge", "Grande", "Large"),
    ("saleEggClassMedium", "Mediano", "Medium"),
    ("saleEggClassSmall", "Pequeño", "Small"),

    # ===== COSTOS ENUMS =====
    # TipoGasto
    ("costTypeFeed", "Alimento", "Feed"),
    ("costTypeFeedDesc", "Concentrados y granos", "Concentrates and grains"),
    ("costTypeLabor", "Mano de Obra", "Labor"),
    ("costTypeLaborDesc", "Salarios y beneficios", "Salaries and benefits"),
    ("costTypeEnergy", "Energía", "Energy"),
    ("costTypeEnergyDesc", "Electricidad y combustible", "Electricity and fuel"),
    ("costTypeMedicine", "Medicamento", "Medicine"),
    ("costTypeMedicineDesc", "Sanidad animal", "Animal health"),
    ("costTypeMaintenance", "Mantenimiento", "Maintenance"),
    ("costTypeMaintenanceDesc", "Reparaciones y limpieza", "Repairs and cleaning"),
    ("costTypeWater", "Agua", "Water"),
    ("costTypeWaterDesc", "Consumo de agua", "Water consumption"),
    ("costTypeTransport", "Transporte", "Transport"),
    ("costTypeTransportDesc", "Logística y movilización", "Logistics and mobilization"),
    ("costTypeAdmin", "Administrativo", "Administrative"),
    ("costTypeAdminDesc", "Gastos generales", "General expenses"),
    ("costTypeDepreciation", "Depreciación", "Depreciation"),
    ("costTypeDepreciationDesc", "Desgaste de activos", "Asset depreciation"),
    ("costTypeFinancial", "Financiero", "Financial"),
    ("costTypeFinancialDesc", "Intereses y comisiones", "Interest and fees"),
    ("costTypeOther", "Otros", "Other"),
    ("costTypeOtherDesc", "Gastos varios", "Miscellaneous expenses"),
    # TipoGasto categoriaEstadoResultados
    ("costCategoryProduction", "Costo de Producción", "Production Cost"),
    ("costCategoryPersonnel", "Gastos de Personal", "Personnel Expenses"),
    ("costCategoryOperating", "Gastos Operativos", "Operating Expenses"),
    ("costCategoryDistribution", "Gastos de Distribución", "Distribution Expenses"),
    ("costCategoryAdmin", "Gastos Administrativos", "Administrative Expenses"),
    ("costCategoryDepreciation", "Depreciación y Amortización", "Depreciation and Amortization"),
    ("costCategoryFinancial", "Gastos Financieros", "Financial Expenses"),
    ("costCategoryOther", "Otros Gastos", "Other Expenses"),
    # CostoGasto validation
    ("costValidateConceptEmpty", "El concepto no puede estar vacío", "Concept cannot be empty"),
    ("costValidateAmountPositive", "El monto debe ser mayor a 0", "Amount must be greater than 0"),
    ("costValidateBirdCountPositive", "Cantidad de aves debe ser mayor a 0", "Bird count must be greater than 0"),
    ("costValidateApprovalNotRequired", "Este gasto no requiere aprobación", "This expense does not require approval"),
    ("costValidateAlreadyApproved", "Este gasto ya está aprobado", "This expense is already approved"),
    ("costValidateRejectionReasonRequired", "Debe proporcionar un motivo de rechazo", "Must provide a rejection reason"),
    # CostoGasto centroCostoEfectivo
    ("costCenterBatch", "Lote", "Batch"),
    ("costCenterHouse", "Casa", "House"),
    ("costCenterAdmin", "Administrativa", "Administrative"),

    # ===== INVENTARIO ENUMS =====
    # TipoItem
    ("invItemTypeFeed", "Alimento", "Feed"),
    ("invItemTypeFeedDesc", "Concentrados, granos y suplementos", "Concentrates, grains and supplements"),
    ("invItemTypeMedicine", "Medicamento", "Medicine"),
    ("invItemTypeMedicineDesc", "Fármacos y productos sanitarios", "Drugs and sanitary products"),
    ("invItemTypeVaccine", "Vacuna", "Vaccine"),
    ("invItemTypeVaccineDesc", "Vacunas y biológicos", "Vaccines and biologics"),
    ("invItemTypeEquipment", "Equipo", "Equipment"),
    ("invItemTypeEquipmentDesc", "Herramientas y maquinaria", "Tools and machinery"),
    ("invItemTypeSupply", "Insumo", "Supply"),
    ("invItemTypeSupplyDesc", "Material de cama, empaques, etc.", "Bedding material, packaging, etc."),
    ("invItemTypeCleaning", "Limpieza", "Cleaning"),
    ("invItemTypeCleaningDesc", "Desinfectantes y productos de aseo", "Disinfectants and cleaning products"),
    ("invItemTypeOther", "Otro", "Other"),
    ("invItemTypeOtherDesc", "Items varios", "Miscellaneous items"),

    # TipoMovimiento
    ("invMovePurchase", "Compra", "Purchase"),
    ("invMovePurchaseDesc", "Ingreso por adquisición", "Entry by acquisition"),
    ("invMoveDonation", "Donación", "Donation"),
    ("invMoveDonationDesc", "Ingreso por donación", "Entry by donation"),
    ("invMoveReturn", "Devolución", "Return"),
    ("invMoveReturnDesc", "Ingreso por devolución de uso", "Entry by return of use"),
    ("invMoveAdjustUp", "Ajuste (+)", "Adjustment (+)"),
    ("invMoveAdjustUpDesc", "Ajuste de inventario positivo", "Positive inventory adjustment"),
    ("invMoveBatchConsumption", "Consumo Lote", "Batch Consumption"),
    ("invMoveBatchConsumptionDesc", "Salida por alimentación de aves", "Output for bird feeding"),
    ("invMoveTreatment", "Tratamiento", "Treatment"),
    ("invMoveTreatmentDesc", "Salida por aplicación de medicamento", "Output for medicine application"),
    ("invMoveVaccination", "Vacunación", "Vaccination"),
    ("invMoveVaccinationDesc", "Salida por aplicación de vacuna", "Output for vaccine application"),
    ("invMoveShrinkage", "Merma", "Shrinkage"),
    ("invMoveShrinkageDesc", "Pérdida por deterioro o vencimiento", "Loss due to deterioration or expiration"),
    ("invMoveAdjustDown", "Ajuste (-)", "Adjustment (-)"),
    ("invMoveAdjustDownDesc", "Ajuste de inventario negativo", "Negative inventory adjustment"),
    ("invMoveTransfer", "Transferencia", "Transfer"),
    ("invMoveTransferDesc", "Traslado a otra ubicación", "Transfer to another location"),
    ("invMoveGeneralUse", "Uso General", "General Use"),
    ("invMoveGeneralUseDesc", "Salida por uso operativo", "Output for operational use"),
    ("invMoveSale", "Venta", "Sale"),
    ("invMoveSaleDesc", "Salida por venta de productos", "Output for product sales"),

    # UnidadMedida
    ("invUnitKilogram", "Kilogramo", "Kilogram"),
    ("invUnitGram", "Gramo", "Gram"),
    ("invUnitPound", "Libra", "Pound"),
    ("invUnitLiter", "Litro", "Liter"),
    ("invUnitMilliliter", "Mililitro", "Milliliter"),
    ("invUnitUnit", "Unidad", "Unit"),
    ("invUnitDozen", "Docena", "Dozen"),
    ("invUnitSack", "Saco", "Sack"),
    ("invUnitBag", "Bulto", "Bag"),
    ("invUnitBox", "Caja", "Box"),
    ("invUnitVial", "Frasco", "Vial"),
    ("invUnitDose", "Dosis", "Dose"),
    ("invUnitAmpoule", "Ampolla", "Ampoule"),
    # UnidadMedida categorias
    ("invUnitCategoryWeight", "Peso", "Weight"),
    ("invUnitCategoryVolume", "Volumen", "Volume"),
    ("invUnitCategoryQuantity", "Cantidad", "Quantity"),
    ("invUnitCategoryPackaging", "Empaque", "Packaging"),
    ("invUnitCategoryApplication", "Aplicación", "Application"),

    # ===== SALUD ENUMS =====
    # CategoriaEnfermedad
    ("healthDiseaseCatViral", "Viral", "Viral"),
    ("healthDiseaseCatViralDesc", "Enfermedades causadas por virus", "Diseases caused by viruses"),
    ("healthDiseaseCatBacterial", "Bacteriana", "Bacterial"),
    ("healthDiseaseCatBacterialDesc", "Enfermedades causadas por bacterias", "Diseases caused by bacteria"),
    ("healthDiseaseCatParasitic", "Parasitaria", "Parasitic"),
    ("healthDiseaseCatParasiticDesc", "Enfermedades causadas por parásitos", "Diseases caused by parasites"),
    ("healthDiseaseCatFungal", "Fúngica", "Fungal"),
    ("healthDiseaseCatFungalDesc", "Enfermedades causadas por hongos", "Diseases caused by fungi"),
    ("healthDiseaseCatNutritional", "Nutricional", "Nutritional"),
    ("healthDiseaseCatNutritionalDesc", "Deficiencias nutricionales", "Nutritional deficiencies"),
    ("healthDiseaseCatMetabolic", "Metabólica", "Metabolic"),
    ("healthDiseaseCatMetabolicDesc", "Trastornos metabólicos", "Metabolic disorders"),
    ("healthDiseaseCatEnvironmental", "Ambiental", "Environmental"),
    ("healthDiseaseCatEnvironmentalDesc", "Causadas por factores ambientales", "Caused by environmental factors"),

    # GravedadEnfermedad
    ("healthSeverityMild", "Leve", "Mild"),
    ("healthSeverityMildDesc", "Bajo impacto en producción", "Low production impact"),
    ("healthSeverityModerate", "Moderada", "Moderate"),
    ("healthSeverityModerateDesc", "Impacto medio en producción", "Medium production impact"),
    ("healthSeveritySevere", "Grave", "Severe"),
    ("healthSeveritySevereDesc", "Alto impacto, requiere acción inmediata", "High impact, requires immediate action"),
    ("healthSeverityCritical", "Crítica", "Critical"),
    ("healthSeverityCriticalDesc", "Emergencia sanitaria", "Sanitary emergency"),

    # EnfermedadAvicola nombres
    ("healthDiseaseNewcastle", "Enfermedad de Newcastle", "Newcastle Disease"),
    ("healthDiseaseGumboro", "Enfermedad de Gumboro (IBD)", "Gumboro Disease (IBD)"),
    ("healthDiseaseMarek", "Enfermedad de Marek", "Marek's Disease"),
    ("healthDiseaseBronchitis", "Bronquitis Infecciosa (IB)", "Infectious Bronchitis (IB)"),
    ("healthDiseaseAvianFlu", "Influenza Aviar (HPAI/LPAI)", "Avian Influenza (HPAI/LPAI)"),
    ("healthDiseaseLaryngotracheitis", "Laringotraqueitis Infecciosa (ILT)", "Infectious Laryngotracheitis (ILT)"),
    ("healthDiseaseFowlPox", "Viruela Aviar", "Fowl Pox"),
    ("healthDiseaseInfectiousAnemia", "Anemia Infecciosa Aviar (CAV)", "Chicken Infectious Anemia (CAV)"),
    ("healthDiseaseColibacillosis", "Colibacilosis (E. coli)", "Colibacillosis (E. coli)"),
    ("healthDiseaseSalmonella", "Salmonelosis", "Salmonellosis"),
    ("healthDiseaseMycoplasmosis", "Micoplasmosis (MG/MS)", "Mycoplasmosis (MG/MS)"),
    ("healthDiseaseFowlCholera", "Cólera Aviar", "Fowl Cholera"),
    ("healthDiseaseCoryza", "Coriza Infecciosa", "Infectious Coryza"),
    ("healthDiseaseNecroticEnteritis", "Enteritis Necrótica", "Necrotic Enteritis"),
    ("healthDiseaseCoccidiosis", "Coccidiosis", "Coccidiosis"),
    ("healthDiseaseRoundworms", "Ascaridiasis (Lombrices)", "Roundworms (Ascaridia)"),
    ("healthDiseaseAspergillosis", "Aspergilosis", "Aspergillosis"),
    ("healthDiseaseAscites", "Síndrome Ascítico", "Ascites Syndrome"),
    ("healthDiseaseSuddenDeath", "Síndrome de Muerte Súbita (SDS)", "Sudden Death Syndrome (SDS)"),
    ("healthDiseaseVitEDeficiency", "Encefalomalacia (Def. Vit E)", "Encephalomalacia (Vit E Def.)"),
    ("healthDiseaseRickets", "Raquitismo (Def. Vit D/Ca/P)", "Rickets (Vit D/Ca/P Def.)"),

    # CausaMortalidad displayName + descripcion
    ("healthMortalityDisease", "Enfermedad", "Disease"),
    ("healthMortalityDiseaseDesc", "Patología infecciosa", "Infectious pathology"),
    ("healthMortalityAccident", "Accidente", "Accident"),
    ("healthMortalityAccidentDesc", "Trauma o lesión", "Trauma or injury"),
    ("healthMortalityMalnutrition", "Desnutrición", "Malnutrition"),
    ("healthMortalityMalnutritionDesc", "Falta de nutrientes", "Nutrient deficiency"),
    ("healthMortalityStress", "Estrés", "Stress"),
    ("healthMortalityStressDesc", "Factores ambientales", "Environmental factors"),
    ("healthMortalityMetabolic", "Metabólica", "Metabolic"),
    ("healthMortalityMetabolicDesc", "Problemas fisiológicos", "Physiological problems"),
    ("healthMortalityPredation", "Depredación", "Predation"),
    ("healthMortalityPredationDesc", "Ataques de animales", "Animal attacks"),
    ("healthMortalitySacrifice", "Sacrificio", "Sacrifice"),
    ("healthMortalitySacrificeDesc", "Muerte en faena", "Death during slaughter"),
    ("healthMortalityOldAge", "Vejez", "Old Age"),
    ("healthMortalityOldAgeDesc", "Fin de vida productiva", "End of productive life"),
    ("healthMortalityUnknown", "Desconocida", "Unknown"),
    ("healthMortalityUnknownDesc", "Causa no identificada", "Unidentified cause"),
    # CausaMortalidad categoria
    ("healthMortalityCatSanitary", "Sanitaria", "Sanitary"),
    ("healthMortalityCatManagement", "Manejo", "Management"),
    ("healthMortalityCatNutritional", "Nutricional", "Nutritional"),
    ("healthMortalityCatEnvironmental", "Ambiental", "Environmental"),
    ("healthMortalityCatPhysiological", "Fisiológica", "Physiological"),
    ("healthMortalityCatNatural", "Natural", "Natural"),
    ("healthMortalityCatUnclassified", "Sin clasificar", "Unclassified"),

    # CausaMortalidad accionesRecomendadas
    ("healthActionVetDiagnosis", "Solicitar diagnóstico veterinario", "Request veterinary diagnosis"),
    ("healthActionIsolate", "Aislar aves afectadas", "Isolate affected birds"),
    ("healthActionTreatment", "Aplicar tratamiento si está disponible", "Apply treatment if available"),
    ("healthActionBiosecurity", "Aumentar bioseguridad", "Increase biosecurity"),
    ("healthActionVaccinationReview", "Revisar programa de vacunación", "Review vaccination program"),
    ("healthActionInspectFacilities", "Inspeccionar instalaciones", "Inspect facilities"),
    ("healthActionRepairEquipment", "Reparar equipos dañados", "Repair damaged equipment"),
    ("healthActionCheckDensity", "Revisar densidad de aves", "Check bird density"),
    ("healthActionTrainStaff", "Capacitar personal en manejo", "Train staff in handling"),
    ("healthActionCheckFoodAccess", "Verificar acceso al alimento", "Verify food access"),
    ("healthActionCheckFoodQuality", "Revisar calidad del alimento", "Check food quality"),
    ("healthActionCheckDrinkers", "Comprobar funcionamiento de bebederos", "Check drinker operation"),
    ("healthActionAdjustNutrition", "Ajustar programa nutricional", "Adjust nutritional program"),
    ("healthActionRegulateTemp", "Regular temperatura ambiente", "Regulate ambient temperature"),
    ("healthActionImproveVentilation", "Mejorar ventilación", "Improve ventilation"),
    ("healthActionReduceDensity", "Reducir densidad si es necesario", "Reduce density if necessary"),
    ("healthActionConsultNutritionist", "Consultar con nutricionista", "Consult nutritionist"),
    ("healthActionReviewGrowthProgram", "Revisar programa de crecimiento", "Review growth program"),
    ("healthActionAdjustFormula", "Ajustar formulación del alimento", "Adjust feed formulation"),
    ("healthActionReinforceFences", "Reforzar cercos perimetrales", "Reinforce perimeter fences"),
    ("healthActionPestControl", "Implementar control de plagas", "Implement pest control"),
    ("healthActionInstallNets", "Instalar mallas de protección", "Install protective nets"),
    ("healthActionNormalProcess", "Normal en el proceso productivo", "Normal in production process"),
    ("healthActionRequestNecropsy", "Solicitar necropsia si mortalidad es alta", "Request necropsy if mortality is high"),
    ("healthActionIncreaseMonitoring", "Aumentar monitoreo del lote", "Increase batch monitoring"),
    ("healthActionConsultVet", "Consultar con veterinario", "Consult veterinarian"),

    # ViaAdministracion
    ("healthRouteOral", "Oral", "Oral"),
    ("healthRouteOralDesc", "Administración por vía oral", "Oral administration"),
    ("healthRouteWater", "En Agua", "In Water"),
    ("healthRouteWaterDesc", "Disuelta en agua de bebida", "Dissolved in drinking water"),
    ("healthRouteFood", "En Alimento", "In Feed"),
    ("healthRouteFoodDesc", "Mezclado en el alimento", "Mixed in feed"),
    ("healthRouteOcular", "Ocular", "Ocular"),
    ("healthRouteOcularDesc", "Gota en el ojo", "Eye drop"),
    ("healthRouteNasal", "Nasal", "Nasal"),
    ("healthRouteNasalDesc", "Spray o gota nasal", "Nasal spray or drop"),
    ("healthRouteSpray", "Spray", "Spray"),
    ("healthRouteSprayDesc", "Aspersión sobre las aves", "Spraying over birds"),
    ("healthRouteSubcutaneous", "Inyección SC", "SC Injection"),
    ("healthRouteSubcutaneousDesc", "Subcutánea en cuello", "Subcutaneous in neck"),
    ("healthRouteIntramuscular", "Inyección IM", "IM Injection"),
    ("healthRouteIntramuscularDesc", "Intramuscular en pechuga", "Intramuscular in breast"),
    ("healthRouteWing", "En Ala", "Wing Web"),
    ("healthRouteWingDesc", "Punción en membrana del ala", "Wing web puncture"),
    ("healthRouteInOvo", "In-Ovo", "In-Ovo"),
    ("healthRouteInOvoDesc", "Inyección en el huevo", "Egg injection"),
    ("healthRouteTopical", "Tópica", "Topical"),
    ("healthRouteTopicalDesc", "Aplicación externa en piel", "External skin application"),

    # EstadoBioseguridad
    ("healthBioStatusPending", "Pendiente", "Pending"),
    ("healthBioStatusCompliant", "Cumple", "Compliant"),
    ("healthBioStatusNonCompliant", "No Cumple", "Non-Compliant"),
    ("healthBioStatusPartial", "Parcial", "Partial"),
    ("healthBioStatusNA", "N/A", "N/A"),

    # CategoriaBioseguridad
    ("healthBioCatPersonnel", "Acceso de Personal", "Personnel Access"),
    ("healthBioCatPersonnelDesc", "Control de ingreso y vestimenta", "Entry and clothing control"),
    ("healthBioCatVehicles", "Acceso de Vehículos", "Vehicle Access"),
    ("healthBioCatVehiclesDesc", "Control de vehículos y equipos", "Vehicle and equipment control"),
    ("healthBioCatCleaning", "Limpieza y Desinfección", "Cleaning and Disinfection"),
    ("healthBioCatCleaningDesc", "Protocolos de higiene", "Hygiene protocols"),
    ("healthBioCatPestControl", "Control de Plagas", "Pest Control"),
    ("healthBioCatPestControlDesc", "Roedores, insectos, aves silvestres", "Rodents, insects, wild birds"),
    ("healthBioCatBirdManagement", "Manejo de Aves", "Bird Management"),
    ("healthBioCatBirdManagementDesc", "Prácticas con las aves", "Practices with birds"),
    ("healthBioCatMortality", "Manejo de Mortalidad", "Mortality Management"),
    ("healthBioCatMortalityDesc", "Disposición de aves muertas", "Dead bird disposal"),
    ("healthBioCatWater", "Calidad del Agua", "Water Quality"),
    ("healthBioCatWaterDesc", "Potabilidad y cloración", "Potability and chlorination"),
    ("healthBioCatFeed", "Manejo de Alimento", "Feed Management"),
    ("healthBioCatFeedDesc", "Almacenamiento y calidad", "Storage and quality"),
    ("healthBioCatFacilities", "Instalaciones", "Facilities"),
    ("healthBioCatFacilitiesDesc", "Estado de galpones y equipos", "Shed and equipment condition"),
    ("healthBioCatRecords", "Registros", "Records"),
    ("healthBioCatRecordsDesc", "Documentación y trazabilidad", "Documentation and traceability"),

    # FrecuenciaInspeccion
    ("healthInspFreqDaily", "Diaria", "Daily"),
    ("healthInspFreqWeekly", "Semanal", "Weekly"),
    ("healthInspFreqBiweekly", "Quincenal", "Biweekly"),
    ("healthInspFreqMonthly", "Mensual", "Monthly"),
    ("healthInspFreqQuarterly", "Trimestral", "Quarterly"),
    ("healthInspFreqPerBatch", "Por Lote", "Per Batch"),

    # CategoriaAntimicrobiano
    ("healthAbCriticallyImportant", "Críticamente Importante", "Critically Important"),
    ("healthAbHighlyImportant", "Altamente Importante", "Highly Important"),
    ("healthAbImportant", "Importante", "Important"),
    ("healthAbUnclassified", "No Clasificado", "Unclassified"),

    # FamiliaAntimicrobiano
    ("healthAbFamilyFluoroquinolones", "Fluoroquinolonas", "Fluoroquinolones"),
    ("healthAbFamilyCephalosporins", "Cefalosporinas 3a/4a gen", "3rd/4th gen Cephalosporins"),
    ("healthAbFamilyMacrolides", "Macrólidos", "Macrolides"),
    ("healthAbFamilyPolymyxins", "Polimixinas (Colistina)", "Polymyxins (Colistin)"),
    ("healthAbFamilyAminoglycosides", "Aminoglucósidos", "Aminoglycosides"),
    ("healthAbFamilyPenicillins", "Penicilinas", "Penicillins"),
    ("healthAbFamilyTetracyclines", "Tetraciclinas", "Tetracyclines"),
    ("healthAbFamilySulfonamides", "Sulfonamidas", "Sulfonamides"),
    ("healthAbFamilyLincosamides", "Lincosamidas", "Lincosamides"),
    ("healthAbFamilyPleuromutilins", "Pleuromutilinas", "Pleuromutilins"),
    ("healthAbFamilyBacitracin", "Bacitracina", "Bacitracin"),
    ("healthAbFamilyIonophores", "Ionóforos", "Ionophores"),

    # MotivoUsoAntimicrobiano
    ("healthAbUseTreatment", "Tratamiento", "Treatment"),
    ("healthAbUseTreatmentDesc", "Tratamiento de enfermedad diagnosticada", "Treatment of diagnosed disease"),
    ("healthAbUseMetaphylaxis", "Metafilaxis", "Metaphylaxis"),
    ("healthAbUseMetaphylaxisDesc", "Tratamiento preventivo de grupo en riesgo", "Preventive treatment of at-risk group"),
    ("healthAbUseProphylaxis", "Profilaxis", "Prophylaxis"),
    ("healthAbUseProphylaxisDesc", "Prevención en animales sanos", "Prevention in healthy animals"),
    ("healthAbUseGrowthPromoter", "Promotor de Crecimiento", "Growth Promoter"),
    ("healthAbUseGrowthPromoterDesc", "Uso prohibido en muchos países", "Prohibited use in many countries"),

    # TipoAveProduccion (salud)
    ("healthBirdTypeBroiler", "Pollo de Engorde", "Broiler"),
    ("healthBirdTypeLayerCommercial", "Gallina Ponedora Comercial", "Commercial Layer Hen"),
    ("healthBirdTypeLayerFreeRange", "Gallina Ponedora Pastoreo", "Free-Range Layer Hen"),
    ("healthBirdTypeHeavyBreeder", "Reproductora Pesada", "Heavy Breeder"),
    ("healthBirdTypeLightBreeder", "Reproductora Ligera", "Light Breeder"),
    ("healthBirdTypeTurkeyMeat", "Pavo de Engorde", "Meat Turkey"),
    ("healthBirdTypeQuail", "Codorniz", "Quail"),
    ("healthBirdTypeDuck", "Pato", "Duck"),

    # ===== GRANJAS ENUMS =====
    # EstadoGranja
    ("farmStatusActive", "Activo", "Active"),
    ("farmStatusActiveDesc", "Granja en operación", "Farm in operation"),
    ("farmStatusInactive", "Inactivo", "Inactive"),
    ("farmStatusInactiveDesc", "Granja sin operaciones", "Farm without operations"),
    ("farmStatusMaintenance", "Mantenimiento", "Maintenance"),
    ("farmStatusMaintenanceDesc", "Granja en reparación", "Farm under repair"),
    # RolGranja
    ("farmRoleOwner", "Propietario", "Owner"),
    ("farmRoleAdmin", "Administrador", "Administrator"),
    ("farmRoleManager", "Gestor", "Manager"),
    ("farmRoleOperator", "Operario", "Operator"),
    ("farmRoleViewer", "Visualizador", "Viewer"),
    ("farmRoleOwnerDesc", "Control total, puede eliminar la granja", "Full control, can delete the farm"),
    ("farmRoleAdminDesc", "Control total excepto eliminar", "Full control except deletion"),
    ("farmRoleManagerDesc", "Gestión de registros e invitaciones", "Records and invitation management"),
    ("farmRoleOperatorDesc", "Solo puede crear registros", "Can only create records"),
    ("farmRoleViewerDesc", "Solo lectura", "Read only"),
    # GranjaNotifier
    ("farmCreating", "Creando granja...", "Creating farm..."),
    ("farmUpdating", "Actualizando granja...", "Updating farm..."),
    ("farmDeleting", "Eliminando granja...", "Deleting farm..."),
    ("farmActivating", "Activando granja...", "Activating farm..."),
    ("farmSuspending", "Suspendiendo granja...", "Suspending farm..."),
    ("farmMaintenanceLoading", "Poniendo en mantenimiento...", "Setting maintenance..."),
    ("farmSearching", "Buscando granjas...", "Searching farms..."),
    ("farmCreatedSuccess", "Granja creada exitosamente", "Farm created successfully"),
    ("farmUpdatedSuccess", "Granja actualizada exitosamente", "Farm updated successfully"),
    ("farmDeletedSuccess", "Granja eliminada exitosamente", "Farm deleted successfully"),
    ("farmActivatedSuccess", "Granja activada exitosamente", "Farm activated successfully"),
    ("farmSuspendedSuccess", "Granja suspendida", "Farm suspended"),
    ("farmMaintenanceSuccess", "Granja en mantenimiento", "Farm in maintenance"),

    # ===== GALPONES ENUMS =====
    # EstadoGalpon
    ("shedStatusActive", "Activo", "Active"),
    ("shedStatusActiveDesc", "Galpón operativo", "Operational shed"),
    ("shedStatusMaintenance", "Mantenimiento", "Maintenance"),
    ("shedStatusMaintenanceDesc", "Galpón en reparación", "Shed under repair"),
    ("shedStatusInactive", "Inactivo", "Inactive"),
    ("shedStatusInactiveDesc", "Galpón sin uso", "Unused shed"),
    ("shedStatusDisinfection", "Desinfección", "Disinfection"),
    ("shedStatusDisinfectionDesc", "Galpón en proceso sanitario", "Shed in sanitary process"),
    ("shedStatusQuarantine", "Cuarentena", "Quarantine"),
    ("shedStatusQuarantineDesc", "Galpón aislado por sanidad", "Shed isolated for health reasons"),
    # TipoGalpon
    ("shedTypeMeat", "Engorde", "Meat"),
    ("shedTypeMeatDesc", "Galpón para producción de carne", "Shed for meat production"),
    ("shedTypeEgg", "Postura", "Egg"),
    ("shedTypeEggDesc", "Galpón para producción de huevos", "Shed for egg production"),
    ("shedTypeBreeder", "Reproductora", "Breeder"),
    ("shedTypeBreederDesc", "Galpón para producción de huevos fértiles", "Shed for fertile egg production"),
    ("shedTypeMixed", "Mixto", "Mixed"),
    ("shedTypeMixedDesc", "Galpón multiuso para diferentes tipos de producción", "Multi-purpose shed for different production types"),
    # TipoEventoGalpon
    ("shedEventDisinfection", "Desinfección", "Disinfection"),
    ("shedEventMaintenance", "Mantenimiento", "Maintenance"),
    ("shedEventStatusChange", "Cambio de Estado", "Status Change"),
    ("shedEventCreation", "Creación", "Creation"),
    ("shedEventBatchAssigned", "Lote Asignado", "Batch Assigned"),
    ("shedEventBatchReleased", "Lote Liberado", "Batch Released"),
    ("shedEventOther", "Otro", "Other"),
    # GalponNotifier
    ("shedCreating", "Creando galpón...", "Creating shed..."),
    ("shedUpdating", "Actualizando galpón...", "Updating shed..."),
    ("shedDeleting", "Eliminando galpón...", "Deleting shed..."),
    ("shedChangingStatus", "Cambiando estado...", "Changing status..."),
    ("shedAssigningBatch", "Asignando lote...", "Assigning batch..."),
    ("shedReleasing", "Liberando galpón...", "Releasing shed..."),
    ("shedSchedulingMaintenance", "Programando mantenimiento...", "Scheduling maintenance..."),
    ("shedCreatedSuccess", "Galpón creado exitosamente", "Shed created successfully"),
    ("shedUpdatedSuccess", "Galpón actualizado exitosamente", "Shed updated successfully"),
    ("shedDeletedSuccess", "Galpón eliminado exitosamente", "Shed deleted successfully"),
    ("shedBatchAssignedSuccess", "Lote asignado exitosamente", "Batch assigned successfully"),
    ("shedReleasedSuccess", "Galpón liberado exitosamente", "Shed released successfully"),
    ("shedMaintenanceScheduled", "Mantenimiento programado", "Maintenance scheduled"),

    # ===== NOTIFICACIONES =====
    # TipoNotificacion labels
    ("notifStockLow", "Stock Bajo", "Low Stock"),
    ("notifStockEmpty", "Agotado", "Out of Stock"),
    ("notifExpiringSoon", "Próximo a Vencer", "Expiring Soon"),
    ("notifExpired", "Vencido", "Expired"),
    ("notifRestocked", "Reabastecido", "Restocked"),
    ("notifInventoryMovement", "Movimiento", "Movement"),
    ("notifMortalityRecorded", "Mortalidad Registrada", "Mortality Recorded"),
    ("notifMortalityHigh", "Mortalidad Alta", "High Mortality"),
    ("notifMortalityCritical", "Mortalidad Crítica", "Critical Mortality"),
    ("notifNewBatch", "Nuevo Lote", "New Batch"),
    ("notifBatchFinished", "Lote Finalizado", "Batch Finished"),
    ("notifWeightLow", "Peso Bajo", "Low Weight"),
    ("notifCloseUpcoming", "Cierre Próximo", "Close Upcoming"),
    ("notifConversionAbnormal", "Conversión Anormal", "Abnormal Conversion"),
    ("notifNoRecords", "Sin Registros", "No Records"),
    ("notifProduction", "Producción", "Production"),
    ("notifProductionLow", "Producción Baja", "Low Production"),
    ("notifProductionDrop", "Caída Producción", "Production Drop"),
    ("notifFirstEgg", "Primer Huevo", "First Egg"),
    ("notifRecord", "Récord", "Record"),
    ("notifGoalReached", "Meta Alcanzada", "Goal Reached"),
    ("notifVaccination", "Vacunación", "Vaccination"),
    ("notifVaccinationTomorrow", "Vacunación Mañana", "Vaccination Tomorrow"),

    # PrioridadNotificacion
    ("notifPriorityLow", "Baja", "Low"),
    ("notifPriorityNormal", "Normal", "Normal"),
    ("notifPriorityHigh", "Alta", "High"),
    ("notifPriorityUrgent", "Urgente", "Urgent"),

    # AlertasService messages
    ("notifTitleStockLow", "⚠️ Stock bajo: {itemName}", "⚠️ Low stock: {itemName}"),
    ("notifMsgStockLow", "Solo quedan {quantity} {unit}", "Only {quantity} {unit} remaining"),
    ("notifTitleStockEmpty", "🚫 Agotado: {itemName}", "🚫 Out of stock: {itemName}"),
    ("notifMsgStockEmpty", "Stock en cero, requiere reabastecimiento urgente", "Stock at zero, requires urgent restocking"),
    ("notifTitleExpired", "❌ Vencido: {itemName}", "❌ Expired: {itemName}"),
    ("notifMsgExpired", "Este producto venció hace {days} días", "This product expired {days} days ago"),
    ("notifTitleExpiringSoon", "📅 Próximo a vencer: {itemName}", "📅 Expiring soon: {itemName}"),
    ("notifMsgExpiresToday", "¡Vence hoy!", "Expires today!"),
    ("notifMsgExpiresInDays", "Vence en {days} días", "Expires in {days} days"),
    ("notifTitleRestocked", "✅ Reabastecido: {itemName}", "✅ Restocked: {itemName}"),
    ("notifMsgRestocked", "Se agregaron {quantity} {unit}", "{quantity} {unit} added"),
    ("notifTitleMortalityCritical", "🚨 Mortalidad CRÍTICA: {batchName}", "🚨 CRITICAL Mortality: {batchName}"),
    ("notifTitleMortalityHigh", "⚠️ Mortalidad alta: {batchName}", "⚠️ High mortality: {batchName}"),
    ("notifTitleMortalityRecorded", "🐔 Mortalidad registrada: {batchName}", "🐔 Mortality recorded: {batchName}"),
    ("notifMsgMortalityRecorded", "{count} aves • Causa: {cause} • Acumulada: {percentage}%", "{count} birds • Cause: {cause} • Accumulated: {percentage}%"),
    ("notifTitleNewBatch", "🐤 Nuevo lote: {batchName}", "🐤 New batch: {batchName}"),
    ("notifMsgNewBatch", "{birdCount} aves en {shedName}", "{birdCount} birds in {shedName}"),
    ("notifTitleBatchFinished", "✅ Lote finalizado: {batchName}", "✅ Batch finished: {batchName}"),
    ("notifMsgBatchFinished", "Ciclo de {days} días", "{days} day cycle"),
    ("notifTitleWeightLow", "⚖️ Peso bajo: {batchName}", "⚖️ Low weight: {batchName}"),
    ("notifTitleConversionAbnormal", "📊 Conversión anormal: {batchName}", "📊 Abnormal conversion: {batchName}"),
    ("notifTitleCloseUpcoming", "📆 Cierre próximo: {batchName}", "📆 Close upcoming: {batchName}"),
    ("notifMsgClosesToday", "¡Fecha de cierre es hoy!", "Close date is today!"),
    ("notifMsgClosesInDays", "Cierra en {days} días", "Closes in {days} days"),

    # ===== REPORTES =====
    # TipoReporte
    ("reportTypeBatchProduction", "Producción de Lote", "Batch Production"),
    ("reportTypeBatchProductionDesc", "Resumen completo del rendimiento productivo", "Complete summary of production performance"),
    ("reportTypeMortality", "Mortalidad", "Mortality"),
    ("reportTypeMortalityDesc", "Análisis detallado de mortalidad y causas", "Detailed mortality and cause analysis"),
    ("reportTypeFeedConsumption", "Consumo de Alimento", "Feed Consumption"),
    ("reportTypeFeedConsumptionDesc", "Análisis de consumo y conversión alimenticia", "Feed consumption and conversion analysis"),
    ("reportTypeWeight", "Peso y Crecimiento", "Weight and Growth"),
    ("reportTypeWeightDesc", "Evolución de peso y curvas de crecimiento", "Weight evolution and growth curves"),
    ("reportTypeCosts", "Costos", "Costs"),
    ("reportTypeCostsDesc", "Desglose de gastos y costos operativos", "Expense and operating cost breakdown"),
    ("reportTypeSales", "Ventas", "Sales"),
    ("reportTypeSalesDesc", "Resumen de ventas e ingresos", "Sales and revenue summary"),
    ("reportTypeProfitability", "Rentabilidad", "Profitability"),
    ("reportTypeProfitabilityDesc", "Análisis de utilidad y márgenes", "Utility and margin analysis"),
    ("reportTypeHealth", "Salud", "Health"),
    ("reportTypeHealthDesc", "Historial de tratamientos y vacunaciones", "Treatment and vaccination history"),
    ("reportTypeInventory", "Inventario", "Inventory"),
    ("reportTypeInventoryDesc", "Estado actual del inventario", "Current inventory status"),
    ("reportTypeExecutive", "Resumen Ejecutivo", "Executive Summary"),
    ("reportTypeExecutiveDesc", "Vista consolidada de indicadores clave", "Consolidated view of key indicators"),

    # PeriodoReporte
    ("reportPeriodWeek", "Última semana", "Last week"),
    ("reportPeriodMonth", "Último mes", "Last month"),
    ("reportPeriodQuarter", "Último trimestre", "Last quarter"),
    ("reportPeriodSemester", "Último semestre", "Last semester"),
    ("reportPeriodYear", "Último año", "Last year"),
    ("reportPeriodCustom", "Personalizado", "Custom"),

    # FormatoReporte
    ("reportFormatPdf", "PDF", "PDF"),
    ("reportFormatPreview", "Vista previa", "Preview"),

    # PDF Generator labels
    ("reportPdfHeaderProduction", "REPORTE DE PRODUCCIÓN", "PRODUCTION REPORT"),
    ("reportPdfHeaderExecutive", "RESUMEN EJECUTIVO", "EXECUTIVE SUMMARY"),
    ("reportPdfHeaderCosts", "REPORTE DE COSTOS", "COST REPORT"),
    ("reportPdfHeaderSales", "REPORTE DE VENTAS", "SALES REPORT"),
    ("reportPdfSectionBatchInfo", "INFORMACIÓN DEL LOTE", "BATCH INFORMATION"),
    ("reportPdfSectionProductionIndicators", "INDICADORES DE PRODUCCIÓN", "PRODUCTION INDICATORS"),
    ("reportPdfSectionFinancialSummary", "RESUMEN FINANCIERO", "FINANCIAL SUMMARY"),
    ("reportPdfLabelCode", "Código", "Code"),
    ("reportPdfLabelBirdType", "Tipo de Ave", "Bird Type"),
    ("reportPdfLabelShed", "Galpón", "Shed"),
    ("reportPdfLabelEntryDate", "Fecha Ingreso", "Entry Date"),
    ("reportPdfLabelCurrentAge", "Edad Actual", "Current Age"),
    ("reportPdfLabelDaysInFarm", "Días en Granja", "Days in Farm"),
    ("reportPdfLabelInitialBirds", "Aves Iniciales", "Initial Birds"),
    ("reportPdfLabelCurrentBirds", "Aves Actuales", "Current Birds"),
    ("reportPdfLabelMortality", "Mortalidad", "Mortality"),
    ("reportPdfLabelAvgWeight", "Peso Promedio", "Average Weight"),
    ("reportPdfLabelTotalConsumption", "Consumo Total", "Total Consumption"),
    ("reportPdfLabelConversion", "Conversión", "Conversion"),
    ("reportPdfLabelBirdCost", "Costo de Aves", "Bird Cost"),
    ("reportPdfLabelFeedCost", "Costo de Alimento", "Feed Cost"),
    ("reportPdfLabelTotalCosts", "Total Costos", "Total Costs"),
    ("reportPdfLabelSalesRevenue", "Ingresos por Ventas", "Sales Revenue"),
    ("reportPdfLabelBalance", "BALANCE", "BALANCE"),
    ("reportPdfLabelPeriod", "PERÍODO", "PERIOD"),
    ("reportPdfConversionSubtitle", "kg alim / kg peso", "kg feed / kg weight"),
]

def main():
    es_path = os.path.join(BASE, 'app_es.arb')
    en_path = os.path.join(BASE, 'app_en.arb')

    es_data = load_arb(es_path)
    en_data = load_arb(en_path)

    added_es = 0
    added_en = 0
    skipped = 0

    for key, es_val, en_val in NEW_KEYS:
        if key not in es_data:
            es_data[key] = es_val
            added_es += 1
        else:
            skipped += 1

        if key not in en_data:
            en_data[key] = en_val
            added_en += 1

    save_arb(es_path, es_data)
    save_arb(en_path, en_data)

    print(f"Added {added_es} keys to app_es.arb")
    print(f"Added {added_en} keys to app_en.arb")
    print(f"Skipped {skipped} keys (already existed)")
    print(f"Total keys in ES: {len([k for k in es_data if not k.startswith('@')])}")
    print(f"Total keys in EN: {len([k for k in en_data if not k.startswith('@')])}")

if __name__ == '__main__':
    main()
