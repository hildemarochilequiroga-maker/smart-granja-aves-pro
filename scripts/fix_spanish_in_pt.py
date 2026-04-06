#!/usr/bin/env python3
"""
Fix all 162 keys with Spanish remnants in app_pt.arb.
Provides complete Portuguese translations instead of word-by-word hybrids.
"""
import json
import sys
import os

sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
L10N_DIR = os.path.join(BASE_DIR, 'lib', 'l10n')

FIXES = {
    "authLinkAccountMessage": "Você já tem uma conta com este email usando {existingProvider}.\n\nDeseja vincular sua conta de {newProvider} para poder acessar com ambos os métodos?",
    "authLinkSuccess": "Conta de {provider} vinculada com sucesso!",
    "authSendInstructions": "Enviar instruções",
    "batchAdjustFilters": "Tente ajustar os filtros ou buscar com outros termos",
    "batchCloseConfirmation": "Tem certeza de que deseja encerrar o lote \"{code}\"?",
    "batchCloseIrreversibleWarning": "Esta ação é IRREVERSÍVEL. O lote passará ao status encerrado e o galpão ficará disponível.\n\nTem certeza de que deseja encerrar este lote?",
    "batchConfirmExit": "Deseja sair?",
    "batchCreateSuccess": "Lote criado com sucesso!",
    "batchDeleteMessage": "O lote \"{code}\" e todos os seus registros serão excluídos. Esta ação não pode ser desfeita.",
    "batchDraftFoundGeneric": "Foi encontrado um rascunho salvo. Deseja restaurá-lo?",
    "batchDraftMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "batchExitWithoutComplete": "Sair sem completar?",
    "batchExitWithoutSaving": "Sair sem salvar as alterações?",
    "batchFirebasePermissionDenied": "Você não tem permissões para realizar esta ação",
    "batchFormWeightObsHint": "Descreva as condições da pesagem, comportamento das aves, condições ambientais, etc.",
    "batchHighBreakageMessage": "A porcentagem de quebra é {percent}% ({count} ovos), que é superior aos 5% esperados. Deseja continuar?",
    "batchHighLayingMessage": "A porcentagem de postura é {percent}%, que é excepcionalmente alta. Deseja continuar com estes dados?",
    "batchHighLayingTitle": "Porcentagem de postura muito alta",
    "batchHistoryNoRecordsDesc": "Não há registros para exibir",
    "batchNoPermissionMortality": "Você não tem permissões para registrar mortalidade nesta granja",
    "batchNoPermissionProduction": "Você não tem permissões para registrar produção nesta granja",
    "batchNoPermissionRecord": "Você não tem permissões para registrar consumo nesta granja",
    "batchNoPermissionWeight": "Você não tem permissões para registrar pesagens nesta granja",
    "batchPermanentStatusWarning": "Este status é permanente e não poderá ser revertido. O lote não poderá mudar para nenhum outro status após esta ação.",
    "batchQuarantineConfirm": "Tem certeza de que deseja colocar \"{code}\" em quarentena?",
    "batchRegisterFirst": "Registre seu primeiro lote de aves para começar a monitorar sua produção",
    "batchSearchHint": "Buscar por nome, código ou tipo...",
    "batchSellConfirm": "Registrar a venda completa do lote \"{code}\"?",
    "batchTransferConfirm": "Transferir \"{code}\" para o galpão {shed}?",
    "batchUpdateSuccess": "Lote atualizado com sucesso!",
    "bioEmptyDescription": "Inicie a primeira inspeção de biossegurança para {farmName} e mantenha um registro contínuo do cumprimento sanitário.",
    "bioInspectionExitTitle": "Sair sem completar?",
    "bioRatingVeryGood": "Muito Bom",
    "bioSummaryPendingNote": "Você pode salvar, mas a pontuação só reflete o que foi avaliado.",
    "commonAdjustFilters": "Tente ajustar os filtros ou buscar com outros termos",
    "commonChangeStatus": "Alterar status",
    "commonDraftRestoreMessage": "Deseja restaurar o rascunho salvo anteriormente?",
    "commonExitWithoutComplete": "Sair sem completar?",
    "commonExitWithoutCompleting": "Sair sem completar?",
    "commonExitWithoutSaving": "Sair sem salvar?",
    "commonSearchByNameCityAddress": "Buscar por nome, cidade ou endereço...",
    "commonYouHaveUnsavedChanges": "Você tem alterações não salvas.",
    "costDeleteConfirm": "Excluir Custo?",
    "costDeleteConfirmMessage": "Tem certeza de que deseja excluir este custo?\n\nEsta ação não pode ser desfeita.",
    "costDeleteMessage": "Tem certeza de que deseja excluir o custo \"{concept}\"?\n\nEsta ação não pode ser desfeita.",
    "costDraftRestoreMessage": "Deseja restaurar o rascunho salvo anteriormente?",
    "costExitConfirm": "Sair sem completar?",
    "costSearchInventory": "Buscar no inventário (opcional)...",
    "costoDeleteConfirm": "Tem certeza de que deseja excluir o custo \"{name}\"?\n\nEsta ação não pode ser desfeita.",
    "costoDetailDeleteConfirm": "Tem certeza de que deseja excluir este custo?",
    "costoDraftFoundMessage": "Deseja restaurar o rascunho salvo anteriormente?",
    "costoFilterEmptyDescription": "Tente ajustar os filtros ou buscar com outros termos",
    "costoInventoryLinkInfo": "Você pode vincular este gasto a um produto do inventário para atualizar o estoque automaticamente.",
    "costoInventorySearchHint": "Buscar no inventário (opcional)...",
    "costoItemCreated": "Item \"{name}\" criado!",
    "costoNoCreatePermission": "Você não tem permissão para registrar custos nesta granja",
    "costoNoEditPermission": "Você não tem permissão para editar custos nesta granja",
    "diseaseCatalogSearchHint": "Buscar doença, sintoma...",
    "draftFoundMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "enumTipoAlimentoDescCrecimiento": "Crescimento (22-35 dias)",
    "farmActivateConfirm": "Ativar \"{name}\"?",
    "farmActivateConfirmMsg": "Ativar \"{name}\"?",
    "farmCannotChangeOwnerRole": "Não é possível alterar a função do proprietário",
    "farmCreatedSuccess": "Granja \"{name}\" criada!",
    "farmDeleteConfirmName": "Excluir \"{name}\"?",
    "farmDraftFoundMsg": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "farmErrorChangingStatus": "Erro ao alterar o status: {error}",
    "farmInvitationMessage": "Convido você a colaborar na minha granja \"{farmName}\"! Use o código: {code}\nFunção: {role}\nVálido até: {expiry}",
    "farmMaintenanceConfirm": "Colocar \"{name}\" em manutenção?",
    "farmMaintenanceConfirmMsg": "Colocar \"{name}\" em manutenção?",
    "farmNoFarmsFoundHint": "Tente ajustar os filtros ou buscar com outros termos",
    "farmNoPermToInvite": "Você não tem permissões para convidar usuários para esta granja.\nApenas proprietários, administradores e gestores podem convidar.",
    "farmSearchHint": "Buscar por nome, cidade ou endereço...",
    "farmUpdatedSuccess": "Granja \"{name}\" atualizada!",
    "feedObsDescribeHint": "Descreva as condições do fornecimento, comportamento das aves, qualidade da ração, etc.",
    "feedTypeDescGrower": "Crescimento (22-35 dias)",
    "healthSearchDisease": "Buscar doença, sintoma...",
    "healthSymptomsHint": "Descreva os sintomas: tosse, espirros, prostração...",
    "invCanAddPhoto": "Você pode adicionar uma foto do produto",
    "invCanAddProductPhoto": "Você pode adicionar uma foto do produto",
    "invConfirmDeleteItemName": "Tem certeza de que deseja excluir {name}?",
    "invDraftFoundMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "invItemCreated": "Item \"{name}\" criado!",
    "invNoMovementsMatchSearch": "Não há movimentos que correspondam à sua busca",
    "invSearchByNameOrCode": "Buscar por nome ou código...",
    "invSearchInventory": "Buscar no inventário...",
    "invSearchProduct": "Buscar produto...",
    "invStockAlertDescription": "Configure o estoque mínimo para receber alertas quando o inventário estiver baixo.",
    "inventoryNoMovementsSearch": "Não há movimentos que correspondam à sua busca",
    "inventorySearchHint": "Buscar por nome ou código...",
    "inventorySearchProduct": "Buscar no inventário...",
    "inventorySearchProductShort": "Buscar produto...",
    "mortalityRegistered": "Mortalidade registrada!",
    "noPermissionCreateCosts": "Você não tem permissão para registrar custos nesta granja",
    "noPermissionEditCosts": "Você não tem permissão para editar custos nesta granja",
    "notifDeleteReadConfirm": "Deseja excluir todas as notificações lidas?",
    "notifMsgClosesToday": "A data de encerramento é hoje!",
    "notifMsgExpiresToday": "Vence hoje!",
    "notifMsgStockEmpty": "Estoque zerado, requer reabastecimento urgente",
    "photoMax5Hint": "Você pode adicionar até 5 fotos",
    "prodObsHint": "Descreva a qualidade dos ovos, cor da casca, condições ambientais, comportamento das aves, etc.",
    "productionRegistered": "Produção registrada!",
    "profileSendFeedback": "Enviar Sugestão",
    "salesDraftRestore": "Deseja restaurar o rascunho de venda salvo anteriormente?",
    "salesNoCreatePermission": "Você não tem permissão para registrar vendas nesta granja",
    "salesNoEditPermission": "Você não tem permissão para editar vendas nesta granja",
    "salesRegisteredSuccess": "Venda registrada com sucesso!",
    "saludDeleteConfirmMsg": "O registro de \"{name}\" será excluído. Esta ação não pode ser desfeita.",
    "saludDeleteDetail": "O registro de \"{name}\" será excluído. Esta ação não pode ser desfeita.",
    "saludDeleteRecordMessage": "O registro \"{diagnosis}\" será excluído. Esta ação não pode ser desfeita.",
    "saludDeleteRecordTitle": "Excluir registro?",
    "saludDeleteTitle": "Excluir registro?",
    "saludDetailDeleteTitle": "Excluir registro?",
    "saludEmptyDescription": "Registre tratamentos, diagnósticos e acompanhamento sanitário do lote",
    "saludVacDraftMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "settingsSendLink": "Enviar link",
    "shedActivateConfirm": "Ativar \"{name}\"?",
    "shedAvailableForNewBatch": "Este galpão está disponível para receber um novo lote",
    "shedCapacityTooHigh": "A capacidade parece muito alta",
    "shedChangeStateAction": "Alterar status",
    "shedChangeStatus": "Alterar status",
    "shedCreatedSuccess": "Galpão \"{name}\" criado!",
    "shedDeleteConfirmMsg": "Excluir \"{name}\"?",
    "shedDisinfectionConfirm": "Colocar \"{name}\" em desinfecção?",
    "shedDisinfectionMessage": "Colocar \"{name}\" em desinfecção?",
    "shedDraftFoundMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "shedErrorChangingStatus": "Erro ao alterar o status: {error}",
    "shedExitWithoutCompleting": "Sair sem completar?",
    "shedMaintenanceConfirm": "Colocar \"{name}\" em manutenção?",
    "shedSearchHint": "Buscar por nome, código ou tipo...",
    "shedSearchInventory": "Buscar no inventário...",
    "shedSpecsDesc": "Configure a capacidade e o equipamento do galpão",
    "shedUpdatedSuccess": "Galpão \"{name}\" atualizado!",
    "treatDraftFoundMessage": "Deseja restaurar o rascunho do tratamento salvo anteriormente?",
    "treatDraftMessage": "Deseja restaurar o rascunho do tratamento salvo anteriormente?",
    "treatStepAdditionalImportantMsg": "Estes campos são opcionais, mas ajudam em um melhor acompanhamento do tratamento.",
    "treatStepSymptomsHint": "Descreva os sintomas: tosse, espirros, prostração...",
    "vacDeleteTitle": "Excluir vacinação?",
    "vacDetailDeleteMessage": "A vacinação \"{nombre}\" será excluída. Esta ação não pode ser desfeita.",
    "vacDetailDeleteTitle": "Excluir vacinação?",
    "vacDraftFoundMsg": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "vacFormDraftMessage": "Foi encontrado um rascunho salvo de {date}.\nDeseja restaurá-lo?",
    "vacFormSuccess": "Vacinação programada com sucesso!",
    "vacScheduledSuccess": "Vacinação programada com sucesso!",
    "vacStepAppObsDesc": "Registre quando foi aplicada e adicione observações",
    "vacSummaryExpiredWarning": "Atenção! Há vacinas vencidas",
    "validateDateTooOld": "A data de entrada parece muito antiga (mais de 5 anos)",
    "ventaCreateSuccess": "Venda registrada com sucesso!",
    "ventaDeleteMessage": "A venda de {product} será excluída. Esta ação não pode ser desfeita.",
    "ventaDraftFoundMessage": "Deseja restaurar o rascunho de venda salvo anteriormente?",
    "ventaDraftMessage": "Deseja restaurar o rascunho de venda salvo anteriormente?",
    "ventaEmptyDescription": "Registre sua primeira venda para começar a controlar seus ganhos",
    "ventaNoCreatePermission": "Você não tem permissão para registrar vendas nesta granja",
    "ventaNoEditPermission": "Você não tem permissão para editar vendas nesta granja",
    "ventaStepProductQuestion": "Que tipo de produto você vende?",
    "weightRegistered": "Pesagem registrada!",
    "whatsappHelp": "Olá! Preciso de ajuda com o app Smart Granja Aves. ",
    "whatsappMsgPricing": "Olá! Gostaria de conhecer os planos e preços do Smart Granja Aves. ",
    "whatsappMsgSuggest": "Olá! Tenho uma sugestão para o app Smart Granja Aves: ",
    "whatsappMsgSupport": "Olá! Preciso de ajuda com o app Smart Granja Aves. ",
    "whatsappPricing": "Olá! Gostaria de conhecer os planos e preços do Smart Granja Aves. ",
    "whatsappSuggestion": "Olá! Tenho uma sugestão para o app Smart Granja Aves: ",
}


def main():
    arb_path = os.path.join(L10N_DIR, 'app_pt.arb')
    with open(arb_path, 'r', encoding='utf-8') as f:
        pt = json.load(f)

    fixed = 0
    for key, new_val in FIXES.items():
        if key in pt:
            old_val = pt[key]
            if old_val != new_val:
                pt[key] = new_val
                fixed += 1

    # Write back
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(pt, f, ensure_ascii=False, indent=2)
        f.write('\n')

    print(f"[OK] Fixed {fixed} keys in app_pt.arb")
    print(f"Total keys in file: {sum(1 for k in pt if not k.startswith('@') and k != '@@locale')}")


if __name__ == '__main__':
    main()
