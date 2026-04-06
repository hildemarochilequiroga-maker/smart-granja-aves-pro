// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Smart Granja Aves Pro';

  @override
  String get navHome => 'Inicio';

  @override
  String get navManagement => 'Gestión';

  @override
  String get navBatches => 'Lotes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String commonHintExample(String value) {
    return 'Ej: $value';
  }

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonAccept => 'Aceptar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonSearch => 'Buscar...';

  @override
  String get commonGoHome => 'Ir al inicio';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonApplyFilters => 'Aplicar filtros';

  @override
  String get commonClearFilters => 'Limpiar filtros';

  @override
  String get commonClear => 'Limpiar';

  @override
  String get commonNoResults => 'No se encontraron resultados';

  @override
  String get commonNoResultsHint =>
      'Prueba modificando los filtros de búsqueda';

  @override
  String get commonSomethingWentWrong => 'Algo salió mal';

  @override
  String get commonErrorOccurred => 'Ha ocurrido un error';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonOr => 'o';

  @override
  String get connectivityOffline => 'Sin conexión a internet';

  @override
  String get connectivityOfflineShort => 'Sin conexión';

  @override
  String get connectivityOfflineBanner =>
      'Sin conexión - Los cambios se guardarán localmente';

  @override
  String get connectivityOfflineMode => 'Modo sin conexión';

  @override
  String get connectivityOfflineDataWarning =>
      'No hay conexión a internet. Los datos pueden no estar actualizados';

  @override
  String get errorServer => 'Error del servidor';

  @override
  String get errorCacheNotFound => 'Datos no encontrados en cache';

  @override
  String get errorNoConnection => 'Sin conexión a internet';

  @override
  String get errorTimeout => 'Tiempo de espera agotado';

  @override
  String get errorInvalidCredentials => 'Credenciales inválidas';

  @override
  String get errorSessionExpired => 'Tu sesión ha expirado';

  @override
  String get errorNoPermission => 'No tienes permiso para realizar esta acción';

  @override
  String get errorWriteCache => 'Error al escribir en cache';

  @override
  String get errorNoSession => 'No hay sesión activa';

  @override
  String get errorInvalidEmail => 'Correo electrónico inválido';

  @override
  String get errorReadFile => 'Error al leer archivo';

  @override
  String get errorWriteFile => 'Error al escribir archivo';

  @override
  String get errorDeleteFile => 'Error al eliminar archivo';

  @override
  String get errorVerifyPermissions => 'Error al verificar permisos';

  @override
  String get errorLoadingActivities => 'Error al cargar actividades';

  @override
  String get permNoCreateRecords => 'No tienes permiso para crear registros';

  @override
  String get permNoEditRecords => 'No tienes permiso para editar registros';

  @override
  String get permNoDeleteRecords => 'No tienes permiso para eliminar registros';

  @override
  String get permNoCreateBatches => 'No tienes permiso para crear lotes';

  @override
  String get permNoEditBatches => 'No tienes permiso para editar lotes';

  @override
  String get permNoDeleteBatches => 'No tienes permiso para eliminar lotes';

  @override
  String get permNoCreateSheds => 'No tienes permiso para crear galpones';

  @override
  String get permNoEditSheds => 'No tienes permiso para editar galpones';

  @override
  String get permNoDeleteSheds => 'No tienes permiso para eliminar galpones';

  @override
  String get permNoInviteUsers => 'No tienes permiso para invitar usuarios';

  @override
  String get permNoChangeRoles => 'No tienes permiso para cambiar roles';

  @override
  String get permNoRemoveUsers => 'No tienes permiso para remover usuarios';

  @override
  String get permNoViewCollaborators =>
      'No tienes permiso para ver colaboradores';

  @override
  String get permNoEditFarm => 'No tienes permiso para editar la granja';

  @override
  String get permNoDeleteFarm => 'No tienes permiso para eliminar la granja';

  @override
  String get permNoViewReports => 'No tienes permiso para ver reportes';

  @override
  String get permNoExportData => 'No tienes permiso para exportar datos';

  @override
  String get permNoManageInventory =>
      'No tienes permiso para gestionar inventario';

  @override
  String get permNoRegisterSales => 'No tienes permiso para registrar ventas';

  @override
  String get permNoViewSettings =>
      'No tienes permiso para ver la configuración';

  @override
  String get authGateManageSmartly => 'Gestiona tu granja de forma inteligente';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authAlreadyHaveAccount => 'Ya tengo cuenta';

  @override
  String get authOrContinueWith => 'o continúa con';

  @override
  String get authWelcomeBack => 'Bienvenido de vuelta';

  @override
  String get authEnterCredentials => 'Ingresa tus credenciales para continuar';

  @override
  String get authOrSignInWithEmail => 'o inicia sesión con email';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authSignIn => 'Iniciar Sesión';

  @override
  String get authForgotPassword => '¿Ha olvidado su contraseña?';

  @override
  String get authNoAccount => '¿No tienes cuenta?';

  @override
  String get authSignUp => 'Regístrate';

  @override
  String get authEmailRequired => 'El correo electrónico es requerido';

  @override
  String get authEmailInvalid => 'Ingresa un correo electrónico válido';

  @override
  String get authPasswordRequired => 'La contraseña es requerida';

  @override
  String get authPasswordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get authJoinToManage =>
      'Únete para gestionar tu granja de forma inteligente';

  @override
  String get authSignUpWithGoogle => 'Registrarse con Google';

  @override
  String get authOrSignUpWithEmail => 'o regístrate con email';

  @override
  String get authFirstName => 'Nombre';

  @override
  String get authLastName => 'Apellidos';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authMustAcceptTerms => 'Debes aceptar los términos y condiciones';

  @override
  String get authTermsAndConditions => 'Términos y Condiciones';

  @override
  String get authCheckEmail => '¡Revisa tu correo!';

  @override
  String get authForgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get authResetLinkSent =>
      'Te hemos enviado un enlace para restablecer tu contraseña';

  @override
  String get authEnterEmailForReset =>
      'Ingresa tu correo y te enviaremos instrucciones';

  @override
  String get authSendInstructions => 'Enviar instrucciones';

  @override
  String get authRememberPassword => '¿Recordaste tu contraseña?';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueWithApple => 'Continuar con Apple';

  @override
  String get authContinueWithFacebook => 'Continuar con Facebook';

  @override
  String get authContinue => 'Continuar';

  @override
  String get authEnterPassword => 'Ingresa tu contraseña';

  @override
  String get authCurrentPassword => 'Contraseña actual';

  @override
  String get authSignOut => 'Cerrar Sesión';

  @override
  String get homeQuickActions => 'Acciones Rápidas';

  @override
  String get homeVaccination => 'Vacunación';

  @override
  String get homeDiseases => 'Enfermedades';

  @override
  String get homeBiosecurity => 'Bioseguridad';

  @override
  String get homeSales => 'Ventas';

  @override
  String get homeCosts => 'Costos';

  @override
  String get homeInventory => 'Inventario';

  @override
  String get homeSelectFarmFirst => 'Selecciona una granja primero';

  @override
  String get homeGeneralStats => 'Estadísticas Generales';

  @override
  String get homeAvailableSheds => 'Galpones Libres';

  @override
  String get homeActiveBatches => 'Lotes Activos';

  @override
  String get homeTotalBirds => 'Aves Totales';

  @override
  String get homeOccupancy => 'Ocupación';

  @override
  String get homeNoSheds => 'Sin galpones';

  @override
  String get homeNoBatches => 'Sin lotes';

  @override
  String get homeAcrossFarm => 'En toda la granja';

  @override
  String get homeExpiringSoon => 'Próximos a vencer';

  @override
  String get homeHighMortality => 'Mortalidad elevada';

  @override
  String get homeNoActiveBatches => 'Sin lotes activos';

  @override
  String get homeCreateBatchToStart => 'Crea un lote para comenzar a registrar';

  @override
  String get homeGreetingMorning => 'Buenos días';

  @override
  String get homeGreetingAfternoon => 'Buenas tardes';

  @override
  String get homeGreetingEvening => 'Buenas noches';

  @override
  String get homeHello => 'Hola';

  @override
  String get profileMyAccount => 'Mi Cuenta';

  @override
  String get profileUser => 'Usuario';

  @override
  String get profileCollaboration => 'Colaboración';

  @override
  String get profileInviteToFarm => 'Invitar a mi Granja';

  @override
  String get profileShareAccess => 'Comparte acceso con otros usuarios';

  @override
  String get profileAcceptInvitation => 'Aceptar Invitación';

  @override
  String get profileJoinFarm => 'Únete a la granja de alguien más';

  @override
  String get profileManageCollaborators => 'Gestionar Colaboradores';

  @override
  String get profileViewManageAccess => 'Ver y administrar accesos';

  @override
  String get profileSettings => 'Configuración';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profileConfigureAlerts => 'Configura alertas y recordatorios';

  @override
  String get profileGeneralSettings => 'Ajustes Generales';

  @override
  String get profileAppPreferences => 'Preferencias de la aplicación';

  @override
  String get profileHelpSupport => 'Ayuda y Soporte';

  @override
  String get profileHelpCenter => 'Centro de Ayuda';

  @override
  String get profileFaqGuides => 'Preguntas frecuentes y guías';

  @override
  String get profileSendFeedback => 'Enviar Sugerencia';

  @override
  String get profileShareIdeas => 'Comparte tus ideas con nosotros';

  @override
  String get profileAbout => 'Acerca de';

  @override
  String get profileAppInfo => 'Información de la aplicación';

  @override
  String get profileSelectFarmToInvite => 'Selecciona la granja donde invitar';

  @override
  String get profileSelectFarm => 'Selecciona una granja';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguageSubtitle => 'Cambia el idioma de la aplicación';

  @override
  String get profileCurrency => 'Moneda';

  @override
  String get profileCurrencySubtitle => 'Selecciona la moneda de tu país';

  @override
  String get salesNoSales => 'Sin ventas registradas';

  @override
  String get salesNotFound => 'No se encontraron ventas';

  @override
  String get salesRegisterFirst => 'Registrar primera venta';

  @override
  String get salesRegisterNew => 'Registrar nueva venta';

  @override
  String get salesDeleteConfirm => '¿Eliminar venta?';

  @override
  String get salesProductType => 'Tipo de producto';

  @override
  String get salesStatus => 'Estado de venta';

  @override
  String get salesNewSale => 'Nueva Venta';

  @override
  String get salesEditSale => 'Editar Venta';

  @override
  String get farmFarm => 'Granja';

  @override
  String get farmFarms => 'Granjas';

  @override
  String get farmNewFarm => 'Nueva Granja';

  @override
  String get farmEditFarm => 'Editar Granja';

  @override
  String get farmDeleteConfirm => '¿Eliminar granja?';

  @override
  String get shedShed => 'Galpón';

  @override
  String get shedSheds => 'Galpones';

  @override
  String get shedNewShed => 'Nuevo Galpón';

  @override
  String get shedEditShed => 'Editar Galpón';

  @override
  String get shedDeleteConfirm => '¿Eliminar galpón?';

  @override
  String get batchBatch => 'Lote';

  @override
  String get batchBatches => 'Lotes';

  @override
  String get batchNewBatch => 'Nuevo Lote';

  @override
  String get batchEditBatch => 'Editar Lote';

  @override
  String get batchDeleteConfirm => '¿Eliminar lote?';

  @override
  String get batchActive => 'Activos';

  @override
  String get batchFinished => 'Finalizado';

  @override
  String get healthDiseases => 'Enfermedades';

  @override
  String get healthSymptoms => 'Síntomas';

  @override
  String get healthTreatment => 'Tratamiento';

  @override
  String get healthPrevention => 'Prevención';

  @override
  String get healthVaccineAvailable => 'Vacuna disponible';

  @override
  String get healthMandatoryNotification => 'Notificación obligatoria';

  @override
  String get healthPreventableByVaccine => 'Prevenible por vacunación';

  @override
  String get inventoryInventory => 'Inventario';

  @override
  String get inventoryMedicines => 'Medicamentos';

  @override
  String get inventoryVaccines => 'Vacunas';

  @override
  String get inventoryFood => 'Alimentos';

  @override
  String get costsTitle => 'Costos';

  @override
  String get costsNewCost => 'Nuevo Costo';

  @override
  String get costsEditCost => 'Editar Costo';

  @override
  String get reportsTitle => 'Reportes';

  @override
  String get reportsGenerate => 'Generar reporte';

  @override
  String get reportsGenerating => 'Generando reporte...';

  @override
  String get reportsSharePdf => 'Compartir PDF';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsEmpty => 'Sin notificaciones';

  @override
  String get mortalityTitle => 'Mortalidad';

  @override
  String get mortalityRegister => 'Registrar mortalidad';

  @override
  String get mortalityRate => 'Tasa de mortalidad';

  @override
  String get mortalityTotal => 'Mortalidad total';

  @override
  String get weightTitle => 'Peso';

  @override
  String get weightRegister => 'Registrar peso';

  @override
  String get weightAverage => 'Peso promedio';

  @override
  String get feedTitle => 'Alimentación';

  @override
  String get feedRegister => 'Registrar alimentación';

  @override
  String get feedDailyConsumption => 'Consumo diario';

  @override
  String get waterTitle => 'Agua';

  @override
  String get waterRegister => 'Registrar agua';

  @override
  String get waterDailyConsumption => 'Consumo diario';

  @override
  String get commonBack => 'Volver';

  @override
  String get commonDetails => 'Detalles';

  @override
  String get commonFilter => 'Filtrar';

  @override
  String get commonMoreOptions => 'Más opciones';

  @override
  String get commonClearSearch => 'Limpiar búsqueda';

  @override
  String get commonAll => 'Todos';

  @override
  String get commonAllTypes => 'Todos los tipos';

  @override
  String get commonAllStatuses => 'Todos los estados';

  @override
  String get commonDiscard => 'Descartar';

  @override
  String get commonComingSoon => 'Próximamente';

  @override
  String get commonUnsavedChanges => 'Cambios sin guardar';

  @override
  String get commonExitWithoutSave => '¿Deseas salir sin guardar los cambios?';

  @override
  String get commonExit => 'Salir';

  @override
  String get commonDontWorryDataSafe =>
      'No te preocupes, tus datos están seguros.';

  @override
  String get commonObservations => 'Observaciones';

  @override
  String get commonDescription => 'Descripción';

  @override
  String get commonDate => 'Fecha';

  @override
  String get commonName => 'Nombre';

  @override
  String get commonPhone => 'Teléfono';

  @override
  String get commonProvider => 'Proveedor';

  @override
  String get commonLocation => 'Ubicación';

  @override
  String get commonActive => 'Activo';

  @override
  String get commonInactive => 'Inactivo';

  @override
  String get commonPending => 'Pendientes';

  @override
  String get commonApproved => 'Aprobados';

  @override
  String get commonTotal => 'Total:';

  @override
  String get commonInformation => 'Información';

  @override
  String get commonSummary => 'Resumen';

  @override
  String get commonBasicInfo => 'Información Básica';

  @override
  String get commonAdditionalInfo => 'Información Adicional';

  @override
  String get commonNotFound => 'No encontrado';

  @override
  String get commonError => 'Error';

  @override
  String commonErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get profileLoadingFarms => 'Cargando granjas...';

  @override
  String get commonSuccess => 'Éxito';

  @override
  String get commonRegisteredBy => 'Registrado por';

  @override
  String get commonRole => 'Rol';

  @override
  String get commonRegistrationDate => 'Fecha de registro';

  @override
  String get authEmailHint => 'ejemplo@correo.com';

  @override
  String get authFirstNameHint => 'Juan';

  @override
  String get authLastNameHint => 'Pérez García';

  @override
  String get authRememberEmail => 'Recordar email';

  @override
  String get authAlreadyHaveAccountLink => '¿Ya tienes cuenta?';

  @override
  String get authSignInLink => 'Inicia sesión';

  @override
  String get authAcceptTermsPrefix => 'Acepto los ';

  @override
  String get authPrivacyPolicy => 'Política de Privacidad';

  @override
  String get authAndThe => ' y la ';

  @override
  String get authMinChars => 'Mínimo 8 caracteres';

  @override
  String get authOneUppercase => 'Una mayúscula';

  @override
  String get authOneLowercase => 'Una minúscula';

  @override
  String get authOneNumber => 'Un número';

  @override
  String get authOneSpecialChar => 'Un carácter especial';

  @override
  String get authPasswordWeak => 'Débil';

  @override
  String get authPasswordMedium => 'Media';

  @override
  String get authPasswordStrong => 'Fuerte';

  @override
  String get authPasswordConfirmRequired => 'Confirma tu contraseña';

  @override
  String get authPasswordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get authPasswordMustContainUpper =>
      'Debe contener al menos una mayúscula';

  @override
  String get authPasswordMustContainLower =>
      'Debe contener al menos una minúscula';

  @override
  String get authPasswordMustContainNumber =>
      'Debe contener al menos un número';

  @override
  String get authLinkAccounts => 'Vincular Cuentas';

  @override
  String authLinkAccountMessage(String existingProvider, String newProvider) {
    return 'Ya tienes una cuenta con este email usando $existingProvider.\n\n¿Deseas vincular tu cuenta de $newProvider para poder acceder con ambos métodos?';
  }

  @override
  String authLinkSuccess(String provider) {
    return '¡Cuenta de $provider vinculada exitosamente!';
  }

  @override
  String get authLinkButton => 'Vincular';

  @override
  String get authSentTo => 'Enviado a:';

  @override
  String get authCheckSpam => 'Si no ves el correo, revisa tu carpeta de spam';

  @override
  String get authResendEmail => 'Reenviar correo';

  @override
  String get authBackToLogin => 'Volver al inicio de sesión';

  @override
  String get authEmailPasswordProvider => 'Email y Contraseña';

  @override
  String get authPasswordMinLengthSix =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String authPasswordMinLengthN(String count) {
    return 'La contraseña debe tener al menos $count caracteres';
  }

  @override
  String authPasswordMinLengthValidator(Object count) {
    return 'Mínimo $count caracteres';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsDarkMode => 'Modo oscuro';

  @override
  String get settingsDarkModeSubtitle => 'Cambia el tema de la aplicación';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsPushNotifications => 'Notificaciones push';

  @override
  String get settingsPushSubtitle => 'Recibe alertas importantes';

  @override
  String get settingsSounds => 'Sonidos';

  @override
  String get settingsSoundsSubtitle => 'Reproduce sonidos de notificación';

  @override
  String get settingsVibration => 'Vibración';

  @override
  String get settingsVibrationSubtitle => 'Vibrar al recibir notificaciones';

  @override
  String get settingsConfigureAlerts => 'Configurar alertas';

  @override
  String get settingsConfigureAlertsSubtitle =>
      'Personaliza qué alertas recibir';

  @override
  String get settingsDataStorage => 'Datos y Almacenamiento';

  @override
  String get settingsClearCache => 'Limpiar caché';

  @override
  String get settingsClearCacheSubtitle => 'Libera espacio en el dispositivo';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsChangePassword => 'Cambiar contraseña';

  @override
  String get settingsChangePasswordSubtitle =>
      'Actualiza tu contraseña de acceso';

  @override
  String get settingsVerifyEmail => 'Verificar email';

  @override
  String get settingsVerifyEmailSubtitle => 'Confirma tu dirección de correo';

  @override
  String get settingsDangerZone => 'Zona de peligro';

  @override
  String get settingsDeleteAccountWarning =>
      'Eliminar tu cuenta borrará permanentemente todos tus datos, incluyendo granjas, lotes y registros.';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsClearCacheConfirm => '¿Limpiar caché?';

  @override
  String get settingsClearCacheMessage =>
      'Se eliminarán los datos temporales. Esto no afectará tus registros.';

  @override
  String get settingsClearCacheConfirmButton => 'Limpiar';

  @override
  String get settingsCacheClearedSuccess => 'Caché limpiado correctamente';

  @override
  String get settingsChangePasswordMessage =>
      'Te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get settingsYourEmail => 'Tu email';

  @override
  String get settingsSendLink => 'Enviar enlace';

  @override
  String get settingsResetLinkSent => 'Se ha enviado un enlace a tu correo';

  @override
  String get settingsVerificationEmailSent =>
      'Se ha enviado un correo de verificación';

  @override
  String get settingsDeleteAccountConfirm => '¿Eliminar cuenta?';

  @override
  String get settingsDeleteAccountMessage =>
      'Esta acción es irreversible y perderás todos tus datos.';

  @override
  String get profileSignOutConfirm => '¿Cerrar sesión?';

  @override
  String get profileSignOutMessage =>
      'Tendrás que volver a iniciar sesión para acceder a tu cuenta.';

  @override
  String get profileNoFarmsMessage => 'No tienes granjas. Crea una primero.';

  @override
  String get profileCreate => 'Crear';

  @override
  String get profileHelpQuestion => '¿En qué podemos ayudarte?';

  @override
  String get profileEmailSupport => 'Soporte por Email';

  @override
  String get profileFaq => 'Preguntas Frecuentes';

  @override
  String get profileFaqSubtitle => 'Consulta las dudas más comunes';

  @override
  String get profileUserManual => 'Manual de Usuario';

  @override
  String get profileUserManualSubtitle => 'Guía completa de uso';

  @override
  String get profileFeedbackQuestion =>
      '¿Tienes alguna idea para mejorar la app? Nos encantaría escucharte.';

  @override
  String get profileFeedbackHint => 'Escribe tu sugerencia aquí...';

  @override
  String get profileFeedbackThanks => '¡Gracias por tu sugerencia!';

  @override
  String get profileAppDescription =>
      'Tu aliado inteligente para la gestión avícola. Controla lotes, monitorea el rendimiento, registra vacunaciones y optimiza la producción de tu granja de manera sencilla y eficiente.';

  @override
  String get profileCopyright =>
      '© 2024 Smart Granja. Todos los derechos reservados.';

  @override
  String profileVersionText(String version) {
    return 'Versión $version';
  }

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get editProfilePersonalInfo => 'Información Personal';

  @override
  String get editProfileAccountInfo => 'Información de Cuenta';

  @override
  String get editProfileLastName => 'Apellido';

  @override
  String get editProfileMemberSince => 'Miembro desde';

  @override
  String get editProfileChangePhoto => 'Cambiar foto de perfil';

  @override
  String get editProfileTakePhoto => 'Tomar foto';

  @override
  String get editProfileChooseGallery => 'Elegir de galería';

  @override
  String get editProfilePhotoUpdated => 'Foto actualizada correctamente';

  @override
  String get editProfilePhotoError =>
      'Error al actualizar la foto. Intenta de nuevo.';

  @override
  String get editProfileImageTooLarge =>
      'La imagen excede el tamaño máximo (5MB)';

  @override
  String get editProfileDiscardChanges => '¿Descartar cambios?';

  @override
  String get editProfileDiscardMessage =>
      'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?';

  @override
  String get editProfileUnknownDate => 'Desconocido';

  @override
  String get editProfileUpdatedSuccess => 'Perfil actualizado correctamente';

  @override
  String editProfileUpdateError(String error) {
    return 'Error al actualizar: $error';
  }

  @override
  String get notifProductionAlerts => 'Alertas de Producción';

  @override
  String get notifHighMortality => 'Mortalidad elevada';

  @override
  String notifHighMortalitySubtitle(String threshold) {
    return 'Alerta cuando la mortalidad supera el $threshold%';
  }

  @override
  String get notifMortalityThreshold => 'Umbral de mortalidad';

  @override
  String get notifLowProduction => 'Baja producción';

  @override
  String notifLowProductionSubtitle(Object threshold) {
    return 'Alerta cuando la producción cae bajo el $threshold%';
  }

  @override
  String get notifProductionThreshold => 'Umbral de producción';

  @override
  String get notifAbnormalConsumption => 'Consumo anormal';

  @override
  String get notifAbnormalConsumptionSubtitle =>
      'Alerta cuando el consumo varía significativamente';

  @override
  String get notifReminders => 'Recordatorios';

  @override
  String get notifPendingVaccinations => 'Vacunaciones pendientes';

  @override
  String get notifPendingVaccinationsSubtitle =>
      'Recuerda vacunaciones programadas';

  @override
  String get notifLowInventory => 'Inventario bajo';

  @override
  String get notifLowInventorySubtitle =>
      'Alerta cuando el alimento está por agotarse';

  @override
  String get notifSummaries => 'Resúmenes';

  @override
  String get notifDailySummary => 'Resumen diario';

  @override
  String get notifDailySummarySubtitle =>
      'Recibe un resumen cada día a las 8:00 PM';

  @override
  String get notifWeeklySummary => 'Resumen semanal';

  @override
  String get notifWeeklySummarySubtitle => 'Recibe un resumen cada lunes';

  @override
  String get notifConfigSaved => 'Configuración guardada';

  @override
  String get notifSaveConfig => 'Guardar configuración';

  @override
  String farmCreatedSuccess(String name) {
    return '¡Granja \"$name\" creada!';
  }

  @override
  String farmUpdatedSuccess(Object name) {
    return '¡Granja \"$name\" actualizada!';
  }

  @override
  String get farmNotFound => 'Granja no encontrada';

  @override
  String get farmOwner => 'Propietario';

  @override
  String get farmCapacity => 'Capacidad';

  @override
  String get farmArea => 'Área';

  @override
  String get farmEmail => 'Correo';

  @override
  String get farmCreatedDate => 'Fecha de Creación';

  @override
  String get farmCollaborators => 'Colaboradores';

  @override
  String get farmInviteCollaborator => 'Invitar Colaborador';

  @override
  String farmRoleUpdated(String role) {
    return 'Rol actualizado a $role';
  }

  @override
  String get farmCodeCopied => 'Código copiado';

  @override
  String farmActivateConfirm(Object name) {
    return '¿Activar \"$name\"?';
  }

  @override
  String farmSuspendConfirm(Object name) {
    return '¿Suspender \"$name\"?';
  }

  @override
  String farmMaintenanceConfirm(Object name) {
    return '¿Poner \"$name\" en mantenimiento?';
  }

  @override
  String shedActivateConfirm(Object name) {
    return '¿Activar \"$name\"?';
  }

  @override
  String shedSuspendConfirm(Object name) {
    return '¿Suspender \"$name\"?';
  }

  @override
  String shedMaintenanceConfirm(Object name) {
    return '¿Poner \"$name\" en mantenimiento?';
  }

  @override
  String shedDisinfectionConfirm(Object name) {
    return '¿Poner \"$name\" en desinfección?';
  }

  @override
  String shedReleaseConfirm(Object name) {
    return '¿Liberar \"$name\"?';
  }

  @override
  String get shedCapacity => 'Capacidad';

  @override
  String get shedCurrentBirds => 'Actuales';

  @override
  String get shedOccupancy => 'Ocupación';

  @override
  String get shedBirds => 'Aves';

  @override
  String get shedTagExists => 'Esta etiqueta ya existe';

  @override
  String shedMaxTags(String max) {
    return 'Máximo $max etiquetas';
  }

  @override
  String get shedAddProduct => 'Agregar producto';

  @override
  String get batchCode => 'Código del Lote';

  @override
  String get batchBirdType => 'Tipo de Ave';

  @override
  String get batchBreedLine => 'Raza/Línea Genética';

  @override
  String get batchInitialCount => 'Cantidad Inicial';

  @override
  String get batchCurrentBirds => 'Aves Actuales';

  @override
  String get batchEntryDate => 'Fecha de Ingreso';

  @override
  String get batchEntryAge => 'Edad al Ingreso';

  @override
  String get batchCurrentAge => 'Edad Actual';

  @override
  String get batchCostPerBird => 'Costo por Ave';

  @override
  String get batchEstimatedClose => 'Cierre Estimado';

  @override
  String get batchSurvivalRate => 'Tasa de Supervivencia';

  @override
  String get batchAccumulatedMortality => 'Mortalidad Acumulada';

  @override
  String get batchAccumulatedDiscards => 'Descartes Acumulados';

  @override
  String get batchAccumulatedSales => 'Ventas Acumuladas';

  @override
  String get batchCurrentAvgWeight => 'Peso promedio actual';

  @override
  String get batchAccumulatedConsumption => 'Consumo Acumulado';

  @override
  String get batchFeedConversion => 'Índice Conversión';

  @override
  String get batchEggsProduced => 'Huevos Producidos';

  @override
  String get batchRemainingDays => 'Días Restantes';

  @override
  String get batchImportantInfo => 'Información importante';

  @override
  String get batchChangeStatus => 'Cambiar Estado';

  @override
  String get batchClosedSuccess => 'Lote cerrado exitosamente';

  @override
  String get batchEntryAgeDays => 'Edad de Ingreso (días)';

  @override
  String get batchSelectBatch => 'Seleccionar lote';

  @override
  String get healthApplied => 'Aplicada';

  @override
  String get healthExpired => 'Vencida';

  @override
  String get healthUpcoming => 'Próxima';

  @override
  String get healthPending => 'Pendiente';

  @override
  String get healthVaccineName => 'Nombre de la vacuna';

  @override
  String get healthVaccineNameHint => 'Ej: Newcastle + Bronquitis';

  @override
  String get healthVaccineBatch => 'Lote de la vacuna (opcional)';

  @override
  String get healthVaccineBatchHint => 'Ej: LOT123456';

  @override
  String get healthSelectInventoryVaccine =>
      'Seleccionar vacuna del inventario';

  @override
  String get healthSelectInventoryVaccineHint =>
      'Opcional - Selecciona una vacuna registrada';

  @override
  String get healthObservationsOptional => 'Observaciones (opcional)';

  @override
  String get healthObservationsHint =>
      'Reacciones observadas, notas especiales, etc.';

  @override
  String get healthTreatmentDescription => 'Descripción del tratamiento';

  @override
  String get healthTreatmentDescriptionHint =>
      'Describe el protocolo de tratamiento aplicado';

  @override
  String get healthMedications => 'Medicamentos';

  @override
  String get healthAdditionalMedications => 'Medicamentos adicionales';

  @override
  String get healthMedicationsHint => 'Ej: Enrofloxacina + Vitaminas A, D, E';

  @override
  String get healthDose => 'Dosis';

  @override
  String get healthDoseHint => 'Ej: 1ml/L';

  @override
  String get healthDurationDays => 'Duración (días)';

  @override
  String get healthDurationHint => 'Ej: 5';

  @override
  String get healthDiagnosis => 'Diagnóstico';

  @override
  String get healthDiagnosisHint => 'Ej: Enfermedad respiratoria crónica';

  @override
  String get healthSymptomsObserved => 'Síntomas observados';

  @override
  String get healthSymptomsHint =>
      'Describe los síntomas: tos, estornudos, decaimiento...';

  @override
  String get healthVeterinarian => 'Veterinario responsable';

  @override
  String get healthVeterinarianHint => 'Nombre del veterinario';

  @override
  String get healthGeneralObservations => 'Observaciones generales';

  @override
  String get healthGeneralObservationsHint =>
      'Notas adicionales, evolución esperada, etc.';

  @override
  String get healthBiosecurityObservationsHint =>
      'Describe hallazgos generales de la inspección…';

  @override
  String get healthCorrectiveActions => 'Acciones correctivas';

  @override
  String get healthCorrectiveActionsHint =>
      'Describe las acciones a implementar…';

  @override
  String get healthCompliant => 'Cumple';

  @override
  String get healthNonCompliant => 'No cumple';

  @override
  String get healthPartial => 'Parcial';

  @override
  String get healthNotApplicable => 'No aplica';

  @override
  String get healthWriteObservation => 'Escribe una observación (opcional)';

  @override
  String get healthScheduleVaccination => 'Programar Vacunación';

  @override
  String get healthVaccine => 'Vacuna';

  @override
  String get healthApplication => 'Aplicación';

  @override
  String get healthMustSelectBatch => 'Debes seleccionar un lote';

  @override
  String get healthDiseaseCatalog => 'Catálogo de Enfermedades';

  @override
  String get healthSearchDisease => 'Buscar enfermedad, síntoma...';

  @override
  String get healthAllSeverities => 'Todas';

  @override
  String get healthCritical => 'Crítica';

  @override
  String get healthSevere => 'Grave';

  @override
  String get healthModerate => 'Moderada';

  @override
  String get healthMild => 'Leve';

  @override
  String get healthRegisterTreatment => 'Registrar Tratamiento';

  @override
  String get healthBiosecurityInspection => 'Inspección de Bioseguridad';

  @override
  String get healthNewInspection => 'Nueva Inspección';

  @override
  String get healthChecklist => 'Checklist';

  @override
  String get healthInspectionSaved => 'Inspección guardada exitosamente';

  @override
  String get healthRecordDetail => 'Detalle de Registro';

  @override
  String get healthCloseTreatment => 'Cerrar Tratamiento';

  @override
  String get healthVaccinationApplied => 'Vacunación marcada como aplicada';

  @override
  String get healthVaccinationDeleted => 'Vacunación eliminada';

  @override
  String get salesDetail => 'Detalle de Venta';

  @override
  String get salesNotFoundDetail => 'Venta no encontrada';

  @override
  String get salesEditTooltip => 'Editar venta';

  @override
  String get salesClient => 'Cliente';

  @override
  String get salesDocument => 'Documento';

  @override
  String get salesBirdCount => 'Cantidad de aves';

  @override
  String get salesAvgWeight => 'Peso promedio';

  @override
  String get salesPricePerKg => 'Precio por kg';

  @override
  String get salesSubtotal => 'Subtotal';

  @override
  String get salesCarcassYield => 'Rendimiento canal';

  @override
  String get salesDiscount => 'Descuento';

  @override
  String get salesTotalAmount => 'TOTAL';

  @override
  String get salesProductDetails => 'Detalles del Producto';

  @override
  String get salesRegistrationInfo => 'Información de Registro';

  @override
  String get salesActive => 'Activas';

  @override
  String get salesCompleted => 'Completadas';

  @override
  String get salesConfirmed => 'Confirmada';

  @override
  String get salesSold => 'Vendida';

  @override
  String get salesClientName => 'Nombre completo';

  @override
  String get salesClientNameHint => 'Ej: Juan Pérez García';

  @override
  String get salesDocType => 'Tipo de documento *';

  @override
  String get salesDni => 'DNI';

  @override
  String get salesRuc => 'RUC';

  @override
  String get salesForeignCard => 'Carnet de Extranjería';

  @override
  String get salesDocNumber => 'Número de documento';

  @override
  String get salesContactPhone => 'Teléfono de contacto';

  @override
  String get salesPhoneHint => '9 dígitos';

  @override
  String get salesDraftFound => 'Borrador encontrado';

  @override
  String get salesDraftRestore =>
      '¿Deseas restaurar el borrador de venta guardado anteriormente?';

  @override
  String get salesDraftRestored => 'Borrador restaurado';

  @override
  String get costDetail => 'Detalle del Costo';

  @override
  String get costEditTooltip => 'Editar costo';

  @override
  String get costConcept => 'Concepto';

  @override
  String get costInvoiceNumber => 'Nº Factura';

  @override
  String get costTypeFood => 'Alimento';

  @override
  String get costTypeLabor => 'Mano de Obra';

  @override
  String get costTypeEnergy => 'Energía';

  @override
  String get costTypeMedicine => 'Medicamento';

  @override
  String get costTypeMaintenance => 'Mantenimiento';

  @override
  String get costTypeWater => 'Agua';

  @override
  String get costTypeTransport => 'Transporte';

  @override
  String get costTypeAdmin => 'Administrativo';

  @override
  String get costTypeDepreciation => 'Depreciación';

  @override
  String get costTypeFinancial => 'Financiero';

  @override
  String get costTypeOther => 'Otros';

  @override
  String get costDeleteConfirm => '¿Eliminar Costo?';

  @override
  String get costDeletedSuccess => 'Costo eliminado exitosamente';

  @override
  String get costNoCosts => 'Sin costos registrados';

  @override
  String get costNotFound => 'No se encontraron costos';

  @override
  String get costRegisterNew => 'Registrar Costo';

  @override
  String get costRegisterNewTooltip => 'Registrar nuevo costo';

  @override
  String get costType => 'Tipo de gasto';

  @override
  String get costDraftFound => 'Borrador encontrado';

  @override
  String get costExitConfirm => '¿Salir sin completar?';

  @override
  String get costAmount => 'Monto';

  @override
  String get costConceptHint => 'Ej: Compra de alimento balanceado';

  @override
  String get costSearchInventory => 'Buscar en inventario (opcional)...';

  @override
  String get costProviderHint => 'Nombre del proveedor o empresa';

  @override
  String get costInvoiceNumberLabel => 'Número de Factura/Recibo';

  @override
  String get costInvoiceHint => 'F001-00001234';

  @override
  String get costNotesHint => 'Notas adicionales sobre este gasto';

  @override
  String get inventoryTitle => 'Inventario';

  @override
  String get inventoryNewItem => 'Nuevo Item';

  @override
  String get inventorySearchHint => 'Buscar por nombre o código...';

  @override
  String get inventoryAddItem => 'Agregar Item';

  @override
  String get inventoryItemDetail => 'Detalle del Item';

  @override
  String get inventoryRegisterEntry => 'Registrar Entrada';

  @override
  String get inventoryRegisterExit => 'Registrar Salida';

  @override
  String get inventoryAdjustStock => 'Ajustar Stock';

  @override
  String get inventoryItemNotFound => 'Item no encontrado';

  @override
  String get inventoryItemDeleted => 'Item eliminado';

  @override
  String get inventoryBasic => 'Básico';

  @override
  String get inventoryImageSelected => 'Imagen seleccionada';

  @override
  String get inventoryItemName => 'Nombre del Item';

  @override
  String get inventoryItemNameHint => 'Ej: Concentrado Iniciador';

  @override
  String get inventoryCodeSku => 'Código/SKU (opcional)';

  @override
  String get inventoryCodeHint => 'Ej: ALI-001';

  @override
  String get inventoryDescriptionOptional => 'Descripción (opcional)';

  @override
  String get inventoryDescriptionHint =>
      'Describe las características del producto...';

  @override
  String get inventoryCurrentStock => 'Stock Actual';

  @override
  String get inventoryMinStock => 'Stock Mínimo';

  @override
  String get inventoryMaxStock => 'Stock Máximo';

  @override
  String get inventoryOptional => 'Opcional';

  @override
  String get inventoryUnitPrice => 'Precio Unitario';

  @override
  String get inventoryProviderHint => 'Nombre del proveedor';

  @override
  String get inventoryStorageLocation => 'Ubicación en Almacén';

  @override
  String get inventoryStorageHint => 'Ej: Bodega A, Estante 3';

  @override
  String get inventoryExpiration => 'Vencimiento';

  @override
  String get inventoryProviderBatch => 'Lote del Proveedor';

  @override
  String get inventoryProviderBatchHint => 'Número de lote';

  @override
  String get inventoryTakePhoto => 'Tomar Foto';

  @override
  String get inventoryGallery => 'Galería';

  @override
  String get inventoryObservation => 'Observación';

  @override
  String get inventoryObservationHint => 'Motivo u observación';

  @override
  String get inventoryPhysicalCount => 'Ej: Inventario físico';

  @override
  String get inventoryAdjustReason => 'Motivo del ajuste';

  @override
  String get inventoryStockAdjusted => 'Stock ajustado correctamente';

  @override
  String get inventorySelectProduct => 'Seleccionar producto';

  @override
  String get inventorySearchProduct => 'Buscar en inventario...';

  @override
  String get inventorySearchProductShort => 'Buscar producto...';

  @override
  String get inventoryItemOptions => 'Más opciones del item';

  @override
  String get inventoryRemoveSelection => 'Quitar selección';

  @override
  String get inventoryEnterProduct => 'Ingrese al menos un producto';

  @override
  String get inventoryEnterDescription => 'Ingrese una descripción';

  @override
  String get weightMinObserved => 'Peso mínimo observado';

  @override
  String get weightMinHint => 'Ej: 2200';

  @override
  String get batchFormWeightObsHint =>
      'Describe condiciones del pesaje, comportamiento de las aves, condiciones ambientales, etc.';

  @override
  String get weightMaxObserved => 'Peso máximo observado';

  @override
  String get weightMethod => 'Método de pesaje';

  @override
  String get weightMethodHint => 'Seleccione el método';

  @override
  String get mortalityEventDescription => 'Descripción del evento';

  @override
  String get mortalityEventDescriptionHint =>
      'Describa síntomas, contexto, condiciones ambientales...';

  @override
  String get productionInfo => 'Información';

  @override
  String get productionClassification => 'Clasificación';

  @override
  String get productionTakePhoto => 'Tomar Foto';

  @override
  String get productionGallery => 'Galería';

  @override
  String get productionEggsCollected => 'Huevos recolectados';

  @override
  String get productionEggsHint => 'Ej: 850';

  @override
  String get productionSmallEggs => 'Pequeños (S) - 43-53g';

  @override
  String get monthJan => 'Ene';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dic';

  @override
  String get commonChangeStatus => 'Cambiar estado';

  @override
  String get commonCurrentStatus => 'Estado actual:';

  @override
  String get commonSelectNewStatus => 'Seleccionar nuevo estado:';

  @override
  String get commonErrorLoading => 'Error al cargar';

  @override
  String get commonSaveChanges => 'Guardar Cambios';

  @override
  String get commonCreate => 'Crear';

  @override
  String get commonUpdate => 'Actualizar';

  @override
  String get commonRegister => 'Registrar';

  @override
  String get commonUnexpectedError => 'Error inesperado';

  @override
  String get commonSearchByNameCityAddress =>
      'Buscar por nombre, ciudad o dirección...';

  @override
  String get commonEnterReason => 'Ingrese el motivo';

  @override
  String get commonDescriptionOptional => 'Descripción (opcional)';

  @override
  String get commonState => 'Estado';

  @override
  String get commonType => 'Tipo';

  @override
  String get commonNoPhotos => 'No hay fotos agregadas';

  @override
  String get commonSelectedPhotos => 'Fotos seleccionadas';

  @override
  String get commonTakePhoto => 'Tomar Foto';

  @override
  String get commonFieldRequired => 'Este campo es obligatorio';

  @override
  String get commonInvalidValue => 'Valor inválido';

  @override
  String get commonLoadingCharts => 'Cargando gráficos...';

  @override
  String get commonNoRecordsWithFilters => 'No hay registros con estos filtros';

  @override
  String get commonFilterCosts => 'Filtrar costos';

  @override
  String get commonApplyFiltersBtn => 'Aplicar filtros';

  @override
  String get commonCloseBtn => 'Cerrar';

  @override
  String get commonSelectType => 'Seleccionar tipo';

  @override
  String get commonSelectStatus => 'Seleccionar estado';

  @override
  String get commonQuantity => 'Cantidad';

  @override
  String get commonAmount => 'Monto';

  @override
  String get commonNoData => 'Sin datos';

  @override
  String get commonRestoreBtn => 'Restaurar';

  @override
  String get commonDiscardBtn => 'Descartar';

  @override
  String get farmName => 'Nombre de la Granja';

  @override
  String get farmNameHint => 'Ej: Granja San José';

  @override
  String get farmNameRequired => 'Ingresa el nombre de la granja';

  @override
  String get farmNameMinLength => 'El nombre debe tener al menos 3 caracteres';

  @override
  String get farmOwnerName => 'Propietario';

  @override
  String get farmOwnerHint => 'Nombre completo del propietario';

  @override
  String get farmOwnerRequired => 'Ingresa el nombre del propietario';

  @override
  String get farmDescriptionOptional => 'Descripción (opcional)';

  @override
  String get farmCreateFarm => 'Crear Granja';

  @override
  String get farmSearchHint => 'Buscar por nombre, ciudad o dirección...';

  @override
  String get farmDetails => 'Detalles';

  @override
  String get farmEditTooltip => 'Editar granja';

  @override
  String get farmDeleteFarm => 'Eliminar granja';

  @override
  String get farmDashboardError => 'Error al cargar dashboard';

  @override
  String farmStatusUpdated(String status) {
    return 'Estado actualizado a $status';
  }

  @override
  String farmErrorChangingStatus(Object error) {
    return 'Error al cambiar el estado: $error';
  }

  @override
  String farmErrorDeleting(Object error) {
    return 'Error al eliminar granja: $error';
  }

  @override
  String farmErrorLoadingFarms(Object error) {
    return 'Error al cargar granjas: $error';
  }

  @override
  String get farmConfirmInvitation => 'Confirmar Invitación';

  @override
  String get farmSelectRole => 'Seleccionar Rol';

  @override
  String farmErrorVerifyingPermissions(Object error) {
    return 'Error al verificar permisos: $error';
  }

  @override
  String get farmManageCollaborators => 'Gestionar Colaboradores';

  @override
  String get farmRefresh => 'Actualizar';

  @override
  String get farmNoShedsRegistered => 'No hay galpones registrados';

  @override
  String get farmCreateFirstShed => 'Crear Primer Galpón';

  @override
  String get farmNewShed => 'Nuevo Galpón';

  @override
  String get farmTemperature => 'Temperatura';

  @override
  String get farmErrorOriginalData =>
      'Error: No se pudo obtener los datos originales de la granja';

  @override
  String get shedName => 'Nombre del Galpón *';

  @override
  String get shedNameTooLong => 'Nombre demasiado largo';

  @override
  String get shedType => 'Tipo de Galpón *';

  @override
  String get shedRegistrationDate => 'Fecha de Registro';

  @override
  String get shedNotFound => 'Galpón no encontrado';

  @override
  String get shedDetails => 'Detalles';

  @override
  String get shedEditTooltip => 'Editar galpón';

  @override
  String get shedDeleteShed => 'Eliminar galpón';

  @override
  String get shedCreated => 'Galpón creado';

  @override
  String get shedDeletedSuccess => 'Galpón eliminado correctamente';

  @override
  String shedErrorDeleting(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String shedErrorChangingStatus(Object error) {
    return 'Error al cambiar el estado: $error';
  }

  @override
  String get shedCreateShed => 'Crear Galpón';

  @override
  String get shedCreateShedTooltip => 'Crear nuevo galpón';

  @override
  String get shedSearchHint => 'Buscar por nombre, código o tipo...';

  @override
  String get shedSelectBatch => 'Seleccionar Lote';

  @override
  String get shedNoBatchesAvailable => 'No hay lotes disponibles';

  @override
  String get shedErrorLoadingBatches => 'Error al cargar lotes';

  @override
  String shedNotAvailable(Object status) {
    return 'Galpón no disponible ($status)';
  }

  @override
  String get shedScale => 'Balanza';

  @override
  String get shedTemperatureSensor => 'Temperatura';

  @override
  String get shedHumiditySensor => 'Humedad';

  @override
  String get shedCO2Sensor => 'CO2';

  @override
  String get shedAmmoniaSensor => 'Amoníaco';

  @override
  String get shedAddTag => 'Agregar etiqueta';

  @override
  String get shedSearchInventory => 'Buscar en inventario...';

  @override
  String get shedDateLabel => 'Fecha';

  @override
  String get shedStartDate => 'Fecha de inicio';

  @override
  String get shedMaintenanceDescription => 'Descripción del mantenimiento *';

  @override
  String get shedDisinfectionInfo => 'Las operaciones serán limitadas.';

  @override
  String get shedDisinfectionTitle => 'Poner en desinfección';

  @override
  String shedDisinfectionMessage(Object name) {
    return '¿Poner \"$name\" en desinfección?';
  }

  @override
  String get shedMustSpecifyQuarantine =>
      'Debe especificar el motivo de la cuarentena';

  @override
  String get shedErrorOriginalData =>
      'Error: No se pudo obtener los datos originales del galpón';

  @override
  String shedSemantics(String code, String birds, Object name, Object status) {
    return 'Galpón $name, código $code, $birds aves, estado $status';
  }

  @override
  String get batchNoActiveSheds => 'No hay galpones activos disponibles';

  @override
  String get batchNoTransitions =>
      'No hay transiciones disponibles desde este estado.';

  @override
  String get batchEnterValidQuantity => 'Ingrese una cantidad válida mayor a 0';

  @override
  String get batchEnterFinalBirdCount => 'Ingrese la cantidad final de aves';

  @override
  String get batchFieldRequired => 'Campo obligatorio';

  @override
  String get batchEnterValidNumber => 'Ingrese un número válido';

  @override
  String get batchNoRecordsMortality => 'No hay registros de mortalidad';

  @override
  String get batchLoadingFoods => 'Cargando alimentos...';

  @override
  String get batchNoFoodsInventory => 'No hay alimentos en el inventario';

  @override
  String get batchEnterValidCost => 'Ingrese un costo válido';

  @override
  String get productionInfoTitle => 'Información de Producción';

  @override
  String get productionDailyCollection =>
      'Registro diario de recolección de huevos';

  @override
  String get productionCannotExceedCollected =>
      'No puede superar los recolectados';

  @override
  String get productionRegistrationDate => 'Fecha del registro';

  @override
  String get productionAcceptableYield => 'Rendimiento aceptable';

  @override
  String get productionBelowExpected => 'Postura por debajo del esperado';

  @override
  String get productionLayingIndicator => 'Indicador de Postura';

  @override
  String get productionEggClassification => 'Clasificación de Huevos';

  @override
  String get productionQualitySizeDetail =>
      'Detalle de calidad y tamaño (opcional)';

  @override
  String get productionDefectiveEggs => 'Huevos Defectuosos';

  @override
  String get productionDirty => 'Sucios';

  @override
  String get productionSizeClassification => 'Clasificación por Tamaño';

  @override
  String productionTotalToClassify(Object count) {
    return 'Total a clasificar: $count huevos buenos';
  }

  @override
  String get productionClassificationSummary => 'Resumen de Clasificación';

  @override
  String get productionTotalClassified => 'Total clasificados';

  @override
  String get productionAvgWeightCalculated => 'Peso Promedio Calculado';

  @override
  String get productionObservationsEvidence => 'Observaciones y Evidencia';

  @override
  String get productionSummary => 'Resumen de Producción';

  @override
  String get productionLayingPercentage => 'Porcentaje de postura';

  @override
  String get productionUtilization => 'Aprovechamiento';

  @override
  String get productionAvgWeight => 'Peso promedio';

  @override
  String get productionNoPhotos => 'No hay fotos agregadas';

  @override
  String get weightInfoTitle => 'Información del Pesaje';

  @override
  String get weightAvgWeight => 'Peso promedio';

  @override
  String get weightEnterAvgWeight => 'Ingresa el peso promedio';

  @override
  String get weightBirdCount => 'Cantidad de aves pesadas';

  @override
  String get weightEnterBirdCount => 'Ingresa la cantidad de aves';

  @override
  String get weightMethodLabel => 'Método de pesaje';

  @override
  String get weightSelectMethod => 'Seleccione el método';

  @override
  String get weightDate => 'Fecha del pesaje';

  @override
  String get weightRangesTitle => 'Rangos de Peso';

  @override
  String get weightMinMaxObserved => 'Peso mínimo y máximo observado';

  @override
  String get weightEnterMinWeight => 'Ingresa el peso mínimo';

  @override
  String get weightEnterMaxWeight => 'Ingresa el peso máximo';

  @override
  String get weightSummaryTitle => 'Resumen del Pesaje';

  @override
  String get weightReviewMetrics =>
      'Revisa las métricas y agrega evidencia fotográfica';

  @override
  String get weightImportantInfo => 'Información importante';

  @override
  String get weightTotalWeight => 'Peso total';

  @override
  String get weightGDP => 'GDP (Ganancia diaria)';

  @override
  String get weightCoefficientVariation => 'Coeficiente de variación';

  @override
  String get weightRange => 'Rango de peso';

  @override
  String get weightBirdsCounted => 'Aves pesadas';

  @override
  String get mortalityBasicDetails =>
      'Detalles básicos del evento de mortalidad';

  @override
  String get salesEditLabel => 'Editar';

  @override
  String get salesDeleteLabel => 'Eliminar';

  @override
  String get salesSaleDate => 'Fecha de venta';

  @override
  String salesDetailsOf(String product) {
    return 'Detalles de $product';
  }

  @override
  String get salesEnterDetails =>
      'Ingresa cantidades, precios y otros detalles';

  @override
  String get salesBirdCountLabel => 'Cantidad de aves';

  @override
  String get salesBirdCountHint => 'Ej: 100';

  @override
  String get salesEnterBirdCount => 'Ingresa la cantidad de aves';

  @override
  String get salesQuantityGreaterThanZero => 'La cantidad debe ser mayor a 0';

  @override
  String get salesMaxQuantity => 'La cantidad máxima es 1,000,000';

  @override
  String get salesTotalWeightKg => 'Peso total (kg)';

  @override
  String get salesDressedWeightKg => 'Peso faenado total (kg)';

  @override
  String get salesEnterTotalWeight => 'Ingresa el peso total';

  @override
  String get salesWeightGreaterThanZero => 'El peso debe ser mayor a 0';

  @override
  String get salesMaxWeight => 'El peso máximo es 50,000 kg';

  @override
  String salesPricePerKgLabel(String currency) {
    return 'Precio por kg ($currency)';
  }

  @override
  String get salesNoFarmSelected =>
      'No hay una granja seleccionada. Por favor selecciona una granja primero.';

  @override
  String get salesNoActiveBatches => 'No hay lotes activos en esta granja.';

  @override
  String salesErrorLoadingBatches(Object error) {
    return 'Error al cargar lotes: $error';
  }

  @override
  String get salesFormStepDetails => 'Detalles';

  @override
  String get salesUpdatedSuccess => 'Venta actualizada correctamente';

  @override
  String get salesRegisteredSuccess => '¡Venta registrada exitosamente!';

  @override
  String get salesInventoryUpdateError =>
      'Venta registrada, pero hubo un error al actualizar inventario';

  @override
  String get salesQuantityInvalid => 'Cantidad inválida';

  @override
  String get salesQuantityExcessive => 'Cantidad excesiva';

  @override
  String get salesPriceInvalid => 'Precio inválido';

  @override
  String get salesPriceExcessive => 'Precio excesivo';

  @override
  String get salesQuantityLabel => 'Cantidad';

  @override
  String salesPricePerDozen(String currency) {
    return '$currency por docena';
  }

  @override
  String salesPollinazaQuantity(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String get salesEnterQuantity => 'Ingresa la cantidad';

  @override
  String salesPollinazaPricePerUnit(Object currency, Object unit) {
    return 'Precio por $unit ($currency)';
  }

  @override
  String get salesEditVenta => 'Editar Venta';

  @override
  String get salesLoadingError => 'Error al cargar la venta';

  @override
  String get salesTotalHuevos => 'Total huevos';

  @override
  String get salesFaenadoWeight => 'Peso faenado';

  @override
  String get salesYield => 'Rendimiento';

  @override
  String get salesUnitPrice => 'Precio unitario';

  @override
  String get salesRegistrationDate => 'Fecha de registro';

  @override
  String get salesObservations => 'Observaciones';

  @override
  String get costRegisteredSuccess => 'Costo registrado correctamente';

  @override
  String get costUpdatedSuccess => 'Costo actualizado correctamente';

  @override
  String get costSelectExpenseType => 'Por favor selecciona un tipo de gasto';

  @override
  String get costRegisterCost => 'Registrar Costo';

  @override
  String get costEditCost => 'Editar Costo';

  @override
  String get costFormStepType => 'Tipo';

  @override
  String get costFormStepAmount => 'Monto';

  @override
  String get costFormStepDetails => 'Detalles';

  @override
  String get costAmountTitle => 'Monto del Gasto';

  @override
  String get costConceptLabel => 'Concepto del gasto';

  @override
  String get costEnterConcept => 'Ingresa el concepto del gasto';

  @override
  String get costEnterAmount => 'Ingresa el monto';

  @override
  String get costEnterValidAmount => 'Ingresa un monto válido';

  @override
  String get costDateLabel => 'Fecha del gasto *';

  @override
  String get costRejectCost => 'Rechazar Costo';

  @override
  String get costRejectReasonLabel => 'Motivo del rechazo';

  @override
  String get costRejectReasonHint => 'Explica por qué se rechaza este costo';

  @override
  String get costEnterRejectReason => 'Ingresa un motivo de rechazo';

  @override
  String get costRejectBtn => 'Rechazar';

  @override
  String costDeleteMessage(String concept) {
    return '¿Estás seguro de eliminar el costo \"$concept\"?\n\nEsta acción no se puede deshacer.';
  }

  @override
  String get costDeletedSuccessMsg => 'Costo eliminado correctamente';

  @override
  String costErrorDeleting(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get costLotCosts => 'Costos del Lote';

  @override
  String get costAllCosts => 'Todos los Costos';

  @override
  String get costNoCostsDescription =>
      'Registra tus gastos operativos para llevar un control detallado de los costos de producción';

  @override
  String get costCostSummary => 'Resumen de Costos';

  @override
  String get costTotalInCosts => 'Total en costos';

  @override
  String get costApprovedCount => 'Aprobados';

  @override
  String get costPendingCount => 'Pendientes';

  @override
  String get costTotalCount => 'Total';

  @override
  String get costUserNotAuthenticated => 'Usuario no autenticado';

  @override
  String costErrorApproving(Object error) {
    return 'Error al aprobar: $error';
  }

  @override
  String costErrorRejecting(Object error) {
    return 'Error al rechazar: $error';
  }

  @override
  String get costTypeOfExpense => 'Tipo de gasto';

  @override
  String get costGeneralInfo => 'Información General';

  @override
  String get costRegistrationInfo => 'Información de Registro';

  @override
  String get costRegisteredBy => 'Registrado por';

  @override
  String get costRole => 'Rol';

  @override
  String get costRegistrationDate => 'Fecha de registro';

  @override
  String get costLastUpdate => 'Última actualización';

  @override
  String get costNoStatus => 'Sin estado';

  @override
  String get costStatusLabel => 'Estado';

  @override
  String get costLotNotFound => 'Lote no encontrado';

  @override
  String get costFarmNotFound => 'Granja no encontrada';

  @override
  String get costProviderName => 'Nombre';

  @override
  String get costDeleteConfirmTitle => 'Eliminar Costo';

  @override
  String get costDeleteConfirmMessage =>
      '¿Estás seguro de que deseas eliminar este costo?\n\nEsta acción no se puede deshacer.';

  @override
  String get costLinkedProduct => 'Producto vinculado';

  @override
  String get costStockUpdateOnSave => 'Se actualizará el stock al guardar';

  @override
  String get costLinkToFoodInventory => 'Vincular a alimento del inventario';

  @override
  String get costLinkToMedicineInventory =>
      'Vincular a medicamento del inventario';

  @override
  String get costAdditionalDetails => 'Detalles Adicionales';

  @override
  String get costComplementaryInfo => 'Información complementaria del gasto';

  @override
  String get costProviderLabel => 'Proveedor';

  @override
  String get costProviderRequired => 'Ingresa el nombre del proveedor';

  @override
  String get costProviderMinLength =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get costObservationsLabel => 'Observaciones';

  @override
  String get costFieldRequired => 'Este campo es obligatorio';

  @override
  String get costDraftRestoreMessage =>
      '¿Deseas restaurar el borrador guardado anteriormente?';

  @override
  String get costSavedMomentAgo => 'Guardado hace un momento';

  @override
  String costSavedMinutesAgo(String minutes) {
    return 'Guardado hace $minutes min';
  }

  @override
  String get inventoryConfirmDefault => 'Confirmar';

  @override
  String get inventoryCancelDefault => 'Cancelar';

  @override
  String get inventoryMovementType => 'Tipo de movimiento';

  @override
  String get inventoryEnterQuantity => 'Ingresa una cantidad';

  @override
  String get inventoryEnterValidNumber => 'Ingresa un número válido mayor a 0';

  @override
  String get inventoryQuantityExceedsStock =>
      'Cantidad mayor al stock disponible';

  @override
  String get inventoryProviderLabel => 'Proveedor';

  @override
  String get inventoryDeleteItem => 'Eliminar Item';

  @override
  String inventoryNewStock(Object unit) {
    return 'Nuevo stock ($unit)';
  }

  @override
  String get inventoryEntryRegistered => 'Entrada registrada';

  @override
  String get inventoryExitRegistered => 'Salida registrada';

  @override
  String get inventoryNoItems => 'No hay items que coincidan con los filtros';

  @override
  String get inventoryNoMovementsSearch =>
      'No hay movimientos que coincidan con tu búsqueda';

  @override
  String get inventoryNoMovements => 'No hay movimientos registrados aún';

  @override
  String get inventoryEditItem => 'Editar Item';

  @override
  String get inventoryNoProductsAvailable => 'No hay productos disponibles';

  @override
  String get inventoryErrorLoading => 'Error al cargar inventario';

  @override
  String get inventoryHistoryError => 'Error al cargar movimientos';

  @override
  String get inventoryHistoryNoFilters =>
      'No hay movimientos con los filtros aplicados';

  @override
  String get inventoryMovementTypeLabel => 'Tipo de movimiento';

  @override
  String get inventoryList => 'Lista';

  @override
  String get inventoryNoImage => 'No hay imagen agregada';

  @override
  String get inventoryExpirationDateOptional =>
      'Fecha de vencimiento (opcional)';

  @override
  String get inventorySelectDate => 'Seleccionar fecha';

  @override
  String get inventoryAdditionalDetails => 'Detalles Adicionales';

  @override
  String get inventoryStockSummary => 'Stock';

  @override
  String get inventoryTotalItems => 'Total Items';

  @override
  String get inventoryLowStock => 'Stock Bajo';

  @override
  String get inventoryOutOfStock => 'Agotados';

  @override
  String get inventoryExpiringSoon => 'Por Vencer';

  @override
  String get inventoryDescriptionLabel => 'Descripción';

  @override
  String get inventoryRegistrationDate => 'Fecha de registro';

  @override
  String get inventoryLastUpdate => 'Última actualización';

  @override
  String get inventoryRegisteredBy => 'Registrado por';

  @override
  String inventoryError(Object error) {
    return 'Error: $error';
  }

  @override
  String get inventoryItemFormType => 'Tipo';

  @override
  String get inventoryItemFormBasic => 'Básico';

  @override
  String get inventoryItemFormStock => 'Stock';

  @override
  String get inventoryItemFormDetails => 'Detalles';

  @override
  String get inventoryImageError => 'Error al seleccionar imagen';

  @override
  String get inventoryImageUploadFailed => 'No se pudo subir la imagen';

  @override
  String get inventoryImageSaveWithout => 'El item se guardará sin imagen';

  @override
  String get inventorySaveBtn => 'Guardar';

  @override
  String get healthSelectLocation => 'Seleccionar Ubicación';

  @override
  String get healthSelectBatch => 'Seleccionar Lote';

  @override
  String get healthErrorLoadingFarms => 'Error al cargar granjas';

  @override
  String get healthNoActiveBatches => 'No hay lotes activos';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonPrevious => 'Anterior';

  @override
  String get commonSaving => 'Guardando...';

  @override
  String get commonSavedJustNow => 'Guardado ahora mismo';

  @override
  String commonSavedSecondsAgo(String seconds) {
    return 'Guardado hace ${seconds}s';
  }

  @override
  String commonSavedMinutesAgo(Object minutes) {
    return 'Guardado hace ${minutes}m';
  }

  @override
  String commonSavedHoursAgo(String hours) {
    return 'Guardado hace ${hours}h';
  }

  @override
  String get commonExitWithoutComplete => '¿Salir sin completar?';

  @override
  String get commonVerifyConnection => 'Verifica tu conexión a internet';

  @override
  String get commonOperationSuccess => 'Operación exitosa';

  @override
  String get farmStartFirstFarm => 'Comienza tu primera granja';

  @override
  String get farmStartFirstFarmDesc =>
      'Registra tu granja avícola y comienza a gestionar tu producción de manera eficiente';

  @override
  String get farmNoFarmsFound => 'No se encontraron granjas';

  @override
  String get farmNoFarmsFoundHint =>
      'Intenta ajustar los filtros o buscar con otros términos';

  @override
  String get farmCreateNewFarmTooltip => 'Crear nueva granja';

  @override
  String get farmDeletedSuccess => 'Granja eliminada correctamente';

  @override
  String get farmFarmNotExists => 'La granja solicitada no existe';

  @override
  String get farmGeneralInfo => 'Información General';

  @override
  String get farmNotes => 'Notas';

  @override
  String get farmActivate => 'Activar';

  @override
  String get farmActivateFarm => 'Activar granja';

  @override
  String farmActivateConfirmMsg(Object name) {
    return '¿Activar \"$name\"?';
  }

  @override
  String get farmActivateInfo => 'Podrás operar normalmente.';

  @override
  String get farmSuspend => 'Suspender';

  @override
  String get farmSuspendFarm => 'Suspender granja';

  @override
  String farmSuspendConfirmMsg(Object name) {
    return '¿Suspender \"$name\"?';
  }

  @override
  String get farmSuspendInfo => 'No podrás crear nuevos lotes.';

  @override
  String get farmMaintenanceFarm => 'Poner en mantenimiento';

  @override
  String farmMaintenanceConfirmMsg(Object name) {
    return '¿Poner \"$name\" en mantenimiento?';
  }

  @override
  String get farmMaintenanceInfo => 'Las operaciones serán limitadas.';

  @override
  String farmDeleteConfirmName(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get farmDeleteIrreversible => 'Esta acción es irreversible:';

  @override
  String get farmDeleteWillRemoveShedsAll =>
      '• Se eliminarán todos los galpones\n• Se eliminarán todos los lotes\n• Se eliminarán todos los registros';

  @override
  String get farmWriteNameToConfirm => 'Escribe el nombre para confirmar:';

  @override
  String get farmWriteHere => 'Escribe aquí';

  @override
  String get farmAlreadyActive => 'La granja ya está activa';

  @override
  String get farmAlreadySuspended => 'La granja ya está suspendida';

  @override
  String get farmActivatedSuccess => 'Granja activada exitosamente';

  @override
  String get farmSuspendedSuccess => 'Granja suspendida exitosamente';

  @override
  String get farmMaintenanceSuccess => 'Granja puesta en mantenimiento';

  @override
  String get farmDraftFound => 'Borrador encontrado';

  @override
  String farmDraftFoundMsg(String date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String farmTodayAt(String time) {
    return 'hoy a las $time';
  }

  @override
  String get farmYesterday => 'ayer';

  @override
  String farmDaysAgo(String days) {
    return 'hace $days días';
  }

  @override
  String get farmEnterBasicData =>
      'Ingresa los datos principales de tu granja avícola';

  @override
  String get farmInfoUsedToIdentify =>
      'Estos datos se utilizarán para identificar tu granja en el sistema.';

  @override
  String get farmUserNotAuthenticated => 'Usuario no autenticado';

  @override
  String get farmFilterAll => 'Todas';

  @override
  String get farmFilterActive => 'Activas';

  @override
  String get farmFilterInactive => 'Inactivas';

  @override
  String get farmFilterMaintenance => 'Mantenimiento';

  @override
  String farmSemantics(Object name, Object status) {
    return 'Granja $name, estado $status';
  }

  @override
  String get farmViewSheds => 'Ver Galpones';

  @override
  String get farmStatusActiveDesc => 'Operando normalmente';

  @override
  String get farmStatusInactiveDesc => 'Operaciones suspendidas';

  @override
  String get farmStatusMaintenanceDesc => 'En proceso de mantenimiento';

  @override
  String get farmContinueEditing => 'Continuar editando';

  @override
  String get farmSelectCountry => 'Selecciona el país';

  @override
  String get farmSelectDepartment => 'Selecciona el departamento';

  @override
  String get farmSelectCity => 'Selecciona la ciudad';

  @override
  String get farmEnterAddress => 'Ingresa la dirección';

  @override
  String get farmAddressMinLength =>
      'La dirección debe tener al menos 10 caracteres';

  @override
  String get farmEnterEmail => 'Ingresa el correo electrónico';

  @override
  String get farmEnterValidEmail => 'Ingresa un correo válido';

  @override
  String get farmEnterPhone => 'Ingresa el teléfono';

  @override
  String farmPhoneLength(String length) {
    return 'El teléfono debe tener $length dígitos';
  }

  @override
  String get farmOnlyActiveCanMaintenance =>
      'Solo se puede poner en mantenimiento una granja activa';

  @override
  String get farmInfoCopiedToClipboard => 'Información copiada al portapapeles';

  @override
  String get farmTotalOccupation => 'Ocupación Total';

  @override
  String get farmBirds => 'aves';

  @override
  String farmOfCapacityBirds(String capacity) {
    return 'de $capacity aves';
  }

  @override
  String get farmActiveSheds => 'Casas Activas';

  @override
  String farmOfTotal(String total) {
    return 'de $total';
  }

  @override
  String get farmBatchesInProduction => 'Lotes en Producción';

  @override
  String farmMoreSheds(Object count) {
    return '+ $count galpón(es) más';
  }

  @override
  String get shedOccupation => 'Ocupación';

  @override
  String shedBirdsCount(String current, Object max) {
    return '$current / $max aves';
  }

  @override
  String get commonViewAll => 'Ver Todos';

  @override
  String commonErrorWithDetail(Object error) {
    return 'Error: $error';
  }

  @override
  String get commonSummary2 => 'Resumen';

  @override
  String get commonMaintShort => 'Mant.';

  @override
  String get commonMaintenance => 'Mantenimiento';

  @override
  String get commonNotDefined => 'No definido';

  @override
  String get commonOccurredError => 'Ocurrió un error';

  @override
  String get commonFieldIsRequired => 'Este campo es obligatorio';

  @override
  String commonFieldRequired2(String label) {
    return '$label es requerido';
  }

  @override
  String commonSelect(String field) {
    return 'Selecciona $field';
  }

  @override
  String commonFirstSelect(Object field) {
    return 'Primero selecciona $field';
  }

  @override
  String get commonMustBeValidNumber => 'Debe ser un número válido';

  @override
  String commonMustBeBetween(String min, Object max) {
    return 'Debe estar entre $min y $max';
  }

  @override
  String get commonEnterValidNumber => 'Ingresa un número válido';

  @override
  String get commonVerifying => 'Verificando...';

  @override
  String get commonJoining => 'Uniéndose...';

  @override
  String get commonUpdate2 => 'Actualizar';

  @override
  String get commonRefresh => 'Actualizar';

  @override
  String get commonYouTag => 'Tú';

  @override
  String get commonNoName => 'Sin nombre';

  @override
  String get commonNoEmail => 'Sin correo';

  @override
  String commonSince(Object date) {
    return 'Desde: $date';
  }

  @override
  String get commonPermissions => 'Permisos';

  @override
  String get commonSelected => 'Seleccionado';

  @override
  String get commonShare => 'Compartir';

  @override
  String commonValidUntil(Object date) {
    return 'Válido hasta $date';
  }

  @override
  String get farmEnvironmentalThresholds => 'Umbrales Ambientales';

  @override
  String get farmHumidity => 'Humedad';

  @override
  String get farmCo2Max => 'CO₂ Máximo';

  @override
  String get farmAmmoniaMax => 'Amoníaco Máximo';

  @override
  String get farmCapacityInstallations => 'Capacidad e Instalaciones';

  @override
  String get farmTechnicalDataOptional =>
      'Datos técnicos de la granja (todos opcionales)';

  @override
  String get farmMaxBirdCapacity => 'Capacidad Máxima de Aves';

  @override
  String get farmMaxBirdsLimit => 'Máximo 1,000,000 aves';

  @override
  String get farmTotalArea => 'Área Total';

  @override
  String get farmNumberOfSheds => 'Número de Galpones';

  @override
  String get farmShedsUnit => 'galpones';

  @override
  String get farmMaxShedsLimit => 'Máximo 100 galpones';

  @override
  String get farmUsefulInfo => 'Información útil';

  @override
  String get farmTechnicalDataHelp =>
      'Estos datos ayudarán a planificar lotes y calcular densidad poblacional.';

  @override
  String get farmPreciseLocation => 'Ubicación precisa';

  @override
  String get farmLocationHelp =>
      'Una ubicación correcta facilita la logística y visitas técnicas.';

  @override
  String get farmExactLocation => 'Ubicación exacta de la granja';

  @override
  String get farmAddress => 'Dirección';

  @override
  String get farmAddressHint => 'Ej: Av. Principal 123, Urbanización...';

  @override
  String get farmReferenceOptional => 'Referencia (opcional)';

  @override
  String get farmReferenceHint => 'Cerca de..., frente a..., a 2 cuadras de...';

  @override
  String get farmGpsCoordinatesOptional => 'Coordenadas GPS (opcional)';

  @override
  String get farmLatitude => 'Latitud';

  @override
  String get farmLatitudeHint => 'Ej: -12.0464';

  @override
  String get farmLongitude => 'Longitud';

  @override
  String get farmLongitudeHint => 'Ej: -77.0428';

  @override
  String get farmContactInfo => 'Información de Contacto';

  @override
  String get farmContactInfoDesc => 'Datos de contacto para comunicación';

  @override
  String get farmEmailLabel => 'Correo Electrónico';

  @override
  String get farmEmailHint => 'ejemplo@correo.com';

  @override
  String get farmWhatsappOptional => 'WhatsApp (opcional)';

  @override
  String get farmContactDataTitle => 'Datos de contacto';

  @override
  String get farmContactDataHelp =>
      'Esta información se usará para notificaciones importantes.';

  @override
  String get farmPhoneLabel => 'Teléfono';

  @override
  String farmFiscalDocOptional(Object label) {
    return '$label (opcional)';
  }

  @override
  String get farmInvalidRifFormat =>
      'Formato de RIF inválido (ej: J-12345678-9)';

  @override
  String farmRucMustHaveDigits(Object count) {
    return 'El RUC debe tener $count dígitos';
  }

  @override
  String get farmInvalidNitFormat =>
      'Formato de NIT inválido (ej: 900123456-7)';

  @override
  String get farmRucMustStartWith => 'El RUC debe iniciar con 10, 15, 17 o 20';

  @override
  String get farmCapacityHint => 'Ej: 10000';

  @override
  String get farmAreaHint => 'Ej: 5000';

  @override
  String get farmShedsHint => 'Ej: 5';

  @override
  String get farmActiveFarmsLabel => 'Activas';

  @override
  String get farmInactiveFarmsLabel => 'Inactivas';

  @override
  String get farmStatusActive => 'Activa';

  @override
  String get farmStatusInactive => 'Inactiva';

  @override
  String get farmOverpopulationDetected => 'Sobrepoblación detectada';

  @override
  String get farmOutdatedData => 'Datos desactualizados';

  @override
  String get farmShedsWithoutBatches => 'Galpones sin lotes asignados';

  @override
  String get farmLoadDashboardError => 'Error al cargar dashboard';

  @override
  String get farmActiveBatches => 'Lotes Activos';

  @override
  String get farmActiveShedsLabel => 'Galpones Activos';

  @override
  String get farmAlertsTitle => 'Alertas';

  @override
  String get farmInviteUser => 'Invitar Usuario';

  @override
  String get farmMustLoginToInvite =>
      'Debes iniciar sesión para invitar usuarios';

  @override
  String get farmNoPermToInvite =>
      'No tienes permisos para invitar usuarios a esta granja.\nSolo propietarios, administradores y gestores pueden invitar.';

  @override
  String get farmNoPermissions => 'Sin Permisos';

  @override
  String get farmWhatRoleWillUserHave => '¿Qué rol tendrá el usuario?';

  @override
  String get farmChoosePermissions =>
      'Elige los permisos que tendrá en tu granja';

  @override
  String get farmRoleFullControl => 'Control total de la granja';

  @override
  String get farmRoleFullManagement =>
      'Gestión completa, sin transferir propiedad';

  @override
  String get farmRoleOperationsMgmt => 'Gestión de operaciones y personal';

  @override
  String get farmRoleDailyRecords => 'Registros diarios y tareas operativas';

  @override
  String get farmRoleViewOnly => 'Solo visualización de datos';

  @override
  String get farmPermAll => 'Todo';

  @override
  String get farmPermEdit => 'Editar';

  @override
  String get farmPermInvite => 'Invitar';

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
    return 'Error al verificar permisos: $error';
  }

  @override
  String get farmGenerateCode => 'Generar Código';

  @override
  String get farmGenerateNewCode => 'Generar nuevo código';

  @override
  String get farmCodeGenerated => '¡Código generado!';

  @override
  String farmInvitationSubject(Object farmName) {
    return 'Invitación a $farmName';
  }

  @override
  String farmInvitationMessage(
    String farmName,
    String code,
    String role,
    String expiry,
  ) {
    return '¡Te invito a colaborar en mi granja \"$farmName\"! Usa el código: $code\nRol: $role\nVálido hasta: $expiry';
  }

  @override
  String farmCollaboratorsCount(Object count) {
    return '$count colaborador(es)';
  }

  @override
  String get farmInviteCollaboratorToFarm => 'Invitar colaborador a la granja';

  @override
  String get farmNoCollaborators => 'Sin colaboradores';

  @override
  String get farmInviteHelpText =>
      'Invita a otros usuarios para que puedan ayudarte a gestionar esta granja.';

  @override
  String get farmChangeRoleTo => 'Cambiar rol a:';

  @override
  String get farmLeaveFarm => 'Abandonar granja';

  @override
  String get farmRemoveUser => 'Remover usuario';

  @override
  String get farmCannotChangeOwnerRole =>
      'No se puede cambiar el rol del propietario';

  @override
  String get farmCannotRemoveOwner => 'No se puede remover al propietario';

  @override
  String get farmRemoveCollaborator => 'Remover Colaborador';

  @override
  String get farmConfirmLeave =>
      '¿Estás seguro de que deseas abandonar esta granja?';

  @override
  String get farmConfirmRemoveUser =>
      '¿Estás seguro de que deseas remover a este usuario?';

  @override
  String get farmLeaveAction => 'Abandonar';

  @override
  String get farmRemoveAction => 'Remover';

  @override
  String get farmLeftFarm => 'Has abandonado la granja';

  @override
  String get farmCollaboratorRemoved => 'Colaborador removido';

  @override
  String get farmJoinFarm => 'Unirse a Granja';

  @override
  String get farmCodeValid => '¡Código válido!';

  @override
  String get farmInvitedBy => 'Invitado por';

  @override
  String get farmWhatRoleYouWillHave => '¿Qué rol tendrás?';

  @override
  String get farmJoinTheFarm => 'Unirse a la Granja';

  @override
  String get farmUseAnotherCode => 'Usar otro código';

  @override
  String get farmWelcome => '¡Bienvenido!';

  @override
  String get farmJoinedSuccessTo => 'Te has unido exitosamente a';

  @override
  String farmAsRole(Object role) {
    return 'Como $role';
  }

  @override
  String get farmViewMyFarms => 'Ver Mis Granjas';

  @override
  String get farmHaveInvitation => '¿Tienes una invitación?';

  @override
  String get farmEnterSharedCode =>
      'Ingresa el código que te compartieron para unirte a una granja';

  @override
  String get farmInvitationCode => 'Código de Invitación';

  @override
  String get farmVerifyCode => 'Verificar Código';

  @override
  String get farmEnterValidCode => 'Ingresa un código válido';

  @override
  String get farmInvalidCodeFormat => 'El formato del código no es válido';

  @override
  String get farmCodeNotFound => 'Código de invitación no encontrado';

  @override
  String get farmCodeAlreadyUsed => 'Este código ya ha sido utilizado';

  @override
  String get farmCodeExpired => 'Este código ha expirado';

  @override
  String get farmCodeNotValidOrExpired =>
      'Código de invitación no válido o expirado';

  @override
  String get farmCodeHasExpiredLong => 'Este código de invitación ha expirado';

  @override
  String get farmMustLoginToAccept =>
      'Debes iniciar sesión para aceptar invitaciones';

  @override
  String get farmAlreadyMember => 'Ya eres miembro de esta granja';

  @override
  String get farmAssigned => 'Asignado';

  @override
  String get farmGranjaLabel => 'Granja';

  @override
  String get farmPermFullControl => 'Control total';

  @override
  String get farmPermFullManagement => 'Gestión completa';

  @override
  String get farmPermDeleteFarm => 'Eliminar granja';

  @override
  String get farmPermEditData => 'Editar datos';

  @override
  String get farmPermInviteUsers => 'Invitar usuarios';

  @override
  String get farmPermManageCollaborators => 'Gestionar colaboradores';

  @override
  String get farmPermViewRecords => 'Ver registros';

  @override
  String get farmPermCreateRecords => 'Crear registros';

  @override
  String get farmPermRegisterTasks => 'Registrar tareas';

  @override
  String get farmPermViewStats => 'Ver estadísticas';

  @override
  String get farmPermissions => 'Permisos';

  @override
  String get commonGoToHome => 'Ir al Inicio';

  @override
  String get farmTheFarm => 'la granja';

  @override
  String get commonCheckConnection => 'Verifica tu conexión.';

  @override
  String get commonExitWithoutSaving => '¿Salir sin guardar?';

  @override
  String get commonYouHaveUnsavedChanges => 'Tienes cambios sin guardar.';

  @override
  String get commonContinueEditing => 'Continuar editando';

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
  String get commonYesterday => 'ayer';

  @override
  String commonDaysAgo(Object days) {
    return 'hace $days días';
  }

  @override
  String commonTodayAt(Object time) {
    return 'hoy a las $time';
  }

  @override
  String commonSavedAt(Object time) {
    return 'Guardado $time';
  }

  @override
  String get commonActivePlural => 'Activos';

  @override
  String get commonInactivePlural => 'Inactivos';

  @override
  String get commonAdjustFilters =>
      'Intenta ajustar los filtros o buscar con otros términos';

  @override
  String get shedStepBasic => 'Básico';

  @override
  String get shedStepSpecifications => 'Especificaciones';

  @override
  String get shedStepEnvironment => 'Ambiente';

  @override
  String get shedDraftFound => 'Borrador encontrado';

  @override
  String shedDraftFoundMessage(Object date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String shedCreatedSuccess(Object name) {
    return '¡Galpón \"$name\" creado!';
  }

  @override
  String shedUpdatedSuccess(Object name) {
    return '¡Galpón \"$name\" actualizado!';
  }

  @override
  String get shedExitWithoutCompleting => '¿Salir sin completar?';

  @override
  String get shedDataIsSafe => 'No te preocupes, tus datos están seguros.';

  @override
  String get shedStartFirstShed => 'Comienza tu primer galpón';

  @override
  String get shedStartFirstShedDesc =>
      'Registra tu primer galpón avícola y comienza a gestionar la producción';

  @override
  String get shedNoShedsFound => 'No se encontraron galpones';

  @override
  String get shedDeletedMsg => 'Galpón eliminado';

  @override
  String get shedDeletedCorrectly => 'Galpón eliminado correctamente';

  @override
  String get shedChangeStatus => 'Cambiar estado';

  @override
  String get shedGeneralInfo => 'Información General';

  @override
  String get shedInfrastructure => 'Infraestructura';

  @override
  String get shedSensorsEquipment => 'Sensores y Equipamiento';

  @override
  String get shedGeneralStats => 'Estadísticas Generales';

  @override
  String get shedByStatus => 'Por estado';

  @override
  String get shedNoTags => 'Sin etiquetas';

  @override
  String get shedRequestedNotExist => 'El galpón solicitado no existe';

  @override
  String get shedDisinfection => 'Desinfección';

  @override
  String get shedQuarantine => 'Cuarentena';

  @override
  String get shedSelectType => 'Selecciona el tipo de galpón';

  @override
  String get shedEnterBirdCapacity => 'Ingresa la capacidad de aves';

  @override
  String get shedCapacityMustBePositive => 'La capacidad debe ser mayor a 0';

  @override
  String get shedCapacityTooHigh => 'La capacidad parece muy alta';

  @override
  String get shedEnterArea => 'Ingresa el área en m²';

  @override
  String get shedAreaMustBePositive => 'El área debe ser mayor a 0';

  @override
  String get shedAreaTooLarge => 'El área parece muy grande';

  @override
  String get shedEnterMaxTemp => 'Ingresa la temperatura máxima';

  @override
  String get shedEnterMinTemp => 'Ingresa la temperatura mínima';

  @override
  String get shedTempMinLessThanMax =>
      'La temperatura mínima debe ser menor que la máxima';

  @override
  String get shedEnterMaxHumidity => 'Ingresa la humedad máxima';

  @override
  String get shedEnterMinHumidity => 'Ingresa la humedad mínima';

  @override
  String get shedHumidityMinLessThanMax =>
      'La humedad mínima debe ser menor que la máxima';

  @override
  String get shedBasicInfo => 'Información Básica';

  @override
  String get shedBasicInfoDesc =>
      'Ingresa los datos principales del galpón avícola';

  @override
  String get shedNameHint => 'Ej: Galpón Principal, Ponedoras Norte';

  @override
  String get shedMinChars => 'Mínimo 3 caracteres';

  @override
  String get shedDescriptionOptional => 'Descripción (opcional)';

  @override
  String get shedDescriptionHint =>
      'Describe las características principales del galpón...';

  @override
  String get shedSelectShedType => 'Selecciona un tipo de galpón';

  @override
  String get shedImportantInfo => 'Información importante';

  @override
  String get shedCodeAutoGenerated =>
      'El código del galpón se genera automáticamente basado en el nombre de la granja y el número de galpones existentes.';

  @override
  String get shedSpecsDesc =>
      'Configure la capacidad y el equipamiento del galpón';

  @override
  String get shedMaxBirdCapacity => 'Capacidad Máxima de Aves';

  @override
  String get shedMustBeValidNumber => 'Debe ser un número válido';

  @override
  String get shedMustBePositiveNumber => 'Debe ser un número positivo';

  @override
  String get shedNumberTooLarge => 'El número es demasiado grande';

  @override
  String get shedTotalArea => 'Área Total';

  @override
  String get shedAreaRequired => 'El área es requerida';

  @override
  String get shedNumberSeemsHigh => 'El número parece muy alto';

  @override
  String get shedUsefulInfo => 'Información útil';

  @override
  String get shedDensityPlanningHelp =>
      'Estos datos ayudarán a planificar lotes y calcular densidad poblacional.';

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
  String get shedRelativeHumidity => 'Humedad Relativa';

  @override
  String get shedInvalidHumidityRange => 'Valor inválido (0-100)';

  @override
  String get shedVentilation => 'Ventilación';

  @override
  String get shedInvalidValue => 'Valor inválido';

  @override
  String get shedEnvironmentalAlertHelp =>
      'Los valores ambientales configurados se usarán para generar alertas automáticas cuando las condiciones reales estén fuera del rango especificado.';

  @override
  String get shedShedType => 'Tipo de Galpón';

  @override
  String get shedMaxCapacity => 'Capacidad Máxima';

  @override
  String get shedCurrentBirdsLabel => 'Aves Actuales';

  @override
  String shedCurrentBirdsValue(Object count) {
    return '$count aves';
  }

  @override
  String get shedOccupationLabel => 'Ocupación';

  @override
  String get shedAreaLabel => 'Área';

  @override
  String get shedLocationLabel => 'Ubicación';

  @override
  String get shedOccupationTitle => 'Ocupación del Galpón';

  @override
  String get shedOptimal => 'Óptimo';

  @override
  String get shedAdjust => 'Ajustar';

  @override
  String get shedVentilationSystem => 'Sistema de Ventilación';

  @override
  String get shedHeatingSystem => 'Sistema de Calefacción';

  @override
  String get shedLightingSystem => 'Sistema de Iluminación';

  @override
  String get shedAmmonia => 'Amoníaco';

  @override
  String get shedAssignBatch => 'Asignar lote';

  @override
  String get shedRegisterDisinfection => 'Registrar\nDesinfección';

  @override
  String shedDisinfectedDaysAgo(Object days) {
    return 'Desinfectado hace $days días';
  }

  @override
  String shedMaintenanceOverdue(Object days) {
    return 'Mantenimiento vencido hace $days días';
  }

  @override
  String get shedMaintenanceToday => 'Mantenimiento programado para hoy';

  @override
  String shedMaintenanceInDays(Object days) {
    return 'Mantenimiento en $days días';
  }

  @override
  String get shedViewBatches => 'Ver Lotes';

  @override
  String get shedRegisterDisinfectionAction => 'Registrar\nDesinfección';

  @override
  String get shedActiveBatch => 'Lote Activo';

  @override
  String get shedAvailableForNewBatch =>
      'Este galpón está disponible para recibir un nuevo lote';

  @override
  String get shedAssignBatchLabel => 'Asignar Lote';

  @override
  String shedNotAvailableForBatch(Object status) {
    return 'Galpón no disponible ($status)';
  }

  @override
  String get shedNotAvailableForAssign =>
      'El galpón no está disponible para asignar lotes';

  @override
  String get shedNoBatchAssigned => 'El galpón no tiene lote asignado';

  @override
  String get shedInfoCopied => 'Información copiada al portapapeles';

  @override
  String get shedCannotDeleteWithBatch =>
      'No se puede eliminar un galpón con lote asignado';

  @override
  String get shedSelectBatchForAssign =>
      'Selecciona un lote para asignar al galpón';

  @override
  String get shedHistoryTitle => 'Historial del Galpón';

  @override
  String get shedEventsAppearHere => 'Los eventos del galpón aparecerán aquí';

  @override
  String get shedCreatedEvent => 'Galpón creado';

  @override
  String shedCreatedEventDesc(Object name) {
    return 'Se registró el galpón $name';
  }

  @override
  String get shedDisinfectionDone => 'Desinfección realizada';

  @override
  String get shedDisinfectionDoneDesc => 'Se realizó desinfección del galpón';

  @override
  String get shedMaintenanceOverdueEvent => 'Mantenimiento vencido';

  @override
  String get shedMaintenanceScheduledEvent => 'Mantenimiento programado';

  @override
  String get shedMaintenanceOverdueDesc =>
      'El mantenimiento estaba programado para esta fecha';

  @override
  String get shedMaintenanceScheduledDesc => 'Próximo mantenimiento del galpón';

  @override
  String get shedBatchFinished => 'Lote finalizado';

  @override
  String shedBatchFinishedDesc(String id) {
    return 'Se finalizó el lote $id';
  }

  @override
  String get shedLastUpdate => 'Última actualización';

  @override
  String get shedLastUpdateDesc => 'Se actualizó la información del galpón';

  @override
  String get shedOccupancyLevel => 'Nivel de ocupación';

  @override
  String get shedAssignedBatch => 'Lote asignado';

  @override
  String get shedLastDisinfection => 'Última desinfección';

  @override
  String get shedNextMaintenance => 'Próximo mantenimiento';

  @override
  String shedDaysAgoLabel(Object days) {
    return 'Hace $days días';
  }

  @override
  String shedOverdueDaysAgo(Object days) {
    return 'Vencido hace $days días';
  }

  @override
  String get shedToday => 'Hoy';

  @override
  String shedInDays(Object days) {
    return 'En $days días';
  }

  @override
  String get shedStatsTitle => 'Estadísticas de Galpones';

  @override
  String get shedTotalCapacity => 'Capacidad Total';

  @override
  String get shedTotalBirds => 'Aves Totales';

  @override
  String get shedStatsRealtime =>
      'Las estadísticas se actualizan en tiempo real';

  @override
  String get shedViewActiveBatch => 'Ver Lote Activo';

  @override
  String get shedFilterSheds => 'Filtrar galpones';

  @override
  String get shedSelectStatus => 'Seleccionar estado';

  @override
  String get shedSelectTypeFilter => 'Seleccionar tipo';

  @override
  String get shedMinCapacity => 'Capacidad minima';

  @override
  String get shedActivateTitle => 'Activar galpón';

  @override
  String get shedActivateAction => 'Activar';

  @override
  String get shedActivateInfo => 'Podrás operar normalmente.';

  @override
  String get shedSuspendTitle => 'Suspender galpón';

  @override
  String get shedSuspendAction => 'Suspender';

  @override
  String get shedSuspendInfo => 'No podrás crear nuevos lotes.';

  @override
  String get shedMaintenanceTitle => 'Poner en mantenimiento';

  @override
  String get shedMaintenanceInfo => 'Las operaciones serán limitadas.';

  @override
  String get shedDisinfectionAction => 'Confirmar';

  @override
  String get shedDisinfectionAvailInfo => 'El galpón no estará disponible.';

  @override
  String get shedReleaseTitle => 'Liberar galpón';

  @override
  String get shedReleaseAction => 'Liberar';

  @override
  String get shedReleaseInfo => 'El lote actual será desvinculado.';

  @override
  String get shedDeleteTitle => 'Eliminar galpón';

  @override
  String shedDeleteConfirmMsg(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get shedDeleteIrreversible => 'Esta acción es irreversible:';

  @override
  String get shedDeleteConsequences =>
      ' Se eliminarán los registros del galpón\n Se desvincularán los lotes asociados\n Se perderá el historial de operaciones';

  @override
  String get shedWriteHere => 'Escribe aquí';

  @override
  String get shedStatusActiveDesc => 'Operación normal habilitada';

  @override
  String get shedStatusInactiveDesc => 'Operaciones pausadas temporalmente';

  @override
  String get shedStatusMaintenanceDesc => 'En proceso de mantenimiento';

  @override
  String get shedStatusQuarantineDesc => 'Aislado por cuarentena sanitaria';

  @override
  String get shedStatusDisinfectionDesc => 'En proceso de desinfección';

  @override
  String get shedRegisterDisinfectionTitle => 'Registrar desinfección';

  @override
  String get shedSelectProductsFromInventory =>
      'Selecciona productos del inventario para descontar automáticamente';

  @override
  String get shedAdditionalObservations => 'Observaciones adicionales';

  @override
  String get shedScheduleMaintenance => 'Programar mantenimiento';

  @override
  String get shedMaintenanceDescriptionLabel =>
      'Descripción del mantenimiento *';

  @override
  String get shedMaintenanceDescriptionHint =>
      'Ej: Revisión de bebederos y comederos';

  @override
  String get shedEnterDescription => 'Ingrese una descripción';

  @override
  String shedWeeksAgo(Object count, Object label) {
    return 'Hace $count $label';
  }

  @override
  String get shedWeek => 'semana';

  @override
  String get shedWeeks => 'semanas';

  @override
  String get shedMonth => 'mes';

  @override
  String get shedMonths => 'meses';

  @override
  String get shedYear => 'año';

  @override
  String get shedYears => 'años';

  @override
  String get shedNotSpecified => 'No especificada';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonSchedule => 'Programar';

  @override
  String get commonReason => 'Motivo';

  @override
  String get shedCurrentState => 'Estado actual:';

  @override
  String get shedSelectNewState => 'Seleccionar nuevo estado:';

  @override
  String get shedWriteNameToConfirm => 'Escribe el nombre para confirmar:';

  @override
  String get shedSelectProductsDesc => 'Productos del inventario';

  @override
  String get shedProductsUsed => 'Productos utilizados *';

  @override
  String get shedProductsHint => 'Ej: Amonio cuaternario, Cal viva';

  @override
  String get shedSeparateWithCommas => 'Separe multiples productos con comas';

  @override
  String get shedObservationsHint => 'Observaciones adicionales';

  @override
  String get shedEnterAtLeastOneProduct => 'Ingrese al menos un producto';

  @override
  String get shedEnterReason => 'Ingrese el motivo';

  @override
  String get shedStartDateLabel => 'Fecha de inicio';

  @override
  String get shedCorralsDivisions => 'Corrales/Divisiones';

  @override
  String shedDivisionsCount(Object count) {
    return '$count divisiones';
  }

  @override
  String get shedWateringSystem => 'Sistema de Bebederos';

  @override
  String get shedFeederSystem => 'Sistema de Comederos';

  @override
  String get shedChangeStateAction => 'Cambiar estado';

  @override
  String get shedReleaseLabel => 'Liberar';

  @override
  String get shedDensityLabel => 'Densidad';

  @override
  String shedMSquarePerBird(String value) {
    return '$value m² por ave';
  }

  @override
  String shedOfCapacity(String percentage) {
    return '$percentage% de capacidad';
  }

  @override
  String shedOfBirdsUnit(Object count) {
    return 'de $count aves';
  }

  @override
  String get shedScheduleMaintenanceGrid => 'Programar\nMantenimiento';

  @override
  String get shedViewHistory => 'Ver\nHistorial';

  @override
  String get shedViewBatchDetail => 'Ver Detalle del Lote';

  @override
  String get shedNoAssignedBatch => 'Sin lote asignado';

  @override
  String get commonAvailable => 'Disponible';

  @override
  String get shedQuarantineReason => 'Motivo de cuarentena';

  @override
  String shedBatchAssignedMsg(Object code) {
    return 'Lote $code asignado correctamente';
  }

  @override
  String shedDeleteErrorMsg(Object message) {
    return 'Error al eliminar: $message';
  }

  @override
  String get shedCreateBatchFirst => 'Crea un nuevo lote primero';

  @override
  String get commonToday => 'Hoy';

  @override
  String get shedNoHistoryAvailable => 'Sin historial disponible';

  @override
  String get commonAssigned => 'Asignado';

  @override
  String shedBirdsOfCapacity(Object current, Object max) {
    return '$current / $max aves';
  }

  @override
  String shedShedsRegistered(Object count) {
    return '$count galpones registrados';
  }

  @override
  String get shedMoreOptions => 'Más opciones';

  @override
  String get shedOccurredError => 'Ocurrió un error';

  @override
  String get shedSpecifications => 'Especificaciones';

  @override
  String get shedConfigureThresholds =>
      'Configure los umbrales para monitoreo (opcional)';

  @override
  String get shedCapacityIsRequired => 'La capacidad es requerida';

  @override
  String get shedNameIsRequired => 'El nombre es obligatorio';

  @override
  String get shedShedNameLabel => 'Nombre del Galpón';

  @override
  String get shedTypeLabel => 'Tipo de Galpón';

  @override
  String get shedSelectTypeHint => 'Selecciona el tipo';

  @override
  String get shedSelectStateHint => 'Selecciona el estado';

  @override
  String get shedDrinkersOptional => 'Bebederos (opcional)';

  @override
  String get shedFeedersOptional => 'Comederos (opcional)';

  @override
  String get shedNestsOptional => 'Nidales (opcional)';

  @override
  String get shedTemperature => 'Temperatura';

  @override
  String get shedTip => 'Consejo';

  @override
  String get shedUnitsLabel => 'unidades';

  @override
  String get shedDensityTypeCol => 'Tipo';

  @override
  String get shedDensityCol => 'Densidad';

  @override
  String get shedFattening => 'Engorde';

  @override
  String get shedLaying => 'Postura';

  @override
  String get shedBreeder => 'Reproductora';

  @override
  String get shedActive => 'Activo';

  @override
  String get shedInactive => 'Inactivo';

  @override
  String shedSemanticsLabel(
    Object birds,
    Object code,
    Object name,
    Object status,
  ) {
    return 'Galpón $name, código $code, $birds aves, estado $status';
  }

  @override
  String shedShareType(Object type) {
    return 'Tipo: $type';
  }

  @override
  String shedShareCapacity(Object count) {
    return 'Capacidad: $count aves';
  }

  @override
  String shedShareOccupation(Object percentage) {
    return 'Ocupación: $percentage%';
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
    return 'Lote $code, $birdType, $birds aves, estado $status';
  }

  @override
  String get batchDetails => 'Detalles';

  @override
  String get batchViewRecords => 'Ver Registros';

  @override
  String get batchMoreOptions => 'Más opciones';

  @override
  String get batchMoreOptionsLote => 'Más opciones del lote';

  @override
  String get batchRetryLoadSemantics => 'Reintentar carga de lotes';

  @override
  String get batchStatusActive => 'Activo';

  @override
  String get batchStatusClosed => 'Cerrado';

  @override
  String get batchStatusQuarantine => 'Cuarentena';

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
  String get batchCloseBatch => 'Cerrar Lote';

  @override
  String get batchConfirmClose => 'Confirmar Cierre';

  @override
  String get batchCloseIrreversibleWarning =>
      'Esta acción es IRREVERSIBLE. El lote pasará a estado cerrado y el galpón quedará disponible.\n\n¿Está seguro de cerrar este lote?';

  @override
  String get batchClosureData => 'Datos del Cierre';

  @override
  String get batchCompleteClosureInfo =>
      'Complete la información final del lote';

  @override
  String get batchLoteInfo => 'Información del Lote';

  @override
  String batchInitialCountBirds(Object count) {
    return '$count aves';
  }

  @override
  String batchDaysInCycle(Object days) {
    return '$days días';
  }

  @override
  String get batchCloseDateLabel => 'Fecha de Cierre *';

  @override
  String get batchCloseDateSimple => 'Fecha de Cierre';

  @override
  String get batchCloseDateHelper => 'Fecha en que se cierra el lote';

  @override
  String get batchCloseDatePicker => 'Fecha de cierre del lote';

  @override
  String get batchFinalBirdCount => 'Cantidad Final de Aves *';

  @override
  String batchFinalBirdCountHelper(Object max) {
    return 'Número de aves vivas al cierre (máx: $max)';
  }

  @override
  String get batchFinalAvgWeight => 'Peso Promedio Final';

  @override
  String get batchFinalAvgWeightHint => 'Ej: 2500';

  @override
  String get batchFinalAvgWeightHelper =>
      'Peso promedio de las aves al cierre (en gramos)';

  @override
  String get batchClosureReason => 'Motivo del Cierre';

  @override
  String get batchClosureReasonHint => 'Ej: Fin de ciclo productivo';

  @override
  String get batchClosureReasonHelper => 'Opcional - Razón del cierre del lote';

  @override
  String get batchAdditionalNotes => 'Observaciones Adicionales';

  @override
  String get batchAdditionalNotesHint => 'Notas finales del lote...';

  @override
  String get batchBatchMetrics => 'Métricas del Lote';

  @override
  String get batchCycleIndicators =>
      'Resumen de indicadores del ciclo productivo';

  @override
  String get batchSurvival => 'Supervivencia';

  @override
  String get batchInitialBirds => 'Aves Iniciales';

  @override
  String get batchFinalBirds => 'Aves Finales';

  @override
  String get batchTotalMortality => 'Mortalidad Total';

  @override
  String batchMortalityBirds(Object count) {
    return '$count aves';
  }

  @override
  String get batchMortalityPercent => '% Mortalidad';

  @override
  String get batchSurvivalPercent => '% Supervivencia';

  @override
  String get batchCycleDuration => 'Duración del Ciclo';

  @override
  String get batchTotalDuration => 'Duración Total';

  @override
  String get batchAgeAtClose => 'Edad al Cierre';

  @override
  String batchAgeAtCloseDays(Object days) {
    return '$days días';
  }

  @override
  String get batchWeight => 'Peso';

  @override
  String get batchCurrentAvgWeightLabel => 'Peso Promedio Actual';

  @override
  String get batchTargetWeight => 'Peso Objetivo';

  @override
  String get batchClosureSummary => 'Resumen del Cierre';

  @override
  String get batchClosureSummaryWarning =>
      'Revisa cuidadosamente toda la información antes de confirmar el cierre. Esta acción es IRREVERSIBLE.';

  @override
  String get batchCloseWarningMessage =>
      'Al cerrar el lote, este pasará a estado CERRADO y el galpón quedará disponible para un nuevo lote.';

  @override
  String get batchFinalData => 'Datos Finales';

  @override
  String get batchFinalCount => 'Cantidad Final';

  @override
  String get batchMortalityTotal => 'Mortalidad Total';

  @override
  String get batchFinalWeightAvg => 'Peso Final Promedio';

  @override
  String get batchClosureNotes => 'Notas del Cierre';

  @override
  String get batchReason => 'Motivo';

  @override
  String get batchObservations => 'Observaciones';

  @override
  String get batchPrevious => 'Anterior';

  @override
  String get batchNext => 'Siguiente';

  @override
  String get batchClosing => 'Cerrando lote...';

  @override
  String get batchCannotBeNegative => 'No puede ser negativo';

  @override
  String get batchCannotExceedInitial =>
      'No puede ser mayor a la cantidad inicial';

  @override
  String get batchInvalidCount => 'Cantidad inválida';

  @override
  String get batchFinalCannotExceedInitial =>
      'La cantidad final no puede ser mayor a la inicial';

  @override
  String get batchNormalCycleClose => 'Cierre de ciclo normal';

  @override
  String batchErrorClosing(Object error) {
    return 'Error al cerrar lote: $error';
  }

  @override
  String get batchDraftFound => 'Borrador encontrado';

  @override
  String batchDraftMessage(Object date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String get batchDraftRestore => 'Restaurar';

  @override
  String get batchDraftDiscard => 'Descartar';

  @override
  String get batchExitWithoutComplete => '¿Salir sin completar?';

  @override
  String get batchDataSafe => 'No te preocupes, tus datos están seguros.';

  @override
  String get batchExit => 'Salir';

  @override
  String get batchSessionExpired =>
      'Tu sesión ha expirado. Por favor inicia sesión nuevamente';

  @override
  String get batchSaving => 'Guardando...';

  @override
  String batchSavedTime(Object time) {
    return 'Guardado $time';
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
    return 'hoy a las $time';
  }

  @override
  String get batchYesterday => 'ayer';

  @override
  String batchDaysAgo(Object days) {
    return 'hace $days días';
  }

  @override
  String get batchCreateSuccess => '¡Lote creado con éxito!';

  @override
  String batchCreateSuccessDetail(Object code) {
    return '\"$code\" está listo para gestionar';
  }

  @override
  String get batchErrorCreating => 'Error al crear el lote';

  @override
  String get batchUnexpectedError => 'Error inesperado';

  @override
  String get batchCheckConnection =>
      'Por favor, verifica tu conexión e intenta nuevamente';

  @override
  String get batchBasicStep => 'Básico';

  @override
  String get batchDetailsStep => 'Detalles';

  @override
  String get batchDataStep => 'Datos';

  @override
  String get batchMetricsStep => 'Métricas';

  @override
  String get batchConfirmStep => 'Confirmar';

  @override
  String get batchInfoStep => 'Información';

  @override
  String get batchRangesStep => 'Rangos';

  @override
  String get batchSummaryStep => 'Resumen';

  @override
  String get batchDescriptionStep => 'Descripción';

  @override
  String get batchEvidenceStep => 'Evidencia';

  @override
  String get batchRegister => 'Registrar';

  @override
  String get batchWaitProcess => 'Espera a que termine el proceso actual';

  @override
  String get batchWaitForProcess => 'Espera a que termine el proceso';

  @override
  String get batchErrorLoadingData => 'Error al cargar datos';

  @override
  String get batchLoadingCharts => 'Cargando gráficos...';

  @override
  String get batchChartsProduction => 'Gráficos de Producción';

  @override
  String get batchChartsWeight => 'Gráficos de Peso';

  @override
  String get batchChartsMortality => 'Gráficos de Mortalidad';

  @override
  String get batchChartsConsumption => 'Gráficos de Consumo';

  @override
  String get batchRefresh => 'Actualizar';

  @override
  String get batchRefreshData => 'Actualizar datos';

  @override
  String get batchProductionHistory => 'Historial de producción';

  @override
  String get batchWeighingHistory => 'Historial de pesajes';

  @override
  String get batchMortalityHistory => 'Historial de mortalidad';

  @override
  String get batchConsumptionHistory => 'Historial de consumo';

  @override
  String get batchRecent => 'Recientes';

  @override
  String get batchOldest => 'Antiguos';

  @override
  String get batchNoFilters => 'Sin filtros';

  @override
  String get batchDays7 => '7 días';

  @override
  String get batchDays30 => '30 días';

  @override
  String get batchHighPosture => 'Postura alta';

  @override
  String get batchMediumPosture => 'Postura media';

  @override
  String get batchLowPosture => 'Postura baja';

  @override
  String get batchBackToHistory => 'Volver al historial';

  @override
  String get batchNoWeightData => 'Sin datos de peso';

  @override
  String get batchChartsAppearWhenData =>
      'Los gráficos aparecerán cuando haya registros de peso';

  @override
  String get batchPosturePercentage => 'Porcentaje de Postura';

  @override
  String get batchPostureEvolution => 'Evolución del % de postura en el tiempo';

  @override
  String get batchDailyConsumption => 'Consumo Diario';

  @override
  String get batchKgPerDay => 'Kilogramos de alimento consumido por día';

  @override
  String get batchWeightEvolution => 'Evolución de Peso';

  @override
  String get batchAccumulatedMortalityChart => 'Mortalidad Acumulada';

  @override
  String get batchAccumulatedMortalityDesc =>
      'Total acumulado de aves muertas en el tiempo';

  @override
  String get batchDailyMortality => 'Mortalidad Diaria';

  @override
  String get batchDailyGainAvg => 'Ganancia Diaria Promedio';

  @override
  String get batchUniformity => 'Uniformidad';

  @override
  String get batchStandardComparison => 'Comparación con Estándar';

  @override
  String get batchConsumptionPerBird => 'Consumo por Ave';

  @override
  String get batchFoodTypeDistribution => 'Distribución por Tipo';

  @override
  String get batchCosts => 'Costos';

  @override
  String get batchQuality => 'Calidad';

  @override
  String get batchDraftFoundGeneric =>
      'Se encontró un borrador guardado. ¿Deseas restaurarlo?';

  @override
  String get batchNoAccessFarm => 'No tienes acceso a esta granja';

  @override
  String get batchNoPermissionRecord =>
      'No tienes permisos para registrar consumo en esta granja';

  @override
  String get batchDaysInCycleLabel => 'Días en Ciclo';

  @override
  String get batchClosePrefix => '[Cierre]';

  @override
  String get batchCreateBatch => 'Crear Lote';

  @override
  String get batchClassificationStep => 'Clasificación';

  @override
  String get batchObservationsStep => 'Observaciones';

  @override
  String get registerProductionTitle => 'Registrar Producción';

  @override
  String get registerWeightTitle => 'Registrar Pesaje';

  @override
  String get registerMortalityTitle => 'Registrar Mortalidad';

  @override
  String get registerConsumptionTitle => 'Registrar Consumo';

  @override
  String get productionRegistered => '¡Producción registrada!';

  @override
  String productionRegisteredDetail(String eggs, String good) {
    return '$eggs huevos · $good buenos';
  }

  @override
  String get weightRegistered => '¡Pesaje registrado!';

  @override
  String get mortalityRegistered => '¡Mortalidad registrada!';

  @override
  String get consumptionRegistered => '¡Consumo registrado!';

  @override
  String get batchMaxPhotosAllowed => 'Máximo 3 fotos permitidas';

  @override
  String get batchPhotoExceeds5MB =>
      'La foto excede 5MB. Elige una imagen más pequeña';

  @override
  String productionGoodEggsExceedCollected(String collected, Object good) {
    return 'Los huevos buenos ($good) no pueden ser más que los recolectados ($collected)';
  }

  @override
  String get productionNoAvailableBirds => 'El lote no tiene aves disponibles';

  @override
  String productionHighLayingPercent(String percent) {
    return 'El porcentaje de postura ($percent%) es mayor al 100%. Verifica los datos.';
  }

  @override
  String productionClassifiedExceedGood(String classified, Object good) {
    return 'Total clasificados ($classified) excede los huevos buenos ($good)';
  }

  @override
  String get batchHighLayingTitle => 'Porcentaje de postura muy alto';

  @override
  String batchHighLayingMessage(Object percent) {
    return 'El porcentaje de postura es $percent%, que es excepcionalmente alto. ¿Deseas continuar con estos datos?';
  }

  @override
  String get batchHighBreakageTitle => 'Alto porcentaje de rotura';

  @override
  String batchHighBreakageMessage(Object count, Object percent) {
    return 'El porcentaje de rotura es $percent% ($count huevos), que es superior al 5% esperado. ¿Deseas continuar?';
  }

  @override
  String get commonReviewData => 'Revisar datos';

  @override
  String get batchNoPermissionProduction =>
      'No tienes permisos para registrar producción en esta granja';

  @override
  String batchErrorVerifyingPermissions(Object error) {
    return 'Error al verificar permisos: $error';
  }

  @override
  String get productionFutureDate =>
      'La fecha de producción no puede ser futura';

  @override
  String get productionBeforeEntryDate =>
      'La fecha de producción no puede ser anterior a la fecha de ingreso del lote';

  @override
  String get batchFirebaseDbError => 'Error de conexión con la base de datos';

  @override
  String get batchFirebasePermissionDenied =>
      'No tienes permisos para realizar esta acción';

  @override
  String get batchFirebasePermissionDetail =>
      'Verifica tu sesión e intenta nuevamente';

  @override
  String get batchFirebaseUnavailable => 'Servicio no disponible';

  @override
  String get batchFirebaseUnavailableDetail =>
      'Verifica tu conexión a internet';

  @override
  String get batchFirebaseSessionExpired => 'Sesión expirada';

  @override
  String get batchFirebaseSessionDetail => 'Por favor inicia sesión nuevamente';

  @override
  String get batchNoPermissionWeight =>
      'No tienes permisos para registrar pesajes en esta granja';

  @override
  String get batchNoPermissionMortality =>
      'No tienes permisos para registrar mortalidad en esta granja';

  @override
  String get mortalityFutureDate =>
      'La fecha de mortalidad no puede ser futura';

  @override
  String get mortalityBeforeEntryDate =>
      'La fecha no puede ser anterior a la fecha de ingreso del lote';

  @override
  String get weightFutureDate => 'La fecha del pesaje no puede ser futura';

  @override
  String get weightBeforeEntryDate =>
      'La fecha no puede ser anterior a la fecha de ingreso del lote';

  @override
  String get consumptionFutureDate => 'La fecha de consumo no puede ser futura';

  @override
  String get consumptionBeforeEntryDate =>
      'La fecha no puede ser anterior a la fecha de ingreso del lote';

  @override
  String weightCannotExceedAvailable(Object count) {
    return 'La cantidad pesada no puede superar las aves actuales del lote ($count)';
  }

  @override
  String get weightMinMustBeLessThanMax =>
      'El peso mínimo debe ser menor que el peso máximo';

  @override
  String get weightLowUniformityTitle => 'Uniformidad Baja Detectada';

  @override
  String weightLowUniformityMessage(String cv) {
    return 'El coeficiente de variación es $cv%, lo que indica baja uniformidad en el lote.';
  }

  @override
  String get weightCvRecommendedTitle => 'Valores recomendados de CV:';

  @override
  String get weightCvRecommendedValues =>
      '• Óptimo: < 8%\n• Aceptable: 8-12%\n• Requiere atención: > 12%';

  @override
  String weightRegisteredDetail(String weight, Object count) {
    return '$count aves • $weight kg promedio';
  }

  @override
  String batchPhotoAdded(Object current, Object max) {
    return 'Foto $current/$max agregada';
  }

  @override
  String get batchPhotoSelectError =>
      'Error al seleccionar la imagen. Intenta nuevamente.';

  @override
  String get batchPhotoUploadFailed =>
      'No se pudieron subir las fotos. ¿Deseas continuar sin fotos?';

  @override
  String get batchContinueWithoutPhotos => '¿Continuar sin fotos?';

  @override
  String get batchPhotoUploadFailedDetail =>
      'Las fotos no se pudieron subir. ¿Deseas registrar sin evidencia fotográfica?';

  @override
  String get batchFirebaseNetworkError => 'Sin conexión';

  @override
  String get batchFirebaseNetworkDetail => 'Verifica tu conexión a internet';

  @override
  String mortalityRegisteredDetail(String cause, Object count) {
    return '$count aves - $cause';
  }

  @override
  String get mortalityAttentionRequired => '¡Atención Requerida!';

  @override
  String mortalityImpactMessage(Object percent) {
    return 'El evento registrado tiene un impacto del $percent% y requiere atención inmediata.';
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
    return 'La cantidad ($count) excede las aves disponibles ($available)';
  }

  @override
  String get mortalityUserRequired => 'El nombre de usuario es requerido';

  @override
  String get mortalityUserInvalid => 'ID de usuario inválido';

  @override
  String get mortalityUserNotAuthenticated => 'Usuario no autenticado';

  @override
  String get batchFirebaseError => 'Error de Firebase';

  @override
  String get batchErrorCreatingRecord => 'Error al crear registro';

  @override
  String get commonUnderstood => 'Entendido';

  @override
  String consumptionInsufficientStock(String stock) {
    return 'Stock insuficiente. Disponible: $stock kg';
  }

  @override
  String consumptionInventoryError(Object error) {
    return 'Consumo registrado, pero hubo un error al actualizar inventario: $error';
  }

  @override
  String consumptionRegisteredDetail(String amount, Object type) {
    return '$amount kg de $type';
  }

  @override
  String get consumptionNoBirdsAvailable => 'El lote no tiene aves disponibles';

  @override
  String get consumptionHighAmountTitle => 'Cantidad Alta de Alimento';

  @override
  String consumptionHighAmountMessage(Object amount) {
    return 'Estás registrando $amount kg de alimento.';
  }

  @override
  String get consumptionPerBird => 'Por ave:';

  @override
  String get commonCorrect => 'Corregir';

  @override
  String get consumptionFoodTypeTitle => 'Tipo de Alimento';

  @override
  String consumptionFoodTypeWarning(Object days, Object type) {
    return 'El tipo \"$type\" no es el recomendado para $days días de edad.';
  }

  @override
  String get consumptionRecommendedType => 'Tipo recomendado:';

  @override
  String get commonReview => 'Revisar';

  @override
  String get consumptionAmountTooHigh =>
      'La cantidad parece demasiado alta. Verifica el valor.';

  @override
  String get consumptionCostNegative => 'El costo por kg no puede ser negativo';

  @override
  String get consumptionCostTooHigh =>
      'El costo parece demasiado alto. Verifica el valor.';

  @override
  String get batchViewCharts => 'Ver Gráficos';

  @override
  String get batchFilterRecords => 'Filtrar registros';

  @override
  String get batchTimePeriod => 'Período de tiempo';

  @override
  String get batchAllTime => 'Todo';

  @override
  String get batchNoTimeLimit => 'Sin límite';

  @override
  String get batchLastWeek => 'Última semana';

  @override
  String get batchLastMonth => 'Último mes';

  @override
  String batchApplyFiltersOrClose(String hasFilters) {
    String _temp0 = intl.Intl.selectLogic(hasFilters, {
      'true': 'Aplicar filtros',
      'other': 'Cerrar',
    });
    return '$_temp0';
  }

  @override
  String get batchErrorLoadingRecords => 'Error al cargar registros';

  @override
  String get historialPostureRange => 'Rango de postura';

  @override
  String get historialAllPostures => 'Todas las posturas';

  @override
  String get historialHighPosture => 'Alta (≥85%)';

  @override
  String get historialMediumPosture => 'Media (70-84%)';

  @override
  String get historialLowPosture => 'Baja (<70%)';

  @override
  String get historialTotalEggs => 'huevos totales';

  @override
  String get historialAvgPosture => 'postura promedio';

  @override
  String get historialRecords => 'registros';

  @override
  String get historialDailyAvg => 'promedio diario';

  @override
  String get historialTotalConsumed => 'total consumido';

  @override
  String get historialDeadBirds => 'aves fallecidas';

  @override
  String get historialNoProductionRecords => 'Sin registros de producción';

  @override
  String get historialNoResults => 'Sin resultados';

  @override
  String get historialRegisterFirstProduction =>
      'Registra la primera producción de huevos';

  @override
  String get historialNoRecordsWithFilters =>
      'No hay registros con estos filtros';

  @override
  String get historialPostureLabel => 'Postura: ';

  @override
  String historialGoodLabel(Object count, Object percent) {
    return 'Buenos: $count ($percent%)';
  }

  @override
  String historialBirdsLabel(Object count) {
    return 'Aves: $count';
  }

  @override
  String historialBrokenLabel(Object count) {
    return 'Rotos: $count';
  }

  @override
  String historialAgeLabel(Object days) {
    return 'Edad: $days días';
  }

  @override
  String get detailPosturePercentage => 'Porcentaje postura';

  @override
  String get detailBirdAge => 'Edad de las aves';

  @override
  String detailDaysWeek(String weeks, Object days) {
    return '$days días (Semana $weeks)';
  }

  @override
  String get detailBirdCount => 'Cantidad de aves';

  @override
  String get detailGoodEggs => 'Huevos buenos';

  @override
  String get detailBrokenEggs => 'Huevos rotos';

  @override
  String get detailDirtyEggs => 'Huevos sucios';

  @override
  String get detailDoubleYolkEggs => 'Huevos doble yema';

  @override
  String get detailAvgEggWeight => 'Peso promedio huevo';

  @override
  String get detailRegisteredBy => 'Registrado por';

  @override
  String get detailObservations => 'Observaciones';

  @override
  String get detailSizeClassification => 'Clasificación por tamaño';

  @override
  String get detailPhotoEvidence => 'Evidencia fotográfica';

  @override
  String historialEggsUnit(Object count) {
    return '$count huevos';
  }

  @override
  String get historialCauseLabel => 'Causa: ';

  @override
  String historialDescriptionLabel(String desc) {
    return 'Descripción: $desc';
  }

  @override
  String get historialTypeLabel => 'Tipo: ';

  @override
  String historialConsumptionPerBird(String grams) {
    return 'Consumo/ave: ${grams}g';
  }

  @override
  String get historialNoMortalityRecords => 'No hay registros de mortalidad';

  @override
  String get historialNoConsumptionRecords => 'Sin registros de consumo';

  @override
  String get historialNoConsumptionResults => 'Sin resultados';

  @override
  String get historialRegisterFirstConsumption =>
      'Registra el primer consumo de alimento';

  @override
  String get historialNoRecordsConsumptionFilters =>
      'No hay registros con estos filtros';

  @override
  String get historialNoProductionData => 'Sin datos de producción';

  @override
  String get historialChartsAppearProduction =>
      'Los gráficos aparecerán cuando haya registros de producción';

  @override
  String get historialNoConsumptionData => 'Sin datos de consumo';

  @override
  String get historialChartsAppearConsumption =>
      'Los gráficos aparecerán cuando haya registros de consumo';

  @override
  String get historialFilterMortalityCause => 'Causa de mortalidad';

  @override
  String get historialFilterFoodType => 'Tipo de alimento';

  @override
  String get historialFilterAllTypes => 'Todos los tipos';

  @override
  String get detailFoodType => 'Tipo de alimento';

  @override
  String get detailBirdsWeighed => 'Aves pesadas';

  @override
  String get detailAvgWeight => 'Peso promedio';

  @override
  String get detailMinWeight => 'Peso mínimo';

  @override
  String get detailMaxWeight => 'Peso máximo';

  @override
  String get detailTotalWeight => 'Peso total';

  @override
  String get detailDailyGain => 'Ganancia diaria (GDP)';

  @override
  String get detailCvCoefficient => 'Coef. Variación (CV)';

  @override
  String get detailUniformity => 'Uniformidad';

  @override
  String get detailUniformityGood => 'Buena (< 10%)';

  @override
  String get detailUniformityRegular => 'Regular (≥ 10%)';

  @override
  String get detailConsumptionPerBird => 'Consumo por ave';

  @override
  String get detailAccumulatedConsumption => 'Consumo acumulado';

  @override
  String get detailFoodBatch => 'Lote de alimento';

  @override
  String get detailCostPerKg => 'Costo por kg';

  @override
  String get detailTotalCost => 'Costo total';

  @override
  String get detailCause => 'Causa';

  @override
  String get detailBirdsBeforeEvent => 'Aves antes del evento';

  @override
  String get detailImpact => 'Impacto';

  @override
  String get detailDescription => 'Descripción';

  @override
  String historialBirdsWeighedLabel(Object count) {
    return 'Aves pesadas: $count';
  }

  @override
  String get historialFilterWeightRange => 'Rango de peso';

  @override
  String get historialAllWeights => 'Todos';

  @override
  String get historialLow => 'Bajo';

  @override
  String get historialNormal => 'Normal';

  @override
  String get historialHigh => 'Alto';

  @override
  String get historialNoWeighingRecords => 'Sin registros de pesaje';

  @override
  String get historialRegisterFirstWeighing =>
      'Registra el primer pesaje de aves';

  @override
  String get historialNoEventsRecords => 'Historial de eventos';

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
    return 'Usuario: $name';
  }

  @override
  String historialAgeDaysLabel(Object days) {
    return 'Edad: $days días';
  }

  @override
  String get historialNoMortalityExcellent =>
      '¡Excelente! No hay bajas registradas';

  @override
  String get historialAllCauses => 'Todas las causas';

  @override
  String get historialWeighingHistory => 'Historial de pesajes';

  @override
  String get historialLastWeight => 'último peso';

  @override
  String get historialDailyGainStat => 'ganancia diaria';

  @override
  String get historialUniformityCV => 'uniformidad CV';

  @override
  String get historialMethodLabel => 'Método';

  @override
  String get historialFilterWeighingMethod => 'Método de pesaje';

  @override
  String get historialAllMethods => 'Todos los métodos';

  @override
  String historialGdpLabel(Object value) {
    return 'GDP: ${value}g';
  }

  @override
  String historialCvLabel(Object value) {
    return 'CV: $value%';
  }

  @override
  String get detailWeighingMethod => 'Método de pesaje';

  @override
  String get historialNoWeightRecords => 'Sin registros de peso';

  @override
  String get historialRegisterFirstWeighingLote =>
      'Registra el primer pesaje de tu lote';

  @override
  String get historialConsumptionHistory => 'Historial de consumo';

  @override
  String get historialAvgDaily => 'promedio diario';

  @override
  String get historialAccumulatedPerBird => 'acumulado/ave';

  @override
  String get historialAllFoodTypes => 'Todos los tipos';

  @override
  String historialBirdNumber(Object count) {
    return 'Aves: $count';
  }

  @override
  String historialConsumptionValue(Object value) {
    return 'Consumo/ave: ${value}g';
  }

  @override
  String get chartsConsumptionTitle => 'Gráficos de Consumo';

  @override
  String get chartsLoading => 'Cargando gráficos...';

  @override
  String get chartsErrorLoading => 'Error al cargar datos';

  @override
  String get chartsNoValidData => 'Sin registros con cantidad válida';

  @override
  String get chartsDailyConsumptionTitle => 'Consumo Diario';

  @override
  String get chartsDailyConsumptionSubtitle =>
      'Kilogramos de alimento consumido por día';

  @override
  String get chartsConsumptionPerBirdTitle => 'Consumo por Ave';

  @override
  String get chartsConsumptionPerBirdSubtitle =>
      'Gramos de alimento por ave por día';

  @override
  String get chartsFoodTypeDistributionTitle => 'Distribución por Tipo';

  @override
  String get chartsFoodTypeDistributionSubtitle =>
      'Consumo total por tipo de alimento (kg)';

  @override
  String get chartsCostEvolutionTitle => 'Costos de Alimentación';

  @override
  String get chartsCostEvolutionSubtitle =>
      'Gasto total por día en alimentación';

  @override
  String get chartsCostNoValidData => 'Sin registros con costo asignado';

  @override
  String get chartsNotEnoughData => 'Sin suficientes datos';

  @override
  String get chartsRegisterMoreToAnalyze =>
      'Registra más consumos para ver el análisis';

  @override
  String get chartsGraphsAppearWhenData =>
      'Los gráficos aparecerán cuando haya registros de consumo';

  @override
  String get chartsMortalityAccumulatedSubtitle =>
      'Porcentaje de bajas sobre inicial';

  @override
  String get chartsMortalityDailyTitle => 'Mortalidad Diaria';

  @override
  String get chartsMortalityDailySubtitle => 'Cantidad de aves por día';

  @override
  String get chartsMortalityCausesTitle => 'Causas de Mortalidad';

  @override
  String get chartsMortalityCausesSubtitle =>
      'Distribución por motivo principal';

  @override
  String get chartsMortalityDistributionCauseTitle => 'Distribución por Causa';

  @override
  String get chartsMortalityTotalByCauseSubtitle =>
      'Total de aves por causa de mortalidad';

  @override
  String get commonExcellent => '¡Excelente!';

  @override
  String get mortalityCauseDisease => 'Enfermedad';

  @override
  String get mortalityCauseStress => 'Estrés';

  @override
  String get mortalityCauseAccident => 'Accidente';

  @override
  String get mortalityCausePredation => 'Depredación';

  @override
  String get mortalityCauseMalnutrition => 'Desnutrición';

  @override
  String get mortalityCauseMetabolic => 'Metabólica';

  @override
  String get mortalityCauseSacrifice => 'Sacrificio';

  @override
  String get mortalityCauseOldAge => 'Vejez';

  @override
  String get mortalityCauseUnknown => 'Desconocida';

  @override
  String get chartsNoMortalityRecords => 'Sin bajas registradas';

  @override
  String get chartsGraphsAppearWhenMortality =>
      'Los gráficos aparecerán cuando se registren bajas';

  @override
  String chartsMortalityTooltipTotal(Object count, Object percent) {
    return 'Total: $count aves ($percent%)';
  }

  @override
  String chartsMortalityTooltipEvent(Object count, Object date) {
    return '$date\n$count aves';
  }

  @override
  String get chartsMortalityAcceptable => 'Aceptable';

  @override
  String get chartsMortalityAlert => 'Alerta';

  @override
  String get chartsMortalityCritical => 'Crítico';

  @override
  String get chartsMortalityPerRegistrationTitle => 'Mortalidad por Registro';

  @override
  String get chartsMortalityPerRegistrationSubtitle =>
      'Cantidad de aves por cada evento registrado';

  @override
  String get chartsNoCauseData => 'Sin datos de causas';

  @override
  String chartsWeightTooltipEvolution(String date, String weight, String age) {
    return '📈 Evolución\n📅 $date\n⚖️ $weight kg\n🐣 Día $age';
  }

  @override
  String chartsWeightTooltipADG(String date, String age, String gain) {
    return '📈 Ganancia diaria\n📅 $date\n🐣 Día $age\n📊 $gain g/día';
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
    return '📊 Real: $real kg\n📈 Estándar: $standard kg\n$emoji Dif: $sign$diff kg';
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
    return 'ðŸ¥š $date\n$count huevos recolectados';
  }

  @override
  String get chartsWeightEvolutionTitle => 'Evolución de Peso';

  @override
  String get chartsWeightEvolutionSubtitle =>
      'Peso promedio a lo largo del tiempo';

  @override
  String get chartsWeightADGTitle => 'Ganancia Diaria de Peso';

  @override
  String get chartsWeightADGSubtitle => 'Gramos ganados por día';

  @override
  String get chartsWeightUniformityTitle => 'Uniformidad del Lote';

  @override
  String get chartsWeightUniformitySubtitle =>
      'Coeficiente de variación del peso';

  @override
  String get chartsWeightUniformityExcellent => 'Excelente uniformidad';

  @override
  String get chartsWeightUniformityGood => 'Buena uniformidad';

  @override
  String get chartsWeightUniformityImprove => 'Necesita mejorar';

  @override
  String get chartsWeightComparisonTitle => 'Comparación con Estándar';

  @override
  String get chartsWeightComparisonSubtitle =>
      'Peso real vs peso estándar de la raza';

  @override
  String get commonActual => 'Real';

  @override
  String get commonStandard => 'Estándar';

  @override
  String get chartsProductionDailyTitle => 'Producción Diaria';

  @override
  String get chartsProductionDailySubtitle => 'Huevos recolectados por día';

  @override
  String get chartsProductionQualityTitle => 'Calidad de Huevos';

  @override
  String get chartsProductionQualitySubtitle =>
      'Distribución por tipo de huevo';

  @override
  String get eggTypeGood => 'Buenos';

  @override
  String get eggTypeBroken => 'Rotos';

  @override
  String get eggTypeDirty => 'Sucios';

  @override
  String get eggTypeDoubleYolk => 'Doble yema';

  @override
  String get homeSelectFarm => 'Seleccionar granja';

  @override
  String get homeHaveCode => '¿Tienes un código?';

  @override
  String get homeJoinFarmWithInvitation => 'Únete a una granja con invitación';

  @override
  String get homeNoFarmsRegistered => 'No tienes granjas registradas';

  @override
  String get homeHaveInvitationCode => '¿Tienes un código de invitación?';

  @override
  String get homeHealth => 'Salud';

  @override
  String get homeAlerts => 'Alertas';

  @override
  String get homeOutOfStock => 'Productos agotados';

  @override
  String get homeLowStock => 'Stock bajo';

  @override
  String get homeRecentActivity => 'Actividad Reciente';

  @override
  String get homeLast7Days => 'Últimos 7 días';

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
    return 'Hace $hours horas';
  }

  @override
  String homeYesterdayAt(Object time) {
    return 'Ayer a las $time';
  }

  @override
  String homeAgoDays(Object days) {
    return 'Hace $days días';
  }

  @override
  String get homeNoRecentActivity => 'Sin actividad reciente';

  @override
  String get homeNoRecentActivityDesc =>
      'Los registros de producción, mortalidad,\nconsumo, inventario, ventas, costos\ny salud aparecerán aquí';

  @override
  String get homeErrorLoadingActivities => 'Error al cargar actividades';

  @override
  String get homeTryReloadPage => 'Intente recargar la página';

  @override
  String homeProductsOutOfStockCount(Object count) {
    return '$count productos sin stock';
  }

  @override
  String homeProductsLowStockCount(Object count) {
    return '$count productos con stock bajo';
  }

  @override
  String homeProductsExpiringSoonCount(Object count) {
    return '$count productos por vencer';
  }

  @override
  String homeMortalityPercent(Object percent) {
    return 'Mortalidad del $percent% en lotes activos';
  }

  @override
  String get homeStatsAppearHere => 'Las estadísticas se mostrarán aquí';

  @override
  String get homeOccupancyLow => 'Ocupación baja';

  @override
  String get homeOccupancyMedium => 'Ocupación media';

  @override
  String get homeOccupancyHigh => 'Ocupación alta';

  @override
  String get homeOccupancyMax => 'Ocupación máxima';

  @override
  String get homeNoCapacityDefined => 'Sin capacidad definida';

  @override
  String get homeCouldNotLoad => 'No se pudo cargar';

  @override
  String get homeWhatsappHelp => '¿En qué podemos ayudarte?';

  @override
  String get homeWhatsappContact => 'Contáctanos por WhatsApp';

  @override
  String get homeWhatsappSupport => 'Soporte técnico';

  @override
  String get homeWhatsappNeedHelp => 'Necesito ayuda con la aplicación';

  @override
  String get homeWhatsappReportProblem => 'Reportar un problema';

  @override
  String get homeWhatsappSuggestImprovement => 'Sugerir una mejora';

  @override
  String get homeWhatsappWorkTogether => 'Trabajar juntos';

  @override
  String get homeWhatsappPlansAndPricing => 'Planes y precios';

  @override
  String get homeWhatsappOtherTopic => 'Otro tema';

  @override
  String get homeWhatsappCouldNotOpen => 'No se pudo abrir WhatsApp';

  @override
  String get homeNoOccupancy => 'Sin ocupación';

  @override
  String get homeSelectAFarm => 'Selecciona una granja';

  @override
  String homeTotalShedsCount(Object count) {
    return '$count en total';
  }

  @override
  String homeTotalBatchesCount(Object count) {
    return '$count lotes en total';
  }

  @override
  String get homeInvTotal => 'Total';

  @override
  String get homeInvLowStock => 'Stock Bajo';

  @override
  String get homeInvOutOfStock => 'Agotados';

  @override
  String get homeInvExpiringSoon => 'Por Vencer';

  @override
  String get homeSetupInventory => 'Configura tu inventario';

  @override
  String get homeSetupInventoryDesc =>
      'Agrega alimentos, medicamentos y más para controlar tu stock';

  @override
  String homeInvAttention(String details) {
    return 'Atención: $details';
  }

  @override
  String homeInvOutOfStockCount(Object count) {
    return '$count agotados';
  }

  @override
  String homeInvLowStockCount(Object count) {
    return '$count con stock bajo';
  }

  @override
  String homeInvExpiringSoonCount(Object count) {
    return '$count próximos a vencer';
  }

  @override
  String get homeWhatsappFoundBug => 'Encontré un error o fallo';

  @override
  String get homeWhatsappHaveIdea => 'Tengo una idea para mejorar la app';

  @override
  String get homeWhatsappCollaboration => 'Colaboración o alianza comercial';

  @override
  String get homeWhatsappLicenseInfo => 'Información sobre licencias y planes';

  @override
  String get homeWhatsappGeneralInquiry => 'Consulta general';

  @override
  String get batchError => 'Error';

  @override
  String get batchNotFound => 'Lote no encontrado';

  @override
  String get batchNotFoundMessage => 'El lote no fue encontrado';

  @override
  String get batchMayHaveBeenDeleted =>
      'Puede que haya sido eliminado o movido';

  @override
  String get batchCouldNotLoad => 'No pudimos cargar el lote';

  @override
  String batchEditCode(Object code) {
    return 'Editar: $code';
  }

  @override
  String get batchUpdateBatch => 'Actualizar Lote';

  @override
  String get batchCodeRequired => 'El código es obligatorio';

  @override
  String get batchSelectBirdType => 'Seleccione el tipo de ave';

  @override
  String get batchSelectShed => 'Debe seleccionar un galpón';

  @override
  String get batchInitialCountRequired => 'La cantidad inicial es obligatoria';

  @override
  String get batchErrorUpdating => 'Error al actualizar lote';

  @override
  String get batchUpdateSuccess => '¡Lote actualizado con éxito!';

  @override
  String get batchChangesSaved => 'Los cambios se han guardado correctamente';

  @override
  String get batchChangesWillBeLost =>
      'Los cambios que has realizado se perderán.';

  @override
  String get batchOperationSuccess => 'Operación exitosa';

  @override
  String get batchDeletedSuccess => 'Lote eliminado';

  @override
  String get batchSearchHint => 'Buscar por nombre, código o tipo...';

  @override
  String get batchAll => 'Todos';

  @override
  String get batchNoFarms => 'Sin granjas';

  @override
  String get batchCreateFarmFirst =>
      'Crea una granja primero para agregar lotes';

  @override
  String get batchCreateFarm => 'Crear granja';

  @override
  String get batchErrorLoadingBatches => 'Error al cargar lotes';

  @override
  String get batchSelectFarm => 'Selecciona una granja';

  @override
  String batchSelectFarmName(Object name) {
    return 'Seleccionar granja $name';
  }

  @override
  String get batchNoRegistered => 'Sin lotes registrados';

  @override
  String get batchRegisterFirst =>
      'Registra tu primer lote de aves para comenzar a monitorear tu producción';

  @override
  String get batchNotFoundFilter => 'No se encontraron lotes';

  @override
  String get batchAdjustFilters =>
      'Intenta ajustar los filtros o buscar con otros términos';

  @override
  String batchFarmWithBatchesLabel(Object count, Object name) {
    return 'Granja $name con $count lotes';
  }

  @override
  String get batchShedBatches => 'Lotes del Galpón';

  @override
  String get batchCreateNewTooltip => 'Crear nuevo lote';

  @override
  String batchStatusUpdatedTo(Object status) {
    return 'Estado actualizado a $status';
  }

  @override
  String batchDeleteMessage(Object code) {
    return 'Se eliminará el lote \"$code\" y todos sus registros. Esta acción no se puede deshacer.';
  }

  @override
  String batchErrorDeletingDetail(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get batchDeletedCorrectly => 'Lote eliminado correctamente';

  @override
  String get batchCannotCreateWithoutShed =>
      'No se puede crear lote sin galpón';

  @override
  String get batchCannotViewWithoutShed => 'No se puede ver detalle sin galpón';

  @override
  String get batchCannotEditWithoutShed => 'No se puede editar sin galpón';

  @override
  String get batchCurrentStatus => 'Estado actual:';

  @override
  String get batchSelectNewStatus => 'Seleccionar nuevo estado:';

  @override
  String batchConfirmStateChange(Object status) {
    return '¿Confirmar cambio a $status?';
  }

  @override
  String get batchPermanentStateWarning =>
      'Este estado es permanente y no podrá revertirse.';

  @override
  String get batchPermanentState => 'Estado permanente';

  @override
  String get batchCycleProgress => 'Progreso del ciclo';

  @override
  String batchDayOfCycle(String day, Object total) {
    return 'Día $day de $total';
  }

  @override
  String batchCycleCompleted(Object day) {
    return 'Día $day - Ciclo completado';
  }

  @override
  String batchExtraDays(String extra, Object day) {
    return 'Día $day ($extra extra)';
  }

  @override
  String get batchEntryLabel => 'Ingreso';

  @override
  String get batchLiveBirds => 'Aves Vivas';

  @override
  String get batchTotalLosses => 'Bajas Totales';

  @override
  String get batchAttention => 'Atención';

  @override
  String get batchKeyIndicators => 'Indicadores clave';

  @override
  String get batchOfInitial => 'del lote inicial';

  @override
  String get batchBirdsLost => 'aves perdidas';

  @override
  String get batchExpected => 'esperado';

  @override
  String get batchCurrentWeight => 'peso actual';

  @override
  String get batchDailyGain => 'ganancia diaria';

  @override
  String get batchGoal => 'meta';

  @override
  String get batchFoodConsumption => 'Consumo de Alimento';

  @override
  String get batchTotalAccumulated => 'total acumulado';

  @override
  String get batchPerBird => 'por ave';

  @override
  String get batchDailyExpectedPerBird => 'diario esperado/ave';

  @override
  String get batchCurrentIndex => 'índice actual';

  @override
  String get batchKgFood => 'kg alimento';

  @override
  String get batchPerKgWeight => 'por kg de peso';

  @override
  String get batchOptimalRange => 'rango óptimo';

  @override
  String get batchEggProduction => 'Producción de Huevos';

  @override
  String get batchTotalEggs => 'huevos totales';

  @override
  String get batchEggsPerBird => 'huevos por ave';

  @override
  String get batchExpectedLaying => 'postura esperada';

  @override
  String get batchHighMortalityAlert => 'Mortalidad elevada, revise el lote';

  @override
  String get batchWeightBelowTarget => 'Peso por debajo del objetivo';

  @override
  String batchOverdueClose(Object days) {
    return 'Cierre vencido hace $days días';
  }

  @override
  String batchCloseUpcoming(Object days) {
    return 'Cierre próximo en $days días';
  }

  @override
  String get batchHighConversionAlert => 'Índice de conversión alto';

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
  String get batchWeightLevelAcceptable => 'Aceptable';

  @override
  String get batchWeightLevelLow => 'Bajo';

  @override
  String get batchQualityGood => 'Buena';

  @override
  String get batchQualityRegular => 'Regular';

  @override
  String get batchQualityLow => 'Baja';

  @override
  String get batchRegisterMortality => 'Registrar Mortalidad';

  @override
  String get batchRegisterWeight => 'Registrar Peso';

  @override
  String get batchRegisterConsumption => 'Registrar Consumo';

  @override
  String get batchRegisterProduction => 'Registrar Producción';

  @override
  String get batchTabMortality => 'Mortalidad';

  @override
  String get batchTabWeight => 'Peso';

  @override
  String get batchTabConsumption => 'Consumo';

  @override
  String get batchTabProduction => 'Producción';

  @override
  String get batchTabHistory => 'Historial';

  @override
  String get batchTabVaccination => 'Vacunación';

  @override
  String get batchNavSummary => 'Resumen';

  @override
  String get batchPutInQuarantine => 'Poner en Cuarentena';

  @override
  String batchQuarantineConfirm(Object code) {
    return '¿Está seguro de poner \"$code\" en cuarentena?';
  }

  @override
  String get batchQuarantineReasonHint => 'Ej: Sospecha de enfermedad';

  @override
  String get batchAlreadyInQuarantine => 'El lote ya está en cuarentena';

  @override
  String get batchQuarantineReason => 'Motivo de cuarentena';

  @override
  String get batchPutInQuarantineSuccess => 'Lote puesto en cuarentena';

  @override
  String get batchAlreadyClosed => 'El lote ya está cerrado';

  @override
  String get batchInfoCopied => 'Información copiada al portapapeles';

  @override
  String get batchCannotDeleteActive => 'No se puede eliminar un lote activo';

  @override
  String get batchDescribeReason => 'Describe el motivo...';

  @override
  String batchReasonForState(Object status) {
    return 'Motivo de $status';
  }

  @override
  String get batchBatchHistory => 'Historial del Lote';

  @override
  String get batchHistoryComingSoon => 'Historial próximamente';

  @override
  String get batchRequiresAttention => 'Requiere Atención';

  @override
  String get batchNeedsReview => 'Este lote necesita revisión';

  @override
  String get batchOverdue => 'Vencido';

  @override
  String batchOfBirds(Object count) {
    return 'de $count aves';
  }

  @override
  String get batchWithinLimits => 'Dentro de límites aceptables';

  @override
  String get batchIndicators => 'Indicadores';

  @override
  String get batchWeeks => 'semanas';

  @override
  String get batchAverage => 'promedio';

  @override
  String get batchMortality => 'Mortalidad';

  @override
  String batchOfAmount(Object count) {
    return 'de $count';
  }

  @override
  String get batchQuickActions => 'Acciones Rápidas';

  @override
  String get batchBatchStatus => 'Estado del Lote';

  @override
  String get batchGeneralInfo => 'Información General';

  @override
  String get batchCodeLabel => 'Código';

  @override
  String get batchSupplier => 'Proveedor';

  @override
  String get batchLatestRecords => 'Últimos Registros';

  @override
  String get batchNoRecentRecords => 'Sin registros recientes';

  @override
  String get batchRecordsWillAppear => 'Los registros aparecerán aquí';

  @override
  String get batchErrorLoadingBatch => 'Error al cargar el lote';

  @override
  String get batchEditBatchTooltip => 'Editar lote';

  @override
  String get batchNotes => 'Notas';

  @override
  String batchErrorDetail(Object error) {
    return 'Error: $error';
  }

  @override
  String get batchStatusDescActive => 'El lote está en producción activa';

  @override
  String get batchStatusDescClosed => 'El lote ha sido cerrado';

  @override
  String get batchStatusDescQuarantine => 'El lote está en cuarentena';

  @override
  String get batchStatusDescSold => 'El lote ha sido vendido';

  @override
  String get batchStatusDescTransfer => 'El lote ha sido transferido';

  @override
  String get batchStatusDescSuspended => 'El lote está suspendido';

  @override
  String get batchCreating => 'Creando lote...';

  @override
  String get batchUpdating => 'Actualizando lote...';

  @override
  String get batchDeleting => 'Eliminando lote...';

  @override
  String get batchRegisteringMortality => 'Registrando mortalidad...';

  @override
  String get batchMortalityRegistered => 'Mortalidad registrada';

  @override
  String get batchRegisteringDiscard => 'Registrando descarte...';

  @override
  String get batchDiscardRegistered => 'Descarte registrado';

  @override
  String get batchRegisteringSale => 'Registrando venta...';

  @override
  String get batchSaleRegistered => 'Venta registrada';

  @override
  String get batchUpdatingWeight => 'Actualizando peso...';

  @override
  String get batchWeightUpdated => 'Peso actualizado';

  @override
  String get batchChangingStatus => 'Cambiando estado...';

  @override
  String batchStatusChangedTo(Object status) {
    return 'Estado cambiado a $status';
  }

  @override
  String get batchRegisteringFullSale => 'Registrando venta completa...';

  @override
  String get batchMarkedAsSold => 'Lote marcado como vendido';

  @override
  String get batchTransferring => 'Transfiriendo lote...';

  @override
  String get batchTransferredSuccess => 'Lote transferido exitosamente';

  @override
  String get batchSelectEntryDate => 'Seleccione la fecha de ingreso';

  @override
  String get batchMin3Chars => 'Mínimo 3 caracteres';

  @override
  String get batchFilterBatches => 'Filtrar Lotes';

  @override
  String get batchStatus => 'Estado';

  @override
  String get batchFrom => 'Desde';

  @override
  String get batchTo => 'Hasta';

  @override
  String get batchAny => 'Cualquiera';

  @override
  String get batchCloseBatchTitle => 'Cerrar Lote';

  @override
  String batchCloseConfirmation(Object code) {
    return '¿Está seguro de cerrar el lote \"$code\"?';
  }

  @override
  String get batchCloseWarning =>
      'Esta acción es irreversible. El lote será marcado como cerrado.';

  @override
  String get batchCloseFinalSummary => 'Resumen Final';

  @override
  String get batchCloseEntryDate => 'Fecha de ingreso';

  @override
  String get batchCloseCloseDate => 'Fecha de cierre';

  @override
  String batchCloseDurationDays(Object days) {
    return 'Duración: $days días';
  }

  @override
  String get batchCloseInitialBirds => 'Aves iniciales';

  @override
  String get batchCloseFinalBirds => 'Aves finales';

  @override
  String get batchCloseFinalMortality => 'Mortalidad final';

  @override
  String get batchCloseObservations => 'Observaciones de cierre';

  @override
  String get batchCloseOptionalNotes =>
      'Notas opcionales sobre el cierre del lote...';

  @override
  String get batchCloseSuccess => 'Lote cerrado exitosamente';

  @override
  String batchCloseError(Object error) {
    return 'Error al cerrar el lote: $error';
  }

  @override
  String get batchTransferTitle => 'Transferir Lote';

  @override
  String batchTransferConfirm(String shed, Object code) {
    return '¿Transferir \"$code\" al galpón $shed?';
  }

  @override
  String get batchTransferSelectShed => 'Seleccionar galpón destino';

  @override
  String get batchTransferNoSheds => 'No hay galpones disponibles';

  @override
  String get batchTransferReason => 'Motivo de transferencia';

  @override
  String get batchSellTitle => 'Vender Lote Completo';

  @override
  String batchSellConfirm(Object code) {
    return '¿Registrar la venta completa del lote \"$code\"?';
  }

  @override
  String batchSellBirdsCount(Object count) {
    return 'Aves a vender: $count';
  }

  @override
  String get batchSellPricePerUnit => 'Precio por unidad';

  @override
  String get batchSellTotalPrice => 'Precio total';

  @override
  String get batchSellBuyer => 'Comprador';

  @override
  String get batchFormStepBasicInfo => 'Información Básica';

  @override
  String get batchFormStepDetails => 'Detalles';

  @override
  String get batchFormStepReview => 'Revisión';

  @override
  String get batchFormCode => 'Código del lote';

  @override
  String get batchFormCodeHint => 'Ej: LOTE-001';

  @override
  String get batchFormBirdType => 'Tipo de ave';

  @override
  String get batchFormSelectType => 'Seleccionar tipo';

  @override
  String get batchFormInitialCount => 'Cantidad inicial';

  @override
  String get batchFormCountHint => 'Ej: 500';

  @override
  String get batchFormEntryDate => 'Fecha de ingreso';

  @override
  String get batchFormExpectedClose => 'Fecha estimada de cierre';

  @override
  String get batchFormShed => 'Galpón';

  @override
  String get batchFormSelectShed => 'Seleccionar galpón';

  @override
  String get batchFormSupplier => 'Proveedor';

  @override
  String get batchFormSupplierHint => 'Nombre del proveedor (opcional)';

  @override
  String get batchFormNotes => 'Notas adicionales';

  @override
  String get batchFormNotesHint => 'Observaciones sobre el lote (opcional)';

  @override
  String get batchFormDeathCount => 'Cantidad de muertes';

  @override
  String get batchFormDeathCountHint => 'Ingrese la cantidad';

  @override
  String get batchFormCause => 'Causa';

  @override
  String get batchFormCauseHint => 'Causa de mortalidad (opcional)';

  @override
  String get batchFormDate => 'Fecha';

  @override
  String get batchFormObservations => 'Observaciones';

  @override
  String get batchFormObservationsHint =>
      'Observaciones adicionales (opcional)';

  @override
  String get batchFormWeight => 'Peso (kg)';

  @override
  String get batchFormWeightHint => 'Peso promedio en kg';

  @override
  String get batchFormSampleSize => 'Tamaño de muestra';

  @override
  String get batchFormSampleSizeHint => 'Ej: 10';

  @override
  String get batchFormMethodHint => 'Método de pesaje';

  @override
  String get batchFormFoodType => 'Tipo de alimento';

  @override
  String get batchFormSelectFoodType => 'Seleccionar tipo de alimento';

  @override
  String get batchFormQuantityKg => 'Cantidad (kg)';

  @override
  String get batchFormQuantityHint => 'Cantidad en kg';

  @override
  String get batchFormCostPerKg => 'Costo por kg';

  @override
  String get batchFormCostHint => 'Costo en \$ (opcional)';

  @override
  String get batchFormEggCount => 'Cantidad de huevos';

  @override
  String get batchFormEggCountHint => 'Total de huevos recolectados';

  @override
  String get batchFormEggQuality => 'Calidad del huevo';

  @override
  String get batchFormSelectQuality => 'Seleccionar calidad';

  @override
  String get batchFormDiscardCount => 'Cantidad de descartes';

  @override
  String get batchFormDiscardCountHint => 'Ej: 5';

  @override
  String get batchFormDiscardReason => 'Motivo del descarte';

  @override
  String get batchFormDiscardReasonHint => 'Motivo del descarte (opcional)';

  @override
  String get batchHistoryMortality => 'Historial de Mortalidad';

  @override
  String get batchHistoryWeight => 'Historial de Peso';

  @override
  String get batchHistoryConsumption => 'Historial de Consumo';

  @override
  String get batchHistoryProduction => 'Historial de Producción';

  @override
  String get batchHistoryNoRecords => 'Sin registros';

  @override
  String get batchHistoryNoRecordsDesc => 'No hay registros para mostrar';

  @override
  String get batchBirdsLabel => 'aves';

  @override
  String get batchBirdLabel => 'ave';

  @override
  String get batchKgLabel => 'kg';

  @override
  String get batchEggsLabel => 'huevos';

  @override
  String get batchUnitLabel => 'unidades';

  @override
  String get batchPercentSign => '%';

  @override
  String get batchDaysLabel => 'días';

  @override
  String get batchDayLabel => 'día';

  @override
  String get batchCopyInfo => 'Copiar información';

  @override
  String get batchShareInfo => 'Compartir información';

  @override
  String get batchViewHistory => 'Ver historial completo';

  @override
  String get batchNoShedsAvailable => 'No hay galpones disponibles';

  @override
  String get batchCreateShedFirst => 'Crea un galpón primero';

  @override
  String batchStepOf(Object current, Object total) {
    return 'Paso $current de $total';
  }

  @override
  String get batchReviewCreateBatch => 'Revisar y Crear Lote';

  @override
  String get batchCreated => 'Lote creado exitosamente';

  @override
  String get batchConfirmExit => '¿Desea salir?';

  @override
  String get batchConfirmExitDesc => 'Los datos del formulario se perderán';

  @override
  String get batchStay => 'Quedarse';

  @override
  String get batchLeave => 'Salir';

  @override
  String get batchUnsavedChanges => 'Cambios sin guardar';

  @override
  String get batchExitWithoutSaving => '¿Salir sin guardar los cambios?';

  @override
  String get batchLoadingBatch => 'Cargando lote...';

  @override
  String get batchLoadingData => 'Cargando datos...';

  @override
  String get batchRetry => 'Reintentar';

  @override
  String get batchNoData => 'Sin datos';

  @override
  String get batchNoBatches => 'Sin lotes';

  @override
  String get batchLotesHome => 'Lotes';

  @override
  String get batchClosed => 'Cerrados';

  @override
  String get batchSuspended => 'Suspendidos';

  @override
  String get batchInQuarantine => 'En cuarentena';

  @override
  String get batchSold => 'Vendido';

  @override
  String get batchTransfer => 'Transferencia';

  @override
  String batchDaysCount(Object count) {
    return '$count días';
  }

  @override
  String get batchNoNotes => 'Sin notas';

  @override
  String get batchShedLabel => 'Galpón';

  @override
  String get batchActions => 'Acciones';

  @override
  String get batchWhatWantToDo => '¿Qué deseas hacer con este lote?';

  @override
  String get batchDeleteWarning => 'Esta acción no se puede deshacer';

  @override
  String batchAgeWeeks(Object weeks) {
    return '$weeks sem';
  }

  @override
  String batchAgeDays(Object days) {
    return '$days días';
  }

  @override
  String batchMortalityRate(String rate) {
    return 'Mortalidad: $rate%';
  }

  @override
  String get batchRecordAdded => 'Registro agregado exitosamente';

  @override
  String get batchRecordError => 'Error al agregar registro';

  @override
  String get batchTotalConsumed => 'Total consumido';

  @override
  String get batchTotalProduced => 'Total producido';

  @override
  String get batchProductionRate => 'Tasa de producción';

  @override
  String get batchSelectDate => 'Seleccionar fecha';

  @override
  String get batchVaccinationHistory => 'Historial de Vacunación';

  @override
  String get batchNoVaccinations => 'Sin vacunaciones registradas';

  @override
  String get batchDeaths => 'muertes';

  @override
  String get batchDiscards => 'descartes';

  @override
  String get batchAverageWeight => 'Peso promedio';

  @override
  String get batchSamples => 'muestras';

  @override
  String get batchConsumed => 'consumido';

  @override
  String get batchEggsCollected => 'huevos';

  @override
  String get batchBrokenDiscarded => 'rotos/descartados';

  @override
  String get batchTotal => 'Total';

  @override
  String get batchLastRecord => 'Último registro';

  @override
  String batchRemainingBirds(Object count) {
    return 'Aves restantes: $count';
  }

  @override
  String batchExceedsCurrentBirds(Object count) {
    return 'La cantidad excede las aves actuales ($count)';
  }

  @override
  String get batchFutureDateNotAllowed => 'La fecha no puede ser futura';

  @override
  String get batchRequiredField => 'Campo requerido';

  @override
  String get batchInvalidNumber => 'Número inválido';

  @override
  String get batchMustBePositive => 'Debe ser mayor a 0';

  @override
  String get batchMustBeGreaterThanZero => 'Debe ser mayor que 0';

  @override
  String get batchProduction => 'Producción';

  @override
  String get batchConsumption => 'Consumo';

  @override
  String get batchMortalityLabel => 'Mortalidad';

  @override
  String get batchVaccination => 'Vacunación';

  @override
  String get batchInfoGeneral => 'Información general';

  @override
  String get batchTitle => 'Lotes';

  @override
  String get batchDeleteBatch => 'Eliminar Lote';

  @override
  String get batchFilterTitle => 'Filtrar Lotes';

  @override
  String get batchFilterClear => 'Limpiar';

  @override
  String get batchFilterStatus => 'Estado';

  @override
  String get batchFilterAll => 'Todos';

  @override
  String get batchFilterBirdType => 'Tipo de ave';

  @override
  String get batchFilterEntryDate => 'Fecha de ingreso';

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
  String get batchCloseSummary => 'Resumen de Cierre';

  @override
  String get batchCloseStartDate => 'Fecha de inicio';

  @override
  String get batchCloseEndDate => 'Fecha de cierre';

  @override
  String get batchCloseDate => 'Fecha de cierre';

  @override
  String get batchCloseDuration => 'Duración';

  @override
  String get batchCloseDays => 'días';

  @override
  String get batchCloseCycleDuration => 'Duración del ciclo';

  @override
  String get batchCloseCycleInfo => 'Información del ciclo';

  @override
  String get batchClosePopulation => 'Población';

  @override
  String get batchCloseTotalMortality => 'Mortalidad total';

  @override
  String get batchCloseMortality => 'Mortalidad';

  @override
  String get batchCloseMortalityPercent => '% de mortalidad';

  @override
  String get batchCloseFinalMetrics => 'Métricas Finales';

  @override
  String get batchCloseFinalWeight => 'Peso final';

  @override
  String get batchCloseFinalWeightLabel => 'Peso final (kg)';

  @override
  String get batchCloseWeightGain => 'Ganancia de peso';

  @override
  String get batchCloseEstimatedWeight => 'Peso estimado';

  @override
  String get batchCloseFeedConversion => 'Conversión alimenticia';

  @override
  String get batchCloseGrams => 'gramos';

  @override
  String get batchCloseWeightRequired => 'El peso es requerido';

  @override
  String get batchCloseWeightMustBePositive => 'El peso debe ser positivo';

  @override
  String get batchCloseWeightTooHigh => 'El peso parece demasiado alto';

  @override
  String get batchCloseWeightHelper => 'Peso promedio por ave en kg';

  @override
  String get batchCloseFinalObservations => 'Observaciones Finales';

  @override
  String get batchCloseObservationsHint => 'Escriba sus observaciones aquí...';

  @override
  String get batchCloseIrreversible => 'Acción irreversible';

  @override
  String get batchCloseIrreversibleMessage =>
      'Una vez cerrado, el lote no podrá reabrirse';

  @override
  String get batchCloseConfirm => 'Confirmar cierre';

  @override
  String get batchCloseSaleInfo => 'Información de Venta';

  @override
  String get batchCloseBirdsToSell => 'Aves a vender';

  @override
  String get batchCloseBirdsUnit => 'aves';

  @override
  String get batchCloseSalePriceLabel => 'Precio de venta por kg';

  @override
  String get batchCloseSalePriceHelper => 'Precio en moneda local';

  @override
  String get batchClosePricePerKg => 'Precio por kg';

  @override
  String get batchCloseEstimatedValue => 'Valor estimado';

  @override
  String get batchCloseBuyerLabel => 'Comprador';

  @override
  String get batchCloseBuyerHint => 'Nombre del comprador (opcional)';

  @override
  String get batchCloseFinancialBalance => 'Balance financiero';

  @override
  String get batchCloseTotalIncome => 'Ingresos totales';

  @override
  String get batchCloseTotalExpenses => 'Gastos totales';

  @override
  String get batchCloseProfitability => 'Rentabilidad';

  @override
  String get batchCloseEnterValidNumber => 'Ingrese un número válido';

  @override
  String get batchFormName => 'Nombre del lote';

  @override
  String get batchFormBasicInfoSubtitle => 'Información básica del lote';

  @override
  String get batchFormBasicInfoNote =>
      'Complete la información básica del lote';

  @override
  String get batchFormDetailsSubtitle => 'Detalles adicionales del lote';

  @override
  String get batchFormReviewSubtitle => 'Revise la información antes de crear';

  @override
  String get batchFormFarm => 'Granja';

  @override
  String get batchFormLocation => 'Ubicación';

  @override
  String get batchFormShedInfo => 'Información del galpón';

  @override
  String get batchFormShedLocationInfo => 'Ubicación del galpón';

  @override
  String get batchFormCapacity => 'Capacidad';

  @override
  String get batchFormMaxCapacity => 'Capacidad máxima';

  @override
  String get batchFormArea => 'Área';

  @override
  String get batchFormAvailable => 'Disponible';

  @override
  String get batchFormShedCapacity => 'Capacidad del galpón';

  @override
  String get batchFormShedCapacityNote =>
      'La cantidad no puede exceder la capacidad';

  @override
  String get batchFormExceedsCapacity => 'Excede la capacidad del galpón';

  @override
  String get batchFormUtilization => 'Utilización';

  @override
  String get batchFormCreateShedFirst => 'Cree un galpón primero';

  @override
  String get batchFormAgeAtEntry => 'Edad al ingreso';

  @override
  String get batchFormAgeHint => 'Edad en días (opcional)';

  @override
  String get batchFormAgeInfoNote => 'La edad se calcula automáticamente';

  @override
  String get batchFormOptional => 'Opcional';

  @override
  String get batchFormNotSelected => 'No seleccionado';

  @override
  String get batchFormNotSpecified => 'No especificado';

  @override
  String get batchFormNotFound => 'No encontrado';

  @override
  String get batchFormUnits => 'unidades';

  @override
  String get batchFormDirty => 'Sucio';

  @override
  String get batchFormCurrentBirds => 'Aves actuales';

  @override
  String get batchFormInvalidNumber => 'Número inválido';

  @override
  String get batchFormInvalidValue => 'Valor inválido';

  @override
  String get batchFormMortalityEventInfo =>
      'Información del evento de mortalidad';

  @override
  String get batchFormMortalityEventSubtitle =>
      'Registre los detalles del evento';

  @override
  String get batchFormMortalityDetailsTitle => 'Detalles de Mortalidad';

  @override
  String get batchFormMortalityDetailsSubtitle =>
      'Describa los detalles adicionales';

  @override
  String get batchFormMortalityDescription => 'Descripción de mortalidad';

  @override
  String get batchFormMortalityDescriptionHint =>
      'Describa las circunstancias...';

  @override
  String get batchFormRecommendation => 'Recomendación';

  @override
  String get batchFormRecommendedActions => 'Acciones recomendadas';

  @override
  String get batchFormPhotoEvidence => 'Evidencia fotográfica';

  @override
  String get batchFormPhotoOptional => 'Fotos opcionales';

  @override
  String get batchFormPhotoHelpText => 'Tome o seleccione fotos como evidencia';

  @override
  String get batchFormNoPhotos => 'Sin fotos';

  @override
  String get batchFormMaxPhotos => 'Máximo de fotos alcanzado';

  @override
  String get batchFormSelectedPhotos => 'Fotos seleccionadas';

  @override
  String get batchFormTakePhoto => 'Tomar foto';

  @override
  String get batchFormGallery => 'Galería';

  @override
  String get batchFormObservationsAndEvidence => 'Observaciones y Evidencia';

  @override
  String get batchFormObservationsSubtitle =>
      'Agregue observaciones adicionales';

  @override
  String get batchFormWeightInfo => 'Información de Peso';

  @override
  String get batchFormWeightSubtitle => 'Registre el peso del lote';

  @override
  String get batchFormWeightMethod => 'Método de pesaje';

  @override
  String get batchFormWeightRanges => 'Rangos de Peso';

  @override
  String get batchFormWeightRangesSubtitle => 'Clasifique por rangos de peso';

  @override
  String get batchFormWeightMin => 'Peso mínimo';

  @override
  String get batchFormWeightMax => 'Peso máximo';

  @override
  String get batchFormWeightSummary => 'Resumen de Peso';

  @override
  String get batchFormWeightSummarySubtitle =>
      'Resumen de los datos registrados';

  @override
  String get batchFormAutoCalculatedWeight => 'Peso calculado automáticamente';

  @override
  String get batchFormCalculatedAvgWeight => 'Peso promedio calculado';

  @override
  String get batchFormCalculatedMetrics => 'Métricas calculadas';

  @override
  String get batchFormMetricsAutoCalculated =>
      'Las métricas se calculan automáticamente';

  @override
  String get batchFormConsumptionInfo => 'Información de Consumo';

  @override
  String get batchFormConsumptionSubtitle => 'Registre el consumo de alimento';

  @override
  String get batchFormConsumptionSaveNote =>
      'Los datos se guardarán al continuar';

  @override
  String get batchFormFoodFromInventory => 'Alimento del inventario';

  @override
  String get batchFormSelectFoodHint => 'Seleccione un alimento';

  @override
  String get batchFormNoFoodInInventory => 'No hay alimentos en inventario';

  @override
  String get batchFormFoodBatch => 'Lote de alimento';

  @override
  String get batchFormLowStock => 'Stock bajo';

  @override
  String get batchFormDetailsCosts => 'Detalles y Costos';

  @override
  String get batchFormDetailsCostsSubtitle => 'Ingrese detalles y costos';

  @override
  String get batchFormCostPerBird => 'Costo por ave';

  @override
  String get batchFormCostThisRecord => 'Costo de este registro';

  @override
  String get batchFormProductionInfo => 'Información de Producción';

  @override
  String get batchFormProductionInfoSubtitle =>
      'Registre la producción de huevos';

  @override
  String get batchFormEggsCollected => 'Huevos recolectados';

  @override
  String get batchFormDefectiveEggs => 'Huevos defectuosos';

  @override
  String get batchFormLayingPercentage => 'Porcentaje de postura';

  @override
  String get batchFormLayingIndicator => 'Indicador de postura';

  @override
  String get batchFormExcellentPerformance => 'Rendimiento excelente';

  @override
  String get batchFormAcceptablePerformance => 'Rendimiento aceptable';

  @override
  String get batchFormBelowExpectedPerformance =>
      'Rendimiento por debajo de lo esperado';

  @override
  String get batchFormProductionSummary => 'Resumen de producción';

  @override
  String get batchFormCompleteAmountToSeeMetrics =>
      'Complete la cantidad para ver métricas';

  @override
  String get batchFormEggClassification => 'Clasificación de Huevos';

  @override
  String get batchFormEggClassificationSubtitle =>
      'Clasifique los huevos recolectados';

  @override
  String get batchFormClassifyForWeight => 'Clasificar por peso';

  @override
  String get batchFormSmallEggs => 'Huevos pequeños';

  @override
  String get batchFormMediumEggs => 'Huevos medianos';

  @override
  String get batchFormLargeEggs => 'Huevos grandes';

  @override
  String get batchFormExtraLargeEggs => 'Huevos extra grandes';

  @override
  String get batchFormBroken => 'Rotos';

  @override
  String get batchFormGoodEggs => 'Huevos buenos';

  @override
  String get batchFormTotalClassified => 'Total clasificados';

  @override
  String get batchFormTotalToClassify => 'Total a clasificar';

  @override
  String get batchFormClassificationSummary => 'Resumen de clasificación';

  @override
  String get batchFormCannotExceedCollected =>
      'No puede exceder los huevos recolectados';

  @override
  String get batchFormExcessEggs => 'Exceso de huevos clasificados';

  @override
  String get batchFormMissingEggs => 'Faltan huevos por clasificar';

  @override
  String get batchFormSizeClassification => 'Clasificación por tamaño';

  @override
  String get birdTypeBroiler => 'Pollo de Engorde';

  @override
  String get birdTypeLayer => 'Gallina Ponedora';

  @override
  String get birdTypeHeavyBreeder => 'Reproductora Pesada';

  @override
  String get birdTypeLightBreeder => 'Reproductora Liviana';

  @override
  String get birdTypeTurkey => 'Pavo';

  @override
  String get birdTypeQuail => 'Codorniz';

  @override
  String get birdTypeDuck => 'Pato';

  @override
  String get birdTypeOther => 'Otro';

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
  String get birdTypeShortOther => 'Otro';

  @override
  String get batchStatusInTransfer => 'En Transferencia';

  @override
  String get batchStatusDescInTransfer => 'Lote siendo transferido';

  @override
  String get weighMethodManual => 'Manual';

  @override
  String get weighMethodIndividualScale => 'Báscula Individual';

  @override
  String get weighMethodBatchScale => 'Báscula de Lote';

  @override
  String get weighMethodAutomatic => 'Automática';

  @override
  String get weighMethodDescManual => 'Manual con báscula';

  @override
  String get weighMethodDescIndividualScale => 'Báscula individual';

  @override
  String get weighMethodDescBatchScale => 'Báscula de lote';

  @override
  String get weighMethodDescAutomatic => 'Sistema automático';

  @override
  String get weighMethodDetailManual =>
      'Pesaje ave por ave con báscula portátil';

  @override
  String get weighMethodDetailIndividualScale =>
      'Báscula electrónica para una ave';

  @override
  String get weighMethodDetailBatchScale =>
      'Pesaje grupal dividido entre cantidad';

  @override
  String get weighMethodDetailAutomatic => 'Sistema automatizado integrado';

  @override
  String get feedTypePreStarter => 'Pre-iniciador';

  @override
  String get feedTypeStarter => 'Iniciador';

  @override
  String get feedTypeGrower => 'Crecimiento';

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
  String get feedTypeOther => 'Otro';

  @override
  String get feedTypeDescPreStarter => 'Pre-iniciador (0-7 días)';

  @override
  String get feedTypeDescStarter => 'Iniciador (8-21 días)';

  @override
  String get feedTypeDescGrower => 'Crecimiento (22-35 días)';

  @override
  String get feedTypeDescFinisher => 'Finalizador (36+ días)';

  @override
  String get feedTypeDescLayer => 'Postura';

  @override
  String get feedTypeDescRearing => 'Levante';

  @override
  String get feedTypeDescMedicated => 'Medicado';

  @override
  String get feedTypeDescConcentrate => 'Concentrado';

  @override
  String get feedTypeDescOther => 'Otro';

  @override
  String get feedAgeRangePreStarter => '0-7 días';

  @override
  String get feedAgeRangeStarter => '8-21 días';

  @override
  String get feedAgeRangeGrower => '22-35 días';

  @override
  String get feedAgeRangeFinisher => '36+ días';

  @override
  String get feedAgeRangeLayer => 'Gallinas ponedoras';

  @override
  String get feedAgeRangeRearing => 'Pollitas reemplazo';

  @override
  String get feedAgeRangeMedicated => 'Con tratamiento';

  @override
  String get feedAgeRangeConcentrate => 'Suplemento';

  @override
  String get feedAgeRangeOther => 'Uso general';

  @override
  String get eggClassSmall => 'Pequeño';

  @override
  String get eggClassMedium => 'Mediano';

  @override
  String get eggClassLarge => 'Grande';

  @override
  String get eggClassExtraLarge => 'Extra Grande';

  @override
  String get validateBatchQuantityMin =>
      'La cantidad inicial debe ser al menos 10 aves';

  @override
  String get validateBatchQuantityMax =>
      'La cantidad inicial no puede exceder 100,000 aves';

  @override
  String get validateMortalityMin =>
      'La cantidad de mortalidad debe ser mayor a 0';

  @override
  String validateMortalityExceedsCurrent(Object current, Object mortality) {
    return 'La cantidad de mortalidad ($mortality) no puede exceder la cantidad actual ($current)';
  }

  @override
  String get validateWeightMin => 'El peso debe ser mayor a 0 gramos';

  @override
  String get validateWeightMax =>
      'El peso no puede exceder 20,000 gramos (20 kg)';

  @override
  String get validateFeedMin => 'La cantidad de alimento debe ser mayor a 0';

  @override
  String get validateFeedMax =>
      'La cantidad de alimento no puede exceder 10,000 kg';

  @override
  String get validateEggLayerOnly =>
      'Solo los lotes de ponedoras pueden producir huevos';

  @override
  String get validateEggMin => 'La cantidad de huevos debe ser mayor a 0';

  @override
  String validateEggRateHigh(Object rate) {
    return 'La tasa de postura del $rate% parece muy alta. Verifique los datos.';
  }

  @override
  String get validateDateFuture => 'La fecha de ingreso no puede ser futura';

  @override
  String get validateDateTooOld =>
      'La fecha de ingreso parece muy antigua (más de 5 años)';

  @override
  String get validateCloseDateBeforeEntry =>
      'La fecha de cierre no puede ser anterior a la fecha de ingreso';

  @override
  String get validateCloseDateFuture =>
      'La fecha de cierre no puede ser futura';

  @override
  String validateCodeExists(Object code) {
    return 'Ya existe otro lote con el código \"$code\"';
  }

  @override
  String get batchRecordingMortality => 'Registrando mortalidad...';

  @override
  String get batchRecordingDiscard => 'Registrando descarte...';

  @override
  String get batchRecordingSale => 'Registrando venta...';

  @override
  String get batchMarkingSold => 'Registrando venta completa...';

  @override
  String get batchCreatedSuccess => 'Lote creado exitosamente';

  @override
  String get batchUpdatedSuccess => 'Lote actualizado exitosamente';

  @override
  String get batchMortalityRecorded => 'Mortalidad registrada';

  @override
  String get batchDiscardRecorded => 'Descarte registrado';

  @override
  String get batchSaleRecorded => 'Venta registrada';

  @override
  String get batchMarkedSold => 'Lote marcado como vendido';

  @override
  String get validateSelectBirdType => 'Seleccione el tipo de ave';

  @override
  String get validateSelectEntryDate => 'Seleccione la fecha de ingreso';

  @override
  String get validateCodeRequired => 'El código es obligatorio';

  @override
  String get validateCodeMinLength => 'Mínimo 3 caracteres';

  @override
  String get validateQuantityValid => 'Ingrese una cantidad válida';

  @override
  String get saleProductLiveBirds => 'Aves Vivas';

  @override
  String get saleProductLiveBirdsDesc => 'Venta de aves en pie';

  @override
  String get saleProductEggs => 'Huevos';

  @override
  String get saleProductEggsDesc => 'Venta de huevos por clasificación';

  @override
  String get saleProductManure => 'Pollinaza/Gallinaza';

  @override
  String get saleProductManureDesc => 'Subproducto orgánico';

  @override
  String get saleProductProcessedBirds => 'Aves Faenadas';

  @override
  String get saleProductProcessedBirdsDesc => 'Aves procesadas para consumo';

  @override
  String get saleProductCullBirds => 'Aves de Descarte';

  @override
  String get saleProductCullBirdsDesc => 'Aves al final del ciclo productivo';

  @override
  String get saleStatusPending => 'Pendiente';

  @override
  String get saleStatusPendingDesc => 'Esperando confirmación';

  @override
  String get saleStatusConfirmed => 'Confirmada';

  @override
  String get saleStatusConfirmedDesc => 'Confirmada por el cliente';

  @override
  String get saleStatusInPreparation => 'En Preparación';

  @override
  String get saleStatusInPreparationDesc => 'Preparando producto';

  @override
  String get saleStatusReadyToShip => 'Lista para Despacho';

  @override
  String get saleStatusReadyToShipDesc => 'Lista para entregar';

  @override
  String get saleStatusInTransit => 'En Tránsito';

  @override
  String get saleStatusInTransitDesc => 'En camino al cliente';

  @override
  String get saleStatusDelivered => 'Entregada';

  @override
  String get saleStatusDeliveredDesc => 'Entregada exitosamente';

  @override
  String get saleStatusInvoiced => 'Facturada';

  @override
  String get saleStatusInvoicedDesc => 'Factura generada';

  @override
  String get saleStatusCancelled => 'Cancelada';

  @override
  String get saleStatusCancelledDesc => 'Cancelada';

  @override
  String get saleStatusReturned => 'Devuelta';

  @override
  String get saleStatusReturnedDesc => 'Devuelta por el cliente';

  @override
  String get orderStatusPending => 'Pendiente';

  @override
  String get orderStatusPendingDesc => 'Pedido en espera de confirmación';

  @override
  String get orderStatusConfirmed => 'Confirmado';

  @override
  String get orderStatusConfirmedDesc => 'Pedido aprobado';

  @override
  String get orderStatusInPreparation => 'En Preparación';

  @override
  String get orderStatusInPreparationDesc => 'Pedido siendo preparado';

  @override
  String get orderStatusReadyToShip => 'Listo Despacho';

  @override
  String get orderStatusReadyToShipDesc => 'Preparado para envío';

  @override
  String get orderStatusInTransit => 'En Tránsito';

  @override
  String get orderStatusInTransitDesc => 'Pedido en camino';

  @override
  String get orderStatusDelivered => 'Entregado';

  @override
  String get orderStatusDeliveredDesc => 'Pedido completado';

  @override
  String get orderStatusCancelled => 'Cancelado';

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
  String get saleUnitBagDesc => 'Bulto de 50 kg';

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
  String get saleEggClassMedium => 'Mediano';

  @override
  String get saleEggClassSmall => 'Pequeño';

  @override
  String get costTypeFeed => 'Alimento';

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
  String get costTypeWaterDesc => 'Consumo de agua';

  @override
  String get costTypeTransportDesc => 'Logística y movilización';

  @override
  String get costTypeAdminDesc => 'Gastos generales';

  @override
  String get costTypeDepreciationDesc => 'Desgaste de activos';

  @override
  String get costTypeFinancialDesc => 'Intereses y comisiones';

  @override
  String get costTypeOtherDesc => 'Gastos varios';

  @override
  String get costCategoryProduction => 'Costo de Producción';

  @override
  String get costCategoryPersonnel => 'Gastos de Personal';

  @override
  String get costCategoryOperating => 'Gastos Operativos';

  @override
  String get costCategoryDistribution => 'Gastos de Distribución';

  @override
  String get costCategoryAdmin => 'Gastos Administrativos';

  @override
  String get costCategoryDepreciation => 'Depreciación y Amortización';

  @override
  String get costCategoryFinancial => 'Gastos Financieros';

  @override
  String get costCategoryOther => 'Otros Gastos';

  @override
  String get costValidateConceptEmpty => 'El concepto no puede estar vacío';

  @override
  String get costValidateAmountPositive => 'El monto debe ser mayor a 0';

  @override
  String get costValidateBirdCountPositive =>
      'Cantidad de aves debe ser mayor a 0';

  @override
  String get costValidateApprovalNotRequired =>
      'Este gasto no requiere aprobación';

  @override
  String get costValidateAlreadyApproved => 'Este gasto ya está aprobado';

  @override
  String get costValidateRejectionReasonRequired =>
      'Debe proporcionar un motivo de rechazo';

  @override
  String get costCenterBatch => 'Lote';

  @override
  String get costCenterHouse => 'Casa';

  @override
  String get costCenterAdmin => 'Administrativa';

  @override
  String get invItemTypeFeed => 'Alimento';

  @override
  String get invItemTypeFeedDesc => 'Concentrados, granos y suplementos';

  @override
  String get invItemTypeMedicine => 'Medicamento';

  @override
  String get invItemTypeMedicineDesc => 'Fármacos y productos sanitarios';

  @override
  String get invItemTypeVaccine => 'Vacuna';

  @override
  String get invItemTypeVaccineDesc => 'Vacunas y biológicos';

  @override
  String get invItemTypeEquipment => 'Equipo';

  @override
  String get invItemTypeEquipmentDesc => 'Herramientas y maquinaria';

  @override
  String get invItemTypeSupply => 'Insumo';

  @override
  String get invItemTypeSupplyDesc => 'Material de cama, empaques, etc.';

  @override
  String get invItemTypeCleaning => 'Limpieza';

  @override
  String get invItemTypeCleaningDesc => 'Desinfectantes y productos de aseo';

  @override
  String get invItemTypeOther => 'Otro';

  @override
  String get invItemTypeOtherDesc => 'Items varios';

  @override
  String get invMovePurchase => 'Compra';

  @override
  String get invMovePurchaseDesc => 'Ingreso por adquisición';

  @override
  String get invMoveDonation => 'Donación';

  @override
  String get invMoveDonationDesc => 'Ingreso por donación';

  @override
  String get invMoveReturn => 'Devolución';

  @override
  String get invMoveReturnDesc => 'Ingreso por devolución de uso';

  @override
  String get invMoveAdjustUp => 'Ajuste (+)';

  @override
  String get invMoveAdjustUpDesc => 'Ajuste de inventario positivo';

  @override
  String get invMoveBatchConsumption => 'Consumo Lote';

  @override
  String get invMoveBatchConsumptionDesc => 'Salida por alimentación de aves';

  @override
  String get invMoveTreatment => 'Tratamiento';

  @override
  String get invMoveTreatmentDesc => 'Salida por aplicación de medicamento';

  @override
  String get invMoveVaccination => 'Vacunación';

  @override
  String get invMoveVaccinationDesc => 'Salida por aplicación de vacuna';

  @override
  String get invMoveShrinkage => 'Merma';

  @override
  String get invMoveShrinkageDesc => 'Pérdida por deterioro o vencimiento';

  @override
  String get invMoveAdjustDown => 'Ajuste (-)';

  @override
  String get invMoveAdjustDownDesc => 'Ajuste de inventario negativo';

  @override
  String get invMoveTransfer => 'Transferencia';

  @override
  String get invMoveTransferDesc => 'Traslado a otra ubicación';

  @override
  String get invMoveGeneralUse => 'Uso General';

  @override
  String get invMoveGeneralUseDesc => 'Salida por uso operativo';

  @override
  String get invMoveSale => 'Venta';

  @override
  String get invMoveSaleDesc => 'Salida por venta de productos';

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
  String get invUnitUnit => 'Unidad';

  @override
  String get invUnitDozen => 'Docena';

  @override
  String get invUnitSack => 'Saco';

  @override
  String get invUnitBag => 'Bulto';

  @override
  String get invUnitBox => 'Caja';

  @override
  String get invUnitVial => 'Frasco';

  @override
  String get invUnitDose => 'Dosis';

  @override
  String get invUnitAmpoule => 'Ampolla';

  @override
  String get invUnitCategoryWeight => 'Peso';

  @override
  String get invUnitCategoryVolume => 'Volumen';

  @override
  String get invUnitCategoryQuantity => 'Cantidad';

  @override
  String get invUnitCategoryPackaging => 'Empaque';

  @override
  String get invUnitCategoryApplication => 'Aplicación';

  @override
  String get healthDiseaseCatViral => 'Viral';

  @override
  String get healthDiseaseCatViralDesc => 'Enfermedades causadas por virus';

  @override
  String get healthDiseaseCatBacterial => 'Bacteriana';

  @override
  String get healthDiseaseCatBacterialDesc =>
      'Enfermedades causadas por bacterias';

  @override
  String get healthDiseaseCatParasitic => 'Parasitaria';

  @override
  String get healthDiseaseCatParasiticDesc =>
      'Enfermedades causadas por parásitos';

  @override
  String get healthDiseaseCatFungal => 'Fúngica';

  @override
  String get healthDiseaseCatFungalDesc => 'Enfermedades causadas por hongos';

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
      'Causadas por factores ambientales';

  @override
  String get healthSeverityMild => 'Leve';

  @override
  String get healthSeverityMildDesc => 'Bajo impacto en producción';

  @override
  String get healthSeverityModerate => 'Moderada';

  @override
  String get healthSeverityModerateDesc => 'Impacto medio en producción';

  @override
  String get healthSeveritySevere => 'Grave';

  @override
  String get healthSeveritySevereDesc =>
      'Alto impacto, requiere acción inmediata';

  @override
  String get healthSeverityCritical => 'Crítica';

  @override
  String get healthSeverityCriticalDesc => 'Emergencia sanitaria';

  @override
  String get healthDiseaseNewcastle => 'Enfermedad de Newcastle';

  @override
  String get healthDiseaseGumboro => 'Enfermedad de Gumboro (IBD)';

  @override
  String get healthDiseaseMarek => 'Enfermedad de Marek';

  @override
  String get healthDiseaseBronchitis => 'Bronquitis Infecciosa (IB)';

  @override
  String get healthDiseaseAvianFlu => 'Influenza Aviar (HPAI/LPAI)';

  @override
  String get healthDiseaseLaryngotracheitis =>
      'Laringotraqueitis Infecciosa (ILT)';

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
  String get healthDiseaseAscites => 'Síndrome Ascítico';

  @override
  String get healthDiseaseSuddenDeath => 'Síndrome de Muerte Súbita (SDS)';

  @override
  String get healthDiseaseVitEDeficiency => 'Encefalomalacia (Def. Vit E)';

  @override
  String get healthDiseaseRickets => 'Raquitismo (Def. Vit D/Ca/P)';

  @override
  String get healthMortalityDisease => 'Enfermedad';

  @override
  String get healthMortalityDiseaseDesc => 'Patología infecciosa';

  @override
  String get healthMortalityAccident => 'Accidente';

  @override
  String get healthMortalityAccidentDesc => 'Trauma o lesión';

  @override
  String get healthMortalityMalnutrition => 'Desnutrición';

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
  String get healthMortalityPredation => 'Depredación';

  @override
  String get healthMortalityPredationDesc => 'Ataques de animales';

  @override
  String get healthMortalitySacrifice => 'Sacrificio';

  @override
  String get healthMortalitySacrificeDesc => 'Muerte en faena';

  @override
  String get healthMortalityOldAge => 'Vejez';

  @override
  String get healthMortalityOldAgeDesc => 'Fin de vida productiva';

  @override
  String get healthMortalityUnknown => 'Desconocida';

  @override
  String get healthMortalityUnknownDesc => 'Causa no identificada';

  @override
  String get healthMortalityCatSanitary => 'Sanitaria';

  @override
  String get healthMortalityCatManagement => 'Manejo';

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
  String get healthActionVetDiagnosis => 'Solicitar diagnóstico veterinario';

  @override
  String get healthActionIsolate => 'Aislar aves afectadas';

  @override
  String get healthActionTreatment => 'Aplicar tratamiento si está disponible';

  @override
  String get healthActionBiosecurity => 'Aumentar bioseguridad';

  @override
  String get healthActionVaccinationReview => 'Revisar programa de vacunación';

  @override
  String get healthActionInspectFacilities => 'Inspeccionar instalaciones';

  @override
  String get healthActionRepairEquipment => 'Reparar equipos dañados';

  @override
  String get healthActionCheckDensity => 'Revisar densidad de aves';

  @override
  String get healthActionTrainStaff => 'Capacitar personal en manejo';

  @override
  String get healthActionCheckFoodAccess => 'Verificar acceso al alimento';

  @override
  String get healthActionCheckFoodQuality => 'Revisar calidad del alimento';

  @override
  String get healthActionCheckDrinkers =>
      'Comprobar funcionamiento de bebederos';

  @override
  String get healthActionAdjustNutrition => 'Ajustar programa nutricional';

  @override
  String get healthActionRegulateTemp => 'Regular temperatura ambiente';

  @override
  String get healthActionImproveVentilation => 'Mejorar ventilación';

  @override
  String get healthActionReduceDensity => 'Reducir densidad si es necesario';

  @override
  String get healthActionConsultNutritionist => 'Consultar con nutricionista';

  @override
  String get healthActionReviewGrowthProgram =>
      'Revisar programa de crecimiento';

  @override
  String get healthActionAdjustFormula => 'Ajustar formulación del alimento';

  @override
  String get healthActionReinforceFences => 'Reforzar cercos perimetrales';

  @override
  String get healthActionPestControl => 'Implementar control de plagas';

  @override
  String get healthActionInstallNets => 'Instalar mallas de protección';

  @override
  String get healthActionNormalProcess => 'Normal en el proceso productivo';

  @override
  String get healthActionRequestNecropsy =>
      'Solicitar necropsia si mortalidad es alta';

  @override
  String get healthActionIncreaseMonitoring => 'Aumentar monitoreo del lote';

  @override
  String get healthActionConsultVet => 'Consultar con veterinario';

  @override
  String get healthRouteOral => 'Oral';

  @override
  String get healthRouteOralDesc => 'Administración por vía oral';

  @override
  String get healthRouteWater => 'En Agua';

  @override
  String get healthRouteWaterDesc => 'Disuelta en agua de bebida';

  @override
  String get healthRouteFood => 'En Alimento';

  @override
  String get healthRouteFoodDesc => 'Mezclado en el alimento';

  @override
  String get healthRouteOcular => 'Ocular';

  @override
  String get healthRouteOcularDesc => 'Gota en el ojo';

  @override
  String get healthRouteNasal => 'Nasal';

  @override
  String get healthRouteNasalDesc => 'Spray o gota nasal';

  @override
  String get healthRouteSpray => 'Spray';

  @override
  String get healthRouteSprayDesc => 'Aspersión sobre las aves';

  @override
  String get healthRouteSubcutaneous => 'Inyección SC';

  @override
  String get healthRouteSubcutaneousDesc => 'Subcutánea en cuello';

  @override
  String get healthRouteIntramuscular => 'Inyección IM';

  @override
  String get healthRouteIntramuscularDesc => 'Intramuscular en pechuga';

  @override
  String get healthRouteWing => 'En Ala';

  @override
  String get healthRouteWingDesc => 'Punción en membrana del ala';

  @override
  String get healthRouteInOvo => 'In-Ovo';

  @override
  String get healthRouteInOvoDesc => 'Inyección en el huevo';

  @override
  String get healthRouteTopical => 'Tópica';

  @override
  String get healthRouteTopicalDesc => 'Aplicación externa en piel';

  @override
  String get healthBioStatusPending => 'Pendiente';

  @override
  String get healthBioStatusCompliant => 'Cumple';

  @override
  String get healthBioStatusNonCompliant => 'No Cumple';

  @override
  String get healthBioStatusPartial => 'Parcial';

  @override
  String get healthBioStatusNA => 'N/A';

  @override
  String get healthBioCatPersonnel => 'Acceso de Personal';

  @override
  String get healthBioCatPersonnelDesc => 'Control de ingreso y vestimenta';

  @override
  String get healthBioCatVehicles => 'Acceso de Vehículos';

  @override
  String get healthBioCatVehiclesDesc => 'Control de vehículos y equipos';

  @override
  String get healthBioCatCleaning => 'Limpieza y Desinfección';

  @override
  String get healthBioCatCleaningDesc => 'Protocolos de higiene';

  @override
  String get healthBioCatPestControl => 'Control de Plagas';

  @override
  String get healthBioCatPestControlDesc =>
      'Roedores, insectos, aves silvestres';

  @override
  String get healthBioCatBirdManagement => 'Manejo de Aves';

  @override
  String get healthBioCatBirdManagementDesc => 'Prácticas con las aves';

  @override
  String get healthBioCatMortality => 'Manejo de Mortalidad';

  @override
  String get healthBioCatMortalityDesc => 'Disposición de aves muertas';

  @override
  String get healthBioCatWater => 'Calidad del Agua';

  @override
  String get healthBioCatWaterDesc => 'Potabilidad y cloración';

  @override
  String get healthBioCatFeed => 'Manejo de Alimento';

  @override
  String get healthBioCatFeedDesc => 'Almacenamiento y calidad';

  @override
  String get healthBioCatFacilities => 'Instalaciones';

  @override
  String get healthBioCatFacilitiesDesc => 'Estado de galpones y equipos';

  @override
  String get healthBioCatRecords => 'Registros';

  @override
  String get healthBioCatRecordsDesc => 'Documentación y trazabilidad';

  @override
  String get healthInspFreqDaily => 'Diaria';

  @override
  String get healthInspFreqWeekly => 'Semanal';

  @override
  String get healthInspFreqBiweekly => 'Quincenal';

  @override
  String get healthInspFreqMonthly => 'Mensual';

  @override
  String get healthInspFreqQuarterly => 'Trimestral';

  @override
  String get healthInspFreqPerBatch => 'Por Lote';

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
  String get healthAbUseTreatment => 'Tratamiento';

  @override
  String get healthAbUseTreatmentDesc =>
      'Tratamiento de enfermedad diagnosticada';

  @override
  String get healthAbUseMetaphylaxis => 'Metafilaxis';

  @override
  String get healthAbUseMetaphylaxisDesc =>
      'Tratamiento preventivo de grupo en riesgo';

  @override
  String get healthAbUseProphylaxis => 'Profilaxis';

  @override
  String get healthAbUseProphylaxisDesc => 'Prevención en animales sanos';

  @override
  String get healthAbUseGrowthPromoter => 'Promotor de Crecimiento';

  @override
  String get healthAbUseGrowthPromoterDesc => 'Uso prohibido en muchos países';

  @override
  String get healthBirdTypeBroiler => 'Pollo de Engorde';

  @override
  String get healthBirdTypeLayerCommercial => 'Gallina Ponedora Comercial';

  @override
  String get healthBirdTypeLayerFreeRange => 'Gallina Ponedora Pastoreo';

  @override
  String get healthBirdTypeHeavyBreeder => 'Reproductora Pesada';

  @override
  String get healthBirdTypeLightBreeder => 'Reproductora Ligera';

  @override
  String get healthBirdTypeTurkeyMeat => 'Pavo de Engorde';

  @override
  String get healthBirdTypeQuail => 'Codorniz';

  @override
  String get healthBirdTypeDuck => 'Pato';

  @override
  String get farmStatusMaintenance => 'Mantenimiento';

  @override
  String get farmRoleOwner => 'Propietario';

  @override
  String get farmRoleAdmin => 'Administrador';

  @override
  String get farmRoleManager => 'Gestor';

  @override
  String get farmRoleOperator => 'Operario';

  @override
  String get farmRoleViewer => 'Visualizador';

  @override
  String get farmRoleOwnerDesc => 'Control total, puede eliminar la granja';

  @override
  String get farmRoleAdminDesc => 'Control total excepto eliminar';

  @override
  String get farmRoleManagerDesc => 'Gestión de registros e invitaciones';

  @override
  String get farmRoleOperatorDesc => 'Solo puede crear registros';

  @override
  String get farmRoleViewerDesc => 'Solo lectura';

  @override
  String get farmCreating => 'Creando granja...';

  @override
  String get farmUpdating => 'Actualizando granja...';

  @override
  String get farmDeleting => 'Eliminando granja...';

  @override
  String get farmActivating => 'Activando granja...';

  @override
  String get farmSuspending => 'Suspendiendo granja...';

  @override
  String get farmMaintenanceLoading => 'Poniendo en mantenimiento...';

  @override
  String get farmSearching => 'Buscando granjas...';

  @override
  String get shedStatusActive => 'Activo';

  @override
  String get shedStatusMaintenance => 'Mantenimiento';

  @override
  String get shedStatusInactive => 'Inactivo';

  @override
  String get shedStatusDisinfection => 'Desinfección';

  @override
  String get shedStatusQuarantine => 'Cuarentena';

  @override
  String get shedTypeMeat => 'Engorde';

  @override
  String get shedTypeMeatDesc => 'Galpón para producción de carne';

  @override
  String get shedTypeEgg => 'Postura';

  @override
  String get shedTypeEggDesc => 'Galpón para producción de huevos';

  @override
  String get shedTypeBreeder => 'Reproductora';

  @override
  String get shedTypeBreederDesc => 'Galpón para producción de huevos fértiles';

  @override
  String get shedTypeMixed => 'Mixto';

  @override
  String get shedTypeMixedDesc =>
      'Galpón multiuso para diferentes tipos de producción';

  @override
  String get shedEventDisinfection => 'Desinfección';

  @override
  String get shedEventMaintenance => 'Mantenimiento';

  @override
  String get shedEventStatusChange => 'Cambio de Estado';

  @override
  String get shedEventCreation => 'Creación';

  @override
  String get shedEventBatchAssigned => 'Lote Asignado';

  @override
  String get shedEventBatchReleased => 'Lote Liberado';

  @override
  String get shedEventOther => 'Otro';

  @override
  String get shedCreating => 'Creando galpón...';

  @override
  String get shedUpdating => 'Actualizando galpón...';

  @override
  String get shedDeleting => 'Eliminando galpón...';

  @override
  String get shedChangingStatus => 'Cambiando estado...';

  @override
  String get shedAssigningBatch => 'Asignando lote...';

  @override
  String get shedReleasing => 'Liberando galpón...';

  @override
  String get shedSchedulingMaintenance => 'Programando mantenimiento...';

  @override
  String get shedBatchAssignedSuccess => 'Lote asignado exitosamente';

  @override
  String get shedReleasedSuccess => 'Galpón liberado exitosamente';

  @override
  String get shedMaintenanceScheduled => 'Mantenimiento programado';

  @override
  String get notifStockLow => 'Stock Bajo';

  @override
  String get notifStockEmpty => 'Agotado';

  @override
  String get notifExpiringSoon => 'Próximo a Vencer';

  @override
  String get notifExpired => 'Vencido';

  @override
  String get notifRestocked => 'Reabastecido';

  @override
  String get notifInventoryMovement => 'Movimiento';

  @override
  String get notifMortalityRecorded => 'Mortalidad Registrada';

  @override
  String get notifMortalityHigh => 'Mortalidad Alta';

  @override
  String get notifMortalityCritical => 'Mortalidad Crítica';

  @override
  String get notifNewBatch => 'Nuevo Lote';

  @override
  String get notifBatchFinished => 'Lote Finalizado';

  @override
  String get notifWeightLow => 'Peso Bajo';

  @override
  String get notifCloseUpcoming => 'Cierre Próximo';

  @override
  String get notifConversionAbnormal => 'Conversión Anormal';

  @override
  String get notifNoRecords => 'Sin Registros';

  @override
  String get notifProduction => 'Producción';

  @override
  String get notifProductionLow => 'Producción Baja';

  @override
  String get notifProductionDrop => 'Caída Producción';

  @override
  String get notifFirstEgg => 'Primer Huevo';

  @override
  String get notifRecord => 'Récord';

  @override
  String get notifGoalReached => 'Meta Alcanzada';

  @override
  String get notifVaccination => 'Vacunación';

  @override
  String get notifVaccinationTomorrow => 'Vacunación Mañana';

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
    return '⚠️ Stock bajo: $itemName';
  }

  @override
  String notifMsgStockLow(Object quantity, Object unit) {
    return 'Solo quedan $quantity $unit';
  }

  @override
  String notifTitleStockEmpty(Object itemName) {
    return '🚫 Agotado: $itemName';
  }

  @override
  String get notifMsgStockEmpty =>
      'Stock en cero, requiere reabastecimiento urgente';

  @override
  String notifTitleExpired(Object itemName) {
    return '❌ Vencido: $itemName';
  }

  @override
  String notifMsgExpired(Object days) {
    return 'Este producto venció hace $days días';
  }

  @override
  String notifTitleExpiringSoon(Object itemName) {
    return '📅 Próximo a vencer: $itemName';
  }

  @override
  String get notifMsgExpiresToday => '¡Vence hoy!';

  @override
  String notifMsgExpiresInDays(Object days) {
    return 'Vence en $days días';
  }

  @override
  String notifTitleRestocked(Object itemName) {
    return '✅ Reabastecido: $itemName';
  }

  @override
  String notifMsgRestocked(Object quantity, Object unit) {
    return 'Se agregaron $quantity $unit';
  }

  @override
  String notifTitleMortalityCritical(Object batchName) {
    return '🚨 Mortalidad CRÍTICA: $batchName';
  }

  @override
  String notifTitleMortalityHigh(Object batchName) {
    return '⚠️ Mortalidad alta: $batchName';
  }

  @override
  String notifTitleMortalityRecorded(Object batchName) {
    return '🐔 Mortalidad registrada: $batchName';
  }

  @override
  String notifMsgMortalityRecorded(
    Object cause,
    Object count,
    Object percentage,
  ) {
    return '$count aves • Causa: $cause • Acumulada: $percentage%';
  }

  @override
  String notifTitleNewBatch(Object batchName) {
    return '🐤 Nuevo lote: $batchName';
  }

  @override
  String notifMsgNewBatch(Object birdCount, Object shedName) {
    return '$birdCount aves en $shedName';
  }

  @override
  String notifTitleBatchFinished(Object batchName) {
    return '✅ Lote finalizado: $batchName';
  }

  @override
  String notifMsgBatchFinished(Object days) {
    return 'Ciclo de $days días';
  }

  @override
  String notifTitleWeightLow(Object batchName) {
    return '⚖️ Peso bajo: $batchName';
  }

  @override
  String notifTitleConversionAbnormal(Object batchName) {
    return '📊 Conversión anormal: $batchName';
  }

  @override
  String notifTitleCloseUpcoming(Object batchName) {
    return '📆 Cierre próximo: $batchName';
  }

  @override
  String get notifMsgClosesToday => '¡Fecha de cierre es hoy!';

  @override
  String notifMsgClosesInDays(Object days) {
    return 'Cierra en $days días';
  }

  @override
  String get reportTypeBatchProduction => 'Producción de Lote';

  @override
  String get reportTypeBatchProductionDesc =>
      'Resumen completo del rendimiento productivo';

  @override
  String get reportTypeMortality => 'Mortalidad';

  @override
  String get reportTypeMortalityDesc =>
      'Análisis detallado de mortalidad y causas';

  @override
  String get reportTypeFeedConsumption => 'Consumo de Alimento';

  @override
  String get reportTypeFeedConsumptionDesc =>
      'Análisis de consumo y conversión alimenticia';

  @override
  String get reportTypeWeight => 'Peso y Crecimiento';

  @override
  String get reportTypeWeightDesc =>
      'Evolución de peso y curvas de crecimiento';

  @override
  String get reportTypeCosts => 'Costos';

  @override
  String get reportTypeCostsDesc => 'Desglose de gastos y costos operativos';

  @override
  String get reportTypeSales => 'Ventas';

  @override
  String get reportTypeSalesDesc => 'Resumen de ventas e ingresos';

  @override
  String get reportTypeProfitability => 'Rentabilidad';

  @override
  String get reportTypeProfitabilityDesc => 'Análisis de utilidad y márgenes';

  @override
  String get reportTypeHealth => 'Salud';

  @override
  String get reportTypeHealthDesc => 'Historial de tratamientos y vacunaciones';

  @override
  String get reportTypeInventory => 'Inventario';

  @override
  String get reportTypeInventoryDesc => 'Estado actual del inventario';

  @override
  String get reportTypeExecutive => 'Resumen Ejecutivo';

  @override
  String get reportTypeExecutiveDesc =>
      'Vista consolidada de indicadores clave';

  @override
  String get reportPeriodWeek => 'Última semana';

  @override
  String get reportPeriodMonth => 'Último mes';

  @override
  String get reportPeriodQuarter => 'Último trimestre';

  @override
  String get reportPeriodSemester => 'Último semestre';

  @override
  String get reportPeriodYear => 'Último año';

  @override
  String get reportPeriodCustom => 'Personalizado';

  @override
  String get reportFormatPdf => 'PDF';

  @override
  String get reportFormatPreview => 'Vista previa';

  @override
  String get reportPdfHeaderProduction => 'REPORTE DE PRODUCCIÓN';

  @override
  String get reportPdfHeaderExecutive => 'RESUMEN EJECUTIVO';

  @override
  String get reportPdfHeaderCosts => 'REPORTE DE COSTOS';

  @override
  String get reportPdfHeaderSales => 'REPORTE DE VENTAS';

  @override
  String get reportPdfSectionBatchInfo => 'INFORMACIÓN DEL LOTE';

  @override
  String get reportPdfSectionProductionIndicators =>
      'INDICADORES DE PRODUCCIÓN';

  @override
  String get reportPdfSectionFinancialSummary => 'RESUMEN FINANCIERO';

  @override
  String get reportPdfLabelCode => 'Código';

  @override
  String get reportPdfLabelBirdType => 'Tipo de Ave';

  @override
  String get reportPdfLabelShed => 'Galpón';

  @override
  String get reportPdfLabelEntryDate => 'Fecha Ingreso';

  @override
  String get reportPdfLabelCurrentAge => 'Edad Actual';

  @override
  String get reportPdfLabelDaysInFarm => 'Días en Granja';

  @override
  String get reportPdfLabelInitialBirds => 'Aves Iniciales';

  @override
  String get reportPdfLabelCurrentBirds => 'Aves Actuales';

  @override
  String get reportPdfLabelMortality => 'Mortalidad';

  @override
  String get reportPdfLabelAvgWeight => 'Peso Promedio';

  @override
  String get reportPdfLabelTotalConsumption => 'Consumo Total';

  @override
  String get reportPdfLabelConversion => 'Conversión';

  @override
  String get reportPdfLabelBirdCost => 'Costo de Aves';

  @override
  String get reportPdfLabelFeedCost => 'Costo de Alimento';

  @override
  String get reportPdfLabelTotalCosts => 'Total Costos';

  @override
  String get reportPdfLabelSalesRevenue => 'Ingresos por Ventas';

  @override
  String get reportPdfLabelBalance => 'BALANCE';

  @override
  String get reportPdfLabelPeriod => 'PERÍODO';

  @override
  String get reportPdfConversionSubtitle => 'kg alim / kg peso';

  @override
  String get reportPageTitle => 'Reportes';

  @override
  String get reportSelectType => 'Selecciona el tipo de reporte';

  @override
  String get reportSelectFarm => 'Selecciona una granja';

  @override
  String get reportSelectFarmHint =>
      'Para generar reportes, primero debes seleccionar una granja desde el inicio.';

  @override
  String get reportPeriodPrefix => 'Período:';

  @override
  String get reportPeriodTitle => 'Período del reporte';

  @override
  String get reportDateFrom => 'Desde';

  @override
  String get reportDateTo => 'Hasta';

  @override
  String get reportGenerating => 'Generando...';

  @override
  String get reportGeneratePdf => 'Generar Reporte PDF';

  @override
  String get reportNoFarmSelected => 'No hay granja seleccionada';

  @override
  String get reportNoActiveBatches =>
      'No hay lotes activos para generar el reporte';

  @override
  String get reportInsufficientData =>
      'No hay datos suficientes para el reporte';

  @override
  String get reportGenerateError => 'Error al generar reporte';

  @override
  String get reportGenerated => 'Reporte Generado';

  @override
  String get reportPrint => 'Imprimir';

  @override
  String get reportShareText => 'Reporte generado por Smart Granja Aves Pro';

  @override
  String get reportShareError => 'Error al compartir';

  @override
  String get reportPrintError => 'Error al imprimir';

  @override
  String get notifPageTitle => 'Notificaciones';

  @override
  String get notifMarkAllRead => 'Marcar todas como leídas';

  @override
  String get notifDeleteRead => 'Eliminar leídas';

  @override
  String get notifLoadError => 'Error al cargar notificaciones';

  @override
  String get notifAllMarkedRead => 'Todas marcadas como leídas';

  @override
  String get notifDeleteTitle => 'Eliminar notificaciones';

  @override
  String get notifDeleteReadConfirm =>
      '¿Deseas eliminar todas las notificaciones leídas?';

  @override
  String get notifDeleted => 'Notificaciones eliminadas';

  @override
  String get notifNoDestination =>
      'Esta notificación no tiene un destino disponible';

  @override
  String get notifSingleDeleted => 'Notificación eliminada';

  @override
  String get notifAllCaughtUp => '¡Todo al día!';

  @override
  String get notifEmptyMessage =>
      'No tienes notificaciones pendientes.\nTe avisaremos cuando haya algo importante.';

  @override
  String get notifTooltip => 'Notificaciones';

  @override
  String get profileEditProfile => 'Editar perfil';

  @override
  String get syncTitle => 'Sincronización y Datos';

  @override
  String get syncConnectionStatus => 'Estado de Conexión';

  @override
  String get syncPendingData => 'Datos pendientes';

  @override
  String get syncChangesPending => 'Hay cambios por sincronizar';

  @override
  String get syncAllSynced => 'Todo sincronizado';

  @override
  String get syncLastSync => 'Última sincronización';

  @override
  String get syncCheckConnection => 'Verificar conexión';

  @override
  String get syncCompleted => 'Sincronización completada';

  @override
  String get syncForceSync => 'Forzar sincronización';

  @override
  String get syncOfflineInfo =>
      'Los datos se guardan automáticamente en tu dispositivo y se sincronizan cuando hay conexión a internet.';

  @override
  String get syncJustNow => 'Hace un momento';

  @override
  String syncMinutesAgo(String n) {
    return 'Hace $n minutos';
  }

  @override
  String syncHoursAgo(Object n) {
    return 'Hace $n horas';
  }

  @override
  String syncDaysAgo(Object n) {
    return 'Hace $n días';
  }

  @override
  String get commonNotSpecified => 'No especificada';

  @override
  String get farmBroiler => 'Engorde';

  @override
  String get farmLayer => 'Ponedora';

  @override
  String get farmBreeder => 'Reproductor';

  @override
  String get farmBird => 'Ave';

  @override
  String get formStepBasic => 'Básico';

  @override
  String get formStepLocation => 'Ubicación';

  @override
  String get formStepContact => 'Contacto';

  @override
  String get formStepCapacity => 'Capacidad';

  @override
  String get commonLeave => 'Salir';

  @override
  String get commonRestore => 'Restaurar';

  @override
  String get commonProcessing => 'Procesando...';

  @override
  String get commonStatus => 'Estado';

  @override
  String get commonDocument => 'Documento';

  @override
  String get commonSupplier => 'Proveedor';

  @override
  String get commonRegistrationInfo => 'Información de Registro';

  @override
  String get commonLastUpdate => 'Última actualización';

  @override
  String get commonDraftFoundTitle => 'Borrador encontrado';

  @override
  String get commonExitWithoutCompleting => '¿Salir sin completar?';

  @override
  String get commonDataSafe => 'No te preocupes, tus datos están seguros.';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonFarm => 'Granja';

  @override
  String get commonBatch => 'Lote';

  @override
  String get commonFarmNotFound => 'Granja no encontrada';

  @override
  String get commonBatchNotFound => 'Lote no encontrado';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

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
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

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
  String get ventaLoteTitle => 'Ventas del Lote';

  @override
  String get ventaAllTitle => 'Todas las Ventas';

  @override
  String get ventaFilterTooltip => 'Filtrar';

  @override
  String get ventaEmptyTitle => 'Sin ventas registradas';

  @override
  String get ventaEmptyDescription =>
      'Registra tu primera venta para comenzar a llevar un control de tus ingresos';

  @override
  String get ventaEmptyAction => 'Registrar primera venta';

  @override
  String get ventaFilterEmptyTitle => 'No se encontraron ventas';

  @override
  String get ventaFilterEmptyDescription =>
      'Prueba modificando los filtros de búsqueda para encontrar las ventas que buscas';

  @override
  String get ventaNewButton => 'Nueva Venta';

  @override
  String get ventaNewTooltip => 'Registrar nueva venta';

  @override
  String get ventaDeleteTitle => '¿Eliminar venta?';

  @override
  String get ventaDeleteSuccess => 'Venta eliminada correctamente';

  @override
  String get ventaFilterTitle => 'Filtrar ventas';

  @override
  String get ventaFilterProductType => 'Tipo de producto';

  @override
  String get ventaFilterSaleState => 'Estado de venta';

  @override
  String get ventaFilterAllStates => 'Todos los estados';

  @override
  String get ventaStatePending => 'Pendiente';

  @override
  String get ventaStateConfirmed => 'Confirmada';

  @override
  String get ventaStateSold => 'Vendida';

  @override
  String get ventaSheetClient => 'Cliente';

  @override
  String get ventaSheetDiscount => 'Descuento';

  @override
  String get ventaSheetInvoiceNumber => 'Nº Factura';

  @override
  String get ventaSheetCarrier => 'Transportista';

  @override
  String get ventaSheetGuideNumber => 'Nº Guía';

  @override
  String get ventaSheetBirdCount => 'Cantidad aves';

  @override
  String get ventaSheetAvgWeight => 'Peso promedio';

  @override
  String get ventaSheetPricePerKg => 'Precio por kg';

  @override
  String get ventaSheetSlaughteredWeight => 'Peso faenado';

  @override
  String get ventaSheetYield => 'Rendimiento';

  @override
  String get ventaSheetTotalEggs => 'Total huevos';

  @override
  String get ventaDetailNotFound => 'Venta no encontrada';

  @override
  String get ventaDetailTitle => 'Detalle de Venta';

  @override
  String get ventaDetailEditTooltip => 'Editar venta';

  @override
  String get ventaDetailClient => 'Cliente';

  @override
  String get ventaDetailProductDetails => 'Detalles del Producto';

  @override
  String get ventaDetailBirdCount => 'Cantidad de aves';

  @override
  String get ventaDetailAvgWeight => 'Peso promedio';

  @override
  String get ventaDetailPricePerKg => 'Precio por kg';

  @override
  String get ventaDetailQuantity => 'Cantidad';

  @override
  String get ventaDetailUnitPrice => 'Precio unitario';

  @override
  String get ventaDetailCarcassYield => 'Rendimiento canal';

  @override
  String get ventaDetailTotalLabel => 'TOTAL';

  @override
  String get ventaDetailShare => 'Compartir';

  @override
  String get ventaDetailSlaughteredWeight => 'Peso faenado';

  @override
  String get ventaStepProduct => 'Producto';

  @override
  String get ventaStepClient => 'Cliente';

  @override
  String get ventaStepDetails => 'Detalles';

  @override
  String get ventaDraftFoundMessage =>
      '¿Deseas restaurar el borrador de venta guardado anteriormente?';

  @override
  String get ventaDraftRestored => 'Borrador restaurado';

  @override
  String get ventaDraftJustNow => 'ahora mismo';

  @override
  String get ventaExitMessage => 'No te preocupes, tus datos están seguros.';

  @override
  String get ventaNoEditPermission =>
      'No tienes permiso para editar ventas en esta granja';

  @override
  String get ventaNoCreatePermission =>
      'No tienes permiso para registrar ventas en esta granja';

  @override
  String get ventaUpdateSuccess => 'Venta actualizada correctamente';

  @override
  String get ventaCreateSuccess => '¡Venta registrada exitosamente!';

  @override
  String get ventaInventoryWarning =>
      'Venta registrada, pero hubo un error al actualizar inventario';

  @override
  String get ventaEditTitle => 'Editar Venta';

  @override
  String get ventaNewTitle => 'Nueva Venta';

  @override
  String get ventaSelectProductFirst =>
      'Selecciona un tipo de producto primero';

  @override
  String get ventaDetailsHint => 'Ingresa cantidades, precios y otros detalles';

  @override
  String get ventaNoFarmSelected =>
      'No hay una granja seleccionada. Por favor selecciona una granja primero.';

  @override
  String get ventaLotLabel => 'Lote *';

  @override
  String get ventaNoActiveLots => 'No hay lotes activos en esta granja.';

  @override
  String get ventaSelectLotHint => 'Selecciona un lote';

  @override
  String get ventaSelectLotError => 'Selecciona un lote';

  @override
  String get ventaSaleDate => 'Fecha de venta';

  @override
  String get ventaBirdCount => 'Cantidad de aves';

  @override
  String get ventaBirdCountRequired => 'Ingresa la cantidad de aves';

  @override
  String get ventaTotalWeight => 'Peso total (kg)';

  @override
  String get ventaSlaughteredWeight => 'Peso faenado total (kg)';

  @override
  String get ventaWeightRequired => 'Ingresa el peso total';

  @override
  String ventaPricePerKg(String currency) {
    return 'Precio por kg ($currency)';
  }

  @override
  String get ventaPriceRequired => 'Ingresa el precio por kg';

  @override
  String get ventaEggInstructions =>
      'Ingresa la cantidad y precio por docena para cada clasificación';

  @override
  String get ventaEggQuantity => 'Cantidad';

  @override
  String ventaEggPricePerDozen(String currency) {
    return '$currency por docena';
  }

  @override
  String get ventaSaleUnit => 'Unidad de venta';

  @override
  String get ventaQuantityRequired => 'Ingresa la cantidad';

  @override
  String get ventaPriceRequired2 => 'Ingresa el precio';

  @override
  String get ventaObservations => 'Observaciones';

  @override
  String get ventaObservationsHint => 'Notas adicionales (opcional)';

  @override
  String get ventaSubmitButton => 'Registrar Venta';

  @override
  String get ventaEditPageTitle => 'Editar Venta';

  @override
  String get ventaEditNotFound => 'Venta no encontrada';

  @override
  String get ventaEditLoadError => 'Error al cargar la venta';

  @override
  String get ventaWhatToSell => '¿Qué deseas vender?';

  @override
  String get ventaSelectProductType =>
      'Selecciona el tipo de producto para esta venta';

  @override
  String get ventaDescAvesVivas =>
      'Venta de aves en pie, listas para transporte o crianza';

  @override
  String get ventaDescHuevos => 'Venta de huevos por clasificación y docena';

  @override
  String get ventaDescPollinaza =>
      'Venta de abono orgánico por bulto, saco o tonelada';

  @override
  String get ventaDescAvesFaenadas => 'Aves procesadas y listas para consumo';

  @override
  String get ventaDescAvesDescarte =>
      'Aves de descarte por fin de ciclo productivo';

  @override
  String get ventaClientData => 'Datos del Cliente';

  @override
  String get ventaClientHint => 'Ingresa la información del comprador';

  @override
  String get ventaClientName => 'Nombre completo';

  @override
  String get ventaClientNameHint => 'Ej: Juan Pérez García';

  @override
  String get ventaClientDocType => 'Tipo de documento *';

  @override
  String get ventaClientCE => 'Carnet de Extranjería';

  @override
  String get ventaClientDocNumber => 'Número de documento';

  @override
  String get ventaClientDni8 => '8 dígitos';

  @override
  String get ventaClientRuc11 => '11 dígitos';

  @override
  String get ventaClientPhone => 'Teléfono de contacto';

  @override
  String get ventaClient9Digits => '9 dígitos';

  @override
  String get ventaClientNameRequired => 'Ingresa el nombre del cliente';

  @override
  String get ventaClientNameMinLength =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get ventaClientDocRequired => 'Ingresa el número de documento';

  @override
  String get ventaClientDniError => 'El DNI debe tener 8 dígitos';

  @override
  String get ventaClientRucError => 'El RUC debe tener 11 dígitos';

  @override
  String get ventaClientInvalidNumber => 'Número inválido';

  @override
  String get ventaClientPhoneRequired => 'Ingresa el teléfono de contacto';

  @override
  String get ventaClientPhoneError => 'El teléfono debe tener 9 dígitos';

  @override
  String get ventaSelectLocation => 'Seleccionar Ubicación';

  @override
  String get ventaSelectLocationHint =>
      'Selecciona la granja y el lote para registrar la venta';

  @override
  String get ventaNoFarms => 'No tienes granjas registradas';

  @override
  String get ventaCreateFarmFirst =>
      'Debes crear una granja antes de registrar una venta';

  @override
  String get ventaFarmLabel => 'Granja *';

  @override
  String get ventaSelectFarmHint => 'Selecciona una granja';

  @override
  String get ventaFarmRequired => 'Por favor selecciona una granja';

  @override
  String get ventaNoActiveLots2 => 'No hay lotes activos';

  @override
  String get ventaNoActiveLotsHint =>
      'Esta granja no tiene lotes activos para registrar ventas';

  @override
  String get ventaLotLabel2 => 'Lote *';

  @override
  String get ventaSelectLotHint2 => 'Selecciona un lote';

  @override
  String get ventaLotRequired => 'Por favor selecciona un lote';

  @override
  String get ventaFarmLoadError => 'Error al cargar granjas';

  @override
  String get ventaLotLoadError2 => 'Error al cargar lotes';

  @override
  String get ventaSummaryTitle => 'Resumen de Ventas';

  @override
  String get ventaSummaryTotal => 'Total en ventas';

  @override
  String get ventaSummaryActive => 'Activas';

  @override
  String get ventaSummaryCompleted => 'Completadas';

  @override
  String get ventaLoadError => 'Error al cargar ventas';

  @override
  String get ventaLoadErrorDetail =>
      'Ocurrió un problema al obtener las ventas';

  @override
  String get ventaCardBuyer => 'Comprador: ';

  @override
  String get ventaCardProduct => 'Producto: ';

  @override
  String get ventaCardBirds => 'aves';

  @override
  String get ventaCardEggs => 'huevos';

  @override
  String get ventaShareReceiptTitle => '📋 COMPROBANTE DE VENTA';

  @override
  String get costoLoteTitle => 'Costos del Lote';

  @override
  String get costoAllTitle => 'Todos los Costos';

  @override
  String get costoFilterTooltip => 'Filtrar';

  @override
  String get costoEmptyTitle => 'Sin costos registrados';

  @override
  String get costoEmptyDescription =>
      'Registra tus gastos operativos para llevar un control detallado de los costos de producción';

  @override
  String get costoEmptyAction => 'Registrar Costo';

  @override
  String get costoFilterEmptyTitle => 'No se encontraron costos';

  @override
  String get costoFilterEmptyDescription =>
      'Intenta ajustar los filtros o buscar con otros términos';

  @override
  String get costoNewButton => 'Nuevo Costo';

  @override
  String get costoNewTooltip => 'Registrar nuevo costo';

  @override
  String get costoRejectTitle => 'Rechazar Costo';

  @override
  String get costoRejectReasonLabel => 'Motivo del rechazo';

  @override
  String get costoRejectReasonHint => 'Explica por qué se rechaza este costo';

  @override
  String get costoRejectButton => 'Rechazar';

  @override
  String get costoRejectReasonRequired => 'Ingresa un motivo de rechazo';

  @override
  String get costoDeleteTitle => 'Eliminar Costo';

  @override
  String get costoDeleteWarning => 'Esta acción no se puede deshacer.';

  @override
  String get costoDeleteSuccess => 'Costo eliminado correctamente';

  @override
  String get costoFilterTitle => 'Filtrar costos';

  @override
  String get costoFilterExpenseType => 'Tipo de gasto';

  @override
  String get costoDetailLoadError => 'No pudimos cargar el detalle del costo';

  @override
  String get costoDetailNotFound => 'Costo no encontrado';

  @override
  String get costoDetailTitle => 'Detalle del Costo';

  @override
  String get costoDetailEditTooltip => 'Editar costo';

  @override
  String get costoDetailPending => 'Pendiente';

  @override
  String get costoDetailRejected => 'Rechazado';

  @override
  String get costoDetailApproved => 'Aprobado';

  @override
  String get costoDetailNoStatus => 'Sin estado';

  @override
  String get costoDetailGeneralInfo => 'Información General';

  @override
  String get costoDetailConcept => 'Concepto';

  @override
  String get costoDetailInvoiceNo => 'Nº Factura';

  @override
  String get costoDetailDeleteConfirm =>
      '¿Estás seguro de que deseas eliminar este costo?';

  @override
  String get costoDetailDeleteWarning => 'Esta acción no se puede deshacer.';

  @override
  String get costoDetailDeleteError => 'Error al eliminar';

  @override
  String get costoDetailDeleteSuccess => 'Costo eliminado exitosamente';

  @override
  String get costoStepType => 'Tipo';

  @override
  String get costoStepAmount => 'Monto';

  @override
  String get costoStepDetails => 'Detalles';

  @override
  String get costoDraftFoundMessage =>
      '¿Deseas restaurar el borrador guardado anteriormente?';

  @override
  String get costoTypeRequired => 'Por favor selecciona un tipo de gasto';

  @override
  String get costoNoEditPermission =>
      'No tienes permiso para editar costos en esta granja';

  @override
  String get costoNoCreatePermission =>
      'No tienes permiso para registrar costos en esta granja';

  @override
  String get costoUpdateSuccess => 'Costo actualizado correctamente';

  @override
  String get costoCreateSuccess => 'Costo registrado correctamente';

  @override
  String get costoInventoryWarning =>
      'Costo registrado, pero hubo un error al actualizar inventario';

  @override
  String get costoEditTitle => 'Editar Costo';

  @override
  String get costoRegisterTitle => 'Registrar Costo';

  @override
  String get costoRegisterButton => 'Registrar';

  @override
  String get costoFarmRequired => 'Por favor selecciona una granja';

  @override
  String get costoWhatType => '¿Qué tipo de gasto es?';

  @override
  String get costoSelectCategory =>
      'Selecciona la categoría que mejor describe este gasto';

  @override
  String get costoAmountTitle => 'Monto del Gasto';

  @override
  String get costoAmountHint => 'Ingresa el monto total del gasto en soles';

  @override
  String get costoConceptLabel => 'Concepto del gasto';

  @override
  String get costoConceptHint => 'Ej: Compra de alimento balanceado';

  @override
  String get costoConceptRequired => 'Ingresa el concepto del gasto';

  @override
  String get costoConceptMinLength =>
      'El concepto debe tener al menos 5 caracteres';

  @override
  String get costoAmountLabel => 'Monto';

  @override
  String get costoAmountRequired => 'Ingresa el monto';

  @override
  String get costoAmountInvalid => 'Ingresa un monto válido';

  @override
  String get costoDateLabel => 'Fecha del gasto *';

  @override
  String get costoInventoryLinkInfo =>
      'Puedes vincular este gasto a un producto del inventario para actualizar el stock automáticamente.';

  @override
  String get costoLinkFood => 'Vincular a alimento del inventario';

  @override
  String get costoLinkMedicine => 'Vincular a medicamento del inventario';

  @override
  String get costoInventorySearchHint => 'Buscar en inventario (opcional)...';

  @override
  String get costoLinkedProduct => 'Producto vinculado';

  @override
  String get costoStockUpdateNote => 'Se actualizará el stock al guardar';

  @override
  String get costoAdditionalDetails => 'Detalles Adicionales';

  @override
  String get costoAdditionalDetailsHint =>
      'Información complementaria del gasto';

  @override
  String get costoSupplierHint => 'Nombre del proveedor o empresa';

  @override
  String get costoSupplierRequired => 'Ingresa el nombre del proveedor';

  @override
  String get costoSupplierMinLength =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get costoInvoiceLabel => 'Número de Factura/Recibo';

  @override
  String get costoObservationsHint => 'Notas adicionales sobre este gasto';

  @override
  String get costoCardType => 'Tipo: ';

  @override
  String get costoCardConcept => 'Concepto: ';

  @override
  String get costoCardSupplier => 'Proveedor: ';

  @override
  String get costoTypeAlimento => 'Alimento';

  @override
  String get costoTypeManoDeObra => 'Mano de Obra';

  @override
  String get costoTypeEnergia => 'Energía';

  @override
  String get costoTypeMedicamento => 'Medicamento';

  @override
  String get costoTypeMantenimiento => 'Mantenimiento';

  @override
  String get costoTypeAgua => 'Agua';

  @override
  String get costoTypeTransporte => 'Transporte';

  @override
  String get costoTypeAdministrativo => 'Administrativo';

  @override
  String get costoTypeDepreciacion => 'Depreciación';

  @override
  String get costoTypeFinanciero => 'Financiero';

  @override
  String get costoTypeOtros => 'Otros';

  @override
  String get costoSummaryTitle => 'Resumen de Costos';

  @override
  String get costoSummaryTotal => 'Total en costos';

  @override
  String get costoSummaryApproved => 'Aprobados';

  @override
  String get costoSummaryPending => 'Pendientes';

  @override
  String get costoLoadError => 'Error al cargar costos';

  @override
  String get inventarioTitle => 'Inventario';

  @override
  String get invFilterByType => 'Filtrar por tipo';

  @override
  String get invSearchByNameOrCode => 'Buscar por nombre o código...';

  @override
  String get invTabItems => 'Items';

  @override
  String get invTabMovements => 'Movimientos';

  @override
  String get invNoFarmSelected => 'Sin granja seleccionada';

  @override
  String get invSelectFarmFromHome => 'Selecciona una granja desde el inicio';

  @override
  String get invAddNewItemTooltip => 'Agregar nuevo ítem al inventario';

  @override
  String get invNewItem => 'Nuevo Item';

  @override
  String get invNoResults => 'Sin resultados';

  @override
  String get invNoMovements => 'Sin movimientos';

  @override
  String get invNoMovementsMatchSearch =>
      'No hay movimientos que coincidan con tu búsqueda';

  @override
  String get invNoMovementsYet => 'No hay movimientos registrados aún';

  @override
  String get invErrorLoadingMovements => 'No pudimos cargar los movimientos';

  @override
  String get invNoItemsInInventory => 'Sin items en inventario';

  @override
  String get invNoItemsMatchFilters =>
      'No hay items que coincidan con los filtros';

  @override
  String get invAddYourFirstItem => 'Agrega tu primer item de inventario';

  @override
  String get invClearFilters => 'Limpiar filtros';

  @override
  String get invAddItem => 'Agregar Item';

  @override
  String get invItemDeletedSuccess => 'Item eliminado correctamente';

  @override
  String get invApplyFilter => 'Aplicar filtro';

  @override
  String get invItemDetail => 'Detalle del Item';

  @override
  String get invRegisterEntry => 'Registrar Entrada';

  @override
  String get invRegisterExit => 'Registrar Salida';

  @override
  String get invAdjustStock => 'Ajustar Stock';

  @override
  String get invItemNotFound => 'Item no encontrado';

  @override
  String get invErrorLoadingItem => 'No pudimos cargar el item de inventario';

  @override
  String get invStockDepleted => 'Agotado';

  @override
  String get invStockLow => 'Stock Bajo';

  @override
  String get invStockAvailable => 'Disponible';

  @override
  String get invStockCurrent => 'Stock Actual';

  @override
  String get invStockMinimum => 'Stock Mínimo';

  @override
  String get invTotalValue => 'Valor Total';

  @override
  String get invInformation => 'Información';

  @override
  String get invCode => 'Código';

  @override
  String get invDescription => 'Descripción';

  @override
  String get invUnit => 'Unidad';

  @override
  String get invUnitPrice => 'Precio Unitario';

  @override
  String get invExpiration => 'Vencimiento';

  @override
  String get invSupplierBatch => 'Lote Proveedor';

  @override
  String get invWarehouse => 'Almacén';

  @override
  String get invAlerts => 'Alertas';

  @override
  String get invAlertStockDepleted => 'Stock agotado';

  @override
  String get invAlertProductExpired => 'Producto vencido';

  @override
  String get invLastMovements => 'Últimos Movimientos';

  @override
  String get invViewAll => 'Ver todo';

  @override
  String get invNoMovementsRegistered => 'Sin movimientos registrados';

  @override
  String get invCouldNotLoadMovements =>
      'No se pudieron cargar los movimientos';

  @override
  String get invItemDeleted => 'Item eliminado';

  @override
  String get invStepType => 'Tipo';

  @override
  String get invStepBasic => 'Básico';

  @override
  String get invStepStock => 'Stock';

  @override
  String get invStepDetails => 'Detalles';

  @override
  String get invDraftFound => 'Borrador encontrado';

  @override
  String get invEditItem => 'Editar Item';

  @override
  String get invNewItemTitle => 'Nuevo Item';

  @override
  String get invCreateItem => 'Crear Item';

  @override
  String get invImageTooLarge => 'La imagen excede 5MB. Elige una más pequeña';

  @override
  String get invImageSelected => 'Imagen seleccionada';

  @override
  String get invErrorSelectingImage => 'Error al seleccionar imagen';

  @override
  String get invCouldNotUploadImage => 'No se pudo subir la imagen';

  @override
  String get invItemSavedWithoutImage => 'El item se guardará sin imagen';

  @override
  String get invItemUpdatedSuccess => 'Item actualizado correctamente';

  @override
  String get invDraftAutoSaveMessage =>
      'No te preocupes, tus datos están seguros. Tu progreso se guarda automáticamente.';

  @override
  String get invMovementsTitle => 'Movimientos';

  @override
  String invMovementsOfItem(String item) {
    return 'Movimientos: $item';
  }

  @override
  String get invFilter => 'Filtrar';

  @override
  String get invErrorLoadingMovementsPage => 'Error al cargar movimientos';

  @override
  String get invNoMovementsWithFilters =>
      'No hay movimientos con estos filtros';

  @override
  String get invNoMovementsRegisteredHist => 'No hay movimientos registrados';

  @override
  String get invClearFiltersHist => 'Limpiar filtros';

  @override
  String get invToday => 'Hoy';

  @override
  String get invYesterday => 'Ayer';

  @override
  String get invFilterMovements => 'Filtrar movimientos';

  @override
  String get invMovementType => 'Tipo de movimiento';

  @override
  String get invAll => 'Todos';

  @override
  String get invDateRange => 'Rango de fechas';

  @override
  String get invFrom => 'Desde';

  @override
  String get invUntil => 'Hasta';

  @override
  String get invClear => 'Limpiar';

  @override
  String get invDialogRegisterEntry => 'Registrar Entrada';

  @override
  String get invDialogRegisterExit => 'Registrar Salida';

  @override
  String get invDialogMovementType => 'Tipo de movimiento';

  @override
  String get invSelectType => 'Selecciona un tipo';

  @override
  String get invEnterQuantity => 'Ingresa la cantidad';

  @override
  String get invEnterValidNumberGt0 => 'Ingresa un número válido mayor a 0';

  @override
  String get invQuantityExceedsStock =>
      'La cantidad excede el stock disponible';

  @override
  String get invTotalCost => 'Costo total';

  @override
  String get invSupplierName => 'Nombre del proveedor';

  @override
  String get invObservation => 'Observación';

  @override
  String get invReasonOrObservation => 'Motivo u observación';

  @override
  String get invDialogAdjustStock => 'Ajustar Stock';

  @override
  String get invEnterNewStock => 'Ingresa el nuevo stock';

  @override
  String get invEnterValidNumber => 'Ingresa un número válido';

  @override
  String get invAdjustmentReason => 'Motivo del ajuste';

  @override
  String get invReasonRequired => 'El motivo es requerido';

  @override
  String get invAdjust => 'Ajustar';

  @override
  String get invStockAdjustedSuccess => 'Stock ajustado correctamente';

  @override
  String get invEntryRegistered => 'Entrada registrada correctamente';

  @override
  String get invExitRegistered => 'Salida registrada correctamente';

  @override
  String get invDeleteItem => 'Eliminar item';

  @override
  String invConfirmDeleteItemName(String name) {
    return '¿Estás seguro de eliminar $name?';
  }

  @override
  String get invActionIrreversible => 'Esta acción es irreversible';

  @override
  String get invDeleteWarningDetails =>
      'Se eliminarán todos los movimientos y datos asociados';

  @override
  String get invTypeNameToConfirm =>
      'Escribe el nombre del item para confirmar';

  @override
  String get invTypeHere => 'Escribe aquí...';

  @override
  String get invCardDepleted => 'Agotado';

  @override
  String get invCardLowStock => 'Stock Bajo';

  @override
  String get invCardAvailable => 'Disponible';

  @override
  String get invCardProductExpired => 'Producto vencido';

  @override
  String get invViewDetails => 'Ver Detalles';

  @override
  String get invMoreOptionsItem => 'Más opciones del item';

  @override
  String get invCardDetails => 'Detalles';

  @override
  String get invCardStock => 'Stock';

  @override
  String get invCardMinimum => 'Mínimo';

  @override
  String get invCardValue => 'Valor';

  @override
  String get invSelectProduct => 'Seleccionar producto';

  @override
  String get invSearchInventory => 'Buscar en inventario...';

  @override
  String get invSearchProduct => 'Buscar producto...';

  @override
  String get invNoProductsFound => 'No se encontraron productos';

  @override
  String get invNoProductsAvailable => 'No hay productos disponibles';

  @override
  String get invSelectorStockLow => 'Stock bajo';

  @override
  String get invErrorLoadingInventory => 'Error al cargar inventario';

  @override
  String get invStockTitle => 'Stock';

  @override
  String get invConfigureQuantities =>
      'Configura las cantidades y unidad de medida';

  @override
  String get invUnitsFilteredAutomatically =>
      'Las unidades se filtran automáticamente según el tipo de producto seleccionado.';

  @override
  String get invUnitOfMeasure => 'Unidad de Medida *';

  @override
  String get invStockActual => 'Stock Actual';

  @override
  String get invEnterCurrentStock => 'Ingresa el stock actual';

  @override
  String get invEnterValidNumberStock => 'Ingresa un número válido';

  @override
  String get invStockMin => 'Stock Mínimo';

  @override
  String get invStockMax => 'Stock Máximo';

  @override
  String get invOptional => 'Opcional';

  @override
  String get invStockAlerts => 'Alertas de stock';

  @override
  String get invStockAlertMessage =>
      'Recibirás una notificación cuando el stock esté por debajo del mínimo configurado.';

  @override
  String get invBasicInfo => 'Información Básica';

  @override
  String get invEnterMainData => 'Ingresa los datos principales del item';

  @override
  String get invItemName => 'Nombre del Item';

  @override
  String get invEnterItemName => 'Ingresa el nombre del item';

  @override
  String get invNameMinChars => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get invCodeSkuOptional => 'Código/SKU (opcional)';

  @override
  String get invDescriptionOptional => 'Descripción (opcional)';

  @override
  String get invDescribeProductCharacteristics =>
      'Describe las características del producto...';

  @override
  String get invSkuHelpsIdentify =>
      'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.';

  @override
  String get invAdditionalDetails => 'Detalles Adicionales';

  @override
  String get invOptionalInfoBetterControl =>
      'Información opcional para mejor control';

  @override
  String get invUnitPriceLabel => 'Precio Unitario';

  @override
  String get invSupplierLabel => 'Proveedor';

  @override
  String get invSupplierNameHint => 'Nombre del proveedor';

  @override
  String get invWarehouseLocation => 'Ubicación en Almacén';

  @override
  String get invExpirationTitle => 'Vencimiento';

  @override
  String get invExpirationDateOptional => 'Fecha de vencimiento (opcional)';

  @override
  String get invSelectDate => 'Seleccionar fecha';

  @override
  String get invSupplierBatchLabel => 'Lote del Proveedor';

  @override
  String get invBatchNumber => 'Número de lote';

  @override
  String get invDetailsOptionalHelp =>
      'Estos datos son opcionales pero ayudan a un mejor control y trazabilidad del inventario.';

  @override
  String get invWhatTypeOfItem => '¿Qué tipo de item es?';

  @override
  String get invSelectItemCategory =>
      'Selecciona la categoría del item de inventario';

  @override
  String get invDescAlimento =>
      'Concentrados, maíz, soya y otros alimentos para aves';

  @override
  String get invDescMedicamento =>
      'Antibióticos, antiparasitarios y tratamientos veterinarios';

  @override
  String get invDescVacuna => 'Vacunas y productos de inmunización';

  @override
  String get invDescEquipo =>
      'Bebederos, comederos, equipos de calefacción y herramientas';

  @override
  String get invDescInsumo =>
      'Materiales de cama, desinfectantes y otros insumos';

  @override
  String get invDescLimpieza => 'Productos de limpieza y desinfección';

  @override
  String get invDescOtro =>
      'Otros items que no encajan en las categorías anteriores';

  @override
  String get invProductImage => 'Imagen del Producto';

  @override
  String get invTakePhoto => 'Tomar Foto';

  @override
  String get invGallery => 'Galería';

  @override
  String get invImageSelectedLabel => 'Imagen seleccionada';

  @override
  String get invReady => 'Lista';

  @override
  String get invNoImageAdded => 'No hay imagen agregada';

  @override
  String get invCanAddProductPhoto => 'Puedes agregar una foto del producto';

  @override
  String get invStockBefore => 'Stock anterior';

  @override
  String get invStockAfter => 'Stock nuevo';

  @override
  String get invInventoryLabel => 'Inventario';

  @override
  String get invItemsRegistered => 'items registrados';

  @override
  String get invViewAllItems => 'Ver todo';

  @override
  String get invTotalItems => 'Total Items';

  @override
  String get invLowStock => 'Stock Bajo';

  @override
  String get invDepletedItems => 'Agotados';

  @override
  String get invExpiringSoon => 'Por Vencer';

  @override
  String get saludFilterAll => 'Todos';

  @override
  String get saludFilterInTreatment => 'En tratamiento';

  @override
  String get saludFilterClosed => 'Cerrados';

  @override
  String get saludRecordsTitle => 'Registros de Salud';

  @override
  String get saludFilterTooltip => 'Filtrar';

  @override
  String get saludEmptyTitle => 'Sin registros de salud';

  @override
  String get saludEmptyDescription =>
      'Registra tratamientos, diagnósticos y seguimiento sanitario del lote';

  @override
  String get saludRegisterTreatment => 'Registrar Tratamiento';

  @override
  String get saludNoRecordsFound => 'No se encontraron registros';

  @override
  String get saludNoFilterResults =>
      'No hay registros que coincidan con los filtros aplicados';

  @override
  String get saludFilterByBatch => 'Filtrar por lote';

  @override
  String get saludNewTreatment => 'Nuevo Tratamiento';

  @override
  String get saludNewTreatmentTooltip => 'Registrar nuevo tratamiento';

  @override
  String get saludFilterRecords => 'Filtrar registros';

  @override
  String get saludTreatmentStatus => 'Estado del tratamiento';

  @override
  String get saludDeleteRecordTitle => '¿Eliminar registro?';

  @override
  String get saludRecordDeleted => 'Registro eliminado correctamente';

  @override
  String get saludCloseTreatmentTitle => 'Cerrar Tratamiento';

  @override
  String get saludDescribeResult =>
      'Describe el resultado del tratamiento aplicado';

  @override
  String get saludResultRequired => 'Resultado *';

  @override
  String get saludResultHint => 'Ej: Recuperación completa, sin síntomas';

  @override
  String get saludResultValidation => 'El resultado es obligatorio';

  @override
  String get saludResultMinLength =>
      'Describe el resultado (mínimo 10 caracteres)';

  @override
  String get saludFinalObservations => 'Observaciones finales';

  @override
  String get saludAdditionalNotesOptional => 'Notas adicionales (opcional)';

  @override
  String get saludTreatmentClosedSuccess => 'Tratamiento cerrado exitosamente';

  @override
  String get saludStatusInTreatment => 'En tratamiento';

  @override
  String get saludStatusClosed => 'Cerrado';

  @override
  String get saludDiagnosis => 'Diagnóstico';

  @override
  String get saludSymptoms => 'Síntomas';

  @override
  String get saludTreatment => 'Tratamiento';

  @override
  String get saludMedications => 'Medicamentos';

  @override
  String get saludDosage => 'Dosis';

  @override
  String get saludDuration => 'Duración';

  @override
  String get saludDays => 'días';

  @override
  String get saludVeterinarian => 'Veterinario';

  @override
  String get saludResult => 'Resultado';

  @override
  String get saludCloseDate => 'Fecha de cierre';

  @override
  String get saludTreatmentDays => 'Días de tratamiento';

  @override
  String get saludAllBatches => 'Todos';

  @override
  String get saludDetailTitle => 'Detalle de Registro';

  @override
  String get saludRecordNotFound => 'Registro no encontrado';

  @override
  String get saludLoadError => 'No pudimos cargar el registro de salud';

  @override
  String get saludDetailStatusClosed => 'Cerrado';

  @override
  String get saludDetailStatusInTreatment => 'En tratamiento';

  @override
  String get saludDetailDiagnosisSection => 'Diagnóstico';

  @override
  String get saludDetailDateLabel => 'Fecha';

  @override
  String get saludDetailTreatmentSection => 'Tratamiento';

  @override
  String get saludDetailUser => 'Usuario';

  @override
  String get saludDetailCloseTreatment => 'Cerrar Tratamiento';

  @override
  String get saludDetailCloseDate => 'Fecha de Cierre';

  @override
  String get saludDetailResultOptional => 'Resultado (Opcional)';

  @override
  String get saludDetailDescribeResult =>
      'Describe el resultado del tratamiento';

  @override
  String get saludDetailDeleteTitle => '¿Eliminar registro?';

  @override
  String get saludDetailRecordDeleted => 'Registro eliminado';

  @override
  String get saludDetailTreatmentClosed => 'Tratamiento cerrado';

  @override
  String get saludDetailCloseError => 'Error al cerrar tratamiento';

  @override
  String get saludDetailDeleteError => 'Error al eliminar registro';

  @override
  String get vacFilterApplied => 'Aplicadas';

  @override
  String get vacFilterPending => 'Pendientes';

  @override
  String get vacFilterExpired => 'Vencidas';

  @override
  String get vacFilterUpcoming => 'Próximas';

  @override
  String get vacTitle => 'Vacunaciones';

  @override
  String get vacFilterTooltip => 'Filtrar';

  @override
  String get vacEmptyTitle => 'No hay vacunaciones programadas';

  @override
  String get vacEmptyDescription =>
      'Programa las vacunas para mantener la salud del lote';

  @override
  String get vacScheduleVaccination => 'Programar Vacunación';

  @override
  String get vacNoResults => 'Sin resultados';

  @override
  String get vacNoFilterResults =>
      'No se encontraron vacunaciones con los filtros aplicados';

  @override
  String get vacSchedule => 'Programar';

  @override
  String get vacScheduleTooltip => 'Programar nueva vacunación';

  @override
  String get vacNoFarmSelected => 'No hay granja seleccionada';

  @override
  String get vacNoFarmDescription =>
      'Selecciona una granja desde el menú principal para ver las vacunaciones programadas.';

  @override
  String get vacGoHome => 'Ir al inicio';

  @override
  String get vacFilterTitle => 'Filtrar vacunaciones';

  @override
  String get vacVaccinationStatus => 'Estado de vacunación';

  @override
  String get vacAllStatuses => 'Todos los estados';

  @override
  String get vacDeleteTitle => '¿Eliminar vacunación?';

  @override
  String get vacDeleted => 'Vacunación eliminada correctamente';

  @override
  String get vacMarkAppliedTitle => 'Marcar como Aplicada';

  @override
  String get vacApplicationDetails => 'Registra los detalles de la aplicación';

  @override
  String get vacAgeWeeksRequired => 'Edad (semanas) *';

  @override
  String get vacAgeRequired => 'La edad es obligatoria';

  @override
  String get vacAgeInvalid => 'La edad debe ser un número mayor a 0';

  @override
  String get vacDosisRequired => 'Dosis *';

  @override
  String get vacDosisValidation => 'La dosis es obligatoria';

  @override
  String get vacRouteRequired => 'Vía de aplicación *';

  @override
  String get vacRouteValidation => 'La vía es obligatoria';

  @override
  String get vacMarkedApplied => 'Vacuna marcada como aplicada';

  @override
  String get vacSheetApplied => 'Aplicada';

  @override
  String get vacSheetExpired => 'Vencida';

  @override
  String get vacSheetUpcoming => 'Próxima';

  @override
  String get vacSheetPending => 'Pendiente';

  @override
  String get vacVaccine => 'Vacuna';

  @override
  String get vacScheduledDate => 'Fecha programada';

  @override
  String get vacApplicationDate => 'Fecha aplicación';

  @override
  String get vacAgeApplication => 'Edad aplicación';

  @override
  String get vacWeeks => 'semanas';

  @override
  String get vacDosis => 'Dosis';

  @override
  String get vacRoute => 'Vía';

  @override
  String get vacLaboratory => 'Laboratorio';

  @override
  String get vacVaccineBatch => 'Lote vacuna';

  @override
  String get vacResponsible => 'Responsable';

  @override
  String get vacNextApplication => 'Próxima aplicación';

  @override
  String get vacScheduledBy => 'Programado por';

  @override
  String get vacMarkAppliedButton => 'Marcar Aplicada';

  @override
  String get vacDeleteButton => 'Eliminar';

  @override
  String get vacDetailTitle => 'Detalle de Vacunación';

  @override
  String get vacDetailNotFound => 'Vacunación no encontrada';

  @override
  String get vacDetailLoadError => 'No pudimos cargar la vacunación';

  @override
  String get vacDetailStatusApplied => 'Aplicada';

  @override
  String get vacDetailStatusExpired => 'Vencida';

  @override
  String get vacDetailStatusUpcoming => 'Próxima';

  @override
  String get vacDetailStatusPending => 'Pendiente';

  @override
  String get vacDetailVaccineInfo => 'Información de la Vacuna';

  @override
  String get vacDetailScheduledDate => 'Fecha Programada';

  @override
  String get vacDetailAgeApplication => 'Edad Aplicación';

  @override
  String get vacDetailVaccineBatch => 'Lote Vacuna';

  @override
  String get vacDetailNextApplication => 'Próxima Aplicación';

  @override
  String get vacDetailMarkAppliedButton => 'Marcar como Aplicada';

  @override
  String get vacDetailSelectDate => 'Selecciona la fecha de aplicación';

  @override
  String get vacDetailMarkedApplied => 'Vacunación marcada como aplicada';

  @override
  String get vacDetailMarkError => 'Error al marcar vacunación';

  @override
  String get vacDetailDeleteTitle => '¿Eliminar vacunación?';

  @override
  String get vacDetailDeleted => 'Vacunación eliminada';

  @override
  String get vacDetailDeleteError => 'Error al eliminar vacunación';

  @override
  String get vacDetailMenuMarkApplied => 'Marcar Aplicada';

  @override
  String get vacDetailMenuDelete => 'Eliminar';

  @override
  String get treatFormStepLocation => 'Ubicación';

  @override
  String get treatFormStepLocationDesc => 'Selecciona granja y lote';

  @override
  String get treatFormStepDiagnosis => 'Diagnóstico';

  @override
  String get treatFormStepDiagnosisDesc =>
      'Información del diagnóstico y síntomas';

  @override
  String get treatFormStepTreatment => 'Tratamiento';

  @override
  String get treatFormStepTreatmentDesc =>
      'Detalles del tratamiento y medicamentos';

  @override
  String get treatFormStepInfo => 'Información';

  @override
  String get treatFormStepInfoDesc => 'Veterinario y observaciones adicionales';

  @override
  String get treatDraftFoundMessage =>
      '¿Deseas restaurar el borrador del tratamiento guardado anteriormente?';

  @override
  String get treatSavedMomentAgo => 'Guardado hace un momento';

  @override
  String get treatExit => 'Salir';

  @override
  String get treatNewTitle => 'Nuevo Tratamiento';

  @override
  String get treatSelectFarmBatch =>
      'Por favor selecciona una granja y un lote';

  @override
  String get treatDurationRange => 'La duración debe ser entre 1 y 365 días';

  @override
  String get treatFutureDate => 'La fecha no puede ser futura';

  @override
  String get treatCompleteRequired =>
      'Por favor completa los campos obligatorios';

  @override
  String get treatRegisteredSuccess => 'Tratamiento registrado exitosamente';

  @override
  String get treatRegisteredInventoryError =>
      'Tratamiento registrado, pero hubo un error al actualizar inventario';

  @override
  String get treatRegisterError => 'Error al registrar tratamiento';

  @override
  String get vacFormStepVaccine => 'Vacuna';

  @override
  String get vacFormStepApplication => 'Aplicación';

  @override
  String get vacFormTitle => 'Programar Vacunación';

  @override
  String get vacFormSubmit => 'Programar Vacunación';

  @override
  String get vacFormDraftFound => 'Borrador encontrado';

  @override
  String get vacFormSelectBatch => 'Debes seleccionar un lote';

  @override
  String get vacFormSuccess => '¡Vacunación programada exitosamente!';

  @override
  String get vacFormInventoryError =>
      'Vacunación registrada, pero hubo un error al descontar inventario';

  @override
  String get vacFormError => 'Error al programar vacunación';

  @override
  String get vacFormScheduleError => 'Error al programar';

  @override
  String get diseaseCatalogTitle => 'Catálogo de Enfermedades';

  @override
  String get diseaseCatalogSearchHint => 'Buscar enfermedad, síntoma...';

  @override
  String get diseaseCatalogAll => 'Todas';

  @override
  String get diseaseCatalogCritical => 'Crítica';

  @override
  String get diseaseCatalogSevere => 'Grave';

  @override
  String get diseaseCatalogModerate => 'Moderada';

  @override
  String get diseaseCatalogMild => 'Leve';

  @override
  String get diseaseCatalogMandatoryNotification => 'Notificación obligatoria';

  @override
  String get diseaseCatalogVaccinable => 'Vacunable';

  @override
  String get diseaseCatalogCategory => 'Categoría';

  @override
  String get diseaseCatalogSymptoms => 'Síntomas';

  @override
  String get diseaseCatalogSeverity => 'Gravedad';

  @override
  String get diseaseCatalogViewDetails => 'Ver Detalles';

  @override
  String get diseaseCatalogNoResults => 'No se encontraron enfermedades';

  @override
  String get diseaseCatalogEmpty => 'Catálogo vacío';

  @override
  String get diseaseCatalogTryOther =>
      'Intenta con otros términos de búsqueda o filtros';

  @override
  String get diseaseCatalogNoneRegistered => 'No hay enfermedades registradas';

  @override
  String get diseaseCatalogClearFilters => 'Limpiar filtros';

  @override
  String get bioOverviewTitle => 'Bioseguridad';

  @override
  String get bioNewInspection => 'Nueva Inspección';

  @override
  String get bioNewInspectionTooltip => 'Crear nueva inspección';

  @override
  String get bioEmptyTitle => 'Todavía no hay inspecciones registradas';

  @override
  String get bioMetricInspections => 'Inspecciones';

  @override
  String get bioMetricAverage => 'Promedio';

  @override
  String get bioMetricCritical => 'Críticas';

  @override
  String get bioMetricLastLevel => 'Último nivel';

  @override
  String get bioRecentHistory => 'Historial reciente';

  @override
  String get bioGeneralInspection => 'Inspección general';

  @override
  String get bioShedInspection => 'Inspección por galpón';

  @override
  String get bioScore => 'Puntaje';

  @override
  String get bioNonCompliant => 'No cumple';

  @override
  String get bioPending => 'Pendientes';

  @override
  String get bioLoadError => 'No se pudo cargar bioseguridad';

  @override
  String get bioNoInspectionYet => 'Aún no hay una inspección completada.';

  @override
  String get bioLastInspection => 'Última inspección:';

  @override
  String get bioInspectionTitle => 'Inspección de Bioseguridad';

  @override
  String get bioInspectionNewTitle => 'Nueva Inspección';

  @override
  String get bioInspectionStepLocation => 'Ubicación';

  @override
  String get bioInspectionStepChecklist => 'Checklist';

  @override
  String get bioInspectionStepSummary => 'Resumen';

  @override
  String get bioInspectionSave => 'Guardar Inspección';

  @override
  String get bioInspectionLoadError => 'Error al cargar datos';

  @override
  String get bioInspectionExitTitle => '¿Salir sin completar?';

  @override
  String get bioInspectionExitMessage =>
      'Tienes una inspección en progreso. Si sales ahora, perderás los cambios.';

  @override
  String get bioInspectionSaveMessage =>
      'Se guardará la inspección y se generará el reporte correspondiente.';

  @override
  String get bioInspectionSaveSuccess => 'Inspección guardada exitosamente';

  @override
  String get bioInspectionLoadingFarm => 'Cargando granja…';

  @override
  String get bioInspectionMinProgress =>
      'Evalúa al menos el 50% de los items para continuar';

  @override
  String get saludSummaryTitle => 'Resumen de Salud';

  @override
  String get saludAllUnderControl => 'Todo bajo control';

  @override
  String get saludHealthStatus => 'Estado sanitario';

  @override
  String get saludActive => 'Activos';

  @override
  String get saludClosedCount => 'Cerrados';

  @override
  String get saludCardActive => 'Activo';

  @override
  String get saludCardClosed => 'Cerrado';

  @override
  String get saludCardDiagnosisPrefix => 'Diagnóstico: ';

  @override
  String get saludCardTreatmentPrefix => 'Tratamiento: ';

  @override
  String get saludErrorTitle => 'Error al cargar registros';

  @override
  String get vacSummaryTitle => 'Resumen de Vacunación';

  @override
  String get vacSummaryExpiredWarning => '¡Atención! Hay vacunas vencidas';

  @override
  String get vacSummaryUpcomingWarning => 'Hay vacunas próximas a aplicar';

  @override
  String get vacSummaryUpToDate => 'Vacunaciones al día';

  @override
  String get vacSummaryAllApplied => 'Todas las vacunas aplicadas';

  @override
  String get vacSummaryApplied => 'Aplicadas';

  @override
  String get vacCardStatusApplied => 'Aplicada';

  @override
  String get vacCardStatusExpired => 'Vencida';

  @override
  String get vacCardStatusUpcoming => 'Próxima';

  @override
  String get vacCardStatusPending => 'Pendiente';

  @override
  String get vacCardVaccinePrefix => 'Vacuna: ';

  @override
  String get vacCardDosisPrefix => 'Dosis: ';

  @override
  String get vacCardRoutePrefix => 'Vía: ';

  @override
  String get vacCardExpiredAgo => 'Vencida hace: ';

  @override
  String get vacCardDaysLeft => 'Faltan: ';

  @override
  String get vacErrorTitle => 'Error al cargar vacunaciones';

  @override
  String get vacStepVaccineInfoTitle => 'Información de la Vacuna';

  @override
  String get vacStepVaccineInfoDesc =>
      'Ingresa los datos de la vacuna a programar';

  @override
  String get vacStepBatchRequired => 'Lote *';

  @override
  String get vacStepSelectBatch => 'Selecciona un lote';

  @override
  String get vacStepSelectFromInventory => 'Seleccionar del inventario';

  @override
  String get vacStepSelectVaccineInventory =>
      'Seleccionar vacuna del inventario';

  @override
  String get vacStepOptionalSelectVaccine =>
      'Opcional - Selecciona una vacuna registrada';

  @override
  String get vacStepInventoryNote =>
      'Si seleccionas del inventario, el stock se descontará automáticamente.';

  @override
  String get vacStepVaccineName => 'Nombre de la vacuna';

  @override
  String get vacStepVaccineNameHint => 'Ej: Newcastle + Bronquitis';

  @override
  String get vacStepVaccineNameRequired => 'Ingresa el nombre de la vacuna';

  @override
  String get vacStepVaccineNameMinLength =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get vacStepVaccineBatch => 'Lote de la vacuna (opcional)';

  @override
  String get vacStepVaccineBatchHint => 'Ej: LOT123456';

  @override
  String get vacStepScheduledDate => 'Fecha programada *';

  @override
  String get vacStepTipTitle => 'Consejo';

  @override
  String get vacStepTipMessage =>
      'Programa las vacunaciones con anticipación para mantener el calendario sanitario al día.';

  @override
  String get vacStepAppObsTitle => 'Aplicación y Observaciones';

  @override
  String get vacStepAppObsDesc =>
      'Registra cuándo se aplicó y añade observaciones';

  @override
  String get vacStepAppDateOptional => 'Fecha de aplicación (opcional)';

  @override
  String get vacStepSelectDate => 'Seleccionar fecha';

  @override
  String get vacStepRemoveDate => 'Quitar fecha';

  @override
  String get vacStepObservationsOptional => 'Observaciones (opcional)';

  @override
  String get vacStepObservationsHint =>
      'Reacciones observadas, notas especiales, etc.';

  @override
  String get vacStepVaccineApplied => 'Vacuna aplicada';

  @override
  String get vacStepAppliedNote =>
      'La vacunación quedará registrada como aplicada.';

  @override
  String get vacStepScheduled => 'Vacunación programada';

  @override
  String get vacStepScheduledNote =>
      'Quedará pendiente. Podrás marcarla como aplicada más tarde.';

  @override
  String get vacStepCalendarReminder =>
      'Las vacunaciones programadas aparecerán en tu calendario y recibirás recordatorios.';

  @override
  String get treatStepDiagTitle => 'Diagnóstico y Síntomas';

  @override
  String get treatStepDiagDesc =>
      'Registra el diagnóstico y los síntomas observados en las aves';

  @override
  String get treatStepDiagImportant => 'Información importante';

  @override
  String get treatStepDiagImportantMsg =>
      'Un diagnóstico preciso permite seleccionar el tratamiento más efectivo y prevenir la propagación.';

  @override
  String get treatStepDateRequired => 'Fecha del tratamiento *';

  @override
  String get treatStepDiagnosis => 'Diagnóstico';

  @override
  String get treatStepDiagnosisHint => 'Ej: Enfermedad respiratoria crónica';

  @override
  String get treatStepDiagRequired => 'El diagnóstico es obligatorio';

  @override
  String get treatStepDiagMinLength => 'Debe tener al menos 5 caracteres';

  @override
  String get treatStepSymptoms => 'Síntomas observados';

  @override
  String get treatStepSymptomsHint =>
      'Describe los síntomas: tos, estornudos, decaimiento...';

  @override
  String get treatStepDetailsTitle => 'Detalles del Tratamiento';

  @override
  String get treatStepDetailsDesc =>
      'Describe el tratamiento aplicado y los medicamentos';

  @override
  String get treatStepDetailsImportant => 'Información importante';

  @override
  String get treatStepDetailsImportantMsg =>
      'Si seleccionas un medicamento del inventario, el stock se descontará automáticamente al guardar.';

  @override
  String get treatStepTreatmentDesc => 'Descripción del tratamiento';

  @override
  String get treatStepTreatmentHint =>
      'Describe el protocolo de tratamiento aplicado';

  @override
  String get treatStepTreatmentRequired => 'El tratamiento es obligatorio';

  @override
  String get treatStepTreatmentMinLength => 'Debe tener al menos 5 caracteres';

  @override
  String get treatStepInventoryMed => 'Medicamento del inventario (opcional)';

  @override
  String get treatStepSelectMed => 'Seleccionar medicamento del inventario...';

  @override
  String get treatStepAutoDeduct =>
      'Se descontará automáticamente del inventario';

  @override
  String get treatStepMedicationsAdditional => 'Medicamentos adicionales';

  @override
  String get treatStepMedications => 'Medicamentos';

  @override
  String get treatStepMedicationsHint =>
      'Ej: Enrofloxacina + Vitaminas A, D, E';

  @override
  String get treatStepDosis => 'Dosis';

  @override
  String get treatStepDosisHint => 'Ej: 1ml/L';

  @override
  String get treatStepDuration => 'Duración (días)';

  @override
  String get treatStepDurationHint => 'Ej: 5';

  @override
  String get treatStepDurationMin => 'Debe ser > 0';

  @override
  String get treatStepDurationMax => 'Máximo 365';

  @override
  String get treatStepSelectLocationTitle => 'Seleccionar Ubicación';

  @override
  String get treatStepSelectBatchTitle => 'Seleccionar Lote';

  @override
  String get treatStepSelectLocationDesc =>
      'Selecciona la granja y el lote para registrar el tratamiento';

  @override
  String get treatStepSelectBatchDesc =>
      'Selecciona el lote para registrar el tratamiento';

  @override
  String get treatStepSelectBatchSubDesc =>
      'Selecciona el lote donde se aplicará el tratamiento';

  @override
  String get treatStepNoFarms => 'No tienes granjas registradas';

  @override
  String get treatStepNoFarmsDesc =>
      'Debes crear una granja antes de registrar un tratamiento';

  @override
  String get treatStepFarmsError => 'Error al cargar granjas';

  @override
  String get treatStepFarmRequired => 'Granja *';

  @override
  String get treatStepSelectFarm => 'Selecciona una granja';

  @override
  String get treatStepFarmValidation => 'Por favor selecciona una granja';

  @override
  String get treatStepBatchRequired => 'Lote *';

  @override
  String get treatStepSelectBatch => 'Selecciona un lote';

  @override
  String get treatStepBatchValidation => 'Por favor selecciona un lote';

  @override
  String get treatStepNoActiveBatches => 'No hay lotes activos';

  @override
  String get treatStepNoActiveBatchesDesc =>
      'Esta granja no tiene lotes activos para registrar tratamientos';

  @override
  String get treatStepBatchesError => 'Error al cargar lotes';

  @override
  String get treatStepAdditionalTitle => 'Información Adicional';

  @override
  String get treatStepAdditionalDesc => 'Datos complementarios del tratamiento';

  @override
  String get treatStepAdditionalImportant => 'Información importante';

  @override
  String get treatStepAdditionalImportantMsg =>
      'Estos campos son opcionales pero ayudan a un mejor seguimiento del tratamiento.';

  @override
  String get treatStepVeterinarian => 'Veterinario responsable';

  @override
  String get treatStepVetName => 'Nombre del veterinario';

  @override
  String get treatStepGeneralObs => 'Observaciones generales';

  @override
  String get treatStepGeneralObsHint =>
      'Notas adicionales, evolución esperada, etc.';

  @override
  String get bioStepLocationTitle => '¿Dónde se realizará la inspección?';

  @override
  String get bioStepLocationDesc =>
      'Selecciona el galpón o deja en blanco para una inspección general.';

  @override
  String get bioStepInspector => 'Inspector';

  @override
  String get bioStepDate => 'Fecha';

  @override
  String get bioStepShed => 'Galpón';

  @override
  String get bioStepShedOptional =>
      'Opcional — si no seleccionas, la inspección aplica a toda la granja.';

  @override
  String get bioStepLoadingFarm => 'Cargando granja…';

  @override
  String get bioStepNoSheds =>
      'No hay galpones registrados. Se realizará inspección general.';

  @override
  String get bioStepWholeFarm => 'Toda la granja';

  @override
  String get bioChecklistCritical => 'Crítico';

  @override
  String get bioChecklistTapToEvaluate => 'Toca para evaluar';

  @override
  String get bioChecklistCompliant => 'Cumple';

  @override
  String get bioChecklistNonCompliant => 'No cumple';

  @override
  String get bioChecklistPartial => 'Parcial';

  @override
  String get bioChecklistNotApplicable => 'No aplica';

  @override
  String get bioChecklistPending => 'Pendiente';

  @override
  String get bioChecklistSelectResult =>
      'Selecciona el resultado de la evaluación';

  @override
  String get bioChecklistObservation => 'Observación';

  @override
  String get bioChecklistObservationHint =>
      'Escribe una observación (opcional)';

  @override
  String get bioSummaryTitle => 'Resumen de la inspección';

  @override
  String get bioSummarySubtitle => 'Revisa los resultados antes de guardar.';

  @override
  String get bioSummaryCumple => 'Cumple';

  @override
  String get bioSummaryParcial => 'Parcial';

  @override
  String get bioSummaryNoCumple => 'No cumple';

  @override
  String get bioSummaryCriticalItems => 'Items críticos sin cumplir';

  @override
  String get bioSummaryPendingNote =>
      'Puedes guardar, pero el puntaje solo refleja lo evaluado.';

  @override
  String get bioSummaryGeneralObs => 'Observaciones generales';

  @override
  String get bioSummaryGeneralObsHint =>
      'Describe hallazgos generales de la inspección…';

  @override
  String get bioSummaryCorrectiveActions => 'Acciones correctivas';

  @override
  String get bioSummaryCorrectiveHint => 'Describe las acciones a implementar…';

  @override
  String get bioSummaryRecommended => 'Recomendado';

  @override
  String get bioSummaryNote =>
      'Al guardar se generará un reporte descargable y el historial quedará registrado.';

  @override
  String get bioRatingExcellent => 'Excelente';

  @override
  String get bioRatingVeryGood => 'Muy Bueno';

  @override
  String get bioRatingGood => 'Bueno';

  @override
  String get bioRatingAcceptable => 'Aceptable';

  @override
  String get bioRatingRegular => 'Regular';

  @override
  String get bioRatingPoor => 'Deficiente';

  @override
  String get saludDialogCancel => 'Cancelar';

  @override
  String get saludDialogDelete => 'Eliminar';

  @override
  String get saludDialogContinue => 'Continuar';

  @override
  String get saludDialogConfirm => 'Confirmar';

  @override
  String get saludDialogAccept => 'Aceptar';

  @override
  String get saludDialogProcessing => 'Procesando...';

  @override
  String get saludSwipeClose => 'Cerrar';

  @override
  String get saludSwipeApply => 'Aplicar';

  @override
  String get saludSwipeDelete => 'Eliminar';

  @override
  String ventaDeleteMessage(Object product) {
    return 'Se eliminará la venta de $product. Esta acción no se puede deshacer.';
  }

  @override
  String ventaDeleteError(Object message) {
    return 'Error al eliminar: $message';
  }

  @override
  String ventaDetailsOf(Object product) {
    return 'Detalles de $product';
  }

  @override
  String ventaLotLoadError(Object error) {
    return 'Error al cargar lotes: $error';
  }

  @override
  String costoDeleteError2(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String costoApproveError(Object error) {
    return 'Error al aprobar: $error';
  }

  @override
  String costoRejectError(Object error) {
    return 'Error al rechazar: $error';
  }

  @override
  String saludDeleteRecordMessage(String diagnosis) {
    return 'Se eliminará el registro \"$diagnosis\". Esta acción no se puede deshacer.';
  }

  @override
  String saludActiveTreatments(Object count) {
    return '$count tratamiento(s) activo(s)';
  }

  @override
  String saludCardDays(Object count) {
    return '$count días';
  }

  @override
  String bioEmptyDescription(Object farmName) {
    return 'Inicia la primera inspección de bioseguridad para $farmName y lleva un registro continuo del cumplimiento sanitario.';
  }

  @override
  String bioChecklistProgress(String evaluated, Object total) {
    return '$evaluated de $total evaluados';
  }

  @override
  String bioSummaryRisk(Object evaluated, Object level, Object total) {
    return 'Riesgo $level · $evaluated de $total evaluados';
  }

  @override
  String bioSummaryPendingItems(Object count) {
    return '$count items pendientes';
  }

  @override
  String vacSummaryExpiredBadge(Object count) {
    return '$count vencida(s)';
  }

  @override
  String vacSummaryUpcomingBadge(Object count) {
    return '$count próxima(s)';
  }

  @override
  String vacCardAppliedDate(Object date) {
    return 'Aplicada: $date';
  }

  @override
  String vacCardDays(Object count) {
    return '$count días';
  }

  @override
  String vacDetailScheduled(Object date) {
    return 'Programada: $date';
  }

  @override
  String vacDetailAppliedOn(Object date) {
    return 'Aplicada el $date';
  }

  @override
  String vacFormDraftMessage(Object date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String treatSavedMinAgo(Object count) {
    return 'Guardado hace $count min';
  }

  @override
  String treatSavedAtTime(Object time) {
    return 'Guardado a las $time';
  }

  @override
  String get monthMayFull => 'Mayo';

  @override
  String get commonDiscard2 => 'Descartar';

  @override
  String get ventaClientBuyerInfo => 'Ingresa la información del comprador';

  @override
  String get ventaClientNameLabel => 'Nombre completo';

  @override
  String get ventaClientPhoneHint => '9 dígitos';

  @override
  String get ventaClientDniLength => 'El DNI debe tener 8 dígitos';

  @override
  String get ventaClientRucLength => 'El RUC debe tener 11 dígitos';

  @override
  String get ventaClientDocInvalid => 'Número inválido';

  @override
  String get ventaClientPhoneLength => 'El teléfono debe tener 9 dígitos';

  @override
  String get ventaClientForeignCard => 'Carnet de Extranjería';

  @override
  String get ventaSelectLocationDesc =>
      'Selecciona la granja y el lote para registrar la venta';

  @override
  String get ventaNoFarmsDesc =>
      'Debes crear una granja antes de registrar una venta';

  @override
  String get ventaErrorLoadingFarms => 'Error al cargar granjas';

  @override
  String get ventaSelectFarmError => 'Por favor selecciona una granja';

  @override
  String get ventaLoteLabelStar => 'Lote *';

  @override
  String get ventaSelectLoteHint => 'Selecciona un lote';

  @override
  String get ventaSelectLoteError => 'Por favor selecciona un lote';

  @override
  String get ventaNoActiveLotes => 'No hay lotes activos';

  @override
  String get ventaNoActiveLotesDesc =>
      'Esta granja no tiene lotes activos para registrar ventas';

  @override
  String get ventaErrorLoadingLotes => 'Error al cargar lotes';

  @override
  String get ventaFilterAllTypes => 'Todos los tipos';

  @override
  String get ventaFilterApply => 'Aplicar filtros';

  @override
  String get ventaFilterClose => 'Cerrar';

  @override
  String get ventaSheetObservations => 'Observaciones';

  @override
  String get ventaSheetRegistrationDate => 'Fecha de registro';

  @override
  String get ventaDetailLocation => 'Ubicación';

  @override
  String get ventaDetailGranja => 'Granja';

  @override
  String get ventaDetailLote => 'Lote';

  @override
  String get ventaDetailPhone => 'Teléfono';

  @override
  String get ventaDetailInfoRegistro => 'Información de Registro';

  @override
  String get ventaDetailRegisteredBy => 'Registrado por';

  @override
  String get ventaDetailRole => 'Rol';

  @override
  String get ventaDetailRegistrationDate => 'Fecha de registro';

  @override
  String get ventaDetailError => 'Error';

  @override
  String get ventaDetailMoreOptions => 'Más opciones';

  @override
  String ventaSavedAgo(Object time) {
    return 'Guardado $time';
  }

  @override
  String ventaShareDate(Object date) {
    return '📅 Fecha: $date';
  }

  @override
  String ventaShareType(Object type) {
    return '🏷️ Tipo: $type';
  }

  @override
  String ventaShareQuantityBirds(Object count) {
    return '📦 Cantidad: $count aves';
  }

  @override
  String ventaSharePrice(String currency, String price) {
    return '💵 Precio: $currency $price/kg';
  }

  @override
  String ventaShareEggs(Object count) {
    return '📦 Huevos: $count unidades';
  }

  @override
  String ventaShareQuantityPollinaza(Object count, Object unit) {
    return '📦 Cantidad: $count $unit';
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
    return '📍 Estado: $status';
  }

  @override
  String get ventaShareAppName => 'Smart Granja Aves Pro';

  @override
  String ventaShareSubject(Object type) {
    return 'Venta - $type';
  }

  @override
  String ventaDateOfLabel(String month, String year, Object day, Object time) {
    return '$day de $month $year • $time';
  }

  @override
  String get bioStepGalpon => 'Galpón';

  @override
  String get bioStepGalponHint => 'Selecciona el galpón a inspeccionar';

  @override
  String get bioStepNoGalpones => 'No hay galpones registrados en esta granja';

  @override
  String get bioStepSelectLocationHint =>
      'Selecciona la ubicación para la inspección de bioseguridad';

  @override
  String get bioTitle => 'Bioseguridad';

  @override
  String get invCodeOptional => 'Código / SKU (opcional)';

  @override
  String get invCurrentStock => 'Stock actual';

  @override
  String get invDescHerramienta =>
      'Herramientas, bebederos, comederos y equipos';

  @override
  String get invDescribeItem => 'Describe brevemente el item';

  @override
  String get invInternalCode => 'Código interno o SKU';

  @override
  String get invItemNameRequired => 'Nombre del item *';

  @override
  String get invLocationWarehouse => 'Ubicación / Almacén';

  @override
  String get invMaximumStock => 'Stock máximo';

  @override
  String get invMinimumStock => 'Stock mínimo';

  @override
  String get invNameRequired => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get invStepStockTitle => 'Stock y Unidades';

  @override
  String get invStockAlertDescription =>
      'Configura el stock mínimo para recibir alertas cuando el inventario esté bajo.';

  @override
  String get invSupplierBatchNumber => 'Número de lote del proveedor';

  @override
  String get invSupplierNameLabel => 'Nombre del proveedor';

  @override
  String get invWarehouseExample => 'Ej: Bodega principal, Galpón 1';

  @override
  String get ventaAverageWeight => 'Peso promedio';

  @override
  String get ventaBirdQuantity => 'Cantidad de aves';

  @override
  String get ventaCarcassYield => 'Rendimiento canal';

  @override
  String get ventaClient => 'Cliente';

  @override
  String get ventaClientDocument => 'Número de documento *';

  @override
  String get ventaClientDocumentInvalid => 'Documento inválido';

  @override
  String get ventaClientDocumentRequired => 'Ingresa el número de documento';

  @override
  String get ventaDeletedSuccess => 'Venta eliminada correctamente';

  @override
  String get ventaDocument => 'Documento';

  @override
  String get ventaEditTooltip => 'Editar venta';

  @override
  String get ventaNewSaleTitle => 'Nueva Venta';

  @override
  String get ventaNotFound => 'Venta no encontrada';

  @override
  String get ventaPhone => 'Teléfono';

  @override
  String get ventaProductDescAbono =>
      'Abono orgánico derivado de la producción avícola';

  @override
  String get ventaProductDescAvesEnPie =>
      'Venta de aves vivas en pie por kilogramo';

  @override
  String get ventaProductDescAvesFaenadas =>
      'Aves procesadas y listas para consumo';

  @override
  String get ventaProductDescHuevos =>
      'Venta de huevos por clasificación y docena';

  @override
  String get ventaProductDescOtro =>
      'Aves de descarte u otros productos avícolas';

  @override
  String get ventaProductDetails => 'Detalles del producto';

  @override
  String get ventaQuantity => 'Cantidad';

  @override
  String get ventaReceiptTitle => 'COMPROBANTE DE VENTA';

  @override
  String get ventasFilterTitle => 'Filtrar ventas';

  @override
  String get ventaShare => 'Compartir';

  @override
  String get ventaSlaughterWeight => 'Peso faenado';

  @override
  String get ventasProductType => 'Tipo de producto';

  @override
  String get ventaStepClientTitle => 'Datos del Cliente';

  @override
  String get ventaStepNoFarms => 'No hay granjas disponibles';

  @override
  String get ventaStepProductQuestion => '¿Qué tipo de producto vendes?';

  @override
  String get ventaStepSelectLocation => 'Selecciona Granja y Lote';

  @override
  String get ventaStepSelectLocationDesc =>
      'Elige la granja y el lote asociado a esta venta';

  @override
  String get ventaStepSummary => 'Resumen';

  @override
  String get ventaSubtotal => 'Subtotal';

  @override
  String get ventaTotalLabel => 'Total';

  @override
  String get ventaUnitPrice => 'Precio unitario';

  @override
  String get ventasTitle => 'Ventas';

  @override
  String get ventasFilter => 'Filtrar ventas';

  @override
  String get ventasEmpty => 'No hay ventas';

  @override
  String get ventasEmptyDescription => 'No se encontraron ventas registradas.';

  @override
  String get ventasNewSale => 'Nueva Venta';

  @override
  String get ventasNoResults => 'No hay resultados';

  @override
  String get ventasNoFilterResults =>
      'No se encontraron ventas con los filtros aplicados';

  @override
  String get ventasNewSaleTooltip => 'Registrar nueva venta';

  @override
  String get bioInspectionSaveButton => 'Guardar Inspección';

  @override
  String get bioInspectionMinEvaluation => 'Evaluación mínima';

  @override
  String get ventaStepFarmRequired => 'Debe seleccionar una granja';

  @override
  String get ventaStepSelectFarmFirst => 'Seleccione una granja primero';

  @override
  String get ventaStepNoActiveBatches => 'No hay lotes activos';

  @override
  String get ventaStepBatchRequired => 'Debe seleccionar un lote';

  @override
  String get ventaStepSelectBatch => 'Seleccionar lote';

  @override
  String get invExpirationDate => 'Fecha de expiración';

  @override
  String get ventaRegister => 'Registrar Venta';

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
    return 'Se eliminará la vacunación \"$nombre\". Esta acción no se puede deshacer.';
  }

  @override
  String get commonDraftFound => 'Borrador encontrado';

  @override
  String get commonDraftRestoreMessage =>
      '¿Deseas restaurar el borrador guardado anteriormente?';

  @override
  String get costoTypeManoObra => 'Mano de Obra';

  @override
  String get costoUpdatedSuccess => 'Costo actualizado correctamente';

  @override
  String get costoRegisteredSuccess => 'Costo registrado correctamente';

  @override
  String get batchAvgWeight => 'Peso Promedio';

  @override
  String get batchFeedConsumption => 'Consumo de Alimento';

  @override
  String get batchFeedConversionICA => 'Conversión Alimenticia (ICA)';

  @override
  String get batchRegisterWeightTooltip => 'Registrar peso del lote';

  @override
  String get batchOpenRegisterMenu => 'Abrir menú de registro';

  @override
  String get shedCapacityTotal => 'Capacidad Total';

  @override
  String get shedBirdsDensity => 'Aves/m²';

  @override
  String get shedMinCapacityHint => 'Ej: 1000';

  @override
  String get vacStepVaccine => 'Vacuna';

  @override
  String get vacStepApplication => 'Aplicación';

  @override
  String get vacSelectLote => 'Debes seleccionar un lote';

  @override
  String get vacErrorScheduling => 'Error al programar';

  @override
  String get vacScheduledSuccess => '¡Vacunación programada exitosamente!';

  @override
  String get vacErrorSchedulingDetail => 'Error al programar vacunación';

  @override
  String get vacCouldNotLoad => 'No pudimos cargar la vacunación';

  @override
  String get vacSelectAppDate => 'Selecciona la fecha de aplicación';

  @override
  String get vacExitTooltip => 'Salir';

  @override
  String get vacProgramLabel => 'Programar';

  @override
  String get vacProgramNewTooltip => 'Programar nueva vacunación';

  @override
  String get vacAgeWeeksLabel => 'Edad (semanas) *';

  @override
  String get vacAgeHint => 'Ej: 4';

  @override
  String get vacDoseHint => 'Ej: 0.5 ml';

  @override
  String get vacRouteLabel => 'Vía de aplicación *';

  @override
  String get vacRouteHint => 'Ej: Oral, subcutánea, ocular';

  @override
  String get vacDoseRequired => 'La dosis es obligatoria';

  @override
  String get treatStepLocation => 'Ubicación';

  @override
  String get treatStepTreatment => 'Tratamiento';

  @override
  String get treatStepInfo => 'Información';

  @override
  String get treatDraftMessage =>
      '¿Deseas restaurar el borrador del tratamiento guardado anteriormente?';

  @override
  String get treatFillRequired => 'Por favor completa los campos obligatorios';

  @override
  String get treatErrorRegistering => 'Error al registrar tratamiento';

  @override
  String get treatClosedSuccess => 'Tratamiento cerrado';

  @override
  String get treatCloseError => 'Error al cerrar tratamiento';

  @override
  String get saludDeleteTitle => '¿Eliminar registro?';

  @override
  String get saludDeletedSuccess => 'Registro eliminado';

  @override
  String get saludDeleteError => 'Error al eliminar registro';

  @override
  String get bioExitInProgress =>
      'Tienes una inspección en progreso. Si sales ahora, perderás los cambios.';

  @override
  String get bioSavedSuccess => 'Inspección guardada exitosamente';

  @override
  String get ventaDraftMessage =>
      '¿Deseas restaurar el borrador de venta guardado anteriormente?';

  @override
  String get ventaSelectBatch => 'Selecciona un lote';

  @override
  String ventaQuantityUnit(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String ventaPricePerUnit(String currency, String unit) {
    return 'Precio por $unit ($currency)';
  }

  @override
  String get ventaSaleStatusTitle => 'Estado de venta';

  @override
  String get ventaAllStatuses => 'Todos los estados';

  @override
  String get ventaPending => 'Pendiente';

  @override
  String get ventaConfirmed => 'Confirmada';

  @override
  String get ventaSold => 'Vendida';

  @override
  String get ventaSelectFarm => 'Selecciona una granja';

  @override
  String ventaDiscountLabel(String percent) {
    return 'Descuento ($percent%)';
  }

  @override
  String get consumoQuantityLabel => 'Cantidad';

  @override
  String get consumoTypeLabel => 'Tipo';

  @override
  String get consumoDateLabel => 'Fecha';

  @override
  String get consumoPerBirdLabel => 'Consumo por ave';

  @override
  String get consumoAccumulatedLabel => 'Consumo acumulado';

  @override
  String get consumoTotalCostLabel => 'Costo total';

  @override
  String get consumoCostPerBirdLabel => 'Costo por ave';

  @override
  String get consumoObservationsLabel => 'Observaciones';

  @override
  String get consumoObservationsOptional => 'Observaciones (opcional)';

  @override
  String get consumoRemoveSelection => 'Quitar selección';

  @override
  String invQuantityLabel(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String invNewStockLabel(String unit) {
    return 'Nuevo stock ($unit)';
  }

  @override
  String get whatsappMsgSupport =>
      '¡Hola! Necesito ayuda con la app Smart Granja Aves. ';

  @override
  String get whatsappMsgBug =>
      '¡Hola! Quiero reportar un problema en la app Smart Granja Aves: ';

  @override
  String get whatsappMsgSuggest =>
      '¡Hola! Tengo una sugerencia para la app Smart Granja Aves: ';

  @override
  String get whatsappMsgCollab =>
      '¡Hola! Estoy interesado en una colaboración con Smart Granja Aves. ';

  @override
  String get whatsappMsgPricing =>
      '¡Hola! Me gustaría conocer los planes y precios de Smart Granja Aves. ';

  @override
  String get whatsappMsgGeneral =>
      '¡Hola! Tengo una consulta sobre Smart Granja Aves. ';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get salesWeightHint => 'Ej: 250';

  @override
  String get salesPricePerKgHint => 'Ej: 8.50';

  @override
  String get salesPollinazaQuantityHint => 'Ej: 10';

  @override
  String get salesPollinazaPriceHint => 'Ej: 25.00';

  @override
  String get salesPriceGreaterThanZero => 'El precio debe ser mayor a 0';

  @override
  String get salesMaxPrice => 'El precio máximo es 9,999,999.99';

  @override
  String get salesEnterPricePerKg => 'Ingresa el precio por kg';

  @override
  String get salesEnterPrice => 'Ingresa el precio';

  @override
  String get salesEggInstructions =>
      'Ingresa la cantidad y precio por docena para cada clasificación';

  @override
  String get salesSaleUnit => 'Unidad de venta';

  @override
  String get salesNoEditPermission =>
      'No tienes permiso para editar ventas en esta granja';

  @override
  String get salesNoCreatePermission =>
      'No tienes permiso para registrar ventas en esta granja';

  @override
  String get salesSelectProductFirst =>
      'Selecciona un tipo de producto primero';

  @override
  String get salesObservationsLabel => 'Observaciones';

  @override
  String get salesObservationsHint => 'Notas adicionales (opcional)';

  @override
  String get salesSelectBatchLabel => 'Lote *';

  @override
  String get salesSelectBatchHint => 'Selecciona un lote';

  @override
  String get salesSelectBatchError => 'Selecciona un lote';

  @override
  String salesHuevosName(String name) {
    return 'Huevos $name';
  }

  @override
  String salesSavedAgo(String time) {
    return 'Guardado $time';
  }

  @override
  String get ventaListProductType => 'Tipo de producto';

  @override
  String get ventaListStatus => 'Estado';

  @override
  String get ventaListDocument => 'Documento';

  @override
  String get ventaListCarrier => 'Transportista';

  @override
  String get ventaListSubtotal => 'Subtotal';

  @override
  String get clientBuyerInfo => 'Ingresa la información del comprador';

  @override
  String get clientDocType => 'Tipo de documento *';

  @override
  String get clientForeignCard => 'Carnet de Extranjería';

  @override
  String get clientDocHint8 => '8 dígitos';

  @override
  String get clientDocHint11 => '11 dígitos';

  @override
  String get clientDocHintGeneral => 'Número de documento';

  @override
  String get clientPhoneHint => '9 dígitos';

  @override
  String get clientNameRequired => 'Ingresa el nombre del cliente';

  @override
  String get clientNameMinLength =>
      'El nombre debe tener al menos 3 caracteres';

  @override
  String get clientDocRequired => 'Ingresa el número de documento';

  @override
  String get clientDniError => 'El DNI debe tener 8 dígitos';

  @override
  String get clientRucError => 'El RUC debe tener 11 dígitos';

  @override
  String get clientDocInvalid => 'Número inválido';

  @override
  String get clientPhoneRequired => 'Ingresa el teléfono de contacto';

  @override
  String get clientPhoneError => 'El teléfono debe tener 9 dígitos';

  @override
  String get selectFarmCreateFirst =>
      'Debes crear una granja antes de registrar una venta';

  @override
  String get selectFarmLoadError => 'Error al cargar granjas';

  @override
  String get selectFarmHint => 'Selecciona una granja';

  @override
  String get selectFarmNoActiveLots =>
      'Esta granja no tiene lotes activos para registrar ventas';

  @override
  String get selectLotHint => 'Selecciona un lote';

  @override
  String get selectLotLoadError => 'Error al cargar lotes';

  @override
  String get selectProductHint =>
      'Selecciona el tipo de producto para esta venta';

  @override
  String get ventaSheetFaenadoWeight => 'Peso faenado';

  @override
  String get ventaSheetTotalHuevos => 'Total huevos';

  @override
  String get ventaSheetPollinazaQty => 'Cantidad';

  @override
  String get ventaSheetUnitPrice => 'Precio unitario';

  @override
  String get ventaSheetPhone => 'Teléfono';

  @override
  String ventaDiscountPercent(String percent) {
    return 'Descuento ($percent%)';
  }

  @override
  String ventaEmailSubject(String id) {
    return 'Venta - $id';
  }

  @override
  String ventaSaleOf(String product) {
    return 'Venta de $product';
  }

  @override
  String ventaSemantics(String product, String client, String status) {
    return 'Venta de $product, $client, estado $status';
  }

  @override
  String ventaDetailsUds(String name, String count) {
    return '$name ($count uds)';
  }

  @override
  String get ventaPerDozen => '/docena';

  @override
  String ventaEggClassifValue(String currency, String cantidad, String precio) {
    return '$cantidad uds ($currency $precio/doc)';
  }

  @override
  String costoDeleteConfirm(String name) {
    return '¿Estás seguro de eliminar el costo \"$name\"?\n\nEsta acción no se puede deshacer.';
  }

  @override
  String costoSemantics(String concept, String type, String amount) {
    return 'Costo $concept, tipo $type, monto $amount';
  }

  @override
  String get costoSheetExpenseType => 'Tipo de gasto';

  @override
  String get costoSheetConcept => 'Concepto';

  @override
  String get costoSheetProvider => 'Proveedor';

  @override
  String get costoSheetInvoice => 'Nº Factura';

  @override
  String get costoSheetRejectionReason => 'Motivo rechazo';

  @override
  String get costoSheetRegistrationDate => 'Fecha de registro';

  @override
  String get costoSheetObservations => 'Observaciones';

  @override
  String costoAutoFillConcept(String name) {
    return 'Compra de $name';
  }

  @override
  String get costoSavedMomentAgo => 'Guardado hace un momento';

  @override
  String costoSavedMinAgo(String min) {
    return 'Guardado hace $min min';
  }

  @override
  String costoSavedAtTime(String time) {
    return 'Guardado a las $time';
  }

  @override
  String get costoSelectExpenseType => 'Por favor selecciona un tipo de gasto';

  @override
  String get costoSelectFarm => 'Por favor selecciona una granja';

  @override
  String get costoFieldRequired => 'Este campo es obligatorio';

  @override
  String get costoInvoiceHint => 'F001-00001234';

  @override
  String costoItemCreated(String name) {
    return '¡Item \"$name\" creado!';
  }

  @override
  String get commonRejected => 'Rechazado';

  @override
  String get commonUser => 'Usuario';

  @override
  String get commonSelectDate => 'Seleccionar fecha';

  @override
  String get commonBirds => 'aves';

  @override
  String get commonDays => 'días';

  @override
  String commonSavedAgo(String time) {
    return 'Guardado $time';
  }

  @override
  String get commonUserNotAuth => 'Usuario no autenticado';

  @override
  String get commonFarmNotSpecified => 'Granja no especificada';

  @override
  String get commonBatchNotSpecified => 'Lote no especificado';

  @override
  String commonWeeksAgo(String weeks) {
    return 'Hace $weeks semana(s)';
  }

  @override
  String commonMonthsAgo(String months) {
    return 'Hace $months mes(es)';
  }

  @override
  String commonYearsAgo(String years) {
    return 'Hace $years año(s)';
  }

  @override
  String commonTodayAtTime(String time) {
    return 'hoy a las $time';
  }

  @override
  String get commonRelativeYesterday => 'ayer';

  @override
  String commonRelativeDaysAgo(String days) {
    return 'hace $days días';
  }

  @override
  String get commonAttention => 'Atención';

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
  String get galponStatCapacity => 'Capacidad Total';

  @override
  String get galponStatTotalBirds => 'Aves Totales';

  @override
  String get galponStatOccupancy => 'Ocupación';

  @override
  String get galponBirdDensity => 'Aves/m²';

  @override
  String get galponCapacityHint => 'Ej: 1000';

  @override
  String get galponAddTag => 'Agregar etiqueta';

  @override
  String get galponSpecCapacityHint => 'Ej: 10000';

  @override
  String get galponSpecAreaHint => 'Ej: 500';

  @override
  String get galponSpecAreaUnit => 'm²';

  @override
  String get galponSpecDrinkersHint => 'Ej: 50';

  @override
  String get galponSpecFeedersHint => 'Ej: 50';

  @override
  String get galponSpecNestsHint => 'Ej: 100';

  @override
  String get galponEnvTempMinHint => 'Ej: 18';

  @override
  String get galponEnvTempMaxHint => 'Ej: 28';

  @override
  String get galponEnvHumMinHint => 'Ej: 50';

  @override
  String get galponEnvHumMaxHint => 'Ej: 70';

  @override
  String get galponEnvVentMinHint => 'Ej: 100';

  @override
  String get galponEnvVentMaxHint => 'Ej: 300';

  @override
  String get galponEnvVentUnit => 'm³/h';

  @override
  String get galponNA => 'N/A';

  @override
  String get galponAvicola => 'Galpón Avícola';

  @override
  String get granjaAvicola => 'Granja Avícola';

  @override
  String get granjaNoAddress => 'Sin dirección';

  @override
  String get granjaPppm => 'ppm';

  @override
  String get granjaRucHint => 'J-12345678-9';

  @override
  String get granjaEngorde => 'Engorde';

  @override
  String get granjaPonedora => 'Ponedora';

  @override
  String get granjaReproductor => 'Reproductor';

  @override
  String get granjaAve => 'Ave';

  @override
  String get granjaActive => 'Activa';

  @override
  String get granjaInactive => 'Inactiva';

  @override
  String get granjaMaintenance => 'Mantenimiento';

  @override
  String get granjaStatusOperating => 'Operando normalmente';

  @override
  String get granjaStatusSuspended => 'Operaciones suspendidas';

  @override
  String get granjaStatusMaintenance => 'En proceso de mantenimiento';

  @override
  String get granjaMonthAbbr1 => 'Ene';

  @override
  String get granjaMonthAbbr2 => 'Feb';

  @override
  String get granjaMonthAbbr3 => 'Mar';

  @override
  String get granjaMonthAbbr4 => 'Abr';

  @override
  String get granjaMonthAbbr5 => 'May';

  @override
  String get granjaMonthAbbr6 => 'Jun';

  @override
  String get granjaMonthAbbr7 => 'Jul';

  @override
  String get granjaMonthAbbr8 => 'Ago';

  @override
  String get granjaMonthAbbr9 => 'Sep';

  @override
  String get granjaMonthAbbr10 => 'Oct';

  @override
  String get granjaMonthAbbr11 => 'Nov';

  @override
  String get granjaMonthAbbr12 => 'Dic';

  @override
  String invNewStock(String unit) {
    return 'Nuevo stock ($unit)';
  }

  @override
  String get invAdjustReasonHint => 'Ej: Inventario físico';

  @override
  String get invErrorEntryRegister =>
      'Error al registrar entrada de inventario';

  @override
  String get invErrorExitRegister => 'Error al registrar salida de inventario';

  @override
  String invExpiresInDays(String days) {
    return 'Vence en $days días';
  }

  @override
  String invStockLowAlert(String min, String unit) {
    return 'Stock bajo (mínimo: $min $unit)';
  }

  @override
  String invStockMinLabel(String min, String unit) {
    return 'Mínimo: $min $unit';
  }

  @override
  String invRelativeTodayAt(String time) {
    return 'hoy a las $time';
  }

  @override
  String get invRelativeYesterday => 'ayer';

  @override
  String invRelativeDaysAgo(String days) {
    return 'hace $days días';
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
    return '¡Item \"$name\" creado!';
  }

  @override
  String get invSkuHelper =>
      'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.';

  @override
  String get invDetailsOptional => 'Información opcional para mejor control';

  @override
  String get invTypeSelect => 'Selecciona la categoría del item de inventario';

  @override
  String get invTypeVaccines => 'Vacunas y productos de inmunización';

  @override
  String get invTypeDisinfectants => 'Productos de limpieza y desinfección';

  @override
  String get invUnitApplication => 'Aplicación';

  @override
  String get invUnitVolume => 'Volumen';

  @override
  String loteDaysAge(String age) {
    return '$age días';
  }

  @override
  String loteWeeksAndDays(String weeks, String days) {
    return '$weeks semanas ($days días)';
  }

  @override
  String loteBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String loteUnitsCount(String count) {
    return '$count unidades';
  }

  @override
  String loteCycleDay(String day, String remaining) {
    return 'Día $day de 45 ($remaining días restantes)';
  }

  @override
  String get loteCycleCompleted => 'Día 45 - Ciclo completado';

  @override
  String loteCycleExtra(String day, String extra) {
    return 'Día $day ($extra días extra)';
  }

  @override
  String get loteFeedUnit => 'kg alimento';

  @override
  String get loteFeedRef => '1.6 - 1.8';

  @override
  String loteCloseOverdue(String days) {
    return 'Cierre vencido hace $days días';
  }

  @override
  String loteCloseUpcoming(String days) {
    return 'Cierre próximo en $days días';
  }

  @override
  String loteICAHigh(String value) {
    return 'Índice de conversión alto ($value)';
  }

  @override
  String loteDaysCount(String days) {
    return '$days días';
  }

  @override
  String get loteRazaLinea => 'Raza/Línea';

  @override
  String get loteDaysRemaining => 'Días Restantes';

  @override
  String get loteBirdsLabel => 'Aves';

  @override
  String get loteEnterValidQty => 'Ingrese una cantidad válida mayor a 0';

  @override
  String get loteSelectNewState => 'Seleccionar nuevo estado:';

  @override
  String loteConfirmStateChange(String state) {
    return '¿Confirmar cambio a $state?';
  }

  @override
  String get loteStateWarning =>
      'Este estado es permanente y no podrá revertirse. Los datos del lote se archivarán.';

  @override
  String get loteLocationCode => 'Código';

  @override
  String get loteLocationMaxCapacity => 'Capacidad Máxima';

  @override
  String get loteLocationCurrentOccupancy => 'Ocupación Actual';

  @override
  String get loteLocationCurrentBirds => 'Aves Actuales';

  @override
  String loteLocationBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String get loteLocationOccupancyLabel => 'Ocupación';

  @override
  String loteLocationOccupancyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get loteLocationBirdType => 'Tipo de Ave en Galpón';

  @override
  String loteLocationMaxCapacityInfo(String count) {
    return 'Capacidad máxima: $count aves';
  }

  @override
  String loteLocationAreaInfo(String area) {
    return 'Área: $area m²';
  }

  @override
  String get loteLocationErrorLoading => 'Error al cargar galpones';

  @override
  String get loteLocationSharedSpace =>
      'El nuevo lote compartirá el espacio disponible.';

  @override
  String get loteTypeLayer => 'Gallinas ponedoras para producción de huevos';

  @override
  String get loteTypeBroiler => 'Pollos de engorde para producción de carne';

  @override
  String get loteTypeHeavyBreeder => 'Aves reproductoras pesadas para crías';

  @override
  String get loteTypeLightBreeder => 'Aves reproductoras livianas para crías';

  @override
  String get loteTypeTurkey => 'Pavos para producción de carne';

  @override
  String get loteTypeDuck => 'Patos para producción de carne';

  @override
  String loteResumenAge(String age) {
    return '$age días';
  }

  @override
  String loteResumenWeeks(String weeks, String days) {
    return '($weeks sem, $days días)';
  }

  @override
  String loteConsumoStockInsufficient(String stock) {
    return 'Stock insuficiente. Disponible: $stock kg';
  }

  @override
  String loteConsumoStockUsage(String percent) {
    return 'Usarás el $percent% del stock disponible';
  }

  @override
  String loteConsumoRecommended(String days, String amount) {
    return 'Recomendado para $days días: $amount';
  }

  @override
  String get loteConsumoImportantInfo => 'Información importante';

  @override
  String get loteConsumoAutoCalc =>
      'Los costos y métricas se calculan automáticamente al registrar el consumo.';

  @override
  String get lotePesoEggHint =>
      'Describe calidad de los huevos, color de cáscara, tamaño, anomalías observadas...';

  @override
  String get lotePesoBirdsWeighed => 'Aves pesadas';

  @override
  String lotePesoGainPerDay(String value) {
    return '$value g/día';
  }

  @override
  String get lotePesoCV => 'Coeficiente de variación';

  @override
  String get loteConsumoErrorLoading => 'Error al cargar alimentos';

  @override
  String get loteLoteDetailEngorde => 'Aves criadas para producción de carne';

  @override
  String get loteLoteDetailPonedora => 'Aves criadas para producción de huevos';

  @override
  String get loteLoteDetailRepPesada => 'Aves reproductoras de línea pesada';

  @override
  String get loteLoteDetailRepLiviana => 'Aves reproductoras de línea liviana';

  @override
  String get loteAreaUnit => 'm²';

  @override
  String get saludDose => 'Dosis';

  @override
  String saludDurationDays(String days) {
    return '$days días';
  }

  @override
  String get saludRegistrationInfo => 'Información de Registro';

  @override
  String get saludLastUpdate => 'Última actualización';

  @override
  String saludDeleteDetail(String name) {
    return 'Se eliminará el registro de \"$name\". Esta acción no se puede deshacer.';
  }

  @override
  String get saludUpcoming => 'Próxima';

  @override
  String get saludLocationSection => 'Ubicación';

  @override
  String get saludFarm => 'Granja';

  @override
  String get saludBatch => 'Lote';

  @override
  String get saludVaccineInfoSection => 'Información de la Vacuna';

  @override
  String get saludVaccine => 'Vacuna';

  @override
  String get saludApplicationAge => 'Edad Aplicación';

  @override
  String get saludRoute => 'Vía';

  @override
  String get saludLaboratory => 'Laboratorio';

  @override
  String get saludVaccineBatch => 'Lote Vacuna';

  @override
  String get saludResponsible => 'Responsable';

  @override
  String get saludNextApplication => 'Próxima Aplicación';

  @override
  String get saludProgramDescription =>
      'Programa las vacunas para mantener la salud del lote';

  @override
  String get saludVacDeleted => 'Vacunación eliminada correctamente';

  @override
  String get saludRegisterAppDetails =>
      'Registra los detalles de la aplicación';

  @override
  String get saludCurrentUser => 'Usuario Actual';

  @override
  String get saludVacTableVaccine => 'Vacuna';

  @override
  String get saludVacTableAppDate => 'Fecha aplicación';

  @override
  String get saludVacTableAppAge => 'Edad aplicación';

  @override
  String get saludVacTableNextApp => 'Próxima aplicación';

  @override
  String get saludTreatStepDescLocation => 'Selecciona granja y lote';

  @override
  String get saludTreatStepDescDiagnosis =>
      'Información del diagnóstico y síntomas';

  @override
  String get saludTreatStepDescTreatment =>
      'Detalles del tratamiento y medicamentos';

  @override
  String get saludTreatStepDescInfo =>
      'Veterinario y observaciones adicionales';

  @override
  String get saludTreatSavedMoment => 'Guardado hace un momento';

  @override
  String saludTreatSavedMin(String min) {
    return 'Guardado hace $min min';
  }

  @override
  String saludTreatSavedAt(String time) {
    return 'Guardado a las $time';
  }

  @override
  String get saludTreatSelectFarmBatch =>
      'Por favor selecciona una granja y un lote';

  @override
  String get saludTreatDurationRange =>
      'La duración debe ser entre 1 y 365 días';

  @override
  String get saludTreatFutureDate => 'La fecha no puede ser futura';

  @override
  String get saludVacInventoryWarning =>
      'Vacunación registrada, pero hubo un error al descontar inventario';

  @override
  String get saludBioErrorLoading => 'Error al cargar datos';

  @override
  String get saludBioConfirmSave =>
      'Se guardará la inspección y se generará el reporte correspondiente.';

  @override
  String saludBioErrorSaving(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get saludBioTitleGeneral => 'Inspección general de bioseguridad';

  @override
  String get saludBioTitleByGalpon => 'Inspección de bioseguridad por galpón';

  @override
  String get saludBioNotReviewed => 'Aún no se ha revisado.';

  @override
  String get saludBioCompliant => 'Cumplimiento correcto.';

  @override
  String get saludBioNonCompliant => 'Se detectó incumplimiento.';

  @override
  String get saludBioWithObservations => 'Cumple con observaciones.';

  @override
  String get saludBioNotApplicable => 'No corresponde evaluar.';

  @override
  String get saludSwipeHint => 'Desliza para acciones rápidas';

  @override
  String get saludCatalogMandatoryNotification => 'Notificación obligatoria';

  @override
  String get saludCatalogCategory => 'Categoría';

  @override
  String get saludCatalogNoResults => 'No se encontraron enfermedades';

  @override
  String get saludCatalogEmpty => 'Catálogo vacío';

  @override
  String get saludCatalogSearchHint =>
      'Intenta con otros términos de búsqueda o filtros';

  @override
  String get saludCatalogGeneralInfo => 'Información General';

  @override
  String get saludCatalogTransmission => 'Transmisión y Diagnóstico';

  @override
  String get saludCatalogMainSymptoms => 'Síntomas Principales';

  @override
  String get saludCatalogPostmortem => 'Lesiones Post-mortem';

  @override
  String get saludCatalogTreatPrevention => 'Tratamiento y Prevención';

  @override
  String get saludCatalogPreventableVax => 'Prevenible por vacunación';

  @override
  String get saludCatalogCausativeAgent => 'Agente Causal';

  @override
  String get saludCatalogNotification => 'Notificación';

  @override
  String get saludCatalogTransmissionLabel => 'Transmisión';

  @override
  String get saludCatalogDiagnosisLabel => 'Diagnóstico';

  @override
  String saludVacDraftMessage(String date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String get saludVacProgramTitle => 'Programar Vacunación';

  @override
  String get whatsappHelp =>
      '¡Hola! Necesito ayuda con la app Smart Granja Aves. ';

  @override
  String get whatsappReportBug =>
      '¡Hola! Quiero reportar un problema en la app Smart Granja Aves: ';

  @override
  String get whatsappSuggestion =>
      '¡Hola! Tengo una sugerencia para la app Smart Granja Aves: ';

  @override
  String get whatsappCollaboration =>
      '¡Hola! Estoy interesado en una colaboración con Smart Granja Aves. ';

  @override
  String get whatsappPricing =>
      '¡Hola! Me gustaría conocer los planes y precios de Smart Granja Aves. ';

  @override
  String get whatsappQuery =>
      '¡Hola! Tengo una consulta sobre Smart Granja Aves. ';

  @override
  String get homeAppTitle => 'Smart Granja Aves';

  @override
  String get authProBadge => 'PRO';

  @override
  String get perfilLanguage => 'Español';

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
    return 'Reporte_$id.pdf';
  }

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusConfirmed => 'Confirmada';

  @override
  String get statusSold => 'Vendida';

  @override
  String get statusApproved => 'Aprobado';

  @override
  String get treatStepSelectFarmLotDesc => 'Selecciona granja y lote';

  @override
  String get treatStepDiagnosisInfoDesc =>
      'Información del diagnóstico y síntomas';

  @override
  String get treatStepTreatmentDetailsDesc =>
      'Detalles del tratamiento y medicamentos';

  @override
  String get treatStepVetObsDesc => 'Veterinario y observaciones adicionales';

  @override
  String saludDeleteConfirmMsg(String name) {
    return 'Se eliminará el registro de \"$name\". Esta acción no se puede deshacer.';
  }

  @override
  String commonDurationDays(String count) {
    return '$count días';
  }

  @override
  String commonWeeks(String count) {
    return '$count semanas';
  }

  @override
  String get vacLocationTitle => 'Ubicación';

  @override
  String get vacInfoTitle => 'Información de la Vacuna';

  @override
  String get vacVaccineLabel => 'Vacuna';

  @override
  String get vacDoseLabel => 'Dosis';

  @override
  String get vacRouteShort => 'Vía';

  @override
  String get vacBatchVaccineLabel => 'Lote Vacuna';

  @override
  String get vacNextApplicationLabel => 'Próxima Aplicación';

  @override
  String get vacScheduleTitle => 'Programar Vacunación';

  @override
  String vacDraftFoundMsg(String date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String vacDaysAgo(String days) {
    return 'hace $days días';
  }

  @override
  String get vacDeletedSuccess => 'Vacunación eliminada correctamente';

  @override
  String get vacApplyDetails => 'Registra los detalles de la aplicación';

  @override
  String get vacFilterAll => 'Todos';

  @override
  String get saludInspectionSaveMsg =>
      'Se guardará la inspección y se generará el reporte correspondiente.';

  @override
  String get saludInspGeneralDesc => 'Inspección general de bioseguridad';

  @override
  String get saludInspShedDesc => 'Inspección de bioseguridad por galpón';

  @override
  String get saludCheckNotReviewed => 'Aún no se ha revisado.';

  @override
  String get saludCheckNonCompliance => 'Se detectó incumplimiento.';

  @override
  String get commonSwipeActions => 'Desliza para acciones rápidas';

  @override
  String get commonGalponAvicola => 'Galpón Avícola';

  @override
  String get commonCode => 'Código';

  @override
  String get commonMaxCapacity => 'Capacidad Máxima';

  @override
  String get commonImportantInfo => 'Información importante';

  @override
  String get commonCostsAutoCalculated =>
      'Los costos y métricas se calculan automáticamente según los datos ingresados.';

  @override
  String get loteRazaLineaLabel => 'Raza/Línea';

  @override
  String get loteDiasRestantes => 'Días Restantes';

  @override
  String loteGdpFormat(String value) {
    return '$value g/día';
  }

  @override
  String get loteCoefVariacion => 'Coeficiente de variación';

  @override
  String get loteShedActiveConflict =>
      'Este galpón ya tiene un lote activo. No es posible asignar más de un lote activo por galpón.';

  @override
  String get commonOptimal => 'Óptimo';

  @override
  String get commonCritical => 'Crítico';

  @override
  String loteCierreVencido(String days) {
    return 'Cierre vencido hace $days días';
  }

  @override
  String loteCierreProximo(String days) {
    return 'Cierre próximo en $days días';
  }

  @override
  String loteEdadDias(String days) {
    return '$days días';
  }

  @override
  String loteEdadSemanasDias(String semanas, String dias) {
    return '$semanas semanas ($dias días)';
  }

  @override
  String loteEdadFormat(String edad, String dias) {
    return '$edad ($dias días)';
  }

  @override
  String invStockBajo(String min, String unit) {
    return 'Stock bajo (mínimo: $min $unit)';
  }

  @override
  String invVenceEn(String days) {
    return 'Vence en $days días';
  }

  @override
  String get invSkuHelp =>
      'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.';

  @override
  String get invSelectCategory =>
      'Selecciona la categoría del item de inventario';

  @override
  String get invCatVaccines => 'Vacunas y productos de inmunización';

  @override
  String get invCatDisinfection => 'Productos de limpieza y desinfección';

  @override
  String get galponTimeToday => 'Hoy';

  @override
  String get galponTimeYesterday => 'Ayer';

  @override
  String galponTimeDaysAgo(String days) {
    return 'Hace $days días';
  }

  @override
  String loteEdadRegistro(String days) {
    return 'Edad: $days días';
  }

  @override
  String get perfilLanguageSpanish => 'Español';

  @override
  String vacScheduledFormat(String date) {
    return 'Programada: $date';
  }

  @override
  String vacAppliedOnFormat(String date) {
    return 'Aplicada el $date';
  }

  @override
  String get vacAppliedDate => 'Fecha aplicación';

  @override
  String get vacCurrentUser => 'Usuario Actual';

  @override
  String get vacEmptyDesc =>
      'Programa las vacunas para mantener la salud del lote';

  @override
  String get commonNoFarmSelected => 'No hay granja seleccionada';

  @override
  String commonErrorDeleting(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String commonErrorApplying(String error) {
    return 'Error al aplicar vacuna: $error';
  }

  @override
  String get vacRegisteredInventoryError =>
      'Vacunación registrada, pero hubo un error al descontar inventario';

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
  String get commonErrorLoadingData => 'Error al cargar datos';

  @override
  String get saludCheckCompliance => 'Cumplimiento correcto.';

  @override
  String get saludCheckPartial => 'Cumple con observaciones.';

  @override
  String get saludCheckNA => 'No corresponde evaluar.';

  @override
  String get loteProgressCycle => 'Progreso del ciclo';

  @override
  String loteDayOfCycle(String day, String remaining) {
    return 'Día $day de 45 ($remaining días restantes)';
  }

  @override
  String loteExtraDays(String day, String extra) {
    return 'Día $day ($extra días extra)';
  }

  @override
  String get loteAttention => 'Atención';

  @override
  String get loteKeyIndicators => 'Indicadores clave';

  @override
  String loteMortalityHigh(String rate, String expected) {
    return 'Mortalidad elevada ($rate% > $expected% esperado)';
  }

  @override
  String loteWeightBelow(String percent) {
    return 'Peso por debajo del objetivo ($percent% menos)';
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
  String get loteTrendAcceptable => 'Aceptable';

  @override
  String get loteTrendBajo => 'Bajo';

  @override
  String get loteTrendBuena => 'Buena';

  @override
  String get loteTrendRegular => 'Regular';

  @override
  String get loteTrendBaja => 'Baja';

  @override
  String get loteRegister => 'Registrar';

  @override
  String get loteDashSummary => 'Resumen';

  @override
  String get batchInitialFlock => 'Parvada inicial';

  @override
  String get loteCierreEstimado => 'Cierre Estimado';

  @override
  String get loteNotRegistered => 'No registrado';

  @override
  String get loteNotRecorded => 'Not recorded';

  @override
  String get birdDescPolloEngorde => 'Aves criadas para producción de carne';

  @override
  String get birdDescGallinaPonedora =>
      'Aves criadas para producción de huevos';

  @override
  String get birdDescRepPesada => 'Aves reproductoras de línea pesada';

  @override
  String get birdDescRepLiviana => 'Aves reproductoras de línea liviana';

  @override
  String get birdDescPavo => 'Pavos para carne';

  @override
  String get birdDescCodorniz => 'Codornices para huevos o carne';

  @override
  String get birdDescPato => 'Patos para carne';

  @override
  String get birdDescOtro => 'Otro tipo de ave';

  @override
  String get birdDescFormPolloEngorde =>
      'Pollos de engorde para producción de carne';

  @override
  String get birdDescFormGallinaPonedora =>
      'Gallinas ponedoras para producción de huevos';

  @override
  String get birdDescFormRepPesada => 'Aves reproductoras pesadas para crías';

  @override
  String get birdDescFormRepLiviana => 'Aves reproductoras livianas para crías';

  @override
  String get birdDescFormPavo => 'Pavos para producción de carne';

  @override
  String get birdDescFormCodorniz => 'Codornices para huevos o carne';

  @override
  String get birdDescFormPato => 'Patos para producción de carne';

  @override
  String get birdDescFormOtro => 'Otro tipo de ave';

  @override
  String loteShedActiveWarning(String code) {
    return 'Este galpón ya tiene un lote activo ($code). El nuevo lote compartirá el espacio disponible.';
  }

  @override
  String get ubicacionCurrentOccupation => 'Ocupación Actual';

  @override
  String get ubicacionCurrentBirds => 'Aves Actuales';

  @override
  String get ubicacionAvailableCapacity => 'Capacidad Disponible';

  @override
  String get ubicacionOccupation => 'Ocupación';

  @override
  String get ubicacionBirdTypeInShed => 'Tipo de Ave en Galpón';

  @override
  String ubicacionBirdsCount(String count) {
    return '$count aves';
  }

  @override
  String ubicacionCapacityInfo(String capacity) {
    return 'Capacidad máxima: $capacity aves';
  }

  @override
  String ubicacionAreaInfo(String area) {
    return 'Área: $area m²';
  }

  @override
  String get commonErrorLoadingShed => 'Error al cargar galpones';

  @override
  String get consumoSummaryTitle => 'Resumen del Consumo';

  @override
  String get consumoSummarySubtitle =>
      'Revisa los datos y agrega observaciones';

  @override
  String get consumoObsHint =>
      'Ej: Aves con buen apetito, alimento bien recibido...';

  @override
  String get invBasicInfoSubtitle => 'Ingresa los datos principales del item';

  @override
  String get invOptionalDetails => 'Información opcional para mejor control';

  @override
  String get invOptionalDetailsInfo =>
      'Estos datos son opcionales pero ayudan a un mejor control y trazabilidad del inventario.';

  @override
  String get invCatInsumo =>
      'Materiales de cama, desinfectantes y otros insumos';

  @override
  String get invImageReady => 'Lista';

  @override
  String get invCanAddPhoto => 'Puedes agregar una foto del producto';

  @override
  String loteFormatDays(String count) {
    return '$count días';
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
    return '$count mes';
  }

  @override
  String loteFormatMonths(String count) {
    return '$count meses';
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
  String get loteFeedKg => 'kg alimento';

  @override
  String loteFormatMonthAndWeeksShort(String months, String weeks) {
    return '$months mes y $weeks sem';
  }

  @override
  String loteFormatMonthsAndWeeksShort(String months, String weeks) {
    return '$months meses y $weeks sem';
  }

  @override
  String loteResumenWeeksDays(String weeks, String days) {
    return ' ($weeks sem, $days días)';
  }

  @override
  String loteResumenWeeksParens(String weeks) {
    return ' ($weeks semanas)';
  }

  @override
  String get invCatLimpieza => 'Productos de limpieza y desinfección';

  @override
  String get invHintExample => 'Ej: Concentrado Iniciador';

  @override
  String get commonArea => 'Área';

  @override
  String invStockInfoFormat(String stock, String unit) {
    return 'Stock actual: $stock $unit';
  }

  @override
  String get invMotiveHint => 'Ej: Inventario físico';

  @override
  String ubicacionShedDropdown(String code, String capacity) {
    return '$code - Capacidad: $capacity aves';
  }

  @override
  String invDraftFoundMessage(String date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String get catalogDiseaseNotifRequired => 'Notificación obligatoria';

  @override
  String get catalogDiseaseVaccinable => 'Vacunable';

  @override
  String get commonCategory => 'Categoría';

  @override
  String get catalogDiseaseSymptoms => 'Síntomas';

  @override
  String get catalogDiseaseSeverity => 'Gravedad';

  @override
  String get catalogDiseaseNotFound => 'No se encontraron enfermedades';

  @override
  String get catalogDiseaseEmpty => 'Catálogo vacío';

  @override
  String get catalogDiseaseSearchHint =>
      'Intenta con otros términos de búsqueda o filtros';

  @override
  String get catalogDiseaseNone => 'No hay enfermedades registradas';

  @override
  String get catalogDiseaseInfoGeneral => 'Información General';

  @override
  String get catalogDiseaseTransDiag => 'Transmisión y Diagnóstico';

  @override
  String get catalogDiseaseMainSymptoms => 'Síntomas Principales';

  @override
  String get catalogDiseasePostmortem => 'Lesiones Post-mortem';

  @override
  String get catalogDiseaseTreatPrev => 'Tratamiento y Prevención';

  @override
  String get catalogDiseaseNotifOblig => 'Notificación Obligatoria';

  @override
  String get catalogDiseaseVaccinePrevent => 'Prevenible por vacunación';

  @override
  String get catalogDiseaseCausalAgent => 'Agente Causal';

  @override
  String get catalogDiseaseContagious => 'Contagiosa';

  @override
  String get catalogDiseaseNotification => 'Notificación';

  @override
  String get catalogDiseaseVaccineAvail => 'Vacuna Disponible';

  @override
  String get catalogDiseaseTransmission => 'Transmisión';

  @override
  String get catalogDiseaseDiagnosis => 'Diagnóstico';

  @override
  String get catalogDiseaseViewDetails => 'Ver Detalles';

  @override
  String get catalogDiseaseConsultVet => 'Consulte con su veterinario';

  @override
  String get batchSelectNewStatusLabel => 'Seleccionar nuevo estado:';

  @override
  String batchConfirmStatusChange(String status) {
    return '¿Confirmar cambio a $status?';
  }

  @override
  String get batchPermanentStatusWarning =>
      'Este estado es permanente y no podrá revertirse. El lote no podrá cambiar a ningún otro estado después de esta acción.';

  @override
  String get batchPermanentStatus => 'Estado permanente';

  @override
  String get batchTypePoultryDesc => 'Aves criadas para producción de carne';

  @override
  String get batchTypeLayersDesc => 'Aves criadas para producción de huevos';

  @override
  String get batchTypeHeavyBreedersDesc => 'Aves reproductoras de línea pesada';

  @override
  String get batchTypeLightBreedersDesc =>
      'Aves reproductoras de línea liviana';

  @override
  String get batchTypeTurkeysDesc => 'Pavos para carne';

  @override
  String get batchTypeQuailDesc => 'Codornices para huevos o carne';

  @override
  String get batchTypeDucksDesc => 'Patos para carne';

  @override
  String get batchTypeOtherDesc => 'Otro tipo de ave';

  @override
  String get batchNotRecorded => 'No registrado';

  @override
  String get commonBirdsUnit => 'aves';

  @override
  String batchAgeDaysValue(String count) {
    return '$count días';
  }

  @override
  String batchAgeWeeksDaysValue(String weeks, String days) {
    return '$weeks semanas ($days días)';
  }

  @override
  String get costExpenseType => 'Tipo de gasto';

  @override
  String get costProvider => 'Proveedor';

  @override
  String get costRejectionReason => 'Motivo rechazo';

  @override
  String get weightBirdsWeighed => 'Aves pesadas';

  @override
  String get weightTotal => 'Peso total';

  @override
  String get weightDailyGain => 'GDP (Ganancia diaria)';

  @override
  String get weightGramsPerDay => 'g/día';

  @override
  String feedExceedsStock(String stock) {
    return 'La cantidad excede el stock disponible ($stock kg)';
  }

  @override
  String feedStockPercentUsage(String percent) {
    return 'Usarás el $percent% del stock disponible';
  }

  @override
  String feedRecommendedForDays(String days, String type) {
    return 'Recomendado para $days días: $type';
  }

  @override
  String get feedConsumptionDate => 'Fecha del consumo';

  @override
  String get feedObsTitle => 'Observaciones';

  @override
  String get feedObsOptionalHint => 'Opcional: Agrega notas adicionales';

  @override
  String get feedObsDescribeHint =>
      'Describe condiciones del suministro, comportamiento de las aves, calidad del alimento, etc.';

  @override
  String get feedObsHelpText =>
      'Las observaciones ayudan a documentar detalles importantes del suministro de alimento y pueden ser útiles para análisis futuros.';

  @override
  String get ventaSelectBatchHint => 'Selecciona un lote';

  @override
  String get ventaBatchLoadError => 'Error al cargar lotes';

  @override
  String get saludRegisteredBy => 'Registrado por';

  @override
  String get saludCloseTreatment => 'Cerrar Tratamiento';

  @override
  String get saludResultOptional => 'Resultado (Opcional)';

  @override
  String get saludMonthNames =>
      'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';

  @override
  String get saludDateConnector => 'de';

  @override
  String get treatDurationValidation =>
      'La duración debe ser entre 1 y 365 días';

  @override
  String get commonDateCannotBeFuture => 'La fecha no puede ser futura';

  @override
  String get treatNewTreatment => 'Nuevo Tratamiento';

  @override
  String get commonSaveAction => 'Guardar';

  @override
  String get costRegisteredInventoryError =>
      'Costo registrado, pero hubo un error al actualizar inventario';

  @override
  String invStockActualLabel(String stock, String unit) {
    return 'Actual: $stock $unit';
  }

  @override
  String invStockMinimoLabel(String stock, String unit) {
    return 'Mínimo: $stock $unit';
  }

  @override
  String get invEntryError => 'Error al registrar entrada de inventario';

  @override
  String get invExitError => 'Error al registrar salida de inventario';

  @override
  String get feedLoadingItems => 'Cargando alimentos...';

  @override
  String get feedLoadError => 'Error al cargar alimentos';

  @override
  String get photoNoPhotosAdded => 'No hay fotos agregadas';

  @override
  String get photoMax5Hint => 'Puedes agregar hasta 5 fotos';

  @override
  String get farmPoultryFarm => 'Granja Avícola';

  @override
  String get farmNoAddress => 'Sin dirección';

  @override
  String get shedAddTagHint => 'Agregar etiqueta';

  @override
  String get shedCapacityHintExample => 'Ej: 1000';

  @override
  String get prodObsHint =>
      'Describe calidad de los huevos, color de cáscara, condiciones ambientales, comportamiento de las aves, etc.';

  @override
  String get commonAge => 'Edad';

  @override
  String get batchQuantityValidation => 'Ingrese una cantidad válida mayor a 0';

  @override
  String invStockBajoMinimo(String min, String unit) {
    return 'Stock bajo (mínimo: $min $unit)';
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
    return '$dayStart al $dayEnd de $month $year';
  }

  @override
  String reportsPeriodSameYear(
    String dayStart,
    String monthStart,
    String dayEnd,
    String monthEnd,
    String year,
  ) {
    return '$dayStart de $monthStart al $dayEnd de $monthEnd, $year';
  }

  @override
  String reportsPeriodDateRange(String start, String end) {
    return '$start al $end';
  }

  @override
  String get batchShareCode => 'Código';

  @override
  String get batchShareType => 'Tipo';

  @override
  String get batchShareBreed => 'Raza';

  @override
  String get batchShareStatus => 'Estado';

  @override
  String get batchShareBirds => 'Aves';

  @override
  String get batchShareEntry => 'Ingreso';

  @override
  String get batchShareAge => 'Edad';

  @override
  String get batchShareWeight => 'Peso';

  @override
  String get batchShareMortality => 'Mortalidad';

  @override
  String batchShareBirdsFormat(String current, String total) {
    return '$current de $total';
  }

  @override
  String get enumTipoAlimentoPreIniciador => 'Pre-iniciador';

  @override
  String get enumTipoAlimentoIniciador => 'Iniciador';

  @override
  String get enumTipoAlimentoCrecimiento => 'Crecimiento';

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
  String get enumTipoAlimentoOtro => 'Otro';

  @override
  String get enumTipoAlimentoDescPreIniciador => 'Pre-iniciador (0-7 días)';

  @override
  String get enumTipoAlimentoDescIniciador => 'Iniciador (8-21 días)';

  @override
  String get enumTipoAlimentoDescCrecimiento => 'Crecimiento (22-35 días)';

  @override
  String get enumTipoAlimentoDescFinalizador => 'Finalizador (36+ días)';

  @override
  String get enumTipoAlimentoRangoPreIniciador => '0-7 días';

  @override
  String get enumTipoAlimentoRangoIniciador => '8-21 días';

  @override
  String get enumTipoAlimentoRangoCrecimiento => '22-35 días';

  @override
  String get enumTipoAlimentoRangoFinalizador => '36+ días';

  @override
  String get enumTipoAlimentoRangoPostura => 'Gallinas ponedoras';

  @override
  String get enumTipoAlimentoRangoLevante => 'Pollitas reemplazo';

  @override
  String get enumMetodoPesajeManual => 'Manual';

  @override
  String get enumMetodoPesajeBasculaIndividual => 'Báscula Individual';

  @override
  String get enumMetodoPesajeBasculaLote => 'Báscula de Lote';

  @override
  String get enumMetodoPesajeAutomatica => 'Automática';

  @override
  String get enumMetodoPesajeDescManual => 'Manual con báscula';

  @override
  String get enumMetodoPesajeDescBasculaIndividual => 'Báscula individual';

  @override
  String get enumMetodoPesajeDescBasculaLote => 'Báscula de lote';

  @override
  String get enumMetodoPesajeDescAutomatica => 'Sistema automático';

  @override
  String get enumMetodoPesajeDetalleManual =>
      'Pesaje ave por ave con báscula portátil';

  @override
  String get enumMetodoPesajeDetalleBasculaIndividual =>
      'Báscula electrónica para una ave';

  @override
  String get enumMetodoPesajeDetalleBasculaLote =>
      'Pesaje grupal dividido entre cantidad';

  @override
  String get enumMetodoPesajeDetalleAutomatica =>
      'Sistema automatizado integrado';

  @override
  String get enumCausaMortEnfermedad => 'Enfermedad';

  @override
  String get enumCausaMortAccidente => 'Accidente';

  @override
  String get enumCausaMortDesnutricion => 'Desnutrición';

  @override
  String get enumCausaMortEstres => 'Estrés';

  @override
  String get enumCausaMortMetabolica => 'Metabólica';

  @override
  String get enumCausaMortDepredacion => 'Depredación';

  @override
  String get enumCausaMortSacrificio => 'Sacrificio';

  @override
  String get enumCausaMortVejez => 'Vejez';

  @override
  String get enumCausaMortDesconocida => 'Desconocida';

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
  String get enumCausaMortDescDepredacion => 'Ataques de animales';

  @override
  String get enumCausaMortDescSacrificio => 'Muerte en faena';

  @override
  String get enumCausaMortDescVejez => 'Fin de vida productiva';

  @override
  String get enumCausaMortDescDesconocida => 'Causa no identificada';

  @override
  String get enumTipoAlimentoRangoMedicado => 'Con tratamiento';

  @override
  String get enumTipoAlimentoRangoConcentrado => 'Suplemento';

  @override
  String get enumTipoAlimentoRangoOtro => 'Uso general';

  @override
  String get enumTipoAlimentoDescPostura => 'Postura';

  @override
  String get enumTipoAlimentoDescLevante => 'Levante';

  @override
  String get enumTipoAlimentoDescMedicado => 'Medicado';

  @override
  String get enumTipoAlimentoDescConcentrado => 'Concentrado';

  @override
  String get enumTipoAlimentoDescOtro => 'Otro';

  @override
  String errorSavingGeneric(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String errorDeletingGeneric(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get errorUserNotAuthenticated => 'Usuario no autenticado';

  @override
  String get errorGeneric => 'Error';

  @override
  String get enumTipoAvePolloEngorde => 'Pollo de Engorde';

  @override
  String get enumTipoAveGallinaPonedora => 'Gallina Ponedora';

  @override
  String get enumTipoAveReproductoraPesada => 'Reproductora Pesada';

  @override
  String get enumTipoAveReproductoraLiviana => 'Reproductora Liviana';

  @override
  String get enumTipoAvePavo => 'Pavo';

  @override
  String get enumTipoAveCodorniz => 'Codorniz';

  @override
  String get enumTipoAvePato => 'Pato';

  @override
  String get enumTipoAveOtro => 'Otro';

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
  String get enumTipoAveShortOtro => 'Otro';

  @override
  String get enumEstadoLoteActivo => 'Activo';

  @override
  String get enumEstadoLoteCerrado => 'Cerrado';

  @override
  String get enumEstadoLoteCuarentena => 'Cuarentena';

  @override
  String get enumEstadoLoteVendido => 'Vendido';

  @override
  String get enumEstadoLoteEnTransferencia => 'En Transferencia';

  @override
  String get enumEstadoLoteSuspendido => 'Suspendido';

  @override
  String get enumEstadoLoteDescActivo => 'Lote en producción normal';

  @override
  String get enumEstadoLoteDescCerrado => 'Lote finalizado';

  @override
  String get enumEstadoLoteDescCuarentena =>
      'Lote aislado por motivos sanitarios';

  @override
  String get enumEstadoLoteDescVendido => 'Lote vendido completamente';

  @override
  String get enumEstadoLoteDescEnTransferencia => 'Lote siendo transferido';

  @override
  String get enumEstadoLoteDescSuspendido => 'Lote temporalmente suspendido';

  @override
  String get enumEstadoGalponActivo => 'Activo';

  @override
  String get enumEstadoGalponMantenimiento => 'Mantenimiento';

  @override
  String get enumEstadoGalponInactivo => 'Inactivo';

  @override
  String get enumEstadoGalponDesinfeccion => 'Desinfección';

  @override
  String get enumEstadoGalponCuarentena => 'Cuarentena';

  @override
  String get enumEstadoGalponDescActivo => 'Galpón operativo';

  @override
  String get enumEstadoGalponDescMantenimiento => 'Galpón en reparación';

  @override
  String get enumEstadoGalponDescInactivo => 'Galpón sin uso';

  @override
  String get enumEstadoGalponDescDesinfeccion => 'Galpón en proceso sanitario';

  @override
  String get enumEstadoGalponDescCuarentena => 'Galpón aislado por sanidad';

  @override
  String get enumTipoGalponEngorde => 'Engorde';

  @override
  String get enumTipoGalponPostura => 'Postura';

  @override
  String get enumTipoGalponReproductora => 'Reproductora';

  @override
  String get enumTipoGalponMixto => 'Mixto';

  @override
  String get enumTipoGalponDescEngorde => 'Galpón para producción de carne';

  @override
  String get enumTipoGalponDescPostura => 'Galpón para producción de huevos';

  @override
  String get enumTipoGalponDescReproductora =>
      'Galpón para producción de huevos fértiles';

  @override
  String get enumTipoGalponDescMixto =>
      'Galpón multiuso para diferentes tipos de producción';

  @override
  String get enumRolGranjaOwner => 'Propietario';

  @override
  String get enumRolGranjaAdmin => 'Administrador';

  @override
  String get enumRolGranjaManager => 'Gestor';

  @override
  String get enumRolGranjaOperator => 'Operario';

  @override
  String get enumRolGranjaViewer => 'Visualizador';

  @override
  String get enumRolGranjaDescOwner =>
      'Control total, puede eliminar la granja';

  @override
  String get enumRolGranjaDescAdmin => 'Control total excepto eliminar';

  @override
  String get enumRolGranjaDescManager => 'Gestión de registros e invitaciones';

  @override
  String get enumRolGranjaDescOperator => 'Solo puede crear registros';

  @override
  String get enumRolGranjaDescViewer => 'Solo lectura';

  @override
  String get savedMomentAgo => 'Guardado hace un momento';

  @override
  String savedMinutesAgo(int minutes) {
    return 'Guardado hace $minutes min';
  }

  @override
  String savedAtTime(String time) {
    return 'Guardado a las $time';
  }

  @override
  String get pleaseSelectFarmAndBatch =>
      'Por favor selecciona una granja y un lote';

  @override
  String get pleaseSelectExpenseType => 'Por favor selecciona un tipo de gasto';

  @override
  String get noPermissionEditCosts =>
      'No tienes permiso para editar costos en esta granja';

  @override
  String get noPermissionCreateCosts =>
      'No tienes permiso para registrar costos en esta granja';

  @override
  String get errorSelectFarm => 'Por favor selecciona una granja';

  @override
  String errorClosingTreatment(String error) {
    return 'Error al cerrar tratamiento: $error';
  }

  @override
  String get couldNotLoadBiosecurity => 'No se pudo cargar bioseguridad';

  @override
  String purchaseOf(String name) {
    return 'Compra de $name';
  }

  @override
  String draftFoundMessage(String date) {
    return 'Se encontró un borrador guardado del $date.\n¿Deseas restaurarlo?';
  }

  @override
  String insufficientStock(String available) {
    return 'Stock insuficiente. Disponible: $available kg';
  }

  @override
  String get maxWeightIs => 'El peso máximo es 50,000 kg';

  @override
  String get fieldRequired => 'Este campo es obligatorio';

  @override
  String closedOnDate(String date) {
    return 'Cerrado el $date';
  }

  @override
  String inventoryOfType(String type) {
    return 'de tipo $type';
  }

  @override
  String get enumTipoRegistroPeso => 'Peso';

  @override
  String get enumTipoRegistroConsumo => 'Consumo';

  @override
  String get enumTipoRegistroMortalidad => 'Mortalidad';

  @override
  String get enumTipoRegistroProduccion => 'Producción';

  @override
  String get semanticsStatusOpen => 'abierto';

  @override
  String get semanticsStatusClosed => 'cerrado';

  @override
  String get semanticsDirectionEntry => 'entrada';

  @override
  String get semanticsDirectionExit => 'salida';

  @override
  String get semanticsUnits => 'unidades';

  @override
  String semanticsHealthRecord(String diagnosis, String date, String status) {
    return 'Registro de salud, $diagnosis, $date, $status';
  }

  @override
  String semanticsVaccination(String name, String date, String status) {
    return 'Vacunación $name, $date, estado $status';
  }

  @override
  String semanticsSale(String type, String date, String status) {
    return 'Venta de $type, $date, estado $status';
  }

  @override
  String semanticsCost(String concept, String type, String date) {
    return 'Costo $concept, tipo $type, $date';
  }

  @override
  String semanticsInventoryMovement(
    String type,
    String direction,
    String quantity,
    String units,
  ) {
    return 'Movimiento $type, $direction de $quantity $units';
  }

  @override
  String semanticsInventoryItem(
    String name,
    String type,
    String stock,
    String unit,
    String status,
  ) {
    return 'Item $name, $type, $stock $unit, estado $status';
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
    return '📅 Fecha: $value';
  }

  @override
  String shareTypeLine(String value) {
    return '🏷️ Tipo: $value';
  }

  @override
  String shareQuantityBirdsLine(String count) {
    return '🐔 Cantidad: $count aves';
  }

  @override
  String sharePricePerKgLine(String currency, String price) {
    return '💰 Precio: $currency $price/kg';
  }

  @override
  String shareEggsLine(String count) {
    return '🥚 Huevos: $count unidades';
  }

  @override
  String shareQuantityLine(String count, String unit) {
    return '📝 Cantidad: $count $unit';
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
    return '📊 Estado: $value';
  }

  @override
  String shareSubjectSale(String type) {
    return 'Venta - $type';
  }

  @override
  String get bultosFallback => 'bultos';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String birdCountWithPercent(String count, String percent) {
    return '$count aves ($percent%)';
  }

  @override
  String eggCountUnits(String count) {
    return '$count unidades';
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
    return 'Stock: $value $unit';
  }

  @override
  String inventoryExpiresLabel(String date) {
    return 'Vence: $date';
  }

  @override
  String inventoryPriceLabel(String price, String unit) {
    return 'Precio: $price/$unit';
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
  String get reportFilePrefix => 'Reporte';

  @override
  String get errorOccurredDefault => 'Ha ocurrido un error';

  @override
  String get errorUnknown => 'Error desconocido';

  @override
  String get unitsFallback => 'unidades';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get guiasManejoTitle => 'Guías de Manejo';

  @override
  String get guiasManejoSubtitle =>
      'Recomendaciones técnicas según manuales oficiales';

  @override
  String get guiasManejoBotonLabel => 'Ver guías de manejo';

  @override
  String get guiaLuzTitle => 'Luz';

  @override
  String get guiaAlimentacionTitle => 'Alimentación';

  @override
  String get guiaPesoTitle => 'Peso';

  @override
  String get guiaAguaTitle => 'Agua';

  @override
  String get guiaSemanaCol => 'Sem';

  @override
  String get guiaHorasLuzCol => 'Horas luz';

  @override
  String get guiaPesoObjetivoCol => 'Peso objetivo';

  @override
  String get guiaTipoCol => 'Tipo';

  @override
  String get guiaTotalLote => 'total lote';

  @override
  String get guiaAveAbrev => 'ave';

  @override
  String get guiaDiaAbrev => 'día';

  @override
  String guiaSemanaActualLabel(int semana) {
    return 'Semana $semana (actual)';
  }

  @override
  String get guiaLuzSubtitle => 'Horas de luz recomendadas por día';

  @override
  String guiaAlimentacionSubtitle(String kgDia, int aves) {
    return 'Total lote: $kgDia kg/día para $aves aves';
  }

  @override
  String guiaAguaSubtitle(String litrosDia, int aves) {
    return 'Total lote: $litrosDia L/día para $aves aves';
  }

  @override
  String guiaPesoComparacion(String actual, String objetivo) {
    return 'Peso actual: ${actual}g — Objetivo: ${objetivo}g';
  }

  @override
  String get guiaPesoSinDatos => 'Sin datos de peso actual registrados';

  @override
  String get guiaTipoAlimentoRecomendado => 'Alimento recomendado';

  @override
  String get guiaFuenteManual => 'Fuente';

  @override
  String get guiaTemperaturaTitle => 'Temperatura';

  @override
  String get guiaHumedadTitle => 'Humedad';

  @override
  String get guiaTemperaturaSubtitle => 'Temperatura ambiental recomendada';

  @override
  String get guiaHumedadSubtitle => 'Humedad relativa recomendada';

  @override
  String get guiaTemperaturaCol => 'Temp (°C)';

  @override
  String get guiaHumedadCol => 'Humedad (%)';

  @override
  String get vetVirtualTitle => 'Veterinario Virtual';

  @override
  String get vetVirtualSubtitle => 'Asistente avícola con IA';

  @override
  String vetVirtualContextoLote(String codigo, String tipoAve) {
    return 'Usando contexto del lote $codigo ($tipoAve)';
  }

  @override
  String get vetVirtualSinContexto => 'Consulta general sin lote seleccionado';

  @override
  String get vetVirtualEligeConsulta => '¿Qué necesitas consultar?';

  @override
  String get vetVirtualDisclaimer =>
      'Este asistente usa inteligencia artificial como apoyo. No reemplaza el diagnóstico de un veterinario profesional. Consulta presencialmente ante emergencias.';

  @override
  String get vetDiagnosticoTitle => 'Diagnóstico';

  @override
  String get vetDiagnosticoDesc =>
      'Describe síntomas y obtén posibles diagnósticos';

  @override
  String get vetMortalidadTitle => 'Mortalidad';

  @override
  String get vetMortalidadDesc =>
      'Analiza tasas de mortalidad y posibles causas';

  @override
  String get vetVacunacionTitle => 'Vacunación';

  @override
  String get vetVacunacionDesc =>
      'Plan de vacunación según tipo y edad del ave';

  @override
  String get vetNutricionTitle => 'Nutrición';

  @override
  String get vetNutricionDesc =>
      'Evalúa alimentación, peso y conversión alimenticia';

  @override
  String get vetAmbienteTitle => 'Ambiente';

  @override
  String get vetAmbienteDesc => 'Temperatura, humedad y condiciones del galpón';

  @override
  String get vetBioseguridadTitle => 'Bioseguridad';

  @override
  String get vetBioseguridadDesc => 'Protocolos de prevención y desinfección';

  @override
  String get vetGeneralTitle => 'Consulta General';

  @override
  String get vetGeneralDesc => 'Pregunta lo que necesites sobre avicultura';

  @override
  String get vetChatHint => 'Escribe tu consulta...';

  @override
  String get vetChatError => 'No se pudo obtener respuesta. Intenta de nuevo.';

  @override
  String get vetChatRetry => 'Reintentar';

  @override
  String get vetVirtualBotonLabel => 'Veterinario Virtual IA';

  @override
  String get vetIaLabel => 'Veterinario IA';

  @override
  String get vetTextoCopied => 'Texto copiado';

  @override
  String get vetAnalizando => 'Analizando...';

  @override
  String get vetAttachImage => 'Adjuntar imagen';

  @override
  String get vetFromCamera => 'Tomar foto';

  @override
  String get vetFromGallery => 'Elegir de galería';

  @override
  String get vetImageAttach => 'Adjuntar imagen';

  @override
  String get vetImageSelectSource => 'Selecciona de dónde obtener la imagen';

  @override
  String get vetStatusProcessing => 'Procesando tu consulta...';

  @override
  String get vetStatusAnalyzingImage => 'Analizando imagen...';

  @override
  String get vetStatusGenerating => 'Generando respuesta...';

  @override
  String get vetVoiceListening => 'Escuchando...';

  @override
  String get vetVoiceNotAvailable =>
      'El reconocimiento de voz no está disponible';

  @override
  String get vetVoiceStart => 'Iniciar dictado';

  @override
  String get vetVoiceStop => 'Detener dictado';

  @override
  String get vetAnalyzeImage => 'Analiza esta imagen';

  @override
  String get legalLastUpdated => 'Última actualización: Abril 2026';

  @override
  String get legalPrivacy1Title => '1. Información que recopilamos';

  @override
  String get legalPrivacy1Body =>
      'Recopilamos la información que usted proporciona directamente: nombre, correo electrónico, datos de sus granjas (nombre, ubicación, galpones, lotes), registros productivos (peso, mortalidad, producción, consumo), imágenes de aves y galpones, y datos de salud animal. También recopilamos automáticamente datos de uso de la app y tokens de notificaciones push.';

  @override
  String get legalPrivacy2Title => '2. Cómo usamos su información';

  @override
  String get legalPrivacy2Body =>
      'Usamos sus datos para: operar y mantener la aplicación, generar reportes y análisis productivos, ofrecer recomendaciones de manejo a través del veterinario virtual IA, enviar notificaciones sobre alertas sanitarias y recordatorios, y mejorar nuestros servicios. No vendemos ni compartimos sus datos con terceros para fines publicitarios.';

  @override
  String get legalPrivacy3Title => '3. Almacenamiento y seguridad';

  @override
  String get legalPrivacy3Body =>
      'Sus datos se almacenan de forma segura en servidores de Firebase (Google Cloud Platform) con cifrado en tránsito y en reposo. Implementamos medidas de seguridad técnicas y organizativas para proteger su información contra acceso no autorizado, alteración o destrucción.';

  @override
  String get legalPrivacy4Title => '4. Compartir datos';

  @override
  String get legalPrivacy4Body =>
      'Solo compartimos sus datos de granja con los colaboradores que usted invite explícitamente. Las consultas al veterinario virtual IA se procesan a través de Google Gemini; estas consultas no contienen información personal identificable más allá del contexto de la granja necesario para la respuesta.';

  @override
  String get legalPrivacy5Title => '5. Sus derechos';

  @override
  String get legalPrivacy5Body =>
      'Usted tiene derecho a: acceder a sus datos personales, corregir información inexacta, solicitar la eliminación de su cuenta y datos, exportar sus datos en formatos estándar, y retirar su consentimiento en cualquier momento.';

  @override
  String get legalPrivacy6Title => '6. Retención de datos';

  @override
  String get legalPrivacy6Body =>
      'Conservamos sus datos mientras su cuenta esté activa. Si solicita la eliminación de su cuenta, eliminaremos sus datos personales en un plazo de 30 días, excepto cuando la ley requiera su conservación por un período mayor.';

  @override
  String get legalPrivacy7Title => '7. Contacto';

  @override
  String get legalPrivacy7Body =>
      'Para consultas sobre privacidad, puede contactarnos a través de la sección de ayuda dentro de la aplicación o enviando un correo a soporte@smartgranjaaves.com.';

  @override
  String get legalTerms1Title => '1. Aceptación de los términos';

  @override
  String get legalTerms1Body =>
      'Al utilizar Smart Granja Aves Pro, usted acepta estos términos y condiciones. Si no está de acuerdo, por favor no utilice la aplicación.';

  @override
  String get legalTerms2Title => '2. Uso de la aplicación';

  @override
  String get legalTerms2Body =>
      'La aplicación está diseñada como herramienta de gestión avícola y apoyo a la toma de decisiones. Las recomendaciones del veterinario virtual IA son orientativas y NO sustituyen la consulta con un médico veterinario presencial. El usuario es responsable de las decisiones que tome basándose en la información proporcionada.';

  @override
  String get legalTerms3Title => '3. Cuenta de usuario';

  @override
  String get legalTerms3Body =>
      'Usted es responsable de mantener la confidencialidad de su cuenta y contraseña. Debe notificarnos inmediatamente sobre cualquier uso no autorizado de su cuenta.';

  @override
  String get legalTerms4Title => '4. Propiedad intelectual';

  @override
  String get legalTerms4Body =>
      'Los datos que usted ingresa en la aplicación son de su propiedad. Smart Granja Aves Pro retiene los derechos sobre el software, diseño, algoritmos y contenido propio de la aplicación.';

  @override
  String get legalTerms5Title => '5. Limitación de responsabilidad';

  @override
  String get legalTerms5Body =>
      'La aplicación se proporciona \"tal cual\". No garantizamos que las recomendaciones del veterinario virtual sean infalibles. No somos responsables por pérdidas derivadas del uso de la información proporcionada. En caso de emergencia sanitaria, siempre consulte a un veterinario presencial.';

  @override
  String get legalTerms6Title => '6. Modificaciones';

  @override
  String get legalTerms6Body =>
      'Nos reservamos el derecho de modificar estos términos en cualquier momento. Le notificaremos sobre cambios significativos a través de la aplicación. El uso continuado después de los cambios constituye su aceptación de los nuevos términos.';
}
