#!/usr/bin/env python3
"""Add new ARB keys for comprehensive i18n audit Round 5."""
import json, sys

def add_keys(filepath, new_keys):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    added = 0
    for key, value in new_keys.items():
        if key not in data:
            data[key] = value
            added += 1
    
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    
    print(f"{filepath}: added {added} new keys (total: {len(data)})")

# ===== SPANISH KEYS =====
es_keys = {
    # === Catálogo de enfermedades ===
    "catalogDiseaseNotifRequired": "Notificación obligatoria",
    "@catalogDiseaseNotifRequired": {},
    "catalogDiseaseVaccinable": "Vacunable",
    "@catalogDiseaseVaccinable": {},
    "commonCategory": "Categoría",
    "@commonCategory": {},
    "catalogDiseaseSymptoms": "Síntomas",
    "@catalogDiseaseSymptoms": {},
    "catalogDiseaseSeverity": "Gravedad",
    "@catalogDiseaseSeverity": {},
    "catalogDiseaseNotFound": "No se encontraron enfermedades",
    "@catalogDiseaseNotFound": {},
    "catalogDiseaseEmpty": "Catálogo vacío",
    "@catalogDiseaseEmpty": {},
    "catalogDiseaseSearchHint": "Intenta con otros términos de búsqueda o filtros",
    "@catalogDiseaseSearchHint": {},
    "catalogDiseaseNone": "No hay enfermedades registradas",
    "@catalogDiseaseNone": {},
    "catalogDiseaseInfoGeneral": "Información General",
    "@catalogDiseaseInfoGeneral": {},
    "catalogDiseaseTransDiag": "Transmisión y Diagnóstico",
    "@catalogDiseaseTransDiag": {},
    "catalogDiseaseMainSymptoms": "Síntomas Principales",
    "@catalogDiseaseMainSymptoms": {},
    "catalogDiseasePostmortem": "Lesiones Post-mortem",
    "@catalogDiseasePostmortem": {},
    "catalogDiseaseTreatPrev": "Tratamiento y Prevención",
    "@catalogDiseaseTreatPrev": {},
    "catalogDiseaseNotifOblig": "Notificación Obligatoria",
    "@catalogDiseaseNotifOblig": {},
    "catalogDiseaseVaccinePrevent": "Prevenible por vacunación",
    "@catalogDiseaseVaccinePrevent": {},
    "catalogDiseaseCausalAgent": "Agente Causal",
    "@catalogDiseaseCausalAgent": {},
    "catalogDiseaseContagious": "Contagiosa",
    "@catalogDiseaseContagious": {},
    "commonYes": "Sí",
    "@commonYes": {},
    "commonNo": "No",
    "@commonNo": {},
    "catalogDiseaseNotification": "Notificación",
    "@catalogDiseaseNotification": {},
    "catalogDiseaseVaccineAvail": "Vacuna Disponible",
    "@catalogDiseaseVaccineAvail": {},
    "catalogDiseaseTransmission": "Transmisión",
    "@catalogDiseaseTransmission": {},
    "catalogDiseaseDiagnosis": "Diagnóstico",
    "@catalogDiseaseDiagnosis": {},
    "catalogDiseaseViewDetails": "Ver Detalles",
    "@catalogDiseaseViewDetails": {},
    "catalogDiseaseConsultVet": "Consulte con su veterinario",
    "@catalogDiseaseConsultVet": {},

    # === Lote detail handlers ===
    "batchNoTransitions": "No hay transiciones disponibles desde este estado.",
    "@batchNoTransitions": {},
    "batchSelectNewStatusLabel": "Seleccionar nuevo estado:",
    "@batchSelectNewStatusLabel": {},
    "batchConfirmStatusChange": "¿Confirmar cambio a {status}?",
    "@batchConfirmStatusChange": {"placeholders": {"status": {"type": "String"}}},
    "batchPermanentStatusWarning": "Este estado es permanente y no podrá revertirse. El lote no podrá cambiar a ningún otro estado después de esta acción.",
    "@batchPermanentStatusWarning": {},
    "batchPermanentStatus": "Estado permanente",
    "@batchPermanentStatus": {},

    # === Lote detail utils ===
    "batchTypePoultryDesc": "Aves criadas para producción de carne",
    "@batchTypePoultryDesc": {},
    "batchTypeLayersDesc": "Aves criadas para producción de huevos",
    "@batchTypeLayersDesc": {},
    "batchTypeHeavyBreedersDesc": "Aves reproductoras de línea pesada",
    "@batchTypeHeavyBreedersDesc": {},
    "batchTypeLightBreedersDesc": "Aves reproductoras de línea liviana",
    "@batchTypeLightBreedersDesc": {},
    "batchTypeTurkeysDesc": "Pavos para carne",
    "@batchTypeTurkeysDesc": {},
    "batchTypeQuailDesc": "Codornices para huevos o carne",
    "@batchTypeQuailDesc": {},
    "batchTypeDucksDesc": "Patos para carne",
    "@batchTypeDucksDesc": {},
    "batchTypeOtherDesc": "Otro tipo de ave",
    "@batchTypeOtherDesc": {},
    "batchNotRecorded": "No registrado",
    "@batchNotRecorded": {},
    "commonBirdsUnit": "aves",
    "@commonBirdsUnit": {},

    # === Lote detail sections ===
    "batchAgeDaysValue": "{count} días",
    "@batchAgeDaysValue": {"placeholders": {"count": {"type": "String"}}},
    "batchAgeWeeksDaysValue": "{weeks} semanas ({days} días)",
    "@batchAgeWeeksDaysValue": {"placeholders": {"weeks": {"type": "String"}, "days": {"type": "String"}}},

    # === Costos list page ===
    "costExpenseType": "Tipo de gasto",
    "@costExpenseType": {},
    "costConcept": "Concepto",
    "@costConcept": {},
    "costProvider": "Proveedor",
    "@costProvider": {},
    "costInvoiceNumber": "Nº Factura",
    "@costInvoiceNumber": {},
    "commonStatus": "Estado",
    "@commonStatus": {},
    "costRejectionReason": "Motivo rechazo",
    "@costRejectionReason": {},
    "commonObservations": "Observaciones",
    "@commonObservations": {},

    # === Peso observaciones_fotos_step ===
    "weightAvgWeight": "Peso promedio",
    "@weightAvgWeight": {},
    "weightBirdsWeighed": "Aves pesadas",
    "@weightBirdsWeighed": {},
    "weightRange": "Rango de peso",
    "@weightRange": {},
    "weightTotal": "Peso total",
    "@weightTotal": {},
    "weightDailyGain": "GDP (Ganancia diaria)",
    "@weightDailyGain": {},
    "weightGramsPerDay": "g/día",
    "@weightGramsPerDay": {},
    "weightCoefficientVariation": "Coeficiente de variación",
    "@weightCoefficientVariation": {},

    # === Consumo informacion_consumo_step ===
    "feedExceedsStock": "La cantidad excede el stock disponible ({stock} kg)",
    "@feedExceedsStock": {"placeholders": {"stock": {"type": "String"}}},
    "feedStockPercentUsage": "Usarás el {percent}% del stock disponible",
    "@feedStockPercentUsage": {"placeholders": {"percent": {"type": "String"}}},
    "feedRecommendedForDays": "Recomendado para {days} días: {type}",
    "@feedRecommendedForDays": {"placeholders": {"days": {"type": "String"}, "type": {"type": "String"}}},
    "feedConsumptionDate": "Fecha del consumo",
    "@feedConsumptionDate": {},

    # === Consumo observaciones_step ===
    "feedObsTitle": "Observaciones",
    "@feedObsTitle": {},
    "feedObsOptionalHint": "Opcional: Agrega notas adicionales",
    "@feedObsOptionalHint": {},
    "feedObsDescribeHint": "Describe condiciones del suministro, comportamiento de las aves, calidad del alimento, etc.",
    "@feedObsDescribeHint": {},
    "feedObsHelpText": "Las observaciones ayudan a documentar detalles importantes del suministro de alimento y pueden ser útiles para análisis futuros.",
    "@feedObsHelpText": {},

    # === Ventas seleccion_granja_lote ===
    "ventaFarmLoadError": "Error al cargar granjas",
    "@ventaFarmLoadError": {},
    "ventaSelectFarmHint": "Selecciona una granja",
    "@ventaSelectFarmHint": {},
    "ventaSelectBatchHint": "Selecciona un lote",
    "@ventaSelectBatchHint": {},
    "ventaBatchLoadError": "Error al cargar lotes",
    "@ventaBatchLoadError": {},
    "commonBatch": "Lote",
    "@commonBatch": {},

    # === Salud detail page ===
    "saludRegisteredBy": "Registrado por",
    "@saludRegisteredBy": {},
    "saludCloseDate": "Fecha de Cierre",
    "@saludCloseDate": {},
    "saludCloseTreatment": "Cerrar Tratamiento",
    "@saludCloseTreatment": {},
    "saludResultOptional": "Resultado (Opcional)",
    "@saludResultOptional": {},
    "saludMonthNames": "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre",
    "@saludMonthNames": {},
    "saludDateConnector": "de",
    "@saludDateConnector": {},

    # === Registrar tratamiento page ===
    "treatDurationValidation": "La duración debe ser entre 1 y 365 días",
    "@treatDurationValidation": {},
    "commonDateCannotBeFuture": "La fecha no puede ser futura",
    "@commonDateCannotBeFuture": {},
    "treatRegisteredInventoryError": "Tratamiento registrado, pero hubo un error al actualizar inventario",
    "@treatRegisteredInventoryError": {},
    "treatNewTreatment": "Nuevo Tratamiento",
    "@treatNewTreatment": {},
    "commonNext": "Siguiente",
    "@commonNext": {},
    "commonSaveAction": "Guardar",
    "@commonSaveAction": {},
    "commonPrevious": "Anterior",
    "@commonPrevious": {},

    # === Registrar costo page ===
    "costRegisteredInventoryError": "Costo registrado, pero hubo un error al actualizar inventario",
    "@costRegisteredInventoryError": {},
    "costsEditCost": "Editar Costo",
    "@costsEditCost": {},
    "costRegisterCost": "Registrar Costo",
    "@costRegisterCost": {},
    "commonUpdate": "Actualizar",
    "@commonUpdate": {},
    "commonRegister": "Registrar",
    "@commonRegister": {},

    # === Stock indicator ===
    "invStockActualLabel": "Actual: {stock} {unit}",
    "@invStockActualLabel": {"placeholders": {"stock": {"type": "String"}, "unit": {"type": "String"}}},
    "invStockMinimoLabel": "Mínimo: {stock} {unit}",
    "@invStockMinimoLabel": {"placeholders": {"stock": {"type": "String"}, "unit": {"type": "String"}}},

    # === Inventario dialogs ===
    "invEntryError": "Error al registrar entrada de inventario",
    "@invEntryError": {},
    "invExitError": "Error al registrar salida de inventario",
    "@invExitError": {},

    # === Selector alimento inventario ===
    "feedLoadingItems": "Cargando alimentos...",
    "@feedLoadingItems": {},
    "feedLoadError": "Error al cargar alimentos",
    "@feedLoadError": {},

    # === Evidencia fotografica step ===
    "photoNoPhotosAdded": "No hay fotos agregadas",
    "@photoNoPhotosAdded": {},
    "photoMax5Hint": "Puedes agregar hasta 5 fotos",
    "@photoMax5Hint": {},

    # === Granja list card ===
    "farmPoultryFarm": "Granja Avícola",
    "@farmPoultryFarm": {},
    "farmNoAddress": "Sin dirección",
    "@farmNoAddress": {},

    # === Tag input field ===
    "shedAddTagHint": "Agregar etiqueta",
    "@shedAddTagHint": {},

    # === Galpon filter dialog ===
    "shedCapacityHintExample": "Ej: 1000",
    "@shedCapacityHintExample": {},

    # === Produccion observaciones_fotos_step ===
    "prodObsHint": "Describe calidad de los huevos, color de cáscara, condiciones ambientales, comportamiento de las aves, etc.",
    "@prodObsHint": {},

    # === Informacion pesaje step ===
    # commonBirdsUnit already added above

    # === Lotes home page ===
    "commonType": "Tipo",
    "@commonType": {},
    "commonBirds": "Aves",
    "@commonBirds": {},
    "commonAge": "Edad",
    "@commonAge": {},

    # === Lote dashboard page ===
    # batchAgeDaysValue already added above (parameterized)

    # === Editar lote page ===
    "batchQuantityValidation": "Ingrese una cantidad válida mayor a 0",
    "@batchQuantityValidation": {},

    # === Inventario detail ===
    "invStockBajoMinimo": "Stock bajo (mínimo: {min} {unit})",
    "@invStockBajoMinimo": {"placeholders": {"min": {"type": "String"}, "unit": {"type": "String"}}},
    "invExpiresInDays": "Vence en {days} días",
    "@invExpiresInDays": {"placeholders": {"days": {"type": "String"}}},

    # === Venta detail page ===
    "ventaDiscountPercent": "Descuento ({percent}%)",
    "@ventaDiscountPercent": {"placeholders": {"percent": {"type": "String"}}},

    # === Reportes page ===
    "reportsPeriodLabel": "Período: {period}",
    "@reportsPeriodLabel": {"placeholders": {"period": {"type": "String"}}},
    "reportsPeriodSameMonth": "{dayStart} al {dayEnd} de {month} {year}",
    "@reportsPeriodSameMonth": {"placeholders": {"dayStart": {"type": "String"}, "dayEnd": {"type": "String"}, "month": {"type": "String"}, "year": {"type": "String"}}},
    "reportsPeriodSameYear": "{dayStart} de {monthStart} al {dayEnd} de {monthEnd}, {year}",
    "@reportsPeriodSameYear": {"placeholders": {"dayStart": {"type": "String"}, "monthStart": {"type": "String"}, "dayEnd": {"type": "String"}, "monthEnd": {"type": "String"}, "year": {"type": "String"}}},
    "reportsPeriodDateRange": "{start} al {end}",
    "@reportsPeriodDateRange": {"placeholders": {"start": {"type": "String"}, "end": {"type": "String"}}},

    # === Salud form field ===
    "commonFieldRequired": "Este campo es obligatorio",
    "@commonFieldRequired": {},

    # === Inventario Más opciones ===
    "commonMoreOptions": "Más opciones",
    "@commonMoreOptions": {},
}

# ===== ENGLISH KEYS =====
en_keys = {
    "catalogDiseaseNotifRequired": "Mandatory notification",
    "@catalogDiseaseNotifRequired": {},
    "catalogDiseaseVaccinable": "Vaccinable",
    "@catalogDiseaseVaccinable": {},
    "commonCategory": "Category",
    "@commonCategory": {},
    "catalogDiseaseSymptoms": "Symptoms",
    "@catalogDiseaseSymptoms": {},
    "catalogDiseaseSeverity": "Severity",
    "@catalogDiseaseSeverity": {},
    "catalogDiseaseNotFound": "No diseases found",
    "@catalogDiseaseNotFound": {},
    "catalogDiseaseEmpty": "Empty catalog",
    "@catalogDiseaseEmpty": {},
    "catalogDiseaseSearchHint": "Try other search terms or filters",
    "@catalogDiseaseSearchHint": {},
    "catalogDiseaseNone": "No diseases registered",
    "@catalogDiseaseNone": {},
    "catalogDiseaseInfoGeneral": "General Information",
    "@catalogDiseaseInfoGeneral": {},
    "catalogDiseaseTransDiag": "Transmission and Diagnosis",
    "@catalogDiseaseTransDiag": {},
    "catalogDiseaseMainSymptoms": "Main Symptoms",
    "@catalogDiseaseMainSymptoms": {},
    "catalogDiseasePostmortem": "Post-mortem Lesions",
    "@catalogDiseasePostmortem": {},
    "catalogDiseaseTreatPrev": "Treatment and Prevention",
    "@catalogDiseaseTreatPrev": {},
    "catalogDiseaseNotifOblig": "Mandatory Notification",
    "@catalogDiseaseNotifOblig": {},
    "catalogDiseaseVaccinePrevent": "Preventable by vaccination",
    "@catalogDiseaseVaccinePrevent": {},
    "catalogDiseaseCausalAgent": "Causal Agent",
    "@catalogDiseaseCausalAgent": {},
    "catalogDiseaseContagious": "Contagious",
    "@catalogDiseaseContagious": {},
    "commonYes": "Yes",
    "@commonYes": {},
    "commonNo": "No",
    "@commonNo": {},
    "catalogDiseaseNotification": "Notification",
    "@catalogDiseaseNotification": {},
    "catalogDiseaseVaccineAvail": "Vaccine Available",
    "@catalogDiseaseVaccineAvail": {},
    "catalogDiseaseTransmission": "Transmission",
    "@catalogDiseaseTransmission": {},
    "catalogDiseaseDiagnosis": "Diagnosis",
    "@catalogDiseaseDiagnosis": {},
    "catalogDiseaseViewDetails": "View Details",
    "@catalogDiseaseViewDetails": {},
    "catalogDiseaseConsultVet": "Consult your veterinarian",
    "@catalogDiseaseConsultVet": {},

    "batchNoTransitions": "No transitions available from this state.",
    "@batchNoTransitions": {},
    "batchSelectNewStatusLabel": "Select new status:",
    "@batchSelectNewStatusLabel": {},
    "batchConfirmStatusChange": "Confirm change to {status}?",
    "@batchConfirmStatusChange": {"placeholders": {"status": {"type": "String"}}},
    "batchPermanentStatusWarning": "This status is permanent and cannot be reversed. The batch will not be able to change to any other status after this action.",
    "@batchPermanentStatusWarning": {},
    "batchPermanentStatus": "Permanent status",
    "@batchPermanentStatus": {},

    "batchTypePoultryDesc": "Birds raised for meat production",
    "@batchTypePoultryDesc": {},
    "batchTypeLayersDesc": "Birds raised for egg production",
    "@batchTypeLayersDesc": {},
    "batchTypeHeavyBreedersDesc": "Heavy-line breeder birds",
    "@batchTypeHeavyBreedersDesc": {},
    "batchTypeLightBreedersDesc": "Light-line breeder birds",
    "@batchTypeLightBreedersDesc": {},
    "batchTypeTurkeysDesc": "Turkeys for meat",
    "@batchTypeTurkeysDesc": {},
    "batchTypeQuailDesc": "Quail for eggs or meat",
    "@batchTypeQuailDesc": {},
    "batchTypeDucksDesc": "Ducks for meat",
    "@batchTypeDucksDesc": {},
    "batchTypeOtherDesc": "Other type of bird",
    "@batchTypeOtherDesc": {},
    "batchNotRecorded": "Not recorded",
    "@batchNotRecorded": {},
    "commonBirdsUnit": "birds",
    "@commonBirdsUnit": {},

    "batchAgeDaysValue": "{count} days",
    "@batchAgeDaysValue": {"placeholders": {"count": {"type": "String"}}},
    "batchAgeWeeksDaysValue": "{weeks} weeks ({days} days)",
    "@batchAgeWeeksDaysValue": {"placeholders": {"weeks": {"type": "String"}, "days": {"type": "String"}}},

    "costExpenseType": "Expense type",
    "@costExpenseType": {},
    "costConcept": "Concept",
    "@costConcept": {},
    "costProvider": "Supplier",
    "@costProvider": {},
    "costInvoiceNumber": "Invoice No.",
    "@costInvoiceNumber": {},
    "commonStatus": "Status",
    "@commonStatus": {},
    "costRejectionReason": "Rejection reason",
    "@costRejectionReason": {},
    "commonObservations": "Observations",
    "@commonObservations": {},

    "weightAvgWeight": "Average weight",
    "@weightAvgWeight": {},
    "weightBirdsWeighed": "Birds weighed",
    "@weightBirdsWeighed": {},
    "weightRange": "Weight range",
    "@weightRange": {},
    "weightTotal": "Total weight",
    "@weightTotal": {},
    "weightDailyGain": "ADG (Average daily gain)",
    "@weightDailyGain": {},
    "weightGramsPerDay": "g/day",
    "@weightGramsPerDay": {},
    "weightCoefficientVariation": "Coefficient of variation",
    "@weightCoefficientVariation": {},

    "feedExceedsStock": "The quantity exceeds available stock ({stock} kg)",
    "@feedExceedsStock": {"placeholders": {"stock": {"type": "String"}}},
    "feedStockPercentUsage": "You will use {percent}% of available stock",
    "@feedStockPercentUsage": {"placeholders": {"percent": {"type": "String"}}},
    "feedRecommendedForDays": "Recommended for {days} days: {type}",
    "@feedRecommendedForDays": {"placeholders": {"days": {"type": "String"}, "type": {"type": "String"}}},
    "feedConsumptionDate": "Consumption date",
    "@feedConsumptionDate": {},

    "feedObsTitle": "Observations",
    "@feedObsTitle": {},
    "feedObsOptionalHint": "Optional: Add additional notes",
    "@feedObsOptionalHint": {},
    "feedObsDescribeHint": "Describe supply conditions, bird behavior, feed quality, etc.",
    "@feedObsDescribeHint": {},
    "feedObsHelpText": "Observations help document important details of feed supply and can be useful for future analysis.",
    "@feedObsHelpText": {},

    "ventaFarmLoadError": "Error loading farms",
    "@ventaFarmLoadError": {},
    "ventaSelectFarmHint": "Select a farm",
    "@ventaSelectFarmHint": {},
    "ventaSelectBatchHint": "Select a batch",
    "@ventaSelectBatchHint": {},
    "ventaBatchLoadError": "Error loading batches",
    "@ventaBatchLoadError": {},
    "commonBatch": "Batch",
    "@commonBatch": {},

    "saludRegisteredBy": "Registered by",
    "@saludRegisteredBy": {},
    "saludCloseDate": "Closing Date",
    "@saludCloseDate": {},
    "saludCloseTreatment": "Close Treatment",
    "@saludCloseTreatment": {},
    "saludResultOptional": "Result (Optional)",
    "@saludResultOptional": {},
    "saludMonthNames": "January,February,March,April,May,June,July,August,September,October,November,December",
    "@saludMonthNames": {},
    "saludDateConnector": "of",
    "@saludDateConnector": {},

    "treatDurationValidation": "Duration must be between 1 and 365 days",
    "@treatDurationValidation": {},
    "commonDateCannotBeFuture": "Date cannot be in the future",
    "@commonDateCannotBeFuture": {},
    "treatRegisteredInventoryError": "Treatment registered, but there was an error updating inventory",
    "@treatRegisteredInventoryError": {},
    "treatNewTreatment": "New Treatment",
    "@treatNewTreatment": {},
    "commonNext": "Next",
    "@commonNext": {},
    "commonSaveAction": "Save",
    "@commonSaveAction": {},
    "commonPrevious": "Previous",
    "@commonPrevious": {},

    "costRegisteredInventoryError": "Cost registered, but there was an error updating inventory",
    "@costRegisteredInventoryError": {},
    "costsEditCost": "Edit Cost",
    "@costsEditCost": {},
    "costRegisterCost": "Register Cost",
    "@costRegisterCost": {},
    "commonUpdate": "Update",
    "@commonUpdate": {},
    "commonRegister": "Register",
    "@commonRegister": {},

    "invStockActualLabel": "Current: {stock} {unit}",
    "@invStockActualLabel": {"placeholders": {"stock": {"type": "String"}, "unit": {"type": "String"}}},
    "invStockMinimoLabel": "Minimum: {stock} {unit}",
    "@invStockMinimoLabel": {"placeholders": {"stock": {"type": "String"}, "unit": {"type": "String"}}},

    "invEntryError": "Error registering inventory entry",
    "@invEntryError": {},
    "invExitError": "Error registering inventory exit",
    "@invExitError": {},

    "feedLoadingItems": "Loading feed items...",
    "@feedLoadingItems": {},
    "feedLoadError": "Error loading feed items",
    "@feedLoadError": {},

    "photoNoPhotosAdded": "No photos added",
    "@photoNoPhotosAdded": {},
    "photoMax5Hint": "You can add up to 5 photos",
    "@photoMax5Hint": {},

    "farmPoultryFarm": "Poultry Farm",
    "@farmPoultryFarm": {},
    "farmNoAddress": "No address",
    "@farmNoAddress": {},

    "shedAddTagHint": "Add tag",
    "@shedAddTagHint": {},
    "shedCapacityHintExample": "E.g.: 1000",
    "@shedCapacityHintExample": {},

    "prodObsHint": "Describe egg quality, shell color, environmental conditions, bird behavior, etc.",
    "@prodObsHint": {},

    "commonType": "Type",
    "@commonType": {},
    "commonBirds": "Birds",
    "@commonBirds": {},
    "commonAge": "Age",
    "@commonAge": {},

    "batchQuantityValidation": "Enter a valid quantity greater than 0",
    "@batchQuantityValidation": {},

    "invStockBajoMinimo": "Low stock (minimum: {min} {unit})",
    "@invStockBajoMinimo": {"placeholders": {"min": {"type": "String"}, "unit": {"type": "String"}}},
    "invExpiresInDays": "Expires in {days} days",
    "@invExpiresInDays": {"placeholders": {"days": {"type": "String"}}},

    "ventaDiscountPercent": "Discount ({percent}%)",
    "@ventaDiscountPercent": {"placeholders": {"percent": {"type": "String"}}},

    "reportsPeriodLabel": "Period: {period}",
    "@reportsPeriodLabel": {"placeholders": {"period": {"type": "String"}}},
    "reportsPeriodSameMonth": "{dayStart} to {dayEnd} of {month} {year}",
    "@reportsPeriodSameMonth": {"placeholders": {"dayStart": {"type": "String"}, "dayEnd": {"type": "String"}, "month": {"type": "String"}, "year": {"type": "String"}}},
    "reportsPeriodSameYear": "{dayStart} of {monthStart} to {dayEnd} of {monthEnd}, {year}",
    "@reportsPeriodSameYear": {"placeholders": {"dayStart": {"type": "String"}, "monthStart": {"type": "String"}, "dayEnd": {"type": "String"}, "monthEnd": {"type": "String"}, "year": {"type": "String"}}},
    "reportsPeriodDateRange": "{start} to {end}",
    "@reportsPeriodDateRange": {"placeholders": {"start": {"type": "String"}, "end": {"type": "String"}}},

    "commonFieldRequired": "This field is required",
    "@commonFieldRequired": {},

    "commonMoreOptions": "More options",
    "@commonMoreOptions": {},
}

es_path = r"c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n\app_es.arb"
en_path = r"c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n\app_en.arb"

add_keys(es_path, es_keys)
add_keys(en_path, en_keys)
print("Done!")
