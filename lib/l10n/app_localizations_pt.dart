// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Smart Granja Aves Pro';

  @override
  String get navHome => 'Início';

  @override
  String get navManagement => 'Gestão';

  @override
  String get navBatches => 'Lotes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String commonHintExample(String value) {
    return 'Ex: $value';
  }

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonAccept => 'Aceitar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonSearch => 'Buscar...';

  @override
  String get commonGoHome => 'Ir ao início';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonApplyFilters => 'Aplicar filtros';

  @override
  String get commonClearFilters => 'Limpar filtros';

  @override
  String get commonClear => 'Limpar';

  @override
  String get commonNoResults => 'Nenhum resultado encontrado';

  @override
  String get commonNoResultsHint => 'Tente modificar os filtros de busca';

  @override
  String get commonSomethingWentWrong => 'Algo deu errado';

  @override
  String get commonErrorOccurred => 'Ocorreu um erro';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonOr => 'ou';

  @override
  String get connectivityOffline => 'Sem conexão com a internet';

  @override
  String get connectivityOfflineShort => 'Offline';

  @override
  String get connectivityOfflineBanner => 'Offline - Dados salvos localmente';

  @override
  String get connectivityOfflineMode => 'Modo offline';

  @override
  String get connectivityOfflineDataWarning =>
      'Sem conexão com a internet. Os dados podem não estar atualizados';

  @override
  String get errorServer => 'Erro do servidor';

  @override
  String get errorCacheNotFound => 'Dados não encontrados no cache';

  @override
  String get errorNoConnection => 'Sem conexão com a internet';

  @override
  String get errorTimeout => 'Tempo de solicitação esgotado';

  @override
  String get errorInvalidCredentials => 'Credenciais inválidas';

  @override
  String get errorSessionExpired => 'Sua sessão expirou';

  @override
  String get errorNoPermission => 'Você não tem permissão para esta ação';

  @override
  String get errorWriteCache => 'Erro ao gravar no cache';

  @override
  String get errorNoSession => 'Nenhuma sessão ativa';

  @override
  String get errorInvalidEmail => 'Endereço de e-mail inválido';

  @override
  String get errorReadFile => 'Erro ao ler arquivo';

  @override
  String get errorWriteFile => 'Erro ao gravar arquivo';

  @override
  String get errorDeleteFile => 'Erro ao excluir arquivo';

  @override
  String get errorVerifyPermissions => 'Erro ao verificar permissões';

  @override
  String get errorLoadingActivities => 'Erro ao carregar atividades';

  @override
  String get permNoCreateRecords =>
      'Você não tem permissão para criar registros';

  @override
  String get permNoEditRecords =>
      'Você não tem permissão para editar registros';

  @override
  String get permNoDeleteRecords =>
      'Você não tem permissão para excluir registros';

  @override
  String get permNoCreateBatches => 'Você não tem permissão para criar lotes';

  @override
  String get permNoEditBatches => 'Você não tem permissão para editar lotes';

  @override
  String get permNoDeleteBatches => 'Você não tem permissão para excluir lotes';

  @override
  String get permNoCreateSheds => 'Você não tem permissão para criar galpões';

  @override
  String get permNoEditSheds => 'Você não tem permissão para editar galpões';

  @override
  String get permNoDeleteSheds => 'Você não tem permissão para excluir galpões';

  @override
  String get permNoInviteUsers =>
      'Você não tem permissão para convidar usuários';

  @override
  String get permNoChangeRoles => 'Você não tem permissão para alterar funções';

  @override
  String get permNoRemoveUsers =>
      'Você não tem permissão para remover usuários';

  @override
  String get permNoViewCollaborators =>
      'Você não tem permissão para ver colaboradores';

  @override
  String get permNoEditFarm => 'Você não tem permissão para editar a granja';

  @override
  String get permNoDeleteFarm => 'Você não tem permissão para excluir a granja';

  @override
  String get permNoViewReports => 'Você não tem permissão para ver relatórios';

  @override
  String get permNoExportData => 'Você não tem permissão para exportar dados';

  @override
  String get permNoManageInventory =>
      'Você não tem permissão para gerenciar inventário';

  @override
  String get permNoRegisterSales =>
      'Você não tem permissão para registrar vendas';

  @override
  String get permNoViewSettings =>
      'Você não tem permissão para ver a configuração';

  @override
  String get authGateManageSmartly =>
      'Gerencie sua granja de forma inteligente';

  @override
  String get authCreateAccount => 'Criar conta';

  @override
  String get authAlreadyHaveAccount => 'Já tenho conta';

  @override
  String get authOrContinueWith => 'ou continue com';

  @override
  String get authWelcomeBack => 'Bem-vindo de volta';

  @override
  String get authEnterCredentials => 'Insira suas credenciais para continuar';

  @override
  String get authOrSignInWithEmail => 'ou entre com e-mail';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authForgotPassword => 'Esqueceu sua senha?';

  @override
  String get authNoAccount => 'Não tem conta?';

  @override
  String get authSignUp => 'Cadastrar-se';

  @override
  String get authEmailRequired => 'O e-mail é obrigatório';

  @override
  String get authEmailInvalid => 'Insira um endereço de e-mail válido';

  @override
  String get authPasswordRequired => 'A senha é obrigatória';

  @override
  String get authPasswordMinLength =>
      'A senha deve ter pelo menos 8 caracteres';

  @override
  String get authJoinToManage =>
      'Junte-se para gerenciar sua granja de forma inteligente';

  @override
  String get authSignUpWithGoogle => 'Cadastrar-se com Google';

  @override
  String get authOrSignUpWithEmail => 'ou cadastre-se com e-mail';

  @override
  String get authFirstName => 'Nome';

  @override
  String get authLastName => 'Sobrenome';

  @override
  String get authPassword => 'Senha';

  @override
  String get authConfirmPassword => 'Confirmar senha';

  @override
  String get authMustAcceptTerms => 'Você deve aceitar os termos e condições';

  @override
  String get authTermsAndConditions => 'Termos e Condições';

  @override
  String get authCheckEmail => 'Verifique seu e-mail!';

  @override
  String get authForgotPasswordTitle => 'Esqueceu sua senha?';

  @override
  String get authResetLinkSent => 'Enviamos um link para redefinir sua senha';

  @override
  String get authEnterEmailForReset =>
      'Insira seu e-mail e enviaremos instruções';

  @override
  String get authSendInstructions => 'Enviar instruções';

  @override
  String get authRememberPassword => 'Lembrou sua senha?';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authContinueWithApple => 'Continuar com Apple';

  @override
  String get authContinueWithFacebook => 'Continuar com Facebook';

  @override
  String get authContinue => 'Continuar';

  @override
  String get authEnterPassword => 'Insira sua senha';

  @override
  String get authCurrentPassword => 'Senha atual';

  @override
  String get authSignOut => 'Sair';

  @override
  String get homeQuickActions => 'Ações Rápidas';

  @override
  String get homeVaccination => 'Vacinação';

  @override
  String get homeDiseases => 'Doenças';

  @override
  String get homeBiosecurity => 'Biossegurança';

  @override
  String get homeSales => 'Vendas';

  @override
  String get homeCosts => 'Custos';

  @override
  String get homeInventory => 'Inventário';

  @override
  String get homeSelectFarmFirst => 'Selecione uma granja primeiro';

  @override
  String get homeGeneralStats => 'Estatísticas Gerais';

  @override
  String get homeAvailableSheds => 'Galpões Disponíveis';

  @override
  String get homeActiveBatches => 'Lotes Ativos';

  @override
  String get homeTotalBirds => 'Aves Totais';

  @override
  String get homeOccupancy => 'Ocupação';

  @override
  String get homeNoSheds => 'Sem galpões';

  @override
  String get homeNoBatches => 'Sem lotes';

  @override
  String get homeAcrossFarm => 'Em toda a granja';

  @override
  String get homeExpiringSoon => 'Próximo a vencer';

  @override
  String get homeHighMortality => 'Mortalidade elevada';

  @override
  String get homeNoActiveBatches => 'Sem lotes ativos';

  @override
  String get homeCreateBatchToStart => 'Crie um lote para começar a registrar';

  @override
  String get homeGreetingMorning => 'Bom dia';

  @override
  String get homeGreetingAfternoon => 'Boa tarde';

  @override
  String get homeGreetingEvening => 'Boa noite';

  @override
  String get homeHello => 'Olá';

  @override
  String get profileMyAccount => 'Minha Conta';

  @override
  String get profileUser => 'Usuário';

  @override
  String get profileCollaboration => 'Colaboração';

  @override
  String get profileInviteToFarm => 'Convidar para minha Granja';

  @override
  String get profileShareAccess => 'Compartilhe acesso com outros usuários';

  @override
  String get profileAcceptInvitation => 'Aceitar Convite';

  @override
  String get profileJoinFarm => 'Junte-se à granja de outra pessoa';

  @override
  String get profileManageCollaborators => 'Gerenciar Colaboradores';

  @override
  String get profileViewManageAccess => 'Ver e gerenciar acessos';

  @override
  String get profileSettings => 'Configurações';

  @override
  String get profileNotifications => 'Notificações';

  @override
  String get profileConfigureAlerts => 'Configure alertas e lembretes';

  @override
  String get profileGeneralSettings => 'Configurações Gerais';

  @override
  String get profileAppPreferences => 'Preferências do aplicativo';

  @override
  String get profileHelpSupport => 'Ajuda e Suporte';

  @override
  String get profileHelpCenter => 'Central de Ajuda';

  @override
  String get profileFaqGuides => 'Perguntas frequentes e guias';

  @override
  String get profileSendFeedback => 'Enviar Sugestão';

  @override
  String get profileShareIdeas => 'Compartilhe suas ideias conosco';

  @override
  String get profileAbout => 'Sobre';

  @override
  String get profileAppInfo => 'Informações do aplicativo';

  @override
  String get profileSelectFarmToInvite => 'Selecione a granja para convidar';

  @override
  String get profileSelectFarm => 'Selecione uma granja';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguageSubtitle => 'Altere o idioma do aplicativo';

  @override
  String get profileCurrency => 'Moeda';

  @override
  String get profileCurrencySubtitle => 'Selecione a moeda do seu país';

  @override
  String get salesNoSales => 'Sem vendas registradas';

  @override
  String get salesNotFound => 'Nenhuma venda encontrada';

  @override
  String get salesRegisterFirst => 'Registrar primeira venda';

  @override
  String get salesRegisterNew => 'Registrar nova venda';

  @override
  String get salesDeleteConfirm => 'Excluir venda?';

  @override
  String get salesProductType => 'Tipo de produto';

  @override
  String get salesStatus => 'Status da venda';

  @override
  String get salesNewSale => 'Nova Venda';

  @override
  String get salesEditSale => 'Editar Venda';

  @override
  String get farmFarm => 'Granja';

  @override
  String get farmFarms => 'Granjas';

  @override
  String get farmNewFarm => 'Nova Granja';

  @override
  String get farmEditFarm => 'Editar Granja';

  @override
  String get farmDeleteConfirm => 'Excluir granja?';

  @override
  String get shedShed => 'Galpão';

  @override
  String get shedSheds => 'Galpões';

  @override
  String get shedNewShed => 'Novo Galpão';

  @override
  String get shedEditShed => 'Editar Galpão';

  @override
  String get shedDeleteConfirm => 'Excluir galpão?';

  @override
  String get batchBatch => 'Lote';

  @override
  String get batchBatches => 'Lotes';

  @override
  String get batchNewBatch => 'Novo Lote';

  @override
  String get batchEditBatch => 'Editar Lote';

  @override
  String get batchDeleteConfirm => 'Excluir lote?';

  @override
  String get batchActive => 'Ativo';

  @override
  String get batchFinished => 'Finalizado';

  @override
  String get healthDiseases => 'Doenças';

  @override
  String get healthSymptoms => 'Sintomas';

  @override
  String get healthTreatment => 'Tratamento';

  @override
  String get healthPrevention => 'Prevenção';

  @override
  String get healthVaccineAvailable => 'Vacina disponível';

  @override
  String get healthMandatoryNotification => 'Notificação obrigatória';

  @override
  String get healthPreventableByVaccine => 'Prevenível por vacinação';

  @override
  String get inventoryInventory => 'Inventário';

  @override
  String get inventoryMedicines => 'Medicamentos';

  @override
  String get inventoryVaccines => 'Vacinas';

  @override
  String get inventoryFood => 'Ração';

  @override
  String get costsTitle => 'Custos';

  @override
  String get costsNewCost => 'Novo Custo';

  @override
  String get costsEditCost => 'Editar Custo';

  @override
  String get reportsTitle => 'Relatórios';

  @override
  String get reportsGenerate => 'Gerar relatório';

  @override
  String get reportsGenerating => 'Gerando relatório...';

  @override
  String get reportsSharePdf => 'Compartilhar PDF';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsEmpty => 'Sem notificações';

  @override
  String get mortalityTitle => 'Mortalidade';

  @override
  String get mortalityRegister => 'Registrar mortalidade';

  @override
  String get mortalityRate => 'Taxa de mortalidade';

  @override
  String get mortalityTotal => 'Mortalidade total';

  @override
  String get weightTitle => 'Peso';

  @override
  String get weightRegister => 'Registrar peso';

  @override
  String get weightAverage => 'Peso médio';

  @override
  String get feedTitle => 'Alimentação';

  @override
  String get feedRegister => 'Registrar alimentação';

  @override
  String get feedDailyConsumption => 'Consumo diário';

  @override
  String get waterTitle => 'Água';

  @override
  String get waterRegister => 'Registrar água';

  @override
  String get waterDailyConsumption => 'Consumo diário';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonDetails => 'Detalhes';

  @override
  String get commonFilter => 'Filtrar';

  @override
  String get commonMoreOptions => 'Mais opções';

  @override
  String get commonClearSearch => 'Limpar busca';

  @override
  String get commonAll => 'Todos';

  @override
  String get commonAllTypes => 'Todos os tipos';

  @override
  String get commonAllStatuses => 'Todos os estados';

  @override
  String get commonDiscard => 'Descartar';

  @override
  String get commonComingSoon => 'Em breve';

  @override
  String get commonUnsavedChanges => 'Alterações não salvas';

  @override
  String get commonExitWithoutSave => 'Deseja sair sem salvar as alterações?';

  @override
  String get commonExit => 'Sair';

  @override
  String get commonDontWorryDataSafe =>
      'Não se preocupe, seus dados estão seguros.';

  @override
  String get commonObservations => 'Observações';

  @override
  String get commonDescription => 'Descrição';

  @override
  String get commonDate => 'Data';

  @override
  String get commonName => 'Nome';

  @override
  String get commonPhone => 'Telefone';

  @override
  String get commonProvider => 'Fornecedor';

  @override
  String get commonLocation => 'Localização';

  @override
  String get commonActive => 'Ativo';

  @override
  String get commonInactive => 'Inativo';

  @override
  String get commonPending => 'Pendentes';

  @override
  String get commonApproved => 'Aprovados';

  @override
  String get commonTotal => 'Total:';

  @override
  String get commonInformation => 'Informações';

  @override
  String get commonSummary => 'Resumo';

  @override
  String get commonBasicInfo => 'Informações Básicas';

  @override
  String get commonAdditionalInfo => 'Informações Adicionais';

  @override
  String get commonNotFound => 'Não encontrado';

  @override
  String get commonError => 'Erro';

  @override
  String commonErrorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get profileLoadingFarms => 'Carregando granjas...';

  @override
  String get commonSuccess => 'Sucesso';

  @override
  String get commonRegisteredBy => 'Registrado por';

  @override
  String get commonRole => 'Função';

  @override
  String get commonRegistrationDate => 'Data de registro';

  @override
  String get authEmailHint => 'exemplo@email.com';

  @override
  String get authFirstNameHint => 'João';

  @override
  String get authLastNameHint => 'Silva';

  @override
  String get authRememberEmail => 'Lembrar e-mail';

  @override
  String get authAlreadyHaveAccountLink => 'Já tem conta?';

  @override
  String get authSignInLink => 'Entrar';

  @override
  String get authAcceptTermsPrefix => 'Eu aceito os ';

  @override
  String get authPrivacyPolicy => 'Política de Privacidade';

  @override
  String get authAndThe => ' e a ';

  @override
  String get authMinChars => 'Mínimo 8 caracteres';

  @override
  String get authOneUppercase => 'Uma letra maiúscula';

  @override
  String get authOneLowercase => 'Uma letra minúscula';

  @override
  String get authOneNumber => 'Um número';

  @override
  String get authOneSpecialChar => 'Um caractere especial';

  @override
  String get authPasswordWeak => 'Fraca';

  @override
  String get authPasswordMedium => 'Média';

  @override
  String get authPasswordStrong => 'Forte';

  @override
  String get authPasswordConfirmRequired => 'Confirme sua senha';

  @override
  String get authPasswordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get authPasswordMustContainUpper =>
      'Deve conter pelo menos uma letra maiúscula';

  @override
  String get authPasswordMustContainLower =>
      'Deve conter pelo menos uma letra minúscula';

  @override
  String get authPasswordMustContainNumber =>
      'Deve conter pelo menos um número';

  @override
  String get authLinkAccounts => 'Vincular Contas';

  @override
  String authLinkAccountMessage(String existingProvider, String newProvider) {
    return 'Você já tem uma conta com este email usando $existingProvider.\n\nDeseja vincular sua conta de $newProvider para poder acessar com ambos os métodos?';
  }

  @override
  String authLinkSuccess(String provider) {
    return 'Conta de $provider vinculada com sucesso!';
  }

  @override
  String get authLinkButton => 'Vincular';

  @override
  String get authSentTo => 'Enviado para:';

  @override
  String get authCheckSpam =>
      'Se não encontrar o e-mail, verifique sua pasta de spam';

  @override
  String get authResendEmail => 'Reenviar e-mail';

  @override
  String get authBackToLogin => 'Voltar ao login';

  @override
  String get authEmailPasswordProvider => 'E-mail e Senha';

  @override
  String get authPasswordMinLengthSix =>
      'A senha deve ter pelo menos 6 caracteres';

  @override
  String authPasswordMinLengthN(String count) {
    return 'A senha deve ter pelo menos $count caracteres';
  }

  @override
  String authPasswordMinLengthValidator(Object count) {
    return 'Mínimo $count caracteres';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsDarkMode => 'Modo escuro';

  @override
  String get settingsDarkModeSubtitle => 'Altere o tema do aplicativo';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsPushNotifications => 'Notificações push';

  @override
  String get settingsPushSubtitle => 'Receba alertas importantes';

  @override
  String get settingsSounds => 'Sons';

  @override
  String get settingsSoundsSubtitle => 'Reproduza sons de notificação';

  @override
  String get settingsVibration => 'Vibração';

  @override
  String get settingsVibrationSubtitle => 'Vibrar ao receber notificações';

  @override
  String get settingsConfigureAlerts => 'Configurar alertas';

  @override
  String get settingsConfigureAlertsSubtitle =>
      'Personalize quais alertas receber';

  @override
  String get settingsDataStorage => 'Dados e Armazenamento';

  @override
  String get settingsClearCache => 'Limpar cache';

  @override
  String get settingsClearCacheSubtitle => 'Libere espaço no dispositivo';

  @override
  String get settingsSecurity => 'Segurança';

  @override
  String get settingsChangePassword => 'Alterar senha';

  @override
  String get settingsChangePasswordSubtitle => 'Atualize sua senha de acesso';

  @override
  String get settingsVerifyEmail => 'Verificar e-mail';

  @override
  String get settingsVerifyEmailSubtitle => 'Confirme seu endereço de e-mail';

  @override
  String get settingsDangerZone => 'Zona de perigo';

  @override
  String get settingsDeleteAccountWarning =>
      'Excluir sua conta apagará permanentemente todos os seus dados, incluindo granjas, lotes e registros.';

  @override
  String get settingsDeleteAccount => 'Excluir conta';

  @override
  String get settingsClearCacheConfirm => 'Limpar cache?';

  @override
  String get settingsClearCacheMessage =>
      'Os dados temporários serão removidos. Isso não afetará seus registros.';

  @override
  String get settingsClearCacheConfirmButton => 'Limpar';

  @override
  String get settingsCacheClearedSuccess => 'Cache limpo com sucesso';

  @override
  String get settingsChangePasswordMessage =>
      'Enviaremos um link para redefinir sua senha.';

  @override
  String get settingsYourEmail => 'Seu e-mail';

  @override
  String get settingsSendLink => 'Enviar link';

  @override
  String get settingsResetLinkSent => 'Um link foi enviado para seu e-mail';

  @override
  String get settingsVerificationEmailSent =>
      'Um e-mail de verificação foi enviado';

  @override
  String get settingsDeleteAccountConfirm => 'Excluir conta?';

  @override
  String get settingsDeleteAccountMessage =>
      'Esta ação é irreversível e você perderá todos os seus dados.';

  @override
  String get profileSignOutConfirm => 'Sair?';

  @override
  String get profileSignOutMessage =>
      'Você precisará fazer login novamente para acessar sua conta.';

  @override
  String get profileNoFarmsMessage =>
      'Você não tem granjas. Crie uma primeiro.';

  @override
  String get profileCreate => 'Criar';

  @override
  String get profileHelpQuestion => 'Como podemos ajudá-lo?';

  @override
  String get profileEmailSupport => 'Suporte por E-mail';

  @override
  String get profileFaq => 'Perguntas Frequentes';

  @override
  String get profileFaqSubtitle => 'Consulte as dúvidas mais comuns';

  @override
  String get profileUserManual => 'Manual do Usuário';

  @override
  String get profileUserManualSubtitle => 'Guia completo de uso';

  @override
  String get profileFeedbackQuestion =>
      'Tem alguma ideia para melhorar o app? Adoraríamos ouvir você.';

  @override
  String get profileFeedbackHint => 'Escreva sua sugestão aqui...';

  @override
  String get profileFeedbackThanks => 'Obrigado pela sua sugestão!';

  @override
  String get profileAppDescription =>
      'Seu parceiro inteligente para gestão avícola. Controle lotes, monitore o desempenho, acompanhe vacinações e otimize a produção da sua granja de forma simples e eficiente.';

  @override
  String get profileCopyright =>
      '© 2024 Smart Granja. Todos os direitos reservados.';

  @override
  String profileVersionText(String version) {
    return 'Versão $version';
  }

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get editProfilePersonalInfo => 'Informações Pessoais';

  @override
  String get editProfileAccountInfo => 'Informações da Conta';

  @override
  String get editProfileLastName => 'Sobrenome';

  @override
  String get editProfileMemberSince => 'Membro desde';

  @override
  String get editProfileChangePhoto => 'Alterar foto de perfil';

  @override
  String get editProfileTakePhoto => 'Tirar foto';

  @override
  String get editProfileChooseGallery => 'Escolher da galeria';

  @override
  String get editProfilePhotoUpdated => 'Foto atualizada com sucesso';

  @override
  String get editProfilePhotoError =>
      'Erro ao atualizar a foto. Tente novamente.';

  @override
  String get editProfileImageTooLarge =>
      'A imagem excede o tamanho máximo (5MB)';

  @override
  String get editProfileDiscardChanges => 'Descartar alterações?';

  @override
  String get editProfileDiscardMessage =>
      'Você tem alterações não salvas. Tem certeza de que deseja sair?';

  @override
  String get editProfileUnknownDate => 'Desconhecido';

  @override
  String get editProfileUpdatedSuccess => 'Perfil atualizado com sucesso';

  @override
  String editProfileUpdateError(String error) {
    return 'Erro ao atualizar: $error';
  }

  @override
  String get notifProductionAlerts => 'Alertas de Produção';

  @override
  String get notifHighMortality => 'Mortalidade elevada';

  @override
  String notifHighMortalitySubtitle(String threshold) {
    return 'Alerta quando a mortalidade excede $threshold%';
  }

  @override
  String get notifMortalityThreshold => 'Limite de mortalidade';

  @override
  String get notifLowProduction => 'Baixa produção';

  @override
  String notifLowProductionSubtitle(Object threshold) {
    return 'Alerta quando a produção cai abaixo de $threshold%';
  }

  @override
  String get notifProductionThreshold => 'Limite de produção';

  @override
  String get notifAbnormalConsumption => 'Consumo anormal';

  @override
  String get notifAbnormalConsumptionSubtitle =>
      'Alerta quando o consumo varia significativamente';

  @override
  String get notifReminders => 'Lembretes';

  @override
  String get notifPendingVaccinations => 'Vacinações pendentes';

  @override
  String get notifPendingVaccinationsSubtitle =>
      'Lembre de vacinações programadas';

  @override
  String get notifLowInventory => 'Inventário baixo';

  @override
  String get notifLowInventorySubtitle => 'Alerta quando a ração está acabando';

  @override
  String get notifSummaries => 'Resumos';

  @override
  String get notifDailySummary => 'Resumo diário';

  @override
  String get notifDailySummarySubtitle => 'Receba um resumo todo dia às 20:00';

  @override
  String get notifWeeklySummary => 'Resumo semanal';

  @override
  String get notifWeeklySummarySubtitle =>
      'Receba um resumo toda segunda-feira';

  @override
  String get notifConfigSaved => 'Configuração salva';

  @override
  String get notifSaveConfig => 'Salvar configuração';

  @override
  String farmCreatedSuccess(String name) {
    return 'Granja \"$name\" criada!';
  }

  @override
  String farmUpdatedSuccess(Object name) {
    return 'Granja \"$name\" atualizada!';
  }

  @override
  String get farmNotFound => 'Granja não encontrada';

  @override
  String get farmOwner => 'Proprietário';

  @override
  String get farmCapacity => 'Capacidade';

  @override
  String get farmArea => 'Área';

  @override
  String get farmEmail => 'E-mail';

  @override
  String get farmCreatedDate => 'Data de Criação';

  @override
  String get farmCollaborators => 'Colaboradores';

  @override
  String get farmInviteCollaborator => 'Convidar Colaborador';

  @override
  String farmRoleUpdated(String role) {
    return 'Função atualizada para $role';
  }

  @override
  String get farmCodeCopied => 'Código copiado';

  @override
  String farmActivateConfirm(Object name) {
    return 'Ativar \"$name\"?';
  }

  @override
  String farmSuspendConfirm(Object name) {
    return 'Suspender \"$name\"?';
  }

  @override
  String farmMaintenanceConfirm(Object name) {
    return 'Colocar \"$name\" em manutenção?';
  }

  @override
  String shedActivateConfirm(Object name) {
    return 'Ativar \"$name\"?';
  }

  @override
  String shedSuspendConfirm(Object name) {
    return 'Suspender \"$name\"?';
  }

  @override
  String shedMaintenanceConfirm(Object name) {
    return 'Colocar \"$name\" em manutenção?';
  }

  @override
  String shedDisinfectionConfirm(Object name) {
    return 'Colocar \"$name\" em desinfecção?';
  }

  @override
  String shedReleaseConfirm(Object name) {
    return 'Liberar \"$name\"?';
  }

  @override
  String get shedCapacity => 'Capacidade';

  @override
  String get shedCurrentBirds => 'Atuais';

  @override
  String get shedOccupancy => 'Ocupação';

  @override
  String get shedBirds => 'Aves';

  @override
  String get shedTagExists => 'Esta etiqueta já existe';

  @override
  String shedMaxTags(String max) {
    return 'Máximo $max etiquetas';
  }

  @override
  String get shedAddProduct => 'Adicionar produto';

  @override
  String get batchCode => 'Código do Lote';

  @override
  String get batchBirdType => 'Tipo de Ave';

  @override
  String get batchBreedLine => 'Raça/Linha Genética';

  @override
  String get batchInitialCount => 'Quantidade Inicial';

  @override
  String get batchCurrentBirds => 'Aves Atuais';

  @override
  String get batchEntryDate => 'Data de Entrada';

  @override
  String get batchEntryAge => 'Idade de Entrada';

  @override
  String get batchCurrentAge => 'Idade Atual';

  @override
  String get batchCostPerBird => 'Custo por Ave';

  @override
  String get batchEstimatedClose => 'Fechamento Estimado';

  @override
  String get batchSurvivalRate => 'Taxa de Sobrevivência';

  @override
  String get batchAccumulatedMortality => 'Mortalidade Acumulada';

  @override
  String get batchAccumulatedDiscards => 'Descartes Acumulados';

  @override
  String get batchAccumulatedSales => 'Vendas Acumuladas';

  @override
  String get batchCurrentAvgWeight => 'Peso médio atual';

  @override
  String get batchAccumulatedConsumption => 'Consumo Acumulado';

  @override
  String get batchFeedConversion => 'Índice de Conversão Alimentar (ICA)';

  @override
  String get batchEggsProduced => 'Ovos Produzidos';

  @override
  String get batchRemainingDays => 'Dias Restantes';

  @override
  String get batchImportantInfo => 'Informação importante';

  @override
  String get batchChangeStatus => 'Alterar Status';

  @override
  String get batchClosedSuccess => 'Lote fechado com sucesso';

  @override
  String get batchEntryAgeDays => 'Idade de Entrada (dias)';

  @override
  String get batchSelectBatch => 'Selecionar lote';

  @override
  String get healthApplied => 'Aplicada';

  @override
  String get healthExpired => 'Vencida';

  @override
  String get healthUpcoming => 'Próxima';

  @override
  String get healthPending => 'Pendentes';

  @override
  String get healthVaccineName => 'Nome da vacina';

  @override
  String get healthVaccineNameHint => 'Ex: Newcastle + Bronquite';

  @override
  String get healthVaccineBatch => 'Lote da vacina (opcional)';

  @override
  String get healthVaccineBatchHint => 'Ex: LOT123456';

  @override
  String get healthSelectInventoryVaccine => 'Selecionar vacina do inventário';

  @override
  String get healthSelectInventoryVaccineHint =>
      'Opcional - Selecione una vacina registrada';

  @override
  String get healthObservationsOptional => 'Observações (opcional)';

  @override
  String get healthObservationsHint =>
      'Reações observadas, notas especiais, etc.';

  @override
  String get healthTreatmentDescription => 'Descrição do tratamento';

  @override
  String get healthTreatmentDescriptionHint =>
      'Descreva el pquebradocolo de tratamento aplicado';

  @override
  String get healthMedications => 'Medicamentos';

  @override
  String get healthAdditionalMedications => 'Medicamentos adicionais';

  @override
  String get healthMedicationsHint => 'Ex: Enrofloxacina + Vitaminas A, D, E';

  @override
  String get healthDose => 'Dose';

  @override
  String get healthDoseHint => 'Ex: 1ml/L';

  @override
  String get healthDurationDays => 'Duração (dias)';

  @override
  String get healthDurationHint => 'Ex: 5';

  @override
  String get healthDiagnosis => 'Diagnóstico';

  @override
  String get healthDiagnosisHint => 'Ex: Doença respiratoria crónica';

  @override
  String get healthSymptomsObserved => 'Sintomas observados';

  @override
  String get healthSymptomsHint =>
      'Descreva os sintomas: tosse, espirros, prostração...';

  @override
  String get healthVeterinarian => 'Veterinário responsável';

  @override
  String get healthVeterinarianHint => 'Nome do veterinário';

  @override
  String get healthGeneralObservations => 'Observações gerais';

  @override
  String get healthGeneralObservationsHint =>
      'Notas adicionais, evolução esperada, etc.';

  @override
  String get healthBiosecurityObservationsHint =>
      'Descreva hallazgos gerales de la inspección…';

  @override
  String get healthCorrectiveActions => 'Ações corretivas';

  @override
  String get healthCorrectiveActionsHint => 'Descreva as ações a implementar…';

  @override
  String get healthCompliant => 'Conforme';

  @override
  String get healthNonCompliant => 'Não conforme';

  @override
  String get healthPartial => 'Parcial';

  @override
  String get healthNotApplicable => 'N/A';

  @override
  String get healthWriteObservation => 'Escreva uma observação (opcional)';

  @override
  String get healthScheduleVaccination => 'Programar Vacinação';

  @override
  String get healthVaccine => 'Vacina';

  @override
  String get healthApplication => 'Aplicação';

  @override
  String get healthMustSelectBatch => 'Você deve selecionar um lote';

  @override
  String get healthDiseaseCatalog => 'Catálogo de Doenças';

  @override
  String get healthSearchDisease => 'Buscar doença, sintoma...';

  @override
  String get healthAllSeverities => 'Todos';

  @override
  String get healthCritical => 'Crítica';

  @override
  String get healthSevere => 'Grave';

  @override
  String get healthModerate => 'Moderada';

  @override
  String get healthMild => 'Leve';

  @override
  String get healthRegisterTreatment => 'Registrar Tratamento';

  @override
  String get healthBiosecurityInspection => 'Inspección de Biossegurança';

  @override
  String get healthNewInspection => 'Nova Inspección';

  @override
  String get healthChecklist => 'Checklist';

  @override
  String get healthInspectionSaved => 'Inspección guardada com sucesso';

  @override
  String get healthRecordDetail => 'Detalhe do Registro';

  @override
  String get healthCloseTreatment => 'Fechar Tratamento';

  @override
  String get healthVaccinationApplied => 'Vacinação marcada como aplicada';

  @override
  String get healthVaccinationDeleted => 'Vacinação eliminada';

  @override
  String get salesDetail => 'Detalhe de Venda';

  @override
  String get salesNotFoundDetail => 'Venda no encontrada';

  @override
  String get salesEditTooltip => 'Editar venda';

  @override
  String get salesClient => 'Cliente';

  @override
  String get salesDocument => 'Documento';

  @override
  String get salesBirdCount => 'Quantidade de aves';

  @override
  String get salesAvgWeight => 'Peso médio';

  @override
  String get salesPricePerKg => 'Preço por kg';

  @override
  String get salesSubtotal => 'Subtotal';

  @override
  String get salesCarcassYield => 'Rendimento de carcaça';

  @override
  String get salesDiscount => 'Desconto';

  @override
  String get salesTotalAmount => 'TOTAL';

  @override
  String get salesProductDetails => 'Detalhes del Produto';

  @override
  String get salesRegistrationInfo => 'Informações de Registro';

  @override
  String get salesActive => 'Ativo';

  @override
  String get salesCompleted => 'Concluído';

  @override
  String get salesConfirmed => 'Confirmared';

  @override
  String get salesSold => 'Vendida';

  @override
  String get salesClientName => 'Nome completo';

  @override
  String get salesClientNameHint => 'Ex: João Silva';

  @override
  String get salesDocType => 'Document tipo *';

  @override
  String get salesDni => 'CPF';

  @override
  String get salesRuc => 'CNPJ';

  @override
  String get salesForeignCard => 'RNE';

  @override
  String get salesDocNumber => 'Número do documento';

  @override
  String get salesContactPhone => 'Telefone de contacto';

  @override
  String get salesPhoneHint => '9 dígitos';

  @override
  String get salesDraftFound => 'Rascunho encontrado';

  @override
  String get salesDraftRestore =>
      'Deseja restaurar o rascunho de venda salvo anteriormente?';

  @override
  String get salesDraftRestored => 'Rascunho restaurado';

  @override
  String get costDetail => 'Detalhe del Custo';

  @override
  String get costEditTooltip => 'Editar custo';

  @override
  String get costConcept => 'Conceito';

  @override
  String get costInvoiceNumber => 'Nº Fatura';

  @override
  String get costTypeFood => 'Ração';

  @override
  String get costTypeLabor => 'Mão de Obra';

  @override
  String get costTypeEnergy => 'Energia';

  @override
  String get costTypeMedicine => 'Medicamento';

  @override
  String get costTypeMaintenance => 'Manutenção';

  @override
  String get costTypeWater => 'Água';

  @override
  String get costTypeTransport => 'Transporte';

  @override
  String get costTypeAdmin => 'Administrativo';

  @override
  String get costTypeDepreciation => 'Depreciação';

  @override
  String get costTypeFinancial => 'Financeiro';

  @override
  String get costTypeOther => 'Outros';

  @override
  String get costDeleteConfirm => 'Excluir Custo?';

  @override
  String get costDeletedSuccess => 'Custo eliminado com sucesso';

  @override
  String get costNoCosts => 'Sin custos registrados';

  @override
  String get costNotFound => 'No se encontraron custos';

  @override
  String get costRegisterNew => 'Registrar Custo';

  @override
  String get costRegisterNewTooltip => 'Registrar novo custo';

  @override
  String get costType => 'Expense tipo';

  @override
  String get costDraftFound => 'Rascunho encontrado';

  @override
  String get costExitConfirm => 'Sair sem completar?';

  @override
  String get costAmount => 'Valor';

  @override
  String get costConceptHint => 'Ex: Compra de alimento balanceado';

  @override
  String get costSearchInventory => 'Buscar no inventário (opcional)...';

  @override
  String get costProviderHint => 'Nome del fornecedor o empresa';

  @override
  String get costInvoiceNumberLabel => 'Número da Fatura/Recibo';

  @override
  String get costInvoiceHint => 'F001-00001234';

  @override
  String get costNotesHint => 'Notas adicionais sobre este gasto';

  @override
  String get inventoryTitle => 'Inventário';

  @override
  String get inventoryNewItem => 'Novo Item';

  @override
  String get inventorySearchHint => 'Buscar por nome ou código...';

  @override
  String get inventoryAddItem => 'Adicionar Item';

  @override
  String get inventoryItemDetail => 'Detalhe do Item';

  @override
  String get inventoryRegisterEntry => 'Registrar Entry';

  @override
  String get inventoryRegisterExit => 'Registrar Exit';

  @override
  String get inventoryAdjustStock => 'Ajustar Estoque';

  @override
  String get inventoryItemNotFound => 'Item não encontrado';

  @override
  String get inventoryItemDeleted => 'Item excluird';

  @override
  String get inventoryBasic => 'Básico';

  @override
  String get inventoryImageSelected => 'Imagen selecioneda';

  @override
  String get inventoryItemName => 'Nome del Item';

  @override
  String get inventoryItemNameHint => 'Ex: Concentrado Iniciador';

  @override
  String get inventoryCodeSku => 'Código/SKU (opcional)';

  @override
  String get inventoryCodeHint => 'Ex: ALI-001';

  @override
  String get inventoryDescriptionOptional => 'Descrição (opcional)';

  @override
  String get inventoryDescriptionHint =>
      'Descreva las características del produto...';

  @override
  String get inventoryCurrentStock => 'Estoque Atual';

  @override
  String get inventoryMinStock => 'Estoque Mínimo';

  @override
  String get inventoryMaxStock => 'Estoque Máximo';

  @override
  String get inventoryOptional => 'Opcional';

  @override
  String get inventoryUnitPrice => 'Preço Unitario';

  @override
  String get inventoryProviderHint => 'Nome del fornecedor';

  @override
  String get inventoryStorageLocation => 'Localização en Almacén';

  @override
  String get inventoryStorageHint => 'Ex: Depósito A, Prateleira 3';

  @override
  String get inventoryExpiration => 'Vencimento';

  @override
  String get inventoryProviderBatch => 'Lote del Fornecedor';

  @override
  String get inventoryProviderBatchHint => 'Lote number';

  @override
  String get inventoryTakePhoto => 'Take Foto';

  @override
  String get inventoryGallery => 'Galeria';

  @override
  String get inventoryObservation => 'Observação';

  @override
  String get inventoryObservationHint => 'Motivo u observação';

  @override
  String get inventoryPhysicalCount => 'Ex: Inventário físico';

  @override
  String get inventoryAdjustReason => 'Motivo do ajuste';

  @override
  String get inventoryStockAdjusted => 'Estoque ajustado corretamente';

  @override
  String get inventorySelectProduct => 'Selecionar produto';

  @override
  String get inventorySearchProduct => 'Buscar no inventário...';

  @override
  String get inventorySearchProductShort => 'Buscar produto...';

  @override
  String get inventoryItemOptions => 'Mais opções del item';

  @override
  String get inventoryRemoveSelection => 'Remove selecionarion';

  @override
  String get inventoryEnterProduct => 'Insira al menos un produto';

  @override
  String get inventoryEnterDescription => 'Insira una descrição';

  @override
  String get weightMinObserved => 'Minimum observed peso';

  @override
  String get weightMinHint => 'Ex: 2200';

  @override
  String get batchFormWeightObsHint =>
      'Descreva as condições da pesagem, comportamento das aves, condições ambientais, etc.';

  @override
  String get weightMaxObserved => 'Maximum observed peso';

  @override
  String get weightMethod => 'Método de pesagem';

  @override
  String get weightMethodHint => 'Selecionar method';

  @override
  String get mortalityEventDescription => 'Descrição del evento';

  @override
  String get mortalityEventDescriptionHint =>
      'Describa sintomas, contexto, condiciones ambientales...';

  @override
  String get productionInfo => 'Informações';

  @override
  String get productionClassification => 'Classificação';

  @override
  String get productionTakePhoto => 'Take Foto';

  @override
  String get productionGallery => 'Galeria';

  @override
  String get productionEggsCollected => 'Ovos recolectados';

  @override
  String get productionEggsHint => 'Ex: 850';

  @override
  String get productionSmallEggs => 'Pequenos (S) - 43-53g';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Fev';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Set';

  @override
  String get monthOct => 'Out';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dez';

  @override
  String get commonChangeStatus => 'Alterar status';

  @override
  String get commonCurrentStatus => 'Status actual:';

  @override
  String get commonSelectNewStatus => 'Selecionar novo status:';

  @override
  String get commonErrorLoading => 'Erro al carregar';

  @override
  String get commonSaveChanges => 'Salvar Cambios';

  @override
  String get commonCreate => 'Criar';

  @override
  String get commonUpdate => 'Atualizar';

  @override
  String get commonRegister => 'Registrar';

  @override
  String get commonUnexpectedError => 'Erro inesperado';

  @override
  String get commonSearchByNameCityAddress =>
      'Buscar por nome, cidade ou endereço...';

  @override
  String get commonEnterReason => 'Insira o motivo';

  @override
  String get commonDescriptionOptional => 'Descrição (opcional)';

  @override
  String get commonState => 'Status';

  @override
  String get commonType => 'Tipo';

  @override
  String get commonNoPhotos => 'No fotos added';

  @override
  String get commonSelectedPhotos => 'Fotos selecionedas';

  @override
  String get commonTakePhoto => 'Take Foto';

  @override
  String get commonFieldRequired => 'Este campo es obrigatório';

  @override
  String get commonInvalidValue => 'Valor inválido';

  @override
  String get commonLoadingCharts => 'Carregando gráficos...';

  @override
  String get commonNoRecordsWithFilters => 'Não há registros com estes filtros';

  @override
  String get commonFilterCosts => 'Filtrar custos';

  @override
  String get commonApplyFiltersBtn => 'Aplicar filtros';

  @override
  String get commonCloseBtn => 'Fechar';

  @override
  String get commonSelectType => 'Selecionar tipo';

  @override
  String get commonSelectStatus => 'Selecionar status';

  @override
  String get commonQuantity => 'Quantidade';

  @override
  String get commonAmount => 'Valor';

  @override
  String get commonNoData => 'Sem dados';

  @override
  String get commonRestoreBtn => 'Restaurar';

  @override
  String get commonDiscardBtn => 'Descartar';

  @override
  String get farmName => 'Nome de la Granja';

  @override
  String get farmNameHint => 'Ex: Granja San José';

  @override
  String get farmNameRequired => 'Insira el nome de la granja';

  @override
  String get farmNameMinLength => 'El nome debe tener al menos 3 caracteres';

  @override
  String get farmOwnerName => 'Proprietário';

  @override
  String get farmOwnerHint => 'Nome completo del proprietário';

  @override
  String get farmOwnerRequired => 'Insira el nome del proprietário';

  @override
  String get farmDescriptionOptional => 'Descrição (opcional)';

  @override
  String get farmCreateFarm => 'Criar Granja';

  @override
  String get farmSearchHint => 'Buscar por nome, cidade ou endereço...';

  @override
  String get farmDetails => 'Detalhes';

  @override
  String get farmEditTooltip => 'Edit granja';

  @override
  String get farmDeleteFarm => 'Excluir granja';

  @override
  String get farmDashboardError => 'Erro al carregar dashboard';

  @override
  String farmStatusUpdated(String status) {
    return 'Status atualizado a $status';
  }

  @override
  String farmErrorChangingStatus(Object error) {
    return 'Erro ao alterar o status: $error';
  }

  @override
  String farmErrorDeleting(Object error) {
    return 'Erro al excluir granja: $error';
  }

  @override
  String farmErrorLoadingFarms(Object error) {
    return 'Erro al carregar granjas: $error';
  }

  @override
  String get farmConfirmInvitation => 'Confirmar Invitation';

  @override
  String get farmSelectRole => 'Selecionar Função';

  @override
  String farmErrorVerifyingPermissions(Object error) {
    return 'Erro al verificar permissões: $error';
  }

  @override
  String get farmManageCollaborators => 'Gerenciar Colaboradores';

  @override
  String get farmRefresh => 'Atualizar';

  @override
  String get farmNoShedsRegistered => 'No hay galpões registrados';

  @override
  String get farmCreateFirstShed => 'Criar Primer Galpão';

  @override
  String get farmNewShed => 'Novo Galpão';

  @override
  String get farmTemperature => 'Temperatura';

  @override
  String get farmErrorOriginalData =>
      'Erro: No se pudo obtener los datos originales de la granja';

  @override
  String get shedName => 'Nome del Galpão *';

  @override
  String get shedNameTooLong => 'Nome demasiado largo';

  @override
  String get shedType => 'Tipo de Galpão *';

  @override
  String get shedRegistrationDate => 'Data de Registro';

  @override
  String get shedNotFound => 'Galpão no encontrado';

  @override
  String get shedDetails => 'Detalhes';

  @override
  String get shedEditTooltip => 'Editar galpão';

  @override
  String get shedDeleteShed => 'Excluir galpão';

  @override
  String get shedCreated => 'Galpão criado';

  @override
  String get shedDeletedSuccess => 'Galpão eliminado correctamente';

  @override
  String shedErrorDeleting(Object error) {
    return 'Erro al excluir: $error';
  }

  @override
  String shedErrorChangingStatus(Object error) {
    return 'Erro ao alterar o status: $error';
  }

  @override
  String get shedCreateShed => 'Criar Galpão';

  @override
  String get shedCreateShedTooltip => 'Criar novo galpão';

  @override
  String get shedSearchHint => 'Buscar por nome, código ou tipo...';

  @override
  String get shedSelectBatch => 'Selecionar Lote';

  @override
  String get shedNoBatchesAvailable => 'No hay lotes disponívels';

  @override
  String get shedErrorLoadingBatches => 'Erro al carregar lotes';

  @override
  String shedNotAvailable(Object status) {
    return 'Galpão no disponível ($status)';
  }

  @override
  String get shedScale => 'Balança';

  @override
  String get shedTemperatureSensor => 'Temperatura';

  @override
  String get shedHumiditySensor => 'Umidade';

  @override
  String get shedCO2Sensor => 'CO2';

  @override
  String get shedAmmoniaSensor => 'Amônia';

  @override
  String get shedAddTag => 'Adicionar etiqueta';

  @override
  String get shedSearchInventory => 'Buscar no inventário...';

  @override
  String get shedDateLabel => 'Data';

  @override
  String get shedStartDate => 'Data de início';

  @override
  String get shedMaintenanceDescription => 'Descrição del manutenção *';

  @override
  String get shedDisinfectionInfo => 'As operações serão limitadas.';

  @override
  String get shedDisinfectionTitle => 'Poner en desinfecção';

  @override
  String shedDisinfectionMessage(Object name) {
    return 'Colocar \"$name\" em desinfecção?';
  }

  @override
  String get shedMustSpecifyQuarantine =>
      'Deve especificar o motivo da quarentena';

  @override
  String get shedErrorOriginalData =>
      'Erro: No se pudo obtener los datos originales del galpão';

  @override
  String shedSemantics(String code, String birds, Object name, Object status) {
    return 'Galpão $name, código $code, $birds aves, status $status';
  }

  @override
  String get batchNoActiveSheds => 'No hay galpões ativos disponívels';

  @override
  String get batchNoTransitions =>
      'No hay transiciones disponívels desde este status.';

  @override
  String get batchEnterValidQuantity =>
      'Insira una quantidade válida mayor a 0';

  @override
  String get batchEnterFinalBirdCount => 'Insira la quantidade final de aves';

  @override
  String get batchFieldRequired => 'Campo obrigatório';

  @override
  String get batchEnterValidNumber => 'Insira um número válido';

  @override
  String get batchNoRecordsMortality => 'Não há registros de mortalidad';

  @override
  String get batchLoadingFoods => 'Carregando ração...';

  @override
  String get batchNoFoodsInventory => 'No hay ração en el inventário';

  @override
  String get batchEnterValidCost => 'Insira un custo válido';

  @override
  String get productionInfoTitle => 'Informações de Produção';

  @override
  String get productionDailyCollection =>
      'Registro diário de recolección de ovos';

  @override
  String get productionCannotExceedCollected => 'Cannot exceed collected ovos';

  @override
  String get productionRegistrationDate => 'Data de registro';

  @override
  String get productionAcceptableYield => 'Rendimento aceptable';

  @override
  String get productionBelowExpected => 'Postura por debaixo del esperado';

  @override
  String get productionLayingIndicator => 'Indicador de Postura';

  @override
  String get productionEggClassification => 'Classificação de Ovos';

  @override
  String get productionQualitySizeDetail =>
      'Detalhe de calidad y tamano (opcional)';

  @override
  String get productionDefectiveEggs => 'Ovos Defectuosos';

  @override
  String get productionDirty => 'Sujos';

  @override
  String get productionSizeClassification => 'Classificação por Tamano';

  @override
  String productionTotalToClassify(Object count) {
    return 'Total a clasificar: $count ovos boms';
  }

  @override
  String get productionClassificationSummary => 'Resumo de Classificação';

  @override
  String get productionTotalClassified => 'Total classificados';

  @override
  String get productionAvgWeightCalculated => 'Peso Promédio Calculado';

  @override
  String get productionObservationsEvidence => 'Observações y Evidencia';

  @override
  String get productionSummary => 'Resumo de Produção';

  @override
  String get productionLayingPercentage => 'Porcentagem de postura';

  @override
  String get productionUtilization => 'Aproveitamento';

  @override
  String get productionAvgWeight => 'Peso médio';

  @override
  String get productionNoPhotos => 'No fotos added';

  @override
  String get weightInfoTitle => 'Informações del Pesagem';

  @override
  String get weightAvgWeight => 'Peso médio';

  @override
  String get weightEnterAvgWeight => 'Insira el peso promédio';

  @override
  String get weightBirdCount => 'Quantidade de aves pesadas';

  @override
  String get weightEnterBirdCount => 'Insira la quantidade de aves';

  @override
  String get weightMethodLabel => 'Método de pesagem';

  @override
  String get weightSelectMethod => 'Selecionar method';

  @override
  String get weightDate => 'Data del pesagem';

  @override
  String get weightRangesTitle => 'Peso Ranges';

  @override
  String get weightMinMaxObserved => 'Minimum and maximum observed peso';

  @override
  String get weightEnterMinWeight => 'Insira el peso mínimo';

  @override
  String get weightEnterMaxWeight => 'Insira el peso máximo';

  @override
  String get weightSummaryTitle => 'Resumo del Pesagem';

  @override
  String get weightReviewMetrics =>
      'Review metrics and add fotographic evidence';

  @override
  String get weightImportantInfo => 'Informação importante';

  @override
  String get weightTotalWeight => 'Total peso';

  @override
  String get weightGDP => 'GDP (Diário gain)';

  @override
  String get weightCoefficientVariation => 'Coeficiente de variação';

  @override
  String get weightRange => 'Peso range';

  @override
  String get weightBirdsCounted => 'Aves weighed';

  @override
  String get mortalityBasicDetails =>
      'Detalhes básicos del evento de mortalidad';

  @override
  String get salesEditLabel => 'Editar';

  @override
  String get salesDeleteLabel => 'Excluir';

  @override
  String get salesSaleDate => 'Data de venda';

  @override
  String salesDetailsOf(String product) {
    return 'Detalhes de $product';
  }

  @override
  String get salesEnterDetails =>
      'Insira quantidadees, preços y outros detalhes';

  @override
  String get salesBirdCountLabel => 'Quantidade de aves';

  @override
  String get salesBirdCountHint => 'Ex: 100';

  @override
  String get salesEnterBirdCount => 'Insira la quantidade de aves';

  @override
  String get salesQuantityGreaterThanZero => 'La quantidade debe ser mayor a 0';

  @override
  String get salesMaxQuantity => 'La quantidade máxima es 1,000,000';

  @override
  String get salesTotalWeightKg => 'Total peso (kg)';

  @override
  String get salesDressedWeightKg => 'Dressed peso total (kg)';

  @override
  String get salesEnterTotalWeight => 'Insira el peso total';

  @override
  String get salesWeightGreaterThanZero => 'Peso must be greater than 0';

  @override
  String get salesMaxWeight => 'Maximum peso is 50,000 kg';

  @override
  String salesPricePerKgLabel(String currency) {
    return 'Preço por kg ($currency)';
  }

  @override
  String get salesNoFarmSelected =>
      'No hay una granja selecioneda. Por favor selecione una granja primeiro.';

  @override
  String get salesNoActiveBatches => 'No hay lotes ativos en esta granja.';

  @override
  String salesErrorLoadingBatches(Object error) {
    return 'Erro al carregar lotes: $error';
  }

  @override
  String get salesFormStepDetails => 'Detalhes';

  @override
  String get salesUpdatedSuccess => 'Venda atualizada correctamente';

  @override
  String get salesRegisteredSuccess => 'Venda registrada com sucesso!';

  @override
  String get salesInventoryUpdateError =>
      'Venda registrada, pero hubo un erro al atualizar inventário';

  @override
  String get salesQuantityInvalid => 'Quantidade inválida';

  @override
  String get salesQuantityExcessive => 'Quantidade excesiva';

  @override
  String get salesPriceInvalid => 'Preço inválido';

  @override
  String get salesPriceExcessive => 'Preço excesivo';

  @override
  String get salesQuantityLabel => 'Quantidade';

  @override
  String salesPricePerDozen(String currency) {
    return '$currency por dúzia';
  }

  @override
  String salesPollinazaQuantity(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String get salesEnterQuantity => 'Insira la quantidade';

  @override
  String salesPollinazaPricePerUnit(Object currency, Object unit) {
    return 'Preço por $unit ($currency)';
  }

  @override
  String get salesEditVenta => 'Editar Venda';

  @override
  String get salesLoadingError => 'Erro al carregar la venda';

  @override
  String get salesTotalHuevos => 'Total ovos';

  @override
  String get salesFaenadoWeight => 'Dressed peso';

  @override
  String get salesYield => 'Rendimento';

  @override
  String get salesUnitPrice => 'Preço unitario';

  @override
  String get salesRegistrationDate => 'Data de registro';

  @override
  String get salesObservations => 'Observações';

  @override
  String get costRegisteredSuccess => 'Custo registrado correctamente';

  @override
  String get costUpdatedSuccess => 'Custo atualizado correctamente';

  @override
  String get costSelectExpenseType => 'Por favor selecione un tipo de gasto';

  @override
  String get costRegisterCost => 'Registrar Custo';

  @override
  String get costEditCost => 'Editar Custo';

  @override
  String get costFormStepType => 'Tipo';

  @override
  String get costFormStepAmount => 'Valor';

  @override
  String get costFormStepDetails => 'Detalhes';

  @override
  String get costAmountTitle => 'Expense Valor';

  @override
  String get costConceptLabel => 'Conceito do gasto';

  @override
  String get costEnterConcept => 'Insira o conceito do gasto';

  @override
  String get costEnterAmount => 'Insira el monto';

  @override
  String get costEnterValidAmount => 'Insira un monto válido';

  @override
  String get costDateLabel => 'Data del gasto *';

  @override
  String get costRejectCost => 'Rejeitar Custo';

  @override
  String get costRejectReasonLabel => 'Motivo da rejeição';

  @override
  String get costRejectReasonHint => 'Explica por qué se rechaza este custo';

  @override
  String get costEnterRejectReason => 'Insira um motivo de rejeição';

  @override
  String get costRejectBtn => 'Rejeitar';

  @override
  String costDeleteMessage(String concept) {
    return 'Tem certeza de que deseja excluir o custo \"$concept\"?\n\nEsta ação não pode ser desfeita.';
  }

  @override
  String get costDeletedSuccessMsg => 'Custo eliminado correctamente';

  @override
  String costErrorDeleting(Object error) {
    return 'Erro al excluir: $error';
  }

  @override
  String get costLotCosts => 'Custos del Lote';

  @override
  String get costAllCosts => 'Todos los Custos';

  @override
  String get costNoCostsDescription =>
      'Registra tus gastos operativos para llevar un control detallado de los custos de produção';

  @override
  String get costCostSummary => 'Resumo de Custos';

  @override
  String get costTotalInCosts => 'Total en custos';

  @override
  String get costApprovedCount => 'Aprovados';

  @override
  String get costPendingCount => 'Pendentes';

  @override
  String get costTotalCount => 'Total';

  @override
  String get costUserNotAuthenticated => 'Usuário not authenticated';

  @override
  String costErrorApproving(Object error) {
    return 'Erro al aprobar: $error';
  }

  @override
  String costErrorRejecting(Object error) {
    return 'Erro al rejeitar: $error';
  }

  @override
  String get costTypeOfExpense => 'Expense tipo';

  @override
  String get costGeneralInfo => 'Informações Geral';

  @override
  String get costRegistrationInfo => 'Informações de Registro';

  @override
  String get costRegisteredBy => 'Registrado por';

  @override
  String get costRole => 'Função';

  @override
  String get costRegistrationDate => 'Data de registro';

  @override
  String get costLastUpdate => 'Última atualização';

  @override
  String get costNoStatus => 'Sin status';

  @override
  String get costStatusLabel => 'Status';

  @override
  String get costLotNotFound => 'Lote not found';

  @override
  String get costFarmNotFound => 'Granja não encontrada';

  @override
  String get costProviderName => 'Nome';

  @override
  String get costDeleteConfirmTitle => 'Excluir Custo';

  @override
  String get costDeleteConfirmMessage =>
      'Tem certeza de que deseja excluir este custo?\n\nEsta ação não pode ser desfeita.';

  @override
  String get costLinkedProduct => 'Produto vinculado';

  @override
  String get costStockUpdateOnSave => 'Se atualizará el estoque al salvar';

  @override
  String get costLinkToFoodInventory => 'Vincular a alimento del inventário';

  @override
  String get costLinkToMedicineInventory =>
      'Vincular a medicamento del inventário';

  @override
  String get costAdditionalDetails => 'Detalhes Adicionales';

  @override
  String get costComplementaryInfo => 'Informações complementaria del gasto';

  @override
  String get costProviderLabel => 'Fornecedor';

  @override
  String get costProviderRequired => 'Insira el nome del fornecedor';

  @override
  String get costProviderMinLength =>
      'El nome debe tener al menos 3 caracteres';

  @override
  String get costObservationsLabel => 'Observações';

  @override
  String get costFieldRequired => 'Este campo es obrigatório';

  @override
  String get costDraftRestoreMessage =>
      'Deseja restaurar o rascunho salvo anteriormente?';

  @override
  String get costSavedMomentAgo => 'Salvard a moment ago';

  @override
  String costSavedMinutesAgo(String minutes) {
    return 'Salvard $minutes min ago';
  }

  @override
  String get inventoryConfirmDefault => 'Confirmar';

  @override
  String get inventoryCancelDefault => 'Cancelar';

  @override
  String get inventoryMovementType => 'Movement tipo';

  @override
  String get inventoryEnterQuantity => 'Insira una quantidade';

  @override
  String get inventoryEnterValidNumber => 'Insira um número válido maior que 0';

  @override
  String get inventoryQuantityExceedsStock =>
      'Quantidade mayor al estoque disponível';

  @override
  String get inventoryProviderLabel => 'Fornecedor';

  @override
  String get inventoryDeleteItem => 'Excluir Item';

  @override
  String inventoryNewStock(Object unit) {
    return 'Novo estoque ($unit)';
  }

  @override
  String get inventoryEntryRegistered => 'Entry registrared';

  @override
  String get inventoryExitRegistered => 'Exit registrared';

  @override
  String get inventoryNoItems => 'Não há itens que correspondam aos filtros';

  @override
  String get inventoryNoMovementsSearch =>
      'Não há movimentos que correspondam à sua busca';

  @override
  String get inventoryNoMovements => 'No movements registrared yet';

  @override
  String get inventoryEditItem => 'Editar Item';

  @override
  String get inventoryNoProductsAvailable => 'No hay produtos disponívels';

  @override
  String get inventoryErrorLoading => 'Erro al carregar inventário';

  @override
  String get inventoryHistoryError => 'Erro al carregar movimientos';

  @override
  String get inventoryHistoryNoFilters =>
      'No movements with the aplicado filters';

  @override
  String get inventoryMovementTypeLabel => 'Movement tipo';

  @override
  String get inventoryList => 'Lista';

  @override
  String get inventoryNoImage => 'No imagem added';

  @override
  String get inventoryExpirationDateOptional => 'Data de vencimento (opcional)';

  @override
  String get inventorySelectDate => 'Selecionar data';

  @override
  String get inventoryAdditionalDetails => 'Detalhes Adicionales';

  @override
  String get inventoryStockSummary => 'Estoque';

  @override
  String get inventoryTotalItems => 'Total de Itens';

  @override
  String get inventoryLowStock => 'Estoque Baixo';

  @override
  String get inventoryOutOfStock => 'Esgotados';

  @override
  String get inventoryExpiringSoon => 'Próximo a Vencer';

  @override
  String get inventoryDescriptionLabel => 'Descrição';

  @override
  String get inventoryRegistrationDate => 'Data de registro';

  @override
  String get inventoryLastUpdate => 'Última atualização';

  @override
  String get inventoryRegisteredBy => 'Registrado por';

  @override
  String inventoryError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get inventoryItemFormType => 'Tipo';

  @override
  String get inventoryItemFormBasic => 'Básico';

  @override
  String get inventoryItemFormStock => 'Estoque';

  @override
  String get inventoryItemFormDetails => 'Detalhes';

  @override
  String get inventoryImageError => 'Erro al selecionar imagen';

  @override
  String get inventoryImageUploadFailed => 'Could not upload the imagem';

  @override
  String get inventoryImageSaveWithout => 'El item se salvará sin imagen';

  @override
  String get inventorySaveBtn => 'Salvar';

  @override
  String get healthSelectLocation => 'Selecionar Localização';

  @override
  String get healthSelectBatch => 'Selecionar Lote';

  @override
  String get healthErrorLoadingFarms => 'Erro al carregar granjas';

  @override
  String get healthNoActiveBatches => 'Sem lotes ativos';

  @override
  String get commonNext => 'Seguinte';

  @override
  String get commonPrevious => 'Anterior';

  @override
  String get commonSaving => 'Salvando...';

  @override
  String get commonSavedJustNow => 'Salvard just now';

  @override
  String commonSavedSecondsAgo(String seconds) {
    return 'Salvard ${seconds}s ago';
  }

  @override
  String commonSavedMinutesAgo(Object minutes) {
    return 'Salvard ${minutes}m ago';
  }

  @override
  String commonSavedHoursAgo(String hours) {
    return 'Salvard ${hours}h ago';
  }

  @override
  String get commonExitWithoutComplete => 'Sair sem completar?';

  @override
  String get commonVerifyConnection => 'Verifique sua conexão com a internet';

  @override
  String get commonOperationSuccess => 'Operation sucessoful';

  @override
  String get farmStartFirstFarm => 'Comienza tu primeira granja';

  @override
  String get farmStartFirstFarmDesc =>
      'Registra tu granja avícola y comienza a gestionar tu produção de manera eficiente';

  @override
  String get farmNoFarmsFound => 'No granjas found';

  @override
  String get farmNoFarmsFoundHint =>
      'Tente ajustar os filtros ou buscar com outros termos';

  @override
  String get farmCreateNewFarmTooltip => 'Criar nova granja';

  @override
  String get farmDeletedSuccess => 'Granja excluird sucessofully';

  @override
  String get farmFarmNotExists => 'The requested granja does not exist';

  @override
  String get farmGeneralInfo => 'Informações Geral';

  @override
  String get farmNotes => 'Notas';

  @override
  String get farmActivate => 'Ativar';

  @override
  String get farmActivateFarm => 'Ativar granja';

  @override
  String farmActivateConfirmMsg(Object name) {
    return 'Ativar \"$name\"?';
  }

  @override
  String get farmActivateInfo => 'Você poderá operar normalmente.';

  @override
  String get farmSuspend => 'Suspender';

  @override
  String get farmSuspendFarm => 'Suspend granja';

  @override
  String farmSuspendConfirmMsg(Object name) {
    return 'Suspender \"$name\"?';
  }

  @override
  String get farmSuspendInfo => 'No podrás criar novos lotes.';

  @override
  String get farmMaintenanceFarm => 'Poner en manutenção';

  @override
  String farmMaintenanceConfirmMsg(Object name) {
    return 'Colocar \"$name\" em manutenção?';
  }

  @override
  String get farmMaintenanceInfo => 'As operações serão limitadas.';

  @override
  String farmDeleteConfirmName(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get farmDeleteIrreversible => 'Esta ação é irreversível:';

  @override
  String get farmDeleteWillRemoveShedsAll =>
      '• Se excluirán todos los galpões\n• Se excluirán todos los lotes\n• Se excluirán todos los registros';

  @override
  String get farmWriteNameToConfirm => 'Escribe el nome para confirmar:';

  @override
  String get farmWriteHere => 'Tipo here';

  @override
  String get farmAlreadyActive => 'The granja is already ativo';

  @override
  String get farmAlreadySuspended => 'The granja is already suspended';

  @override
  String get farmActivatedSuccess => 'Granja activada com sucesso';

  @override
  String get farmSuspendedSuccess => 'Granja suspendida com sucesso';

  @override
  String get farmMaintenanceSuccess => 'Granja puesta en manutenção';

  @override
  String get farmDraftFound => 'Rascunho encontrado';

  @override
  String farmDraftFoundMsg(String date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String farmTodayAt(String time) {
    return 'hoje a las $time';
  }

  @override
  String get farmYesterday => 'ontem';

  @override
  String farmDaysAgo(String days) {
    return 'hace $days dias';
  }

  @override
  String get farmEnterBasicData =>
      'Insira los datos principales de tu granja avícola';

  @override
  String get farmInfoUsedToIdentify =>
      'This data will be used to identify your granja in the system.';

  @override
  String get farmUserNotAuthenticated => 'Usuário not authenticated';

  @override
  String get farmFilterAll => 'Todos';

  @override
  String get farmFilterActive => 'Ativo';

  @override
  String get farmFilterInactive => 'Inativo';

  @override
  String get farmFilterMaintenance => 'Manutenção';

  @override
  String farmSemantics(Object name, Object status) {
    return 'Granja $name, status $status';
  }

  @override
  String get farmViewSheds => 'Ver Galpões';

  @override
  String get farmStatusActiveDesc => 'Operando normalmente';

  @override
  String get farmStatusInactiveDesc => 'Operações suspensas';

  @override
  String get farmStatusMaintenanceDesc => 'En proceso de manutenção';

  @override
  String get farmContinueEditing => 'Continue editaring';

  @override
  String get farmSelectCountry => 'Selecione el país';

  @override
  String get farmSelectDepartment => 'Selecione el departamento';

  @override
  String get farmSelectCity => 'Selecione la ciudad';

  @override
  String get farmEnterAddress => 'Insira la dirección';

  @override
  String get farmAddressMinLength =>
      'Endereço must be at least 10 characters long';

  @override
  String get farmEnterEmail => 'Insira el e-mail';

  @override
  String get farmEnterValidEmail => 'Insira un e-mail válido';

  @override
  String get farmEnterPhone => 'Insira el telefone';

  @override
  String farmPhoneLength(String length) {
    return 'El telefone debe tener $length dígitos';
  }

  @override
  String get farmOnlyActiveCanMaintenance =>
      'Solo se puede poner en manutenção una granja activa';

  @override
  String get farmInfoCopiedToClipboard => 'Informações copiada al portapapeles';

  @override
  String get farmTotalOccupation => 'Ocupação Total';

  @override
  String get farmBirds => 'aves';

  @override
  String farmOfCapacityBirds(String capacity) {
    return 'of $capacity aves';
  }

  @override
  String get farmActiveSheds => 'Ativo Galpãos';

  @override
  String farmOfTotal(String total) {
    return 'de $total';
  }

  @override
  String get farmBatchesInProduction => 'Lotes en Produção';

  @override
  String farmMoreSheds(Object count) {
    return '+ $count galpão(es) más';
  }

  @override
  String get shedOccupation => 'Ocupação';

  @override
  String shedBirdsCount(String current, Object max) {
    return '$current / $max aves';
  }

  @override
  String get commonViewAll => 'Ver Todos';

  @override
  String commonErrorWithDetail(Object error) {
    return 'Erro: $error';
  }

  @override
  String get commonSummary2 => 'Resumo';

  @override
  String get commonMaintShort => 'Manut.';

  @override
  String get commonMaintenance => 'Manutenção';

  @override
  String get commonNotDefined => 'Não definido';

  @override
  String get commonOccurredError => 'Ocurrió un erro';

  @override
  String get commonFieldIsRequired => 'Este campo es obrigatório';

  @override
  String commonFieldRequired2(String label) {
    return '$label es obrigatório';
  }

  @override
  String commonSelect(String field) {
    return 'Selecione $field';
  }

  @override
  String commonFirstSelect(Object field) {
    return 'Primeiro selecione $field';
  }

  @override
  String get commonMustBeValidNumber => 'Deve ser um número válido';

  @override
  String commonMustBeBetween(String min, Object max) {
    return 'Deve estar entre $min e $max';
  }

  @override
  String get commonEnterValidNumber => 'Insira um número válido';

  @override
  String get commonVerifying => 'Verificando...';

  @override
  String get commonJoining => 'Ingressando...';

  @override
  String get commonUpdate2 => 'Atualizar';

  @override
  String get commonRefresh => 'Atualizar';

  @override
  String get commonYouTag => 'Você';

  @override
  String get commonNoName => 'Sin nome';

  @override
  String get commonNoEmail => 'Sin e-mail';

  @override
  String commonSince(Object date) {
    return 'Desde: $date';
  }

  @override
  String get commonPermissions => 'Permissões';

  @override
  String get commonSelected => 'Selecionedo';

  @override
  String get commonShare => 'Compartilhar';

  @override
  String commonValidUntil(Object date) {
    return 'Válido até $date';
  }

  @override
  String get farmEnvironmentalThresholds => 'Limitees Ambientales';

  @override
  String get farmHumidity => 'Umidade';

  @override
  String get farmCo2Max => 'CO₂ Máximo';

  @override
  String get farmAmmoniaMax => 'Amônia Máximo';

  @override
  String get farmCapacityInstallations => 'Capacidade e Instalaciones';

  @override
  String get farmTechnicalDataOptional =>
      'Technical granja data (all opcional)';

  @override
  String get farmMaxBirdCapacity => 'Capacidade Máxima de Aves';

  @override
  String get farmMaxBirdsLimit => 'Maximum 1,000,000 aves';

  @override
  String get farmTotalArea => 'Área Total';

  @override
  String get farmNumberOfSheds => 'Número de Galpões';

  @override
  String get farmShedsUnit => 'galpões';

  @override
  String get farmMaxShedsLimit => 'Máximo 100 galpões';

  @override
  String get farmUsefulInfo => 'Informações útil';

  @override
  String get farmTechnicalDataHelp =>
      'Estos datos ajudarán a planificar lotes y calcular densidad poblacional.';

  @override
  String get farmPreciseLocation => 'Localização precisa';

  @override
  String get farmLocationHelp =>
      'Una localização correcta facilita la logística y visitas técnicas.';

  @override
  String get farmExactLocation => 'Localização exacta de la granja';

  @override
  String get farmAddress => 'Endereço';

  @override
  String get farmAddressHint => 'Ex: Av. Principal 123, Urbanización...';

  @override
  String get farmReferenceOptional => 'Reference (opcional)';

  @override
  String get farmReferenceHint => 'Cerca de..., frente a..., a 2 cuadras de...';

  @override
  String get farmGpsCoordinatesOptional => 'GPS Coordinates (opcional)';

  @override
  String get farmLatitude => 'Latitud';

  @override
  String get farmLatitudeHint => 'Ex: -12.0464';

  @override
  String get farmLongitude => 'Longitud';

  @override
  String get farmLongitudeHint => 'Ex: -77.0428';

  @override
  String get farmContactInfo => 'Informações de Contacto';

  @override
  String get farmContactInfoDesc => 'Dados de contato para comunicação';

  @override
  String get farmEmailLabel => 'E-mail Electrónico';

  @override
  String get farmEmailHint => 'exemplo@email.com';

  @override
  String get farmWhatsappOptional => 'WhatsApp (opcional)';

  @override
  String get farmContactDataTitle => 'Dados de contato';

  @override
  String get farmContactDataHelp =>
      'Esta informações se usará para notificaciones importantes.';

  @override
  String get farmPhoneLabel => 'Telefone';

  @override
  String farmFiscalDocOptional(Object label) {
    return '$label (opcional)';
  }

  @override
  String get farmInvalidRifFormat =>
      'Formato de RIF inválido (ex: J-12345678-9)';

  @override
  String farmRucMustHaveDigits(Object count) {
    return 'El CNPJ debe tener $count dígitos';
  }

  @override
  String get farmInvalidNitFormat =>
      'Formato de NIT inválido (ex: 900123456-7)';

  @override
  String get farmRucMustStartWith => 'El CNPJ debe iniciar con 10, 15, 17 o 20';

  @override
  String get farmCapacityHint => 'Ex: 10000';

  @override
  String get farmAreaHint => 'Ex: 5000';

  @override
  String get farmShedsHint => 'Ex: 5';

  @override
  String get farmActiveFarmsLabel => 'Ativo';

  @override
  String get farmInactiveFarmsLabel => 'Inativo';

  @override
  String get farmStatusActive => 'Ativo';

  @override
  String get farmStatusInactive => 'Inativo';

  @override
  String get farmOverpopulationDetected => 'Superpopulação detectada';

  @override
  String get farmOutdatedData => 'Datos desatualizados';

  @override
  String get farmShedsWithoutBatches => 'Galpões sin lotes asignados';

  @override
  String get farmLoadDashboardError => 'Erro al carregar dashboard';

  @override
  String get farmActiveBatches => 'Lotes Ativos';

  @override
  String get farmActiveShedsLabel => 'Galpões Ativos';

  @override
  String get farmAlertsTitle => 'Alertas';

  @override
  String get farmInviteUser => 'Convidar Usuario';

  @override
  String get farmMustLoginToInvite =>
      'Debes iniciar sesión para convidar usuarios';

  @override
  String get farmNoPermToInvite =>
      'Você não tem permissões para convidar usuários para esta granja.\nApenas proprietários, administradores e gestores podem convidar.';

  @override
  String get farmNoPermissions => 'Sin Permissões';

  @override
  String get farmWhatRoleWillUserHave => 'What função will the usuário have?';

  @override
  String get farmChoosePermissions =>
      'Elige los permissões que tendrá en tu granja';

  @override
  String get farmRoleFullControl => 'Full granja control';

  @override
  String get farmRoleFullManagement =>
      'Gestão completa, sin transferir propiedad';

  @override
  String get farmRoleOperationsMgmt => 'Gestão de operações y personal';

  @override
  String get farmRoleDailyRecords => 'Registros diários y tareas operativas';

  @override
  String get farmRoleViewOnly => 'Somente visualização de dados';

  @override
  String get farmPermAll => 'Todos';

  @override
  String get farmPermEdit => 'Editar';

  @override
  String get farmPermInvite => 'Convidar';

  @override
  String get farmPermManage => 'Gestionar';

  @override
  String get farmPermRecords => 'Registros';

  @override
  String get farmPermView => 'Ver';

  @override
  String get farmPermViewData => 'Ver datos';

  @override
  String get farmPermReadOnly => 'Solo lectura';

  @override
  String farmVerifyPermError(Object error) {
    return 'Erro al verificar permissões: $error';
  }

  @override
  String get farmGenerateCode => 'Generate Código';

  @override
  String get farmGenerateNewCode => 'Generar novo código';

  @override
  String get farmCodeGenerated => 'Código generated!';

  @override
  String farmInvitationSubject(Object farmName) {
    return 'Convite para $farmName';
  }

  @override
  String farmInvitationMessage(
    String farmName,
    String code,
    String role,
    String expiry,
  ) {
    return 'Convido você a colaborar na minha granja \"$farmName\"! Use o código: $code\nFunção: $role\nVálido até: $expiry';
  }

  @override
  String farmCollaboratorsCount(Object count) {
    return '$count colaborador(s)';
  }

  @override
  String get farmInviteCollaboratorToFarm => 'Convidar colaborador a la granja';

  @override
  String get farmNoCollaborators => 'No colaboradors';

  @override
  String get farmInviteHelpText =>
      'Invita a outros usuarios para que puedan ajudarte a gestionar esta granja.';

  @override
  String get farmChangeRoleTo => 'Change função to:';

  @override
  String get farmLeaveFarm => 'Leave granja';

  @override
  String get farmRemoveUser => 'Remove usuário';

  @override
  String get farmCannotChangeOwnerRole =>
      'Não é possível alterar a função do proprietário';

  @override
  String get farmCannotRemoveOwner => 'No se puede remover al proprietário';

  @override
  String get farmRemoveCollaborator => 'Remove Colaborador';

  @override
  String get farmConfirmLeave => 'Are you sure you want to leave this granja?';

  @override
  String get farmConfirmRemoveUser =>
      'Are you sure you want to remove this usuário?';

  @override
  String get farmLeaveAction => 'Sair';

  @override
  String get farmRemoveAction => 'Remover';

  @override
  String get farmLeftFarm => 'You have left the granja';

  @override
  String get farmCollaboratorRemoved => 'Colaborador removed';

  @override
  String get farmJoinFarm => 'Join Granja';

  @override
  String get farmCodeValid => 'Valid código!';

  @override
  String get farmInvitedBy => 'Convidard by';

  @override
  String get farmWhatRoleYouWillHave => 'What função will you have?';

  @override
  String get farmJoinTheFarm => 'Join the Granja';

  @override
  String get farmUseAnotherCode => 'Usar outro código';

  @override
  String get farmWelcome => '¡Bienvenido!';

  @override
  String get farmJoinedSuccessTo => 'Te has unido com sucesso a';

  @override
  String farmAsRole(Object role) {
    return 'Como $role';
  }

  @override
  String get farmViewMyFarms => 'View My Granjas';

  @override
  String get farmHaveInvitation => 'Tem um convite?';

  @override
  String get farmEnterSharedCode =>
      'Insira el código que te compartieron para unirte a una granja';

  @override
  String get farmInvitationCode => 'Invitation Código';

  @override
  String get farmVerifyCode => 'Verify Código';

  @override
  String get farmEnterValidCode => 'Insira un código válido';

  @override
  String get farmInvalidCodeFormat => 'The código format is not valid';

  @override
  String get farmCodeNotFound => 'Invitation código not found';

  @override
  String get farmCodeAlreadyUsed => 'This código has already been used';

  @override
  String get farmCodeExpired => 'This código has vencido';

  @override
  String get farmCodeNotValidOrExpired =>
      'Invitation código not valid or vencido';

  @override
  String get farmCodeHasExpiredLong => 'This invitation código has vencido';

  @override
  String get farmMustLoginToAccept => 'You must log in to aceitar invitations';

  @override
  String get farmAlreadyMember => 'You are already a member of this granja';

  @override
  String get farmAssigned => 'Asignado';

  @override
  String get farmGranjaLabel => 'Granja';

  @override
  String get farmPermFullControl => 'Control total';

  @override
  String get farmPermFullManagement => 'Gestão completa';

  @override
  String get farmPermDeleteFarm => 'Excluir granja';

  @override
  String get farmPermEditData => 'Editar datos';

  @override
  String get farmPermInviteUsers => 'Convidar usuarios';

  @override
  String get farmPermManageCollaborators => 'Manage colaboradors';

  @override
  String get farmPermViewRecords => 'Ver registros';

  @override
  String get farmPermCreateRecords => 'Criar registros';

  @override
  String get farmPermRegisterTasks => 'Registrar tasks';

  @override
  String get farmPermViewStats => 'Ver estadísticas';

  @override
  String get farmPermissions => 'Permissões';

  @override
  String get commonGoToHome => 'Ir al Início';

  @override
  String get farmTheFarm => 'the granja';

  @override
  String get commonCheckConnection => 'Verifica tu conexión.';

  @override
  String get commonExitWithoutSaving => 'Sair sem salvar?';

  @override
  String get commonYouHaveUnsavedChanges => 'Você tem alterações não salvas.';

  @override
  String get commonContinueEditing => 'Continue editaring';

  @override
  String get commonNotes => 'Notas';

  @override
  String get commonJustNow => 'ahora mismo';

  @override
  String commonSecondsAgo(Object seconds) {
    return 'hace ${seconds}s';
  }

  @override
  String commonMinutesAgo(Object minutes) {
    return 'hace ${minutes}m';
  }

  @override
  String commonHoursAgo(Object hours) {
    return 'hace ${hours}h';
  }

  @override
  String get commonYesterday => 'ontem';

  @override
  String commonDaysAgo(Object days) {
    return 'hace $days dias';
  }

  @override
  String commonTodayAt(Object time) {
    return 'hoje a las $time';
  }

  @override
  String commonSavedAt(Object time) {
    return 'Salvard $time';
  }

  @override
  String get commonActivePlural => 'Ativo';

  @override
  String get commonInactivePlural => 'Inativo';

  @override
  String get commonAdjustFilters =>
      'Tente ajustar os filtros ou buscar com outros termos';

  @override
  String get shedStepBasic => 'Básico';

  @override
  String get shedStepSpecifications => 'Especificaciones';

  @override
  String get shedStepEnvironment => 'Ambiente';

  @override
  String get shedDraftFound => 'Rascunho encontrado';

  @override
  String shedDraftFoundMessage(Object date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String shedCreatedSuccess(Object name) {
    return 'Galpão \"$name\" criado!';
  }

  @override
  String shedUpdatedSuccess(Object name) {
    return 'Galpão \"$name\" atualizado!';
  }

  @override
  String get shedExitWithoutCompleting => 'Sair sem completar?';

  @override
  String get shedDataIsSafe => 'Não se preocupe, seus dados estão seguros.';

  @override
  String get shedStartFirstShed => 'Comienza tu primer galpão';

  @override
  String get shedStartFirstShedDesc =>
      'Registra tu primer galpão avícola y comienza a gestionar la produção';

  @override
  String get shedNoShedsFound => 'No se encontraron galpões';

  @override
  String get shedDeletedMsg => 'Galpão eliminado';

  @override
  String get shedDeletedCorrectly => 'Galpão eliminado correctamente';

  @override
  String get shedChangeStatus => 'Alterar status';

  @override
  String get shedGeneralInfo => 'Informações Geral';

  @override
  String get shedInfrastructure => 'Infraestructura';

  @override
  String get shedSensorsEquipment => 'Sensores e Equipamentos';

  @override
  String get shedGeneralStats => 'Estatísticas Gerais';

  @override
  String get shedByStatus => 'Por status';

  @override
  String get shedNoTags => 'Sin etiquetas';

  @override
  String get shedRequestedNotExist => 'El galpão solicitado no existe';

  @override
  String get shedDisinfection => 'Desinfecção';

  @override
  String get shedQuarantine => 'Quarentena';

  @override
  String get shedSelectType => 'Selecione el tipo de galpão';

  @override
  String get shedEnterBirdCapacity => 'Insira la capacidade de aves';

  @override
  String get shedCapacityMustBePositive => 'La capacidade debe ser mayor a 0';

  @override
  String get shedCapacityTooHigh => 'A capacidade parece muito alta';

  @override
  String get shedEnterArea => 'Insira el área en m²';

  @override
  String get shedAreaMustBePositive => 'El área debe ser mayor a 0';

  @override
  String get shedAreaTooLarge => 'El área parece muy grande';

  @override
  String get shedEnterMaxTemp => 'Insira la temperatura máxima';

  @override
  String get shedEnterMinTemp => 'Insira la temperatura mínima';

  @override
  String get shedTempMinLessThanMax =>
      'Minimum temperatura must be less than maximum';

  @override
  String get shedEnterMaxHumidity => 'Insira la umidade máxima';

  @override
  String get shedEnterMinHumidity => 'Insira la umidade mínima';

  @override
  String get shedHumidityMinLessThanMax =>
      'La umidade mínima debe ser menor que la máxima';

  @override
  String get shedBasicInfo => 'Informações Básicas';

  @override
  String get shedBasicInfoDesc =>
      'Insira los datos principales del galpão avícola';

  @override
  String get shedNameHint => 'Ex: Galpão Principal, Ponedoras Norte';

  @override
  String get shedMinChars => 'Mínimo 3 caracteres';

  @override
  String get shedDescriptionOptional => 'Descrição (opcional)';

  @override
  String get shedDescriptionHint =>
      'Descreva las características principales del galpão...';

  @override
  String get shedSelectShedType => 'Selecione un tipo de galpão';

  @override
  String get shedImportantInfo => 'Informação importante';

  @override
  String get shedCodeAutoGenerated =>
      'El código del galpão se genera automáticamente basado en el nome de la granja y el número de galpões existentes.';

  @override
  String get shedSpecsDesc =>
      'Configure a capacidade e o equipamento do galpão';

  @override
  String get shedMaxBirdCapacity => 'Capacidade Máxima de Aves';

  @override
  String get shedMustBeValidNumber => 'Deve ser um número válido';

  @override
  String get shedMustBePositiveNumber => 'Deve ser um número positivo';

  @override
  String get shedNumberTooLarge => 'El número es demasiado grande';

  @override
  String get shedTotalArea => 'Área Total';

  @override
  String get shedAreaRequired => 'El área es obrigatória';

  @override
  String get shedNumberSeemsHigh => 'El número parece muy alto';

  @override
  String get shedUsefulInfo => 'Informações útil';

  @override
  String get shedDensityPlanningHelp =>
      'Estos datos ajudarán a planificar lotes y calcular densidad poblacional.';

  @override
  String get shedRecommendedDensities => 'Densidades recomendadas';

  @override
  String get shedEnvironmentalConditions => 'Condiciones Ambientales';

  @override
  String get shedMinLabel => 'Mínima';

  @override
  String get shedMaxLabel => 'Máxima';

  @override
  String get shedInvalidTempRange => 'Valor inválido (0-50)';

  @override
  String get shedRelativeHumidity => 'Umidade Relativa';

  @override
  String get shedInvalidHumidityRange => 'Valor inválido (0-100)';

  @override
  String get shedVentilation => 'Ventilação';

  @override
  String get shedInvalidValue => 'Valor inválido';

  @override
  String get shedEnvironmentalAlertHelp =>
      'Os valores ambientais configurados serão usados para gerar alertas automáticos quando as condições reais estiverem fora da faixa especificada.';

  @override
  String get shedShedType => 'Tipo de Galpão';

  @override
  String get shedMaxCapacity => 'Capacidade Máxima';

  @override
  String get shedCurrentBirdsLabel => 'Aves Atuais';

  @override
  String shedCurrentBirdsValue(Object count) {
    return '$count aves';
  }

  @override
  String get shedOccupationLabel => 'Ocupação';

  @override
  String get shedAreaLabel => 'Área';

  @override
  String get shedLocationLabel => 'Localização';

  @override
  String get shedOccupationTitle => 'Ocupação del Galpão';

  @override
  String get shedOptimal => 'Óptimo';

  @override
  String get shedAdjust => 'Ajustar';

  @override
  String get shedVentilationSystem => 'Sistema de Ventilação';

  @override
  String get shedHeatingSystem => 'Sistema de Aquecimento';

  @override
  String get shedLightingSystem => 'Sistema de Iluminação';

  @override
  String get shedAmmonia => 'Amônia';

  @override
  String get shedAssignBatch => 'Assign lote';

  @override
  String get shedRegisterDisinfection => 'Registrar\nDesinfecção';

  @override
  String shedDisinfectedDaysAgo(Object days) {
    return 'Desinfectado hace $days dias';
  }

  @override
  String shedMaintenanceOverdue(Object days) {
    return 'Manutenção vencido hace $days dias';
  }

  @override
  String get shedMaintenanceToday => 'Manutenção programado para hoje';

  @override
  String shedMaintenanceInDays(Object days) {
    return 'Manutenção en $days dias';
  }

  @override
  String get shedViewBatches => 'View Lotees';

  @override
  String get shedRegisterDisinfectionAction => 'Registrar\nDesinfecção';

  @override
  String get shedActiveBatch => 'Lote Ativo';

  @override
  String get shedAvailableForNewBatch =>
      'Este galpão está disponível para receber um novo lote';

  @override
  String get shedAssignBatchLabel => 'Assign Lote';

  @override
  String shedNotAvailableForBatch(Object status) {
    return 'Galpão no disponível ($status)';
  }

  @override
  String get shedNotAvailableForAssign =>
      'El galpão no está disponível para asignar lotes';

  @override
  String get shedNoBatchAssigned => 'El galpão no tiene lote asignado';

  @override
  String get shedInfoCopied => 'Informações copiada al portapapeles';

  @override
  String get shedCannotDeleteWithBatch =>
      'No se puede excluir un galpão con lote asignado';

  @override
  String get shedSelectBatchForAssign =>
      'Selecione un lote para asignar al galpão';

  @override
  String get shedHistoryTitle => 'Historial del Galpão';

  @override
  String get shedEventsAppearHere => 'Los eventos del galpão aparecerán aquí';

  @override
  String get shedCreatedEvent => 'Galpão criado';

  @override
  String shedCreatedEventDesc(Object name) {
    return 'Se registró el galpão $name';
  }

  @override
  String get shedDisinfectionDone => 'Desinfecção realizada';

  @override
  String get shedDisinfectionDoneDesc => 'Se realizó desinfecção del galpão';

  @override
  String get shedMaintenanceOverdueEvent => 'Manutenção vencido';

  @override
  String get shedMaintenanceScheduledEvent => 'Manutenção programado';

  @override
  String get shedMaintenanceOverdueDesc =>
      'El manutenção estaba programado para esta data';

  @override
  String get shedMaintenanceScheduledDesc => 'Próximo manutenção del galpão';

  @override
  String get shedBatchFinished => 'Lote finigalpão';

  @override
  String shedBatchFinishedDesc(String id) {
    return 'Lote $id was finigalpão';
  }

  @override
  String get shedLastUpdate => 'Última atualização';

  @override
  String get shedLastUpdateDesc => 'Se actualizó la informações del galpão';

  @override
  String get shedOccupancyLevel => 'Nivel de ocupação';

  @override
  String get shedAssignedBatch => 'Assigned lote';

  @override
  String get shedLastDisinfection => 'Última desinfecção';

  @override
  String get shedNextMaintenance => 'Próximo manutenção';

  @override
  String shedDaysAgoLabel(Object days) {
    return 'Hace $days dias';
  }

  @override
  String shedOverdueDaysAgo(Object days) {
    return 'Vencido hace $days dias';
  }

  @override
  String get shedToday => 'Hoje';

  @override
  String shedInDays(Object days) {
    return 'En $days dias';
  }

  @override
  String get shedStatsTitle => 'Estadísticas de Galpões';

  @override
  String get shedTotalCapacity => 'Capacidade Total';

  @override
  String get shedTotalBirds => 'Aves Totais';

  @override
  String get shedStatsRealtime => 'Statistics are atualizard in real time';

  @override
  String get shedViewActiveBatch => 'Ver Lote Ativo';

  @override
  String get shedFilterSheds => 'Filtrar galpões';

  @override
  String get shedSelectStatus => 'Selecionar status';

  @override
  String get shedSelectTypeFilter => 'Selecionar tipo';

  @override
  String get shedMinCapacity => 'Capacidade minima';

  @override
  String get shedActivateTitle => 'Ativar galpão';

  @override
  String get shedActivateAction => 'Ativar';

  @override
  String get shedActivateInfo => 'Você poderá operar normalmente.';

  @override
  String get shedSuspendTitle => 'Suspender galpão';

  @override
  String get shedSuspendAction => 'Suspender';

  @override
  String get shedSuspendInfo => 'No podrás criar novos lotes.';

  @override
  String get shedMaintenanceTitle => 'Poner en manutenção';

  @override
  String get shedMaintenanceInfo => 'As operações serão limitadas.';

  @override
  String get shedDisinfectionAction => 'Confirmar';

  @override
  String get shedDisinfectionAvailInfo => 'El galpão no estará disponível.';

  @override
  String get shedReleaseTitle => 'Liberar galpão';

  @override
  String get shedReleaseAction => 'Liberar';

  @override
  String get shedReleaseInfo => 'The current lote will be unlinked.';

  @override
  String get shedDeleteTitle => 'Excluir galpão';

  @override
  String shedDeleteConfirmMsg(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get shedDeleteIrreversible => 'Esta ação é irreversível:';

  @override
  String get shedDeleteConsequences =>
      ' Se excluirán los registros del galpão\n Se desvincularán los lotes asociados\n Se perderá el historial de operações';

  @override
  String get shedWriteHere => 'Escribe aquí';

  @override
  String get shedStatusActiveDesc => 'Operação normal habilitada';

  @override
  String get shedStatusInactiveDesc => 'Operaciones pausadas temporalmente';

  @override
  String get shedStatusMaintenanceDesc => 'En proceso de manutenção';

  @override
  String get shedStatusQuarantineDesc => 'Aislado por quarentena sanitaria';

  @override
  String get shedStatusDisinfectionDesc => 'En proceso de desinfecção';

  @override
  String get shedRegisterDisinfectionTitle => 'Registrar desinfecção';

  @override
  String get shedSelectProductsFromInventory =>
      'Selecione produtos del inventário para descontar automáticamente';

  @override
  String get shedAdditionalObservations => 'Observações adicionales';

  @override
  String get shedScheduleMaintenance => 'Programar manutenção';

  @override
  String get shedMaintenanceDescriptionLabel => 'Descrição del manutenção *';

  @override
  String get shedMaintenanceDescriptionHint =>
      'Ex: Revisión de bebederos y comederos';

  @override
  String get shedEnterDescription => 'Insira una descrição';

  @override
  String shedWeeksAgo(Object count, Object label) {
    return 'Hace $count $label';
  }

  @override
  String get shedWeek => 'semana';

  @override
  String get shedWeeks => 'semanas';

  @override
  String get shedMonth => 'mês';

  @override
  String get shedMonths => 'mêses';

  @override
  String get shedYear => 'ano';

  @override
  String get shedYears => 'anos';

  @override
  String get shedNotSpecified => 'No especificada';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonSchedule => 'Programar';

  @override
  String get commonReason => 'Motivo';

  @override
  String get shedCurrentState => 'Status actual:';

  @override
  String get shedSelectNewState => 'Selecionar novo status:';

  @override
  String get shedWriteNameToConfirm => 'Escribe el nome para confirmar:';

  @override
  String get shedSelectProductsDesc => 'Produtos del inventário';

  @override
  String get shedProductsUsed => 'Produtos utilizados *';

  @override
  String get shedProductsHint => 'Ex: Amonio cuaternario, Cal viva';

  @override
  String get shedSeparateWithCommas => 'Setare multiples produtos con comas';

  @override
  String get shedObservationsHint => 'Observações adicionales';

  @override
  String get shedEnterAtLeastOneProduct => 'Insira al menos un produto';

  @override
  String get shedEnterReason => 'Insira el motivo';

  @override
  String get shedStartDateLabel => 'Data de início';

  @override
  String get shedCorralsDivisions => 'Corrales/Divisiones';

  @override
  String shedDivisionsCount(Object count) {
    return '$count divisiones';
  }

  @override
  String get shedWateringSystem => 'Águaing System';

  @override
  String get shedFeederSystem => 'Raçãoer System';

  @override
  String get shedChangeStateAction => 'Alterar status';

  @override
  String get shedReleaseLabel => 'Liberar';

  @override
  String get shedDensityLabel => 'Densidad';

  @override
  String shedMSquarePerBird(String value) {
    return '$value m² per ave';
  }

  @override
  String shedOfCapacity(String percentage) {
    return '$percentage% de capacidade';
  }

  @override
  String shedOfBirdsUnit(Object count) {
    return 'of $count aves';
  }

  @override
  String get shedScheduleMaintenanceGrid => 'Programar\nManutenção';

  @override
  String get shedViewHistory => 'Ver\nHistorial';

  @override
  String get shedViewBatchDetail => 'Ver Detalhe del Lote';

  @override
  String get shedNoAssignedBatch => 'No assigned lote';

  @override
  String get commonAvailable => 'Disponível';

  @override
  String get shedQuarantineReason => 'Motivo de quarentena';

  @override
  String shedBatchAssignedMsg(Object code) {
    return 'Lote $code assigned sucessofully';
  }

  @override
  String shedDeleteErrorMsg(Object message) {
    return 'Erro al excluir: $message';
  }

  @override
  String get shedCreateBatchFirst => 'Crea un novo lote primeiro';

  @override
  String get commonToday => 'Hoje';

  @override
  String get shedNoHistoryAvailable => 'Sin historial disponível';

  @override
  String get commonAssigned => 'Asignado';

  @override
  String shedBirdsOfCapacity(Object current, Object max) {
    return '$current / $max aves';
  }

  @override
  String shedShedsRegistered(Object count) {
    return '$count galpões registrados';
  }

  @override
  String get shedMoreOptions => 'Mais opções';

  @override
  String get shedOccurredError => 'Ocurrió un erro';

  @override
  String get shedSpecifications => 'Especificaciones';

  @override
  String get shedConfigureThresholds =>
      'Configure los limitees para monitoreo (opcional)';

  @override
  String get shedCapacityIsRequired => 'La capacidade es obrigatória';

  @override
  String get shedNameIsRequired => 'El nome es obrigatório';

  @override
  String get shedShedNameLabel => 'Nome del Galpão';

  @override
  String get shedTypeLabel => 'Tipo de Galpão';

  @override
  String get shedSelectTypeHint => 'Selecione el tipo';

  @override
  String get shedSelectStateHint => 'Selecione el status';

  @override
  String get shedDrinkersOptional => 'Drinkers (opcional)';

  @override
  String get shedFeedersOptional => 'Raçãoers (opcional)';

  @override
  String get shedNestsOptional => 'Nests (opcional)';

  @override
  String get shedTemperature => 'Temperatura';

  @override
  String get shedTip => 'Consejo';

  @override
  String get shedUnitsLabel => 'unidadees';

  @override
  String get shedDensityTypeCol => 'Tipo';

  @override
  String get shedDensityCol => 'Densidad';

  @override
  String get shedFattening => 'Engorde';

  @override
  String get shedLaying => 'Postura';

  @override
  String get shedBreeder => 'Reprodutora';

  @override
  String get shedActive => 'Ativo';

  @override
  String get shedInactive => 'Inativo';

  @override
  String shedSemanticsLabel(
    Object birds,
    Object code,
    Object name,
    Object status,
  ) {
    return 'Galpão $name, código $code, $birds aves, status $status';
  }

  @override
  String shedShareType(Object type) {
    return 'Tipo: $type';
  }

  @override
  String shedShareCapacity(Object count) {
    return 'Capacidade: $count aves';
  }

  @override
  String shedShareOccupation(Object percentage) {
    return 'Ocupação: $percentage%';
  }

  @override
  String shedBirdsBullet(Object count, Object type) {
    return '$count aves • $type';
  }

  @override
  String batchSemanticsLabel(
    String birdType,
    Object birds,
    Object code,
    Object status,
  ) {
    return 'Lote $code, $birdType, $birds aves, status $status';
  }

  @override
  String get batchDetails => 'Detalhes';

  @override
  String get batchViewRecords => 'Ver Registros';

  @override
  String get batchMoreOptions => 'Mais opções';

  @override
  String get batchMoreOptionsLote => 'Mais opções del lote';

  @override
  String get batchRetryLoadSemantics => 'Tentar novamente carga de lotes';

  @override
  String get batchStatusActive => 'Ativo';

  @override
  String get batchStatusClosed => 'Fechard';

  @override
  String get batchStatusQuarantine => 'Quarentena';

  @override
  String get batchStatusSold => 'Vendido';

  @override
  String get batchStatusTransfer => 'Transferencia';

  @override
  String get batchStatusSuspended => 'Suspendido';

  @override
  String get batchType => 'Tipo';

  @override
  String get batchBirds => 'Aves';

  @override
  String get batchAge => 'Edad';

  @override
  String get batchCloseBatch => 'Fechar Lote';

  @override
  String get batchConfirmClose => 'Confirmar Fechar';

  @override
  String get batchCloseIrreversibleWarning =>
      'Esta ação é IRREVERSÍVEL. O lote passará ao status encerrado e o galpão ficará disponível.\n\nTem certeza de que deseja encerrar este lote?';

  @override
  String get batchClosureData => 'Dados do Encerramento';

  @override
  String get batchCompleteClosureInfo =>
      'Complete la informações final del lote';

  @override
  String get batchLoteInfo => 'Informações del Lote';

  @override
  String batchInitialCountBirds(Object count) {
    return '$count aves';
  }

  @override
  String batchDaysInCycle(Object days) {
    return '$days dias';
  }

  @override
  String get batchCloseDateLabel => 'Data de Cierre *';

  @override
  String get batchCloseDateSimple => 'Data de Cierre';

  @override
  String get batchCloseDateHelper => 'Data en que se cierra el lote';

  @override
  String get batchCloseDatePicker => 'Data de cierre del lote';

  @override
  String get batchFinalBirdCount => 'Quantidade Final de Aves *';

  @override
  String batchFinalBirdCountHelper(Object max) {
    return 'Number of live aves at closing (max: $max)';
  }

  @override
  String get batchFinalAvgWeight => 'Peso Promédio Final';

  @override
  String get batchFinalAvgWeightHint => 'Ex: 2500';

  @override
  String get batchFinalAvgWeightHelper =>
      'Peso médio de las aves al cierre (en gramas)';

  @override
  String get batchClosureReason => 'Motivo do Encerramento';

  @override
  String get batchClosureReasonHint => 'Ex: Fin de ciclo productivo';

  @override
  String get batchClosureReasonHelper =>
      'Opcional - Reason for closing the lote';

  @override
  String get batchAdditionalNotes => 'Observações Adicionales';

  @override
  String get batchAdditionalNotesHint => 'Final lote notes...';

  @override
  String get batchBatchMetrics => 'Lote Metrics';

  @override
  String get batchCycleIndicators =>
      'Resumo de indicadores del ciclo productivo';

  @override
  String get batchSurvival => 'Supervivencia';

  @override
  String get batchInitialBirds => 'Initial Aves';

  @override
  String get batchFinalBirds => 'Final Aves';

  @override
  String get batchTotalMortality => 'Mortalidade Total';

  @override
  String batchMortalityBirds(Object count) {
    return '$count aves';
  }

  @override
  String get batchMortalityPercent => '% Mortalidade';

  @override
  String get batchSurvivalPercent => '% Supervivencia';

  @override
  String get batchCycleDuration => 'Duração del Ciclo';

  @override
  String get batchTotalDuration => 'Duração Total';

  @override
  String get batchAgeAtClose => 'Age at Fechar';

  @override
  String batchAgeAtCloseDays(Object days) {
    return '$days dias';
  }

  @override
  String get batchWeight => 'Peso';

  @override
  String get batchCurrentAvgWeightLabel => 'Peso Promédio Actual';

  @override
  String get batchTargetWeight => 'Target Peso';

  @override
  String get batchClosureSummary => 'Resumo del Cierre';

  @override
  String get batchClosureSummaryWarning =>
      'Revisa cuidadosamente toda la informações antes de confirmar el cierre. Esta acción es IRREVERSIBLE.';

  @override
  String get batchCloseWarningMessage =>
      'Al fechar el lote, este pasará a status CERRADO y el galpão quedará disponível para un novo lote.';

  @override
  String get batchFinalData => 'Datos Finales';

  @override
  String get batchFinalCount => 'Quantidade Final';

  @override
  String get batchMortalityTotal => 'Mortalidade Total';

  @override
  String get batchFinalWeightAvg => 'Peso Final Promédio';

  @override
  String get batchClosureNotes => 'Notas do Encerramento';

  @override
  String get batchReason => 'Motivo';

  @override
  String get batchObservations => 'Observações';

  @override
  String get batchPrevious => 'Anterior';

  @override
  String get batchNext => 'Seguinte';

  @override
  String get batchClosing => 'Closing lote...';

  @override
  String get batchCannotBeNegative => 'Não pode ser negativo';

  @override
  String get batchCannotExceedInitial =>
      'No puede ser mayor a la quantidade inicial';

  @override
  String get batchInvalidCount => 'Quantidade inválida';

  @override
  String get batchFinalCannotExceedInitial =>
      'La quantidade final no puede ser mayor a la inicial';

  @override
  String get batchNormalCycleClose => 'Normal cycle fechar';

  @override
  String batchErrorClosing(Object error) {
    return 'Erro al fechar lote: $error';
  }

  @override
  String get batchDraftFound => 'Rascunho encontrado';

  @override
  String batchDraftMessage(Object date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String get batchDraftRestore => 'Restaurar';

  @override
  String get batchDraftDiscard => 'Descartar';

  @override
  String get batchExitWithoutComplete => 'Sair sem completar?';

  @override
  String get batchDataSafe => 'Não se preocupe, seus dados estão seguros.';

  @override
  String get batchExit => 'Sair';

  @override
  String get batchSessionExpired =>
      'Tu sessão expirou. Por favor inicia sesión novamente';

  @override
  String get batchSaving => 'Salvando...';

  @override
  String batchSavedTime(Object time) {
    return 'Salvard $time';
  }

  @override
  String get batchRightNow => 'ahora mismo';

  @override
  String batchSecondsAgo(Object seconds) {
    return 'hace ${seconds}s';
  }

  @override
  String batchMinutesAgo(Object minutes) {
    return 'hace ${minutes}m';
  }

  @override
  String batchHoursAgo(Object hours) {
    return 'hace ${hours}h';
  }

  @override
  String batchTodayAt(Object time) {
    return 'hoje a las $time';
  }

  @override
  String get batchYesterday => 'ontem';

  @override
  String batchDaysAgo(Object days) {
    return 'hace $days dias';
  }

  @override
  String get batchCreateSuccess => 'Lote criado com sucesso!';

  @override
  String batchCreateSuccessDetail(Object code) {
    return '\"$code\" está pronto para gerenciar';
  }

  @override
  String get batchErrorCreating => 'Erro al criar el lote';

  @override
  String get batchUnexpectedError => 'Erro inesperado';

  @override
  String get batchCheckConnection =>
      'Por favor, verifica tu conexión e intenta novamente';

  @override
  String get batchBasicStep => 'Básico';

  @override
  String get batchDetailsStep => 'Detalhes';

  @override
  String get batchDataStep => 'Datos';

  @override
  String get batchMetricsStep => 'Métricas';

  @override
  String get batchConfirmStep => 'Confirmar';

  @override
  String get batchInfoStep => 'Informações';

  @override
  String get batchRangesStep => 'Rangos';

  @override
  String get batchSummaryStep => 'Resumo';

  @override
  String get batchDescriptionStep => 'Descrição';

  @override
  String get batchEvidenceStep => 'Evidencia';

  @override
  String get batchRegister => 'Registrar';

  @override
  String get batchWaitProcess => 'Aguarde o término do processo atual';

  @override
  String get batchWaitForProcess => 'Aguarde o término do processo';

  @override
  String get batchErrorLoadingData => 'Erro al carregar datos';

  @override
  String get batchLoadingCharts => 'Carregando gráficos...';

  @override
  String get batchChartsProduction => 'Gráficos de Produção';

  @override
  String get batchChartsWeight => 'Peso Charts';

  @override
  String get batchChartsMortality => 'Gráficos de Mortalidade';

  @override
  String get batchChartsConsumption => 'Gráficos de Consumo';

  @override
  String get batchRefresh => 'Atualizar';

  @override
  String get batchRefreshData => 'Atualizar datos';

  @override
  String get batchProductionHistory => 'Historial de produção';

  @override
  String get batchWeighingHistory => 'Historial de pesagems';

  @override
  String get batchMortalityHistory => 'Mortalidade history';

  @override
  String get batchConsumptionHistory => 'Histórico de consumo';

  @override
  String get batchRecent => 'Recientes';

  @override
  String get batchOldest => 'Antiguos';

  @override
  String get batchNoFilters => 'Sin filtros';

  @override
  String get batchDays7 => '7 dias';

  @override
  String get batchDays30 => '30 dias';

  @override
  String get batchHighPosture => 'Postura alta';

  @override
  String get batchMediumPosture => 'Postura media';

  @override
  String get batchLowPosture => 'Postura baja';

  @override
  String get batchBackToHistory => 'Voltar al historial';

  @override
  String get batchNoWeightData => 'Sem dados de peso';

  @override
  String get batchChartsAppearWhenData =>
      'Charts will appear when there are peso records';

  @override
  String get batchPosturePercentage => 'Porcentagem de Postura';

  @override
  String get batchPostureEvolution =>
      'Evolução da % de postura ao longo do tempo';

  @override
  String get batchDailyConsumption => 'Consumo Diário';

  @override
  String get batchKgPerDay => 'Kilogramas de alimento consumido por día';

  @override
  String get batchWeightEvolution => 'Peso Evolution';

  @override
  String get batchAccumulatedMortalityChart => 'Mortalidade Acumulada';

  @override
  String get batchAccumulatedMortalityDesc =>
      'Total accumulated morto aves over time';

  @override
  String get batchDailyMortality => 'Mortalidade Diaria';

  @override
  String get batchDailyGainAvg => 'Ganancia Diaria Promédio';

  @override
  String get batchUniformity => 'Uniformidad';

  @override
  String get batchStandardComparison => 'Comparação com Padrão';

  @override
  String get batchConsumptionPerBird => 'Consumption per Ave';

  @override
  String get batchFoodTypeDistribution => 'Distribution by Tipo';

  @override
  String get batchCosts => 'Custos';

  @override
  String get batchQuality => 'Calidad';

  @override
  String get batchDraftFoundGeneric =>
      'Foi encontrado um rascunho salvo. Deseja restaurá-lo?';

  @override
  String get batchNoAccessFarm => 'You don\'t have access to this granja';

  @override
  String get batchNoPermissionRecord =>
      'Você não tem permissões para registrar consumo nesta granja';

  @override
  String get batchDaysInCycleLabel => 'Dias en Ciclo';

  @override
  String get batchClosePrefix => '[Cierre]';

  @override
  String get batchCreateBatch => 'Criar Lote';

  @override
  String get batchClassificationStep => 'Classificação';

  @override
  String get batchObservationsStep => 'Observações';

  @override
  String get registerProductionTitle => 'Registrar Produção';

  @override
  String get registerWeightTitle => 'Registrar Pesagem';

  @override
  String get registerMortalityTitle => 'Registrar Mortalidade';

  @override
  String get registerConsumptionTitle => 'Registrar Consumo';

  @override
  String get productionRegistered => 'Produção registrada!';

  @override
  String productionRegisteredDetail(String eggs, String good) {
    return '$eggs ovos · $good boms';
  }

  @override
  String get weightRegistered => 'Pesagem registrada!';

  @override
  String get mortalityRegistered => 'Mortalidade registrada!';

  @override
  String get consumptionRegistered => '¡Consumo registrado!';

  @override
  String get batchMaxPhotosAllowed => 'Maximum 3 fotos allowed';

  @override
  String get batchPhotoExceeds5MB =>
      'Foto exceeds 5MB. Choose a smaller imagem';

  @override
  String productionGoodEggsExceedCollected(String collected, Object good) {
    return 'Los ovos boms ($good) no pueden ser más que los recolectados ($collected)';
  }

  @override
  String get productionNoAvailableBirds => 'El lote no tiene aves disponívels';

  @override
  String productionHighLayingPercent(String percent) {
    return 'El porcentagem de postura ($percent%) es mayor al 100%. Verifica los datos.';
  }

  @override
  String productionClassifiedExceedGood(String classified, Object good) {
    return 'Total clasificados ($classified) excede los ovos boms ($good)';
  }

  @override
  String get batchHighLayingTitle => 'Porcentagem de postura muito alta';

  @override
  String batchHighLayingMessage(Object percent) {
    return 'A porcentagem de postura é $percent%, que é excepcionalmente alta. Deseja continuar com estes dados?';
  }

  @override
  String get batchHighBreakageTitle => 'Alto porcentagem de rotura';

  @override
  String batchHighBreakageMessage(Object count, Object percent) {
    return 'A porcentagem de quebra é $percent% ($count ovos), que é superior aos 5% esperados. Deseja continuar?';
  }

  @override
  String get commonReviewData => 'Revisar datos';

  @override
  String get batchNoPermissionProduction =>
      'Você não tem permissões para registrar produção nesta granja';

  @override
  String batchErrorVerifyingPermissions(Object error) {
    return 'Erro al verificar permissões: $error';
  }

  @override
  String get productionFutureDate => 'La data de produção no puede ser futura';

  @override
  String get productionBeforeEntryDate =>
      'A data de produção não pode ser anterior à data de entrada do lote';

  @override
  String get batchFirebaseDbError => 'Erro de conexión con la base de datos';

  @override
  String get batchFirebasePermissionDenied =>
      'Você não tem permissões para realizar esta ação';

  @override
  String get batchFirebasePermissionDetail =>
      'Verifica tu sesión e intenta novamente';

  @override
  String get batchFirebaseUnavailable => 'Servicio no disponível';

  @override
  String get batchFirebaseUnavailableDetail =>
      'Verifica tu conexión a internet';

  @override
  String get batchFirebaseSessionExpired => 'Session vencido';

  @override
  String get batchFirebaseSessionDetail => 'Por favor inicia sesión novamente';

  @override
  String get batchNoPermissionWeight =>
      'Você não tem permissões para registrar pesagens nesta granja';

  @override
  String get batchNoPermissionMortality =>
      'Você não tem permissões para registrar mortalidade nesta granja';

  @override
  String get mortalityFutureDate => 'La data de mortalidad no puede ser futura';

  @override
  String get mortalityBeforeEntryDate =>
      'A data não pode ser anterior à data de entrada do lote';

  @override
  String get weightFutureDate => 'La data del pesagem no puede ser futura';

  @override
  String get weightBeforeEntryDate =>
      'A data não pode ser anterior à data de entrada do lote';

  @override
  String get consumptionFutureDate => 'La data de consumo no puede ser futura';

  @override
  String get consumptionBeforeEntryDate =>
      'A data não pode ser anterior à data de entrada do lote';

  @override
  String weightCannotExceedAvailable(Object count) {
    return 'La quantidade pesada no puede superar las aves actuales del lote ($count)';
  }

  @override
  String get weightMinMustBeLessThanMax =>
      'Minimum peso must be less than maximum peso';

  @override
  String get weightLowUniformityTitle => 'Uniformidad Baja Detectada';

  @override
  String weightLowUniformityMessage(String cv) {
    return 'El coeficiente de variação es $cv%, lo que indica baja uniformidad en el lote.';
  }

  @override
  String get weightCvRecommendedTitle => 'Valores recomendados de CV:';

  @override
  String get weightCvRecommendedValues =>
      '• Optimal: < 8%\n• Aceitarable: 8-12%\n• Needs attention: > 12%';

  @override
  String weightRegisteredDetail(String weight, Object count) {
    return '$count aves • $weight kg promédio';
  }

  @override
  String batchPhotoAdded(Object current, Object max) {
    return 'Foto $current/$max added';
  }

  @override
  String get batchPhotoSelectError =>
      'Erro al selecionar la imagen. Intenta novamente.';

  @override
  String get batchPhotoUploadFailed =>
      'Fotos could not be uploaded. Continue without fotos?';

  @override
  String get batchContinueWithoutPhotos => 'Continue without fotos?';

  @override
  String get batchPhotoUploadFailedDetail =>
      'Fotos could not be uploaded. Registrar without fotographic evidence?';

  @override
  String get batchFirebaseNetworkError => 'Sem conexão';

  @override
  String get batchFirebaseNetworkDetail => 'Verifica tu conexión a internet';

  @override
  String mortalityRegisteredDetail(String cause, Object count) {
    return '$count aves - $cause';
  }

  @override
  String get mortalityAttentionRequired => 'Attention Obrigatório!';

  @override
  String mortalityImpactMessage(Object percent) {
    return 'O evento registrado tem um impacto de $percent% e requer atenção imediata.';
  }

  @override
  String mortalityCause(Object cause) {
    return 'Causa: $cause';
  }

  @override
  String mortalitySeverity(String level) {
    return 'Gravedad: $level/10';
  }

  @override
  String get mortalityContagiousWarning =>
      'Esta causa es contagiosa. Se recomienda tomar medidas preventivas inmediatas.';

  @override
  String mortalityExceedsAvailable(String available, Object count) {
    return 'La quantidade ($count) excede las aves disponívels ($available)';
  }

  @override
  String get mortalityUserRequired => 'El nome de usuario es obrigatório';

  @override
  String get mortalityUserInvalid => 'Invalid usuário ID';

  @override
  String get mortalityUserNotAuthenticated => 'Usuário not authenticated';

  @override
  String get batchFirebaseError => 'Erro de Firebase';

  @override
  String get batchErrorCreatingRecord => 'Erro al criar registro';

  @override
  String get commonUnderstood => 'Entendido';

  @override
  String consumptionInsufficientStock(String stock) {
    return 'Estoque insuficiente. Disponível: $stock kg';
  }

  @override
  String consumptionInventoryError(Object error) {
    return 'Consumo registrado, pero hubo un erro al atualizar inventário: $error';
  }

  @override
  String consumptionRegisteredDetail(String amount, Object type) {
    return '$amount kg de $type';
  }

  @override
  String get consumptionNoBirdsAvailable => 'El lote no tiene aves disponívels';

  @override
  String get consumptionHighAmountTitle => 'Quantidade Alta de Alimento';

  @override
  String consumptionHighAmountMessage(Object amount) {
    return 'You are recording $amount kg of ração.';
  }

  @override
  String get consumptionPerBird => 'Per ave:';

  @override
  String get commonCorrect => 'Corregir';

  @override
  String get consumptionFoodTypeTitle => 'Ração Tipo';

  @override
  String consumptionFoodTypeWarning(Object days, Object type) {
    return 'El tipo \"$type\" no es el recomendado para $days dias de edad.';
  }

  @override
  String get consumptionRecommendedType => 'Recommended tipo:';

  @override
  String get commonReview => 'Revisar';

  @override
  String get consumptionAmountTooHigh =>
      'La quantidade parece demasiado alta. Verifica el valor.';

  @override
  String get consumptionCostNegative => 'El custo por kg no puede ser negativo';

  @override
  String get consumptionCostTooHigh =>
      'El custo parece demasiado alto. Verifica el valor.';

  @override
  String get batchViewCharts => 'Ver Gráficos';

  @override
  String get batchFilterRecords => 'Filtrar registros';

  @override
  String get batchTimePeriod => 'Período de tempo';

  @override
  String get batchAllTime => 'Todos';

  @override
  String get batchNoTimeLimit => 'Sin límite';

  @override
  String get batchLastWeek => 'Última semana';

  @override
  String get batchLastMonth => 'Último mês';

  @override
  String batchApplyFiltersOrClose(String hasFilters) {
    String _temp0 = intl.Intl.selectLogic(hasFilters, {
      'true': 'Aplicar filtros',
      'other': 'Fechar',
    });
    return '$_temp0';
  }

  @override
  String get batchErrorLoadingRecords => 'Erro al carregar registros';

  @override
  String get historialPostureRange => 'Faixa de postura';

  @override
  String get historialAllPostures => 'Todas as posturas';

  @override
  String get historialHighPosture => 'Alta (≥85%)';

  @override
  String get historialMediumPosture => 'Média (70-84%)';

  @override
  String get historialLowPosture => 'Baja (<70%)';

  @override
  String get historialTotalEggs => 'ovos totales';

  @override
  String get historialAvgPosture => 'postura promédio';

  @override
  String get historialRecords => 'registros';

  @override
  String get historialDailyAvg => 'promédio diário';

  @override
  String get historialTotalConsumed => 'total consumido';

  @override
  String get historialDeadBirds => 'morto aves';

  @override
  String get historialNoProductionRecords => 'Sin registros de produção';

  @override
  String get historialNoResults => 'Sin resultados';

  @override
  String get historialRegisterFirstProduction =>
      'Registra la primeira produção de ovos';

  @override
  String get historialNoRecordsWithFilters =>
      'Não há registros con estos filtros';

  @override
  String get historialPostureLabel => 'Postura: ';

  @override
  String historialGoodLabel(Object count, Object percent) {
    return 'Boms: $count ($percent%)';
  }

  @override
  String historialBirdsLabel(Object count) {
    return 'Aves: $count';
  }

  @override
  String historialBrokenLabel(Object count) {
    return 'Quebrados: $count';
  }

  @override
  String historialAgeLabel(Object days) {
    return 'Edad: $days dias';
  }

  @override
  String get detailPosturePercentage => 'Porcentagem postura';

  @override
  String get detailBirdAge => 'Ave age';

  @override
  String detailDaysWeek(String weeks, Object days) {
    return '$days dias (Semana $weeks)';
  }

  @override
  String get detailBirdCount => 'Quantidade de aves';

  @override
  String get detailGoodEggs => 'Ovos boms';

  @override
  String get detailBrokenEggs => 'Ovos quebrados';

  @override
  String get detailDirtyEggs => 'Ovos sujos';

  @override
  String get detailDoubleYolkEggs => 'Ovos doble yema';

  @override
  String get detailAvgEggWeight => 'Peso médio ovo';

  @override
  String get detailRegisteredBy => 'Registrado por';

  @override
  String get detailObservations => 'Observações';

  @override
  String get detailSizeClassification => 'Classificação por tamano';

  @override
  String get detailPhotoEvidence => 'Foto evidence';

  @override
  String historialEggsUnit(Object count) {
    return '$count ovos';
  }

  @override
  String get historialCauseLabel => 'Causa: ';

  @override
  String historialDescriptionLabel(String desc) {
    return 'Descrição: $desc';
  }

  @override
  String get historialTypeLabel => 'Tipo: ';

  @override
  String historialConsumptionPerBird(String grams) {
    return 'Intake/ave: ${grams}g';
  }

  @override
  String get historialNoMortalityRecords => 'Não há registros de mortalidad';

  @override
  String get historialNoConsumptionRecords => 'Sem registros de consumo';

  @override
  String get historialNoConsumptionResults => 'Sin resultados';

  @override
  String get historialRegisterFirstConsumption =>
      'Registrar the first ração consumption';

  @override
  String get historialNoRecordsConsumptionFilters =>
      'Não há registros con estos filtros';

  @override
  String get historialNoProductionData => 'Sem dados de produção';

  @override
  String get historialChartsAppearProduction =>
      'Los gráficos aparecerán cuando haya registros de produção';

  @override
  String get historialNoConsumptionData => 'Sem dados de consumo';

  @override
  String get historialChartsAppearConsumption =>
      'Os gráficos aparecerão quando houver registros de consumo';

  @override
  String get historialFilterMortalityCause => 'Mortalidade cause';

  @override
  String get historialFilterFoodType => 'Ração tipo';

  @override
  String get historialFilterAllTypes => 'Todos os tipos';

  @override
  String get detailFoodType => 'Ração tipo';

  @override
  String get detailBirdsWeighed => 'Aves weighed';

  @override
  String get detailAvgWeight => 'Peso médio';

  @override
  String get detailMinWeight => 'Minimum peso';

  @override
  String get detailMaxWeight => 'Maximum peso';

  @override
  String get detailTotalWeight => 'Total peso';

  @override
  String get detailDailyGain => 'Diário gain (ADG)';

  @override
  String get detailCvCoefficient => 'Coef. Variação (CV)';

  @override
  String get detailUniformity => 'Uniformidad';

  @override
  String get detailUniformityGood => 'Buena (< 10%)';

  @override
  String get detailUniformityRegular => 'Regular (≥ 10%)';

  @override
  String get detailConsumptionPerBird => 'Consumption per ave';

  @override
  String get detailAccumulatedConsumption => 'Consumo acumulado';

  @override
  String get detailFoodBatch => 'Ração lote';

  @override
  String get detailCostPerKg => 'Custo por kg';

  @override
  String get detailTotalCost => 'Custo total';

  @override
  String get detailCause => 'Causa';

  @override
  String get detailBirdsBeforeEvent => 'Aves before event';

  @override
  String get detailImpact => 'Impacto';

  @override
  String get detailDescription => 'Descrição';

  @override
  String historialBirdsWeighedLabel(Object count) {
    return 'Aves weighed: $count';
  }

  @override
  String get historialFilterWeightRange => 'Peso range';

  @override
  String get historialAllWeights => 'Todos';

  @override
  String get historialLow => 'Baixo';

  @override
  String get historialNormal => 'Normal';

  @override
  String get historialHigh => 'Alto';

  @override
  String get historialNoWeighingRecords => 'Sin registros de pesagem';

  @override
  String get historialRegisterFirstWeighing =>
      'Registra el primer pesagem de aves';

  @override
  String get historialNoEventsRecords => 'Histórico de eventos';

  @override
  String get historialPerEvent => 'por evento';

  @override
  String get historialAccumulatedRate => 'tasa acumulada';

  @override
  String historialBirdsUnit(Object count) {
    return '$count aves';
  }

  @override
  String historialUserLabel(Object name) {
    return 'Usuário: $name';
  }

  @override
  String historialAgeDaysLabel(Object days) {
    return 'Edad: $days dias';
  }

  @override
  String get historialNoMortalityExcellent =>
      '¡Excelente! No hay bajas registradas';

  @override
  String get historialAllCauses => 'Todas as causas';

  @override
  String get historialWeighingHistory => 'Historial de pesagems';

  @override
  String get historialLastWeight => 'last peso';

  @override
  String get historialDailyGainStat => 'diário gain';

  @override
  String get historialUniformityCV => 'uniformidad CV';

  @override
  String get historialMethodLabel => 'Método';

  @override
  String get historialFilterWeighingMethod => 'Método de pesagem';

  @override
  String get historialAllMethods => 'Todos os métodos';

  @override
  String historialGdpLabel(Object value) {
    return 'GDP: ${value}g';
  }

  @override
  String historialCvLabel(Object value) {
    return 'CV: $value%';
  }

  @override
  String get detailWeighingMethod => 'Método de pesagem';

  @override
  String get historialNoWeightRecords => 'No peso records';

  @override
  String get historialRegisterFirstWeighingLote =>
      'Registra el primer pesagem de tu lote';

  @override
  String get historialConsumptionHistory => 'Histórico de consumo';

  @override
  String get historialAvgDaily => 'promédio diário';

  @override
  String get historialAccumulatedPerBird => 'accumulated/ave';

  @override
  String get historialAllFoodTypes => 'Todos os tipos';

  @override
  String historialBirdNumber(Object count) {
    return 'Aves: $count';
  }

  @override
  String historialConsumptionValue(Object value) {
    return 'Consumption/ave: ${value}g';
  }

  @override
  String get chartsConsumptionTitle => 'Gráficos de Consumo';

  @override
  String get chartsLoading => 'Carregando gráficos...';

  @override
  String get chartsErrorLoading => 'Erro al carregar datos';

  @override
  String get chartsNoValidData => 'Sin registros con quantidade válida';

  @override
  String get chartsDailyConsumptionTitle => 'Consumo Diário';

  @override
  String get chartsDailyConsumptionSubtitle =>
      'Kilogramas de alimento consumido por día';

  @override
  String get chartsConsumptionPerBirdTitle => 'Consumption Per Ave';

  @override
  String get chartsConsumptionPerBirdSubtitle =>
      'Gramas de alimento por ave por día';

  @override
  String get chartsFoodTypeDistributionTitle => 'Tipo Distribution';

  @override
  String get chartsFoodTypeDistributionSubtitle =>
      'Total consumption by food tipo (kg)';

  @override
  String get chartsCostEvolutionTitle => 'Custos de Alimentação';

  @override
  String get chartsCostEvolutionSubtitle =>
      'Gasto total por día en alimentação';

  @override
  String get chartsCostNoValidData => 'Sin registros con custo asignado';

  @override
  String get chartsNotEnoughData => 'Sin suficientes datos';

  @override
  String get chartsRegisterMoreToAnalyze =>
      'Registrar more consumption to see analysis';

  @override
  String get chartsGraphsAppearWhenData =>
      'Os gráficos aparecerão quando houver registros de consumo';

  @override
  String get chartsMortalityAccumulatedSubtitle =>
      'Porcentagem de bajas sobre inicial';

  @override
  String get chartsMortalityDailyTitle => 'Mortalidade Diaria';

  @override
  String get chartsMortalityDailySubtitle => 'Quantidade de aves por día';

  @override
  String get chartsMortalityCausesTitle => 'Causas de Mortalidade';

  @override
  String get chartsMortalityCausesSubtitle =>
      'Distribuição por motivo principal';

  @override
  String get chartsMortalityDistributionCauseTitle => 'Distribuição por Causa';

  @override
  String get chartsMortalityTotalByCauseSubtitle =>
      'Total aves by mortalidade cause';

  @override
  String get commonExcellent => '¡Excelente!';

  @override
  String get mortalityCauseDisease => 'Doença';

  @override
  String get mortalityCauseStress => 'Estrés';

  @override
  String get mortalityCauseAccident => 'Accidente';

  @override
  String get mortalityCausePredation => 'Predação';

  @override
  String get mortalityCauseMalnutrition => 'Desnutrição';

  @override
  String get mortalityCauseMetabolic => 'Metabólica';

  @override
  String get mortalityCauseSacrifice => 'Sacrificio';

  @override
  String get mortalityCauseOldAge => 'Vejez';

  @override
  String get mortalityCauseUnknown => 'Desconhecido';

  @override
  String get chartsNoMortalityRecords => 'No registrared losses';

  @override
  String get chartsGraphsAppearWhenMortality =>
      'Charts will appear when losses are registrared';

  @override
  String chartsMortalityTooltipTotal(Object count, Object percent) {
    return 'Total: $count aves ($percent%)';
  }

  @override
  String chartsMortalityTooltipEvent(Object count, Object date) {
    return '$date\n$count aves';
  }

  @override
  String get chartsMortalityAcceptable => 'Aceitarable';

  @override
  String get chartsMortalityAlert => 'Alerta';

  @override
  String get chartsMortalityCritical => 'Crítico';

  @override
  String get chartsMortalityPerRegistrationTitle => 'Mortalidade por Registro';

  @override
  String get chartsMortalityPerRegistrationSubtitle =>
      'Quantidade de aves por cada evento registrado';

  @override
  String get chartsNoCauseData => 'Sem dados de causas';

  @override
  String chartsWeightTooltipEvolution(String date, String weight, String age) {
    return '📈 Evolução\n📅 $date\n⚖️ $weight kg\n🐣 Dia $age';
  }

  @override
  String chartsWeightTooltipADG(String date, String age, String gain) {
    return '📈 Diário gain\n📅 $date\n🐣 Day $age\n📊 $gain g/day';
  }

  @override
  String chartsWeightTooltipUniformity(
    String date,
    String value,
    String estado,
  ) {
    return '📈 Uniformidad\n📅 $date\n📊 CV: $value%\n$estado';
  }

  @override
  String chartsWeightTooltipComparison(
    String diff,
    String emoji,
    String standard,
    String sign,
    String real,
  ) {
    return '📊 Real: $real kg\n📈 Padrão: $standard kg\n$emoji Dif: $sign$diff kg';
  }

  @override
  String chartsProductionTooltipPosture(
    Object date,
    Object emoji,
    Object percentage,
  ) {
    return '$emoji $date\n$percentage% de postura';
  }

  @override
  String chartsProductionTooltipDaily(Object count, Object date) {
    return 'ðŸ¥š $date\n$count ovos recolectados';
  }

  @override
  String get chartsWeightEvolutionTitle => 'Peso Evolution';

  @override
  String get chartsWeightEvolutionSubtitle =>
      'Peso médio a lo largo del tiempo';

  @override
  String get chartsWeightADGTitle => 'Average Diário Gain';

  @override
  String get chartsWeightADGSubtitle => 'Gramas ganados por día';

  @override
  String get chartsWeightUniformityTitle => 'Uniformidade do Lote';

  @override
  String get chartsWeightUniformitySubtitle =>
      'Coeficiente de variação del peso';

  @override
  String get chartsWeightUniformityExcellent => 'Excelente uniformidad';

  @override
  String get chartsWeightUniformityGood => 'Buena uniformidad';

  @override
  String get chartsWeightUniformityImprove => 'Necesita mejorar';

  @override
  String get chartsWeightComparisonTitle => 'Comparação com Padrão';

  @override
  String get chartsWeightComparisonSubtitle =>
      'Actual peso vs breed standard peso';

  @override
  String get commonActual => 'Real';

  @override
  String get commonStandard => 'Estándar';

  @override
  String get chartsProductionDailyTitle => 'Produção Diaria';

  @override
  String get chartsProductionDailySubtitle => 'Ovos recolectados por día';

  @override
  String get chartsProductionQualityTitle => 'Calidad de Ovos';

  @override
  String get chartsProductionQualitySubtitle => 'Distribución por tipo de ovo';

  @override
  String get eggTypeGood => 'Boms';

  @override
  String get eggTypeBroken => 'Quebrados';

  @override
  String get eggTypeDirty => 'Sujos';

  @override
  String get eggTypeDoubleYolk => 'Doble yema';

  @override
  String get homeSelectFarm => 'Selecionar granja';

  @override
  String get homeHaveCode => 'Have a código?';

  @override
  String get homeJoinFarmWithInvitation => 'Join a granja with an invitation';

  @override
  String get homeNoFarmsRegistered => 'You have no registrared granjas';

  @override
  String get homeHaveInvitationCode => 'Have an invitation código?';

  @override
  String get homeHealth => 'Salud';

  @override
  String get homeAlerts => 'Alertas';

  @override
  String get homeOutOfStock => 'Produtos esgotados';

  @override
  String get homeLowStock => 'Estoque baixo';

  @override
  String get homeRecentActivity => 'Actividad Reciente';

  @override
  String get homeLast7Days => 'Últimos 7 dias';

  @override
  String get homeRightNow => 'Ahora mismo';

  @override
  String homeAgoMinutes(Object minutes) {
    return 'Hace $minutes min';
  }

  @override
  String homeAgoHoursOne(Object hours) {
    return 'Hace $hours hora';
  }

  @override
  String homeAgoHoursOther(Object hours) {
    return '$hours horas ago';
  }

  @override
  String homeYesterdayAt(Object time) {
    return 'Ontem a las $time';
  }

  @override
  String homeAgoDays(Object days) {
    return 'Hace $days dias';
  }

  @override
  String get homeNoRecentActivity => 'Sin actividad reciente';

  @override
  String get homeNoRecentActivityDesc =>
      'Los registros de produção, mortalidad,\nconsumo, inventário, vendas, custos\ny salud aparecerán aquí';

  @override
  String get homeErrorLoadingActivities => 'Erro ao carregar atividades';

  @override
  String get homeTryReloadPage => 'Intente recarregar la página';

  @override
  String homeProductsOutOfStockCount(Object count) {
    return '$count produtos sin estoque';
  }

  @override
  String homeProductsLowStockCount(Object count) {
    return '$count produtos con estoque baixo';
  }

  @override
  String homeProductsExpiringSoonCount(Object count) {
    return '$count produtos por vencer';
  }

  @override
  String homeMortalityPercent(Object percent) {
    return 'Mortalidade del $percent% en lotes ativos';
  }

  @override
  String get homeStatsAppearHere => 'Las estadísticas se mostrarán aquí';

  @override
  String get homeOccupancyLow => 'Ocupação baja';

  @override
  String get homeOccupancyMedium => 'Ocupação media';

  @override
  String get homeOccupancyHigh => 'Ocupação alta';

  @override
  String get homeOccupancyMax => 'Ocupação máxima';

  @override
  String get homeNoCapacityDefined => 'Sin capacidade definida';

  @override
  String get homeCouldNotLoad => 'No se pudo carregar';

  @override
  String get homeWhatsappHelp => 'Como podemos ajudá-lo?';

  @override
  String get homeWhatsappContact => 'Fale conosco pelo WhatsApp';

  @override
  String get homeWhatsappSupport => 'Suporte técnico';

  @override
  String get homeWhatsappNeedHelp => 'Necesito ajuda con la aplicación';

  @override
  String get homeWhatsappReportProblem => 'Relatório a problem';

  @override
  String get homeWhatsappSuggestImprovement => 'Sugerir uma melhoria';

  @override
  String get homeWhatsappWorkTogether => 'Trabajar juntos';

  @override
  String get homeWhatsappPlansAndPricing => 'Planes y preços';

  @override
  String get homeWhatsappOtherTopic => 'Outro tema';

  @override
  String get homeWhatsappCouldNotOpen => 'No se pudo abrir WhatsApp';

  @override
  String get homeNoOccupancy => 'Sin ocupação';

  @override
  String get homeSelectAFarm => 'Selecione uma granja';

  @override
  String homeTotalShedsCount(Object count) {
    return '$count en total';
  }

  @override
  String homeTotalBatchesCount(Object count) {
    return '$count lotees total';
  }

  @override
  String get homeInvTotal => 'Total';

  @override
  String get homeInvLowStock => 'Estoque Baixo';

  @override
  String get homeInvOutOfStock => 'Esgotados';

  @override
  String get homeInvExpiringSoon => 'Próximo a Vencer';

  @override
  String get homeSetupInventory => 'Configura tu inventário';

  @override
  String get homeSetupInventoryDesc =>
      'Agrega ração, medicamentos y más para controlar tu estoque';

  @override
  String homeInvAttention(String details) {
    return 'Atenção: $details';
  }

  @override
  String homeInvOutOfStockCount(Object count) {
    return '$count esgotados';
  }

  @override
  String homeInvLowStockCount(Object count) {
    return '$count con estoque baixo';
  }

  @override
  String homeInvExpiringSoonCount(Object count) {
    return '$count próximos a vencer';
  }

  @override
  String get homeWhatsappFoundBug => 'Encontré un erro o fallo';

  @override
  String get homeWhatsappHaveIdea => 'Tenho uma ideia para melhorar o app';

  @override
  String get homeWhatsappCollaboration => 'Colaboração ou aliança comercial';

  @override
  String get homeWhatsappLicenseInfo => 'Informações sobre licencias y planes';

  @override
  String get homeWhatsappGeneralInquiry => 'Consulta geral';

  @override
  String get batchError => 'Erro';

  @override
  String get batchNotFound => 'Lote not found';

  @override
  String get batchNotFoundMessage => 'The lote was not found';

  @override
  String get batchMayHaveBeenDeleted => 'It may have been excluird or moved';

  @override
  String get batchCouldNotLoad => 'No pudimos carregar el lote';

  @override
  String batchEditCode(Object code) {
    return 'Editar: $code';
  }

  @override
  String get batchUpdateBatch => 'Atualizar Lote';

  @override
  String get batchCodeRequired => 'El código es obrigatório';

  @override
  String get batchSelectBirdType => 'Selecionar ave tipo';

  @override
  String get batchSelectShed => 'Debe selecionar un galpão';

  @override
  String get batchInitialCountRequired =>
      'La quantidade inicial es obrigatória';

  @override
  String get batchErrorUpdating => 'Erro al atualizar lote';

  @override
  String get batchUpdateSuccess => 'Lote atualizado com sucesso!';

  @override
  String get batchChangesSaved => 'Changes have been salvard sucessofully';

  @override
  String get batchChangesWillBeLost =>
      'Los cambios que has realizado se perderán.';

  @override
  String get batchOperationSuccess => 'Operation sucessoful';

  @override
  String get batchDeletedSuccess => 'Lote excluird';

  @override
  String get batchSearchHint => 'Buscar por nome, código ou tipo...';

  @override
  String get batchAll => 'Todos';

  @override
  String get batchNoFarms => 'No granjas';

  @override
  String get batchCreateFarmFirst =>
      'Crea una granja primeiro para adicionar lotes';

  @override
  String get batchCreateFarm => 'Criar granja';

  @override
  String get batchErrorLoadingBatches => 'Erro al carregar lotes';

  @override
  String get batchSelectFarm => 'Selecione uma granja';

  @override
  String batchSelectFarmName(Object name) {
    return 'Selecionar granja $name';
  }

  @override
  String get batchNoRegistered => 'Sem lotes registrados';

  @override
  String get batchRegisterFirst =>
      'Registre seu primeiro lote de aves para começar a monitorar sua produção';

  @override
  String get batchNotFoundFilter => 'No lotees found';

  @override
  String get batchAdjustFilters =>
      'Tente ajustar os filtros ou buscar com outros termos';

  @override
  String batchFarmWithBatchesLabel(Object count, Object name) {
    return 'Granja $name with $count lotees';
  }

  @override
  String get batchShedBatches => 'Lotes del Galpão';

  @override
  String get batchCreateNewTooltip => 'Criar novo lote';

  @override
  String batchStatusUpdatedTo(Object status) {
    return 'Status atualizado a $status';
  }

  @override
  String batchDeleteMessage(Object code) {
    return 'O lote \"$code\" e todos os seus registros serão excluídos. Esta ação não pode ser desfeita.';
  }

  @override
  String batchErrorDeletingDetail(Object error) {
    return 'Erro al excluir: $error';
  }

  @override
  String get batchDeletedCorrectly => 'Lote excluird sucessofully';

  @override
  String get batchCannotCreateWithoutShed =>
      'No se puede criar lote sin galpão';

  @override
  String get batchCannotViewWithoutShed => 'No se puede ver detalhe sin galpão';

  @override
  String get batchCannotEditWithoutShed => 'No se puede editar sin galpão';

  @override
  String get batchCurrentStatus => 'Status actual:';

  @override
  String get batchSelectNewStatus => 'Selecionar novo status:';

  @override
  String batchConfirmStateChange(Object status) {
    return 'Confirmar change to $status?';
  }

  @override
  String get batchPermanentStateWarning =>
      'Este status es permanente y no podrá revertirse.';

  @override
  String get batchPermanentState => 'Status permanente';

  @override
  String get batchCycleProgress => 'Progresso do ciclo';

  @override
  String batchDayOfCycle(String day, Object total) {
    return 'Dia $day de $total';
  }

  @override
  String batchCycleCompleted(Object day) {
    return 'Day $day - Cycle concluído';
  }

  @override
  String batchExtraDays(String extra, Object day) {
    return 'Día $day ($extra extra)';
  }

  @override
  String get batchEntryLabel => 'Ingreso';

  @override
  String get batchLiveBirds => 'Live Aves';

  @override
  String get batchTotalLosses => 'Bajas Totales';

  @override
  String get batchAttention => 'Atenção';

  @override
  String get batchKeyIndicators => 'Indicadores clave';

  @override
  String get batchOfInitial => 'of initial lote';

  @override
  String get batchBirdsLost => 'aves lost';

  @override
  String get batchExpected => 'esperado';

  @override
  String get batchCurrentWeight => 'current peso';

  @override
  String get batchDailyGain => 'diário gain';

  @override
  String get batchGoal => 'meta';

  @override
  String get batchFoodConsumption => 'Consumo de Alimento';

  @override
  String get batchTotalAccumulated => 'total acumulado';

  @override
  String get batchPerBird => 'per ave';

  @override
  String get batchDailyExpectedPerBird => 'diário esperado/ave';

  @override
  String get batchCurrentIndex => 'índice actual';

  @override
  String get batchKgFood => 'kg alimento';

  @override
  String get batchPerKgWeight => 'per kg of peso';

  @override
  String get batchOptimalRange => 'rango óptimo';

  @override
  String get batchEggProduction => 'Produção de Ovos';

  @override
  String get batchTotalEggs => 'ovos totales';

  @override
  String get batchEggsPerBird => 'ovos por ave';

  @override
  String get batchExpectedLaying => 'postura esperada';

  @override
  String get batchHighMortalityAlert => 'Mortalidadee elevada, revise el lote';

  @override
  String get batchWeightBelowTarget => 'Peso por debaixo del objetivo';

  @override
  String batchOverdueClose(Object days) {
    return 'Cierre vencido hace $days dias';
  }

  @override
  String batchCloseUpcoming(Object days) {
    return 'Cierre próximo en $days dias';
  }

  @override
  String get batchHighConversionAlert => 'Índice de conversão alto';

  @override
  String get batchLevelOptimal => 'Óptimo';

  @override
  String get batchLevelNormal => 'Normal';

  @override
  String get batchLevelHigh => 'Alto';

  @override
  String get batchLevelCritical => 'Crítico';

  @override
  String get batchMortLevelExcellent => 'Excelente';

  @override
  String get batchMortLevelElevated => 'Elevada';

  @override
  String get batchMortLevelCritical => 'Crítica';

  @override
  String get batchWeightLevelAcceptable => 'Aceitarable';

  @override
  String get batchWeightLevelLow => 'Baixo';

  @override
  String get batchQualityGood => 'Buena';

  @override
  String get batchQualityRegular => 'Regular';

  @override
  String get batchQualityLow => 'Baja';

  @override
  String get batchRegisterMortality => 'Registrar Mortalidade';

  @override
  String get batchRegisterWeight => 'Registrar Peso';

  @override
  String get batchRegisterConsumption => 'Registrar Consumption';

  @override
  String get batchRegisterProduction => 'Registrar Produção';

  @override
  String get batchTabMortality => 'Mortalidade';

  @override
  String get batchTabWeight => 'Peso';

  @override
  String get batchTabConsumption => 'Consumo';

  @override
  String get batchTabProduction => 'Produção';

  @override
  String get batchTabHistory => 'Historial';

  @override
  String get batchTabVaccination => 'Vacinação';

  @override
  String get batchNavSummary => 'Resumo';

  @override
  String get batchPutInQuarantine => 'Poner en Quarentena';

  @override
  String batchQuarantineConfirm(Object code) {
    return 'Tem certeza de que deseja colocar \"$code\" em quarentena?';
  }

  @override
  String get batchQuarantineReasonHint => 'Ex: Sospecha de doença';

  @override
  String get batchAlreadyInQuarantine => 'El lote ya está en quarentena';

  @override
  String get batchQuarantineReason => 'Motivo de quarentena';

  @override
  String get batchPutInQuarantineSuccess => 'Lote puesto en quarentena';

  @override
  String get batchAlreadyClosed => 'The lote is already fechard';

  @override
  String get batchInfoCopied => 'Informações copiada al portapapeles';

  @override
  String get batchCannotDeleteActive => 'No se puede excluir un lote ativo';

  @override
  String get batchDescribeReason => 'Descreva el motivo...';

  @override
  String batchReasonForState(Object status) {
    return 'Motivo de $status';
  }

  @override
  String get batchBatchHistory => 'Lote History';

  @override
  String get batchHistoryComingSoon => 'Historial próximamente';

  @override
  String get batchRequiresAttention => 'Requer Atenção';

  @override
  String get batchNeedsReview => 'This lote needs review';

  @override
  String get batchOverdue => 'Vencido';

  @override
  String batchOfBirds(Object count) {
    return 'of $count aves';
  }

  @override
  String get batchWithinLimits => 'Within aceitarable limits';

  @override
  String get batchIndicators => 'Indicadores';

  @override
  String get batchWeeks => 'semanas';

  @override
  String get batchAverage => 'promédio';

  @override
  String get batchMortality => 'Mortalidade';

  @override
  String batchOfAmount(Object count) {
    return 'de $count';
  }

  @override
  String get batchQuickActions => 'Ações Rápidas';

  @override
  String get batchBatchStatus => 'Status del Lote';

  @override
  String get batchGeneralInfo => 'Informações Geral';

  @override
  String get batchCodeLabel => 'Código';

  @override
  String get batchSupplier => 'Fornecedor';

  @override
  String get batchLatestRecords => 'Últimos Registros';

  @override
  String get batchNoRecentRecords => 'Sin registros recientes';

  @override
  String get batchRecordsWillAppear => 'Los registros aparecerán aquí';

  @override
  String get batchErrorLoadingBatch => 'Erro al carregar el lote';

  @override
  String get batchEditBatchTooltip => 'Edit lote';

  @override
  String get batchNotes => 'Notas';

  @override
  String batchErrorDetail(Object error) {
    return 'Erro: $error';
  }

  @override
  String get batchStatusDescActive => 'El lote está en produção activa';

  @override
  String get batchStatusDescClosed => 'The lote has been fechard';

  @override
  String get batchStatusDescQuarantine => 'El lote está en quarentena';

  @override
  String get batchStatusDescSold => 'The lote has been sold';

  @override
  String get batchStatusDescTransfer => 'The lote has been transferred';

  @override
  String get batchStatusDescSuspended => 'The lote is suspended';

  @override
  String get batchCreating => 'Creating lote...';

  @override
  String get batchUpdating => 'Updating lote...';

  @override
  String get batchDeleting => 'Deleting lote...';

  @override
  String get batchRegisteringMortality => 'Registraring mortalidade...';

  @override
  String get batchMortalityRegistered => 'Mortalidade registrada';

  @override
  String get batchRegisteringDiscard => 'Registraring discard...';

  @override
  String get batchDiscardRegistered => 'Discard registrared';

  @override
  String get batchRegisteringSale => 'Registrando venda...';

  @override
  String get batchSaleRegistered => 'Venda registrada';

  @override
  String get batchUpdatingWeight => 'Updating peso...';

  @override
  String get batchWeightUpdated => 'Peso atualizado';

  @override
  String get batchChangingStatus => 'Cambiando status...';

  @override
  String batchStatusChangedTo(Object status) {
    return 'Status cambiado a $status';
  }

  @override
  String get batchRegisteringFullSale => 'Registrando venda completa...';

  @override
  String get batchMarkedAsSold => 'Lote marked as sold';

  @override
  String get batchTransferring => 'Transferring lote...';

  @override
  String get batchTransferredSuccess => 'Lote transferido com sucesso';

  @override
  String get batchSelectEntryDate => 'Seleccione la data de ingreso';

  @override
  String get batchMin3Chars => 'Mínimo 3 caracteres';

  @override
  String get batchFilterBatches => 'Filter Lotees';

  @override
  String get batchStatus => 'Status';

  @override
  String get batchFrom => 'Desde';

  @override
  String get batchTo => 'Hasta';

  @override
  String get batchAny => 'Cualquiera';

  @override
  String get batchCloseBatchTitle => 'Fechar Lote';

  @override
  String batchCloseConfirmation(Object code) {
    return 'Tem certeza de que deseja encerrar o lote \"$code\"?';
  }

  @override
  String get batchCloseWarning =>
      'Esta ação é irreversível. El lote será marcado como cerrado.';

  @override
  String get batchCloseFinalSummary => 'Resumo Final';

  @override
  String get batchCloseEntryDate => 'Data de ingreso';

  @override
  String get batchCloseCloseDate => 'Data de cierre';

  @override
  String batchCloseDurationDays(Object days) {
    return 'Duração: $days dias';
  }

  @override
  String get batchCloseInitialBirds => 'Initial aves';

  @override
  String get batchCloseFinalBirds => 'Final aves';

  @override
  String get batchCloseFinalMortality => 'Mortalidade final';

  @override
  String get batchCloseObservations => 'Observações de cierre';

  @override
  String get batchCloseOptionalNotes =>
      'Opcional notes sobre the lote closure...';

  @override
  String get batchCloseSuccess => 'Lote fechado com sucesso';

  @override
  String batchCloseError(Object error) {
    return 'Erro al fechar el lote: $error';
  }

  @override
  String get batchTransferTitle => 'Transfer Lote';

  @override
  String batchTransferConfirm(String shed, Object code) {
    return 'Transferir \"$code\" para o galpão $shed?';
  }

  @override
  String get batchTransferSelectShed => 'Selecionar galpão destino';

  @override
  String get batchTransferNoSheds => 'No hay galpões disponívels';

  @override
  String get batchTransferReason => 'Motivo da transferência';

  @override
  String get batchSellTitle => 'Sell Entire Lote';

  @override
  String batchSellConfirm(Object code) {
    return 'Registrar a venda completa do lote \"$code\"?';
  }

  @override
  String batchSellBirdsCount(Object count) {
    return 'Aves to sell: $count';
  }

  @override
  String get batchSellPricePerUnit => 'Preço por unidade';

  @override
  String get batchSellTotalPrice => 'Preço total';

  @override
  String get batchSellBuyer => 'Comprador';

  @override
  String get batchFormStepBasicInfo => 'Informações Básicas';

  @override
  String get batchFormStepDetails => 'Detalhes';

  @override
  String get batchFormStepReview => 'Revisión';

  @override
  String get batchFormCode => 'Lote código';

  @override
  String get batchFormCodeHint => 'Ex: LOTE-001';

  @override
  String get batchFormBirdType => 'Ave tipo';

  @override
  String get batchFormSelectType => 'Selecionar tipo';

  @override
  String get batchFormInitialCount => 'Quantidade inicial';

  @override
  String get batchFormCountHint => 'Ex: 500';

  @override
  String get batchFormEntryDate => 'Data de ingreso';

  @override
  String get batchFormExpectedClose => 'Data estimada de cierre';

  @override
  String get batchFormShed => 'Galpão';

  @override
  String get batchFormSelectShed => 'Selecionar galpão';

  @override
  String get batchFormSupplier => 'Fornecedor';

  @override
  String get batchFormSupplierHint => 'Nome del fornecedor (opcional)';

  @override
  String get batchFormNotes => 'Notas adicionais';

  @override
  String get batchFormNotesHint => 'Observações sobre el lote (opcional)';

  @override
  String get batchFormDeathCount => 'Quantidade de muertes';

  @override
  String get batchFormDeathCountHint => 'Insira la quantidade';

  @override
  String get batchFormCause => 'Causa';

  @override
  String get batchFormCauseHint => 'Cause of mortalidade (opcional)';

  @override
  String get batchFormDate => 'Data';

  @override
  String get batchFormObservations => 'Observações';

  @override
  String get batchFormObservationsHint => 'Observações adicionales (opcional)';

  @override
  String get batchFormWeight => 'Peso (kg)';

  @override
  String get batchFormWeightHint => 'Peso médio en kg';

  @override
  String get batchFormSampleSize => 'Tamano de muestra';

  @override
  String get batchFormSampleSizeHint => 'Ex: 10';

  @override
  String get batchFormMethodHint => 'Método de pesagem';

  @override
  String get batchFormFoodType => 'Food tipo';

  @override
  String get batchFormSelectFoodType => 'Selecionar tipo de alimento';

  @override
  String get batchFormQuantityKg => 'Quantidade (kg)';

  @override
  String get batchFormQuantityHint => 'Quantidade en kg';

  @override
  String get batchFormCostPerKg => 'Custo por kg';

  @override
  String get batchFormCostHint => 'Custo en \$ (opcional)';

  @override
  String get batchFormEggCount => 'Quantidade de ovos';

  @override
  String get batchFormEggCountHint => 'Total de ovos recolectados';

  @override
  String get batchFormEggQuality => 'Calidad del ovo';

  @override
  String get batchFormSelectQuality => 'Selecionar calidad';

  @override
  String get batchFormDiscardCount => 'Quantidade de descartes';

  @override
  String get batchFormDiscardCountHint => 'Ex: 5';

  @override
  String get batchFormDiscardReason => 'Motivo do descarte';

  @override
  String get batchFormDiscardReasonHint => 'Discard reason (opcional)';

  @override
  String get batchHistoryMortality => 'Historial de Mortalidade';

  @override
  String get batchHistoryWeight => 'Peso History';

  @override
  String get batchHistoryConsumption => 'Histórico de Consumo';

  @override
  String get batchHistoryProduction => 'Historial de Produção';

  @override
  String get batchHistoryNoRecords => 'Sin registros';

  @override
  String get batchHistoryNoRecordsDesc => 'Não há registros para exibir';

  @override
  String get batchBirdsLabel => 'aves';

  @override
  String get batchBirdLabel => 'ave';

  @override
  String get batchKgLabel => 'kg';

  @override
  String get batchEggsLabel => 'ovos';

  @override
  String get batchUnitLabel => 'unidadees';

  @override
  String get batchPercentSign => '%';

  @override
  String get batchDaysLabel => 'dias';

  @override
  String get batchDayLabel => 'día';

  @override
  String get batchCopyInfo => 'Copiar informações';

  @override
  String get batchShareInfo => 'Compartilhar informações';

  @override
  String get batchViewHistory => 'Ver historial completo';

  @override
  String get batchNoShedsAvailable => 'No hay galpões disponívels';

  @override
  String get batchCreateShedFirst => 'Crea un galpão primeiro';

  @override
  String batchStepOf(Object current, Object total) {
    return 'Passo $current de $total';
  }

  @override
  String get batchReviewCreateBatch => 'Revisar y Criar Lote';

  @override
  String get batchCreated => 'Lote criado com sucesso';

  @override
  String get batchConfirmExit => 'Deseja sair?';

  @override
  String get batchConfirmExitDesc => 'Os dados do formulário serão perdidos';

  @override
  String get batchStay => 'Quedarse';

  @override
  String get batchLeave => 'Sair';

  @override
  String get batchUnsavedChanges => 'Alterações não salvas';

  @override
  String get batchExitWithoutSaving => 'Sair sem salvar as alterações?';

  @override
  String get batchLoadingBatch => 'Carregando lote...';

  @override
  String get batchLoadingData => 'Carregando datos...';

  @override
  String get batchRetry => 'Tentar novamente';

  @override
  String get batchNoData => 'Sem dados';

  @override
  String get batchNoBatches => 'Sem lotes';

  @override
  String get batchLotesHome => 'Lotes';

  @override
  String get batchClosed => 'Fechard';

  @override
  String get batchSuspended => 'Suspendidos';

  @override
  String get batchInQuarantine => 'En quarentena';

  @override
  String get batchSold => 'Vendido';

  @override
  String get batchTransfer => 'Transferencia';

  @override
  String batchDaysCount(Object count) {
    return '$count dias';
  }

  @override
  String get batchNoNotes => 'Sin notas';

  @override
  String get batchShedLabel => 'Galpão';

  @override
  String get batchActions => 'Acciones';

  @override
  String get batchWhatWantToDo => 'What do you want to do with this lote?';

  @override
  String get batchDeleteWarning => 'Esta ação não pode ser desfeita';

  @override
  String batchAgeWeeks(Object weeks) {
    return '$weeks sem';
  }

  @override
  String batchAgeDays(Object days) {
    return '$days dias';
  }

  @override
  String batchMortalityRate(String rate) {
    return 'Mortalidade: $rate%';
  }

  @override
  String get batchRecordAdded => 'Registro agregado com sucesso';

  @override
  String get batchRecordError => 'Erro al adicionar registro';

  @override
  String get batchTotalConsumed => 'Total consumido';

  @override
  String get batchTotalProduced => 'Total producido';

  @override
  String get batchProductionRate => 'Tasa de produção';

  @override
  String get batchSelectDate => 'Selecionar data';

  @override
  String get batchVaccinationHistory => 'Historial de Vacinação';

  @override
  String get batchNoVaccinations => 'Sin vacinações registradas';

  @override
  String get batchDeaths => 'muertes';

  @override
  String get batchDiscards => 'descartes';

  @override
  String get batchAverageWeight => 'Peso médio';

  @override
  String get batchSamples => 'muestras';

  @override
  String get batchConsumed => 'consumido';

  @override
  String get batchEggsCollected => 'ovos';

  @override
  String get batchBrokenDiscarded => 'quebrados/descartados';

  @override
  String get batchTotal => 'Total';

  @override
  String get batchLastRecord => 'Último registro';

  @override
  String batchRemainingBirds(Object count) {
    return 'Aves rprateleiras: $count';
  }

  @override
  String batchExceedsCurrentBirds(Object count) {
    return 'La quantidade excede las aves actuales ($count)';
  }

  @override
  String get batchFutureDateNotAllowed => 'La data no puede ser futura';

  @override
  String get batchRequiredField => 'Campo obrigatório';

  @override
  String get batchInvalidNumber => 'Número inválido';

  @override
  String get batchMustBePositive => 'Debe ser mayor a 0';

  @override
  String get batchMustBeGreaterThanZero => 'Debe ser mayor que 0';

  @override
  String get batchProduction => 'Produção';

  @override
  String get batchConsumption => 'Consumo';

  @override
  String get batchMortalityLabel => 'Mortalidade';

  @override
  String get batchVaccination => 'Vacinação';

  @override
  String get batchInfoGeneral => 'Informações geral';

  @override
  String get batchTitle => 'Lotes';

  @override
  String get batchDeleteBatch => 'Excluir Lote';

  @override
  String get batchFilterTitle => 'Filter Lotees';

  @override
  String get batchFilterClear => 'Limpar';

  @override
  String get batchFilterStatus => 'Status';

  @override
  String get batchFilterAll => 'Todos';

  @override
  String get batchFilterBirdType => 'Ave tipo';

  @override
  String get batchFilterEntryDate => 'Data de ingreso';

  @override
  String get batchFilterFrom => 'Desde';

  @override
  String get batchFilterTo => 'Hasta';

  @override
  String get batchFilterAny => 'Cualquiera';

  @override
  String get batchFilterCancel => 'Cancelar';

  @override
  String get batchFilterApply => 'Aplicar';

  @override
  String get batchCloseSummary => 'Resumo de Cierre';

  @override
  String get batchCloseStartDate => 'Data de início';

  @override
  String get batchCloseEndDate => 'Data de cierre';

  @override
  String get batchCloseDate => 'Data de cierre';

  @override
  String get batchCloseDuration => 'Duração';

  @override
  String get batchCloseDays => 'dias';

  @override
  String get batchCloseCycleDuration => 'Duração del ciclo';

  @override
  String get batchCloseCycleInfo => 'Informações del ciclo';

  @override
  String get batchClosePopulation => 'População';

  @override
  String get batchCloseTotalMortality => 'Mortalidade total';

  @override
  String get batchCloseMortality => 'Mortalidade';

  @override
  String get batchCloseMortalityPercent => 'Mortalidade %';

  @override
  String get batchCloseFinalMetrics => 'Métricas Finales';

  @override
  String get batchCloseFinalWeight => 'Final peso';

  @override
  String get batchCloseFinalWeightLabel => 'Final peso (kg)';

  @override
  String get batchCloseWeightGain => 'Peso gain';

  @override
  String get batchCloseEstimatedWeight => 'Estimated peso';

  @override
  String get batchCloseFeedConversion => 'Conversão alimenticia';

  @override
  String get batchCloseGrams => 'gramas';

  @override
  String get batchCloseWeightRequired => 'El peso es obrigatório';

  @override
  String get batchCloseWeightMustBePositive => 'Peso must be positive';

  @override
  String get batchCloseWeightTooHigh => 'Peso seems too high';

  @override
  String get batchCloseWeightHelper => 'Peso médio por ave en kg';

  @override
  String get batchCloseFinalObservations => 'Observações Finales';

  @override
  String get batchCloseObservationsHint => 'Escriba sus observações aquí...';

  @override
  String get batchCloseIrreversible => 'Ação irreversível';

  @override
  String get batchCloseIrreversibleMessage =>
      'Once fechard, the lote cannot be reopened';

  @override
  String get batchCloseConfirm => 'Confirmar closure';

  @override
  String get batchCloseSaleInfo => 'Informações de Venda';

  @override
  String get batchCloseBirdsToSell => 'Aves to sell';

  @override
  String get batchCloseBirdsUnit => 'aves';

  @override
  String get batchCloseSalePriceLabel => 'Preço de venda por kg';

  @override
  String get batchCloseSalePriceHelper => 'Preço en moneda local';

  @override
  String get batchClosePricePerKg => 'Preço por kg';

  @override
  String get batchCloseEstimatedValue => 'Valor estimado';

  @override
  String get batchCloseBuyerLabel => 'Comprador';

  @override
  String get batchCloseBuyerHint => 'Nome del comprador (opcional)';

  @override
  String get batchCloseFinancialBalance => 'Balance financeiro';

  @override
  String get batchCloseTotalIncome => 'Ingresos totales';

  @override
  String get batchCloseTotalExpenses => 'Gastos totales';

  @override
  String get batchCloseProfitability => 'Rentabilidad';

  @override
  String get batchCloseEnterValidNumber => 'Insira um número válido';

  @override
  String get batchFormName => 'Nome del lote';

  @override
  String get batchFormBasicInfoSubtitle => 'Informações básica del lote';

  @override
  String get batchFormBasicInfoNote =>
      'Complete la informações básica del lote';

  @override
  String get batchFormDetailsSubtitle => 'Detalhes adicionales del lote';

  @override
  String get batchFormReviewSubtitle => 'Revise la informações antes de criar';

  @override
  String get batchFormFarm => 'Granja';

  @override
  String get batchFormLocation => 'Localização';

  @override
  String get batchFormShedInfo => 'Informações del galpão';

  @override
  String get batchFormShedLocationInfo => 'Localização del galpão';

  @override
  String get batchFormCapacity => 'Capacidade';

  @override
  String get batchFormMaxCapacity => 'Capacidade máxima';

  @override
  String get batchFormArea => 'Área';

  @override
  String get batchFormAvailable => 'Disponível';

  @override
  String get batchFormShedCapacity => 'Capacidade del galpão';

  @override
  String get batchFormShedCapacityNote =>
      'La quantidade no puede exceder la capacidade';

  @override
  String get batchFormExceedsCapacity => 'Excede la capacidade del galpão';

  @override
  String get batchFormUtilization => 'Utilização';

  @override
  String get batchFormCreateShedFirst => 'Cree un galpão primeiro';

  @override
  String get batchFormAgeAtEntry => 'Idade na entrada';

  @override
  String get batchFormAgeHint => 'Edad en dias (opcional)';

  @override
  String get batchFormAgeInfoNote => 'La edad se calcula automáticamente';

  @override
  String get batchFormOptional => 'Opcional';

  @override
  String get batchFormNotSelected => 'No selecionedo';

  @override
  String get batchFormNotSpecified => 'No especificado';

  @override
  String get batchFormNotFound => 'Não encontrado';

  @override
  String get batchFormUnits => 'unidadees';

  @override
  String get batchFormDirty => 'Sucio';

  @override
  String get batchFormCurrentBirds => 'Current aves';

  @override
  String get batchFormInvalidNumber => 'Número inválido';

  @override
  String get batchFormInvalidValue => 'Valor inválido';

  @override
  String get batchFormMortalityEventInfo =>
      'Informações del evento de mortalidad';

  @override
  String get batchFormMortalityEventSubtitle =>
      'Registre los detalhes del evento';

  @override
  String get batchFormMortalityDetailsTitle => 'Detalhes de Mortalidade';

  @override
  String get batchFormMortalityDetailsSubtitle =>
      'Describa los detalhes adicionales';

  @override
  String get batchFormMortalityDescription => 'Descrição de mortalidad';

  @override
  String get batchFormMortalityDescriptionHint =>
      'Descreva as circunstâncias...';

  @override
  String get batchFormRecommendation => 'Recomendação';

  @override
  String get batchFormRecommendedActions => 'Acciones recomendadas';

  @override
  String get batchFormPhotoEvidence => 'Foto evidence';

  @override
  String get batchFormPhotoOptional => 'Opcional fotos';

  @override
  String get batchFormPhotoHelpText => 'Take or selecionar fotos as evidence';

  @override
  String get batchFormNoPhotos => 'No fotos';

  @override
  String get batchFormMaxPhotos => 'Maximum fotos reached';

  @override
  String get batchFormSelectedPhotos => 'Fotos selecionedas';

  @override
  String get batchFormTakePhoto => 'Tirar foto';

  @override
  String get batchFormGallery => 'Galeria';

  @override
  String get batchFormObservationsAndEvidence => 'Observações y Evidencia';

  @override
  String get batchFormObservationsSubtitle => 'Agregue observações adicionales';

  @override
  String get batchFormWeightInfo => 'Informações de Peso';

  @override
  String get batchFormWeightSubtitle => 'Record lote peso';

  @override
  String get batchFormWeightMethod => 'Método de pesagem';

  @override
  String get batchFormWeightRanges => 'Peso Ranges';

  @override
  String get batchFormWeightRangesSubtitle => 'Classify by peso ranges';

  @override
  String get batchFormWeightMin => 'Minimum peso';

  @override
  String get batchFormWeightMax => 'Maximum peso';

  @override
  String get batchFormWeightSummary => 'Resumo de Peso';

  @override
  String get batchFormWeightSummarySubtitle =>
      'Resumo de los datos registrados';

  @override
  String get batchFormAutoCalculatedWeight => 'Automatically calculated peso';

  @override
  String get batchFormCalculatedAvgWeight => 'Peso médio calculado';

  @override
  String get batchFormCalculatedMetrics => 'Métricas calculadas';

  @override
  String get batchFormMetricsAutoCalculated =>
      'Las métricas se calculan automáticamente';

  @override
  String get batchFormConsumptionInfo => 'Informações de Consumo';

  @override
  String get batchFormConsumptionSubtitle => 'Registre o consumo de alimento';

  @override
  String get batchFormConsumptionSaveNote =>
      'Los datos se salvarán al continuar';

  @override
  String get batchFormFoodFromInventory => 'Alimento del inventário';

  @override
  String get batchFormSelectFoodHint => 'Selecionar a food item';

  @override
  String get batchFormNoFoodInInventory => 'No hay ração en inventário';

  @override
  String get batchFormFoodBatch => 'Food lote';

  @override
  String get batchFormLowStock => 'Estoque baixo';

  @override
  String get batchFormDetailsCosts => 'Detalhes y Custos';

  @override
  String get batchFormDetailsCostsSubtitle => 'Insira detalhes y custos';

  @override
  String get batchFormCostPerBird => 'Custo por ave';

  @override
  String get batchFormCostThisRecord => 'Custo de este registro';

  @override
  String get batchFormProductionInfo => 'Informações de Produção';

  @override
  String get batchFormProductionInfoSubtitle => 'Registre la produção de ovos';

  @override
  String get batchFormEggsCollected => 'Ovos recolectados';

  @override
  String get batchFormDefectiveEggs => 'Ovos defectuosos';

  @override
  String get batchFormLayingPercentage => 'Porcentagem de postura';

  @override
  String get batchFormLayingIndicator => 'Indicador de postura';

  @override
  String get batchFormExcellentPerformance => 'Rendimento excelente';

  @override
  String get batchFormAcceptablePerformance => 'Rendimento aceptable';

  @override
  String get batchFormBelowExpectedPerformance =>
      'Rendimento por debaixo de lo esperado';

  @override
  String get batchFormProductionSummary => 'Resumo de produção';

  @override
  String get batchFormCompleteAmountToSeeMetrics =>
      'Complete la quantidade para ver métricas';

  @override
  String get batchFormEggClassification => 'Classificação de Ovos';

  @override
  String get batchFormEggClassificationSubtitle =>
      'Clasifique los ovos recolectados';

  @override
  String get batchFormClassifyForWeight => 'Classify by peso';

  @override
  String get batchFormSmallEggs => 'Ovos pequenos';

  @override
  String get batchFormMediumEggs => 'Ovos médios';

  @override
  String get batchFormLargeEggs => 'Ovos grandes';

  @override
  String get batchFormExtraLargeEggs => 'Ovos extra grandes';

  @override
  String get batchFormBroken => 'Quebrados';

  @override
  String get batchFormGoodEggs => 'Ovos boms';

  @override
  String get batchFormTotalClassified => 'Total clasificados';

  @override
  String get batchFormTotalToClassify => 'Total a clasificar';

  @override
  String get batchFormClassificationSummary => 'Resumo de classificação';

  @override
  String get batchFormCannotExceedCollected =>
      'No puede exceder los ovos recolectados';

  @override
  String get batchFormExcessEggs => 'Exceso de ovos clasificados';

  @override
  String get batchFormMissingEggs => 'Faltan ovos por clasificar';

  @override
  String get batchFormSizeClassification => 'Classificação por tamano';

  @override
  String get birdTypeBroiler => 'Frango de Corte';

  @override
  String get birdTypeLayer => 'Gallina Ponedora';

  @override
  String get birdTypeHeavyBreeder => 'Reprodutora Pesada';

  @override
  String get birdTypeLightBreeder => 'Reprodutora Liviana';

  @override
  String get birdTypeTurkey => 'Pavo';

  @override
  String get birdTypeQuail => 'Codorniz';

  @override
  String get birdTypeDuck => 'Pato';

  @override
  String get birdTypeOther => 'Outro';

  @override
  String get birdTypeShortBroiler => 'Engorde';

  @override
  String get birdTypeShortLayer => 'Ponedora';

  @override
  String get birdTypeShortHeavyBreeder => 'Rep. Pesada';

  @override
  String get birdTypeShortLightBreeder => 'Rep. Liviana';

  @override
  String get birdTypeShortTurkey => 'Pavo';

  @override
  String get birdTypeShortQuail => 'Codorniz';

  @override
  String get birdTypeShortDuck => 'Pato';

  @override
  String get birdTypeShortOther => 'Outro';

  @override
  String get batchStatusInTransfer => 'En Transferencia';

  @override
  String get batchStatusDescInTransfer => 'Lote being transferred';

  @override
  String get weighMethodManual => 'Manual';

  @override
  String get weighMethodIndividualScale => 'Báscula Individual';

  @override
  String get weighMethodBatchScale => 'Lote Scale';

  @override
  String get weighMethodAutomatic => 'Automática';

  @override
  String get weighMethodDescManual => 'Manual com balança';

  @override
  String get weighMethodDescIndividualScale => 'Báscula individual';

  @override
  String get weighMethodDescBatchScale => 'Lote scale';

  @override
  String get weighMethodDescAutomatic => 'Sistema automático';

  @override
  String get weighMethodDetailManual =>
      'Pesagem ave por ave con báscula portátil';

  @override
  String get weighMethodDetailIndividualScale => 'Electronic scale for one ave';

  @override
  String get weighMethodDetailBatchScale =>
      'Pesagem grupal dividido entre quantidade';

  @override
  String get weighMethodDetailAutomatic => 'Sistema automatizado integrado';

  @override
  String get feedTypePreStarter => 'Pre-iniciador';

  @override
  String get feedTypeStarter => 'Iniciador';

  @override
  String get feedTypeGrower => 'Crescimento';

  @override
  String get feedTypeFinisher => 'Finalizador';

  @override
  String get feedTypeLayer => 'Postura';

  @override
  String get feedTypeRearing => 'Levante';

  @override
  String get feedTypeMedicated => 'Medicado';

  @override
  String get feedTypeConcentrate => 'Concentrado';

  @override
  String get feedTypeOther => 'Outro';

  @override
  String get feedTypeDescPreStarter => 'Pre-iniciador (0-7 dias)';

  @override
  String get feedTypeDescStarter => 'Iniciador (8-21 dias)';

  @override
  String get feedTypeDescGrower => 'Crescimento (22-35 dias)';

  @override
  String get feedTypeDescFinisher => 'Finalizador (36+ dias)';

  @override
  String get feedTypeDescLayer => 'Postura';

  @override
  String get feedTypeDescRearing => 'Levante';

  @override
  String get feedTypeDescMedicated => 'Medicado';

  @override
  String get feedTypeDescConcentrate => 'Concentrado';

  @override
  String get feedTypeDescOther => 'Outro';

  @override
  String get feedAgeRangePreStarter => '0-7 dias';

  @override
  String get feedAgeRangeStarter => '8-21 dias';

  @override
  String get feedAgeRangeGrower => '22-35 dias';

  @override
  String get feedAgeRangeFinisher => '36+ dias';

  @override
  String get feedAgeRangeLayer => 'Gallinas ponedoras';

  @override
  String get feedAgeRangeRearing => 'Pollitas reemplazo';

  @override
  String get feedAgeRangeMedicated => 'Con tratamento';

  @override
  String get feedAgeRangeConcentrate => 'Suplemento';

  @override
  String get feedAgeRangeOther => 'Uso geral';

  @override
  String get eggClassSmall => 'Pequeno';

  @override
  String get eggClassMedium => 'Média';

  @override
  String get eggClassLarge => 'Grande';

  @override
  String get eggClassExtraLarge => 'Extra Grande';

  @override
  String get validateBatchQuantityMin =>
      'La quantidade inicial debe ser al menos 10 aves';

  @override
  String get validateBatchQuantityMax =>
      'La quantidade inicial no puede exceder 100,000 aves';

  @override
  String get validateMortalityMin =>
      'La quantidade de mortalidad debe ser mayor a 0';

  @override
  String validateMortalityExceedsCurrent(Object current, Object mortality) {
    return 'La quantidade de mortalidad ($mortality) no puede exceder la quantidade actual ($current)';
  }

  @override
  String get validateWeightMin => 'El peso debe ser mayor a 0 gramas';

  @override
  String get validateWeightMax =>
      'El peso no puede exceder 20,000 gramas (20 kg)';

  @override
  String get validateFeedMin => 'La quantidade de alimento debe ser mayor a 0';

  @override
  String get validateFeedMax =>
      'La quantidade de alimento no puede exceder 10,000 kg';

  @override
  String get validateEggLayerOnly =>
      'Solo los lotes de ponedoras pueden producir ovos';

  @override
  String get validateEggMin => 'La quantidade de ovos debe ser mayor a 0';

  @override
  String validateEggRateHigh(Object rate) {
    return 'A taxa de postura de $rate% parece muito alta. Verifique os dados.';
  }

  @override
  String get validateDateFuture => 'La data de ingreso no puede ser futura';

  @override
  String get validateDateTooOld =>
      'A data de entrada parece muito antiga (mais de 5 anos)';

  @override
  String get validateCloseDateBeforeEntry =>
      'A data de encerramento não pode ser anterior à data de entrada';

  @override
  String get validateCloseDateFuture => 'La data de cierre no puede ser futura';

  @override
  String validateCodeExists(Object code) {
    return 'Ya existe outro lote con el código \"$code\"';
  }

  @override
  String get batchRecordingMortality => 'Recording mortalidade...';

  @override
  String get batchRecordingDiscard => 'Registrando descarte...';

  @override
  String get batchRecordingSale => 'Registrando venda...';

  @override
  String get batchMarkingSold => 'Registrando venda completa...';

  @override
  String get batchCreatedSuccess => 'Lote criado com sucesso';

  @override
  String get batchUpdatedSuccess => 'Lote atualizado com sucesso';

  @override
  String get batchMortalityRecorded => 'Mortalidade registrada';

  @override
  String get batchDiscardRecorded => 'Descarte registrado';

  @override
  String get batchSaleRecorded => 'Venda registrada';

  @override
  String get batchMarkedSold => 'Lote marked as sold';

  @override
  String get validateSelectBirdType => 'Selecionar ave tipo';

  @override
  String get validateSelectEntryDate => 'Seleccione la data de ingreso';

  @override
  String get validateCodeRequired => 'El código es obrigatório';

  @override
  String get validateCodeMinLength => 'Mínimo 3 caracteres';

  @override
  String get validateQuantityValid => 'Insira una quantidade válida';

  @override
  String get saleProductLiveBirds => 'Live Aves';

  @override
  String get saleProductLiveBirdsDesc => 'Venda de aves en pie';

  @override
  String get saleProductEggs => 'Ovos';

  @override
  String get saleProductEggsDesc => 'Venda de ovos por classificação';

  @override
  String get saleProductManure => 'Pollinaza/Gallinaza';

  @override
  String get saleProductManureDesc => 'Subproduto orgánico';

  @override
  String get saleProductProcessedBirds => 'Processed Aves';

  @override
  String get saleProductProcessedBirdsDesc => 'Aves processed for consumption';

  @override
  String get saleProductCullBirds => 'Cull Aves';

  @override
  String get saleProductCullBirdsDesc => 'Aves at end of produção cycle';

  @override
  String get saleStatusPending => 'Pendentes';

  @override
  String get saleStatusPendingDesc => 'Awaiting confirmaration';

  @override
  String get saleStatusConfirmed => 'Confirmared';

  @override
  String get saleStatusConfirmedDesc => 'Confirmared by client';

  @override
  String get saleStatusInPreparation => 'Em Preparação';

  @override
  String get saleStatusInPreparationDesc => 'Preparando produto';

  @override
  String get saleStatusReadyToShip => 'Pronta para Despacho';

  @override
  String get saleStatusReadyToShipDesc => 'Pronta para entregar';

  @override
  String get saleStatusInTransit => 'En Tránsito';

  @override
  String get saleStatusInTransitDesc => 'A caminho do cliente';

  @override
  String get saleStatusDelivered => 'Entregada';

  @override
  String get saleStatusDeliveredDesc => 'Entregada com sucesso';

  @override
  String get saleStatusInvoiced => 'Faturada';

  @override
  String get saleStatusInvoicedDesc => 'Fatura generada';

  @override
  String get saleStatusCancelled => 'Cancelarled';

  @override
  String get saleStatusCancelledDesc => 'Cancelarled';

  @override
  String get saleStatusReturned => 'Devuelta';

  @override
  String get saleStatusReturnedDesc => 'Devolvida pelo cliente';

  @override
  String get orderStatusPending => 'Pendentes';

  @override
  String get orderStatusPendingDesc => 'Order awaiting confirmaration';

  @override
  String get orderStatusConfirmed => 'Confirmared';

  @override
  String get orderStatusConfirmedDesc => 'Order aprovado';

  @override
  String get orderStatusInPreparation => 'Em Preparação';

  @override
  String get orderStatusInPreparationDesc => 'Pedido sendo preparado';

  @override
  String get orderStatusReadyToShip => 'Listo Despacho';

  @override
  String get orderStatusReadyToShipDesc => 'Preparado para envio';

  @override
  String get orderStatusInTransit => 'En Tránsito';

  @override
  String get orderStatusInTransitDesc => 'Pedido en camino';

  @override
  String get orderStatusDelivered => 'Entregado';

  @override
  String get orderStatusDeliveredDesc => 'Order concluído';

  @override
  String get orderStatusCancelled => 'Cancelarled';

  @override
  String get orderStatusCancelledDesc => 'Pedido anulado';

  @override
  String get orderStatusReturned => 'Devuelto';

  @override
  String get orderStatusReturnedDesc => 'Pedido retornado';

  @override
  String get orderStatusPartial => 'Parcial';

  @override
  String get orderStatusPartialDesc => 'Entrega incompleta';

  @override
  String get saleUnitBag => 'Bulto';

  @override
  String get saleUnitBagDesc => 'Saco de 50 kg';

  @override
  String get saleUnitTon => 'Tonelada';

  @override
  String get saleUnitTonDesc => 'Tonelada métrica';

  @override
  String get saleUnitKg => 'Kilogramo';

  @override
  String get saleUnitKgDesc => 'Kilogramo';

  @override
  String get saleEggClassExtraLarge => 'Extra Grande';

  @override
  String get saleEggClassLarge => 'Grande';

  @override
  String get saleEggClassMedium => 'Média';

  @override
  String get saleEggClassSmall => 'Pequeno';

  @override
  String get costTypeFeed => 'Ração';

  @override
  String get costTypeFeedDesc => 'Concentrados y granos';

  @override
  String get costTypeLaborDesc => 'Salarios y beneficios';

  @override
  String get costTypeEnergyDesc => 'Electricidad y combustible';

  @override
  String get costTypeMedicineDesc => 'Sanidad animal';

  @override
  String get costTypeMaintenanceDesc => 'Reparaciones y limpieza';

  @override
  String get costTypeWaterDesc => 'Consumo de água';

  @override
  String get costTypeTransportDesc => 'Logística e mobilização';

  @override
  String get costTypeAdminDesc => 'Gastos gerales';

  @override
  String get costTypeDepreciationDesc => 'Desgaste de ativos';

  @override
  String get costTypeFinancialDesc => 'Intereses y comisiones';

  @override
  String get costTypeOtherDesc => 'Gastos varios';

  @override
  String get costCategoryProduction => 'Custo de Produção';

  @override
  String get costCategoryPersonnel => 'Gastos de Pessoal';

  @override
  String get costCategoryOperating => 'Gastos Operativos';

  @override
  String get costCategoryDistribution => 'Gastos de Distribuição';

  @override
  String get costCategoryAdmin => 'Gastos Administrativos';

  @override
  String get costCategoryDepreciation => 'Depreciação y Amortización';

  @override
  String get costCategoryFinancial => 'Gastos Financeiros';

  @override
  String get costCategoryOther => 'Outros Gastos';

  @override
  String get costValidateConceptEmpty => 'El conceito no puede estar vacío';

  @override
  String get costValidateAmountPositive => 'Valor must be greater than 0';

  @override
  String get costValidateBirdCountPositive =>
      'Quantidade de aves debe ser mayor a 0';

  @override
  String get costValidateApprovalNotRequired =>
      'Este gasto não requer aprovação';

  @override
  String get costValidateAlreadyApproved => 'This expense is already aprovado';

  @override
  String get costValidateRejectionReasonRequired =>
      'Debe proporcionar un motivo de rejeição';

  @override
  String get costCenterBatch => 'Lote';

  @override
  String get costCenterHouse => 'Casa';

  @override
  String get costCenterAdmin => 'Administrativa';

  @override
  String get invItemTypeFeed => 'Ração';

  @override
  String get invItemTypeFeedDesc => 'Concentrados, granos y suplementos';

  @override
  String get invItemTypeMedicine => 'Medicamento';

  @override
  String get invItemTypeMedicineDesc => 'Fármacos y produtos sanitarios';

  @override
  String get invItemTypeVaccine => 'Vacina';

  @override
  String get invItemTypeVaccineDesc => 'Vacinas y biológicos';

  @override
  String get invItemTypeEquipment => 'Equipo';

  @override
  String get invItemTypeEquipmentDesc => 'Herramientas y maquinaria';

  @override
  String get invItemTypeSupply => 'Insumo';

  @override
  String get invItemTypeSupplyDesc => 'Material de cama, embalagens, etc.';

  @override
  String get invItemTypeCleaning => 'Limpieza';

  @override
  String get invItemTypeCleaningDesc => 'Desinfectantes y produtos de aseo';

  @override
  String get invItemTypeOther => 'Outro';

  @override
  String get invItemTypeOtherDesc => 'Items varios';

  @override
  String get invMovePurchase => 'Compra';

  @override
  String get invMovePurchaseDesc => 'Entrada por aquisição';

  @override
  String get invMoveDonation => 'Doação';

  @override
  String get invMoveDonationDesc => 'Entrada por doação';

  @override
  String get invMoveReturn => 'Devolução';

  @override
  String get invMoveReturnDesc => 'Entrada por devolução de uso';

  @override
  String get invMoveAdjustUp => 'Ajuste (+)';

  @override
  String get invMoveAdjustUpDesc => 'Ajuste de inventário positivo';

  @override
  String get invMoveBatchConsumption => 'Lote Consumption';

  @override
  String get invMoveBatchConsumptionDesc => 'Salida por alimentação de aves';

  @override
  String get invMoveTreatment => 'Tratamento';

  @override
  String get invMoveTreatmentDesc => 'Saída por aplicação de medicamento';

  @override
  String get invMoveVaccination => 'Vacinação';

  @override
  String get invMoveVaccinationDesc => 'Salida por aplicación de vacina';

  @override
  String get invMoveShrinkage => 'Merma';

  @override
  String get invMoveShrinkageDesc => 'Pérdida por deterioro o vencimento';

  @override
  String get invMoveAdjustDown => 'Ajuste (-)';

  @override
  String get invMoveAdjustDownDesc => 'Ajuste de inventário negativo';

  @override
  String get invMoveTransfer => 'Transferencia';

  @override
  String get invMoveTransferDesc => 'Traslado a outra localização';

  @override
  String get invMoveGeneralUse => 'Uso Geral';

  @override
  String get invMoveGeneralUseDesc => 'Saída por uso operacional';

  @override
  String get invMoveSale => 'Venda';

  @override
  String get invMoveSaleDesc => 'Salida por venda de produtos';

  @override
  String get invUnitKilogram => 'Kilogramo';

  @override
  String get invUnitGram => 'Gramo';

  @override
  String get invUnitPound => 'Libra';

  @override
  String get invUnitLiter => 'Litro';

  @override
  String get invUnitMilliliter => 'Mililitro';

  @override
  String get invUnitUnit => 'Unidade';

  @override
  String get invUnitDozen => 'Dúzia';

  @override
  String get invUnitSack => 'Saco';

  @override
  String get invUnitBag => 'Bulto';

  @override
  String get invUnitBox => 'Caja';

  @override
  String get invUnitVial => 'Frasco';

  @override
  String get invUnitDose => 'Dose';

  @override
  String get invUnitAmpoule => 'Ampolla';

  @override
  String get invUnitCategoryWeight => 'Peso';

  @override
  String get invUnitCategoryVolume => 'Volumen';

  @override
  String get invUnitCategoryQuantity => 'Quantidade';

  @override
  String get invUnitCategoryPackaging => 'Empaque';

  @override
  String get invUnitCategoryApplication => 'Aplicação';

  @override
  String get healthDiseaseCatViral => 'Viral';

  @override
  String get healthDiseaseCatViralDesc => 'Doenças causadas por virus';

  @override
  String get healthDiseaseCatBacterial => 'Bacteriana';

  @override
  String get healthDiseaseCatBacterialDesc => 'Doenças causadas por bacterias';

  @override
  String get healthDiseaseCatParasitic => 'Parasitaria';

  @override
  String get healthDiseaseCatParasiticDesc => 'Doenças causadas por parásitos';

  @override
  String get healthDiseaseCatFungal => 'Fúngica';

  @override
  String get healthDiseaseCatFungalDesc => 'Doenças causadas por hongos';

  @override
  String get healthDiseaseCatNutritional => 'Nutricional';

  @override
  String get healthDiseaseCatNutritionalDesc => 'Deficiencias nutricionales';

  @override
  String get healthDiseaseCatMetabolic => 'Metabólica';

  @override
  String get healthDiseaseCatMetabolicDesc => 'Trastornos metabólicos';

  @override
  String get healthDiseaseCatEnvironmental => 'Ambiental';

  @override
  String get healthDiseaseCatEnvironmentalDesc =>
      'Causadas por fatores ambientais';

  @override
  String get healthSeverityMild => 'Leve';

  @override
  String get healthSeverityMildDesc => 'Baixo impacto en produção';

  @override
  String get healthSeverityModerate => 'Moderada';

  @override
  String get healthSeverityModerateDesc => 'Impacto médio en produção';

  @override
  String get healthSeveritySevere => 'Grave';

  @override
  String get healthSeveritySevereDesc => 'Alto impacto, requer ação imediata';

  @override
  String get healthSeverityCritical => 'Crítica';

  @override
  String get healthSeverityCriticalDesc => 'Emergencia sanitaria';

  @override
  String get healthDiseaseNewcastle => 'Doença de Newcastle';

  @override
  String get healthDiseaseGumboro => 'Doença de Gumboro (IBD)';

  @override
  String get healthDiseaseMarek => 'Doença de Marek';

  @override
  String get healthDiseaseBronchitis => 'Bronquite Infecciosa (IB)';

  @override
  String get healthDiseaseAvianFlu => 'Influenza Aviar (HPAI/LPAI)';

  @override
  String get healthDiseaseLaryngotracheitis =>
      'Laringoutraqueitis Infecciosa (ILT)';

  @override
  String get healthDiseaseFowlPox => 'Viruela Aviar';

  @override
  String get healthDiseaseInfectiousAnemia => 'Anemia Infecciosa Aviar (CAV)';

  @override
  String get healthDiseaseColibacillosis => 'Colibacilosis (E. coli)';

  @override
  String get healthDiseaseSalmonella => 'Salmonelosis';

  @override
  String get healthDiseaseMycoplasmosis => 'Micoplasmosis (MG/MS)';

  @override
  String get healthDiseaseFowlCholera => 'Cólera Aviar';

  @override
  String get healthDiseaseCoryza => 'Coriza Infecciosa';

  @override
  String get healthDiseaseNecroticEnteritis => 'Enteritis Necrótica';

  @override
  String get healthDiseaseCoccidiosis => 'Coccidiosis';

  @override
  String get healthDiseaseRoundworms => 'Ascaridiasis (Lombrices)';

  @override
  String get healthDiseaseAspergillosis => 'Aspergilosis';

  @override
  String get healthDiseaseAscites => 'Simndrome Ascítico';

  @override
  String get healthDiseaseSuddenDeath => 'Simndrome de Muerte Súbita (SDS)';

  @override
  String get healthDiseaseVitEDeficiency => 'Encefalomalacia (Def. Vit E)';

  @override
  String get healthDiseaseRickets => 'Raquitismo (Def. Vit D/Ca/P)';

  @override
  String get healthMortalityDisease => 'Doença';

  @override
  String get healthMortalityDiseaseDesc => 'Patología infecciosa';

  @override
  String get healthMortalityAccident => 'Accidente';

  @override
  String get healthMortalityAccidentDesc => 'Trauma o lesión';

  @override
  String get healthMortalityMalnutrition => 'Desnutrição';

  @override
  String get healthMortalityMalnutritionDesc => 'Falta de nutrientes';

  @override
  String get healthMortalityStress => 'Estrés';

  @override
  String get healthMortalityStressDesc => 'Factores ambientales';

  @override
  String get healthMortalityMetabolic => 'Metabólica';

  @override
  String get healthMortalityMetabolicDesc => 'Problemas fisiológicos';

  @override
  String get healthMortalityPredation => 'Predação';

  @override
  String get healthMortalityPredationDesc => 'Ataques de animais';

  @override
  String get healthMortalitySacrifice => 'Sacrificio';

  @override
  String get healthMortalitySacrificeDesc => 'Muerte en faena';

  @override
  String get healthMortalityOldAge => 'Vejez';

  @override
  String get healthMortalityOldAgeDesc => 'Fim da vida produtiva';

  @override
  String get healthMortalityUnknown => 'Desconhecido';

  @override
  String get healthMortalityUnknownDesc => 'Causa no identificada';

  @override
  String get healthMortalityCatSanitary => 'Sanitaria';

  @override
  String get healthMortalityCatManagement => 'Gestão';

  @override
  String get healthMortalityCatNutritional => 'Nutricional';

  @override
  String get healthMortalityCatEnvironmental => 'Ambiental';

  @override
  String get healthMortalityCatPhysiological => 'Fisiológica';

  @override
  String get healthMortalityCatNatural => 'Natural';

  @override
  String get healthMortalityCatUnclassified => 'Sin clasificar';

  @override
  String get healthActionVetDiagnosis => 'Solicitar diagnóstico veterinário';

  @override
  String get healthActionIsolate => 'Isolate affected aves';

  @override
  String get healthActionTreatment => 'Aplicar tratamento si está disponível';

  @override
  String get healthActionBiosecurity => 'Aumentar biossegurança';

  @override
  String get healthActionVaccinationReview => 'Revisar programa de vacinação';

  @override
  String get healthActionInspectFacilities => 'Inspeccionar instalaciones';

  @override
  String get healthActionRepairEquipment => 'Reparar equipamentos danificados';

  @override
  String get healthActionCheckDensity => 'Check ave density';

  @override
  String get healthActionTrainStaff => 'Capacitar personal en manejo';

  @override
  String get healthActionCheckFoodAccess => 'Verificar acesso ao alimento';

  @override
  String get healthActionCheckFoodQuality => 'Revisar qualidade do alimento';

  @override
  String get healthActionCheckDrinkers =>
      'Verificar funcionamento dos bebedouros';

  @override
  String get healthActionAdjustNutrition => 'Ajustar programa nutricional';

  @override
  String get healthActionRegulateTemp => 'Regulate ambient temperatura';

  @override
  String get healthActionImproveVentilation => 'Mejorar ventilação';

  @override
  String get healthActionReduceDensity => 'Reducir densidad si es necesario';

  @override
  String get healthActionConsultNutritionist => 'Consultar nutricionista';

  @override
  String get healthActionReviewGrowthProgram =>
      'Revisar programa de crescimento';

  @override
  String get healthActionAdjustFormula => 'Adjust ração formulation';

  @override
  String get healthActionReinforceFences => 'Reforzar cercos perimetrales';

  @override
  String get healthActionPestControl => 'Implementar controle de pragas';

  @override
  String get healthActionInstallNets => 'Instalar redes de proteção';

  @override
  String get healthActionNormalProcess => 'Normal in produção process';

  @override
  String get healthActionRequestNecropsy =>
      'Request necropsy if mortalidade is high';

  @override
  String get healthActionIncreaseMonitoring => 'Increase lote monitoring';

  @override
  String get healthActionConsultVet => 'Consultar con veterinário';

  @override
  String get healthRouteOral => 'Oral';

  @override
  String get healthRouteOralDesc => 'Administração por via oral';

  @override
  String get healthRouteWater => 'En Água';

  @override
  String get healthRouteWaterDesc => 'Disuelta en água de bebida';

  @override
  String get healthRouteFood => 'In Ração';

  @override
  String get healthRouteFoodDesc => 'Misto in ração';

  @override
  String get healthRouteOcular => 'Ocular';

  @override
  String get healthRouteOcularDesc => 'Gota no olho';

  @override
  String get healthRouteNasal => 'Nasal';

  @override
  String get healthRouteNasalDesc => 'Spray o gota nasal';

  @override
  String get healthRouteSpray => 'Spray';

  @override
  String get healthRouteSprayDesc => 'Spraying over aves';

  @override
  String get healthRouteSubcutaneous => 'Injeção SC';

  @override
  String get healthRouteSubcutaneousDesc => 'Subcutánea en cuello';

  @override
  String get healthRouteIntramuscular => 'Injeção IM';

  @override
  String get healthRouteIntramuscularDesc => 'Intramuscular en pechuga';

  @override
  String get healthRouteWing => 'En Ala';

  @override
  String get healthRouteWingDesc => 'Punção na membrana da asa';

  @override
  String get healthRouteInOvo => 'In-Ovo';

  @override
  String get healthRouteInOvoDesc => 'Inyección en el ovo';

  @override
  String get healthRouteTopical => 'Tópica';

  @override
  String get healthRouteTopicalDesc => 'Aplicação externa en piel';

  @override
  String get healthBioStatusPending => 'Pendentes';

  @override
  String get healthBioStatusCompliant => 'Conforme';

  @override
  String get healthBioStatusNonCompliant => 'No Conforme';

  @override
  String get healthBioStatusPartial => 'Parcial';

  @override
  String get healthBioStatusNA => 'N/A';

  @override
  String get healthBioCatPersonnel => 'Acesso de Pessoal';

  @override
  String get healthBioCatPersonnelDesc => 'Controle de entrada e vestimenta';

  @override
  String get healthBioCatVehicles => 'Acesso de Veículos';

  @override
  String get healthBioCatVehiclesDesc => 'Controle de veículos e equipamentos';

  @override
  String get healthBioCatCleaning => 'Limpieza y Desinfecção';

  @override
  String get healthBioCatCleaningDesc => 'Pquebradocolos de higiene';

  @override
  String get healthBioCatPestControl => 'Controle de Pragas';

  @override
  String get healthBioCatPestControlDesc => 'Rodents, insects, wild aves';

  @override
  String get healthBioCatBirdManagement => 'Ave Management';

  @override
  String get healthBioCatBirdManagementDesc => 'Practices with aves';

  @override
  String get healthBioCatMortality => 'Manejo de Mortalidade';

  @override
  String get healthBioCatMortalityDesc => 'Morto ave disposal';

  @override
  String get healthBioCatWater => 'Calidad del Água';

  @override
  String get healthBioCatWaterDesc => 'Potabilidade e cloração';

  @override
  String get healthBioCatFeed => 'Ração Management';

  @override
  String get healthBioCatFeedDesc => 'Armazenamento e qualidade';

  @override
  String get healthBioCatFacilities => 'Instalaciones';

  @override
  String get healthBioCatFacilitiesDesc => 'Status de galpões y equipos';

  @override
  String get healthBioCatRecords => 'Registros';

  @override
  String get healthBioCatRecordsDesc => 'Documentação e rastreabilidade';

  @override
  String get healthInspFreqDaily => 'Diário';

  @override
  String get healthInspFreqWeekly => 'Semanal';

  @override
  String get healthInspFreqBiweekly => 'Bisemanal';

  @override
  String get healthInspFreqMonthly => 'Mensal';

  @override
  String get healthInspFreqQuarterly => 'Trimêstral';

  @override
  String get healthInspFreqPerBatch => 'Per Lote';

  @override
  String get healthAbCriticallyImportant => 'Críticamente Importante';

  @override
  String get healthAbHighlyImportant => 'Altamente Importante';

  @override
  String get healthAbImportant => 'Importante';

  @override
  String get healthAbUnclassified => 'No Clasificado';

  @override
  String get healthAbFamilyFluoroquinolones => 'Fluoroquinolonas';

  @override
  String get healthAbFamilyCephalosporins => 'Cefalosporinas 3a/4a gen';

  @override
  String get healthAbFamilyMacrolides => 'Macrólidos';

  @override
  String get healthAbFamilyPolymyxins => 'Polimixinas (Colistina)';

  @override
  String get healthAbFamilyAminoglycosides => 'Aminoglucósidos';

  @override
  String get healthAbFamilyPenicillins => 'Penicilinas';

  @override
  String get healthAbFamilyTetracyclines => 'Tetraciclinas';

  @override
  String get healthAbFamilySulfonamides => 'Sulfonamidas';

  @override
  String get healthAbFamilyLincosamides => 'Lincosamidas';

  @override
  String get healthAbFamilyPleuromutilins => 'Pleuromutilinas';

  @override
  String get healthAbFamilyBacitracin => 'Bacitracina';

  @override
  String get healthAbFamilyIonophores => 'Ionóforos';

  @override
  String get healthAbUseTreatment => 'Tratamento';

  @override
  String get healthAbUseTreatmentDesc => 'Tratamento de doença diagnosticada';

  @override
  String get healthAbUseMetaphylaxis => 'Metafilaxis';

  @override
  String get healthAbUseMetaphylaxisDesc =>
      'Tratamento preventivo de grupo en riesgo';

  @override
  String get healthAbUseProphylaxis => 'Profilaxis';

  @override
  String get healthAbUseProphylaxisDesc => 'Prevenção en animales saudávels';

  @override
  String get healthAbUseGrowthPromoter => 'Promotor de Crescimento';

  @override
  String get healthAbUseGrowthPromoterDesc => 'Uso prohibido en muchos países';

  @override
  String get healthBirdTypeBroiler => 'Frango de Corte';

  @override
  String get healthBirdTypeLayerCommercial => 'Gallina Ponedora Comercial';

  @override
  String get healthBirdTypeLayerFreeRange => 'Gallina Ponedora Pastoreo';

  @override
  String get healthBirdTypeHeavyBreeder => 'Reprodutora Pesada';

  @override
  String get healthBirdTypeLightBreeder => 'Reprodutora Ligera';

  @override
  String get healthBirdTypeTurkeyMeat => 'Peru de Corte';

  @override
  String get healthBirdTypeQuail => 'Codorniz';

  @override
  String get healthBirdTypeDuck => 'Pato';

  @override
  String get farmStatusMaintenance => 'Manutenção';

  @override
  String get farmRoleOwner => 'Proprietário';

  @override
  String get farmRoleAdmin => 'Administrador';

  @override
  String get farmRoleManager => 'Gestor';

  @override
  String get farmRoleOperator => 'Operario';

  @override
  String get farmRoleViewer => 'Visualizador';

  @override
  String get farmRoleOwnerDesc => 'Control total, puede excluir la granja';

  @override
  String get farmRoleAdminDesc => 'Control total excepto excluir';

  @override
  String get farmRoleManagerDesc => 'Gestão de registros e invitaciones';

  @override
  String get farmRoleOperatorDesc => 'Solo puede criar registros';

  @override
  String get farmRoleViewerDesc => 'Solo lectura';

  @override
  String get farmCreating => 'Creating granja...';

  @override
  String get farmUpdating => 'Updating granja...';

  @override
  String get farmDeleting => 'Deleting granja...';

  @override
  String get farmActivating => 'Activating granja...';

  @override
  String get farmSuspending => 'Suspendente granja...';

  @override
  String get farmMaintenanceLoading => 'Poniendo en manutenção...';

  @override
  String get farmSearching => 'Buscaring granjas...';

  @override
  String get shedStatusActive => 'Ativo';

  @override
  String get shedStatusMaintenance => 'Manutenção';

  @override
  String get shedStatusInactive => 'Inativo';

  @override
  String get shedStatusDisinfection => 'Desinfecção';

  @override
  String get shedStatusQuarantine => 'Quarentena';

  @override
  String get shedTypeMeat => 'Engorde';

  @override
  String get shedTypeMeatDesc => 'Galpão para produção de carne';

  @override
  String get shedTypeEgg => 'Ovo';

  @override
  String get shedTypeEggDesc => 'Galpão para produção de ovos';

  @override
  String get shedTypeBreeder => 'Reprodutora';

  @override
  String get shedTypeBreederDesc => 'Galpão para produção de ovos fértiles';

  @override
  String get shedTypeMixed => 'Misto';

  @override
  String get shedTypeMixedDesc =>
      'Galpão multiuso para diferentes tipos de produção';

  @override
  String get shedEventDisinfection => 'Desinfecção';

  @override
  String get shedEventMaintenance => 'Manutenção';

  @override
  String get shedEventStatusChange => 'Cambio de Status';

  @override
  String get shedEventCreation => 'Criação';

  @override
  String get shedEventBatchAssigned => 'Lote Assigned';

  @override
  String get shedEventBatchReleased => 'Lote Released';

  @override
  String get shedEventOther => 'Outro';

  @override
  String get shedCreating => 'Creando galpão...';

  @override
  String get shedUpdating => 'Actualizando galpão...';

  @override
  String get shedDeleting => 'Eliminando galpão...';

  @override
  String get shedChangingStatus => 'Cambiando status...';

  @override
  String get shedAssigningBatch => 'Assigning lote...';

  @override
  String get shedReleasing => 'Liberando galpão...';

  @override
  String get shedSchedulingMaintenance => 'Programando manutenção...';

  @override
  String get shedBatchAssignedSuccess => 'Lote asignado com sucesso';

  @override
  String get shedReleasedSuccess => 'Galpão liberado com sucesso';

  @override
  String get shedMaintenanceScheduled => 'Manutenção programado';

  @override
  String get notifStockLow => 'Estoque Baixo';

  @override
  String get notifStockEmpty => 'Esgotado';

  @override
  String get notifExpiringSoon => 'Próximo a Vencer';

  @override
  String get notifExpired => 'Vencida';

  @override
  String get notifRestocked => 'Reabastecido';

  @override
  String get notifInventoryMovement => 'Movimento';

  @override
  String get notifMortalityRecorded => 'Mortalidade Registrada';

  @override
  String get notifMortalityHigh => 'Mortalidade Alta';

  @override
  String get notifMortalityCritical => 'Mortalidade Crítica';

  @override
  String get notifNewBatch => 'Novo Lote';

  @override
  String get notifBatchFinished => 'Lote Finigalpão';

  @override
  String get notifWeightLow => 'Peso Baixo';

  @override
  String get notifCloseUpcoming => 'Fechar Upcoming';

  @override
  String get notifConversionAbnormal => 'Conversão Anormal';

  @override
  String get notifNoRecords => 'Sin Registros';

  @override
  String get notifProduction => 'Produção';

  @override
  String get notifProductionLow => 'Produção Baja';

  @override
  String get notifProductionDrop => 'Caída Produção';

  @override
  String get notifFirstEgg => 'Primer Ovo';

  @override
  String get notifRecord => 'Récord';

  @override
  String get notifGoalReached => 'Meta Alcanzada';

  @override
  String get notifVaccination => 'Vacinação';

  @override
  String get notifVaccinationTomorrow => 'Vacinação Amanhã';

  @override
  String get notifPriorityLow => 'Baja';

  @override
  String get notifPriorityNormal => 'Normal';

  @override
  String get notifPriorityHigh => 'Alta';

  @override
  String get notifPriorityUrgent => 'Urgente';

  @override
  String notifTitleStockLow(Object itemName) {
    return '⚠️ Estoque baixo: $itemName';
  }

  @override
  String notifMsgStockLow(Object quantity, Object unit) {
    return 'Solo quedan $quantity $unit';
  }

  @override
  String notifTitleStockEmpty(Object itemName) {
    return '🚫 Esgotado: $itemName';
  }

  @override
  String get notifMsgStockEmpty =>
      'Estoque zerado, requer reabastecimento urgente';

  @override
  String notifTitleExpired(Object itemName) {
    return '❌ Vencido: $itemName';
  }

  @override
  String notifMsgExpired(Object days) {
    return 'Este produto venció hace $days dias';
  }

  @override
  String notifTitleExpiringSoon(Object itemName) {
    return '📅 Próximo a vencer: $itemName';
  }

  @override
  String get notifMsgExpiresToday => 'Vence hoje!';

  @override
  String notifMsgExpiresInDays(Object days) {
    return 'Vence en $days dias';
  }

  @override
  String notifTitleRestocked(Object itemName) {
    return '✅ Reabastecido: $itemName';
  }

  @override
  String notifMsgRestocked(Object quantity, Object unit) {
    return 'Se adicionaron $quantity $unit';
  }

  @override
  String notifTitleMortalityCritical(Object batchName) {
    return '🚨 Mortalidade CRÍTICA: $batchName';
  }

  @override
  String notifTitleMortalityHigh(Object batchName) {
    return '⚠️ Mortalidade alta: $batchName';
  }

  @override
  String notifTitleMortalityRecorded(Object batchName) {
    return '🐔 Mortalidade registrada: $batchName';
  }

  @override
  String notifMsgMortalityRecorded(
    Object cause,
    Object count,
    Object percentage,
  ) {
    return '$count aves • Cause: $cause • Accumulated: $percentage%';
  }

  @override
  String notifTitleNewBatch(Object batchName) {
    return '🐤 Novo lote: $batchName';
  }

  @override
  String notifMsgNewBatch(Object birdCount, Object shedName) {
    return '$birdCount aves in $shedName';
  }

  @override
  String notifTitleBatchFinished(Object batchName) {
    return '✅ Lote finigalpão: $batchName';
  }

  @override
  String notifMsgBatchFinished(Object days) {
    return 'Ciclo de $days dias';
  }

  @override
  String notifTitleWeightLow(Object batchName) {
    return '⚖️ Peso baixo: $batchName';
  }

  @override
  String notifTitleConversionAbnormal(Object batchName) {
    return '📊 Conversão anormal: $batchName';
  }

  @override
  String notifTitleCloseUpcoming(Object batchName) {
    return '📆 Fechar upcoming: $batchName';
  }

  @override
  String get notifMsgClosesToday => 'A data de encerramento é hoje!';

  @override
  String notifMsgClosesInDays(Object days) {
    return 'Cierra en $days dias';
  }

  @override
  String get reportTypeBatchProduction => 'Produção de Lote';

  @override
  String get reportTypeBatchProductionDesc =>
      'Resumo completo del rendimento productivo';

  @override
  String get reportTypeMortality => 'Mortalidade';

  @override
  String get reportTypeMortalityDesc =>
      'Detailed mortalidade and cause analysis';

  @override
  String get reportTypeFeedConsumption => 'Ração Consumption';

  @override
  String get reportTypeFeedConsumptionDesc =>
      'Análisis de consumo y conversão alimenticia';

  @override
  String get reportTypeWeight => 'Peso and Growth';

  @override
  String get reportTypeWeightDesc => 'Peso evolution and growth curves';

  @override
  String get reportTypeCosts => 'Custos';

  @override
  String get reportTypeCostsDesc => 'Desglose de gastos y custos operativos';

  @override
  String get reportTypeSales => 'Vendas';

  @override
  String get reportTypeSalesDesc => 'Resumo de vendas e ingresos';

  @override
  String get reportTypeProfitability => 'Rentabilidad';

  @override
  String get reportTypeProfitabilityDesc =>
      'Análise de rentabilidade e margens';

  @override
  String get reportTypeHealth => 'Salud';

  @override
  String get reportTypeHealthDesc => 'Historial de tratamentos y vacinações';

  @override
  String get reportTypeInventory => 'Inventário';

  @override
  String get reportTypeInventoryDesc => 'Status actual del inventário';

  @override
  String get reportTypeExecutive => 'Resumo Ejecutivo';

  @override
  String get reportTypeExecutiveDesc =>
      'Visão consolidada de indicadores chave';

  @override
  String get reportPeriodWeek => 'Última semana';

  @override
  String get reportPeriodMonth => 'Último mês';

  @override
  String get reportPeriodQuarter => 'Último trimêstre';

  @override
  String get reportPeriodSemester => 'Último semêstre';

  @override
  String get reportPeriodYear => 'Último ano';

  @override
  String get reportPeriodCustom => 'Personalizado';

  @override
  String get reportFormatPdf => 'PDF';

  @override
  String get reportFormatPreview => 'Vista previa';

  @override
  String get reportPdfHeaderProduction => 'RELATÓRIO DE PRODUÇÃO';

  @override
  String get reportPdfHeaderExecutive => 'RESUMEN EJECUTIVO';

  @override
  String get reportPdfHeaderCosts => 'RELATÓRIO DE CUSTOS';

  @override
  String get reportPdfHeaderSales => 'RELATÓRIO DE VENDAS';

  @override
  String get reportPdfSectionBatchInfo => 'INFORMAÇÃO DO LOTE';

  @override
  String get reportPdfSectionProductionIndicators => 'INDICADORES DE PRODUÇÃO';

  @override
  String get reportPdfSectionFinancialSummary => 'RESUMEN FINANCIERO';

  @override
  String get reportPdfLabelCode => 'Código';

  @override
  String get reportPdfLabelBirdType => 'Tipo de Ave';

  @override
  String get reportPdfLabelShed => 'Galpão';

  @override
  String get reportPdfLabelEntryDate => 'Data de Entrada';

  @override
  String get reportPdfLabelCurrentAge => 'Idade Atual';

  @override
  String get reportPdfLabelDaysInFarm => 'Dias en Granja';

  @override
  String get reportPdfLabelInitialBirds => 'Initial Aves';

  @override
  String get reportPdfLabelCurrentBirds => 'Aves Atuais';

  @override
  String get reportPdfLabelMortality => 'Mortalidade';

  @override
  String get reportPdfLabelAvgWeight => 'Peso Promédio';

  @override
  String get reportPdfLabelTotalConsumption => 'Consumo Total';

  @override
  String get reportPdfLabelConversion => 'Conversão';

  @override
  String get reportPdfLabelBirdCost => 'Custo de Aves';

  @override
  String get reportPdfLabelFeedCost => 'Custo de Alimento';

  @override
  String get reportPdfLabelTotalCosts => 'Total Custos';

  @override
  String get reportPdfLabelSalesRevenue => 'Ingresos por Vendas';

  @override
  String get reportPdfLabelBalance => 'BALANCE';

  @override
  String get reportPdfLabelPeriod => 'PERÍODO';

  @override
  String get reportPdfConversionSubtitle => 'kg ração / kg peso';

  @override
  String get reportPageTitle => 'Relatórios';

  @override
  String get reportSelectType => 'Selecione el tipo de relatório';

  @override
  String get reportSelectFarm => 'Selecione uma granja';

  @override
  String get reportSelectFarmHint =>
      'Para generar relatórios, primeiro debes selecionar una granja desde el início.';

  @override
  String get reportPeriodPrefix => 'Período:';

  @override
  String get reportPeriodTitle => 'Período del relatório';

  @override
  String get reportDateFrom => 'Desde';

  @override
  String get reportDateTo => 'Hasta';

  @override
  String get reportGenerating => 'Gerando...';

  @override
  String get reportGeneratePdf => 'Generar Relatório PDF';

  @override
  String get reportNoFarmSelected => 'No hay granja selecioneda';

  @override
  String get reportNoActiveBatches =>
      'No hay lotes ativos para generar el relatório';

  @override
  String get reportInsufficientData =>
      'No hay datos suficientes para el relatório';

  @override
  String get reportGenerateError => 'Erro al generar relatório';

  @override
  String get reportGenerated => 'Relatório Generado';

  @override
  String get reportPrint => 'Imprimir';

  @override
  String get reportShareText => 'Relatório generado por Smart Granja Aves Pro';

  @override
  String get reportShareError => 'Erro al compartilhar';

  @override
  String get reportPrintError => 'Erro al imprimir';

  @override
  String get notifPageTitle => 'Notificações';

  @override
  String get notifMarkAllRead => 'Marcar todas como leídas';

  @override
  String get notifDeleteRead => 'Excluir leídas';

  @override
  String get notifLoadError => 'Erro al carregar notificaciones';

  @override
  String get notifAllMarkedRead => 'Todas marcadas como leídas';

  @override
  String get notifDeleteTitle => 'Excluir notificaciones';

  @override
  String get notifDeleteReadConfirm =>
      'Deseja excluir todas as notificações lidas?';

  @override
  String get notifDeleted => 'Notificações eliminadas';

  @override
  String get notifNoDestination =>
      'Esta notificación no tiene un destino disponível';

  @override
  String get notifSingleDeleted => 'Notificação excluird';

  @override
  String get notifAllCaughtUp => 'Tudo em dia!';

  @override
  String get notifEmptyMessage =>
      'You have no pendente notificaçãos.\nWe\'ll let you know when something important comes up.';

  @override
  String get notifTooltip => 'Notificações';

  @override
  String get profileEditProfile => 'Edit perfil';

  @override
  String get syncTitle => 'Sincronização e Dados';

  @override
  String get syncConnectionStatus => 'Status de Conexión';

  @override
  String get syncPendingData => 'Pendente data';

  @override
  String get syncChangesPending => 'Há alterações a sincronizar';

  @override
  String get syncAllSynced => 'Todo sincronizado';

  @override
  String get syncLastSync => 'Última sincronização';

  @override
  String get syncCheckConnection => 'Verificar conexión';

  @override
  String get syncCompleted => 'Sync concluído';

  @override
  String get syncForceSync => 'Forçar sincronização';

  @override
  String get syncOfflineInfo =>
      'Data is automatically salvard to your device and synced when internet connection is disponível.';

  @override
  String get syncJustNow => 'Agora mesmo';

  @override
  String syncMinutesAgo(String n) {
    return 'Hace $n minutos';
  }

  @override
  String syncHoursAgo(Object n) {
    return '$n horas ago';
  }

  @override
  String syncDaysAgo(Object n) {
    return 'Hace $n dias';
  }

  @override
  String get commonNotSpecified => 'No especificada';

  @override
  String get farmBroiler => 'Engorde';

  @override
  String get farmLayer => 'Ponedora';

  @override
  String get farmBreeder => 'Reprodutor';

  @override
  String get farmBird => 'Ave';

  @override
  String get formStepBasic => 'Básico';

  @override
  String get formStepLocation => 'Localização';

  @override
  String get formStepContact => 'Contacto';

  @override
  String get formStepCapacity => 'Capacidade';

  @override
  String get commonLeave => 'Sair';

  @override
  String get commonRestore => 'Restaurar';

  @override
  String get commonProcessing => 'Processando...';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonDocument => 'Documento';

  @override
  String get commonSupplier => 'Fornecedor';

  @override
  String get commonRegistrationInfo => 'Informações de Registro';

  @override
  String get commonLastUpdate => 'Última atualização';

  @override
  String get commonDraftFoundTitle => 'Rascunho encontrado';

  @override
  String get commonExitWithoutCompleting => 'Sair sem completar?';

  @override
  String get commonDataSafe => 'Não se preocupe, seus dados estão seguros.';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonFarm => 'Granja';

  @override
  String get commonBatch => 'Lote';

  @override
  String get commonFarmNotFound => 'Granja não encontrada';

  @override
  String get commonBatchNotFound => 'Lote no encontrado';

  @override
  String get monthJanuary => 'Janro';

  @override
  String get monthFebruary => 'Fevrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Settiembre';

  @override
  String get monthOctober => 'Outubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Deziembre';

  @override
  String get monthJanAbbr => 'ene';

  @override
  String get monthFebAbbr => 'feb';

  @override
  String get monthMarAbbr => 'mar';

  @override
  String get monthAprAbbr => 'abr';

  @override
  String get monthMayAbbr => 'may';

  @override
  String get monthJunAbbr => 'jun';

  @override
  String get monthJulAbbr => 'jul';

  @override
  String get monthAugAbbr => 'ago';

  @override
  String get monthSepAbbr => 'sep';

  @override
  String get monthOctAbbr => 'oct';

  @override
  String get monthNovAbbr => 'nov';

  @override
  String get monthDecAbbr => 'dic';

  @override
  String get ventaLoteTitle => 'Vendas del Lote';

  @override
  String get ventaAllTitle => 'Todas las Vendas';

  @override
  String get ventaFilterTooltip => 'Filtrar';

  @override
  String get ventaEmptyTitle => 'Sem vendas registradas';

  @override
  String get ventaEmptyDescription =>
      'Registre sua primeira venda para começar a controlar seus ganhos';

  @override
  String get ventaEmptyAction => 'Registrar primeira venda';

  @override
  String get ventaFilterEmptyTitle => 'Nenhuma venda encontrada';

  @override
  String get ventaFilterEmptyDescription =>
      'Prueba modificando los filtros de búsqueda para encontrar las vendas que buscas';

  @override
  String get ventaNewButton => 'Nova Venda';

  @override
  String get ventaNewTooltip => 'Registrar nova venda';

  @override
  String get ventaDeleteTitle => 'Excluir venda?';

  @override
  String get ventaDeleteSuccess => 'Venda eliminada correctamente';

  @override
  String get ventaFilterTitle => 'Filtrar vendas';

  @override
  String get ventaFilterProductType => 'Tipo de produto';

  @override
  String get ventaFilterSaleState => 'Status da venda';

  @override
  String get ventaFilterAllStates => 'Todos os estados';

  @override
  String get ventaStatePending => 'Pendentes';

  @override
  String get ventaStateConfirmed => 'Confirmared';

  @override
  String get ventaStateSold => 'Vendida';

  @override
  String get ventaSheetClient => 'Cliente';

  @override
  String get ventaSheetDiscount => 'Desconto';

  @override
  String get ventaSheetInvoiceNumber => 'Nº Fatura';

  @override
  String get ventaSheetCarrier => 'Transportista';

  @override
  String get ventaSheetGuideNumber => 'Guia #';

  @override
  String get ventaSheetBirdCount => 'Quantidade aves';

  @override
  String get ventaSheetAvgWeight => 'Peso médio';

  @override
  String get ventaSheetPricePerKg => 'Preço por kg';

  @override
  String get ventaSheetSlaughteredWeight => 'Slaughtered peso';

  @override
  String get ventaSheetYield => 'Rendimento';

  @override
  String get ventaSheetTotalEggs => 'Total ovos';

  @override
  String get ventaDetailNotFound => 'Venda no encontrada';

  @override
  String get ventaDetailTitle => 'Detalhe de Venda';

  @override
  String get ventaDetailEditTooltip => 'Editar venda';

  @override
  String get ventaDetailClient => 'Cliente';

  @override
  String get ventaDetailProductDetails => 'Detalhes del Produto';

  @override
  String get ventaDetailBirdCount => 'Quantidade de aves';

  @override
  String get ventaDetailAvgWeight => 'Peso médio';

  @override
  String get ventaDetailPricePerKg => 'Preço por kg';

  @override
  String get ventaDetailQuantity => 'Quantidade';

  @override
  String get ventaDetailUnitPrice => 'Preço unitario';

  @override
  String get ventaDetailCarcassYield => 'Rendimento canal';

  @override
  String get ventaDetailTotalLabel => 'TOTAL';

  @override
  String get ventaDetailShare => 'Compartilhar';

  @override
  String get ventaDetailSlaughteredWeight => 'Slaughtered peso';

  @override
  String get ventaStepProduct => 'Produto';

  @override
  String get ventaStepClient => 'Cliente';

  @override
  String get ventaStepDetails => 'Detalhes';

  @override
  String get ventaDraftFoundMessage =>
      'Deseja restaurar o rascunho de venda salvo anteriormente?';

  @override
  String get ventaDraftRestored => 'Rascunho restaurado';

  @override
  String get ventaDraftJustNow => 'ahora mismo';

  @override
  String get ventaExitMessage => 'Não se preocupe, seus dados estão seguros.';

  @override
  String get ventaNoEditPermission =>
      'Você não tem permissão para editar vendas nesta granja';

  @override
  String get ventaNoCreatePermission =>
      'Você não tem permissão para registrar vendas nesta granja';

  @override
  String get ventaUpdateSuccess => 'Venda atualizada correctamente';

  @override
  String get ventaCreateSuccess => 'Venda registrada com sucesso!';

  @override
  String get ventaInventoryWarning =>
      'Venda registrada, pero hubo un erro al atualizar inventário';

  @override
  String get ventaEditTitle => 'Editar Venda';

  @override
  String get ventaNewTitle => 'Nova Venda';

  @override
  String get ventaSelectProductFirst => 'Selecione un tipo de produto primeiro';

  @override
  String get ventaDetailsHint =>
      'Insira quantidadees, preços y outros detalhes';

  @override
  String get ventaNoFarmSelected =>
      'No hay una granja selecioneda. Por favor selecione una granja primeiro.';

  @override
  String get ventaLotLabel => 'Lote *';

  @override
  String get ventaNoActiveLots => 'No hay lotes ativos en esta granja.';

  @override
  String get ventaSelectLotHint => 'Selecione un lote';

  @override
  String get ventaSelectLotError => 'Selecione un lote';

  @override
  String get ventaSaleDate => 'Data de venda';

  @override
  String get ventaBirdCount => 'Quantidade de aves';

  @override
  String get ventaBirdCountRequired => 'Insira la quantidade de aves';

  @override
  String get ventaTotalWeight => 'Total peso (kg)';

  @override
  String get ventaSlaughteredWeight => 'Total slaughtered peso (kg)';

  @override
  String get ventaWeightRequired => 'Insira el peso total';

  @override
  String ventaPricePerKg(String currency) {
    return 'Preço por kg ($currency)';
  }

  @override
  String get ventaPriceRequired => 'Insira el preço por kg';

  @override
  String get ventaEggInstructions =>
      'Insira la quantidade y preço por dúzia para cada classificação';

  @override
  String get ventaEggQuantity => 'Quantidade';

  @override
  String ventaEggPricePerDozen(String currency) {
    return '$currency por dúzia';
  }

  @override
  String get ventaSaleUnit => 'Unidade de venda';

  @override
  String get ventaQuantityRequired => 'Insira la quantidade';

  @override
  String get ventaPriceRequired2 => 'Insira el preço';

  @override
  String get ventaObservations => 'Observações';

  @override
  String get ventaObservationsHint => 'Notas adicionais (opcional)';

  @override
  String get ventaSubmitButton => 'Registrar Venda';

  @override
  String get ventaEditPageTitle => 'Editar Venda';

  @override
  String get ventaEditNotFound => 'Venda no encontrada';

  @override
  String get ventaEditLoadError => 'Erro al carregar la venda';

  @override
  String get ventaWhatToSell => 'O que deseja vender?';

  @override
  String get ventaSelectProductType =>
      'Selecione el tipo de produto para esta venda';

  @override
  String get ventaDescAvesVivas =>
      'Venda de aves en pie, listas para transporte o crianza';

  @override
  String get ventaDescHuevos => 'Venda de ovos por classificação y dúzia';

  @override
  String get ventaDescPollinaza =>
      'Venda de abono orgánico por bulto, saco o tonelada';

  @override
  String get ventaDescAvesFaenadas => 'Processed aves ready for consumption';

  @override
  String get ventaDescAvesDescarte => 'Cull aves at end of produção cycle';

  @override
  String get ventaClientData => 'Dados do Cliente';

  @override
  String get ventaClientHint => 'Insira la informações del comprador';

  @override
  String get ventaClientName => 'Nome completo';

  @override
  String get ventaClientNameHint => 'Ex: Juan Pérez García';

  @override
  String get ventaClientDocType => 'Document tipo *';

  @override
  String get ventaClientCE => 'RNE';

  @override
  String get ventaClientDocNumber => 'Número do documento';

  @override
  String get ventaClientDni8 => '8 dígitos';

  @override
  String get ventaClientRuc11 => '11 dígitos';

  @override
  String get ventaClientPhone => 'Telefone de contacto';

  @override
  String get ventaClient9Digits => '9 dígitos';

  @override
  String get ventaClientNameRequired => 'Insira el nome del cliente';

  @override
  String get ventaClientNameMinLength =>
      'El nome debe tener al menos 3 caracteres';

  @override
  String get ventaClientDocRequired => 'Insira el número do documento';

  @override
  String get ventaClientDniError => 'El CPF debe tener 8 dígitos';

  @override
  String get ventaClientRucError => 'El CNPJ debe tener 11 dígitos';

  @override
  String get ventaClientInvalidNumber => 'Número inválido';

  @override
  String get ventaClientPhoneRequired => 'Insira el telefone de contacto';

  @override
  String get ventaClientPhoneError => 'El telefone debe tener 9 dígitos';

  @override
  String get ventaSelectLocation => 'Selecionar Localização';

  @override
  String get ventaSelectLocationHint =>
      'Selecione la granja y el lote para registrar la venda';

  @override
  String get ventaNoFarms => 'No granjas registrared';

  @override
  String get ventaCreateFarmFirst =>
      'Debes criar una granja antes de registrar una venda';

  @override
  String get ventaFarmLabel => 'Granja *';

  @override
  String get ventaSelectFarmHint => 'Selecione uma granja';

  @override
  String get ventaFarmRequired => 'Por favor selecione una granja';

  @override
  String get ventaNoActiveLots2 => 'No hay lotes ativos';

  @override
  String get ventaNoActiveLotsHint =>
      'Esta granja no tiene lotes ativos para registrar vendas';

  @override
  String get ventaLotLabel2 => 'Lote *';

  @override
  String get ventaSelectLotHint2 => 'Selecione un lote';

  @override
  String get ventaLotRequired => 'Por favor selecione un lote';

  @override
  String get ventaFarmLoadError => 'Erro al carregar granjas';

  @override
  String get ventaLotLoadError2 => 'Erro al carregar lotes';

  @override
  String get ventaSummaryTitle => 'Resumo de Vendas';

  @override
  String get ventaSummaryTotal => 'Total en vendas';

  @override
  String get ventaSummaryActive => 'Ativo';

  @override
  String get ventaSummaryCompleted => 'Concluído';

  @override
  String get ventaLoadError => 'Erro al carregar vendas';

  @override
  String get ventaLoadErrorDetail =>
      'Ocurrió un problema al obtener las vendas';

  @override
  String get ventaCardBuyer => 'Comprador: ';

  @override
  String get ventaCardProduct => 'Produto: ';

  @override
  String get ventaCardBirds => 'aves';

  @override
  String get ventaCardEggs => 'ovos';

  @override
  String get ventaShareReceiptTitle => '📋 COMPROVANTE DE VENDA';

  @override
  String get costoLoteTitle => 'Custos del Lote';

  @override
  String get costoAllTitle => 'Todos los Custos';

  @override
  String get costoFilterTooltip => 'Filtrar';

  @override
  String get costoEmptyTitle => 'Sin custos registrados';

  @override
  String get costoEmptyDescription =>
      'Registra tus gastos operativos para llevar un control detallado de los custos de produção';

  @override
  String get costoEmptyAction => 'Registrar Custo';

  @override
  String get costoFilterEmptyTitle => 'No se encontraron custos';

  @override
  String get costoFilterEmptyDescription =>
      'Tente ajustar os filtros ou buscar com outros termos';

  @override
  String get costoNewButton => 'Novo Custo';

  @override
  String get costoNewTooltip => 'Registrar novo custo';

  @override
  String get costoRejectTitle => 'Rejeitar Custo';

  @override
  String get costoRejectReasonLabel => 'Motivo da rejeição';

  @override
  String get costoRejectReasonHint => 'Explica por qué se rechaza este custo';

  @override
  String get costoRejectButton => 'Rejeitar';

  @override
  String get costoRejectReasonRequired => 'Insira un motivo de rejeição';

  @override
  String get costoDeleteTitle => 'Excluir Custo';

  @override
  String get costoDeleteWarning => 'Esta ação não pode ser desfeita.';

  @override
  String get costoDeleteSuccess => 'Custo eliminado correctamente';

  @override
  String get costoFilterTitle => 'Filtrar custos';

  @override
  String get costoFilterExpenseType => 'Expense tipo';

  @override
  String get costoDetailLoadError => 'No pudimos carregar el detalhe del custo';

  @override
  String get costoDetailNotFound => 'Custo no encontrado';

  @override
  String get costoDetailTitle => 'Detalhe del Custo';

  @override
  String get costoDetailEditTooltip => 'Editar custo';

  @override
  String get costoDetailPending => 'Pendentes';

  @override
  String get costoDetailRejected => 'Rechazado';

  @override
  String get costoDetailApproved => 'Aprovados';

  @override
  String get costoDetailNoStatus => 'Sin status';

  @override
  String get costoDetailGeneralInfo => 'Informações Geral';

  @override
  String get costoDetailConcept => 'Conceito';

  @override
  String get costoDetailInvoiceNo => 'Nº Fatura';

  @override
  String get costoDetailDeleteConfirm =>
      'Tem certeza de que deseja excluir este custo?';

  @override
  String get costoDetailDeleteWarning => 'Esta ação não pode ser desfeita.';

  @override
  String get costoDetailDeleteError => 'Erro al excluir';

  @override
  String get costoDetailDeleteSuccess => 'Custo eliminado com sucesso';

  @override
  String get costoStepType => 'Tipo';

  @override
  String get costoStepAmount => 'Valor';

  @override
  String get costoStepDetails => 'Detalhes';

  @override
  String get costoDraftFoundMessage =>
      'Deseja restaurar o rascunho salvo anteriormente?';

  @override
  String get costoTypeRequired => 'Por favor selecione un tipo de gasto';

  @override
  String get costoNoEditPermission =>
      'Você não tem permissão para editar custos nesta granja';

  @override
  String get costoNoCreatePermission =>
      'Você não tem permissão para registrar custos nesta granja';

  @override
  String get costoUpdateSuccess => 'Custo atualizado correctamente';

  @override
  String get costoCreateSuccess => 'Custo registrado correctamente';

  @override
  String get costoInventoryWarning =>
      'Custo registrado, pero hubo un erro al atualizar inventário';

  @override
  String get costoEditTitle => 'Editar Custo';

  @override
  String get costoRegisterTitle => 'Registrar Custo';

  @override
  String get costoRegisterButton => 'Registrar';

  @override
  String get costoFarmRequired => 'Por favor selecione una granja';

  @override
  String get costoWhatType => 'What tipo of expense is it?';

  @override
  String get costoSelectCategory =>
      'Selecione la categoría que mejor descreva este gasto';

  @override
  String get costoAmountTitle => 'Expense Valor';

  @override
  String get costoAmountHint => 'Insira el monto total del gasto en soles';

  @override
  String get costoConceptLabel => 'Conceito del gasto';

  @override
  String get costoConceptHint => 'Ex: Compra de alimento balanceado';

  @override
  String get costoConceptRequired => 'Insira el conceito del gasto';

  @override
  String get costoConceptMinLength =>
      'El conceito debe tener al menos 5 caracteres';

  @override
  String get costoAmountLabel => 'Valor';

  @override
  String get costoAmountRequired => 'Insira el monto';

  @override
  String get costoAmountInvalid => 'Insira un monto válido';

  @override
  String get costoDateLabel => 'Data del gasto *';

  @override
  String get costoInventoryLinkInfo =>
      'Você pode vincular este gasto a um produto do inventário para atualizar o estoque automaticamente.';

  @override
  String get costoLinkFood => 'Vincular a alimento del inventário';

  @override
  String get costoLinkMedicine => 'Vincular a medicamento del inventário';

  @override
  String get costoInventorySearchHint => 'Buscar no inventário (opcional)...';

  @override
  String get costoLinkedProduct => 'Produto vinculado';

  @override
  String get costoStockUpdateNote => 'Se atualizará el estoque al salvar';

  @override
  String get costoAdditionalDetails => 'Detalhes Adicionales';

  @override
  String get costoAdditionalDetailsHint =>
      'Informações complementaria del gasto';

  @override
  String get costoSupplierHint => 'Nome del fornecedor o empresa';

  @override
  String get costoSupplierRequired => 'Insira el nome del fornecedor';

  @override
  String get costoSupplierMinLength =>
      'El nome debe tener al menos 3 caracteres';

  @override
  String get costoInvoiceLabel => 'Número de Fatura/Recibo';

  @override
  String get costoObservationsHint => 'Notas adicionais sobre este gasto';

  @override
  String get costoCardType => 'Tipo: ';

  @override
  String get costoCardConcept => 'Conceito: ';

  @override
  String get costoCardSupplier => 'Fornecedor: ';

  @override
  String get costoTypeAlimento => 'Ração';

  @override
  String get costoTypeManoDeObra => 'Mão de Obra';

  @override
  String get costoTypeEnergia => 'Janrgia';

  @override
  String get costoTypeMedicamento => 'Medicamento';

  @override
  String get costoTypeMantenimiento => 'Manutenção';

  @override
  String get costoTypeAgua => 'Água';

  @override
  String get costoTypeTransporte => 'Transporte';

  @override
  String get costoTypeAdministrativo => 'Administrativo';

  @override
  String get costoTypeDepreciacion => 'Depreciação';

  @override
  String get costoTypeFinanciero => 'Financeiro';

  @override
  String get costoTypeOtros => 'Outros';

  @override
  String get costoSummaryTitle => 'Resumo de Custos';

  @override
  String get costoSummaryTotal => 'Total en custos';

  @override
  String get costoSummaryApproved => 'Aprovados';

  @override
  String get costoSummaryPending => 'Pendentes';

  @override
  String get costoLoadError => 'Erro al carregar custos';

  @override
  String get inventarioTitle => 'Inventário';

  @override
  String get invFilterByType => 'Filter by tipo';

  @override
  String get invSearchByNameOrCode => 'Buscar por nome ou código...';

  @override
  String get invTabItems => 'Items';

  @override
  String get invTabMovements => 'Movimentos';

  @override
  String get invNoFarmSelected => 'Sin granja selecioneda';

  @override
  String get invSelectFarmFromHome => 'Selecione una granja desde el início';

  @override
  String get invAddNewItemTooltip => 'Adicionar novo ítem al inventário';

  @override
  String get invNewItem => 'Novo Item';

  @override
  String get invNoResults => 'Sin resultados';

  @override
  String get invNoMovements => 'Sem movimentos';

  @override
  String get invNoMovementsMatchSearch =>
      'Não há movimentos que correspondam à sua busca';

  @override
  String get invNoMovementsYet => 'Não há movimentos registrados ainda';

  @override
  String get invErrorLoadingMovements => 'No pudimos carregar los movimientos';

  @override
  String get invNoItemsInInventory => 'Sin itens en inventário';

  @override
  String get invNoItemsMatchFilters =>
      'Não há itens que coincidan con los filtros';

  @override
  String get invAddYourFirstItem => 'Agrega tu primer item de inventário';

  @override
  String get invClearFilters => 'Limpar filtros';

  @override
  String get invAddItem => 'Adicionar Item';

  @override
  String get invItemDeletedSuccess => 'Item excluird sucessofully';

  @override
  String get invApplyFilter => 'Aplicar filtro';

  @override
  String get invItemDetail => 'Detalhe do Item';

  @override
  String get invRegisterEntry => 'Registrar Entry';

  @override
  String get invRegisterExit => 'Registrar Exit';

  @override
  String get invAdjustStock => 'Ajustar Estoque';

  @override
  String get invItemNotFound => 'Item no encontrado';

  @override
  String get invErrorLoadingItem => 'No pudimos carregar el item de inventário';

  @override
  String get invStockDepleted => 'Esgotado';

  @override
  String get invStockLow => 'Estoque Baixo';

  @override
  String get invStockAvailable => 'Disponível';

  @override
  String get invStockCurrent => 'Estoque Atual';

  @override
  String get invStockMinimum => 'Estoque Mínimo';

  @override
  String get invTotalValue => 'Valor Total';

  @override
  String get invInformation => 'Informações';

  @override
  String get invCode => 'Código';

  @override
  String get invDescription => 'Descrição';

  @override
  String get invUnit => 'Unidade';

  @override
  String get invUnitPrice => 'Preço Unitario';

  @override
  String get invExpiration => 'Vencimento';

  @override
  String get invSupplierBatch => 'Lote Fornecedor';

  @override
  String get invWarehouse => 'Almacén';

  @override
  String get invAlerts => 'Alertas';

  @override
  String get invAlertStockDepleted => 'Estoque esgotado';

  @override
  String get invAlertProductExpired => 'Produto vencido';

  @override
  String get invLastMovements => 'Últimos Movimentos';

  @override
  String get invViewAll => 'Ver todo';

  @override
  String get invNoMovementsRegistered => 'Sem movimentos registrados';

  @override
  String get invCouldNotLoadMovements =>
      'No se pudieron carregar los movimientos';

  @override
  String get invItemDeleted => 'Item excluird';

  @override
  String get invStepType => 'Tipo';

  @override
  String get invStepBasic => 'Básico';

  @override
  String get invStepStock => 'Estoque';

  @override
  String get invStepDetails => 'Detalhes';

  @override
  String get invDraftFound => 'Rascunho encontrado';

  @override
  String get invEditItem => 'Editar Item';

  @override
  String get invNewItemTitle => 'Novo Item';

  @override
  String get invCreateItem => 'Criar Item';

  @override
  String get invImageTooLarge => 'Imagem exceeds 5MB. Choose a smaller one';

  @override
  String get invImageSelected => 'Imagen selecioneda';

  @override
  String get invErrorSelectingImage => 'Erro al selecionar imagen';

  @override
  String get invCouldNotUploadImage => 'Could not upload imagem';

  @override
  String get invItemSavedWithoutImage => 'El item se salvará sin imagen';

  @override
  String get invItemUpdatedSuccess => 'Item atualizado correctamente';

  @override
  String get invDraftAutoSaveMessage =>
      'Don\'t worry, your data is safe. Your progress is salvard automatically.';

  @override
  String get invMovementsTitle => 'Movimentos';

  @override
  String invMovementsOfItem(String item) {
    return 'Movimentos: $item';
  }

  @override
  String get invFilter => 'Filtrar';

  @override
  String get invErrorLoadingMovementsPage => 'Erro al carregar movimientos';

  @override
  String get invNoMovementsWithFilters => 'Não há movimentos com estes filtros';

  @override
  String get invNoMovementsRegisteredHist => 'No movements registrared';

  @override
  String get invClearFiltersHist => 'Limpar filtros';

  @override
  String get invToday => 'Hoje';

  @override
  String get invYesterday => 'Ontem';

  @override
  String get invFilterMovements => 'Filtrar movimentos';

  @override
  String get invMovementType => 'Movement tipo';

  @override
  String get invAll => 'Todos';

  @override
  String get invDateRange => 'Rango de datas';

  @override
  String get invFrom => 'Desde';

  @override
  String get invUntil => 'Hasta';

  @override
  String get invClear => 'Limpar';

  @override
  String get invDialogRegisterEntry => 'Registrar Entry';

  @override
  String get invDialogRegisterExit => 'Registrar Exit';

  @override
  String get invDialogMovementType => 'Movement tipo';

  @override
  String get invSelectType => 'Selecione un tipo';

  @override
  String get invEnterQuantity => 'Insira la quantidade';

  @override
  String get invEnterValidNumberGt0 => 'Insira um número válido mayor a 0';

  @override
  String get invQuantityExceedsStock =>
      'La quantidade excede el estoque disponível';

  @override
  String get invTotalCost => 'Custo total';

  @override
  String get invSupplierName => 'Nome del fornecedor';

  @override
  String get invObservation => 'Observação';

  @override
  String get invReasonOrObservation => 'Motivo u observação';

  @override
  String get invDialogAdjustStock => 'Ajustar Estoque';

  @override
  String get invEnterNewStock => 'Insira el novo estoque';

  @override
  String get invEnterValidNumber => 'Insira um número válido';

  @override
  String get invAdjustmentReason => 'Motivo do ajuste';

  @override
  String get invReasonRequired => 'El motivo es obrigatório';

  @override
  String get invAdjust => 'Ajustar';

  @override
  String get invStockAdjustedSuccess => 'Estoque ajustado correctamente';

  @override
  String get invEntryRegistered => 'Entry registrared sucessofully';

  @override
  String get invExitRegistered => 'Exit registrared sucessofully';

  @override
  String get invDeleteItem => 'Excluir item';

  @override
  String invConfirmDeleteItemName(String name) {
    return 'Tem certeza de que deseja excluir $name?';
  }

  @override
  String get invActionIrreversible => 'Esta ação é irreversível';

  @override
  String get invDeleteWarningDetails =>
      'Se excluirán todos los movimientos y datos asociados';

  @override
  String get invTypeNameToConfirm => 'Escribe el nome del item para confirmar';

  @override
  String get invTypeHere => 'Tipo here...';

  @override
  String get invCardDepleted => 'Esgotado';

  @override
  String get invCardLowStock => 'Estoque Baixo';

  @override
  String get invCardAvailable => 'Disponível';

  @override
  String get invCardProductExpired => 'Produto vencido';

  @override
  String get invViewDetails => 'Ver Detalhes';

  @override
  String get invMoreOptionsItem => 'Mais opções del item';

  @override
  String get invCardDetails => 'Detalhes';

  @override
  String get invCardStock => 'Estoque';

  @override
  String get invCardMinimum => 'Mínimo';

  @override
  String get invCardValue => 'Valor';

  @override
  String get invSelectProduct => 'Selecionar produto';

  @override
  String get invSearchInventory => 'Buscar no inventário...';

  @override
  String get invSearchProduct => 'Buscar produto...';

  @override
  String get invNoProductsFound => 'No se encontraron produtos';

  @override
  String get invNoProductsAvailable => 'No hay produtos disponívels';

  @override
  String get invSelectorStockLow => 'Estoque baixo';

  @override
  String get invErrorLoadingInventory => 'Erro al carregar inventário';

  @override
  String get invStockTitle => 'Estoque';

  @override
  String get invConfigureQuantities =>
      'Configura las quantidadees y unidade de medida';

  @override
  String get invUnitsFilteredAutomatically =>
      'Las unidadees se filtran automáticamente según el tipo de produto selecionedo.';

  @override
  String get invUnitOfMeasure => 'Unidade de Medida *';

  @override
  String get invStockActual => 'Estoque Atual';

  @override
  String get invEnterCurrentStock => 'Insira el estoque actual';

  @override
  String get invEnterValidNumberStock => 'Insira um número válido';

  @override
  String get invStockMin => 'Estoque Mínimo';

  @override
  String get invStockMax => 'Estoque Máximo';

  @override
  String get invOptional => 'Opcional';

  @override
  String get invStockAlerts => 'Alertas de estoque';

  @override
  String get invStockAlertMessage =>
      'Recibirás una notificación cuando el estoque esté por debaixo del mínimo configurado.';

  @override
  String get invBasicInfo => 'Informações Básicas';

  @override
  String get invEnterMainData => 'Insira los datos principales del item';

  @override
  String get invItemName => 'Nome del Item';

  @override
  String get invEnterItemName => 'Insira el nome del item';

  @override
  String get invNameMinChars => 'El nome debe tener al menos 2 caracteres';

  @override
  String get invCodeSkuOptional => 'Código/SKU (opcional)';

  @override
  String get invDescriptionOptional => 'Descrição (opcional)';

  @override
  String get invDescribeProductCharacteristics =>
      'Descreva las características del produto...';

  @override
  String get invSkuHelpsIdentify =>
      'El código/SKU te ajudará a identificar rápidamente el item en tu inventário.';

  @override
  String get invAdditionalDetails => 'Detalhes Adicionales';

  @override
  String get invOptionalInfoBetterControl =>
      'Informações opcional para mejor control';

  @override
  String get invUnitPriceLabel => 'Preço Unitario';

  @override
  String get invSupplierLabel => 'Fornecedor';

  @override
  String get invSupplierNameHint => 'Nome del fornecedor';

  @override
  String get invWarehouseLocation => 'Localização en Almacén';

  @override
  String get invExpirationTitle => 'Vencimento';

  @override
  String get invExpirationDateOptional => 'Data de vencimento (opcional)';

  @override
  String get invSelectDate => 'Selecionar data';

  @override
  String get invSupplierBatchLabel => 'Lote del Fornecedor';

  @override
  String get invBatchNumber => 'Lote number';

  @override
  String get invDetailsOptionalHelp =>
      'Estos datos son opcionales pero ajudan a un mejor control y trazabilidad del inventário.';

  @override
  String get invWhatTypeOfItem => 'What tipo of item is it?';

  @override
  String get invSelectItemCategory =>
      'Selecione la categoría del item de inventário';

  @override
  String get invDescAlimento =>
      'Concentrados, maíz, soya y outros ração para aves';

  @override
  String get invDescMedicamento =>
      'Antibióticos, antiparasitarios y tratamentos veterinários';

  @override
  String get invDescVacuna => 'Vacinas y produtos de inmunización';

  @override
  String get invDescEquipo => 'Drinkers, raçãoers, heating equipment and tools';

  @override
  String get invDescInsumo =>
      'Materiales de cama, desinfectantes y outros insumos';

  @override
  String get invDescLimpieza => 'Produtos de limpieza y desinfecção';

  @override
  String get invDescOtro =>
      'Outros itens que no encajan en las categorías anteriores';

  @override
  String get invProductImage => 'Imagen del Produto';

  @override
  String get invTakePhoto => 'Take Foto';

  @override
  String get invGallery => 'Galeria';

  @override
  String get invImageSelectedLabel => 'Imagen selecioneda';

  @override
  String get invReady => 'Lista';

  @override
  String get invNoImageAdded => 'No imagem added';

  @override
  String get invCanAddProductPhoto => 'Você pode adicionar uma foto do produto';

  @override
  String get invStockBefore => 'Estoque anterior';

  @override
  String get invStockAfter => 'Estoque novo';

  @override
  String get invInventoryLabel => 'Inventário';

  @override
  String get invItemsRegistered => 'itens registrados';

  @override
  String get invViewAllItems => 'Ver todo';

  @override
  String get invTotalItems => 'Total Items';

  @override
  String get invLowStock => 'Estoque Baixo';

  @override
  String get invDepletedItems => 'Esgotados';

  @override
  String get invExpiringSoon => 'Próximo a Vencer';

  @override
  String get saludFilterAll => 'Todos';

  @override
  String get saludFilterInTreatment => 'En tratamento';

  @override
  String get saludFilterClosed => 'Fechard';

  @override
  String get saludRecordsTitle => 'Registros de Saúde';

  @override
  String get saludFilterTooltip => 'Filtrar';

  @override
  String get saludEmptyTitle => 'Sem registros de saúde';

  @override
  String get saludEmptyDescription =>
      'Registre tratamentos, diagnósticos e acompanhamento sanitário do lote';

  @override
  String get saludRegisterTreatment => 'Registrar Tratamento';

  @override
  String get saludNoRecordsFound => 'No se encontraron registros';

  @override
  String get saludNoFilterResults =>
      'Não há registros que coincidan con los filtros aplicados';

  @override
  String get saludFilterByBatch => 'Filter by lote';

  @override
  String get saludNewTreatment => 'Novo Tratamento';

  @override
  String get saludNewTreatmentTooltip => 'Registrar novo tratamento';

  @override
  String get saludFilterRecords => 'Filtrar registros';

  @override
  String get saludTreatmentStatus => 'Status del tratamento';

  @override
  String get saludDeleteRecordTitle => 'Excluir registro?';

  @override
  String get saludRecordDeleted => 'Record excluird sucessofully';

  @override
  String get saludCloseTreatmentTitle => 'Fechar Tratamento';

  @override
  String get saludDescribeResult =>
      'Descreva el resultado del tratamento aplicado';

  @override
  String get saludResultRequired => 'Resultado *';

  @override
  String get saludResultHint => 'Ex: Recuperación completa, sin sintomas';

  @override
  String get saludResultValidation => 'El resultado es obrigatório';

  @override
  String get saludResultMinLength =>
      'Descreva el resultado (mínimo 10 caracteres)';

  @override
  String get saludFinalObservations => 'Observações finales';

  @override
  String get saludAdditionalNotesOptional => 'Notas adicionais (opcional)';

  @override
  String get saludTreatmentClosedSuccess => 'Tratamento cerrado com sucesso';

  @override
  String get saludStatusInTreatment => 'En tratamento';

  @override
  String get saludStatusClosed => 'Fechard';

  @override
  String get saludDiagnosis => 'Diagnóstico';

  @override
  String get saludSymptoms => 'Sintomas';

  @override
  String get saludTreatment => 'Tratamento';

  @override
  String get saludMedications => 'Medicamentos';

  @override
  String get saludDosage => 'Dose';

  @override
  String get saludDuration => 'Duração';

  @override
  String get saludDays => 'dias';

  @override
  String get saludVeterinarian => 'Veterinário';

  @override
  String get saludResult => 'Resultado';

  @override
  String get saludCloseDate => 'Data de cierre';

  @override
  String get saludTreatmentDays => 'Dias de tratamento';

  @override
  String get saludAllBatches => 'Todos';

  @override
  String get saludDetailTitle => 'Detalhe de Registro';

  @override
  String get saludRecordNotFound => 'Registro no encontrado';

  @override
  String get saludLoadError => 'No pudimos carregar el registro de salud';

  @override
  String get saludDetailStatusClosed => 'Fechard';

  @override
  String get saludDetailStatusInTreatment => 'En tratamento';

  @override
  String get saludDetailDiagnosisSection => 'Diagnóstico';

  @override
  String get saludDetailDateLabel => 'Data';

  @override
  String get saludDetailTreatmentSection => 'Tratamento';

  @override
  String get saludDetailUser => 'Usuário';

  @override
  String get saludDetailCloseTreatment => 'Fechar Tratamento';

  @override
  String get saludDetailCloseDate => 'Data de Cierre';

  @override
  String get saludDetailResultOptional => 'Result (Opcional)';

  @override
  String get saludDetailDescribeResult =>
      'Descreva el resultado del tratamento';

  @override
  String get saludDetailDeleteTitle => 'Excluir registro?';

  @override
  String get saludDetailRecordDeleted => 'Record excluird';

  @override
  String get saludDetailTreatmentClosed => 'Tratamento cerrado';

  @override
  String get saludDetailCloseError => 'Erro al fechar tratamento';

  @override
  String get saludDetailDeleteError => 'Erro al excluir registro';

  @override
  String get vacFilterApplied => 'Aplicada';

  @override
  String get vacFilterPending => 'Pendentes';

  @override
  String get vacFilterExpired => 'Vencida';

  @override
  String get vacFilterUpcoming => 'Próxima';

  @override
  String get vacTitle => 'Vacinações';

  @override
  String get vacFilterTooltip => 'Filtrar';

  @override
  String get vacEmptyTitle => 'No hay vacinações programadas';

  @override
  String get vacEmptyDescription =>
      'Programa las vacinas para mantener la salud del lote';

  @override
  String get vacScheduleVaccination => 'Programar Vacinação';

  @override
  String get vacNoResults => 'Sin resultados';

  @override
  String get vacNoFilterResults =>
      'No se encontraron vacinações con los filtros aplicados';

  @override
  String get vacSchedule => 'Programar';

  @override
  String get vacScheduleTooltip => 'Programar nova vacinação';

  @override
  String get vacNoFarmSelected => 'No hay granja selecioneda';

  @override
  String get vacNoFarmDescription =>
      'Selecione una granja desde el menú principal para ver las vacinações programadas.';

  @override
  String get vacGoHome => 'Ir ao início';

  @override
  String get vacFilterTitle => 'Filtrar vacinações';

  @override
  String get vacVaccinationStatus => 'Status de vacinação';

  @override
  String get vacAllStatuses => 'Todos os estados';

  @override
  String get vacDeleteTitle => 'Excluir vacinação?';

  @override
  String get vacDeleted => 'Vacinação eliminada correctamente';

  @override
  String get vacMarkAppliedTitle => 'Mark as Aplicado';

  @override
  String get vacApplicationDetails => 'Registra los detalhes de la aplicación';

  @override
  String get vacAgeWeeksRequired => 'Age (semanas) *';

  @override
  String get vacAgeRequired => 'La edad es obrigatória';

  @override
  String get vacAgeInvalid => 'A idade deve ser um número maior que 0';

  @override
  String get vacDosisRequired => 'Dose *';

  @override
  String get vacDosisValidation => 'La dose es obrigatória';

  @override
  String get vacRouteRequired => 'Via de aplicação *';

  @override
  String get vacRouteValidation => 'La vía es obrigatória';

  @override
  String get vacMarkedApplied => 'Vacina marcada como aplicada';

  @override
  String get vacSheetApplied => 'Aplicada';

  @override
  String get vacSheetExpired => 'Vencida';

  @override
  String get vacSheetUpcoming => 'Próxima';

  @override
  String get vacSheetPending => 'Pendentes';

  @override
  String get vacVaccine => 'Vacina';

  @override
  String get vacScheduledDate => 'Data programada';

  @override
  String get vacApplicationDate => 'Data aplicación';

  @override
  String get vacAgeApplication => 'Idade de aplicação';

  @override
  String get vacWeeks => 'semanas';

  @override
  String get vacDosis => 'Dose';

  @override
  String get vacRoute => 'Vía';

  @override
  String get vacLaboratory => 'Laboratorio';

  @override
  String get vacVaccineBatch => 'Lote vacina';

  @override
  String get vacResponsible => 'Responsable';

  @override
  String get vacNextApplication => 'Próxima aplicação';

  @override
  String get vacScheduledBy => 'Programado by';

  @override
  String get vacMarkAppliedButton => 'Mark Aplicado';

  @override
  String get vacDeleteButton => 'Excluir';

  @override
  String get vacDetailTitle => 'Detalhe de Vacinação';

  @override
  String get vacDetailNotFound => 'Vacinação no encontrada';

  @override
  String get vacDetailLoadError => 'No pudimos carregar la vacinação';

  @override
  String get vacDetailStatusApplied => 'Aplicada';

  @override
  String get vacDetailStatusExpired => 'Vencida';

  @override
  String get vacDetailStatusUpcoming => 'Próxima';

  @override
  String get vacDetailStatusPending => 'Pendentes';

  @override
  String get vacDetailVaccineInfo => 'Informações de la Vacina';

  @override
  String get vacDetailScheduledDate => 'Data Programada';

  @override
  String get vacDetailAgeApplication => 'Edad Aplicação';

  @override
  String get vacDetailVaccineBatch => 'Lote Vacina';

  @override
  String get vacDetailNextApplication => 'Próxima Aplicação';

  @override
  String get vacDetailMarkAppliedButton => 'Mark as Aplicado';

  @override
  String get vacDetailSelectDate => 'Selecione la data de aplicación';

  @override
  String get vacDetailMarkedApplied => 'Vacinação marcada como aplicada';

  @override
  String get vacDetailMarkError => 'Erro al marcar vacinação';

  @override
  String get vacDetailDeleteTitle => 'Excluir vacinação?';

  @override
  String get vacDetailDeleted => 'Vacinação eliminada';

  @override
  String get vacDetailDeleteError => 'Erro al excluir vacinação';

  @override
  String get vacDetailMenuMarkApplied => 'Mark Aplicado';

  @override
  String get vacDetailMenuDelete => 'Excluir';

  @override
  String get treatFormStepLocation => 'Localização';

  @override
  String get treatFormStepLocationDesc => 'Selecione granja y lote';

  @override
  String get treatFormStepDiagnosis => 'Diagnóstico';

  @override
  String get treatFormStepDiagnosisDesc =>
      'Informações del diagnóstico y sintomas';

  @override
  String get treatFormStepTreatment => 'Tratamento';

  @override
  String get treatFormStepTreatmentDesc =>
      'Detalhes del tratamento y medicamentos';

  @override
  String get treatFormStepInfo => 'Informações';

  @override
  String get treatFormStepInfoDesc => 'Veterinário y observações adicionales';

  @override
  String get treatDraftFoundMessage =>
      'Deseja restaurar o rascunho do tratamento salvo anteriormente?';

  @override
  String get treatSavedMomentAgo => 'Salvard a moment ago';

  @override
  String get treatExit => 'Sair';

  @override
  String get treatNewTitle => 'Novo Tratamento';

  @override
  String get treatSelectFarmBatch => 'Por favor selecione una granja y un lote';

  @override
  String get treatDurationRange => 'La duração debe ser entre 1 y 365 dias';

  @override
  String get treatFutureDate => 'La data no puede ser futura';

  @override
  String get treatCompleteRequired =>
      'Por favor completa los campos obrigatórios';

  @override
  String get treatRegisteredSuccess => 'Tratamento registrado com sucesso';

  @override
  String get treatRegisteredInventoryError =>
      'Tratamento registrado, pero hubo un erro al atualizar inventário';

  @override
  String get treatRegisterError => 'Erro al registrar tratamento';

  @override
  String get vacFormStepVaccine => 'Vacina';

  @override
  String get vacFormStepApplication => 'Aplicação';

  @override
  String get vacFormTitle => 'Programar Vacinação';

  @override
  String get vacFormSubmit => 'Programar Vacinação';

  @override
  String get vacFormDraftFound => 'Rascunho encontrado';

  @override
  String get vacFormSelectBatch => 'Você deve selecionar um lote';

  @override
  String get vacFormSuccess => 'Vacinação programada com sucesso!';

  @override
  String get vacFormInventoryError =>
      'Vacinação registrada, pero hubo un erro al descontar inventário';

  @override
  String get vacFormError => 'Erro al programar vacinação';

  @override
  String get vacFormScheduleError => 'Erro al programar';

  @override
  String get diseaseCatalogTitle => 'Catálogo de Doenças';

  @override
  String get diseaseCatalogSearchHint => 'Buscar doença, sintoma...';

  @override
  String get diseaseCatalogAll => 'Todos';

  @override
  String get diseaseCatalogCritical => 'Crítica';

  @override
  String get diseaseCatalogSevere => 'Grave';

  @override
  String get diseaseCatalogModerate => 'Moderada';

  @override
  String get diseaseCatalogMild => 'Leve';

  @override
  String get diseaseCatalogMandatoryNotification => 'Notificação obrigatória';

  @override
  String get diseaseCatalogVaccinable => 'Vacinable';

  @override
  String get diseaseCatalogCategory => 'Categoria';

  @override
  String get diseaseCatalogSymptoms => 'Sintomas';

  @override
  String get diseaseCatalogSeverity => 'Gravedad';

  @override
  String get diseaseCatalogViewDetails => 'Ver Detalhes';

  @override
  String get diseaseCatalogNoResults => 'No se encontraron doençaes';

  @override
  String get diseaseCatalogEmpty => 'Catálogo vacío';

  @override
  String get diseaseCatalogTryOther =>
      'Intenta con outros términos de búsqueda o filtros';

  @override
  String get diseaseCatalogNoneRegistered => 'No hay doençaes registradas';

  @override
  String get diseaseCatalogClearFilters => 'Limpar filtros';

  @override
  String get bioOverviewTitle => 'Biossegurança';

  @override
  String get bioNewInspection => 'Nova Inspección';

  @override
  String get bioNewInspectionTooltip => 'Criar nova inspección';

  @override
  String get bioEmptyTitle => 'No inspections registrared yet';

  @override
  String get bioMetricInspections => 'Inspecciones';

  @override
  String get bioMetricAverage => 'Promédio';

  @override
  String get bioMetricCritical => 'Críticas';

  @override
  String get bioMetricLastLevel => 'Último nivel';

  @override
  String get bioRecentHistory => 'Historial reciente';

  @override
  String get bioGeneralInspection => 'Inspección geral';

  @override
  String get bioShedInspection => 'Inspección por galpão';

  @override
  String get bioScore => 'Puntaje';

  @override
  String get bioNonCompliant => 'Não conforme';

  @override
  String get bioPending => 'Pendentes';

  @override
  String get bioLoadError => 'No se pudo carregar biossegurança';

  @override
  String get bioNoInspectionYet => 'No inspection concluído yet.';

  @override
  String get bioLastInspection => 'Última inspeção:';

  @override
  String get bioInspectionTitle => 'Inspección de Biossegurança';

  @override
  String get bioInspectionNewTitle => 'Nova Inspección';

  @override
  String get bioInspectionStepLocation => 'Localização';

  @override
  String get bioInspectionStepChecklist => 'Checklist';

  @override
  String get bioInspectionStepSummary => 'Resumo';

  @override
  String get bioInspectionSave => 'Salvar Inspección';

  @override
  String get bioInspectionLoadError => 'Erro al carregar datos';

  @override
  String get bioInspectionExitTitle => 'Sair sem completar?';

  @override
  String get bioInspectionExitMessage =>
      'Você tem uma inspeção em andamento. Se sair agora, perderá as alterações.';

  @override
  String get bioInspectionSaveMessage =>
      'Se salvará la inspección y se generará el relatório correspondiente.';

  @override
  String get bioInspectionSaveSuccess => 'Inspección guardada com sucesso';

  @override
  String get bioInspectionLoadingFarm => 'Carregando granja…';

  @override
  String get bioInspectionMinProgress =>
      'Evalúa al menos el 50% de los itens para continuar';

  @override
  String get saludSummaryTitle => 'Resumo de Salud';

  @override
  String get saludAllUnderControl => 'Todo baixo control';

  @override
  String get saludHealthStatus => 'Status sanitario';

  @override
  String get saludActive => 'Ativo';

  @override
  String get saludClosedCount => 'Fechard';

  @override
  String get saludCardActive => 'Ativo';

  @override
  String get saludCardClosed => 'Fechard';

  @override
  String get saludCardDiagnosisPrefix => 'Diagnóstico: ';

  @override
  String get saludCardTreatmentPrefix => 'Tratamento: ';

  @override
  String get saludErrorTitle => 'Erro al carregar registros';

  @override
  String get vacSummaryTitle => 'Resumo de Vacinação';

  @override
  String get vacSummaryExpiredWarning => 'Atenção! Há vacinas vencidas';

  @override
  String get vacSummaryUpcomingWarning => 'Hay vacinas próximas a aplicar';

  @override
  String get vacSummaryUpToDate => 'Vacinações al día';

  @override
  String get vacSummaryAllApplied => 'Todas las vacinas aplicadas';

  @override
  String get vacSummaryApplied => 'Aplicada';

  @override
  String get vacCardStatusApplied => 'Aplicada';

  @override
  String get vacCardStatusExpired => 'Vencida';

  @override
  String get vacCardStatusUpcoming => 'Próxima';

  @override
  String get vacCardStatusPending => 'Pendentes';

  @override
  String get vacCardVaccinePrefix => 'Vacina: ';

  @override
  String get vacCardDosisPrefix => 'Dose: ';

  @override
  String get vacCardRoutePrefix => 'Vía: ';

  @override
  String get vacCardExpiredAgo => 'Vencido ago: ';

  @override
  String get vacCardDaysLeft => 'Faltan: ';

  @override
  String get vacErrorTitle => 'Erro al carregar vacinações';

  @override
  String get vacStepVaccineInfoTitle => 'Informações de la Vacina';

  @override
  String get vacStepVaccineInfoDesc =>
      'Insira los datos de la vacina a programar';

  @override
  String get vacStepBatchRequired => 'Lote *';

  @override
  String get vacStepSelectBatch => 'Selecione un lote';

  @override
  String get vacStepSelectFromInventory => 'Selecionar del inventário';

  @override
  String get vacStepSelectVaccineInventory => 'Selecionar vacina do inventário';

  @override
  String get vacStepOptionalSelectVaccine =>
      'Opcional - Selecione una vacina registrada';

  @override
  String get vacStepInventoryNote =>
      'Si seleciones del inventário, el estoque se descontará automáticamente.';

  @override
  String get vacStepVaccineName => 'Nome da vacina';

  @override
  String get vacStepVaccineNameHint => 'Ex: Newcastle + Bronquite';

  @override
  String get vacStepVaccineNameRequired => 'Insira el nome de la vacina';

  @override
  String get vacStepVaccineNameMinLength =>
      'El nome debe tener al menos 3 caracteres';

  @override
  String get vacStepVaccineBatch => 'Lote da vacina (opcional)';

  @override
  String get vacStepVaccineBatchHint => 'Ex: LOT123456';

  @override
  String get vacStepScheduledDate => 'Data programada *';

  @override
  String get vacStepTipTitle => 'Consejo';

  @override
  String get vacStepTipMessage =>
      'Programa las vacinações con anticipación para mantener el calendario sanitario al día.';

  @override
  String get vacStepAppObsTitle => 'Aplicação y Observações';

  @override
  String get vacStepAppObsDesc =>
      'Registre quando foi aplicada e adicione observações';

  @override
  String get vacStepAppDateOptional => 'Data de aplicación (opcional)';

  @override
  String get vacStepSelectDate => 'Selecionar data';

  @override
  String get vacStepRemoveDate => 'Quitar data';

  @override
  String get vacStepObservationsOptional => 'Observações (opcional)';

  @override
  String get vacStepObservationsHint =>
      'Reações observadas, notas especiais, etc.';

  @override
  String get vacStepVaccineApplied => 'Vacina aplicada';

  @override
  String get vacStepAppliedNote =>
      'La vacinação quedará registrada como aplicada.';

  @override
  String get vacStepScheduled => 'Vacinação programada';

  @override
  String get vacStepScheduledNote =>
      'It will remain pendente. You can mark it as aplicado later.';

  @override
  String get vacStepCalendarReminder =>
      'Las vacinações programadas aparecerán en tu calendario y recibirás lembretes.';

  @override
  String get treatStepDiagTitle => 'Diagnóstico y Sintomas';

  @override
  String get treatStepDiagDesc =>
      'Registra el diagnóstico y los sintomas observados en las aves';

  @override
  String get treatStepDiagImportant => 'Informação importante';

  @override
  String get treatStepDiagImportantMsg =>
      'Un diagnóstico preciso permite selecionar el tratamento más efectivo y prevenir la propagación.';

  @override
  String get treatStepDateRequired => 'Data del tratamento *';

  @override
  String get treatStepDiagnosis => 'Diagnóstico';

  @override
  String get treatStepDiagnosisHint => 'Ex: Doença respiratoria crónica';

  @override
  String get treatStepDiagRequired => 'El diagnóstico es obrigatório';

  @override
  String get treatStepDiagMinLength => 'Deve ter pelo menos 5 caracteres';

  @override
  String get treatStepSymptoms => 'Sintomas observados';

  @override
  String get treatStepSymptomsHint =>
      'Descreva os sintomas: tosse, espirros, prostração...';

  @override
  String get treatStepDetailsTitle => 'Detalhes del Tratamento';

  @override
  String get treatStepDetailsDesc =>
      'Descreva el tratamento aplicado y los medicamentos';

  @override
  String get treatStepDetailsImportant => 'Informação importante';

  @override
  String get treatStepDetailsImportantMsg =>
      'Si seleciones un medicamento del inventário, el estoque se descontará automáticamente al salvar.';

  @override
  String get treatStepTreatmentDesc => 'Descrição do tratamento';

  @override
  String get treatStepTreatmentHint =>
      'Descreva el pquebradocolo de tratamento aplicado';

  @override
  String get treatStepTreatmentRequired => 'El tratamento es obrigatório';

  @override
  String get treatStepTreatmentMinLength => 'Deve ter pelo menos 5 caracteres';

  @override
  String get treatStepInventoryMed => 'Medicamento del inventário (opcional)';

  @override
  String get treatStepSelectMed => 'Selecionar medicamento del inventário...';

  @override
  String get treatStepAutoDeduct =>
      'Se descontará automáticamente del inventário';

  @override
  String get treatStepMedicationsAdditional => 'Medicamentos adicionais';

  @override
  String get treatStepMedications => 'Medicamentos';

  @override
  String get treatStepMedicationsHint =>
      'Ex: Enrofloxacina + Vitaminas A, D, E';

  @override
  String get treatStepDosis => 'Dose';

  @override
  String get treatStepDosisHint => 'Ex: 1ml/L';

  @override
  String get treatStepDuration => 'Duração (dias)';

  @override
  String get treatStepDurationHint => 'Ex: 5';

  @override
  String get treatStepDurationMin => 'Debe ser > 0';

  @override
  String get treatStepDurationMax => 'Máximo 365';

  @override
  String get treatStepSelectLocationTitle => 'Selecionar Localização';

  @override
  String get treatStepSelectBatchTitle => 'Selecionar Lote';

  @override
  String get treatStepSelectLocationDesc =>
      'Selecione la granja y el lote para registrar el tratamento';

  @override
  String get treatStepSelectBatchDesc =>
      'Selecione el lote para registrar el tratamento';

  @override
  String get treatStepSelectBatchSubDesc =>
      'Selecione el lote donde se aplicará el tratamento';

  @override
  String get treatStepNoFarms => 'You have no registrared granjas';

  @override
  String get treatStepNoFarmsDesc =>
      'Debes criar una granja antes de registrar un tratamento';

  @override
  String get treatStepFarmsError => 'Erro al carregar granjas';

  @override
  String get treatStepFarmRequired => 'Granja *';

  @override
  String get treatStepSelectFarm => 'Selecione uma granja';

  @override
  String get treatStepFarmValidation => 'Por favor selecione una granja';

  @override
  String get treatStepBatchRequired => 'Lote *';

  @override
  String get treatStepSelectBatch => 'Selecione un lote';

  @override
  String get treatStepBatchValidation => 'Por favor selecione un lote';

  @override
  String get treatStepNoActiveBatches => 'Sem lotes ativos';

  @override
  String get treatStepNoActiveBatchesDesc =>
      'Esta granja no tiene lotes ativos para registrar tratamentos';

  @override
  String get treatStepBatchesError => 'Erro al carregar lotes';

  @override
  String get treatStepAdditionalTitle => 'Informações Adicionais';

  @override
  String get treatStepAdditionalDesc => 'Datos complementarios del tratamento';

  @override
  String get treatStepAdditionalImportant => 'Informação importante';

  @override
  String get treatStepAdditionalImportantMsg =>
      'Estes campos são opcionais, mas ajudam em um melhor acompanhamento do tratamento.';

  @override
  String get treatStepVeterinarian => 'Veterinário responsável';

  @override
  String get treatStepVetName => 'Nome do veterinário';

  @override
  String get treatStepGeneralObs => 'Observações gerais';

  @override
  String get treatStepGeneralObsHint =>
      'Notas adicionais, evolução esperada, etc.';

  @override
  String get bioStepLocationTitle => 'Onde será realizada a inspeção?';

  @override
  String get bioStepLocationDesc =>
      'Selecione el galpão o deja en blanco para una inspección geral.';

  @override
  String get bioStepInspector => 'Inspector';

  @override
  String get bioStepDate => 'Data';

  @override
  String get bioStepShed => 'Galpão';

  @override
  String get bioStepShedOptional =>
      'Opcional — si no seleciones, la inspección aplica a toda la granja.';

  @override
  String get bioStepLoadingFarm => 'Carregando granja…';

  @override
  String get bioStepNoSheds =>
      'No hay galpões registrados. Se realizará inspección geral.';

  @override
  String get bioStepWholeFarm => 'Whole granja';

  @override
  String get bioChecklistCritical => 'Crítico';

  @override
  String get bioChecklistTapToEvaluate => 'Toque para avaliar';

  @override
  String get bioChecklistCompliant => 'Conforme';

  @override
  String get bioChecklistNonCompliant => 'Não conforme';

  @override
  String get bioChecklistPartial => 'Parcial';

  @override
  String get bioChecklistNotApplicable => 'Não se aplica';

  @override
  String get bioChecklistPending => 'Pendentes';

  @override
  String get bioChecklistSelectResult =>
      'Selecione el resultado de la evaluación';

  @override
  String get bioChecklistObservation => 'Observação';

  @override
  String get bioChecklistObservationHint => 'Escreva uma observação (opcional)';

  @override
  String get bioSummaryTitle => 'Resumo de la inspección';

  @override
  String get bioSummarySubtitle => 'Revisa los resultados antes de salvar.';

  @override
  String get bioSummaryCumple => 'Conforme';

  @override
  String get bioSummaryParcial => 'Parcial';

  @override
  String get bioSummaryNoCumple => 'Não conforme';

  @override
  String get bioSummaryCriticalItems => 'Itens críticos não cumpridos';

  @override
  String get bioSummaryPendingNote =>
      'Você pode salvar, mas a pontuação só reflete o que foi avaliado.';

  @override
  String get bioSummaryGeneralObs => 'Observações gerais';

  @override
  String get bioSummaryGeneralObsHint =>
      'Descreva hallazgos gerales de la inspección…';

  @override
  String get bioSummaryCorrectiveActions => 'Ações corretivas';

  @override
  String get bioSummaryCorrectiveHint => 'Descreva as ações a implementar…';

  @override
  String get bioSummaryRecommended => 'Recomendado';

  @override
  String get bioSummaryNote =>
      'Al salvar se generará un relatório descargable y el historial quedará registrado.';

  @override
  String get bioRatingExcellent => 'Excelente';

  @override
  String get bioRatingVeryGood => 'Muito Bom';

  @override
  String get bioRatingGood => 'Bom';

  @override
  String get bioRatingAcceptable => 'Aceitarable';

  @override
  String get bioRatingRegular => 'Regular';

  @override
  String get bioRatingPoor => 'Deficiente';

  @override
  String get saludDialogCancel => 'Cancelar';

  @override
  String get saludDialogDelete => 'Excluir';

  @override
  String get saludDialogContinue => 'Continuar';

  @override
  String get saludDialogConfirm => 'Confirmar';

  @override
  String get saludDialogAccept => 'Aceitar';

  @override
  String get saludDialogProcessing => 'Processando...';

  @override
  String get saludSwipeClose => 'Fechar';

  @override
  String get saludSwipeApply => 'Aplicar';

  @override
  String get saludSwipeDelete => 'Excluir';

  @override
  String ventaDeleteMessage(Object product) {
    return 'A venda de $product será excluída. Esta ação não pode ser desfeita.';
  }

  @override
  String ventaDeleteError(Object message) {
    return 'Erro al excluir: $message';
  }

  @override
  String ventaDetailsOf(Object product) {
    return 'Detalhes de $product';
  }

  @override
  String ventaLotLoadError(Object error) {
    return 'Erro al carregar lotes: $error';
  }

  @override
  String costoDeleteError2(Object error) {
    return 'Erro al excluir: $error';
  }

  @override
  String costoApproveError(Object error) {
    return 'Erro al aprobar: $error';
  }

  @override
  String costoRejectError(Object error) {
    return 'Erro al rejeitar: $error';
  }

  @override
  String saludDeleteRecordMessage(String diagnosis) {
    return 'O registro \"$diagnosis\" será excluído. Esta ação não pode ser desfeita.';
  }

  @override
  String saludActiveTreatments(Object count) {
    return '$count tratamento(s) ativo(s)';
  }

  @override
  String saludCardDays(Object count) {
    return '$count dias';
  }

  @override
  String bioEmptyDescription(Object farmName) {
    return 'Inicie a primeira inspeção de biossegurança para $farmName e mantenha um registro contínuo do cumprimento sanitário.';
  }

  @override
  String bioChecklistProgress(String evaluated, Object total) {
    return '$evaluated de $total avaliados';
  }

  @override
  String bioSummaryRisk(Object evaluated, Object level, Object total) {
    return 'Risco $level · $evaluated de $total avaliados';
  }

  @override
  String bioSummaryPendingItems(Object count) {
    return '$count itens pendientes';
  }

  @override
  String vacSummaryExpiredBadge(Object count) {
    return '$count vencido';
  }

  @override
  String vacSummaryUpcomingBadge(Object count) {
    return '$count próxima(s)';
  }

  @override
  String vacCardAppliedDate(Object date) {
    return 'Aplicado: $date';
  }

  @override
  String vacCardDays(Object count) {
    return '$count dias';
  }

  @override
  String vacDetailScheduled(Object date) {
    return 'Programado: $date';
  }

  @override
  String vacDetailAppliedOn(Object date) {
    return 'Aplicado on $date';
  }

  @override
  String vacFormDraftMessage(Object date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String treatSavedMinAgo(Object count) {
    return 'Salvard $count min ago';
  }

  @override
  String treatSavedAtTime(Object time) {
    return 'Salvard at $time';
  }

  @override
  String get monthMayFull => 'Maio';

  @override
  String get commonDiscard2 => 'Descartar';

  @override
  String get ventaClientBuyerInfo => 'Insira la informações del comprador';

  @override
  String get ventaClientNameLabel => 'Nome completo';

  @override
  String get ventaClientPhoneHint => '9 dígitos';

  @override
  String get ventaClientDniLength => 'El CPF debe tener 8 dígitos';

  @override
  String get ventaClientRucLength => 'El CNPJ debe tener 11 dígitos';

  @override
  String get ventaClientDocInvalid => 'Número inválido';

  @override
  String get ventaClientPhoneLength => 'El telefone debe tener 9 dígitos';

  @override
  String get ventaClientForeignCard => 'RNE';

  @override
  String get ventaSelectLocationDesc =>
      'Selecione la granja y el lote para registrar la venda';

  @override
  String get ventaNoFarmsDesc =>
      'Debes criar una granja antes de registrar una venda';

  @override
  String get ventaErrorLoadingFarms => 'Erro al carregar granjas';

  @override
  String get ventaSelectFarmError => 'Por favor selecione una granja';

  @override
  String get ventaLoteLabelStar => 'Lote *';

  @override
  String get ventaSelectLoteHint => 'Selecione un lote';

  @override
  String get ventaSelectLoteError => 'Por favor selecione un lote';

  @override
  String get ventaNoActiveLotes => 'Sem lotes ativos';

  @override
  String get ventaNoActiveLotesDesc =>
      'Esta granja no tiene lotes ativos para registrar vendas';

  @override
  String get ventaErrorLoadingLotes => 'Erro al carregar lotes';

  @override
  String get ventaFilterAllTypes => 'Todos os tipos';

  @override
  String get ventaFilterApply => 'Aplicar filtros';

  @override
  String get ventaFilterClose => 'Fechar';

  @override
  String get ventaSheetObservations => 'Observações';

  @override
  String get ventaSheetRegistrationDate => 'Data de registro';

  @override
  String get ventaDetailLocation => 'Localização';

  @override
  String get ventaDetailGranja => 'Granja';

  @override
  String get ventaDetailLote => 'Lote';

  @override
  String get ventaDetailPhone => 'Telefone';

  @override
  String get ventaDetailInfoRegistro => 'Informações de Registro';

  @override
  String get ventaDetailRegisteredBy => 'Registrado por';

  @override
  String get ventaDetailRole => 'Função';

  @override
  String get ventaDetailRegistrationDate => 'Data de registro';

  @override
  String get ventaDetailError => 'Erro';

  @override
  String get ventaDetailMoreOptions => 'Mais opções';

  @override
  String ventaSavedAgo(Object time) {
    return 'Salvard $time';
  }

  @override
  String ventaShareDate(Object date) {
    return '📅 Data: $date';
  }

  @override
  String ventaShareType(Object type) {
    return '🏷️ Tipo: $type';
  }

  @override
  String ventaShareQuantityBirds(Object count) {
    return '📦 Quantidade: $count aves';
  }

  @override
  String ventaSharePrice(String currency, String price) {
    return '💵 Preço: $currency $price/kg';
  }

  @override
  String ventaShareEggs(Object count) {
    return '📦 Ovos: $count unidadees';
  }

  @override
  String ventaShareQuantityPollinaza(Object count, Object unit) {
    return '📦 Quantidade: $count $unit';
  }

  @override
  String ventaShareTotal(Object currency, Object total) {
    return '💰 TOTAL: $currency $total';
  }

  @override
  String ventaShareClient(Object name) {
    return '👤 Cliente: $name';
  }

  @override
  String ventaShareContact(String contact) {
    return '📞 Contacto: $contact';
  }

  @override
  String ventaShareStatus(Object status) {
    return '📍 Status: $status';
  }

  @override
  String get ventaShareAppName => 'Smart Granja Aves Pro';

  @override
  String ventaShareSubject(Object type) {
    return 'Venda - $type';
  }

  @override
  String ventaDateOfLabel(String month, String year, Object day, Object time) {
    return '$day de $month $year • $time';
  }

  @override
  String get bioStepGalpon => 'Galpão';

  @override
  String get bioStepGalponHint => 'Selecione el galpão a inspeccionar';

  @override
  String get bioStepNoGalpones => 'No hay galpões registrados en esta granja';

  @override
  String get bioStepSelectLocationHint =>
      'Selecione la localização para la inspección de biossegurança';

  @override
  String get bioTitle => 'Biossegurança';

  @override
  String get invCodeOptional => 'Código / SKU (opcional)';

  @override
  String get invCurrentStock => 'Estoque actual';

  @override
  String get invDescHerramienta => 'Tools, drinkers, raçãoers and equipment';

  @override
  String get invDescribeItem => 'Descreva brevemente el item';

  @override
  String get invInternalCode => 'Internal código or SKU';

  @override
  String get invItemNameRequired => 'Nome del item *';

  @override
  String get invLocationWarehouse => 'Localização / Almacén';

  @override
  String get invMaximumStock => 'Estoque máximo';

  @override
  String get invMinimumStock => 'Estoque mínimo';

  @override
  String get invNameRequired => 'El nome debe tener al menos 2 caracteres';

  @override
  String get invStepStockTitle => 'Estoque y Unidadees';

  @override
  String get invStockAlertDescription =>
      'Configure o estoque mínimo para receber alertas quando o inventário estiver baixo.';

  @override
  String get invSupplierBatchNumber => 'Número de lote del fornecedor';

  @override
  String get invSupplierNameLabel => 'Nome del fornecedor';

  @override
  String get invWarehouseExample => 'Ex: Depósito principal, Galpão 1';

  @override
  String get ventaAverageWeight => 'Peso médio';

  @override
  String get ventaBirdQuantity => 'Quantidade de aves';

  @override
  String get ventaCarcassYield => 'Rendimento canal';

  @override
  String get ventaClient => 'Cliente';

  @override
  String get ventaClientDocument => 'Número do documento *';

  @override
  String get ventaClientDocumentInvalid => 'Documento inválido';

  @override
  String get ventaClientDocumentRequired => 'Insira el número do documento';

  @override
  String get ventaDeletedSuccess => 'Venda eliminada correctamente';

  @override
  String get ventaDocument => 'Documento';

  @override
  String get ventaEditTooltip => 'Editar venda';

  @override
  String get ventaNewSaleTitle => 'Nova Venda';

  @override
  String get ventaNotFound => 'Venda no encontrada';

  @override
  String get ventaPhone => 'Telefone';

  @override
  String get ventaProductDescAbono =>
      'Abono orgánico derivado de la produção avícola';

  @override
  String get ventaProductDescAvesEnPie =>
      'Venda de aves vivas en pie por kilogramo';

  @override
  String get ventaProductDescAvesFaenadas =>
      'Processed aves ready for consumption';

  @override
  String get ventaProductDescHuevos =>
      'Venda de ovos por classificação y dúzia';

  @override
  String get ventaProductDescOtro =>
      'Aves de descarte u outros produtos avícolas';

  @override
  String get ventaProductDetails => 'Detalhes del produto';

  @override
  String get ventaQuantity => 'Quantidade';

  @override
  String get ventaReceiptTitle => 'COMPROVANTE DE VENDA';

  @override
  String get ventasFilterTitle => 'Filtrar vendas';

  @override
  String get ventaShare => 'Compartilhar';

  @override
  String get ventaSlaughterWeight => 'Slaughter peso';

  @override
  String get ventasProductType => 'Tipo de produto';

  @override
  String get ventaStepClientTitle => 'Dados do Cliente';

  @override
  String get ventaStepNoFarms => 'No hay granjas disponívels';

  @override
  String get ventaStepProductQuestion => 'Que tipo de produto você vende?';

  @override
  String get ventaStepSelectLocation => 'Selecione Granja y Lote';

  @override
  String get ventaStepSelectLocationDesc =>
      'Elige la granja y el lote asociado a esta venda';

  @override
  String get ventaStepSummary => 'Resumo';

  @override
  String get ventaSubtotal => 'Subtotal';

  @override
  String get ventaTotalLabel => 'Total';

  @override
  String get ventaUnitPrice => 'Preço unitario';

  @override
  String get ventasTitle => 'Vendas';

  @override
  String get ventasFilter => 'Filtrar vendas';

  @override
  String get ventasEmpty => 'No hay vendas';

  @override
  String get ventasEmptyDescription => 'No se encontraron vendas registradas.';

  @override
  String get ventasNewSale => 'Nova Venda';

  @override
  String get ventasNoResults => 'No hay resultados';

  @override
  String get ventasNoFilterResults =>
      'No se encontraron vendas con los filtros aplicados';

  @override
  String get ventasNewSaleTooltip => 'Registrar nova venda';

  @override
  String get bioInspectionSaveButton => 'Salvar Inspección';

  @override
  String get bioInspectionMinEvaluation => 'Avaliação mínima';

  @override
  String get ventaStepFarmRequired => 'Debe selecionar una granja';

  @override
  String get ventaStepSelectFarmFirst => 'Selecione uma granja primeiro';

  @override
  String get ventaStepNoActiveBatches => 'Sem lotes ativos';

  @override
  String get ventaStepBatchRequired => 'Você deve selecionar um lote';

  @override
  String get ventaStepSelectBatch => 'Selecionar lote';

  @override
  String get invExpirationDate => 'Data de expiración';

  @override
  String get ventaRegister => 'Registrar Venda';

  @override
  String get bioInspections => 'bioInspections';

  @override
  String get bioAverage => 'bioAverage';

  @override
  String get bioCritical => 'bioCritical';

  @override
  String get bioLastLevel => 'bioLastLevel';

  @override
  String get diseaseCatalogSearch => 'diseaseCatalogSearch';

  @override
  String get diseaseCatalogWarning => 'diseaseCatalogWarning';

  @override
  String get diseaseCatalogMonitor => 'diseaseCatalogMonitor';

  @override
  String get bioStepWholeGranja => 'bioStepWholeGranja';

  @override
  String vacDetailDeleteMessage(Object nombre) {
    return 'A vacinação \"$nombre\" será excluída. Esta ação não pode ser desfeita.';
  }

  @override
  String get commonDraftFound => 'Rascunho encontrado';

  @override
  String get commonDraftRestoreMessage =>
      'Deseja restaurar o rascunho salvo anteriormente?';

  @override
  String get costoTypeManoObra => 'Mão de Obra';

  @override
  String get costoUpdatedSuccess => 'Custo atualizado correctamente';

  @override
  String get costoRegisteredSuccess => 'Custo registrado correctamente';

  @override
  String get batchAvgWeight => 'Peso Promédio';

  @override
  String get batchFeedConsumption => 'Ração Consumption';

  @override
  String get batchFeedConversionICA => 'Conversão Alimenticia (ICA)';

  @override
  String get batchRegisterWeightTooltip => 'Registrar lote peso';

  @override
  String get batchOpenRegisterMenu => 'Open registrar menu';

  @override
  String get shedCapacityTotal => 'Capacidade Total';

  @override
  String get shedBirdsDensity => 'Aves/m²';

  @override
  String get shedMinCapacityHint => 'Ex: 1000';

  @override
  String get vacStepVaccine => 'Vacina';

  @override
  String get vacStepApplication => 'Aplicação';

  @override
  String get vacSelectLote => 'Você deve selecionar um lote';

  @override
  String get vacErrorScheduling => 'Erro al programar';

  @override
  String get vacScheduledSuccess => 'Vacinação programada com sucesso!';

  @override
  String get vacErrorSchedulingDetail => 'Erro al programar vacinação';

  @override
  String get vacCouldNotLoad => 'No pudimos carregar la vacinação';

  @override
  String get vacSelectAppDate => 'Selecione la data de aplicación';

  @override
  String get vacExitTooltip => 'Sair';

  @override
  String get vacProgramLabel => 'Programar';

  @override
  String get vacProgramNewTooltip => 'Programar nova vacinação';

  @override
  String get vacAgeWeeksLabel => 'Age (semanas) *';

  @override
  String get vacAgeHint => 'Ex: 4';

  @override
  String get vacDoseHint => 'Ex: 0.5 ml';

  @override
  String get vacRouteLabel => 'Via de aplicação *';

  @override
  String get vacRouteHint => 'Ex: Oral, subcutánea, ocular';

  @override
  String get vacDoseRequired => 'La dose es obrigatória';

  @override
  String get treatStepLocation => 'Localização';

  @override
  String get treatStepTreatment => 'Tratamento';

  @override
  String get treatStepInfo => 'Informações';

  @override
  String get treatDraftMessage =>
      'Deseja restaurar o rascunho do tratamento salvo anteriormente?';

  @override
  String get treatFillRequired => 'Por favor completa los campos obrigatórios';

  @override
  String get treatErrorRegistering => 'Erro al registrar tratamento';

  @override
  String get treatClosedSuccess => 'Tratamento cerrado';

  @override
  String get treatCloseError => 'Erro al fechar tratamento';

  @override
  String get saludDeleteTitle => 'Excluir registro?';

  @override
  String get saludDeletedSuccess => 'Record excluird';

  @override
  String get saludDeleteError => 'Erro al excluir registro';

  @override
  String get bioExitInProgress =>
      'Você tem uma inspeção em andamento. Se sair agora, perderá as alterações.';

  @override
  String get bioSavedSuccess => 'Inspección guardada com sucesso';

  @override
  String get ventaDraftMessage =>
      'Deseja restaurar o rascunho de venda salvo anteriormente?';

  @override
  String get ventaSelectBatch => 'Selecione un lote';

  @override
  String ventaQuantityUnit(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String ventaPricePerUnit(String currency, String unit) {
    return 'Preço por $unit ($currency)';
  }

  @override
  String get ventaSaleStatusTitle => 'Status da venda';

  @override
  String get ventaAllStatuses => 'Todos os estados';

  @override
  String get ventaPending => 'Pendentes';

  @override
  String get ventaConfirmed => 'Confirmared';

  @override
  String get ventaSold => 'Vendida';

  @override
  String get ventaSelectFarm => 'Selecione uma granja';

  @override
  String ventaDiscountLabel(String percent) {
    return 'Desconto ($percent%)';
  }

  @override
  String get consumoQuantityLabel => 'Quantidade';

  @override
  String get consumoTypeLabel => 'Tipo';

  @override
  String get consumoDateLabel => 'Data';

  @override
  String get consumoPerBirdLabel => 'Consumption per ave';

  @override
  String get consumoAccumulatedLabel => 'Consumo acumulado';

  @override
  String get consumoTotalCostLabel => 'Custo total';

  @override
  String get consumoCostPerBirdLabel => 'Custo por ave';

  @override
  String get consumoObservationsLabel => 'Observações';

  @override
  String get consumoObservationsOptional => 'Observações (opcional)';

  @override
  String get consumoRemoveSelection => 'Remove selecionarion';

  @override
  String invQuantityLabel(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String invNewStockLabel(String unit) {
    return 'Novo estoque ($unit)';
  }

  @override
  String get whatsappMsgSupport =>
      'Olá! Preciso de ajuda com o app Smart Granja Aves. ';

  @override
  String get whatsappMsgBug =>
      'Hello! I want to relatório a problem in the Smart Granja Aves app: ';

  @override
  String get whatsappMsgSuggest =>
      'Olá! Tenho uma sugestão para o app Smart Granja Aves: ';

  @override
  String get whatsappMsgCollab =>
      'Olá! Estou interessado em uma colaboração com Smart Granja Aves.';

  @override
  String get whatsappMsgPricing =>
      'Olá! Gostaria de conhecer os planos e preços do Smart Granja Aves. ';

  @override
  String get whatsappMsgGeneral =>
      'Hello! I have a question sobre Smart Granja Aves. ';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get salesWeightHint => 'Ex: 250';

  @override
  String get salesPricePerKgHint => 'Ex: 8.50';

  @override
  String get salesPollinazaQuantityHint => 'Ex: 10';

  @override
  String get salesPollinazaPriceHint => 'Ex: 25.00';

  @override
  String get salesPriceGreaterThanZero => 'El preço debe ser mayor a 0';

  @override
  String get salesMaxPrice => 'El preço máximo es 9,999,999.99';

  @override
  String get salesEnterPricePerKg => 'Insira el preço por kg';

  @override
  String get salesEnterPrice => 'Insira el preço';

  @override
  String get salesEggInstructions =>
      'Insira la quantidade y preço por dúzia para cada classificação';

  @override
  String get salesSaleUnit => 'Unidade de venda';

  @override
  String get salesNoEditPermission =>
      'Você não tem permissão para editar vendas nesta granja';

  @override
  String get salesNoCreatePermission =>
      'Você não tem permissão para registrar vendas nesta granja';

  @override
  String get salesSelectProductFirst => 'Selecione un tipo de produto primeiro';

  @override
  String get salesObservationsLabel => 'Observações';

  @override
  String get salesObservationsHint => 'Notas adicionais (opcional)';

  @override
  String get salesSelectBatchLabel => 'Lote *';

  @override
  String get salesSelectBatchHint => 'Selecione un lote';

  @override
  String get salesSelectBatchError => 'Selecione un lote';

  @override
  String salesHuevosName(String name) {
    return 'Ovos $name';
  }

  @override
  String salesSavedAgo(String time) {
    return 'Salvard $time';
  }

  @override
  String get ventaListProductType => 'Tipo de produto';

  @override
  String get ventaListStatus => 'Status';

  @override
  String get ventaListDocument => 'Documento';

  @override
  String get ventaListCarrier => 'Transportista';

  @override
  String get ventaListSubtotal => 'Subtotal';

  @override
  String get clientBuyerInfo => 'Insira la informações del comprador';

  @override
  String get clientDocType => 'Document tipo *';

  @override
  String get clientForeignCard => 'RNE';

  @override
  String get clientDocHint8 => '8 dígitos';

  @override
  String get clientDocHint11 => '11 dígitos';

  @override
  String get clientDocHintGeneral => 'Número do documento';

  @override
  String get clientPhoneHint => '9 dígitos';

  @override
  String get clientNameRequired => 'Insira el nome del cliente';

  @override
  String get clientNameMinLength => 'El nome debe tener al menos 3 caracteres';

  @override
  String get clientDocRequired => 'Insira el número do documento';

  @override
  String get clientDniError => 'El CPF debe tener 8 dígitos';

  @override
  String get clientRucError => 'El CNPJ debe tener 11 dígitos';

  @override
  String get clientDocInvalid => 'Número inválido';

  @override
  String get clientPhoneRequired => 'Insira el telefone de contacto';

  @override
  String get clientPhoneError => 'El telefone debe tener 9 dígitos';

  @override
  String get selectFarmCreateFirst =>
      'Debes criar una granja antes de registrar una venda';

  @override
  String get selectFarmLoadError => 'Erro al carregar granjas';

  @override
  String get selectFarmHint => 'Selecione uma granja';

  @override
  String get selectFarmNoActiveLots =>
      'Esta granja no tiene lotes ativos para registrar vendas';

  @override
  String get selectLotHint => 'Selecione un lote';

  @override
  String get selectLotLoadError => 'Erro al carregar lotes';

  @override
  String get selectProductHint =>
      'Selecione el tipo de produto para esta venda';

  @override
  String get ventaSheetFaenadoWeight => 'Dressed peso';

  @override
  String get ventaSheetTotalHuevos => 'Total ovos';

  @override
  String get ventaSheetPollinazaQty => 'Quantidade';

  @override
  String get ventaSheetUnitPrice => 'Preço unitario';

  @override
  String get ventaSheetPhone => 'Telefone';

  @override
  String ventaDiscountPercent(String percent) {
    return 'Desconto ($percent%)';
  }

  @override
  String ventaEmailSubject(String id) {
    return 'Venda - $id';
  }

  @override
  String ventaSaleOf(String product) {
    return 'Venda de $product';
  }

  @override
  String ventaSemantics(String product, String client, String status) {
    return 'Venda de $product, $client, status $status';
  }

  @override
  String ventaDetailsUds(String name, String count) {
    return '$name ($count unidades)';
  }

  @override
  String get ventaPerDozen => '/dúzia';

  @override
  String ventaEggClassifValue(String currency, String cantidad, String precio) {
    return '$cantidad unidades ($currency $precio/dz)';
  }

  @override
  String costoDeleteConfirm(String name) {
    return 'Tem certeza de que deseja excluir o custo \"$name\"?\n\nEsta ação não pode ser desfeita.';
  }

  @override
  String costoSemantics(String concept, String type, String amount) {
    return 'Custo $concept, tipo $type, monto $amount';
  }

  @override
  String get costoSheetExpenseType => 'Expense tipo';

  @override
  String get costoSheetConcept => 'Conceito';

  @override
  String get costoSheetProvider => 'Fornecedor';

  @override
  String get costoSheetInvoice => 'Nº Fatura';

  @override
  String get costoSheetRejectionReason => 'Motivo rejeição';

  @override
  String get costoSheetRegistrationDate => 'Data de registro';

  @override
  String get costoSheetObservations => 'Observações';

  @override
  String costoAutoFillConcept(String name) {
    return 'Compra de $name';
  }

  @override
  String get costoSavedMomentAgo => 'Salvard a moment ago';

  @override
  String costoSavedMinAgo(String min) {
    return 'Salvard $min min ago';
  }

  @override
  String costoSavedAtTime(String time) {
    return 'Salvard at $time';
  }

  @override
  String get costoSelectExpenseType => 'Por favor selecione un tipo de gasto';

  @override
  String get costoSelectFarm => 'Por favor selecione una granja';

  @override
  String get costoFieldRequired => 'Este campo es obrigatório';

  @override
  String get costoInvoiceHint => 'F001-00001234';

  @override
  String costoItemCreated(String name) {
    return 'Item \"$name\" criado!';
  }

  @override
  String get commonRejected => 'Rechazado';

  @override
  String get commonUser => 'Usuário';

  @override
  String get commonSelectDate => 'Selecionar data';

  @override
  String get commonBirds => 'aves';

  @override
  String get commonDays => 'dias';

  @override
  String commonSavedAgo(String time) {
    return 'Salvard $time';
  }

  @override
  String get commonUserNotAuth => 'Usuário not authenticated';

  @override
  String get commonFarmNotSpecified => 'Granja not specified';

  @override
  String get commonBatchNotSpecified => 'Lote not specified';

  @override
  String commonWeeksAgo(String weeks) {
    return 'Hace $weeks semana(s)';
  }

  @override
  String commonMonthsAgo(String months) {
    return 'Hace $months mês(es)';
  }

  @override
  String commonYearsAgo(String years) {
    return 'Hace $years ano(s)';
  }

  @override
  String commonTodayAtTime(String time) {
    return 'hoje a las $time';
  }

  @override
  String get commonRelativeYesterday => 'ontem';

  @override
  String commonRelativeDaysAgo(String days) {
    return 'hace $days dias';
  }

  @override
  String get commonAttention => 'Atenção';

  @override
  String get commonCriticalFem => 'Crítica';

  @override
  String currencyPrefix(String currency) {
    return '$currency ';
  }

  @override
  String currencyAmount(String currency, String amount) {
    return '$currency $amount';
  }

  @override
  String get galponStatCapacity => 'Capacidade Total';

  @override
  String get galponStatTotalBirds => 'Aves Totais';

  @override
  String get galponStatOccupancy => 'Ocupação';

  @override
  String get galponBirdDensity => 'Aves/m²';

  @override
  String get galponCapacityHint => 'Ex: 1000';

  @override
  String get galponAddTag => 'Adicionar etiqueta';

  @override
  String get galponSpecCapacityHint => 'Ex: 10000';

  @override
  String get galponSpecAreaHint => 'Ex: 500';

  @override
  String get galponSpecAreaUnit => 'm²';

  @override
  String get galponSpecDrinkersHint => 'Ex: 50';

  @override
  String get galponSpecFeedersHint => 'Ex: 50';

  @override
  String get galponSpecNestsHint => 'Ex: 100';

  @override
  String get galponEnvTempMinHint => 'Ex: 18';

  @override
  String get galponEnvTempMaxHint => 'Ex: 28';

  @override
  String get galponEnvHumMinHint => 'Ex: 50';

  @override
  String get galponEnvHumMaxHint => 'Ex: 70';

  @override
  String get galponEnvVentMinHint => 'Ex: 100';

  @override
  String get galponEnvVentMaxHint => 'Ex: 300';

  @override
  String get galponEnvVentUnit => 'm³/h';

  @override
  String get galponNA => 'N/A';

  @override
  String get galponAvicola => 'Galpão Avícola';

  @override
  String get granjaAvicola => 'Poultry Granja';

  @override
  String get granjaNoAddress => 'No endereço';

  @override
  String get granjaPppm => 'ppm';

  @override
  String get granjaRucHint => 'J-12345678-9';

  @override
  String get granjaEngorde => 'Engorde';

  @override
  String get granjaPonedora => 'Ponedora';

  @override
  String get granjaReproductor => 'Reprodutor';

  @override
  String get granjaAve => 'Ave';

  @override
  String get granjaActive => 'Ativo';

  @override
  String get granjaInactive => 'Inativo';

  @override
  String get granjaMaintenance => 'Manutenção';

  @override
  String get granjaStatusOperating => 'Operando normalmente';

  @override
  String get granjaStatusSuspended => 'Operações suspensas';

  @override
  String get granjaStatusMaintenance => 'En proceso de manutenção';

  @override
  String get granjaMonthAbbr1 => 'Jan';

  @override
  String get granjaMonthAbbr2 => 'Fev';

  @override
  String get granjaMonthAbbr3 => 'Mar';

  @override
  String get granjaMonthAbbr4 => 'Abr';

  @override
  String get granjaMonthAbbr5 => 'Mai';

  @override
  String get granjaMonthAbbr6 => 'Jun';

  @override
  String get granjaMonthAbbr7 => 'Jul';

  @override
  String get granjaMonthAbbr8 => 'Ago';

  @override
  String get granjaMonthAbbr9 => 'Set';

  @override
  String get granjaMonthAbbr10 => 'Out';

  @override
  String get granjaMonthAbbr11 => 'Nov';

  @override
  String get granjaMonthAbbr12 => 'Dez';

  @override
  String invNewStock(String unit) {
    return 'Novo estoque ($unit)';
  }

  @override
  String get invAdjustReasonHint => 'Ex: Inventário físico';

  @override
  String get invErrorEntryRegister => 'Erro al registrar entrada de inventário';

  @override
  String get invErrorExitRegister => 'Erro al registrar salida de inventário';

  @override
  String invExpiresInDays(String days) {
    return 'Vence en $days dias';
  }

  @override
  String invStockLowAlert(String min, String unit) {
    return 'Estoque baixo (mínimo: $min $unit)';
  }

  @override
  String invStockMinLabel(String min, String unit) {
    return 'Mínimo: $min $unit';
  }

  @override
  String invRelativeTodayAt(String time) {
    return 'hoje a las $time';
  }

  @override
  String get invRelativeYesterday => 'ontem';

  @override
  String invRelativeDaysAgo(String days) {
    return 'hace $days dias';
  }

  @override
  String get invRelativeNow => 'ahora mismo';

  @override
  String invRelativeSecsAgo(String secs) {
    return 'hace ${secs}s';
  }

  @override
  String invRelativeMinsAgo(String mins) {
    return 'hace ${mins}m';
  }

  @override
  String invRelativeHoursAgo(String hours) {
    return 'hace ${hours}h';
  }

  @override
  String invItemCreated(String name) {
    return 'Item \"$name\" criado!';
  }

  @override
  String get invSkuHelper =>
      'El código/SKU te ajudará a identificar rápidamente el item en tu inventário.';

  @override
  String get invDetailsOptional => 'Informações opcional para mejor control';

  @override
  String get invTypeSelect => 'Selecione la categoría del item de inventário';

  @override
  String get invTypeVaccines => 'Vacinas y produtos de inmunización';

  @override
  String get invTypeDisinfectants => 'Produtos de limpieza y desinfecção';

  @override
  String get invUnitApplication => 'Aplicação';

  @override
  String get invUnitVolume => 'Volumen';

  @override
  String loteDaysAge(String age) {
    return '$age dias';
  }

  @override
  String loteWeeksAndDays(String weeks, String days) {
    return '$weeks semanas ($days dias)';
  }

  @override
  String loteBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String loteUnitsCount(String count) {
    return '$count unidadees';
  }

  @override
  String loteCycleDay(String day, String remaining) {
    return 'Día $day de 45 ($remaining dias rprateleiras)';
  }

  @override
  String get loteCycleCompleted => 'Day 45 - Cycle concluído';

  @override
  String loteCycleExtra(String day, String extra) {
    return 'Día $day ($extra dias extra)';
  }

  @override
  String get loteFeedUnit => 'kg ração';

  @override
  String get loteFeedRef => '1.6 - 1.8';

  @override
  String loteCloseOverdue(String days) {
    return 'Cierre vencido hace $days dias';
  }

  @override
  String loteCloseUpcoming(String days) {
    return 'Cierre próximo en $days dias';
  }

  @override
  String loteICAHigh(String value) {
    return 'Índice de conversão alto ($value)';
  }

  @override
  String loteDaysCount(String days) {
    return '$days dias';
  }

  @override
  String get loteRazaLinea => 'Raza/Línea';

  @override
  String get loteDaysRemaining => 'Dias Rprateleiras';

  @override
  String get loteBirdsLabel => 'Aves';

  @override
  String get loteEnterValidQty => 'Insira una quantidade válida mayor a 0';

  @override
  String get loteSelectNewState => 'Selecionar novo status:';

  @override
  String loteConfirmStateChange(String state) {
    return 'Confirmar change to $state?';
  }

  @override
  String get loteStateWarning =>
      'Este status es permanente y no podrá revertirse. Los datos del lote se archivarán.';

  @override
  String get loteLocationCode => 'Código';

  @override
  String get loteLocationMaxCapacity => 'Capacidade Máxima';

  @override
  String get loteLocationCurrentOccupancy => 'Ocupação Actual';

  @override
  String get loteLocationCurrentBirds => 'Aves Atuais';

  @override
  String loteLocationBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String get loteLocationOccupancyLabel => 'Ocupação';

  @override
  String loteLocationOccupancyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get loteLocationBirdType => 'Tipo de Ave en Galpão';

  @override
  String loteLocationMaxCapacityInfo(String count) {
    return 'Capacidade máxima: $count aves';
  }

  @override
  String loteLocationAreaInfo(String area) {
    return 'Área: $area m²';
  }

  @override
  String get loteLocationErrorLoading => 'Erro al carregar galpões';

  @override
  String get loteLocationSharedSpace =>
      'El novo lote compartilhará el espacio disponível.';

  @override
  String get loteTypeLayer => 'Gallinas ponedoras para produção de ovos';

  @override
  String get loteTypeBroiler => 'Pollos de engorde para produção de carne';

  @override
  String get loteTypeHeavyBreeder => 'Aves reprodutoras pesadas para crías';

  @override
  String get loteTypeLightBreeder => 'Aves reprodutoras livianas para crías';

  @override
  String get loteTypeTurkey => 'Pavos para produção de carne';

  @override
  String get loteTypeDuck => 'Patos para produção de carne';

  @override
  String loteResumenAge(String age) {
    return '$age dias';
  }

  @override
  String loteResumenWeeks(String weeks, String days) {
    return '($weeks sem, $days dias)';
  }

  @override
  String loteConsumoStockInsufficient(String stock) {
    return 'Estoque insuficiente. Disponível: $stock kg';
  }

  @override
  String loteConsumoStockUsage(String percent) {
    return 'Usarás el $percent% del estoque disponível';
  }

  @override
  String loteConsumoRecommended(String days, String amount) {
    return 'Recomendado para $days dias: $amount';
  }

  @override
  String get loteConsumoImportantInfo => 'Informação importante';

  @override
  String get loteConsumoAutoCalc =>
      'Los custos y métricas se calculan automáticamente al registrar el consumo.';

  @override
  String get lotePesoEggHint =>
      'Descreva calidad de los ovos, color de cáscara, tamano, anomalías observadas...';

  @override
  String get lotePesoBirdsWeighed => 'Aves weighed';

  @override
  String lotePesoGainPerDay(String value) {
    return '$value g/día';
  }

  @override
  String get lotePesoCV => 'Coeficiente de variação';

  @override
  String get loteConsumoErrorLoading => 'Erro al carregar ração';

  @override
  String get loteLoteDetailEngorde => 'Aves criadas para produção de carne';

  @override
  String get loteLoteDetailPonedora => 'Aves criadas para produção de ovos';

  @override
  String get loteLoteDetailRepPesada => 'Aves reprodutoras de línea pesada';

  @override
  String get loteLoteDetailRepLiviana => 'Aves reprodutoras de línea liviana';

  @override
  String get loteAreaUnit => 'm²';

  @override
  String get saludDose => 'Dose';

  @override
  String saludDurationDays(String days) {
    return '$days dias';
  }

  @override
  String get saludRegistrationInfo => 'Informações de Registro';

  @override
  String get saludLastUpdate => 'Última atualização';

  @override
  String saludDeleteDetail(String name) {
    return 'O registro de \"$name\" será excluído. Esta ação não pode ser desfeita.';
  }

  @override
  String get saludUpcoming => 'Próxima';

  @override
  String get saludLocationSection => 'Localização';

  @override
  String get saludFarm => 'Granja';

  @override
  String get saludBatch => 'Lote';

  @override
  String get saludVaccineInfoSection => 'Informações de la Vacina';

  @override
  String get saludVaccine => 'Vacina';

  @override
  String get saludApplicationAge => 'Edad Aplicação';

  @override
  String get saludRoute => 'Vía';

  @override
  String get saludLaboratory => 'Laboratorio';

  @override
  String get saludVaccineBatch => 'Lote Vacina';

  @override
  String get saludResponsible => 'Responsable';

  @override
  String get saludNextApplication => 'Próxima Aplicação';

  @override
  String get saludProgramDescription =>
      'Programa las vacinas para mantener la salud del lote';

  @override
  String get saludVacDeleted => 'Vacinação eliminada correctamente';

  @override
  String get saludRegisterAppDetails =>
      'Registra los detalhes de la aplicación';

  @override
  String get saludCurrentUser => 'Current Usuário';

  @override
  String get saludVacTableVaccine => 'Vacina';

  @override
  String get saludVacTableAppDate => 'Data aplicación';

  @override
  String get saludVacTableAppAge => 'Idade de aplicação';

  @override
  String get saludVacTableNextApp => 'Próxima aplicação';

  @override
  String get saludTreatStepDescLocation => 'Selecione granja y lote';

  @override
  String get saludTreatStepDescDiagnosis =>
      'Informações del diagnóstico y sintomas';

  @override
  String get saludTreatStepDescTreatment =>
      'Detalhes del tratamento y medicamentos';

  @override
  String get saludTreatStepDescInfo => 'Veterinário y observações adicionales';

  @override
  String get saludTreatSavedMoment => 'Salvard a moment ago';

  @override
  String saludTreatSavedMin(String min) {
    return 'Salvard $min min ago';
  }

  @override
  String saludTreatSavedAt(String time) {
    return 'Salvard at $time';
  }

  @override
  String get saludTreatSelectFarmBatch =>
      'Por favor selecione una granja y un lote';

  @override
  String get saludTreatDurationRange =>
      'La duração debe ser entre 1 y 365 dias';

  @override
  String get saludTreatFutureDate => 'La data no puede ser futura';

  @override
  String get saludVacInventoryWarning =>
      'Vacinação registrada, pero hubo un erro al descontar inventário';

  @override
  String get saludBioErrorLoading => 'Erro al carregar datos';

  @override
  String get saludBioConfirmSave =>
      'Se salvará la inspección y se generará el relatório correspondiente.';

  @override
  String saludBioErrorSaving(String error) {
    return 'Erro al salvar: $error';
  }

  @override
  String get saludBioTitleGeneral => 'Inspección geral de biossegurança';

  @override
  String get saludBioTitleByGalpon => 'Inspección de biossegurança por galpão';

  @override
  String get saludBioNotReviewed => 'Aún no se ha revisado.';

  @override
  String get saludBioCompliant => 'Cumprimento correto.';

  @override
  String get saludBioNonCompliant => 'Não conformidade detectada.';

  @override
  String get saludBioWithObservations => 'Conforme con observações.';

  @override
  String get saludBioNotApplicable => 'No corresponde evaluar.';

  @override
  String get saludSwipeHint => 'Desliza para ações rápidas';

  @override
  String get saludCatalogMandatoryNotification => 'Notificação obrigatória';

  @override
  String get saludCatalogCategory => 'Categoria';

  @override
  String get saludCatalogNoResults => 'No se encontraron doençaes';

  @override
  String get saludCatalogEmpty => 'Catálogo vacío';

  @override
  String get saludCatalogSearchHint =>
      'Intenta con outros términos de búsqueda o filtros';

  @override
  String get saludCatalogGeneralInfo => 'Informações Geral';

  @override
  String get saludCatalogTransmission => 'Transmission and Diagnóstico';

  @override
  String get saludCatalogMainSymptoms => 'Sintomas Principales';

  @override
  String get saludCatalogPostmortem => 'Lesiones Post-mortem';

  @override
  String get saludCatalogTreatPrevention => 'Tratamento y Prevenção';

  @override
  String get saludCatalogPreventableVax => 'Prevenível por vacinação';

  @override
  String get saludCatalogCausativeAgent => 'Agente Causal';

  @override
  String get saludCatalogNotification => 'Notificação';

  @override
  String get saludCatalogTransmissionLabel => 'Transmisión';

  @override
  String get saludCatalogDiagnosisLabel => 'Diagnóstico';

  @override
  String saludVacDraftMessage(String date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String get saludVacProgramTitle => 'Programar Vacinação';

  @override
  String get whatsappHelp =>
      'Olá! Preciso de ajuda com o app Smart Granja Aves. ';

  @override
  String get whatsappReportBug =>
      'Hello! I want to relatório a problem in the Smart Granja Aves app: ';

  @override
  String get whatsappSuggestion =>
      'Olá! Tenho uma sugestão para o app Smart Granja Aves: ';

  @override
  String get whatsappCollaboration =>
      'Olá! Estou interessado em uma colaboração com Smart Granja Aves.';

  @override
  String get whatsappPricing =>
      'Olá! Gostaria de conhecer os planos e preços do Smart Granja Aves. ';

  @override
  String get whatsappQuery =>
      'Hello! I have a question sobre Smart Granja Aves. ';

  @override
  String get homeAppTitle => 'Smart Granja Aves';

  @override
  String get authProBadge => 'PRO';

  @override
  String get perfilLanguage => 'Espanol';

  @override
  String get perfilSyncing => 'Sincronizando';

  @override
  String get perfilAppTitle => 'Smart Granja Aves Pro';

  @override
  String reportsPeriod(String period) {
    return 'Período: $period';
  }

  @override
  String get reportsDateTo => 'al';

  @override
  String get reportsDateOf => 'de';

  @override
  String reportsFileName(String id) {
    return 'Relatório_$id.pdf';
  }

  @override
  String get statusPending => 'Pendentes';

  @override
  String get statusConfirmed => 'Confirmared';

  @override
  String get statusSold => 'Vendida';

  @override
  String get statusApproved => 'Aprovados';

  @override
  String get treatStepSelectFarmLotDesc => 'Selecione granja y lote';

  @override
  String get treatStepDiagnosisInfoDesc =>
      'Informações del diagnóstico y sintomas';

  @override
  String get treatStepTreatmentDetailsDesc =>
      'Detalhes del tratamento y medicamentos';

  @override
  String get treatStepVetObsDesc => 'Veterinário y observações adicionales';

  @override
  String saludDeleteConfirmMsg(String name) {
    return 'O registro de \"$name\" será excluído. Esta ação não pode ser desfeita.';
  }

  @override
  String commonDurationDays(String count) {
    return '$count dias';
  }

  @override
  String commonWeeks(String count) {
    return '$count semanas';
  }

  @override
  String get vacLocationTitle => 'Localização';

  @override
  String get vacInfoTitle => 'Informações de la Vacina';

  @override
  String get vacVaccineLabel => 'Vacina';

  @override
  String get vacDoseLabel => 'Dose';

  @override
  String get vacRouteShort => 'Vía';

  @override
  String get vacBatchVaccineLabel => 'Lote Vacina';

  @override
  String get vacNextApplicationLabel => 'Próxima Aplicação';

  @override
  String get vacScheduleTitle => 'Programar Vacinação';

  @override
  String vacDraftFoundMsg(String date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String vacDaysAgo(String days) {
    return 'hace $days dias';
  }

  @override
  String get vacDeletedSuccess => 'Vacinação eliminada correctamente';

  @override
  String get vacApplyDetails => 'Registra los detalhes de la aplicación';

  @override
  String get vacFilterAll => 'Todos';

  @override
  String get saludInspectionSaveMsg =>
      'Se salvará la inspección y se generará el relatório correspondiente.';

  @override
  String get saludInspGeneralDesc => 'Inspección geral de biossegurança';

  @override
  String get saludInspShedDesc => 'Inspección de biossegurança por galpão';

  @override
  String get saludCheckNotReviewed => 'Aún no se ha revisado.';

  @override
  String get saludCheckNonCompliance => 'Não conformidade detectada.';

  @override
  String get commonSwipeActions => 'Desliza para ações rápidas';

  @override
  String get commonGalponAvicola => 'Galpão Avícola';

  @override
  String get commonCode => 'Código';

  @override
  String get commonMaxCapacity => 'Capacidade Máxima';

  @override
  String get commonImportantInfo => 'Informação importante';

  @override
  String get commonCostsAutoCalculated =>
      'Los custos y métricas se calculan automáticamente según los datos insirados.';

  @override
  String get loteRazaLineaLabel => 'Raza/Línea';

  @override
  String get loteDiasRestantes => 'Dias Rprateleiras';

  @override
  String loteGdpFormat(String value) {
    return '$value g/día';
  }

  @override
  String get loteCoefVariacion => 'Coeficiente de variação';

  @override
  String get loteShedActiveConflict =>
      'Este galpão ya tiene un lote ativo. No es posible asignar más de un lote ativo por galpão.';

  @override
  String get commonOptimal => 'Óptimo';

  @override
  String get commonCritical => 'Crítico';

  @override
  String loteCierreVencido(String days) {
    return 'Cierre vencido hace $days dias';
  }

  @override
  String loteCierreProximo(String days) {
    return 'Cierre próximo en $days dias';
  }

  @override
  String loteEdadDias(String days) {
    return '$days dias';
  }

  @override
  String loteEdadSemanasDias(String semanas, String dias) {
    return '$semanas semanas ($dias dias)';
  }

  @override
  String loteEdadFormat(String edad, String dias) {
    return '$edad ($dias dias)';
  }

  @override
  String invStockBajo(String min, String unit) {
    return 'Estoque baixo (mínimo: $min $unit)';
  }

  @override
  String invVenceEn(String days) {
    return 'Vence en $days dias';
  }

  @override
  String get invSkuHelp =>
      'El código/SKU te ajudará a identificar rápidamente el item en tu inventário.';

  @override
  String get invSelectCategory =>
      'Selecione la categoría del item de inventário';

  @override
  String get invCatVaccines => 'Vacinas y produtos de inmunización';

  @override
  String get invCatDisinfection => 'Produtos de limpieza y desinfecção';

  @override
  String get galponTimeToday => 'Hoje';

  @override
  String get galponTimeYesterday => 'Ontem';

  @override
  String galponTimeDaysAgo(String days) {
    return 'Hace $days dias';
  }

  @override
  String loteEdadRegistro(String days) {
    return 'Edad: $days dias';
  }

  @override
  String get perfilLanguageSpanish => 'Espanol';

  @override
  String vacScheduledFormat(String date) {
    return 'Programado: $date';
  }

  @override
  String vacAppliedOnFormat(String date) {
    return 'Aplicado on $date';
  }

  @override
  String get vacAppliedDate => 'Data aplicación';

  @override
  String get vacCurrentUser => 'Current Usuário';

  @override
  String get vacEmptyDesc =>
      'Programa las vacinas para mantener la salud del lote';

  @override
  String get commonNoFarmSelected => 'No hay granja selecioneda';

  @override
  String commonErrorDeleting(String error) {
    return 'Erro al excluir: $error';
  }

  @override
  String commonErrorApplying(String error) {
    return 'Erro al aplicar vacina: $error';
  }

  @override
  String get vacRegisteredInventoryError =>
      'Vacinação registrada, pero hubo un erro al descontar inventário';

  @override
  String get commonTimeRightNow => 'ahora mismo';

  @override
  String commonTimeSecondsAgo(String count) {
    return 'hace ${count}s';
  }

  @override
  String commonTimeMinutesAgo(String count) {
    return 'hace ${count}m';
  }

  @override
  String commonTimeHoursAgo(String count) {
    return 'hace ${count}h';
  }

  @override
  String get commonErrorLoadingData => 'Erro al carregar datos';

  @override
  String get saludCheckCompliance => 'Cumprimento correto.';

  @override
  String get saludCheckPartial => 'Conforme con observações.';

  @override
  String get saludCheckNA => 'No corresponde evaluar.';

  @override
  String get loteProgressCycle => 'Progresso do ciclo';

  @override
  String loteDayOfCycle(String day, String remaining) {
    return 'Día $day de 45 ($remaining dias rprateleiras)';
  }

  @override
  String loteExtraDays(String day, String extra) {
    return 'Día $day ($extra dias extra)';
  }

  @override
  String get loteAttention => 'Atenção';

  @override
  String get loteKeyIndicators => 'Indicadores clave';

  @override
  String loteMortalityHigh(String rate, String expected) {
    return 'Mortalidadee elevada ($rate% > $expected% esperado)';
  }

  @override
  String loteWeightBelow(String percent) {
    return 'Peso por debaixo del objetivo ($percent% menos)';
  }

  @override
  String get loteTrendNormal => 'Normal';

  @override
  String get loteTrendAlto => 'Alto';

  @override
  String get loteTrendExcellent => 'Excelente';

  @override
  String get loteTrendElevated => 'Elevada';

  @override
  String get loteTrendAcceptable => 'Aceitarable';

  @override
  String get loteTrendBajo => 'Baixo';

  @override
  String get loteTrendBuena => 'Buena';

  @override
  String get loteTrendRegular => 'Regular';

  @override
  String get loteTrendBaja => 'Baja';

  @override
  String get loteRegister => 'Registrar';

  @override
  String get loteDashSummary => 'Resumo';

  @override
  String get batchInitialFlock => 'Parvada inicial';

  @override
  String get loteCierreEstimado => 'Datamento Estimado';

  @override
  String get loteNotRegistered => 'Not registrared';

  @override
  String get loteNotRecorded => 'Not recorded';

  @override
  String get birdDescPolloEngorde => 'Aves criadas para produção de carne';

  @override
  String get birdDescGallinaPonedora => 'Aves criadas para produção de ovos';

  @override
  String get birdDescRepPesada => 'Aves reprodutoras de línea pesada';

  @override
  String get birdDescRepLiviana => 'Aves reprodutoras de línea liviana';

  @override
  String get birdDescPavo => 'Perus para carne';

  @override
  String get birdDescCodorniz => 'Codornices para ovos o carne';

  @override
  String get birdDescPato => 'Patos para carne';

  @override
  String get birdDescOtro => 'Outro tipo de ave';

  @override
  String get birdDescFormPolloEngorde =>
      'Pollos de engorde para produção de carne';

  @override
  String get birdDescFormGallinaPonedora =>
      'Gallinas ponedoras para produção de ovos';

  @override
  String get birdDescFormRepPesada => 'Aves reprodutoras pesadas para crías';

  @override
  String get birdDescFormRepLiviana => 'Aves reprodutoras livianas para crías';

  @override
  String get birdDescFormPavo => 'Pavos para produção de carne';

  @override
  String get birdDescFormCodorniz => 'Codornices para ovos o carne';

  @override
  String get birdDescFormPato => 'Patos para produção de carne';

  @override
  String get birdDescFormOtro => 'Outro tipo de ave';

  @override
  String loteShedActiveWarning(String code) {
    return 'Este galpão ya tiene un lote ativo ($code). El novo lote compartilhará el espacio disponível.';
  }

  @override
  String get ubicacionCurrentOccupation => 'Ocupação Actual';

  @override
  String get ubicacionCurrentBirds => 'Aves Atuais';

  @override
  String get ubicacionAvailableCapacity => 'Capacidade Disponível';

  @override
  String get ubicacionOccupation => 'Ocupação';

  @override
  String get ubicacionBirdTypeInShed => 'Tipo de Ave en Galpão';

  @override
  String ubicacionBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String ubicacionCapacityInfo(String capacity) {
    return 'Capacidade máxima: $capacity aves';
  }

  @override
  String ubicacionAreaInfo(String area) {
    return 'Área: $area m²';
  }

  @override
  String get commonErrorLoadingShed => 'Erro al carregar galpões';

  @override
  String get consumoSummaryTitle => 'Resumo del Consumo';

  @override
  String get consumoSummarySubtitle => 'Revisa los datos y agrega observações';

  @override
  String get consumoObsHint =>
      'Ex: Aves con buen apetito, alimento bien recibido...';

  @override
  String get invBasicInfoSubtitle => 'Insira los datos principales del item';

  @override
  String get invOptionalDetails => 'Informações opcional para mejor control';

  @override
  String get invOptionalDetailsInfo =>
      'Estos datos son opcionales pero ajudan a un mejor control y trazabilidad del inventário.';

  @override
  String get invCatInsumo =>
      'Materiales de cama, desinfectantes y outros insumos';

  @override
  String get invImageReady => 'Lista';

  @override
  String get invCanAddPhoto => 'Você pode adicionar uma foto do produto';

  @override
  String loteFormatDays(String count) {
    return '$count dias';
  }

  @override
  String loteFormatWeek(String count) {
    return '$count semana';
  }

  @override
  String loteFormatWeeks(String count) {
    return '$count semanas';
  }

  @override
  String loteFormatMonth(String count) {
    return '$count mês';
  }

  @override
  String loteFormatMonths(String count) {
    return '$count mêses';
  }

  @override
  String loteFormatWeeksShort(String count) {
    return '$count sem';
  }

  @override
  String get loteTrendOptimal => 'Óptimo';

  @override
  String get loteTrendCritical => 'Crítico';

  @override
  String get loteTrendCritica => 'Crítica';

  @override
  String get loteFeedKg => 'kg ração';

  @override
  String loteFormatMonthAndWeeksShort(String months, String weeks) {
    return '$months mês y $weeks sem';
  }

  @override
  String loteFormatMonthsAndWeeksShort(String months, String weeks) {
    return '$months mêses y $weeks sem';
  }

  @override
  String loteResumenWeeksDays(String weeks, String days) {
    return ' ($weeks sem, $days dias)';
  }

  @override
  String loteResumenWeeksParens(String weeks) {
    return ' ($weeks semanas)';
  }

  @override
  String get invCatLimpieza => 'Produtos de limpieza y desinfecção';

  @override
  String get invHintExample => 'Ex: Concentrado Iniciador';

  @override
  String get commonArea => 'Área';

  @override
  String invStockInfoFormat(String stock, String unit) {
    return 'Estoque actual: $stock $unit';
  }

  @override
  String get invMotiveHint => 'Ex: Inventário físico';

  @override
  String ubicacionShedDropdown(String code, String capacity) {
    return '$code - Capacidade: $capacity aves';
  }

  @override
  String invDraftFoundMessage(String date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String get catalogDiseaseNotifRequired => 'Notificação obrigatória';

  @override
  String get catalogDiseaseVaccinable => 'Vacinable';

  @override
  String get commonCategory => 'Categoria';

  @override
  String get catalogDiseaseSymptoms => 'Sintomas';

  @override
  String get catalogDiseaseSeverity => 'Gravedad';

  @override
  String get catalogDiseaseNotFound => 'No se encontraron doençaes';

  @override
  String get catalogDiseaseEmpty => 'Catálogo vacío';

  @override
  String get catalogDiseaseSearchHint =>
      'Intenta con outros términos de búsqueda o filtros';

  @override
  String get catalogDiseaseNone => 'No hay doençaes registradas';

  @override
  String get catalogDiseaseInfoGeneral => 'Informações Geral';

  @override
  String get catalogDiseaseTransDiag => 'Transmission and Diagnóstico';

  @override
  String get catalogDiseaseMainSymptoms => 'Sintomas Principales';

  @override
  String get catalogDiseasePostmortem => 'Lesiones Post-mortem';

  @override
  String get catalogDiseaseTreatPrev => 'Tratamento y Prevenção';

  @override
  String get catalogDiseaseNotifOblig => 'Mandatory Notificação';

  @override
  String get catalogDiseaseVaccinePrevent => 'Prevenível por vacinação';

  @override
  String get catalogDiseaseCausalAgent => 'Agente Causal';

  @override
  String get catalogDiseaseContagious => 'Contagiosa';

  @override
  String get catalogDiseaseNotification => 'Notificação';

  @override
  String get catalogDiseaseVaccineAvail => 'Vacina Disponível';

  @override
  String get catalogDiseaseTransmission => 'Transmisión';

  @override
  String get catalogDiseaseDiagnosis => 'Diagnóstico';

  @override
  String get catalogDiseaseViewDetails => 'Ver Detalhes';

  @override
  String get catalogDiseaseConsultVet => 'Consulte con su veterinário';

  @override
  String get batchSelectNewStatusLabel => 'Selecionar novo status:';

  @override
  String batchConfirmStatusChange(String status) {
    return 'Confirmar change to $status?';
  }

  @override
  String get batchPermanentStatusWarning =>
      'Este status é permanente e não poderá ser revertido. O lote não poderá mudar para nenhum outro status após esta ação.';

  @override
  String get batchPermanentStatus => 'Status permanente';

  @override
  String get batchTypePoultryDesc => 'Aves criadas para produção de carne';

  @override
  String get batchTypeLayersDesc => 'Aves criadas para produção de ovos';

  @override
  String get batchTypeHeavyBreedersDesc => 'Aves reprodutoras de línea pesada';

  @override
  String get batchTypeLightBreedersDesc => 'Aves reprodutoras de línea liviana';

  @override
  String get batchTypeTurkeysDesc => 'Perus para carne';

  @override
  String get batchTypeQuailDesc => 'Codornices para ovos o carne';

  @override
  String get batchTypeDucksDesc => 'Patos para carne';

  @override
  String get batchTypeOtherDesc => 'Outro tipo de ave';

  @override
  String get batchNotRecorded => 'No registrado';

  @override
  String get commonBirdsUnit => 'aves';

  @override
  String batchAgeDaysValue(String count) {
    return '$count dias';
  }

  @override
  String batchAgeWeeksDaysValue(String weeks, String days) {
    return '$weeks semanas ($days dias)';
  }

  @override
  String get costExpenseType => 'Expense tipo';

  @override
  String get costProvider => 'Fornecedor';

  @override
  String get costRejectionReason => 'Motivo rejeição';

  @override
  String get weightBirdsWeighed => 'Aves weighed';

  @override
  String get weightTotal => 'Total peso';

  @override
  String get weightDailyGain => 'ADG (Average diário gain)';

  @override
  String get weightGramsPerDay => 'g/día';

  @override
  String feedExceedsStock(String stock) {
    return 'La quantidade excede el estoque disponível ($stock kg)';
  }

  @override
  String feedStockPercentUsage(String percent) {
    return 'Usarás el $percent% del estoque disponível';
  }

  @override
  String feedRecommendedForDays(String days, String type) {
    return 'Recomendado para $days dias: $type';
  }

  @override
  String get feedConsumptionDate => 'Data del consumo';

  @override
  String get feedObsTitle => 'Observações';

  @override
  String get feedObsOptionalHint => 'Opcional: Agrega notas adicionais';

  @override
  String get feedObsDescribeHint =>
      'Descreva as condições do fornecimento, comportamento das aves, qualidade da ração, etc.';

  @override
  String get feedObsHelpText =>
      'Las observações ajudan a documentar detalhes importantes del suministro de alimento y pueden ser útiles para análisis futuros.';

  @override
  String get ventaSelectBatchHint => 'Selecione un lote';

  @override
  String get ventaBatchLoadError => 'Erro al carregar lotes';

  @override
  String get saludRegisteredBy => 'Registrado por';

  @override
  String get saludCloseTreatment => 'Fechar Tratamento';

  @override
  String get saludResultOptional => 'Result (Opcional)';

  @override
  String get saludMonthNames =>
      'Janro,Fevrero,Marzo,Abril,Maio,Junio,Julio,Agosto,Settiembre,Outubre,Noviembre,Deziembre';

  @override
  String get saludDateConnector => 'de';

  @override
  String get treatDurationValidation =>
      'La duração debe ser entre 1 y 365 dias';

  @override
  String get commonDateCannotBeFuture => 'La data no puede ser futura';

  @override
  String get treatNewTreatment => 'Novo Tratamento';

  @override
  String get commonSaveAction => 'Salvar';

  @override
  String get costRegisteredInventoryError =>
      'Custo registrado, pero hubo un erro al atualizar inventário';

  @override
  String invStockActualLabel(String stock, String unit) {
    return 'Actual: $stock $unit';
  }

  @override
  String invStockMinimoLabel(String stock, String unit) {
    return 'Mínimo: $stock $unit';
  }

  @override
  String get invEntryError => 'Erro al registrar entrada de inventário';

  @override
  String get invExitError => 'Erro al registrar salida de inventário';

  @override
  String get feedLoadingItems => 'Carregando ração...';

  @override
  String get feedLoadError => 'Erro al carregar ração';

  @override
  String get photoNoPhotosAdded => 'No fotos added';

  @override
  String get photoMax5Hint => 'Você pode adicionar até 5 fotos';

  @override
  String get farmPoultryFarm => 'Poultry Granja';

  @override
  String get farmNoAddress => 'No endereço';

  @override
  String get shedAddTagHint => 'Adicionar etiqueta';

  @override
  String get shedCapacityHintExample => 'Ex: 1000';

  @override
  String get prodObsHint =>
      'Descreva a qualidade dos ovos, cor da casca, condições ambientais, comportamento das aves, etc.';

  @override
  String get commonAge => 'Edad';

  @override
  String get batchQuantityValidation =>
      'Insira una quantidade válida mayor a 0';

  @override
  String invStockBajoMinimo(String min, String unit) {
    return 'Estoque baixo (mínimo: $min $unit)';
  }

  @override
  String reportsPeriodLabel(String period) {
    return 'Período: $period';
  }

  @override
  String reportsPeriodSameMonth(
    String dayStart,
    String dayEnd,
    String month,
    String year,
  ) {
    return '$dayStart a $dayEnd de $month $year';
  }

  @override
  String reportsPeriodSameYear(
    String dayStart,
    String monthStart,
    String dayEnd,
    String monthEnd,
    String year,
  ) {
    return '$dayStart de $monthStart a $dayEnd de $monthEnd, $year';
  }

  @override
  String reportsPeriodDateRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String get batchShareCode => 'Código';

  @override
  String get batchShareType => 'Tipo';

  @override
  String get batchShareBreed => 'Raza';

  @override
  String get batchShareStatus => 'Status';

  @override
  String get batchShareBirds => 'Aves';

  @override
  String get batchShareEntry => 'Ingreso';

  @override
  String get batchShareAge => 'Edad';

  @override
  String get batchShareWeight => 'Peso';

  @override
  String get batchShareMortality => 'Mortalidade';

  @override
  String batchShareBirdsFormat(String current, String total) {
    return '$current de $total';
  }

  @override
  String get enumTipoAlimentoPreIniciador => 'Pre-iniciador';

  @override
  String get enumTipoAlimentoIniciador => 'Iniciador';

  @override
  String get enumTipoAlimentoCrecimiento => 'Crescimento';

  @override
  String get enumTipoAlimentoFinalizador => 'Finalizador';

  @override
  String get enumTipoAlimentoPostura => 'Postura';

  @override
  String get enumTipoAlimentoLevante => 'Levante';

  @override
  String get enumTipoAlimentoMedicado => 'Medicado';

  @override
  String get enumTipoAlimentoConcentrado => 'Concentrado';

  @override
  String get enumTipoAlimentoOtro => 'Outro';

  @override
  String get enumTipoAlimentoDescPreIniciador => 'Pre-iniciador (0-7 dias)';

  @override
  String get enumTipoAlimentoDescIniciador => 'Iniciador (8-21 dias)';

  @override
  String get enumTipoAlimentoDescCrecimiento => 'Crescimento (22-35 dias)';

  @override
  String get enumTipoAlimentoDescFinalizador => 'Finalizador (36+ dias)';

  @override
  String get enumTipoAlimentoRangoPreIniciador => '0-7 dias';

  @override
  String get enumTipoAlimentoRangoIniciador => '8-21 dias';

  @override
  String get enumTipoAlimentoRangoCrecimiento => '22-35 dias';

  @override
  String get enumTipoAlimentoRangoFinalizador => '36+ dias';

  @override
  String get enumTipoAlimentoRangoPostura => 'Gallinas ponedoras';

  @override
  String get enumTipoAlimentoRangoLevante => 'Pollitas reemplazo';

  @override
  String get enumMetodoPesajeManual => 'Manual';

  @override
  String get enumMetodoPesajeBasculaIndividual => 'Báscula Individual';

  @override
  String get enumMetodoPesajeBasculaLote => 'Lote Scale';

  @override
  String get enumMetodoPesajeAutomatica => 'Automática';

  @override
  String get enumMetodoPesajeDescManual => 'Manual com balança';

  @override
  String get enumMetodoPesajeDescBasculaIndividual => 'Báscula individual';

  @override
  String get enumMetodoPesajeDescBasculaLote => 'Lote scale';

  @override
  String get enumMetodoPesajeDescAutomatica => 'Sistema automático';

  @override
  String get enumMetodoPesajeDetalleManual =>
      'Pesagem ave por ave con báscula portátil';

  @override
  String get enumMetodoPesajeDetalleBasculaIndividual =>
      'Electronic scale for one ave';

  @override
  String get enumMetodoPesajeDetalleBasculaLote =>
      'Pesagem grupal dividido entre quantidade';

  @override
  String get enumMetodoPesajeDetalleAutomatica =>
      'Sistema automatizado integrado';

  @override
  String get enumCausaMortEnfermedad => 'Doença';

  @override
  String get enumCausaMortAccidente => 'Accidente';

  @override
  String get enumCausaMortDesnutricion => 'Desnutrição';

  @override
  String get enumCausaMortEstres => 'Estrés';

  @override
  String get enumCausaMortMetabolica => 'Metabólica';

  @override
  String get enumCausaMortDepredacion => 'Predação';

  @override
  String get enumCausaMortSacrificio => 'Sacrificio';

  @override
  String get enumCausaMortVejez => 'Vejez';

  @override
  String get enumCausaMortDesconocida => 'Desconhecido';

  @override
  String get enumCausaMortDescEnfermedad => 'Patología infecciosa';

  @override
  String get enumCausaMortDescAccidente => 'Trauma o lesión';

  @override
  String get enumCausaMortDescDesnutricion => 'Falta de nutrientes';

  @override
  String get enumCausaMortDescEstres => 'Factores ambientales';

  @override
  String get enumCausaMortDescMetabolica => 'Problemas fisiológicos';

  @override
  String get enumCausaMortDescDepredacion => 'Ataques de animais';

  @override
  String get enumCausaMortDescSacrificio => 'Muerte en faena';

  @override
  String get enumCausaMortDescVejez => 'Fim da vida produtiva';

  @override
  String get enumCausaMortDescDesconocida => 'Causa no identificada';

  @override
  String get enumTipoAlimentoRangoMedicado => 'Con tratamento';

  @override
  String get enumTipoAlimentoRangoConcentrado => 'Suplemento';

  @override
  String get enumTipoAlimentoRangoOtro => 'Uso geral';

  @override
  String get enumTipoAlimentoDescPostura => 'Postura';

  @override
  String get enumTipoAlimentoDescLevante => 'Levante';

  @override
  String get enumTipoAlimentoDescMedicado => 'Medicado';

  @override
  String get enumTipoAlimentoDescConcentrado => 'Concentrado';

  @override
  String get enumTipoAlimentoDescOtro => 'Outro';

  @override
  String errorSavingGeneric(String error) {
    return 'Erro al salvar: $error';
  }

  @override
  String errorDeletingGeneric(String error) {
    return 'Erro al excluir: $error';
  }

  @override
  String get errorUserNotAuthenticated => 'Usuário not authenticated';

  @override
  String get errorGeneric => 'Erro';

  @override
  String get enumTipoAvePolloEngorde => 'Frango de Corte';

  @override
  String get enumTipoAveGallinaPonedora => 'Gallina Ponedora';

  @override
  String get enumTipoAveReproductoraPesada => 'Reprodutora Pesada';

  @override
  String get enumTipoAveReproductoraLiviana => 'Reprodutora Liviana';

  @override
  String get enumTipoAvePavo => 'Pavo';

  @override
  String get enumTipoAveCodorniz => 'Codorniz';

  @override
  String get enumTipoAvePato => 'Pato';

  @override
  String get enumTipoAveOtro => 'Outro';

  @override
  String get enumTipoAveShortPolloEngorde => 'Engorde';

  @override
  String get enumTipoAveShortGallinaPonedora => 'Ponedora';

  @override
  String get enumTipoAveShortReproductoraPesada => 'Rep. Pesada';

  @override
  String get enumTipoAveShortReproductoraLiviana => 'Rep. Liviana';

  @override
  String get enumTipoAveShortPavo => 'Pavo';

  @override
  String get enumTipoAveShortCodorniz => 'Codorniz';

  @override
  String get enumTipoAveShortPato => 'Pato';

  @override
  String get enumTipoAveShortOtro => 'Outro';

  @override
  String get enumEstadoLoteActivo => 'Ativo';

  @override
  String get enumEstadoLoteCerrado => 'Fechard';

  @override
  String get enumEstadoLoteCuarentena => 'Quarentena';

  @override
  String get enumEstadoLoteVendido => 'Vendido';

  @override
  String get enumEstadoLoteEnTransferencia => 'En Transferencia';

  @override
  String get enumEstadoLoteSuspendido => 'Suspendido';

  @override
  String get enumEstadoLoteDescActivo => 'Lote en produção normal';

  @override
  String get enumEstadoLoteDescCerrado => 'Lote finalized';

  @override
  String get enumEstadoLoteDescCuarentena =>
      'Lote isolated for sanitary reasons';

  @override
  String get enumEstadoLoteDescVendido => 'Lote completely sold';

  @override
  String get enumEstadoLoteDescEnTransferencia => 'Lote being transferred';

  @override
  String get enumEstadoLoteDescSuspendido => 'Lote temporarily suspended';

  @override
  String get enumEstadoGalponActivo => 'Ativo';

  @override
  String get enumEstadoGalponMantenimiento => 'Manutenção';

  @override
  String get enumEstadoGalponInactivo => 'Inativo';

  @override
  String get enumEstadoGalponDesinfeccion => 'Desinfecção';

  @override
  String get enumEstadoGalponCuarentena => 'Quarentena';

  @override
  String get enumEstadoGalponDescActivo => 'Galpão operativo';

  @override
  String get enumEstadoGalponDescMantenimiento => 'Galpão en reparación';

  @override
  String get enumEstadoGalponDescInactivo => 'Galpão sin uso';

  @override
  String get enumEstadoGalponDescDesinfeccion => 'Galpão en proceso sanitario';

  @override
  String get enumEstadoGalponDescCuarentena => 'Galpão aislado por sanidad';

  @override
  String get enumTipoGalponEngorde => 'Engorde';

  @override
  String get enumTipoGalponPostura => 'Postura';

  @override
  String get enumTipoGalponReproductora => 'Reprodutora';

  @override
  String get enumTipoGalponMixto => 'Misto';

  @override
  String get enumTipoGalponDescEngorde => 'Galpão para produção de carne';

  @override
  String get enumTipoGalponDescPostura => 'Galpão para produção de ovos';

  @override
  String get enumTipoGalponDescReproductora =>
      'Galpão para produção de ovos fértiles';

  @override
  String get enumTipoGalponDescMixto =>
      'Galpão multiuso para diferentes tipos de produção';

  @override
  String get enumRolGranjaOwner => 'Proprietário';

  @override
  String get enumRolGranjaAdmin => 'Administrador';

  @override
  String get enumRolGranjaManager => 'Gestor';

  @override
  String get enumRolGranjaOperator => 'Operario';

  @override
  String get enumRolGranjaViewer => 'Visualizador';

  @override
  String get enumRolGranjaDescOwner => 'Control total, puede excluir la granja';

  @override
  String get enumRolGranjaDescAdmin => 'Control total excepto excluir';

  @override
  String get enumRolGranjaDescManager => 'Gestão de registros e invitaciones';

  @override
  String get enumRolGranjaDescOperator => 'Solo puede criar registros';

  @override
  String get enumRolGranjaDescViewer => 'Solo lectura';

  @override
  String get savedMomentAgo => 'Salvard a moment ago';

  @override
  String savedMinutesAgo(int minutes) {
    return 'Salvard $minutes min ago';
  }

  @override
  String savedAtTime(String time) {
    return 'Salvard at $time';
  }

  @override
  String get pleaseSelectFarmAndBatch =>
      'Por favor selecione una granja y un lote';

  @override
  String get pleaseSelectExpenseType => 'Por favor selecione un tipo de gasto';

  @override
  String get noPermissionEditCosts =>
      'Você não tem permissão para editar custos nesta granja';

  @override
  String get noPermissionCreateCosts =>
      'Você não tem permissão para registrar custos nesta granja';

  @override
  String get errorSelectFarm => 'Por favor selecione una granja';

  @override
  String errorClosingTreatment(String error) {
    return 'Erro al fechar tratamento: $error';
  }

  @override
  String get couldNotLoadBiosecurity => 'No se pudo carregar biossegurança';

  @override
  String purchaseOf(String name) {
    return 'Compra de $name';
  }

  @override
  String draftFoundMessage(String date) {
    return 'Foi encontrado um rascunho salvo de $date.\nDeseja restaurá-lo?';
  }

  @override
  String insufficientStock(String available) {
    return 'Estoque insuficiente. Disponível: $available kg';
  }

  @override
  String get maxWeightIs => 'Maximum peso is 50,000 kg';

  @override
  String get fieldRequired => 'Este campo es obrigatório';

  @override
  String closedOnDate(String date) {
    return 'Fechard on $date';
  }

  @override
  String inventoryOfType(String type) {
    return 'of tipo $type';
  }

  @override
  String get enumTipoRegistroPeso => 'Peso';

  @override
  String get enumTipoRegistroConsumo => 'Consumo';

  @override
  String get enumTipoRegistroMortalidad => 'Mortalidade';

  @override
  String get enumTipoRegistroProduccion => 'Produção';

  @override
  String get semanticsStatusOpen => 'abierto';

  @override
  String get semanticsStatusClosed => 'fechard';

  @override
  String get semanticsDirectionEntry => 'entrada';

  @override
  String get semanticsDirectionExit => 'salida';

  @override
  String get semanticsUnits => 'unidadees';

  @override
  String semanticsHealthRecord(String diagnosis, String date, String status) {
    return 'Registro de saúde, $diagnosis, $date, $status';
  }

  @override
  String semanticsVaccination(String name, String date, String status) {
    return 'Vacinação $name, $date, status $status';
  }

  @override
  String semanticsSale(String type, String date, String status) {
    return 'Venda de $type, $date, status $status';
  }

  @override
  String semanticsCost(String concept, String type, String date) {
    return 'Custo $concept, tipo $type, $date';
  }

  @override
  String semanticsInventoryMovement(
    String type,
    String direction,
    String quantity,
    String units,
  ) {
    return 'Movimento $type, $direction de $quantity $units';
  }

  @override
  String semanticsInventoryItem(
    String name,
    String type,
    String stock,
    String unit,
    String status,
  ) {
    return 'Item $name, $type, $stock $unit, status $status';
  }

  @override
  String dateFormatDayOfMonthYearTime(
    String day,
    String month,
    String year,
    String time,
  ) {
    return '$day de $month $year • $time';
  }

  @override
  String shareDateLine(String value) {
    return '📅 Data: $value';
  }

  @override
  String shareTypeLine(String value) {
    return '🏷️ Tipo: $value';
  }

  @override
  String shareQuantityBirdsLine(String count) {
    return '🐔 Quantidade: $count aves';
  }

  @override
  String sharePricePerKgLine(String currency, String price) {
    return '💰 Preço: $currency $price/kg';
  }

  @override
  String shareEggsLine(String count) {
    return '🥚 Ovos: $count unidadees';
  }

  @override
  String shareQuantityLine(String count, String unit) {
    return '📝 Quantidade: $count $unit';
  }

  @override
  String shareTotalLine(String currency, String amount) {
    return '💵 TOTAL: $currency $amount';
  }

  @override
  String shareClientLine(String value) {
    return '👤 Cliente: $value';
  }

  @override
  String shareContactLine(String value) {
    return '📱 Contacto: $value';
  }

  @override
  String shareStatusLine(String value) {
    return '📊 Status: $value';
  }

  @override
  String shareSubjectSale(String type) {
    return 'Venda - $type';
  }

  @override
  String get bultosFallback => 'sacos';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String birdCountWithPercent(String count, String percent) {
    return '$count aves ($percent%)';
  }

  @override
  String eggCountUnits(String count) {
    return '$count unidadees';
  }

  @override
  String batchDropdownItemCode(String code, String count) {
    return '$code - $count aves';
  }

  @override
  String batchDropdownItemName(String name, String count) {
    return '$name - $count aves';
  }

  @override
  String semanticsLoteSummary(
    String code,
    String type,
    String count,
    String status,
  ) {
    return 'Lote $code, $type, $count aves, $status';
  }

  @override
  String inventoryStockLabel(String value, String unit) {
    return 'Estoque: $value $unit';
  }

  @override
  String inventoryExpiresLabel(String date) {
    return 'Vence: $date';
  }

  @override
  String inventoryPriceLabel(String price, String unit) {
    return 'Preço: $price/$unit';
  }

  @override
  String get shedDensityFattening => '10-12 aves/m²';

  @override
  String get shedDensityLaying => '8-10 aves/m²';

  @override
  String get shedDensityBreeder => '6-8 aves/m²';

  @override
  String galponTotalCount(String count) {
    return '$count total';
  }

  @override
  String get pollinazaItemName => 'Pollinaza';

  @override
  String get inspectorFallback => 'Inspector';

  @override
  String get collaboratorRoleFallback => 'colaborador';

  @override
  String get reportFilePrefix => 'Relatório';

  @override
  String get errorOccurredDefault => 'Ocorreu um erro';

  @override
  String get errorUnknown => 'Erro desconhecido';

  @override
  String get unitsFallback => 'unidadees';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get guiasManejoTitle => 'Guias de Manejo';

  @override
  String get guiasManejoSubtitle =>
      'Recomendações técnicas baseadas em manuais oficiais';

  @override
  String get guiasManejoBotonLabel => 'Ver guias de manejo';

  @override
  String get guiaLuzTitle => 'Luz';

  @override
  String get guiaAlimentacionTitle => 'Alimentação';

  @override
  String get guiaPesoTitle => 'Peso';

  @override
  String get guiaAguaTitle => 'Água';

  @override
  String get guiaSemanaCol => 'Sem';

  @override
  String get guiaHorasLuzCol => 'Horas de luz';

  @override
  String get guiaPesoObjetivoCol => 'Peso alvo';

  @override
  String get guiaTipoCol => 'Tipo';

  @override
  String get guiaTotalLote => 'total lote';

  @override
  String get guiaAveAbrev => 'ave';

  @override
  String get guiaDiaAbrev => 'dia';

  @override
  String guiaSemanaActualLabel(int semana) {
    return 'Semana $semana (atual)';
  }

  @override
  String get guiaLuzSubtitle => 'Horas de luz recomendadas por dia';

  @override
  String guiaAlimentacionSubtitle(String kgDia, int aves) {
    return 'Total lote: $kgDia kg/dia para $aves aves';
  }

  @override
  String guiaAguaSubtitle(String litrosDia, int aves) {
    return 'Total lote: $litrosDia L/dia para $aves aves';
  }

  @override
  String guiaPesoComparacion(String actual, String objetivo) {
    return 'Peso atual: ${actual}g — Alvo: ${objetivo}g';
  }

  @override
  String get guiaPesoSinDatos => 'Sem dados de peso atual registrados';

  @override
  String get guiaTipoAlimentoRecomendado => 'Alimento recomendado';

  @override
  String get guiaFuenteManual => 'Fonte';

  @override
  String get guiaTemperaturaTitle => 'Temperatura';

  @override
  String get guiaHumedadTitle => 'Umidade';

  @override
  String get guiaTemperaturaSubtitle => 'Temperatura ambiente recomendada';

  @override
  String get guiaHumedadSubtitle => 'Umidade relativa recomendada';

  @override
  String get guiaTemperaturaCol => 'Temp (°C)';

  @override
  String get guiaHumedadCol => 'Umidade (%)';

  @override
  String get vetVirtualTitle => 'Veterinário Virtual';

  @override
  String get vetVirtualSubtitle => 'Assistente avícola com IA';

  @override
  String vetVirtualContextoLote(String codigo, String tipoAve) {
    return 'Usando contexto do lote $codigo ($tipoAve)';
  }

  @override
  String get vetVirtualSinContexto => 'Consulta geral sem lote selecionado';

  @override
  String get vetVirtualEligeConsulta => 'O que você precisa consultar?';

  @override
  String get vetVirtualDisclaimer =>
      'Este assistente usa inteligência artificial como apoio. Não substitui o diagnóstico de um veterinário profissional. Consulte presencialmente em emergências.';

  @override
  String get vetDiagnosticoTitle => 'Diagnóstico';

  @override
  String get vetDiagnosticoDesc =>
      'Descreva sintomas e obtenha possíveis diagnósticos';

  @override
  String get vetMortalidadTitle => 'Mortalidade';

  @override
  String get vetMortalidadDesc =>
      'Analise taxas de mortalidade e possíveis causas';

  @override
  String get vetVacunacionTitle => 'Vacinação';

  @override
  String get vetVacunacionDesc => 'Plano de vacinação por tipo e idade da ave';

  @override
  String get vetNutricionTitle => 'Nutrição';

  @override
  String get vetNutricionDesc =>
      'Avalie alimentação, peso e conversão alimentar';

  @override
  String get vetAmbienteTitle => 'Ambiente';

  @override
  String get vetAmbienteDesc => 'Temperatura, umidade e condições do galpão';

  @override
  String get vetBioseguridadTitle => 'Biossegurança';

  @override
  String get vetBioseguridadDesc => 'Protocolos de prevenção e desinfecção';

  @override
  String get vetGeneralTitle => 'Consulta Geral';

  @override
  String get vetGeneralDesc => 'Pergunte o que precisar sobre avicultura';

  @override
  String get vetChatHint => 'Escreva sua consulta...';

  @override
  String get vetChatError =>
      'Não foi possível obter resposta. Tente novamente.';

  @override
  String get vetChatRetry => 'Tentar novamente';

  @override
  String get vetVirtualBotonLabel => 'Veterinário Virtual IA';

  @override
  String get vetIaLabel => 'Veterinário IA';

  @override
  String get vetTextoCopied => 'Texto copiado';

  @override
  String get vetAnalizando => 'Analisando...';

  @override
  String get vetAttachImage => 'Anexar imagem';

  @override
  String get vetFromCamera => 'Tirar foto';

  @override
  String get vetFromGallery => 'Escolher da galeria';

  @override
  String get vetImageAttach => 'Anexar imagem';

  @override
  String get vetImageSelectSource => 'Selecione de onde obter a imagem';

  @override
  String get vetStatusProcessing => 'Processando sua consulta...';

  @override
  String get vetStatusAnalyzingImage => 'Analisando imagem...';

  @override
  String get vetStatusGenerating => 'Gerando resposta...';

  @override
  String get vetVoiceListening => 'Ouvindo...';

  @override
  String get vetVoiceNotAvailable =>
      'O reconhecimento de voz não está disponível';

  @override
  String get vetVoiceStart => 'Iniciar ditado';

  @override
  String get vetVoiceStop => 'Parar ditado';

  @override
  String get vetAnalyzeImage => 'Analise esta imagem';

  @override
  String get legalLastUpdated => 'Última atualização: Abril 2026';

  @override
  String get legalPrivacy1Title => '1. Informações que coletamos';

  @override
  String get legalPrivacy1Body =>
      'Coletamos as informações que você fornece diretamente: nome, e-mail, dados de suas granjas (nome, localização, galpões, lotes), registros produtivos (peso, mortalidade, produção, consumo), imagens de aves e galpões, e dados de saúde animal. Também coletamos automaticamente dados de uso do app e tokens de notificações push.';

  @override
  String get legalPrivacy2Title => '2. Como usamos suas informações';

  @override
  String get legalPrivacy2Body =>
      'Usamos seus dados para: operar e manter o aplicativo, gerar relatórios e análises produtivas, oferecer recomendações de manejo através do veterinário virtual IA, enviar notificações sobre alertas sanitários e lembretes, e melhorar nossos serviços. Não vendemos nem compartilhamos seus dados com terceiros para fins publicitários.';

  @override
  String get legalPrivacy3Title => '3. Armazenamento e segurança';

  @override
  String get legalPrivacy3Body =>
      'Seus dados são armazenados de forma segura nos servidores Firebase (Google Cloud Platform) com criptografia em trânsito e em repouso. Implementamos medidas de segurança técnicas e organizacionais para proteger suas informações contra acesso não autorizado, alteração ou destruição.';

  @override
  String get legalPrivacy4Title => '4. Compartilhamento de dados';

  @override
  String get legalPrivacy4Body =>
      'Só compartilhamos seus dados de granja com os colaboradores que você convidar explicitamente. As consultas ao veterinário virtual IA são processadas pelo Google Gemini; essas consultas não contêm informações pessoais identificáveis além do contexto da granja necessário para a resposta.';

  @override
  String get legalPrivacy5Title => '5. Seus direitos';

  @override
  String get legalPrivacy5Body =>
      'Você tem direito a: acessar seus dados pessoais, corrigir informações inexatas, solicitar a exclusão de sua conta e dados, exportar seus dados em formatos padrão, e retirar seu consentimento a qualquer momento.';

  @override
  String get legalPrivacy6Title => '6. Retenção de dados';

  @override
  String get legalPrivacy6Body =>
      'Conservamos seus dados enquanto sua conta estiver ativa. Se solicitar a exclusão de sua conta, excluiremos seus dados pessoais em até 30 dias, exceto quando a lei exigir conservação por período maior.';

  @override
  String get legalPrivacy7Title => '7. Contato';

  @override
  String get legalPrivacy7Body =>
      'Para consultas sobre privacidade, entre em contato conosco pela seção de ajuda do aplicativo ou enviando um e-mail para soporte@smartgranjaaves.com.';

  @override
  String get legalTerms1Title => '1. Aceitação dos termos';

  @override
  String get legalTerms1Body =>
      'Ao utilizar o Smart Granja Aves Pro, você aceita estes termos e condições. Se não concordar, por favor não utilize o aplicativo.';

  @override
  String get legalTerms2Title => '2. Uso do aplicativo';

  @override
  String get legalTerms2Body =>
      'O aplicativo é projetado como ferramenta de gestão avícola e apoio à tomada de decisões. As recomendações do veterinário virtual IA são orientativas e NÃO substituem a consulta com um médico veterinário presencial. O usuário é responsável pelas decisões tomadas com base nas informações fornecidas.';

  @override
  String get legalTerms3Title => '3. Conta de usuário';

  @override
  String get legalTerms3Body =>
      'Você é responsável por manter a confidencialidade de sua conta e senha. Deve nos notificar imediatamente sobre qualquer uso não autorizado de sua conta.';

  @override
  String get legalTerms4Title => '4. Propriedade intelectual';

  @override
  String get legalTerms4Body =>
      'Os dados que você insere no aplicativo são de sua propriedade. Smart Granja Aves Pro retém os direitos sobre o software, design, algoritmos e conteúdo próprio do aplicativo.';

  @override
  String get legalTerms5Title => '5. Limitação de responsabilidade';

  @override
  String get legalTerms5Body =>
      'O aplicativo é fornecido \"como está\". Não garantimos que as recomendações do veterinário virtual sejam infalíveis. Não somos responsáveis por perdas decorrentes do uso das informações fornecidas. Em caso de emergência sanitária, sempre consulte um veterinário presencial.';

  @override
  String get legalTerms6Title => '6. Modificações';

  @override
  String get legalTerms6Body =>
      'Reservamo-nos o direito de modificar estes termos a qualquer momento. Notificaremos sobre alterações significativas através do aplicativo. O uso continuado após as alterações constitui sua aceitação dos novos termos.';
}
