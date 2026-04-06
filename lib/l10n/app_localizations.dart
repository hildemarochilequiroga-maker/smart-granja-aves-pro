import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Smart Granja Aves Pro'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navManagement.
  ///
  /// In es, this message translates to:
  /// **'Gestión'**
  String get navManagement;

  /// No description provided for @navBatches.
  ///
  /// In es, this message translates to:
  /// **'Lotes'**
  String get navBatches;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @commonCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonHintExample.
  ///
  /// In es, this message translates to:
  /// **'Ej: {value}'**
  String commonHintExample(String value);

  /// No description provided for @commonDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get commonDelete;

  /// No description provided for @commonContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get commonContinue;

  /// No description provided for @commonConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get commonConfirm;

  /// No description provided for @commonAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get commonAccept;

  /// No description provided for @commonSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get commonSearch;

  /// No description provided for @commonGoHome.
  ///
  /// In es, this message translates to:
  /// **'Ir al inicio'**
  String get commonGoHome;

  /// No description provided for @commonLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get commonLoading;

  /// No description provided for @commonApplyFilters.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get commonApplyFilters;

  /// No description provided for @commonClearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get commonClearFilters;

  /// No description provided for @commonClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get commonClear;

  /// No description provided for @commonNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados'**
  String get commonNoResults;

  /// No description provided for @commonNoResultsHint.
  ///
  /// In es, this message translates to:
  /// **'Prueba modificando los filtros de búsqueda'**
  String get commonNoResultsHint;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error'**
  String get commonErrorOccurred;

  /// No description provided for @commonYes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonOr.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get commonOr;

  /// No description provided for @connectivityOffline.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get connectivityOffline;

  /// No description provided for @connectivityOfflineShort.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get connectivityOfflineShort;

  /// No description provided for @connectivityOfflineBanner.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión - Los cambios se guardarán localmente'**
  String get connectivityOfflineBanner;

  /// No description provided for @connectivityOfflineMode.
  ///
  /// In es, this message translates to:
  /// **'Modo sin conexión'**
  String get connectivityOfflineMode;

  /// No description provided for @connectivityOfflineDataWarning.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión a internet. Los datos pueden no estar actualizados'**
  String get connectivityOfflineDataWarning;

  /// No description provided for @errorServer.
  ///
  /// In es, this message translates to:
  /// **'Error del servidor'**
  String get errorServer;

  /// No description provided for @errorCacheNotFound.
  ///
  /// In es, this message translates to:
  /// **'Datos no encontrados en cache'**
  String get errorCacheNotFound;

  /// No description provided for @errorNoConnection.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get errorNoConnection;

  /// No description provided for @errorTimeout.
  ///
  /// In es, this message translates to:
  /// **'Tiempo de espera agotado'**
  String get errorTimeout;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Credenciales inválidas'**
  String get errorInvalidCredentials;

  /// No description provided for @errorSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha expirado'**
  String get errorSessionExpired;

  /// No description provided for @errorNoPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para realizar esta acción'**
  String get errorNoPermission;

  /// No description provided for @errorWriteCache.
  ///
  /// In es, this message translates to:
  /// **'Error al escribir en cache'**
  String get errorWriteCache;

  /// No description provided for @errorNoSession.
  ///
  /// In es, this message translates to:
  /// **'No hay sesión activa'**
  String get errorNoSession;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico inválido'**
  String get errorInvalidEmail;

  /// No description provided for @errorReadFile.
  ///
  /// In es, this message translates to:
  /// **'Error al leer archivo'**
  String get errorReadFile;

  /// No description provided for @errorWriteFile.
  ///
  /// In es, this message translates to:
  /// **'Error al escribir archivo'**
  String get errorWriteFile;

  /// No description provided for @errorDeleteFile.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar archivo'**
  String get errorDeleteFile;

  /// No description provided for @errorVerifyPermissions.
  ///
  /// In es, this message translates to:
  /// **'Error al verificar permisos'**
  String get errorVerifyPermissions;

  /// No description provided for @errorLoadingActivities.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar actividades'**
  String get errorLoadingActivities;

  /// No description provided for @permNoCreateRecords.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para crear registros'**
  String get permNoCreateRecords;

  /// No description provided for @permNoEditRecords.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar registros'**
  String get permNoEditRecords;

  /// No description provided for @permNoDeleteRecords.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para eliminar registros'**
  String get permNoDeleteRecords;

  /// No description provided for @permNoCreateBatches.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para crear lotes'**
  String get permNoCreateBatches;

  /// No description provided for @permNoEditBatches.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar lotes'**
  String get permNoEditBatches;

  /// No description provided for @permNoDeleteBatches.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para eliminar lotes'**
  String get permNoDeleteBatches;

  /// No description provided for @permNoCreateSheds.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para crear galpones'**
  String get permNoCreateSheds;

  /// No description provided for @permNoEditSheds.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar galpones'**
  String get permNoEditSheds;

  /// No description provided for @permNoDeleteSheds.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para eliminar galpones'**
  String get permNoDeleteSheds;

  /// No description provided for @permNoInviteUsers.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para invitar usuarios'**
  String get permNoInviteUsers;

  /// No description provided for @permNoChangeRoles.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para cambiar roles'**
  String get permNoChangeRoles;

  /// No description provided for @permNoRemoveUsers.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para remover usuarios'**
  String get permNoRemoveUsers;

  /// No description provided for @permNoViewCollaborators.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para ver colaboradores'**
  String get permNoViewCollaborators;

  /// No description provided for @permNoEditFarm.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar la granja'**
  String get permNoEditFarm;

  /// No description provided for @permNoDeleteFarm.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para eliminar la granja'**
  String get permNoDeleteFarm;

  /// No description provided for @permNoViewReports.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para ver reportes'**
  String get permNoViewReports;

  /// No description provided for @permNoExportData.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para exportar datos'**
  String get permNoExportData;

  /// No description provided for @permNoManageInventory.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para gestionar inventario'**
  String get permNoManageInventory;

  /// No description provided for @permNoRegisterSales.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para registrar ventas'**
  String get permNoRegisterSales;

  /// No description provided for @permNoViewSettings.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para ver la configuración'**
  String get permNoViewSettings;

  /// No description provided for @authGateManageSmartly.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tu granja de forma inteligente'**
  String get authGateManageSmartly;

  /// No description provided for @authCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get authCreateAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo cuenta'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authOrContinueWith.
  ///
  /// In es, this message translates to:
  /// **'o continúa con'**
  String get authOrContinueWith;

  /// No description provided for @authWelcomeBack.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido de vuelta'**
  String get authWelcomeBack;

  /// No description provided for @authEnterCredentials.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tus credenciales para continuar'**
  String get authEnterCredentials;

  /// No description provided for @authOrSignInWithEmail.
  ///
  /// In es, this message translates to:
  /// **'o inicia sesión con email'**
  String get authOrSignInWithEmail;

  /// No description provided for @authEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get authEmail;

  /// No description provided for @authSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get authSignIn;

  /// No description provided for @authForgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Ha olvidado su contraseña?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get authNoAccount;

  /// No description provided for @authSignUp.
  ///
  /// In es, this message translates to:
  /// **'Regístrate'**
  String get authSignUp;

  /// No description provided for @authEmailRequired.
  ///
  /// In es, this message translates to:
  /// **'El correo electrónico es requerido'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo electrónico válido'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es requerida'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get authPasswordMinLength;

  /// No description provided for @authJoinToManage.
  ///
  /// In es, this message translates to:
  /// **'Únete para gestionar tu granja de forma inteligente'**
  String get authJoinToManage;

  /// No description provided for @authSignUpWithGoogle.
  ///
  /// In es, this message translates to:
  /// **'Registrarse con Google'**
  String get authSignUpWithGoogle;

  /// No description provided for @authOrSignUpWithEmail.
  ///
  /// In es, this message translates to:
  /// **'o regístrate con email'**
  String get authOrSignUpWithEmail;

  /// No description provided for @authFirstName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get authFirstName;

  /// No description provided for @authLastName.
  ///
  /// In es, this message translates to:
  /// **'Apellidos'**
  String get authLastName;

  /// No description provided for @authPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get authConfirmPassword;

  /// No description provided for @authMustAcceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar los términos y condiciones'**
  String get authMustAcceptTerms;

  /// No description provided for @authTermsAndConditions.
  ///
  /// In es, this message translates to:
  /// **'Términos y Condiciones'**
  String get authTermsAndConditions;

  /// No description provided for @authCheckEmail.
  ///
  /// In es, this message translates to:
  /// **'¡Revisa tu correo!'**
  String get authCheckEmail;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get authForgotPasswordTitle;

  /// No description provided for @authResetLinkSent.
  ///
  /// In es, this message translates to:
  /// **'Te hemos enviado un enlace para restablecer tu contraseña'**
  String get authResetLinkSent;

  /// No description provided for @authEnterEmailForReset.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo y te enviaremos instrucciones'**
  String get authEnterEmailForReset;

  /// No description provided for @authSendInstructions.
  ///
  /// In es, this message translates to:
  /// **'Enviar instrucciones'**
  String get authSendInstructions;

  /// No description provided for @authRememberPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Recordaste tu contraseña?'**
  String get authRememberPassword;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithFacebook.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Facebook'**
  String get authContinueWithFacebook;

  /// No description provided for @authContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get authContinue;

  /// No description provided for @authEnterPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu contraseña'**
  String get authEnterPassword;

  /// No description provided for @authCurrentPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actual'**
  String get authCurrentPassword;

  /// No description provided for @authSignOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get authSignOut;

  /// No description provided for @homeQuickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get homeQuickActions;

  /// No description provided for @homeVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get homeVaccination;

  /// No description provided for @homeDiseases.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades'**
  String get homeDiseases;

  /// No description provided for @homeBiosecurity.
  ///
  /// In es, this message translates to:
  /// **'Bioseguridad'**
  String get homeBiosecurity;

  /// No description provided for @homeSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get homeSales;

  /// No description provided for @homeCosts.
  ///
  /// In es, this message translates to:
  /// **'Costos'**
  String get homeCosts;

  /// No description provided for @homeInventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get homeInventory;

  /// No description provided for @homeSelectFarmFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja primero'**
  String get homeSelectFarmFirst;

  /// No description provided for @homeGeneralStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas Generales'**
  String get homeGeneralStats;

  /// No description provided for @homeAvailableSheds.
  ///
  /// In es, this message translates to:
  /// **'Galpones Libres'**
  String get homeAvailableSheds;

  /// No description provided for @homeActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'Lotes Activos'**
  String get homeActiveBatches;

  /// No description provided for @homeTotalBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Totales'**
  String get homeTotalBirds;

  /// No description provided for @homeOccupancy.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get homeOccupancy;

  /// No description provided for @homeNoSheds.
  ///
  /// In es, this message translates to:
  /// **'Sin galpones'**
  String get homeNoSheds;

  /// No description provided for @homeNoBatches.
  ///
  /// In es, this message translates to:
  /// **'Sin lotes'**
  String get homeNoBatches;

  /// No description provided for @homeAcrossFarm.
  ///
  /// In es, this message translates to:
  /// **'En toda la granja'**
  String get homeAcrossFarm;

  /// No description provided for @homeExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximos a vencer'**
  String get homeExpiringSoon;

  /// No description provided for @homeHighMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad elevada'**
  String get homeHighMortality;

  /// No description provided for @homeNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'Sin lotes activos'**
  String get homeNoActiveBatches;

  /// No description provided for @homeCreateBatchToStart.
  ///
  /// In es, this message translates to:
  /// **'Crea un lote para comenzar a registrar'**
  String get homeCreateBatchToStart;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In es, this message translates to:
  /// **'Buenos días'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches'**
  String get homeGreetingEvening;

  /// No description provided for @homeHello.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get homeHello;

  /// No description provided for @profileMyAccount.
  ///
  /// In es, this message translates to:
  /// **'Mi Cuenta'**
  String get profileMyAccount;

  /// No description provided for @profileUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get profileUser;

  /// No description provided for @profileCollaboration.
  ///
  /// In es, this message translates to:
  /// **'Colaboración'**
  String get profileCollaboration;

  /// No description provided for @profileInviteToFarm.
  ///
  /// In es, this message translates to:
  /// **'Invitar a mi Granja'**
  String get profileInviteToFarm;

  /// No description provided for @profileShareAccess.
  ///
  /// In es, this message translates to:
  /// **'Comparte acceso con otros usuarios'**
  String get profileShareAccess;

  /// No description provided for @profileAcceptInvitation.
  ///
  /// In es, this message translates to:
  /// **'Aceptar Invitación'**
  String get profileAcceptInvitation;

  /// No description provided for @profileJoinFarm.
  ///
  /// In es, this message translates to:
  /// **'Únete a la granja de alguien más'**
  String get profileJoinFarm;

  /// No description provided for @profileManageCollaborators.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Colaboradores'**
  String get profileManageCollaborators;

  /// No description provided for @profileViewManageAccess.
  ///
  /// In es, this message translates to:
  /// **'Ver y administrar accesos'**
  String get profileViewManageAccess;

  /// No description provided for @profileSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get profileSettings;

  /// No description provided for @profileNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get profileNotifications;

  /// No description provided for @profileConfigureAlerts.
  ///
  /// In es, this message translates to:
  /// **'Configura alertas y recordatorios'**
  String get profileConfigureAlerts;

  /// No description provided for @profileGeneralSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes Generales'**
  String get profileGeneralSettings;

  /// No description provided for @profileAppPreferences.
  ///
  /// In es, this message translates to:
  /// **'Preferencias de la aplicación'**
  String get profileAppPreferences;

  /// No description provided for @profileHelpSupport.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y Soporte'**
  String get profileHelpSupport;

  /// No description provided for @profileHelpCenter.
  ///
  /// In es, this message translates to:
  /// **'Centro de Ayuda'**
  String get profileHelpCenter;

  /// No description provided for @profileFaqGuides.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes y guías'**
  String get profileFaqGuides;

  /// No description provided for @profileSendFeedback.
  ///
  /// In es, this message translates to:
  /// **'Enviar Sugerencia'**
  String get profileSendFeedback;

  /// No description provided for @profileShareIdeas.
  ///
  /// In es, this message translates to:
  /// **'Comparte tus ideas con nosotros'**
  String get profileShareIdeas;

  /// No description provided for @profileAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get profileAbout;

  /// No description provided for @profileAppInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de la aplicación'**
  String get profileAppInfo;

  /// No description provided for @profileSelectFarmToInvite.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la granja donde invitar'**
  String get profileSelectFarmToInvite;

  /// No description provided for @profileSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get profileSelectFarm;

  /// No description provided for @profileLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get profileLanguage;

  /// No description provided for @profileLanguageSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cambia el idioma de la aplicación'**
  String get profileLanguageSubtitle;

  /// No description provided for @profileCurrency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get profileCurrency;

  /// No description provided for @profileCurrencySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la moneda de tu país'**
  String get profileCurrencySubtitle;

  /// No description provided for @salesNoSales.
  ///
  /// In es, this message translates to:
  /// **'Sin ventas registradas'**
  String get salesNoSales;

  /// No description provided for @salesNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron ventas'**
  String get salesNotFound;

  /// No description provided for @salesRegisterFirst.
  ///
  /// In es, this message translates to:
  /// **'Registrar primera venta'**
  String get salesRegisterFirst;

  /// No description provided for @salesRegisterNew.
  ///
  /// In es, this message translates to:
  /// **'Registrar nueva venta'**
  String get salesRegisterNew;

  /// No description provided for @salesDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar venta?'**
  String get salesDeleteConfirm;

  /// No description provided for @salesProductType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de producto'**
  String get salesProductType;

  /// No description provided for @salesStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de venta'**
  String get salesStatus;

  /// No description provided for @salesNewSale.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get salesNewSale;

  /// No description provided for @salesEditSale.
  ///
  /// In es, this message translates to:
  /// **'Editar Venta'**
  String get salesEditSale;

  /// No description provided for @farmFarm.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get farmFarm;

  /// No description provided for @farmFarms.
  ///
  /// In es, this message translates to:
  /// **'Granjas'**
  String get farmFarms;

  /// No description provided for @farmNewFarm.
  ///
  /// In es, this message translates to:
  /// **'Nueva Granja'**
  String get farmNewFarm;

  /// No description provided for @farmEditFarm.
  ///
  /// In es, this message translates to:
  /// **'Editar Granja'**
  String get farmEditFarm;

  /// No description provided for @farmDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar granja?'**
  String get farmDeleteConfirm;

  /// No description provided for @shedShed.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get shedShed;

  /// No description provided for @shedSheds.
  ///
  /// In es, this message translates to:
  /// **'Galpones'**
  String get shedSheds;

  /// No description provided for @shedNewShed.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Galpón'**
  String get shedNewShed;

  /// No description provided for @shedEditShed.
  ///
  /// In es, this message translates to:
  /// **'Editar Galpón'**
  String get shedEditShed;

  /// No description provided for @shedDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar galpón?'**
  String get shedDeleteConfirm;

  /// No description provided for @batchBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote'**
  String get batchBatch;

  /// No description provided for @batchBatches.
  ///
  /// In es, this message translates to:
  /// **'Lotes'**
  String get batchBatches;

  /// No description provided for @batchNewBatch.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Lote'**
  String get batchNewBatch;

  /// No description provided for @batchEditBatch.
  ///
  /// In es, this message translates to:
  /// **'Editar Lote'**
  String get batchEditBatch;

  /// No description provided for @batchDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar lote?'**
  String get batchDeleteConfirm;

  /// No description provided for @batchActive.
  ///
  /// In es, this message translates to:
  /// **'Activos'**
  String get batchActive;

  /// No description provided for @batchFinished.
  ///
  /// In es, this message translates to:
  /// **'Finalizado'**
  String get batchFinished;

  /// No description provided for @healthDiseases.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades'**
  String get healthDiseases;

  /// No description provided for @healthSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas'**
  String get healthSymptoms;

  /// No description provided for @healthTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get healthTreatment;

  /// No description provided for @healthPrevention.
  ///
  /// In es, this message translates to:
  /// **'Prevención'**
  String get healthPrevention;

  /// No description provided for @healthVaccineAvailable.
  ///
  /// In es, this message translates to:
  /// **'Vacuna disponible'**
  String get healthVaccineAvailable;

  /// No description provided for @healthMandatoryNotification.
  ///
  /// In es, this message translates to:
  /// **'Notificación obligatoria'**
  String get healthMandatoryNotification;

  /// No description provided for @healthPreventableByVaccine.
  ///
  /// In es, this message translates to:
  /// **'Prevenible por vacunación'**
  String get healthPreventableByVaccine;

  /// No description provided for @inventoryInventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventoryInventory;

  /// No description provided for @inventoryMedicines.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get inventoryMedicines;

  /// No description provided for @inventoryVaccines.
  ///
  /// In es, this message translates to:
  /// **'Vacunas'**
  String get inventoryVaccines;

  /// No description provided for @inventoryFood.
  ///
  /// In es, this message translates to:
  /// **'Alimentos'**
  String get inventoryFood;

  /// No description provided for @costsTitle.
  ///
  /// In es, this message translates to:
  /// **'Costos'**
  String get costsTitle;

  /// No description provided for @costsNewCost.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Costo'**
  String get costsNewCost;

  /// No description provided for @costsEditCost.
  ///
  /// In es, this message translates to:
  /// **'Editar Costo'**
  String get costsEditCost;

  /// No description provided for @reportsTitle.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reportsTitle;

  /// No description provided for @reportsGenerate.
  ///
  /// In es, this message translates to:
  /// **'Generar reporte'**
  String get reportsGenerate;

  /// No description provided for @reportsGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando reporte...'**
  String get reportsGenerating;

  /// No description provided for @reportsSharePdf.
  ///
  /// In es, this message translates to:
  /// **'Compartir PDF'**
  String get reportsSharePdf;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Sin notificaciones'**
  String get notificationsEmpty;

  /// No description provided for @mortalityTitle.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get mortalityTitle;

  /// No description provided for @mortalityRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar mortalidad'**
  String get mortalityRegister;

  /// No description provided for @mortalityRate.
  ///
  /// In es, this message translates to:
  /// **'Tasa de mortalidad'**
  String get mortalityRate;

  /// No description provided for @mortalityTotal.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad total'**
  String get mortalityTotal;

  /// No description provided for @weightTitle.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get weightTitle;

  /// No description provided for @weightRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar peso'**
  String get weightRegister;

  /// No description provided for @weightAverage.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get weightAverage;

  /// No description provided for @feedTitle.
  ///
  /// In es, this message translates to:
  /// **'Alimentación'**
  String get feedTitle;

  /// No description provided for @feedRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar alimentación'**
  String get feedRegister;

  /// No description provided for @feedDailyConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo diario'**
  String get feedDailyConsumption;

  /// No description provided for @waterTitle.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get waterTitle;

  /// No description provided for @waterRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar agua'**
  String get waterRegister;

  /// No description provided for @waterDailyConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo diario'**
  String get waterDailyConsumption;

  /// No description provided for @commonBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get commonBack;

  /// No description provided for @commonDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get commonDetails;

  /// No description provided for @commonFilter.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get commonFilter;

  /// No description provided for @commonMoreOptions.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get commonMoreOptions;

  /// No description provided for @commonClearSearch.
  ///
  /// In es, this message translates to:
  /// **'Limpiar búsqueda'**
  String get commonClearSearch;

  /// No description provided for @commonAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get commonAll;

  /// No description provided for @commonAllTypes.
  ///
  /// In es, this message translates to:
  /// **'Todos los tipos'**
  String get commonAllTypes;

  /// No description provided for @commonAllStatuses.
  ///
  /// In es, this message translates to:
  /// **'Todos los estados'**
  String get commonAllStatuses;

  /// No description provided for @commonDiscard.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get commonDiscard;

  /// No description provided for @commonComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get commonComingSoon;

  /// No description provided for @commonUnsavedChanges.
  ///
  /// In es, this message translates to:
  /// **'Cambios sin guardar'**
  String get commonUnsavedChanges;

  /// No description provided for @commonExitWithoutSave.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas salir sin guardar los cambios?'**
  String get commonExitWithoutSave;

  /// No description provided for @commonExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get commonExit;

  /// No description provided for @commonDontWorryDataSafe.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros.'**
  String get commonDontWorryDataSafe;

  /// No description provided for @commonObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get commonObservations;

  /// No description provided for @commonDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get commonDescription;

  /// No description provided for @commonDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get commonDate;

  /// No description provided for @commonName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get commonName;

  /// No description provided for @commonPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get commonPhone;

  /// No description provided for @commonProvider.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get commonProvider;

  /// No description provided for @commonLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get commonLocation;

  /// No description provided for @commonActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get commonInactive;

  /// No description provided for @commonPending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get commonPending;

  /// No description provided for @commonApproved.
  ///
  /// In es, this message translates to:
  /// **'Aprobados'**
  String get commonApproved;

  /// No description provided for @commonTotal.
  ///
  /// In es, this message translates to:
  /// **'Total:'**
  String get commonTotal;

  /// No description provided for @commonInformation.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get commonInformation;

  /// No description provided for @commonSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get commonSummary;

  /// No description provided for @commonBasicInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get commonBasicInfo;

  /// No description provided for @commonAdditionalInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Adicional'**
  String get commonAdditionalInfo;

  /// No description provided for @commonNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontrado'**
  String get commonNotFound;

  /// No description provided for @commonError.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonErrorWithMessage.
  ///
  /// In es, this message translates to:
  /// **'Error: {message}'**
  String commonErrorWithMessage(String message);

  /// No description provided for @profileLoadingFarms.
  ///
  /// In es, this message translates to:
  /// **'Cargando granjas...'**
  String get profileLoadingFarms;

  /// No description provided for @commonSuccess.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get commonSuccess;

  /// No description provided for @commonRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get commonRegisteredBy;

  /// No description provided for @commonRole.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get commonRole;

  /// No description provided for @commonRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get commonRegistrationDate;

  /// No description provided for @authEmailHint.
  ///
  /// In es, this message translates to:
  /// **'ejemplo@correo.com'**
  String get authEmailHint;

  /// No description provided for @authFirstNameHint.
  ///
  /// In es, this message translates to:
  /// **'Juan'**
  String get authFirstNameHint;

  /// No description provided for @authLastNameHint.
  ///
  /// In es, this message translates to:
  /// **'Pérez García'**
  String get authLastNameHint;

  /// No description provided for @authRememberEmail.
  ///
  /// In es, this message translates to:
  /// **'Recordar email'**
  String get authRememberEmail;

  /// No description provided for @authAlreadyHaveAccountLink.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get authAlreadyHaveAccountLink;

  /// No description provided for @authSignInLink.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get authSignInLink;

  /// No description provided for @authAcceptTermsPrefix.
  ///
  /// In es, this message translates to:
  /// **'Acepto los '**
  String get authAcceptTermsPrefix;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de Privacidad'**
  String get authPrivacyPolicy;

  /// No description provided for @authAndThe.
  ///
  /// In es, this message translates to:
  /// **' y la '**
  String get authAndThe;

  /// No description provided for @authMinChars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get authMinChars;

  /// No description provided for @authOneUppercase.
  ///
  /// In es, this message translates to:
  /// **'Una mayúscula'**
  String get authOneUppercase;

  /// No description provided for @authOneLowercase.
  ///
  /// In es, this message translates to:
  /// **'Una minúscula'**
  String get authOneLowercase;

  /// No description provided for @authOneNumber.
  ///
  /// In es, this message translates to:
  /// **'Un número'**
  String get authOneNumber;

  /// No description provided for @authOneSpecialChar.
  ///
  /// In es, this message translates to:
  /// **'Un carácter especial'**
  String get authOneSpecialChar;

  /// No description provided for @authPasswordWeak.
  ///
  /// In es, this message translates to:
  /// **'Débil'**
  String get authPasswordWeak;

  /// No description provided for @authPasswordMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get authPasswordMedium;

  /// No description provided for @authPasswordStrong.
  ///
  /// In es, this message translates to:
  /// **'Fuerte'**
  String get authPasswordStrong;

  /// No description provided for @authPasswordConfirmRequired.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get authPasswordConfirmRequired;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authPasswordMustContainUpper.
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una mayúscula'**
  String get authPasswordMustContainUpper;

  /// No description provided for @authPasswordMustContainLower.
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una minúscula'**
  String get authPasswordMustContainLower;

  /// No description provided for @authPasswordMustContainNumber.
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos un número'**
  String get authPasswordMustContainNumber;

  /// No description provided for @authLinkAccounts.
  ///
  /// In es, this message translates to:
  /// **'Vincular Cuentas'**
  String get authLinkAccounts;

  /// No description provided for @authLinkAccountMessage.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes una cuenta con este email usando {existingProvider}.\n\n¿Deseas vincular tu cuenta de {newProvider} para poder acceder con ambos métodos?'**
  String authLinkAccountMessage(String existingProvider, String newProvider);

  /// No description provided for @authLinkSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Cuenta de {provider} vinculada exitosamente!'**
  String authLinkSuccess(String provider);

  /// No description provided for @authLinkButton.
  ///
  /// In es, this message translates to:
  /// **'Vincular'**
  String get authLinkButton;

  /// No description provided for @authSentTo.
  ///
  /// In es, this message translates to:
  /// **'Enviado a:'**
  String get authSentTo;

  /// No description provided for @authCheckSpam.
  ///
  /// In es, this message translates to:
  /// **'Si no ves el correo, revisa tu carpeta de spam'**
  String get authCheckSpam;

  /// No description provided for @authResendEmail.
  ///
  /// In es, this message translates to:
  /// **'Reenviar correo'**
  String get authResendEmail;

  /// No description provided for @authBackToLogin.
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio de sesión'**
  String get authBackToLogin;

  /// No description provided for @authEmailPasswordProvider.
  ///
  /// In es, this message translates to:
  /// **'Email y Contraseña'**
  String get authEmailPasswordProvider;

  /// No description provided for @authPasswordMinLengthSix.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get authPasswordMinLengthSix;

  /// No description provided for @authPasswordMinLengthN.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos {count} caracteres'**
  String authPasswordMinLengthN(String count);

  /// No description provided for @authPasswordMinLengthValidator.
  ///
  /// In es, this message translates to:
  /// **'Mínimo {count} caracteres'**
  String authPasswordMinLengthValidator(Object count);

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cambia el tema de la aplicación'**
  String get settingsDarkModeSubtitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get settingsNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones push'**
  String get settingsPushNotifications;

  /// No description provided for @settingsPushSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibe alertas importantes'**
  String get settingsPushSubtitle;

  /// No description provided for @settingsSounds.
  ///
  /// In es, this message translates to:
  /// **'Sonidos'**
  String get settingsSounds;

  /// No description provided for @settingsSoundsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reproduce sonidos de notificación'**
  String get settingsSoundsSubtitle;

  /// No description provided for @settingsVibration.
  ///
  /// In es, this message translates to:
  /// **'Vibración'**
  String get settingsVibration;

  /// No description provided for @settingsVibrationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Vibrar al recibir notificaciones'**
  String get settingsVibrationSubtitle;

  /// No description provided for @settingsConfigureAlerts.
  ///
  /// In es, this message translates to:
  /// **'Configurar alertas'**
  String get settingsConfigureAlerts;

  /// No description provided for @settingsConfigureAlertsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Personaliza qué alertas recibir'**
  String get settingsConfigureAlertsSubtitle;

  /// No description provided for @settingsDataStorage.
  ///
  /// In es, this message translates to:
  /// **'Datos y Almacenamiento'**
  String get settingsDataStorage;

  /// No description provided for @settingsClearCache.
  ///
  /// In es, this message translates to:
  /// **'Limpiar caché'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCacheSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Libera espacio en el dispositivo'**
  String get settingsClearCacheSubtitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get settingsSecurity;

  /// No description provided for @settingsChangePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu contraseña de acceso'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsVerifyEmail.
  ///
  /// In es, this message translates to:
  /// **'Verificar email'**
  String get settingsVerifyEmail;

  /// No description provided for @settingsVerifyEmailSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu dirección de correo'**
  String get settingsVerifyEmailSubtitle;

  /// No description provided for @settingsDangerZone.
  ///
  /// In es, this message translates to:
  /// **'Zona de peligro'**
  String get settingsDangerZone;

  /// No description provided for @settingsDeleteAccountWarning.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tu cuenta borrará permanentemente todos tus datos, incluyendo granjas, lotes y registros.'**
  String get settingsDeleteAccountWarning;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsClearCacheConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Limpiar caché?'**
  String get settingsClearCacheConfirm;

  /// No description provided for @settingsClearCacheMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán los datos temporales. Esto no afectará tus registros.'**
  String get settingsClearCacheMessage;

  /// No description provided for @settingsClearCacheConfirmButton.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get settingsClearCacheConfirmButton;

  /// No description provided for @settingsCacheClearedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Caché limpiado correctamente'**
  String get settingsCacheClearedSuccess;

  /// No description provided for @settingsChangePasswordMessage.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un enlace para restablecer tu contraseña.'**
  String get settingsChangePasswordMessage;

  /// No description provided for @settingsYourEmail.
  ///
  /// In es, this message translates to:
  /// **'Tu email'**
  String get settingsYourEmail;

  /// No description provided for @settingsSendLink.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get settingsSendLink;

  /// No description provided for @settingsResetLinkSent.
  ///
  /// In es, this message translates to:
  /// **'Se ha enviado un enlace a tu correo'**
  String get settingsResetLinkSent;

  /// No description provided for @settingsVerificationEmailSent.
  ///
  /// In es, this message translates to:
  /// **'Se ha enviado un correo de verificación'**
  String get settingsVerificationEmailSent;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar cuenta?'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible y perderás todos tus datos.'**
  String get settingsDeleteAccountMessage;

  /// No description provided for @profileSignOutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar sesión?'**
  String get profileSignOutConfirm;

  /// No description provided for @profileSignOutMessage.
  ///
  /// In es, this message translates to:
  /// **'Tendrás que volver a iniciar sesión para acceder a tu cuenta.'**
  String get profileSignOutMessage;

  /// No description provided for @profileNoFarmsMessage.
  ///
  /// In es, this message translates to:
  /// **'No tienes granjas. Crea una primero.'**
  String get profileNoFarmsMessage;

  /// No description provided for @profileCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get profileCreate;

  /// No description provided for @profileHelpQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿En qué podemos ayudarte?'**
  String get profileHelpQuestion;

  /// No description provided for @profileEmailSupport.
  ///
  /// In es, this message translates to:
  /// **'Soporte por Email'**
  String get profileEmailSupport;

  /// No description provided for @profileFaq.
  ///
  /// In es, this message translates to:
  /// **'Preguntas Frecuentes'**
  String get profileFaq;

  /// No description provided for @profileFaqSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Consulta las dudas más comunes'**
  String get profileFaqSubtitle;

  /// No description provided for @profileUserManual.
  ///
  /// In es, this message translates to:
  /// **'Manual de Usuario'**
  String get profileUserManual;

  /// No description provided for @profileUserManualSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guía completa de uso'**
  String get profileUserManualSubtitle;

  /// No description provided for @profileFeedbackQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Tienes alguna idea para mejorar la app? Nos encantaría escucharte.'**
  String get profileFeedbackQuestion;

  /// No description provided for @profileFeedbackHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu sugerencia aquí...'**
  String get profileFeedbackHint;

  /// No description provided for @profileFeedbackThanks.
  ///
  /// In es, this message translates to:
  /// **'¡Gracias por tu sugerencia!'**
  String get profileFeedbackThanks;

  /// No description provided for @profileAppDescription.
  ///
  /// In es, this message translates to:
  /// **'Tu aliado inteligente para la gestión avícola. Controla lotes, monitorea el rendimiento, registra vacunaciones y optimiza la producción de tu granja de manera sencilla y eficiente.'**
  String get profileAppDescription;

  /// No description provided for @profileCopyright.
  ///
  /// In es, this message translates to:
  /// **'© 2024 Smart Granja. Todos los derechos reservados.'**
  String get profileCopyright;

  /// No description provided for @profileVersionText.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String profileVersionText(String version);

  /// No description provided for @editProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfileTitle;

  /// No description provided for @editProfilePersonalInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Personal'**
  String get editProfilePersonalInfo;

  /// No description provided for @editProfileAccountInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Cuenta'**
  String get editProfileAccountInfo;

  /// No description provided for @editProfileLastName.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get editProfileLastName;

  /// No description provided for @editProfileMemberSince.
  ///
  /// In es, this message translates to:
  /// **'Miembro desde'**
  String get editProfileMemberSince;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto de perfil'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get editProfileTakePhoto;

  /// No description provided for @editProfileChooseGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get editProfileChooseGallery;

  /// No description provided for @editProfilePhotoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada correctamente'**
  String get editProfilePhotoUpdated;

  /// No description provided for @editProfilePhotoError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar la foto. Intenta de nuevo.'**
  String get editProfilePhotoError;

  /// No description provided for @editProfileImageTooLarge.
  ///
  /// In es, this message translates to:
  /// **'La imagen excede el tamaño máximo (5MB)'**
  String get editProfileImageTooLarge;

  /// No description provided for @editProfileDiscardChanges.
  ///
  /// In es, this message translates to:
  /// **'¿Descartar cambios?'**
  String get editProfileDiscardChanges;

  /// No description provided for @editProfileDiscardMessage.
  ///
  /// In es, this message translates to:
  /// **'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?'**
  String get editProfileDiscardMessage;

  /// No description provided for @editProfileUnknownDate.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get editProfileUnknownDate;

  /// No description provided for @editProfileUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get editProfileUpdatedSuccess;

  /// No description provided for @editProfileUpdateError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar: {error}'**
  String editProfileUpdateError(String error);

  /// No description provided for @notifProductionAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de Producción'**
  String get notifProductionAlerts;

  /// No description provided for @notifHighMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad elevada'**
  String get notifHighMortality;

  /// No description provided for @notifHighMortalitySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta cuando la mortalidad supera el {threshold}%'**
  String notifHighMortalitySubtitle(String threshold);

  /// No description provided for @notifMortalityThreshold.
  ///
  /// In es, this message translates to:
  /// **'Umbral de mortalidad'**
  String get notifMortalityThreshold;

  /// No description provided for @notifLowProduction.
  ///
  /// In es, this message translates to:
  /// **'Baja producción'**
  String get notifLowProduction;

  /// No description provided for @notifLowProductionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta cuando la producción cae bajo el {threshold}%'**
  String notifLowProductionSubtitle(Object threshold);

  /// No description provided for @notifProductionThreshold.
  ///
  /// In es, this message translates to:
  /// **'Umbral de producción'**
  String get notifProductionThreshold;

  /// No description provided for @notifAbnormalConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo anormal'**
  String get notifAbnormalConsumption;

  /// No description provided for @notifAbnormalConsumptionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta cuando el consumo varía significativamente'**
  String get notifAbnormalConsumptionSubtitle;

  /// No description provided for @notifReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios'**
  String get notifReminders;

  /// No description provided for @notifPendingVaccinations.
  ///
  /// In es, this message translates to:
  /// **'Vacunaciones pendientes'**
  String get notifPendingVaccinations;

  /// No description provided for @notifPendingVaccinationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recuerda vacunaciones programadas'**
  String get notifPendingVaccinationsSubtitle;

  /// No description provided for @notifLowInventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario bajo'**
  String get notifLowInventory;

  /// No description provided for @notifLowInventorySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta cuando el alimento está por agotarse'**
  String get notifLowInventorySubtitle;

  /// No description provided for @notifSummaries.
  ///
  /// In es, this message translates to:
  /// **'Resúmenes'**
  String get notifSummaries;

  /// No description provided for @notifDailySummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen diario'**
  String get notifDailySummary;

  /// No description provided for @notifDailySummarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibe un resumen cada día a las 8:00 PM'**
  String get notifDailySummarySubtitle;

  /// No description provided for @notifWeeklySummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen semanal'**
  String get notifWeeklySummary;

  /// No description provided for @notifWeeklySummarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibe un resumen cada lunes'**
  String get notifWeeklySummarySubtitle;

  /// No description provided for @notifConfigSaved.
  ///
  /// In es, this message translates to:
  /// **'Configuración guardada'**
  String get notifConfigSaved;

  /// No description provided for @notifSaveConfig.
  ///
  /// In es, this message translates to:
  /// **'Guardar configuración'**
  String get notifSaveConfig;

  /// No description provided for @farmCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Granja \"{name}\" creada!'**
  String farmCreatedSuccess(String name);

  /// No description provided for @farmUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Granja \"{name}\" actualizada!'**
  String farmUpdatedSuccess(Object name);

  /// No description provided for @farmNotFound.
  ///
  /// In es, this message translates to:
  /// **'Granja no encontrada'**
  String get farmNotFound;

  /// No description provided for @farmOwner.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get farmOwner;

  /// No description provided for @farmCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad'**
  String get farmCapacity;

  /// No description provided for @farmArea.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get farmArea;

  /// No description provided for @farmEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get farmEmail;

  /// No description provided for @farmCreatedDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Creación'**
  String get farmCreatedDate;

  /// No description provided for @farmCollaborators.
  ///
  /// In es, this message translates to:
  /// **'Colaboradores'**
  String get farmCollaborators;

  /// No description provided for @farmInviteCollaborator.
  ///
  /// In es, this message translates to:
  /// **'Invitar Colaborador'**
  String get farmInviteCollaborator;

  /// No description provided for @farmRoleUpdated.
  ///
  /// In es, this message translates to:
  /// **'Rol actualizado a {role}'**
  String farmRoleUpdated(String role);

  /// No description provided for @farmCodeCopied.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get farmCodeCopied;

  /// No description provided for @farmActivateConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Activar \"{name}\"?'**
  String farmActivateConfirm(Object name);

  /// No description provided for @farmSuspendConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Suspender \"{name}\"?'**
  String farmSuspendConfirm(Object name);

  /// No description provided for @farmMaintenanceConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Poner \"{name}\" en mantenimiento?'**
  String farmMaintenanceConfirm(Object name);

  /// No description provided for @shedActivateConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Activar \"{name}\"?'**
  String shedActivateConfirm(Object name);

  /// No description provided for @shedSuspendConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Suspender \"{name}\"?'**
  String shedSuspendConfirm(Object name);

  /// No description provided for @shedMaintenanceConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Poner \"{name}\" en mantenimiento?'**
  String shedMaintenanceConfirm(Object name);

  /// No description provided for @shedDisinfectionConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Poner \"{name}\" en desinfección?'**
  String shedDisinfectionConfirm(Object name);

  /// No description provided for @shedReleaseConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Liberar \"{name}\"?'**
  String shedReleaseConfirm(Object name);

  /// No description provided for @shedCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad'**
  String get shedCapacity;

  /// No description provided for @shedCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Actuales'**
  String get shedCurrentBirds;

  /// No description provided for @shedOccupancy.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get shedOccupancy;

  /// No description provided for @shedBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves'**
  String get shedBirds;

  /// No description provided for @shedTagExists.
  ///
  /// In es, this message translates to:
  /// **'Esta etiqueta ya existe'**
  String get shedTagExists;

  /// No description provided for @shedMaxTags.
  ///
  /// In es, this message translates to:
  /// **'Máximo {max} etiquetas'**
  String shedMaxTags(String max);

  /// No description provided for @shedAddProduct.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get shedAddProduct;

  /// No description provided for @batchCode.
  ///
  /// In es, this message translates to:
  /// **'Código del Lote'**
  String get batchCode;

  /// No description provided for @batchBirdType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Ave'**
  String get batchBirdType;

  /// No description provided for @batchBreedLine.
  ///
  /// In es, this message translates to:
  /// **'Raza/Línea Genética'**
  String get batchBreedLine;

  /// No description provided for @batchInitialCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad Inicial'**
  String get batchInitialCount;

  /// No description provided for @batchCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Actuales'**
  String get batchCurrentBirds;

  /// No description provided for @batchEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Ingreso'**
  String get batchEntryDate;

  /// No description provided for @batchEntryAge.
  ///
  /// In es, this message translates to:
  /// **'Edad al Ingreso'**
  String get batchEntryAge;

  /// No description provided for @batchCurrentAge.
  ///
  /// In es, this message translates to:
  /// **'Edad Actual'**
  String get batchCurrentAge;

  /// No description provided for @batchCostPerBird.
  ///
  /// In es, this message translates to:
  /// **'Costo por Ave'**
  String get batchCostPerBird;

  /// No description provided for @batchEstimatedClose.
  ///
  /// In es, this message translates to:
  /// **'Cierre Estimado'**
  String get batchEstimatedClose;

  /// No description provided for @batchSurvivalRate.
  ///
  /// In es, this message translates to:
  /// **'Tasa de Supervivencia'**
  String get batchSurvivalRate;

  /// No description provided for @batchAccumulatedMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Acumulada'**
  String get batchAccumulatedMortality;

  /// No description provided for @batchAccumulatedDiscards.
  ///
  /// In es, this message translates to:
  /// **'Descartes Acumulados'**
  String get batchAccumulatedDiscards;

  /// No description provided for @batchAccumulatedSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas Acumuladas'**
  String get batchAccumulatedSales;

  /// No description provided for @batchCurrentAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio actual'**
  String get batchCurrentAvgWeight;

  /// No description provided for @batchAccumulatedConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo Acumulado'**
  String get batchAccumulatedConsumption;

  /// No description provided for @batchFeedConversion.
  ///
  /// In es, this message translates to:
  /// **'Índice Conversión'**
  String get batchFeedConversion;

  /// No description provided for @batchEggsProduced.
  ///
  /// In es, this message translates to:
  /// **'Huevos Producidos'**
  String get batchEggsProduced;

  /// No description provided for @batchRemainingDays.
  ///
  /// In es, this message translates to:
  /// **'Días Restantes'**
  String get batchRemainingDays;

  /// No description provided for @batchImportantInfo.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get batchImportantInfo;

  /// No description provided for @batchChangeStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Estado'**
  String get batchChangeStatus;

  /// No description provided for @batchClosedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote cerrado exitosamente'**
  String get batchClosedSuccess;

  /// No description provided for @batchEntryAgeDays.
  ///
  /// In es, this message translates to:
  /// **'Edad de Ingreso (días)'**
  String get batchEntryAgeDays;

  /// No description provided for @batchSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar lote'**
  String get batchSelectBatch;

  /// No description provided for @healthApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicada'**
  String get healthApplied;

  /// No description provided for @healthExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get healthExpired;

  /// No description provided for @healthUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próxima'**
  String get healthUpcoming;

  /// No description provided for @healthPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get healthPending;

  /// No description provided for @healthVaccineName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la vacuna'**
  String get healthVaccineName;

  /// No description provided for @healthVaccineNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Newcastle + Bronquitis'**
  String get healthVaccineNameHint;

  /// No description provided for @healthVaccineBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote de la vacuna (opcional)'**
  String get healthVaccineBatch;

  /// No description provided for @healthVaccineBatchHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: LOT123456'**
  String get healthVaccineBatchHint;

  /// No description provided for @healthSelectInventoryVaccine.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar vacuna del inventario'**
  String get healthSelectInventoryVaccine;

  /// No description provided for @healthSelectInventoryVaccineHint.
  ///
  /// In es, this message translates to:
  /// **'Opcional - Selecciona una vacuna registrada'**
  String get healthSelectInventoryVaccineHint;

  /// No description provided for @healthObservationsOptional.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get healthObservationsOptional;

  /// No description provided for @healthObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Reacciones observadas, notas especiales, etc.'**
  String get healthObservationsHint;

  /// No description provided for @healthTreatmentDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción del tratamiento'**
  String get healthTreatmentDescription;

  /// No description provided for @healthTreatmentDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describe el protocolo de tratamiento aplicado'**
  String get healthTreatmentDescriptionHint;

  /// No description provided for @healthMedications.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get healthMedications;

  /// No description provided for @healthAdditionalMedications.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos adicionales'**
  String get healthAdditionalMedications;

  /// No description provided for @healthMedicationsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Enrofloxacina + Vitaminas A, D, E'**
  String get healthMedicationsHint;

  /// No description provided for @healthDose.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get healthDose;

  /// No description provided for @healthDoseHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1ml/L'**
  String get healthDoseHint;

  /// No description provided for @healthDurationDays.
  ///
  /// In es, this message translates to:
  /// **'Duración (días)'**
  String get healthDurationDays;

  /// No description provided for @healthDurationHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 5'**
  String get healthDurationHint;

  /// No description provided for @healthDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get healthDiagnosis;

  /// No description provided for @healthDiagnosisHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Enfermedad respiratoria crónica'**
  String get healthDiagnosisHint;

  /// No description provided for @healthSymptomsObserved.
  ///
  /// In es, this message translates to:
  /// **'Síntomas observados'**
  String get healthSymptomsObserved;

  /// No description provided for @healthSymptomsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe los síntomas: tos, estornudos, decaimiento...'**
  String get healthSymptomsHint;

  /// No description provided for @healthVeterinarian.
  ///
  /// In es, this message translates to:
  /// **'Veterinario responsable'**
  String get healthVeterinarian;

  /// No description provided for @healthVeterinarianHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del veterinario'**
  String get healthVeterinarianHint;

  /// No description provided for @healthGeneralObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones generales'**
  String get healthGeneralObservations;

  /// No description provided for @healthGeneralObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales, evolución esperada, etc.'**
  String get healthGeneralObservationsHint;

  /// No description provided for @healthBiosecurityObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe hallazgos generales de la inspección…'**
  String get healthBiosecurityObservationsHint;

  /// No description provided for @healthCorrectiveActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones correctivas'**
  String get healthCorrectiveActions;

  /// No description provided for @healthCorrectiveActionsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe las acciones a implementar…'**
  String get healthCorrectiveActionsHint;

  /// No description provided for @healthCompliant.
  ///
  /// In es, this message translates to:
  /// **'Cumple'**
  String get healthCompliant;

  /// No description provided for @healthNonCompliant.
  ///
  /// In es, this message translates to:
  /// **'No cumple'**
  String get healthNonCompliant;

  /// No description provided for @healthPartial.
  ///
  /// In es, this message translates to:
  /// **'Parcial'**
  String get healthPartial;

  /// No description provided for @healthNotApplicable.
  ///
  /// In es, this message translates to:
  /// **'No aplica'**
  String get healthNotApplicable;

  /// No description provided for @healthWriteObservation.
  ///
  /// In es, this message translates to:
  /// **'Escribe una observación (opcional)'**
  String get healthWriteObservation;

  /// No description provided for @healthScheduleVaccination.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get healthScheduleVaccination;

  /// No description provided for @healthVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get healthVaccine;

  /// No description provided for @healthApplication.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get healthApplication;

  /// No description provided for @healthMustSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar un lote'**
  String get healthMustSelectBatch;

  /// No description provided for @healthDiseaseCatalog.
  ///
  /// In es, this message translates to:
  /// **'Catálogo de Enfermedades'**
  String get healthDiseaseCatalog;

  /// No description provided for @healthSearchDisease.
  ///
  /// In es, this message translates to:
  /// **'Buscar enfermedad, síntoma...'**
  String get healthSearchDisease;

  /// No description provided for @healthAllSeverities.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get healthAllSeverities;

  /// No description provided for @healthCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get healthCritical;

  /// No description provided for @healthSevere.
  ///
  /// In es, this message translates to:
  /// **'Grave'**
  String get healthSevere;

  /// No description provided for @healthModerate.
  ///
  /// In es, this message translates to:
  /// **'Moderada'**
  String get healthModerate;

  /// No description provided for @healthMild.
  ///
  /// In es, this message translates to:
  /// **'Leve'**
  String get healthMild;

  /// No description provided for @healthRegisterTreatment.
  ///
  /// In es, this message translates to:
  /// **'Registrar Tratamiento'**
  String get healthRegisterTreatment;

  /// No description provided for @healthBiosecurityInspection.
  ///
  /// In es, this message translates to:
  /// **'Inspección de Bioseguridad'**
  String get healthBiosecurityInspection;

  /// No description provided for @healthNewInspection.
  ///
  /// In es, this message translates to:
  /// **'Nueva Inspección'**
  String get healthNewInspection;

  /// No description provided for @healthChecklist.
  ///
  /// In es, this message translates to:
  /// **'Checklist'**
  String get healthChecklist;

  /// No description provided for @healthInspectionSaved.
  ///
  /// In es, this message translates to:
  /// **'Inspección guardada exitosamente'**
  String get healthInspectionSaved;

  /// No description provided for @healthRecordDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Registro'**
  String get healthRecordDetail;

  /// No description provided for @healthCloseTreatment.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Tratamiento'**
  String get healthCloseTreatment;

  /// No description provided for @healthVaccinationApplied.
  ///
  /// In es, this message translates to:
  /// **'Vacunación marcada como aplicada'**
  String get healthVaccinationApplied;

  /// No description provided for @healthVaccinationDeleted.
  ///
  /// In es, this message translates to:
  /// **'Vacunación eliminada'**
  String get healthVaccinationDeleted;

  /// No description provided for @salesDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Venta'**
  String get salesDetail;

  /// No description provided for @salesNotFoundDetail.
  ///
  /// In es, this message translates to:
  /// **'Venta no encontrada'**
  String get salesNotFoundDetail;

  /// No description provided for @salesEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar venta'**
  String get salesEditTooltip;

  /// No description provided for @salesClient.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get salesClient;

  /// No description provided for @salesDocument.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get salesDocument;

  /// No description provided for @salesBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get salesBirdCount;

  /// No description provided for @salesAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get salesAvgWeight;

  /// No description provided for @salesPricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg'**
  String get salesPricePerKg;

  /// No description provided for @salesSubtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get salesSubtotal;

  /// No description provided for @salesCarcassYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento canal'**
  String get salesCarcassYield;

  /// No description provided for @salesDiscount.
  ///
  /// In es, this message translates to:
  /// **'Descuento'**
  String get salesDiscount;

  /// No description provided for @salesTotalAmount.
  ///
  /// In es, this message translates to:
  /// **'TOTAL'**
  String get salesTotalAmount;

  /// No description provided for @salesProductDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Producto'**
  String get salesProductDetails;

  /// No description provided for @salesRegistrationInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Registro'**
  String get salesRegistrationInfo;

  /// No description provided for @salesActive.
  ///
  /// In es, this message translates to:
  /// **'Activas'**
  String get salesActive;

  /// No description provided for @salesCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get salesCompleted;

  /// No description provided for @salesConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get salesConfirmed;

  /// No description provided for @salesSold.
  ///
  /// In es, this message translates to:
  /// **'Vendida'**
  String get salesSold;

  /// No description provided for @salesClientName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get salesClientName;

  /// No description provided for @salesClientNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Juan Pérez García'**
  String get salesClientNameHint;

  /// No description provided for @salesDocType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de documento *'**
  String get salesDocType;

  /// No description provided for @salesDni.
  ///
  /// In es, this message translates to:
  /// **'DNI'**
  String get salesDni;

  /// No description provided for @salesRuc.
  ///
  /// In es, this message translates to:
  /// **'RUC'**
  String get salesRuc;

  /// No description provided for @salesForeignCard.
  ///
  /// In es, this message translates to:
  /// **'Carnet de Extranjería'**
  String get salesForeignCard;

  /// No description provided for @salesDocNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de documento'**
  String get salesDocNumber;

  /// No description provided for @salesContactPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono de contacto'**
  String get salesContactPhone;

  /// No description provided for @salesPhoneHint.
  ///
  /// In es, this message translates to:
  /// **'9 dígitos'**
  String get salesPhoneHint;

  /// No description provided for @salesDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get salesDraftFound;

  /// No description provided for @salesDraftRestore.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador de venta guardado anteriormente?'**
  String get salesDraftRestore;

  /// No description provided for @salesDraftRestored.
  ///
  /// In es, this message translates to:
  /// **'Borrador restaurado'**
  String get salesDraftRestored;

  /// No description provided for @costDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle del Costo'**
  String get costDetail;

  /// No description provided for @costEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar costo'**
  String get costEditTooltip;

  /// No description provided for @costConcept.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get costConcept;

  /// No description provided for @costInvoiceNumber.
  ///
  /// In es, this message translates to:
  /// **'Nº Factura'**
  String get costInvoiceNumber;

  /// No description provided for @costTypeFood.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get costTypeFood;

  /// No description provided for @costTypeLabor.
  ///
  /// In es, this message translates to:
  /// **'Mano de Obra'**
  String get costTypeLabor;

  /// No description provided for @costTypeEnergy.
  ///
  /// In es, this message translates to:
  /// **'Energía'**
  String get costTypeEnergy;

  /// No description provided for @costTypeMedicine.
  ///
  /// In es, this message translates to:
  /// **'Medicamento'**
  String get costTypeMedicine;

  /// No description provided for @costTypeMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get costTypeMaintenance;

  /// No description provided for @costTypeWater.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get costTypeWater;

  /// No description provided for @costTypeTransport.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get costTypeTransport;

  /// No description provided for @costTypeAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrativo'**
  String get costTypeAdmin;

  /// No description provided for @costTypeDepreciation.
  ///
  /// In es, this message translates to:
  /// **'Depreciación'**
  String get costTypeDepreciation;

  /// No description provided for @costTypeFinancial.
  ///
  /// In es, this message translates to:
  /// **'Financiero'**
  String get costTypeFinancial;

  /// No description provided for @costTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get costTypeOther;

  /// No description provided for @costDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar Costo?'**
  String get costDeleteConfirm;

  /// No description provided for @costDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo eliminado exitosamente'**
  String get costDeletedSuccess;

  /// No description provided for @costNoCosts.
  ///
  /// In es, this message translates to:
  /// **'Sin costos registrados'**
  String get costNoCosts;

  /// No description provided for @costNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron costos'**
  String get costNotFound;

  /// No description provided for @costRegisterNew.
  ///
  /// In es, this message translates to:
  /// **'Registrar Costo'**
  String get costRegisterNew;

  /// No description provided for @costRegisterNewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar nuevo costo'**
  String get costRegisterNewTooltip;

  /// No description provided for @costType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de gasto'**
  String get costType;

  /// No description provided for @costDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get costDraftFound;

  /// No description provided for @costExitConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get costExitConfirm;

  /// No description provided for @costAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get costAmount;

  /// No description provided for @costConceptHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Compra de alimento balanceado'**
  String get costConceptHint;

  /// No description provided for @costSearchInventory.
  ///
  /// In es, this message translates to:
  /// **'Buscar en inventario (opcional)...'**
  String get costSearchInventory;

  /// No description provided for @costProviderHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor o empresa'**
  String get costProviderHint;

  /// No description provided for @costInvoiceNumberLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de Factura/Recibo'**
  String get costInvoiceNumberLabel;

  /// No description provided for @costInvoiceHint.
  ///
  /// In es, this message translates to:
  /// **'F001-00001234'**
  String get costInvoiceHint;

  /// No description provided for @costNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales sobre este gasto'**
  String get costNotesHint;

  /// No description provided for @inventoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventoryTitle;

  /// No description provided for @inventoryNewItem.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Item'**
  String get inventoryNewItem;

  /// No description provided for @inventorySearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o código...'**
  String get inventorySearchHint;

  /// No description provided for @inventoryAddItem.
  ///
  /// In es, this message translates to:
  /// **'Agregar Item'**
  String get inventoryAddItem;

  /// No description provided for @inventoryItemDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle del Item'**
  String get inventoryItemDetail;

  /// No description provided for @inventoryRegisterEntry.
  ///
  /// In es, this message translates to:
  /// **'Registrar Entrada'**
  String get inventoryRegisterEntry;

  /// No description provided for @inventoryRegisterExit.
  ///
  /// In es, this message translates to:
  /// **'Registrar Salida'**
  String get inventoryRegisterExit;

  /// No description provided for @inventoryAdjustStock.
  ///
  /// In es, this message translates to:
  /// **'Ajustar Stock'**
  String get inventoryAdjustStock;

  /// No description provided for @inventoryItemNotFound.
  ///
  /// In es, this message translates to:
  /// **'Item no encontrado'**
  String get inventoryItemNotFound;

  /// No description provided for @inventoryItemDeleted.
  ///
  /// In es, this message translates to:
  /// **'Item eliminado'**
  String get inventoryItemDeleted;

  /// No description provided for @inventoryBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get inventoryBasic;

  /// No description provided for @inventoryImageSelected.
  ///
  /// In es, this message translates to:
  /// **'Imagen seleccionada'**
  String get inventoryImageSelected;

  /// No description provided for @inventoryItemName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Item'**
  String get inventoryItemName;

  /// No description provided for @inventoryItemNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Concentrado Iniciador'**
  String get inventoryItemNameHint;

  /// No description provided for @inventoryCodeSku.
  ///
  /// In es, this message translates to:
  /// **'Código/SKU (opcional)'**
  String get inventoryCodeSku;

  /// No description provided for @inventoryCodeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: ALI-001'**
  String get inventoryCodeHint;

  /// No description provided for @inventoryDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get inventoryDescriptionOptional;

  /// No description provided for @inventoryDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describe las características del producto...'**
  String get inventoryDescriptionHint;

  /// No description provided for @inventoryCurrentStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Actual'**
  String get inventoryCurrentStock;

  /// No description provided for @inventoryMinStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Mínimo'**
  String get inventoryMinStock;

  /// No description provided for @inventoryMaxStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Máximo'**
  String get inventoryMaxStock;

  /// No description provided for @inventoryOptional.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get inventoryOptional;

  /// No description provided for @inventoryUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio Unitario'**
  String get inventoryUnitPrice;

  /// No description provided for @inventoryProviderHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor'**
  String get inventoryProviderHint;

  /// No description provided for @inventoryStorageLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación en Almacén'**
  String get inventoryStorageLocation;

  /// No description provided for @inventoryStorageHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Bodega A, Estante 3'**
  String get inventoryStorageHint;

  /// No description provided for @inventoryExpiration.
  ///
  /// In es, this message translates to:
  /// **'Vencimiento'**
  String get inventoryExpiration;

  /// No description provided for @inventoryProviderBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote del Proveedor'**
  String get inventoryProviderBatch;

  /// No description provided for @inventoryProviderBatchHint.
  ///
  /// In es, this message translates to:
  /// **'Número de lote'**
  String get inventoryProviderBatchHint;

  /// No description provided for @inventoryTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get inventoryTakePhoto;

  /// No description provided for @inventoryGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get inventoryGallery;

  /// No description provided for @inventoryObservation.
  ///
  /// In es, this message translates to:
  /// **'Observación'**
  String get inventoryObservation;

  /// No description provided for @inventoryObservationHint.
  ///
  /// In es, this message translates to:
  /// **'Motivo u observación'**
  String get inventoryObservationHint;

  /// No description provided for @inventoryPhysicalCount.
  ///
  /// In es, this message translates to:
  /// **'Ej: Inventario físico'**
  String get inventoryPhysicalCount;

  /// No description provided for @inventoryAdjustReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo del ajuste'**
  String get inventoryAdjustReason;

  /// No description provided for @inventoryStockAdjusted.
  ///
  /// In es, this message translates to:
  /// **'Stock ajustado correctamente'**
  String get inventoryStockAdjusted;

  /// No description provided for @inventorySelectProduct.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar producto'**
  String get inventorySelectProduct;

  /// No description provided for @inventorySearchProduct.
  ///
  /// In es, this message translates to:
  /// **'Buscar en inventario...'**
  String get inventorySearchProduct;

  /// No description provided for @inventorySearchProductShort.
  ///
  /// In es, this message translates to:
  /// **'Buscar producto...'**
  String get inventorySearchProductShort;

  /// No description provided for @inventoryItemOptions.
  ///
  /// In es, this message translates to:
  /// **'Más opciones del item'**
  String get inventoryItemOptions;

  /// No description provided for @inventoryRemoveSelection.
  ///
  /// In es, this message translates to:
  /// **'Quitar selección'**
  String get inventoryRemoveSelection;

  /// No description provided for @inventoryEnterProduct.
  ///
  /// In es, this message translates to:
  /// **'Ingrese al menos un producto'**
  String get inventoryEnterProduct;

  /// No description provided for @inventoryEnterDescription.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una descripción'**
  String get inventoryEnterDescription;

  /// No description provided for @weightMinObserved.
  ///
  /// In es, this message translates to:
  /// **'Peso mínimo observado'**
  String get weightMinObserved;

  /// No description provided for @weightMinHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 2200'**
  String get weightMinHint;

  /// No description provided for @batchFormWeightObsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe condiciones del pesaje, comportamiento de las aves, condiciones ambientales, etc.'**
  String get batchFormWeightObsHint;

  /// No description provided for @weightMaxObserved.
  ///
  /// In es, this message translates to:
  /// **'Peso máximo observado'**
  String get weightMaxObserved;

  /// No description provided for @weightMethod.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get weightMethod;

  /// No description provided for @weightMethodHint.
  ///
  /// In es, this message translates to:
  /// **'Seleccione el método'**
  String get weightMethodHint;

  /// No description provided for @mortalityEventDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción del evento'**
  String get mortalityEventDescription;

  /// No description provided for @mortalityEventDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describa síntomas, contexto, condiciones ambientales...'**
  String get mortalityEventDescriptionHint;

  /// No description provided for @productionInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get productionInfo;

  /// No description provided for @productionClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get productionClassification;

  /// No description provided for @productionTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get productionTakePhoto;

  /// No description provided for @productionGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get productionGallery;

  /// No description provided for @productionEggsCollected.
  ///
  /// In es, this message translates to:
  /// **'Huevos recolectados'**
  String get productionEggsCollected;

  /// No description provided for @productionEggsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 850'**
  String get productionEggsHint;

  /// No description provided for @productionSmallEggs.
  ///
  /// In es, this message translates to:
  /// **'Pequeños (S) - 43-53g'**
  String get productionSmallEggs;

  /// No description provided for @monthJan.
  ///
  /// In es, this message translates to:
  /// **'Ene'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In es, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In es, this message translates to:
  /// **'Abr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In es, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In es, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In es, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In es, this message translates to:
  /// **'Ago'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In es, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In es, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In es, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In es, this message translates to:
  /// **'Dic'**
  String get monthDec;

  /// No description provided for @commonChangeStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiar estado'**
  String get commonChangeStatus;

  /// No description provided for @commonCurrentStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado actual:'**
  String get commonCurrentStatus;

  /// No description provided for @commonSelectNewStatus.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar nuevo estado:'**
  String get commonSelectNewStatus;

  /// No description provided for @commonErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get commonErrorLoading;

  /// No description provided for @commonSaveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get commonSaveChanges;

  /// No description provided for @commonCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get commonCreate;

  /// No description provided for @commonUpdate.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get commonUpdate;

  /// No description provided for @commonRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get commonRegister;

  /// No description provided for @commonUnexpectedError.
  ///
  /// In es, this message translates to:
  /// **'Error inesperado'**
  String get commonUnexpectedError;

  /// No description provided for @commonSearchByNameCityAddress.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, ciudad o dirección...'**
  String get commonSearchByNameCityAddress;

  /// No description provided for @commonEnterReason.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el motivo'**
  String get commonEnterReason;

  /// No description provided for @commonDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get commonDescriptionOptional;

  /// No description provided for @commonState.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get commonState;

  /// No description provided for @commonType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get commonType;

  /// No description provided for @commonNoPhotos.
  ///
  /// In es, this message translates to:
  /// **'No hay fotos agregadas'**
  String get commonNoPhotos;

  /// No description provided for @commonSelectedPhotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos seleccionadas'**
  String get commonSelectedPhotos;

  /// No description provided for @commonTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get commonTakePhoto;

  /// No description provided for @commonFieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get commonFieldRequired;

  /// No description provided for @commonInvalidValue.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido'**
  String get commonInvalidValue;

  /// No description provided for @commonLoadingCharts.
  ///
  /// In es, this message translates to:
  /// **'Cargando gráficos...'**
  String get commonLoadingCharts;

  /// No description provided for @commonNoRecordsWithFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay registros con estos filtros'**
  String get commonNoRecordsWithFilters;

  /// No description provided for @commonFilterCosts.
  ///
  /// In es, this message translates to:
  /// **'Filtrar costos'**
  String get commonFilterCosts;

  /// No description provided for @commonApplyFiltersBtn.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get commonApplyFiltersBtn;

  /// No description provided for @commonCloseBtn.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get commonCloseBtn;

  /// No description provided for @commonSelectType.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tipo'**
  String get commonSelectType;

  /// No description provided for @commonSelectStatus.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar estado'**
  String get commonSelectStatus;

  /// No description provided for @commonQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get commonQuantity;

  /// No description provided for @commonAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get commonAmount;

  /// No description provided for @commonNoData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos'**
  String get commonNoData;

  /// No description provided for @commonRestoreBtn.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get commonRestoreBtn;

  /// No description provided for @commonDiscardBtn.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get commonDiscardBtn;

  /// No description provided for @farmName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la Granja'**
  String get farmName;

  /// No description provided for @farmNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Granja San José'**
  String get farmNameHint;

  /// No description provided for @farmNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre de la granja'**
  String get farmNameRequired;

  /// No description provided for @farmNameMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get farmNameMinLength;

  /// No description provided for @farmOwnerName.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get farmOwnerName;

  /// No description provided for @farmOwnerHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo del propietario'**
  String get farmOwnerHint;

  /// No description provided for @farmOwnerRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del propietario'**
  String get farmOwnerRequired;

  /// No description provided for @farmDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get farmDescriptionOptional;

  /// No description provided for @farmCreateFarm.
  ///
  /// In es, this message translates to:
  /// **'Crear Granja'**
  String get farmCreateFarm;

  /// No description provided for @farmSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, ciudad o dirección...'**
  String get farmSearchHint;

  /// No description provided for @farmDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get farmDetails;

  /// No description provided for @farmEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar granja'**
  String get farmEditTooltip;

  /// No description provided for @farmDeleteFarm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar granja'**
  String get farmDeleteFarm;

  /// No description provided for @farmDashboardError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar dashboard'**
  String get farmDashboardError;

  /// No description provided for @farmStatusUpdated.
  ///
  /// In es, this message translates to:
  /// **'Estado actualizado a {status}'**
  String farmStatusUpdated(String status);

  /// No description provided for @farmErrorChangingStatus.
  ///
  /// In es, this message translates to:
  /// **'Error al cambiar el estado: {error}'**
  String farmErrorChangingStatus(Object error);

  /// No description provided for @farmErrorDeleting.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar granja: {error}'**
  String farmErrorDeleting(Object error);

  /// No description provided for @farmErrorLoadingFarms.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas: {error}'**
  String farmErrorLoadingFarms(Object error);

  /// No description provided for @farmConfirmInvitation.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Invitación'**
  String get farmConfirmInvitation;

  /// No description provided for @farmSelectRole.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Rol'**
  String get farmSelectRole;

  /// No description provided for @farmErrorVerifyingPermissions.
  ///
  /// In es, this message translates to:
  /// **'Error al verificar permisos: {error}'**
  String farmErrorVerifyingPermissions(Object error);

  /// No description provided for @farmManageCollaborators.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Colaboradores'**
  String get farmManageCollaborators;

  /// No description provided for @farmRefresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get farmRefresh;

  /// No description provided for @farmNoShedsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones registrados'**
  String get farmNoShedsRegistered;

  /// No description provided for @farmCreateFirstShed.
  ///
  /// In es, this message translates to:
  /// **'Crear Primer Galpón'**
  String get farmCreateFirstShed;

  /// No description provided for @farmNewShed.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Galpón'**
  String get farmNewShed;

  /// No description provided for @farmTemperature.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get farmTemperature;

  /// No description provided for @farmErrorOriginalData.
  ///
  /// In es, this message translates to:
  /// **'Error: No se pudo obtener los datos originales de la granja'**
  String get farmErrorOriginalData;

  /// No description provided for @shedName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Galpón *'**
  String get shedName;

  /// No description provided for @shedNameTooLong.
  ///
  /// In es, this message translates to:
  /// **'Nombre demasiado largo'**
  String get shedNameTooLong;

  /// No description provided for @shedType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Galpón *'**
  String get shedType;

  /// No description provided for @shedRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Registro'**
  String get shedRegistrationDate;

  /// No description provided for @shedNotFound.
  ///
  /// In es, this message translates to:
  /// **'Galpón no encontrado'**
  String get shedNotFound;

  /// No description provided for @shedDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get shedDetails;

  /// No description provided for @shedEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar galpón'**
  String get shedEditTooltip;

  /// No description provided for @shedDeleteShed.
  ///
  /// In es, this message translates to:
  /// **'Eliminar galpón'**
  String get shedDeleteShed;

  /// No description provided for @shedCreated.
  ///
  /// In es, this message translates to:
  /// **'Galpón creado'**
  String get shedCreated;

  /// No description provided for @shedDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Galpón eliminado correctamente'**
  String get shedDeletedSuccess;

  /// No description provided for @shedErrorDeleting.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String shedErrorDeleting(Object error);

  /// No description provided for @shedErrorChangingStatus.
  ///
  /// In es, this message translates to:
  /// **'Error al cambiar el estado: {error}'**
  String shedErrorChangingStatus(Object error);

  /// No description provided for @shedCreateShed.
  ///
  /// In es, this message translates to:
  /// **'Crear Galpón'**
  String get shedCreateShed;

  /// No description provided for @shedCreateShedTooltip.
  ///
  /// In es, this message translates to:
  /// **'Crear nuevo galpón'**
  String get shedCreateShedTooltip;

  /// No description provided for @shedSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, código o tipo...'**
  String get shedSearchHint;

  /// No description provided for @shedSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Lote'**
  String get shedSelectBatch;

  /// No description provided for @shedNoBatchesAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes disponibles'**
  String get shedNoBatchesAvailable;

  /// No description provided for @shedErrorLoadingBatches.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get shedErrorLoadingBatches;

  /// No description provided for @shedNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'Galpón no disponible ({status})'**
  String shedNotAvailable(Object status);

  /// No description provided for @shedScale.
  ///
  /// In es, this message translates to:
  /// **'Balanza'**
  String get shedScale;

  /// No description provided for @shedTemperatureSensor.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get shedTemperatureSensor;

  /// No description provided for @shedHumiditySensor.
  ///
  /// In es, this message translates to:
  /// **'Humedad'**
  String get shedHumiditySensor;

  /// No description provided for @shedCO2Sensor.
  ///
  /// In es, this message translates to:
  /// **'CO2'**
  String get shedCO2Sensor;

  /// No description provided for @shedAmmoniaSensor.
  ///
  /// In es, this message translates to:
  /// **'Amoníaco'**
  String get shedAmmoniaSensor;

  /// No description provided for @shedAddTag.
  ///
  /// In es, this message translates to:
  /// **'Agregar etiqueta'**
  String get shedAddTag;

  /// No description provided for @shedSearchInventory.
  ///
  /// In es, this message translates to:
  /// **'Buscar en inventario...'**
  String get shedSearchInventory;

  /// No description provided for @shedDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get shedDateLabel;

  /// No description provided for @shedStartDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get shedStartDate;

  /// No description provided for @shedMaintenanceDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción del mantenimiento *'**
  String get shedMaintenanceDescription;

  /// No description provided for @shedDisinfectionInfo.
  ///
  /// In es, this message translates to:
  /// **'Las operaciones serán limitadas.'**
  String get shedDisinfectionInfo;

  /// No description provided for @shedDisinfectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Poner en desinfección'**
  String get shedDisinfectionTitle;

  /// No description provided for @shedDisinfectionMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Poner \"{name}\" en desinfección?'**
  String shedDisinfectionMessage(Object name);

  /// No description provided for @shedMustSpecifyQuarantine.
  ///
  /// In es, this message translates to:
  /// **'Debe especificar el motivo de la cuarentena'**
  String get shedMustSpecifyQuarantine;

  /// No description provided for @shedErrorOriginalData.
  ///
  /// In es, this message translates to:
  /// **'Error: No se pudo obtener los datos originales del galpón'**
  String get shedErrorOriginalData;

  /// No description provided for @shedSemantics.
  ///
  /// In es, this message translates to:
  /// **'Galpón {name}, código {code}, {birds} aves, estado {status}'**
  String shedSemantics(String code, String birds, Object name, Object status);

  /// No description provided for @batchNoActiveSheds.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones activos disponibles'**
  String get batchNoActiveSheds;

  /// No description provided for @batchNoTransitions.
  ///
  /// In es, this message translates to:
  /// **'No hay transiciones disponibles desde este estado.'**
  String get batchNoTransitions;

  /// No description provided for @batchEnterValidQuantity.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una cantidad válida mayor a 0'**
  String get batchEnterValidQuantity;

  /// No description provided for @batchEnterFinalBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Ingrese la cantidad final de aves'**
  String get batchEnterFinalBirdCount;

  /// No description provided for @batchFieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get batchFieldRequired;

  /// No description provided for @batchEnterValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un número válido'**
  String get batchEnterValidNumber;

  /// No description provided for @batchNoRecordsMortality.
  ///
  /// In es, this message translates to:
  /// **'No hay registros de mortalidad'**
  String get batchNoRecordsMortality;

  /// No description provided for @batchLoadingFoods.
  ///
  /// In es, this message translates to:
  /// **'Cargando alimentos...'**
  String get batchLoadingFoods;

  /// No description provided for @batchNoFoodsInventory.
  ///
  /// In es, this message translates to:
  /// **'No hay alimentos en el inventario'**
  String get batchNoFoodsInventory;

  /// No description provided for @batchEnterValidCost.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un costo válido'**
  String get batchEnterValidCost;

  /// No description provided for @productionInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información de Producción'**
  String get productionInfoTitle;

  /// No description provided for @productionDailyCollection.
  ///
  /// In es, this message translates to:
  /// **'Registro diario de recolección de huevos'**
  String get productionDailyCollection;

  /// No description provided for @productionCannotExceedCollected.
  ///
  /// In es, this message translates to:
  /// **'No puede superar los recolectados'**
  String get productionCannotExceedCollected;

  /// No description provided for @productionRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del registro'**
  String get productionRegistrationDate;

  /// No description provided for @productionAcceptableYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento aceptable'**
  String get productionAcceptableYield;

  /// No description provided for @productionBelowExpected.
  ///
  /// In es, this message translates to:
  /// **'Postura por debajo del esperado'**
  String get productionBelowExpected;

  /// No description provided for @productionLayingIndicator.
  ///
  /// In es, this message translates to:
  /// **'Indicador de Postura'**
  String get productionLayingIndicator;

  /// No description provided for @productionEggClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación de Huevos'**
  String get productionEggClassification;

  /// No description provided for @productionQualitySizeDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de calidad y tamaño (opcional)'**
  String get productionQualitySizeDetail;

  /// No description provided for @productionDefectiveEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos Defectuosos'**
  String get productionDefectiveEggs;

  /// No description provided for @productionDirty.
  ///
  /// In es, this message translates to:
  /// **'Sucios'**
  String get productionDirty;

  /// No description provided for @productionSizeClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación por Tamaño'**
  String get productionSizeClassification;

  /// No description provided for @productionTotalToClassify.
  ///
  /// In es, this message translates to:
  /// **'Total a clasificar: {count} huevos buenos'**
  String productionTotalToClassify(Object count);

  /// No description provided for @productionClassificationSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Clasificación'**
  String get productionClassificationSummary;

  /// No description provided for @productionTotalClassified.
  ///
  /// In es, this message translates to:
  /// **'Total clasificados'**
  String get productionTotalClassified;

  /// No description provided for @productionAvgWeightCalculated.
  ///
  /// In es, this message translates to:
  /// **'Peso Promedio Calculado'**
  String get productionAvgWeightCalculated;

  /// No description provided for @productionObservationsEvidence.
  ///
  /// In es, this message translates to:
  /// **'Observaciones y Evidencia'**
  String get productionObservationsEvidence;

  /// No description provided for @productionSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Producción'**
  String get productionSummary;

  /// No description provided for @productionLayingPercentage.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de postura'**
  String get productionLayingPercentage;

  /// No description provided for @productionUtilization.
  ///
  /// In es, this message translates to:
  /// **'Aprovechamiento'**
  String get productionUtilization;

  /// No description provided for @productionAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get productionAvgWeight;

  /// No description provided for @productionNoPhotos.
  ///
  /// In es, this message translates to:
  /// **'No hay fotos agregadas'**
  String get productionNoPhotos;

  /// No description provided for @weightInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información del Pesaje'**
  String get weightInfoTitle;

  /// No description provided for @weightAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get weightAvgWeight;

  /// No description provided for @weightEnterAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el peso promedio'**
  String get weightEnterAvgWeight;

  /// No description provided for @weightBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves pesadas'**
  String get weightBirdCount;

  /// No description provided for @weightEnterBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad de aves'**
  String get weightEnterBirdCount;

  /// No description provided for @weightMethodLabel.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get weightMethodLabel;

  /// No description provided for @weightSelectMethod.
  ///
  /// In es, this message translates to:
  /// **'Seleccione el método'**
  String get weightSelectMethod;

  /// No description provided for @weightDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del pesaje'**
  String get weightDate;

  /// No description provided for @weightRangesTitle.
  ///
  /// In es, this message translates to:
  /// **'Rangos de Peso'**
  String get weightRangesTitle;

  /// No description provided for @weightMinMaxObserved.
  ///
  /// In es, this message translates to:
  /// **'Peso mínimo y máximo observado'**
  String get weightMinMaxObserved;

  /// No description provided for @weightEnterMinWeight.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el peso mínimo'**
  String get weightEnterMinWeight;

  /// No description provided for @weightEnterMaxWeight.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el peso máximo'**
  String get weightEnterMaxWeight;

  /// No description provided for @weightSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen del Pesaje'**
  String get weightSummaryTitle;

  /// No description provided for @weightReviewMetrics.
  ///
  /// In es, this message translates to:
  /// **'Revisa las métricas y agrega evidencia fotográfica'**
  String get weightReviewMetrics;

  /// No description provided for @weightImportantInfo.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get weightImportantInfo;

  /// No description provided for @weightTotalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso total'**
  String get weightTotalWeight;

  /// No description provided for @weightGDP.
  ///
  /// In es, this message translates to:
  /// **'GDP (Ganancia diaria)'**
  String get weightGDP;

  /// No description provided for @weightCoefficientVariation.
  ///
  /// In es, this message translates to:
  /// **'Coeficiente de variación'**
  String get weightCoefficientVariation;

  /// No description provided for @weightRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de peso'**
  String get weightRange;

  /// No description provided for @weightBirdsCounted.
  ///
  /// In es, this message translates to:
  /// **'Aves pesadas'**
  String get weightBirdsCounted;

  /// No description provided for @mortalityBasicDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles básicos del evento de mortalidad'**
  String get mortalityBasicDetails;

  /// No description provided for @salesEditLabel.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get salesEditLabel;

  /// No description provided for @salesDeleteLabel.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get salesDeleteLabel;

  /// No description provided for @salesSaleDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de venta'**
  String get salesSaleDate;

  /// No description provided for @salesDetailsOf.
  ///
  /// In es, this message translates to:
  /// **'Detalles de {product}'**
  String salesDetailsOf(String product);

  /// No description provided for @salesEnterDetails.
  ///
  /// In es, this message translates to:
  /// **'Ingresa cantidades, precios y otros detalles'**
  String get salesEnterDetails;

  /// No description provided for @salesBirdCountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get salesBirdCountLabel;

  /// No description provided for @salesBirdCountHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 100'**
  String get salesBirdCountHint;

  /// No description provided for @salesEnterBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad de aves'**
  String get salesEnterBirdCount;

  /// No description provided for @salesQuantityGreaterThanZero.
  ///
  /// In es, this message translates to:
  /// **'La cantidad debe ser mayor a 0'**
  String get salesQuantityGreaterThanZero;

  /// No description provided for @salesMaxQuantity.
  ///
  /// In es, this message translates to:
  /// **'La cantidad máxima es 1,000,000'**
  String get salesMaxQuantity;

  /// No description provided for @salesTotalWeightKg.
  ///
  /// In es, this message translates to:
  /// **'Peso total (kg)'**
  String get salesTotalWeightKg;

  /// No description provided for @salesDressedWeightKg.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado total (kg)'**
  String get salesDressedWeightKg;

  /// No description provided for @salesEnterTotalWeight.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el peso total'**
  String get salesEnterTotalWeight;

  /// No description provided for @salesWeightGreaterThanZero.
  ///
  /// In es, this message translates to:
  /// **'El peso debe ser mayor a 0'**
  String get salesWeightGreaterThanZero;

  /// No description provided for @salesMaxWeight.
  ///
  /// In es, this message translates to:
  /// **'El peso máximo es 50,000 kg'**
  String get salesMaxWeight;

  /// No description provided for @salesPricePerKgLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg ({currency})'**
  String salesPricePerKgLabel(String currency);

  /// No description provided for @salesNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'No hay una granja seleccionada. Por favor selecciona una granja primero.'**
  String get salesNoFarmSelected;

  /// No description provided for @salesNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos en esta granja.'**
  String get salesNoActiveBatches;

  /// No description provided for @salesErrorLoadingBatches.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes: {error}'**
  String salesErrorLoadingBatches(Object error);

  /// No description provided for @salesFormStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get salesFormStepDetails;

  /// No description provided for @salesUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Venta actualizada correctamente'**
  String get salesUpdatedSuccess;

  /// No description provided for @salesRegisteredSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Venta registrada exitosamente!'**
  String get salesRegisteredSuccess;

  /// No description provided for @salesInventoryUpdateError.
  ///
  /// In es, this message translates to:
  /// **'Venta registrada, pero hubo un error al actualizar inventario'**
  String get salesInventoryUpdateError;

  /// No description provided for @salesQuantityInvalid.
  ///
  /// In es, this message translates to:
  /// **'Cantidad inválida'**
  String get salesQuantityInvalid;

  /// No description provided for @salesQuantityExcessive.
  ///
  /// In es, this message translates to:
  /// **'Cantidad excesiva'**
  String get salesQuantityExcessive;

  /// No description provided for @salesPriceInvalid.
  ///
  /// In es, this message translates to:
  /// **'Precio inválido'**
  String get salesPriceInvalid;

  /// No description provided for @salesPriceExcessive.
  ///
  /// In es, this message translates to:
  /// **'Precio excesivo'**
  String get salesPriceExcessive;

  /// No description provided for @salesQuantityLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get salesQuantityLabel;

  /// No description provided for @salesPricePerDozen.
  ///
  /// In es, this message translates to:
  /// **'{currency} por docena'**
  String salesPricePerDozen(String currency);

  /// No description provided for @salesPollinazaQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad ({unit})'**
  String salesPollinazaQuantity(String unit);

  /// No description provided for @salesEnterQuantity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad'**
  String get salesEnterQuantity;

  /// No description provided for @salesPollinazaPricePerUnit.
  ///
  /// In es, this message translates to:
  /// **'Precio por {unit} ({currency})'**
  String salesPollinazaPricePerUnit(Object currency, Object unit);

  /// No description provided for @salesEditVenta.
  ///
  /// In es, this message translates to:
  /// **'Editar Venta'**
  String get salesEditVenta;

  /// No description provided for @salesLoadingError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la venta'**
  String get salesLoadingError;

  /// No description provided for @salesTotalHuevos.
  ///
  /// In es, this message translates to:
  /// **'Total huevos'**
  String get salesTotalHuevos;

  /// No description provided for @salesFaenadoWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado'**
  String get salesFaenadoWeight;

  /// No description provided for @salesYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento'**
  String get salesYield;

  /// No description provided for @salesUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get salesUnitPrice;

  /// No description provided for @salesRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get salesRegistrationDate;

  /// No description provided for @salesObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get salesObservations;

  /// No description provided for @costRegisteredSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo registrado correctamente'**
  String get costRegisteredSuccess;

  /// No description provided for @costUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo actualizado correctamente'**
  String get costUpdatedSuccess;

  /// No description provided for @costSelectExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un tipo de gasto'**
  String get costSelectExpenseType;

  /// No description provided for @costRegisterCost.
  ///
  /// In es, this message translates to:
  /// **'Registrar Costo'**
  String get costRegisterCost;

  /// No description provided for @costEditCost.
  ///
  /// In es, this message translates to:
  /// **'Editar Costo'**
  String get costEditCost;

  /// No description provided for @costFormStepType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get costFormStepType;

  /// No description provided for @costFormStepAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get costFormStepAmount;

  /// No description provided for @costFormStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get costFormStepDetails;

  /// No description provided for @costAmountTitle.
  ///
  /// In es, this message translates to:
  /// **'Monto del Gasto'**
  String get costAmountTitle;

  /// No description provided for @costConceptLabel.
  ///
  /// In es, this message translates to:
  /// **'Concepto del gasto'**
  String get costConceptLabel;

  /// No description provided for @costEnterConcept.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el concepto del gasto'**
  String get costEnterConcept;

  /// No description provided for @costEnterAmount.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el monto'**
  String get costEnterAmount;

  /// No description provided for @costEnterValidAmount.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un monto válido'**
  String get costEnterValidAmount;

  /// No description provided for @costDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha del gasto *'**
  String get costDateLabel;

  /// No description provided for @costRejectCost.
  ///
  /// In es, this message translates to:
  /// **'Rechazar Costo'**
  String get costRejectCost;

  /// No description provided for @costRejectReasonLabel.
  ///
  /// In es, this message translates to:
  /// **'Motivo del rechazo'**
  String get costRejectReasonLabel;

  /// No description provided for @costRejectReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Explica por qué se rechaza este costo'**
  String get costRejectReasonHint;

  /// No description provided for @costEnterRejectReason.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un motivo de rechazo'**
  String get costEnterRejectReason;

  /// No description provided for @costRejectBtn.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get costRejectBtn;

  /// No description provided for @costDeleteMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de eliminar el costo \"{concept}\"?\n\nEsta acción no se puede deshacer.'**
  String costDeleteMessage(String concept);

  /// No description provided for @costDeletedSuccessMsg.
  ///
  /// In es, this message translates to:
  /// **'Costo eliminado correctamente'**
  String get costDeletedSuccessMsg;

  /// No description provided for @costErrorDeleting.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String costErrorDeleting(Object error);

  /// No description provided for @costLotCosts.
  ///
  /// In es, this message translates to:
  /// **'Costos del Lote'**
  String get costLotCosts;

  /// No description provided for @costAllCosts.
  ///
  /// In es, this message translates to:
  /// **'Todos los Costos'**
  String get costAllCosts;

  /// No description provided for @costNoCostsDescription.
  ///
  /// In es, this message translates to:
  /// **'Registra tus gastos operativos para llevar un control detallado de los costos de producción'**
  String get costNoCostsDescription;

  /// No description provided for @costCostSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Costos'**
  String get costCostSummary;

  /// No description provided for @costTotalInCosts.
  ///
  /// In es, this message translates to:
  /// **'Total en costos'**
  String get costTotalInCosts;

  /// No description provided for @costApprovedCount.
  ///
  /// In es, this message translates to:
  /// **'Aprobados'**
  String get costApprovedCount;

  /// No description provided for @costPendingCount.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get costPendingCount;

  /// No description provided for @costTotalCount.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get costTotalCount;

  /// No description provided for @costUserNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get costUserNotAuthenticated;

  /// No description provided for @costErrorApproving.
  ///
  /// In es, this message translates to:
  /// **'Error al aprobar: {error}'**
  String costErrorApproving(Object error);

  /// No description provided for @costErrorRejecting.
  ///
  /// In es, this message translates to:
  /// **'Error al rechazar: {error}'**
  String costErrorRejecting(Object error);

  /// No description provided for @costTypeOfExpense.
  ///
  /// In es, this message translates to:
  /// **'Tipo de gasto'**
  String get costTypeOfExpense;

  /// No description provided for @costGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get costGeneralInfo;

  /// No description provided for @costRegistrationInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Registro'**
  String get costRegistrationInfo;

  /// No description provided for @costRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get costRegisteredBy;

  /// No description provided for @costRole.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get costRole;

  /// No description provided for @costRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get costRegistrationDate;

  /// No description provided for @costLastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get costLastUpdate;

  /// No description provided for @costNoStatus.
  ///
  /// In es, this message translates to:
  /// **'Sin estado'**
  String get costNoStatus;

  /// No description provided for @costStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get costStatusLabel;

  /// No description provided for @costLotNotFound.
  ///
  /// In es, this message translates to:
  /// **'Lote no encontrado'**
  String get costLotNotFound;

  /// No description provided for @costFarmNotFound.
  ///
  /// In es, this message translates to:
  /// **'Granja no encontrada'**
  String get costFarmNotFound;

  /// No description provided for @costProviderName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get costProviderName;

  /// No description provided for @costDeleteConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Costo'**
  String get costDeleteConfirmTitle;

  /// No description provided for @costDeleteConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este costo?\n\nEsta acción no se puede deshacer.'**
  String get costDeleteConfirmMessage;

  /// No description provided for @costLinkedProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto vinculado'**
  String get costLinkedProduct;

  /// No description provided for @costStockUpdateOnSave.
  ///
  /// In es, this message translates to:
  /// **'Se actualizará el stock al guardar'**
  String get costStockUpdateOnSave;

  /// No description provided for @costLinkToFoodInventory.
  ///
  /// In es, this message translates to:
  /// **'Vincular a alimento del inventario'**
  String get costLinkToFoodInventory;

  /// No description provided for @costLinkToMedicineInventory.
  ///
  /// In es, this message translates to:
  /// **'Vincular a medicamento del inventario'**
  String get costLinkToMedicineInventory;

  /// No description provided for @costAdditionalDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles Adicionales'**
  String get costAdditionalDetails;

  /// No description provided for @costComplementaryInfo.
  ///
  /// In es, this message translates to:
  /// **'Información complementaria del gasto'**
  String get costComplementaryInfo;

  /// No description provided for @costProviderLabel.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get costProviderLabel;

  /// No description provided for @costProviderRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del proveedor'**
  String get costProviderRequired;

  /// No description provided for @costProviderMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get costProviderMinLength;

  /// No description provided for @costObservationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get costObservationsLabel;

  /// No description provided for @costFieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get costFieldRequired;

  /// No description provided for @costDraftRestoreMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador guardado anteriormente?'**
  String get costDraftRestoreMessage;

  /// No description provided for @costSavedMomentAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace un momento'**
  String get costSavedMomentAgo;

  /// No description provided for @costSavedMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {minutes} min'**
  String costSavedMinutesAgo(String minutes);

  /// No description provided for @inventoryConfirmDefault.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get inventoryConfirmDefault;

  /// No description provided for @inventoryCancelDefault.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get inventoryCancelDefault;

  /// No description provided for @inventoryMovementType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de movimiento'**
  String get inventoryMovementType;

  /// No description provided for @inventoryEnterQuantity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una cantidad'**
  String get inventoryEnterQuantity;

  /// No description provided for @inventoryEnterValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido mayor a 0'**
  String get inventoryEnterValidNumber;

  /// No description provided for @inventoryQuantityExceedsStock.
  ///
  /// In es, this message translates to:
  /// **'Cantidad mayor al stock disponible'**
  String get inventoryQuantityExceedsStock;

  /// No description provided for @inventoryProviderLabel.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get inventoryProviderLabel;

  /// No description provided for @inventoryDeleteItem.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Item'**
  String get inventoryDeleteItem;

  /// No description provided for @inventoryNewStock.
  ///
  /// In es, this message translates to:
  /// **'Nuevo stock ({unit})'**
  String inventoryNewStock(Object unit);

  /// No description provided for @inventoryEntryRegistered.
  ///
  /// In es, this message translates to:
  /// **'Entrada registrada'**
  String get inventoryEntryRegistered;

  /// No description provided for @inventoryExitRegistered.
  ///
  /// In es, this message translates to:
  /// **'Salida registrada'**
  String get inventoryExitRegistered;

  /// No description provided for @inventoryNoItems.
  ///
  /// In es, this message translates to:
  /// **'No hay items que coincidan con los filtros'**
  String get inventoryNoItems;

  /// No description provided for @inventoryNoMovementsSearch.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos que coincidan con tu búsqueda'**
  String get inventoryNoMovementsSearch;

  /// No description provided for @inventoryNoMovements.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos registrados aún'**
  String get inventoryNoMovements;

  /// No description provided for @inventoryEditItem.
  ///
  /// In es, this message translates to:
  /// **'Editar Item'**
  String get inventoryEditItem;

  /// No description provided for @inventoryNoProductsAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay productos disponibles'**
  String get inventoryNoProductsAvailable;

  /// No description provided for @inventoryErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar inventario'**
  String get inventoryErrorLoading;

  /// No description provided for @inventoryHistoryError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar movimientos'**
  String get inventoryHistoryError;

  /// No description provided for @inventoryHistoryNoFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos con los filtros aplicados'**
  String get inventoryHistoryNoFilters;

  /// No description provided for @inventoryMovementTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de movimiento'**
  String get inventoryMovementTypeLabel;

  /// No description provided for @inventoryList.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get inventoryList;

  /// No description provided for @inventoryNoImage.
  ///
  /// In es, this message translates to:
  /// **'No hay imagen agregada'**
  String get inventoryNoImage;

  /// No description provided for @inventoryExpirationDateOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha de vencimiento (opcional)'**
  String get inventoryExpirationDateOptional;

  /// No description provided for @inventorySelectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get inventorySelectDate;

  /// No description provided for @inventoryAdditionalDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles Adicionales'**
  String get inventoryAdditionalDetails;

  /// No description provided for @inventoryStockSummary.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get inventoryStockSummary;

  /// No description provided for @inventoryTotalItems.
  ///
  /// In es, this message translates to:
  /// **'Total Items'**
  String get inventoryTotalItems;

  /// No description provided for @inventoryLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get inventoryLowStock;

  /// No description provided for @inventoryOutOfStock.
  ///
  /// In es, this message translates to:
  /// **'Agotados'**
  String get inventoryOutOfStock;

  /// No description provided for @inventoryExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Por Vencer'**
  String get inventoryExpiringSoon;

  /// No description provided for @inventoryDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get inventoryDescriptionLabel;

  /// No description provided for @inventoryRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get inventoryRegistrationDate;

  /// No description provided for @inventoryLastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get inventoryLastUpdate;

  /// No description provided for @inventoryRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get inventoryRegisteredBy;

  /// No description provided for @inventoryError.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String inventoryError(Object error);

  /// No description provided for @inventoryItemFormType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get inventoryItemFormType;

  /// No description provided for @inventoryItemFormBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get inventoryItemFormBasic;

  /// No description provided for @inventoryItemFormStock.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get inventoryItemFormStock;

  /// No description provided for @inventoryItemFormDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get inventoryItemFormDetails;

  /// No description provided for @inventoryImageError.
  ///
  /// In es, this message translates to:
  /// **'Error al seleccionar imagen'**
  String get inventoryImageError;

  /// No description provided for @inventoryImageUploadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir la imagen'**
  String get inventoryImageUploadFailed;

  /// No description provided for @inventoryImageSaveWithout.
  ///
  /// In es, this message translates to:
  /// **'El item se guardará sin imagen'**
  String get inventoryImageSaveWithout;

  /// No description provided for @inventorySaveBtn.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get inventorySaveBtn;

  /// No description provided for @healthSelectLocation.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Ubicación'**
  String get healthSelectLocation;

  /// No description provided for @healthSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Lote'**
  String get healthSelectBatch;

  /// No description provided for @healthErrorLoadingFarms.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas'**
  String get healthErrorLoadingFarms;

  /// No description provided for @healthNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos'**
  String get healthNoActiveBatches;

  /// No description provided for @commonNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get commonNext;

  /// No description provided for @commonPrevious.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get commonPrevious;

  /// No description provided for @commonSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get commonSaving;

  /// No description provided for @commonSavedJustNow.
  ///
  /// In es, this message translates to:
  /// **'Guardado ahora mismo'**
  String get commonSavedJustNow;

  /// No description provided for @commonSavedSecondsAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {seconds}s'**
  String commonSavedSecondsAgo(String seconds);

  /// No description provided for @commonSavedMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {minutes}m'**
  String commonSavedMinutesAgo(Object minutes);

  /// No description provided for @commonSavedHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {hours}h'**
  String commonSavedHoursAgo(String hours);

  /// No description provided for @commonExitWithoutComplete.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get commonExitWithoutComplete;

  /// No description provided for @commonVerifyConnection.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión a internet'**
  String get commonVerifyConnection;

  /// No description provided for @commonOperationSuccess.
  ///
  /// In es, this message translates to:
  /// **'Operación exitosa'**
  String get commonOperationSuccess;

  /// No description provided for @farmStartFirstFarm.
  ///
  /// In es, this message translates to:
  /// **'Comienza tu primera granja'**
  String get farmStartFirstFarm;

  /// No description provided for @farmStartFirstFarmDesc.
  ///
  /// In es, this message translates to:
  /// **'Registra tu granja avícola y comienza a gestionar tu producción de manera eficiente'**
  String get farmStartFirstFarmDesc;

  /// No description provided for @farmNoFarmsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron granjas'**
  String get farmNoFarmsFound;

  /// No description provided for @farmNoFarmsFoundHint.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar los filtros o buscar con otros términos'**
  String get farmNoFarmsFoundHint;

  /// No description provided for @farmCreateNewFarmTooltip.
  ///
  /// In es, this message translates to:
  /// **'Crear nueva granja'**
  String get farmCreateNewFarmTooltip;

  /// No description provided for @farmDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Granja eliminada correctamente'**
  String get farmDeletedSuccess;

  /// No description provided for @farmFarmNotExists.
  ///
  /// In es, this message translates to:
  /// **'La granja solicitada no existe'**
  String get farmFarmNotExists;

  /// No description provided for @farmGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get farmGeneralInfo;

  /// No description provided for @farmNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get farmNotes;

  /// No description provided for @farmActivate.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get farmActivate;

  /// No description provided for @farmActivateFarm.
  ///
  /// In es, this message translates to:
  /// **'Activar granja'**
  String get farmActivateFarm;

  /// No description provided for @farmActivateConfirmMsg.
  ///
  /// In es, this message translates to:
  /// **'¿Activar \"{name}\"?'**
  String farmActivateConfirmMsg(Object name);

  /// No description provided for @farmActivateInfo.
  ///
  /// In es, this message translates to:
  /// **'Podrás operar normalmente.'**
  String get farmActivateInfo;

  /// No description provided for @farmSuspend.
  ///
  /// In es, this message translates to:
  /// **'Suspender'**
  String get farmSuspend;

  /// No description provided for @farmSuspendFarm.
  ///
  /// In es, this message translates to:
  /// **'Suspender granja'**
  String get farmSuspendFarm;

  /// No description provided for @farmSuspendConfirmMsg.
  ///
  /// In es, this message translates to:
  /// **'¿Suspender \"{name}\"?'**
  String farmSuspendConfirmMsg(Object name);

  /// No description provided for @farmSuspendInfo.
  ///
  /// In es, this message translates to:
  /// **'No podrás crear nuevos lotes.'**
  String get farmSuspendInfo;

  /// No description provided for @farmMaintenanceFarm.
  ///
  /// In es, this message translates to:
  /// **'Poner en mantenimiento'**
  String get farmMaintenanceFarm;

  /// No description provided for @farmMaintenanceConfirmMsg.
  ///
  /// In es, this message translates to:
  /// **'¿Poner \"{name}\" en mantenimiento?'**
  String farmMaintenanceConfirmMsg(Object name);

  /// No description provided for @farmMaintenanceInfo.
  ///
  /// In es, this message translates to:
  /// **'Las operaciones serán limitadas.'**
  String get farmMaintenanceInfo;

  /// No description provided for @farmDeleteConfirmName.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{name}\"?'**
  String farmDeleteConfirmName(Object name);

  /// No description provided for @farmDeleteIrreversible.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible:'**
  String get farmDeleteIrreversible;

  /// No description provided for @farmDeleteWillRemoveShedsAll.
  ///
  /// In es, this message translates to:
  /// **'• Se eliminarán todos los galpones\n• Se eliminarán todos los lotes\n• Se eliminarán todos los registros'**
  String get farmDeleteWillRemoveShedsAll;

  /// No description provided for @farmWriteNameToConfirm.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre para confirmar:'**
  String get farmWriteNameToConfirm;

  /// No description provided for @farmWriteHere.
  ///
  /// In es, this message translates to:
  /// **'Escribe aquí'**
  String get farmWriteHere;

  /// No description provided for @farmAlreadyActive.
  ///
  /// In es, this message translates to:
  /// **'La granja ya está activa'**
  String get farmAlreadyActive;

  /// No description provided for @farmAlreadySuspended.
  ///
  /// In es, this message translates to:
  /// **'La granja ya está suspendida'**
  String get farmAlreadySuspended;

  /// No description provided for @farmActivatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Granja activada exitosamente'**
  String get farmActivatedSuccess;

  /// No description provided for @farmSuspendedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Granja suspendida exitosamente'**
  String get farmSuspendedSuccess;

  /// No description provided for @farmMaintenanceSuccess.
  ///
  /// In es, this message translates to:
  /// **'Granja puesta en mantenimiento'**
  String get farmMaintenanceSuccess;

  /// No description provided for @farmDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get farmDraftFound;

  /// No description provided for @farmDraftFoundMsg.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String farmDraftFoundMsg(String date);

  /// No description provided for @farmTodayAt.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {time}'**
  String farmTodayAt(String time);

  /// No description provided for @farmYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get farmYesterday;

  /// No description provided for @farmDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String farmDaysAgo(String days);

  /// No description provided for @farmEnterBasicData.
  ///
  /// In es, this message translates to:
  /// **'Ingresa los datos principales de tu granja avícola'**
  String get farmEnterBasicData;

  /// No description provided for @farmInfoUsedToIdentify.
  ///
  /// In es, this message translates to:
  /// **'Estos datos se utilizarán para identificar tu granja en el sistema.'**
  String get farmInfoUsedToIdentify;

  /// No description provided for @farmUserNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get farmUserNotAuthenticated;

  /// No description provided for @farmFilterAll.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get farmFilterAll;

  /// No description provided for @farmFilterActive.
  ///
  /// In es, this message translates to:
  /// **'Activas'**
  String get farmFilterActive;

  /// No description provided for @farmFilterInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactivas'**
  String get farmFilterInactive;

  /// No description provided for @farmFilterMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get farmFilterMaintenance;

  /// No description provided for @farmSemantics.
  ///
  /// In es, this message translates to:
  /// **'Granja {name}, estado {status}'**
  String farmSemantics(Object name, Object status);

  /// No description provided for @farmViewSheds.
  ///
  /// In es, this message translates to:
  /// **'Ver Galpones'**
  String get farmViewSheds;

  /// No description provided for @farmStatusActiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Operando normalmente'**
  String get farmStatusActiveDesc;

  /// No description provided for @farmStatusInactiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Operaciones suspendidas'**
  String get farmStatusInactiveDesc;

  /// No description provided for @farmStatusMaintenanceDesc.
  ///
  /// In es, this message translates to:
  /// **'En proceso de mantenimiento'**
  String get farmStatusMaintenanceDesc;

  /// No description provided for @farmContinueEditing.
  ///
  /// In es, this message translates to:
  /// **'Continuar editando'**
  String get farmContinueEditing;

  /// No description provided for @farmSelectCountry.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el país'**
  String get farmSelectCountry;

  /// No description provided for @farmSelectDepartment.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el departamento'**
  String get farmSelectDepartment;

  /// No description provided for @farmSelectCity.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la ciudad'**
  String get farmSelectCity;

  /// No description provided for @farmEnterAddress.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la dirección'**
  String get farmEnterAddress;

  /// No description provided for @farmAddressMinLength.
  ///
  /// In es, this message translates to:
  /// **'La dirección debe tener al menos 10 caracteres'**
  String get farmAddressMinLength;

  /// No description provided for @farmEnterEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el correo electrónico'**
  String get farmEnterEmail;

  /// No description provided for @farmEnterValidEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo válido'**
  String get farmEnterValidEmail;

  /// No description provided for @farmEnterPhone.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el teléfono'**
  String get farmEnterPhone;

  /// No description provided for @farmPhoneLength.
  ///
  /// In es, this message translates to:
  /// **'El teléfono debe tener {length} dígitos'**
  String farmPhoneLength(String length);

  /// No description provided for @farmOnlyActiveCanMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Solo se puede poner en mantenimiento una granja activa'**
  String get farmOnlyActiveCanMaintenance;

  /// No description provided for @farmInfoCopiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Información copiada al portapapeles'**
  String get farmInfoCopiedToClipboard;

  /// No description provided for @farmTotalOccupation.
  ///
  /// In es, this message translates to:
  /// **'Ocupación Total'**
  String get farmTotalOccupation;

  /// No description provided for @farmBirds.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get farmBirds;

  /// No description provided for @farmOfCapacityBirds.
  ///
  /// In es, this message translates to:
  /// **'de {capacity} aves'**
  String farmOfCapacityBirds(String capacity);

  /// No description provided for @farmActiveSheds.
  ///
  /// In es, this message translates to:
  /// **'Casas Activas'**
  String get farmActiveSheds;

  /// No description provided for @farmOfTotal.
  ///
  /// In es, this message translates to:
  /// **'de {total}'**
  String farmOfTotal(String total);

  /// No description provided for @farmBatchesInProduction.
  ///
  /// In es, this message translates to:
  /// **'Lotes en Producción'**
  String get farmBatchesInProduction;

  /// No description provided for @farmMoreSheds.
  ///
  /// In es, this message translates to:
  /// **'+ {count} galpón(es) más'**
  String farmMoreSheds(Object count);

  /// No description provided for @shedOccupation.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get shedOccupation;

  /// No description provided for @shedBirdsCount.
  ///
  /// In es, this message translates to:
  /// **'{current} / {max} aves'**
  String shedBirdsCount(String current, Object max);

  /// No description provided for @commonViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver Todos'**
  String get commonViewAll;

  /// No description provided for @commonErrorWithDetail.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String commonErrorWithDetail(Object error);

  /// No description provided for @commonSummary2.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get commonSummary2;

  /// No description provided for @commonMaintShort.
  ///
  /// In es, this message translates to:
  /// **'Mant.'**
  String get commonMaintShort;

  /// No description provided for @commonMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get commonMaintenance;

  /// No description provided for @commonNotDefined.
  ///
  /// In es, this message translates to:
  /// **'No definido'**
  String get commonNotDefined;

  /// No description provided for @commonOccurredError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error'**
  String get commonOccurredError;

  /// No description provided for @commonFieldIsRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get commonFieldIsRequired;

  /// No description provided for @commonFieldRequired2.
  ///
  /// In es, this message translates to:
  /// **'{label} es requerido'**
  String commonFieldRequired2(String label);

  /// No description provided for @commonSelect.
  ///
  /// In es, this message translates to:
  /// **'Selecciona {field}'**
  String commonSelect(String field);

  /// No description provided for @commonFirstSelect.
  ///
  /// In es, this message translates to:
  /// **'Primero selecciona {field}'**
  String commonFirstSelect(Object field);

  /// No description provided for @commonMustBeValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Debe ser un número válido'**
  String get commonMustBeValidNumber;

  /// No description provided for @commonMustBeBetween.
  ///
  /// In es, this message translates to:
  /// **'Debe estar entre {min} y {max}'**
  String commonMustBeBetween(String min, Object max);

  /// No description provided for @commonEnterValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido'**
  String get commonEnterValidNumber;

  /// No description provided for @commonVerifying.
  ///
  /// In es, this message translates to:
  /// **'Verificando...'**
  String get commonVerifying;

  /// No description provided for @commonJoining.
  ///
  /// In es, this message translates to:
  /// **'Uniéndose...'**
  String get commonJoining;

  /// No description provided for @commonUpdate2.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get commonUpdate2;

  /// No description provided for @commonRefresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get commonRefresh;

  /// No description provided for @commonYouTag.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get commonYouTag;

  /// No description provided for @commonNoName.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get commonNoName;

  /// No description provided for @commonNoEmail.
  ///
  /// In es, this message translates to:
  /// **'Sin correo'**
  String get commonNoEmail;

  /// No description provided for @commonSince.
  ///
  /// In es, this message translates to:
  /// **'Desde: {date}'**
  String commonSince(Object date);

  /// No description provided for @commonPermissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos'**
  String get commonPermissions;

  /// No description provided for @commonSelected.
  ///
  /// In es, this message translates to:
  /// **'Seleccionado'**
  String get commonSelected;

  /// No description provided for @commonShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get commonShare;

  /// No description provided for @commonValidUntil.
  ///
  /// In es, this message translates to:
  /// **'Válido hasta {date}'**
  String commonValidUntil(Object date);

  /// No description provided for @farmEnvironmentalThresholds.
  ///
  /// In es, this message translates to:
  /// **'Umbrales Ambientales'**
  String get farmEnvironmentalThresholds;

  /// No description provided for @farmHumidity.
  ///
  /// In es, this message translates to:
  /// **'Humedad'**
  String get farmHumidity;

  /// No description provided for @farmCo2Max.
  ///
  /// In es, this message translates to:
  /// **'CO₂ Máximo'**
  String get farmCo2Max;

  /// No description provided for @farmAmmoniaMax.
  ///
  /// In es, this message translates to:
  /// **'Amoníaco Máximo'**
  String get farmAmmoniaMax;

  /// No description provided for @farmCapacityInstallations.
  ///
  /// In es, this message translates to:
  /// **'Capacidad e Instalaciones'**
  String get farmCapacityInstallations;

  /// No description provided for @farmTechnicalDataOptional.
  ///
  /// In es, this message translates to:
  /// **'Datos técnicos de la granja (todos opcionales)'**
  String get farmTechnicalDataOptional;

  /// No description provided for @farmMaxBirdCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Máxima de Aves'**
  String get farmMaxBirdCapacity;

  /// No description provided for @farmMaxBirdsLimit.
  ///
  /// In es, this message translates to:
  /// **'Máximo 1,000,000 aves'**
  String get farmMaxBirdsLimit;

  /// No description provided for @farmTotalArea.
  ///
  /// In es, this message translates to:
  /// **'Área Total'**
  String get farmTotalArea;

  /// No description provided for @farmNumberOfSheds.
  ///
  /// In es, this message translates to:
  /// **'Número de Galpones'**
  String get farmNumberOfSheds;

  /// No description provided for @farmShedsUnit.
  ///
  /// In es, this message translates to:
  /// **'galpones'**
  String get farmShedsUnit;

  /// No description provided for @farmMaxShedsLimit.
  ///
  /// In es, this message translates to:
  /// **'Máximo 100 galpones'**
  String get farmMaxShedsLimit;

  /// No description provided for @farmUsefulInfo.
  ///
  /// In es, this message translates to:
  /// **'Información útil'**
  String get farmUsefulInfo;

  /// No description provided for @farmTechnicalDataHelp.
  ///
  /// In es, this message translates to:
  /// **'Estos datos ayudarán a planificar lotes y calcular densidad poblacional.'**
  String get farmTechnicalDataHelp;

  /// No description provided for @farmPreciseLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación precisa'**
  String get farmPreciseLocation;

  /// No description provided for @farmLocationHelp.
  ///
  /// In es, this message translates to:
  /// **'Una ubicación correcta facilita la logística y visitas técnicas.'**
  String get farmLocationHelp;

  /// No description provided for @farmExactLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación exacta de la granja'**
  String get farmExactLocation;

  /// No description provided for @farmAddress.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get farmAddress;

  /// No description provided for @farmAddressHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Av. Principal 123, Urbanización...'**
  String get farmAddressHint;

  /// No description provided for @farmReferenceOptional.
  ///
  /// In es, this message translates to:
  /// **'Referencia (opcional)'**
  String get farmReferenceOptional;

  /// No description provided for @farmReferenceHint.
  ///
  /// In es, this message translates to:
  /// **'Cerca de..., frente a..., a 2 cuadras de...'**
  String get farmReferenceHint;

  /// No description provided for @farmGpsCoordinatesOptional.
  ///
  /// In es, this message translates to:
  /// **'Coordenadas GPS (opcional)'**
  String get farmGpsCoordinatesOptional;

  /// No description provided for @farmLatitude.
  ///
  /// In es, this message translates to:
  /// **'Latitud'**
  String get farmLatitude;

  /// No description provided for @farmLatitudeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: -12.0464'**
  String get farmLatitudeHint;

  /// No description provided for @farmLongitude.
  ///
  /// In es, this message translates to:
  /// **'Longitud'**
  String get farmLongitude;

  /// No description provided for @farmLongitudeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: -77.0428'**
  String get farmLongitudeHint;

  /// No description provided for @farmContactInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Contacto'**
  String get farmContactInfo;

  /// No description provided for @farmContactInfoDesc.
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto para comunicación'**
  String get farmContactInfoDesc;

  /// No description provided for @farmEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get farmEmailLabel;

  /// No description provided for @farmEmailHint.
  ///
  /// In es, this message translates to:
  /// **'ejemplo@correo.com'**
  String get farmEmailHint;

  /// No description provided for @farmWhatsappOptional.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp (opcional)'**
  String get farmWhatsappOptional;

  /// No description provided for @farmContactDataTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto'**
  String get farmContactDataTitle;

  /// No description provided for @farmContactDataHelp.
  ///
  /// In es, this message translates to:
  /// **'Esta información se usará para notificaciones importantes.'**
  String get farmContactDataHelp;

  /// No description provided for @farmPhoneLabel.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get farmPhoneLabel;

  /// No description provided for @farmFiscalDocOptional.
  ///
  /// In es, this message translates to:
  /// **'{label} (opcional)'**
  String farmFiscalDocOptional(Object label);

  /// No description provided for @farmInvalidRifFormat.
  ///
  /// In es, this message translates to:
  /// **'Formato de RIF inválido (ej: J-12345678-9)'**
  String get farmInvalidRifFormat;

  /// No description provided for @farmRucMustHaveDigits.
  ///
  /// In es, this message translates to:
  /// **'El RUC debe tener {count} dígitos'**
  String farmRucMustHaveDigits(Object count);

  /// No description provided for @farmInvalidNitFormat.
  ///
  /// In es, this message translates to:
  /// **'Formato de NIT inválido (ej: 900123456-7)'**
  String get farmInvalidNitFormat;

  /// No description provided for @farmRucMustStartWith.
  ///
  /// In es, this message translates to:
  /// **'El RUC debe iniciar con 10, 15, 17 o 20'**
  String get farmRucMustStartWith;

  /// No description provided for @farmCapacityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 10000'**
  String get farmCapacityHint;

  /// No description provided for @farmAreaHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 5000'**
  String get farmAreaHint;

  /// No description provided for @farmShedsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 5'**
  String get farmShedsHint;

  /// No description provided for @farmActiveFarmsLabel.
  ///
  /// In es, this message translates to:
  /// **'Activas'**
  String get farmActiveFarmsLabel;

  /// No description provided for @farmInactiveFarmsLabel.
  ///
  /// In es, this message translates to:
  /// **'Inactivas'**
  String get farmInactiveFarmsLabel;

  /// No description provided for @farmStatusActive.
  ///
  /// In es, this message translates to:
  /// **'Activa'**
  String get farmStatusActive;

  /// No description provided for @farmStatusInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactiva'**
  String get farmStatusInactive;

  /// No description provided for @farmOverpopulationDetected.
  ///
  /// In es, this message translates to:
  /// **'Sobrepoblación detectada'**
  String get farmOverpopulationDetected;

  /// No description provided for @farmOutdatedData.
  ///
  /// In es, this message translates to:
  /// **'Datos desactualizados'**
  String get farmOutdatedData;

  /// No description provided for @farmShedsWithoutBatches.
  ///
  /// In es, this message translates to:
  /// **'Galpones sin lotes asignados'**
  String get farmShedsWithoutBatches;

  /// No description provided for @farmLoadDashboardError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar dashboard'**
  String get farmLoadDashboardError;

  /// No description provided for @farmActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'Lotes Activos'**
  String get farmActiveBatches;

  /// No description provided for @farmActiveShedsLabel.
  ///
  /// In es, this message translates to:
  /// **'Galpones Activos'**
  String get farmActiveShedsLabel;

  /// No description provided for @farmAlertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get farmAlertsTitle;

  /// No description provided for @farmInviteUser.
  ///
  /// In es, this message translates to:
  /// **'Invitar Usuario'**
  String get farmInviteUser;

  /// No description provided for @farmMustLoginToInvite.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión para invitar usuarios'**
  String get farmMustLoginToInvite;

  /// No description provided for @farmNoPermToInvite.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para invitar usuarios a esta granja.\nSolo propietarios, administradores y gestores pueden invitar.'**
  String get farmNoPermToInvite;

  /// No description provided for @farmNoPermissions.
  ///
  /// In es, this message translates to:
  /// **'Sin Permisos'**
  String get farmNoPermissions;

  /// No description provided for @farmWhatRoleWillUserHave.
  ///
  /// In es, this message translates to:
  /// **'¿Qué rol tendrá el usuario?'**
  String get farmWhatRoleWillUserHave;

  /// No description provided for @farmChoosePermissions.
  ///
  /// In es, this message translates to:
  /// **'Elige los permisos que tendrá en tu granja'**
  String get farmChoosePermissions;

  /// No description provided for @farmRoleFullControl.
  ///
  /// In es, this message translates to:
  /// **'Control total de la granja'**
  String get farmRoleFullControl;

  /// No description provided for @farmRoleFullManagement.
  ///
  /// In es, this message translates to:
  /// **'Gestión completa, sin transferir propiedad'**
  String get farmRoleFullManagement;

  /// No description provided for @farmRoleOperationsMgmt.
  ///
  /// In es, this message translates to:
  /// **'Gestión de operaciones y personal'**
  String get farmRoleOperationsMgmt;

  /// No description provided for @farmRoleDailyRecords.
  ///
  /// In es, this message translates to:
  /// **'Registros diarios y tareas operativas'**
  String get farmRoleDailyRecords;

  /// No description provided for @farmRoleViewOnly.
  ///
  /// In es, this message translates to:
  /// **'Solo visualización de datos'**
  String get farmRoleViewOnly;

  /// No description provided for @farmPermAll.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get farmPermAll;

  /// No description provided for @farmPermEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get farmPermEdit;

  /// No description provided for @farmPermInvite.
  ///
  /// In es, this message translates to:
  /// **'Invitar'**
  String get farmPermInvite;

  /// No description provided for @farmPermManage.
  ///
  /// In es, this message translates to:
  /// **'Gestionar'**
  String get farmPermManage;

  /// No description provided for @farmPermRecords.
  ///
  /// In es, this message translates to:
  /// **'Registros'**
  String get farmPermRecords;

  /// No description provided for @farmPermView.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get farmPermView;

  /// No description provided for @farmPermViewData.
  ///
  /// In es, this message translates to:
  /// **'Ver datos'**
  String get farmPermViewData;

  /// No description provided for @farmPermReadOnly.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura'**
  String get farmPermReadOnly;

  /// No description provided for @farmVerifyPermError.
  ///
  /// In es, this message translates to:
  /// **'Error al verificar permisos: {error}'**
  String farmVerifyPermError(Object error);

  /// No description provided for @farmGenerateCode.
  ///
  /// In es, this message translates to:
  /// **'Generar Código'**
  String get farmGenerateCode;

  /// No description provided for @farmGenerateNewCode.
  ///
  /// In es, this message translates to:
  /// **'Generar nuevo código'**
  String get farmGenerateNewCode;

  /// No description provided for @farmCodeGenerated.
  ///
  /// In es, this message translates to:
  /// **'¡Código generado!'**
  String get farmCodeGenerated;

  /// No description provided for @farmInvitationSubject.
  ///
  /// In es, this message translates to:
  /// **'Invitación a {farmName}'**
  String farmInvitationSubject(Object farmName);

  /// No description provided for @farmInvitationMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Te invito a colaborar en mi granja \"{farmName}\"! Usa el código: {code}\nRol: {role}\nVálido hasta: {expiry}'**
  String farmInvitationMessage(
    String farmName,
    String code,
    String role,
    String expiry,
  );

  /// No description provided for @farmCollaboratorsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} colaborador(es)'**
  String farmCollaboratorsCount(Object count);

  /// No description provided for @farmInviteCollaboratorToFarm.
  ///
  /// In es, this message translates to:
  /// **'Invitar colaborador a la granja'**
  String get farmInviteCollaboratorToFarm;

  /// No description provided for @farmNoCollaborators.
  ///
  /// In es, this message translates to:
  /// **'Sin colaboradores'**
  String get farmNoCollaborators;

  /// No description provided for @farmInviteHelpText.
  ///
  /// In es, this message translates to:
  /// **'Invita a otros usuarios para que puedan ayudarte a gestionar esta granja.'**
  String get farmInviteHelpText;

  /// No description provided for @farmChangeRoleTo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar rol a:'**
  String get farmChangeRoleTo;

  /// No description provided for @farmLeaveFarm.
  ///
  /// In es, this message translates to:
  /// **'Abandonar granja'**
  String get farmLeaveFarm;

  /// No description provided for @farmRemoveUser.
  ///
  /// In es, this message translates to:
  /// **'Remover usuario'**
  String get farmRemoveUser;

  /// No description provided for @farmCannotChangeOwnerRole.
  ///
  /// In es, this message translates to:
  /// **'No se puede cambiar el rol del propietario'**
  String get farmCannotChangeOwnerRole;

  /// No description provided for @farmCannotRemoveOwner.
  ///
  /// In es, this message translates to:
  /// **'No se puede remover al propietario'**
  String get farmCannotRemoveOwner;

  /// No description provided for @farmRemoveCollaborator.
  ///
  /// In es, this message translates to:
  /// **'Remover Colaborador'**
  String get farmRemoveCollaborator;

  /// No description provided for @farmConfirmLeave.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas abandonar esta granja?'**
  String get farmConfirmLeave;

  /// No description provided for @farmConfirmRemoveUser.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas remover a este usuario?'**
  String get farmConfirmRemoveUser;

  /// No description provided for @farmLeaveAction.
  ///
  /// In es, this message translates to:
  /// **'Abandonar'**
  String get farmLeaveAction;

  /// No description provided for @farmRemoveAction.
  ///
  /// In es, this message translates to:
  /// **'Remover'**
  String get farmRemoveAction;

  /// No description provided for @farmLeftFarm.
  ///
  /// In es, this message translates to:
  /// **'Has abandonado la granja'**
  String get farmLeftFarm;

  /// No description provided for @farmCollaboratorRemoved.
  ///
  /// In es, this message translates to:
  /// **'Colaborador removido'**
  String get farmCollaboratorRemoved;

  /// No description provided for @farmJoinFarm.
  ///
  /// In es, this message translates to:
  /// **'Unirse a Granja'**
  String get farmJoinFarm;

  /// No description provided for @farmCodeValid.
  ///
  /// In es, this message translates to:
  /// **'¡Código válido!'**
  String get farmCodeValid;

  /// No description provided for @farmInvitedBy.
  ///
  /// In es, this message translates to:
  /// **'Invitado por'**
  String get farmInvitedBy;

  /// No description provided for @farmWhatRoleYouWillHave.
  ///
  /// In es, this message translates to:
  /// **'¿Qué rol tendrás?'**
  String get farmWhatRoleYouWillHave;

  /// No description provided for @farmJoinTheFarm.
  ///
  /// In es, this message translates to:
  /// **'Unirse a la Granja'**
  String get farmJoinTheFarm;

  /// No description provided for @farmUseAnotherCode.
  ///
  /// In es, this message translates to:
  /// **'Usar otro código'**
  String get farmUseAnotherCode;

  /// No description provided for @farmWelcome.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido!'**
  String get farmWelcome;

  /// No description provided for @farmJoinedSuccessTo.
  ///
  /// In es, this message translates to:
  /// **'Te has unido exitosamente a'**
  String get farmJoinedSuccessTo;

  /// No description provided for @farmAsRole.
  ///
  /// In es, this message translates to:
  /// **'Como {role}'**
  String farmAsRole(Object role);

  /// No description provided for @farmViewMyFarms.
  ///
  /// In es, this message translates to:
  /// **'Ver Mis Granjas'**
  String get farmViewMyFarms;

  /// No description provided for @farmHaveInvitation.
  ///
  /// In es, this message translates to:
  /// **'¿Tienes una invitación?'**
  String get farmHaveInvitation;

  /// No description provided for @farmEnterSharedCode.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código que te compartieron para unirte a una granja'**
  String get farmEnterSharedCode;

  /// No description provided for @farmInvitationCode.
  ///
  /// In es, this message translates to:
  /// **'Código de Invitación'**
  String get farmInvitationCode;

  /// No description provided for @farmVerifyCode.
  ///
  /// In es, this message translates to:
  /// **'Verificar Código'**
  String get farmVerifyCode;

  /// No description provided for @farmEnterValidCode.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un código válido'**
  String get farmEnterValidCode;

  /// No description provided for @farmInvalidCodeFormat.
  ///
  /// In es, this message translates to:
  /// **'El formato del código no es válido'**
  String get farmInvalidCodeFormat;

  /// No description provided for @farmCodeNotFound.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación no encontrado'**
  String get farmCodeNotFound;

  /// No description provided for @farmCodeAlreadyUsed.
  ///
  /// In es, this message translates to:
  /// **'Este código ya ha sido utilizado'**
  String get farmCodeAlreadyUsed;

  /// No description provided for @farmCodeExpired.
  ///
  /// In es, this message translates to:
  /// **'Este código ha expirado'**
  String get farmCodeExpired;

  /// No description provided for @farmCodeNotValidOrExpired.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación no válido o expirado'**
  String get farmCodeNotValidOrExpired;

  /// No description provided for @farmCodeHasExpiredLong.
  ///
  /// In es, this message translates to:
  /// **'Este código de invitación ha expirado'**
  String get farmCodeHasExpiredLong;

  /// No description provided for @farmMustLoginToAccept.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión para aceptar invitaciones'**
  String get farmMustLoginToAccept;

  /// No description provided for @farmAlreadyMember.
  ///
  /// In es, this message translates to:
  /// **'Ya eres miembro de esta granja'**
  String get farmAlreadyMember;

  /// No description provided for @farmAssigned.
  ///
  /// In es, this message translates to:
  /// **'Asignado'**
  String get farmAssigned;

  /// No description provided for @farmGranjaLabel.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get farmGranjaLabel;

  /// No description provided for @farmPermFullControl.
  ///
  /// In es, this message translates to:
  /// **'Control total'**
  String get farmPermFullControl;

  /// No description provided for @farmPermFullManagement.
  ///
  /// In es, this message translates to:
  /// **'Gestión completa'**
  String get farmPermFullManagement;

  /// No description provided for @farmPermDeleteFarm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar granja'**
  String get farmPermDeleteFarm;

  /// No description provided for @farmPermEditData.
  ///
  /// In es, this message translates to:
  /// **'Editar datos'**
  String get farmPermEditData;

  /// No description provided for @farmPermInviteUsers.
  ///
  /// In es, this message translates to:
  /// **'Invitar usuarios'**
  String get farmPermInviteUsers;

  /// No description provided for @farmPermManageCollaborators.
  ///
  /// In es, this message translates to:
  /// **'Gestionar colaboradores'**
  String get farmPermManageCollaborators;

  /// No description provided for @farmPermViewRecords.
  ///
  /// In es, this message translates to:
  /// **'Ver registros'**
  String get farmPermViewRecords;

  /// No description provided for @farmPermCreateRecords.
  ///
  /// In es, this message translates to:
  /// **'Crear registros'**
  String get farmPermCreateRecords;

  /// No description provided for @farmPermRegisterTasks.
  ///
  /// In es, this message translates to:
  /// **'Registrar tareas'**
  String get farmPermRegisterTasks;

  /// No description provided for @farmPermViewStats.
  ///
  /// In es, this message translates to:
  /// **'Ver estadísticas'**
  String get farmPermViewStats;

  /// No description provided for @farmPermissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos'**
  String get farmPermissions;

  /// No description provided for @commonGoToHome.
  ///
  /// In es, this message translates to:
  /// **'Ir al Inicio'**
  String get commonGoToHome;

  /// No description provided for @farmTheFarm.
  ///
  /// In es, this message translates to:
  /// **'la granja'**
  String get farmTheFarm;

  /// No description provided for @commonCheckConnection.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión.'**
  String get commonCheckConnection;

  /// No description provided for @commonExitWithoutSaving.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin guardar?'**
  String get commonExitWithoutSaving;

  /// No description provided for @commonYouHaveUnsavedChanges.
  ///
  /// In es, this message translates to:
  /// **'Tienes cambios sin guardar.'**
  String get commonYouHaveUnsavedChanges;

  /// No description provided for @commonContinueEditing.
  ///
  /// In es, this message translates to:
  /// **'Continuar editando'**
  String get commonContinueEditing;

  /// No description provided for @commonNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get commonNotes;

  /// No description provided for @commonJustNow.
  ///
  /// In es, this message translates to:
  /// **'ahora mismo'**
  String get commonJustNow;

  /// No description provided for @commonSecondsAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {seconds}s'**
  String commonSecondsAgo(Object seconds);

  /// No description provided for @commonMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {minutes}m'**
  String commonMinutesAgo(Object minutes);

  /// No description provided for @commonHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {hours}h'**
  String commonHoursAgo(Object hours);

  /// No description provided for @commonYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get commonYesterday;

  /// No description provided for @commonDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String commonDaysAgo(Object days);

  /// No description provided for @commonTodayAt.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {time}'**
  String commonTodayAt(Object time);

  /// No description provided for @commonSavedAt.
  ///
  /// In es, this message translates to:
  /// **'Guardado {time}'**
  String commonSavedAt(Object time);

  /// No description provided for @commonActivePlural.
  ///
  /// In es, this message translates to:
  /// **'Activos'**
  String get commonActivePlural;

  /// No description provided for @commonInactivePlural.
  ///
  /// In es, this message translates to:
  /// **'Inactivos'**
  String get commonInactivePlural;

  /// No description provided for @commonAdjustFilters.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar los filtros o buscar con otros términos'**
  String get commonAdjustFilters;

  /// No description provided for @shedStepBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get shedStepBasic;

  /// No description provided for @shedStepSpecifications.
  ///
  /// In es, this message translates to:
  /// **'Especificaciones'**
  String get shedStepSpecifications;

  /// No description provided for @shedStepEnvironment.
  ///
  /// In es, this message translates to:
  /// **'Ambiente'**
  String get shedStepEnvironment;

  /// No description provided for @shedDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get shedDraftFound;

  /// No description provided for @shedDraftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String shedDraftFoundMessage(Object date);

  /// No description provided for @shedCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Galpón \"{name}\" creado!'**
  String shedCreatedSuccess(Object name);

  /// No description provided for @shedUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Galpón \"{name}\" actualizado!'**
  String shedUpdatedSuccess(Object name);

  /// No description provided for @shedExitWithoutCompleting.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get shedExitWithoutCompleting;

  /// No description provided for @shedDataIsSafe.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros.'**
  String get shedDataIsSafe;

  /// No description provided for @shedStartFirstShed.
  ///
  /// In es, this message translates to:
  /// **'Comienza tu primer galpón'**
  String get shedStartFirstShed;

  /// No description provided for @shedStartFirstShedDesc.
  ///
  /// In es, this message translates to:
  /// **'Registra tu primer galpón avícola y comienza a gestionar la producción'**
  String get shedStartFirstShedDesc;

  /// No description provided for @shedNoShedsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron galpones'**
  String get shedNoShedsFound;

  /// No description provided for @shedDeletedMsg.
  ///
  /// In es, this message translates to:
  /// **'Galpón eliminado'**
  String get shedDeletedMsg;

  /// No description provided for @shedDeletedCorrectly.
  ///
  /// In es, this message translates to:
  /// **'Galpón eliminado correctamente'**
  String get shedDeletedCorrectly;

  /// No description provided for @shedChangeStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiar estado'**
  String get shedChangeStatus;

  /// No description provided for @shedGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get shedGeneralInfo;

  /// No description provided for @shedInfrastructure.
  ///
  /// In es, this message translates to:
  /// **'Infraestructura'**
  String get shedInfrastructure;

  /// No description provided for @shedSensorsEquipment.
  ///
  /// In es, this message translates to:
  /// **'Sensores y Equipamiento'**
  String get shedSensorsEquipment;

  /// No description provided for @shedGeneralStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas Generales'**
  String get shedGeneralStats;

  /// No description provided for @shedByStatus.
  ///
  /// In es, this message translates to:
  /// **'Por estado'**
  String get shedByStatus;

  /// No description provided for @shedNoTags.
  ///
  /// In es, this message translates to:
  /// **'Sin etiquetas'**
  String get shedNoTags;

  /// No description provided for @shedRequestedNotExist.
  ///
  /// In es, this message translates to:
  /// **'El galpón solicitado no existe'**
  String get shedRequestedNotExist;

  /// No description provided for @shedDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Desinfección'**
  String get shedDisinfection;

  /// No description provided for @shedQuarantine.
  ///
  /// In es, this message translates to:
  /// **'Cuarentena'**
  String get shedQuarantine;

  /// No description provided for @shedSelectType.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de galpón'**
  String get shedSelectType;

  /// No description provided for @shedEnterBirdCapacity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la capacidad de aves'**
  String get shedEnterBirdCapacity;

  /// No description provided for @shedCapacityMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'La capacidad debe ser mayor a 0'**
  String get shedCapacityMustBePositive;

  /// No description provided for @shedCapacityTooHigh.
  ///
  /// In es, this message translates to:
  /// **'La capacidad parece muy alta'**
  String get shedCapacityTooHigh;

  /// No description provided for @shedEnterArea.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el área en m²'**
  String get shedEnterArea;

  /// No description provided for @shedAreaMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'El área debe ser mayor a 0'**
  String get shedAreaMustBePositive;

  /// No description provided for @shedAreaTooLarge.
  ///
  /// In es, this message translates to:
  /// **'El área parece muy grande'**
  String get shedAreaTooLarge;

  /// No description provided for @shedEnterMaxTemp.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la temperatura máxima'**
  String get shedEnterMaxTemp;

  /// No description provided for @shedEnterMinTemp.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la temperatura mínima'**
  String get shedEnterMinTemp;

  /// No description provided for @shedTempMinLessThanMax.
  ///
  /// In es, this message translates to:
  /// **'La temperatura mínima debe ser menor que la máxima'**
  String get shedTempMinLessThanMax;

  /// No description provided for @shedEnterMaxHumidity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la humedad máxima'**
  String get shedEnterMaxHumidity;

  /// No description provided for @shedEnterMinHumidity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la humedad mínima'**
  String get shedEnterMinHumidity;

  /// No description provided for @shedHumidityMinLessThanMax.
  ///
  /// In es, this message translates to:
  /// **'La humedad mínima debe ser menor que la máxima'**
  String get shedHumidityMinLessThanMax;

  /// No description provided for @shedBasicInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get shedBasicInfo;

  /// No description provided for @shedBasicInfoDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingresa los datos principales del galpón avícola'**
  String get shedBasicInfoDesc;

  /// No description provided for @shedNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Galpón Principal, Ponedoras Norte'**
  String get shedNameHint;

  /// No description provided for @shedMinChars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get shedMinChars;

  /// No description provided for @shedDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get shedDescriptionOptional;

  /// No description provided for @shedDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describe las características principales del galpón...'**
  String get shedDescriptionHint;

  /// No description provided for @shedSelectShedType.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo de galpón'**
  String get shedSelectShedType;

  /// No description provided for @shedImportantInfo.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get shedImportantInfo;

  /// No description provided for @shedCodeAutoGenerated.
  ///
  /// In es, this message translates to:
  /// **'El código del galpón se genera automáticamente basado en el nombre de la granja y el número de galpones existentes.'**
  String get shedCodeAutoGenerated;

  /// No description provided for @shedSpecsDesc.
  ///
  /// In es, this message translates to:
  /// **'Configure la capacidad y el equipamiento del galpón'**
  String get shedSpecsDesc;

  /// No description provided for @shedMaxBirdCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Máxima de Aves'**
  String get shedMaxBirdCapacity;

  /// No description provided for @shedMustBeValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Debe ser un número válido'**
  String get shedMustBeValidNumber;

  /// No description provided for @shedMustBePositiveNumber.
  ///
  /// In es, this message translates to:
  /// **'Debe ser un número positivo'**
  String get shedMustBePositiveNumber;

  /// No description provided for @shedNumberTooLarge.
  ///
  /// In es, this message translates to:
  /// **'El número es demasiado grande'**
  String get shedNumberTooLarge;

  /// No description provided for @shedTotalArea.
  ///
  /// In es, this message translates to:
  /// **'Área Total'**
  String get shedTotalArea;

  /// No description provided for @shedAreaRequired.
  ///
  /// In es, this message translates to:
  /// **'El área es requerida'**
  String get shedAreaRequired;

  /// No description provided for @shedNumberSeemsHigh.
  ///
  /// In es, this message translates to:
  /// **'El número parece muy alto'**
  String get shedNumberSeemsHigh;

  /// No description provided for @shedUsefulInfo.
  ///
  /// In es, this message translates to:
  /// **'Información útil'**
  String get shedUsefulInfo;

  /// No description provided for @shedDensityPlanningHelp.
  ///
  /// In es, this message translates to:
  /// **'Estos datos ayudarán a planificar lotes y calcular densidad poblacional.'**
  String get shedDensityPlanningHelp;

  /// No description provided for @shedRecommendedDensities.
  ///
  /// In es, this message translates to:
  /// **'Densidades recomendadas'**
  String get shedRecommendedDensities;

  /// No description provided for @shedEnvironmentalConditions.
  ///
  /// In es, this message translates to:
  /// **'Condiciones Ambientales'**
  String get shedEnvironmentalConditions;

  /// No description provided for @shedMinLabel.
  ///
  /// In es, this message translates to:
  /// **'Mínima'**
  String get shedMinLabel;

  /// No description provided for @shedMaxLabel.
  ///
  /// In es, this message translates to:
  /// **'Máxima'**
  String get shedMaxLabel;

  /// No description provided for @shedInvalidTempRange.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido (0-50)'**
  String get shedInvalidTempRange;

  /// No description provided for @shedRelativeHumidity.
  ///
  /// In es, this message translates to:
  /// **'Humedad Relativa'**
  String get shedRelativeHumidity;

  /// No description provided for @shedInvalidHumidityRange.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido (0-100)'**
  String get shedInvalidHumidityRange;

  /// No description provided for @shedVentilation.
  ///
  /// In es, this message translates to:
  /// **'Ventilación'**
  String get shedVentilation;

  /// No description provided for @shedInvalidValue.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido'**
  String get shedInvalidValue;

  /// No description provided for @shedEnvironmentalAlertHelp.
  ///
  /// In es, this message translates to:
  /// **'Los valores ambientales configurados se usarán para generar alertas automáticas cuando las condiciones reales estén fuera del rango especificado.'**
  String get shedEnvironmentalAlertHelp;

  /// No description provided for @shedShedType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Galpón'**
  String get shedShedType;

  /// No description provided for @shedMaxCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Máxima'**
  String get shedMaxCapacity;

  /// No description provided for @shedCurrentBirdsLabel.
  ///
  /// In es, this message translates to:
  /// **'Aves Actuales'**
  String get shedCurrentBirdsLabel;

  /// No description provided for @shedCurrentBirdsValue.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String shedCurrentBirdsValue(Object count);

  /// No description provided for @shedOccupationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get shedOccupationLabel;

  /// No description provided for @shedAreaLabel.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get shedAreaLabel;

  /// No description provided for @shedLocationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get shedLocationLabel;

  /// No description provided for @shedOccupationTitle.
  ///
  /// In es, this message translates to:
  /// **'Ocupación del Galpón'**
  String get shedOccupationTitle;

  /// No description provided for @shedOptimal.
  ///
  /// In es, this message translates to:
  /// **'Óptimo'**
  String get shedOptimal;

  /// No description provided for @shedAdjust.
  ///
  /// In es, this message translates to:
  /// **'Ajustar'**
  String get shedAdjust;

  /// No description provided for @shedVentilationSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de Ventilación'**
  String get shedVentilationSystem;

  /// No description provided for @shedHeatingSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de Calefacción'**
  String get shedHeatingSystem;

  /// No description provided for @shedLightingSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de Iluminación'**
  String get shedLightingSystem;

  /// No description provided for @shedAmmonia.
  ///
  /// In es, this message translates to:
  /// **'Amoníaco'**
  String get shedAmmonia;

  /// No description provided for @shedAssignBatch.
  ///
  /// In es, this message translates to:
  /// **'Asignar lote'**
  String get shedAssignBatch;

  /// No description provided for @shedRegisterDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Registrar\nDesinfección'**
  String get shedRegisterDisinfection;

  /// No description provided for @shedDisinfectedDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Desinfectado hace {days} días'**
  String shedDisinfectedDaysAgo(Object days);

  /// No description provided for @shedMaintenanceOverdue.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento vencido hace {days} días'**
  String shedMaintenanceOverdue(Object days);

  /// No description provided for @shedMaintenanceToday.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento programado para hoy'**
  String get shedMaintenanceToday;

  /// No description provided for @shedMaintenanceInDays.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento en {days} días'**
  String shedMaintenanceInDays(Object days);

  /// No description provided for @shedViewBatches.
  ///
  /// In es, this message translates to:
  /// **'Ver Lotes'**
  String get shedViewBatches;

  /// No description provided for @shedRegisterDisinfectionAction.
  ///
  /// In es, this message translates to:
  /// **'Registrar\nDesinfección'**
  String get shedRegisterDisinfectionAction;

  /// No description provided for @shedActiveBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote Activo'**
  String get shedActiveBatch;

  /// No description provided for @shedAvailableForNewBatch.
  ///
  /// In es, this message translates to:
  /// **'Este galpón está disponible para recibir un nuevo lote'**
  String get shedAvailableForNewBatch;

  /// No description provided for @shedAssignBatchLabel.
  ///
  /// In es, this message translates to:
  /// **'Asignar Lote'**
  String get shedAssignBatchLabel;

  /// No description provided for @shedNotAvailableForBatch.
  ///
  /// In es, this message translates to:
  /// **'Galpón no disponible ({status})'**
  String shedNotAvailableForBatch(Object status);

  /// No description provided for @shedNotAvailableForAssign.
  ///
  /// In es, this message translates to:
  /// **'El galpón no está disponible para asignar lotes'**
  String get shedNotAvailableForAssign;

  /// No description provided for @shedNoBatchAssigned.
  ///
  /// In es, this message translates to:
  /// **'El galpón no tiene lote asignado'**
  String get shedNoBatchAssigned;

  /// No description provided for @shedInfoCopied.
  ///
  /// In es, this message translates to:
  /// **'Información copiada al portapapeles'**
  String get shedInfoCopied;

  /// No description provided for @shedCannotDeleteWithBatch.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar un galpón con lote asignado'**
  String get shedCannotDeleteWithBatch;

  /// No description provided for @shedSelectBatchForAssign.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote para asignar al galpón'**
  String get shedSelectBatchForAssign;

  /// No description provided for @shedHistoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Historial del Galpón'**
  String get shedHistoryTitle;

  /// No description provided for @shedEventsAppearHere.
  ///
  /// In es, this message translates to:
  /// **'Los eventos del galpón aparecerán aquí'**
  String get shedEventsAppearHere;

  /// No description provided for @shedCreatedEvent.
  ///
  /// In es, this message translates to:
  /// **'Galpón creado'**
  String get shedCreatedEvent;

  /// No description provided for @shedCreatedEventDesc.
  ///
  /// In es, this message translates to:
  /// **'Se registró el galpón {name}'**
  String shedCreatedEventDesc(Object name);

  /// No description provided for @shedDisinfectionDone.
  ///
  /// In es, this message translates to:
  /// **'Desinfección realizada'**
  String get shedDisinfectionDone;

  /// No description provided for @shedDisinfectionDoneDesc.
  ///
  /// In es, this message translates to:
  /// **'Se realizó desinfección del galpón'**
  String get shedDisinfectionDoneDesc;

  /// No description provided for @shedMaintenanceOverdueEvent.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento vencido'**
  String get shedMaintenanceOverdueEvent;

  /// No description provided for @shedMaintenanceScheduledEvent.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento programado'**
  String get shedMaintenanceScheduledEvent;

  /// No description provided for @shedMaintenanceOverdueDesc.
  ///
  /// In es, this message translates to:
  /// **'El mantenimiento estaba programado para esta fecha'**
  String get shedMaintenanceOverdueDesc;

  /// No description provided for @shedMaintenanceScheduledDesc.
  ///
  /// In es, this message translates to:
  /// **'Próximo mantenimiento del galpón'**
  String get shedMaintenanceScheduledDesc;

  /// No description provided for @shedBatchFinished.
  ///
  /// In es, this message translates to:
  /// **'Lote finalizado'**
  String get shedBatchFinished;

  /// No description provided for @shedBatchFinishedDesc.
  ///
  /// In es, this message translates to:
  /// **'Se finalizó el lote {id}'**
  String shedBatchFinishedDesc(String id);

  /// No description provided for @shedLastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get shedLastUpdate;

  /// No description provided for @shedLastUpdateDesc.
  ///
  /// In es, this message translates to:
  /// **'Se actualizó la información del galpón'**
  String get shedLastUpdateDesc;

  /// No description provided for @shedOccupancyLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de ocupación'**
  String get shedOccupancyLevel;

  /// No description provided for @shedAssignedBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote asignado'**
  String get shedAssignedBatch;

  /// No description provided for @shedLastDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Última desinfección'**
  String get shedLastDisinfection;

  /// No description provided for @shedNextMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Próximo mantenimiento'**
  String get shedNextMaintenance;

  /// No description provided for @shedDaysAgoLabel.
  ///
  /// In es, this message translates to:
  /// **'Hace {days} días'**
  String shedDaysAgoLabel(Object days);

  /// No description provided for @shedOverdueDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Vencido hace {days} días'**
  String shedOverdueDaysAgo(Object days);

  /// No description provided for @shedToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get shedToday;

  /// No description provided for @shedInDays.
  ///
  /// In es, this message translates to:
  /// **'En {days} días'**
  String shedInDays(Object days);

  /// No description provided for @shedStatsTitle.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas de Galpones'**
  String get shedStatsTitle;

  /// No description provided for @shedTotalCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Total'**
  String get shedTotalCapacity;

  /// No description provided for @shedTotalBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Totales'**
  String get shedTotalBirds;

  /// No description provided for @shedStatsRealtime.
  ///
  /// In es, this message translates to:
  /// **'Las estadísticas se actualizan en tiempo real'**
  String get shedStatsRealtime;

  /// No description provided for @shedViewActiveBatch.
  ///
  /// In es, this message translates to:
  /// **'Ver Lote Activo'**
  String get shedViewActiveBatch;

  /// No description provided for @shedFilterSheds.
  ///
  /// In es, this message translates to:
  /// **'Filtrar galpones'**
  String get shedFilterSheds;

  /// No description provided for @shedSelectStatus.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar estado'**
  String get shedSelectStatus;

  /// No description provided for @shedSelectTypeFilter.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tipo'**
  String get shedSelectTypeFilter;

  /// No description provided for @shedMinCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad minima'**
  String get shedMinCapacity;

  /// No description provided for @shedActivateTitle.
  ///
  /// In es, this message translates to:
  /// **'Activar galpón'**
  String get shedActivateTitle;

  /// No description provided for @shedActivateAction.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get shedActivateAction;

  /// No description provided for @shedActivateInfo.
  ///
  /// In es, this message translates to:
  /// **'Podrás operar normalmente.'**
  String get shedActivateInfo;

  /// No description provided for @shedSuspendTitle.
  ///
  /// In es, this message translates to:
  /// **'Suspender galpón'**
  String get shedSuspendTitle;

  /// No description provided for @shedSuspendAction.
  ///
  /// In es, this message translates to:
  /// **'Suspender'**
  String get shedSuspendAction;

  /// No description provided for @shedSuspendInfo.
  ///
  /// In es, this message translates to:
  /// **'No podrás crear nuevos lotes.'**
  String get shedSuspendInfo;

  /// No description provided for @shedMaintenanceTitle.
  ///
  /// In es, this message translates to:
  /// **'Poner en mantenimiento'**
  String get shedMaintenanceTitle;

  /// No description provided for @shedMaintenanceInfo.
  ///
  /// In es, this message translates to:
  /// **'Las operaciones serán limitadas.'**
  String get shedMaintenanceInfo;

  /// No description provided for @shedDisinfectionAction.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get shedDisinfectionAction;

  /// No description provided for @shedDisinfectionAvailInfo.
  ///
  /// In es, this message translates to:
  /// **'El galpón no estará disponible.'**
  String get shedDisinfectionAvailInfo;

  /// No description provided for @shedReleaseTitle.
  ///
  /// In es, this message translates to:
  /// **'Liberar galpón'**
  String get shedReleaseTitle;

  /// No description provided for @shedReleaseAction.
  ///
  /// In es, this message translates to:
  /// **'Liberar'**
  String get shedReleaseAction;

  /// No description provided for @shedReleaseInfo.
  ///
  /// In es, this message translates to:
  /// **'El lote actual será desvinculado.'**
  String get shedReleaseInfo;

  /// No description provided for @shedDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar galpón'**
  String get shedDeleteTitle;

  /// No description provided for @shedDeleteConfirmMsg.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{name}\"?'**
  String shedDeleteConfirmMsg(Object name);

  /// No description provided for @shedDeleteIrreversible.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible:'**
  String get shedDeleteIrreversible;

  /// No description provided for @shedDeleteConsequences.
  ///
  /// In es, this message translates to:
  /// **' Se eliminarán los registros del galpón\n Se desvincularán los lotes asociados\n Se perderá el historial de operaciones'**
  String get shedDeleteConsequences;

  /// No description provided for @shedWriteHere.
  ///
  /// In es, this message translates to:
  /// **'Escribe aquí'**
  String get shedWriteHere;

  /// No description provided for @shedStatusActiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Operación normal habilitada'**
  String get shedStatusActiveDesc;

  /// No description provided for @shedStatusInactiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Operaciones pausadas temporalmente'**
  String get shedStatusInactiveDesc;

  /// No description provided for @shedStatusMaintenanceDesc.
  ///
  /// In es, this message translates to:
  /// **'En proceso de mantenimiento'**
  String get shedStatusMaintenanceDesc;

  /// No description provided for @shedStatusQuarantineDesc.
  ///
  /// In es, this message translates to:
  /// **'Aislado por cuarentena sanitaria'**
  String get shedStatusQuarantineDesc;

  /// No description provided for @shedStatusDisinfectionDesc.
  ///
  /// In es, this message translates to:
  /// **'En proceso de desinfección'**
  String get shedStatusDisinfectionDesc;

  /// No description provided for @shedRegisterDisinfectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar desinfección'**
  String get shedRegisterDisinfectionTitle;

  /// No description provided for @shedSelectProductsFromInventory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona productos del inventario para descontar automáticamente'**
  String get shedSelectProductsFromInventory;

  /// No description provided for @shedAdditionalObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones adicionales'**
  String get shedAdditionalObservations;

  /// No description provided for @shedScheduleMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Programar mantenimiento'**
  String get shedScheduleMaintenance;

  /// No description provided for @shedMaintenanceDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción del mantenimiento *'**
  String get shedMaintenanceDescriptionLabel;

  /// No description provided for @shedMaintenanceDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Revisión de bebederos y comederos'**
  String get shedMaintenanceDescriptionHint;

  /// No description provided for @shedEnterDescription.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una descripción'**
  String get shedEnterDescription;

  /// No description provided for @shedWeeksAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {count} {label}'**
  String shedWeeksAgo(Object count, Object label);

  /// No description provided for @shedWeek.
  ///
  /// In es, this message translates to:
  /// **'semana'**
  String get shedWeek;

  /// No description provided for @shedWeeks.
  ///
  /// In es, this message translates to:
  /// **'semanas'**
  String get shedWeeks;

  /// No description provided for @shedMonth.
  ///
  /// In es, this message translates to:
  /// **'mes'**
  String get shedMonth;

  /// No description provided for @shedMonths.
  ///
  /// In es, this message translates to:
  /// **'meses'**
  String get shedMonths;

  /// No description provided for @shedYear.
  ///
  /// In es, this message translates to:
  /// **'año'**
  String get shedYear;

  /// No description provided for @shedYears.
  ///
  /// In es, this message translates to:
  /// **'años'**
  String get shedYears;

  /// No description provided for @shedNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'No especificada'**
  String get shedNotSpecified;

  /// No description provided for @commonApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get commonApply;

  /// No description provided for @commonSchedule.
  ///
  /// In es, this message translates to:
  /// **'Programar'**
  String get commonSchedule;

  /// No description provided for @commonReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo'**
  String get commonReason;

  /// No description provided for @shedCurrentState.
  ///
  /// In es, this message translates to:
  /// **'Estado actual:'**
  String get shedCurrentState;

  /// No description provided for @shedSelectNewState.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar nuevo estado:'**
  String get shedSelectNewState;

  /// No description provided for @shedWriteNameToConfirm.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre para confirmar:'**
  String get shedWriteNameToConfirm;

  /// No description provided for @shedSelectProductsDesc.
  ///
  /// In es, this message translates to:
  /// **'Productos del inventario'**
  String get shedSelectProductsDesc;

  /// No description provided for @shedProductsUsed.
  ///
  /// In es, this message translates to:
  /// **'Productos utilizados *'**
  String get shedProductsUsed;

  /// No description provided for @shedProductsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Amonio cuaternario, Cal viva'**
  String get shedProductsHint;

  /// No description provided for @shedSeparateWithCommas.
  ///
  /// In es, this message translates to:
  /// **'Separe multiples productos con comas'**
  String get shedSeparateWithCommas;

  /// No description provided for @shedObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Observaciones adicionales'**
  String get shedObservationsHint;

  /// No description provided for @shedEnterAtLeastOneProduct.
  ///
  /// In es, this message translates to:
  /// **'Ingrese al menos un producto'**
  String get shedEnterAtLeastOneProduct;

  /// No description provided for @shedEnterReason.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el motivo'**
  String get shedEnterReason;

  /// No description provided for @shedStartDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get shedStartDateLabel;

  /// No description provided for @shedCorralsDivisions.
  ///
  /// In es, this message translates to:
  /// **'Corrales/Divisiones'**
  String get shedCorralsDivisions;

  /// No description provided for @shedDivisionsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} divisiones'**
  String shedDivisionsCount(Object count);

  /// No description provided for @shedWateringSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de Bebederos'**
  String get shedWateringSystem;

  /// No description provided for @shedFeederSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de Comederos'**
  String get shedFeederSystem;

  /// No description provided for @shedChangeStateAction.
  ///
  /// In es, this message translates to:
  /// **'Cambiar estado'**
  String get shedChangeStateAction;

  /// No description provided for @shedReleaseLabel.
  ///
  /// In es, this message translates to:
  /// **'Liberar'**
  String get shedReleaseLabel;

  /// No description provided for @shedDensityLabel.
  ///
  /// In es, this message translates to:
  /// **'Densidad'**
  String get shedDensityLabel;

  /// No description provided for @shedMSquarePerBird.
  ///
  /// In es, this message translates to:
  /// **'{value} m² por ave'**
  String shedMSquarePerBird(String value);

  /// No description provided for @shedOfCapacity.
  ///
  /// In es, this message translates to:
  /// **'{percentage}% de capacidad'**
  String shedOfCapacity(String percentage);

  /// No description provided for @shedOfBirdsUnit.
  ///
  /// In es, this message translates to:
  /// **'de {count} aves'**
  String shedOfBirdsUnit(Object count);

  /// No description provided for @shedScheduleMaintenanceGrid.
  ///
  /// In es, this message translates to:
  /// **'Programar\nMantenimiento'**
  String get shedScheduleMaintenanceGrid;

  /// No description provided for @shedViewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver\nHistorial'**
  String get shedViewHistory;

  /// No description provided for @shedViewBatchDetail.
  ///
  /// In es, this message translates to:
  /// **'Ver Detalle del Lote'**
  String get shedViewBatchDetail;

  /// No description provided for @shedNoAssignedBatch.
  ///
  /// In es, this message translates to:
  /// **'Sin lote asignado'**
  String get shedNoAssignedBatch;

  /// No description provided for @commonAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get commonAvailable;

  /// No description provided for @shedQuarantineReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo de cuarentena'**
  String get shedQuarantineReason;

  /// No description provided for @shedBatchAssignedMsg.
  ///
  /// In es, this message translates to:
  /// **'Lote {code} asignado correctamente'**
  String shedBatchAssignedMsg(Object code);

  /// No description provided for @shedDeleteErrorMsg.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {message}'**
  String shedDeleteErrorMsg(Object message);

  /// No description provided for @shedCreateBatchFirst.
  ///
  /// In es, this message translates to:
  /// **'Crea un nuevo lote primero'**
  String get shedCreateBatchFirst;

  /// No description provided for @commonToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get commonToday;

  /// No description provided for @shedNoHistoryAvailable.
  ///
  /// In es, this message translates to:
  /// **'Sin historial disponible'**
  String get shedNoHistoryAvailable;

  /// No description provided for @commonAssigned.
  ///
  /// In es, this message translates to:
  /// **'Asignado'**
  String get commonAssigned;

  /// No description provided for @shedBirdsOfCapacity.
  ///
  /// In es, this message translates to:
  /// **'{current} / {max} aves'**
  String shedBirdsOfCapacity(Object current, Object max);

  /// No description provided for @shedShedsRegistered.
  ///
  /// In es, this message translates to:
  /// **'{count} galpones registrados'**
  String shedShedsRegistered(Object count);

  /// No description provided for @shedMoreOptions.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get shedMoreOptions;

  /// No description provided for @shedOccurredError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error'**
  String get shedOccurredError;

  /// No description provided for @shedSpecifications.
  ///
  /// In es, this message translates to:
  /// **'Especificaciones'**
  String get shedSpecifications;

  /// No description provided for @shedConfigureThresholds.
  ///
  /// In es, this message translates to:
  /// **'Configure los umbrales para monitoreo (opcional)'**
  String get shedConfigureThresholds;

  /// No description provided for @shedCapacityIsRequired.
  ///
  /// In es, this message translates to:
  /// **'La capacidad es requerida'**
  String get shedCapacityIsRequired;

  /// No description provided for @shedNameIsRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get shedNameIsRequired;

  /// No description provided for @shedShedNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Galpón'**
  String get shedShedNameLabel;

  /// No description provided for @shedTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Galpón'**
  String get shedTypeLabel;

  /// No description provided for @shedSelectTypeHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo'**
  String get shedSelectTypeHint;

  /// No description provided for @shedSelectStateHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el estado'**
  String get shedSelectStateHint;

  /// No description provided for @shedDrinkersOptional.
  ///
  /// In es, this message translates to:
  /// **'Bebederos (opcional)'**
  String get shedDrinkersOptional;

  /// No description provided for @shedFeedersOptional.
  ///
  /// In es, this message translates to:
  /// **'Comederos (opcional)'**
  String get shedFeedersOptional;

  /// No description provided for @shedNestsOptional.
  ///
  /// In es, this message translates to:
  /// **'Nidales (opcional)'**
  String get shedNestsOptional;

  /// No description provided for @shedTemperature.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get shedTemperature;

  /// No description provided for @shedTip.
  ///
  /// In es, this message translates to:
  /// **'Consejo'**
  String get shedTip;

  /// No description provided for @shedUnitsLabel.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get shedUnitsLabel;

  /// No description provided for @shedDensityTypeCol.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get shedDensityTypeCol;

  /// No description provided for @shedDensityCol.
  ///
  /// In es, this message translates to:
  /// **'Densidad'**
  String get shedDensityCol;

  /// No description provided for @shedFattening.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get shedFattening;

  /// No description provided for @shedLaying.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get shedLaying;

  /// No description provided for @shedBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora'**
  String get shedBreeder;

  /// No description provided for @shedActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get shedActive;

  /// No description provided for @shedInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get shedInactive;

  /// No description provided for @shedSemanticsLabel.
  ///
  /// In es, this message translates to:
  /// **'Galpón {name}, código {code}, {birds} aves, estado {status}'**
  String shedSemanticsLabel(
    Object birds,
    Object code,
    Object name,
    Object status,
  );

  /// No description provided for @shedShareType.
  ///
  /// In es, this message translates to:
  /// **'Tipo: {type}'**
  String shedShareType(Object type);

  /// No description provided for @shedShareCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad: {count} aves'**
  String shedShareCapacity(Object count);

  /// No description provided for @shedShareOccupation.
  ///
  /// In es, this message translates to:
  /// **'Ocupación: {percentage}%'**
  String shedShareOccupation(Object percentage);

  /// No description provided for @shedBirdsBullet.
  ///
  /// In es, this message translates to:
  /// **'{count} aves • {type}'**
  String shedBirdsBullet(Object count, Object type);

  /// No description provided for @batchSemanticsLabel.
  ///
  /// In es, this message translates to:
  /// **'Lote {code}, {birdType}, {birds} aves, estado {status}'**
  String batchSemanticsLabel(
    String birdType,
    Object birds,
    Object code,
    Object status,
  );

  /// No description provided for @batchDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get batchDetails;

  /// No description provided for @batchViewRecords.
  ///
  /// In es, this message translates to:
  /// **'Ver Registros'**
  String get batchViewRecords;

  /// No description provided for @batchMoreOptions.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get batchMoreOptions;

  /// No description provided for @batchMoreOptionsLote.
  ///
  /// In es, this message translates to:
  /// **'Más opciones del lote'**
  String get batchMoreOptionsLote;

  /// No description provided for @batchRetryLoadSemantics.
  ///
  /// In es, this message translates to:
  /// **'Reintentar carga de lotes'**
  String get batchRetryLoadSemantics;

  /// No description provided for @batchStatusActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get batchStatusActive;

  /// No description provided for @batchStatusClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get batchStatusClosed;

  /// No description provided for @batchStatusQuarantine.
  ///
  /// In es, this message translates to:
  /// **'Cuarentena'**
  String get batchStatusQuarantine;

  /// No description provided for @batchStatusSold.
  ///
  /// In es, this message translates to:
  /// **'Vendido'**
  String get batchStatusSold;

  /// No description provided for @batchStatusTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get batchStatusTransfer;

  /// No description provided for @batchStatusSuspended.
  ///
  /// In es, this message translates to:
  /// **'Suspendido'**
  String get batchStatusSuspended;

  /// No description provided for @batchType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get batchType;

  /// No description provided for @batchBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves'**
  String get batchBirds;

  /// No description provided for @batchAge.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get batchAge;

  /// No description provided for @batchCloseBatch.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Lote'**
  String get batchCloseBatch;

  /// No description provided for @batchConfirmClose.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Cierre'**
  String get batchConfirmClose;

  /// No description provided for @batchCloseIrreversibleWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es IRREVERSIBLE. El lote pasará a estado cerrado y el galpón quedará disponible.\n\n¿Está seguro de cerrar este lote?'**
  String get batchCloseIrreversibleWarning;

  /// No description provided for @batchClosureData.
  ///
  /// In es, this message translates to:
  /// **'Datos del Cierre'**
  String get batchClosureData;

  /// No description provided for @batchCompleteClosureInfo.
  ///
  /// In es, this message translates to:
  /// **'Complete la información final del lote'**
  String get batchCompleteClosureInfo;

  /// No description provided for @batchLoteInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del Lote'**
  String get batchLoteInfo;

  /// No description provided for @batchInitialCountBirds.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String batchInitialCountBirds(Object count);

  /// No description provided for @batchDaysInCycle.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String batchDaysInCycle(Object days);

  /// No description provided for @batchCloseDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Cierre *'**
  String get batchCloseDateLabel;

  /// No description provided for @batchCloseDateSimple.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Cierre'**
  String get batchCloseDateSimple;

  /// No description provided for @batchCloseDateHelper.
  ///
  /// In es, this message translates to:
  /// **'Fecha en que se cierra el lote'**
  String get batchCloseDateHelper;

  /// No description provided for @batchCloseDatePicker.
  ///
  /// In es, this message translates to:
  /// **'Fecha de cierre del lote'**
  String get batchCloseDatePicker;

  /// No description provided for @batchFinalBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad Final de Aves *'**
  String get batchFinalBirdCount;

  /// No description provided for @batchFinalBirdCountHelper.
  ///
  /// In es, this message translates to:
  /// **'Número de aves vivas al cierre (máx: {max})'**
  String batchFinalBirdCountHelper(Object max);

  /// No description provided for @batchFinalAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso Promedio Final'**
  String get batchFinalAvgWeight;

  /// No description provided for @batchFinalAvgWeightHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 2500'**
  String get batchFinalAvgWeightHint;

  /// No description provided for @batchFinalAvgWeightHelper.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio de las aves al cierre (en gramos)'**
  String get batchFinalAvgWeightHelper;

  /// No description provided for @batchClosureReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo del Cierre'**
  String get batchClosureReason;

  /// No description provided for @batchClosureReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Fin de ciclo productivo'**
  String get batchClosureReasonHint;

  /// No description provided for @batchClosureReasonHelper.
  ///
  /// In es, this message translates to:
  /// **'Opcional - Razón del cierre del lote'**
  String get batchClosureReasonHelper;

  /// No description provided for @batchAdditionalNotes.
  ///
  /// In es, this message translates to:
  /// **'Observaciones Adicionales'**
  String get batchAdditionalNotes;

  /// No description provided for @batchAdditionalNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Notas finales del lote...'**
  String get batchAdditionalNotesHint;

  /// No description provided for @batchBatchMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas del Lote'**
  String get batchBatchMetrics;

  /// No description provided for @batchCycleIndicators.
  ///
  /// In es, this message translates to:
  /// **'Resumen de indicadores del ciclo productivo'**
  String get batchCycleIndicators;

  /// No description provided for @batchSurvival.
  ///
  /// In es, this message translates to:
  /// **'Supervivencia'**
  String get batchSurvival;

  /// No description provided for @batchInitialBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Iniciales'**
  String get batchInitialBirds;

  /// No description provided for @batchFinalBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Finales'**
  String get batchFinalBirds;

  /// No description provided for @batchTotalMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Total'**
  String get batchTotalMortality;

  /// No description provided for @batchMortalityBirds.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String batchMortalityBirds(Object count);

  /// No description provided for @batchMortalityPercent.
  ///
  /// In es, this message translates to:
  /// **'% Mortalidad'**
  String get batchMortalityPercent;

  /// No description provided for @batchSurvivalPercent.
  ///
  /// In es, this message translates to:
  /// **'% Supervivencia'**
  String get batchSurvivalPercent;

  /// No description provided for @batchCycleDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración del Ciclo'**
  String get batchCycleDuration;

  /// No description provided for @batchTotalDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración Total'**
  String get batchTotalDuration;

  /// No description provided for @batchAgeAtClose.
  ///
  /// In es, this message translates to:
  /// **'Edad al Cierre'**
  String get batchAgeAtClose;

  /// No description provided for @batchAgeAtCloseDays.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String batchAgeAtCloseDays(Object days);

  /// No description provided for @batchWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get batchWeight;

  /// No description provided for @batchCurrentAvgWeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Peso Promedio Actual'**
  String get batchCurrentAvgWeightLabel;

  /// No description provided for @batchTargetWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso Objetivo'**
  String get batchTargetWeight;

  /// No description provided for @batchClosureSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen del Cierre'**
  String get batchClosureSummary;

  /// No description provided for @batchClosureSummaryWarning.
  ///
  /// In es, this message translates to:
  /// **'Revisa cuidadosamente toda la información antes de confirmar el cierre. Esta acción es IRREVERSIBLE.'**
  String get batchClosureSummaryWarning;

  /// No description provided for @batchCloseWarningMessage.
  ///
  /// In es, this message translates to:
  /// **'Al cerrar el lote, este pasará a estado CERRADO y el galpón quedará disponible para un nuevo lote.'**
  String get batchCloseWarningMessage;

  /// No description provided for @batchFinalData.
  ///
  /// In es, this message translates to:
  /// **'Datos Finales'**
  String get batchFinalData;

  /// No description provided for @batchFinalCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad Final'**
  String get batchFinalCount;

  /// No description provided for @batchMortalityTotal.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Total'**
  String get batchMortalityTotal;

  /// No description provided for @batchFinalWeightAvg.
  ///
  /// In es, this message translates to:
  /// **'Peso Final Promedio'**
  String get batchFinalWeightAvg;

  /// No description provided for @batchClosureNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas del Cierre'**
  String get batchClosureNotes;

  /// No description provided for @batchReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo'**
  String get batchReason;

  /// No description provided for @batchObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get batchObservations;

  /// No description provided for @batchPrevious.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get batchPrevious;

  /// No description provided for @batchNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get batchNext;

  /// No description provided for @batchClosing.
  ///
  /// In es, this message translates to:
  /// **'Cerrando lote...'**
  String get batchClosing;

  /// No description provided for @batchCannotBeNegative.
  ///
  /// In es, this message translates to:
  /// **'No puede ser negativo'**
  String get batchCannotBeNegative;

  /// No description provided for @batchCannotExceedInitial.
  ///
  /// In es, this message translates to:
  /// **'No puede ser mayor a la cantidad inicial'**
  String get batchCannotExceedInitial;

  /// No description provided for @batchInvalidCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad inválida'**
  String get batchInvalidCount;

  /// No description provided for @batchFinalCannotExceedInitial.
  ///
  /// In es, this message translates to:
  /// **'La cantidad final no puede ser mayor a la inicial'**
  String get batchFinalCannotExceedInitial;

  /// No description provided for @batchNormalCycleClose.
  ///
  /// In es, this message translates to:
  /// **'Cierre de ciclo normal'**
  String get batchNormalCycleClose;

  /// No description provided for @batchErrorClosing.
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar lote: {error}'**
  String batchErrorClosing(Object error);

  /// No description provided for @batchDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get batchDraftFound;

  /// No description provided for @batchDraftMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String batchDraftMessage(Object date);

  /// No description provided for @batchDraftRestore.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get batchDraftRestore;

  /// No description provided for @batchDraftDiscard.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get batchDraftDiscard;

  /// No description provided for @batchExitWithoutComplete.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get batchExitWithoutComplete;

  /// No description provided for @batchDataSafe.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros.'**
  String get batchDataSafe;

  /// No description provided for @batchExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get batchExit;

  /// No description provided for @batchSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha expirado. Por favor inicia sesión nuevamente'**
  String get batchSessionExpired;

  /// No description provided for @batchSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get batchSaving;

  /// No description provided for @batchSavedTime.
  ///
  /// In es, this message translates to:
  /// **'Guardado {time}'**
  String batchSavedTime(Object time);

  /// No description provided for @batchRightNow.
  ///
  /// In es, this message translates to:
  /// **'ahora mismo'**
  String get batchRightNow;

  /// No description provided for @batchSecondsAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {seconds}s'**
  String batchSecondsAgo(Object seconds);

  /// No description provided for @batchMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {minutes}m'**
  String batchMinutesAgo(Object minutes);

  /// No description provided for @batchHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {hours}h'**
  String batchHoursAgo(Object hours);

  /// No description provided for @batchTodayAt.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {time}'**
  String batchTodayAt(Object time);

  /// No description provided for @batchYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get batchYesterday;

  /// No description provided for @batchDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String batchDaysAgo(Object days);

  /// No description provided for @batchCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Lote creado con éxito!'**
  String get batchCreateSuccess;

  /// No description provided for @batchCreateSuccessDetail.
  ///
  /// In es, this message translates to:
  /// **'\"{code}\" está listo para gestionar'**
  String batchCreateSuccessDetail(Object code);

  /// No description provided for @batchErrorCreating.
  ///
  /// In es, this message translates to:
  /// **'Error al crear el lote'**
  String get batchErrorCreating;

  /// No description provided for @batchUnexpectedError.
  ///
  /// In es, this message translates to:
  /// **'Error inesperado'**
  String get batchUnexpectedError;

  /// No description provided for @batchCheckConnection.
  ///
  /// In es, this message translates to:
  /// **'Por favor, verifica tu conexión e intenta nuevamente'**
  String get batchCheckConnection;

  /// No description provided for @batchBasicStep.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get batchBasicStep;

  /// No description provided for @batchDetailsStep.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get batchDetailsStep;

  /// No description provided for @batchDataStep.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get batchDataStep;

  /// No description provided for @batchMetricsStep.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get batchMetricsStep;

  /// No description provided for @batchConfirmStep.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get batchConfirmStep;

  /// No description provided for @batchInfoStep.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get batchInfoStep;

  /// No description provided for @batchRangesStep.
  ///
  /// In es, this message translates to:
  /// **'Rangos'**
  String get batchRangesStep;

  /// No description provided for @batchSummaryStep.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get batchSummaryStep;

  /// No description provided for @batchDescriptionStep.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get batchDescriptionStep;

  /// No description provided for @batchEvidenceStep.
  ///
  /// In es, this message translates to:
  /// **'Evidencia'**
  String get batchEvidenceStep;

  /// No description provided for @batchRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get batchRegister;

  /// No description provided for @batchWaitProcess.
  ///
  /// In es, this message translates to:
  /// **'Espera a que termine el proceso actual'**
  String get batchWaitProcess;

  /// No description provided for @batchWaitForProcess.
  ///
  /// In es, this message translates to:
  /// **'Espera a que termine el proceso'**
  String get batchWaitForProcess;

  /// No description provided for @batchErrorLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos'**
  String get batchErrorLoadingData;

  /// No description provided for @batchLoadingCharts.
  ///
  /// In es, this message translates to:
  /// **'Cargando gráficos...'**
  String get batchLoadingCharts;

  /// No description provided for @batchChartsProduction.
  ///
  /// In es, this message translates to:
  /// **'Gráficos de Producción'**
  String get batchChartsProduction;

  /// No description provided for @batchChartsWeight.
  ///
  /// In es, this message translates to:
  /// **'Gráficos de Peso'**
  String get batchChartsWeight;

  /// No description provided for @batchChartsMortality.
  ///
  /// In es, this message translates to:
  /// **'Gráficos de Mortalidad'**
  String get batchChartsMortality;

  /// No description provided for @batchChartsConsumption.
  ///
  /// In es, this message translates to:
  /// **'Gráficos de Consumo'**
  String get batchChartsConsumption;

  /// No description provided for @batchRefresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get batchRefresh;

  /// No description provided for @batchRefreshData.
  ///
  /// In es, this message translates to:
  /// **'Actualizar datos'**
  String get batchRefreshData;

  /// No description provided for @batchProductionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de producción'**
  String get batchProductionHistory;

  /// No description provided for @batchWeighingHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de pesajes'**
  String get batchWeighingHistory;

  /// No description provided for @batchMortalityHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de mortalidad'**
  String get batchMortalityHistory;

  /// No description provided for @batchConsumptionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de consumo'**
  String get batchConsumptionHistory;

  /// No description provided for @batchRecent.
  ///
  /// In es, this message translates to:
  /// **'Recientes'**
  String get batchRecent;

  /// No description provided for @batchOldest.
  ///
  /// In es, this message translates to:
  /// **'Antiguos'**
  String get batchOldest;

  /// No description provided for @batchNoFilters.
  ///
  /// In es, this message translates to:
  /// **'Sin filtros'**
  String get batchNoFilters;

  /// No description provided for @batchDays7.
  ///
  /// In es, this message translates to:
  /// **'7 días'**
  String get batchDays7;

  /// No description provided for @batchDays30.
  ///
  /// In es, this message translates to:
  /// **'30 días'**
  String get batchDays30;

  /// No description provided for @batchHighPosture.
  ///
  /// In es, this message translates to:
  /// **'Postura alta'**
  String get batchHighPosture;

  /// No description provided for @batchMediumPosture.
  ///
  /// In es, this message translates to:
  /// **'Postura media'**
  String get batchMediumPosture;

  /// No description provided for @batchLowPosture.
  ///
  /// In es, this message translates to:
  /// **'Postura baja'**
  String get batchLowPosture;

  /// No description provided for @batchBackToHistory.
  ///
  /// In es, this message translates to:
  /// **'Volver al historial'**
  String get batchBackToHistory;

  /// No description provided for @batchNoWeightData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de peso'**
  String get batchNoWeightData;

  /// No description provided for @batchChartsAppearWhenData.
  ///
  /// In es, this message translates to:
  /// **'Los gráficos aparecerán cuando haya registros de peso'**
  String get batchChartsAppearWhenData;

  /// No description provided for @batchPosturePercentage.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de Postura'**
  String get batchPosturePercentage;

  /// No description provided for @batchPostureEvolution.
  ///
  /// In es, this message translates to:
  /// **'Evolución del % de postura en el tiempo'**
  String get batchPostureEvolution;

  /// No description provided for @batchDailyConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo Diario'**
  String get batchDailyConsumption;

  /// No description provided for @batchKgPerDay.
  ///
  /// In es, this message translates to:
  /// **'Kilogramos de alimento consumido por día'**
  String get batchKgPerDay;

  /// No description provided for @batchWeightEvolution.
  ///
  /// In es, this message translates to:
  /// **'Evolución de Peso'**
  String get batchWeightEvolution;

  /// No description provided for @batchAccumulatedMortalityChart.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Acumulada'**
  String get batchAccumulatedMortalityChart;

  /// No description provided for @batchAccumulatedMortalityDesc.
  ///
  /// In es, this message translates to:
  /// **'Total acumulado de aves muertas en el tiempo'**
  String get batchAccumulatedMortalityDesc;

  /// No description provided for @batchDailyMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Diaria'**
  String get batchDailyMortality;

  /// No description provided for @batchDailyGainAvg.
  ///
  /// In es, this message translates to:
  /// **'Ganancia Diaria Promedio'**
  String get batchDailyGainAvg;

  /// No description provided for @batchUniformity.
  ///
  /// In es, this message translates to:
  /// **'Uniformidad'**
  String get batchUniformity;

  /// No description provided for @batchStandardComparison.
  ///
  /// In es, this message translates to:
  /// **'Comparación con Estándar'**
  String get batchStandardComparison;

  /// No description provided for @batchConsumptionPerBird.
  ///
  /// In es, this message translates to:
  /// **'Consumo por Ave'**
  String get batchConsumptionPerBird;

  /// No description provided for @batchFoodTypeDistribution.
  ///
  /// In es, this message translates to:
  /// **'Distribución por Tipo'**
  String get batchFoodTypeDistribution;

  /// No description provided for @batchCosts.
  ///
  /// In es, this message translates to:
  /// **'Costos'**
  String get batchCosts;

  /// No description provided for @batchQuality.
  ///
  /// In es, this message translates to:
  /// **'Calidad'**
  String get batchQuality;

  /// No description provided for @batchDraftFoundGeneric.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado. ¿Deseas restaurarlo?'**
  String get batchDraftFoundGeneric;

  /// No description provided for @batchNoAccessFarm.
  ///
  /// In es, this message translates to:
  /// **'No tienes acceso a esta granja'**
  String get batchNoAccessFarm;

  /// No description provided for @batchNoPermissionRecord.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para registrar consumo en esta granja'**
  String get batchNoPermissionRecord;

  /// No description provided for @batchDaysInCycleLabel.
  ///
  /// In es, this message translates to:
  /// **'Días en Ciclo'**
  String get batchDaysInCycleLabel;

  /// No description provided for @batchClosePrefix.
  ///
  /// In es, this message translates to:
  /// **'[Cierre]'**
  String get batchClosePrefix;

  /// No description provided for @batchCreateBatch.
  ///
  /// In es, this message translates to:
  /// **'Crear Lote'**
  String get batchCreateBatch;

  /// No description provided for @batchClassificationStep.
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get batchClassificationStep;

  /// No description provided for @batchObservationsStep.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get batchObservationsStep;

  /// No description provided for @registerProductionTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Producción'**
  String get registerProductionTitle;

  /// No description provided for @registerWeightTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Pesaje'**
  String get registerWeightTitle;

  /// No description provided for @registerMortalityTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Mortalidad'**
  String get registerMortalityTitle;

  /// No description provided for @registerConsumptionTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Consumo'**
  String get registerConsumptionTitle;

  /// No description provided for @productionRegistered.
  ///
  /// In es, this message translates to:
  /// **'¡Producción registrada!'**
  String get productionRegistered;

  /// No description provided for @productionRegisteredDetail.
  ///
  /// In es, this message translates to:
  /// **'{eggs} huevos · {good} buenos'**
  String productionRegisteredDetail(String eggs, String good);

  /// No description provided for @weightRegistered.
  ///
  /// In es, this message translates to:
  /// **'¡Pesaje registrado!'**
  String get weightRegistered;

  /// No description provided for @mortalityRegistered.
  ///
  /// In es, this message translates to:
  /// **'¡Mortalidad registrada!'**
  String get mortalityRegistered;

  /// No description provided for @consumptionRegistered.
  ///
  /// In es, this message translates to:
  /// **'¡Consumo registrado!'**
  String get consumptionRegistered;

  /// No description provided for @batchMaxPhotosAllowed.
  ///
  /// In es, this message translates to:
  /// **'Máximo 3 fotos permitidas'**
  String get batchMaxPhotosAllowed;

  /// No description provided for @batchPhotoExceeds5MB.
  ///
  /// In es, this message translates to:
  /// **'La foto excede 5MB. Elige una imagen más pequeña'**
  String get batchPhotoExceeds5MB;

  /// No description provided for @productionGoodEggsExceedCollected.
  ///
  /// In es, this message translates to:
  /// **'Los huevos buenos ({good}) no pueden ser más que los recolectados ({collected})'**
  String productionGoodEggsExceedCollected(String collected, Object good);

  /// No description provided for @productionNoAvailableBirds.
  ///
  /// In es, this message translates to:
  /// **'El lote no tiene aves disponibles'**
  String get productionNoAvailableBirds;

  /// No description provided for @productionHighLayingPercent.
  ///
  /// In es, this message translates to:
  /// **'El porcentaje de postura ({percent}%) es mayor al 100%. Verifica los datos.'**
  String productionHighLayingPercent(String percent);

  /// No description provided for @productionClassifiedExceedGood.
  ///
  /// In es, this message translates to:
  /// **'Total clasificados ({classified}) excede los huevos buenos ({good})'**
  String productionClassifiedExceedGood(String classified, Object good);

  /// No description provided for @batchHighLayingTitle.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de postura muy alto'**
  String get batchHighLayingTitle;

  /// No description provided for @batchHighLayingMessage.
  ///
  /// In es, this message translates to:
  /// **'El porcentaje de postura es {percent}%, que es excepcionalmente alto. ¿Deseas continuar con estos datos?'**
  String batchHighLayingMessage(Object percent);

  /// No description provided for @batchHighBreakageTitle.
  ///
  /// In es, this message translates to:
  /// **'Alto porcentaje de rotura'**
  String get batchHighBreakageTitle;

  /// No description provided for @batchHighBreakageMessage.
  ///
  /// In es, this message translates to:
  /// **'El porcentaje de rotura es {percent}% ({count} huevos), que es superior al 5% esperado. ¿Deseas continuar?'**
  String batchHighBreakageMessage(Object count, Object percent);

  /// No description provided for @commonReviewData.
  ///
  /// In es, this message translates to:
  /// **'Revisar datos'**
  String get commonReviewData;

  /// No description provided for @batchNoPermissionProduction.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para registrar producción en esta granja'**
  String get batchNoPermissionProduction;

  /// No description provided for @batchErrorVerifyingPermissions.
  ///
  /// In es, this message translates to:
  /// **'Error al verificar permisos: {error}'**
  String batchErrorVerifyingPermissions(Object error);

  /// No description provided for @productionFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha de producción no puede ser futura'**
  String get productionFutureDate;

  /// No description provided for @productionBeforeEntryDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha de producción no puede ser anterior a la fecha de ingreso del lote'**
  String get productionBeforeEntryDate;

  /// No description provided for @batchFirebaseDbError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión con la base de datos'**
  String get batchFirebaseDbError;

  /// No description provided for @batchFirebasePermissionDenied.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para realizar esta acción'**
  String get batchFirebasePermissionDenied;

  /// No description provided for @batchFirebasePermissionDetail.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu sesión e intenta nuevamente'**
  String get batchFirebasePermissionDetail;

  /// No description provided for @batchFirebaseUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Servicio no disponible'**
  String get batchFirebaseUnavailable;

  /// No description provided for @batchFirebaseUnavailableDetail.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión a internet'**
  String get batchFirebaseUnavailableDetail;

  /// No description provided for @batchFirebaseSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Sesión expirada'**
  String get batchFirebaseSessionExpired;

  /// No description provided for @batchFirebaseSessionDetail.
  ///
  /// In es, this message translates to:
  /// **'Por favor inicia sesión nuevamente'**
  String get batchFirebaseSessionDetail;

  /// No description provided for @batchNoPermissionWeight.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para registrar pesajes en esta granja'**
  String get batchNoPermissionWeight;

  /// No description provided for @batchNoPermissionMortality.
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para registrar mortalidad en esta granja'**
  String get batchNoPermissionMortality;

  /// No description provided for @mortalityFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha de mortalidad no puede ser futura'**
  String get mortalityFutureDate;

  /// No description provided for @mortalityBeforeEntryDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser anterior a la fecha de ingreso del lote'**
  String get mortalityBeforeEntryDate;

  /// No description provided for @weightFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha del pesaje no puede ser futura'**
  String get weightFutureDate;

  /// No description provided for @weightBeforeEntryDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser anterior a la fecha de ingreso del lote'**
  String get weightBeforeEntryDate;

  /// No description provided for @consumptionFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha de consumo no puede ser futura'**
  String get consumptionFutureDate;

  /// No description provided for @consumptionBeforeEntryDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser anterior a la fecha de ingreso del lote'**
  String get consumptionBeforeEntryDate;

  /// No description provided for @weightCannotExceedAvailable.
  ///
  /// In es, this message translates to:
  /// **'La cantidad pesada no puede superar las aves actuales del lote ({count})'**
  String weightCannotExceedAvailable(Object count);

  /// No description provided for @weightMinMustBeLessThanMax.
  ///
  /// In es, this message translates to:
  /// **'El peso mínimo debe ser menor que el peso máximo'**
  String get weightMinMustBeLessThanMax;

  /// No description provided for @weightLowUniformityTitle.
  ///
  /// In es, this message translates to:
  /// **'Uniformidad Baja Detectada'**
  String get weightLowUniformityTitle;

  /// No description provided for @weightLowUniformityMessage.
  ///
  /// In es, this message translates to:
  /// **'El coeficiente de variación es {cv}%, lo que indica baja uniformidad en el lote.'**
  String weightLowUniformityMessage(String cv);

  /// No description provided for @weightCvRecommendedTitle.
  ///
  /// In es, this message translates to:
  /// **'Valores recomendados de CV:'**
  String get weightCvRecommendedTitle;

  /// No description provided for @weightCvRecommendedValues.
  ///
  /// In es, this message translates to:
  /// **'• Óptimo: < 8%\n• Aceptable: 8-12%\n• Requiere atención: > 12%'**
  String get weightCvRecommendedValues;

  /// No description provided for @weightRegisteredDetail.
  ///
  /// In es, this message translates to:
  /// **'{count} aves • {weight} kg promedio'**
  String weightRegisteredDetail(String weight, Object count);

  /// No description provided for @batchPhotoAdded.
  ///
  /// In es, this message translates to:
  /// **'Foto {current}/{max} agregada'**
  String batchPhotoAdded(Object current, Object max);

  /// No description provided for @batchPhotoSelectError.
  ///
  /// In es, this message translates to:
  /// **'Error al seleccionar la imagen. Intenta nuevamente.'**
  String get batchPhotoSelectError;

  /// No description provided for @batchPhotoUploadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron subir las fotos. ¿Deseas continuar sin fotos?'**
  String get batchPhotoUploadFailed;

  /// No description provided for @batchContinueWithoutPhotos.
  ///
  /// In es, this message translates to:
  /// **'¿Continuar sin fotos?'**
  String get batchContinueWithoutPhotos;

  /// No description provided for @batchPhotoUploadFailedDetail.
  ///
  /// In es, this message translates to:
  /// **'Las fotos no se pudieron subir. ¿Deseas registrar sin evidencia fotográfica?'**
  String get batchPhotoUploadFailedDetail;

  /// No description provided for @batchFirebaseNetworkError.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get batchFirebaseNetworkError;

  /// No description provided for @batchFirebaseNetworkDetail.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión a internet'**
  String get batchFirebaseNetworkDetail;

  /// No description provided for @mortalityRegisteredDetail.
  ///
  /// In es, this message translates to:
  /// **'{count} aves - {cause}'**
  String mortalityRegisteredDetail(String cause, Object count);

  /// No description provided for @mortalityAttentionRequired.
  ///
  /// In es, this message translates to:
  /// **'¡Atención Requerida!'**
  String get mortalityAttentionRequired;

  /// No description provided for @mortalityImpactMessage.
  ///
  /// In es, this message translates to:
  /// **'El evento registrado tiene un impacto del {percent}% y requiere atención inmediata.'**
  String mortalityImpactMessage(Object percent);

  /// No description provided for @mortalityCause.
  ///
  /// In es, this message translates to:
  /// **'Causa: {cause}'**
  String mortalityCause(Object cause);

  /// No description provided for @mortalitySeverity.
  ///
  /// In es, this message translates to:
  /// **'Gravedad: {level}/10'**
  String mortalitySeverity(String level);

  /// No description provided for @mortalityContagiousWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta causa es contagiosa. Se recomienda tomar medidas preventivas inmediatas.'**
  String get mortalityContagiousWarning;

  /// No description provided for @mortalityExceedsAvailable.
  ///
  /// In es, this message translates to:
  /// **'La cantidad ({count}) excede las aves disponibles ({available})'**
  String mortalityExceedsAvailable(String available, Object count);

  /// No description provided for @mortalityUserRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre de usuario es requerido'**
  String get mortalityUserRequired;

  /// No description provided for @mortalityUserInvalid.
  ///
  /// In es, this message translates to:
  /// **'ID de usuario inválido'**
  String get mortalityUserInvalid;

  /// No description provided for @mortalityUserNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get mortalityUserNotAuthenticated;

  /// No description provided for @batchFirebaseError.
  ///
  /// In es, this message translates to:
  /// **'Error de Firebase'**
  String get batchFirebaseError;

  /// No description provided for @batchErrorCreatingRecord.
  ///
  /// In es, this message translates to:
  /// **'Error al crear registro'**
  String get batchErrorCreatingRecord;

  /// No description provided for @commonUnderstood.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get commonUnderstood;

  /// No description provided for @consumptionInsufficientStock.
  ///
  /// In es, this message translates to:
  /// **'Stock insuficiente. Disponible: {stock} kg'**
  String consumptionInsufficientStock(String stock);

  /// No description provided for @consumptionInventoryError.
  ///
  /// In es, this message translates to:
  /// **'Consumo registrado, pero hubo un error al actualizar inventario: {error}'**
  String consumptionInventoryError(Object error);

  /// No description provided for @consumptionRegisteredDetail.
  ///
  /// In es, this message translates to:
  /// **'{amount} kg de {type}'**
  String consumptionRegisteredDetail(String amount, Object type);

  /// No description provided for @consumptionNoBirdsAvailable.
  ///
  /// In es, this message translates to:
  /// **'El lote no tiene aves disponibles'**
  String get consumptionNoBirdsAvailable;

  /// No description provided for @consumptionHighAmountTitle.
  ///
  /// In es, this message translates to:
  /// **'Cantidad Alta de Alimento'**
  String get consumptionHighAmountTitle;

  /// No description provided for @consumptionHighAmountMessage.
  ///
  /// In es, this message translates to:
  /// **'Estás registrando {amount} kg de alimento.'**
  String consumptionHighAmountMessage(Object amount);

  /// No description provided for @consumptionPerBird.
  ///
  /// In es, this message translates to:
  /// **'Por ave:'**
  String get consumptionPerBird;

  /// No description provided for @commonCorrect.
  ///
  /// In es, this message translates to:
  /// **'Corregir'**
  String get commonCorrect;

  /// No description provided for @consumptionFoodTypeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Alimento'**
  String get consumptionFoodTypeTitle;

  /// No description provided for @consumptionFoodTypeWarning.
  ///
  /// In es, this message translates to:
  /// **'El tipo \"{type}\" no es el recomendado para {days} días de edad.'**
  String consumptionFoodTypeWarning(Object days, Object type);

  /// No description provided for @consumptionRecommendedType.
  ///
  /// In es, this message translates to:
  /// **'Tipo recomendado:'**
  String get consumptionRecommendedType;

  /// No description provided for @commonReview.
  ///
  /// In es, this message translates to:
  /// **'Revisar'**
  String get commonReview;

  /// No description provided for @consumptionAmountTooHigh.
  ///
  /// In es, this message translates to:
  /// **'La cantidad parece demasiado alta. Verifica el valor.'**
  String get consumptionAmountTooHigh;

  /// No description provided for @consumptionCostNegative.
  ///
  /// In es, this message translates to:
  /// **'El costo por kg no puede ser negativo'**
  String get consumptionCostNegative;

  /// No description provided for @consumptionCostTooHigh.
  ///
  /// In es, this message translates to:
  /// **'El costo parece demasiado alto. Verifica el valor.'**
  String get consumptionCostTooHigh;

  /// No description provided for @batchViewCharts.
  ///
  /// In es, this message translates to:
  /// **'Ver Gráficos'**
  String get batchViewCharts;

  /// No description provided for @batchFilterRecords.
  ///
  /// In es, this message translates to:
  /// **'Filtrar registros'**
  String get batchFilterRecords;

  /// No description provided for @batchTimePeriod.
  ///
  /// In es, this message translates to:
  /// **'Período de tiempo'**
  String get batchTimePeriod;

  /// No description provided for @batchAllTime.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get batchAllTime;

  /// No description provided for @batchNoTimeLimit.
  ///
  /// In es, this message translates to:
  /// **'Sin límite'**
  String get batchNoTimeLimit;

  /// No description provided for @batchLastWeek.
  ///
  /// In es, this message translates to:
  /// **'Última semana'**
  String get batchLastWeek;

  /// No description provided for @batchLastMonth.
  ///
  /// In es, this message translates to:
  /// **'Último mes'**
  String get batchLastMonth;

  /// No description provided for @batchApplyFiltersOrClose.
  ///
  /// In es, this message translates to:
  /// **'{hasFilters, select, true{Aplicar filtros} other{Cerrar}}'**
  String batchApplyFiltersOrClose(String hasFilters);

  /// No description provided for @batchErrorLoadingRecords.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar registros'**
  String get batchErrorLoadingRecords;

  /// No description provided for @historialPostureRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de postura'**
  String get historialPostureRange;

  /// No description provided for @historialAllPostures.
  ///
  /// In es, this message translates to:
  /// **'Todas las posturas'**
  String get historialAllPostures;

  /// No description provided for @historialHighPosture.
  ///
  /// In es, this message translates to:
  /// **'Alta (≥85%)'**
  String get historialHighPosture;

  /// No description provided for @historialMediumPosture.
  ///
  /// In es, this message translates to:
  /// **'Media (70-84%)'**
  String get historialMediumPosture;

  /// No description provided for @historialLowPosture.
  ///
  /// In es, this message translates to:
  /// **'Baja (<70%)'**
  String get historialLowPosture;

  /// No description provided for @historialTotalEggs.
  ///
  /// In es, this message translates to:
  /// **'huevos totales'**
  String get historialTotalEggs;

  /// No description provided for @historialAvgPosture.
  ///
  /// In es, this message translates to:
  /// **'postura promedio'**
  String get historialAvgPosture;

  /// No description provided for @historialRecords.
  ///
  /// In es, this message translates to:
  /// **'registros'**
  String get historialRecords;

  /// No description provided for @historialDailyAvg.
  ///
  /// In es, this message translates to:
  /// **'promedio diario'**
  String get historialDailyAvg;

  /// No description provided for @historialTotalConsumed.
  ///
  /// In es, this message translates to:
  /// **'total consumido'**
  String get historialTotalConsumed;

  /// No description provided for @historialDeadBirds.
  ///
  /// In es, this message translates to:
  /// **'aves fallecidas'**
  String get historialDeadBirds;

  /// No description provided for @historialNoProductionRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de producción'**
  String get historialNoProductionRecords;

  /// No description provided for @historialNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get historialNoResults;

  /// No description provided for @historialRegisterFirstProduction.
  ///
  /// In es, this message translates to:
  /// **'Registra la primera producción de huevos'**
  String get historialRegisterFirstProduction;

  /// No description provided for @historialNoRecordsWithFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay registros con estos filtros'**
  String get historialNoRecordsWithFilters;

  /// No description provided for @historialPostureLabel.
  ///
  /// In es, this message translates to:
  /// **'Postura: '**
  String get historialPostureLabel;

  /// No description provided for @historialGoodLabel.
  ///
  /// In es, this message translates to:
  /// **'Buenos: {count} ({percent}%)'**
  String historialGoodLabel(Object count, Object percent);

  /// No description provided for @historialBirdsLabel.
  ///
  /// In es, this message translates to:
  /// **'Aves: {count}'**
  String historialBirdsLabel(Object count);

  /// No description provided for @historialBrokenLabel.
  ///
  /// In es, this message translates to:
  /// **'Rotos: {count}'**
  String historialBrokenLabel(Object count);

  /// No description provided for @historialAgeLabel.
  ///
  /// In es, this message translates to:
  /// **'Edad: {days} días'**
  String historialAgeLabel(Object days);

  /// No description provided for @detailPosturePercentage.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje postura'**
  String get detailPosturePercentage;

  /// No description provided for @detailBirdAge.
  ///
  /// In es, this message translates to:
  /// **'Edad de las aves'**
  String get detailBirdAge;

  /// No description provided for @detailDaysWeek.
  ///
  /// In es, this message translates to:
  /// **'{days} días (Semana {weeks})'**
  String detailDaysWeek(String weeks, Object days);

  /// No description provided for @detailBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get detailBirdCount;

  /// No description provided for @detailGoodEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos buenos'**
  String get detailGoodEggs;

  /// No description provided for @detailBrokenEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos rotos'**
  String get detailBrokenEggs;

  /// No description provided for @detailDirtyEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos sucios'**
  String get detailDirtyEggs;

  /// No description provided for @detailDoubleYolkEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos doble yema'**
  String get detailDoubleYolkEggs;

  /// No description provided for @detailAvgEggWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio huevo'**
  String get detailAvgEggWeight;

  /// No description provided for @detailRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get detailRegisteredBy;

  /// No description provided for @detailObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get detailObservations;

  /// No description provided for @detailSizeClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación por tamaño'**
  String get detailSizeClassification;

  /// No description provided for @detailPhotoEvidence.
  ///
  /// In es, this message translates to:
  /// **'Evidencia fotográfica'**
  String get detailPhotoEvidence;

  /// No description provided for @historialEggsUnit.
  ///
  /// In es, this message translates to:
  /// **'{count} huevos'**
  String historialEggsUnit(Object count);

  /// No description provided for @historialCauseLabel.
  ///
  /// In es, this message translates to:
  /// **'Causa: '**
  String get historialCauseLabel;

  /// No description provided for @historialDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción: {desc}'**
  String historialDescriptionLabel(String desc);

  /// No description provided for @historialTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo: '**
  String get historialTypeLabel;

  /// No description provided for @historialConsumptionPerBird.
  ///
  /// In es, this message translates to:
  /// **'Consumo/ave: {grams}g'**
  String historialConsumptionPerBird(String grams);

  /// No description provided for @historialNoMortalityRecords.
  ///
  /// In es, this message translates to:
  /// **'No hay registros de mortalidad'**
  String get historialNoMortalityRecords;

  /// No description provided for @historialNoConsumptionRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de consumo'**
  String get historialNoConsumptionRecords;

  /// No description provided for @historialNoConsumptionResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get historialNoConsumptionResults;

  /// No description provided for @historialRegisterFirstConsumption.
  ///
  /// In es, this message translates to:
  /// **'Registra el primer consumo de alimento'**
  String get historialRegisterFirstConsumption;

  /// No description provided for @historialNoRecordsConsumptionFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay registros con estos filtros'**
  String get historialNoRecordsConsumptionFilters;

  /// No description provided for @historialNoProductionData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de producción'**
  String get historialNoProductionData;

  /// No description provided for @historialChartsAppearProduction.
  ///
  /// In es, this message translates to:
  /// **'Los gráficos aparecerán cuando haya registros de producción'**
  String get historialChartsAppearProduction;

  /// No description provided for @historialNoConsumptionData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de consumo'**
  String get historialNoConsumptionData;

  /// No description provided for @historialChartsAppearConsumption.
  ///
  /// In es, this message translates to:
  /// **'Los gráficos aparecerán cuando haya registros de consumo'**
  String get historialChartsAppearConsumption;

  /// No description provided for @historialFilterMortalityCause.
  ///
  /// In es, this message translates to:
  /// **'Causa de mortalidad'**
  String get historialFilterMortalityCause;

  /// No description provided for @historialFilterFoodType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de alimento'**
  String get historialFilterFoodType;

  /// No description provided for @historialFilterAllTypes.
  ///
  /// In es, this message translates to:
  /// **'Todos los tipos'**
  String get historialFilterAllTypes;

  /// No description provided for @detailFoodType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de alimento'**
  String get detailFoodType;

  /// No description provided for @detailBirdsWeighed.
  ///
  /// In es, this message translates to:
  /// **'Aves pesadas'**
  String get detailBirdsWeighed;

  /// No description provided for @detailAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get detailAvgWeight;

  /// No description provided for @detailMinWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso mínimo'**
  String get detailMinWeight;

  /// No description provided for @detailMaxWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso máximo'**
  String get detailMaxWeight;

  /// No description provided for @detailTotalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso total'**
  String get detailTotalWeight;

  /// No description provided for @detailDailyGain.
  ///
  /// In es, this message translates to:
  /// **'Ganancia diaria (GDP)'**
  String get detailDailyGain;

  /// No description provided for @detailCvCoefficient.
  ///
  /// In es, this message translates to:
  /// **'Coef. Variación (CV)'**
  String get detailCvCoefficient;

  /// No description provided for @detailUniformity.
  ///
  /// In es, this message translates to:
  /// **'Uniformidad'**
  String get detailUniformity;

  /// No description provided for @detailUniformityGood.
  ///
  /// In es, this message translates to:
  /// **'Buena (< 10%)'**
  String get detailUniformityGood;

  /// No description provided for @detailUniformityRegular.
  ///
  /// In es, this message translates to:
  /// **'Regular (≥ 10%)'**
  String get detailUniformityRegular;

  /// No description provided for @detailConsumptionPerBird.
  ///
  /// In es, this message translates to:
  /// **'Consumo por ave'**
  String get detailConsumptionPerBird;

  /// No description provided for @detailAccumulatedConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo acumulado'**
  String get detailAccumulatedConsumption;

  /// No description provided for @detailFoodBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote de alimento'**
  String get detailFoodBatch;

  /// No description provided for @detailCostPerKg.
  ///
  /// In es, this message translates to:
  /// **'Costo por kg'**
  String get detailCostPerKg;

  /// No description provided for @detailTotalCost.
  ///
  /// In es, this message translates to:
  /// **'Costo total'**
  String get detailTotalCost;

  /// No description provided for @detailCause.
  ///
  /// In es, this message translates to:
  /// **'Causa'**
  String get detailCause;

  /// No description provided for @detailBirdsBeforeEvent.
  ///
  /// In es, this message translates to:
  /// **'Aves antes del evento'**
  String get detailBirdsBeforeEvent;

  /// No description provided for @detailImpact.
  ///
  /// In es, this message translates to:
  /// **'Impacto'**
  String get detailImpact;

  /// No description provided for @detailDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get detailDescription;

  /// No description provided for @historialBirdsWeighedLabel.
  ///
  /// In es, this message translates to:
  /// **'Aves pesadas: {count}'**
  String historialBirdsWeighedLabel(Object count);

  /// No description provided for @historialFilterWeightRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de peso'**
  String get historialFilterWeightRange;

  /// No description provided for @historialAllWeights.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get historialAllWeights;

  /// No description provided for @historialLow.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get historialLow;

  /// No description provided for @historialNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get historialNormal;

  /// No description provided for @historialHigh.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get historialHigh;

  /// No description provided for @historialNoWeighingRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de pesaje'**
  String get historialNoWeighingRecords;

  /// No description provided for @historialRegisterFirstWeighing.
  ///
  /// In es, this message translates to:
  /// **'Registra el primer pesaje de aves'**
  String get historialRegisterFirstWeighing;

  /// No description provided for @historialNoEventsRecords.
  ///
  /// In es, this message translates to:
  /// **'Historial de eventos'**
  String get historialNoEventsRecords;

  /// No description provided for @historialPerEvent.
  ///
  /// In es, this message translates to:
  /// **'por evento'**
  String get historialPerEvent;

  /// No description provided for @historialAccumulatedRate.
  ///
  /// In es, this message translates to:
  /// **'tasa acumulada'**
  String get historialAccumulatedRate;

  /// No description provided for @historialBirdsUnit.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String historialBirdsUnit(Object count);

  /// No description provided for @historialUserLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario: {name}'**
  String historialUserLabel(Object name);

  /// No description provided for @historialAgeDaysLabel.
  ///
  /// In es, this message translates to:
  /// **'Edad: {days} días'**
  String historialAgeDaysLabel(Object days);

  /// No description provided for @historialNoMortalityExcellent.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente! No hay bajas registradas'**
  String get historialNoMortalityExcellent;

  /// No description provided for @historialAllCauses.
  ///
  /// In es, this message translates to:
  /// **'Todas las causas'**
  String get historialAllCauses;

  /// No description provided for @historialWeighingHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de pesajes'**
  String get historialWeighingHistory;

  /// No description provided for @historialLastWeight.
  ///
  /// In es, this message translates to:
  /// **'último peso'**
  String get historialLastWeight;

  /// No description provided for @historialDailyGainStat.
  ///
  /// In es, this message translates to:
  /// **'ganancia diaria'**
  String get historialDailyGainStat;

  /// No description provided for @historialUniformityCV.
  ///
  /// In es, this message translates to:
  /// **'uniformidad CV'**
  String get historialUniformityCV;

  /// No description provided for @historialMethodLabel.
  ///
  /// In es, this message translates to:
  /// **'Método'**
  String get historialMethodLabel;

  /// No description provided for @historialFilterWeighingMethod.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get historialFilterWeighingMethod;

  /// No description provided for @historialAllMethods.
  ///
  /// In es, this message translates to:
  /// **'Todos los métodos'**
  String get historialAllMethods;

  /// No description provided for @historialGdpLabel.
  ///
  /// In es, this message translates to:
  /// **'GDP: {value}g'**
  String historialGdpLabel(Object value);

  /// No description provided for @historialCvLabel.
  ///
  /// In es, this message translates to:
  /// **'CV: {value}%'**
  String historialCvLabel(Object value);

  /// No description provided for @detailWeighingMethod.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get detailWeighingMethod;

  /// No description provided for @historialNoWeightRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de peso'**
  String get historialNoWeightRecords;

  /// No description provided for @historialRegisterFirstWeighingLote.
  ///
  /// In es, this message translates to:
  /// **'Registra el primer pesaje de tu lote'**
  String get historialRegisterFirstWeighingLote;

  /// No description provided for @historialConsumptionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de consumo'**
  String get historialConsumptionHistory;

  /// No description provided for @historialAvgDaily.
  ///
  /// In es, this message translates to:
  /// **'promedio diario'**
  String get historialAvgDaily;

  /// No description provided for @historialAccumulatedPerBird.
  ///
  /// In es, this message translates to:
  /// **'acumulado/ave'**
  String get historialAccumulatedPerBird;

  /// No description provided for @historialAllFoodTypes.
  ///
  /// In es, this message translates to:
  /// **'Todos los tipos'**
  String get historialAllFoodTypes;

  /// No description provided for @historialBirdNumber.
  ///
  /// In es, this message translates to:
  /// **'Aves: {count}'**
  String historialBirdNumber(Object count);

  /// No description provided for @historialConsumptionValue.
  ///
  /// In es, this message translates to:
  /// **'Consumo/ave: {value}g'**
  String historialConsumptionValue(Object value);

  /// No description provided for @chartsConsumptionTitle.
  ///
  /// In es, this message translates to:
  /// **'Gráficos de Consumo'**
  String get chartsConsumptionTitle;

  /// No description provided for @chartsLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando gráficos...'**
  String get chartsLoading;

  /// No description provided for @chartsErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos'**
  String get chartsErrorLoading;

  /// No description provided for @chartsNoValidData.
  ///
  /// In es, this message translates to:
  /// **'Sin registros con cantidad válida'**
  String get chartsNoValidData;

  /// No description provided for @chartsDailyConsumptionTitle.
  ///
  /// In es, this message translates to:
  /// **'Consumo Diario'**
  String get chartsDailyConsumptionTitle;

  /// No description provided for @chartsDailyConsumptionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Kilogramos de alimento consumido por día'**
  String get chartsDailyConsumptionSubtitle;

  /// No description provided for @chartsConsumptionPerBirdTitle.
  ///
  /// In es, this message translates to:
  /// **'Consumo por Ave'**
  String get chartsConsumptionPerBirdTitle;

  /// No description provided for @chartsConsumptionPerBirdSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gramos de alimento por ave por día'**
  String get chartsConsumptionPerBirdSubtitle;

  /// No description provided for @chartsFoodTypeDistributionTitle.
  ///
  /// In es, this message translates to:
  /// **'Distribución por Tipo'**
  String get chartsFoodTypeDistributionTitle;

  /// No description provided for @chartsFoodTypeDistributionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Consumo total por tipo de alimento (kg)'**
  String get chartsFoodTypeDistributionSubtitle;

  /// No description provided for @chartsCostEvolutionTitle.
  ///
  /// In es, this message translates to:
  /// **'Costos de Alimentación'**
  String get chartsCostEvolutionTitle;

  /// No description provided for @chartsCostEvolutionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gasto total por día en alimentación'**
  String get chartsCostEvolutionSubtitle;

  /// No description provided for @chartsCostNoValidData.
  ///
  /// In es, this message translates to:
  /// **'Sin registros con costo asignado'**
  String get chartsCostNoValidData;

  /// No description provided for @chartsNotEnoughData.
  ///
  /// In es, this message translates to:
  /// **'Sin suficientes datos'**
  String get chartsNotEnoughData;

  /// No description provided for @chartsRegisterMoreToAnalyze.
  ///
  /// In es, this message translates to:
  /// **'Registra más consumos para ver el análisis'**
  String get chartsRegisterMoreToAnalyze;

  /// No description provided for @chartsGraphsAppearWhenData.
  ///
  /// In es, this message translates to:
  /// **'Los gráficos aparecerán cuando haya registros de consumo'**
  String get chartsGraphsAppearWhenData;

  /// No description provided for @chartsMortalityAccumulatedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de bajas sobre inicial'**
  String get chartsMortalityAccumulatedSubtitle;

  /// No description provided for @chartsMortalityDailyTitle.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Diaria'**
  String get chartsMortalityDailyTitle;

  /// No description provided for @chartsMortalityDailySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves por día'**
  String get chartsMortalityDailySubtitle;

  /// No description provided for @chartsMortalityCausesTitle.
  ///
  /// In es, this message translates to:
  /// **'Causas de Mortalidad'**
  String get chartsMortalityCausesTitle;

  /// No description provided for @chartsMortalityCausesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Distribución por motivo principal'**
  String get chartsMortalityCausesSubtitle;

  /// No description provided for @chartsMortalityDistributionCauseTitle.
  ///
  /// In es, this message translates to:
  /// **'Distribución por Causa'**
  String get chartsMortalityDistributionCauseTitle;

  /// No description provided for @chartsMortalityTotalByCauseSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Total de aves por causa de mortalidad'**
  String get chartsMortalityTotalByCauseSubtitle;

  /// No description provided for @commonExcellent.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente!'**
  String get commonExcellent;

  /// No description provided for @mortalityCauseDisease.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad'**
  String get mortalityCauseDisease;

  /// No description provided for @mortalityCauseStress.
  ///
  /// In es, this message translates to:
  /// **'Estrés'**
  String get mortalityCauseStress;

  /// No description provided for @mortalityCauseAccident.
  ///
  /// In es, this message translates to:
  /// **'Accidente'**
  String get mortalityCauseAccident;

  /// No description provided for @mortalityCausePredation.
  ///
  /// In es, this message translates to:
  /// **'Depredación'**
  String get mortalityCausePredation;

  /// No description provided for @mortalityCauseMalnutrition.
  ///
  /// In es, this message translates to:
  /// **'Desnutrición'**
  String get mortalityCauseMalnutrition;

  /// No description provided for @mortalityCauseMetabolic.
  ///
  /// In es, this message translates to:
  /// **'Metabólica'**
  String get mortalityCauseMetabolic;

  /// No description provided for @mortalityCauseSacrifice.
  ///
  /// In es, this message translates to:
  /// **'Sacrificio'**
  String get mortalityCauseSacrifice;

  /// No description provided for @mortalityCauseOldAge.
  ///
  /// In es, this message translates to:
  /// **'Vejez'**
  String get mortalityCauseOldAge;

  /// No description provided for @mortalityCauseUnknown.
  ///
  /// In es, this message translates to:
  /// **'Desconocida'**
  String get mortalityCauseUnknown;

  /// No description provided for @chartsNoMortalityRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin bajas registradas'**
  String get chartsNoMortalityRecords;

  /// No description provided for @chartsGraphsAppearWhenMortality.
  ///
  /// In es, this message translates to:
  /// **'Los gráficos aparecerán cuando se registren bajas'**
  String get chartsGraphsAppearWhenMortality;

  /// No description provided for @chartsMortalityTooltipTotal.
  ///
  /// In es, this message translates to:
  /// **'Total: {count} aves ({percent}%)'**
  String chartsMortalityTooltipTotal(Object count, Object percent);

  /// No description provided for @chartsMortalityTooltipEvent.
  ///
  /// In es, this message translates to:
  /// **'{date}\n{count} aves'**
  String chartsMortalityTooltipEvent(Object count, Object date);

  /// No description provided for @chartsMortalityAcceptable.
  ///
  /// In es, this message translates to:
  /// **'Aceptable'**
  String get chartsMortalityAcceptable;

  /// No description provided for @chartsMortalityAlert.
  ///
  /// In es, this message translates to:
  /// **'Alerta'**
  String get chartsMortalityAlert;

  /// No description provided for @chartsMortalityCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get chartsMortalityCritical;

  /// No description provided for @chartsMortalityPerRegistrationTitle.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad por Registro'**
  String get chartsMortalityPerRegistrationTitle;

  /// No description provided for @chartsMortalityPerRegistrationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves por cada evento registrado'**
  String get chartsMortalityPerRegistrationSubtitle;

  /// No description provided for @chartsNoCauseData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de causas'**
  String get chartsNoCauseData;

  /// No description provided for @chartsWeightTooltipEvolution.
  ///
  /// In es, this message translates to:
  /// **'📈 Evolución\n📅 {date}\n⚖️ {weight} kg\n🐣 Día {age}'**
  String chartsWeightTooltipEvolution(String date, String weight, String age);

  /// No description provided for @chartsWeightTooltipADG.
  ///
  /// In es, this message translates to:
  /// **'📈 Ganancia diaria\n📅 {date}\n🐣 Día {age}\n📊 {gain} g/día'**
  String chartsWeightTooltipADG(String date, String age, String gain);

  /// No description provided for @chartsWeightTooltipUniformity.
  ///
  /// In es, this message translates to:
  /// **'📈 Uniformidad\n📅 {date}\n📊 CV: {value}%\n{estado}'**
  String chartsWeightTooltipUniformity(
    String date,
    String value,
    String estado,
  );

  /// No description provided for @chartsWeightTooltipComparison.
  ///
  /// In es, this message translates to:
  /// **'📊 Real: {real} kg\n📈 Estándar: {standard} kg\n{emoji} Dif: {sign}{diff} kg'**
  String chartsWeightTooltipComparison(
    String diff,
    String emoji,
    String standard,
    String sign,
    String real,
  );

  /// No description provided for @chartsProductionTooltipPosture.
  ///
  /// In es, this message translates to:
  /// **'{emoji} {date}\n{percentage}% de postura'**
  String chartsProductionTooltipPosture(
    Object date,
    Object emoji,
    Object percentage,
  );

  /// No description provided for @chartsProductionTooltipDaily.
  ///
  /// In es, this message translates to:
  /// **'ðŸ¥š {date}\n{count} huevos recolectados'**
  String chartsProductionTooltipDaily(Object count, Object date);

  /// No description provided for @chartsWeightEvolutionTitle.
  ///
  /// In es, this message translates to:
  /// **'Evolución de Peso'**
  String get chartsWeightEvolutionTitle;

  /// No description provided for @chartsWeightEvolutionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio a lo largo del tiempo'**
  String get chartsWeightEvolutionSubtitle;

  /// No description provided for @chartsWeightADGTitle.
  ///
  /// In es, this message translates to:
  /// **'Ganancia Diaria de Peso'**
  String get chartsWeightADGTitle;

  /// No description provided for @chartsWeightADGSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gramos ganados por día'**
  String get chartsWeightADGSubtitle;

  /// No description provided for @chartsWeightUniformityTitle.
  ///
  /// In es, this message translates to:
  /// **'Uniformidad del Lote'**
  String get chartsWeightUniformityTitle;

  /// No description provided for @chartsWeightUniformitySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Coeficiente de variación del peso'**
  String get chartsWeightUniformitySubtitle;

  /// No description provided for @chartsWeightUniformityExcellent.
  ///
  /// In es, this message translates to:
  /// **'Excelente uniformidad'**
  String get chartsWeightUniformityExcellent;

  /// No description provided for @chartsWeightUniformityGood.
  ///
  /// In es, this message translates to:
  /// **'Buena uniformidad'**
  String get chartsWeightUniformityGood;

  /// No description provided for @chartsWeightUniformityImprove.
  ///
  /// In es, this message translates to:
  /// **'Necesita mejorar'**
  String get chartsWeightUniformityImprove;

  /// No description provided for @chartsWeightComparisonTitle.
  ///
  /// In es, this message translates to:
  /// **'Comparación con Estándar'**
  String get chartsWeightComparisonTitle;

  /// No description provided for @chartsWeightComparisonSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Peso real vs peso estándar de la raza'**
  String get chartsWeightComparisonSubtitle;

  /// No description provided for @commonActual.
  ///
  /// In es, this message translates to:
  /// **'Real'**
  String get commonActual;

  /// No description provided for @commonStandard.
  ///
  /// In es, this message translates to:
  /// **'Estándar'**
  String get commonStandard;

  /// No description provided for @chartsProductionDailyTitle.
  ///
  /// In es, this message translates to:
  /// **'Producción Diaria'**
  String get chartsProductionDailyTitle;

  /// No description provided for @chartsProductionDailySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Huevos recolectados por día'**
  String get chartsProductionDailySubtitle;

  /// No description provided for @chartsProductionQualityTitle.
  ///
  /// In es, this message translates to:
  /// **'Calidad de Huevos'**
  String get chartsProductionQualityTitle;

  /// No description provided for @chartsProductionQualitySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Distribución por tipo de huevo'**
  String get chartsProductionQualitySubtitle;

  /// No description provided for @eggTypeGood.
  ///
  /// In es, this message translates to:
  /// **'Buenos'**
  String get eggTypeGood;

  /// No description provided for @eggTypeBroken.
  ///
  /// In es, this message translates to:
  /// **'Rotos'**
  String get eggTypeBroken;

  /// No description provided for @eggTypeDirty.
  ///
  /// In es, this message translates to:
  /// **'Sucios'**
  String get eggTypeDirty;

  /// No description provided for @eggTypeDoubleYolk.
  ///
  /// In es, this message translates to:
  /// **'Doble yema'**
  String get eggTypeDoubleYolk;

  /// No description provided for @homeSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar granja'**
  String get homeSelectFarm;

  /// No description provided for @homeHaveCode.
  ///
  /// In es, this message translates to:
  /// **'¿Tienes un código?'**
  String get homeHaveCode;

  /// No description provided for @homeJoinFarmWithInvitation.
  ///
  /// In es, this message translates to:
  /// **'Únete a una granja con invitación'**
  String get homeJoinFarmWithInvitation;

  /// No description provided for @homeNoFarmsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No tienes granjas registradas'**
  String get homeNoFarmsRegistered;

  /// No description provided for @homeHaveInvitationCode.
  ///
  /// In es, this message translates to:
  /// **'¿Tienes un código de invitación?'**
  String get homeHaveInvitationCode;

  /// No description provided for @homeHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get homeHealth;

  /// No description provided for @homeAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get homeAlerts;

  /// No description provided for @homeOutOfStock.
  ///
  /// In es, this message translates to:
  /// **'Productos agotados'**
  String get homeOutOfStock;

  /// No description provided for @homeLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo'**
  String get homeLowStock;

  /// No description provided for @homeRecentActivity.
  ///
  /// In es, this message translates to:
  /// **'Actividad Reciente'**
  String get homeRecentActivity;

  /// No description provided for @homeLast7Days.
  ///
  /// In es, this message translates to:
  /// **'Últimos 7 días'**
  String get homeLast7Days;

  /// No description provided for @homeRightNow.
  ///
  /// In es, this message translates to:
  /// **'Ahora mismo'**
  String get homeRightNow;

  /// No description provided for @homeAgoMinutes.
  ///
  /// In es, this message translates to:
  /// **'Hace {minutes} min'**
  String homeAgoMinutes(Object minutes);

  /// No description provided for @homeAgoHoursOne.
  ///
  /// In es, this message translates to:
  /// **'Hace {hours} hora'**
  String homeAgoHoursOne(Object hours);

  /// No description provided for @homeAgoHoursOther.
  ///
  /// In es, this message translates to:
  /// **'Hace {hours} horas'**
  String homeAgoHoursOther(Object hours);

  /// No description provided for @homeYesterdayAt.
  ///
  /// In es, this message translates to:
  /// **'Ayer a las {time}'**
  String homeYesterdayAt(Object time);

  /// No description provided for @homeAgoDays.
  ///
  /// In es, this message translates to:
  /// **'Hace {days} días'**
  String homeAgoDays(Object days);

  /// No description provided for @homeNoRecentActivity.
  ///
  /// In es, this message translates to:
  /// **'Sin actividad reciente'**
  String get homeNoRecentActivity;

  /// No description provided for @homeNoRecentActivityDesc.
  ///
  /// In es, this message translates to:
  /// **'Los registros de producción, mortalidad,\nconsumo, inventario, ventas, costos\ny salud aparecerán aquí'**
  String get homeNoRecentActivityDesc;

  /// No description provided for @homeErrorLoadingActivities.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar actividades'**
  String get homeErrorLoadingActivities;

  /// No description provided for @homeTryReloadPage.
  ///
  /// In es, this message translates to:
  /// **'Intente recargar la página'**
  String get homeTryReloadPage;

  /// No description provided for @homeProductsOutOfStockCount.
  ///
  /// In es, this message translates to:
  /// **'{count} productos sin stock'**
  String homeProductsOutOfStockCount(Object count);

  /// No description provided for @homeProductsLowStockCount.
  ///
  /// In es, this message translates to:
  /// **'{count} productos con stock bajo'**
  String homeProductsLowStockCount(Object count);

  /// No description provided for @homeProductsExpiringSoonCount.
  ///
  /// In es, this message translates to:
  /// **'{count} productos por vencer'**
  String homeProductsExpiringSoonCount(Object count);

  /// No description provided for @homeMortalityPercent.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad del {percent}% en lotes activos'**
  String homeMortalityPercent(Object percent);

  /// No description provided for @homeStatsAppearHere.
  ///
  /// In es, this message translates to:
  /// **'Las estadísticas se mostrarán aquí'**
  String get homeStatsAppearHere;

  /// No description provided for @homeOccupancyLow.
  ///
  /// In es, this message translates to:
  /// **'Ocupación baja'**
  String get homeOccupancyLow;

  /// No description provided for @homeOccupancyMedium.
  ///
  /// In es, this message translates to:
  /// **'Ocupación media'**
  String get homeOccupancyMedium;

  /// No description provided for @homeOccupancyHigh.
  ///
  /// In es, this message translates to:
  /// **'Ocupación alta'**
  String get homeOccupancyHigh;

  /// No description provided for @homeOccupancyMax.
  ///
  /// In es, this message translates to:
  /// **'Ocupación máxima'**
  String get homeOccupancyMax;

  /// No description provided for @homeNoCapacityDefined.
  ///
  /// In es, this message translates to:
  /// **'Sin capacidad definida'**
  String get homeNoCapacityDefined;

  /// No description provided for @homeCouldNotLoad.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar'**
  String get homeCouldNotLoad;

  /// No description provided for @homeWhatsappHelp.
  ///
  /// In es, this message translates to:
  /// **'¿En qué podemos ayudarte?'**
  String get homeWhatsappHelp;

  /// No description provided for @homeWhatsappContact.
  ///
  /// In es, this message translates to:
  /// **'Contáctanos por WhatsApp'**
  String get homeWhatsappContact;

  /// No description provided for @homeWhatsappSupport.
  ///
  /// In es, this message translates to:
  /// **'Soporte técnico'**
  String get homeWhatsappSupport;

  /// No description provided for @homeWhatsappNeedHelp.
  ///
  /// In es, this message translates to:
  /// **'Necesito ayuda con la aplicación'**
  String get homeWhatsappNeedHelp;

  /// No description provided for @homeWhatsappReportProblem.
  ///
  /// In es, this message translates to:
  /// **'Reportar un problema'**
  String get homeWhatsappReportProblem;

  /// No description provided for @homeWhatsappSuggestImprovement.
  ///
  /// In es, this message translates to:
  /// **'Sugerir una mejora'**
  String get homeWhatsappSuggestImprovement;

  /// No description provided for @homeWhatsappWorkTogether.
  ///
  /// In es, this message translates to:
  /// **'Trabajar juntos'**
  String get homeWhatsappWorkTogether;

  /// No description provided for @homeWhatsappPlansAndPricing.
  ///
  /// In es, this message translates to:
  /// **'Planes y precios'**
  String get homeWhatsappPlansAndPricing;

  /// No description provided for @homeWhatsappOtherTopic.
  ///
  /// In es, this message translates to:
  /// **'Otro tema'**
  String get homeWhatsappOtherTopic;

  /// No description provided for @homeWhatsappCouldNotOpen.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir WhatsApp'**
  String get homeWhatsappCouldNotOpen;

  /// No description provided for @homeNoOccupancy.
  ///
  /// In es, this message translates to:
  /// **'Sin ocupación'**
  String get homeNoOccupancy;

  /// No description provided for @homeSelectAFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get homeSelectAFarm;

  /// No description provided for @homeTotalShedsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} en total'**
  String homeTotalShedsCount(Object count);

  /// No description provided for @homeTotalBatchesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} lotes en total'**
  String homeTotalBatchesCount(Object count);

  /// No description provided for @homeInvTotal.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get homeInvTotal;

  /// No description provided for @homeInvLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get homeInvLowStock;

  /// No description provided for @homeInvOutOfStock.
  ///
  /// In es, this message translates to:
  /// **'Agotados'**
  String get homeInvOutOfStock;

  /// No description provided for @homeInvExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Por Vencer'**
  String get homeInvExpiringSoon;

  /// No description provided for @homeSetupInventory.
  ///
  /// In es, this message translates to:
  /// **'Configura tu inventario'**
  String get homeSetupInventory;

  /// No description provided for @homeSetupInventoryDesc.
  ///
  /// In es, this message translates to:
  /// **'Agrega alimentos, medicamentos y más para controlar tu stock'**
  String get homeSetupInventoryDesc;

  /// No description provided for @homeInvAttention.
  ///
  /// In es, this message translates to:
  /// **'Atención: {details}'**
  String homeInvAttention(String details);

  /// No description provided for @homeInvOutOfStockCount.
  ///
  /// In es, this message translates to:
  /// **'{count} agotados'**
  String homeInvOutOfStockCount(Object count);

  /// No description provided for @homeInvLowStockCount.
  ///
  /// In es, this message translates to:
  /// **'{count} con stock bajo'**
  String homeInvLowStockCount(Object count);

  /// No description provided for @homeInvExpiringSoonCount.
  ///
  /// In es, this message translates to:
  /// **'{count} próximos a vencer'**
  String homeInvExpiringSoonCount(Object count);

  /// No description provided for @homeWhatsappFoundBug.
  ///
  /// In es, this message translates to:
  /// **'Encontré un error o fallo'**
  String get homeWhatsappFoundBug;

  /// No description provided for @homeWhatsappHaveIdea.
  ///
  /// In es, this message translates to:
  /// **'Tengo una idea para mejorar la app'**
  String get homeWhatsappHaveIdea;

  /// No description provided for @homeWhatsappCollaboration.
  ///
  /// In es, this message translates to:
  /// **'Colaboración o alianza comercial'**
  String get homeWhatsappCollaboration;

  /// No description provided for @homeWhatsappLicenseInfo.
  ///
  /// In es, this message translates to:
  /// **'Información sobre licencias y planes'**
  String get homeWhatsappLicenseInfo;

  /// No description provided for @homeWhatsappGeneralInquiry.
  ///
  /// In es, this message translates to:
  /// **'Consulta general'**
  String get homeWhatsappGeneralInquiry;

  /// No description provided for @batchError.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get batchError;

  /// No description provided for @batchNotFound.
  ///
  /// In es, this message translates to:
  /// **'Lote no encontrado'**
  String get batchNotFound;

  /// No description provided for @batchNotFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'El lote no fue encontrado'**
  String get batchNotFoundMessage;

  /// No description provided for @batchMayHaveBeenDeleted.
  ///
  /// In es, this message translates to:
  /// **'Puede que haya sido eliminado o movido'**
  String get batchMayHaveBeenDeleted;

  /// No description provided for @batchCouldNotLoad.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el lote'**
  String get batchCouldNotLoad;

  /// No description provided for @batchEditCode.
  ///
  /// In es, this message translates to:
  /// **'Editar: {code}'**
  String batchEditCode(Object code);

  /// No description provided for @batchUpdateBatch.
  ///
  /// In es, this message translates to:
  /// **'Actualizar Lote'**
  String get batchUpdateBatch;

  /// No description provided for @batchCodeRequired.
  ///
  /// In es, this message translates to:
  /// **'El código es obligatorio'**
  String get batchCodeRequired;

  /// No description provided for @batchSelectBirdType.
  ///
  /// In es, this message translates to:
  /// **'Seleccione el tipo de ave'**
  String get batchSelectBirdType;

  /// No description provided for @batchSelectShed.
  ///
  /// In es, this message translates to:
  /// **'Debe seleccionar un galpón'**
  String get batchSelectShed;

  /// No description provided for @batchInitialCountRequired.
  ///
  /// In es, this message translates to:
  /// **'La cantidad inicial es obligatoria'**
  String get batchInitialCountRequired;

  /// No description provided for @batchErrorUpdating.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar lote'**
  String get batchErrorUpdating;

  /// No description provided for @batchUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Lote actualizado con éxito!'**
  String get batchUpdateSuccess;

  /// No description provided for @batchChangesSaved.
  ///
  /// In es, this message translates to:
  /// **'Los cambios se han guardado correctamente'**
  String get batchChangesSaved;

  /// No description provided for @batchChangesWillBeLost.
  ///
  /// In es, this message translates to:
  /// **'Los cambios que has realizado se perderán.'**
  String get batchChangesWillBeLost;

  /// No description provided for @batchOperationSuccess.
  ///
  /// In es, this message translates to:
  /// **'Operación exitosa'**
  String get batchOperationSuccess;

  /// No description provided for @batchDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote eliminado'**
  String get batchDeletedSuccess;

  /// No description provided for @batchSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, código o tipo...'**
  String get batchSearchHint;

  /// No description provided for @batchAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get batchAll;

  /// No description provided for @batchNoFarms.
  ///
  /// In es, this message translates to:
  /// **'Sin granjas'**
  String get batchNoFarms;

  /// No description provided for @batchCreateFarmFirst.
  ///
  /// In es, this message translates to:
  /// **'Crea una granja primero para agregar lotes'**
  String get batchCreateFarmFirst;

  /// No description provided for @batchCreateFarm.
  ///
  /// In es, this message translates to:
  /// **'Crear granja'**
  String get batchCreateFarm;

  /// No description provided for @batchErrorLoadingBatches.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get batchErrorLoadingBatches;

  /// No description provided for @batchSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get batchSelectFarm;

  /// No description provided for @batchSelectFarmName.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar granja {name}'**
  String batchSelectFarmName(Object name);

  /// No description provided for @batchNoRegistered.
  ///
  /// In es, this message translates to:
  /// **'Sin lotes registrados'**
  String get batchNoRegistered;

  /// No description provided for @batchRegisterFirst.
  ///
  /// In es, this message translates to:
  /// **'Registra tu primer lote de aves para comenzar a monitorear tu producción'**
  String get batchRegisterFirst;

  /// No description provided for @batchNotFoundFilter.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron lotes'**
  String get batchNotFoundFilter;

  /// No description provided for @batchAdjustFilters.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar los filtros o buscar con otros términos'**
  String get batchAdjustFilters;

  /// No description provided for @batchFarmWithBatchesLabel.
  ///
  /// In es, this message translates to:
  /// **'Granja {name} con {count} lotes'**
  String batchFarmWithBatchesLabel(Object count, Object name);

  /// No description provided for @batchShedBatches.
  ///
  /// In es, this message translates to:
  /// **'Lotes del Galpón'**
  String get batchShedBatches;

  /// No description provided for @batchCreateNewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Crear nuevo lote'**
  String get batchCreateNewTooltip;

  /// No description provided for @batchStatusUpdatedTo.
  ///
  /// In es, this message translates to:
  /// **'Estado actualizado a {status}'**
  String batchStatusUpdatedTo(Object status);

  /// No description provided for @batchDeleteMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará el lote \"{code}\" y todos sus registros. Esta acción no se puede deshacer.'**
  String batchDeleteMessage(Object code);

  /// No description provided for @batchErrorDeletingDetail.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String batchErrorDeletingDetail(Object error);

  /// No description provided for @batchDeletedCorrectly.
  ///
  /// In es, this message translates to:
  /// **'Lote eliminado correctamente'**
  String get batchDeletedCorrectly;

  /// No description provided for @batchCannotCreateWithoutShed.
  ///
  /// In es, this message translates to:
  /// **'No se puede crear lote sin galpón'**
  String get batchCannotCreateWithoutShed;

  /// No description provided for @batchCannotViewWithoutShed.
  ///
  /// In es, this message translates to:
  /// **'No se puede ver detalle sin galpón'**
  String get batchCannotViewWithoutShed;

  /// No description provided for @batchCannotEditWithoutShed.
  ///
  /// In es, this message translates to:
  /// **'No se puede editar sin galpón'**
  String get batchCannotEditWithoutShed;

  /// No description provided for @batchCurrentStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado actual:'**
  String get batchCurrentStatus;

  /// No description provided for @batchSelectNewStatus.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar nuevo estado:'**
  String get batchSelectNewStatus;

  /// No description provided for @batchConfirmStateChange.
  ///
  /// In es, this message translates to:
  /// **'¿Confirmar cambio a {status}?'**
  String batchConfirmStateChange(Object status);

  /// No description provided for @batchPermanentStateWarning.
  ///
  /// In es, this message translates to:
  /// **'Este estado es permanente y no podrá revertirse.'**
  String get batchPermanentStateWarning;

  /// No description provided for @batchPermanentState.
  ///
  /// In es, this message translates to:
  /// **'Estado permanente'**
  String get batchPermanentState;

  /// No description provided for @batchCycleProgress.
  ///
  /// In es, this message translates to:
  /// **'Progreso del ciclo'**
  String get batchCycleProgress;

  /// No description provided for @batchDayOfCycle.
  ///
  /// In es, this message translates to:
  /// **'Día {day} de {total}'**
  String batchDayOfCycle(String day, Object total);

  /// No description provided for @batchCycleCompleted.
  ///
  /// In es, this message translates to:
  /// **'Día {day} - Ciclo completado'**
  String batchCycleCompleted(Object day);

  /// No description provided for @batchExtraDays.
  ///
  /// In es, this message translates to:
  /// **'Día {day} ({extra} extra)'**
  String batchExtraDays(String extra, Object day);

  /// No description provided for @batchEntryLabel.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get batchEntryLabel;

  /// No description provided for @batchLiveBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Vivas'**
  String get batchLiveBirds;

  /// No description provided for @batchTotalLosses.
  ///
  /// In es, this message translates to:
  /// **'Bajas Totales'**
  String get batchTotalLosses;

  /// No description provided for @batchAttention.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get batchAttention;

  /// No description provided for @batchKeyIndicators.
  ///
  /// In es, this message translates to:
  /// **'Indicadores clave'**
  String get batchKeyIndicators;

  /// No description provided for @batchOfInitial.
  ///
  /// In es, this message translates to:
  /// **'del lote inicial'**
  String get batchOfInitial;

  /// No description provided for @batchBirdsLost.
  ///
  /// In es, this message translates to:
  /// **'aves perdidas'**
  String get batchBirdsLost;

  /// No description provided for @batchExpected.
  ///
  /// In es, this message translates to:
  /// **'esperado'**
  String get batchExpected;

  /// No description provided for @batchCurrentWeight.
  ///
  /// In es, this message translates to:
  /// **'peso actual'**
  String get batchCurrentWeight;

  /// No description provided for @batchDailyGain.
  ///
  /// In es, this message translates to:
  /// **'ganancia diaria'**
  String get batchDailyGain;

  /// No description provided for @batchGoal.
  ///
  /// In es, this message translates to:
  /// **'meta'**
  String get batchGoal;

  /// No description provided for @batchFoodConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo de Alimento'**
  String get batchFoodConsumption;

  /// No description provided for @batchTotalAccumulated.
  ///
  /// In es, this message translates to:
  /// **'total acumulado'**
  String get batchTotalAccumulated;

  /// No description provided for @batchPerBird.
  ///
  /// In es, this message translates to:
  /// **'por ave'**
  String get batchPerBird;

  /// No description provided for @batchDailyExpectedPerBird.
  ///
  /// In es, this message translates to:
  /// **'diario esperado/ave'**
  String get batchDailyExpectedPerBird;

  /// No description provided for @batchCurrentIndex.
  ///
  /// In es, this message translates to:
  /// **'índice actual'**
  String get batchCurrentIndex;

  /// No description provided for @batchKgFood.
  ///
  /// In es, this message translates to:
  /// **'kg alimento'**
  String get batchKgFood;

  /// No description provided for @batchPerKgWeight.
  ///
  /// In es, this message translates to:
  /// **'por kg de peso'**
  String get batchPerKgWeight;

  /// No description provided for @batchOptimalRange.
  ///
  /// In es, this message translates to:
  /// **'rango óptimo'**
  String get batchOptimalRange;

  /// No description provided for @batchEggProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción de Huevos'**
  String get batchEggProduction;

  /// No description provided for @batchTotalEggs.
  ///
  /// In es, this message translates to:
  /// **'huevos totales'**
  String get batchTotalEggs;

  /// No description provided for @batchEggsPerBird.
  ///
  /// In es, this message translates to:
  /// **'huevos por ave'**
  String get batchEggsPerBird;

  /// No description provided for @batchExpectedLaying.
  ///
  /// In es, this message translates to:
  /// **'postura esperada'**
  String get batchExpectedLaying;

  /// No description provided for @batchHighMortalityAlert.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad elevada, revise el lote'**
  String get batchHighMortalityAlert;

  /// No description provided for @batchWeightBelowTarget.
  ///
  /// In es, this message translates to:
  /// **'Peso por debajo del objetivo'**
  String get batchWeightBelowTarget;

  /// No description provided for @batchOverdueClose.
  ///
  /// In es, this message translates to:
  /// **'Cierre vencido hace {days} días'**
  String batchOverdueClose(Object days);

  /// No description provided for @batchCloseUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Cierre próximo en {days} días'**
  String batchCloseUpcoming(Object days);

  /// No description provided for @batchHighConversionAlert.
  ///
  /// In es, this message translates to:
  /// **'Índice de conversión alto'**
  String get batchHighConversionAlert;

  /// No description provided for @batchLevelOptimal.
  ///
  /// In es, this message translates to:
  /// **'Óptimo'**
  String get batchLevelOptimal;

  /// No description provided for @batchLevelNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get batchLevelNormal;

  /// No description provided for @batchLevelHigh.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get batchLevelHigh;

  /// No description provided for @batchLevelCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get batchLevelCritical;

  /// No description provided for @batchMortLevelExcellent.
  ///
  /// In es, this message translates to:
  /// **'Excelente'**
  String get batchMortLevelExcellent;

  /// No description provided for @batchMortLevelElevated.
  ///
  /// In es, this message translates to:
  /// **'Elevada'**
  String get batchMortLevelElevated;

  /// No description provided for @batchMortLevelCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get batchMortLevelCritical;

  /// No description provided for @batchWeightLevelAcceptable.
  ///
  /// In es, this message translates to:
  /// **'Aceptable'**
  String get batchWeightLevelAcceptable;

  /// No description provided for @batchWeightLevelLow.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get batchWeightLevelLow;

  /// No description provided for @batchQualityGood.
  ///
  /// In es, this message translates to:
  /// **'Buena'**
  String get batchQualityGood;

  /// No description provided for @batchQualityRegular.
  ///
  /// In es, this message translates to:
  /// **'Regular'**
  String get batchQualityRegular;

  /// No description provided for @batchQualityLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get batchQualityLow;

  /// No description provided for @batchRegisterMortality.
  ///
  /// In es, this message translates to:
  /// **'Registrar Mortalidad'**
  String get batchRegisterMortality;

  /// No description provided for @batchRegisterWeight.
  ///
  /// In es, this message translates to:
  /// **'Registrar Peso'**
  String get batchRegisterWeight;

  /// No description provided for @batchRegisterConsumption.
  ///
  /// In es, this message translates to:
  /// **'Registrar Consumo'**
  String get batchRegisterConsumption;

  /// No description provided for @batchRegisterProduction.
  ///
  /// In es, this message translates to:
  /// **'Registrar Producción'**
  String get batchRegisterProduction;

  /// No description provided for @batchTabMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get batchTabMortality;

  /// No description provided for @batchTabWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get batchTabWeight;

  /// No description provided for @batchTabConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo'**
  String get batchTabConsumption;

  /// No description provided for @batchTabProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción'**
  String get batchTabProduction;

  /// No description provided for @batchTabHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get batchTabHistory;

  /// No description provided for @batchTabVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get batchTabVaccination;

  /// No description provided for @batchNavSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get batchNavSummary;

  /// No description provided for @batchPutInQuarantine.
  ///
  /// In es, this message translates to:
  /// **'Poner en Cuarentena'**
  String get batchPutInQuarantine;

  /// No description provided for @batchQuarantineConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de poner \"{code}\" en cuarentena?'**
  String batchQuarantineConfirm(Object code);

  /// No description provided for @batchQuarantineReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Sospecha de enfermedad'**
  String get batchQuarantineReasonHint;

  /// No description provided for @batchAlreadyInQuarantine.
  ///
  /// In es, this message translates to:
  /// **'El lote ya está en cuarentena'**
  String get batchAlreadyInQuarantine;

  /// No description provided for @batchQuarantineReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo de cuarentena'**
  String get batchQuarantineReason;

  /// No description provided for @batchPutInQuarantineSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote puesto en cuarentena'**
  String get batchPutInQuarantineSuccess;

  /// No description provided for @batchAlreadyClosed.
  ///
  /// In es, this message translates to:
  /// **'El lote ya está cerrado'**
  String get batchAlreadyClosed;

  /// No description provided for @batchInfoCopied.
  ///
  /// In es, this message translates to:
  /// **'Información copiada al portapapeles'**
  String get batchInfoCopied;

  /// No description provided for @batchCannotDeleteActive.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar un lote activo'**
  String get batchCannotDeleteActive;

  /// No description provided for @batchDescribeReason.
  ///
  /// In es, this message translates to:
  /// **'Describe el motivo...'**
  String get batchDescribeReason;

  /// No description provided for @batchReasonForState.
  ///
  /// In es, this message translates to:
  /// **'Motivo de {status}'**
  String batchReasonForState(Object status);

  /// No description provided for @batchBatchHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial del Lote'**
  String get batchBatchHistory;

  /// No description provided for @batchHistoryComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Historial próximamente'**
  String get batchHistoryComingSoon;

  /// No description provided for @batchRequiresAttention.
  ///
  /// In es, this message translates to:
  /// **'Requiere Atención'**
  String get batchRequiresAttention;

  /// No description provided for @batchNeedsReview.
  ///
  /// In es, this message translates to:
  /// **'Este lote necesita revisión'**
  String get batchNeedsReview;

  /// No description provided for @batchOverdue.
  ///
  /// In es, this message translates to:
  /// **'Vencido'**
  String get batchOverdue;

  /// No description provided for @batchOfBirds.
  ///
  /// In es, this message translates to:
  /// **'de {count} aves'**
  String batchOfBirds(Object count);

  /// No description provided for @batchWithinLimits.
  ///
  /// In es, this message translates to:
  /// **'Dentro de límites aceptables'**
  String get batchWithinLimits;

  /// No description provided for @batchIndicators.
  ///
  /// In es, this message translates to:
  /// **'Indicadores'**
  String get batchIndicators;

  /// No description provided for @batchWeeks.
  ///
  /// In es, this message translates to:
  /// **'semanas'**
  String get batchWeeks;

  /// No description provided for @batchAverage.
  ///
  /// In es, this message translates to:
  /// **'promedio'**
  String get batchAverage;

  /// No description provided for @batchMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get batchMortality;

  /// No description provided for @batchOfAmount.
  ///
  /// In es, this message translates to:
  /// **'de {count}'**
  String batchOfAmount(Object count);

  /// No description provided for @batchQuickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get batchQuickActions;

  /// No description provided for @batchBatchStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado del Lote'**
  String get batchBatchStatus;

  /// No description provided for @batchGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get batchGeneralInfo;

  /// No description provided for @batchCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get batchCodeLabel;

  /// No description provided for @batchSupplier.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get batchSupplier;

  /// No description provided for @batchLatestRecords.
  ///
  /// In es, this message translates to:
  /// **'Últimos Registros'**
  String get batchLatestRecords;

  /// No description provided for @batchNoRecentRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros recientes'**
  String get batchNoRecentRecords;

  /// No description provided for @batchRecordsWillAppear.
  ///
  /// In es, this message translates to:
  /// **'Los registros aparecerán aquí'**
  String get batchRecordsWillAppear;

  /// No description provided for @batchErrorLoadingBatch.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el lote'**
  String get batchErrorLoadingBatch;

  /// No description provided for @batchEditBatchTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar lote'**
  String get batchEditBatchTooltip;

  /// No description provided for @batchNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get batchNotes;

  /// No description provided for @batchErrorDetail.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String batchErrorDetail(Object error);

  /// No description provided for @batchStatusDescActive.
  ///
  /// In es, this message translates to:
  /// **'El lote está en producción activa'**
  String get batchStatusDescActive;

  /// No description provided for @batchStatusDescClosed.
  ///
  /// In es, this message translates to:
  /// **'El lote ha sido cerrado'**
  String get batchStatusDescClosed;

  /// No description provided for @batchStatusDescQuarantine.
  ///
  /// In es, this message translates to:
  /// **'El lote está en cuarentena'**
  String get batchStatusDescQuarantine;

  /// No description provided for @batchStatusDescSold.
  ///
  /// In es, this message translates to:
  /// **'El lote ha sido vendido'**
  String get batchStatusDescSold;

  /// No description provided for @batchStatusDescTransfer.
  ///
  /// In es, this message translates to:
  /// **'El lote ha sido transferido'**
  String get batchStatusDescTransfer;

  /// No description provided for @batchStatusDescSuspended.
  ///
  /// In es, this message translates to:
  /// **'El lote está suspendido'**
  String get batchStatusDescSuspended;

  /// No description provided for @batchCreating.
  ///
  /// In es, this message translates to:
  /// **'Creando lote...'**
  String get batchCreating;

  /// No description provided for @batchUpdating.
  ///
  /// In es, this message translates to:
  /// **'Actualizando lote...'**
  String get batchUpdating;

  /// No description provided for @batchDeleting.
  ///
  /// In es, this message translates to:
  /// **'Eliminando lote...'**
  String get batchDeleting;

  /// No description provided for @batchRegisteringMortality.
  ///
  /// In es, this message translates to:
  /// **'Registrando mortalidad...'**
  String get batchRegisteringMortality;

  /// No description provided for @batchMortalityRegistered.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad registrada'**
  String get batchMortalityRegistered;

  /// No description provided for @batchRegisteringDiscard.
  ///
  /// In es, this message translates to:
  /// **'Registrando descarte...'**
  String get batchRegisteringDiscard;

  /// No description provided for @batchDiscardRegistered.
  ///
  /// In es, this message translates to:
  /// **'Descarte registrado'**
  String get batchDiscardRegistered;

  /// No description provided for @batchRegisteringSale.
  ///
  /// In es, this message translates to:
  /// **'Registrando venta...'**
  String get batchRegisteringSale;

  /// No description provided for @batchSaleRegistered.
  ///
  /// In es, this message translates to:
  /// **'Venta registrada'**
  String get batchSaleRegistered;

  /// No description provided for @batchUpdatingWeight.
  ///
  /// In es, this message translates to:
  /// **'Actualizando peso...'**
  String get batchUpdatingWeight;

  /// No description provided for @batchWeightUpdated.
  ///
  /// In es, this message translates to:
  /// **'Peso actualizado'**
  String get batchWeightUpdated;

  /// No description provided for @batchChangingStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiando estado...'**
  String get batchChangingStatus;

  /// No description provided for @batchStatusChangedTo.
  ///
  /// In es, this message translates to:
  /// **'Estado cambiado a {status}'**
  String batchStatusChangedTo(Object status);

  /// No description provided for @batchRegisteringFullSale.
  ///
  /// In es, this message translates to:
  /// **'Registrando venta completa...'**
  String get batchRegisteringFullSale;

  /// No description provided for @batchMarkedAsSold.
  ///
  /// In es, this message translates to:
  /// **'Lote marcado como vendido'**
  String get batchMarkedAsSold;

  /// No description provided for @batchTransferring.
  ///
  /// In es, this message translates to:
  /// **'Transfiriendo lote...'**
  String get batchTransferring;

  /// No description provided for @batchTransferredSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote transferido exitosamente'**
  String get batchTransferredSuccess;

  /// No description provided for @batchSelectEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccione la fecha de ingreso'**
  String get batchSelectEntryDate;

  /// No description provided for @batchMin3Chars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get batchMin3Chars;

  /// No description provided for @batchFilterBatches.
  ///
  /// In es, this message translates to:
  /// **'Filtrar Lotes'**
  String get batchFilterBatches;

  /// No description provided for @batchStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get batchStatus;

  /// No description provided for @batchFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get batchFrom;

  /// No description provided for @batchTo.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get batchTo;

  /// No description provided for @batchAny.
  ///
  /// In es, this message translates to:
  /// **'Cualquiera'**
  String get batchAny;

  /// No description provided for @batchCloseBatchTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Lote'**
  String get batchCloseBatchTitle;

  /// No description provided for @batchCloseConfirmation.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de cerrar el lote \"{code}\"?'**
  String batchCloseConfirmation(Object code);

  /// No description provided for @batchCloseWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible. El lote será marcado como cerrado.'**
  String get batchCloseWarning;

  /// No description provided for @batchCloseFinalSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen Final'**
  String get batchCloseFinalSummary;

  /// No description provided for @batchCloseEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de ingreso'**
  String get batchCloseEntryDate;

  /// No description provided for @batchCloseCloseDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de cierre'**
  String get batchCloseCloseDate;

  /// No description provided for @batchCloseDurationDays.
  ///
  /// In es, this message translates to:
  /// **'Duración: {days} días'**
  String batchCloseDurationDays(Object days);

  /// No description provided for @batchCloseInitialBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves iniciales'**
  String get batchCloseInitialBirds;

  /// No description provided for @batchCloseFinalBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves finales'**
  String get batchCloseFinalBirds;

  /// No description provided for @batchCloseFinalMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad final'**
  String get batchCloseFinalMortality;

  /// No description provided for @batchCloseObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones de cierre'**
  String get batchCloseObservations;

  /// No description provided for @batchCloseOptionalNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas opcionales sobre el cierre del lote...'**
  String get batchCloseOptionalNotes;

  /// No description provided for @batchCloseSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote cerrado exitosamente'**
  String get batchCloseSuccess;

  /// No description provided for @batchCloseError.
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar el lote: {error}'**
  String batchCloseError(Object error);

  /// No description provided for @batchTransferTitle.
  ///
  /// In es, this message translates to:
  /// **'Transferir Lote'**
  String get batchTransferTitle;

  /// No description provided for @batchTransferConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Transferir \"{code}\" al galpón {shed}?'**
  String batchTransferConfirm(String shed, Object code);

  /// No description provided for @batchTransferSelectShed.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar galpón destino'**
  String get batchTransferSelectShed;

  /// No description provided for @batchTransferNoSheds.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones disponibles'**
  String get batchTransferNoSheds;

  /// No description provided for @batchTransferReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo de transferencia'**
  String get batchTransferReason;

  /// No description provided for @batchSellTitle.
  ///
  /// In es, this message translates to:
  /// **'Vender Lote Completo'**
  String get batchSellTitle;

  /// No description provided for @batchSellConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Registrar la venta completa del lote \"{code}\"?'**
  String batchSellConfirm(Object code);

  /// No description provided for @batchSellBirdsCount.
  ///
  /// In es, this message translates to:
  /// **'Aves a vender: {count}'**
  String batchSellBirdsCount(Object count);

  /// No description provided for @batchSellPricePerUnit.
  ///
  /// In es, this message translates to:
  /// **'Precio por unidad'**
  String get batchSellPricePerUnit;

  /// No description provided for @batchSellTotalPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio total'**
  String get batchSellTotalPrice;

  /// No description provided for @batchSellBuyer.
  ///
  /// In es, this message translates to:
  /// **'Comprador'**
  String get batchSellBuyer;

  /// No description provided for @batchFormStepBasicInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get batchFormStepBasicInfo;

  /// No description provided for @batchFormStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get batchFormStepDetails;

  /// No description provided for @batchFormStepReview.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get batchFormStepReview;

  /// No description provided for @batchFormCode.
  ///
  /// In es, this message translates to:
  /// **'Código del lote'**
  String get batchFormCode;

  /// No description provided for @batchFormCodeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: LOTE-001'**
  String get batchFormCodeHint;

  /// No description provided for @batchFormBirdType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de ave'**
  String get batchFormBirdType;

  /// No description provided for @batchFormSelectType.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tipo'**
  String get batchFormSelectType;

  /// No description provided for @batchFormInitialCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad inicial'**
  String get batchFormInitialCount;

  /// No description provided for @batchFormCountHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 500'**
  String get batchFormCountHint;

  /// No description provided for @batchFormEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de ingreso'**
  String get batchFormEntryDate;

  /// No description provided for @batchFormExpectedClose.
  ///
  /// In es, this message translates to:
  /// **'Fecha estimada de cierre'**
  String get batchFormExpectedClose;

  /// No description provided for @batchFormShed.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get batchFormShed;

  /// No description provided for @batchFormSelectShed.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar galpón'**
  String get batchFormSelectShed;

  /// No description provided for @batchFormSupplier.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get batchFormSupplier;

  /// No description provided for @batchFormSupplierHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor (opcional)'**
  String get batchFormSupplierHint;

  /// No description provided for @batchFormNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales'**
  String get batchFormNotes;

  /// No description provided for @batchFormNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Observaciones sobre el lote (opcional)'**
  String get batchFormNotesHint;

  /// No description provided for @batchFormDeathCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de muertes'**
  String get batchFormDeathCount;

  /// No description provided for @batchFormDeathCountHint.
  ///
  /// In es, this message translates to:
  /// **'Ingrese la cantidad'**
  String get batchFormDeathCountHint;

  /// No description provided for @batchFormCause.
  ///
  /// In es, this message translates to:
  /// **'Causa'**
  String get batchFormCause;

  /// No description provided for @batchFormCauseHint.
  ///
  /// In es, this message translates to:
  /// **'Causa de mortalidad (opcional)'**
  String get batchFormCauseHint;

  /// No description provided for @batchFormDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get batchFormDate;

  /// No description provided for @batchFormObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get batchFormObservations;

  /// No description provided for @batchFormObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Observaciones adicionales (opcional)'**
  String get batchFormObservationsHint;

  /// No description provided for @batchFormWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso (kg)'**
  String get batchFormWeight;

  /// No description provided for @batchFormWeightHint.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio en kg'**
  String get batchFormWeightHint;

  /// No description provided for @batchFormSampleSize.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de muestra'**
  String get batchFormSampleSize;

  /// No description provided for @batchFormSampleSizeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 10'**
  String get batchFormSampleSizeHint;

  /// No description provided for @batchFormMethodHint.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get batchFormMethodHint;

  /// No description provided for @batchFormFoodType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de alimento'**
  String get batchFormFoodType;

  /// No description provided for @batchFormSelectFoodType.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tipo de alimento'**
  String get batchFormSelectFoodType;

  /// No description provided for @batchFormQuantityKg.
  ///
  /// In es, this message translates to:
  /// **'Cantidad (kg)'**
  String get batchFormQuantityKg;

  /// No description provided for @batchFormQuantityHint.
  ///
  /// In es, this message translates to:
  /// **'Cantidad en kg'**
  String get batchFormQuantityHint;

  /// No description provided for @batchFormCostPerKg.
  ///
  /// In es, this message translates to:
  /// **'Costo por kg'**
  String get batchFormCostPerKg;

  /// No description provided for @batchFormCostHint.
  ///
  /// In es, this message translates to:
  /// **'Costo en \$ (opcional)'**
  String get batchFormCostHint;

  /// No description provided for @batchFormEggCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de huevos'**
  String get batchFormEggCount;

  /// No description provided for @batchFormEggCountHint.
  ///
  /// In es, this message translates to:
  /// **'Total de huevos recolectados'**
  String get batchFormEggCountHint;

  /// No description provided for @batchFormEggQuality.
  ///
  /// In es, this message translates to:
  /// **'Calidad del huevo'**
  String get batchFormEggQuality;

  /// No description provided for @batchFormSelectQuality.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar calidad'**
  String get batchFormSelectQuality;

  /// No description provided for @batchFormDiscardCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de descartes'**
  String get batchFormDiscardCount;

  /// No description provided for @batchFormDiscardCountHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 5'**
  String get batchFormDiscardCountHint;

  /// No description provided for @batchFormDiscardReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo del descarte'**
  String get batchFormDiscardReason;

  /// No description provided for @batchFormDiscardReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Motivo del descarte (opcional)'**
  String get batchFormDiscardReasonHint;

  /// No description provided for @batchHistoryMortality.
  ///
  /// In es, this message translates to:
  /// **'Historial de Mortalidad'**
  String get batchHistoryMortality;

  /// No description provided for @batchHistoryWeight.
  ///
  /// In es, this message translates to:
  /// **'Historial de Peso'**
  String get batchHistoryWeight;

  /// No description provided for @batchHistoryConsumption.
  ///
  /// In es, this message translates to:
  /// **'Historial de Consumo'**
  String get batchHistoryConsumption;

  /// No description provided for @batchHistoryProduction.
  ///
  /// In es, this message translates to:
  /// **'Historial de Producción'**
  String get batchHistoryProduction;

  /// No description provided for @batchHistoryNoRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros'**
  String get batchHistoryNoRecords;

  /// No description provided for @batchHistoryNoRecordsDesc.
  ///
  /// In es, this message translates to:
  /// **'No hay registros para mostrar'**
  String get batchHistoryNoRecordsDesc;

  /// No description provided for @batchBirdsLabel.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get batchBirdsLabel;

  /// No description provided for @batchBirdLabel.
  ///
  /// In es, this message translates to:
  /// **'ave'**
  String get batchBirdLabel;

  /// No description provided for @batchKgLabel.
  ///
  /// In es, this message translates to:
  /// **'kg'**
  String get batchKgLabel;

  /// No description provided for @batchEggsLabel.
  ///
  /// In es, this message translates to:
  /// **'huevos'**
  String get batchEggsLabel;

  /// No description provided for @batchUnitLabel.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get batchUnitLabel;

  /// No description provided for @batchPercentSign.
  ///
  /// In es, this message translates to:
  /// **'%'**
  String get batchPercentSign;

  /// No description provided for @batchDaysLabel.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get batchDaysLabel;

  /// No description provided for @batchDayLabel.
  ///
  /// In es, this message translates to:
  /// **'día'**
  String get batchDayLabel;

  /// No description provided for @batchCopyInfo.
  ///
  /// In es, this message translates to:
  /// **'Copiar información'**
  String get batchCopyInfo;

  /// No description provided for @batchShareInfo.
  ///
  /// In es, this message translates to:
  /// **'Compartir información'**
  String get batchShareInfo;

  /// No description provided for @batchViewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver historial completo'**
  String get batchViewHistory;

  /// No description provided for @batchNoShedsAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones disponibles'**
  String get batchNoShedsAvailable;

  /// No description provided for @batchCreateShedFirst.
  ///
  /// In es, this message translates to:
  /// **'Crea un galpón primero'**
  String get batchCreateShedFirst;

  /// No description provided for @batchStepOf.
  ///
  /// In es, this message translates to:
  /// **'Paso {current} de {total}'**
  String batchStepOf(Object current, Object total);

  /// No description provided for @batchReviewCreateBatch.
  ///
  /// In es, this message translates to:
  /// **'Revisar y Crear Lote'**
  String get batchReviewCreateBatch;

  /// No description provided for @batchCreated.
  ///
  /// In es, this message translates to:
  /// **'Lote creado exitosamente'**
  String get batchCreated;

  /// No description provided for @batchConfirmExit.
  ///
  /// In es, this message translates to:
  /// **'¿Desea salir?'**
  String get batchConfirmExit;

  /// No description provided for @batchConfirmExitDesc.
  ///
  /// In es, this message translates to:
  /// **'Los datos del formulario se perderán'**
  String get batchConfirmExitDesc;

  /// No description provided for @batchStay.
  ///
  /// In es, this message translates to:
  /// **'Quedarse'**
  String get batchStay;

  /// No description provided for @batchLeave.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get batchLeave;

  /// No description provided for @batchUnsavedChanges.
  ///
  /// In es, this message translates to:
  /// **'Cambios sin guardar'**
  String get batchUnsavedChanges;

  /// No description provided for @batchExitWithoutSaving.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin guardar los cambios?'**
  String get batchExitWithoutSaving;

  /// No description provided for @batchLoadingBatch.
  ///
  /// In es, this message translates to:
  /// **'Cargando lote...'**
  String get batchLoadingBatch;

  /// No description provided for @batchLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Cargando datos...'**
  String get batchLoadingData;

  /// No description provided for @batchRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get batchRetry;

  /// No description provided for @batchNoData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos'**
  String get batchNoData;

  /// No description provided for @batchNoBatches.
  ///
  /// In es, this message translates to:
  /// **'Sin lotes'**
  String get batchNoBatches;

  /// No description provided for @batchLotesHome.
  ///
  /// In es, this message translates to:
  /// **'Lotes'**
  String get batchLotesHome;

  /// No description provided for @batchClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrados'**
  String get batchClosed;

  /// No description provided for @batchSuspended.
  ///
  /// In es, this message translates to:
  /// **'Suspendidos'**
  String get batchSuspended;

  /// No description provided for @batchInQuarantine.
  ///
  /// In es, this message translates to:
  /// **'En cuarentena'**
  String get batchInQuarantine;

  /// No description provided for @batchSold.
  ///
  /// In es, this message translates to:
  /// **'Vendido'**
  String get batchSold;

  /// No description provided for @batchTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get batchTransfer;

  /// No description provided for @batchDaysCount.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String batchDaysCount(Object count);

  /// No description provided for @batchNoNotes.
  ///
  /// In es, this message translates to:
  /// **'Sin notas'**
  String get batchNoNotes;

  /// No description provided for @batchShedLabel.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get batchShedLabel;

  /// No description provided for @batchActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones'**
  String get batchActions;

  /// No description provided for @batchWhatWantToDo.
  ///
  /// In es, this message translates to:
  /// **'¿Qué deseas hacer con este lote?'**
  String get batchWhatWantToDo;

  /// No description provided for @batchDeleteWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer'**
  String get batchDeleteWarning;

  /// No description provided for @batchAgeWeeks.
  ///
  /// In es, this message translates to:
  /// **'{weeks} sem'**
  String batchAgeWeeks(Object weeks);

  /// No description provided for @batchAgeDays.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String batchAgeDays(Object days);

  /// No description provided for @batchMortalityRate.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad: {rate}%'**
  String batchMortalityRate(String rate);

  /// No description provided for @batchRecordAdded.
  ///
  /// In es, this message translates to:
  /// **'Registro agregado exitosamente'**
  String get batchRecordAdded;

  /// No description provided for @batchRecordError.
  ///
  /// In es, this message translates to:
  /// **'Error al agregar registro'**
  String get batchRecordError;

  /// No description provided for @batchTotalConsumed.
  ///
  /// In es, this message translates to:
  /// **'Total consumido'**
  String get batchTotalConsumed;

  /// No description provided for @batchTotalProduced.
  ///
  /// In es, this message translates to:
  /// **'Total producido'**
  String get batchTotalProduced;

  /// No description provided for @batchProductionRate.
  ///
  /// In es, this message translates to:
  /// **'Tasa de producción'**
  String get batchProductionRate;

  /// No description provided for @batchSelectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get batchSelectDate;

  /// No description provided for @batchVaccinationHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Vacunación'**
  String get batchVaccinationHistory;

  /// No description provided for @batchNoVaccinations.
  ///
  /// In es, this message translates to:
  /// **'Sin vacunaciones registradas'**
  String get batchNoVaccinations;

  /// No description provided for @batchDeaths.
  ///
  /// In es, this message translates to:
  /// **'muertes'**
  String get batchDeaths;

  /// No description provided for @batchDiscards.
  ///
  /// In es, this message translates to:
  /// **'descartes'**
  String get batchDiscards;

  /// No description provided for @batchAverageWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get batchAverageWeight;

  /// No description provided for @batchSamples.
  ///
  /// In es, this message translates to:
  /// **'muestras'**
  String get batchSamples;

  /// No description provided for @batchConsumed.
  ///
  /// In es, this message translates to:
  /// **'consumido'**
  String get batchConsumed;

  /// No description provided for @batchEggsCollected.
  ///
  /// In es, this message translates to:
  /// **'huevos'**
  String get batchEggsCollected;

  /// No description provided for @batchBrokenDiscarded.
  ///
  /// In es, this message translates to:
  /// **'rotos/descartados'**
  String get batchBrokenDiscarded;

  /// No description provided for @batchTotal.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get batchTotal;

  /// No description provided for @batchLastRecord.
  ///
  /// In es, this message translates to:
  /// **'Último registro'**
  String get batchLastRecord;

  /// No description provided for @batchRemainingBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves restantes: {count}'**
  String batchRemainingBirds(Object count);

  /// No description provided for @batchExceedsCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'La cantidad excede las aves actuales ({count})'**
  String batchExceedsCurrentBirds(Object count);

  /// No description provided for @batchFutureDateNotAllowed.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser futura'**
  String get batchFutureDateNotAllowed;

  /// No description provided for @batchRequiredField.
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get batchRequiredField;

  /// No description provided for @batchInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get batchInvalidNumber;

  /// No description provided for @batchMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'Debe ser mayor a 0'**
  String get batchMustBePositive;

  /// No description provided for @batchMustBeGreaterThanZero.
  ///
  /// In es, this message translates to:
  /// **'Debe ser mayor que 0'**
  String get batchMustBeGreaterThanZero;

  /// No description provided for @batchProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción'**
  String get batchProduction;

  /// No description provided for @batchConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo'**
  String get batchConsumption;

  /// No description provided for @batchMortalityLabel.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get batchMortalityLabel;

  /// No description provided for @batchVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get batchVaccination;

  /// No description provided for @batchInfoGeneral.
  ///
  /// In es, this message translates to:
  /// **'Información general'**
  String get batchInfoGeneral;

  /// No description provided for @batchTitle.
  ///
  /// In es, this message translates to:
  /// **'Lotes'**
  String get batchTitle;

  /// No description provided for @batchDeleteBatch.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Lote'**
  String get batchDeleteBatch;

  /// No description provided for @batchFilterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar Lotes'**
  String get batchFilterTitle;

  /// No description provided for @batchFilterClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get batchFilterClear;

  /// No description provided for @batchFilterStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get batchFilterStatus;

  /// No description provided for @batchFilterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get batchFilterAll;

  /// No description provided for @batchFilterBirdType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de ave'**
  String get batchFilterBirdType;

  /// No description provided for @batchFilterEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de ingreso'**
  String get batchFilterEntryDate;

  /// No description provided for @batchFilterFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get batchFilterFrom;

  /// No description provided for @batchFilterTo.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get batchFilterTo;

  /// No description provided for @batchFilterAny.
  ///
  /// In es, this message translates to:
  /// **'Cualquiera'**
  String get batchFilterAny;

  /// No description provided for @batchFilterCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get batchFilterCancel;

  /// No description provided for @batchFilterApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get batchFilterApply;

  /// No description provided for @batchCloseSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Cierre'**
  String get batchCloseSummary;

  /// No description provided for @batchCloseStartDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get batchCloseStartDate;

  /// No description provided for @batchCloseEndDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de cierre'**
  String get batchCloseEndDate;

  /// No description provided for @batchCloseDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de cierre'**
  String get batchCloseDate;

  /// No description provided for @batchCloseDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración'**
  String get batchCloseDuration;

  /// No description provided for @batchCloseDays.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get batchCloseDays;

  /// No description provided for @batchCloseCycleDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración del ciclo'**
  String get batchCloseCycleDuration;

  /// No description provided for @batchCloseCycleInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del ciclo'**
  String get batchCloseCycleInfo;

  /// No description provided for @batchClosePopulation.
  ///
  /// In es, this message translates to:
  /// **'Población'**
  String get batchClosePopulation;

  /// No description provided for @batchCloseTotalMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad total'**
  String get batchCloseTotalMortality;

  /// No description provided for @batchCloseMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get batchCloseMortality;

  /// No description provided for @batchCloseMortalityPercent.
  ///
  /// In es, this message translates to:
  /// **'% de mortalidad'**
  String get batchCloseMortalityPercent;

  /// No description provided for @batchCloseFinalMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas Finales'**
  String get batchCloseFinalMetrics;

  /// No description provided for @batchCloseFinalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso final'**
  String get batchCloseFinalWeight;

  /// No description provided for @batchCloseFinalWeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Peso final (kg)'**
  String get batchCloseFinalWeightLabel;

  /// No description provided for @batchCloseWeightGain.
  ///
  /// In es, this message translates to:
  /// **'Ganancia de peso'**
  String get batchCloseWeightGain;

  /// No description provided for @batchCloseEstimatedWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso estimado'**
  String get batchCloseEstimatedWeight;

  /// No description provided for @batchCloseFeedConversion.
  ///
  /// In es, this message translates to:
  /// **'Conversión alimenticia'**
  String get batchCloseFeedConversion;

  /// No description provided for @batchCloseGrams.
  ///
  /// In es, this message translates to:
  /// **'gramos'**
  String get batchCloseGrams;

  /// No description provided for @batchCloseWeightRequired.
  ///
  /// In es, this message translates to:
  /// **'El peso es requerido'**
  String get batchCloseWeightRequired;

  /// No description provided for @batchCloseWeightMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'El peso debe ser positivo'**
  String get batchCloseWeightMustBePositive;

  /// No description provided for @batchCloseWeightTooHigh.
  ///
  /// In es, this message translates to:
  /// **'El peso parece demasiado alto'**
  String get batchCloseWeightTooHigh;

  /// No description provided for @batchCloseWeightHelper.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio por ave en kg'**
  String get batchCloseWeightHelper;

  /// No description provided for @batchCloseFinalObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones Finales'**
  String get batchCloseFinalObservations;

  /// No description provided for @batchCloseObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Escriba sus observaciones aquí...'**
  String get batchCloseObservationsHint;

  /// No description provided for @batchCloseIrreversible.
  ///
  /// In es, this message translates to:
  /// **'Acción irreversible'**
  String get batchCloseIrreversible;

  /// No description provided for @batchCloseIrreversibleMessage.
  ///
  /// In es, this message translates to:
  /// **'Una vez cerrado, el lote no podrá reabrirse'**
  String get batchCloseIrreversibleMessage;

  /// No description provided for @batchCloseConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar cierre'**
  String get batchCloseConfirm;

  /// No description provided for @batchCloseSaleInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Venta'**
  String get batchCloseSaleInfo;

  /// No description provided for @batchCloseBirdsToSell.
  ///
  /// In es, this message translates to:
  /// **'Aves a vender'**
  String get batchCloseBirdsToSell;

  /// No description provided for @batchCloseBirdsUnit.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get batchCloseBirdsUnit;

  /// No description provided for @batchCloseSalePriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio de venta por kg'**
  String get batchCloseSalePriceLabel;

  /// No description provided for @batchCloseSalePriceHelper.
  ///
  /// In es, this message translates to:
  /// **'Precio en moneda local'**
  String get batchCloseSalePriceHelper;

  /// No description provided for @batchClosePricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg'**
  String get batchClosePricePerKg;

  /// No description provided for @batchCloseEstimatedValue.
  ///
  /// In es, this message translates to:
  /// **'Valor estimado'**
  String get batchCloseEstimatedValue;

  /// No description provided for @batchCloseBuyerLabel.
  ///
  /// In es, this message translates to:
  /// **'Comprador'**
  String get batchCloseBuyerLabel;

  /// No description provided for @batchCloseBuyerHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del comprador (opcional)'**
  String get batchCloseBuyerHint;

  /// No description provided for @batchCloseFinancialBalance.
  ///
  /// In es, this message translates to:
  /// **'Balance financiero'**
  String get batchCloseFinancialBalance;

  /// No description provided for @batchCloseTotalIncome.
  ///
  /// In es, this message translates to:
  /// **'Ingresos totales'**
  String get batchCloseTotalIncome;

  /// No description provided for @batchCloseTotalExpenses.
  ///
  /// In es, this message translates to:
  /// **'Gastos totales'**
  String get batchCloseTotalExpenses;

  /// No description provided for @batchCloseProfitability.
  ///
  /// In es, this message translates to:
  /// **'Rentabilidad'**
  String get batchCloseProfitability;

  /// No description provided for @batchCloseEnterValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un número válido'**
  String get batchCloseEnterValidNumber;

  /// No description provided for @batchFormName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del lote'**
  String get batchFormName;

  /// No description provided for @batchFormBasicInfoSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Información básica del lote'**
  String get batchFormBasicInfoSubtitle;

  /// No description provided for @batchFormBasicInfoNote.
  ///
  /// In es, this message translates to:
  /// **'Complete la información básica del lote'**
  String get batchFormBasicInfoNote;

  /// No description provided for @batchFormDetailsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Detalles adicionales del lote'**
  String get batchFormDetailsSubtitle;

  /// No description provided for @batchFormReviewSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revise la información antes de crear'**
  String get batchFormReviewSubtitle;

  /// No description provided for @batchFormFarm.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get batchFormFarm;

  /// No description provided for @batchFormLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get batchFormLocation;

  /// No description provided for @batchFormShedInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del galpón'**
  String get batchFormShedInfo;

  /// No description provided for @batchFormShedLocationInfo.
  ///
  /// In es, this message translates to:
  /// **'Ubicación del galpón'**
  String get batchFormShedLocationInfo;

  /// No description provided for @batchFormCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad'**
  String get batchFormCapacity;

  /// No description provided for @batchFormMaxCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad máxima'**
  String get batchFormMaxCapacity;

  /// No description provided for @batchFormArea.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get batchFormArea;

  /// No description provided for @batchFormAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get batchFormAvailable;

  /// No description provided for @batchFormShedCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad del galpón'**
  String get batchFormShedCapacity;

  /// No description provided for @batchFormShedCapacityNote.
  ///
  /// In es, this message translates to:
  /// **'La cantidad no puede exceder la capacidad'**
  String get batchFormShedCapacityNote;

  /// No description provided for @batchFormExceedsCapacity.
  ///
  /// In es, this message translates to:
  /// **'Excede la capacidad del galpón'**
  String get batchFormExceedsCapacity;

  /// No description provided for @batchFormUtilization.
  ///
  /// In es, this message translates to:
  /// **'Utilización'**
  String get batchFormUtilization;

  /// No description provided for @batchFormCreateShedFirst.
  ///
  /// In es, this message translates to:
  /// **'Cree un galpón primero'**
  String get batchFormCreateShedFirst;

  /// No description provided for @batchFormAgeAtEntry.
  ///
  /// In es, this message translates to:
  /// **'Edad al ingreso'**
  String get batchFormAgeAtEntry;

  /// No description provided for @batchFormAgeHint.
  ///
  /// In es, this message translates to:
  /// **'Edad en días (opcional)'**
  String get batchFormAgeHint;

  /// No description provided for @batchFormAgeInfoNote.
  ///
  /// In es, this message translates to:
  /// **'La edad se calcula automáticamente'**
  String get batchFormAgeInfoNote;

  /// No description provided for @batchFormOptional.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get batchFormOptional;

  /// No description provided for @batchFormNotSelected.
  ///
  /// In es, this message translates to:
  /// **'No seleccionado'**
  String get batchFormNotSelected;

  /// No description provided for @batchFormNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'No especificado'**
  String get batchFormNotSpecified;

  /// No description provided for @batchFormNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontrado'**
  String get batchFormNotFound;

  /// No description provided for @batchFormUnits.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get batchFormUnits;

  /// No description provided for @batchFormDirty.
  ///
  /// In es, this message translates to:
  /// **'Sucio'**
  String get batchFormDirty;

  /// No description provided for @batchFormCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves actuales'**
  String get batchFormCurrentBirds;

  /// No description provided for @batchFormInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get batchFormInvalidNumber;

  /// No description provided for @batchFormInvalidValue.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido'**
  String get batchFormInvalidValue;

  /// No description provided for @batchFormMortalityEventInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del evento de mortalidad'**
  String get batchFormMortalityEventInfo;

  /// No description provided for @batchFormMortalityEventSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registre los detalles del evento'**
  String get batchFormMortalityEventSubtitle;

  /// No description provided for @batchFormMortalityDetailsTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalles de Mortalidad'**
  String get batchFormMortalityDetailsTitle;

  /// No description provided for @batchFormMortalityDetailsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Describa los detalles adicionales'**
  String get batchFormMortalityDetailsSubtitle;

  /// No description provided for @batchFormMortalityDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción de mortalidad'**
  String get batchFormMortalityDescription;

  /// No description provided for @batchFormMortalityDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describa las circunstancias...'**
  String get batchFormMortalityDescriptionHint;

  /// No description provided for @batchFormRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Recomendación'**
  String get batchFormRecommendation;

  /// No description provided for @batchFormRecommendedActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones recomendadas'**
  String get batchFormRecommendedActions;

  /// No description provided for @batchFormPhotoEvidence.
  ///
  /// In es, this message translates to:
  /// **'Evidencia fotográfica'**
  String get batchFormPhotoEvidence;

  /// No description provided for @batchFormPhotoOptional.
  ///
  /// In es, this message translates to:
  /// **'Fotos opcionales'**
  String get batchFormPhotoOptional;

  /// No description provided for @batchFormPhotoHelpText.
  ///
  /// In es, this message translates to:
  /// **'Tome o seleccione fotos como evidencia'**
  String get batchFormPhotoHelpText;

  /// No description provided for @batchFormNoPhotos.
  ///
  /// In es, this message translates to:
  /// **'Sin fotos'**
  String get batchFormNoPhotos;

  /// No description provided for @batchFormMaxPhotos.
  ///
  /// In es, this message translates to:
  /// **'Máximo de fotos alcanzado'**
  String get batchFormMaxPhotos;

  /// No description provided for @batchFormSelectedPhotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos seleccionadas'**
  String get batchFormSelectedPhotos;

  /// No description provided for @batchFormTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get batchFormTakePhoto;

  /// No description provided for @batchFormGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get batchFormGallery;

  /// No description provided for @batchFormObservationsAndEvidence.
  ///
  /// In es, this message translates to:
  /// **'Observaciones y Evidencia'**
  String get batchFormObservationsAndEvidence;

  /// No description provided for @batchFormObservationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Agregue observaciones adicionales'**
  String get batchFormObservationsSubtitle;

  /// No description provided for @batchFormWeightInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Peso'**
  String get batchFormWeightInfo;

  /// No description provided for @batchFormWeightSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registre el peso del lote'**
  String get batchFormWeightSubtitle;

  /// No description provided for @batchFormWeightMethod.
  ///
  /// In es, this message translates to:
  /// **'Método de pesaje'**
  String get batchFormWeightMethod;

  /// No description provided for @batchFormWeightRanges.
  ///
  /// In es, this message translates to:
  /// **'Rangos de Peso'**
  String get batchFormWeightRanges;

  /// No description provided for @batchFormWeightRangesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Clasifique por rangos de peso'**
  String get batchFormWeightRangesSubtitle;

  /// No description provided for @batchFormWeightMin.
  ///
  /// In es, this message translates to:
  /// **'Peso mínimo'**
  String get batchFormWeightMin;

  /// No description provided for @batchFormWeightMax.
  ///
  /// In es, this message translates to:
  /// **'Peso máximo'**
  String get batchFormWeightMax;

  /// No description provided for @batchFormWeightSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Peso'**
  String get batchFormWeightSummary;

  /// No description provided for @batchFormWeightSummarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de los datos registrados'**
  String get batchFormWeightSummarySubtitle;

  /// No description provided for @batchFormAutoCalculatedWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso calculado automáticamente'**
  String get batchFormAutoCalculatedWeight;

  /// No description provided for @batchFormCalculatedAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio calculado'**
  String get batchFormCalculatedAvgWeight;

  /// No description provided for @batchFormCalculatedMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas calculadas'**
  String get batchFormCalculatedMetrics;

  /// No description provided for @batchFormMetricsAutoCalculated.
  ///
  /// In es, this message translates to:
  /// **'Las métricas se calculan automáticamente'**
  String get batchFormMetricsAutoCalculated;

  /// No description provided for @batchFormConsumptionInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Consumo'**
  String get batchFormConsumptionInfo;

  /// No description provided for @batchFormConsumptionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registre el consumo de alimento'**
  String get batchFormConsumptionSubtitle;

  /// No description provided for @batchFormConsumptionSaveNote.
  ///
  /// In es, this message translates to:
  /// **'Los datos se guardarán al continuar'**
  String get batchFormConsumptionSaveNote;

  /// No description provided for @batchFormFoodFromInventory.
  ///
  /// In es, this message translates to:
  /// **'Alimento del inventario'**
  String get batchFormFoodFromInventory;

  /// No description provided for @batchFormSelectFoodHint.
  ///
  /// In es, this message translates to:
  /// **'Seleccione un alimento'**
  String get batchFormSelectFoodHint;

  /// No description provided for @batchFormNoFoodInInventory.
  ///
  /// In es, this message translates to:
  /// **'No hay alimentos en inventario'**
  String get batchFormNoFoodInInventory;

  /// No description provided for @batchFormFoodBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote de alimento'**
  String get batchFormFoodBatch;

  /// No description provided for @batchFormLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo'**
  String get batchFormLowStock;

  /// No description provided for @batchFormDetailsCosts.
  ///
  /// In es, this message translates to:
  /// **'Detalles y Costos'**
  String get batchFormDetailsCosts;

  /// No description provided for @batchFormDetailsCostsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingrese detalles y costos'**
  String get batchFormDetailsCostsSubtitle;

  /// No description provided for @batchFormCostPerBird.
  ///
  /// In es, this message translates to:
  /// **'Costo por ave'**
  String get batchFormCostPerBird;

  /// No description provided for @batchFormCostThisRecord.
  ///
  /// In es, this message translates to:
  /// **'Costo de este registro'**
  String get batchFormCostThisRecord;

  /// No description provided for @batchFormProductionInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Producción'**
  String get batchFormProductionInfo;

  /// No description provided for @batchFormProductionInfoSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registre la producción de huevos'**
  String get batchFormProductionInfoSubtitle;

  /// No description provided for @batchFormEggsCollected.
  ///
  /// In es, this message translates to:
  /// **'Huevos recolectados'**
  String get batchFormEggsCollected;

  /// No description provided for @batchFormDefectiveEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos defectuosos'**
  String get batchFormDefectiveEggs;

  /// No description provided for @batchFormLayingPercentage.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de postura'**
  String get batchFormLayingPercentage;

  /// No description provided for @batchFormLayingIndicator.
  ///
  /// In es, this message translates to:
  /// **'Indicador de postura'**
  String get batchFormLayingIndicator;

  /// No description provided for @batchFormExcellentPerformance.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento excelente'**
  String get batchFormExcellentPerformance;

  /// No description provided for @batchFormAcceptablePerformance.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento aceptable'**
  String get batchFormAcceptablePerformance;

  /// No description provided for @batchFormBelowExpectedPerformance.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento por debajo de lo esperado'**
  String get batchFormBelowExpectedPerformance;

  /// No description provided for @batchFormProductionSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de producción'**
  String get batchFormProductionSummary;

  /// No description provided for @batchFormCompleteAmountToSeeMetrics.
  ///
  /// In es, this message translates to:
  /// **'Complete la cantidad para ver métricas'**
  String get batchFormCompleteAmountToSeeMetrics;

  /// No description provided for @batchFormEggClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación de Huevos'**
  String get batchFormEggClassification;

  /// No description provided for @batchFormEggClassificationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Clasifique los huevos recolectados'**
  String get batchFormEggClassificationSubtitle;

  /// No description provided for @batchFormClassifyForWeight.
  ///
  /// In es, this message translates to:
  /// **'Clasificar por peso'**
  String get batchFormClassifyForWeight;

  /// No description provided for @batchFormSmallEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos pequeños'**
  String get batchFormSmallEggs;

  /// No description provided for @batchFormMediumEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos medianos'**
  String get batchFormMediumEggs;

  /// No description provided for @batchFormLargeEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos grandes'**
  String get batchFormLargeEggs;

  /// No description provided for @batchFormExtraLargeEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos extra grandes'**
  String get batchFormExtraLargeEggs;

  /// No description provided for @batchFormBroken.
  ///
  /// In es, this message translates to:
  /// **'Rotos'**
  String get batchFormBroken;

  /// No description provided for @batchFormGoodEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos buenos'**
  String get batchFormGoodEggs;

  /// No description provided for @batchFormTotalClassified.
  ///
  /// In es, this message translates to:
  /// **'Total clasificados'**
  String get batchFormTotalClassified;

  /// No description provided for @batchFormTotalToClassify.
  ///
  /// In es, this message translates to:
  /// **'Total a clasificar'**
  String get batchFormTotalToClassify;

  /// No description provided for @batchFormClassificationSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de clasificación'**
  String get batchFormClassificationSummary;

  /// No description provided for @batchFormCannotExceedCollected.
  ///
  /// In es, this message translates to:
  /// **'No puede exceder los huevos recolectados'**
  String get batchFormCannotExceedCollected;

  /// No description provided for @batchFormExcessEggs.
  ///
  /// In es, this message translates to:
  /// **'Exceso de huevos clasificados'**
  String get batchFormExcessEggs;

  /// No description provided for @batchFormMissingEggs.
  ///
  /// In es, this message translates to:
  /// **'Faltan huevos por clasificar'**
  String get batchFormMissingEggs;

  /// No description provided for @batchFormSizeClassification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación por tamaño'**
  String get batchFormSizeClassification;

  /// No description provided for @birdTypeBroiler.
  ///
  /// In es, this message translates to:
  /// **'Pollo de Engorde'**
  String get birdTypeBroiler;

  /// No description provided for @birdTypeLayer.
  ///
  /// In es, this message translates to:
  /// **'Gallina Ponedora'**
  String get birdTypeLayer;

  /// No description provided for @birdTypeHeavyBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Pesada'**
  String get birdTypeHeavyBreeder;

  /// No description provided for @birdTypeLightBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Liviana'**
  String get birdTypeLightBreeder;

  /// No description provided for @birdTypeTurkey.
  ///
  /// In es, this message translates to:
  /// **'Pavo'**
  String get birdTypeTurkey;

  /// No description provided for @birdTypeQuail.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get birdTypeQuail;

  /// No description provided for @birdTypeDuck.
  ///
  /// In es, this message translates to:
  /// **'Pato'**
  String get birdTypeDuck;

  /// No description provided for @birdTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get birdTypeOther;

  /// No description provided for @birdTypeShortBroiler.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get birdTypeShortBroiler;

  /// No description provided for @birdTypeShortLayer.
  ///
  /// In es, this message translates to:
  /// **'Ponedora'**
  String get birdTypeShortLayer;

  /// No description provided for @birdTypeShortHeavyBreeder.
  ///
  /// In es, this message translates to:
  /// **'Rep. Pesada'**
  String get birdTypeShortHeavyBreeder;

  /// No description provided for @birdTypeShortLightBreeder.
  ///
  /// In es, this message translates to:
  /// **'Rep. Liviana'**
  String get birdTypeShortLightBreeder;

  /// No description provided for @birdTypeShortTurkey.
  ///
  /// In es, this message translates to:
  /// **'Pavo'**
  String get birdTypeShortTurkey;

  /// No description provided for @birdTypeShortQuail.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get birdTypeShortQuail;

  /// No description provided for @birdTypeShortDuck.
  ///
  /// In es, this message translates to:
  /// **'Pato'**
  String get birdTypeShortDuck;

  /// No description provided for @birdTypeShortOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get birdTypeShortOther;

  /// No description provided for @batchStatusInTransfer.
  ///
  /// In es, this message translates to:
  /// **'En Transferencia'**
  String get batchStatusInTransfer;

  /// No description provided for @batchStatusDescInTransfer.
  ///
  /// In es, this message translates to:
  /// **'Lote siendo transferido'**
  String get batchStatusDescInTransfer;

  /// No description provided for @weighMethodManual.
  ///
  /// In es, this message translates to:
  /// **'Manual'**
  String get weighMethodManual;

  /// No description provided for @weighMethodIndividualScale.
  ///
  /// In es, this message translates to:
  /// **'Báscula Individual'**
  String get weighMethodIndividualScale;

  /// No description provided for @weighMethodBatchScale.
  ///
  /// In es, this message translates to:
  /// **'Báscula de Lote'**
  String get weighMethodBatchScale;

  /// No description provided for @weighMethodAutomatic.
  ///
  /// In es, this message translates to:
  /// **'Automática'**
  String get weighMethodAutomatic;

  /// No description provided for @weighMethodDescManual.
  ///
  /// In es, this message translates to:
  /// **'Manual con báscula'**
  String get weighMethodDescManual;

  /// No description provided for @weighMethodDescIndividualScale.
  ///
  /// In es, this message translates to:
  /// **'Báscula individual'**
  String get weighMethodDescIndividualScale;

  /// No description provided for @weighMethodDescBatchScale.
  ///
  /// In es, this message translates to:
  /// **'Báscula de lote'**
  String get weighMethodDescBatchScale;

  /// No description provided for @weighMethodDescAutomatic.
  ///
  /// In es, this message translates to:
  /// **'Sistema automático'**
  String get weighMethodDescAutomatic;

  /// No description provided for @weighMethodDetailManual.
  ///
  /// In es, this message translates to:
  /// **'Pesaje ave por ave con báscula portátil'**
  String get weighMethodDetailManual;

  /// No description provided for @weighMethodDetailIndividualScale.
  ///
  /// In es, this message translates to:
  /// **'Báscula electrónica para una ave'**
  String get weighMethodDetailIndividualScale;

  /// No description provided for @weighMethodDetailBatchScale.
  ///
  /// In es, this message translates to:
  /// **'Pesaje grupal dividido entre cantidad'**
  String get weighMethodDetailBatchScale;

  /// No description provided for @weighMethodDetailAutomatic.
  ///
  /// In es, this message translates to:
  /// **'Sistema automatizado integrado'**
  String get weighMethodDetailAutomatic;

  /// No description provided for @feedTypePreStarter.
  ///
  /// In es, this message translates to:
  /// **'Pre-iniciador'**
  String get feedTypePreStarter;

  /// No description provided for @feedTypeStarter.
  ///
  /// In es, this message translates to:
  /// **'Iniciador'**
  String get feedTypeStarter;

  /// No description provided for @feedTypeGrower.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento'**
  String get feedTypeGrower;

  /// No description provided for @feedTypeFinisher.
  ///
  /// In es, this message translates to:
  /// **'Finalizador'**
  String get feedTypeFinisher;

  /// No description provided for @feedTypeLayer.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get feedTypeLayer;

  /// No description provided for @feedTypeRearing.
  ///
  /// In es, this message translates to:
  /// **'Levante'**
  String get feedTypeRearing;

  /// No description provided for @feedTypeMedicated.
  ///
  /// In es, this message translates to:
  /// **'Medicado'**
  String get feedTypeMedicated;

  /// No description provided for @feedTypeConcentrate.
  ///
  /// In es, this message translates to:
  /// **'Concentrado'**
  String get feedTypeConcentrate;

  /// No description provided for @feedTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get feedTypeOther;

  /// No description provided for @feedTypeDescPreStarter.
  ///
  /// In es, this message translates to:
  /// **'Pre-iniciador (0-7 días)'**
  String get feedTypeDescPreStarter;

  /// No description provided for @feedTypeDescStarter.
  ///
  /// In es, this message translates to:
  /// **'Iniciador (8-21 días)'**
  String get feedTypeDescStarter;

  /// No description provided for @feedTypeDescGrower.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento (22-35 días)'**
  String get feedTypeDescGrower;

  /// No description provided for @feedTypeDescFinisher.
  ///
  /// In es, this message translates to:
  /// **'Finalizador (36+ días)'**
  String get feedTypeDescFinisher;

  /// No description provided for @feedTypeDescLayer.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get feedTypeDescLayer;

  /// No description provided for @feedTypeDescRearing.
  ///
  /// In es, this message translates to:
  /// **'Levante'**
  String get feedTypeDescRearing;

  /// No description provided for @feedTypeDescMedicated.
  ///
  /// In es, this message translates to:
  /// **'Medicado'**
  String get feedTypeDescMedicated;

  /// No description provided for @feedTypeDescConcentrate.
  ///
  /// In es, this message translates to:
  /// **'Concentrado'**
  String get feedTypeDescConcentrate;

  /// No description provided for @feedTypeDescOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get feedTypeDescOther;

  /// No description provided for @feedAgeRangePreStarter.
  ///
  /// In es, this message translates to:
  /// **'0-7 días'**
  String get feedAgeRangePreStarter;

  /// No description provided for @feedAgeRangeStarter.
  ///
  /// In es, this message translates to:
  /// **'8-21 días'**
  String get feedAgeRangeStarter;

  /// No description provided for @feedAgeRangeGrower.
  ///
  /// In es, this message translates to:
  /// **'22-35 días'**
  String get feedAgeRangeGrower;

  /// No description provided for @feedAgeRangeFinisher.
  ///
  /// In es, this message translates to:
  /// **'36+ días'**
  String get feedAgeRangeFinisher;

  /// No description provided for @feedAgeRangeLayer.
  ///
  /// In es, this message translates to:
  /// **'Gallinas ponedoras'**
  String get feedAgeRangeLayer;

  /// No description provided for @feedAgeRangeRearing.
  ///
  /// In es, this message translates to:
  /// **'Pollitas reemplazo'**
  String get feedAgeRangeRearing;

  /// No description provided for @feedAgeRangeMedicated.
  ///
  /// In es, this message translates to:
  /// **'Con tratamiento'**
  String get feedAgeRangeMedicated;

  /// No description provided for @feedAgeRangeConcentrate.
  ///
  /// In es, this message translates to:
  /// **'Suplemento'**
  String get feedAgeRangeConcentrate;

  /// No description provided for @feedAgeRangeOther.
  ///
  /// In es, this message translates to:
  /// **'Uso general'**
  String get feedAgeRangeOther;

  /// No description provided for @eggClassSmall.
  ///
  /// In es, this message translates to:
  /// **'Pequeño'**
  String get eggClassSmall;

  /// No description provided for @eggClassMedium.
  ///
  /// In es, this message translates to:
  /// **'Mediano'**
  String get eggClassMedium;

  /// No description provided for @eggClassLarge.
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get eggClassLarge;

  /// No description provided for @eggClassExtraLarge.
  ///
  /// In es, this message translates to:
  /// **'Extra Grande'**
  String get eggClassExtraLarge;

  /// No description provided for @validateBatchQuantityMin.
  ///
  /// In es, this message translates to:
  /// **'La cantidad inicial debe ser al menos 10 aves'**
  String get validateBatchQuantityMin;

  /// No description provided for @validateBatchQuantityMax.
  ///
  /// In es, this message translates to:
  /// **'La cantidad inicial no puede exceder 100,000 aves'**
  String get validateBatchQuantityMax;

  /// No description provided for @validateMortalityMin.
  ///
  /// In es, this message translates to:
  /// **'La cantidad de mortalidad debe ser mayor a 0'**
  String get validateMortalityMin;

  /// No description provided for @validateMortalityExceedsCurrent.
  ///
  /// In es, this message translates to:
  /// **'La cantidad de mortalidad ({mortality}) no puede exceder la cantidad actual ({current})'**
  String validateMortalityExceedsCurrent(Object current, Object mortality);

  /// No description provided for @validateWeightMin.
  ///
  /// In es, this message translates to:
  /// **'El peso debe ser mayor a 0 gramos'**
  String get validateWeightMin;

  /// No description provided for @validateWeightMax.
  ///
  /// In es, this message translates to:
  /// **'El peso no puede exceder 20,000 gramos (20 kg)'**
  String get validateWeightMax;

  /// No description provided for @validateFeedMin.
  ///
  /// In es, this message translates to:
  /// **'La cantidad de alimento debe ser mayor a 0'**
  String get validateFeedMin;

  /// No description provided for @validateFeedMax.
  ///
  /// In es, this message translates to:
  /// **'La cantidad de alimento no puede exceder 10,000 kg'**
  String get validateFeedMax;

  /// No description provided for @validateEggLayerOnly.
  ///
  /// In es, this message translates to:
  /// **'Solo los lotes de ponedoras pueden producir huevos'**
  String get validateEggLayerOnly;

  /// No description provided for @validateEggMin.
  ///
  /// In es, this message translates to:
  /// **'La cantidad de huevos debe ser mayor a 0'**
  String get validateEggMin;

  /// No description provided for @validateEggRateHigh.
  ///
  /// In es, this message translates to:
  /// **'La tasa de postura del {rate}% parece muy alta. Verifique los datos.'**
  String validateEggRateHigh(Object rate);

  /// No description provided for @validateDateFuture.
  ///
  /// In es, this message translates to:
  /// **'La fecha de ingreso no puede ser futura'**
  String get validateDateFuture;

  /// No description provided for @validateDateTooOld.
  ///
  /// In es, this message translates to:
  /// **'La fecha de ingreso parece muy antigua (más de 5 años)'**
  String get validateDateTooOld;

  /// No description provided for @validateCloseDateBeforeEntry.
  ///
  /// In es, this message translates to:
  /// **'La fecha de cierre no puede ser anterior a la fecha de ingreso'**
  String get validateCloseDateBeforeEntry;

  /// No description provided for @validateCloseDateFuture.
  ///
  /// In es, this message translates to:
  /// **'La fecha de cierre no puede ser futura'**
  String get validateCloseDateFuture;

  /// No description provided for @validateCodeExists.
  ///
  /// In es, this message translates to:
  /// **'Ya existe otro lote con el código \"{code}\"'**
  String validateCodeExists(Object code);

  /// No description provided for @batchRecordingMortality.
  ///
  /// In es, this message translates to:
  /// **'Registrando mortalidad...'**
  String get batchRecordingMortality;

  /// No description provided for @batchRecordingDiscard.
  ///
  /// In es, this message translates to:
  /// **'Registrando descarte...'**
  String get batchRecordingDiscard;

  /// No description provided for @batchRecordingSale.
  ///
  /// In es, this message translates to:
  /// **'Registrando venta...'**
  String get batchRecordingSale;

  /// No description provided for @batchMarkingSold.
  ///
  /// In es, this message translates to:
  /// **'Registrando venta completa...'**
  String get batchMarkingSold;

  /// No description provided for @batchCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote creado exitosamente'**
  String get batchCreatedSuccess;

  /// No description provided for @batchUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote actualizado exitosamente'**
  String get batchUpdatedSuccess;

  /// No description provided for @batchMortalityRecorded.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad registrada'**
  String get batchMortalityRecorded;

  /// No description provided for @batchDiscardRecorded.
  ///
  /// In es, this message translates to:
  /// **'Descarte registrado'**
  String get batchDiscardRecorded;

  /// No description provided for @batchSaleRecorded.
  ///
  /// In es, this message translates to:
  /// **'Venta registrada'**
  String get batchSaleRecorded;

  /// No description provided for @batchMarkedSold.
  ///
  /// In es, this message translates to:
  /// **'Lote marcado como vendido'**
  String get batchMarkedSold;

  /// No description provided for @validateSelectBirdType.
  ///
  /// In es, this message translates to:
  /// **'Seleccione el tipo de ave'**
  String get validateSelectBirdType;

  /// No description provided for @validateSelectEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccione la fecha de ingreso'**
  String get validateSelectEntryDate;

  /// No description provided for @validateCodeRequired.
  ///
  /// In es, this message translates to:
  /// **'El código es obligatorio'**
  String get validateCodeRequired;

  /// No description provided for @validateCodeMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get validateCodeMinLength;

  /// No description provided for @validateQuantityValid.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una cantidad válida'**
  String get validateQuantityValid;

  /// No description provided for @saleProductLiveBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Vivas'**
  String get saleProductLiveBirds;

  /// No description provided for @saleProductLiveBirdsDesc.
  ///
  /// In es, this message translates to:
  /// **'Venta de aves en pie'**
  String get saleProductLiveBirdsDesc;

  /// No description provided for @saleProductEggs.
  ///
  /// In es, this message translates to:
  /// **'Huevos'**
  String get saleProductEggs;

  /// No description provided for @saleProductEggsDesc.
  ///
  /// In es, this message translates to:
  /// **'Venta de huevos por clasificación'**
  String get saleProductEggsDesc;

  /// No description provided for @saleProductManure.
  ///
  /// In es, this message translates to:
  /// **'Pollinaza/Gallinaza'**
  String get saleProductManure;

  /// No description provided for @saleProductManureDesc.
  ///
  /// In es, this message translates to:
  /// **'Subproducto orgánico'**
  String get saleProductManureDesc;

  /// No description provided for @saleProductProcessedBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Faenadas'**
  String get saleProductProcessedBirds;

  /// No description provided for @saleProductProcessedBirdsDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves procesadas para consumo'**
  String get saleProductProcessedBirdsDesc;

  /// No description provided for @saleProductCullBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves de Descarte'**
  String get saleProductCullBirds;

  /// No description provided for @saleProductCullBirdsDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves al final del ciclo productivo'**
  String get saleProductCullBirdsDesc;

  /// No description provided for @saleStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get saleStatusPending;

  /// No description provided for @saleStatusPendingDesc.
  ///
  /// In es, this message translates to:
  /// **'Esperando confirmación'**
  String get saleStatusPendingDesc;

  /// No description provided for @saleStatusConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get saleStatusConfirmed;

  /// No description provided for @saleStatusConfirmedDesc.
  ///
  /// In es, this message translates to:
  /// **'Confirmada por el cliente'**
  String get saleStatusConfirmedDesc;

  /// No description provided for @saleStatusInPreparation.
  ///
  /// In es, this message translates to:
  /// **'En Preparación'**
  String get saleStatusInPreparation;

  /// No description provided for @saleStatusInPreparationDesc.
  ///
  /// In es, this message translates to:
  /// **'Preparando producto'**
  String get saleStatusInPreparationDesc;

  /// No description provided for @saleStatusReadyToShip.
  ///
  /// In es, this message translates to:
  /// **'Lista para Despacho'**
  String get saleStatusReadyToShip;

  /// No description provided for @saleStatusReadyToShipDesc.
  ///
  /// In es, this message translates to:
  /// **'Lista para entregar'**
  String get saleStatusReadyToShipDesc;

  /// No description provided for @saleStatusInTransit.
  ///
  /// In es, this message translates to:
  /// **'En Tránsito'**
  String get saleStatusInTransit;

  /// No description provided for @saleStatusInTransitDesc.
  ///
  /// In es, this message translates to:
  /// **'En camino al cliente'**
  String get saleStatusInTransitDesc;

  /// No description provided for @saleStatusDelivered.
  ///
  /// In es, this message translates to:
  /// **'Entregada'**
  String get saleStatusDelivered;

  /// No description provided for @saleStatusDeliveredDesc.
  ///
  /// In es, this message translates to:
  /// **'Entregada exitosamente'**
  String get saleStatusDeliveredDesc;

  /// No description provided for @saleStatusInvoiced.
  ///
  /// In es, this message translates to:
  /// **'Facturada'**
  String get saleStatusInvoiced;

  /// No description provided for @saleStatusInvoicedDesc.
  ///
  /// In es, this message translates to:
  /// **'Factura generada'**
  String get saleStatusInvoicedDesc;

  /// No description provided for @saleStatusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get saleStatusCancelled;

  /// No description provided for @saleStatusCancelledDesc.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get saleStatusCancelledDesc;

  /// No description provided for @saleStatusReturned.
  ///
  /// In es, this message translates to:
  /// **'Devuelta'**
  String get saleStatusReturned;

  /// No description provided for @saleStatusReturnedDesc.
  ///
  /// In es, this message translates to:
  /// **'Devuelta por el cliente'**
  String get saleStatusReturnedDesc;

  /// No description provided for @orderStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get orderStatusPending;

  /// No description provided for @orderStatusPendingDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido en espera de confirmación'**
  String get orderStatusPendingDesc;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmado'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusConfirmedDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido aprobado'**
  String get orderStatusConfirmedDesc;

  /// No description provided for @orderStatusInPreparation.
  ///
  /// In es, this message translates to:
  /// **'En Preparación'**
  String get orderStatusInPreparation;

  /// No description provided for @orderStatusInPreparationDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido siendo preparado'**
  String get orderStatusInPreparationDesc;

  /// No description provided for @orderStatusReadyToShip.
  ///
  /// In es, this message translates to:
  /// **'Listo Despacho'**
  String get orderStatusReadyToShip;

  /// No description provided for @orderStatusReadyToShipDesc.
  ///
  /// In es, this message translates to:
  /// **'Preparado para envío'**
  String get orderStatusReadyToShipDesc;

  /// No description provided for @orderStatusInTransit.
  ///
  /// In es, this message translates to:
  /// **'En Tránsito'**
  String get orderStatusInTransit;

  /// No description provided for @orderStatusInTransitDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido en camino'**
  String get orderStatusInTransitDesc;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In es, this message translates to:
  /// **'Entregado'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusDeliveredDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido completado'**
  String get orderStatusDeliveredDesc;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusCancelledDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido anulado'**
  String get orderStatusCancelledDesc;

  /// No description provided for @orderStatusReturned.
  ///
  /// In es, this message translates to:
  /// **'Devuelto'**
  String get orderStatusReturned;

  /// No description provided for @orderStatusReturnedDesc.
  ///
  /// In es, this message translates to:
  /// **'Pedido retornado'**
  String get orderStatusReturnedDesc;

  /// No description provided for @orderStatusPartial.
  ///
  /// In es, this message translates to:
  /// **'Parcial'**
  String get orderStatusPartial;

  /// No description provided for @orderStatusPartialDesc.
  ///
  /// In es, this message translates to:
  /// **'Entrega incompleta'**
  String get orderStatusPartialDesc;

  /// No description provided for @saleUnitBag.
  ///
  /// In es, this message translates to:
  /// **'Bulto'**
  String get saleUnitBag;

  /// No description provided for @saleUnitBagDesc.
  ///
  /// In es, this message translates to:
  /// **'Bulto de 50 kg'**
  String get saleUnitBagDesc;

  /// No description provided for @saleUnitTon.
  ///
  /// In es, this message translates to:
  /// **'Tonelada'**
  String get saleUnitTon;

  /// No description provided for @saleUnitTonDesc.
  ///
  /// In es, this message translates to:
  /// **'Tonelada métrica'**
  String get saleUnitTonDesc;

  /// No description provided for @saleUnitKg.
  ///
  /// In es, this message translates to:
  /// **'Kilogramo'**
  String get saleUnitKg;

  /// No description provided for @saleUnitKgDesc.
  ///
  /// In es, this message translates to:
  /// **'Kilogramo'**
  String get saleUnitKgDesc;

  /// No description provided for @saleEggClassExtraLarge.
  ///
  /// In es, this message translates to:
  /// **'Extra Grande'**
  String get saleEggClassExtraLarge;

  /// No description provided for @saleEggClassLarge.
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get saleEggClassLarge;

  /// No description provided for @saleEggClassMedium.
  ///
  /// In es, this message translates to:
  /// **'Mediano'**
  String get saleEggClassMedium;

  /// No description provided for @saleEggClassSmall.
  ///
  /// In es, this message translates to:
  /// **'Pequeño'**
  String get saleEggClassSmall;

  /// No description provided for @costTypeFeed.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get costTypeFeed;

  /// No description provided for @costTypeFeedDesc.
  ///
  /// In es, this message translates to:
  /// **'Concentrados y granos'**
  String get costTypeFeedDesc;

  /// No description provided for @costTypeLaborDesc.
  ///
  /// In es, this message translates to:
  /// **'Salarios y beneficios'**
  String get costTypeLaborDesc;

  /// No description provided for @costTypeEnergyDesc.
  ///
  /// In es, this message translates to:
  /// **'Electricidad y combustible'**
  String get costTypeEnergyDesc;

  /// No description provided for @costTypeMedicineDesc.
  ///
  /// In es, this message translates to:
  /// **'Sanidad animal'**
  String get costTypeMedicineDesc;

  /// No description provided for @costTypeMaintenanceDesc.
  ///
  /// In es, this message translates to:
  /// **'Reparaciones y limpieza'**
  String get costTypeMaintenanceDesc;

  /// No description provided for @costTypeWaterDesc.
  ///
  /// In es, this message translates to:
  /// **'Consumo de agua'**
  String get costTypeWaterDesc;

  /// No description provided for @costTypeTransportDesc.
  ///
  /// In es, this message translates to:
  /// **'Logística y movilización'**
  String get costTypeTransportDesc;

  /// No description provided for @costTypeAdminDesc.
  ///
  /// In es, this message translates to:
  /// **'Gastos generales'**
  String get costTypeAdminDesc;

  /// No description provided for @costTypeDepreciationDesc.
  ///
  /// In es, this message translates to:
  /// **'Desgaste de activos'**
  String get costTypeDepreciationDesc;

  /// No description provided for @costTypeFinancialDesc.
  ///
  /// In es, this message translates to:
  /// **'Intereses y comisiones'**
  String get costTypeFinancialDesc;

  /// No description provided for @costTypeOtherDesc.
  ///
  /// In es, this message translates to:
  /// **'Gastos varios'**
  String get costTypeOtherDesc;

  /// No description provided for @costCategoryProduction.
  ///
  /// In es, this message translates to:
  /// **'Costo de Producción'**
  String get costCategoryProduction;

  /// No description provided for @costCategoryPersonnel.
  ///
  /// In es, this message translates to:
  /// **'Gastos de Personal'**
  String get costCategoryPersonnel;

  /// No description provided for @costCategoryOperating.
  ///
  /// In es, this message translates to:
  /// **'Gastos Operativos'**
  String get costCategoryOperating;

  /// No description provided for @costCategoryDistribution.
  ///
  /// In es, this message translates to:
  /// **'Gastos de Distribución'**
  String get costCategoryDistribution;

  /// No description provided for @costCategoryAdmin.
  ///
  /// In es, this message translates to:
  /// **'Gastos Administrativos'**
  String get costCategoryAdmin;

  /// No description provided for @costCategoryDepreciation.
  ///
  /// In es, this message translates to:
  /// **'Depreciación y Amortización'**
  String get costCategoryDepreciation;

  /// No description provided for @costCategoryFinancial.
  ///
  /// In es, this message translates to:
  /// **'Gastos Financieros'**
  String get costCategoryFinancial;

  /// No description provided for @costCategoryOther.
  ///
  /// In es, this message translates to:
  /// **'Otros Gastos'**
  String get costCategoryOther;

  /// No description provided for @costValidateConceptEmpty.
  ///
  /// In es, this message translates to:
  /// **'El concepto no puede estar vacío'**
  String get costValidateConceptEmpty;

  /// No description provided for @costValidateAmountPositive.
  ///
  /// In es, this message translates to:
  /// **'El monto debe ser mayor a 0'**
  String get costValidateAmountPositive;

  /// No description provided for @costValidateBirdCountPositive.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves debe ser mayor a 0'**
  String get costValidateBirdCountPositive;

  /// No description provided for @costValidateApprovalNotRequired.
  ///
  /// In es, this message translates to:
  /// **'Este gasto no requiere aprobación'**
  String get costValidateApprovalNotRequired;

  /// No description provided for @costValidateAlreadyApproved.
  ///
  /// In es, this message translates to:
  /// **'Este gasto ya está aprobado'**
  String get costValidateAlreadyApproved;

  /// No description provided for @costValidateRejectionReasonRequired.
  ///
  /// In es, this message translates to:
  /// **'Debe proporcionar un motivo de rechazo'**
  String get costValidateRejectionReasonRequired;

  /// No description provided for @costCenterBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote'**
  String get costCenterBatch;

  /// No description provided for @costCenterHouse.
  ///
  /// In es, this message translates to:
  /// **'Casa'**
  String get costCenterHouse;

  /// No description provided for @costCenterAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrativa'**
  String get costCenterAdmin;

  /// No description provided for @invItemTypeFeed.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get invItemTypeFeed;

  /// No description provided for @invItemTypeFeedDesc.
  ///
  /// In es, this message translates to:
  /// **'Concentrados, granos y suplementos'**
  String get invItemTypeFeedDesc;

  /// No description provided for @invItemTypeMedicine.
  ///
  /// In es, this message translates to:
  /// **'Medicamento'**
  String get invItemTypeMedicine;

  /// No description provided for @invItemTypeMedicineDesc.
  ///
  /// In es, this message translates to:
  /// **'Fármacos y productos sanitarios'**
  String get invItemTypeMedicineDesc;

  /// No description provided for @invItemTypeVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get invItemTypeVaccine;

  /// No description provided for @invItemTypeVaccineDesc.
  ///
  /// In es, this message translates to:
  /// **'Vacunas y biológicos'**
  String get invItemTypeVaccineDesc;

  /// No description provided for @invItemTypeEquipment.
  ///
  /// In es, this message translates to:
  /// **'Equipo'**
  String get invItemTypeEquipment;

  /// No description provided for @invItemTypeEquipmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Herramientas y maquinaria'**
  String get invItemTypeEquipmentDesc;

  /// No description provided for @invItemTypeSupply.
  ///
  /// In es, this message translates to:
  /// **'Insumo'**
  String get invItemTypeSupply;

  /// No description provided for @invItemTypeSupplyDesc.
  ///
  /// In es, this message translates to:
  /// **'Material de cama, empaques, etc.'**
  String get invItemTypeSupplyDesc;

  /// No description provided for @invItemTypeCleaning.
  ///
  /// In es, this message translates to:
  /// **'Limpieza'**
  String get invItemTypeCleaning;

  /// No description provided for @invItemTypeCleaningDesc.
  ///
  /// In es, this message translates to:
  /// **'Desinfectantes y productos de aseo'**
  String get invItemTypeCleaningDesc;

  /// No description provided for @invItemTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get invItemTypeOther;

  /// No description provided for @invItemTypeOtherDesc.
  ///
  /// In es, this message translates to:
  /// **'Items varios'**
  String get invItemTypeOtherDesc;

  /// No description provided for @invMovePurchase.
  ///
  /// In es, this message translates to:
  /// **'Compra'**
  String get invMovePurchase;

  /// No description provided for @invMovePurchaseDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingreso por adquisición'**
  String get invMovePurchaseDesc;

  /// No description provided for @invMoveDonation.
  ///
  /// In es, this message translates to:
  /// **'Donación'**
  String get invMoveDonation;

  /// No description provided for @invMoveDonationDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingreso por donación'**
  String get invMoveDonationDesc;

  /// No description provided for @invMoveReturn.
  ///
  /// In es, this message translates to:
  /// **'Devolución'**
  String get invMoveReturn;

  /// No description provided for @invMoveReturnDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingreso por devolución de uso'**
  String get invMoveReturnDesc;

  /// No description provided for @invMoveAdjustUp.
  ///
  /// In es, this message translates to:
  /// **'Ajuste (+)'**
  String get invMoveAdjustUp;

  /// No description provided for @invMoveAdjustUpDesc.
  ///
  /// In es, this message translates to:
  /// **'Ajuste de inventario positivo'**
  String get invMoveAdjustUpDesc;

  /// No description provided for @invMoveBatchConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo Lote'**
  String get invMoveBatchConsumption;

  /// No description provided for @invMoveBatchConsumptionDesc.
  ///
  /// In es, this message translates to:
  /// **'Salida por alimentación de aves'**
  String get invMoveBatchConsumptionDesc;

  /// No description provided for @invMoveTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get invMoveTreatment;

  /// No description provided for @invMoveTreatmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Salida por aplicación de medicamento'**
  String get invMoveTreatmentDesc;

  /// No description provided for @invMoveVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get invMoveVaccination;

  /// No description provided for @invMoveVaccinationDesc.
  ///
  /// In es, this message translates to:
  /// **'Salida por aplicación de vacuna'**
  String get invMoveVaccinationDesc;

  /// No description provided for @invMoveShrinkage.
  ///
  /// In es, this message translates to:
  /// **'Merma'**
  String get invMoveShrinkage;

  /// No description provided for @invMoveShrinkageDesc.
  ///
  /// In es, this message translates to:
  /// **'Pérdida por deterioro o vencimiento'**
  String get invMoveShrinkageDesc;

  /// No description provided for @invMoveAdjustDown.
  ///
  /// In es, this message translates to:
  /// **'Ajuste (-)'**
  String get invMoveAdjustDown;

  /// No description provided for @invMoveAdjustDownDesc.
  ///
  /// In es, this message translates to:
  /// **'Ajuste de inventario negativo'**
  String get invMoveAdjustDownDesc;

  /// No description provided for @invMoveTransfer.
  ///
  /// In es, this message translates to:
  /// **'Transferencia'**
  String get invMoveTransfer;

  /// No description provided for @invMoveTransferDesc.
  ///
  /// In es, this message translates to:
  /// **'Traslado a otra ubicación'**
  String get invMoveTransferDesc;

  /// No description provided for @invMoveGeneralUse.
  ///
  /// In es, this message translates to:
  /// **'Uso General'**
  String get invMoveGeneralUse;

  /// No description provided for @invMoveGeneralUseDesc.
  ///
  /// In es, this message translates to:
  /// **'Salida por uso operativo'**
  String get invMoveGeneralUseDesc;

  /// No description provided for @invMoveSale.
  ///
  /// In es, this message translates to:
  /// **'Venta'**
  String get invMoveSale;

  /// No description provided for @invMoveSaleDesc.
  ///
  /// In es, this message translates to:
  /// **'Salida por venta de productos'**
  String get invMoveSaleDesc;

  /// No description provided for @invUnitKilogram.
  ///
  /// In es, this message translates to:
  /// **'Kilogramo'**
  String get invUnitKilogram;

  /// No description provided for @invUnitGram.
  ///
  /// In es, this message translates to:
  /// **'Gramo'**
  String get invUnitGram;

  /// No description provided for @invUnitPound.
  ///
  /// In es, this message translates to:
  /// **'Libra'**
  String get invUnitPound;

  /// No description provided for @invUnitLiter.
  ///
  /// In es, this message translates to:
  /// **'Litro'**
  String get invUnitLiter;

  /// No description provided for @invUnitMilliliter.
  ///
  /// In es, this message translates to:
  /// **'Mililitro'**
  String get invUnitMilliliter;

  /// No description provided for @invUnitUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get invUnitUnit;

  /// No description provided for @invUnitDozen.
  ///
  /// In es, this message translates to:
  /// **'Docena'**
  String get invUnitDozen;

  /// No description provided for @invUnitSack.
  ///
  /// In es, this message translates to:
  /// **'Saco'**
  String get invUnitSack;

  /// No description provided for @invUnitBag.
  ///
  /// In es, this message translates to:
  /// **'Bulto'**
  String get invUnitBag;

  /// No description provided for @invUnitBox.
  ///
  /// In es, this message translates to:
  /// **'Caja'**
  String get invUnitBox;

  /// No description provided for @invUnitVial.
  ///
  /// In es, this message translates to:
  /// **'Frasco'**
  String get invUnitVial;

  /// No description provided for @invUnitDose.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get invUnitDose;

  /// No description provided for @invUnitAmpoule.
  ///
  /// In es, this message translates to:
  /// **'Ampolla'**
  String get invUnitAmpoule;

  /// No description provided for @invUnitCategoryWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get invUnitCategoryWeight;

  /// No description provided for @invUnitCategoryVolume.
  ///
  /// In es, this message translates to:
  /// **'Volumen'**
  String get invUnitCategoryVolume;

  /// No description provided for @invUnitCategoryQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get invUnitCategoryQuantity;

  /// No description provided for @invUnitCategoryPackaging.
  ///
  /// In es, this message translates to:
  /// **'Empaque'**
  String get invUnitCategoryPackaging;

  /// No description provided for @invUnitCategoryApplication.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get invUnitCategoryApplication;

  /// No description provided for @healthDiseaseCatViral.
  ///
  /// In es, this message translates to:
  /// **'Viral'**
  String get healthDiseaseCatViral;

  /// No description provided for @healthDiseaseCatViralDesc.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades causadas por virus'**
  String get healthDiseaseCatViralDesc;

  /// No description provided for @healthDiseaseCatBacterial.
  ///
  /// In es, this message translates to:
  /// **'Bacteriana'**
  String get healthDiseaseCatBacterial;

  /// No description provided for @healthDiseaseCatBacterialDesc.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades causadas por bacterias'**
  String get healthDiseaseCatBacterialDesc;

  /// No description provided for @healthDiseaseCatParasitic.
  ///
  /// In es, this message translates to:
  /// **'Parasitaria'**
  String get healthDiseaseCatParasitic;

  /// No description provided for @healthDiseaseCatParasiticDesc.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades causadas por parásitos'**
  String get healthDiseaseCatParasiticDesc;

  /// No description provided for @healthDiseaseCatFungal.
  ///
  /// In es, this message translates to:
  /// **'Fúngica'**
  String get healthDiseaseCatFungal;

  /// No description provided for @healthDiseaseCatFungalDesc.
  ///
  /// In es, this message translates to:
  /// **'Enfermedades causadas por hongos'**
  String get healthDiseaseCatFungalDesc;

  /// No description provided for @healthDiseaseCatNutritional.
  ///
  /// In es, this message translates to:
  /// **'Nutricional'**
  String get healthDiseaseCatNutritional;

  /// No description provided for @healthDiseaseCatNutritionalDesc.
  ///
  /// In es, this message translates to:
  /// **'Deficiencias nutricionales'**
  String get healthDiseaseCatNutritionalDesc;

  /// No description provided for @healthDiseaseCatMetabolic.
  ///
  /// In es, this message translates to:
  /// **'Metabólica'**
  String get healthDiseaseCatMetabolic;

  /// No description provided for @healthDiseaseCatMetabolicDesc.
  ///
  /// In es, this message translates to:
  /// **'Trastornos metabólicos'**
  String get healthDiseaseCatMetabolicDesc;

  /// No description provided for @healthDiseaseCatEnvironmental.
  ///
  /// In es, this message translates to:
  /// **'Ambiental'**
  String get healthDiseaseCatEnvironmental;

  /// No description provided for @healthDiseaseCatEnvironmentalDesc.
  ///
  /// In es, this message translates to:
  /// **'Causadas por factores ambientales'**
  String get healthDiseaseCatEnvironmentalDesc;

  /// No description provided for @healthSeverityMild.
  ///
  /// In es, this message translates to:
  /// **'Leve'**
  String get healthSeverityMild;

  /// No description provided for @healthSeverityMildDesc.
  ///
  /// In es, this message translates to:
  /// **'Bajo impacto en producción'**
  String get healthSeverityMildDesc;

  /// No description provided for @healthSeverityModerate.
  ///
  /// In es, this message translates to:
  /// **'Moderada'**
  String get healthSeverityModerate;

  /// No description provided for @healthSeverityModerateDesc.
  ///
  /// In es, this message translates to:
  /// **'Impacto medio en producción'**
  String get healthSeverityModerateDesc;

  /// No description provided for @healthSeveritySevere.
  ///
  /// In es, this message translates to:
  /// **'Grave'**
  String get healthSeveritySevere;

  /// No description provided for @healthSeveritySevereDesc.
  ///
  /// In es, this message translates to:
  /// **'Alto impacto, requiere acción inmediata'**
  String get healthSeveritySevereDesc;

  /// No description provided for @healthSeverityCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get healthSeverityCritical;

  /// No description provided for @healthSeverityCriticalDesc.
  ///
  /// In es, this message translates to:
  /// **'Emergencia sanitaria'**
  String get healthSeverityCriticalDesc;

  /// No description provided for @healthDiseaseNewcastle.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad de Newcastle'**
  String get healthDiseaseNewcastle;

  /// No description provided for @healthDiseaseGumboro.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad de Gumboro (IBD)'**
  String get healthDiseaseGumboro;

  /// No description provided for @healthDiseaseMarek.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad de Marek'**
  String get healthDiseaseMarek;

  /// No description provided for @healthDiseaseBronchitis.
  ///
  /// In es, this message translates to:
  /// **'Bronquitis Infecciosa (IB)'**
  String get healthDiseaseBronchitis;

  /// No description provided for @healthDiseaseAvianFlu.
  ///
  /// In es, this message translates to:
  /// **'Influenza Aviar (HPAI/LPAI)'**
  String get healthDiseaseAvianFlu;

  /// No description provided for @healthDiseaseLaryngotracheitis.
  ///
  /// In es, this message translates to:
  /// **'Laringotraqueitis Infecciosa (ILT)'**
  String get healthDiseaseLaryngotracheitis;

  /// No description provided for @healthDiseaseFowlPox.
  ///
  /// In es, this message translates to:
  /// **'Viruela Aviar'**
  String get healthDiseaseFowlPox;

  /// No description provided for @healthDiseaseInfectiousAnemia.
  ///
  /// In es, this message translates to:
  /// **'Anemia Infecciosa Aviar (CAV)'**
  String get healthDiseaseInfectiousAnemia;

  /// No description provided for @healthDiseaseColibacillosis.
  ///
  /// In es, this message translates to:
  /// **'Colibacilosis (E. coli)'**
  String get healthDiseaseColibacillosis;

  /// No description provided for @healthDiseaseSalmonella.
  ///
  /// In es, this message translates to:
  /// **'Salmonelosis'**
  String get healthDiseaseSalmonella;

  /// No description provided for @healthDiseaseMycoplasmosis.
  ///
  /// In es, this message translates to:
  /// **'Micoplasmosis (MG/MS)'**
  String get healthDiseaseMycoplasmosis;

  /// No description provided for @healthDiseaseFowlCholera.
  ///
  /// In es, this message translates to:
  /// **'Cólera Aviar'**
  String get healthDiseaseFowlCholera;

  /// No description provided for @healthDiseaseCoryza.
  ///
  /// In es, this message translates to:
  /// **'Coriza Infecciosa'**
  String get healthDiseaseCoryza;

  /// No description provided for @healthDiseaseNecroticEnteritis.
  ///
  /// In es, this message translates to:
  /// **'Enteritis Necrótica'**
  String get healthDiseaseNecroticEnteritis;

  /// No description provided for @healthDiseaseCoccidiosis.
  ///
  /// In es, this message translates to:
  /// **'Coccidiosis'**
  String get healthDiseaseCoccidiosis;

  /// No description provided for @healthDiseaseRoundworms.
  ///
  /// In es, this message translates to:
  /// **'Ascaridiasis (Lombrices)'**
  String get healthDiseaseRoundworms;

  /// No description provided for @healthDiseaseAspergillosis.
  ///
  /// In es, this message translates to:
  /// **'Aspergilosis'**
  String get healthDiseaseAspergillosis;

  /// No description provided for @healthDiseaseAscites.
  ///
  /// In es, this message translates to:
  /// **'Síndrome Ascítico'**
  String get healthDiseaseAscites;

  /// No description provided for @healthDiseaseSuddenDeath.
  ///
  /// In es, this message translates to:
  /// **'Síndrome de Muerte Súbita (SDS)'**
  String get healthDiseaseSuddenDeath;

  /// No description provided for @healthDiseaseVitEDeficiency.
  ///
  /// In es, this message translates to:
  /// **'Encefalomalacia (Def. Vit E)'**
  String get healthDiseaseVitEDeficiency;

  /// No description provided for @healthDiseaseRickets.
  ///
  /// In es, this message translates to:
  /// **'Raquitismo (Def. Vit D/Ca/P)'**
  String get healthDiseaseRickets;

  /// No description provided for @healthMortalityDisease.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad'**
  String get healthMortalityDisease;

  /// No description provided for @healthMortalityDiseaseDesc.
  ///
  /// In es, this message translates to:
  /// **'Patología infecciosa'**
  String get healthMortalityDiseaseDesc;

  /// No description provided for @healthMortalityAccident.
  ///
  /// In es, this message translates to:
  /// **'Accidente'**
  String get healthMortalityAccident;

  /// No description provided for @healthMortalityAccidentDesc.
  ///
  /// In es, this message translates to:
  /// **'Trauma o lesión'**
  String get healthMortalityAccidentDesc;

  /// No description provided for @healthMortalityMalnutrition.
  ///
  /// In es, this message translates to:
  /// **'Desnutrición'**
  String get healthMortalityMalnutrition;

  /// No description provided for @healthMortalityMalnutritionDesc.
  ///
  /// In es, this message translates to:
  /// **'Falta de nutrientes'**
  String get healthMortalityMalnutritionDesc;

  /// No description provided for @healthMortalityStress.
  ///
  /// In es, this message translates to:
  /// **'Estrés'**
  String get healthMortalityStress;

  /// No description provided for @healthMortalityStressDesc.
  ///
  /// In es, this message translates to:
  /// **'Factores ambientales'**
  String get healthMortalityStressDesc;

  /// No description provided for @healthMortalityMetabolic.
  ///
  /// In es, this message translates to:
  /// **'Metabólica'**
  String get healthMortalityMetabolic;

  /// No description provided for @healthMortalityMetabolicDesc.
  ///
  /// In es, this message translates to:
  /// **'Problemas fisiológicos'**
  String get healthMortalityMetabolicDesc;

  /// No description provided for @healthMortalityPredation.
  ///
  /// In es, this message translates to:
  /// **'Depredación'**
  String get healthMortalityPredation;

  /// No description provided for @healthMortalityPredationDesc.
  ///
  /// In es, this message translates to:
  /// **'Ataques de animales'**
  String get healthMortalityPredationDesc;

  /// No description provided for @healthMortalitySacrifice.
  ///
  /// In es, this message translates to:
  /// **'Sacrificio'**
  String get healthMortalitySacrifice;

  /// No description provided for @healthMortalitySacrificeDesc.
  ///
  /// In es, this message translates to:
  /// **'Muerte en faena'**
  String get healthMortalitySacrificeDesc;

  /// No description provided for @healthMortalityOldAge.
  ///
  /// In es, this message translates to:
  /// **'Vejez'**
  String get healthMortalityOldAge;

  /// No description provided for @healthMortalityOldAgeDesc.
  ///
  /// In es, this message translates to:
  /// **'Fin de vida productiva'**
  String get healthMortalityOldAgeDesc;

  /// No description provided for @healthMortalityUnknown.
  ///
  /// In es, this message translates to:
  /// **'Desconocida'**
  String get healthMortalityUnknown;

  /// No description provided for @healthMortalityUnknownDesc.
  ///
  /// In es, this message translates to:
  /// **'Causa no identificada'**
  String get healthMortalityUnknownDesc;

  /// No description provided for @healthMortalityCatSanitary.
  ///
  /// In es, this message translates to:
  /// **'Sanitaria'**
  String get healthMortalityCatSanitary;

  /// No description provided for @healthMortalityCatManagement.
  ///
  /// In es, this message translates to:
  /// **'Manejo'**
  String get healthMortalityCatManagement;

  /// No description provided for @healthMortalityCatNutritional.
  ///
  /// In es, this message translates to:
  /// **'Nutricional'**
  String get healthMortalityCatNutritional;

  /// No description provided for @healthMortalityCatEnvironmental.
  ///
  /// In es, this message translates to:
  /// **'Ambiental'**
  String get healthMortalityCatEnvironmental;

  /// No description provided for @healthMortalityCatPhysiological.
  ///
  /// In es, this message translates to:
  /// **'Fisiológica'**
  String get healthMortalityCatPhysiological;

  /// No description provided for @healthMortalityCatNatural.
  ///
  /// In es, this message translates to:
  /// **'Natural'**
  String get healthMortalityCatNatural;

  /// No description provided for @healthMortalityCatUnclassified.
  ///
  /// In es, this message translates to:
  /// **'Sin clasificar'**
  String get healthMortalityCatUnclassified;

  /// No description provided for @healthActionVetDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Solicitar diagnóstico veterinario'**
  String get healthActionVetDiagnosis;

  /// No description provided for @healthActionIsolate.
  ///
  /// In es, this message translates to:
  /// **'Aislar aves afectadas'**
  String get healthActionIsolate;

  /// No description provided for @healthActionTreatment.
  ///
  /// In es, this message translates to:
  /// **'Aplicar tratamiento si está disponible'**
  String get healthActionTreatment;

  /// No description provided for @healthActionBiosecurity.
  ///
  /// In es, this message translates to:
  /// **'Aumentar bioseguridad'**
  String get healthActionBiosecurity;

  /// No description provided for @healthActionVaccinationReview.
  ///
  /// In es, this message translates to:
  /// **'Revisar programa de vacunación'**
  String get healthActionVaccinationReview;

  /// No description provided for @healthActionInspectFacilities.
  ///
  /// In es, this message translates to:
  /// **'Inspeccionar instalaciones'**
  String get healthActionInspectFacilities;

  /// No description provided for @healthActionRepairEquipment.
  ///
  /// In es, this message translates to:
  /// **'Reparar equipos dañados'**
  String get healthActionRepairEquipment;

  /// No description provided for @healthActionCheckDensity.
  ///
  /// In es, this message translates to:
  /// **'Revisar densidad de aves'**
  String get healthActionCheckDensity;

  /// No description provided for @healthActionTrainStaff.
  ///
  /// In es, this message translates to:
  /// **'Capacitar personal en manejo'**
  String get healthActionTrainStaff;

  /// No description provided for @healthActionCheckFoodAccess.
  ///
  /// In es, this message translates to:
  /// **'Verificar acceso al alimento'**
  String get healthActionCheckFoodAccess;

  /// No description provided for @healthActionCheckFoodQuality.
  ///
  /// In es, this message translates to:
  /// **'Revisar calidad del alimento'**
  String get healthActionCheckFoodQuality;

  /// No description provided for @healthActionCheckDrinkers.
  ///
  /// In es, this message translates to:
  /// **'Comprobar funcionamiento de bebederos'**
  String get healthActionCheckDrinkers;

  /// No description provided for @healthActionAdjustNutrition.
  ///
  /// In es, this message translates to:
  /// **'Ajustar programa nutricional'**
  String get healthActionAdjustNutrition;

  /// No description provided for @healthActionRegulateTemp.
  ///
  /// In es, this message translates to:
  /// **'Regular temperatura ambiente'**
  String get healthActionRegulateTemp;

  /// No description provided for @healthActionImproveVentilation.
  ///
  /// In es, this message translates to:
  /// **'Mejorar ventilación'**
  String get healthActionImproveVentilation;

  /// No description provided for @healthActionReduceDensity.
  ///
  /// In es, this message translates to:
  /// **'Reducir densidad si es necesario'**
  String get healthActionReduceDensity;

  /// No description provided for @healthActionConsultNutritionist.
  ///
  /// In es, this message translates to:
  /// **'Consultar con nutricionista'**
  String get healthActionConsultNutritionist;

  /// No description provided for @healthActionReviewGrowthProgram.
  ///
  /// In es, this message translates to:
  /// **'Revisar programa de crecimiento'**
  String get healthActionReviewGrowthProgram;

  /// No description provided for @healthActionAdjustFormula.
  ///
  /// In es, this message translates to:
  /// **'Ajustar formulación del alimento'**
  String get healthActionAdjustFormula;

  /// No description provided for @healthActionReinforceFences.
  ///
  /// In es, this message translates to:
  /// **'Reforzar cercos perimetrales'**
  String get healthActionReinforceFences;

  /// No description provided for @healthActionPestControl.
  ///
  /// In es, this message translates to:
  /// **'Implementar control de plagas'**
  String get healthActionPestControl;

  /// No description provided for @healthActionInstallNets.
  ///
  /// In es, this message translates to:
  /// **'Instalar mallas de protección'**
  String get healthActionInstallNets;

  /// No description provided for @healthActionNormalProcess.
  ///
  /// In es, this message translates to:
  /// **'Normal en el proceso productivo'**
  String get healthActionNormalProcess;

  /// No description provided for @healthActionRequestNecropsy.
  ///
  /// In es, this message translates to:
  /// **'Solicitar necropsia si mortalidad es alta'**
  String get healthActionRequestNecropsy;

  /// No description provided for @healthActionIncreaseMonitoring.
  ///
  /// In es, this message translates to:
  /// **'Aumentar monitoreo del lote'**
  String get healthActionIncreaseMonitoring;

  /// No description provided for @healthActionConsultVet.
  ///
  /// In es, this message translates to:
  /// **'Consultar con veterinario'**
  String get healthActionConsultVet;

  /// No description provided for @healthRouteOral.
  ///
  /// In es, this message translates to:
  /// **'Oral'**
  String get healthRouteOral;

  /// No description provided for @healthRouteOralDesc.
  ///
  /// In es, this message translates to:
  /// **'Administración por vía oral'**
  String get healthRouteOralDesc;

  /// No description provided for @healthRouteWater.
  ///
  /// In es, this message translates to:
  /// **'En Agua'**
  String get healthRouteWater;

  /// No description provided for @healthRouteWaterDesc.
  ///
  /// In es, this message translates to:
  /// **'Disuelta en agua de bebida'**
  String get healthRouteWaterDesc;

  /// No description provided for @healthRouteFood.
  ///
  /// In es, this message translates to:
  /// **'En Alimento'**
  String get healthRouteFood;

  /// No description provided for @healthRouteFoodDesc.
  ///
  /// In es, this message translates to:
  /// **'Mezclado en el alimento'**
  String get healthRouteFoodDesc;

  /// No description provided for @healthRouteOcular.
  ///
  /// In es, this message translates to:
  /// **'Ocular'**
  String get healthRouteOcular;

  /// No description provided for @healthRouteOcularDesc.
  ///
  /// In es, this message translates to:
  /// **'Gota en el ojo'**
  String get healthRouteOcularDesc;

  /// No description provided for @healthRouteNasal.
  ///
  /// In es, this message translates to:
  /// **'Nasal'**
  String get healthRouteNasal;

  /// No description provided for @healthRouteNasalDesc.
  ///
  /// In es, this message translates to:
  /// **'Spray o gota nasal'**
  String get healthRouteNasalDesc;

  /// No description provided for @healthRouteSpray.
  ///
  /// In es, this message translates to:
  /// **'Spray'**
  String get healthRouteSpray;

  /// No description provided for @healthRouteSprayDesc.
  ///
  /// In es, this message translates to:
  /// **'Aspersión sobre las aves'**
  String get healthRouteSprayDesc;

  /// No description provided for @healthRouteSubcutaneous.
  ///
  /// In es, this message translates to:
  /// **'Inyección SC'**
  String get healthRouteSubcutaneous;

  /// No description provided for @healthRouteSubcutaneousDesc.
  ///
  /// In es, this message translates to:
  /// **'Subcutánea en cuello'**
  String get healthRouteSubcutaneousDesc;

  /// No description provided for @healthRouteIntramuscular.
  ///
  /// In es, this message translates to:
  /// **'Inyección IM'**
  String get healthRouteIntramuscular;

  /// No description provided for @healthRouteIntramuscularDesc.
  ///
  /// In es, this message translates to:
  /// **'Intramuscular en pechuga'**
  String get healthRouteIntramuscularDesc;

  /// No description provided for @healthRouteWing.
  ///
  /// In es, this message translates to:
  /// **'En Ala'**
  String get healthRouteWing;

  /// No description provided for @healthRouteWingDesc.
  ///
  /// In es, this message translates to:
  /// **'Punción en membrana del ala'**
  String get healthRouteWingDesc;

  /// No description provided for @healthRouteInOvo.
  ///
  /// In es, this message translates to:
  /// **'In-Ovo'**
  String get healthRouteInOvo;

  /// No description provided for @healthRouteInOvoDesc.
  ///
  /// In es, this message translates to:
  /// **'Inyección en el huevo'**
  String get healthRouteInOvoDesc;

  /// No description provided for @healthRouteTopical.
  ///
  /// In es, this message translates to:
  /// **'Tópica'**
  String get healthRouteTopical;

  /// No description provided for @healthRouteTopicalDesc.
  ///
  /// In es, this message translates to:
  /// **'Aplicación externa en piel'**
  String get healthRouteTopicalDesc;

  /// No description provided for @healthBioStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get healthBioStatusPending;

  /// No description provided for @healthBioStatusCompliant.
  ///
  /// In es, this message translates to:
  /// **'Cumple'**
  String get healthBioStatusCompliant;

  /// No description provided for @healthBioStatusNonCompliant.
  ///
  /// In es, this message translates to:
  /// **'No Cumple'**
  String get healthBioStatusNonCompliant;

  /// No description provided for @healthBioStatusPartial.
  ///
  /// In es, this message translates to:
  /// **'Parcial'**
  String get healthBioStatusPartial;

  /// No description provided for @healthBioStatusNA.
  ///
  /// In es, this message translates to:
  /// **'N/A'**
  String get healthBioStatusNA;

  /// No description provided for @healthBioCatPersonnel.
  ///
  /// In es, this message translates to:
  /// **'Acceso de Personal'**
  String get healthBioCatPersonnel;

  /// No description provided for @healthBioCatPersonnelDesc.
  ///
  /// In es, this message translates to:
  /// **'Control de ingreso y vestimenta'**
  String get healthBioCatPersonnelDesc;

  /// No description provided for @healthBioCatVehicles.
  ///
  /// In es, this message translates to:
  /// **'Acceso de Vehículos'**
  String get healthBioCatVehicles;

  /// No description provided for @healthBioCatVehiclesDesc.
  ///
  /// In es, this message translates to:
  /// **'Control de vehículos y equipos'**
  String get healthBioCatVehiclesDesc;

  /// No description provided for @healthBioCatCleaning.
  ///
  /// In es, this message translates to:
  /// **'Limpieza y Desinfección'**
  String get healthBioCatCleaning;

  /// No description provided for @healthBioCatCleaningDesc.
  ///
  /// In es, this message translates to:
  /// **'Protocolos de higiene'**
  String get healthBioCatCleaningDesc;

  /// No description provided for @healthBioCatPestControl.
  ///
  /// In es, this message translates to:
  /// **'Control de Plagas'**
  String get healthBioCatPestControl;

  /// No description provided for @healthBioCatPestControlDesc.
  ///
  /// In es, this message translates to:
  /// **'Roedores, insectos, aves silvestres'**
  String get healthBioCatPestControlDesc;

  /// No description provided for @healthBioCatBirdManagement.
  ///
  /// In es, this message translates to:
  /// **'Manejo de Aves'**
  String get healthBioCatBirdManagement;

  /// No description provided for @healthBioCatBirdManagementDesc.
  ///
  /// In es, this message translates to:
  /// **'Prácticas con las aves'**
  String get healthBioCatBirdManagementDesc;

  /// No description provided for @healthBioCatMortality.
  ///
  /// In es, this message translates to:
  /// **'Manejo de Mortalidad'**
  String get healthBioCatMortality;

  /// No description provided for @healthBioCatMortalityDesc.
  ///
  /// In es, this message translates to:
  /// **'Disposición de aves muertas'**
  String get healthBioCatMortalityDesc;

  /// No description provided for @healthBioCatWater.
  ///
  /// In es, this message translates to:
  /// **'Calidad del Agua'**
  String get healthBioCatWater;

  /// No description provided for @healthBioCatWaterDesc.
  ///
  /// In es, this message translates to:
  /// **'Potabilidad y cloración'**
  String get healthBioCatWaterDesc;

  /// No description provided for @healthBioCatFeed.
  ///
  /// In es, this message translates to:
  /// **'Manejo de Alimento'**
  String get healthBioCatFeed;

  /// No description provided for @healthBioCatFeedDesc.
  ///
  /// In es, this message translates to:
  /// **'Almacenamiento y calidad'**
  String get healthBioCatFeedDesc;

  /// No description provided for @healthBioCatFacilities.
  ///
  /// In es, this message translates to:
  /// **'Instalaciones'**
  String get healthBioCatFacilities;

  /// No description provided for @healthBioCatFacilitiesDesc.
  ///
  /// In es, this message translates to:
  /// **'Estado de galpones y equipos'**
  String get healthBioCatFacilitiesDesc;

  /// No description provided for @healthBioCatRecords.
  ///
  /// In es, this message translates to:
  /// **'Registros'**
  String get healthBioCatRecords;

  /// No description provided for @healthBioCatRecordsDesc.
  ///
  /// In es, this message translates to:
  /// **'Documentación y trazabilidad'**
  String get healthBioCatRecordsDesc;

  /// No description provided for @healthInspFreqDaily.
  ///
  /// In es, this message translates to:
  /// **'Diaria'**
  String get healthInspFreqDaily;

  /// No description provided for @healthInspFreqWeekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get healthInspFreqWeekly;

  /// No description provided for @healthInspFreqBiweekly.
  ///
  /// In es, this message translates to:
  /// **'Quincenal'**
  String get healthInspFreqBiweekly;

  /// No description provided for @healthInspFreqMonthly.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get healthInspFreqMonthly;

  /// No description provided for @healthInspFreqQuarterly.
  ///
  /// In es, this message translates to:
  /// **'Trimestral'**
  String get healthInspFreqQuarterly;

  /// No description provided for @healthInspFreqPerBatch.
  ///
  /// In es, this message translates to:
  /// **'Por Lote'**
  String get healthInspFreqPerBatch;

  /// No description provided for @healthAbCriticallyImportant.
  ///
  /// In es, this message translates to:
  /// **'Críticamente Importante'**
  String get healthAbCriticallyImportant;

  /// No description provided for @healthAbHighlyImportant.
  ///
  /// In es, this message translates to:
  /// **'Altamente Importante'**
  String get healthAbHighlyImportant;

  /// No description provided for @healthAbImportant.
  ///
  /// In es, this message translates to:
  /// **'Importante'**
  String get healthAbImportant;

  /// No description provided for @healthAbUnclassified.
  ///
  /// In es, this message translates to:
  /// **'No Clasificado'**
  String get healthAbUnclassified;

  /// No description provided for @healthAbFamilyFluoroquinolones.
  ///
  /// In es, this message translates to:
  /// **'Fluoroquinolonas'**
  String get healthAbFamilyFluoroquinolones;

  /// No description provided for @healthAbFamilyCephalosporins.
  ///
  /// In es, this message translates to:
  /// **'Cefalosporinas 3a/4a gen'**
  String get healthAbFamilyCephalosporins;

  /// No description provided for @healthAbFamilyMacrolides.
  ///
  /// In es, this message translates to:
  /// **'Macrólidos'**
  String get healthAbFamilyMacrolides;

  /// No description provided for @healthAbFamilyPolymyxins.
  ///
  /// In es, this message translates to:
  /// **'Polimixinas (Colistina)'**
  String get healthAbFamilyPolymyxins;

  /// No description provided for @healthAbFamilyAminoglycosides.
  ///
  /// In es, this message translates to:
  /// **'Aminoglucósidos'**
  String get healthAbFamilyAminoglycosides;

  /// No description provided for @healthAbFamilyPenicillins.
  ///
  /// In es, this message translates to:
  /// **'Penicilinas'**
  String get healthAbFamilyPenicillins;

  /// No description provided for @healthAbFamilyTetracyclines.
  ///
  /// In es, this message translates to:
  /// **'Tetraciclinas'**
  String get healthAbFamilyTetracyclines;

  /// No description provided for @healthAbFamilySulfonamides.
  ///
  /// In es, this message translates to:
  /// **'Sulfonamidas'**
  String get healthAbFamilySulfonamides;

  /// No description provided for @healthAbFamilyLincosamides.
  ///
  /// In es, this message translates to:
  /// **'Lincosamidas'**
  String get healthAbFamilyLincosamides;

  /// No description provided for @healthAbFamilyPleuromutilins.
  ///
  /// In es, this message translates to:
  /// **'Pleuromutilinas'**
  String get healthAbFamilyPleuromutilins;

  /// No description provided for @healthAbFamilyBacitracin.
  ///
  /// In es, this message translates to:
  /// **'Bacitracina'**
  String get healthAbFamilyBacitracin;

  /// No description provided for @healthAbFamilyIonophores.
  ///
  /// In es, this message translates to:
  /// **'Ionóforos'**
  String get healthAbFamilyIonophores;

  /// No description provided for @healthAbUseTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get healthAbUseTreatment;

  /// No description provided for @healthAbUseTreatmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento de enfermedad diagnosticada'**
  String get healthAbUseTreatmentDesc;

  /// No description provided for @healthAbUseMetaphylaxis.
  ///
  /// In es, this message translates to:
  /// **'Metafilaxis'**
  String get healthAbUseMetaphylaxis;

  /// No description provided for @healthAbUseMetaphylaxisDesc.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento preventivo de grupo en riesgo'**
  String get healthAbUseMetaphylaxisDesc;

  /// No description provided for @healthAbUseProphylaxis.
  ///
  /// In es, this message translates to:
  /// **'Profilaxis'**
  String get healthAbUseProphylaxis;

  /// No description provided for @healthAbUseProphylaxisDesc.
  ///
  /// In es, this message translates to:
  /// **'Prevención en animales sanos'**
  String get healthAbUseProphylaxisDesc;

  /// No description provided for @healthAbUseGrowthPromoter.
  ///
  /// In es, this message translates to:
  /// **'Promotor de Crecimiento'**
  String get healthAbUseGrowthPromoter;

  /// No description provided for @healthAbUseGrowthPromoterDesc.
  ///
  /// In es, this message translates to:
  /// **'Uso prohibido en muchos países'**
  String get healthAbUseGrowthPromoterDesc;

  /// No description provided for @healthBirdTypeBroiler.
  ///
  /// In es, this message translates to:
  /// **'Pollo de Engorde'**
  String get healthBirdTypeBroiler;

  /// No description provided for @healthBirdTypeLayerCommercial.
  ///
  /// In es, this message translates to:
  /// **'Gallina Ponedora Comercial'**
  String get healthBirdTypeLayerCommercial;

  /// No description provided for @healthBirdTypeLayerFreeRange.
  ///
  /// In es, this message translates to:
  /// **'Gallina Ponedora Pastoreo'**
  String get healthBirdTypeLayerFreeRange;

  /// No description provided for @healthBirdTypeHeavyBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Pesada'**
  String get healthBirdTypeHeavyBreeder;

  /// No description provided for @healthBirdTypeLightBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Ligera'**
  String get healthBirdTypeLightBreeder;

  /// No description provided for @healthBirdTypeTurkeyMeat.
  ///
  /// In es, this message translates to:
  /// **'Pavo de Engorde'**
  String get healthBirdTypeTurkeyMeat;

  /// No description provided for @healthBirdTypeQuail.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get healthBirdTypeQuail;

  /// No description provided for @healthBirdTypeDuck.
  ///
  /// In es, this message translates to:
  /// **'Pato'**
  String get healthBirdTypeDuck;

  /// No description provided for @farmStatusMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get farmStatusMaintenance;

  /// No description provided for @farmRoleOwner.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get farmRoleOwner;

  /// No description provided for @farmRoleAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get farmRoleAdmin;

  /// No description provided for @farmRoleManager.
  ///
  /// In es, this message translates to:
  /// **'Gestor'**
  String get farmRoleManager;

  /// No description provided for @farmRoleOperator.
  ///
  /// In es, this message translates to:
  /// **'Operario'**
  String get farmRoleOperator;

  /// No description provided for @farmRoleViewer.
  ///
  /// In es, this message translates to:
  /// **'Visualizador'**
  String get farmRoleViewer;

  /// No description provided for @farmRoleOwnerDesc.
  ///
  /// In es, this message translates to:
  /// **'Control total, puede eliminar la granja'**
  String get farmRoleOwnerDesc;

  /// No description provided for @farmRoleAdminDesc.
  ///
  /// In es, this message translates to:
  /// **'Control total excepto eliminar'**
  String get farmRoleAdminDesc;

  /// No description provided for @farmRoleManagerDesc.
  ///
  /// In es, this message translates to:
  /// **'Gestión de registros e invitaciones'**
  String get farmRoleManagerDesc;

  /// No description provided for @farmRoleOperatorDesc.
  ///
  /// In es, this message translates to:
  /// **'Solo puede crear registros'**
  String get farmRoleOperatorDesc;

  /// No description provided for @farmRoleViewerDesc.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura'**
  String get farmRoleViewerDesc;

  /// No description provided for @farmCreating.
  ///
  /// In es, this message translates to:
  /// **'Creando granja...'**
  String get farmCreating;

  /// No description provided for @farmUpdating.
  ///
  /// In es, this message translates to:
  /// **'Actualizando granja...'**
  String get farmUpdating;

  /// No description provided for @farmDeleting.
  ///
  /// In es, this message translates to:
  /// **'Eliminando granja...'**
  String get farmDeleting;

  /// No description provided for @farmActivating.
  ///
  /// In es, this message translates to:
  /// **'Activando granja...'**
  String get farmActivating;

  /// No description provided for @farmSuspending.
  ///
  /// In es, this message translates to:
  /// **'Suspendiendo granja...'**
  String get farmSuspending;

  /// No description provided for @farmMaintenanceLoading.
  ///
  /// In es, this message translates to:
  /// **'Poniendo en mantenimiento...'**
  String get farmMaintenanceLoading;

  /// No description provided for @farmSearching.
  ///
  /// In es, this message translates to:
  /// **'Buscando granjas...'**
  String get farmSearching;

  /// No description provided for @shedStatusActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get shedStatusActive;

  /// No description provided for @shedStatusMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get shedStatusMaintenance;

  /// No description provided for @shedStatusInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get shedStatusInactive;

  /// No description provided for @shedStatusDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Desinfección'**
  String get shedStatusDisinfection;

  /// No description provided for @shedStatusQuarantine.
  ///
  /// In es, this message translates to:
  /// **'Cuarentena'**
  String get shedStatusQuarantine;

  /// No description provided for @shedTypeMeat.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get shedTypeMeat;

  /// No description provided for @shedTypeMeatDesc.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de carne'**
  String get shedTypeMeatDesc;

  /// No description provided for @shedTypeEgg.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get shedTypeEgg;

  /// No description provided for @shedTypeEggDesc.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de huevos'**
  String get shedTypeEggDesc;

  /// No description provided for @shedTypeBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductora'**
  String get shedTypeBreeder;

  /// No description provided for @shedTypeBreederDesc.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de huevos fértiles'**
  String get shedTypeBreederDesc;

  /// No description provided for @shedTypeMixed.
  ///
  /// In es, this message translates to:
  /// **'Mixto'**
  String get shedTypeMixed;

  /// No description provided for @shedTypeMixedDesc.
  ///
  /// In es, this message translates to:
  /// **'Galpón multiuso para diferentes tipos de producción'**
  String get shedTypeMixedDesc;

  /// No description provided for @shedEventDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Desinfección'**
  String get shedEventDisinfection;

  /// No description provided for @shedEventMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get shedEventMaintenance;

  /// No description provided for @shedEventStatusChange.
  ///
  /// In es, this message translates to:
  /// **'Cambio de Estado'**
  String get shedEventStatusChange;

  /// No description provided for @shedEventCreation.
  ///
  /// In es, this message translates to:
  /// **'Creación'**
  String get shedEventCreation;

  /// No description provided for @shedEventBatchAssigned.
  ///
  /// In es, this message translates to:
  /// **'Lote Asignado'**
  String get shedEventBatchAssigned;

  /// No description provided for @shedEventBatchReleased.
  ///
  /// In es, this message translates to:
  /// **'Lote Liberado'**
  String get shedEventBatchReleased;

  /// No description provided for @shedEventOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get shedEventOther;

  /// No description provided for @shedCreating.
  ///
  /// In es, this message translates to:
  /// **'Creando galpón...'**
  String get shedCreating;

  /// No description provided for @shedUpdating.
  ///
  /// In es, this message translates to:
  /// **'Actualizando galpón...'**
  String get shedUpdating;

  /// No description provided for @shedDeleting.
  ///
  /// In es, this message translates to:
  /// **'Eliminando galpón...'**
  String get shedDeleting;

  /// No description provided for @shedChangingStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiando estado...'**
  String get shedChangingStatus;

  /// No description provided for @shedAssigningBatch.
  ///
  /// In es, this message translates to:
  /// **'Asignando lote...'**
  String get shedAssigningBatch;

  /// No description provided for @shedReleasing.
  ///
  /// In es, this message translates to:
  /// **'Liberando galpón...'**
  String get shedReleasing;

  /// No description provided for @shedSchedulingMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Programando mantenimiento...'**
  String get shedSchedulingMaintenance;

  /// No description provided for @shedBatchAssignedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lote asignado exitosamente'**
  String get shedBatchAssignedSuccess;

  /// No description provided for @shedReleasedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Galpón liberado exitosamente'**
  String get shedReleasedSuccess;

  /// No description provided for @shedMaintenanceScheduled.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento programado'**
  String get shedMaintenanceScheduled;

  /// No description provided for @notifStockLow.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get notifStockLow;

  /// No description provided for @notifStockEmpty.
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get notifStockEmpty;

  /// No description provided for @notifExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximo a Vencer'**
  String get notifExpiringSoon;

  /// No description provided for @notifExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencido'**
  String get notifExpired;

  /// No description provided for @notifRestocked.
  ///
  /// In es, this message translates to:
  /// **'Reabastecido'**
  String get notifRestocked;

  /// No description provided for @notifInventoryMovement.
  ///
  /// In es, this message translates to:
  /// **'Movimiento'**
  String get notifInventoryMovement;

  /// No description provided for @notifMortalityRecorded.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Registrada'**
  String get notifMortalityRecorded;

  /// No description provided for @notifMortalityHigh.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Alta'**
  String get notifMortalityHigh;

  /// No description provided for @notifMortalityCritical.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad Crítica'**
  String get notifMortalityCritical;

  /// No description provided for @notifNewBatch.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Lote'**
  String get notifNewBatch;

  /// No description provided for @notifBatchFinished.
  ///
  /// In es, this message translates to:
  /// **'Lote Finalizado'**
  String get notifBatchFinished;

  /// No description provided for @notifWeightLow.
  ///
  /// In es, this message translates to:
  /// **'Peso Bajo'**
  String get notifWeightLow;

  /// No description provided for @notifCloseUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Cierre Próximo'**
  String get notifCloseUpcoming;

  /// No description provided for @notifConversionAbnormal.
  ///
  /// In es, this message translates to:
  /// **'Conversión Anormal'**
  String get notifConversionAbnormal;

  /// No description provided for @notifNoRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin Registros'**
  String get notifNoRecords;

  /// No description provided for @notifProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción'**
  String get notifProduction;

  /// No description provided for @notifProductionLow.
  ///
  /// In es, this message translates to:
  /// **'Producción Baja'**
  String get notifProductionLow;

  /// No description provided for @notifProductionDrop.
  ///
  /// In es, this message translates to:
  /// **'Caída Producción'**
  String get notifProductionDrop;

  /// No description provided for @notifFirstEgg.
  ///
  /// In es, this message translates to:
  /// **'Primer Huevo'**
  String get notifFirstEgg;

  /// No description provided for @notifRecord.
  ///
  /// In es, this message translates to:
  /// **'Récord'**
  String get notifRecord;

  /// No description provided for @notifGoalReached.
  ///
  /// In es, this message translates to:
  /// **'Meta Alcanzada'**
  String get notifGoalReached;

  /// No description provided for @notifVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get notifVaccination;

  /// No description provided for @notifVaccinationTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Vacunación Mañana'**
  String get notifVaccinationTomorrow;

  /// No description provided for @notifPriorityLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get notifPriorityLow;

  /// No description provided for @notifPriorityNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get notifPriorityNormal;

  /// No description provided for @notifPriorityHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get notifPriorityHigh;

  /// No description provided for @notifPriorityUrgent.
  ///
  /// In es, this message translates to:
  /// **'Urgente'**
  String get notifPriorityUrgent;

  /// No description provided for @notifTitleStockLow.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Stock bajo: {itemName}'**
  String notifTitleStockLow(Object itemName);

  /// No description provided for @notifMsgStockLow.
  ///
  /// In es, this message translates to:
  /// **'Solo quedan {quantity} {unit}'**
  String notifMsgStockLow(Object quantity, Object unit);

  /// No description provided for @notifTitleStockEmpty.
  ///
  /// In es, this message translates to:
  /// **'🚫 Agotado: {itemName}'**
  String notifTitleStockEmpty(Object itemName);

  /// No description provided for @notifMsgStockEmpty.
  ///
  /// In es, this message translates to:
  /// **'Stock en cero, requiere reabastecimiento urgente'**
  String get notifMsgStockEmpty;

  /// No description provided for @notifTitleExpired.
  ///
  /// In es, this message translates to:
  /// **'❌ Vencido: {itemName}'**
  String notifTitleExpired(Object itemName);

  /// No description provided for @notifMsgExpired.
  ///
  /// In es, this message translates to:
  /// **'Este producto venció hace {days} días'**
  String notifMsgExpired(Object days);

  /// No description provided for @notifTitleExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'📅 Próximo a vencer: {itemName}'**
  String notifTitleExpiringSoon(Object itemName);

  /// No description provided for @notifMsgExpiresToday.
  ///
  /// In es, this message translates to:
  /// **'¡Vence hoy!'**
  String get notifMsgExpiresToday;

  /// No description provided for @notifMsgExpiresInDays.
  ///
  /// In es, this message translates to:
  /// **'Vence en {days} días'**
  String notifMsgExpiresInDays(Object days);

  /// No description provided for @notifTitleRestocked.
  ///
  /// In es, this message translates to:
  /// **'✅ Reabastecido: {itemName}'**
  String notifTitleRestocked(Object itemName);

  /// No description provided for @notifMsgRestocked.
  ///
  /// In es, this message translates to:
  /// **'Se agregaron {quantity} {unit}'**
  String notifMsgRestocked(Object quantity, Object unit);

  /// No description provided for @notifTitleMortalityCritical.
  ///
  /// In es, this message translates to:
  /// **'🚨 Mortalidad CRÍTICA: {batchName}'**
  String notifTitleMortalityCritical(Object batchName);

  /// No description provided for @notifTitleMortalityHigh.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Mortalidad alta: {batchName}'**
  String notifTitleMortalityHigh(Object batchName);

  /// No description provided for @notifTitleMortalityRecorded.
  ///
  /// In es, this message translates to:
  /// **'🐔 Mortalidad registrada: {batchName}'**
  String notifTitleMortalityRecorded(Object batchName);

  /// No description provided for @notifMsgMortalityRecorded.
  ///
  /// In es, this message translates to:
  /// **'{count} aves • Causa: {cause} • Acumulada: {percentage}%'**
  String notifMsgMortalityRecorded(
    Object cause,
    Object count,
    Object percentage,
  );

  /// No description provided for @notifTitleNewBatch.
  ///
  /// In es, this message translates to:
  /// **'🐤 Nuevo lote: {batchName}'**
  String notifTitleNewBatch(Object batchName);

  /// No description provided for @notifMsgNewBatch.
  ///
  /// In es, this message translates to:
  /// **'{birdCount} aves en {shedName}'**
  String notifMsgNewBatch(Object birdCount, Object shedName);

  /// No description provided for @notifTitleBatchFinished.
  ///
  /// In es, this message translates to:
  /// **'✅ Lote finalizado: {batchName}'**
  String notifTitleBatchFinished(Object batchName);

  /// No description provided for @notifMsgBatchFinished.
  ///
  /// In es, this message translates to:
  /// **'Ciclo de {days} días'**
  String notifMsgBatchFinished(Object days);

  /// No description provided for @notifTitleWeightLow.
  ///
  /// In es, this message translates to:
  /// **'⚖️ Peso bajo: {batchName}'**
  String notifTitleWeightLow(Object batchName);

  /// No description provided for @notifTitleConversionAbnormal.
  ///
  /// In es, this message translates to:
  /// **'📊 Conversión anormal: {batchName}'**
  String notifTitleConversionAbnormal(Object batchName);

  /// No description provided for @notifTitleCloseUpcoming.
  ///
  /// In es, this message translates to:
  /// **'📆 Cierre próximo: {batchName}'**
  String notifTitleCloseUpcoming(Object batchName);

  /// No description provided for @notifMsgClosesToday.
  ///
  /// In es, this message translates to:
  /// **'¡Fecha de cierre es hoy!'**
  String get notifMsgClosesToday;

  /// No description provided for @notifMsgClosesInDays.
  ///
  /// In es, this message translates to:
  /// **'Cierra en {days} días'**
  String notifMsgClosesInDays(Object days);

  /// No description provided for @reportTypeBatchProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción de Lote'**
  String get reportTypeBatchProduction;

  /// No description provided for @reportTypeBatchProductionDesc.
  ///
  /// In es, this message translates to:
  /// **'Resumen completo del rendimiento productivo'**
  String get reportTypeBatchProductionDesc;

  /// No description provided for @reportTypeMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get reportTypeMortality;

  /// No description provided for @reportTypeMortalityDesc.
  ///
  /// In es, this message translates to:
  /// **'Análisis detallado de mortalidad y causas'**
  String get reportTypeMortalityDesc;

  /// No description provided for @reportTypeFeedConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo de Alimento'**
  String get reportTypeFeedConsumption;

  /// No description provided for @reportTypeFeedConsumptionDesc.
  ///
  /// In es, this message translates to:
  /// **'Análisis de consumo y conversión alimenticia'**
  String get reportTypeFeedConsumptionDesc;

  /// No description provided for @reportTypeWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso y Crecimiento'**
  String get reportTypeWeight;

  /// No description provided for @reportTypeWeightDesc.
  ///
  /// In es, this message translates to:
  /// **'Evolución de peso y curvas de crecimiento'**
  String get reportTypeWeightDesc;

  /// No description provided for @reportTypeCosts.
  ///
  /// In es, this message translates to:
  /// **'Costos'**
  String get reportTypeCosts;

  /// No description provided for @reportTypeCostsDesc.
  ///
  /// In es, this message translates to:
  /// **'Desglose de gastos y costos operativos'**
  String get reportTypeCostsDesc;

  /// No description provided for @reportTypeSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get reportTypeSales;

  /// No description provided for @reportTypeSalesDesc.
  ///
  /// In es, this message translates to:
  /// **'Resumen de ventas e ingresos'**
  String get reportTypeSalesDesc;

  /// No description provided for @reportTypeProfitability.
  ///
  /// In es, this message translates to:
  /// **'Rentabilidad'**
  String get reportTypeProfitability;

  /// No description provided for @reportTypeProfitabilityDesc.
  ///
  /// In es, this message translates to:
  /// **'Análisis de utilidad y márgenes'**
  String get reportTypeProfitabilityDesc;

  /// No description provided for @reportTypeHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get reportTypeHealth;

  /// No description provided for @reportTypeHealthDesc.
  ///
  /// In es, this message translates to:
  /// **'Historial de tratamientos y vacunaciones'**
  String get reportTypeHealthDesc;

  /// No description provided for @reportTypeInventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get reportTypeInventory;

  /// No description provided for @reportTypeInventoryDesc.
  ///
  /// In es, this message translates to:
  /// **'Estado actual del inventario'**
  String get reportTypeInventoryDesc;

  /// No description provided for @reportTypeExecutive.
  ///
  /// In es, this message translates to:
  /// **'Resumen Ejecutivo'**
  String get reportTypeExecutive;

  /// No description provided for @reportTypeExecutiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Vista consolidada de indicadores clave'**
  String get reportTypeExecutiveDesc;

  /// No description provided for @reportPeriodWeek.
  ///
  /// In es, this message translates to:
  /// **'Última semana'**
  String get reportPeriodWeek;

  /// No description provided for @reportPeriodMonth.
  ///
  /// In es, this message translates to:
  /// **'Último mes'**
  String get reportPeriodMonth;

  /// No description provided for @reportPeriodQuarter.
  ///
  /// In es, this message translates to:
  /// **'Último trimestre'**
  String get reportPeriodQuarter;

  /// No description provided for @reportPeriodSemester.
  ///
  /// In es, this message translates to:
  /// **'Último semestre'**
  String get reportPeriodSemester;

  /// No description provided for @reportPeriodYear.
  ///
  /// In es, this message translates to:
  /// **'Último año'**
  String get reportPeriodYear;

  /// No description provided for @reportPeriodCustom.
  ///
  /// In es, this message translates to:
  /// **'Personalizado'**
  String get reportPeriodCustom;

  /// No description provided for @reportFormatPdf.
  ///
  /// In es, this message translates to:
  /// **'PDF'**
  String get reportFormatPdf;

  /// No description provided for @reportFormatPreview.
  ///
  /// In es, this message translates to:
  /// **'Vista previa'**
  String get reportFormatPreview;

  /// No description provided for @reportPdfHeaderProduction.
  ///
  /// In es, this message translates to:
  /// **'REPORTE DE PRODUCCIÓN'**
  String get reportPdfHeaderProduction;

  /// No description provided for @reportPdfHeaderExecutive.
  ///
  /// In es, this message translates to:
  /// **'RESUMEN EJECUTIVO'**
  String get reportPdfHeaderExecutive;

  /// No description provided for @reportPdfHeaderCosts.
  ///
  /// In es, this message translates to:
  /// **'REPORTE DE COSTOS'**
  String get reportPdfHeaderCosts;

  /// No description provided for @reportPdfHeaderSales.
  ///
  /// In es, this message translates to:
  /// **'REPORTE DE VENTAS'**
  String get reportPdfHeaderSales;

  /// No description provided for @reportPdfSectionBatchInfo.
  ///
  /// In es, this message translates to:
  /// **'INFORMACIÓN DEL LOTE'**
  String get reportPdfSectionBatchInfo;

  /// No description provided for @reportPdfSectionProductionIndicators.
  ///
  /// In es, this message translates to:
  /// **'INDICADORES DE PRODUCCIÓN'**
  String get reportPdfSectionProductionIndicators;

  /// No description provided for @reportPdfSectionFinancialSummary.
  ///
  /// In es, this message translates to:
  /// **'RESUMEN FINANCIERO'**
  String get reportPdfSectionFinancialSummary;

  /// No description provided for @reportPdfLabelCode.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get reportPdfLabelCode;

  /// No description provided for @reportPdfLabelBirdType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Ave'**
  String get reportPdfLabelBirdType;

  /// No description provided for @reportPdfLabelShed.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get reportPdfLabelShed;

  /// No description provided for @reportPdfLabelEntryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha Ingreso'**
  String get reportPdfLabelEntryDate;

  /// No description provided for @reportPdfLabelCurrentAge.
  ///
  /// In es, this message translates to:
  /// **'Edad Actual'**
  String get reportPdfLabelCurrentAge;

  /// No description provided for @reportPdfLabelDaysInFarm.
  ///
  /// In es, this message translates to:
  /// **'Días en Granja'**
  String get reportPdfLabelDaysInFarm;

  /// No description provided for @reportPdfLabelInitialBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Iniciales'**
  String get reportPdfLabelInitialBirds;

  /// No description provided for @reportPdfLabelCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Actuales'**
  String get reportPdfLabelCurrentBirds;

  /// No description provided for @reportPdfLabelMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get reportPdfLabelMortality;

  /// No description provided for @reportPdfLabelAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso Promedio'**
  String get reportPdfLabelAvgWeight;

  /// No description provided for @reportPdfLabelTotalConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo Total'**
  String get reportPdfLabelTotalConsumption;

  /// No description provided for @reportPdfLabelConversion.
  ///
  /// In es, this message translates to:
  /// **'Conversión'**
  String get reportPdfLabelConversion;

  /// No description provided for @reportPdfLabelBirdCost.
  ///
  /// In es, this message translates to:
  /// **'Costo de Aves'**
  String get reportPdfLabelBirdCost;

  /// No description provided for @reportPdfLabelFeedCost.
  ///
  /// In es, this message translates to:
  /// **'Costo de Alimento'**
  String get reportPdfLabelFeedCost;

  /// No description provided for @reportPdfLabelTotalCosts.
  ///
  /// In es, this message translates to:
  /// **'Total Costos'**
  String get reportPdfLabelTotalCosts;

  /// No description provided for @reportPdfLabelSalesRevenue.
  ///
  /// In es, this message translates to:
  /// **'Ingresos por Ventas'**
  String get reportPdfLabelSalesRevenue;

  /// No description provided for @reportPdfLabelBalance.
  ///
  /// In es, this message translates to:
  /// **'BALANCE'**
  String get reportPdfLabelBalance;

  /// No description provided for @reportPdfLabelPeriod.
  ///
  /// In es, this message translates to:
  /// **'PERÍODO'**
  String get reportPdfLabelPeriod;

  /// No description provided for @reportPdfConversionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'kg alim / kg peso'**
  String get reportPdfConversionSubtitle;

  /// No description provided for @reportPageTitle.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reportPageTitle;

  /// No description provided for @reportSelectType.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de reporte'**
  String get reportSelectType;

  /// No description provided for @reportSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get reportSelectFarm;

  /// No description provided for @reportSelectFarmHint.
  ///
  /// In es, this message translates to:
  /// **'Para generar reportes, primero debes seleccionar una granja desde el inicio.'**
  String get reportSelectFarmHint;

  /// No description provided for @reportPeriodPrefix.
  ///
  /// In es, this message translates to:
  /// **'Período:'**
  String get reportPeriodPrefix;

  /// No description provided for @reportPeriodTitle.
  ///
  /// In es, this message translates to:
  /// **'Período del reporte'**
  String get reportPeriodTitle;

  /// No description provided for @reportDateFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get reportDateFrom;

  /// No description provided for @reportDateTo.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get reportDateTo;

  /// No description provided for @reportGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando...'**
  String get reportGenerating;

  /// No description provided for @reportGeneratePdf.
  ///
  /// In es, this message translates to:
  /// **'Generar Reporte PDF'**
  String get reportGeneratePdf;

  /// No description provided for @reportNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'No hay granja seleccionada'**
  String get reportNoFarmSelected;

  /// No description provided for @reportNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos para generar el reporte'**
  String get reportNoActiveBatches;

  /// No description provided for @reportInsufficientData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos suficientes para el reporte'**
  String get reportInsufficientData;

  /// No description provided for @reportGenerateError.
  ///
  /// In es, this message translates to:
  /// **'Error al generar reporte'**
  String get reportGenerateError;

  /// No description provided for @reportGenerated.
  ///
  /// In es, this message translates to:
  /// **'Reporte Generado'**
  String get reportGenerated;

  /// No description provided for @reportPrint.
  ///
  /// In es, this message translates to:
  /// **'Imprimir'**
  String get reportPrint;

  /// No description provided for @reportShareText.
  ///
  /// In es, this message translates to:
  /// **'Reporte generado por Smart Granja Aves Pro'**
  String get reportShareText;

  /// No description provided for @reportShareError.
  ///
  /// In es, this message translates to:
  /// **'Error al compartir'**
  String get reportShareError;

  /// No description provided for @reportPrintError.
  ///
  /// In es, this message translates to:
  /// **'Error al imprimir'**
  String get reportPrintError;

  /// No description provided for @notifPageTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifPageTitle;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas como leídas'**
  String get notifMarkAllRead;

  /// No description provided for @notifDeleteRead.
  ///
  /// In es, this message translates to:
  /// **'Eliminar leídas'**
  String get notifDeleteRead;

  /// No description provided for @notifLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar notificaciones'**
  String get notifLoadError;

  /// No description provided for @notifAllMarkedRead.
  ///
  /// In es, this message translates to:
  /// **'Todas marcadas como leídas'**
  String get notifAllMarkedRead;

  /// No description provided for @notifDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar notificaciones'**
  String get notifDeleteTitle;

  /// No description provided for @notifDeleteReadConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas eliminar todas las notificaciones leídas?'**
  String get notifDeleteReadConfirm;

  /// No description provided for @notifDeleted.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones eliminadas'**
  String get notifDeleted;

  /// No description provided for @notifNoDestination.
  ///
  /// In es, this message translates to:
  /// **'Esta notificación no tiene un destino disponible'**
  String get notifNoDestination;

  /// No description provided for @notifSingleDeleted.
  ///
  /// In es, this message translates to:
  /// **'Notificación eliminada'**
  String get notifSingleDeleted;

  /// No description provided for @notifAllCaughtUp.
  ///
  /// In es, this message translates to:
  /// **'¡Todo al día!'**
  String get notifAllCaughtUp;

  /// No description provided for @notifEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones pendientes.\nTe avisaremos cuando haya algo importante.'**
  String get notifEmptyMessage;

  /// No description provided for @notifTooltip.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifTooltip;

  /// No description provided for @profileEditProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get profileEditProfile;

  /// No description provided for @syncTitle.
  ///
  /// In es, this message translates to:
  /// **'Sincronización y Datos'**
  String get syncTitle;

  /// No description provided for @syncConnectionStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de Conexión'**
  String get syncConnectionStatus;

  /// No description provided for @syncPendingData.
  ///
  /// In es, this message translates to:
  /// **'Datos pendientes'**
  String get syncPendingData;

  /// No description provided for @syncChangesPending.
  ///
  /// In es, this message translates to:
  /// **'Hay cambios por sincronizar'**
  String get syncChangesPending;

  /// No description provided for @syncAllSynced.
  ///
  /// In es, this message translates to:
  /// **'Todo sincronizado'**
  String get syncAllSynced;

  /// No description provided for @syncLastSync.
  ///
  /// In es, this message translates to:
  /// **'Última sincronización'**
  String get syncLastSync;

  /// No description provided for @syncCheckConnection.
  ///
  /// In es, this message translates to:
  /// **'Verificar conexión'**
  String get syncCheckConnection;

  /// No description provided for @syncCompleted.
  ///
  /// In es, this message translates to:
  /// **'Sincronización completada'**
  String get syncCompleted;

  /// No description provided for @syncForceSync.
  ///
  /// In es, this message translates to:
  /// **'Forzar sincronización'**
  String get syncForceSync;

  /// No description provided for @syncOfflineInfo.
  ///
  /// In es, this message translates to:
  /// **'Los datos se guardan automáticamente en tu dispositivo y se sincronizan cuando hay conexión a internet.'**
  String get syncOfflineInfo;

  /// No description provided for @syncJustNow.
  ///
  /// In es, this message translates to:
  /// **'Hace un momento'**
  String get syncJustNow;

  /// No description provided for @syncMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {n} minutos'**
  String syncMinutesAgo(String n);

  /// No description provided for @syncHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {n} horas'**
  String syncHoursAgo(Object n);

  /// No description provided for @syncDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {n} días'**
  String syncDaysAgo(Object n);

  /// No description provided for @commonNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'No especificada'**
  String get commonNotSpecified;

  /// No description provided for @farmBroiler.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get farmBroiler;

  /// No description provided for @farmLayer.
  ///
  /// In es, this message translates to:
  /// **'Ponedora'**
  String get farmLayer;

  /// No description provided for @farmBreeder.
  ///
  /// In es, this message translates to:
  /// **'Reproductor'**
  String get farmBreeder;

  /// No description provided for @farmBird.
  ///
  /// In es, this message translates to:
  /// **'Ave'**
  String get farmBird;

  /// No description provided for @formStepBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get formStepBasic;

  /// No description provided for @formStepLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get formStepLocation;

  /// No description provided for @formStepContact.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get formStepContact;

  /// No description provided for @formStepCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad'**
  String get formStepCapacity;

  /// No description provided for @commonLeave.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get commonLeave;

  /// No description provided for @commonRestore.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get commonRestore;

  /// No description provided for @commonProcessing.
  ///
  /// In es, this message translates to:
  /// **'Procesando...'**
  String get commonProcessing;

  /// No description provided for @commonStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get commonStatus;

  /// No description provided for @commonDocument.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get commonDocument;

  /// No description provided for @commonSupplier.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get commonSupplier;

  /// No description provided for @commonRegistrationInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Registro'**
  String get commonRegistrationInfo;

  /// No description provided for @commonLastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get commonLastUpdate;

  /// No description provided for @commonDraftFoundTitle.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get commonDraftFoundTitle;

  /// No description provided for @commonExitWithoutCompleting.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get commonExitWithoutCompleting;

  /// No description provided for @commonDataSafe.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros.'**
  String get commonDataSafe;

  /// No description provided for @commonSubtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get commonSubtotal;

  /// No description provided for @commonFarm.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get commonFarm;

  /// No description provided for @commonBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote'**
  String get commonBatch;

  /// No description provided for @commonFarmNotFound.
  ///
  /// In es, this message translates to:
  /// **'Granja no encontrada'**
  String get commonFarmNotFound;

  /// No description provided for @commonBatchNotFound.
  ///
  /// In es, this message translates to:
  /// **'Lote no encontrado'**
  String get commonBatchNotFound;

  /// No description provided for @monthJanuary.
  ///
  /// In es, this message translates to:
  /// **'Enero'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In es, this message translates to:
  /// **'Febrero'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In es, this message translates to:
  /// **'Marzo'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In es, this message translates to:
  /// **'Abril'**
  String get monthApril;

  /// No description provided for @monthJune.
  ///
  /// In es, this message translates to:
  /// **'Junio'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In es, this message translates to:
  /// **'Julio'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In es, this message translates to:
  /// **'Agosto'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In es, this message translates to:
  /// **'Septiembre'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In es, this message translates to:
  /// **'Octubre'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In es, this message translates to:
  /// **'Noviembre'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In es, this message translates to:
  /// **'Diciembre'**
  String get monthDecember;

  /// No description provided for @monthJanAbbr.
  ///
  /// In es, this message translates to:
  /// **'ene'**
  String get monthJanAbbr;

  /// No description provided for @monthFebAbbr.
  ///
  /// In es, this message translates to:
  /// **'feb'**
  String get monthFebAbbr;

  /// No description provided for @monthMarAbbr.
  ///
  /// In es, this message translates to:
  /// **'mar'**
  String get monthMarAbbr;

  /// No description provided for @monthAprAbbr.
  ///
  /// In es, this message translates to:
  /// **'abr'**
  String get monthAprAbbr;

  /// No description provided for @monthMayAbbr.
  ///
  /// In es, this message translates to:
  /// **'may'**
  String get monthMayAbbr;

  /// No description provided for @monthJunAbbr.
  ///
  /// In es, this message translates to:
  /// **'jun'**
  String get monthJunAbbr;

  /// No description provided for @monthJulAbbr.
  ///
  /// In es, this message translates to:
  /// **'jul'**
  String get monthJulAbbr;

  /// No description provided for @monthAugAbbr.
  ///
  /// In es, this message translates to:
  /// **'ago'**
  String get monthAugAbbr;

  /// No description provided for @monthSepAbbr.
  ///
  /// In es, this message translates to:
  /// **'sep'**
  String get monthSepAbbr;

  /// No description provided for @monthOctAbbr.
  ///
  /// In es, this message translates to:
  /// **'oct'**
  String get monthOctAbbr;

  /// No description provided for @monthNovAbbr.
  ///
  /// In es, this message translates to:
  /// **'nov'**
  String get monthNovAbbr;

  /// No description provided for @monthDecAbbr.
  ///
  /// In es, this message translates to:
  /// **'dic'**
  String get monthDecAbbr;

  /// No description provided for @ventaLoteTitle.
  ///
  /// In es, this message translates to:
  /// **'Ventas del Lote'**
  String get ventaLoteTitle;

  /// No description provided for @ventaAllTitle.
  ///
  /// In es, this message translates to:
  /// **'Todas las Ventas'**
  String get ventaAllTitle;

  /// No description provided for @ventaFilterTooltip.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get ventaFilterTooltip;

  /// No description provided for @ventaEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin ventas registradas'**
  String get ventaEmptyTitle;

  /// No description provided for @ventaEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Registra tu primera venta para comenzar a llevar un control de tus ingresos'**
  String get ventaEmptyDescription;

  /// No description provided for @ventaEmptyAction.
  ///
  /// In es, this message translates to:
  /// **'Registrar primera venta'**
  String get ventaEmptyAction;

  /// No description provided for @ventaFilterEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron ventas'**
  String get ventaFilterEmptyTitle;

  /// No description provided for @ventaFilterEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Prueba modificando los filtros de búsqueda para encontrar las ventas que buscas'**
  String get ventaFilterEmptyDescription;

  /// No description provided for @ventaNewButton.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get ventaNewButton;

  /// No description provided for @ventaNewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar nueva venta'**
  String get ventaNewTooltip;

  /// No description provided for @ventaDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar venta?'**
  String get ventaDeleteTitle;

  /// No description provided for @ventaDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Venta eliminada correctamente'**
  String get ventaDeleteSuccess;

  /// No description provided for @ventaFilterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar ventas'**
  String get ventaFilterTitle;

  /// No description provided for @ventaFilterProductType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de producto'**
  String get ventaFilterProductType;

  /// No description provided for @ventaFilterSaleState.
  ///
  /// In es, this message translates to:
  /// **'Estado de venta'**
  String get ventaFilterSaleState;

  /// No description provided for @ventaFilterAllStates.
  ///
  /// In es, this message translates to:
  /// **'Todos los estados'**
  String get ventaFilterAllStates;

  /// No description provided for @ventaStatePending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get ventaStatePending;

  /// No description provided for @ventaStateConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get ventaStateConfirmed;

  /// No description provided for @ventaStateSold.
  ///
  /// In es, this message translates to:
  /// **'Vendida'**
  String get ventaStateSold;

  /// No description provided for @ventaSheetClient.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get ventaSheetClient;

  /// No description provided for @ventaSheetDiscount.
  ///
  /// In es, this message translates to:
  /// **'Descuento'**
  String get ventaSheetDiscount;

  /// No description provided for @ventaSheetInvoiceNumber.
  ///
  /// In es, this message translates to:
  /// **'Nº Factura'**
  String get ventaSheetInvoiceNumber;

  /// No description provided for @ventaSheetCarrier.
  ///
  /// In es, this message translates to:
  /// **'Transportista'**
  String get ventaSheetCarrier;

  /// No description provided for @ventaSheetGuideNumber.
  ///
  /// In es, this message translates to:
  /// **'Nº Guía'**
  String get ventaSheetGuideNumber;

  /// No description provided for @ventaSheetBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad aves'**
  String get ventaSheetBirdCount;

  /// No description provided for @ventaSheetAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get ventaSheetAvgWeight;

  /// No description provided for @ventaSheetPricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg'**
  String get ventaSheetPricePerKg;

  /// No description provided for @ventaSheetSlaughteredWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado'**
  String get ventaSheetSlaughteredWeight;

  /// No description provided for @ventaSheetYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento'**
  String get ventaSheetYield;

  /// No description provided for @ventaSheetTotalEggs.
  ///
  /// In es, this message translates to:
  /// **'Total huevos'**
  String get ventaSheetTotalEggs;

  /// No description provided for @ventaDetailNotFound.
  ///
  /// In es, this message translates to:
  /// **'Venta no encontrada'**
  String get ventaDetailNotFound;

  /// No description provided for @ventaDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Venta'**
  String get ventaDetailTitle;

  /// No description provided for @ventaDetailEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar venta'**
  String get ventaDetailEditTooltip;

  /// No description provided for @ventaDetailClient.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get ventaDetailClient;

  /// No description provided for @ventaDetailProductDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Producto'**
  String get ventaDetailProductDetails;

  /// No description provided for @ventaDetailBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get ventaDetailBirdCount;

  /// No description provided for @ventaDetailAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get ventaDetailAvgWeight;

  /// No description provided for @ventaDetailPricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg'**
  String get ventaDetailPricePerKg;

  /// No description provided for @ventaDetailQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get ventaDetailQuantity;

  /// No description provided for @ventaDetailUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get ventaDetailUnitPrice;

  /// No description provided for @ventaDetailCarcassYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento canal'**
  String get ventaDetailCarcassYield;

  /// No description provided for @ventaDetailTotalLabel.
  ///
  /// In es, this message translates to:
  /// **'TOTAL'**
  String get ventaDetailTotalLabel;

  /// No description provided for @ventaDetailShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get ventaDetailShare;

  /// No description provided for @ventaDetailSlaughteredWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado'**
  String get ventaDetailSlaughteredWeight;

  /// No description provided for @ventaStepProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto'**
  String get ventaStepProduct;

  /// No description provided for @ventaStepClient.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get ventaStepClient;

  /// No description provided for @ventaStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get ventaStepDetails;

  /// No description provided for @ventaDraftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador de venta guardado anteriormente?'**
  String get ventaDraftFoundMessage;

  /// No description provided for @ventaDraftRestored.
  ///
  /// In es, this message translates to:
  /// **'Borrador restaurado'**
  String get ventaDraftRestored;

  /// No description provided for @ventaDraftJustNow.
  ///
  /// In es, this message translates to:
  /// **'ahora mismo'**
  String get ventaDraftJustNow;

  /// No description provided for @ventaExitMessage.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros.'**
  String get ventaExitMessage;

  /// No description provided for @ventaNoEditPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar ventas en esta granja'**
  String get ventaNoEditPermission;

  /// No description provided for @ventaNoCreatePermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para registrar ventas en esta granja'**
  String get ventaNoCreatePermission;

  /// No description provided for @ventaUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Venta actualizada correctamente'**
  String get ventaUpdateSuccess;

  /// No description provided for @ventaCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Venta registrada exitosamente!'**
  String get ventaCreateSuccess;

  /// No description provided for @ventaInventoryWarning.
  ///
  /// In es, this message translates to:
  /// **'Venta registrada, pero hubo un error al actualizar inventario'**
  String get ventaInventoryWarning;

  /// No description provided for @ventaEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Venta'**
  String get ventaEditTitle;

  /// No description provided for @ventaNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get ventaNewTitle;

  /// No description provided for @ventaSelectProductFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo de producto primero'**
  String get ventaSelectProductFirst;

  /// No description provided for @ventaDetailsHint.
  ///
  /// In es, this message translates to:
  /// **'Ingresa cantidades, precios y otros detalles'**
  String get ventaDetailsHint;

  /// No description provided for @ventaNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'No hay una granja seleccionada. Por favor selecciona una granja primero.'**
  String get ventaNoFarmSelected;

  /// No description provided for @ventaLotLabel.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get ventaLotLabel;

  /// No description provided for @ventaNoActiveLots.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos en esta granja.'**
  String get ventaNoActiveLots;

  /// No description provided for @ventaSelectLotHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectLotHint;

  /// No description provided for @ventaSelectLotError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectLotError;

  /// No description provided for @ventaSaleDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de venta'**
  String get ventaSaleDate;

  /// No description provided for @ventaBirdCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get ventaBirdCount;

  /// No description provided for @ventaBirdCountRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad de aves'**
  String get ventaBirdCountRequired;

  /// No description provided for @ventaTotalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso total (kg)'**
  String get ventaTotalWeight;

  /// No description provided for @ventaSlaughteredWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado total (kg)'**
  String get ventaSlaughteredWeight;

  /// No description provided for @ventaWeightRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el peso total'**
  String get ventaWeightRequired;

  /// No description provided for @ventaPricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Precio por kg ({currency})'**
  String ventaPricePerKg(String currency);

  /// No description provided for @ventaPriceRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el precio por kg'**
  String get ventaPriceRequired;

  /// No description provided for @ventaEggInstructions.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad y precio por docena para cada clasificación'**
  String get ventaEggInstructions;

  /// No description provided for @ventaEggQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get ventaEggQuantity;

  /// No description provided for @ventaEggPricePerDozen.
  ///
  /// In es, this message translates to:
  /// **'{currency} por docena'**
  String ventaEggPricePerDozen(String currency);

  /// No description provided for @ventaSaleUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad de venta'**
  String get ventaSaleUnit;

  /// No description provided for @ventaQuantityRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad'**
  String get ventaQuantityRequired;

  /// No description provided for @ventaPriceRequired2.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el precio'**
  String get ventaPriceRequired2;

  /// No description provided for @ventaObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get ventaObservations;

  /// No description provided for @ventaObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales (opcional)'**
  String get ventaObservationsHint;

  /// No description provided for @ventaSubmitButton.
  ///
  /// In es, this message translates to:
  /// **'Registrar Venta'**
  String get ventaSubmitButton;

  /// No description provided for @ventaEditPageTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Venta'**
  String get ventaEditPageTitle;

  /// No description provided for @ventaEditNotFound.
  ///
  /// In es, this message translates to:
  /// **'Venta no encontrada'**
  String get ventaEditNotFound;

  /// No description provided for @ventaEditLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la venta'**
  String get ventaEditLoadError;

  /// No description provided for @ventaWhatToSell.
  ///
  /// In es, this message translates to:
  /// **'¿Qué deseas vender?'**
  String get ventaWhatToSell;

  /// No description provided for @ventaSelectProductType.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de producto para esta venta'**
  String get ventaSelectProductType;

  /// No description provided for @ventaDescAvesVivas.
  ///
  /// In es, this message translates to:
  /// **'Venta de aves en pie, listas para transporte o crianza'**
  String get ventaDescAvesVivas;

  /// No description provided for @ventaDescHuevos.
  ///
  /// In es, this message translates to:
  /// **'Venta de huevos por clasificación y docena'**
  String get ventaDescHuevos;

  /// No description provided for @ventaDescPollinaza.
  ///
  /// In es, this message translates to:
  /// **'Venta de abono orgánico por bulto, saco o tonelada'**
  String get ventaDescPollinaza;

  /// No description provided for @ventaDescAvesFaenadas.
  ///
  /// In es, this message translates to:
  /// **'Aves procesadas y listas para consumo'**
  String get ventaDescAvesFaenadas;

  /// No description provided for @ventaDescAvesDescarte.
  ///
  /// In es, this message translates to:
  /// **'Aves de descarte por fin de ciclo productivo'**
  String get ventaDescAvesDescarte;

  /// No description provided for @ventaClientData.
  ///
  /// In es, this message translates to:
  /// **'Datos del Cliente'**
  String get ventaClientData;

  /// No description provided for @ventaClientHint.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la información del comprador'**
  String get ventaClientHint;

  /// No description provided for @ventaClientName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get ventaClientName;

  /// No description provided for @ventaClientNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Juan Pérez García'**
  String get ventaClientNameHint;

  /// No description provided for @ventaClientDocType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de documento *'**
  String get ventaClientDocType;

  /// No description provided for @ventaClientCE.
  ///
  /// In es, this message translates to:
  /// **'Carnet de Extranjería'**
  String get ventaClientCE;

  /// No description provided for @ventaClientDocNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de documento'**
  String get ventaClientDocNumber;

  /// No description provided for @ventaClientDni8.
  ///
  /// In es, this message translates to:
  /// **'8 dígitos'**
  String get ventaClientDni8;

  /// No description provided for @ventaClientRuc11.
  ///
  /// In es, this message translates to:
  /// **'11 dígitos'**
  String get ventaClientRuc11;

  /// No description provided for @ventaClientPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono de contacto'**
  String get ventaClientPhone;

  /// No description provided for @ventaClient9Digits.
  ///
  /// In es, this message translates to:
  /// **'9 dígitos'**
  String get ventaClient9Digits;

  /// No description provided for @ventaClientNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del cliente'**
  String get ventaClientNameRequired;

  /// No description provided for @ventaClientNameMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get ventaClientNameMinLength;

  /// No description provided for @ventaClientDocRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el número de documento'**
  String get ventaClientDocRequired;

  /// No description provided for @ventaClientDniError.
  ///
  /// In es, this message translates to:
  /// **'El DNI debe tener 8 dígitos'**
  String get ventaClientDniError;

  /// No description provided for @ventaClientRucError.
  ///
  /// In es, this message translates to:
  /// **'El RUC debe tener 11 dígitos'**
  String get ventaClientRucError;

  /// No description provided for @ventaClientInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get ventaClientInvalidNumber;

  /// No description provided for @ventaClientPhoneRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el teléfono de contacto'**
  String get ventaClientPhoneRequired;

  /// No description provided for @ventaClientPhoneError.
  ///
  /// In es, this message translates to:
  /// **'El teléfono debe tener 9 dígitos'**
  String get ventaClientPhoneError;

  /// No description provided for @ventaSelectLocation.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Ubicación'**
  String get ventaSelectLocation;

  /// No description provided for @ventaSelectLocationHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la granja y el lote para registrar la venta'**
  String get ventaSelectLocationHint;

  /// No description provided for @ventaNoFarms.
  ///
  /// In es, this message translates to:
  /// **'No tienes granjas registradas'**
  String get ventaNoFarms;

  /// No description provided for @ventaCreateFarmFirst.
  ///
  /// In es, this message translates to:
  /// **'Debes crear una granja antes de registrar una venta'**
  String get ventaCreateFarmFirst;

  /// No description provided for @ventaFarmLabel.
  ///
  /// In es, this message translates to:
  /// **'Granja *'**
  String get ventaFarmLabel;

  /// No description provided for @ventaSelectFarmHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get ventaSelectFarmHint;

  /// No description provided for @ventaFarmRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get ventaFarmRequired;

  /// No description provided for @ventaNoActiveLots2.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos'**
  String get ventaNoActiveLots2;

  /// No description provided for @ventaNoActiveLotsHint.
  ///
  /// In es, this message translates to:
  /// **'Esta granja no tiene lotes activos para registrar ventas'**
  String get ventaNoActiveLotsHint;

  /// No description provided for @ventaLotLabel2.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get ventaLotLabel2;

  /// No description provided for @ventaSelectLotHint2.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectLotHint2;

  /// No description provided for @ventaLotRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un lote'**
  String get ventaLotRequired;

  /// No description provided for @ventaFarmLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas'**
  String get ventaFarmLoadError;

  /// No description provided for @ventaLotLoadError2.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get ventaLotLoadError2;

  /// No description provided for @ventaSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Ventas'**
  String get ventaSummaryTitle;

  /// No description provided for @ventaSummaryTotal.
  ///
  /// In es, this message translates to:
  /// **'Total en ventas'**
  String get ventaSummaryTotal;

  /// No description provided for @ventaSummaryActive.
  ///
  /// In es, this message translates to:
  /// **'Activas'**
  String get ventaSummaryActive;

  /// No description provided for @ventaSummaryCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get ventaSummaryCompleted;

  /// No description provided for @ventaLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar ventas'**
  String get ventaLoadError;

  /// No description provided for @ventaLoadErrorDetail.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un problema al obtener las ventas'**
  String get ventaLoadErrorDetail;

  /// No description provided for @ventaCardBuyer.
  ///
  /// In es, this message translates to:
  /// **'Comprador: '**
  String get ventaCardBuyer;

  /// No description provided for @ventaCardProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto: '**
  String get ventaCardProduct;

  /// No description provided for @ventaCardBirds.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get ventaCardBirds;

  /// No description provided for @ventaCardEggs.
  ///
  /// In es, this message translates to:
  /// **'huevos'**
  String get ventaCardEggs;

  /// No description provided for @ventaShareReceiptTitle.
  ///
  /// In es, this message translates to:
  /// **'📋 COMPROBANTE DE VENTA'**
  String get ventaShareReceiptTitle;

  /// No description provided for @costoLoteTitle.
  ///
  /// In es, this message translates to:
  /// **'Costos del Lote'**
  String get costoLoteTitle;

  /// No description provided for @costoAllTitle.
  ///
  /// In es, this message translates to:
  /// **'Todos los Costos'**
  String get costoAllTitle;

  /// No description provided for @costoFilterTooltip.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get costoFilterTooltip;

  /// No description provided for @costoEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin costos registrados'**
  String get costoEmptyTitle;

  /// No description provided for @costoEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Registra tus gastos operativos para llevar un control detallado de los costos de producción'**
  String get costoEmptyDescription;

  /// No description provided for @costoEmptyAction.
  ///
  /// In es, this message translates to:
  /// **'Registrar Costo'**
  String get costoEmptyAction;

  /// No description provided for @costoFilterEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron costos'**
  String get costoFilterEmptyTitle;

  /// No description provided for @costoFilterEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar los filtros o buscar con otros términos'**
  String get costoFilterEmptyDescription;

  /// No description provided for @costoNewButton.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Costo'**
  String get costoNewButton;

  /// No description provided for @costoNewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar nuevo costo'**
  String get costoNewTooltip;

  /// No description provided for @costoRejectTitle.
  ///
  /// In es, this message translates to:
  /// **'Rechazar Costo'**
  String get costoRejectTitle;

  /// No description provided for @costoRejectReasonLabel.
  ///
  /// In es, this message translates to:
  /// **'Motivo del rechazo'**
  String get costoRejectReasonLabel;

  /// No description provided for @costoRejectReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Explica por qué se rechaza este costo'**
  String get costoRejectReasonHint;

  /// No description provided for @costoRejectButton.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get costoRejectButton;

  /// No description provided for @costoRejectReasonRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un motivo de rechazo'**
  String get costoRejectReasonRequired;

  /// No description provided for @costoDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Costo'**
  String get costoDeleteTitle;

  /// No description provided for @costoDeleteWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get costoDeleteWarning;

  /// No description provided for @costoDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo eliminado correctamente'**
  String get costoDeleteSuccess;

  /// No description provided for @costoFilterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar costos'**
  String get costoFilterTitle;

  /// No description provided for @costoFilterExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de gasto'**
  String get costoFilterExpenseType;

  /// No description provided for @costoDetailLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el detalle del costo'**
  String get costoDetailLoadError;

  /// No description provided for @costoDetailNotFound.
  ///
  /// In es, this message translates to:
  /// **'Costo no encontrado'**
  String get costoDetailNotFound;

  /// No description provided for @costoDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del Costo'**
  String get costoDetailTitle;

  /// No description provided for @costoDetailEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar costo'**
  String get costoDetailEditTooltip;

  /// No description provided for @costoDetailPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get costoDetailPending;

  /// No description provided for @costoDetailRejected.
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get costoDetailRejected;

  /// No description provided for @costoDetailApproved.
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get costoDetailApproved;

  /// No description provided for @costoDetailNoStatus.
  ///
  /// In es, this message translates to:
  /// **'Sin estado'**
  String get costoDetailNoStatus;

  /// No description provided for @costoDetailGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get costoDetailGeneralInfo;

  /// No description provided for @costoDetailConcept.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get costoDetailConcept;

  /// No description provided for @costoDetailInvoiceNo.
  ///
  /// In es, this message translates to:
  /// **'Nº Factura'**
  String get costoDetailInvoiceNo;

  /// No description provided for @costoDetailDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este costo?'**
  String get costoDetailDeleteConfirm;

  /// No description provided for @costoDetailDeleteWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get costoDetailDeleteWarning;

  /// No description provided for @costoDetailDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar'**
  String get costoDetailDeleteError;

  /// No description provided for @costoDetailDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo eliminado exitosamente'**
  String get costoDetailDeleteSuccess;

  /// No description provided for @costoStepType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get costoStepType;

  /// No description provided for @costoStepAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get costoStepAmount;

  /// No description provided for @costoStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get costoStepDetails;

  /// No description provided for @costoDraftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador guardado anteriormente?'**
  String get costoDraftFoundMessage;

  /// No description provided for @costoTypeRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un tipo de gasto'**
  String get costoTypeRequired;

  /// No description provided for @costoNoEditPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar costos en esta granja'**
  String get costoNoEditPermission;

  /// No description provided for @costoNoCreatePermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para registrar costos en esta granja'**
  String get costoNoCreatePermission;

  /// No description provided for @costoUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo actualizado correctamente'**
  String get costoUpdateSuccess;

  /// No description provided for @costoCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo registrado correctamente'**
  String get costoCreateSuccess;

  /// No description provided for @costoInventoryWarning.
  ///
  /// In es, this message translates to:
  /// **'Costo registrado, pero hubo un error al actualizar inventario'**
  String get costoInventoryWarning;

  /// No description provided for @costoEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Costo'**
  String get costoEditTitle;

  /// No description provided for @costoRegisterTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Costo'**
  String get costoRegisterTitle;

  /// No description provided for @costoRegisterButton.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get costoRegisterButton;

  /// No description provided for @costoFarmRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get costoFarmRequired;

  /// No description provided for @costoWhatType.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de gasto es?'**
  String get costoWhatType;

  /// No description provided for @costoSelectCategory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la categoría que mejor describe este gasto'**
  String get costoSelectCategory;

  /// No description provided for @costoAmountTitle.
  ///
  /// In es, this message translates to:
  /// **'Monto del Gasto'**
  String get costoAmountTitle;

  /// No description provided for @costoAmountHint.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el monto total del gasto en soles'**
  String get costoAmountHint;

  /// No description provided for @costoConceptLabel.
  ///
  /// In es, this message translates to:
  /// **'Concepto del gasto'**
  String get costoConceptLabel;

  /// No description provided for @costoConceptHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Compra de alimento balanceado'**
  String get costoConceptHint;

  /// No description provided for @costoConceptRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el concepto del gasto'**
  String get costoConceptRequired;

  /// No description provided for @costoConceptMinLength.
  ///
  /// In es, this message translates to:
  /// **'El concepto debe tener al menos 5 caracteres'**
  String get costoConceptMinLength;

  /// No description provided for @costoAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get costoAmountLabel;

  /// No description provided for @costoAmountRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el monto'**
  String get costoAmountRequired;

  /// No description provided for @costoAmountInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un monto válido'**
  String get costoAmountInvalid;

  /// No description provided for @costoDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha del gasto *'**
  String get costoDateLabel;

  /// No description provided for @costoInventoryLinkInfo.
  ///
  /// In es, this message translates to:
  /// **'Puedes vincular este gasto a un producto del inventario para actualizar el stock automáticamente.'**
  String get costoInventoryLinkInfo;

  /// No description provided for @costoLinkFood.
  ///
  /// In es, this message translates to:
  /// **'Vincular a alimento del inventario'**
  String get costoLinkFood;

  /// No description provided for @costoLinkMedicine.
  ///
  /// In es, this message translates to:
  /// **'Vincular a medicamento del inventario'**
  String get costoLinkMedicine;

  /// No description provided for @costoInventorySearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en inventario (opcional)...'**
  String get costoInventorySearchHint;

  /// No description provided for @costoLinkedProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto vinculado'**
  String get costoLinkedProduct;

  /// No description provided for @costoStockUpdateNote.
  ///
  /// In es, this message translates to:
  /// **'Se actualizará el stock al guardar'**
  String get costoStockUpdateNote;

  /// No description provided for @costoAdditionalDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles Adicionales'**
  String get costoAdditionalDetails;

  /// No description provided for @costoAdditionalDetailsHint.
  ///
  /// In es, this message translates to:
  /// **'Información complementaria del gasto'**
  String get costoAdditionalDetailsHint;

  /// No description provided for @costoSupplierHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor o empresa'**
  String get costoSupplierHint;

  /// No description provided for @costoSupplierRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del proveedor'**
  String get costoSupplierRequired;

  /// No description provided for @costoSupplierMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get costoSupplierMinLength;

  /// No description provided for @costoInvoiceLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de Factura/Recibo'**
  String get costoInvoiceLabel;

  /// No description provided for @costoObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales sobre este gasto'**
  String get costoObservationsHint;

  /// No description provided for @costoCardType.
  ///
  /// In es, this message translates to:
  /// **'Tipo: '**
  String get costoCardType;

  /// No description provided for @costoCardConcept.
  ///
  /// In es, this message translates to:
  /// **'Concepto: '**
  String get costoCardConcept;

  /// No description provided for @costoCardSupplier.
  ///
  /// In es, this message translates to:
  /// **'Proveedor: '**
  String get costoCardSupplier;

  /// No description provided for @costoTypeAlimento.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get costoTypeAlimento;

  /// No description provided for @costoTypeManoDeObra.
  ///
  /// In es, this message translates to:
  /// **'Mano de Obra'**
  String get costoTypeManoDeObra;

  /// No description provided for @costoTypeEnergia.
  ///
  /// In es, this message translates to:
  /// **'Energía'**
  String get costoTypeEnergia;

  /// No description provided for @costoTypeMedicamento.
  ///
  /// In es, this message translates to:
  /// **'Medicamento'**
  String get costoTypeMedicamento;

  /// No description provided for @costoTypeMantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get costoTypeMantenimiento;

  /// No description provided for @costoTypeAgua.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get costoTypeAgua;

  /// No description provided for @costoTypeTransporte.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get costoTypeTransporte;

  /// No description provided for @costoTypeAdministrativo.
  ///
  /// In es, this message translates to:
  /// **'Administrativo'**
  String get costoTypeAdministrativo;

  /// No description provided for @costoTypeDepreciacion.
  ///
  /// In es, this message translates to:
  /// **'Depreciación'**
  String get costoTypeDepreciacion;

  /// No description provided for @costoTypeFinanciero.
  ///
  /// In es, this message translates to:
  /// **'Financiero'**
  String get costoTypeFinanciero;

  /// No description provided for @costoTypeOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get costoTypeOtros;

  /// No description provided for @costoSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Costos'**
  String get costoSummaryTitle;

  /// No description provided for @costoSummaryTotal.
  ///
  /// In es, this message translates to:
  /// **'Total en costos'**
  String get costoSummaryTotal;

  /// No description provided for @costoSummaryApproved.
  ///
  /// In es, this message translates to:
  /// **'Aprobados'**
  String get costoSummaryApproved;

  /// No description provided for @costoSummaryPending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get costoSummaryPending;

  /// No description provided for @costoLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar costos'**
  String get costoLoadError;

  /// No description provided for @inventarioTitle.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventarioTitle;

  /// No description provided for @invFilterByType.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por tipo'**
  String get invFilterByType;

  /// No description provided for @invSearchByNameOrCode.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o código...'**
  String get invSearchByNameOrCode;

  /// No description provided for @invTabItems.
  ///
  /// In es, this message translates to:
  /// **'Items'**
  String get invTabItems;

  /// No description provided for @invTabMovements.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get invTabMovements;

  /// No description provided for @invNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'Sin granja seleccionada'**
  String get invNoFarmSelected;

  /// No description provided for @invSelectFarmFromHome.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja desde el inicio'**
  String get invSelectFarmFromHome;

  /// No description provided for @invAddNewItemTooltip.
  ///
  /// In es, this message translates to:
  /// **'Agregar nuevo ítem al inventario'**
  String get invAddNewItemTooltip;

  /// No description provided for @invNewItem.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Item'**
  String get invNewItem;

  /// No description provided for @invNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get invNoResults;

  /// No description provided for @invNoMovements.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos'**
  String get invNoMovements;

  /// No description provided for @invNoMovementsMatchSearch.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos que coincidan con tu búsqueda'**
  String get invNoMovementsMatchSearch;

  /// No description provided for @invNoMovementsYet.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos registrados aún'**
  String get invNoMovementsYet;

  /// No description provided for @invErrorLoadingMovements.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar los movimientos'**
  String get invErrorLoadingMovements;

  /// No description provided for @invNoItemsInInventory.
  ///
  /// In es, this message translates to:
  /// **'Sin items en inventario'**
  String get invNoItemsInInventory;

  /// No description provided for @invNoItemsMatchFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay items que coincidan con los filtros'**
  String get invNoItemsMatchFilters;

  /// No description provided for @invAddYourFirstItem.
  ///
  /// In es, this message translates to:
  /// **'Agrega tu primer item de inventario'**
  String get invAddYourFirstItem;

  /// No description provided for @invClearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get invClearFilters;

  /// No description provided for @invAddItem.
  ///
  /// In es, this message translates to:
  /// **'Agregar Item'**
  String get invAddItem;

  /// No description provided for @invItemDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Item eliminado correctamente'**
  String get invItemDeletedSuccess;

  /// No description provided for @invApplyFilter.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtro'**
  String get invApplyFilter;

  /// No description provided for @invItemDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle del Item'**
  String get invItemDetail;

  /// No description provided for @invRegisterEntry.
  ///
  /// In es, this message translates to:
  /// **'Registrar Entrada'**
  String get invRegisterEntry;

  /// No description provided for @invRegisterExit.
  ///
  /// In es, this message translates to:
  /// **'Registrar Salida'**
  String get invRegisterExit;

  /// No description provided for @invAdjustStock.
  ///
  /// In es, this message translates to:
  /// **'Ajustar Stock'**
  String get invAdjustStock;

  /// No description provided for @invItemNotFound.
  ///
  /// In es, this message translates to:
  /// **'Item no encontrado'**
  String get invItemNotFound;

  /// No description provided for @invErrorLoadingItem.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el item de inventario'**
  String get invErrorLoadingItem;

  /// No description provided for @invStockDepleted.
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get invStockDepleted;

  /// No description provided for @invStockLow.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get invStockLow;

  /// No description provided for @invStockAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get invStockAvailable;

  /// No description provided for @invStockCurrent.
  ///
  /// In es, this message translates to:
  /// **'Stock Actual'**
  String get invStockCurrent;

  /// No description provided for @invStockMinimum.
  ///
  /// In es, this message translates to:
  /// **'Stock Mínimo'**
  String get invStockMinimum;

  /// No description provided for @invTotalValue.
  ///
  /// In es, this message translates to:
  /// **'Valor Total'**
  String get invTotalValue;

  /// No description provided for @invInformation.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get invInformation;

  /// No description provided for @invCode.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get invCode;

  /// No description provided for @invDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get invDescription;

  /// No description provided for @invUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get invUnit;

  /// No description provided for @invUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio Unitario'**
  String get invUnitPrice;

  /// No description provided for @invExpiration.
  ///
  /// In es, this message translates to:
  /// **'Vencimiento'**
  String get invExpiration;

  /// No description provided for @invSupplierBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote Proveedor'**
  String get invSupplierBatch;

  /// No description provided for @invWarehouse.
  ///
  /// In es, this message translates to:
  /// **'Almacén'**
  String get invWarehouse;

  /// No description provided for @invAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get invAlerts;

  /// No description provided for @invAlertStockDepleted.
  ///
  /// In es, this message translates to:
  /// **'Stock agotado'**
  String get invAlertStockDepleted;

  /// No description provided for @invAlertProductExpired.
  ///
  /// In es, this message translates to:
  /// **'Producto vencido'**
  String get invAlertProductExpired;

  /// No description provided for @invLastMovements.
  ///
  /// In es, this message translates to:
  /// **'Últimos Movimientos'**
  String get invLastMovements;

  /// No description provided for @invViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get invViewAll;

  /// No description provided for @invNoMovementsRegistered.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos registrados'**
  String get invNoMovementsRegistered;

  /// No description provided for @invCouldNotLoadMovements.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los movimientos'**
  String get invCouldNotLoadMovements;

  /// No description provided for @invItemDeleted.
  ///
  /// In es, this message translates to:
  /// **'Item eliminado'**
  String get invItemDeleted;

  /// No description provided for @invStepType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get invStepType;

  /// No description provided for @invStepBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get invStepBasic;

  /// No description provided for @invStepStock.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get invStepStock;

  /// No description provided for @invStepDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get invStepDetails;

  /// No description provided for @invDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get invDraftFound;

  /// No description provided for @invEditItem.
  ///
  /// In es, this message translates to:
  /// **'Editar Item'**
  String get invEditItem;

  /// No description provided for @invNewItemTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Item'**
  String get invNewItemTitle;

  /// No description provided for @invCreateItem.
  ///
  /// In es, this message translates to:
  /// **'Crear Item'**
  String get invCreateItem;

  /// No description provided for @invImageTooLarge.
  ///
  /// In es, this message translates to:
  /// **'La imagen excede 5MB. Elige una más pequeña'**
  String get invImageTooLarge;

  /// No description provided for @invImageSelected.
  ///
  /// In es, this message translates to:
  /// **'Imagen seleccionada'**
  String get invImageSelected;

  /// No description provided for @invErrorSelectingImage.
  ///
  /// In es, this message translates to:
  /// **'Error al seleccionar imagen'**
  String get invErrorSelectingImage;

  /// No description provided for @invCouldNotUploadImage.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir la imagen'**
  String get invCouldNotUploadImage;

  /// No description provided for @invItemSavedWithoutImage.
  ///
  /// In es, this message translates to:
  /// **'El item se guardará sin imagen'**
  String get invItemSavedWithoutImage;

  /// No description provided for @invItemUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Item actualizado correctamente'**
  String get invItemUpdatedSuccess;

  /// No description provided for @invDraftAutoSaveMessage.
  ///
  /// In es, this message translates to:
  /// **'No te preocupes, tus datos están seguros. Tu progreso se guarda automáticamente.'**
  String get invDraftAutoSaveMessage;

  /// No description provided for @invMovementsTitle.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get invMovementsTitle;

  /// No description provided for @invMovementsOfItem.
  ///
  /// In es, this message translates to:
  /// **'Movimientos: {item}'**
  String invMovementsOfItem(String item);

  /// No description provided for @invFilter.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get invFilter;

  /// No description provided for @invErrorLoadingMovementsPage.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar movimientos'**
  String get invErrorLoadingMovementsPage;

  /// No description provided for @invNoMovementsWithFilters.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos con estos filtros'**
  String get invNoMovementsWithFilters;

  /// No description provided for @invNoMovementsRegisteredHist.
  ///
  /// In es, this message translates to:
  /// **'No hay movimientos registrados'**
  String get invNoMovementsRegisteredHist;

  /// No description provided for @invClearFiltersHist.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get invClearFiltersHist;

  /// No description provided for @invToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get invToday;

  /// No description provided for @invYesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get invYesterday;

  /// No description provided for @invFilterMovements.
  ///
  /// In es, this message translates to:
  /// **'Filtrar movimientos'**
  String get invFilterMovements;

  /// No description provided for @invMovementType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de movimiento'**
  String get invMovementType;

  /// No description provided for @invAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get invAll;

  /// No description provided for @invDateRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de fechas'**
  String get invDateRange;

  /// No description provided for @invFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get invFrom;

  /// No description provided for @invUntil.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get invUntil;

  /// No description provided for @invClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get invClear;

  /// No description provided for @invDialogRegisterEntry.
  ///
  /// In es, this message translates to:
  /// **'Registrar Entrada'**
  String get invDialogRegisterEntry;

  /// No description provided for @invDialogRegisterExit.
  ///
  /// In es, this message translates to:
  /// **'Registrar Salida'**
  String get invDialogRegisterExit;

  /// No description provided for @invDialogMovementType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de movimiento'**
  String get invDialogMovementType;

  /// No description provided for @invSelectType.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo'**
  String get invSelectType;

  /// No description provided for @invEnterQuantity.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad'**
  String get invEnterQuantity;

  /// No description provided for @invEnterValidNumberGt0.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido mayor a 0'**
  String get invEnterValidNumberGt0;

  /// No description provided for @invQuantityExceedsStock.
  ///
  /// In es, this message translates to:
  /// **'La cantidad excede el stock disponible'**
  String get invQuantityExceedsStock;

  /// No description provided for @invTotalCost.
  ///
  /// In es, this message translates to:
  /// **'Costo total'**
  String get invTotalCost;

  /// No description provided for @invSupplierName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor'**
  String get invSupplierName;

  /// No description provided for @invObservation.
  ///
  /// In es, this message translates to:
  /// **'Observación'**
  String get invObservation;

  /// No description provided for @invReasonOrObservation.
  ///
  /// In es, this message translates to:
  /// **'Motivo u observación'**
  String get invReasonOrObservation;

  /// No description provided for @invDialogAdjustStock.
  ///
  /// In es, this message translates to:
  /// **'Ajustar Stock'**
  String get invDialogAdjustStock;

  /// No description provided for @invEnterNewStock.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nuevo stock'**
  String get invEnterNewStock;

  /// No description provided for @invEnterValidNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido'**
  String get invEnterValidNumber;

  /// No description provided for @invAdjustmentReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo del ajuste'**
  String get invAdjustmentReason;

  /// No description provided for @invReasonRequired.
  ///
  /// In es, this message translates to:
  /// **'El motivo es requerido'**
  String get invReasonRequired;

  /// No description provided for @invAdjust.
  ///
  /// In es, this message translates to:
  /// **'Ajustar'**
  String get invAdjust;

  /// No description provided for @invStockAdjustedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Stock ajustado correctamente'**
  String get invStockAdjustedSuccess;

  /// No description provided for @invEntryRegistered.
  ///
  /// In es, this message translates to:
  /// **'Entrada registrada correctamente'**
  String get invEntryRegistered;

  /// No description provided for @invExitRegistered.
  ///
  /// In es, this message translates to:
  /// **'Salida registrada correctamente'**
  String get invExitRegistered;

  /// No description provided for @invDeleteItem.
  ///
  /// In es, this message translates to:
  /// **'Eliminar item'**
  String get invDeleteItem;

  /// No description provided for @invConfirmDeleteItemName.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de eliminar {name}?'**
  String invConfirmDeleteItemName(String name);

  /// No description provided for @invActionIrreversible.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible'**
  String get invActionIrreversible;

  /// No description provided for @invDeleteWarningDetails.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán todos los movimientos y datos asociados'**
  String get invDeleteWarningDetails;

  /// No description provided for @invTypeNameToConfirm.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre del item para confirmar'**
  String get invTypeNameToConfirm;

  /// No description provided for @invTypeHere.
  ///
  /// In es, this message translates to:
  /// **'Escribe aquí...'**
  String get invTypeHere;

  /// No description provided for @invCardDepleted.
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get invCardDepleted;

  /// No description provided for @invCardLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get invCardLowStock;

  /// No description provided for @invCardAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get invCardAvailable;

  /// No description provided for @invCardProductExpired.
  ///
  /// In es, this message translates to:
  /// **'Producto vencido'**
  String get invCardProductExpired;

  /// No description provided for @invViewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver Detalles'**
  String get invViewDetails;

  /// No description provided for @invMoreOptionsItem.
  ///
  /// In es, this message translates to:
  /// **'Más opciones del item'**
  String get invMoreOptionsItem;

  /// No description provided for @invCardDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles'**
  String get invCardDetails;

  /// No description provided for @invCardStock.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get invCardStock;

  /// No description provided for @invCardMinimum.
  ///
  /// In es, this message translates to:
  /// **'Mínimo'**
  String get invCardMinimum;

  /// No description provided for @invCardValue.
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get invCardValue;

  /// No description provided for @invSelectProduct.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar producto'**
  String get invSelectProduct;

  /// No description provided for @invSearchInventory.
  ///
  /// In es, this message translates to:
  /// **'Buscar en inventario...'**
  String get invSearchInventory;

  /// No description provided for @invSearchProduct.
  ///
  /// In es, this message translates to:
  /// **'Buscar producto...'**
  String get invSearchProduct;

  /// No description provided for @invNoProductsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get invNoProductsFound;

  /// No description provided for @invNoProductsAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay productos disponibles'**
  String get invNoProductsAvailable;

  /// No description provided for @invSelectorStockLow.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo'**
  String get invSelectorStockLow;

  /// No description provided for @invErrorLoadingInventory.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar inventario'**
  String get invErrorLoadingInventory;

  /// No description provided for @invStockTitle.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get invStockTitle;

  /// No description provided for @invConfigureQuantities.
  ///
  /// In es, this message translates to:
  /// **'Configura las cantidades y unidad de medida'**
  String get invConfigureQuantities;

  /// No description provided for @invUnitsFilteredAutomatically.
  ///
  /// In es, this message translates to:
  /// **'Las unidades se filtran automáticamente según el tipo de producto seleccionado.'**
  String get invUnitsFilteredAutomatically;

  /// No description provided for @invUnitOfMeasure.
  ///
  /// In es, this message translates to:
  /// **'Unidad de Medida *'**
  String get invUnitOfMeasure;

  /// No description provided for @invStockActual.
  ///
  /// In es, this message translates to:
  /// **'Stock Actual'**
  String get invStockActual;

  /// No description provided for @invEnterCurrentStock.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el stock actual'**
  String get invEnterCurrentStock;

  /// No description provided for @invEnterValidNumberStock.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido'**
  String get invEnterValidNumberStock;

  /// No description provided for @invStockMin.
  ///
  /// In es, this message translates to:
  /// **'Stock Mínimo'**
  String get invStockMin;

  /// No description provided for @invStockMax.
  ///
  /// In es, this message translates to:
  /// **'Stock Máximo'**
  String get invStockMax;

  /// No description provided for @invOptional.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get invOptional;

  /// No description provided for @invStockAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de stock'**
  String get invStockAlerts;

  /// No description provided for @invStockAlertMessage.
  ///
  /// In es, this message translates to:
  /// **'Recibirás una notificación cuando el stock esté por debajo del mínimo configurado.'**
  String get invStockAlertMessage;

  /// No description provided for @invBasicInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get invBasicInfo;

  /// No description provided for @invEnterMainData.
  ///
  /// In es, this message translates to:
  /// **'Ingresa los datos principales del item'**
  String get invEnterMainData;

  /// No description provided for @invItemName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Item'**
  String get invItemName;

  /// No description provided for @invEnterItemName.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del item'**
  String get invEnterItemName;

  /// No description provided for @invNameMinChars.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 2 caracteres'**
  String get invNameMinChars;

  /// No description provided for @invCodeSkuOptional.
  ///
  /// In es, this message translates to:
  /// **'Código/SKU (opcional)'**
  String get invCodeSkuOptional;

  /// No description provided for @invDescriptionOptional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get invDescriptionOptional;

  /// No description provided for @invDescribeProductCharacteristics.
  ///
  /// In es, this message translates to:
  /// **'Describe las características del producto...'**
  String get invDescribeProductCharacteristics;

  /// No description provided for @invSkuHelpsIdentify.
  ///
  /// In es, this message translates to:
  /// **'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.'**
  String get invSkuHelpsIdentify;

  /// No description provided for @invAdditionalDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles Adicionales'**
  String get invAdditionalDetails;

  /// No description provided for @invOptionalInfoBetterControl.
  ///
  /// In es, this message translates to:
  /// **'Información opcional para mejor control'**
  String get invOptionalInfoBetterControl;

  /// No description provided for @invUnitPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio Unitario'**
  String get invUnitPriceLabel;

  /// No description provided for @invSupplierLabel.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get invSupplierLabel;

  /// No description provided for @invSupplierNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor'**
  String get invSupplierNameHint;

  /// No description provided for @invWarehouseLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación en Almacén'**
  String get invWarehouseLocation;

  /// No description provided for @invExpirationTitle.
  ///
  /// In es, this message translates to:
  /// **'Vencimiento'**
  String get invExpirationTitle;

  /// No description provided for @invExpirationDateOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha de vencimiento (opcional)'**
  String get invExpirationDateOptional;

  /// No description provided for @invSelectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get invSelectDate;

  /// No description provided for @invSupplierBatchLabel.
  ///
  /// In es, this message translates to:
  /// **'Lote del Proveedor'**
  String get invSupplierBatchLabel;

  /// No description provided for @invBatchNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de lote'**
  String get invBatchNumber;

  /// No description provided for @invDetailsOptionalHelp.
  ///
  /// In es, this message translates to:
  /// **'Estos datos son opcionales pero ayudan a un mejor control y trazabilidad del inventario.'**
  String get invDetailsOptionalHelp;

  /// No description provided for @invWhatTypeOfItem.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de item es?'**
  String get invWhatTypeOfItem;

  /// No description provided for @invSelectItemCategory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la categoría del item de inventario'**
  String get invSelectItemCategory;

  /// No description provided for @invDescAlimento.
  ///
  /// In es, this message translates to:
  /// **'Concentrados, maíz, soya y otros alimentos para aves'**
  String get invDescAlimento;

  /// No description provided for @invDescMedicamento.
  ///
  /// In es, this message translates to:
  /// **'Antibióticos, antiparasitarios y tratamientos veterinarios'**
  String get invDescMedicamento;

  /// No description provided for @invDescVacuna.
  ///
  /// In es, this message translates to:
  /// **'Vacunas y productos de inmunización'**
  String get invDescVacuna;

  /// No description provided for @invDescEquipo.
  ///
  /// In es, this message translates to:
  /// **'Bebederos, comederos, equipos de calefacción y herramientas'**
  String get invDescEquipo;

  /// No description provided for @invDescInsumo.
  ///
  /// In es, this message translates to:
  /// **'Materiales de cama, desinfectantes y otros insumos'**
  String get invDescInsumo;

  /// No description provided for @invDescLimpieza.
  ///
  /// In es, this message translates to:
  /// **'Productos de limpieza y desinfección'**
  String get invDescLimpieza;

  /// No description provided for @invDescOtro.
  ///
  /// In es, this message translates to:
  /// **'Otros items que no encajan en las categorías anteriores'**
  String get invDescOtro;

  /// No description provided for @invProductImage.
  ///
  /// In es, this message translates to:
  /// **'Imagen del Producto'**
  String get invProductImage;

  /// No description provided for @invTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get invTakePhoto;

  /// No description provided for @invGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get invGallery;

  /// No description provided for @invImageSelectedLabel.
  ///
  /// In es, this message translates to:
  /// **'Imagen seleccionada'**
  String get invImageSelectedLabel;

  /// No description provided for @invReady.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get invReady;

  /// No description provided for @invNoImageAdded.
  ///
  /// In es, this message translates to:
  /// **'No hay imagen agregada'**
  String get invNoImageAdded;

  /// No description provided for @invCanAddProductPhoto.
  ///
  /// In es, this message translates to:
  /// **'Puedes agregar una foto del producto'**
  String get invCanAddProductPhoto;

  /// No description provided for @invStockBefore.
  ///
  /// In es, this message translates to:
  /// **'Stock anterior'**
  String get invStockBefore;

  /// No description provided for @invStockAfter.
  ///
  /// In es, this message translates to:
  /// **'Stock nuevo'**
  String get invStockAfter;

  /// No description provided for @invInventoryLabel.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get invInventoryLabel;

  /// No description provided for @invItemsRegistered.
  ///
  /// In es, this message translates to:
  /// **'items registrados'**
  String get invItemsRegistered;

  /// No description provided for @invViewAllItems.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get invViewAllItems;

  /// No description provided for @invTotalItems.
  ///
  /// In es, this message translates to:
  /// **'Total Items'**
  String get invTotalItems;

  /// No description provided for @invLowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock Bajo'**
  String get invLowStock;

  /// No description provided for @invDepletedItems.
  ///
  /// In es, this message translates to:
  /// **'Agotados'**
  String get invDepletedItems;

  /// No description provided for @invExpiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Por Vencer'**
  String get invExpiringSoon;

  /// No description provided for @saludFilterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get saludFilterAll;

  /// No description provided for @saludFilterInTreatment.
  ///
  /// In es, this message translates to:
  /// **'En tratamiento'**
  String get saludFilterInTreatment;

  /// No description provided for @saludFilterClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrados'**
  String get saludFilterClosed;

  /// No description provided for @saludRecordsTitle.
  ///
  /// In es, this message translates to:
  /// **'Registros de Salud'**
  String get saludRecordsTitle;

  /// No description provided for @saludFilterTooltip.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get saludFilterTooltip;

  /// No description provided for @saludEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de salud'**
  String get saludEmptyTitle;

  /// No description provided for @saludEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Registra tratamientos, diagnósticos y seguimiento sanitario del lote'**
  String get saludEmptyDescription;

  /// No description provided for @saludRegisterTreatment.
  ///
  /// In es, this message translates to:
  /// **'Registrar Tratamiento'**
  String get saludRegisterTreatment;

  /// No description provided for @saludNoRecordsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron registros'**
  String get saludNoRecordsFound;

  /// No description provided for @saludNoFilterResults.
  ///
  /// In es, this message translates to:
  /// **'No hay registros que coincidan con los filtros aplicados'**
  String get saludNoFilterResults;

  /// No description provided for @saludFilterByBatch.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por lote'**
  String get saludFilterByBatch;

  /// No description provided for @saludNewTreatment.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Tratamiento'**
  String get saludNewTreatment;

  /// No description provided for @saludNewTreatmentTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar nuevo tratamiento'**
  String get saludNewTreatmentTooltip;

  /// No description provided for @saludFilterRecords.
  ///
  /// In es, this message translates to:
  /// **'Filtrar registros'**
  String get saludFilterRecords;

  /// No description provided for @saludTreatmentStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado del tratamiento'**
  String get saludTreatmentStatus;

  /// No description provided for @saludDeleteRecordTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar registro?'**
  String get saludDeleteRecordTitle;

  /// No description provided for @saludRecordDeleted.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado correctamente'**
  String get saludRecordDeleted;

  /// No description provided for @saludCloseTreatmentTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Tratamiento'**
  String get saludCloseTreatmentTitle;

  /// No description provided for @saludDescribeResult.
  ///
  /// In es, this message translates to:
  /// **'Describe el resultado del tratamiento aplicado'**
  String get saludDescribeResult;

  /// No description provided for @saludResultRequired.
  ///
  /// In es, this message translates to:
  /// **'Resultado *'**
  String get saludResultRequired;

  /// No description provided for @saludResultHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Recuperación completa, sin síntomas'**
  String get saludResultHint;

  /// No description provided for @saludResultValidation.
  ///
  /// In es, this message translates to:
  /// **'El resultado es obligatorio'**
  String get saludResultValidation;

  /// No description provided for @saludResultMinLength.
  ///
  /// In es, this message translates to:
  /// **'Describe el resultado (mínimo 10 caracteres)'**
  String get saludResultMinLength;

  /// No description provided for @saludFinalObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones finales'**
  String get saludFinalObservations;

  /// No description provided for @saludAdditionalNotesOptional.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales (opcional)'**
  String get saludAdditionalNotesOptional;

  /// No description provided for @saludTreatmentClosedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento cerrado exitosamente'**
  String get saludTreatmentClosedSuccess;

  /// No description provided for @saludStatusInTreatment.
  ///
  /// In es, this message translates to:
  /// **'En tratamiento'**
  String get saludStatusInTreatment;

  /// No description provided for @saludStatusClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get saludStatusClosed;

  /// No description provided for @saludDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get saludDiagnosis;

  /// No description provided for @saludSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas'**
  String get saludSymptoms;

  /// No description provided for @saludTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get saludTreatment;

  /// No description provided for @saludMedications.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get saludMedications;

  /// No description provided for @saludDosage.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get saludDosage;

  /// No description provided for @saludDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración'**
  String get saludDuration;

  /// No description provided for @saludDays.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get saludDays;

  /// No description provided for @saludVeterinarian.
  ///
  /// In es, this message translates to:
  /// **'Veterinario'**
  String get saludVeterinarian;

  /// No description provided for @saludResult.
  ///
  /// In es, this message translates to:
  /// **'Resultado'**
  String get saludResult;

  /// No description provided for @saludCloseDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de cierre'**
  String get saludCloseDate;

  /// No description provided for @saludTreatmentDays.
  ///
  /// In es, this message translates to:
  /// **'Días de tratamiento'**
  String get saludTreatmentDays;

  /// No description provided for @saludAllBatches.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get saludAllBatches;

  /// No description provided for @saludDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Registro'**
  String get saludDetailTitle;

  /// No description provided for @saludRecordNotFound.
  ///
  /// In es, this message translates to:
  /// **'Registro no encontrado'**
  String get saludRecordNotFound;

  /// No description provided for @saludLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el registro de salud'**
  String get saludLoadError;

  /// No description provided for @saludDetailStatusClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get saludDetailStatusClosed;

  /// No description provided for @saludDetailStatusInTreatment.
  ///
  /// In es, this message translates to:
  /// **'En tratamiento'**
  String get saludDetailStatusInTreatment;

  /// No description provided for @saludDetailDiagnosisSection.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get saludDetailDiagnosisSection;

  /// No description provided for @saludDetailDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get saludDetailDateLabel;

  /// No description provided for @saludDetailTreatmentSection.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get saludDetailTreatmentSection;

  /// No description provided for @saludDetailUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get saludDetailUser;

  /// No description provided for @saludDetailCloseTreatment.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Tratamiento'**
  String get saludDetailCloseTreatment;

  /// No description provided for @saludDetailCloseDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Cierre'**
  String get saludDetailCloseDate;

  /// No description provided for @saludDetailResultOptional.
  ///
  /// In es, this message translates to:
  /// **'Resultado (Opcional)'**
  String get saludDetailResultOptional;

  /// No description provided for @saludDetailDescribeResult.
  ///
  /// In es, this message translates to:
  /// **'Describe el resultado del tratamiento'**
  String get saludDetailDescribeResult;

  /// No description provided for @saludDetailDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar registro?'**
  String get saludDetailDeleteTitle;

  /// No description provided for @saludDetailRecordDeleted.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get saludDetailRecordDeleted;

  /// No description provided for @saludDetailTreatmentClosed.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento cerrado'**
  String get saludDetailTreatmentClosed;

  /// No description provided for @saludDetailCloseError.
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar tratamiento'**
  String get saludDetailCloseError;

  /// No description provided for @saludDetailDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar registro'**
  String get saludDetailDeleteError;

  /// No description provided for @vacFilterApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicadas'**
  String get vacFilterApplied;

  /// No description provided for @vacFilterPending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get vacFilterPending;

  /// No description provided for @vacFilterExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencidas'**
  String get vacFilterExpired;

  /// No description provided for @vacFilterUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próximas'**
  String get vacFilterUpcoming;

  /// No description provided for @vacTitle.
  ///
  /// In es, this message translates to:
  /// **'Vacunaciones'**
  String get vacTitle;

  /// No description provided for @vacFilterTooltip.
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get vacFilterTooltip;

  /// No description provided for @vacEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No hay vacunaciones programadas'**
  String get vacEmptyTitle;

  /// No description provided for @vacEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Programa las vacunas para mantener la salud del lote'**
  String get vacEmptyDescription;

  /// No description provided for @vacScheduleVaccination.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get vacScheduleVaccination;

  /// No description provided for @vacNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get vacNoResults;

  /// No description provided for @vacNoFilterResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron vacunaciones con los filtros aplicados'**
  String get vacNoFilterResults;

  /// No description provided for @vacSchedule.
  ///
  /// In es, this message translates to:
  /// **'Programar'**
  String get vacSchedule;

  /// No description provided for @vacScheduleTooltip.
  ///
  /// In es, this message translates to:
  /// **'Programar nueva vacunación'**
  String get vacScheduleTooltip;

  /// No description provided for @vacNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'No hay granja seleccionada'**
  String get vacNoFarmSelected;

  /// No description provided for @vacNoFarmDescription.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja desde el menú principal para ver las vacunaciones programadas.'**
  String get vacNoFarmDescription;

  /// No description provided for @vacGoHome.
  ///
  /// In es, this message translates to:
  /// **'Ir al inicio'**
  String get vacGoHome;

  /// No description provided for @vacFilterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar vacunaciones'**
  String get vacFilterTitle;

  /// No description provided for @vacVaccinationStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de vacunación'**
  String get vacVaccinationStatus;

  /// No description provided for @vacAllStatuses.
  ///
  /// In es, this message translates to:
  /// **'Todos los estados'**
  String get vacAllStatuses;

  /// No description provided for @vacDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar vacunación?'**
  String get vacDeleteTitle;

  /// No description provided for @vacDeleted.
  ///
  /// In es, this message translates to:
  /// **'Vacunación eliminada correctamente'**
  String get vacDeleted;

  /// No description provided for @vacMarkAppliedTitle.
  ///
  /// In es, this message translates to:
  /// **'Marcar como Aplicada'**
  String get vacMarkAppliedTitle;

  /// No description provided for @vacApplicationDetails.
  ///
  /// In es, this message translates to:
  /// **'Registra los detalles de la aplicación'**
  String get vacApplicationDetails;

  /// No description provided for @vacAgeWeeksRequired.
  ///
  /// In es, this message translates to:
  /// **'Edad (semanas) *'**
  String get vacAgeWeeksRequired;

  /// No description provided for @vacAgeRequired.
  ///
  /// In es, this message translates to:
  /// **'La edad es obligatoria'**
  String get vacAgeRequired;

  /// No description provided for @vacAgeInvalid.
  ///
  /// In es, this message translates to:
  /// **'La edad debe ser un número mayor a 0'**
  String get vacAgeInvalid;

  /// No description provided for @vacDosisRequired.
  ///
  /// In es, this message translates to:
  /// **'Dosis *'**
  String get vacDosisRequired;

  /// No description provided for @vacDosisValidation.
  ///
  /// In es, this message translates to:
  /// **'La dosis es obligatoria'**
  String get vacDosisValidation;

  /// No description provided for @vacRouteRequired.
  ///
  /// In es, this message translates to:
  /// **'Vía de aplicación *'**
  String get vacRouteRequired;

  /// No description provided for @vacRouteValidation.
  ///
  /// In es, this message translates to:
  /// **'La vía es obligatoria'**
  String get vacRouteValidation;

  /// No description provided for @vacMarkedApplied.
  ///
  /// In es, this message translates to:
  /// **'Vacuna marcada como aplicada'**
  String get vacMarkedApplied;

  /// No description provided for @vacSheetApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicada'**
  String get vacSheetApplied;

  /// No description provided for @vacSheetExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get vacSheetExpired;

  /// No description provided for @vacSheetUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próxima'**
  String get vacSheetUpcoming;

  /// No description provided for @vacSheetPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get vacSheetPending;

  /// No description provided for @vacVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get vacVaccine;

  /// No description provided for @vacScheduledDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha programada'**
  String get vacScheduledDate;

  /// No description provided for @vacApplicationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha aplicación'**
  String get vacApplicationDate;

  /// No description provided for @vacAgeApplication.
  ///
  /// In es, this message translates to:
  /// **'Edad aplicación'**
  String get vacAgeApplication;

  /// No description provided for @vacWeeks.
  ///
  /// In es, this message translates to:
  /// **'semanas'**
  String get vacWeeks;

  /// No description provided for @vacDosis.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get vacDosis;

  /// No description provided for @vacRoute.
  ///
  /// In es, this message translates to:
  /// **'Vía'**
  String get vacRoute;

  /// No description provided for @vacLaboratory.
  ///
  /// In es, this message translates to:
  /// **'Laboratorio'**
  String get vacLaboratory;

  /// No description provided for @vacVaccineBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote vacuna'**
  String get vacVaccineBatch;

  /// No description provided for @vacResponsible.
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get vacResponsible;

  /// No description provided for @vacNextApplication.
  ///
  /// In es, this message translates to:
  /// **'Próxima aplicación'**
  String get vacNextApplication;

  /// No description provided for @vacScheduledBy.
  ///
  /// In es, this message translates to:
  /// **'Programado por'**
  String get vacScheduledBy;

  /// No description provided for @vacMarkAppliedButton.
  ///
  /// In es, this message translates to:
  /// **'Marcar Aplicada'**
  String get vacMarkAppliedButton;

  /// No description provided for @vacDeleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get vacDeleteButton;

  /// No description provided for @vacDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Vacunación'**
  String get vacDetailTitle;

  /// No description provided for @vacDetailNotFound.
  ///
  /// In es, this message translates to:
  /// **'Vacunación no encontrada'**
  String get vacDetailNotFound;

  /// No description provided for @vacDetailLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la vacunación'**
  String get vacDetailLoadError;

  /// No description provided for @vacDetailStatusApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicada'**
  String get vacDetailStatusApplied;

  /// No description provided for @vacDetailStatusExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get vacDetailStatusExpired;

  /// No description provided for @vacDetailStatusUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próxima'**
  String get vacDetailStatusUpcoming;

  /// No description provided for @vacDetailStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get vacDetailStatusPending;

  /// No description provided for @vacDetailVaccineInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de la Vacuna'**
  String get vacDetailVaccineInfo;

  /// No description provided for @vacDetailScheduledDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha Programada'**
  String get vacDetailScheduledDate;

  /// No description provided for @vacDetailAgeApplication.
  ///
  /// In es, this message translates to:
  /// **'Edad Aplicación'**
  String get vacDetailAgeApplication;

  /// No description provided for @vacDetailVaccineBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote Vacuna'**
  String get vacDetailVaccineBatch;

  /// No description provided for @vacDetailNextApplication.
  ///
  /// In es, this message translates to:
  /// **'Próxima Aplicación'**
  String get vacDetailNextApplication;

  /// No description provided for @vacDetailMarkAppliedButton.
  ///
  /// In es, this message translates to:
  /// **'Marcar como Aplicada'**
  String get vacDetailMarkAppliedButton;

  /// No description provided for @vacDetailSelectDate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de aplicación'**
  String get vacDetailSelectDate;

  /// No description provided for @vacDetailMarkedApplied.
  ///
  /// In es, this message translates to:
  /// **'Vacunación marcada como aplicada'**
  String get vacDetailMarkedApplied;

  /// No description provided for @vacDetailMarkError.
  ///
  /// In es, this message translates to:
  /// **'Error al marcar vacunación'**
  String get vacDetailMarkError;

  /// No description provided for @vacDetailDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar vacunación?'**
  String get vacDetailDeleteTitle;

  /// No description provided for @vacDetailDeleted.
  ///
  /// In es, this message translates to:
  /// **'Vacunación eliminada'**
  String get vacDetailDeleted;

  /// No description provided for @vacDetailDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar vacunación'**
  String get vacDetailDeleteError;

  /// No description provided for @vacDetailMenuMarkApplied.
  ///
  /// In es, this message translates to:
  /// **'Marcar Aplicada'**
  String get vacDetailMenuMarkApplied;

  /// No description provided for @vacDetailMenuDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get vacDetailMenuDelete;

  /// No description provided for @treatFormStepLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get treatFormStepLocation;

  /// No description provided for @treatFormStepLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona granja y lote'**
  String get treatFormStepLocationDesc;

  /// No description provided for @treatFormStepDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get treatFormStepDiagnosis;

  /// No description provided for @treatFormStepDiagnosisDesc.
  ///
  /// In es, this message translates to:
  /// **'Información del diagnóstico y síntomas'**
  String get treatFormStepDiagnosisDesc;

  /// No description provided for @treatFormStepTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get treatFormStepTreatment;

  /// No description provided for @treatFormStepTreatmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Detalles del tratamiento y medicamentos'**
  String get treatFormStepTreatmentDesc;

  /// No description provided for @treatFormStepInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get treatFormStepInfo;

  /// No description provided for @treatFormStepInfoDesc.
  ///
  /// In es, this message translates to:
  /// **'Veterinario y observaciones adicionales'**
  String get treatFormStepInfoDesc;

  /// No description provided for @treatDraftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador del tratamiento guardado anteriormente?'**
  String get treatDraftFoundMessage;

  /// No description provided for @treatSavedMomentAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace un momento'**
  String get treatSavedMomentAgo;

  /// No description provided for @treatExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get treatExit;

  /// No description provided for @treatNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Tratamiento'**
  String get treatNewTitle;

  /// No description provided for @treatSelectFarmBatch.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja y un lote'**
  String get treatSelectFarmBatch;

  /// No description provided for @treatDurationRange.
  ///
  /// In es, this message translates to:
  /// **'La duración debe ser entre 1 y 365 días'**
  String get treatDurationRange;

  /// No description provided for @treatFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser futura'**
  String get treatFutureDate;

  /// No description provided for @treatCompleteRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor completa los campos obligatorios'**
  String get treatCompleteRequired;

  /// No description provided for @treatRegisteredSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento registrado exitosamente'**
  String get treatRegisteredSuccess;

  /// No description provided for @treatRegisteredInventoryError.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento registrado, pero hubo un error al actualizar inventario'**
  String get treatRegisteredInventoryError;

  /// No description provided for @treatRegisterError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar tratamiento'**
  String get treatRegisterError;

  /// No description provided for @vacFormStepVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get vacFormStepVaccine;

  /// No description provided for @vacFormStepApplication.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get vacFormStepApplication;

  /// No description provided for @vacFormTitle.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get vacFormTitle;

  /// No description provided for @vacFormSubmit.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get vacFormSubmit;

  /// No description provided for @vacFormDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get vacFormDraftFound;

  /// No description provided for @vacFormSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar un lote'**
  String get vacFormSelectBatch;

  /// No description provided for @vacFormSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Vacunación programada exitosamente!'**
  String get vacFormSuccess;

  /// No description provided for @vacFormInventoryError.
  ///
  /// In es, this message translates to:
  /// **'Vacunación registrada, pero hubo un error al descontar inventario'**
  String get vacFormInventoryError;

  /// No description provided for @vacFormError.
  ///
  /// In es, this message translates to:
  /// **'Error al programar vacunación'**
  String get vacFormError;

  /// No description provided for @vacFormScheduleError.
  ///
  /// In es, this message translates to:
  /// **'Error al programar'**
  String get vacFormScheduleError;

  /// No description provided for @diseaseCatalogTitle.
  ///
  /// In es, this message translates to:
  /// **'Catálogo de Enfermedades'**
  String get diseaseCatalogTitle;

  /// No description provided for @diseaseCatalogSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar enfermedad, síntoma...'**
  String get diseaseCatalogSearchHint;

  /// No description provided for @diseaseCatalogAll.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get diseaseCatalogAll;

  /// No description provided for @diseaseCatalogCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get diseaseCatalogCritical;

  /// No description provided for @diseaseCatalogSevere.
  ///
  /// In es, this message translates to:
  /// **'Grave'**
  String get diseaseCatalogSevere;

  /// No description provided for @diseaseCatalogModerate.
  ///
  /// In es, this message translates to:
  /// **'Moderada'**
  String get diseaseCatalogModerate;

  /// No description provided for @diseaseCatalogMild.
  ///
  /// In es, this message translates to:
  /// **'Leve'**
  String get diseaseCatalogMild;

  /// No description provided for @diseaseCatalogMandatoryNotification.
  ///
  /// In es, this message translates to:
  /// **'Notificación obligatoria'**
  String get diseaseCatalogMandatoryNotification;

  /// No description provided for @diseaseCatalogVaccinable.
  ///
  /// In es, this message translates to:
  /// **'Vacunable'**
  String get diseaseCatalogVaccinable;

  /// No description provided for @diseaseCatalogCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get diseaseCatalogCategory;

  /// No description provided for @diseaseCatalogSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas'**
  String get diseaseCatalogSymptoms;

  /// No description provided for @diseaseCatalogSeverity.
  ///
  /// In es, this message translates to:
  /// **'Gravedad'**
  String get diseaseCatalogSeverity;

  /// No description provided for @diseaseCatalogViewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver Detalles'**
  String get diseaseCatalogViewDetails;

  /// No description provided for @diseaseCatalogNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron enfermedades'**
  String get diseaseCatalogNoResults;

  /// No description provided for @diseaseCatalogEmpty.
  ///
  /// In es, this message translates to:
  /// **'Catálogo vacío'**
  String get diseaseCatalogEmpty;

  /// No description provided for @diseaseCatalogTryOther.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otros términos de búsqueda o filtros'**
  String get diseaseCatalogTryOther;

  /// No description provided for @diseaseCatalogNoneRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay enfermedades registradas'**
  String get diseaseCatalogNoneRegistered;

  /// No description provided for @diseaseCatalogClearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get diseaseCatalogClearFilters;

  /// No description provided for @bioOverviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Bioseguridad'**
  String get bioOverviewTitle;

  /// No description provided for @bioNewInspection.
  ///
  /// In es, this message translates to:
  /// **'Nueva Inspección'**
  String get bioNewInspection;

  /// No description provided for @bioNewInspectionTooltip.
  ///
  /// In es, this message translates to:
  /// **'Crear nueva inspección'**
  String get bioNewInspectionTooltip;

  /// No description provided for @bioEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay inspecciones registradas'**
  String get bioEmptyTitle;

  /// No description provided for @bioMetricInspections.
  ///
  /// In es, this message translates to:
  /// **'Inspecciones'**
  String get bioMetricInspections;

  /// No description provided for @bioMetricAverage.
  ///
  /// In es, this message translates to:
  /// **'Promedio'**
  String get bioMetricAverage;

  /// No description provided for @bioMetricCritical.
  ///
  /// In es, this message translates to:
  /// **'Críticas'**
  String get bioMetricCritical;

  /// No description provided for @bioMetricLastLevel.
  ///
  /// In es, this message translates to:
  /// **'Último nivel'**
  String get bioMetricLastLevel;

  /// No description provided for @bioRecentHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial reciente'**
  String get bioRecentHistory;

  /// No description provided for @bioGeneralInspection.
  ///
  /// In es, this message translates to:
  /// **'Inspección general'**
  String get bioGeneralInspection;

  /// No description provided for @bioShedInspection.
  ///
  /// In es, this message translates to:
  /// **'Inspección por galpón'**
  String get bioShedInspection;

  /// No description provided for @bioScore.
  ///
  /// In es, this message translates to:
  /// **'Puntaje'**
  String get bioScore;

  /// No description provided for @bioNonCompliant.
  ///
  /// In es, this message translates to:
  /// **'No cumple'**
  String get bioNonCompliant;

  /// No description provided for @bioPending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get bioPending;

  /// No description provided for @bioLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar bioseguridad'**
  String get bioLoadError;

  /// No description provided for @bioNoInspectionYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay una inspección completada.'**
  String get bioNoInspectionYet;

  /// No description provided for @bioLastInspection.
  ///
  /// In es, this message translates to:
  /// **'Última inspección:'**
  String get bioLastInspection;

  /// No description provided for @bioInspectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Inspección de Bioseguridad'**
  String get bioInspectionTitle;

  /// No description provided for @bioInspectionNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva Inspección'**
  String get bioInspectionNewTitle;

  /// No description provided for @bioInspectionStepLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get bioInspectionStepLocation;

  /// No description provided for @bioInspectionStepChecklist.
  ///
  /// In es, this message translates to:
  /// **'Checklist'**
  String get bioInspectionStepChecklist;

  /// No description provided for @bioInspectionStepSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get bioInspectionStepSummary;

  /// No description provided for @bioInspectionSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar Inspección'**
  String get bioInspectionSave;

  /// No description provided for @bioInspectionLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos'**
  String get bioInspectionLoadError;

  /// No description provided for @bioInspectionExitTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get bioInspectionExitTitle;

  /// No description provided for @bioInspectionExitMessage.
  ///
  /// In es, this message translates to:
  /// **'Tienes una inspección en progreso. Si sales ahora, perderás los cambios.'**
  String get bioInspectionExitMessage;

  /// No description provided for @bioInspectionSaveMessage.
  ///
  /// In es, this message translates to:
  /// **'Se guardará la inspección y se generará el reporte correspondiente.'**
  String get bioInspectionSaveMessage;

  /// No description provided for @bioInspectionSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Inspección guardada exitosamente'**
  String get bioInspectionSaveSuccess;

  /// No description provided for @bioInspectionLoadingFarm.
  ///
  /// In es, this message translates to:
  /// **'Cargando granja…'**
  String get bioInspectionLoadingFarm;

  /// No description provided for @bioInspectionMinProgress.
  ///
  /// In es, this message translates to:
  /// **'Evalúa al menos el 50% de los items para continuar'**
  String get bioInspectionMinProgress;

  /// No description provided for @saludSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Salud'**
  String get saludSummaryTitle;

  /// No description provided for @saludAllUnderControl.
  ///
  /// In es, this message translates to:
  /// **'Todo bajo control'**
  String get saludAllUnderControl;

  /// No description provided for @saludHealthStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado sanitario'**
  String get saludHealthStatus;

  /// No description provided for @saludActive.
  ///
  /// In es, this message translates to:
  /// **'Activos'**
  String get saludActive;

  /// No description provided for @saludClosedCount.
  ///
  /// In es, this message translates to:
  /// **'Cerrados'**
  String get saludClosedCount;

  /// No description provided for @saludCardActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get saludCardActive;

  /// No description provided for @saludCardClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get saludCardClosed;

  /// No description provided for @saludCardDiagnosisPrefix.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico: '**
  String get saludCardDiagnosisPrefix;

  /// No description provided for @saludCardTreatmentPrefix.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento: '**
  String get saludCardTreatmentPrefix;

  /// No description provided for @saludErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar registros'**
  String get saludErrorTitle;

  /// No description provided for @vacSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Vacunación'**
  String get vacSummaryTitle;

  /// No description provided for @vacSummaryExpiredWarning.
  ///
  /// In es, this message translates to:
  /// **'¡Atención! Hay vacunas vencidas'**
  String get vacSummaryExpiredWarning;

  /// No description provided for @vacSummaryUpcomingWarning.
  ///
  /// In es, this message translates to:
  /// **'Hay vacunas próximas a aplicar'**
  String get vacSummaryUpcomingWarning;

  /// No description provided for @vacSummaryUpToDate.
  ///
  /// In es, this message translates to:
  /// **'Vacunaciones al día'**
  String get vacSummaryUpToDate;

  /// No description provided for @vacSummaryAllApplied.
  ///
  /// In es, this message translates to:
  /// **'Todas las vacunas aplicadas'**
  String get vacSummaryAllApplied;

  /// No description provided for @vacSummaryApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicadas'**
  String get vacSummaryApplied;

  /// No description provided for @vacCardStatusApplied.
  ///
  /// In es, this message translates to:
  /// **'Aplicada'**
  String get vacCardStatusApplied;

  /// No description provided for @vacCardStatusExpired.
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get vacCardStatusExpired;

  /// No description provided for @vacCardStatusUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próxima'**
  String get vacCardStatusUpcoming;

  /// No description provided for @vacCardStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get vacCardStatusPending;

  /// No description provided for @vacCardVaccinePrefix.
  ///
  /// In es, this message translates to:
  /// **'Vacuna: '**
  String get vacCardVaccinePrefix;

  /// No description provided for @vacCardDosisPrefix.
  ///
  /// In es, this message translates to:
  /// **'Dosis: '**
  String get vacCardDosisPrefix;

  /// No description provided for @vacCardRoutePrefix.
  ///
  /// In es, this message translates to:
  /// **'Vía: '**
  String get vacCardRoutePrefix;

  /// No description provided for @vacCardExpiredAgo.
  ///
  /// In es, this message translates to:
  /// **'Vencida hace: '**
  String get vacCardExpiredAgo;

  /// No description provided for @vacCardDaysLeft.
  ///
  /// In es, this message translates to:
  /// **'Faltan: '**
  String get vacCardDaysLeft;

  /// No description provided for @vacErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar vacunaciones'**
  String get vacErrorTitle;

  /// No description provided for @vacStepVaccineInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información de la Vacuna'**
  String get vacStepVaccineInfoTitle;

  /// No description provided for @vacStepVaccineInfoDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingresa los datos de la vacuna a programar'**
  String get vacStepVaccineInfoDesc;

  /// No description provided for @vacStepBatchRequired.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get vacStepBatchRequired;

  /// No description provided for @vacStepSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get vacStepSelectBatch;

  /// No description provided for @vacStepSelectFromInventory.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar del inventario'**
  String get vacStepSelectFromInventory;

  /// No description provided for @vacStepSelectVaccineInventory.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar vacuna del inventario'**
  String get vacStepSelectVaccineInventory;

  /// No description provided for @vacStepOptionalSelectVaccine.
  ///
  /// In es, this message translates to:
  /// **'Opcional - Selecciona una vacuna registrada'**
  String get vacStepOptionalSelectVaccine;

  /// No description provided for @vacStepInventoryNote.
  ///
  /// In es, this message translates to:
  /// **'Si seleccionas del inventario, el stock se descontará automáticamente.'**
  String get vacStepInventoryNote;

  /// No description provided for @vacStepVaccineName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la vacuna'**
  String get vacStepVaccineName;

  /// No description provided for @vacStepVaccineNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Newcastle + Bronquitis'**
  String get vacStepVaccineNameHint;

  /// No description provided for @vacStepVaccineNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre de la vacuna'**
  String get vacStepVaccineNameRequired;

  /// No description provided for @vacStepVaccineNameMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get vacStepVaccineNameMinLength;

  /// No description provided for @vacStepVaccineBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote de la vacuna (opcional)'**
  String get vacStepVaccineBatch;

  /// No description provided for @vacStepVaccineBatchHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: LOT123456'**
  String get vacStepVaccineBatchHint;

  /// No description provided for @vacStepScheduledDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha programada *'**
  String get vacStepScheduledDate;

  /// No description provided for @vacStepTipTitle.
  ///
  /// In es, this message translates to:
  /// **'Consejo'**
  String get vacStepTipTitle;

  /// No description provided for @vacStepTipMessage.
  ///
  /// In es, this message translates to:
  /// **'Programa las vacunaciones con anticipación para mantener el calendario sanitario al día.'**
  String get vacStepTipMessage;

  /// No description provided for @vacStepAppObsTitle.
  ///
  /// In es, this message translates to:
  /// **'Aplicación y Observaciones'**
  String get vacStepAppObsTitle;

  /// No description provided for @vacStepAppObsDesc.
  ///
  /// In es, this message translates to:
  /// **'Registra cuándo se aplicó y añade observaciones'**
  String get vacStepAppObsDesc;

  /// No description provided for @vacStepAppDateOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha de aplicación (opcional)'**
  String get vacStepAppDateOptional;

  /// No description provided for @vacStepSelectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get vacStepSelectDate;

  /// No description provided for @vacStepRemoveDate.
  ///
  /// In es, this message translates to:
  /// **'Quitar fecha'**
  String get vacStepRemoveDate;

  /// No description provided for @vacStepObservationsOptional.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get vacStepObservationsOptional;

  /// No description provided for @vacStepObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Reacciones observadas, notas especiales, etc.'**
  String get vacStepObservationsHint;

  /// No description provided for @vacStepVaccineApplied.
  ///
  /// In es, this message translates to:
  /// **'Vacuna aplicada'**
  String get vacStepVaccineApplied;

  /// No description provided for @vacStepAppliedNote.
  ///
  /// In es, this message translates to:
  /// **'La vacunación quedará registrada como aplicada.'**
  String get vacStepAppliedNote;

  /// No description provided for @vacStepScheduled.
  ///
  /// In es, this message translates to:
  /// **'Vacunación programada'**
  String get vacStepScheduled;

  /// No description provided for @vacStepScheduledNote.
  ///
  /// In es, this message translates to:
  /// **'Quedará pendiente. Podrás marcarla como aplicada más tarde.'**
  String get vacStepScheduledNote;

  /// No description provided for @vacStepCalendarReminder.
  ///
  /// In es, this message translates to:
  /// **'Las vacunaciones programadas aparecerán en tu calendario y recibirás recordatorios.'**
  String get vacStepCalendarReminder;

  /// No description provided for @treatStepDiagTitle.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico y Síntomas'**
  String get treatStepDiagTitle;

  /// No description provided for @treatStepDiagDesc.
  ///
  /// In es, this message translates to:
  /// **'Registra el diagnóstico y los síntomas observados en las aves'**
  String get treatStepDiagDesc;

  /// No description provided for @treatStepDiagImportant.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get treatStepDiagImportant;

  /// No description provided for @treatStepDiagImportantMsg.
  ///
  /// In es, this message translates to:
  /// **'Un diagnóstico preciso permite seleccionar el tratamiento más efectivo y prevenir la propagación.'**
  String get treatStepDiagImportantMsg;

  /// No description provided for @treatStepDateRequired.
  ///
  /// In es, this message translates to:
  /// **'Fecha del tratamiento *'**
  String get treatStepDateRequired;

  /// No description provided for @treatStepDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get treatStepDiagnosis;

  /// No description provided for @treatStepDiagnosisHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Enfermedad respiratoria crónica'**
  String get treatStepDiagnosisHint;

  /// No description provided for @treatStepDiagRequired.
  ///
  /// In es, this message translates to:
  /// **'El diagnóstico es obligatorio'**
  String get treatStepDiagRequired;

  /// No description provided for @treatStepDiagMinLength.
  ///
  /// In es, this message translates to:
  /// **'Debe tener al menos 5 caracteres'**
  String get treatStepDiagMinLength;

  /// No description provided for @treatStepSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas observados'**
  String get treatStepSymptoms;

  /// No description provided for @treatStepSymptomsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe los síntomas: tos, estornudos, decaimiento...'**
  String get treatStepSymptomsHint;

  /// No description provided for @treatStepDetailsTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Tratamiento'**
  String get treatStepDetailsTitle;

  /// No description provided for @treatStepDetailsDesc.
  ///
  /// In es, this message translates to:
  /// **'Describe el tratamiento aplicado y los medicamentos'**
  String get treatStepDetailsDesc;

  /// No description provided for @treatStepDetailsImportant.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get treatStepDetailsImportant;

  /// No description provided for @treatStepDetailsImportantMsg.
  ///
  /// In es, this message translates to:
  /// **'Si seleccionas un medicamento del inventario, el stock se descontará automáticamente al guardar.'**
  String get treatStepDetailsImportantMsg;

  /// No description provided for @treatStepTreatmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Descripción del tratamiento'**
  String get treatStepTreatmentDesc;

  /// No description provided for @treatStepTreatmentHint.
  ///
  /// In es, this message translates to:
  /// **'Describe el protocolo de tratamiento aplicado'**
  String get treatStepTreatmentHint;

  /// No description provided for @treatStepTreatmentRequired.
  ///
  /// In es, this message translates to:
  /// **'El tratamiento es obligatorio'**
  String get treatStepTreatmentRequired;

  /// No description provided for @treatStepTreatmentMinLength.
  ///
  /// In es, this message translates to:
  /// **'Debe tener al menos 5 caracteres'**
  String get treatStepTreatmentMinLength;

  /// No description provided for @treatStepInventoryMed.
  ///
  /// In es, this message translates to:
  /// **'Medicamento del inventario (opcional)'**
  String get treatStepInventoryMed;

  /// No description provided for @treatStepSelectMed.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar medicamento del inventario...'**
  String get treatStepSelectMed;

  /// No description provided for @treatStepAutoDeduct.
  ///
  /// In es, this message translates to:
  /// **'Se descontará automáticamente del inventario'**
  String get treatStepAutoDeduct;

  /// No description provided for @treatStepMedicationsAdditional.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos adicionales'**
  String get treatStepMedicationsAdditional;

  /// No description provided for @treatStepMedications.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get treatStepMedications;

  /// No description provided for @treatStepMedicationsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Enrofloxacina + Vitaminas A, D, E'**
  String get treatStepMedicationsHint;

  /// No description provided for @treatStepDosis.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get treatStepDosis;

  /// No description provided for @treatStepDosisHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1ml/L'**
  String get treatStepDosisHint;

  /// No description provided for @treatStepDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración (días)'**
  String get treatStepDuration;

  /// No description provided for @treatStepDurationHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 5'**
  String get treatStepDurationHint;

  /// No description provided for @treatStepDurationMin.
  ///
  /// In es, this message translates to:
  /// **'Debe ser > 0'**
  String get treatStepDurationMin;

  /// No description provided for @treatStepDurationMax.
  ///
  /// In es, this message translates to:
  /// **'Máximo 365'**
  String get treatStepDurationMax;

  /// No description provided for @treatStepSelectLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Ubicación'**
  String get treatStepSelectLocationTitle;

  /// No description provided for @treatStepSelectBatchTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Lote'**
  String get treatStepSelectBatchTitle;

  /// No description provided for @treatStepSelectLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la granja y el lote para registrar el tratamiento'**
  String get treatStepSelectLocationDesc;

  /// No description provided for @treatStepSelectBatchDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el lote para registrar el tratamiento'**
  String get treatStepSelectBatchDesc;

  /// No description provided for @treatStepSelectBatchSubDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el lote donde se aplicará el tratamiento'**
  String get treatStepSelectBatchSubDesc;

  /// No description provided for @treatStepNoFarms.
  ///
  /// In es, this message translates to:
  /// **'No tienes granjas registradas'**
  String get treatStepNoFarms;

  /// No description provided for @treatStepNoFarmsDesc.
  ///
  /// In es, this message translates to:
  /// **'Debes crear una granja antes de registrar un tratamiento'**
  String get treatStepNoFarmsDesc;

  /// No description provided for @treatStepFarmsError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas'**
  String get treatStepFarmsError;

  /// No description provided for @treatStepFarmRequired.
  ///
  /// In es, this message translates to:
  /// **'Granja *'**
  String get treatStepFarmRequired;

  /// No description provided for @treatStepSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get treatStepSelectFarm;

  /// No description provided for @treatStepFarmValidation.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get treatStepFarmValidation;

  /// No description provided for @treatStepBatchRequired.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get treatStepBatchRequired;

  /// No description provided for @treatStepSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get treatStepSelectBatch;

  /// No description provided for @treatStepBatchValidation.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un lote'**
  String get treatStepBatchValidation;

  /// No description provided for @treatStepNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos'**
  String get treatStepNoActiveBatches;

  /// No description provided for @treatStepNoActiveBatchesDesc.
  ///
  /// In es, this message translates to:
  /// **'Esta granja no tiene lotes activos para registrar tratamientos'**
  String get treatStepNoActiveBatchesDesc;

  /// No description provided for @treatStepBatchesError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get treatStepBatchesError;

  /// No description provided for @treatStepAdditionalTitle.
  ///
  /// In es, this message translates to:
  /// **'Información Adicional'**
  String get treatStepAdditionalTitle;

  /// No description provided for @treatStepAdditionalDesc.
  ///
  /// In es, this message translates to:
  /// **'Datos complementarios del tratamiento'**
  String get treatStepAdditionalDesc;

  /// No description provided for @treatStepAdditionalImportant.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get treatStepAdditionalImportant;

  /// No description provided for @treatStepAdditionalImportantMsg.
  ///
  /// In es, this message translates to:
  /// **'Estos campos son opcionales pero ayudan a un mejor seguimiento del tratamiento.'**
  String get treatStepAdditionalImportantMsg;

  /// No description provided for @treatStepVeterinarian.
  ///
  /// In es, this message translates to:
  /// **'Veterinario responsable'**
  String get treatStepVeterinarian;

  /// No description provided for @treatStepVetName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del veterinario'**
  String get treatStepVetName;

  /// No description provided for @treatStepGeneralObs.
  ///
  /// In es, this message translates to:
  /// **'Observaciones generales'**
  String get treatStepGeneralObs;

  /// No description provided for @treatStepGeneralObsHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales, evolución esperada, etc.'**
  String get treatStepGeneralObsHint;

  /// No description provided for @bioStepLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Dónde se realizará la inspección?'**
  String get bioStepLocationTitle;

  /// No description provided for @bioStepLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el galpón o deja en blanco para una inspección general.'**
  String get bioStepLocationDesc;

  /// No description provided for @bioStepInspector.
  ///
  /// In es, this message translates to:
  /// **'Inspector'**
  String get bioStepInspector;

  /// No description provided for @bioStepDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get bioStepDate;

  /// No description provided for @bioStepShed.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get bioStepShed;

  /// No description provided for @bioStepShedOptional.
  ///
  /// In es, this message translates to:
  /// **'Opcional — si no seleccionas, la inspección aplica a toda la granja.'**
  String get bioStepShedOptional;

  /// No description provided for @bioStepLoadingFarm.
  ///
  /// In es, this message translates to:
  /// **'Cargando granja…'**
  String get bioStepLoadingFarm;

  /// No description provided for @bioStepNoSheds.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones registrados. Se realizará inspección general.'**
  String get bioStepNoSheds;

  /// No description provided for @bioStepWholeFarm.
  ///
  /// In es, this message translates to:
  /// **'Toda la granja'**
  String get bioStepWholeFarm;

  /// No description provided for @bioChecklistCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get bioChecklistCritical;

  /// No description provided for @bioChecklistTapToEvaluate.
  ///
  /// In es, this message translates to:
  /// **'Toca para evaluar'**
  String get bioChecklistTapToEvaluate;

  /// No description provided for @bioChecklistCompliant.
  ///
  /// In es, this message translates to:
  /// **'Cumple'**
  String get bioChecklistCompliant;

  /// No description provided for @bioChecklistNonCompliant.
  ///
  /// In es, this message translates to:
  /// **'No cumple'**
  String get bioChecklistNonCompliant;

  /// No description provided for @bioChecklistPartial.
  ///
  /// In es, this message translates to:
  /// **'Parcial'**
  String get bioChecklistPartial;

  /// No description provided for @bioChecklistNotApplicable.
  ///
  /// In es, this message translates to:
  /// **'No aplica'**
  String get bioChecklistNotApplicable;

  /// No description provided for @bioChecklistPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get bioChecklistPending;

  /// No description provided for @bioChecklistSelectResult.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el resultado de la evaluación'**
  String get bioChecklistSelectResult;

  /// No description provided for @bioChecklistObservation.
  ///
  /// In es, this message translates to:
  /// **'Observación'**
  String get bioChecklistObservation;

  /// No description provided for @bioChecklistObservationHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe una observación (opcional)'**
  String get bioChecklistObservationHint;

  /// No description provided for @bioSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de la inspección'**
  String get bioSummaryTitle;

  /// No description provided for @bioSummarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa los resultados antes de guardar.'**
  String get bioSummarySubtitle;

  /// No description provided for @bioSummaryCumple.
  ///
  /// In es, this message translates to:
  /// **'Cumple'**
  String get bioSummaryCumple;

  /// No description provided for @bioSummaryParcial.
  ///
  /// In es, this message translates to:
  /// **'Parcial'**
  String get bioSummaryParcial;

  /// No description provided for @bioSummaryNoCumple.
  ///
  /// In es, this message translates to:
  /// **'No cumple'**
  String get bioSummaryNoCumple;

  /// No description provided for @bioSummaryCriticalItems.
  ///
  /// In es, this message translates to:
  /// **'Items críticos sin cumplir'**
  String get bioSummaryCriticalItems;

  /// No description provided for @bioSummaryPendingNote.
  ///
  /// In es, this message translates to:
  /// **'Puedes guardar, pero el puntaje solo refleja lo evaluado.'**
  String get bioSummaryPendingNote;

  /// No description provided for @bioSummaryGeneralObs.
  ///
  /// In es, this message translates to:
  /// **'Observaciones generales'**
  String get bioSummaryGeneralObs;

  /// No description provided for @bioSummaryGeneralObsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe hallazgos generales de la inspección…'**
  String get bioSummaryGeneralObsHint;

  /// No description provided for @bioSummaryCorrectiveActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones correctivas'**
  String get bioSummaryCorrectiveActions;

  /// No description provided for @bioSummaryCorrectiveHint.
  ///
  /// In es, this message translates to:
  /// **'Describe las acciones a implementar…'**
  String get bioSummaryCorrectiveHint;

  /// No description provided for @bioSummaryRecommended.
  ///
  /// In es, this message translates to:
  /// **'Recomendado'**
  String get bioSummaryRecommended;

  /// No description provided for @bioSummaryNote.
  ///
  /// In es, this message translates to:
  /// **'Al guardar se generará un reporte descargable y el historial quedará registrado.'**
  String get bioSummaryNote;

  /// No description provided for @bioRatingExcellent.
  ///
  /// In es, this message translates to:
  /// **'Excelente'**
  String get bioRatingExcellent;

  /// No description provided for @bioRatingVeryGood.
  ///
  /// In es, this message translates to:
  /// **'Muy Bueno'**
  String get bioRatingVeryGood;

  /// No description provided for @bioRatingGood.
  ///
  /// In es, this message translates to:
  /// **'Bueno'**
  String get bioRatingGood;

  /// No description provided for @bioRatingAcceptable.
  ///
  /// In es, this message translates to:
  /// **'Aceptable'**
  String get bioRatingAcceptable;

  /// No description provided for @bioRatingRegular.
  ///
  /// In es, this message translates to:
  /// **'Regular'**
  String get bioRatingRegular;

  /// No description provided for @bioRatingPoor.
  ///
  /// In es, this message translates to:
  /// **'Deficiente'**
  String get bioRatingPoor;

  /// No description provided for @saludDialogCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get saludDialogCancel;

  /// No description provided for @saludDialogDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get saludDialogDelete;

  /// No description provided for @saludDialogContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get saludDialogContinue;

  /// No description provided for @saludDialogConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get saludDialogConfirm;

  /// No description provided for @saludDialogAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get saludDialogAccept;

  /// No description provided for @saludDialogProcessing.
  ///
  /// In es, this message translates to:
  /// **'Procesando...'**
  String get saludDialogProcessing;

  /// No description provided for @saludSwipeClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get saludSwipeClose;

  /// No description provided for @saludSwipeApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get saludSwipeApply;

  /// No description provided for @saludSwipeDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get saludSwipeDelete;

  /// No description provided for @ventaDeleteMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará la venta de {product}. Esta acción no se puede deshacer.'**
  String ventaDeleteMessage(Object product);

  /// No description provided for @ventaDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {message}'**
  String ventaDeleteError(Object message);

  /// No description provided for @ventaDetailsOf.
  ///
  /// In es, this message translates to:
  /// **'Detalles de {product}'**
  String ventaDetailsOf(Object product);

  /// No description provided for @ventaLotLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes: {error}'**
  String ventaLotLoadError(Object error);

  /// No description provided for @costoDeleteError2.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String costoDeleteError2(Object error);

  /// No description provided for @costoApproveError.
  ///
  /// In es, this message translates to:
  /// **'Error al aprobar: {error}'**
  String costoApproveError(Object error);

  /// No description provided for @costoRejectError.
  ///
  /// In es, this message translates to:
  /// **'Error al rechazar: {error}'**
  String costoRejectError(Object error);

  /// No description provided for @saludDeleteRecordMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará el registro \"{diagnosis}\". Esta acción no se puede deshacer.'**
  String saludDeleteRecordMessage(String diagnosis);

  /// No description provided for @saludActiveTreatments.
  ///
  /// In es, this message translates to:
  /// **'{count} tratamiento(s) activo(s)'**
  String saludActiveTreatments(Object count);

  /// No description provided for @saludCardDays.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String saludCardDays(Object count);

  /// No description provided for @bioEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Inicia la primera inspección de bioseguridad para {farmName} y lleva un registro continuo del cumplimiento sanitario.'**
  String bioEmptyDescription(Object farmName);

  /// No description provided for @bioChecklistProgress.
  ///
  /// In es, this message translates to:
  /// **'{evaluated} de {total} evaluados'**
  String bioChecklistProgress(String evaluated, Object total);

  /// No description provided for @bioSummaryRisk.
  ///
  /// In es, this message translates to:
  /// **'Riesgo {level} · {evaluated} de {total} evaluados'**
  String bioSummaryRisk(Object evaluated, Object level, Object total);

  /// No description provided for @bioSummaryPendingItems.
  ///
  /// In es, this message translates to:
  /// **'{count} items pendientes'**
  String bioSummaryPendingItems(Object count);

  /// No description provided for @vacSummaryExpiredBadge.
  ///
  /// In es, this message translates to:
  /// **'{count} vencida(s)'**
  String vacSummaryExpiredBadge(Object count);

  /// No description provided for @vacSummaryUpcomingBadge.
  ///
  /// In es, this message translates to:
  /// **'{count} próxima(s)'**
  String vacSummaryUpcomingBadge(Object count);

  /// No description provided for @vacCardAppliedDate.
  ///
  /// In es, this message translates to:
  /// **'Aplicada: {date}'**
  String vacCardAppliedDate(Object date);

  /// No description provided for @vacCardDays.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String vacCardDays(Object count);

  /// No description provided for @vacDetailScheduled.
  ///
  /// In es, this message translates to:
  /// **'Programada: {date}'**
  String vacDetailScheduled(Object date);

  /// No description provided for @vacDetailAppliedOn.
  ///
  /// In es, this message translates to:
  /// **'Aplicada el {date}'**
  String vacDetailAppliedOn(Object date);

  /// No description provided for @vacFormDraftMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String vacFormDraftMessage(Object date);

  /// No description provided for @treatSavedMinAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {count} min'**
  String treatSavedMinAgo(Object count);

  /// No description provided for @treatSavedAtTime.
  ///
  /// In es, this message translates to:
  /// **'Guardado a las {time}'**
  String treatSavedAtTime(Object time);

  /// No description provided for @monthMayFull.
  ///
  /// In es, this message translates to:
  /// **'Mayo'**
  String get monthMayFull;

  /// No description provided for @commonDiscard2.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get commonDiscard2;

  /// No description provided for @ventaClientBuyerInfo.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la información del comprador'**
  String get ventaClientBuyerInfo;

  /// No description provided for @ventaClientNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get ventaClientNameLabel;

  /// No description provided for @ventaClientPhoneHint.
  ///
  /// In es, this message translates to:
  /// **'9 dígitos'**
  String get ventaClientPhoneHint;

  /// No description provided for @ventaClientDniLength.
  ///
  /// In es, this message translates to:
  /// **'El DNI debe tener 8 dígitos'**
  String get ventaClientDniLength;

  /// No description provided for @ventaClientRucLength.
  ///
  /// In es, this message translates to:
  /// **'El RUC debe tener 11 dígitos'**
  String get ventaClientRucLength;

  /// No description provided for @ventaClientDocInvalid.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get ventaClientDocInvalid;

  /// No description provided for @ventaClientPhoneLength.
  ///
  /// In es, this message translates to:
  /// **'El teléfono debe tener 9 dígitos'**
  String get ventaClientPhoneLength;

  /// No description provided for @ventaClientForeignCard.
  ///
  /// In es, this message translates to:
  /// **'Carnet de Extranjería'**
  String get ventaClientForeignCard;

  /// No description provided for @ventaSelectLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la granja y el lote para registrar la venta'**
  String get ventaSelectLocationDesc;

  /// No description provided for @ventaNoFarmsDesc.
  ///
  /// In es, this message translates to:
  /// **'Debes crear una granja antes de registrar una venta'**
  String get ventaNoFarmsDesc;

  /// No description provided for @ventaErrorLoadingFarms.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas'**
  String get ventaErrorLoadingFarms;

  /// No description provided for @ventaSelectFarmError.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get ventaSelectFarmError;

  /// No description provided for @ventaLoteLabelStar.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get ventaLoteLabelStar;

  /// No description provided for @ventaSelectLoteHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectLoteHint;

  /// No description provided for @ventaSelectLoteError.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un lote'**
  String get ventaSelectLoteError;

  /// No description provided for @ventaNoActiveLotes.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos'**
  String get ventaNoActiveLotes;

  /// No description provided for @ventaNoActiveLotesDesc.
  ///
  /// In es, this message translates to:
  /// **'Esta granja no tiene lotes activos para registrar ventas'**
  String get ventaNoActiveLotesDesc;

  /// No description provided for @ventaErrorLoadingLotes.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get ventaErrorLoadingLotes;

  /// No description provided for @ventaFilterAllTypes.
  ///
  /// In es, this message translates to:
  /// **'Todos los tipos'**
  String get ventaFilterAllTypes;

  /// No description provided for @ventaFilterApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get ventaFilterApply;

  /// No description provided for @ventaFilterClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get ventaFilterClose;

  /// No description provided for @ventaSheetObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get ventaSheetObservations;

  /// No description provided for @ventaSheetRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get ventaSheetRegistrationDate;

  /// No description provided for @ventaDetailLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get ventaDetailLocation;

  /// No description provided for @ventaDetailGranja.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get ventaDetailGranja;

  /// No description provided for @ventaDetailLote.
  ///
  /// In es, this message translates to:
  /// **'Lote'**
  String get ventaDetailLote;

  /// No description provided for @ventaDetailPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get ventaDetailPhone;

  /// No description provided for @ventaDetailInfoRegistro.
  ///
  /// In es, this message translates to:
  /// **'Información de Registro'**
  String get ventaDetailInfoRegistro;

  /// No description provided for @ventaDetailRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get ventaDetailRegisteredBy;

  /// No description provided for @ventaDetailRole.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get ventaDetailRole;

  /// No description provided for @ventaDetailRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get ventaDetailRegistrationDate;

  /// No description provided for @ventaDetailError.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get ventaDetailError;

  /// No description provided for @ventaDetailMoreOptions.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get ventaDetailMoreOptions;

  /// No description provided for @ventaSavedAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado {time}'**
  String ventaSavedAgo(Object time);

  /// No description provided for @ventaShareDate.
  ///
  /// In es, this message translates to:
  /// **'📅 Fecha: {date}'**
  String ventaShareDate(Object date);

  /// No description provided for @ventaShareType.
  ///
  /// In es, this message translates to:
  /// **'🏷️ Tipo: {type}'**
  String ventaShareType(Object type);

  /// No description provided for @ventaShareQuantityBirds.
  ///
  /// In es, this message translates to:
  /// **'📦 Cantidad: {count} aves'**
  String ventaShareQuantityBirds(Object count);

  /// No description provided for @ventaSharePrice.
  ///
  /// In es, this message translates to:
  /// **'💵 Precio: {currency} {price}/kg'**
  String ventaSharePrice(String currency, String price);

  /// No description provided for @ventaShareEggs.
  ///
  /// In es, this message translates to:
  /// **'📦 Huevos: {count} unidades'**
  String ventaShareEggs(Object count);

  /// No description provided for @ventaShareQuantityPollinaza.
  ///
  /// In es, this message translates to:
  /// **'📦 Cantidad: {count} {unit}'**
  String ventaShareQuantityPollinaza(Object count, Object unit);

  /// No description provided for @ventaShareTotal.
  ///
  /// In es, this message translates to:
  /// **'💰 TOTAL: {currency} {total}'**
  String ventaShareTotal(Object currency, Object total);

  /// No description provided for @ventaShareClient.
  ///
  /// In es, this message translates to:
  /// **'👤 Cliente: {name}'**
  String ventaShareClient(Object name);

  /// No description provided for @ventaShareContact.
  ///
  /// In es, this message translates to:
  /// **'📞 Contacto: {contact}'**
  String ventaShareContact(String contact);

  /// No description provided for @ventaShareStatus.
  ///
  /// In es, this message translates to:
  /// **'📍 Estado: {status}'**
  String ventaShareStatus(Object status);

  /// No description provided for @ventaShareAppName.
  ///
  /// In es, this message translates to:
  /// **'Smart Granja Aves Pro'**
  String get ventaShareAppName;

  /// No description provided for @ventaShareSubject.
  ///
  /// In es, this message translates to:
  /// **'Venta - {type}'**
  String ventaShareSubject(Object type);

  /// No description provided for @ventaDateOfLabel.
  ///
  /// In es, this message translates to:
  /// **'{day} de {month} {year} • {time}'**
  String ventaDateOfLabel(String month, String year, Object day, Object time);

  /// No description provided for @bioStepGalpon.
  ///
  /// In es, this message translates to:
  /// **'Galpón'**
  String get bioStepGalpon;

  /// No description provided for @bioStepGalponHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el galpón a inspeccionar'**
  String get bioStepGalponHint;

  /// No description provided for @bioStepNoGalpones.
  ///
  /// In es, this message translates to:
  /// **'No hay galpones registrados en esta granja'**
  String get bioStepNoGalpones;

  /// No description provided for @bioStepSelectLocationHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la ubicación para la inspección de bioseguridad'**
  String get bioStepSelectLocationHint;

  /// No description provided for @bioTitle.
  ///
  /// In es, this message translates to:
  /// **'Bioseguridad'**
  String get bioTitle;

  /// No description provided for @invCodeOptional.
  ///
  /// In es, this message translates to:
  /// **'Código / SKU (opcional)'**
  String get invCodeOptional;

  /// No description provided for @invCurrentStock.
  ///
  /// In es, this message translates to:
  /// **'Stock actual'**
  String get invCurrentStock;

  /// No description provided for @invDescHerramienta.
  ///
  /// In es, this message translates to:
  /// **'Herramientas, bebederos, comederos y equipos'**
  String get invDescHerramienta;

  /// No description provided for @invDescribeItem.
  ///
  /// In es, this message translates to:
  /// **'Describe brevemente el item'**
  String get invDescribeItem;

  /// No description provided for @invInternalCode.
  ///
  /// In es, this message translates to:
  /// **'Código interno o SKU'**
  String get invInternalCode;

  /// No description provided for @invItemNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Nombre del item *'**
  String get invItemNameRequired;

  /// No description provided for @invLocationWarehouse.
  ///
  /// In es, this message translates to:
  /// **'Ubicación / Almacén'**
  String get invLocationWarehouse;

  /// No description provided for @invMaximumStock.
  ///
  /// In es, this message translates to:
  /// **'Stock máximo'**
  String get invMaximumStock;

  /// No description provided for @invMinimumStock.
  ///
  /// In es, this message translates to:
  /// **'Stock mínimo'**
  String get invMinimumStock;

  /// No description provided for @invNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 2 caracteres'**
  String get invNameRequired;

  /// No description provided for @invStepStockTitle.
  ///
  /// In es, this message translates to:
  /// **'Stock y Unidades'**
  String get invStepStockTitle;

  /// No description provided for @invStockAlertDescription.
  ///
  /// In es, this message translates to:
  /// **'Configura el stock mínimo para recibir alertas cuando el inventario esté bajo.'**
  String get invStockAlertDescription;

  /// No description provided for @invSupplierBatchNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de lote del proveedor'**
  String get invSupplierBatchNumber;

  /// No description provided for @invSupplierNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del proveedor'**
  String get invSupplierNameLabel;

  /// No description provided for @invWarehouseExample.
  ///
  /// In es, this message translates to:
  /// **'Ej: Bodega principal, Galpón 1'**
  String get invWarehouseExample;

  /// No description provided for @ventaAverageWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso promedio'**
  String get ventaAverageWeight;

  /// No description provided for @ventaBirdQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de aves'**
  String get ventaBirdQuantity;

  /// No description provided for @ventaCarcassYield.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento canal'**
  String get ventaCarcassYield;

  /// No description provided for @ventaClient.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get ventaClient;

  /// No description provided for @ventaClientDocument.
  ///
  /// In es, this message translates to:
  /// **'Número de documento *'**
  String get ventaClientDocument;

  /// No description provided for @ventaClientDocumentInvalid.
  ///
  /// In es, this message translates to:
  /// **'Documento inválido'**
  String get ventaClientDocumentInvalid;

  /// No description provided for @ventaClientDocumentRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el número de documento'**
  String get ventaClientDocumentRequired;

  /// No description provided for @ventaDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Venta eliminada correctamente'**
  String get ventaDeletedSuccess;

  /// No description provided for @ventaDocument.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get ventaDocument;

  /// No description provided for @ventaEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar venta'**
  String get ventaEditTooltip;

  /// No description provided for @ventaNewSaleTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get ventaNewSaleTitle;

  /// No description provided for @ventaNotFound.
  ///
  /// In es, this message translates to:
  /// **'Venta no encontrada'**
  String get ventaNotFound;

  /// No description provided for @ventaPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get ventaPhone;

  /// No description provided for @ventaProductDescAbono.
  ///
  /// In es, this message translates to:
  /// **'Abono orgánico derivado de la producción avícola'**
  String get ventaProductDescAbono;

  /// No description provided for @ventaProductDescAvesEnPie.
  ///
  /// In es, this message translates to:
  /// **'Venta de aves vivas en pie por kilogramo'**
  String get ventaProductDescAvesEnPie;

  /// No description provided for @ventaProductDescAvesFaenadas.
  ///
  /// In es, this message translates to:
  /// **'Aves procesadas y listas para consumo'**
  String get ventaProductDescAvesFaenadas;

  /// No description provided for @ventaProductDescHuevos.
  ///
  /// In es, this message translates to:
  /// **'Venta de huevos por clasificación y docena'**
  String get ventaProductDescHuevos;

  /// No description provided for @ventaProductDescOtro.
  ///
  /// In es, this message translates to:
  /// **'Aves de descarte u otros productos avícolas'**
  String get ventaProductDescOtro;

  /// No description provided for @ventaProductDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del producto'**
  String get ventaProductDetails;

  /// No description provided for @ventaQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get ventaQuantity;

  /// No description provided for @ventaReceiptTitle.
  ///
  /// In es, this message translates to:
  /// **'COMPROBANTE DE VENTA'**
  String get ventaReceiptTitle;

  /// No description provided for @ventasFilterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar ventas'**
  String get ventasFilterTitle;

  /// No description provided for @ventaShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get ventaShare;

  /// No description provided for @ventaSlaughterWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado'**
  String get ventaSlaughterWeight;

  /// No description provided for @ventasProductType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de producto'**
  String get ventasProductType;

  /// No description provided for @ventaStepClientTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos del Cliente'**
  String get ventaStepClientTitle;

  /// No description provided for @ventaStepNoFarms.
  ///
  /// In es, this message translates to:
  /// **'No hay granjas disponibles'**
  String get ventaStepNoFarms;

  /// No description provided for @ventaStepProductQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de producto vendes?'**
  String get ventaStepProductQuestion;

  /// No description provided for @ventaStepSelectLocation.
  ///
  /// In es, this message translates to:
  /// **'Selecciona Granja y Lote'**
  String get ventaStepSelectLocation;

  /// No description provided for @ventaStepSelectLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Elige la granja y el lote asociado a esta venta'**
  String get ventaStepSelectLocationDesc;

  /// No description provided for @ventaStepSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get ventaStepSummary;

  /// No description provided for @ventaSubtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get ventaSubtotal;

  /// No description provided for @ventaTotalLabel.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get ventaTotalLabel;

  /// No description provided for @ventaUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get ventaUnitPrice;

  /// No description provided for @ventasTitle.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get ventasTitle;

  /// No description provided for @ventasFilter.
  ///
  /// In es, this message translates to:
  /// **'Filtrar ventas'**
  String get ventasFilter;

  /// No description provided for @ventasEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay ventas'**
  String get ventasEmpty;

  /// No description provided for @ventasEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron ventas registradas.'**
  String get ventasEmptyDescription;

  /// No description provided for @ventasNewSale.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get ventasNewSale;

  /// No description provided for @ventasNoResults.
  ///
  /// In es, this message translates to:
  /// **'No hay resultados'**
  String get ventasNoResults;

  /// No description provided for @ventasNoFilterResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron ventas con los filtros aplicados'**
  String get ventasNoFilterResults;

  /// No description provided for @ventasNewSaleTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar nueva venta'**
  String get ventasNewSaleTooltip;

  /// No description provided for @bioInspectionSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar Inspección'**
  String get bioInspectionSaveButton;

  /// No description provided for @bioInspectionMinEvaluation.
  ///
  /// In es, this message translates to:
  /// **'Evaluación mínima'**
  String get bioInspectionMinEvaluation;

  /// No description provided for @ventaStepFarmRequired.
  ///
  /// In es, this message translates to:
  /// **'Debe seleccionar una granja'**
  String get ventaStepFarmRequired;

  /// No description provided for @ventaStepSelectFarmFirst.
  ///
  /// In es, this message translates to:
  /// **'Seleccione una granja primero'**
  String get ventaStepSelectFarmFirst;

  /// No description provided for @ventaStepNoActiveBatches.
  ///
  /// In es, this message translates to:
  /// **'No hay lotes activos'**
  String get ventaStepNoActiveBatches;

  /// No description provided for @ventaStepBatchRequired.
  ///
  /// In es, this message translates to:
  /// **'Debe seleccionar un lote'**
  String get ventaStepBatchRequired;

  /// No description provided for @ventaStepSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar lote'**
  String get ventaStepSelectBatch;

  /// No description provided for @invExpirationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de expiración'**
  String get invExpirationDate;

  /// No description provided for @ventaRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar Venta'**
  String get ventaRegister;

  /// No description provided for @bioInspections.
  ///
  /// In es, this message translates to:
  /// **'bioInspections'**
  String get bioInspections;

  /// No description provided for @bioAverage.
  ///
  /// In es, this message translates to:
  /// **'bioAverage'**
  String get bioAverage;

  /// No description provided for @bioCritical.
  ///
  /// In es, this message translates to:
  /// **'bioCritical'**
  String get bioCritical;

  /// No description provided for @bioLastLevel.
  ///
  /// In es, this message translates to:
  /// **'bioLastLevel'**
  String get bioLastLevel;

  /// No description provided for @diseaseCatalogSearch.
  ///
  /// In es, this message translates to:
  /// **'diseaseCatalogSearch'**
  String get diseaseCatalogSearch;

  /// No description provided for @diseaseCatalogWarning.
  ///
  /// In es, this message translates to:
  /// **'diseaseCatalogWarning'**
  String get diseaseCatalogWarning;

  /// No description provided for @diseaseCatalogMonitor.
  ///
  /// In es, this message translates to:
  /// **'diseaseCatalogMonitor'**
  String get diseaseCatalogMonitor;

  /// No description provided for @bioStepWholeGranja.
  ///
  /// In es, this message translates to:
  /// **'bioStepWholeGranja'**
  String get bioStepWholeGranja;

  /// No description provided for @vacDetailDeleteMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará la vacunación \"{nombre}\". Esta acción no se puede deshacer.'**
  String vacDetailDeleteMessage(Object nombre);

  /// No description provided for @commonDraftFound.
  ///
  /// In es, this message translates to:
  /// **'Borrador encontrado'**
  String get commonDraftFound;

  /// No description provided for @commonDraftRestoreMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador guardado anteriormente?'**
  String get commonDraftRestoreMessage;

  /// No description provided for @costoTypeManoObra.
  ///
  /// In es, this message translates to:
  /// **'Mano de Obra'**
  String get costoTypeManoObra;

  /// No description provided for @costoUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo actualizado correctamente'**
  String get costoUpdatedSuccess;

  /// No description provided for @costoRegisteredSuccess.
  ///
  /// In es, this message translates to:
  /// **'Costo registrado correctamente'**
  String get costoRegisteredSuccess;

  /// No description provided for @batchAvgWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso Promedio'**
  String get batchAvgWeight;

  /// No description provided for @batchFeedConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo de Alimento'**
  String get batchFeedConsumption;

  /// No description provided for @batchFeedConversionICA.
  ///
  /// In es, this message translates to:
  /// **'Conversión Alimenticia (ICA)'**
  String get batchFeedConversionICA;

  /// No description provided for @batchRegisterWeightTooltip.
  ///
  /// In es, this message translates to:
  /// **'Registrar peso del lote'**
  String get batchRegisterWeightTooltip;

  /// No description provided for @batchOpenRegisterMenu.
  ///
  /// In es, this message translates to:
  /// **'Abrir menú de registro'**
  String get batchOpenRegisterMenu;

  /// No description provided for @shedCapacityTotal.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Total'**
  String get shedCapacityTotal;

  /// No description provided for @shedBirdsDensity.
  ///
  /// In es, this message translates to:
  /// **'Aves/m²'**
  String get shedBirdsDensity;

  /// No description provided for @shedMinCapacityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1000'**
  String get shedMinCapacityHint;

  /// No description provided for @vacStepVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get vacStepVaccine;

  /// No description provided for @vacStepApplication.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get vacStepApplication;

  /// No description provided for @vacSelectLote.
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar un lote'**
  String get vacSelectLote;

  /// No description provided for @vacErrorScheduling.
  ///
  /// In es, this message translates to:
  /// **'Error al programar'**
  String get vacErrorScheduling;

  /// No description provided for @vacScheduledSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Vacunación programada exitosamente!'**
  String get vacScheduledSuccess;

  /// No description provided for @vacErrorSchedulingDetail.
  ///
  /// In es, this message translates to:
  /// **'Error al programar vacunación'**
  String get vacErrorSchedulingDetail;

  /// No description provided for @vacCouldNotLoad.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la vacunación'**
  String get vacCouldNotLoad;

  /// No description provided for @vacSelectAppDate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de aplicación'**
  String get vacSelectAppDate;

  /// No description provided for @vacExitTooltip.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get vacExitTooltip;

  /// No description provided for @vacProgramLabel.
  ///
  /// In es, this message translates to:
  /// **'Programar'**
  String get vacProgramLabel;

  /// No description provided for @vacProgramNewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Programar nueva vacunación'**
  String get vacProgramNewTooltip;

  /// No description provided for @vacAgeWeeksLabel.
  ///
  /// In es, this message translates to:
  /// **'Edad (semanas) *'**
  String get vacAgeWeeksLabel;

  /// No description provided for @vacAgeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 4'**
  String get vacAgeHint;

  /// No description provided for @vacDoseHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 0.5 ml'**
  String get vacDoseHint;

  /// No description provided for @vacRouteLabel.
  ///
  /// In es, this message translates to:
  /// **'Vía de aplicación *'**
  String get vacRouteLabel;

  /// No description provided for @vacRouteHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Oral, subcutánea, ocular'**
  String get vacRouteHint;

  /// No description provided for @vacDoseRequired.
  ///
  /// In es, this message translates to:
  /// **'La dosis es obligatoria'**
  String get vacDoseRequired;

  /// No description provided for @treatStepLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get treatStepLocation;

  /// No description provided for @treatStepTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento'**
  String get treatStepTreatment;

  /// No description provided for @treatStepInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get treatStepInfo;

  /// No description provided for @treatDraftMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador del tratamiento guardado anteriormente?'**
  String get treatDraftMessage;

  /// No description provided for @treatFillRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor completa los campos obligatorios'**
  String get treatFillRequired;

  /// No description provided for @treatErrorRegistering.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar tratamiento'**
  String get treatErrorRegistering;

  /// No description provided for @treatClosedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento cerrado'**
  String get treatClosedSuccess;

  /// No description provided for @treatCloseError.
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar tratamiento'**
  String get treatCloseError;

  /// No description provided for @saludDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar registro?'**
  String get saludDeleteTitle;

  /// No description provided for @saludDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get saludDeletedSuccess;

  /// No description provided for @saludDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar registro'**
  String get saludDeleteError;

  /// No description provided for @bioExitInProgress.
  ///
  /// In es, this message translates to:
  /// **'Tienes una inspección en progreso. Si sales ahora, perderás los cambios.'**
  String get bioExitInProgress;

  /// No description provided for @bioSavedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Inspección guardada exitosamente'**
  String get bioSavedSuccess;

  /// No description provided for @ventaDraftMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas restaurar el borrador de venta guardado anteriormente?'**
  String get ventaDraftMessage;

  /// No description provided for @ventaSelectBatch.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectBatch;

  /// No description provided for @ventaQuantityUnit.
  ///
  /// In es, this message translates to:
  /// **'Cantidad ({unit})'**
  String ventaQuantityUnit(String unit);

  /// No description provided for @ventaPricePerUnit.
  ///
  /// In es, this message translates to:
  /// **'Precio por {unit} ({currency})'**
  String ventaPricePerUnit(String currency, String unit);

  /// No description provided for @ventaSaleStatusTitle.
  ///
  /// In es, this message translates to:
  /// **'Estado de venta'**
  String get ventaSaleStatusTitle;

  /// No description provided for @ventaAllStatuses.
  ///
  /// In es, this message translates to:
  /// **'Todos los estados'**
  String get ventaAllStatuses;

  /// No description provided for @ventaPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get ventaPending;

  /// No description provided for @ventaConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get ventaConfirmed;

  /// No description provided for @ventaSold.
  ///
  /// In es, this message translates to:
  /// **'Vendida'**
  String get ventaSold;

  /// No description provided for @ventaSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get ventaSelectFarm;

  /// No description provided for @ventaDiscountLabel.
  ///
  /// In es, this message translates to:
  /// **'Descuento ({percent}%)'**
  String ventaDiscountLabel(String percent);

  /// No description provided for @consumoQuantityLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get consumoQuantityLabel;

  /// No description provided for @consumoTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get consumoTypeLabel;

  /// No description provided for @consumoDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get consumoDateLabel;

  /// No description provided for @consumoPerBirdLabel.
  ///
  /// In es, this message translates to:
  /// **'Consumo por ave'**
  String get consumoPerBirdLabel;

  /// No description provided for @consumoAccumulatedLabel.
  ///
  /// In es, this message translates to:
  /// **'Consumo acumulado'**
  String get consumoAccumulatedLabel;

  /// No description provided for @consumoTotalCostLabel.
  ///
  /// In es, this message translates to:
  /// **'Costo total'**
  String get consumoTotalCostLabel;

  /// No description provided for @consumoCostPerBirdLabel.
  ///
  /// In es, this message translates to:
  /// **'Costo por ave'**
  String get consumoCostPerBirdLabel;

  /// No description provided for @consumoObservationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get consumoObservationsLabel;

  /// No description provided for @consumoObservationsOptional.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get consumoObservationsOptional;

  /// No description provided for @consumoRemoveSelection.
  ///
  /// In es, this message translates to:
  /// **'Quitar selección'**
  String get consumoRemoveSelection;

  /// No description provided for @invQuantityLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad ({unit})'**
  String invQuantityLabel(String unit);

  /// No description provided for @invNewStockLabel.
  ///
  /// In es, this message translates to:
  /// **'Nuevo stock ({unit})'**
  String invNewStockLabel(String unit);

  /// No description provided for @whatsappMsgSupport.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Necesito ayuda con la app Smart Granja Aves. '**
  String get whatsappMsgSupport;

  /// No description provided for @whatsappMsgBug.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Quiero reportar un problema en la app Smart Granja Aves: '**
  String get whatsappMsgBug;

  /// No description provided for @whatsappMsgSuggest.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Tengo una sugerencia para la app Smart Granja Aves: '**
  String get whatsappMsgSuggest;

  /// No description provided for @whatsappMsgCollab.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Estoy interesado en una colaboración con Smart Granja Aves. '**
  String get whatsappMsgCollab;

  /// No description provided for @whatsappMsgPricing.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Me gustaría conocer los planes y precios de Smart Granja Aves. '**
  String get whatsappMsgPricing;

  /// No description provided for @whatsappMsgGeneral.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Tengo una consulta sobre Smart Granja Aves. '**
  String get whatsappMsgGeneral;

  /// No description provided for @errorWithMessage.
  ///
  /// In es, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @salesWeightHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 250'**
  String get salesWeightHint;

  /// No description provided for @salesPricePerKgHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 8.50'**
  String get salesPricePerKgHint;

  /// No description provided for @salesPollinazaQuantityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 10'**
  String get salesPollinazaQuantityHint;

  /// No description provided for @salesPollinazaPriceHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 25.00'**
  String get salesPollinazaPriceHint;

  /// No description provided for @salesPriceGreaterThanZero.
  ///
  /// In es, this message translates to:
  /// **'El precio debe ser mayor a 0'**
  String get salesPriceGreaterThanZero;

  /// No description provided for @salesMaxPrice.
  ///
  /// In es, this message translates to:
  /// **'El precio máximo es 9,999,999.99'**
  String get salesMaxPrice;

  /// No description provided for @salesEnterPricePerKg.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el precio por kg'**
  String get salesEnterPricePerKg;

  /// No description provided for @salesEnterPrice.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el precio'**
  String get salesEnterPrice;

  /// No description provided for @salesEggInstructions.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la cantidad y precio por docena para cada clasificación'**
  String get salesEggInstructions;

  /// No description provided for @salesSaleUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad de venta'**
  String get salesSaleUnit;

  /// No description provided for @salesNoEditPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar ventas en esta granja'**
  String get salesNoEditPermission;

  /// No description provided for @salesNoCreatePermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para registrar ventas en esta granja'**
  String get salesNoCreatePermission;

  /// No description provided for @salesSelectProductFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo de producto primero'**
  String get salesSelectProductFirst;

  /// No description provided for @salesObservationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get salesObservationsLabel;

  /// No description provided for @salesObservationsHint.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales (opcional)'**
  String get salesObservationsHint;

  /// No description provided for @salesSelectBatchLabel.
  ///
  /// In es, this message translates to:
  /// **'Lote *'**
  String get salesSelectBatchLabel;

  /// No description provided for @salesSelectBatchHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get salesSelectBatchHint;

  /// No description provided for @salesSelectBatchError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get salesSelectBatchError;

  /// No description provided for @salesHuevosName.
  ///
  /// In es, this message translates to:
  /// **'Huevos {name}'**
  String salesHuevosName(String name);

  /// No description provided for @salesSavedAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado {time}'**
  String salesSavedAgo(String time);

  /// No description provided for @ventaListProductType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de producto'**
  String get ventaListProductType;

  /// No description provided for @ventaListStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get ventaListStatus;

  /// No description provided for @ventaListDocument.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get ventaListDocument;

  /// No description provided for @ventaListCarrier.
  ///
  /// In es, this message translates to:
  /// **'Transportista'**
  String get ventaListCarrier;

  /// No description provided for @ventaListSubtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get ventaListSubtotal;

  /// No description provided for @clientBuyerInfo.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la información del comprador'**
  String get clientBuyerInfo;

  /// No description provided for @clientDocType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de documento *'**
  String get clientDocType;

  /// No description provided for @clientForeignCard.
  ///
  /// In es, this message translates to:
  /// **'Carnet de Extranjería'**
  String get clientForeignCard;

  /// No description provided for @clientDocHint8.
  ///
  /// In es, this message translates to:
  /// **'8 dígitos'**
  String get clientDocHint8;

  /// No description provided for @clientDocHint11.
  ///
  /// In es, this message translates to:
  /// **'11 dígitos'**
  String get clientDocHint11;

  /// No description provided for @clientDocHintGeneral.
  ///
  /// In es, this message translates to:
  /// **'Número de documento'**
  String get clientDocHintGeneral;

  /// No description provided for @clientPhoneHint.
  ///
  /// In es, this message translates to:
  /// **'9 dígitos'**
  String get clientPhoneHint;

  /// No description provided for @clientNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del cliente'**
  String get clientNameRequired;

  /// No description provided for @clientNameMinLength.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 3 caracteres'**
  String get clientNameMinLength;

  /// No description provided for @clientDocRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el número de documento'**
  String get clientDocRequired;

  /// No description provided for @clientDniError.
  ///
  /// In es, this message translates to:
  /// **'El DNI debe tener 8 dígitos'**
  String get clientDniError;

  /// No description provided for @clientRucError.
  ///
  /// In es, this message translates to:
  /// **'El RUC debe tener 11 dígitos'**
  String get clientRucError;

  /// No description provided for @clientDocInvalid.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get clientDocInvalid;

  /// No description provided for @clientPhoneRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el teléfono de contacto'**
  String get clientPhoneRequired;

  /// No description provided for @clientPhoneError.
  ///
  /// In es, this message translates to:
  /// **'El teléfono debe tener 9 dígitos'**
  String get clientPhoneError;

  /// No description provided for @selectFarmCreateFirst.
  ///
  /// In es, this message translates to:
  /// **'Debes crear una granja antes de registrar una venta'**
  String get selectFarmCreateFirst;

  /// No description provided for @selectFarmLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar granjas'**
  String get selectFarmLoadError;

  /// No description provided for @selectFarmHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una granja'**
  String get selectFarmHint;

  /// No description provided for @selectFarmNoActiveLots.
  ///
  /// In es, this message translates to:
  /// **'Esta granja no tiene lotes activos para registrar ventas'**
  String get selectFarmNoActiveLots;

  /// No description provided for @selectLotHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get selectLotHint;

  /// No description provided for @selectLotLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get selectLotLoadError;

  /// No description provided for @selectProductHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de producto para esta venta'**
  String get selectProductHint;

  /// No description provided for @ventaSheetFaenadoWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso faenado'**
  String get ventaSheetFaenadoWeight;

  /// No description provided for @ventaSheetTotalHuevos.
  ///
  /// In es, this message translates to:
  /// **'Total huevos'**
  String get ventaSheetTotalHuevos;

  /// No description provided for @ventaSheetPollinazaQty.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get ventaSheetPollinazaQty;

  /// No description provided for @ventaSheetUnitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get ventaSheetUnitPrice;

  /// No description provided for @ventaSheetPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get ventaSheetPhone;

  /// No description provided for @ventaDiscountPercent.
  ///
  /// In es, this message translates to:
  /// **'Descuento ({percent}%)'**
  String ventaDiscountPercent(String percent);

  /// No description provided for @ventaEmailSubject.
  ///
  /// In es, this message translates to:
  /// **'Venta - {id}'**
  String ventaEmailSubject(String id);

  /// No description provided for @ventaSaleOf.
  ///
  /// In es, this message translates to:
  /// **'Venta de {product}'**
  String ventaSaleOf(String product);

  /// No description provided for @ventaSemantics.
  ///
  /// In es, this message translates to:
  /// **'Venta de {product}, {client}, estado {status}'**
  String ventaSemantics(String product, String client, String status);

  /// No description provided for @ventaDetailsUds.
  ///
  /// In es, this message translates to:
  /// **'{name} ({count} uds)'**
  String ventaDetailsUds(String name, String count);

  /// No description provided for @ventaPerDozen.
  ///
  /// In es, this message translates to:
  /// **'/docena'**
  String get ventaPerDozen;

  /// No description provided for @ventaEggClassifValue.
  ///
  /// In es, this message translates to:
  /// **'{cantidad} uds ({currency} {precio}/doc)'**
  String ventaEggClassifValue(String currency, String cantidad, String precio);

  /// No description provided for @costoDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de eliminar el costo \"{name}\"?\n\nEsta acción no se puede deshacer.'**
  String costoDeleteConfirm(String name);

  /// No description provided for @costoSemantics.
  ///
  /// In es, this message translates to:
  /// **'Costo {concept}, tipo {type}, monto {amount}'**
  String costoSemantics(String concept, String type, String amount);

  /// No description provided for @costoSheetExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de gasto'**
  String get costoSheetExpenseType;

  /// No description provided for @costoSheetConcept.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get costoSheetConcept;

  /// No description provided for @costoSheetProvider.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get costoSheetProvider;

  /// No description provided for @costoSheetInvoice.
  ///
  /// In es, this message translates to:
  /// **'Nº Factura'**
  String get costoSheetInvoice;

  /// No description provided for @costoSheetRejectionReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo rechazo'**
  String get costoSheetRejectionReason;

  /// No description provided for @costoSheetRegistrationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get costoSheetRegistrationDate;

  /// No description provided for @costoSheetObservations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get costoSheetObservations;

  /// No description provided for @costoAutoFillConcept.
  ///
  /// In es, this message translates to:
  /// **'Compra de {name}'**
  String costoAutoFillConcept(String name);

  /// No description provided for @costoSavedMomentAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace un momento'**
  String get costoSavedMomentAgo;

  /// No description provided for @costoSavedMinAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {min} min'**
  String costoSavedMinAgo(String min);

  /// No description provided for @costoSavedAtTime.
  ///
  /// In es, this message translates to:
  /// **'Guardado a las {time}'**
  String costoSavedAtTime(String time);

  /// No description provided for @costoSelectExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un tipo de gasto'**
  String get costoSelectExpenseType;

  /// No description provided for @costoSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get costoSelectFarm;

  /// No description provided for @costoFieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get costoFieldRequired;

  /// No description provided for @costoInvoiceHint.
  ///
  /// In es, this message translates to:
  /// **'F001-00001234'**
  String get costoInvoiceHint;

  /// No description provided for @costoItemCreated.
  ///
  /// In es, this message translates to:
  /// **'¡Item \"{name}\" creado!'**
  String costoItemCreated(String name);

  /// No description provided for @commonRejected.
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get commonRejected;

  /// No description provided for @commonUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get commonUser;

  /// No description provided for @commonSelectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get commonSelectDate;

  /// No description provided for @commonBirds.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get commonBirds;

  /// No description provided for @commonDays.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get commonDays;

  /// No description provided for @commonSavedAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado {time}'**
  String commonSavedAgo(String time);

  /// No description provided for @commonUserNotAuth.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get commonUserNotAuth;

  /// No description provided for @commonFarmNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'Granja no especificada'**
  String get commonFarmNotSpecified;

  /// No description provided for @commonBatchNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'Lote no especificado'**
  String get commonBatchNotSpecified;

  /// No description provided for @commonWeeksAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {weeks} semana(s)'**
  String commonWeeksAgo(String weeks);

  /// No description provided for @commonMonthsAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {months} mes(es)'**
  String commonMonthsAgo(String months);

  /// No description provided for @commonYearsAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {years} año(s)'**
  String commonYearsAgo(String years);

  /// No description provided for @commonTodayAtTime.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {time}'**
  String commonTodayAtTime(String time);

  /// No description provided for @commonRelativeYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get commonRelativeYesterday;

  /// No description provided for @commonRelativeDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String commonRelativeDaysAgo(String days);

  /// No description provided for @commonAttention.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get commonAttention;

  /// No description provided for @commonCriticalFem.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get commonCriticalFem;

  /// No description provided for @currencyPrefix.
  ///
  /// In es, this message translates to:
  /// **'{currency} '**
  String currencyPrefix(String currency);

  /// No description provided for @currencyAmount.
  ///
  /// In es, this message translates to:
  /// **'{currency} {amount}'**
  String currencyAmount(String currency, String amount);

  /// No description provided for @galponStatCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Total'**
  String get galponStatCapacity;

  /// No description provided for @galponStatTotalBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Totales'**
  String get galponStatTotalBirds;

  /// No description provided for @galponStatOccupancy.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get galponStatOccupancy;

  /// No description provided for @galponBirdDensity.
  ///
  /// In es, this message translates to:
  /// **'Aves/m²'**
  String get galponBirdDensity;

  /// No description provided for @galponCapacityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1000'**
  String get galponCapacityHint;

  /// No description provided for @galponAddTag.
  ///
  /// In es, this message translates to:
  /// **'Agregar etiqueta'**
  String get galponAddTag;

  /// No description provided for @galponSpecCapacityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 10000'**
  String get galponSpecCapacityHint;

  /// No description provided for @galponSpecAreaHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 500'**
  String get galponSpecAreaHint;

  /// No description provided for @galponSpecAreaUnit.
  ///
  /// In es, this message translates to:
  /// **'m²'**
  String get galponSpecAreaUnit;

  /// No description provided for @galponSpecDrinkersHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 50'**
  String get galponSpecDrinkersHint;

  /// No description provided for @galponSpecFeedersHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 50'**
  String get galponSpecFeedersHint;

  /// No description provided for @galponSpecNestsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 100'**
  String get galponSpecNestsHint;

  /// No description provided for @galponEnvTempMinHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 18'**
  String get galponEnvTempMinHint;

  /// No description provided for @galponEnvTempMaxHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 28'**
  String get galponEnvTempMaxHint;

  /// No description provided for @galponEnvHumMinHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 50'**
  String get galponEnvHumMinHint;

  /// No description provided for @galponEnvHumMaxHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 70'**
  String get galponEnvHumMaxHint;

  /// No description provided for @galponEnvVentMinHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 100'**
  String get galponEnvVentMinHint;

  /// No description provided for @galponEnvVentMaxHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 300'**
  String get galponEnvVentMaxHint;

  /// No description provided for @galponEnvVentUnit.
  ///
  /// In es, this message translates to:
  /// **'m³/h'**
  String get galponEnvVentUnit;

  /// No description provided for @galponNA.
  ///
  /// In es, this message translates to:
  /// **'N/A'**
  String get galponNA;

  /// No description provided for @galponAvicola.
  ///
  /// In es, this message translates to:
  /// **'Galpón Avícola'**
  String get galponAvicola;

  /// No description provided for @granjaAvicola.
  ///
  /// In es, this message translates to:
  /// **'Granja Avícola'**
  String get granjaAvicola;

  /// No description provided for @granjaNoAddress.
  ///
  /// In es, this message translates to:
  /// **'Sin dirección'**
  String get granjaNoAddress;

  /// No description provided for @granjaPppm.
  ///
  /// In es, this message translates to:
  /// **'ppm'**
  String get granjaPppm;

  /// No description provided for @granjaRucHint.
  ///
  /// In es, this message translates to:
  /// **'J-12345678-9'**
  String get granjaRucHint;

  /// No description provided for @granjaEngorde.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get granjaEngorde;

  /// No description provided for @granjaPonedora.
  ///
  /// In es, this message translates to:
  /// **'Ponedora'**
  String get granjaPonedora;

  /// No description provided for @granjaReproductor.
  ///
  /// In es, this message translates to:
  /// **'Reproductor'**
  String get granjaReproductor;

  /// No description provided for @granjaAve.
  ///
  /// In es, this message translates to:
  /// **'Ave'**
  String get granjaAve;

  /// No description provided for @granjaActive.
  ///
  /// In es, this message translates to:
  /// **'Activa'**
  String get granjaActive;

  /// No description provided for @granjaInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactiva'**
  String get granjaInactive;

  /// No description provided for @granjaMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get granjaMaintenance;

  /// No description provided for @granjaStatusOperating.
  ///
  /// In es, this message translates to:
  /// **'Operando normalmente'**
  String get granjaStatusOperating;

  /// No description provided for @granjaStatusSuspended.
  ///
  /// In es, this message translates to:
  /// **'Operaciones suspendidas'**
  String get granjaStatusSuspended;

  /// No description provided for @granjaStatusMaintenance.
  ///
  /// In es, this message translates to:
  /// **'En proceso de mantenimiento'**
  String get granjaStatusMaintenance;

  /// No description provided for @granjaMonthAbbr1.
  ///
  /// In es, this message translates to:
  /// **'Ene'**
  String get granjaMonthAbbr1;

  /// No description provided for @granjaMonthAbbr2.
  ///
  /// In es, this message translates to:
  /// **'Feb'**
  String get granjaMonthAbbr2;

  /// No description provided for @granjaMonthAbbr3.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get granjaMonthAbbr3;

  /// No description provided for @granjaMonthAbbr4.
  ///
  /// In es, this message translates to:
  /// **'Abr'**
  String get granjaMonthAbbr4;

  /// No description provided for @granjaMonthAbbr5.
  ///
  /// In es, this message translates to:
  /// **'May'**
  String get granjaMonthAbbr5;

  /// No description provided for @granjaMonthAbbr6.
  ///
  /// In es, this message translates to:
  /// **'Jun'**
  String get granjaMonthAbbr6;

  /// No description provided for @granjaMonthAbbr7.
  ///
  /// In es, this message translates to:
  /// **'Jul'**
  String get granjaMonthAbbr7;

  /// No description provided for @granjaMonthAbbr8.
  ///
  /// In es, this message translates to:
  /// **'Ago'**
  String get granjaMonthAbbr8;

  /// No description provided for @granjaMonthAbbr9.
  ///
  /// In es, this message translates to:
  /// **'Sep'**
  String get granjaMonthAbbr9;

  /// No description provided for @granjaMonthAbbr10.
  ///
  /// In es, this message translates to:
  /// **'Oct'**
  String get granjaMonthAbbr10;

  /// No description provided for @granjaMonthAbbr11.
  ///
  /// In es, this message translates to:
  /// **'Nov'**
  String get granjaMonthAbbr11;

  /// No description provided for @granjaMonthAbbr12.
  ///
  /// In es, this message translates to:
  /// **'Dic'**
  String get granjaMonthAbbr12;

  /// No description provided for @invNewStock.
  ///
  /// In es, this message translates to:
  /// **'Nuevo stock ({unit})'**
  String invNewStock(String unit);

  /// No description provided for @invAdjustReasonHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Inventario físico'**
  String get invAdjustReasonHint;

  /// No description provided for @invErrorEntryRegister.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar entrada de inventario'**
  String get invErrorEntryRegister;

  /// No description provided for @invErrorExitRegister.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar salida de inventario'**
  String get invErrorExitRegister;

  /// No description provided for @invExpiresInDays.
  ///
  /// In es, this message translates to:
  /// **'Vence en {days} días'**
  String invExpiresInDays(String days);

  /// No description provided for @invStockLowAlert.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo (mínimo: {min} {unit})'**
  String invStockLowAlert(String min, String unit);

  /// No description provided for @invStockMinLabel.
  ///
  /// In es, this message translates to:
  /// **'Mínimo: {min} {unit}'**
  String invStockMinLabel(String min, String unit);

  /// No description provided for @invRelativeTodayAt.
  ///
  /// In es, this message translates to:
  /// **'hoy a las {time}'**
  String invRelativeTodayAt(String time);

  /// No description provided for @invRelativeYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get invRelativeYesterday;

  /// No description provided for @invRelativeDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String invRelativeDaysAgo(String days);

  /// No description provided for @invRelativeNow.
  ///
  /// In es, this message translates to:
  /// **'ahora mismo'**
  String get invRelativeNow;

  /// No description provided for @invRelativeSecsAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {secs}s'**
  String invRelativeSecsAgo(String secs);

  /// No description provided for @invRelativeMinsAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {mins}m'**
  String invRelativeMinsAgo(String mins);

  /// No description provided for @invRelativeHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {hours}h'**
  String invRelativeHoursAgo(String hours);

  /// No description provided for @invItemCreated.
  ///
  /// In es, this message translates to:
  /// **'¡Item \"{name}\" creado!'**
  String invItemCreated(String name);

  /// No description provided for @invSkuHelper.
  ///
  /// In es, this message translates to:
  /// **'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.'**
  String get invSkuHelper;

  /// No description provided for @invDetailsOptional.
  ///
  /// In es, this message translates to:
  /// **'Información opcional para mejor control'**
  String get invDetailsOptional;

  /// No description provided for @invTypeSelect.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la categoría del item de inventario'**
  String get invTypeSelect;

  /// No description provided for @invTypeVaccines.
  ///
  /// In es, this message translates to:
  /// **'Vacunas y productos de inmunización'**
  String get invTypeVaccines;

  /// No description provided for @invTypeDisinfectants.
  ///
  /// In es, this message translates to:
  /// **'Productos de limpieza y desinfección'**
  String get invTypeDisinfectants;

  /// No description provided for @invUnitApplication.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get invUnitApplication;

  /// No description provided for @invUnitVolume.
  ///
  /// In es, this message translates to:
  /// **'Volumen'**
  String get invUnitVolume;

  /// No description provided for @loteDaysAge.
  ///
  /// In es, this message translates to:
  /// **'{age} días'**
  String loteDaysAge(String age);

  /// No description provided for @loteWeeksAndDays.
  ///
  /// In es, this message translates to:
  /// **'{weeks} semanas ({days} días)'**
  String loteWeeksAndDays(String weeks, String days);

  /// No description provided for @loteBirdsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String loteBirdsCount(String count);

  /// No description provided for @loteUnitsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} unidades'**
  String loteUnitsCount(String count);

  /// No description provided for @loteCycleDay.
  ///
  /// In es, this message translates to:
  /// **'Día {day} de 45 ({remaining} días restantes)'**
  String loteCycleDay(String day, String remaining);

  /// No description provided for @loteCycleCompleted.
  ///
  /// In es, this message translates to:
  /// **'Día 45 - Ciclo completado'**
  String get loteCycleCompleted;

  /// No description provided for @loteCycleExtra.
  ///
  /// In es, this message translates to:
  /// **'Día {day} ({extra} días extra)'**
  String loteCycleExtra(String day, String extra);

  /// No description provided for @loteFeedUnit.
  ///
  /// In es, this message translates to:
  /// **'kg alimento'**
  String get loteFeedUnit;

  /// No description provided for @loteFeedRef.
  ///
  /// In es, this message translates to:
  /// **'1.6 - 1.8'**
  String get loteFeedRef;

  /// No description provided for @loteCloseOverdue.
  ///
  /// In es, this message translates to:
  /// **'Cierre vencido hace {days} días'**
  String loteCloseOverdue(String days);

  /// No description provided for @loteCloseUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Cierre próximo en {days} días'**
  String loteCloseUpcoming(String days);

  /// No description provided for @loteICAHigh.
  ///
  /// In es, this message translates to:
  /// **'Índice de conversión alto ({value})'**
  String loteICAHigh(String value);

  /// No description provided for @loteDaysCount.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String loteDaysCount(String days);

  /// No description provided for @loteRazaLinea.
  ///
  /// In es, this message translates to:
  /// **'Raza/Línea'**
  String get loteRazaLinea;

  /// No description provided for @loteDaysRemaining.
  ///
  /// In es, this message translates to:
  /// **'Días Restantes'**
  String get loteDaysRemaining;

  /// No description provided for @loteBirdsLabel.
  ///
  /// In es, this message translates to:
  /// **'Aves'**
  String get loteBirdsLabel;

  /// No description provided for @loteEnterValidQty.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una cantidad válida mayor a 0'**
  String get loteEnterValidQty;

  /// No description provided for @loteSelectNewState.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar nuevo estado:'**
  String get loteSelectNewState;

  /// No description provided for @loteConfirmStateChange.
  ///
  /// In es, this message translates to:
  /// **'¿Confirmar cambio a {state}?'**
  String loteConfirmStateChange(String state);

  /// No description provided for @loteStateWarning.
  ///
  /// In es, this message translates to:
  /// **'Este estado es permanente y no podrá revertirse. Los datos del lote se archivarán.'**
  String get loteStateWarning;

  /// No description provided for @loteLocationCode.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get loteLocationCode;

  /// No description provided for @loteLocationMaxCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Máxima'**
  String get loteLocationMaxCapacity;

  /// No description provided for @loteLocationCurrentOccupancy.
  ///
  /// In es, this message translates to:
  /// **'Ocupación Actual'**
  String get loteLocationCurrentOccupancy;

  /// No description provided for @loteLocationCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Actuales'**
  String get loteLocationCurrentBirds;

  /// No description provided for @loteLocationBirdsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String loteLocationBirdsCount(String count);

  /// No description provided for @loteLocationOccupancyLabel.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get loteLocationOccupancyLabel;

  /// No description provided for @loteLocationOccupancyPercent.
  ///
  /// In es, this message translates to:
  /// **'{percent}%'**
  String loteLocationOccupancyPercent(String percent);

  /// No description provided for @loteLocationBirdType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Ave en Galpón'**
  String get loteLocationBirdType;

  /// No description provided for @loteLocationMaxCapacityInfo.
  ///
  /// In es, this message translates to:
  /// **'Capacidad máxima: {count} aves'**
  String loteLocationMaxCapacityInfo(String count);

  /// No description provided for @loteLocationAreaInfo.
  ///
  /// In es, this message translates to:
  /// **'Área: {area} m²'**
  String loteLocationAreaInfo(String area);

  /// No description provided for @loteLocationErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar galpones'**
  String get loteLocationErrorLoading;

  /// No description provided for @loteLocationSharedSpace.
  ///
  /// In es, this message translates to:
  /// **'El nuevo lote compartirá el espacio disponible.'**
  String get loteLocationSharedSpace;

  /// No description provided for @loteTypeLayer.
  ///
  /// In es, this message translates to:
  /// **'Gallinas ponedoras para producción de huevos'**
  String get loteTypeLayer;

  /// No description provided for @loteTypeBroiler.
  ///
  /// In es, this message translates to:
  /// **'Pollos de engorde para producción de carne'**
  String get loteTypeBroiler;

  /// No description provided for @loteTypeHeavyBreeder.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras pesadas para crías'**
  String get loteTypeHeavyBreeder;

  /// No description provided for @loteTypeLightBreeder.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras livianas para crías'**
  String get loteTypeLightBreeder;

  /// No description provided for @loteTypeTurkey.
  ///
  /// In es, this message translates to:
  /// **'Pavos para producción de carne'**
  String get loteTypeTurkey;

  /// No description provided for @loteTypeDuck.
  ///
  /// In es, this message translates to:
  /// **'Patos para producción de carne'**
  String get loteTypeDuck;

  /// No description provided for @loteResumenAge.
  ///
  /// In es, this message translates to:
  /// **'{age} días'**
  String loteResumenAge(String age);

  /// No description provided for @loteResumenWeeks.
  ///
  /// In es, this message translates to:
  /// **'({weeks} sem, {days} días)'**
  String loteResumenWeeks(String weeks, String days);

  /// No description provided for @loteConsumoStockInsufficient.
  ///
  /// In es, this message translates to:
  /// **'Stock insuficiente. Disponible: {stock} kg'**
  String loteConsumoStockInsufficient(String stock);

  /// No description provided for @loteConsumoStockUsage.
  ///
  /// In es, this message translates to:
  /// **'Usarás el {percent}% del stock disponible'**
  String loteConsumoStockUsage(String percent);

  /// No description provided for @loteConsumoRecommended.
  ///
  /// In es, this message translates to:
  /// **'Recomendado para {days} días: {amount}'**
  String loteConsumoRecommended(String days, String amount);

  /// No description provided for @loteConsumoImportantInfo.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get loteConsumoImportantInfo;

  /// No description provided for @loteConsumoAutoCalc.
  ///
  /// In es, this message translates to:
  /// **'Los costos y métricas se calculan automáticamente al registrar el consumo.'**
  String get loteConsumoAutoCalc;

  /// No description provided for @lotePesoEggHint.
  ///
  /// In es, this message translates to:
  /// **'Describe calidad de los huevos, color de cáscara, tamaño, anomalías observadas...'**
  String get lotePesoEggHint;

  /// No description provided for @lotePesoBirdsWeighed.
  ///
  /// In es, this message translates to:
  /// **'Aves pesadas'**
  String get lotePesoBirdsWeighed;

  /// No description provided for @lotePesoGainPerDay.
  ///
  /// In es, this message translates to:
  /// **'{value} g/día'**
  String lotePesoGainPerDay(String value);

  /// No description provided for @lotePesoCV.
  ///
  /// In es, this message translates to:
  /// **'Coeficiente de variación'**
  String get lotePesoCV;

  /// No description provided for @loteConsumoErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar alimentos'**
  String get loteConsumoErrorLoading;

  /// No description provided for @loteLoteDetailEngorde.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de carne'**
  String get loteLoteDetailEngorde;

  /// No description provided for @loteLoteDetailPonedora.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de huevos'**
  String get loteLoteDetailPonedora;

  /// No description provided for @loteLoteDetailRepPesada.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea pesada'**
  String get loteLoteDetailRepPesada;

  /// No description provided for @loteLoteDetailRepLiviana.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea liviana'**
  String get loteLoteDetailRepLiviana;

  /// No description provided for @loteAreaUnit.
  ///
  /// In es, this message translates to:
  /// **'m²'**
  String get loteAreaUnit;

  /// No description provided for @saludDose.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get saludDose;

  /// No description provided for @saludDurationDays.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String saludDurationDays(String days);

  /// No description provided for @saludRegistrationInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de Registro'**
  String get saludRegistrationInfo;

  /// No description provided for @saludLastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get saludLastUpdate;

  /// No description provided for @saludDeleteDetail.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará el registro de \"{name}\". Esta acción no se puede deshacer.'**
  String saludDeleteDetail(String name);

  /// No description provided for @saludUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próxima'**
  String get saludUpcoming;

  /// No description provided for @saludLocationSection.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get saludLocationSection;

  /// No description provided for @saludFarm.
  ///
  /// In es, this message translates to:
  /// **'Granja'**
  String get saludFarm;

  /// No description provided for @saludBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote'**
  String get saludBatch;

  /// No description provided for @saludVaccineInfoSection.
  ///
  /// In es, this message translates to:
  /// **'Información de la Vacuna'**
  String get saludVaccineInfoSection;

  /// No description provided for @saludVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get saludVaccine;

  /// No description provided for @saludApplicationAge.
  ///
  /// In es, this message translates to:
  /// **'Edad Aplicación'**
  String get saludApplicationAge;

  /// No description provided for @saludRoute.
  ///
  /// In es, this message translates to:
  /// **'Vía'**
  String get saludRoute;

  /// No description provided for @saludLaboratory.
  ///
  /// In es, this message translates to:
  /// **'Laboratorio'**
  String get saludLaboratory;

  /// No description provided for @saludVaccineBatch.
  ///
  /// In es, this message translates to:
  /// **'Lote Vacuna'**
  String get saludVaccineBatch;

  /// No description provided for @saludResponsible.
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get saludResponsible;

  /// No description provided for @saludNextApplication.
  ///
  /// In es, this message translates to:
  /// **'Próxima Aplicación'**
  String get saludNextApplication;

  /// No description provided for @saludProgramDescription.
  ///
  /// In es, this message translates to:
  /// **'Programa las vacunas para mantener la salud del lote'**
  String get saludProgramDescription;

  /// No description provided for @saludVacDeleted.
  ///
  /// In es, this message translates to:
  /// **'Vacunación eliminada correctamente'**
  String get saludVacDeleted;

  /// No description provided for @saludRegisterAppDetails.
  ///
  /// In es, this message translates to:
  /// **'Registra los detalles de la aplicación'**
  String get saludRegisterAppDetails;

  /// No description provided for @saludCurrentUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario Actual'**
  String get saludCurrentUser;

  /// No description provided for @saludVacTableVaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get saludVacTableVaccine;

  /// No description provided for @saludVacTableAppDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha aplicación'**
  String get saludVacTableAppDate;

  /// No description provided for @saludVacTableAppAge.
  ///
  /// In es, this message translates to:
  /// **'Edad aplicación'**
  String get saludVacTableAppAge;

  /// No description provided for @saludVacTableNextApp.
  ///
  /// In es, this message translates to:
  /// **'Próxima aplicación'**
  String get saludVacTableNextApp;

  /// No description provided for @saludTreatStepDescLocation.
  ///
  /// In es, this message translates to:
  /// **'Selecciona granja y lote'**
  String get saludTreatStepDescLocation;

  /// No description provided for @saludTreatStepDescDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Información del diagnóstico y síntomas'**
  String get saludTreatStepDescDiagnosis;

  /// No description provided for @saludTreatStepDescTreatment.
  ///
  /// In es, this message translates to:
  /// **'Detalles del tratamiento y medicamentos'**
  String get saludTreatStepDescTreatment;

  /// No description provided for @saludTreatStepDescInfo.
  ///
  /// In es, this message translates to:
  /// **'Veterinario y observaciones adicionales'**
  String get saludTreatStepDescInfo;

  /// No description provided for @saludTreatSavedMoment.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace un momento'**
  String get saludTreatSavedMoment;

  /// No description provided for @saludTreatSavedMin.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {min} min'**
  String saludTreatSavedMin(String min);

  /// No description provided for @saludTreatSavedAt.
  ///
  /// In es, this message translates to:
  /// **'Guardado a las {time}'**
  String saludTreatSavedAt(String time);

  /// No description provided for @saludTreatSelectFarmBatch.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja y un lote'**
  String get saludTreatSelectFarmBatch;

  /// No description provided for @saludTreatDurationRange.
  ///
  /// In es, this message translates to:
  /// **'La duración debe ser entre 1 y 365 días'**
  String get saludTreatDurationRange;

  /// No description provided for @saludTreatFutureDate.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser futura'**
  String get saludTreatFutureDate;

  /// No description provided for @saludVacInventoryWarning.
  ///
  /// In es, this message translates to:
  /// **'Vacunación registrada, pero hubo un error al descontar inventario'**
  String get saludVacInventoryWarning;

  /// No description provided for @saludBioErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos'**
  String get saludBioErrorLoading;

  /// No description provided for @saludBioConfirmSave.
  ///
  /// In es, this message translates to:
  /// **'Se guardará la inspección y se generará el reporte correspondiente.'**
  String get saludBioConfirmSave;

  /// No description provided for @saludBioErrorSaving.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String saludBioErrorSaving(String error);

  /// No description provided for @saludBioTitleGeneral.
  ///
  /// In es, this message translates to:
  /// **'Inspección general de bioseguridad'**
  String get saludBioTitleGeneral;

  /// No description provided for @saludBioTitleByGalpon.
  ///
  /// In es, this message translates to:
  /// **'Inspección de bioseguridad por galpón'**
  String get saludBioTitleByGalpon;

  /// No description provided for @saludBioNotReviewed.
  ///
  /// In es, this message translates to:
  /// **'Aún no se ha revisado.'**
  String get saludBioNotReviewed;

  /// No description provided for @saludBioCompliant.
  ///
  /// In es, this message translates to:
  /// **'Cumplimiento correcto.'**
  String get saludBioCompliant;

  /// No description provided for @saludBioNonCompliant.
  ///
  /// In es, this message translates to:
  /// **'Se detectó incumplimiento.'**
  String get saludBioNonCompliant;

  /// No description provided for @saludBioWithObservations.
  ///
  /// In es, this message translates to:
  /// **'Cumple con observaciones.'**
  String get saludBioWithObservations;

  /// No description provided for @saludBioNotApplicable.
  ///
  /// In es, this message translates to:
  /// **'No corresponde evaluar.'**
  String get saludBioNotApplicable;

  /// No description provided for @saludSwipeHint.
  ///
  /// In es, this message translates to:
  /// **'Desliza para acciones rápidas'**
  String get saludSwipeHint;

  /// No description provided for @saludCatalogMandatoryNotification.
  ///
  /// In es, this message translates to:
  /// **'Notificación obligatoria'**
  String get saludCatalogMandatoryNotification;

  /// No description provided for @saludCatalogCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get saludCatalogCategory;

  /// No description provided for @saludCatalogNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron enfermedades'**
  String get saludCatalogNoResults;

  /// No description provided for @saludCatalogEmpty.
  ///
  /// In es, this message translates to:
  /// **'Catálogo vacío'**
  String get saludCatalogEmpty;

  /// No description provided for @saludCatalogSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otros términos de búsqueda o filtros'**
  String get saludCatalogSearchHint;

  /// No description provided for @saludCatalogGeneralInfo.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get saludCatalogGeneralInfo;

  /// No description provided for @saludCatalogTransmission.
  ///
  /// In es, this message translates to:
  /// **'Transmisión y Diagnóstico'**
  String get saludCatalogTransmission;

  /// No description provided for @saludCatalogMainSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas Principales'**
  String get saludCatalogMainSymptoms;

  /// No description provided for @saludCatalogPostmortem.
  ///
  /// In es, this message translates to:
  /// **'Lesiones Post-mortem'**
  String get saludCatalogPostmortem;

  /// No description provided for @saludCatalogTreatPrevention.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento y Prevención'**
  String get saludCatalogTreatPrevention;

  /// No description provided for @saludCatalogPreventableVax.
  ///
  /// In es, this message translates to:
  /// **'Prevenible por vacunación'**
  String get saludCatalogPreventableVax;

  /// No description provided for @saludCatalogCausativeAgent.
  ///
  /// In es, this message translates to:
  /// **'Agente Causal'**
  String get saludCatalogCausativeAgent;

  /// No description provided for @saludCatalogNotification.
  ///
  /// In es, this message translates to:
  /// **'Notificación'**
  String get saludCatalogNotification;

  /// No description provided for @saludCatalogTransmissionLabel.
  ///
  /// In es, this message translates to:
  /// **'Transmisión'**
  String get saludCatalogTransmissionLabel;

  /// No description provided for @saludCatalogDiagnosisLabel.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get saludCatalogDiagnosisLabel;

  /// No description provided for @saludVacDraftMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String saludVacDraftMessage(String date);

  /// No description provided for @saludVacProgramTitle.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get saludVacProgramTitle;

  /// No description provided for @whatsappHelp.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Necesito ayuda con la app Smart Granja Aves. '**
  String get whatsappHelp;

  /// No description provided for @whatsappReportBug.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Quiero reportar un problema en la app Smart Granja Aves: '**
  String get whatsappReportBug;

  /// No description provided for @whatsappSuggestion.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Tengo una sugerencia para la app Smart Granja Aves: '**
  String get whatsappSuggestion;

  /// No description provided for @whatsappCollaboration.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Estoy interesado en una colaboración con Smart Granja Aves. '**
  String get whatsappCollaboration;

  /// No description provided for @whatsappPricing.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Me gustaría conocer los planes y precios de Smart Granja Aves. '**
  String get whatsappPricing;

  /// No description provided for @whatsappQuery.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Tengo una consulta sobre Smart Granja Aves. '**
  String get whatsappQuery;

  /// No description provided for @homeAppTitle.
  ///
  /// In es, this message translates to:
  /// **'Smart Granja Aves'**
  String get homeAppTitle;

  /// No description provided for @authProBadge.
  ///
  /// In es, this message translates to:
  /// **'PRO'**
  String get authProBadge;

  /// No description provided for @perfilLanguage.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get perfilLanguage;

  /// No description provided for @perfilSyncing.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando'**
  String get perfilSyncing;

  /// No description provided for @perfilAppTitle.
  ///
  /// In es, this message translates to:
  /// **'Smart Granja Aves Pro'**
  String get perfilAppTitle;

  /// No description provided for @reportsPeriod.
  ///
  /// In es, this message translates to:
  /// **'Período: {period}'**
  String reportsPeriod(String period);

  /// No description provided for @reportsDateTo.
  ///
  /// In es, this message translates to:
  /// **'al'**
  String get reportsDateTo;

  /// No description provided for @reportsDateOf.
  ///
  /// In es, this message translates to:
  /// **'de'**
  String get reportsDateOf;

  /// No description provided for @reportsFileName.
  ///
  /// In es, this message translates to:
  /// **'Reporte_{id}.pdf'**
  String reportsFileName(String id);

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get statusConfirmed;

  /// No description provided for @statusSold.
  ///
  /// In es, this message translates to:
  /// **'Vendida'**
  String get statusSold;

  /// No description provided for @statusApproved.
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get statusApproved;

  /// No description provided for @treatStepSelectFarmLotDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona granja y lote'**
  String get treatStepSelectFarmLotDesc;

  /// No description provided for @treatStepDiagnosisInfoDesc.
  ///
  /// In es, this message translates to:
  /// **'Información del diagnóstico y síntomas'**
  String get treatStepDiagnosisInfoDesc;

  /// No description provided for @treatStepTreatmentDetailsDesc.
  ///
  /// In es, this message translates to:
  /// **'Detalles del tratamiento y medicamentos'**
  String get treatStepTreatmentDetailsDesc;

  /// No description provided for @treatStepVetObsDesc.
  ///
  /// In es, this message translates to:
  /// **'Veterinario y observaciones adicionales'**
  String get treatStepVetObsDesc;

  /// No description provided for @saludDeleteConfirmMsg.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará el registro de \"{name}\". Esta acción no se puede deshacer.'**
  String saludDeleteConfirmMsg(String name);

  /// No description provided for @commonDurationDays.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String commonDurationDays(String count);

  /// No description provided for @commonWeeks.
  ///
  /// In es, this message translates to:
  /// **'{count} semanas'**
  String commonWeeks(String count);

  /// No description provided for @vacLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get vacLocationTitle;

  /// No description provided for @vacInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información de la Vacuna'**
  String get vacInfoTitle;

  /// No description provided for @vacVaccineLabel.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get vacVaccineLabel;

  /// No description provided for @vacDoseLabel.
  ///
  /// In es, this message translates to:
  /// **'Dosis'**
  String get vacDoseLabel;

  /// No description provided for @vacRouteShort.
  ///
  /// In es, this message translates to:
  /// **'Vía'**
  String get vacRouteShort;

  /// No description provided for @vacBatchVaccineLabel.
  ///
  /// In es, this message translates to:
  /// **'Lote Vacuna'**
  String get vacBatchVaccineLabel;

  /// No description provided for @vacNextApplicationLabel.
  ///
  /// In es, this message translates to:
  /// **'Próxima Aplicación'**
  String get vacNextApplicationLabel;

  /// No description provided for @vacScheduleTitle.
  ///
  /// In es, this message translates to:
  /// **'Programar Vacunación'**
  String get vacScheduleTitle;

  /// No description provided for @vacDraftFoundMsg.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String vacDraftFoundMsg(String date);

  /// No description provided for @vacDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {days} días'**
  String vacDaysAgo(String days);

  /// No description provided for @vacDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Vacunación eliminada correctamente'**
  String get vacDeletedSuccess;

  /// No description provided for @vacApplyDetails.
  ///
  /// In es, this message translates to:
  /// **'Registra los detalles de la aplicación'**
  String get vacApplyDetails;

  /// No description provided for @vacFilterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get vacFilterAll;

  /// No description provided for @saludInspectionSaveMsg.
  ///
  /// In es, this message translates to:
  /// **'Se guardará la inspección y se generará el reporte correspondiente.'**
  String get saludInspectionSaveMsg;

  /// No description provided for @saludInspGeneralDesc.
  ///
  /// In es, this message translates to:
  /// **'Inspección general de bioseguridad'**
  String get saludInspGeneralDesc;

  /// No description provided for @saludInspShedDesc.
  ///
  /// In es, this message translates to:
  /// **'Inspección de bioseguridad por galpón'**
  String get saludInspShedDesc;

  /// No description provided for @saludCheckNotReviewed.
  ///
  /// In es, this message translates to:
  /// **'Aún no se ha revisado.'**
  String get saludCheckNotReviewed;

  /// No description provided for @saludCheckNonCompliance.
  ///
  /// In es, this message translates to:
  /// **'Se detectó incumplimiento.'**
  String get saludCheckNonCompliance;

  /// No description provided for @commonSwipeActions.
  ///
  /// In es, this message translates to:
  /// **'Desliza para acciones rápidas'**
  String get commonSwipeActions;

  /// No description provided for @commonGalponAvicola.
  ///
  /// In es, this message translates to:
  /// **'Galpón Avícola'**
  String get commonGalponAvicola;

  /// No description provided for @commonCode.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get commonCode;

  /// No description provided for @commonMaxCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Máxima'**
  String get commonMaxCapacity;

  /// No description provided for @commonImportantInfo.
  ///
  /// In es, this message translates to:
  /// **'Información importante'**
  String get commonImportantInfo;

  /// No description provided for @commonCostsAutoCalculated.
  ///
  /// In es, this message translates to:
  /// **'Los costos y métricas se calculan automáticamente según los datos ingresados.'**
  String get commonCostsAutoCalculated;

  /// No description provided for @loteRazaLineaLabel.
  ///
  /// In es, this message translates to:
  /// **'Raza/Línea'**
  String get loteRazaLineaLabel;

  /// No description provided for @loteDiasRestantes.
  ///
  /// In es, this message translates to:
  /// **'Días Restantes'**
  String get loteDiasRestantes;

  /// No description provided for @loteGdpFormat.
  ///
  /// In es, this message translates to:
  /// **'{value} g/día'**
  String loteGdpFormat(String value);

  /// No description provided for @loteCoefVariacion.
  ///
  /// In es, this message translates to:
  /// **'Coeficiente de variación'**
  String get loteCoefVariacion;

  /// No description provided for @loteShedActiveConflict.
  ///
  /// In es, this message translates to:
  /// **'Este galpón ya tiene un lote activo. No es posible asignar más de un lote activo por galpón.'**
  String get loteShedActiveConflict;

  /// No description provided for @commonOptimal.
  ///
  /// In es, this message translates to:
  /// **'Óptimo'**
  String get commonOptimal;

  /// No description provided for @commonCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get commonCritical;

  /// No description provided for @loteCierreVencido.
  ///
  /// In es, this message translates to:
  /// **'Cierre vencido hace {days} días'**
  String loteCierreVencido(String days);

  /// No description provided for @loteCierreProximo.
  ///
  /// In es, this message translates to:
  /// **'Cierre próximo en {days} días'**
  String loteCierreProximo(String days);

  /// No description provided for @loteEdadDias.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String loteEdadDias(String days);

  /// No description provided for @loteEdadSemanasDias.
  ///
  /// In es, this message translates to:
  /// **'{semanas} semanas ({dias} días)'**
  String loteEdadSemanasDias(String semanas, String dias);

  /// No description provided for @loteEdadFormat.
  ///
  /// In es, this message translates to:
  /// **'{edad} ({dias} días)'**
  String loteEdadFormat(String edad, String dias);

  /// No description provided for @invStockBajo.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo (mínimo: {min} {unit})'**
  String invStockBajo(String min, String unit);

  /// No description provided for @invVenceEn.
  ///
  /// In es, this message translates to:
  /// **'Vence en {days} días'**
  String invVenceEn(String days);

  /// No description provided for @invSkuHelp.
  ///
  /// In es, this message translates to:
  /// **'El código/SKU te ayudará a identificar rápidamente el item en tu inventario.'**
  String get invSkuHelp;

  /// No description provided for @invSelectCategory.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la categoría del item de inventario'**
  String get invSelectCategory;

  /// No description provided for @invCatVaccines.
  ///
  /// In es, this message translates to:
  /// **'Vacunas y productos de inmunización'**
  String get invCatVaccines;

  /// No description provided for @invCatDisinfection.
  ///
  /// In es, this message translates to:
  /// **'Productos de limpieza y desinfección'**
  String get invCatDisinfection;

  /// No description provided for @galponTimeToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get galponTimeToday;

  /// No description provided for @galponTimeYesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get galponTimeYesterday;

  /// No description provided for @galponTimeDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {days} días'**
  String galponTimeDaysAgo(String days);

  /// No description provided for @loteEdadRegistro.
  ///
  /// In es, this message translates to:
  /// **'Edad: {days} días'**
  String loteEdadRegistro(String days);

  /// No description provided for @perfilLanguageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get perfilLanguageSpanish;

  /// No description provided for @vacScheduledFormat.
  ///
  /// In es, this message translates to:
  /// **'Programada: {date}'**
  String vacScheduledFormat(String date);

  /// No description provided for @vacAppliedOnFormat.
  ///
  /// In es, this message translates to:
  /// **'Aplicada el {date}'**
  String vacAppliedOnFormat(String date);

  /// No description provided for @vacAppliedDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha aplicación'**
  String get vacAppliedDate;

  /// No description provided for @vacCurrentUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario Actual'**
  String get vacCurrentUser;

  /// No description provided for @vacEmptyDesc.
  ///
  /// In es, this message translates to:
  /// **'Programa las vacunas para mantener la salud del lote'**
  String get vacEmptyDesc;

  /// No description provided for @commonNoFarmSelected.
  ///
  /// In es, this message translates to:
  /// **'No hay granja seleccionada'**
  String get commonNoFarmSelected;

  /// No description provided for @commonErrorDeleting.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String commonErrorDeleting(String error);

  /// No description provided for @commonErrorApplying.
  ///
  /// In es, this message translates to:
  /// **'Error al aplicar vacuna: {error}'**
  String commonErrorApplying(String error);

  /// No description provided for @vacRegisteredInventoryError.
  ///
  /// In es, this message translates to:
  /// **'Vacunación registrada, pero hubo un error al descontar inventario'**
  String get vacRegisteredInventoryError;

  /// No description provided for @commonTimeRightNow.
  ///
  /// In es, this message translates to:
  /// **'ahora mismo'**
  String get commonTimeRightNow;

  /// No description provided for @commonTimeSecondsAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count}s'**
  String commonTimeSecondsAgo(String count);

  /// No description provided for @commonTimeMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count}m'**
  String commonTimeMinutesAgo(String count);

  /// No description provided for @commonTimeHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count}h'**
  String commonTimeHoursAgo(String count);

  /// No description provided for @commonErrorLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar datos'**
  String get commonErrorLoadingData;

  /// No description provided for @saludCheckCompliance.
  ///
  /// In es, this message translates to:
  /// **'Cumplimiento correcto.'**
  String get saludCheckCompliance;

  /// No description provided for @saludCheckPartial.
  ///
  /// In es, this message translates to:
  /// **'Cumple con observaciones.'**
  String get saludCheckPartial;

  /// No description provided for @saludCheckNA.
  ///
  /// In es, this message translates to:
  /// **'No corresponde evaluar.'**
  String get saludCheckNA;

  /// No description provided for @loteProgressCycle.
  ///
  /// In es, this message translates to:
  /// **'Progreso del ciclo'**
  String get loteProgressCycle;

  /// No description provided for @loteDayOfCycle.
  ///
  /// In es, this message translates to:
  /// **'Día {day} de 45 ({remaining} días restantes)'**
  String loteDayOfCycle(String day, String remaining);

  /// No description provided for @loteExtraDays.
  ///
  /// In es, this message translates to:
  /// **'Día {day} ({extra} días extra)'**
  String loteExtraDays(String day, String extra);

  /// No description provided for @loteAttention.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get loteAttention;

  /// No description provided for @loteKeyIndicators.
  ///
  /// In es, this message translates to:
  /// **'Indicadores clave'**
  String get loteKeyIndicators;

  /// No description provided for @loteMortalityHigh.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad elevada ({rate}% > {expected}% esperado)'**
  String loteMortalityHigh(String rate, String expected);

  /// No description provided for @loteWeightBelow.
  ///
  /// In es, this message translates to:
  /// **'Peso por debajo del objetivo ({percent}% menos)'**
  String loteWeightBelow(String percent);

  /// No description provided for @loteTrendNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get loteTrendNormal;

  /// No description provided for @loteTrendAlto.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get loteTrendAlto;

  /// No description provided for @loteTrendExcellent.
  ///
  /// In es, this message translates to:
  /// **'Excelente'**
  String get loteTrendExcellent;

  /// No description provided for @loteTrendElevated.
  ///
  /// In es, this message translates to:
  /// **'Elevada'**
  String get loteTrendElevated;

  /// No description provided for @loteTrendAcceptable.
  ///
  /// In es, this message translates to:
  /// **'Aceptable'**
  String get loteTrendAcceptable;

  /// No description provided for @loteTrendBajo.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get loteTrendBajo;

  /// No description provided for @loteTrendBuena.
  ///
  /// In es, this message translates to:
  /// **'Buena'**
  String get loteTrendBuena;

  /// No description provided for @loteTrendRegular.
  ///
  /// In es, this message translates to:
  /// **'Regular'**
  String get loteTrendRegular;

  /// No description provided for @loteTrendBaja.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get loteTrendBaja;

  /// No description provided for @loteRegister.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get loteRegister;

  /// No description provided for @loteDashSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get loteDashSummary;

  /// No description provided for @batchInitialFlock.
  ///
  /// In es, this message translates to:
  /// **'Parvada inicial'**
  String get batchInitialFlock;

  /// No description provided for @loteCierreEstimado.
  ///
  /// In es, this message translates to:
  /// **'Cierre Estimado'**
  String get loteCierreEstimado;

  /// No description provided for @loteNotRegistered.
  ///
  /// In es, this message translates to:
  /// **'No registrado'**
  String get loteNotRegistered;

  /// No description provided for @loteNotRecorded.
  ///
  /// In es, this message translates to:
  /// **'Not recorded'**
  String get loteNotRecorded;

  /// No description provided for @birdDescPolloEngorde.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de carne'**
  String get birdDescPolloEngorde;

  /// No description provided for @birdDescGallinaPonedora.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de huevos'**
  String get birdDescGallinaPonedora;

  /// No description provided for @birdDescRepPesada.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea pesada'**
  String get birdDescRepPesada;

  /// No description provided for @birdDescRepLiviana.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea liviana'**
  String get birdDescRepLiviana;

  /// No description provided for @birdDescPavo.
  ///
  /// In es, this message translates to:
  /// **'Pavos para carne'**
  String get birdDescPavo;

  /// No description provided for @birdDescCodorniz.
  ///
  /// In es, this message translates to:
  /// **'Codornices para huevos o carne'**
  String get birdDescCodorniz;

  /// No description provided for @birdDescPato.
  ///
  /// In es, this message translates to:
  /// **'Patos para carne'**
  String get birdDescPato;

  /// No description provided for @birdDescOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro tipo de ave'**
  String get birdDescOtro;

  /// No description provided for @birdDescFormPolloEngorde.
  ///
  /// In es, this message translates to:
  /// **'Pollos de engorde para producción de carne'**
  String get birdDescFormPolloEngorde;

  /// No description provided for @birdDescFormGallinaPonedora.
  ///
  /// In es, this message translates to:
  /// **'Gallinas ponedoras para producción de huevos'**
  String get birdDescFormGallinaPonedora;

  /// No description provided for @birdDescFormRepPesada.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras pesadas para crías'**
  String get birdDescFormRepPesada;

  /// No description provided for @birdDescFormRepLiviana.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras livianas para crías'**
  String get birdDescFormRepLiviana;

  /// No description provided for @birdDescFormPavo.
  ///
  /// In es, this message translates to:
  /// **'Pavos para producción de carne'**
  String get birdDescFormPavo;

  /// No description provided for @birdDescFormCodorniz.
  ///
  /// In es, this message translates to:
  /// **'Codornices para huevos o carne'**
  String get birdDescFormCodorniz;

  /// No description provided for @birdDescFormPato.
  ///
  /// In es, this message translates to:
  /// **'Patos para producción de carne'**
  String get birdDescFormPato;

  /// No description provided for @birdDescFormOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro tipo de ave'**
  String get birdDescFormOtro;

  /// No description provided for @loteShedActiveWarning.
  ///
  /// In es, this message translates to:
  /// **'Este galpón ya tiene un lote activo ({code}). El nuevo lote compartirá el espacio disponible.'**
  String loteShedActiveWarning(String code);

  /// No description provided for @ubicacionCurrentOccupation.
  ///
  /// In es, this message translates to:
  /// **'Ocupación Actual'**
  String get ubicacionCurrentOccupation;

  /// No description provided for @ubicacionCurrentBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves Actuales'**
  String get ubicacionCurrentBirds;

  /// No description provided for @ubicacionAvailableCapacity.
  ///
  /// In es, this message translates to:
  /// **'Capacidad Disponible'**
  String get ubicacionAvailableCapacity;

  /// No description provided for @ubicacionOccupation.
  ///
  /// In es, this message translates to:
  /// **'Ocupación'**
  String get ubicacionOccupation;

  /// No description provided for @ubicacionBirdTypeInShed.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Ave en Galpón'**
  String get ubicacionBirdTypeInShed;

  /// No description provided for @ubicacionBirdsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} aves'**
  String ubicacionBirdsCount(String count);

  /// No description provided for @ubicacionCapacityInfo.
  ///
  /// In es, this message translates to:
  /// **'Capacidad máxima: {capacity} aves'**
  String ubicacionCapacityInfo(String capacity);

  /// No description provided for @ubicacionAreaInfo.
  ///
  /// In es, this message translates to:
  /// **'Área: {area} m²'**
  String ubicacionAreaInfo(String area);

  /// No description provided for @commonErrorLoadingShed.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar galpones'**
  String get commonErrorLoadingShed;

  /// No description provided for @consumoSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen del Consumo'**
  String get consumoSummaryTitle;

  /// No description provided for @consumoSummarySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos y agrega observaciones'**
  String get consumoSummarySubtitle;

  /// No description provided for @consumoObsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Aves con buen apetito, alimento bien recibido...'**
  String get consumoObsHint;

  /// No description provided for @invBasicInfoSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa los datos principales del item'**
  String get invBasicInfoSubtitle;

  /// No description provided for @invOptionalDetails.
  ///
  /// In es, this message translates to:
  /// **'Información opcional para mejor control'**
  String get invOptionalDetails;

  /// No description provided for @invOptionalDetailsInfo.
  ///
  /// In es, this message translates to:
  /// **'Estos datos son opcionales pero ayudan a un mejor control y trazabilidad del inventario.'**
  String get invOptionalDetailsInfo;

  /// No description provided for @invCatInsumo.
  ///
  /// In es, this message translates to:
  /// **'Materiales de cama, desinfectantes y otros insumos'**
  String get invCatInsumo;

  /// No description provided for @invImageReady.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get invImageReady;

  /// No description provided for @invCanAddPhoto.
  ///
  /// In es, this message translates to:
  /// **'Puedes agregar una foto del producto'**
  String get invCanAddPhoto;

  /// No description provided for @loteFormatDays.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String loteFormatDays(String count);

  /// No description provided for @loteFormatWeek.
  ///
  /// In es, this message translates to:
  /// **'{count} semana'**
  String loteFormatWeek(String count);

  /// No description provided for @loteFormatWeeks.
  ///
  /// In es, this message translates to:
  /// **'{count} semanas'**
  String loteFormatWeeks(String count);

  /// No description provided for @loteFormatMonth.
  ///
  /// In es, this message translates to:
  /// **'{count} mes'**
  String loteFormatMonth(String count);

  /// No description provided for @loteFormatMonths.
  ///
  /// In es, this message translates to:
  /// **'{count} meses'**
  String loteFormatMonths(String count);

  /// No description provided for @loteFormatWeeksShort.
  ///
  /// In es, this message translates to:
  /// **'{count} sem'**
  String loteFormatWeeksShort(String count);

  /// No description provided for @loteTrendOptimal.
  ///
  /// In es, this message translates to:
  /// **'Óptimo'**
  String get loteTrendOptimal;

  /// No description provided for @loteTrendCritical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get loteTrendCritical;

  /// No description provided for @loteTrendCritica.
  ///
  /// In es, this message translates to:
  /// **'Crítica'**
  String get loteTrendCritica;

  /// No description provided for @loteFeedKg.
  ///
  /// In es, this message translates to:
  /// **'kg alimento'**
  String get loteFeedKg;

  /// No description provided for @loteFormatMonthAndWeeksShort.
  ///
  /// In es, this message translates to:
  /// **'{months} mes y {weeks} sem'**
  String loteFormatMonthAndWeeksShort(String months, String weeks);

  /// No description provided for @loteFormatMonthsAndWeeksShort.
  ///
  /// In es, this message translates to:
  /// **'{months} meses y {weeks} sem'**
  String loteFormatMonthsAndWeeksShort(String months, String weeks);

  /// No description provided for @loteResumenWeeksDays.
  ///
  /// In es, this message translates to:
  /// **' ({weeks} sem, {days} días)'**
  String loteResumenWeeksDays(String weeks, String days);

  /// No description provided for @loteResumenWeeksParens.
  ///
  /// In es, this message translates to:
  /// **' ({weeks} semanas)'**
  String loteResumenWeeksParens(String weeks);

  /// No description provided for @invCatLimpieza.
  ///
  /// In es, this message translates to:
  /// **'Productos de limpieza y desinfección'**
  String get invCatLimpieza;

  /// No description provided for @invHintExample.
  ///
  /// In es, this message translates to:
  /// **'Ej: Concentrado Iniciador'**
  String get invHintExample;

  /// No description provided for @commonArea.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get commonArea;

  /// No description provided for @invStockInfoFormat.
  ///
  /// In es, this message translates to:
  /// **'Stock actual: {stock} {unit}'**
  String invStockInfoFormat(String stock, String unit);

  /// No description provided for @invMotiveHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Inventario físico'**
  String get invMotiveHint;

  /// No description provided for @ubicacionShedDropdown.
  ///
  /// In es, this message translates to:
  /// **'{code} - Capacidad: {capacity} aves'**
  String ubicacionShedDropdown(String code, String capacity);

  /// No description provided for @invDraftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String invDraftFoundMessage(String date);

  /// No description provided for @catalogDiseaseNotifRequired.
  ///
  /// In es, this message translates to:
  /// **'Notificación obligatoria'**
  String get catalogDiseaseNotifRequired;

  /// No description provided for @catalogDiseaseVaccinable.
  ///
  /// In es, this message translates to:
  /// **'Vacunable'**
  String get catalogDiseaseVaccinable;

  /// No description provided for @commonCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get commonCategory;

  /// No description provided for @catalogDiseaseSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas'**
  String get catalogDiseaseSymptoms;

  /// No description provided for @catalogDiseaseSeverity.
  ///
  /// In es, this message translates to:
  /// **'Gravedad'**
  String get catalogDiseaseSeverity;

  /// No description provided for @catalogDiseaseNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron enfermedades'**
  String get catalogDiseaseNotFound;

  /// No description provided for @catalogDiseaseEmpty.
  ///
  /// In es, this message translates to:
  /// **'Catálogo vacío'**
  String get catalogDiseaseEmpty;

  /// No description provided for @catalogDiseaseSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otros términos de búsqueda o filtros'**
  String get catalogDiseaseSearchHint;

  /// No description provided for @catalogDiseaseNone.
  ///
  /// In es, this message translates to:
  /// **'No hay enfermedades registradas'**
  String get catalogDiseaseNone;

  /// No description provided for @catalogDiseaseInfoGeneral.
  ///
  /// In es, this message translates to:
  /// **'Información General'**
  String get catalogDiseaseInfoGeneral;

  /// No description provided for @catalogDiseaseTransDiag.
  ///
  /// In es, this message translates to:
  /// **'Transmisión y Diagnóstico'**
  String get catalogDiseaseTransDiag;

  /// No description provided for @catalogDiseaseMainSymptoms.
  ///
  /// In es, this message translates to:
  /// **'Síntomas Principales'**
  String get catalogDiseaseMainSymptoms;

  /// No description provided for @catalogDiseasePostmortem.
  ///
  /// In es, this message translates to:
  /// **'Lesiones Post-mortem'**
  String get catalogDiseasePostmortem;

  /// No description provided for @catalogDiseaseTreatPrev.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento y Prevención'**
  String get catalogDiseaseTreatPrev;

  /// No description provided for @catalogDiseaseNotifOblig.
  ///
  /// In es, this message translates to:
  /// **'Notificación Obligatoria'**
  String get catalogDiseaseNotifOblig;

  /// No description provided for @catalogDiseaseVaccinePrevent.
  ///
  /// In es, this message translates to:
  /// **'Prevenible por vacunación'**
  String get catalogDiseaseVaccinePrevent;

  /// No description provided for @catalogDiseaseCausalAgent.
  ///
  /// In es, this message translates to:
  /// **'Agente Causal'**
  String get catalogDiseaseCausalAgent;

  /// No description provided for @catalogDiseaseContagious.
  ///
  /// In es, this message translates to:
  /// **'Contagiosa'**
  String get catalogDiseaseContagious;

  /// No description provided for @catalogDiseaseNotification.
  ///
  /// In es, this message translates to:
  /// **'Notificación'**
  String get catalogDiseaseNotification;

  /// No description provided for @catalogDiseaseVaccineAvail.
  ///
  /// In es, this message translates to:
  /// **'Vacuna Disponible'**
  String get catalogDiseaseVaccineAvail;

  /// No description provided for @catalogDiseaseTransmission.
  ///
  /// In es, this message translates to:
  /// **'Transmisión'**
  String get catalogDiseaseTransmission;

  /// No description provided for @catalogDiseaseDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get catalogDiseaseDiagnosis;

  /// No description provided for @catalogDiseaseViewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver Detalles'**
  String get catalogDiseaseViewDetails;

  /// No description provided for @catalogDiseaseConsultVet.
  ///
  /// In es, this message translates to:
  /// **'Consulte con su veterinario'**
  String get catalogDiseaseConsultVet;

  /// No description provided for @batchSelectNewStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar nuevo estado:'**
  String get batchSelectNewStatusLabel;

  /// No description provided for @batchConfirmStatusChange.
  ///
  /// In es, this message translates to:
  /// **'¿Confirmar cambio a {status}?'**
  String batchConfirmStatusChange(String status);

  /// No description provided for @batchPermanentStatusWarning.
  ///
  /// In es, this message translates to:
  /// **'Este estado es permanente y no podrá revertirse. El lote no podrá cambiar a ningún otro estado después de esta acción.'**
  String get batchPermanentStatusWarning;

  /// No description provided for @batchPermanentStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado permanente'**
  String get batchPermanentStatus;

  /// No description provided for @batchTypePoultryDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de carne'**
  String get batchTypePoultryDesc;

  /// No description provided for @batchTypeLayersDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves criadas para producción de huevos'**
  String get batchTypeLayersDesc;

  /// No description provided for @batchTypeHeavyBreedersDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea pesada'**
  String get batchTypeHeavyBreedersDesc;

  /// No description provided for @batchTypeLightBreedersDesc.
  ///
  /// In es, this message translates to:
  /// **'Aves reproductoras de línea liviana'**
  String get batchTypeLightBreedersDesc;

  /// No description provided for @batchTypeTurkeysDesc.
  ///
  /// In es, this message translates to:
  /// **'Pavos para carne'**
  String get batchTypeTurkeysDesc;

  /// No description provided for @batchTypeQuailDesc.
  ///
  /// In es, this message translates to:
  /// **'Codornices para huevos o carne'**
  String get batchTypeQuailDesc;

  /// No description provided for @batchTypeDucksDesc.
  ///
  /// In es, this message translates to:
  /// **'Patos para carne'**
  String get batchTypeDucksDesc;

  /// No description provided for @batchTypeOtherDesc.
  ///
  /// In es, this message translates to:
  /// **'Otro tipo de ave'**
  String get batchTypeOtherDesc;

  /// No description provided for @batchNotRecorded.
  ///
  /// In es, this message translates to:
  /// **'No registrado'**
  String get batchNotRecorded;

  /// No description provided for @commonBirdsUnit.
  ///
  /// In es, this message translates to:
  /// **'aves'**
  String get commonBirdsUnit;

  /// No description provided for @batchAgeDaysValue.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String batchAgeDaysValue(String count);

  /// No description provided for @batchAgeWeeksDaysValue.
  ///
  /// In es, this message translates to:
  /// **'{weeks} semanas ({days} días)'**
  String batchAgeWeeksDaysValue(String weeks, String days);

  /// No description provided for @costExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de gasto'**
  String get costExpenseType;

  /// No description provided for @costProvider.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get costProvider;

  /// No description provided for @costRejectionReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo rechazo'**
  String get costRejectionReason;

  /// No description provided for @weightBirdsWeighed.
  ///
  /// In es, this message translates to:
  /// **'Aves pesadas'**
  String get weightBirdsWeighed;

  /// No description provided for @weightTotal.
  ///
  /// In es, this message translates to:
  /// **'Peso total'**
  String get weightTotal;

  /// No description provided for @weightDailyGain.
  ///
  /// In es, this message translates to:
  /// **'GDP (Ganancia diaria)'**
  String get weightDailyGain;

  /// No description provided for @weightGramsPerDay.
  ///
  /// In es, this message translates to:
  /// **'g/día'**
  String get weightGramsPerDay;

  /// No description provided for @feedExceedsStock.
  ///
  /// In es, this message translates to:
  /// **'La cantidad excede el stock disponible ({stock} kg)'**
  String feedExceedsStock(String stock);

  /// No description provided for @feedStockPercentUsage.
  ///
  /// In es, this message translates to:
  /// **'Usarás el {percent}% del stock disponible'**
  String feedStockPercentUsage(String percent);

  /// No description provided for @feedRecommendedForDays.
  ///
  /// In es, this message translates to:
  /// **'Recomendado para {days} días: {type}'**
  String feedRecommendedForDays(String days, String type);

  /// No description provided for @feedConsumptionDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del consumo'**
  String get feedConsumptionDate;

  /// No description provided for @feedObsTitle.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get feedObsTitle;

  /// No description provided for @feedObsOptionalHint.
  ///
  /// In es, this message translates to:
  /// **'Opcional: Agrega notas adicionales'**
  String get feedObsOptionalHint;

  /// No description provided for @feedObsDescribeHint.
  ///
  /// In es, this message translates to:
  /// **'Describe condiciones del suministro, comportamiento de las aves, calidad del alimento, etc.'**
  String get feedObsDescribeHint;

  /// No description provided for @feedObsHelpText.
  ///
  /// In es, this message translates to:
  /// **'Las observaciones ayudan a documentar detalles importantes del suministro de alimento y pueden ser útiles para análisis futuros.'**
  String get feedObsHelpText;

  /// No description provided for @ventaSelectBatchHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un lote'**
  String get ventaSelectBatchHint;

  /// No description provided for @ventaBatchLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar lotes'**
  String get ventaBatchLoadError;

  /// No description provided for @saludRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'Registrado por'**
  String get saludRegisteredBy;

  /// No description provided for @saludCloseTreatment.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Tratamiento'**
  String get saludCloseTreatment;

  /// No description provided for @saludResultOptional.
  ///
  /// In es, this message translates to:
  /// **'Resultado (Opcional)'**
  String get saludResultOptional;

  /// No description provided for @saludMonthNames.
  ///
  /// In es, this message translates to:
  /// **'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre'**
  String get saludMonthNames;

  /// No description provided for @saludDateConnector.
  ///
  /// In es, this message translates to:
  /// **'de'**
  String get saludDateConnector;

  /// No description provided for @treatDurationValidation.
  ///
  /// In es, this message translates to:
  /// **'La duración debe ser entre 1 y 365 días'**
  String get treatDurationValidation;

  /// No description provided for @commonDateCannotBeFuture.
  ///
  /// In es, this message translates to:
  /// **'La fecha no puede ser futura'**
  String get commonDateCannotBeFuture;

  /// No description provided for @treatNewTreatment.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Tratamiento'**
  String get treatNewTreatment;

  /// No description provided for @commonSaveAction.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get commonSaveAction;

  /// No description provided for @costRegisteredInventoryError.
  ///
  /// In es, this message translates to:
  /// **'Costo registrado, pero hubo un error al actualizar inventario'**
  String get costRegisteredInventoryError;

  /// No description provided for @invStockActualLabel.
  ///
  /// In es, this message translates to:
  /// **'Actual: {stock} {unit}'**
  String invStockActualLabel(String stock, String unit);

  /// No description provided for @invStockMinimoLabel.
  ///
  /// In es, this message translates to:
  /// **'Mínimo: {stock} {unit}'**
  String invStockMinimoLabel(String stock, String unit);

  /// No description provided for @invEntryError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar entrada de inventario'**
  String get invEntryError;

  /// No description provided for @invExitError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar salida de inventario'**
  String get invExitError;

  /// No description provided for @feedLoadingItems.
  ///
  /// In es, this message translates to:
  /// **'Cargando alimentos...'**
  String get feedLoadingItems;

  /// No description provided for @feedLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar alimentos'**
  String get feedLoadError;

  /// No description provided for @photoNoPhotosAdded.
  ///
  /// In es, this message translates to:
  /// **'No hay fotos agregadas'**
  String get photoNoPhotosAdded;

  /// No description provided for @photoMax5Hint.
  ///
  /// In es, this message translates to:
  /// **'Puedes agregar hasta 5 fotos'**
  String get photoMax5Hint;

  /// No description provided for @farmPoultryFarm.
  ///
  /// In es, this message translates to:
  /// **'Granja Avícola'**
  String get farmPoultryFarm;

  /// No description provided for @farmNoAddress.
  ///
  /// In es, this message translates to:
  /// **'Sin dirección'**
  String get farmNoAddress;

  /// No description provided for @shedAddTagHint.
  ///
  /// In es, this message translates to:
  /// **'Agregar etiqueta'**
  String get shedAddTagHint;

  /// No description provided for @shedCapacityHintExample.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1000'**
  String get shedCapacityHintExample;

  /// No description provided for @prodObsHint.
  ///
  /// In es, this message translates to:
  /// **'Describe calidad de los huevos, color de cáscara, condiciones ambientales, comportamiento de las aves, etc.'**
  String get prodObsHint;

  /// No description provided for @commonAge.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get commonAge;

  /// No description provided for @batchQuantityValidation.
  ///
  /// In es, this message translates to:
  /// **'Ingrese una cantidad válida mayor a 0'**
  String get batchQuantityValidation;

  /// No description provided for @invStockBajoMinimo.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo (mínimo: {min} {unit})'**
  String invStockBajoMinimo(String min, String unit);

  /// No description provided for @reportsPeriodLabel.
  ///
  /// In es, this message translates to:
  /// **'Período: {period}'**
  String reportsPeriodLabel(String period);

  /// No description provided for @reportsPeriodSameMonth.
  ///
  /// In es, this message translates to:
  /// **'{dayStart} al {dayEnd} de {month} {year}'**
  String reportsPeriodSameMonth(
    String dayStart,
    String dayEnd,
    String month,
    String year,
  );

  /// No description provided for @reportsPeriodSameYear.
  ///
  /// In es, this message translates to:
  /// **'{dayStart} de {monthStart} al {dayEnd} de {monthEnd}, {year}'**
  String reportsPeriodSameYear(
    String dayStart,
    String monthStart,
    String dayEnd,
    String monthEnd,
    String year,
  );

  /// No description provided for @reportsPeriodDateRange.
  ///
  /// In es, this message translates to:
  /// **'{start} al {end}'**
  String reportsPeriodDateRange(String start, String end);

  /// No description provided for @batchShareCode.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get batchShareCode;

  /// No description provided for @batchShareType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get batchShareType;

  /// No description provided for @batchShareBreed.
  ///
  /// In es, this message translates to:
  /// **'Raza'**
  String get batchShareBreed;

  /// No description provided for @batchShareStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get batchShareStatus;

  /// No description provided for @batchShareBirds.
  ///
  /// In es, this message translates to:
  /// **'Aves'**
  String get batchShareBirds;

  /// No description provided for @batchShareEntry.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get batchShareEntry;

  /// No description provided for @batchShareAge.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get batchShareAge;

  /// No description provided for @batchShareWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get batchShareWeight;

  /// No description provided for @batchShareMortality.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get batchShareMortality;

  /// No description provided for @batchShareBirdsFormat.
  ///
  /// In es, this message translates to:
  /// **'{current} de {total}'**
  String batchShareBirdsFormat(String current, String total);

  /// No description provided for @enumTipoAlimentoPreIniciador.
  ///
  /// In es, this message translates to:
  /// **'Pre-iniciador'**
  String get enumTipoAlimentoPreIniciador;

  /// No description provided for @enumTipoAlimentoIniciador.
  ///
  /// In es, this message translates to:
  /// **'Iniciador'**
  String get enumTipoAlimentoIniciador;

  /// No description provided for @enumTipoAlimentoCrecimiento.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento'**
  String get enumTipoAlimentoCrecimiento;

  /// No description provided for @enumTipoAlimentoFinalizador.
  ///
  /// In es, this message translates to:
  /// **'Finalizador'**
  String get enumTipoAlimentoFinalizador;

  /// No description provided for @enumTipoAlimentoPostura.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get enumTipoAlimentoPostura;

  /// No description provided for @enumTipoAlimentoLevante.
  ///
  /// In es, this message translates to:
  /// **'Levante'**
  String get enumTipoAlimentoLevante;

  /// No description provided for @enumTipoAlimentoMedicado.
  ///
  /// In es, this message translates to:
  /// **'Medicado'**
  String get enumTipoAlimentoMedicado;

  /// No description provided for @enumTipoAlimentoConcentrado.
  ///
  /// In es, this message translates to:
  /// **'Concentrado'**
  String get enumTipoAlimentoConcentrado;

  /// No description provided for @enumTipoAlimentoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get enumTipoAlimentoOtro;

  /// No description provided for @enumTipoAlimentoDescPreIniciador.
  ///
  /// In es, this message translates to:
  /// **'Pre-iniciador (0-7 días)'**
  String get enumTipoAlimentoDescPreIniciador;

  /// No description provided for @enumTipoAlimentoDescIniciador.
  ///
  /// In es, this message translates to:
  /// **'Iniciador (8-21 días)'**
  String get enumTipoAlimentoDescIniciador;

  /// No description provided for @enumTipoAlimentoDescCrecimiento.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento (22-35 días)'**
  String get enumTipoAlimentoDescCrecimiento;

  /// No description provided for @enumTipoAlimentoDescFinalizador.
  ///
  /// In es, this message translates to:
  /// **'Finalizador (36+ días)'**
  String get enumTipoAlimentoDescFinalizador;

  /// No description provided for @enumTipoAlimentoRangoPreIniciador.
  ///
  /// In es, this message translates to:
  /// **'0-7 días'**
  String get enumTipoAlimentoRangoPreIniciador;

  /// No description provided for @enumTipoAlimentoRangoIniciador.
  ///
  /// In es, this message translates to:
  /// **'8-21 días'**
  String get enumTipoAlimentoRangoIniciador;

  /// No description provided for @enumTipoAlimentoRangoCrecimiento.
  ///
  /// In es, this message translates to:
  /// **'22-35 días'**
  String get enumTipoAlimentoRangoCrecimiento;

  /// No description provided for @enumTipoAlimentoRangoFinalizador.
  ///
  /// In es, this message translates to:
  /// **'36+ días'**
  String get enumTipoAlimentoRangoFinalizador;

  /// No description provided for @enumTipoAlimentoRangoPostura.
  ///
  /// In es, this message translates to:
  /// **'Gallinas ponedoras'**
  String get enumTipoAlimentoRangoPostura;

  /// No description provided for @enumTipoAlimentoRangoLevante.
  ///
  /// In es, this message translates to:
  /// **'Pollitas reemplazo'**
  String get enumTipoAlimentoRangoLevante;

  /// No description provided for @enumMetodoPesajeManual.
  ///
  /// In es, this message translates to:
  /// **'Manual'**
  String get enumMetodoPesajeManual;

  /// No description provided for @enumMetodoPesajeBasculaIndividual.
  ///
  /// In es, this message translates to:
  /// **'Báscula Individual'**
  String get enumMetodoPesajeBasculaIndividual;

  /// No description provided for @enumMetodoPesajeBasculaLote.
  ///
  /// In es, this message translates to:
  /// **'Báscula de Lote'**
  String get enumMetodoPesajeBasculaLote;

  /// No description provided for @enumMetodoPesajeAutomatica.
  ///
  /// In es, this message translates to:
  /// **'Automática'**
  String get enumMetodoPesajeAutomatica;

  /// No description provided for @enumMetodoPesajeDescManual.
  ///
  /// In es, this message translates to:
  /// **'Manual con báscula'**
  String get enumMetodoPesajeDescManual;

  /// No description provided for @enumMetodoPesajeDescBasculaIndividual.
  ///
  /// In es, this message translates to:
  /// **'Báscula individual'**
  String get enumMetodoPesajeDescBasculaIndividual;

  /// No description provided for @enumMetodoPesajeDescBasculaLote.
  ///
  /// In es, this message translates to:
  /// **'Báscula de lote'**
  String get enumMetodoPesajeDescBasculaLote;

  /// No description provided for @enumMetodoPesajeDescAutomatica.
  ///
  /// In es, this message translates to:
  /// **'Sistema automático'**
  String get enumMetodoPesajeDescAutomatica;

  /// No description provided for @enumMetodoPesajeDetalleManual.
  ///
  /// In es, this message translates to:
  /// **'Pesaje ave por ave con báscula portátil'**
  String get enumMetodoPesajeDetalleManual;

  /// No description provided for @enumMetodoPesajeDetalleBasculaIndividual.
  ///
  /// In es, this message translates to:
  /// **'Báscula electrónica para una ave'**
  String get enumMetodoPesajeDetalleBasculaIndividual;

  /// No description provided for @enumMetodoPesajeDetalleBasculaLote.
  ///
  /// In es, this message translates to:
  /// **'Pesaje grupal dividido entre cantidad'**
  String get enumMetodoPesajeDetalleBasculaLote;

  /// No description provided for @enumMetodoPesajeDetalleAutomatica.
  ///
  /// In es, this message translates to:
  /// **'Sistema automatizado integrado'**
  String get enumMetodoPesajeDetalleAutomatica;

  /// No description provided for @enumCausaMortEnfermedad.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad'**
  String get enumCausaMortEnfermedad;

  /// No description provided for @enumCausaMortAccidente.
  ///
  /// In es, this message translates to:
  /// **'Accidente'**
  String get enumCausaMortAccidente;

  /// No description provided for @enumCausaMortDesnutricion.
  ///
  /// In es, this message translates to:
  /// **'Desnutrición'**
  String get enumCausaMortDesnutricion;

  /// No description provided for @enumCausaMortEstres.
  ///
  /// In es, this message translates to:
  /// **'Estrés'**
  String get enumCausaMortEstres;

  /// No description provided for @enumCausaMortMetabolica.
  ///
  /// In es, this message translates to:
  /// **'Metabólica'**
  String get enumCausaMortMetabolica;

  /// No description provided for @enumCausaMortDepredacion.
  ///
  /// In es, this message translates to:
  /// **'Depredación'**
  String get enumCausaMortDepredacion;

  /// No description provided for @enumCausaMortSacrificio.
  ///
  /// In es, this message translates to:
  /// **'Sacrificio'**
  String get enumCausaMortSacrificio;

  /// No description provided for @enumCausaMortVejez.
  ///
  /// In es, this message translates to:
  /// **'Vejez'**
  String get enumCausaMortVejez;

  /// No description provided for @enumCausaMortDesconocida.
  ///
  /// In es, this message translates to:
  /// **'Desconocida'**
  String get enumCausaMortDesconocida;

  /// No description provided for @enumCausaMortDescEnfermedad.
  ///
  /// In es, this message translates to:
  /// **'Patología infecciosa'**
  String get enumCausaMortDescEnfermedad;

  /// No description provided for @enumCausaMortDescAccidente.
  ///
  /// In es, this message translates to:
  /// **'Trauma o lesión'**
  String get enumCausaMortDescAccidente;

  /// No description provided for @enumCausaMortDescDesnutricion.
  ///
  /// In es, this message translates to:
  /// **'Falta de nutrientes'**
  String get enumCausaMortDescDesnutricion;

  /// No description provided for @enumCausaMortDescEstres.
  ///
  /// In es, this message translates to:
  /// **'Factores ambientales'**
  String get enumCausaMortDescEstres;

  /// No description provided for @enumCausaMortDescMetabolica.
  ///
  /// In es, this message translates to:
  /// **'Problemas fisiológicos'**
  String get enumCausaMortDescMetabolica;

  /// No description provided for @enumCausaMortDescDepredacion.
  ///
  /// In es, this message translates to:
  /// **'Ataques de animales'**
  String get enumCausaMortDescDepredacion;

  /// No description provided for @enumCausaMortDescSacrificio.
  ///
  /// In es, this message translates to:
  /// **'Muerte en faena'**
  String get enumCausaMortDescSacrificio;

  /// No description provided for @enumCausaMortDescVejez.
  ///
  /// In es, this message translates to:
  /// **'Fin de vida productiva'**
  String get enumCausaMortDescVejez;

  /// No description provided for @enumCausaMortDescDesconocida.
  ///
  /// In es, this message translates to:
  /// **'Causa no identificada'**
  String get enumCausaMortDescDesconocida;

  /// No description provided for @enumTipoAlimentoRangoMedicado.
  ///
  /// In es, this message translates to:
  /// **'Con tratamiento'**
  String get enumTipoAlimentoRangoMedicado;

  /// No description provided for @enumTipoAlimentoRangoConcentrado.
  ///
  /// In es, this message translates to:
  /// **'Suplemento'**
  String get enumTipoAlimentoRangoConcentrado;

  /// No description provided for @enumTipoAlimentoRangoOtro.
  ///
  /// In es, this message translates to:
  /// **'Uso general'**
  String get enumTipoAlimentoRangoOtro;

  /// No description provided for @enumTipoAlimentoDescPostura.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get enumTipoAlimentoDescPostura;

  /// No description provided for @enumTipoAlimentoDescLevante.
  ///
  /// In es, this message translates to:
  /// **'Levante'**
  String get enumTipoAlimentoDescLevante;

  /// No description provided for @enumTipoAlimentoDescMedicado.
  ///
  /// In es, this message translates to:
  /// **'Medicado'**
  String get enumTipoAlimentoDescMedicado;

  /// No description provided for @enumTipoAlimentoDescConcentrado.
  ///
  /// In es, this message translates to:
  /// **'Concentrado'**
  String get enumTipoAlimentoDescConcentrado;

  /// No description provided for @enumTipoAlimentoDescOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get enumTipoAlimentoDescOtro;

  /// No description provided for @errorSavingGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String errorSavingGeneric(String error);

  /// No description provided for @errorDeletingGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String errorDeletingGeneric(String error);

  /// No description provided for @errorUserNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get errorUserNotAuthenticated;

  /// No description provided for @errorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @enumTipoAvePolloEngorde.
  ///
  /// In es, this message translates to:
  /// **'Pollo de Engorde'**
  String get enumTipoAvePolloEngorde;

  /// No description provided for @enumTipoAveGallinaPonedora.
  ///
  /// In es, this message translates to:
  /// **'Gallina Ponedora'**
  String get enumTipoAveGallinaPonedora;

  /// No description provided for @enumTipoAveReproductoraPesada.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Pesada'**
  String get enumTipoAveReproductoraPesada;

  /// No description provided for @enumTipoAveReproductoraLiviana.
  ///
  /// In es, this message translates to:
  /// **'Reproductora Liviana'**
  String get enumTipoAveReproductoraLiviana;

  /// No description provided for @enumTipoAvePavo.
  ///
  /// In es, this message translates to:
  /// **'Pavo'**
  String get enumTipoAvePavo;

  /// No description provided for @enumTipoAveCodorniz.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get enumTipoAveCodorniz;

  /// No description provided for @enumTipoAvePato.
  ///
  /// In es, this message translates to:
  /// **'Pato'**
  String get enumTipoAvePato;

  /// No description provided for @enumTipoAveOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get enumTipoAveOtro;

  /// No description provided for @enumTipoAveShortPolloEngorde.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get enumTipoAveShortPolloEngorde;

  /// No description provided for @enumTipoAveShortGallinaPonedora.
  ///
  /// In es, this message translates to:
  /// **'Ponedora'**
  String get enumTipoAveShortGallinaPonedora;

  /// No description provided for @enumTipoAveShortReproductoraPesada.
  ///
  /// In es, this message translates to:
  /// **'Rep. Pesada'**
  String get enumTipoAveShortReproductoraPesada;

  /// No description provided for @enumTipoAveShortReproductoraLiviana.
  ///
  /// In es, this message translates to:
  /// **'Rep. Liviana'**
  String get enumTipoAveShortReproductoraLiviana;

  /// No description provided for @enumTipoAveShortPavo.
  ///
  /// In es, this message translates to:
  /// **'Pavo'**
  String get enumTipoAveShortPavo;

  /// No description provided for @enumTipoAveShortCodorniz.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get enumTipoAveShortCodorniz;

  /// No description provided for @enumTipoAveShortPato.
  ///
  /// In es, this message translates to:
  /// **'Pato'**
  String get enumTipoAveShortPato;

  /// No description provided for @enumTipoAveShortOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get enumTipoAveShortOtro;

  /// No description provided for @enumEstadoLoteActivo.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get enumEstadoLoteActivo;

  /// No description provided for @enumEstadoLoteCerrado.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get enumEstadoLoteCerrado;

  /// No description provided for @enumEstadoLoteCuarentena.
  ///
  /// In es, this message translates to:
  /// **'Cuarentena'**
  String get enumEstadoLoteCuarentena;

  /// No description provided for @enumEstadoLoteVendido.
  ///
  /// In es, this message translates to:
  /// **'Vendido'**
  String get enumEstadoLoteVendido;

  /// No description provided for @enumEstadoLoteEnTransferencia.
  ///
  /// In es, this message translates to:
  /// **'En Transferencia'**
  String get enumEstadoLoteEnTransferencia;

  /// No description provided for @enumEstadoLoteSuspendido.
  ///
  /// In es, this message translates to:
  /// **'Suspendido'**
  String get enumEstadoLoteSuspendido;

  /// No description provided for @enumEstadoLoteDescActivo.
  ///
  /// In es, this message translates to:
  /// **'Lote en producción normal'**
  String get enumEstadoLoteDescActivo;

  /// No description provided for @enumEstadoLoteDescCerrado.
  ///
  /// In es, this message translates to:
  /// **'Lote finalizado'**
  String get enumEstadoLoteDescCerrado;

  /// No description provided for @enumEstadoLoteDescCuarentena.
  ///
  /// In es, this message translates to:
  /// **'Lote aislado por motivos sanitarios'**
  String get enumEstadoLoteDescCuarentena;

  /// No description provided for @enumEstadoLoteDescVendido.
  ///
  /// In es, this message translates to:
  /// **'Lote vendido completamente'**
  String get enumEstadoLoteDescVendido;

  /// No description provided for @enumEstadoLoteDescEnTransferencia.
  ///
  /// In es, this message translates to:
  /// **'Lote siendo transferido'**
  String get enumEstadoLoteDescEnTransferencia;

  /// No description provided for @enumEstadoLoteDescSuspendido.
  ///
  /// In es, this message translates to:
  /// **'Lote temporalmente suspendido'**
  String get enumEstadoLoteDescSuspendido;

  /// No description provided for @enumEstadoGalponActivo.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get enumEstadoGalponActivo;

  /// No description provided for @enumEstadoGalponMantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get enumEstadoGalponMantenimiento;

  /// No description provided for @enumEstadoGalponInactivo.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get enumEstadoGalponInactivo;

  /// No description provided for @enumEstadoGalponDesinfeccion.
  ///
  /// In es, this message translates to:
  /// **'Desinfección'**
  String get enumEstadoGalponDesinfeccion;

  /// No description provided for @enumEstadoGalponCuarentena.
  ///
  /// In es, this message translates to:
  /// **'Cuarentena'**
  String get enumEstadoGalponCuarentena;

  /// No description provided for @enumEstadoGalponDescActivo.
  ///
  /// In es, this message translates to:
  /// **'Galpón operativo'**
  String get enumEstadoGalponDescActivo;

  /// No description provided for @enumEstadoGalponDescMantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Galpón en reparación'**
  String get enumEstadoGalponDescMantenimiento;

  /// No description provided for @enumEstadoGalponDescInactivo.
  ///
  /// In es, this message translates to:
  /// **'Galpón sin uso'**
  String get enumEstadoGalponDescInactivo;

  /// No description provided for @enumEstadoGalponDescDesinfeccion.
  ///
  /// In es, this message translates to:
  /// **'Galpón en proceso sanitario'**
  String get enumEstadoGalponDescDesinfeccion;

  /// No description provided for @enumEstadoGalponDescCuarentena.
  ///
  /// In es, this message translates to:
  /// **'Galpón aislado por sanidad'**
  String get enumEstadoGalponDescCuarentena;

  /// No description provided for @enumTipoGalponEngorde.
  ///
  /// In es, this message translates to:
  /// **'Engorde'**
  String get enumTipoGalponEngorde;

  /// No description provided for @enumTipoGalponPostura.
  ///
  /// In es, this message translates to:
  /// **'Postura'**
  String get enumTipoGalponPostura;

  /// No description provided for @enumTipoGalponReproductora.
  ///
  /// In es, this message translates to:
  /// **'Reproductora'**
  String get enumTipoGalponReproductora;

  /// No description provided for @enumTipoGalponMixto.
  ///
  /// In es, this message translates to:
  /// **'Mixto'**
  String get enumTipoGalponMixto;

  /// No description provided for @enumTipoGalponDescEngorde.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de carne'**
  String get enumTipoGalponDescEngorde;

  /// No description provided for @enumTipoGalponDescPostura.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de huevos'**
  String get enumTipoGalponDescPostura;

  /// No description provided for @enumTipoGalponDescReproductora.
  ///
  /// In es, this message translates to:
  /// **'Galpón para producción de huevos fértiles'**
  String get enumTipoGalponDescReproductora;

  /// No description provided for @enumTipoGalponDescMixto.
  ///
  /// In es, this message translates to:
  /// **'Galpón multiuso para diferentes tipos de producción'**
  String get enumTipoGalponDescMixto;

  /// No description provided for @enumRolGranjaOwner.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get enumRolGranjaOwner;

  /// No description provided for @enumRolGranjaAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get enumRolGranjaAdmin;

  /// No description provided for @enumRolGranjaManager.
  ///
  /// In es, this message translates to:
  /// **'Gestor'**
  String get enumRolGranjaManager;

  /// No description provided for @enumRolGranjaOperator.
  ///
  /// In es, this message translates to:
  /// **'Operario'**
  String get enumRolGranjaOperator;

  /// No description provided for @enumRolGranjaViewer.
  ///
  /// In es, this message translates to:
  /// **'Visualizador'**
  String get enumRolGranjaViewer;

  /// No description provided for @enumRolGranjaDescOwner.
  ///
  /// In es, this message translates to:
  /// **'Control total, puede eliminar la granja'**
  String get enumRolGranjaDescOwner;

  /// No description provided for @enumRolGranjaDescAdmin.
  ///
  /// In es, this message translates to:
  /// **'Control total excepto eliminar'**
  String get enumRolGranjaDescAdmin;

  /// No description provided for @enumRolGranjaDescManager.
  ///
  /// In es, this message translates to:
  /// **'Gestión de registros e invitaciones'**
  String get enumRolGranjaDescManager;

  /// No description provided for @enumRolGranjaDescOperator.
  ///
  /// In es, this message translates to:
  /// **'Solo puede crear registros'**
  String get enumRolGranjaDescOperator;

  /// No description provided for @enumRolGranjaDescViewer.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura'**
  String get enumRolGranjaDescViewer;

  /// No description provided for @savedMomentAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace un momento'**
  String get savedMomentAgo;

  /// No description provided for @savedMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'Guardado hace {minutes} min'**
  String savedMinutesAgo(int minutes);

  /// No description provided for @savedAtTime.
  ///
  /// In es, this message translates to:
  /// **'Guardado a las {time}'**
  String savedAtTime(String time);

  /// No description provided for @pleaseSelectFarmAndBatch.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja y un lote'**
  String get pleaseSelectFarmAndBatch;

  /// No description provided for @pleaseSelectExpenseType.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un tipo de gasto'**
  String get pleaseSelectExpenseType;

  /// No description provided for @noPermissionEditCosts.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar costos en esta granja'**
  String get noPermissionEditCosts;

  /// No description provided for @noPermissionCreateCosts.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para registrar costos en esta granja'**
  String get noPermissionCreateCosts;

  /// No description provided for @errorSelectFarm.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una granja'**
  String get errorSelectFarm;

  /// No description provided for @errorClosingTreatment.
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar tratamiento: {error}'**
  String errorClosingTreatment(String error);

  /// No description provided for @couldNotLoadBiosecurity.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar bioseguridad'**
  String get couldNotLoadBiosecurity;

  /// No description provided for @purchaseOf.
  ///
  /// In es, this message translates to:
  /// **'Compra de {name}'**
  String purchaseOf(String name);

  /// No description provided for @draftFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'Se encontró un borrador guardado del {date}.\n¿Deseas restaurarlo?'**
  String draftFoundMessage(String date);

  /// No description provided for @insufficientStock.
  ///
  /// In es, this message translates to:
  /// **'Stock insuficiente. Disponible: {available} kg'**
  String insufficientStock(String available);

  /// No description provided for @maxWeightIs.
  ///
  /// In es, this message translates to:
  /// **'El peso máximo es 50,000 kg'**
  String get maxWeightIs;

  /// No description provided for @fieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get fieldRequired;

  /// No description provided for @closedOnDate.
  ///
  /// In es, this message translates to:
  /// **'Cerrado el {date}'**
  String closedOnDate(String date);

  /// No description provided for @inventoryOfType.
  ///
  /// In es, this message translates to:
  /// **'de tipo {type}'**
  String inventoryOfType(String type);

  /// No description provided for @enumTipoRegistroPeso.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get enumTipoRegistroPeso;

  /// No description provided for @enumTipoRegistroConsumo.
  ///
  /// In es, this message translates to:
  /// **'Consumo'**
  String get enumTipoRegistroConsumo;

  /// No description provided for @enumTipoRegistroMortalidad.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get enumTipoRegistroMortalidad;

  /// No description provided for @enumTipoRegistroProduccion.
  ///
  /// In es, this message translates to:
  /// **'Producción'**
  String get enumTipoRegistroProduccion;

  /// No description provided for @semanticsStatusOpen.
  ///
  /// In es, this message translates to:
  /// **'abierto'**
  String get semanticsStatusOpen;

  /// No description provided for @semanticsStatusClosed.
  ///
  /// In es, this message translates to:
  /// **'cerrado'**
  String get semanticsStatusClosed;

  /// No description provided for @semanticsDirectionEntry.
  ///
  /// In es, this message translates to:
  /// **'entrada'**
  String get semanticsDirectionEntry;

  /// No description provided for @semanticsDirectionExit.
  ///
  /// In es, this message translates to:
  /// **'salida'**
  String get semanticsDirectionExit;

  /// No description provided for @semanticsUnits.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get semanticsUnits;

  /// No description provided for @semanticsHealthRecord.
  ///
  /// In es, this message translates to:
  /// **'Registro de salud, {diagnosis}, {date}, {status}'**
  String semanticsHealthRecord(String diagnosis, String date, String status);

  /// No description provided for @semanticsVaccination.
  ///
  /// In es, this message translates to:
  /// **'Vacunación {name}, {date}, estado {status}'**
  String semanticsVaccination(String name, String date, String status);

  /// No description provided for @semanticsSale.
  ///
  /// In es, this message translates to:
  /// **'Venta de {type}, {date}, estado {status}'**
  String semanticsSale(String type, String date, String status);

  /// No description provided for @semanticsCost.
  ///
  /// In es, this message translates to:
  /// **'Costo {concept}, tipo {type}, {date}'**
  String semanticsCost(String concept, String type, String date);

  /// No description provided for @semanticsInventoryMovement.
  ///
  /// In es, this message translates to:
  /// **'Movimiento {type}, {direction} de {quantity} {units}'**
  String semanticsInventoryMovement(
    String type,
    String direction,
    String quantity,
    String units,
  );

  /// No description provided for @semanticsInventoryItem.
  ///
  /// In es, this message translates to:
  /// **'Item {name}, {type}, {stock} {unit}, estado {status}'**
  String semanticsInventoryItem(
    String name,
    String type,
    String stock,
    String unit,
    String status,
  );

  /// No description provided for @dateFormatDayOfMonthYearTime.
  ///
  /// In es, this message translates to:
  /// **'{day} de {month} {year} • {time}'**
  String dateFormatDayOfMonthYearTime(
    String day,
    String month,
    String year,
    String time,
  );

  /// No description provided for @shareDateLine.
  ///
  /// In es, this message translates to:
  /// **'📅 Fecha: {value}'**
  String shareDateLine(String value);

  /// No description provided for @shareTypeLine.
  ///
  /// In es, this message translates to:
  /// **'🏷️ Tipo: {value}'**
  String shareTypeLine(String value);

  /// No description provided for @shareQuantityBirdsLine.
  ///
  /// In es, this message translates to:
  /// **'🐔 Cantidad: {count} aves'**
  String shareQuantityBirdsLine(String count);

  /// No description provided for @sharePricePerKgLine.
  ///
  /// In es, this message translates to:
  /// **'💰 Precio: {currency} {price}/kg'**
  String sharePricePerKgLine(String currency, String price);

  /// No description provided for @shareEggsLine.
  ///
  /// In es, this message translates to:
  /// **'🥚 Huevos: {count} unidades'**
  String shareEggsLine(String count);

  /// No description provided for @shareQuantityLine.
  ///
  /// In es, this message translates to:
  /// **'📝 Cantidad: {count} {unit}'**
  String shareQuantityLine(String count, String unit);

  /// No description provided for @shareTotalLine.
  ///
  /// In es, this message translates to:
  /// **'💵 TOTAL: {currency} {amount}'**
  String shareTotalLine(String currency, String amount);

  /// No description provided for @shareClientLine.
  ///
  /// In es, this message translates to:
  /// **'👤 Cliente: {value}'**
  String shareClientLine(String value);

  /// No description provided for @shareContactLine.
  ///
  /// In es, this message translates to:
  /// **'📱 Contacto: {value}'**
  String shareContactLine(String value);

  /// No description provided for @shareStatusLine.
  ///
  /// In es, this message translates to:
  /// **'📊 Estado: {value}'**
  String shareStatusLine(String value);

  /// No description provided for @shareSubjectSale.
  ///
  /// In es, this message translates to:
  /// **'Venta - {type}'**
  String shareSubjectSale(String type);

  /// No description provided for @bultosFallback.
  ///
  /// In es, this message translates to:
  /// **'bultos'**
  String get bultosFallback;

  /// No description provided for @statusRejected.
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get statusRejected;

  /// No description provided for @birdCountWithPercent.
  ///
  /// In es, this message translates to:
  /// **'{count} aves ({percent}%)'**
  String birdCountWithPercent(String count, String percent);

  /// No description provided for @eggCountUnits.
  ///
  /// In es, this message translates to:
  /// **'{count} unidades'**
  String eggCountUnits(String count);

  /// No description provided for @batchDropdownItemCode.
  ///
  /// In es, this message translates to:
  /// **'{code} - {count} aves'**
  String batchDropdownItemCode(String code, String count);

  /// No description provided for @batchDropdownItemName.
  ///
  /// In es, this message translates to:
  /// **'{name} - {count} aves'**
  String batchDropdownItemName(String name, String count);

  /// No description provided for @semanticsLoteSummary.
  ///
  /// In es, this message translates to:
  /// **'Lote {code}, {type}, {count} aves, {status}'**
  String semanticsLoteSummary(
    String code,
    String type,
    String count,
    String status,
  );

  /// No description provided for @inventoryStockLabel.
  ///
  /// In es, this message translates to:
  /// **'Stock: {value} {unit}'**
  String inventoryStockLabel(String value, String unit);

  /// No description provided for @inventoryExpiresLabel.
  ///
  /// In es, this message translates to:
  /// **'Vence: {date}'**
  String inventoryExpiresLabel(String date);

  /// No description provided for @inventoryPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio: {price}/{unit}'**
  String inventoryPriceLabel(String price, String unit);

  /// No description provided for @shedDensityFattening.
  ///
  /// In es, this message translates to:
  /// **'10-12 aves/m²'**
  String get shedDensityFattening;

  /// No description provided for @shedDensityLaying.
  ///
  /// In es, this message translates to:
  /// **'8-10 aves/m²'**
  String get shedDensityLaying;

  /// No description provided for @shedDensityBreeder.
  ///
  /// In es, this message translates to:
  /// **'6-8 aves/m²'**
  String get shedDensityBreeder;

  /// No description provided for @galponTotalCount.
  ///
  /// In es, this message translates to:
  /// **'{count} total'**
  String galponTotalCount(String count);

  /// No description provided for @pollinazaItemName.
  ///
  /// In es, this message translates to:
  /// **'Pollinaza'**
  String get pollinazaItemName;

  /// No description provided for @inspectorFallback.
  ///
  /// In es, this message translates to:
  /// **'Inspector'**
  String get inspectorFallback;

  /// No description provided for @collaboratorRoleFallback.
  ///
  /// In es, this message translates to:
  /// **'colaborador'**
  String get collaboratorRoleFallback;

  /// No description provided for @reportFilePrefix.
  ///
  /// In es, this message translates to:
  /// **'Reporte'**
  String get reportFilePrefix;

  /// No description provided for @errorOccurredDefault.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error'**
  String get errorOccurredDefault;

  /// No description provided for @errorUnknown.
  ///
  /// In es, this message translates to:
  /// **'Error desconocido'**
  String get errorUnknown;

  /// No description provided for @unitsFallback.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get unitsFallback;

  /// No description provided for @pageNotFound.
  ///
  /// In es, this message translates to:
  /// **'Página no encontrada'**
  String get pageNotFound;

  /// No description provided for @guiasManejoTitle.
  ///
  /// In es, this message translates to:
  /// **'Guías de Manejo'**
  String get guiasManejoTitle;

  /// No description provided for @guiasManejoSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones técnicas según manuales oficiales'**
  String get guiasManejoSubtitle;

  /// No description provided for @guiasManejoBotonLabel.
  ///
  /// In es, this message translates to:
  /// **'Ver guías de manejo'**
  String get guiasManejoBotonLabel;

  /// No description provided for @guiaLuzTitle.
  ///
  /// In es, this message translates to:
  /// **'Luz'**
  String get guiaLuzTitle;

  /// No description provided for @guiaAlimentacionTitle.
  ///
  /// In es, this message translates to:
  /// **'Alimentación'**
  String get guiaAlimentacionTitle;

  /// No description provided for @guiaPesoTitle.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get guiaPesoTitle;

  /// No description provided for @guiaAguaTitle.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get guiaAguaTitle;

  /// No description provided for @guiaSemanaCol.
  ///
  /// In es, this message translates to:
  /// **'Sem'**
  String get guiaSemanaCol;

  /// No description provided for @guiaHorasLuzCol.
  ///
  /// In es, this message translates to:
  /// **'Horas luz'**
  String get guiaHorasLuzCol;

  /// No description provided for @guiaPesoObjetivoCol.
  ///
  /// In es, this message translates to:
  /// **'Peso objetivo'**
  String get guiaPesoObjetivoCol;

  /// No description provided for @guiaTipoCol.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get guiaTipoCol;

  /// No description provided for @guiaTotalLote.
  ///
  /// In es, this message translates to:
  /// **'total lote'**
  String get guiaTotalLote;

  /// No description provided for @guiaAveAbrev.
  ///
  /// In es, this message translates to:
  /// **'ave'**
  String get guiaAveAbrev;

  /// No description provided for @guiaDiaAbrev.
  ///
  /// In es, this message translates to:
  /// **'día'**
  String get guiaDiaAbrev;

  /// No description provided for @guiaSemanaActualLabel.
  ///
  /// In es, this message translates to:
  /// **'Semana {semana} (actual)'**
  String guiaSemanaActualLabel(int semana);

  /// No description provided for @guiaLuzSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Horas de luz recomendadas por día'**
  String get guiaLuzSubtitle;

  /// No description provided for @guiaAlimentacionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Total lote: {kgDia} kg/día para {aves} aves'**
  String guiaAlimentacionSubtitle(String kgDia, int aves);

  /// No description provided for @guiaAguaSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Total lote: {litrosDia} L/día para {aves} aves'**
  String guiaAguaSubtitle(String litrosDia, int aves);

  /// No description provided for @guiaPesoComparacion.
  ///
  /// In es, this message translates to:
  /// **'Peso actual: {actual}g — Objetivo: {objetivo}g'**
  String guiaPesoComparacion(String actual, String objetivo);

  /// No description provided for @guiaPesoSinDatos.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de peso actual registrados'**
  String get guiaPesoSinDatos;

  /// No description provided for @guiaTipoAlimentoRecomendado.
  ///
  /// In es, this message translates to:
  /// **'Alimento recomendado'**
  String get guiaTipoAlimentoRecomendado;

  /// No description provided for @guiaFuenteManual.
  ///
  /// In es, this message translates to:
  /// **'Fuente'**
  String get guiaFuenteManual;

  /// No description provided for @guiaTemperaturaTitle.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get guiaTemperaturaTitle;

  /// No description provided for @guiaHumedadTitle.
  ///
  /// In es, this message translates to:
  /// **'Humedad'**
  String get guiaHumedadTitle;

  /// No description provided for @guiaTemperaturaSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Temperatura ambiental recomendada'**
  String get guiaTemperaturaSubtitle;

  /// No description provided for @guiaHumedadSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Humedad relativa recomendada'**
  String get guiaHumedadSubtitle;

  /// No description provided for @guiaTemperaturaCol.
  ///
  /// In es, this message translates to:
  /// **'Temp (°C)'**
  String get guiaTemperaturaCol;

  /// No description provided for @guiaHumedadCol.
  ///
  /// In es, this message translates to:
  /// **'Humedad (%)'**
  String get guiaHumedadCol;

  /// No description provided for @vetVirtualTitle.
  ///
  /// In es, this message translates to:
  /// **'Veterinario Virtual'**
  String get vetVirtualTitle;

  /// No description provided for @vetVirtualSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Asistente avícola con IA'**
  String get vetVirtualSubtitle;

  /// No description provided for @vetVirtualContextoLote.
  ///
  /// In es, this message translates to:
  /// **'Usando contexto del lote {codigo} ({tipoAve})'**
  String vetVirtualContextoLote(String codigo, String tipoAve);

  /// No description provided for @vetVirtualSinContexto.
  ///
  /// In es, this message translates to:
  /// **'Consulta general sin lote seleccionado'**
  String get vetVirtualSinContexto;

  /// No description provided for @vetVirtualEligeConsulta.
  ///
  /// In es, this message translates to:
  /// **'¿Qué necesitas consultar?'**
  String get vetVirtualEligeConsulta;

  /// No description provided for @vetVirtualDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'Este asistente usa inteligencia artificial como apoyo. No reemplaza el diagnóstico de un veterinario profesional. Consulta presencialmente ante emergencias.'**
  String get vetVirtualDisclaimer;

  /// No description provided for @vetDiagnosticoTitle.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get vetDiagnosticoTitle;

  /// No description provided for @vetDiagnosticoDesc.
  ///
  /// In es, this message translates to:
  /// **'Describe síntomas y obtén posibles diagnósticos'**
  String get vetDiagnosticoDesc;

  /// No description provided for @vetMortalidadTitle.
  ///
  /// In es, this message translates to:
  /// **'Mortalidad'**
  String get vetMortalidadTitle;

  /// No description provided for @vetMortalidadDesc.
  ///
  /// In es, this message translates to:
  /// **'Analiza tasas de mortalidad y posibles causas'**
  String get vetMortalidadDesc;

  /// No description provided for @vetVacunacionTitle.
  ///
  /// In es, this message translates to:
  /// **'Vacunación'**
  String get vetVacunacionTitle;

  /// No description provided for @vetVacunacionDesc.
  ///
  /// In es, this message translates to:
  /// **'Plan de vacunación según tipo y edad del ave'**
  String get vetVacunacionDesc;

  /// No description provided for @vetNutricionTitle.
  ///
  /// In es, this message translates to:
  /// **'Nutrición'**
  String get vetNutricionTitle;

  /// No description provided for @vetNutricionDesc.
  ///
  /// In es, this message translates to:
  /// **'Evalúa alimentación, peso y conversión alimenticia'**
  String get vetNutricionDesc;

  /// No description provided for @vetAmbienteTitle.
  ///
  /// In es, this message translates to:
  /// **'Ambiente'**
  String get vetAmbienteTitle;

  /// No description provided for @vetAmbienteDesc.
  ///
  /// In es, this message translates to:
  /// **'Temperatura, humedad y condiciones del galpón'**
  String get vetAmbienteDesc;

  /// No description provided for @vetBioseguridadTitle.
  ///
  /// In es, this message translates to:
  /// **'Bioseguridad'**
  String get vetBioseguridadTitle;

  /// No description provided for @vetBioseguridadDesc.
  ///
  /// In es, this message translates to:
  /// **'Protocolos de prevención y desinfección'**
  String get vetBioseguridadDesc;

  /// No description provided for @vetGeneralTitle.
  ///
  /// In es, this message translates to:
  /// **'Consulta General'**
  String get vetGeneralTitle;

  /// No description provided for @vetGeneralDesc.
  ///
  /// In es, this message translates to:
  /// **'Pregunta lo que necesites sobre avicultura'**
  String get vetGeneralDesc;

  /// No description provided for @vetChatHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu consulta...'**
  String get vetChatHint;

  /// No description provided for @vetChatError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener respuesta. Intenta de nuevo.'**
  String get vetChatError;

  /// No description provided for @vetChatRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get vetChatRetry;

  /// No description provided for @vetVirtualBotonLabel.
  ///
  /// In es, this message translates to:
  /// **'Veterinario Virtual IA'**
  String get vetVirtualBotonLabel;

  /// No description provided for @vetIaLabel.
  ///
  /// In es, this message translates to:
  /// **'Veterinario IA'**
  String get vetIaLabel;

  /// No description provided for @vetTextoCopied.
  ///
  /// In es, this message translates to:
  /// **'Texto copiado'**
  String get vetTextoCopied;

  /// No description provided for @vetAnalizando.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get vetAnalizando;

  /// No description provided for @vetAttachImage.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar imagen'**
  String get vetAttachImage;

  /// No description provided for @vetFromCamera.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get vetFromCamera;

  /// No description provided for @vetFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get vetFromGallery;

  /// No description provided for @vetImageAttach.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar imagen'**
  String get vetImageAttach;

  /// No description provided for @vetImageSelectSource.
  ///
  /// In es, this message translates to:
  /// **'Selecciona de dónde obtener la imagen'**
  String get vetImageSelectSource;

  /// No description provided for @vetStatusProcessing.
  ///
  /// In es, this message translates to:
  /// **'Procesando tu consulta...'**
  String get vetStatusProcessing;

  /// No description provided for @vetStatusAnalyzingImage.
  ///
  /// In es, this message translates to:
  /// **'Analizando imagen...'**
  String get vetStatusAnalyzingImage;

  /// No description provided for @vetStatusGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando respuesta...'**
  String get vetStatusGenerating;

  /// No description provided for @vetVoiceListening.
  ///
  /// In es, this message translates to:
  /// **'Escuchando...'**
  String get vetVoiceListening;

  /// No description provided for @vetVoiceNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'El reconocimiento de voz no está disponible'**
  String get vetVoiceNotAvailable;

  /// No description provided for @vetVoiceStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar dictado'**
  String get vetVoiceStart;

  /// No description provided for @vetVoiceStop.
  ///
  /// In es, this message translates to:
  /// **'Detener dictado'**
  String get vetVoiceStop;

  /// No description provided for @vetAnalyzeImage.
  ///
  /// In es, this message translates to:
  /// **'Analiza esta imagen'**
  String get vetAnalyzeImage;

  /// No description provided for @legalLastUpdated.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: Abril 2026'**
  String get legalLastUpdated;

  /// No description provided for @legalPrivacy1Title.
  ///
  /// In es, this message translates to:
  /// **'1. Información que recopilamos'**
  String get legalPrivacy1Title;

  /// No description provided for @legalPrivacy1Body.
  ///
  /// In es, this message translates to:
  /// **'Recopilamos la información que usted proporciona directamente: nombre, correo electrónico, datos de sus granjas (nombre, ubicación, galpones, lotes), registros productivos (peso, mortalidad, producción, consumo), imágenes de aves y galpones, y datos de salud animal. También recopilamos automáticamente datos de uso de la app y tokens de notificaciones push.'**
  String get legalPrivacy1Body;

  /// No description provided for @legalPrivacy2Title.
  ///
  /// In es, this message translates to:
  /// **'2. Cómo usamos su información'**
  String get legalPrivacy2Title;

  /// No description provided for @legalPrivacy2Body.
  ///
  /// In es, this message translates to:
  /// **'Usamos sus datos para: operar y mantener la aplicación, generar reportes y análisis productivos, ofrecer recomendaciones de manejo a través del veterinario virtual IA, enviar notificaciones sobre alertas sanitarias y recordatorios, y mejorar nuestros servicios. No vendemos ni compartimos sus datos con terceros para fines publicitarios.'**
  String get legalPrivacy2Body;

  /// No description provided for @legalPrivacy3Title.
  ///
  /// In es, this message translates to:
  /// **'3. Almacenamiento y seguridad'**
  String get legalPrivacy3Title;

  /// No description provided for @legalPrivacy3Body.
  ///
  /// In es, this message translates to:
  /// **'Sus datos se almacenan de forma segura en servidores de Firebase (Google Cloud Platform) con cifrado en tránsito y en reposo. Implementamos medidas de seguridad técnicas y organizativas para proteger su información contra acceso no autorizado, alteración o destrucción.'**
  String get legalPrivacy3Body;

  /// No description provided for @legalPrivacy4Title.
  ///
  /// In es, this message translates to:
  /// **'4. Compartir datos'**
  String get legalPrivacy4Title;

  /// No description provided for @legalPrivacy4Body.
  ///
  /// In es, this message translates to:
  /// **'Solo compartimos sus datos de granja con los colaboradores que usted invite explícitamente. Las consultas al veterinario virtual IA se procesan a través de Google Gemini; estas consultas no contienen información personal identificable más allá del contexto de la granja necesario para la respuesta.'**
  String get legalPrivacy4Body;

  /// No description provided for @legalPrivacy5Title.
  ///
  /// In es, this message translates to:
  /// **'5. Sus derechos'**
  String get legalPrivacy5Title;

  /// No description provided for @legalPrivacy5Body.
  ///
  /// In es, this message translates to:
  /// **'Usted tiene derecho a: acceder a sus datos personales, corregir información inexacta, solicitar la eliminación de su cuenta y datos, exportar sus datos en formatos estándar, y retirar su consentimiento en cualquier momento.'**
  String get legalPrivacy5Body;

  /// No description provided for @legalPrivacy6Title.
  ///
  /// In es, this message translates to:
  /// **'6. Retención de datos'**
  String get legalPrivacy6Title;

  /// No description provided for @legalPrivacy6Body.
  ///
  /// In es, this message translates to:
  /// **'Conservamos sus datos mientras su cuenta esté activa. Si solicita la eliminación de su cuenta, eliminaremos sus datos personales en un plazo de 30 días, excepto cuando la ley requiera su conservación por un período mayor.'**
  String get legalPrivacy6Body;

  /// No description provided for @legalPrivacy7Title.
  ///
  /// In es, this message translates to:
  /// **'7. Contacto'**
  String get legalPrivacy7Title;

  /// No description provided for @legalPrivacy7Body.
  ///
  /// In es, this message translates to:
  /// **'Para consultas sobre privacidad, puede contactarnos a través de la sección de ayuda dentro de la aplicación o enviando un correo a soporte@smartgranjaaves.com.'**
  String get legalPrivacy7Body;

  /// No description provided for @legalTerms1Title.
  ///
  /// In es, this message translates to:
  /// **'1. Aceptación de los términos'**
  String get legalTerms1Title;

  /// No description provided for @legalTerms1Body.
  ///
  /// In es, this message translates to:
  /// **'Al utilizar Smart Granja Aves Pro, usted acepta estos términos y condiciones. Si no está de acuerdo, por favor no utilice la aplicación.'**
  String get legalTerms1Body;

  /// No description provided for @legalTerms2Title.
  ///
  /// In es, this message translates to:
  /// **'2. Uso de la aplicación'**
  String get legalTerms2Title;

  /// No description provided for @legalTerms2Body.
  ///
  /// In es, this message translates to:
  /// **'La aplicación está diseñada como herramienta de gestión avícola y apoyo a la toma de decisiones. Las recomendaciones del veterinario virtual IA son orientativas y NO sustituyen la consulta con un médico veterinario presencial. El usuario es responsable de las decisiones que tome basándose en la información proporcionada.'**
  String get legalTerms2Body;

  /// No description provided for @legalTerms3Title.
  ///
  /// In es, this message translates to:
  /// **'3. Cuenta de usuario'**
  String get legalTerms3Title;

  /// No description provided for @legalTerms3Body.
  ///
  /// In es, this message translates to:
  /// **'Usted es responsable de mantener la confidencialidad de su cuenta y contraseña. Debe notificarnos inmediatamente sobre cualquier uso no autorizado de su cuenta.'**
  String get legalTerms3Body;

  /// No description provided for @legalTerms4Title.
  ///
  /// In es, this message translates to:
  /// **'4. Propiedad intelectual'**
  String get legalTerms4Title;

  /// No description provided for @legalTerms4Body.
  ///
  /// In es, this message translates to:
  /// **'Los datos que usted ingresa en la aplicación son de su propiedad. Smart Granja Aves Pro retiene los derechos sobre el software, diseño, algoritmos y contenido propio de la aplicación.'**
  String get legalTerms4Body;

  /// No description provided for @legalTerms5Title.
  ///
  /// In es, this message translates to:
  /// **'5. Limitación de responsabilidad'**
  String get legalTerms5Title;

  /// No description provided for @legalTerms5Body.
  ///
  /// In es, this message translates to:
  /// **'La aplicación se proporciona \"tal cual\". No garantizamos que las recomendaciones del veterinario virtual sean infalibles. No somos responsables por pérdidas derivadas del uso de la información proporcionada. En caso de emergencia sanitaria, siempre consulte a un veterinario presencial.'**
  String get legalTerms5Body;

  /// No description provided for @legalTerms6Title.
  ///
  /// In es, this message translates to:
  /// **'6. Modificaciones'**
  String get legalTerms6Title;

  /// No description provided for @legalTerms6Body.
  ///
  /// In es, this message translates to:
  /// **'Nos reservamos el derecho de modificar estos términos en cualquier momento. Le notificaremos sobre cambios significativos a través de la aplicación. El uso continuado después de los cambios constituye su aceptación de los nuevos términos.'**
  String get legalTerms6Body;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'es':
      return SEs();
    case 'pt':
      return SPt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
