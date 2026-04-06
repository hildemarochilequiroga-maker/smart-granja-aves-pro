// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Poultry Farm Pro';

  @override
  String get navHome => 'Home';

  @override
  String get navManagement => 'Management';

  @override
  String get navBatches => 'Batches';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonCancel => 'Cancel';

  @override
  String commonHintExample(String value) {
    return 'Ex: $value';
  }

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonAccept => 'Accept';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSearch => 'Search...';

  @override
  String get commonGoHome => 'Go to home';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonApplyFilters => 'Apply filters';

  @override
  String get commonClearFilters => 'Clear filters';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonNoResults => 'No results found';

  @override
  String get commonNoResultsHint => 'Try modifying the search filters';

  @override
  String get commonSomethingWentWrong => 'Something went wrong';

  @override
  String get commonErrorOccurred => 'An error has occurred';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOr => 'or';

  @override
  String get connectivityOffline => 'No internet connection';

  @override
  String get connectivityOfflineShort => 'Offline';

  @override
  String get connectivityOfflineBanner => 'Offline • Data saved locally';

  @override
  String get connectivityOfflineMode => 'Offline mode';

  @override
  String get connectivityOfflineDataWarning =>
      'No internet connection. Displayed data may be outdated';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorCacheNotFound => 'Data not found in cache';

  @override
  String get errorNoConnection => 'No internet connection';

  @override
  String get errorTimeout => 'Request timed out';

  @override
  String get errorInvalidCredentials => 'Invalid credentials';

  @override
  String get errorSessionExpired => 'Your session has expired';

  @override
  String get errorNoPermission => 'You don\'t have permission for this action';

  @override
  String get errorWriteCache => 'Error writing to cache';

  @override
  String get errorNoSession => 'No active session';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorReadFile => 'Error reading file';

  @override
  String get errorWriteFile => 'Error writing file';

  @override
  String get errorDeleteFile => 'Error deleting file';

  @override
  String get errorVerifyPermissions => 'Error verifying permissions';

  @override
  String get errorLoadingActivities => 'Error loading activities';

  @override
  String get permNoCreateRecords =>
      'You don\'t have permission to create records';

  @override
  String get permNoEditRecords => 'You don\'t have permission to edit records';

  @override
  String get permNoDeleteRecords =>
      'You don\'t have permission to delete records';

  @override
  String get permNoCreateBatches =>
      'You don\'t have permission to create batches';

  @override
  String get permNoEditBatches => 'You don\'t have permission to edit batches';

  @override
  String get permNoDeleteBatches =>
      'You don\'t have permission to delete batches';

  @override
  String get permNoCreateSheds => 'You don\'t have permission to create sheds';

  @override
  String get permNoEditSheds => 'You don\'t have permission to edit sheds';

  @override
  String get permNoDeleteSheds => 'You don\'t have permission to delete sheds';

  @override
  String get permNoInviteUsers => 'You don\'t have permission to invite users';

  @override
  String get permNoChangeRoles => 'You don\'t have permission to change roles';

  @override
  String get permNoRemoveUsers => 'You don\'t have permission to remove users';

  @override
  String get permNoViewCollaborators =>
      'You don\'t have permission to view collaborators';

  @override
  String get permNoEditFarm => 'You don\'t have permission to edit the farm';

  @override
  String get permNoDeleteFarm =>
      'You don\'t have permission to delete the farm';

  @override
  String get permNoViewReports => 'You don\'t have permission to view reports';

  @override
  String get permNoExportData => 'You don\'t have permission to export data';

  @override
  String get permNoManageInventory =>
      'You don\'t have permission to manage inventory';

  @override
  String get permNoRegisterSales =>
      'You don\'t have permission to register sales';

  @override
  String get permNoViewSettings =>
      'You don\'t have permission to view settings';

  @override
  String get authGateManageSmartly => 'Manage your farm intelligently';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authAlreadyHaveAccount => 'I already have an account';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authEnterCredentials => 'Enter your credentials to continue';

  @override
  String get authOrSignInWithEmail => 'or sign in with email';

  @override
  String get authEmail => 'Email';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authEmailRequired => 'Email is required';

  @override
  String get authEmailInvalid => 'Enter a valid email address';

  @override
  String get authPasswordRequired => 'Password is required';

  @override
  String get authPasswordMinLength => 'Password must be at least 8 characters';

  @override
  String get authJoinToManage => 'Join to manage your farm intelligently';

  @override
  String get authSignUpWithGoogle => 'Sign up with Google';

  @override
  String get authOrSignUpWithEmail => 'or sign up with email';

  @override
  String get authFirstName => 'First name';

  @override
  String get authLastName => 'Last name';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authMustAcceptTerms => 'You must accept the terms and conditions';

  @override
  String get authTermsAndConditions => 'Terms and Conditions';

  @override
  String get authCheckEmail => 'Check your email!';

  @override
  String get authForgotPasswordTitle => 'Forgot your password?';

  @override
  String get authResetLinkSent => 'We sent you a link to reset your password';

  @override
  String get authEnterEmailForReset =>
      'Enter your email and we\'ll send instructions';

  @override
  String get authSendInstructions => 'Send instructions';

  @override
  String get authRememberPassword => 'Remember your password?';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authContinueWithFacebook => 'Continue with Facebook';

  @override
  String get authContinue => 'Continue';

  @override
  String get authEnterPassword => 'Enter your password';

  @override
  String get authCurrentPassword => 'Current password';

  @override
  String get authSignOut => 'Sign Out';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeVaccination => 'Vaccination';

  @override
  String get homeDiseases => 'Diseases';

  @override
  String get homeBiosecurity => 'Biosecurity';

  @override
  String get homeSales => 'Sales';

  @override
  String get homeCosts => 'Costs';

  @override
  String get homeInventory => 'Inventory';

  @override
  String get homeSelectFarmFirst => 'Select a farm first';

  @override
  String get homeGeneralStats => 'General Statistics';

  @override
  String get homeAvailableSheds => 'Available Sheds';

  @override
  String get homeActiveBatches => 'Active Batches';

  @override
  String get homeTotalBirds => 'Total Birds';

  @override
  String get homeOccupancy => 'Occupancy';

  @override
  String get homeNoSheds => 'No sheds';

  @override
  String get homeNoBatches => 'No batches';

  @override
  String get homeAcrossFarm => 'Across the farm';

  @override
  String get homeExpiringSoon => 'Expiring soon';

  @override
  String get homeHighMortality => 'High mortality';

  @override
  String get homeNoActiveBatches => 'No active batches';

  @override
  String get homeCreateBatchToStart => 'Create a batch to start recording';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeHello => 'Hello';

  @override
  String get profileMyAccount => 'My Account';

  @override
  String get profileUser => 'User';

  @override
  String get profileCollaboration => 'Collaboration';

  @override
  String get profileInviteToFarm => 'Invite to my Farm';

  @override
  String get profileShareAccess => 'Share access with other users';

  @override
  String get profileAcceptInvitation => 'Accept Invitation';

  @override
  String get profileJoinFarm => 'Join someone else\'s farm';

  @override
  String get profileManageCollaborators => 'Manage Collaborators';

  @override
  String get profileViewManageAccess => 'View and manage access';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileConfigureAlerts => 'Configure alerts and reminders';

  @override
  String get profileGeneralSettings => 'General Settings';

  @override
  String get profileAppPreferences => 'App preferences';

  @override
  String get profileHelpSupport => 'Help & Support';

  @override
  String get profileHelpCenter => 'Help Center';

  @override
  String get profileFaqGuides => 'FAQ and guides';

  @override
  String get profileSendFeedback => 'Send Feedback';

  @override
  String get profileShareIdeas => 'Share your ideas with us';

  @override
  String get profileAbout => 'About';

  @override
  String get profileAppInfo => 'App information';

  @override
  String get profileSelectFarmToInvite => 'Select the farm to invite to';

  @override
  String get profileSelectFarm => 'Select a farm';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageSubtitle => 'Change the app language';

  @override
  String get profileCurrency => 'Currency';

  @override
  String get profileCurrencySubtitle => 'Select your country\'s currency';

  @override
  String get salesNoSales => 'No sales registered';

  @override
  String get salesNotFound => 'No sales found';

  @override
  String get salesRegisterFirst => 'Register first sale';

  @override
  String get salesRegisterNew => 'Register new sale';

  @override
  String get salesDeleteConfirm => 'Delete sale?';

  @override
  String get salesProductType => 'Product type';

  @override
  String get salesStatus => 'Sale status';

  @override
  String get salesNewSale => 'New Sale';

  @override
  String get salesEditSale => 'Edit Sale';

  @override
  String get farmFarm => 'Farm';

  @override
  String get farmFarms => 'Farms';

  @override
  String get farmNewFarm => 'New Farm';

  @override
  String get farmEditFarm => 'Edit Farm';

  @override
  String get farmDeleteConfirm => 'Delete farm?';

  @override
  String get shedShed => 'Shed';

  @override
  String get shedSheds => 'Sheds';

  @override
  String get shedNewShed => 'New Shed';

  @override
  String get shedEditShed => 'Edit Shed';

  @override
  String get shedDeleteConfirm => 'Delete shed?';

  @override
  String get batchBatch => 'Batch';

  @override
  String get batchBatches => 'Batches';

  @override
  String get batchNewBatch => 'New Batch';

  @override
  String get batchEditBatch => 'Edit Batch';

  @override
  String get batchDeleteConfirm => 'Delete batch?';

  @override
  String get batchActive => 'Active';

  @override
  String get batchFinished => 'Finished';

  @override
  String get healthDiseases => 'Diseases';

  @override
  String get healthSymptoms => 'Symptoms';

  @override
  String get healthTreatment => 'Treatment';

  @override
  String get healthPrevention => 'Prevention';

  @override
  String get healthVaccineAvailable => 'Vaccine available';

  @override
  String get healthMandatoryNotification => 'Mandatory notification';

  @override
  String get healthPreventableByVaccine => 'Preventable by vaccination';

  @override
  String get inventoryInventory => 'Inventory';

  @override
  String get inventoryMedicines => 'Medicines';

  @override
  String get inventoryVaccines => 'Vaccines';

  @override
  String get inventoryFood => 'Feed';

  @override
  String get costsTitle => 'Costs';

  @override
  String get costsNewCost => 'New Cost';

  @override
  String get costsEditCost => 'Edit Cost';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsGenerate => 'Generate report';

  @override
  String get reportsGenerating => 'Generating report...';

  @override
  String get reportsSharePdf => 'Share PDF';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get mortalityTitle => 'Mortality';

  @override
  String get mortalityRegister => 'Register mortality';

  @override
  String get mortalityRate => 'Mortality rate';

  @override
  String get mortalityTotal => 'Total mortality';

  @override
  String get weightTitle => 'Weight';

  @override
  String get weightRegister => 'Register weight';

  @override
  String get weightAverage => 'Average weight';

  @override
  String get feedTitle => 'Feeding';

  @override
  String get feedRegister => 'Register feeding';

  @override
  String get feedDailyConsumption => 'Daily consumption';

  @override
  String get waterTitle => 'Water';

  @override
  String get waterRegister => 'Register water';

  @override
  String get waterDailyConsumption => 'Daily consumption';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonMoreOptions => 'More options';

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String get commonAll => 'All';

  @override
  String get commonAllTypes => 'All types';

  @override
  String get commonAllStatuses => 'All statuses';

  @override
  String get commonDiscard => 'Discard';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonUnsavedChanges => 'Unsaved changes';

  @override
  String get commonExitWithoutSave => 'Do you want to leave without saving?';

  @override
  String get commonExit => 'Exit';

  @override
  String get commonDontWorryDataSafe => 'Don\'t worry, your data is safe.';

  @override
  String get commonObservations => 'Observations';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonDate => 'Date';

  @override
  String get commonName => 'Name';

  @override
  String get commonPhone => 'Phone';

  @override
  String get commonProvider => 'Provider';

  @override
  String get commonLocation => 'Location';

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonPending => 'Pending';

  @override
  String get commonApproved => 'Approved';

  @override
  String get commonTotal => 'Total:';

  @override
  String get commonInformation => 'Information';

  @override
  String get commonSummary => 'Summary';

  @override
  String get commonBasicInfo => 'Basic Information';

  @override
  String get commonAdditionalInfo => 'Additional Information';

  @override
  String get commonNotFound => 'Not found';

  @override
  String get commonError => 'Error';

  @override
  String commonErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get profileLoadingFarms => 'Loading farms...';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonRegisteredBy => 'Registered by';

  @override
  String get commonRole => 'Role';

  @override
  String get commonRegistrationDate => 'Registration date';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authFirstNameHint => 'John';

  @override
  String get authLastNameHint => 'Smith';

  @override
  String get authRememberEmail => 'Remember email';

  @override
  String get authAlreadyHaveAccountLink => 'Already have an account?';

  @override
  String get authSignInLink => 'Sign in';

  @override
  String get authAcceptTermsPrefix => 'I accept the ';

  @override
  String get authPrivacyPolicy => 'Privacy Policy';

  @override
  String get authAndThe => ' and the ';

  @override
  String get authMinChars => 'Minimum 8 characters';

  @override
  String get authOneUppercase => 'One uppercase letter';

  @override
  String get authOneLowercase => 'One lowercase letter';

  @override
  String get authOneNumber => 'One number';

  @override
  String get authOneSpecialChar => 'One special character';

  @override
  String get authPasswordWeak => 'Weak';

  @override
  String get authPasswordMedium => 'Medium';

  @override
  String get authPasswordStrong => 'Strong';

  @override
  String get authPasswordConfirmRequired => 'Confirm your password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authPasswordMustContainUpper =>
      'Must contain at least one uppercase letter';

  @override
  String get authPasswordMustContainLower =>
      'Must contain at least one lowercase letter';

  @override
  String get authPasswordMustContainNumber =>
      'Must contain at least one number';

  @override
  String get authLinkAccounts => 'Link Accounts';

  @override
  String authLinkAccountMessage(String existingProvider, String newProvider) {
    return 'You already have an account with this email using $existingProvider.\n\nWould you like to link your $newProvider account to access with both methods?';
  }

  @override
  String authLinkSuccess(String provider) {
    return '$provider account linked successfully!';
  }

  @override
  String get authLinkButton => 'Link';

  @override
  String get authSentTo => 'Sent to:';

  @override
  String get authCheckSpam =>
      'If you don\'t see the email, check your spam folder';

  @override
  String get authResendEmail => 'Resend email';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authEmailPasswordProvider => 'Email and Password';

  @override
  String get authPasswordMinLengthSix =>
      'Password must be at least 6 characters';

  @override
  String authPasswordMinLengthN(String count) {
    return 'Password must be at least $count characters';
  }

  @override
  String authPasswordMinLengthValidator(Object count) {
    return 'Minimum $count characters';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsDarkModeSubtitle => 'Change the app theme';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Push notifications';

  @override
  String get settingsPushSubtitle => 'Receive important alerts';

  @override
  String get settingsSounds => 'Sounds';

  @override
  String get settingsSoundsSubtitle => 'Play notification sounds';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsVibrationSubtitle => 'Vibrate on notifications';

  @override
  String get settingsConfigureAlerts => 'Configure alerts';

  @override
  String get settingsConfigureAlertsSubtitle =>
      'Customize which alerts to receive';

  @override
  String get settingsDataStorage => 'Data & Storage';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsClearCacheSubtitle => 'Free up device storage';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsChangePasswordSubtitle => 'Update your access password';

  @override
  String get settingsVerifyEmail => 'Verify email';

  @override
  String get settingsVerifyEmailSubtitle => 'Confirm your email address';

  @override
  String get settingsDangerZone => 'Danger zone';

  @override
  String get settingsDeleteAccountWarning =>
      'Deleting your account will permanently erase all your data, including farms, batches, and records.';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsClearCacheConfirm => 'Clear cache?';

  @override
  String get settingsClearCacheMessage =>
      'Temporary data will be removed. This won\'t affect your records.';

  @override
  String get settingsClearCacheConfirmButton => 'Clear';

  @override
  String get settingsCacheClearedSuccess => 'Cache cleared successfully';

  @override
  String get settingsChangePasswordMessage =>
      'We\'ll send you a link to reset your password.';

  @override
  String get settingsYourEmail => 'Your email';

  @override
  String get settingsSendLink => 'Send link';

  @override
  String get settingsResetLinkSent => 'A link has been sent to your email';

  @override
  String get settingsVerificationEmailSent =>
      'A verification email has been sent';

  @override
  String get settingsDeleteAccountConfirm => 'Delete account?';

  @override
  String get settingsDeleteAccountMessage =>
      'This action is irreversible and you\'ll lose all your data.';

  @override
  String get profileSignOutConfirm => 'Sign out?';

  @override
  String get profileSignOutMessage =>
      'You\'ll need to sign in again to access your account.';

  @override
  String get profileNoFarmsMessage => 'You have no farms. Create one first.';

  @override
  String get profileCreate => 'Create';

  @override
  String get profileHelpQuestion => 'How can we help you?';

  @override
  String get profileEmailSupport => 'Email Support';

  @override
  String get profileFaq => 'FAQ';

  @override
  String get profileFaqSubtitle => 'Check common questions';

  @override
  String get profileUserManual => 'User Manual';

  @override
  String get profileUserManualSubtitle => 'Complete usage guide';

  @override
  String get profileFeedbackQuestion =>
      'Do you have any ideas to improve the app? We\'d love to hear from you.';

  @override
  String get profileFeedbackHint => 'Write your suggestion here...';

  @override
  String get profileFeedbackThanks => 'Thanks for your feedback!';

  @override
  String get profileAppDescription =>
      'Your smart poultry farm management partner. Control batches, monitor performance, track vaccinations, and optimize your farm\'s production easily and efficiently.';

  @override
  String get profileCopyright => '© 2024 Smart Granja. All rights reserved.';

  @override
  String profileVersionText(String version) {
    return 'Version $version';
  }

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfilePersonalInfo => 'Personal Information';

  @override
  String get editProfileAccountInfo => 'Account Information';

  @override
  String get editProfileLastName => 'Last name';

  @override
  String get editProfileMemberSince => 'Member since';

  @override
  String get editProfileChangePhoto => 'Change profile photo';

  @override
  String get editProfileTakePhoto => 'Take photo';

  @override
  String get editProfileChooseGallery => 'Choose from gallery';

  @override
  String get editProfilePhotoUpdated => 'Photo updated successfully';

  @override
  String get editProfilePhotoError => 'Error updating photo. Try again.';

  @override
  String get editProfileImageTooLarge => 'Image exceeds maximum size (5MB)';

  @override
  String get editProfileDiscardChanges => 'Discard changes?';

  @override
  String get editProfileDiscardMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get editProfileUnknownDate => 'Unknown';

  @override
  String get editProfileUpdatedSuccess => 'Profile updated successfully';

  @override
  String editProfileUpdateError(String error) {
    return 'Error updating: $error';
  }

  @override
  String get notifProductionAlerts => 'Production Alerts';

  @override
  String get notifHighMortality => 'High mortality';

  @override
  String notifHighMortalitySubtitle(String threshold) {
    return 'Alert when mortality exceeds $threshold%';
  }

  @override
  String get notifMortalityThreshold => 'Mortality threshold';

  @override
  String get notifLowProduction => 'Low production';

  @override
  String notifLowProductionSubtitle(Object threshold) {
    return 'Alert when production falls below $threshold%';
  }

  @override
  String get notifProductionThreshold => 'Production threshold';

  @override
  String get notifAbnormalConsumption => 'Abnormal consumption';

  @override
  String get notifAbnormalConsumptionSubtitle =>
      'Alert when consumption varies significantly';

  @override
  String get notifReminders => 'Reminders';

  @override
  String get notifPendingVaccinations => 'Pending vaccinations';

  @override
  String get notifPendingVaccinationsSubtitle =>
      'Remind scheduled vaccinations';

  @override
  String get notifLowInventory => 'Low inventory';

  @override
  String get notifLowInventorySubtitle => 'Alert when feed is running low';

  @override
  String get notifSummaries => 'Summaries';

  @override
  String get notifDailySummary => 'Daily summary';

  @override
  String get notifDailySummarySubtitle =>
      'Receive a summary every day at 8:00 PM';

  @override
  String get notifWeeklySummary => 'Weekly summary';

  @override
  String get notifWeeklySummarySubtitle => 'Receive a summary every Monday';

  @override
  String get notifConfigSaved => 'Configuration saved';

  @override
  String get notifSaveConfig => 'Save configuration';

  @override
  String farmCreatedSuccess(String name) {
    return 'Farm \"$name\" created!';
  }

  @override
  String farmUpdatedSuccess(Object name) {
    return 'Farm \"$name\" updated!';
  }

  @override
  String get farmNotFound => 'Farm not found';

  @override
  String get farmOwner => 'Owner';

  @override
  String get farmCapacity => 'Capacity';

  @override
  String get farmArea => 'Area';

  @override
  String get farmEmail => 'Email';

  @override
  String get farmCreatedDate => 'Created date';

  @override
  String get farmCollaborators => 'Collaborators';

  @override
  String get farmInviteCollaborator => 'Invite Collaborator';

  @override
  String farmRoleUpdated(String role) {
    return 'Role updated to $role';
  }

  @override
  String get farmCodeCopied => 'Code copied';

  @override
  String farmActivateConfirm(Object name) {
    return 'Activate \"$name\"?';
  }

  @override
  String farmSuspendConfirm(Object name) {
    return 'Suspend \"$name\"?';
  }

  @override
  String farmMaintenanceConfirm(Object name) {
    return 'Set \"$name\" to maintenance?';
  }

  @override
  String shedActivateConfirm(Object name) {
    return 'Activate \"$name\"?';
  }

  @override
  String shedSuspendConfirm(Object name) {
    return 'Suspend \"$name\"?';
  }

  @override
  String shedMaintenanceConfirm(Object name) {
    return 'Set \"$name\" to maintenance?';
  }

  @override
  String shedDisinfectionConfirm(Object name) {
    return 'Set \"$name\" to disinfection?';
  }

  @override
  String shedReleaseConfirm(Object name) {
    return 'Release \"$name\"?';
  }

  @override
  String get shedCapacity => 'Capacity';

  @override
  String get shedCurrentBirds => 'Current';

  @override
  String get shedOccupancy => 'Occupancy';

  @override
  String get shedBirds => 'Birds';

  @override
  String get shedTagExists => 'This tag already exists';

  @override
  String shedMaxTags(String max) {
    return 'Maximum $max tags';
  }

  @override
  String get shedAddProduct => 'Add product';

  @override
  String get batchCode => 'Batch Code';

  @override
  String get batchBirdType => 'Bird Type';

  @override
  String get batchBreedLine => 'Breed/Genetic Line';

  @override
  String get batchInitialCount => 'Initial Count';

  @override
  String get batchCurrentBirds => 'Current Birds';

  @override
  String get batchEntryDate => 'Entry Date';

  @override
  String get batchEntryAge => 'Entry Age';

  @override
  String get batchCurrentAge => 'Current Age';

  @override
  String get batchCostPerBird => 'Cost per Bird';

  @override
  String get batchEstimatedClose => 'Estimated Close';

  @override
  String get batchSurvivalRate => 'Survival Rate';

  @override
  String get batchAccumulatedMortality => 'Accumulated Mortality';

  @override
  String get batchAccumulatedDiscards => 'Accumulated Discards';

  @override
  String get batchAccumulatedSales => 'Accumulated Sales';

  @override
  String get batchCurrentAvgWeight => 'Current average weight';

  @override
  String get batchAccumulatedConsumption => 'Accumulated Consumption';

  @override
  String get batchFeedConversion => 'Feed Conversion Ratio (FCR)';

  @override
  String get batchEggsProduced => 'Eggs Produced';

  @override
  String get batchRemainingDays => 'Remaining Days';

  @override
  String get batchImportantInfo => 'Important information';

  @override
  String get batchChangeStatus => 'Change Status';

  @override
  String get batchClosedSuccess => 'Batch closed successfully';

  @override
  String get batchEntryAgeDays => 'Entry Age (days)';

  @override
  String get batchSelectBatch => 'Select batch';

  @override
  String get healthApplied => 'Applied';

  @override
  String get healthExpired => 'Expired';

  @override
  String get healthUpcoming => 'Upcoming';

  @override
  String get healthPending => 'Pending';

  @override
  String get healthVaccineName => 'Vaccine name';

  @override
  String get healthVaccineNameHint => 'E.g.: Newcastle + Bronchitis';

  @override
  String get healthVaccineBatch => 'Vaccine batch (optional)';

  @override
  String get healthVaccineBatchHint => 'E.g.: LOT123456';

  @override
  String get healthSelectInventoryVaccine => 'Select vaccine from inventory';

  @override
  String get healthSelectInventoryVaccineHint =>
      'Optional - Select a registered vaccine';

  @override
  String get healthObservationsOptional => 'Observations (optional)';

  @override
  String get healthObservationsHint =>
      'Observed reactions, special notes, etc.';

  @override
  String get healthTreatmentDescription => 'Treatment description';

  @override
  String get healthTreatmentDescriptionHint =>
      'Describe the treatment protocol applied';

  @override
  String get healthMedications => 'Medications';

  @override
  String get healthAdditionalMedications => 'Additional medications';

  @override
  String get healthMedicationsHint => 'E.g.: Enrofloxacin + Vitamins A, D, E';

  @override
  String get healthDose => 'Dose';

  @override
  String get healthDoseHint => 'E.g.: 1ml/L';

  @override
  String get healthDurationDays => 'Duration (days)';

  @override
  String get healthDurationHint => 'E.g.: 5';

  @override
  String get healthDiagnosis => 'Diagnosis';

  @override
  String get healthDiagnosisHint => 'E.g.: Chronic respiratory disease';

  @override
  String get healthSymptomsObserved => 'Observed symptoms';

  @override
  String get healthSymptomsHint =>
      'Describe symptoms: coughing, sneezing, lethargy...';

  @override
  String get healthVeterinarian => 'Responsible veterinarian';

  @override
  String get healthVeterinarianHint => 'Veterinarian name';

  @override
  String get healthGeneralObservations => 'General observations';

  @override
  String get healthGeneralObservationsHint =>
      'Additional notes, expected evolution, etc.';

  @override
  String get healthBiosecurityObservationsHint =>
      'Describe general inspection findings…';

  @override
  String get healthCorrectiveActions => 'Corrective actions';

  @override
  String get healthCorrectiveActionsHint => 'Describe actions to implement…';

  @override
  String get healthCompliant => 'Compliant';

  @override
  String get healthNonCompliant => 'Non-compliant';

  @override
  String get healthPartial => 'Partial';

  @override
  String get healthNotApplicable => 'N/A';

  @override
  String get healthWriteObservation => 'Write an observation (optional)';

  @override
  String get healthScheduleVaccination => 'Schedule Vaccination';

  @override
  String get healthVaccine => 'Vaccine';

  @override
  String get healthApplication => 'Application';

  @override
  String get healthMustSelectBatch => 'You must select a batch';

  @override
  String get healthDiseaseCatalog => 'Disease Catalog';

  @override
  String get healthSearchDisease => 'Search disease, symptom...';

  @override
  String get healthAllSeverities => 'All';

  @override
  String get healthCritical => 'Critical';

  @override
  String get healthSevere => 'Severe';

  @override
  String get healthModerate => 'Moderate';

  @override
  String get healthMild => 'Mild';

  @override
  String get healthRegisterTreatment => 'Register Treatment';

  @override
  String get healthBiosecurityInspection => 'Biosecurity Inspection';

  @override
  String get healthNewInspection => 'New Inspection';

  @override
  String get healthChecklist => 'Checklist';

  @override
  String get healthInspectionSaved => 'Inspection saved successfully';

  @override
  String get healthRecordDetail => 'Record Detail';

  @override
  String get healthCloseTreatment => 'Close Treatment';

  @override
  String get healthVaccinationApplied => 'Vaccination marked as applied';

  @override
  String get healthVaccinationDeleted => 'Vaccination deleted';

  @override
  String get salesDetail => 'Sale Detail';

  @override
  String get salesNotFoundDetail => 'Sale not found';

  @override
  String get salesEditTooltip => 'Edit sale';

  @override
  String get salesClient => 'Client';

  @override
  String get salesDocument => 'Document';

  @override
  String get salesBirdCount => 'Number of birds';

  @override
  String get salesAvgWeight => 'Average weight';

  @override
  String get salesPricePerKg => 'Price per kg';

  @override
  String get salesSubtotal => 'Subtotal';

  @override
  String get salesCarcassYield => 'Carcass yield';

  @override
  String get salesDiscount => 'Discount';

  @override
  String get salesTotalAmount => 'TOTAL';

  @override
  String get salesProductDetails => 'Product Details';

  @override
  String get salesRegistrationInfo => 'Registration Information';

  @override
  String get salesActive => 'Active';

  @override
  String get salesCompleted => 'Completed';

  @override
  String get salesConfirmed => 'Confirmed';

  @override
  String get salesSold => 'Sold';

  @override
  String get salesClientName => 'Full name';

  @override
  String get salesClientNameHint => 'E.g.: John Smith';

  @override
  String get salesDocType => 'Document type *';

  @override
  String get salesDni => 'DNI';

  @override
  String get salesRuc => 'RUC';

  @override
  String get salesForeignCard => 'Foreign ID Card';

  @override
  String get salesDocNumber => 'Document number';

  @override
  String get salesContactPhone => 'Contact phone';

  @override
  String get salesPhoneHint => '9 digits';

  @override
  String get salesDraftFound => 'Draft found';

  @override
  String get salesDraftRestore =>
      'Would you like to restore the previously saved sale draft?';

  @override
  String get salesDraftRestored => 'Draft restored';

  @override
  String get costDetail => 'Cost Detail';

  @override
  String get costEditTooltip => 'Edit cost';

  @override
  String get costConcept => 'Concept';

  @override
  String get costInvoiceNumber => 'Invoice No.';

  @override
  String get costTypeFood => 'Feed';

  @override
  String get costTypeLabor => 'Labor';

  @override
  String get costTypeEnergy => 'Energy';

  @override
  String get costTypeMedicine => 'Medicine';

  @override
  String get costTypeMaintenance => 'Maintenance';

  @override
  String get costTypeWater => 'Water';

  @override
  String get costTypeTransport => 'Transport';

  @override
  String get costTypeAdmin => 'Administrative';

  @override
  String get costTypeDepreciation => 'Depreciation';

  @override
  String get costTypeFinancial => 'Financial';

  @override
  String get costTypeOther => 'Other';

  @override
  String get costDeleteConfirm => 'Delete Cost?';

  @override
  String get costDeletedSuccess => 'Cost deleted successfully';

  @override
  String get costNoCosts => 'No costs registered';

  @override
  String get costNotFound => 'No costs found';

  @override
  String get costRegisterNew => 'Register Cost';

  @override
  String get costRegisterNewTooltip => 'Register new cost';

  @override
  String get costType => 'Expense type';

  @override
  String get costDraftFound => 'Draft found';

  @override
  String get costExitConfirm => 'Leave without completing?';

  @override
  String get costAmount => 'Amount';

  @override
  String get costConceptHint => 'E.g.: Purchase of balanced feed';

  @override
  String get costSearchInventory => 'Search inventory (optional)...';

  @override
  String get costProviderHint => 'Supplier or company name';

  @override
  String get costInvoiceNumberLabel => 'Invoice/Receipt Number';

  @override
  String get costInvoiceHint => 'F001-00001234';

  @override
  String get costNotesHint => 'Additional notes about this expense';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get inventoryNewItem => 'New Item';

  @override
  String get inventorySearchHint => 'Search by name or code...';

  @override
  String get inventoryAddItem => 'Add Item';

  @override
  String get inventoryItemDetail => 'Item Detail';

  @override
  String get inventoryRegisterEntry => 'Register Entry';

  @override
  String get inventoryRegisterExit => 'Register Exit';

  @override
  String get inventoryAdjustStock => 'Adjust Stock';

  @override
  String get inventoryItemNotFound => 'Item not found';

  @override
  String get inventoryItemDeleted => 'Item deleted';

  @override
  String get inventoryBasic => 'Basic';

  @override
  String get inventoryImageSelected => 'Image selected';

  @override
  String get inventoryItemName => 'Item Name';

  @override
  String get inventoryItemNameHint => 'E.g.: Starter Feed';

  @override
  String get inventoryCodeSku => 'Code/SKU (optional)';

  @override
  String get inventoryCodeHint => 'E.g.: FD-001';

  @override
  String get inventoryDescriptionOptional => 'Description (optional)';

  @override
  String get inventoryDescriptionHint =>
      'Describe the product characteristics...';

  @override
  String get inventoryCurrentStock => 'Current Stock';

  @override
  String get inventoryMinStock => 'Minimum Stock';

  @override
  String get inventoryMaxStock => 'Maximum Stock';

  @override
  String get inventoryOptional => 'Optional';

  @override
  String get inventoryUnitPrice => 'Unit Price';

  @override
  String get inventoryProviderHint => 'Supplier name';

  @override
  String get inventoryStorageLocation => 'Storage Location';

  @override
  String get inventoryStorageHint => 'E.g.: Warehouse A, Shelf 3';

  @override
  String get inventoryExpiration => 'Expiration';

  @override
  String get inventoryProviderBatch => 'Supplier Batch';

  @override
  String get inventoryProviderBatchHint => 'Batch number';

  @override
  String get inventoryTakePhoto => 'Take Photo';

  @override
  String get inventoryGallery => 'Gallery';

  @override
  String get inventoryObservation => 'Observation';

  @override
  String get inventoryObservationHint => 'Reason or observation';

  @override
  String get inventoryPhysicalCount => 'E.g.: Physical count';

  @override
  String get inventoryAdjustReason => 'Adjustment reason';

  @override
  String get inventoryStockAdjusted => 'Stock adjusted correctly';

  @override
  String get inventorySelectProduct => 'Select product';

  @override
  String get inventorySearchProduct => 'Search inventory...';

  @override
  String get inventorySearchProductShort => 'Search product...';

  @override
  String get inventoryItemOptions => 'Item options';

  @override
  String get inventoryRemoveSelection => 'Remove selection';

  @override
  String get inventoryEnterProduct => 'Enter at least one product';

  @override
  String get inventoryEnterDescription => 'Enter a description';

  @override
  String get weightMinObserved => 'Minimum observed weight';

  @override
  String get weightMinHint => 'E.g.: 2200';

  @override
  String get batchFormWeightObsHint =>
      'Describe weighing conditions, bird behavior, environmental conditions, etc.';

  @override
  String get weightMaxObserved => 'Maximum observed weight';

  @override
  String get weightMethod => 'Weighing method';

  @override
  String get weightMethodHint => 'Select method';

  @override
  String get mortalityEventDescription => 'Event description';

  @override
  String get mortalityEventDescriptionHint =>
      'Describe symptoms, context, environmental conditions...';

  @override
  String get productionInfo => 'Information';

  @override
  String get productionClassification => 'Classification';

  @override
  String get productionTakePhoto => 'Take Photo';

  @override
  String get productionGallery => 'Gallery';

  @override
  String get productionEggsCollected => 'Eggs collected';

  @override
  String get productionEggsHint => 'E.g.: 850';

  @override
  String get productionSmallEggs => 'Small (S) - 43-53g';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get commonChangeStatus => 'Change status';

  @override
  String get commonCurrentStatus => 'Current status:';

  @override
  String get commonSelectNewStatus => 'Select new status:';

  @override
  String get commonErrorLoading => 'Error loading';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonRegister => 'Register';

  @override
  String get commonUnexpectedError => 'Unexpected error';

  @override
  String get commonSearchByNameCityAddress =>
      'Search by name, city or address...';

  @override
  String get commonEnterReason => 'Enter the reason';

  @override
  String get commonDescriptionOptional => 'Description (optional)';

  @override
  String get commonState => 'State';

  @override
  String get commonType => 'Type';

  @override
  String get commonNoPhotos => 'No photos added';

  @override
  String get commonSelectedPhotos => 'Selected photos';

  @override
  String get commonTakePhoto => 'Take Photo';

  @override
  String get commonFieldRequired => 'This field is required';

  @override
  String get commonInvalidValue => 'Invalid value';

  @override
  String get commonLoadingCharts => 'Loading charts...';

  @override
  String get commonNoRecordsWithFilters => 'No records match these filters';

  @override
  String get commonFilterCosts => 'Filter costs';

  @override
  String get commonApplyFiltersBtn => 'Apply filters';

  @override
  String get commonCloseBtn => 'Close';

  @override
  String get commonSelectType => 'Select type';

  @override
  String get commonSelectStatus => 'Select status';

  @override
  String get commonQuantity => 'Quantity';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonNoData => 'No data';

  @override
  String get commonRestoreBtn => 'Restore';

  @override
  String get commonDiscardBtn => 'Discard';

  @override
  String get farmName => 'Farm Name';

  @override
  String get farmNameHint => 'E.g.: San José Farm';

  @override
  String get farmNameRequired => 'Enter the farm name';

  @override
  String get farmNameMinLength => 'Name must be at least 3 characters';

  @override
  String get farmOwnerName => 'Owner';

  @override
  String get farmOwnerHint => 'Owner\'s full name';

  @override
  String get farmOwnerRequired => 'Enter the owner\'s name';

  @override
  String get farmDescriptionOptional => 'Description (optional)';

  @override
  String get farmCreateFarm => 'Create Farm';

  @override
  String get farmSearchHint => 'Search by name, city or address...';

  @override
  String get farmDetails => 'Details';

  @override
  String get farmEditTooltip => 'Edit farm';

  @override
  String get farmDeleteFarm => 'Delete farm';

  @override
  String get farmDashboardError => 'Error loading dashboard';

  @override
  String farmStatusUpdated(String status) {
    return 'Status updated to $status';
  }

  @override
  String farmErrorChangingStatus(Object error) {
    return 'Error changing status: $error';
  }

  @override
  String farmErrorDeleting(Object error) {
    return 'Error deleting farm: $error';
  }

  @override
  String farmErrorLoadingFarms(Object error) {
    return 'Error loading farms: $error';
  }

  @override
  String get farmConfirmInvitation => 'Confirm Invitation';

  @override
  String get farmSelectRole => 'Select Role';

  @override
  String farmErrorVerifyingPermissions(Object error) {
    return 'Error verifying permissions: $error';
  }

  @override
  String get farmManageCollaborators => 'Manage Collaborators';

  @override
  String get farmRefresh => 'Refresh';

  @override
  String get farmNoShedsRegistered => 'No sheds registered';

  @override
  String get farmCreateFirstShed => 'Create First Shed';

  @override
  String get farmNewShed => 'New Shed';

  @override
  String get farmTemperature => 'Temperature';

  @override
  String get farmErrorOriginalData =>
      'Error: Could not get the original farm data';

  @override
  String get shedName => 'Shed Name *';

  @override
  String get shedNameTooLong => 'Name too long';

  @override
  String get shedType => 'Shed Type *';

  @override
  String get shedRegistrationDate => 'Registration Date';

  @override
  String get shedNotFound => 'Shed not found';

  @override
  String get shedDetails => 'Details';

  @override
  String get shedEditTooltip => 'Edit shed';

  @override
  String get shedDeleteShed => 'Delete shed';

  @override
  String get shedCreated => 'Shed created';

  @override
  String get shedDeletedSuccess => 'Shed deleted successfully';

  @override
  String shedErrorDeleting(Object error) {
    return 'Error deleting: $error';
  }

  @override
  String shedErrorChangingStatus(Object error) {
    return 'Error changing status: $error';
  }

  @override
  String get shedCreateShed => 'Create Shed';

  @override
  String get shedCreateShedTooltip => 'Create new shed';

  @override
  String get shedSearchHint => 'Search by name, code or type...';

  @override
  String get shedSelectBatch => 'Select Batch';

  @override
  String get shedNoBatchesAvailable => 'No batches available';

  @override
  String get shedErrorLoadingBatches => 'Error loading batches';

  @override
  String shedNotAvailable(Object status) {
    return 'Shed not available ($status)';
  }

  @override
  String get shedScale => 'Scale';

  @override
  String get shedTemperatureSensor => 'Temperature';

  @override
  String get shedHumiditySensor => 'Humidity';

  @override
  String get shedCO2Sensor => 'CO2';

  @override
  String get shedAmmoniaSensor => 'Ammonia';

  @override
  String get shedAddTag => 'Add tag';

  @override
  String get shedSearchInventory => 'Search in inventory...';

  @override
  String get shedDateLabel => 'Date';

  @override
  String get shedStartDate => 'Start date';

  @override
  String get shedMaintenanceDescription => 'Maintenance description *';

  @override
  String get shedDisinfectionInfo => 'Operations will be limited.';

  @override
  String get shedDisinfectionTitle => 'Start disinfection';

  @override
  String shedDisinfectionMessage(Object name) {
    return 'Put \"$name\" in disinfection?';
  }

  @override
  String get shedMustSpecifyQuarantine =>
      'You must specify the quarantine reason';

  @override
  String get shedErrorOriginalData =>
      'Error: Could not get the original shed data';

  @override
  String shedSemantics(String code, String birds, Object name, Object status) {
    return 'Shed $name, code $code, $birds birds, status $status';
  }

  @override
  String get batchNoActiveSheds => 'No active sheds available';

  @override
  String get batchNoTransitions => 'No transitions available from this status.';

  @override
  String get batchEnterValidQuantity => 'Enter a valid quantity greater than 0';

  @override
  String get batchEnterFinalBirdCount => 'Enter the final bird count';

  @override
  String get batchFieldRequired => 'Required field';

  @override
  String get batchEnterValidNumber => 'Enter a valid number';

  @override
  String get batchNoRecordsMortality => 'No mortality records';

  @override
  String get batchLoadingFoods => 'Loading foods...';

  @override
  String get batchNoFoodsInventory => 'No foods in the inventory';

  @override
  String get batchEnterValidCost => 'Enter a valid cost';

  @override
  String get productionInfoTitle => 'Production Information';

  @override
  String get productionDailyCollection => 'Daily egg collection record';

  @override
  String get productionCannotExceedCollected => 'Cannot exceed collected eggs';

  @override
  String get productionRegistrationDate => 'Registration date';

  @override
  String get productionAcceptableYield => 'Acceptable yield';

  @override
  String get productionBelowExpected => 'Laying below expected';

  @override
  String get productionLayingIndicator => 'Laying Indicator';

  @override
  String get productionEggClassification => 'Egg Classification';

  @override
  String get productionQualitySizeDetail =>
      'Quality and size detail (optional)';

  @override
  String get productionDefectiveEggs => 'Defective Eggs';

  @override
  String get productionDirty => 'Dirty';

  @override
  String get productionSizeClassification => 'Size Classification';

  @override
  String productionTotalToClassify(Object count) {
    return 'Total to classify: $count good eggs';
  }

  @override
  String get productionClassificationSummary => 'Classification Summary';

  @override
  String get productionTotalClassified => 'Total classified';

  @override
  String get productionAvgWeightCalculated => 'Calculated Average Weight';

  @override
  String get productionObservationsEvidence => 'Observations and Evidence';

  @override
  String get productionSummary => 'Production Summary';

  @override
  String get productionLayingPercentage => 'Laying percentage';

  @override
  String get productionUtilization => 'Utilization';

  @override
  String get productionAvgWeight => 'Average weight';

  @override
  String get productionNoPhotos => 'No photos added';

  @override
  String get weightInfoTitle => 'Weighing Information';

  @override
  String get weightAvgWeight => 'Average weight';

  @override
  String get weightEnterAvgWeight => 'Enter the average weight';

  @override
  String get weightBirdCount => 'Number of birds weighed';

  @override
  String get weightEnterBirdCount => 'Enter the number of birds';

  @override
  String get weightMethodLabel => 'Weighing method';

  @override
  String get weightSelectMethod => 'Select method';

  @override
  String get weightDate => 'Weighing date';

  @override
  String get weightRangesTitle => 'Weight Ranges';

  @override
  String get weightMinMaxObserved => 'Minimum and maximum observed weight';

  @override
  String get weightEnterMinWeight => 'Enter the minimum weight';

  @override
  String get weightEnterMaxWeight => 'Enter the maximum weight';

  @override
  String get weightSummaryTitle => 'Weighing Summary';

  @override
  String get weightReviewMetrics =>
      'Review metrics and add photographic evidence';

  @override
  String get weightImportantInfo => 'Important information';

  @override
  String get weightTotalWeight => 'Total weight';

  @override
  String get weightGDP => 'GDP (Daily gain)';

  @override
  String get weightCoefficientVariation => 'Coefficient of variation';

  @override
  String get weightRange => 'Weight range';

  @override
  String get weightBirdsCounted => 'Birds weighed';

  @override
  String get mortalityBasicDetails => 'Basic details of the mortality event';

  @override
  String get salesEditLabel => 'Edit';

  @override
  String get salesDeleteLabel => 'Delete';

  @override
  String get salesSaleDate => 'Sale date';

  @override
  String salesDetailsOf(String product) {
    return 'Details of $product';
  }

  @override
  String get salesEnterDetails => 'Enter quantities, prices and other details';

  @override
  String get salesBirdCountLabel => 'Number of birds';

  @override
  String get salesBirdCountHint => 'E.g.: 100';

  @override
  String get salesEnterBirdCount => 'Enter the number of birds';

  @override
  String get salesQuantityGreaterThanZero => 'Quantity must be greater than 0';

  @override
  String get salesMaxQuantity => 'Maximum quantity is 1,000,000';

  @override
  String get salesTotalWeightKg => 'Total weight (kg)';

  @override
  String get salesDressedWeightKg => 'Dressed weight total (kg)';

  @override
  String get salesEnterTotalWeight => 'Enter the total weight';

  @override
  String get salesWeightGreaterThanZero => 'Weight must be greater than 0';

  @override
  String get salesMaxWeight => 'Maximum weight is 50,000 kg';

  @override
  String salesPricePerKgLabel(String currency) {
    return 'Price per kg ($currency)';
  }

  @override
  String get salesNoFarmSelected =>
      'No farm selected. Please select a farm first.';

  @override
  String get salesNoActiveBatches => 'No active batches in this farm.';

  @override
  String salesErrorLoadingBatches(Object error) {
    return 'Error loading batches: $error';
  }

  @override
  String get salesFormStepDetails => 'Details';

  @override
  String get salesUpdatedSuccess => 'Sale updated successfully';

  @override
  String get salesRegisteredSuccess => 'Sale registered successfully!';

  @override
  String get salesInventoryUpdateError =>
      'Sale registered, but there was an error updating inventory';

  @override
  String get salesQuantityInvalid => 'Invalid quantity';

  @override
  String get salesQuantityExcessive => 'Excessive quantity';

  @override
  String get salesPriceInvalid => 'Invalid price';

  @override
  String get salesPriceExcessive => 'Excessive price';

  @override
  String get salesQuantityLabel => 'Quantity';

  @override
  String salesPricePerDozen(String currency) {
    return '$currency per dozen';
  }

  @override
  String salesPollinazaQuantity(String unit) {
    return 'Quantity ($unit)';
  }

  @override
  String get salesEnterQuantity => 'Enter the quantity';

  @override
  String salesPollinazaPricePerUnit(Object currency, Object unit) {
    return 'Price per $unit ($currency)';
  }

  @override
  String get salesEditVenta => 'Edit Sale';

  @override
  String get salesLoadingError => 'Error loading the sale';

  @override
  String get salesTotalHuevos => 'Total eggs';

  @override
  String get salesFaenadoWeight => 'Dressed weight';

  @override
  String get salesYield => 'Yield';

  @override
  String get salesUnitPrice => 'Unit price';

  @override
  String get salesRegistrationDate => 'Registration date';

  @override
  String get salesObservations => 'Observations';

  @override
  String get costRegisteredSuccess => 'Cost registered successfully';

  @override
  String get costUpdatedSuccess => 'Cost updated successfully';

  @override
  String get costSelectExpenseType => 'Please select an expense type';

  @override
  String get costRegisterCost => 'Register Cost';

  @override
  String get costEditCost => 'Edit Cost';

  @override
  String get costFormStepType => 'Type';

  @override
  String get costFormStepAmount => 'Amount';

  @override
  String get costFormStepDetails => 'Details';

  @override
  String get costAmountTitle => 'Expense Amount';

  @override
  String get costConceptLabel => 'Expense concept';

  @override
  String get costEnterConcept => 'Enter the expense concept';

  @override
  String get costEnterAmount => 'Enter the amount';

  @override
  String get costEnterValidAmount => 'Enter a valid amount';

  @override
  String get costDateLabel => 'Expense date *';

  @override
  String get costRejectCost => 'Reject Cost';

  @override
  String get costRejectReasonLabel => 'Rejection reason';

  @override
  String get costRejectReasonHint => 'Explain why this cost is rejected';

  @override
  String get costEnterRejectReason => 'Enter a rejection reason';

  @override
  String get costRejectBtn => 'Reject';

  @override
  String costDeleteMessage(String concept) {
    return 'Are you sure you want to delete the cost \"$concept\"?\n\nThis action cannot be undone.';
  }

  @override
  String get costDeletedSuccessMsg => 'Cost deleted successfully';

  @override
  String costErrorDeleting(Object error) {
    return 'Error deleting: $error';
  }

  @override
  String get costLotCosts => 'Batch Costs';

  @override
  String get costAllCosts => 'All Costs';

  @override
  String get costNoCostsDescription =>
      'Register your operational expenses to keep a detailed cost control';

  @override
  String get costCostSummary => 'Cost Summary';

  @override
  String get costTotalInCosts => 'Total in costs';

  @override
  String get costApprovedCount => 'Approved';

  @override
  String get costPendingCount => 'Pending';

  @override
  String get costTotalCount => 'Total';

  @override
  String get costUserNotAuthenticated => 'User not authenticated';

  @override
  String costErrorApproving(Object error) {
    return 'Error approving: $error';
  }

  @override
  String costErrorRejecting(Object error) {
    return 'Error rejecting: $error';
  }

  @override
  String get costTypeOfExpense => 'Expense type';

  @override
  String get costGeneralInfo => 'General Information';

  @override
  String get costRegistrationInfo => 'Registration Information';

  @override
  String get costRegisteredBy => 'Registered by';

  @override
  String get costRole => 'Role';

  @override
  String get costRegistrationDate => 'Registration date';

  @override
  String get costLastUpdate => 'Last update';

  @override
  String get costNoStatus => 'No status';

  @override
  String get costStatusLabel => 'Status';

  @override
  String get costLotNotFound => 'Batch not found';

  @override
  String get costFarmNotFound => 'Farm not found';

  @override
  String get costProviderName => 'Name';

  @override
  String get costDeleteConfirmTitle => 'Delete Cost';

  @override
  String get costDeleteConfirmMessage =>
      'Are you sure you want to delete this cost?\n\nThis action cannot be undone.';

  @override
  String get costLinkedProduct => 'Linked product';

  @override
  String get costStockUpdateOnSave => 'Stock will be updated on save';

  @override
  String get costLinkToFoodInventory => 'Link to food inventory';

  @override
  String get costLinkToMedicineInventory => 'Link to medicine inventory';

  @override
  String get costAdditionalDetails => 'Additional Details';

  @override
  String get costComplementaryInfo => 'Complementary expense information';

  @override
  String get costProviderLabel => 'Provider';

  @override
  String get costProviderRequired => 'Enter the provider name';

  @override
  String get costProviderMinLength => 'Name must be at least 3 characters';

  @override
  String get costObservationsLabel => 'Observations';

  @override
  String get costFieldRequired => 'This field is required';

  @override
  String get costDraftRestoreMessage =>
      'Would you like to restore the previously saved draft?';

  @override
  String get costSavedMomentAgo => 'Saved a moment ago';

  @override
  String costSavedMinutesAgo(String minutes) {
    return 'Saved $minutes min ago';
  }

  @override
  String get inventoryConfirmDefault => 'Confirm';

  @override
  String get inventoryCancelDefault => 'Cancel';

  @override
  String get inventoryMovementType => 'Movement type';

  @override
  String get inventoryEnterQuantity => 'Enter a quantity';

  @override
  String get inventoryEnterValidNumber => 'Enter a valid number greater than 0';

  @override
  String get inventoryQuantityExceedsStock =>
      'Quantity exceeds available stock';

  @override
  String get inventoryProviderLabel => 'Provider';

  @override
  String get inventoryDeleteItem => 'Delete Item';

  @override
  String inventoryNewStock(Object unit) {
    return 'New stock ($unit)';
  }

  @override
  String get inventoryEntryRegistered => 'Entry registered';

  @override
  String get inventoryExitRegistered => 'Exit registered';

  @override
  String get inventoryNoItems => 'No items match the filters';

  @override
  String get inventoryNoMovementsSearch => 'No movements match your search';

  @override
  String get inventoryNoMovements => 'No movements registered yet';

  @override
  String get inventoryEditItem => 'Edit Item';

  @override
  String get inventoryNoProductsAvailable => 'No products available';

  @override
  String get inventoryErrorLoading => 'Error loading inventory';

  @override
  String get inventoryHistoryError => 'Error loading movements';

  @override
  String get inventoryHistoryNoFilters =>
      'No movements with the applied filters';

  @override
  String get inventoryMovementTypeLabel => 'Movement type';

  @override
  String get inventoryList => 'List';

  @override
  String get inventoryNoImage => 'No image added';

  @override
  String get inventoryExpirationDateOptional => 'Expiration date (optional)';

  @override
  String get inventorySelectDate => 'Select date';

  @override
  String get inventoryAdditionalDetails => 'Additional Details';

  @override
  String get inventoryStockSummary => 'Stock';

  @override
  String get inventoryTotalItems => 'Total Items';

  @override
  String get inventoryLowStock => 'Low Stock';

  @override
  String get inventoryOutOfStock => 'Out of Stock';

  @override
  String get inventoryExpiringSoon => 'Expiring Soon';

  @override
  String get inventoryDescriptionLabel => 'Description';

  @override
  String get inventoryRegistrationDate => 'Registration date';

  @override
  String get inventoryLastUpdate => 'Last update';

  @override
  String get inventoryRegisteredBy => 'Registered by';

  @override
  String inventoryError(Object error) {
    return 'Error: $error';
  }

  @override
  String get inventoryItemFormType => 'Type';

  @override
  String get inventoryItemFormBasic => 'Basic';

  @override
  String get inventoryItemFormStock => 'Stock';

  @override
  String get inventoryItemFormDetails => 'Details';

  @override
  String get inventoryImageError => 'Error selecting image';

  @override
  String get inventoryImageUploadFailed => 'Could not upload the image';

  @override
  String get inventoryImageSaveWithout =>
      'The item will be saved without an image';

  @override
  String get inventorySaveBtn => 'Save';

  @override
  String get healthSelectLocation => 'Select Location';

  @override
  String get healthSelectBatch => 'Select Batch';

  @override
  String get healthErrorLoadingFarms => 'Error loading farms';

  @override
  String get healthNoActiveBatches => 'No active batches';

  @override
  String get commonNext => 'Next';

  @override
  String get commonPrevious => 'Previous';

  @override
  String get commonSaving => 'Saving...';

  @override
  String get commonSavedJustNow => 'Saved just now';

  @override
  String commonSavedSecondsAgo(String seconds) {
    return 'Saved ${seconds}s ago';
  }

  @override
  String commonSavedMinutesAgo(Object minutes) {
    return 'Saved ${minutes}m ago';
  }

  @override
  String commonSavedHoursAgo(String hours) {
    return 'Saved ${hours}h ago';
  }

  @override
  String get commonExitWithoutComplete => 'Exit without completing?';

  @override
  String get commonVerifyConnection => 'Check your internet connection';

  @override
  String get commonOperationSuccess => 'Operation successful';

  @override
  String get farmStartFirstFarm => 'Start your first farm';

  @override
  String get farmStartFirstFarmDesc =>
      'Register your poultry farm and start managing your production efficiently';

  @override
  String get farmNoFarmsFound => 'No farms found';

  @override
  String get farmNoFarmsFoundHint =>
      'Try adjusting the filters or searching with different terms';

  @override
  String get farmCreateNewFarmTooltip => 'Create new farm';

  @override
  String get farmDeletedSuccess => 'Farm deleted successfully';

  @override
  String get farmFarmNotExists => 'The requested farm does not exist';

  @override
  String get farmGeneralInfo => 'General Information';

  @override
  String get farmNotes => 'Notes';

  @override
  String get farmActivate => 'Activate';

  @override
  String get farmActivateFarm => 'Activate farm';

  @override
  String farmActivateConfirmMsg(Object name) {
    return 'Activate \"$name\"?';
  }

  @override
  String get farmActivateInfo => 'You will be able to operate normally.';

  @override
  String get farmSuspend => 'Suspend';

  @override
  String get farmSuspendFarm => 'Suspend farm';

  @override
  String farmSuspendConfirmMsg(Object name) {
    return 'Suspend \"$name\"?';
  }

  @override
  String get farmSuspendInfo => 'You will not be able to create new batches.';

  @override
  String get farmMaintenanceFarm => 'Put in maintenance';

  @override
  String farmMaintenanceConfirmMsg(Object name) {
    return 'Put \"$name\" in maintenance?';
  }

  @override
  String get farmMaintenanceInfo => 'Operations will be limited.';

  @override
  String farmDeleteConfirmName(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get farmDeleteIrreversible => 'This action is irreversible:';

  @override
  String get farmDeleteWillRemoveShedsAll =>
      '• All sheds will be deleted\n• All batches will be deleted\n• All records will be deleted';

  @override
  String get farmWriteNameToConfirm => 'Type the name to confirm:';

  @override
  String get farmWriteHere => 'Type here';

  @override
  String get farmAlreadyActive => 'The farm is already active';

  @override
  String get farmAlreadySuspended => 'The farm is already suspended';

  @override
  String get farmActivatedSuccess => 'Farm activated successfully';

  @override
  String get farmSuspendedSuccess => 'Farm suspended successfully';

  @override
  String get farmMaintenanceSuccess => 'Farm put in maintenance';

  @override
  String get farmDraftFound => 'Draft found';

  @override
  String farmDraftFoundMsg(String date) {
    return 'A saved draft from $date was found.\nDo you want to restore it?';
  }

  @override
  String farmTodayAt(String time) {
    return 'today at $time';
  }

  @override
  String get farmYesterday => 'yesterday';

  @override
  String farmDaysAgo(String days) {
    return '$days days ago';
  }

  @override
  String get farmEnterBasicData => 'Enter the main data of your poultry farm';

  @override
  String get farmInfoUsedToIdentify =>
      'This data will be used to identify your farm in the system.';

  @override
  String get farmUserNotAuthenticated => 'User not authenticated';

  @override
  String get farmFilterAll => 'All';

  @override
  String get farmFilterActive => 'Active';

  @override
  String get farmFilterInactive => 'Inactive';

  @override
  String get farmFilterMaintenance => 'Maintenance';

  @override
  String farmSemantics(Object name, Object status) {
    return 'Farm $name, status $status';
  }

  @override
  String get farmViewSheds => 'View Sheds';

  @override
  String get farmStatusActiveDesc => 'Operating normally';

  @override
  String get farmStatusInactiveDesc => 'Operations suspended';

  @override
  String get farmStatusMaintenanceDesc => 'Under maintenance';

  @override
  String get farmContinueEditing => 'Continue editing';

  @override
  String get farmSelectCountry => 'Select the country';

  @override
  String get farmSelectDepartment => 'Select the department';

  @override
  String get farmSelectCity => 'Select the city';

  @override
  String get farmEnterAddress => 'Enter the address';

  @override
  String get farmAddressMinLength =>
      'Address must be at least 10 characters long';

  @override
  String get farmEnterEmail => 'Enter the email';

  @override
  String get farmEnterValidEmail => 'Enter a valid email';

  @override
  String get farmEnterPhone => 'Enter the phone number';

  @override
  String farmPhoneLength(String length) {
    return 'Phone number must have $length digits';
  }

  @override
  String get farmOnlyActiveCanMaintenance =>
      'Only an active farm can be put in maintenance';

  @override
  String get farmInfoCopiedToClipboard => 'Information copied to clipboard';

  @override
  String get farmTotalOccupation => 'Total Occupation';

  @override
  String get farmBirds => 'birds';

  @override
  String farmOfCapacityBirds(String capacity) {
    return 'of $capacity birds';
  }

  @override
  String get farmActiveSheds => 'Active Sheds';

  @override
  String farmOfTotal(String total) {
    return 'of $total';
  }

  @override
  String get farmBatchesInProduction => 'Batches in Production';

  @override
  String farmMoreSheds(Object count) {
    return '+ $count more shed(s)';
  }

  @override
  String get shedOccupation => 'Occupation';

  @override
  String shedBirdsCount(String current, Object max) {
    return '$current / $max birds';
  }

  @override
  String get commonViewAll => 'View All';

  @override
  String commonErrorWithDetail(Object error) {
    return 'Error: $error';
  }

  @override
  String get commonSummary2 => 'Summary';

  @override
  String get commonMaintShort => 'Maint.';

  @override
  String get commonMaintenance => 'Maintenance';

  @override
  String get commonNotDefined => 'Not defined';

  @override
  String get commonOccurredError => 'An error occurred';

  @override
  String get commonFieldIsRequired => 'This field is required';

  @override
  String commonFieldRequired2(String label) {
    return '$label is required';
  }

  @override
  String commonSelect(String field) {
    return 'Select $field';
  }

  @override
  String commonFirstSelect(Object field) {
    return 'First select $field';
  }

  @override
  String get commonMustBeValidNumber => 'Must be a valid number';

  @override
  String commonMustBeBetween(String min, Object max) {
    return 'Must be between $min and $max';
  }

  @override
  String get commonEnterValidNumber => 'Enter a valid number';

  @override
  String get commonVerifying => 'Verifying...';

  @override
  String get commonJoining => 'Joining...';

  @override
  String get commonUpdate2 => 'Update';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonYouTag => 'You';

  @override
  String get commonNoName => 'No name';

  @override
  String get commonNoEmail => 'No email';

  @override
  String commonSince(Object date) {
    return 'Since: $date';
  }

  @override
  String get commonPermissions => 'Permissions';

  @override
  String get commonSelected => 'Selected';

  @override
  String get commonShare => 'Share';

  @override
  String commonValidUntil(Object date) {
    return 'Valid until $date';
  }

  @override
  String get farmEnvironmentalThresholds => 'Environmental Thresholds';

  @override
  String get farmHumidity => 'Humidity';

  @override
  String get farmCo2Max => 'CO₂ Maximum';

  @override
  String get farmAmmoniaMax => 'Ammonia Maximum';

  @override
  String get farmCapacityInstallations => 'Capacity & Facilities';

  @override
  String get farmTechnicalDataOptional => 'Technical farm data (all optional)';

  @override
  String get farmMaxBirdCapacity => 'Maximum Bird Capacity';

  @override
  String get farmMaxBirdsLimit => 'Maximum 1,000,000 birds';

  @override
  String get farmTotalArea => 'Total Area';

  @override
  String get farmNumberOfSheds => 'Number of Sheds';

  @override
  String get farmShedsUnit => 'sheds';

  @override
  String get farmMaxShedsLimit => 'Maximum 100 sheds';

  @override
  String get farmUsefulInfo => 'Useful information';

  @override
  String get farmTechnicalDataHelp =>
      'This data will help plan batches and calculate population density.';

  @override
  String get farmPreciseLocation => 'Precise location';

  @override
  String get farmLocationHelp =>
      'A correct location facilitates logistics and technical visits.';

  @override
  String get farmExactLocation => 'Exact location of the farm';

  @override
  String get farmAddress => 'Address';

  @override
  String get farmAddressHint => 'E.g.: Main Ave 123, Neighborhood...';

  @override
  String get farmReferenceOptional => 'Reference (optional)';

  @override
  String get farmReferenceHint => 'Near..., in front of..., 2 blocks from...';

  @override
  String get farmGpsCoordinatesOptional => 'GPS Coordinates (optional)';

  @override
  String get farmLatitude => 'Latitude';

  @override
  String get farmLatitudeHint => 'E.g.: -12.0464';

  @override
  String get farmLongitude => 'Longitude';

  @override
  String get farmLongitudeHint => 'E.g.: -77.0428';

  @override
  String get farmContactInfo => 'Contact Information';

  @override
  String get farmContactInfoDesc => 'Contact details for communication';

  @override
  String get farmEmailLabel => 'Email Address';

  @override
  String get farmEmailHint => 'example@email.com';

  @override
  String get farmWhatsappOptional => 'WhatsApp (optional)';

  @override
  String get farmContactDataTitle => 'Contact data';

  @override
  String get farmContactDataHelp =>
      'This information will be used for important notifications.';

  @override
  String get farmPhoneLabel => 'Phone';

  @override
  String farmFiscalDocOptional(Object label) {
    return '$label (optional)';
  }

  @override
  String get farmInvalidRifFormat => 'Invalid RIF format (e.g.: J-12345678-9)';

  @override
  String farmRucMustHaveDigits(Object count) {
    return 'The RUC must have $count digits';
  }

  @override
  String get farmInvalidNitFormat => 'Invalid NIT format (e.g.: 900123456-7)';

  @override
  String get farmRucMustStartWith => 'The RUC must start with 10, 15, 17 or 20';

  @override
  String get farmCapacityHint => 'E.g.: 10000';

  @override
  String get farmAreaHint => 'E.g.: 5000';

  @override
  String get farmShedsHint => 'E.g.: 5';

  @override
  String get farmActiveFarmsLabel => 'Active';

  @override
  String get farmInactiveFarmsLabel => 'Inactive';

  @override
  String get farmStatusActive => 'Active';

  @override
  String get farmStatusInactive => 'Inactive';

  @override
  String get farmOverpopulationDetected => 'Overpopulation detected';

  @override
  String get farmOutdatedData => 'Outdated data';

  @override
  String get farmShedsWithoutBatches => 'Sheds without assigned batches';

  @override
  String get farmLoadDashboardError => 'Error loading dashboard';

  @override
  String get farmActiveBatches => 'Active Batches';

  @override
  String get farmActiveShedsLabel => 'Active Sheds';

  @override
  String get farmAlertsTitle => 'Alerts';

  @override
  String get farmInviteUser => 'Invite User';

  @override
  String get farmMustLoginToInvite => 'You must log in to invite users';

  @override
  String get farmNoPermToInvite =>
      'You don\'t have permission to invite users to this farm.\nOnly owners, administrators, and managers can invite.';

  @override
  String get farmNoPermissions => 'No Permissions';

  @override
  String get farmWhatRoleWillUserHave => 'What role will the user have?';

  @override
  String get farmChoosePermissions =>
      'Choose the permissions they will have on your farm';

  @override
  String get farmRoleFullControl => 'Full farm control';

  @override
  String get farmRoleFullManagement =>
      'Full management, without transferring ownership';

  @override
  String get farmRoleOperationsMgmt => 'Operations and staff management';

  @override
  String get farmRoleDailyRecords => 'Daily records and operational tasks';

  @override
  String get farmRoleViewOnly => 'View-only data access';

  @override
  String get farmPermAll => 'All';

  @override
  String get farmPermEdit => 'Edit';

  @override
  String get farmPermInvite => 'Invite';

  @override
  String get farmPermManage => 'Manage';

  @override
  String get farmPermRecords => 'Records';

  @override
  String get farmPermView => 'View';

  @override
  String get farmPermViewData => 'View data';

  @override
  String get farmPermReadOnly => 'Read only';

  @override
  String farmVerifyPermError(Object error) {
    return 'Error verifying permissions: $error';
  }

  @override
  String get farmGenerateCode => 'Generate Code';

  @override
  String get farmGenerateNewCode => 'Generate new code';

  @override
  String get farmCodeGenerated => 'Code generated!';

  @override
  String farmInvitationSubject(Object farmName) {
    return 'Invitation to $farmName';
  }

  @override
  String farmInvitationMessage(
    String farmName,
    String code,
    String role,
    String expiry,
  ) {
    return 'I invite you to collaborate on my farm \"$farmName\"! Use the code: $code\nRole: $role\nValid until: $expiry';
  }

  @override
  String farmCollaboratorsCount(Object count) {
    return '$count collaborator(s)';
  }

  @override
  String get farmInviteCollaboratorToFarm => 'Invite collaborator to the farm';

  @override
  String get farmNoCollaborators => 'No collaborators';

  @override
  String get farmInviteHelpText =>
      'Invite other users so they can help you manage this farm.';

  @override
  String get farmChangeRoleTo => 'Change role to:';

  @override
  String get farmLeaveFarm => 'Leave farm';

  @override
  String get farmRemoveUser => 'Remove user';

  @override
  String get farmCannotChangeOwnerRole => 'Cannot change the owner\'s role';

  @override
  String get farmCannotRemoveOwner => 'Cannot remove the owner';

  @override
  String get farmRemoveCollaborator => 'Remove Collaborator';

  @override
  String get farmConfirmLeave => 'Are you sure you want to leave this farm?';

  @override
  String get farmConfirmRemoveUser =>
      'Are you sure you want to remove this user?';

  @override
  String get farmLeaveAction => 'Leave';

  @override
  String get farmRemoveAction => 'Remove';

  @override
  String get farmLeftFarm => 'You have left the farm';

  @override
  String get farmCollaboratorRemoved => 'Collaborator removed';

  @override
  String get farmJoinFarm => 'Join Farm';

  @override
  String get farmCodeValid => 'Valid code!';

  @override
  String get farmInvitedBy => 'Invited by';

  @override
  String get farmWhatRoleYouWillHave => 'What role will you have?';

  @override
  String get farmJoinTheFarm => 'Join the Farm';

  @override
  String get farmUseAnotherCode => 'Use another code';

  @override
  String get farmWelcome => 'Welcome!';

  @override
  String get farmJoinedSuccessTo => 'You have successfully joined';

  @override
  String farmAsRole(Object role) {
    return 'As $role';
  }

  @override
  String get farmViewMyFarms => 'View My Farms';

  @override
  String get farmHaveInvitation => 'Do you have an invitation?';

  @override
  String get farmEnterSharedCode =>
      'Enter the code that was shared with you to join a farm';

  @override
  String get farmInvitationCode => 'Invitation Code';

  @override
  String get farmVerifyCode => 'Verify Code';

  @override
  String get farmEnterValidCode => 'Enter a valid code';

  @override
  String get farmInvalidCodeFormat => 'The code format is not valid';

  @override
  String get farmCodeNotFound => 'Invitation code not found';

  @override
  String get farmCodeAlreadyUsed => 'This code has already been used';

  @override
  String get farmCodeExpired => 'This code has expired';

  @override
  String get farmCodeNotValidOrExpired =>
      'Invitation code not valid or expired';

  @override
  String get farmCodeHasExpiredLong => 'This invitation code has expired';

  @override
  String get farmMustLoginToAccept => 'You must log in to accept invitations';

  @override
  String get farmAlreadyMember => 'You are already a member of this farm';

  @override
  String get farmAssigned => 'Assigned';

  @override
  String get farmGranjaLabel => 'Farm';

  @override
  String get farmPermFullControl => 'Full control';

  @override
  String get farmPermFullManagement => 'Full management';

  @override
  String get farmPermDeleteFarm => 'Delete farm';

  @override
  String get farmPermEditData => 'Edit data';

  @override
  String get farmPermInviteUsers => 'Invite users';

  @override
  String get farmPermManageCollaborators => 'Manage collaborators';

  @override
  String get farmPermViewRecords => 'View records';

  @override
  String get farmPermCreateRecords => 'Create records';

  @override
  String get farmPermRegisterTasks => 'Register tasks';

  @override
  String get farmPermViewStats => 'View statistics';

  @override
  String get farmPermissions => 'Permissions';

  @override
  String get commonGoToHome => 'Go to Home';

  @override
  String get farmTheFarm => 'the farm';

  @override
  String get commonCheckConnection => 'Check your connection.';

  @override
  String get commonExitWithoutSaving => 'Exit without saving?';

  @override
  String get commonYouHaveUnsavedChanges => 'You have unsaved changes.';

  @override
  String get commonContinueEditing => 'Continue editing';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonJustNow => 'just now';

  @override
  String commonSecondsAgo(Object seconds) {
    return '${seconds}s ago';
  }

  @override
  String commonMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String commonHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String get commonYesterday => 'yesterday';

  @override
  String commonDaysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String commonTodayAt(Object time) {
    return 'today at $time';
  }

  @override
  String commonSavedAt(Object time) {
    return 'Saved $time';
  }

  @override
  String get commonActivePlural => 'Active';

  @override
  String get commonInactivePlural => 'Inactive';

  @override
  String get commonAdjustFilters =>
      'Try adjusting the filters or searching with other terms';

  @override
  String get shedStepBasic => 'Basic';

  @override
  String get shedStepSpecifications => 'Specifications';

  @override
  String get shedStepEnvironment => 'Environment';

  @override
  String get shedDraftFound => 'Draft found';

  @override
  String shedDraftFoundMessage(Object date) {
    return 'A saved draft from $date was found.\nWould you like to restore it?';
  }

  @override
  String shedCreatedSuccess(Object name) {
    return 'Shed \"$name\" created!';
  }

  @override
  String shedUpdatedSuccess(Object name) {
    return 'Shed \"$name\" updated!';
  }

  @override
  String get shedExitWithoutCompleting => 'Exit without completing?';

  @override
  String get shedDataIsSafe => 'Don\'t worry, your data is safe.';

  @override
  String get shedStartFirstShed => 'Start your first shed';

  @override
  String get shedStartFirstShedDesc =>
      'Register your first poultry shed and start managing production';

  @override
  String get shedNoShedsFound => 'No sheds found';

  @override
  String get shedDeletedMsg => 'Shed deleted';

  @override
  String get shedDeletedCorrectly => 'Shed deleted successfully';

  @override
  String get shedChangeStatus => 'Change status';

  @override
  String get shedGeneralInfo => 'General Information';

  @override
  String get shedInfrastructure => 'Infrastructure';

  @override
  String get shedSensorsEquipment => 'Sensors and Equipment';

  @override
  String get shedGeneralStats => 'General Statistics';

  @override
  String get shedByStatus => 'By status';

  @override
  String get shedNoTags => 'No tags';

  @override
  String get shedRequestedNotExist => 'The requested shed does not exist';

  @override
  String get shedDisinfection => 'Disinfection';

  @override
  String get shedQuarantine => 'Quarantine';

  @override
  String get shedSelectType => 'Select shed type';

  @override
  String get shedEnterBirdCapacity => 'Enter bird capacity';

  @override
  String get shedCapacityMustBePositive => 'Capacity must be greater than 0';

  @override
  String get shedCapacityTooHigh => 'Capacity seems too high';

  @override
  String get shedEnterArea => 'Enter area in m²';

  @override
  String get shedAreaMustBePositive => 'Area must be greater than 0';

  @override
  String get shedAreaTooLarge => 'Area seems too large';

  @override
  String get shedEnterMaxTemp => 'Enter maximum temperature';

  @override
  String get shedEnterMinTemp => 'Enter minimum temperature';

  @override
  String get shedTempMinLessThanMax =>
      'Minimum temperature must be less than maximum';

  @override
  String get shedEnterMaxHumidity => 'Enter maximum humidity';

  @override
  String get shedEnterMinHumidity => 'Enter minimum humidity';

  @override
  String get shedHumidityMinLessThanMax =>
      'Minimum humidity must be less than maximum';

  @override
  String get shedBasicInfo => 'Basic Information';

  @override
  String get shedBasicInfoDesc => 'Enter the main data of the poultry shed';

  @override
  String get shedNameHint => 'E.g.: Main Shed, North Layers';

  @override
  String get shedMinChars => 'Minimum 3 characters';

  @override
  String get shedDescriptionOptional => 'Description (optional)';

  @override
  String get shedDescriptionHint =>
      'Describe the main characteristics of the shed...';

  @override
  String get shedSelectShedType => 'Select a shed type';

  @override
  String get shedImportantInfo => 'Important information';

  @override
  String get shedCodeAutoGenerated =>
      'The shed code is automatically generated based on the farm name and the number of existing sheds.';

  @override
  String get shedSpecsDesc =>
      'Configure the capacity and equipment of the shed';

  @override
  String get shedMaxBirdCapacity => 'Maximum Bird Capacity';

  @override
  String get shedMustBeValidNumber => 'Must be a valid number';

  @override
  String get shedMustBePositiveNumber => 'Must be a positive number';

  @override
  String get shedNumberTooLarge => 'The number is too large';

  @override
  String get shedTotalArea => 'Total Area';

  @override
  String get shedAreaRequired => 'Area is required';

  @override
  String get shedNumberSeemsHigh => 'The number seems too high';

  @override
  String get shedUsefulInfo => 'Useful information';

  @override
  String get shedDensityPlanningHelp =>
      'This data will help plan batches and calculate population density.';

  @override
  String get shedRecommendedDensities => 'Recommended densities';

  @override
  String get shedEnvironmentalConditions => 'Environmental Conditions';

  @override
  String get shedMinLabel => 'Minimum';

  @override
  String get shedMaxLabel => 'Maximum';

  @override
  String get shedInvalidTempRange => 'Invalid value (0-50)';

  @override
  String get shedRelativeHumidity => 'Relative Humidity';

  @override
  String get shedInvalidHumidityRange => 'Invalid value (0-100)';

  @override
  String get shedVentilation => 'Ventilation';

  @override
  String get shedInvalidValue => 'Invalid value';

  @override
  String get shedEnvironmentalAlertHelp =>
      'The configured environmental values will be used to generate automatic alerts when actual conditions are outside the specified range.';

  @override
  String get shedShedType => 'Shed Type';

  @override
  String get shedMaxCapacity => 'Maximum Capacity';

  @override
  String get shedCurrentBirdsLabel => 'Current Birds';

  @override
  String shedCurrentBirdsValue(Object count) {
    return '$count birds';
  }

  @override
  String get shedOccupationLabel => 'Occupancy';

  @override
  String get shedAreaLabel => 'Area';

  @override
  String get shedLocationLabel => 'Location';

  @override
  String get shedOccupationTitle => 'Shed Occupancy';

  @override
  String get shedOptimal => 'Optimal';

  @override
  String get shedAdjust => 'Adjust';

  @override
  String get shedVentilationSystem => 'Ventilation System';

  @override
  String get shedHeatingSystem => 'Heating System';

  @override
  String get shedLightingSystem => 'Lighting System';

  @override
  String get shedAmmonia => 'Ammonia';

  @override
  String get shedAssignBatch => 'Assign batch';

  @override
  String get shedRegisterDisinfection => 'Register\nDisinfection';

  @override
  String shedDisinfectedDaysAgo(Object days) {
    return 'Disinfected $days days ago';
  }

  @override
  String shedMaintenanceOverdue(Object days) {
    return 'Maintenance overdue by $days days';
  }

  @override
  String get shedMaintenanceToday => 'Maintenance scheduled for today';

  @override
  String shedMaintenanceInDays(Object days) {
    return 'Maintenance in $days days';
  }

  @override
  String get shedViewBatches => 'View Batches';

  @override
  String get shedRegisterDisinfectionAction => 'Register\nDisinfection';

  @override
  String get shedActiveBatch => 'Active Batch';

  @override
  String get shedAvailableForNewBatch =>
      'This shed is available to receive a new batch';

  @override
  String get shedAssignBatchLabel => 'Assign Batch';

  @override
  String shedNotAvailableForBatch(Object status) {
    return 'Shed not available ($status)';
  }

  @override
  String get shedNotAvailableForAssign =>
      'The shed is not available for batch assignment';

  @override
  String get shedNoBatchAssigned => 'The shed has no assigned batch';

  @override
  String get shedInfoCopied => 'Information copied to clipboard';

  @override
  String get shedCannotDeleteWithBatch =>
      'Cannot delete a shed with an assigned batch';

  @override
  String get shedSelectBatchForAssign => 'Select a batch to assign to the shed';

  @override
  String get shedHistoryTitle => 'Shed History';

  @override
  String get shedEventsAppearHere => 'Shed events will appear here';

  @override
  String get shedCreatedEvent => 'Shed created';

  @override
  String shedCreatedEventDesc(Object name) {
    return 'Shed $name was registered';
  }

  @override
  String get shedDisinfectionDone => 'Disinfection performed';

  @override
  String get shedDisinfectionDoneDesc => 'Shed disinfection was performed';

  @override
  String get shedMaintenanceOverdueEvent => 'Maintenance overdue';

  @override
  String get shedMaintenanceScheduledEvent => 'Maintenance scheduled';

  @override
  String get shedMaintenanceOverdueDesc =>
      'Maintenance was scheduled for this date';

  @override
  String get shedMaintenanceScheduledDesc => 'Next shed maintenance';

  @override
  String get shedBatchFinished => 'Batch finished';

  @override
  String shedBatchFinishedDesc(String id) {
    return 'Batch $id was finished';
  }

  @override
  String get shedLastUpdate => 'Last update';

  @override
  String get shedLastUpdateDesc => 'Shed information was updated';

  @override
  String get shedOccupancyLevel => 'Occupancy level';

  @override
  String get shedAssignedBatch => 'Assigned batch';

  @override
  String get shedLastDisinfection => 'Last disinfection';

  @override
  String get shedNextMaintenance => 'Next maintenance';

  @override
  String shedDaysAgoLabel(Object days) {
    return '$days days ago';
  }

  @override
  String shedOverdueDaysAgo(Object days) {
    return 'Overdue by $days days';
  }

  @override
  String get shedToday => 'Today';

  @override
  String shedInDays(Object days) {
    return 'In $days days';
  }

  @override
  String get shedStatsTitle => 'Shed Statistics';

  @override
  String get shedTotalCapacity => 'Total Capacity';

  @override
  String get shedTotalBirds => 'Total Birds';

  @override
  String get shedStatsRealtime => 'Statistics are updated in real time';

  @override
  String get shedViewActiveBatch => 'View Active Batch';

  @override
  String get shedFilterSheds => 'Filter sheds';

  @override
  String get shedSelectStatus => 'Select status';

  @override
  String get shedSelectTypeFilter => 'Select type';

  @override
  String get shedMinCapacity => 'Minimum capacity';

  @override
  String get shedActivateTitle => 'Activate shed';

  @override
  String get shedActivateAction => 'Activate';

  @override
  String get shedActivateInfo => 'You will be able to operate normally.';

  @override
  String get shedSuspendTitle => 'Suspend shed';

  @override
  String get shedSuspendAction => 'Suspend';

  @override
  String get shedSuspendInfo => 'You will not be able to create new batches.';

  @override
  String get shedMaintenanceTitle => 'Set to maintenance';

  @override
  String get shedMaintenanceInfo => 'Operations will be limited.';

  @override
  String get shedDisinfectionAction => 'Confirm';

  @override
  String get shedDisinfectionAvailInfo => 'The shed will not be available.';

  @override
  String get shedReleaseTitle => 'Release shed';

  @override
  String get shedReleaseAction => 'Release';

  @override
  String get shedReleaseInfo => 'The current batch will be unlinked.';

  @override
  String get shedDeleteTitle => 'Delete shed';

  @override
  String shedDeleteConfirmMsg(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get shedDeleteIrreversible => 'This action is irreversible:';

  @override
  String get shedDeleteConsequences =>
      ' Shed records will be deleted\n Associated batches will be unlinked\n Operation history will be lost';

  @override
  String get shedWriteHere => 'Write here';

  @override
  String get shedStatusActiveDesc => 'Normal operation enabled';

  @override
  String get shedStatusInactiveDesc => 'Operations temporarily paused';

  @override
  String get shedStatusMaintenanceDesc => 'Under maintenance';

  @override
  String get shedStatusQuarantineDesc => 'Isolated for sanitary quarantine';

  @override
  String get shedStatusDisinfectionDesc => 'Under disinfection';

  @override
  String get shedRegisterDisinfectionTitle => 'Register disinfection';

  @override
  String get shedSelectProductsFromInventory =>
      'Select products from inventory to automatically deduct';

  @override
  String get shedAdditionalObservations => 'Additional observations';

  @override
  String get shedScheduleMaintenance => 'Schedule maintenance';

  @override
  String get shedMaintenanceDescriptionLabel => 'Maintenance description *';

  @override
  String get shedMaintenanceDescriptionHint =>
      'E.g.: Review of drinkers and feeders';

  @override
  String get shedEnterDescription => 'Enter a description';

  @override
  String shedWeeksAgo(Object count, Object label) {
    return '$count $label ago';
  }

  @override
  String get shedWeek => 'week';

  @override
  String get shedWeeks => 'weeks';

  @override
  String get shedMonth => 'month';

  @override
  String get shedMonths => 'months';

  @override
  String get shedYear => 'year';

  @override
  String get shedYears => 'years';

  @override
  String get shedNotSpecified => 'Not specified';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonSchedule => 'Schedule';

  @override
  String get commonReason => 'Reason';

  @override
  String get shedCurrentState => 'Current status:';

  @override
  String get shedSelectNewState => 'Select new status:';

  @override
  String get shedWriteNameToConfirm => 'Type the name to confirm:';

  @override
  String get shedSelectProductsDesc => 'Inventory products';

  @override
  String get shedProductsUsed => 'Products used *';

  @override
  String get shedProductsHint => 'E.g.: Quaternary ammonium, Quicklime';

  @override
  String get shedSeparateWithCommas => 'Separate multiple products with commas';

  @override
  String get shedObservationsHint => 'Additional observations';

  @override
  String get shedEnterAtLeastOneProduct => 'Enter at least one product';

  @override
  String get shedEnterReason => 'Enter the reason';

  @override
  String get shedStartDateLabel => 'Start date';

  @override
  String get shedCorralsDivisions => 'Corrals/Divisions';

  @override
  String shedDivisionsCount(Object count) {
    return '$count divisions';
  }

  @override
  String get shedWateringSystem => 'Watering System';

  @override
  String get shedFeederSystem => 'Feeder System';

  @override
  String get shedChangeStateAction => 'Change status';

  @override
  String get shedReleaseLabel => 'Release';

  @override
  String get shedDensityLabel => 'Density';

  @override
  String shedMSquarePerBird(String value) {
    return '$value m² per bird';
  }

  @override
  String shedOfCapacity(String percentage) {
    return '$percentage% of capacity';
  }

  @override
  String shedOfBirdsUnit(Object count) {
    return 'of $count birds';
  }

  @override
  String get shedScheduleMaintenanceGrid => 'Schedule\nMaintenance';

  @override
  String get shedViewHistory => 'View\nHistory';

  @override
  String get shedViewBatchDetail => 'View Batch Detail';

  @override
  String get shedNoAssignedBatch => 'No assigned batch';

  @override
  String get commonAvailable => 'Available';

  @override
  String get shedQuarantineReason => 'Quarantine reason';

  @override
  String shedBatchAssignedMsg(Object code) {
    return 'Batch $code assigned successfully';
  }

  @override
  String shedDeleteErrorMsg(Object message) {
    return 'Error deleting: $message';
  }

  @override
  String get shedCreateBatchFirst => 'Create a new batch first';

  @override
  String get commonToday => 'Today';

  @override
  String get shedNoHistoryAvailable => 'No history available';

  @override
  String get commonAssigned => 'Assigned';

  @override
  String shedBirdsOfCapacity(Object current, Object max) {
    return '$current / $max birds';
  }

  @override
  String shedShedsRegistered(Object count) {
    return '$count registered sheds';
  }

  @override
  String get shedMoreOptions => 'More options';

  @override
  String get shedOccurredError => 'An error occurred';

  @override
  String get shedSpecifications => 'Specifications';

  @override
  String get shedConfigureThresholds =>
      'Configure monitoring thresholds (optional)';

  @override
  String get shedCapacityIsRequired => 'Capacity is required';

  @override
  String get shedNameIsRequired => 'Name is required';

  @override
  String get shedShedNameLabel => 'Shed Name';

  @override
  String get shedTypeLabel => 'Shed Type';

  @override
  String get shedSelectTypeHint => 'Select type';

  @override
  String get shedSelectStateHint => 'Select state';

  @override
  String get shedDrinkersOptional => 'Drinkers (optional)';

  @override
  String get shedFeedersOptional => 'Feeders (optional)';

  @override
  String get shedNestsOptional => 'Nests (optional)';

  @override
  String get shedTemperature => 'Temperature';

  @override
  String get shedTip => 'Tip';

  @override
  String get shedUnitsLabel => 'units';

  @override
  String get shedDensityTypeCol => 'Type';

  @override
  String get shedDensityCol => 'Density';

  @override
  String get shedFattening => 'Fattening';

  @override
  String get shedLaying => 'Laying';

  @override
  String get shedBreeder => 'Breeder';

  @override
  String get shedActive => 'Active';

  @override
  String get shedInactive => 'Inactive';

  @override
  String shedSemanticsLabel(
    Object birds,
    Object code,
    Object name,
    Object status,
  ) {
    return 'Shed $name, code $code, $birds birds, status $status';
  }

  @override
  String shedShareType(Object type) {
    return 'Type: $type';
  }

  @override
  String shedShareCapacity(Object count) {
    return 'Capacity: $count birds';
  }

  @override
  String shedShareOccupation(Object percentage) {
    return 'Occupation: $percentage%';
  }

  @override
  String shedBirdsBullet(Object count, Object type) {
    return '$count birds • $type';
  }

  @override
  String batchSemanticsLabel(
    String birdType,
    Object birds,
    Object code,
    Object status,
  ) {
    return 'Batch $code, $birdType, $birds birds, status $status';
  }

  @override
  String get batchDetails => 'Details';

  @override
  String get batchViewRecords => 'View Records';

  @override
  String get batchMoreOptions => 'More options';

  @override
  String get batchMoreOptionsLote => 'More batch options';

  @override
  String get batchRetryLoadSemantics => 'Retry loading batches';

  @override
  String get batchStatusActive => 'Active';

  @override
  String get batchStatusClosed => 'Closed';

  @override
  String get batchStatusQuarantine => 'Quarantine';

  @override
  String get batchStatusSold => 'Sold';

  @override
  String get batchStatusTransfer => 'Transfer';

  @override
  String get batchStatusSuspended => 'Suspended';

  @override
  String get batchType => 'Type';

  @override
  String get batchBirds => 'Birds';

  @override
  String get batchAge => 'Age';

  @override
  String get batchCloseBatch => 'Close Batch';

  @override
  String get batchConfirmClose => 'Confirm Close';

  @override
  String get batchCloseIrreversibleWarning =>
      'This action is IRREVERSIBLE. The batch will be closed and the shed will become available.\n\nAre you sure you want to close this batch?';

  @override
  String get batchClosureData => 'Closure Data';

  @override
  String get batchCompleteClosureInfo => 'Complete the final batch information';

  @override
  String get batchLoteInfo => 'Batch Information';

  @override
  String batchInitialCountBirds(Object count) {
    return '$count birds';
  }

  @override
  String batchDaysInCycle(Object days) {
    return '$days days';
  }

  @override
  String get batchCloseDateLabel => 'Close Date *';

  @override
  String get batchCloseDateSimple => 'Close Date';

  @override
  String get batchCloseDateHelper => 'Date the batch is being closed';

  @override
  String get batchCloseDatePicker => 'Batch close date';

  @override
  String get batchFinalBirdCount => 'Final Bird Count *';

  @override
  String batchFinalBirdCountHelper(Object max) {
    return 'Number of live birds at closing (max: $max)';
  }

  @override
  String get batchFinalAvgWeight => 'Final Average Weight';

  @override
  String get batchFinalAvgWeightHint => 'E.g.: 2500';

  @override
  String get batchFinalAvgWeightHelper =>
      'Average bird weight at closing (in grams)';

  @override
  String get batchClosureReason => 'Closure Reason';

  @override
  String get batchClosureReasonHint => 'E.g.: End of production cycle';

  @override
  String get batchClosureReasonHelper =>
      'Optional - Reason for closing the batch';

  @override
  String get batchAdditionalNotes => 'Additional Notes';

  @override
  String get batchAdditionalNotesHint => 'Final batch notes...';

  @override
  String get batchBatchMetrics => 'Batch Metrics';

  @override
  String get batchCycleIndicators => 'Summary of production cycle indicators';

  @override
  String get batchSurvival => 'Survival';

  @override
  String get batchInitialBirds => 'Initial Birds';

  @override
  String get batchFinalBirds => 'Final Birds';

  @override
  String get batchTotalMortality => 'Total Mortality';

  @override
  String batchMortalityBirds(Object count) {
    return '$count birds';
  }

  @override
  String get batchMortalityPercent => '% Mortality';

  @override
  String get batchSurvivalPercent => '% Survival';

  @override
  String get batchCycleDuration => 'Cycle Duration';

  @override
  String get batchTotalDuration => 'Total Duration';

  @override
  String get batchAgeAtClose => 'Age at Close';

  @override
  String batchAgeAtCloseDays(Object days) {
    return '$days days';
  }

  @override
  String get batchWeight => 'Weight';

  @override
  String get batchCurrentAvgWeightLabel => 'Current Average Weight';

  @override
  String get batchTargetWeight => 'Target Weight';

  @override
  String get batchClosureSummary => 'Closure Summary';

  @override
  String get batchClosureSummaryWarning =>
      'Review all information carefully before confirming closure. This action is IRREVERSIBLE.';

  @override
  String get batchCloseWarningMessage =>
      'When closing the batch, it will change to CLOSED status and the shed will become available for a new batch.';

  @override
  String get batchFinalData => 'Final Data';

  @override
  String get batchFinalCount => 'Final Count';

  @override
  String get batchMortalityTotal => 'Total Mortality';

  @override
  String get batchFinalWeightAvg => 'Final Average Weight';

  @override
  String get batchClosureNotes => 'Closure Notes';

  @override
  String get batchReason => 'Reason';

  @override
  String get batchObservations => 'Observations';

  @override
  String get batchPrevious => 'Previous';

  @override
  String get batchNext => 'Next';

  @override
  String get batchClosing => 'Closing batch...';

  @override
  String get batchCannotBeNegative => 'Cannot be negative';

  @override
  String get batchCannotExceedInitial => 'Cannot exceed initial count';

  @override
  String get batchInvalidCount => 'Invalid count';

  @override
  String get batchFinalCannotExceedInitial =>
      'Final count cannot exceed initial count';

  @override
  String get batchNormalCycleClose => 'Normal cycle close';

  @override
  String batchErrorClosing(Object error) {
    return 'Error closing batch: $error';
  }

  @override
  String get batchDraftFound => 'Draft found';

  @override
  String batchDraftMessage(Object date) {
    return 'A saved draft from $date was found.\nDo you want to restore it?';
  }

  @override
  String get batchDraftRestore => 'Restore';

  @override
  String get batchDraftDiscard => 'Discard';

  @override
  String get batchExitWithoutComplete => 'Exit without completing?';

  @override
  String get batchDataSafe => 'Don\'t worry, your data is safe.';

  @override
  String get batchExit => 'Exit';

  @override
  String get batchSessionExpired =>
      'Your session has expired. Please sign in again';

  @override
  String get batchSaving => 'Saving...';

  @override
  String batchSavedTime(Object time) {
    return 'Saved $time';
  }

  @override
  String get batchRightNow => 'right now';

  @override
  String batchSecondsAgo(Object seconds) {
    return '${seconds}s ago';
  }

  @override
  String batchMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String batchHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String batchTodayAt(Object time) {
    return 'today at $time';
  }

  @override
  String get batchYesterday => 'yesterday';

  @override
  String batchDaysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get batchCreateSuccess => 'Batch created successfully!';

  @override
  String batchCreateSuccessDetail(Object code) {
    return '\"$code\" is ready to manage';
  }

  @override
  String get batchErrorCreating => 'Error creating batch';

  @override
  String get batchUnexpectedError => 'Unexpected error';

  @override
  String get batchCheckConnection =>
      'Please check your connection and try again';

  @override
  String get batchBasicStep => 'Basic';

  @override
  String get batchDetailsStep => 'Details';

  @override
  String get batchDataStep => 'Data';

  @override
  String get batchMetricsStep => 'Metrics';

  @override
  String get batchConfirmStep => 'Confirm';

  @override
  String get batchInfoStep => 'Information';

  @override
  String get batchRangesStep => 'Ranges';

  @override
  String get batchSummaryStep => 'Summary';

  @override
  String get batchDescriptionStep => 'Description';

  @override
  String get batchEvidenceStep => 'Evidence';

  @override
  String get batchRegister => 'Register';

  @override
  String get batchWaitProcess => 'Wait for the current process to finish';

  @override
  String get batchWaitForProcess => 'Wait for the process to finish';

  @override
  String get batchErrorLoadingData => 'Error loading data';

  @override
  String get batchLoadingCharts => 'Loading charts...';

  @override
  String get batchChartsProduction => 'Production Charts';

  @override
  String get batchChartsWeight => 'Weight Charts';

  @override
  String get batchChartsMortality => 'Mortality Charts';

  @override
  String get batchChartsConsumption => 'Consumption Charts';

  @override
  String get batchRefresh => 'Refresh';

  @override
  String get batchRefreshData => 'Refresh data';

  @override
  String get batchProductionHistory => 'Production history';

  @override
  String get batchWeighingHistory => 'Weighing history';

  @override
  String get batchMortalityHistory => 'Mortality history';

  @override
  String get batchConsumptionHistory => 'Consumption history';

  @override
  String get batchRecent => 'Recent';

  @override
  String get batchOldest => 'Oldest';

  @override
  String get batchNoFilters => 'No filters';

  @override
  String get batchDays7 => '7 days';

  @override
  String get batchDays30 => '30 days';

  @override
  String get batchHighPosture => 'High laying rate';

  @override
  String get batchMediumPosture => 'Medium laying rate';

  @override
  String get batchLowPosture => 'Low laying rate';

  @override
  String get batchBackToHistory => 'Back to history';

  @override
  String get batchNoWeightData => 'No weight data';

  @override
  String get batchChartsAppearWhenData =>
      'Charts will appear when there are weight records';

  @override
  String get batchPosturePercentage => 'Laying Percentage';

  @override
  String get batchPostureEvolution => 'Laying rate % evolution over time';

  @override
  String get batchDailyConsumption => 'Daily Consumption';

  @override
  String get batchKgPerDay => 'Kilograms of feed consumed per day';

  @override
  String get batchWeightEvolution => 'Weight Evolution';

  @override
  String get batchAccumulatedMortalityChart => 'Accumulated Mortality';

  @override
  String get batchAccumulatedMortalityDesc =>
      'Total accumulated dead birds over time';

  @override
  String get batchDailyMortality => 'Daily Mortality';

  @override
  String get batchDailyGainAvg => 'Average Daily Gain';

  @override
  String get batchUniformity => 'Uniformity';

  @override
  String get batchStandardComparison => 'Standard Comparison';

  @override
  String get batchConsumptionPerBird => 'Consumption per Bird';

  @override
  String get batchFoodTypeDistribution => 'Distribution by Type';

  @override
  String get batchCosts => 'Costs';

  @override
  String get batchQuality => 'Quality';

  @override
  String get batchDraftFoundGeneric =>
      'A saved draft was found. Do you want to restore it?';

  @override
  String get batchNoAccessFarm => 'You don\'t have access to this farm';

  @override
  String get batchNoPermissionRecord =>
      'You don\'t have permission to record consumption in this farm';

  @override
  String get batchDaysInCycleLabel => 'Days in Cycle';

  @override
  String get batchClosePrefix => '[Closure]';

  @override
  String get batchCreateBatch => 'Create Batch';

  @override
  String get batchClassificationStep => 'Classification';

  @override
  String get batchObservationsStep => 'Observations';

  @override
  String get registerProductionTitle => 'Record Production';

  @override
  String get registerWeightTitle => 'Record Weighing';

  @override
  String get registerMortalityTitle => 'Record Mortality';

  @override
  String get registerConsumptionTitle => 'Record Consumption';

  @override
  String get productionRegistered => 'Production recorded!';

  @override
  String productionRegisteredDetail(String eggs, String good) {
    return '$eggs eggs · $good good';
  }

  @override
  String get weightRegistered => 'Weighing recorded!';

  @override
  String get mortalityRegistered => 'Mortality recorded!';

  @override
  String get consumptionRegistered => 'Consumption recorded!';

  @override
  String get batchMaxPhotosAllowed => 'Maximum 3 photos allowed';

  @override
  String get batchPhotoExceeds5MB =>
      'Photo exceeds 5MB. Choose a smaller image';

  @override
  String productionGoodEggsExceedCollected(String collected, Object good) {
    return 'Good eggs ($good) cannot exceed collected eggs ($collected)';
  }

  @override
  String get productionNoAvailableBirds => 'The batch has no available birds';

  @override
  String productionHighLayingPercent(String percent) {
    return 'The laying percentage ($percent%) is above 100%. Check the data.';
  }

  @override
  String productionClassifiedExceedGood(String classified, Object good) {
    return 'Total classified ($classified) exceeds good eggs ($good)';
  }

  @override
  String get batchHighLayingTitle => 'Very high laying percentage';

  @override
  String batchHighLayingMessage(Object percent) {
    return 'The laying percentage is $percent%, which is exceptionally high. Do you want to continue with this data?';
  }

  @override
  String get batchHighBreakageTitle => 'High breakage percentage';

  @override
  String batchHighBreakageMessage(Object count, Object percent) {
    return 'The breakage percentage is $percent% ($count eggs), which is above the expected 5%. Do you want to continue?';
  }

  @override
  String get commonReviewData => 'Review data';

  @override
  String get batchNoPermissionProduction =>
      'You don\'t have permission to record production in this farm';

  @override
  String batchErrorVerifyingPermissions(Object error) {
    return 'Error verifying permissions: $error';
  }

  @override
  String get productionFutureDate => 'Production date cannot be in the future';

  @override
  String get productionBeforeEntryDate =>
      'Production date cannot be before the batch entry date';

  @override
  String get batchFirebaseDbError => 'Database connection error';

  @override
  String get batchFirebasePermissionDenied =>
      'You don\'t have permission to perform this action';

  @override
  String get batchFirebasePermissionDetail =>
      'Check your session and try again';

  @override
  String get batchFirebaseUnavailable => 'Service unavailable';

  @override
  String get batchFirebaseUnavailableDetail => 'Check your internet connection';

  @override
  String get batchFirebaseSessionExpired => 'Session expired';

  @override
  String get batchFirebaseSessionDetail => 'Please sign in again';

  @override
  String get batchNoPermissionWeight =>
      'You don\'t have permission to record weighings in this farm';

  @override
  String get batchNoPermissionMortality =>
      'You don\'t have permission to record mortality in this farm';

  @override
  String get mortalityFutureDate => 'Mortality date cannot be in the future';

  @override
  String get mortalityBeforeEntryDate =>
      'Date cannot be before the batch entry date';

  @override
  String get weightFutureDate => 'Weighing date cannot be in the future';

  @override
  String get weightBeforeEntryDate =>
      'Date cannot be before the batch entry date';

  @override
  String get consumptionFutureDate =>
      'Consumption date cannot be in the future';

  @override
  String get consumptionBeforeEntryDate =>
      'Date cannot be before the batch entry date';

  @override
  String weightCannotExceedAvailable(Object count) {
    return 'Weighed quantity cannot exceed current birds in the batch ($count)';
  }

  @override
  String get weightMinMustBeLessThanMax =>
      'Minimum weight must be less than maximum weight';

  @override
  String get weightLowUniformityTitle => 'Low Uniformity Detected';

  @override
  String weightLowUniformityMessage(String cv) {
    return 'The coefficient of variation is $cv%, indicating low uniformity in the batch.';
  }

  @override
  String get weightCvRecommendedTitle => 'Recommended CV values:';

  @override
  String get weightCvRecommendedValues =>
      '• Optimal: < 8%\n• Acceptable: 8-12%\n• Needs attention: > 12%';

  @override
  String weightRegisteredDetail(String weight, Object count) {
    return '$count birds • $weight kg average';
  }

  @override
  String batchPhotoAdded(Object current, Object max) {
    return 'Photo $current/$max added';
  }

  @override
  String get batchPhotoSelectError =>
      'Error selecting the image. Please try again.';

  @override
  String get batchPhotoUploadFailed =>
      'Photos could not be uploaded. Continue without photos?';

  @override
  String get batchContinueWithoutPhotos => 'Continue without photos?';

  @override
  String get batchPhotoUploadFailedDetail =>
      'Photos could not be uploaded. Register without photographic evidence?';

  @override
  String get batchFirebaseNetworkError => 'No connection';

  @override
  String get batchFirebaseNetworkDetail => 'Check your internet connection';

  @override
  String mortalityRegisteredDetail(String cause, Object count) {
    return '$count birds - $cause';
  }

  @override
  String get mortalityAttentionRequired => 'Attention Required!';

  @override
  String mortalityImpactMessage(Object percent) {
    return 'The recorded event has an impact of $percent% and requires immediate attention.';
  }

  @override
  String mortalityCause(Object cause) {
    return 'Cause: $cause';
  }

  @override
  String mortalitySeverity(String level) {
    return 'Severity: $level/10';
  }

  @override
  String get mortalityContagiousWarning =>
      'This cause is contagious. Immediate preventive measures are recommended.';

  @override
  String mortalityExceedsAvailable(String available, Object count) {
    return 'Quantity ($count) exceeds available birds ($available)';
  }

  @override
  String get mortalityUserRequired => 'Username is required';

  @override
  String get mortalityUserInvalid => 'Invalid user ID';

  @override
  String get mortalityUserNotAuthenticated => 'User not authenticated';

  @override
  String get batchFirebaseError => 'Firebase Error';

  @override
  String get batchErrorCreatingRecord => 'Error creating record';

  @override
  String get commonUnderstood => 'Understood';

  @override
  String consumptionInsufficientStock(String stock) {
    return 'Insufficient stock. Available: $stock kg';
  }

  @override
  String consumptionInventoryError(Object error) {
    return 'Consumption recorded, but there was an error updating inventory: $error';
  }

  @override
  String consumptionRegisteredDetail(String amount, Object type) {
    return '$amount kg of $type';
  }

  @override
  String get consumptionNoBirdsAvailable => 'The batch has no available birds';

  @override
  String get consumptionHighAmountTitle => 'High Feed Amount';

  @override
  String consumptionHighAmountMessage(Object amount) {
    return 'You are recording $amount kg of feed.';
  }

  @override
  String get consumptionPerBird => 'Per bird:';

  @override
  String get commonCorrect => 'Correct';

  @override
  String get consumptionFoodTypeTitle => 'Feed Type';

  @override
  String consumptionFoodTypeWarning(Object days, Object type) {
    return 'The type \"$type\" is not recommended for $days days of age.';
  }

  @override
  String get consumptionRecommendedType => 'Recommended type:';

  @override
  String get commonReview => 'Review';

  @override
  String get consumptionAmountTooHigh =>
      'The amount seems too high. Please verify the value.';

  @override
  String get consumptionCostNegative => 'Cost per kg cannot be negative';

  @override
  String get consumptionCostTooHigh =>
      'The cost seems too high. Please verify the value.';

  @override
  String get batchViewCharts => 'View Charts';

  @override
  String get batchFilterRecords => 'Filter records';

  @override
  String get batchTimePeriod => 'Time period';

  @override
  String get batchAllTime => 'All';

  @override
  String get batchNoTimeLimit => 'No limit';

  @override
  String get batchLastWeek => 'Last week';

  @override
  String get batchLastMonth => 'Last month';

  @override
  String batchApplyFiltersOrClose(String hasFilters) {
    String _temp0 = intl.Intl.selectLogic(hasFilters, {
      'true': 'Apply filters',
      'other': 'Close',
    });
    return '$_temp0';
  }

  @override
  String get batchErrorLoadingRecords => 'Error loading records';

  @override
  String get historialPostureRange => 'Laying rate range';

  @override
  String get historialAllPostures => 'All laying rates';

  @override
  String get historialHighPosture => 'High (≥85%)';

  @override
  String get historialMediumPosture => 'Medium (70-84%)';

  @override
  String get historialLowPosture => 'Low (<70%)';

  @override
  String get historialTotalEggs => 'total eggs';

  @override
  String get historialAvgPosture => 'avg. laying rate';

  @override
  String get historialRecords => 'records';

  @override
  String get historialDailyAvg => 'daily average';

  @override
  String get historialTotalConsumed => 'total consumed';

  @override
  String get historialDeadBirds => 'dead birds';

  @override
  String get historialNoProductionRecords => 'No production records';

  @override
  String get historialNoResults => 'No results';

  @override
  String get historialRegisterFirstProduction =>
      'Register the first egg production';

  @override
  String get historialNoRecordsWithFilters => 'No records match these filters';

  @override
  String get historialPostureLabel => 'Laying: ';

  @override
  String historialGoodLabel(Object count, Object percent) {
    return 'Good: $count ($percent%)';
  }

  @override
  String historialBirdsLabel(Object count) {
    return 'Birds: $count';
  }

  @override
  String historialBrokenLabel(Object count) {
    return 'Broken: $count';
  }

  @override
  String historialAgeLabel(Object days) {
    return 'Age: $days days';
  }

  @override
  String get detailPosturePercentage => 'Laying percentage';

  @override
  String get detailBirdAge => 'Bird age';

  @override
  String detailDaysWeek(String weeks, Object days) {
    return '$days days (Week $weeks)';
  }

  @override
  String get detailBirdCount => 'Number of birds';

  @override
  String get detailGoodEggs => 'Good eggs';

  @override
  String get detailBrokenEggs => 'Broken eggs';

  @override
  String get detailDirtyEggs => 'Dirty eggs';

  @override
  String get detailDoubleYolkEggs => 'Double yolk eggs';

  @override
  String get detailAvgEggWeight => 'Average egg weight';

  @override
  String get detailRegisteredBy => 'Registered by';

  @override
  String get detailObservations => 'Observations';

  @override
  String get detailSizeClassification => 'Size classification';

  @override
  String get detailPhotoEvidence => 'Photo evidence';

  @override
  String historialEggsUnit(Object count) {
    return '$count eggs';
  }

  @override
  String get historialCauseLabel => 'Cause: ';

  @override
  String historialDescriptionLabel(String desc) {
    return 'Description: $desc';
  }

  @override
  String get historialTypeLabel => 'Type: ';

  @override
  String historialConsumptionPerBird(String grams) {
    return 'Intake/bird: ${grams}g';
  }

  @override
  String get historialNoMortalityRecords => 'No mortality records';

  @override
  String get historialNoConsumptionRecords => 'No consumption records';

  @override
  String get historialNoConsumptionResults => 'No results';

  @override
  String get historialRegisterFirstConsumption =>
      'Register the first feed consumption';

  @override
  String get historialNoRecordsConsumptionFilters =>
      'No records match these filters';

  @override
  String get historialNoProductionData => 'No production data';

  @override
  String get historialChartsAppearProduction =>
      'Charts will appear when there are production records';

  @override
  String get historialNoConsumptionData => 'No consumption data';

  @override
  String get historialChartsAppearConsumption =>
      'Charts will appear when there are consumption records';

  @override
  String get historialFilterMortalityCause => 'Mortality cause';

  @override
  String get historialFilterFoodType => 'Feed type';

  @override
  String get historialFilterAllTypes => 'All types';

  @override
  String get detailFoodType => 'Feed type';

  @override
  String get detailBirdsWeighed => 'Birds weighed';

  @override
  String get detailAvgWeight => 'Average weight';

  @override
  String get detailMinWeight => 'Minimum weight';

  @override
  String get detailMaxWeight => 'Maximum weight';

  @override
  String get detailTotalWeight => 'Total weight';

  @override
  String get detailDailyGain => 'Daily gain (ADG)';

  @override
  String get detailCvCoefficient => 'Coeff. of Variation (CV)';

  @override
  String get detailUniformity => 'Uniformity';

  @override
  String get detailUniformityGood => 'Good (< 10%)';

  @override
  String get detailUniformityRegular => 'Regular (≥ 10%)';

  @override
  String get detailConsumptionPerBird => 'Consumption per bird';

  @override
  String get detailAccumulatedConsumption => 'Accumulated consumption';

  @override
  String get detailFoodBatch => 'Feed batch';

  @override
  String get detailCostPerKg => 'Cost per kg';

  @override
  String get detailTotalCost => 'Total cost';

  @override
  String get detailCause => 'Cause';

  @override
  String get detailBirdsBeforeEvent => 'Birds before event';

  @override
  String get detailImpact => 'Impact';

  @override
  String get detailDescription => 'Description';

  @override
  String historialBirdsWeighedLabel(Object count) {
    return 'Birds weighed: $count';
  }

  @override
  String get historialFilterWeightRange => 'Weight range';

  @override
  String get historialAllWeights => 'All';

  @override
  String get historialLow => 'Low';

  @override
  String get historialNormal => 'Normal';

  @override
  String get historialHigh => 'High';

  @override
  String get historialNoWeighingRecords => 'No weighing records';

  @override
  String get historialRegisterFirstWeighing =>
      'Register the first bird weighing';

  @override
  String get historialNoEventsRecords => 'Event history';

  @override
  String get historialPerEvent => 'per event';

  @override
  String get historialAccumulatedRate => 'accumulated rate';

  @override
  String historialBirdsUnit(Object count) {
    return '$count birds';
  }

  @override
  String historialUserLabel(Object name) {
    return 'User: $name';
  }

  @override
  String historialAgeDaysLabel(Object days) {
    return 'Age: $days days';
  }

  @override
  String get historialNoMortalityExcellent => 'Excellent! No deaths recorded';

  @override
  String get historialAllCauses => 'All causes';

  @override
  String get historialWeighingHistory => 'Weighing history';

  @override
  String get historialLastWeight => 'last weight';

  @override
  String get historialDailyGainStat => 'daily gain';

  @override
  String get historialUniformityCV => 'uniformity CV';

  @override
  String get historialMethodLabel => 'Method';

  @override
  String get historialFilterWeighingMethod => 'Weighing method';

  @override
  String get historialAllMethods => 'All methods';

  @override
  String historialGdpLabel(Object value) {
    return 'ADG: ${value}g';
  }

  @override
  String historialCvLabel(Object value) {
    return 'CV: $value%';
  }

  @override
  String get detailWeighingMethod => 'Weighing method';

  @override
  String get historialNoWeightRecords => 'No weight records';

  @override
  String get historialRegisterFirstWeighingLote =>
      'Register the first weighing of your batch';

  @override
  String get historialConsumptionHistory => 'Consumption history';

  @override
  String get historialAvgDaily => 'daily average';

  @override
  String get historialAccumulatedPerBird => 'accumulated/bird';

  @override
  String get historialAllFoodTypes => 'All types';

  @override
  String historialBirdNumber(Object count) {
    return 'Birds: $count';
  }

  @override
  String historialConsumptionValue(Object value) {
    return 'Consumption/bird: ${value}g';
  }

  @override
  String get chartsConsumptionTitle => 'Consumption Charts';

  @override
  String get chartsLoading => 'Loading charts...';

  @override
  String get chartsErrorLoading => 'Error loading data';

  @override
  String get chartsNoValidData => 'No valid data records';

  @override
  String get chartsDailyConsumptionTitle => 'Daily Consumption';

  @override
  String get chartsDailyConsumptionSubtitle =>
      'Kilograms of food consumed per day';

  @override
  String get chartsConsumptionPerBirdTitle => 'Consumption Per Bird';

  @override
  String get chartsConsumptionPerBirdSubtitle =>
      'Grams of food per bird per day';

  @override
  String get chartsFoodTypeDistributionTitle => 'Type Distribution';

  @override
  String get chartsFoodTypeDistributionSubtitle =>
      'Total consumption by food type (kg)';

  @override
  String get chartsCostEvolutionTitle => 'Feeding Costs';

  @override
  String get chartsCostEvolutionSubtitle => 'Total expense per day on feeding';

  @override
  String get chartsCostNoValidData => 'No records with assigned cost';

  @override
  String get chartsNotEnoughData => 'Not enough data';

  @override
  String get chartsRegisterMoreToAnalyze =>
      'Register more consumption to see analysis';

  @override
  String get chartsGraphsAppearWhenData =>
      'Charts will appear when there are consumption records';

  @override
  String get chartsMortalityAccumulatedSubtitle =>
      'Percentage of losses over initial';

  @override
  String get chartsMortalityDailyTitle => 'Daily Mortality';

  @override
  String get chartsMortalityDailySubtitle => 'Quantity of birds per day';

  @override
  String get chartsMortalityCausesTitle => 'Mortality Causes';

  @override
  String get chartsMortalityCausesSubtitle => 'Distribution by main reason';

  @override
  String get chartsMortalityDistributionCauseTitle => 'Distribution by Cause';

  @override
  String get chartsMortalityTotalByCauseSubtitle =>
      'Total birds by mortality cause';

  @override
  String get commonExcellent => 'Excellent!';

  @override
  String get mortalityCauseDisease => 'Disease';

  @override
  String get mortalityCauseStress => 'Stress';

  @override
  String get mortalityCauseAccident => 'Accident';

  @override
  String get mortalityCausePredation => 'Predation';

  @override
  String get mortalityCauseMalnutrition => 'Malnutrition';

  @override
  String get mortalityCauseMetabolic => 'Metabolic';

  @override
  String get mortalityCauseSacrifice => 'Sacrifice';

  @override
  String get mortalityCauseOldAge => 'Old Age';

  @override
  String get mortalityCauseUnknown => 'Unknown';

  @override
  String get chartsNoMortalityRecords => 'No registered losses';

  @override
  String get chartsGraphsAppearWhenMortality =>
      'Charts will appear when losses are registered';

  @override
  String chartsMortalityTooltipTotal(Object count, Object percent) {
    return 'Total: $count birds ($percent%)';
  }

  @override
  String chartsMortalityTooltipEvent(Object count, Object date) {
    return '$date\n$count birds';
  }

  @override
  String get chartsMortalityAcceptable => 'Acceptable';

  @override
  String get chartsMortalityAlert => 'Alert';

  @override
  String get chartsMortalityCritical => 'Critical';

  @override
  String get chartsMortalityPerRegistrationTitle => 'Mortality Per Request';

  @override
  String get chartsMortalityPerRegistrationSubtitle =>
      'Amount of birds per registered event';

  @override
  String get chartsNoCauseData => 'No cause data';

  @override
  String chartsWeightTooltipEvolution(String date, String weight, String age) {
    return '📈 Evolution\n📅 $date\n⚖️ $weight kg\n🐣 Day $age';
  }

  @override
  String chartsWeightTooltipADG(String date, String age, String gain) {
    return '📈 Daily gain\n📅 $date\n🐣 Day $age\n📊 $gain g/day';
  }

  @override
  String chartsWeightTooltipUniformity(
    String date,
    String value,
    String estado,
  ) {
    return '📈 Uniformity\n📅 $date\n📊 CV: $value%\n$estado';
  }

  @override
  String chartsWeightTooltipComparison(
    String diff,
    String emoji,
    String standard,
    String sign,
    String real,
  ) {
    return '📊 Actual: $real kg\n📈 Standard: $standard kg\n$emoji Diff: $sign$diff kg';
  }

  @override
  String chartsProductionTooltipPosture(
    Object date,
    Object emoji,
    Object percentage,
  ) {
    return '$emoji $date\n$percentage% laying rate';
  }

  @override
  String chartsProductionTooltipDaily(Object count, Object date) {
    return 'ðŸ¥š $date\n$count eggs collected';
  }

  @override
  String get chartsWeightEvolutionTitle => 'Weight Evolution';

  @override
  String get chartsWeightEvolutionSubtitle => 'Average weight over time';

  @override
  String get chartsWeightADGTitle => 'Average Daily Gain';

  @override
  String get chartsWeightADGSubtitle => 'Grams gained per day';

  @override
  String get chartsWeightUniformityTitle => 'Flock Uniformity';

  @override
  String get chartsWeightUniformitySubtitle =>
      'Weight coefficient of variation';

  @override
  String get chartsWeightUniformityExcellent => 'Excellent uniformity';

  @override
  String get chartsWeightUniformityGood => 'Good uniformity';

  @override
  String get chartsWeightUniformityImprove => 'Needs improvement';

  @override
  String get chartsWeightComparisonTitle => 'Standard Comparison';

  @override
  String get chartsWeightComparisonSubtitle =>
      'Actual weight vs breed standard weight';

  @override
  String get commonActual => 'Actual';

  @override
  String get commonStandard => 'Standard';

  @override
  String get chartsProductionDailyTitle => 'Daily Production';

  @override
  String get chartsProductionDailySubtitle => 'Eggs collected per day';

  @override
  String get chartsProductionQualityTitle => 'Egg Quality';

  @override
  String get chartsProductionQualitySubtitle => 'Distribution by egg type';

  @override
  String get eggTypeGood => 'Good';

  @override
  String get eggTypeBroken => 'Broken';

  @override
  String get eggTypeDirty => 'Dirty';

  @override
  String get eggTypeDoubleYolk => 'Double yolk';

  @override
  String get homeSelectFarm => 'Select farm';

  @override
  String get homeHaveCode => 'Have a code?';

  @override
  String get homeJoinFarmWithInvitation => 'Join a farm with an invitation';

  @override
  String get homeNoFarmsRegistered => 'You have no registered farms';

  @override
  String get homeHaveInvitationCode => 'Have an invitation code?';

  @override
  String get homeHealth => 'Health';

  @override
  String get homeAlerts => 'Alerts';

  @override
  String get homeOutOfStock => 'Out of stock';

  @override
  String get homeLowStock => 'Low stock';

  @override
  String get homeRecentActivity => 'Recent Activity';

  @override
  String get homeLast7Days => 'Last 7 days';

  @override
  String get homeRightNow => 'Right now';

  @override
  String homeAgoMinutes(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String homeAgoHoursOne(Object hours) {
    return '$hours hour ago';
  }

  @override
  String homeAgoHoursOther(Object hours) {
    return '$hours hours ago';
  }

  @override
  String homeYesterdayAt(Object time) {
    return 'Yesterday at $time';
  }

  @override
  String homeAgoDays(Object days) {
    return '$days days ago';
  }

  @override
  String get homeNoRecentActivity => 'No recent activity';

  @override
  String get homeNoRecentActivityDesc =>
      'Production, mortality, consumption,\ninventory, sales, cost, and health\nrecords will appear here';

  @override
  String get homeErrorLoadingActivities => 'Error loading activities';

  @override
  String get homeTryReloadPage => 'Try reloading the page';

  @override
  String homeProductsOutOfStockCount(Object count) {
    return '$count products out of stock';
  }

  @override
  String homeProductsLowStockCount(Object count) {
    return '$count products with low stock';
  }

  @override
  String homeProductsExpiringSoonCount(Object count) {
    return '$count products expiring soon';
  }

  @override
  String homeMortalityPercent(Object percent) {
    return 'Mortality at $percent% in active batches';
  }

  @override
  String get homeStatsAppearHere => 'Statistics will appear here';

  @override
  String get homeOccupancyLow => 'Low occupancy';

  @override
  String get homeOccupancyMedium => 'Medium occupancy';

  @override
  String get homeOccupancyHigh => 'High occupancy';

  @override
  String get homeOccupancyMax => 'Maximum occupancy';

  @override
  String get homeNoCapacityDefined => 'No capacity defined';

  @override
  String get homeCouldNotLoad => 'Could not load';

  @override
  String get homeWhatsappHelp => 'How can we help you?';

  @override
  String get homeWhatsappContact => 'Contact us on WhatsApp';

  @override
  String get homeWhatsappSupport => 'Technical support';

  @override
  String get homeWhatsappNeedHelp => 'I need help with the app';

  @override
  String get homeWhatsappReportProblem => 'Report a problem';

  @override
  String get homeWhatsappSuggestImprovement => 'Suggest an improvement';

  @override
  String get homeWhatsappWorkTogether => 'Work together';

  @override
  String get homeWhatsappPlansAndPricing => 'Plans and pricing';

  @override
  String get homeWhatsappOtherTopic => 'Other topic';

  @override
  String get homeWhatsappCouldNotOpen => 'Could not open WhatsApp';

  @override
  String get homeNoOccupancy => 'No occupancy';

  @override
  String get homeSelectAFarm => 'Select a farm';

  @override
  String homeTotalShedsCount(Object count) {
    return '$count total';
  }

  @override
  String homeTotalBatchesCount(Object count) {
    return '$count batches total';
  }

  @override
  String get homeInvTotal => 'Total';

  @override
  String get homeInvLowStock => 'Low Stock';

  @override
  String get homeInvOutOfStock => 'Out of Stock';

  @override
  String get homeInvExpiringSoon => 'Expiring Soon';

  @override
  String get homeSetupInventory => 'Set up your inventory';

  @override
  String get homeSetupInventoryDesc =>
      'Add food, medicine, and more to track your stock';

  @override
  String homeInvAttention(String details) {
    return 'Attention: $details';
  }

  @override
  String homeInvOutOfStockCount(Object count) {
    return '$count out of stock';
  }

  @override
  String homeInvLowStockCount(Object count) {
    return '$count with low stock';
  }

  @override
  String homeInvExpiringSoonCount(Object count) {
    return '$count expiring soon';
  }

  @override
  String get homeWhatsappFoundBug => 'Found an error or bug';

  @override
  String get homeWhatsappHaveIdea => 'I have an idea to improve the app';

  @override
  String get homeWhatsappCollaboration =>
      'Collaboration or business partnership';

  @override
  String get homeWhatsappLicenseInfo => 'License and plan information';

  @override
  String get homeWhatsappGeneralInquiry => 'General inquiry';

  @override
  String get batchError => 'Error';

  @override
  String get batchNotFound => 'Batch not found';

  @override
  String get batchNotFoundMessage => 'The batch was not found';

  @override
  String get batchMayHaveBeenDeleted => 'It may have been deleted or moved';

  @override
  String get batchCouldNotLoad => 'Could not load the batch';

  @override
  String batchEditCode(Object code) {
    return 'Edit: $code';
  }

  @override
  String get batchUpdateBatch => 'Update Batch';

  @override
  String get batchCodeRequired => 'Code is required';

  @override
  String get batchSelectBirdType => 'Select bird type';

  @override
  String get batchSelectShed => 'You must select a shed';

  @override
  String get batchInitialCountRequired => 'Initial quantity is required';

  @override
  String get batchErrorUpdating => 'Error updating batch';

  @override
  String get batchUpdateSuccess => 'Batch updated successfully!';

  @override
  String get batchChangesSaved => 'Changes have been saved successfully';

  @override
  String get batchChangesWillBeLost => 'Changes you have made will be lost.';

  @override
  String get batchOperationSuccess => 'Operation successful';

  @override
  String get batchDeletedSuccess => 'Batch deleted';

  @override
  String get batchSearchHint => 'Search by name, code or type...';

  @override
  String get batchAll => 'All';

  @override
  String get batchNoFarms => 'No farms';

  @override
  String get batchCreateFarmFirst => 'Create a farm first to add batches';

  @override
  String get batchCreateFarm => 'Create farm';

  @override
  String get batchErrorLoadingBatches => 'Error loading batches';

  @override
  String get batchSelectFarm => 'Select a farm';

  @override
  String batchSelectFarmName(Object name) {
    return 'Select farm $name';
  }

  @override
  String get batchNoRegistered => 'No batches registered';

  @override
  String get batchRegisterFirst =>
      'Register your first bird batch to start monitoring your production';

  @override
  String get batchNotFoundFilter => 'No batches found';

  @override
  String get batchAdjustFilters =>
      'Try adjusting filters or searching with different terms';

  @override
  String batchFarmWithBatchesLabel(Object count, Object name) {
    return 'Farm $name with $count batches';
  }

  @override
  String get batchShedBatches => 'Shed Batches';

  @override
  String get batchCreateNewTooltip => 'Create new batch';

  @override
  String batchStatusUpdatedTo(Object status) {
    return 'Status updated to $status';
  }

  @override
  String batchDeleteMessage(Object code) {
    return 'Batch \"$code\" and all its records will be deleted. This action cannot be undone.';
  }

  @override
  String batchErrorDeletingDetail(Object error) {
    return 'Error deleting: $error';
  }

  @override
  String get batchDeletedCorrectly => 'Batch deleted successfully';

  @override
  String get batchCannotCreateWithoutShed =>
      'Cannot create batch without a shed';

  @override
  String get batchCannotViewWithoutShed => 'Cannot view details without a shed';

  @override
  String get batchCannotEditWithoutShed => 'Cannot edit without a shed';

  @override
  String get batchCurrentStatus => 'Current status:';

  @override
  String get batchSelectNewStatus => 'Select new status:';

  @override
  String batchConfirmStateChange(Object status) {
    return 'Confirm change to $status?';
  }

  @override
  String get batchPermanentStateWarning =>
      'This status is permanent and cannot be reversed.';

  @override
  String get batchPermanentState => 'Permanent status';

  @override
  String get batchCycleProgress => 'Cycle progress';

  @override
  String batchDayOfCycle(String day, Object total) {
    return 'Day $day of $total';
  }

  @override
  String batchCycleCompleted(Object day) {
    return 'Day $day - Cycle completed';
  }

  @override
  String batchExtraDays(String extra, Object day) {
    return 'Day $day ($extra extra)';
  }

  @override
  String get batchEntryLabel => 'Entry';

  @override
  String get batchLiveBirds => 'Live Birds';

  @override
  String get batchTotalLosses => 'Total Losses';

  @override
  String get batchAttention => 'Attention';

  @override
  String get batchKeyIndicators => 'Key indicators';

  @override
  String get batchOfInitial => 'of initial batch';

  @override
  String get batchBirdsLost => 'birds lost';

  @override
  String get batchExpected => 'expected';

  @override
  String get batchCurrentWeight => 'current weight';

  @override
  String get batchDailyGain => 'daily gain';

  @override
  String get batchGoal => 'goal';

  @override
  String get batchFoodConsumption => 'Food Consumption';

  @override
  String get batchTotalAccumulated => 'total accumulated';

  @override
  String get batchPerBird => 'per bird';

  @override
  String get batchDailyExpectedPerBird => 'daily expected/bird';

  @override
  String get batchCurrentIndex => 'current index';

  @override
  String get batchKgFood => 'kg food';

  @override
  String get batchPerKgWeight => 'per kg of weight';

  @override
  String get batchOptimalRange => 'optimal range';

  @override
  String get batchEggProduction => 'Egg Production';

  @override
  String get batchTotalEggs => 'total eggs';

  @override
  String get batchEggsPerBird => 'eggs per bird';

  @override
  String get batchExpectedLaying => 'expected laying';

  @override
  String get batchHighMortalityAlert => 'High mortality, review the batch';

  @override
  String get batchWeightBelowTarget => 'Weight below target';

  @override
  String batchOverdueClose(Object days) {
    return 'Closure overdue by $days days';
  }

  @override
  String batchCloseUpcoming(Object days) {
    return 'Closure coming in $days days';
  }

  @override
  String get batchHighConversionAlert => 'High feed conversion index';

  @override
  String get batchLevelOptimal => 'Optimal';

  @override
  String get batchLevelNormal => 'Normal';

  @override
  String get batchLevelHigh => 'High';

  @override
  String get batchLevelCritical => 'Critical';

  @override
  String get batchMortLevelExcellent => 'Excellent';

  @override
  String get batchMortLevelElevated => 'Elevated';

  @override
  String get batchMortLevelCritical => 'Critical';

  @override
  String get batchWeightLevelAcceptable => 'Acceptable';

  @override
  String get batchWeightLevelLow => 'Low';

  @override
  String get batchQualityGood => 'Good';

  @override
  String get batchQualityRegular => 'Regular';

  @override
  String get batchQualityLow => 'Low';

  @override
  String get batchRegisterMortality => 'Register Mortality';

  @override
  String get batchRegisterWeight => 'Register Weight';

  @override
  String get batchRegisterConsumption => 'Register Consumption';

  @override
  String get batchRegisterProduction => 'Register Production';

  @override
  String get batchTabMortality => 'Mortality';

  @override
  String get batchTabWeight => 'Weight';

  @override
  String get batchTabConsumption => 'Consumption';

  @override
  String get batchTabProduction => 'Production';

  @override
  String get batchTabHistory => 'History';

  @override
  String get batchTabVaccination => 'Vaccination';

  @override
  String get batchNavSummary => 'Summary';

  @override
  String get batchPutInQuarantine => 'Put in Quarantine';

  @override
  String batchQuarantineConfirm(Object code) {
    return 'Are you sure you want to put \"$code\" in quarantine?';
  }

  @override
  String get batchQuarantineReasonHint => 'E.g.: Suspected disease';

  @override
  String get batchAlreadyInQuarantine => 'The batch is already in quarantine';

  @override
  String get batchQuarantineReason => 'Quarantine reason';

  @override
  String get batchPutInQuarantineSuccess => 'Batch put in quarantine';

  @override
  String get batchAlreadyClosed => 'The batch is already closed';

  @override
  String get batchInfoCopied => 'Information copied to clipboard';

  @override
  String get batchCannotDeleteActive => 'Cannot delete an active batch';

  @override
  String get batchDescribeReason => 'Describe the reason...';

  @override
  String batchReasonForState(Object status) {
    return 'Reason for $status';
  }

  @override
  String get batchBatchHistory => 'Batch History';

  @override
  String get batchHistoryComingSoon => 'History coming soon';

  @override
  String get batchRequiresAttention => 'Requires Attention';

  @override
  String get batchNeedsReview => 'This batch needs review';

  @override
  String get batchOverdue => 'Overdue';

  @override
  String batchOfBirds(Object count) {
    return 'of $count birds';
  }

  @override
  String get batchWithinLimits => 'Within acceptable limits';

  @override
  String get batchIndicators => 'Indicators';

  @override
  String get batchWeeks => 'weeks';

  @override
  String get batchAverage => 'average';

  @override
  String get batchMortality => 'Mortality';

  @override
  String batchOfAmount(Object count) {
    return 'of $count';
  }

  @override
  String get batchQuickActions => 'Quick Actions';

  @override
  String get batchBatchStatus => 'Batch Status';

  @override
  String get batchGeneralInfo => 'General Information';

  @override
  String get batchCodeLabel => 'Code';

  @override
  String get batchSupplier => 'Supplier';

  @override
  String get batchLatestRecords => 'Latest Records';

  @override
  String get batchNoRecentRecords => 'No recent records';

  @override
  String get batchRecordsWillAppear => 'Records will appear here';

  @override
  String get batchErrorLoadingBatch => 'Error loading batch';

  @override
  String get batchEditBatchTooltip => 'Edit batch';

  @override
  String get batchNotes => 'Notes';

  @override
  String batchErrorDetail(Object error) {
    return 'Error: $error';
  }

  @override
  String get batchStatusDescActive => 'The batch is in active production';

  @override
  String get batchStatusDescClosed => 'The batch has been closed';

  @override
  String get batchStatusDescQuarantine => 'The batch is in quarantine';

  @override
  String get batchStatusDescSold => 'The batch has been sold';

  @override
  String get batchStatusDescTransfer => 'The batch has been transferred';

  @override
  String get batchStatusDescSuspended => 'The batch is suspended';

  @override
  String get batchCreating => 'Creating batch...';

  @override
  String get batchUpdating => 'Updating batch...';

  @override
  String get batchDeleting => 'Deleting batch...';

  @override
  String get batchRegisteringMortality => 'Registering mortality...';

  @override
  String get batchMortalityRegistered => 'Mortality registered';

  @override
  String get batchRegisteringDiscard => 'Registering discard...';

  @override
  String get batchDiscardRegistered => 'Discard registered';

  @override
  String get batchRegisteringSale => 'Registering sale...';

  @override
  String get batchSaleRegistered => 'Sale registered';

  @override
  String get batchUpdatingWeight => 'Updating weight...';

  @override
  String get batchWeightUpdated => 'Weight updated';

  @override
  String get batchChangingStatus => 'Changing status...';

  @override
  String batchStatusChangedTo(Object status) {
    return 'Status changed to $status';
  }

  @override
  String get batchRegisteringFullSale => 'Registering full sale...';

  @override
  String get batchMarkedAsSold => 'Batch marked as sold';

  @override
  String get batchTransferring => 'Transferring batch...';

  @override
  String get batchTransferredSuccess => 'Batch transferred successfully';

  @override
  String get batchSelectEntryDate => 'Select entry date';

  @override
  String get batchMin3Chars => 'Minimum 3 characters';

  @override
  String get batchFilterBatches => 'Filter Batches';

  @override
  String get batchStatus => 'Status';

  @override
  String get batchFrom => 'From';

  @override
  String get batchTo => 'To';

  @override
  String get batchAny => 'Any';

  @override
  String get batchCloseBatchTitle => 'Close Batch';

  @override
  String batchCloseConfirmation(Object code) {
    return 'Are you sure you want to close batch \"$code\"?';
  }

  @override
  String get batchCloseWarning =>
      'This action is irreversible. The batch will be marked as closed.';

  @override
  String get batchCloseFinalSummary => 'Final Summary';

  @override
  String get batchCloseEntryDate => 'Entry date';

  @override
  String get batchCloseCloseDate => 'Close date';

  @override
  String batchCloseDurationDays(Object days) {
    return 'Duration: $days days';
  }

  @override
  String get batchCloseInitialBirds => 'Initial birds';

  @override
  String get batchCloseFinalBirds => 'Final birds';

  @override
  String get batchCloseFinalMortality => 'Final mortality';

  @override
  String get batchCloseObservations => 'Closure observations';

  @override
  String get batchCloseOptionalNotes =>
      'Optional notes about the batch closure...';

  @override
  String get batchCloseSuccess => 'Batch closed successfully';

  @override
  String batchCloseError(Object error) {
    return 'Error closing batch: $error';
  }

  @override
  String get batchTransferTitle => 'Transfer Batch';

  @override
  String batchTransferConfirm(String shed, Object code) {
    return 'Transfer \"$code\" to shed $shed?';
  }

  @override
  String get batchTransferSelectShed => 'Select destination shed';

  @override
  String get batchTransferNoSheds => 'No sheds available';

  @override
  String get batchTransferReason => 'Transfer reason';

  @override
  String get batchSellTitle => 'Sell Entire Batch';

  @override
  String batchSellConfirm(Object code) {
    return 'Register the full sale of batch \"$code\"?';
  }

  @override
  String batchSellBirdsCount(Object count) {
    return 'Birds to sell: $count';
  }

  @override
  String get batchSellPricePerUnit => 'Price per unit';

  @override
  String get batchSellTotalPrice => 'Total price';

  @override
  String get batchSellBuyer => 'Buyer';

  @override
  String get batchFormStepBasicInfo => 'Basic Information';

  @override
  String get batchFormStepDetails => 'Details';

  @override
  String get batchFormStepReview => 'Review';

  @override
  String get batchFormCode => 'Batch code';

  @override
  String get batchFormCodeHint => 'E.g.: BATCH-001';

  @override
  String get batchFormBirdType => 'Bird type';

  @override
  String get batchFormSelectType => 'Select type';

  @override
  String get batchFormInitialCount => 'Initial quantity';

  @override
  String get batchFormCountHint => 'E.g.: 500';

  @override
  String get batchFormEntryDate => 'Entry date';

  @override
  String get batchFormExpectedClose => 'Expected closing date';

  @override
  String get batchFormShed => 'Shed';

  @override
  String get batchFormSelectShed => 'Select shed';

  @override
  String get batchFormSupplier => 'Supplier';

  @override
  String get batchFormSupplierHint => 'Supplier name (optional)';

  @override
  String get batchFormNotes => 'Additional notes';

  @override
  String get batchFormNotesHint => 'Observations about the batch (optional)';

  @override
  String get batchFormDeathCount => 'Death count';

  @override
  String get batchFormDeathCountHint => 'Enter the quantity';

  @override
  String get batchFormCause => 'Cause';

  @override
  String get batchFormCauseHint => 'Cause of mortality (optional)';

  @override
  String get batchFormDate => 'Date';

  @override
  String get batchFormObservations => 'Observations';

  @override
  String get batchFormObservationsHint => 'Additional observations (optional)';

  @override
  String get batchFormWeight => 'Weight (kg)';

  @override
  String get batchFormWeightHint => 'Average weight in kg';

  @override
  String get batchFormSampleSize => 'Sample size';

  @override
  String get batchFormSampleSizeHint => 'E.g.: 10';

  @override
  String get batchFormMethodHint => 'Weighing method';

  @override
  String get batchFormFoodType => 'Food type';

  @override
  String get batchFormSelectFoodType => 'Select food type';

  @override
  String get batchFormQuantityKg => 'Quantity (kg)';

  @override
  String get batchFormQuantityHint => 'Quantity in kg';

  @override
  String get batchFormCostPerKg => 'Cost per kg';

  @override
  String get batchFormCostHint => 'Cost in \$ (optional)';

  @override
  String get batchFormEggCount => 'Egg count';

  @override
  String get batchFormEggCountHint => 'Total eggs collected';

  @override
  String get batchFormEggQuality => 'Egg quality';

  @override
  String get batchFormSelectQuality => 'Select quality';

  @override
  String get batchFormDiscardCount => 'Discard count';

  @override
  String get batchFormDiscardCountHint => 'E.g.: 5';

  @override
  String get batchFormDiscardReason => 'Discard reason';

  @override
  String get batchFormDiscardReasonHint => 'Discard reason (optional)';

  @override
  String get batchHistoryMortality => 'Mortality History';

  @override
  String get batchHistoryWeight => 'Weight History';

  @override
  String get batchHistoryConsumption => 'Consumption History';

  @override
  String get batchHistoryProduction => 'Production History';

  @override
  String get batchHistoryNoRecords => 'No records';

  @override
  String get batchHistoryNoRecordsDesc => 'No records to display';

  @override
  String get batchBirdsLabel => 'birds';

  @override
  String get batchBirdLabel => 'bird';

  @override
  String get batchKgLabel => 'kg';

  @override
  String get batchEggsLabel => 'eggs';

  @override
  String get batchUnitLabel => 'units';

  @override
  String get batchPercentSign => '%';

  @override
  String get batchDaysLabel => 'days';

  @override
  String get batchDayLabel => 'day';

  @override
  String get batchCopyInfo => 'Copy information';

  @override
  String get batchShareInfo => 'Share information';

  @override
  String get batchViewHistory => 'View full history';

  @override
  String get batchNoShedsAvailable => 'No sheds available';

  @override
  String get batchCreateShedFirst => 'Create a shed first';

  @override
  String batchStepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get batchReviewCreateBatch => 'Review and Create Batch';

  @override
  String get batchCreated => 'Batch created successfully';

  @override
  String get batchConfirmExit => 'Do you want to exit?';

  @override
  String get batchConfirmExitDesc => 'Form data will be lost';

  @override
  String get batchStay => 'Stay';

  @override
  String get batchLeave => 'Leave';

  @override
  String get batchUnsavedChanges => 'Unsaved changes';

  @override
  String get batchExitWithoutSaving => 'Exit without saving changes?';

  @override
  String get batchLoadingBatch => 'Loading batch...';

  @override
  String get batchLoadingData => 'Loading data...';

  @override
  String get batchRetry => 'Retry';

  @override
  String get batchNoData => 'No data';

  @override
  String get batchNoBatches => 'No batches';

  @override
  String get batchLotesHome => 'Batches';

  @override
  String get batchClosed => 'Closed';

  @override
  String get batchSuspended => 'Suspended';

  @override
  String get batchInQuarantine => 'In quarantine';

  @override
  String get batchSold => 'Sold';

  @override
  String get batchTransfer => 'Transfer';

  @override
  String batchDaysCount(Object count) {
    return '$count days';
  }

  @override
  String get batchNoNotes => 'No notes';

  @override
  String get batchShedLabel => 'Shed';

  @override
  String get batchActions => 'Actions';

  @override
  String get batchWhatWantToDo => 'What do you want to do with this batch?';

  @override
  String get batchDeleteWarning => 'This action cannot be undone';

  @override
  String batchAgeWeeks(Object weeks) {
    return '$weeks wk';
  }

  @override
  String batchAgeDays(Object days) {
    return '$days days';
  }

  @override
  String batchMortalityRate(String rate) {
    return 'Mortality: $rate%';
  }

  @override
  String get batchRecordAdded => 'Record added successfully';

  @override
  String get batchRecordError => 'Error adding record';

  @override
  String get batchTotalConsumed => 'Total consumed';

  @override
  String get batchTotalProduced => 'Total produced';

  @override
  String get batchProductionRate => 'Production rate';

  @override
  String get batchSelectDate => 'Select date';

  @override
  String get batchVaccinationHistory => 'Vaccination History';

  @override
  String get batchNoVaccinations => 'No vaccinations registered';

  @override
  String get batchDeaths => 'deaths';

  @override
  String get batchDiscards => 'discards';

  @override
  String get batchAverageWeight => 'Average weight';

  @override
  String get batchSamples => 'samples';

  @override
  String get batchConsumed => 'consumed';

  @override
  String get batchEggsCollected => 'eggs';

  @override
  String get batchBrokenDiscarded => 'broken/discarded';

  @override
  String get batchTotal => 'Total';

  @override
  String get batchLastRecord => 'Last record';

  @override
  String batchRemainingBirds(Object count) {
    return 'Remaining birds: $count';
  }

  @override
  String batchExceedsCurrentBirds(Object count) {
    return 'Quantity exceeds current birds ($count)';
  }

  @override
  String get batchFutureDateNotAllowed => 'Date cannot be in the future';

  @override
  String get batchRequiredField => 'Required field';

  @override
  String get batchInvalidNumber => 'Invalid number';

  @override
  String get batchMustBePositive => 'Must be greater than 0';

  @override
  String get batchMustBeGreaterThanZero => 'Must be greater than 0';

  @override
  String get batchProduction => 'Production';

  @override
  String get batchConsumption => 'Consumption';

  @override
  String get batchMortalityLabel => 'Mortality';

  @override
  String get batchVaccination => 'Vaccination';

  @override
  String get batchInfoGeneral => 'General information';

  @override
  String get batchTitle => 'Batches';

  @override
  String get batchDeleteBatch => 'Delete Batch';

  @override
  String get batchFilterTitle => 'Filter Batches';

  @override
  String get batchFilterClear => 'Clear';

  @override
  String get batchFilterStatus => 'Status';

  @override
  String get batchFilterAll => 'All';

  @override
  String get batchFilterBirdType => 'Bird type';

  @override
  String get batchFilterEntryDate => 'Entry date';

  @override
  String get batchFilterFrom => 'From';

  @override
  String get batchFilterTo => 'To';

  @override
  String get batchFilterAny => 'Any';

  @override
  String get batchFilterCancel => 'Cancel';

  @override
  String get batchFilterApply => 'Apply';

  @override
  String get batchCloseSummary => 'Closure Summary';

  @override
  String get batchCloseStartDate => 'Start date';

  @override
  String get batchCloseEndDate => 'Close date';

  @override
  String get batchCloseDate => 'Close date';

  @override
  String get batchCloseDuration => 'Duration';

  @override
  String get batchCloseDays => 'days';

  @override
  String get batchCloseCycleDuration => 'Cycle duration';

  @override
  String get batchCloseCycleInfo => 'Cycle information';

  @override
  String get batchClosePopulation => 'Population';

  @override
  String get batchCloseTotalMortality => 'Total mortality';

  @override
  String get batchCloseMortality => 'Mortality';

  @override
  String get batchCloseMortalityPercent => 'Mortality %';

  @override
  String get batchCloseFinalMetrics => 'Final Metrics';

  @override
  String get batchCloseFinalWeight => 'Final weight';

  @override
  String get batchCloseFinalWeightLabel => 'Final weight (kg)';

  @override
  String get batchCloseWeightGain => 'Weight gain';

  @override
  String get batchCloseEstimatedWeight => 'Estimated weight';

  @override
  String get batchCloseFeedConversion => 'Feed conversion';

  @override
  String get batchCloseGrams => 'grams';

  @override
  String get batchCloseWeightRequired => 'Weight is required';

  @override
  String get batchCloseWeightMustBePositive => 'Weight must be positive';

  @override
  String get batchCloseWeightTooHigh => 'Weight seems too high';

  @override
  String get batchCloseWeightHelper => 'Average weight per bird in kg';

  @override
  String get batchCloseFinalObservations => 'Final Observations';

  @override
  String get batchCloseObservationsHint => 'Write your observations here...';

  @override
  String get batchCloseIrreversible => 'Irreversible action';

  @override
  String get batchCloseIrreversibleMessage =>
      'Once closed, the batch cannot be reopened';

  @override
  String get batchCloseConfirm => 'Confirm closure';

  @override
  String get batchCloseSaleInfo => 'Sale Information';

  @override
  String get batchCloseBirdsToSell => 'Birds to sell';

  @override
  String get batchCloseBirdsUnit => 'birds';

  @override
  String get batchCloseSalePriceLabel => 'Sale price per kg';

  @override
  String get batchCloseSalePriceHelper => 'Price in local currency';

  @override
  String get batchClosePricePerKg => 'Price per kg';

  @override
  String get batchCloseEstimatedValue => 'Estimated value';

  @override
  String get batchCloseBuyerLabel => 'Buyer';

  @override
  String get batchCloseBuyerHint => 'Buyer name (optional)';

  @override
  String get batchCloseFinancialBalance => 'Financial balance';

  @override
  String get batchCloseTotalIncome => 'Total income';

  @override
  String get batchCloseTotalExpenses => 'Total expenses';

  @override
  String get batchCloseProfitability => 'Profitability';

  @override
  String get batchCloseEnterValidNumber => 'Enter a valid number';

  @override
  String get batchFormName => 'Batch name';

  @override
  String get batchFormBasicInfoSubtitle => 'Basic batch information';

  @override
  String get batchFormBasicInfoNote => 'Complete the basic batch information';

  @override
  String get batchFormDetailsSubtitle => 'Additional batch details';

  @override
  String get batchFormReviewSubtitle => 'Review information before creating';

  @override
  String get batchFormFarm => 'Farm';

  @override
  String get batchFormLocation => 'Location';

  @override
  String get batchFormShedInfo => 'Shed information';

  @override
  String get batchFormShedLocationInfo => 'Shed location';

  @override
  String get batchFormCapacity => 'Capacity';

  @override
  String get batchFormMaxCapacity => 'Maximum capacity';

  @override
  String get batchFormArea => 'Area';

  @override
  String get batchFormAvailable => 'Available';

  @override
  String get batchFormShedCapacity => 'Shed capacity';

  @override
  String get batchFormShedCapacityNote => 'Quantity cannot exceed capacity';

  @override
  String get batchFormExceedsCapacity => 'Exceeds shed capacity';

  @override
  String get batchFormUtilization => 'Utilization';

  @override
  String get batchFormCreateShedFirst => 'Create a shed first';

  @override
  String get batchFormAgeAtEntry => 'Age at entry';

  @override
  String get batchFormAgeHint => 'Age in days (optional)';

  @override
  String get batchFormAgeInfoNote => 'Age is calculated automatically';

  @override
  String get batchFormOptional => 'Optional';

  @override
  String get batchFormNotSelected => 'Not selected';

  @override
  String get batchFormNotSpecified => 'Not specified';

  @override
  String get batchFormNotFound => 'Not found';

  @override
  String get batchFormUnits => 'units';

  @override
  String get batchFormDirty => 'Dirty';

  @override
  String get batchFormCurrentBirds => 'Current birds';

  @override
  String get batchFormInvalidNumber => 'Invalid number';

  @override
  String get batchFormInvalidValue => 'Invalid value';

  @override
  String get batchFormMortalityEventInfo => 'Mortality event information';

  @override
  String get batchFormMortalityEventSubtitle => 'Record event details';

  @override
  String get batchFormMortalityDetailsTitle => 'Mortality Details';

  @override
  String get batchFormMortalityDetailsSubtitle => 'Describe additional details';

  @override
  String get batchFormMortalityDescription => 'Mortality description';

  @override
  String get batchFormMortalityDescriptionHint =>
      'Describe the circumstances...';

  @override
  String get batchFormRecommendation => 'Recommendation';

  @override
  String get batchFormRecommendedActions => 'Recommended actions';

  @override
  String get batchFormPhotoEvidence => 'Photo evidence';

  @override
  String get batchFormPhotoOptional => 'Optional photos';

  @override
  String get batchFormPhotoHelpText => 'Take or select photos as evidence';

  @override
  String get batchFormNoPhotos => 'No photos';

  @override
  String get batchFormMaxPhotos => 'Maximum photos reached';

  @override
  String get batchFormSelectedPhotos => 'Selected photos';

  @override
  String get batchFormTakePhoto => 'Take photo';

  @override
  String get batchFormGallery => 'Gallery';

  @override
  String get batchFormObservationsAndEvidence => 'Observations and Evidence';

  @override
  String get batchFormObservationsSubtitle => 'Add additional observations';

  @override
  String get batchFormWeightInfo => 'Weight Information';

  @override
  String get batchFormWeightSubtitle => 'Record batch weight';

  @override
  String get batchFormWeightMethod => 'Weighing method';

  @override
  String get batchFormWeightRanges => 'Weight Ranges';

  @override
  String get batchFormWeightRangesSubtitle => 'Classify by weight ranges';

  @override
  String get batchFormWeightMin => 'Minimum weight';

  @override
  String get batchFormWeightMax => 'Maximum weight';

  @override
  String get batchFormWeightSummary => 'Weight Summary';

  @override
  String get batchFormWeightSummarySubtitle => 'Summary of recorded data';

  @override
  String get batchFormAutoCalculatedWeight => 'Automatically calculated weight';

  @override
  String get batchFormCalculatedAvgWeight => 'Calculated average weight';

  @override
  String get batchFormCalculatedMetrics => 'Calculated metrics';

  @override
  String get batchFormMetricsAutoCalculated =>
      'Metrics are automatically calculated';

  @override
  String get batchFormConsumptionInfo => 'Consumption Information';

  @override
  String get batchFormConsumptionSubtitle => 'Record food consumption';

  @override
  String get batchFormConsumptionSaveNote =>
      'Data will be saved when continuing';

  @override
  String get batchFormFoodFromInventory => 'Food from inventory';

  @override
  String get batchFormSelectFoodHint => 'Select a food item';

  @override
  String get batchFormNoFoodInInventory => 'No food items in inventory';

  @override
  String get batchFormFoodBatch => 'Food batch';

  @override
  String get batchFormLowStock => 'Low stock';

  @override
  String get batchFormDetailsCosts => 'Details and Costs';

  @override
  String get batchFormDetailsCostsSubtitle => 'Enter details and costs';

  @override
  String get batchFormCostPerBird => 'Cost per bird';

  @override
  String get batchFormCostThisRecord => 'Cost of this record';

  @override
  String get batchFormProductionInfo => 'Production Information';

  @override
  String get batchFormProductionInfoSubtitle => 'Record egg production';

  @override
  String get batchFormEggsCollected => 'Eggs collected';

  @override
  String get batchFormDefectiveEggs => 'Defective eggs';

  @override
  String get batchFormLayingPercentage => 'Laying percentage';

  @override
  String get batchFormLayingIndicator => 'Laying indicator';

  @override
  String get batchFormExcellentPerformance => 'Excellent performance';

  @override
  String get batchFormAcceptablePerformance => 'Acceptable performance';

  @override
  String get batchFormBelowExpectedPerformance => 'Below expected performance';

  @override
  String get batchFormProductionSummary => 'Production summary';

  @override
  String get batchFormCompleteAmountToSeeMetrics =>
      'Complete amount to see metrics';

  @override
  String get batchFormEggClassification => 'Egg Classification';

  @override
  String get batchFormEggClassificationSubtitle => 'Classify collected eggs';

  @override
  String get batchFormClassifyForWeight => 'Classify by weight';

  @override
  String get batchFormSmallEggs => 'Small eggs';

  @override
  String get batchFormMediumEggs => 'Medium eggs';

  @override
  String get batchFormLargeEggs => 'Large eggs';

  @override
  String get batchFormExtraLargeEggs => 'Extra large eggs';

  @override
  String get batchFormBroken => 'Broken';

  @override
  String get batchFormGoodEggs => 'Good eggs';

  @override
  String get batchFormTotalClassified => 'Total classified';

  @override
  String get batchFormTotalToClassify => 'Total to classify';

  @override
  String get batchFormClassificationSummary => 'Classification summary';

  @override
  String get batchFormCannotExceedCollected => 'Cannot exceed collected eggs';

  @override
  String get batchFormExcessEggs => 'Excess classified eggs';

  @override
  String get batchFormMissingEggs => 'Missing eggs to classify';

  @override
  String get batchFormSizeClassification => 'Size classification';

  @override
  String get birdTypeBroiler => 'Broiler';

  @override
  String get birdTypeLayer => 'Layer Hen';

  @override
  String get birdTypeHeavyBreeder => 'Heavy Breeder';

  @override
  String get birdTypeLightBreeder => 'Light Breeder';

  @override
  String get birdTypeTurkey => 'Turkey';

  @override
  String get birdTypeQuail => 'Quail';

  @override
  String get birdTypeDuck => 'Duck';

  @override
  String get birdTypeOther => 'Other';

  @override
  String get birdTypeShortBroiler => 'Broiler';

  @override
  String get birdTypeShortLayer => 'Layer';

  @override
  String get birdTypeShortHeavyBreeder => 'Heavy Br.';

  @override
  String get birdTypeShortLightBreeder => 'Light Br.';

  @override
  String get birdTypeShortTurkey => 'Turkey';

  @override
  String get birdTypeShortQuail => 'Quail';

  @override
  String get birdTypeShortDuck => 'Duck';

  @override
  String get birdTypeShortOther => 'Other';

  @override
  String get batchStatusInTransfer => 'In Transfer';

  @override
  String get batchStatusDescInTransfer => 'Batch being transferred';

  @override
  String get weighMethodManual => 'Manual';

  @override
  String get weighMethodIndividualScale => 'Individual Scale';

  @override
  String get weighMethodBatchScale => 'Batch Scale';

  @override
  String get weighMethodAutomatic => 'Automatic';

  @override
  String get weighMethodDescManual => 'Manual with scale';

  @override
  String get weighMethodDescIndividualScale => 'Individual scale';

  @override
  String get weighMethodDescBatchScale => 'Batch scale';

  @override
  String get weighMethodDescAutomatic => 'Automatic system';

  @override
  String get weighMethodDetailManual =>
      'Weighing bird by bird with portable scale';

  @override
  String get weighMethodDetailIndividualScale =>
      'Electronic scale for one bird';

  @override
  String get weighMethodDetailBatchScale =>
      'Group weighing divided by quantity';

  @override
  String get weighMethodDetailAutomatic => 'Integrated automated system';

  @override
  String get feedTypePreStarter => 'Pre-starter';

  @override
  String get feedTypeStarter => 'Starter';

  @override
  String get feedTypeGrower => 'Grower';

  @override
  String get feedTypeFinisher => 'Finisher';

  @override
  String get feedTypeLayer => 'Layer';

  @override
  String get feedTypeRearing => 'Rearing';

  @override
  String get feedTypeMedicated => 'Medicated';

  @override
  String get feedTypeConcentrate => 'Concentrate';

  @override
  String get feedTypeOther => 'Other';

  @override
  String get feedTypeDescPreStarter => 'Pre-starter (0-7 days)';

  @override
  String get feedTypeDescStarter => 'Starter (8-21 days)';

  @override
  String get feedTypeDescGrower => 'Grower (22-35 days)';

  @override
  String get feedTypeDescFinisher => 'Finisher (36+ days)';

  @override
  String get feedTypeDescLayer => 'Layer';

  @override
  String get feedTypeDescRearing => 'Rearing';

  @override
  String get feedTypeDescMedicated => 'Medicated';

  @override
  String get feedTypeDescConcentrate => 'Concentrate';

  @override
  String get feedTypeDescOther => 'Other';

  @override
  String get feedAgeRangePreStarter => '0-7 days';

  @override
  String get feedAgeRangeStarter => '8-21 days';

  @override
  String get feedAgeRangeGrower => '22-35 days';

  @override
  String get feedAgeRangeFinisher => '36+ days';

  @override
  String get feedAgeRangeLayer => 'Layer hens';

  @override
  String get feedAgeRangeRearing => 'Replacement pullets';

  @override
  String get feedAgeRangeMedicated => 'Under treatment';

  @override
  String get feedAgeRangeConcentrate => 'Supplement';

  @override
  String get feedAgeRangeOther => 'General use';

  @override
  String get eggClassSmall => 'Small';

  @override
  String get eggClassMedium => 'Medium';

  @override
  String get eggClassLarge => 'Large';

  @override
  String get eggClassExtraLarge => 'Extra Large';

  @override
  String get validateBatchQuantityMin =>
      'Initial quantity must be at least 10 birds';

  @override
  String get validateBatchQuantityMax =>
      'Initial quantity cannot exceed 100,000 birds';

  @override
  String get validateMortalityMin => 'Mortality count must be greater than 0';

  @override
  String validateMortalityExceedsCurrent(Object current, Object mortality) {
    return 'Mortality count ($mortality) cannot exceed current count ($current)';
  }

  @override
  String get validateWeightMin => 'Weight must be greater than 0 grams';

  @override
  String get validateWeightMax => 'Weight cannot exceed 20,000 grams (20 kg)';

  @override
  String get validateFeedMin => 'Feed amount must be greater than 0';

  @override
  String get validateFeedMax => 'Feed amount cannot exceed 10,000 kg';

  @override
  String get validateEggLayerOnly => 'Only layer batches can produce eggs';

  @override
  String get validateEggMin => 'Egg count must be greater than 0';

  @override
  String validateEggRateHigh(Object rate) {
    return 'The laying rate of $rate% seems very high. Please verify the data.';
  }

  @override
  String get validateDateFuture => 'Entry date cannot be in the future';

  @override
  String get validateDateTooOld =>
      'Entry date seems too old (more than 5 years)';

  @override
  String get validateCloseDateBeforeEntry =>
      'Close date cannot be before the entry date';

  @override
  String get validateCloseDateFuture => 'Close date cannot be in the future';

  @override
  String validateCodeExists(Object code) {
    return 'Another batch with code \"$code\" already exists';
  }

  @override
  String get batchRecordingMortality => 'Recording mortality...';

  @override
  String get batchRecordingDiscard => 'Recording discard...';

  @override
  String get batchRecordingSale => 'Recording sale...';

  @override
  String get batchMarkingSold => 'Recording full sale...';

  @override
  String get batchCreatedSuccess => 'Batch created successfully';

  @override
  String get batchUpdatedSuccess => 'Batch updated successfully';

  @override
  String get batchMortalityRecorded => 'Mortality recorded';

  @override
  String get batchDiscardRecorded => 'Discard recorded';

  @override
  String get batchSaleRecorded => 'Sale recorded';

  @override
  String get batchMarkedSold => 'Batch marked as sold';

  @override
  String get validateSelectBirdType => 'Select bird type';

  @override
  String get validateSelectEntryDate => 'Select entry date';

  @override
  String get validateCodeRequired => 'Code is required';

  @override
  String get validateCodeMinLength => 'Minimum 3 characters';

  @override
  String get validateQuantityValid => 'Enter a valid quantity';

  @override
  String get saleProductLiveBirds => 'Live Birds';

  @override
  String get saleProductLiveBirdsDesc => 'Live bird sales';

  @override
  String get saleProductEggs => 'Eggs';

  @override
  String get saleProductEggsDesc => 'Egg sales by classification';

  @override
  String get saleProductManure => 'Poultry Manure';

  @override
  String get saleProductManureDesc => 'Organic by-product';

  @override
  String get saleProductProcessedBirds => 'Processed Birds';

  @override
  String get saleProductProcessedBirdsDesc => 'Birds processed for consumption';

  @override
  String get saleProductCullBirds => 'Cull Birds';

  @override
  String get saleProductCullBirdsDesc => 'Birds at end of production cycle';

  @override
  String get saleStatusPending => 'Pending';

  @override
  String get saleStatusPendingDesc => 'Awaiting confirmation';

  @override
  String get saleStatusConfirmed => 'Confirmed';

  @override
  String get saleStatusConfirmedDesc => 'Confirmed by client';

  @override
  String get saleStatusInPreparation => 'In Preparation';

  @override
  String get saleStatusInPreparationDesc => 'Preparing product';

  @override
  String get saleStatusReadyToShip => 'Ready to Ship';

  @override
  String get saleStatusReadyToShipDesc => 'Ready for delivery';

  @override
  String get saleStatusInTransit => 'In Transit';

  @override
  String get saleStatusInTransitDesc => 'On the way to client';

  @override
  String get saleStatusDelivered => 'Delivered';

  @override
  String get saleStatusDeliveredDesc => 'Delivered successfully';

  @override
  String get saleStatusInvoiced => 'Invoiced';

  @override
  String get saleStatusInvoicedDesc => 'Invoice generated';

  @override
  String get saleStatusCancelled => 'Cancelled';

  @override
  String get saleStatusCancelledDesc => 'Cancelled';

  @override
  String get saleStatusReturned => 'Returned';

  @override
  String get saleStatusReturnedDesc => 'Returned by client';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusPendingDesc => 'Order awaiting confirmation';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusConfirmedDesc => 'Order approved';

  @override
  String get orderStatusInPreparation => 'In Preparation';

  @override
  String get orderStatusInPreparationDesc => 'Order being prepared';

  @override
  String get orderStatusReadyToShip => 'Ready to Ship';

  @override
  String get orderStatusReadyToShipDesc => 'Ready for shipping';

  @override
  String get orderStatusInTransit => 'In Transit';

  @override
  String get orderStatusInTransitDesc => 'Order on the way';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusDeliveredDesc => 'Order completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStatusCancelledDesc => 'Order voided';

  @override
  String get orderStatusReturned => 'Returned';

  @override
  String get orderStatusReturnedDesc => 'Order returned';

  @override
  String get orderStatusPartial => 'Partial';

  @override
  String get orderStatusPartialDesc => 'Incomplete delivery';

  @override
  String get saleUnitBag => 'Bag';

  @override
  String get saleUnitBagDesc => '50 kg bag';

  @override
  String get saleUnitTon => 'Ton';

  @override
  String get saleUnitTonDesc => 'Metric ton';

  @override
  String get saleUnitKg => 'Kilogram';

  @override
  String get saleUnitKgDesc => 'Kilogram';

  @override
  String get saleEggClassExtraLarge => 'Extra Large';

  @override
  String get saleEggClassLarge => 'Large';

  @override
  String get saleEggClassMedium => 'Medium';

  @override
  String get saleEggClassSmall => 'Small';

  @override
  String get costTypeFeed => 'Feed';

  @override
  String get costTypeFeedDesc => 'Concentrates and grains';

  @override
  String get costTypeLaborDesc => 'Salaries and benefits';

  @override
  String get costTypeEnergyDesc => 'Electricity and fuel';

  @override
  String get costTypeMedicineDesc => 'Animal health';

  @override
  String get costTypeMaintenanceDesc => 'Repairs and cleaning';

  @override
  String get costTypeWaterDesc => 'Water consumption';

  @override
  String get costTypeTransportDesc => 'Logistics and mobilization';

  @override
  String get costTypeAdminDesc => 'General expenses';

  @override
  String get costTypeDepreciationDesc => 'Asset depreciation';

  @override
  String get costTypeFinancialDesc => 'Interest and fees';

  @override
  String get costTypeOtherDesc => 'Miscellaneous expenses';

  @override
  String get costCategoryProduction => 'Production Cost';

  @override
  String get costCategoryPersonnel => 'Personnel Expenses';

  @override
  String get costCategoryOperating => 'Operating Expenses';

  @override
  String get costCategoryDistribution => 'Distribution Expenses';

  @override
  String get costCategoryAdmin => 'Administrative Expenses';

  @override
  String get costCategoryDepreciation => 'Depreciation and Amortization';

  @override
  String get costCategoryFinancial => 'Financial Expenses';

  @override
  String get costCategoryOther => 'Other Expenses';

  @override
  String get costValidateConceptEmpty => 'Concept cannot be empty';

  @override
  String get costValidateAmountPositive => 'Amount must be greater than 0';

  @override
  String get costValidateBirdCountPositive =>
      'Bird count must be greater than 0';

  @override
  String get costValidateApprovalNotRequired =>
      'This expense does not require approval';

  @override
  String get costValidateAlreadyApproved => 'This expense is already approved';

  @override
  String get costValidateRejectionReasonRequired =>
      'Must provide a rejection reason';

  @override
  String get costCenterBatch => 'Batch';

  @override
  String get costCenterHouse => 'House';

  @override
  String get costCenterAdmin => 'Administrative';

  @override
  String get invItemTypeFeed => 'Feed';

  @override
  String get invItemTypeFeedDesc => 'Concentrates, grains and supplements';

  @override
  String get invItemTypeMedicine => 'Medicine';

  @override
  String get invItemTypeMedicineDesc => 'Drugs and sanitary products';

  @override
  String get invItemTypeVaccine => 'Vaccine';

  @override
  String get invItemTypeVaccineDesc => 'Vaccines and biologics';

  @override
  String get invItemTypeEquipment => 'Equipment';

  @override
  String get invItemTypeEquipmentDesc => 'Tools and machinery';

  @override
  String get invItemTypeSupply => 'Supply';

  @override
  String get invItemTypeSupplyDesc => 'Bedding material, packaging, etc.';

  @override
  String get invItemTypeCleaning => 'Cleaning';

  @override
  String get invItemTypeCleaningDesc => 'Disinfectants and cleaning products';

  @override
  String get invItemTypeOther => 'Other';

  @override
  String get invItemTypeOtherDesc => 'Miscellaneous items';

  @override
  String get invMovePurchase => 'Purchase';

  @override
  String get invMovePurchaseDesc => 'Entry by acquisition';

  @override
  String get invMoveDonation => 'Donation';

  @override
  String get invMoveDonationDesc => 'Entry by donation';

  @override
  String get invMoveReturn => 'Return';

  @override
  String get invMoveReturnDesc => 'Entry by return of use';

  @override
  String get invMoveAdjustUp => 'Adjustment (+)';

  @override
  String get invMoveAdjustUpDesc => 'Positive inventory adjustment';

  @override
  String get invMoveBatchConsumption => 'Batch Consumption';

  @override
  String get invMoveBatchConsumptionDesc => 'Output for bird feeding';

  @override
  String get invMoveTreatment => 'Treatment';

  @override
  String get invMoveTreatmentDesc => 'Output for medicine application';

  @override
  String get invMoveVaccination => 'Vaccination';

  @override
  String get invMoveVaccinationDesc => 'Output for vaccine application';

  @override
  String get invMoveShrinkage => 'Shrinkage';

  @override
  String get invMoveShrinkageDesc => 'Loss due to deterioration or expiration';

  @override
  String get invMoveAdjustDown => 'Adjustment (-)';

  @override
  String get invMoveAdjustDownDesc => 'Negative inventory adjustment';

  @override
  String get invMoveTransfer => 'Transfer';

  @override
  String get invMoveTransferDesc => 'Transfer to another location';

  @override
  String get invMoveGeneralUse => 'General Use';

  @override
  String get invMoveGeneralUseDesc => 'Output for operational use';

  @override
  String get invMoveSale => 'Sale';

  @override
  String get invMoveSaleDesc => 'Output for product sales';

  @override
  String get invUnitKilogram => 'Kilogram';

  @override
  String get invUnitGram => 'Gram';

  @override
  String get invUnitPound => 'Pound';

  @override
  String get invUnitLiter => 'Liter';

  @override
  String get invUnitMilliliter => 'Milliliter';

  @override
  String get invUnitUnit => 'Unit';

  @override
  String get invUnitDozen => 'Dozen';

  @override
  String get invUnitSack => 'Sack';

  @override
  String get invUnitBag => 'Bag';

  @override
  String get invUnitBox => 'Box';

  @override
  String get invUnitVial => 'Vial';

  @override
  String get invUnitDose => 'Dose';

  @override
  String get invUnitAmpoule => 'Ampoule';

  @override
  String get invUnitCategoryWeight => 'Weight';

  @override
  String get invUnitCategoryVolume => 'Volume';

  @override
  String get invUnitCategoryQuantity => 'Quantity';

  @override
  String get invUnitCategoryPackaging => 'Packaging';

  @override
  String get invUnitCategoryApplication => 'Application';

  @override
  String get healthDiseaseCatViral => 'Viral';

  @override
  String get healthDiseaseCatViralDesc => 'Diseases caused by viruses';

  @override
  String get healthDiseaseCatBacterial => 'Bacterial';

  @override
  String get healthDiseaseCatBacterialDesc => 'Diseases caused by bacteria';

  @override
  String get healthDiseaseCatParasitic => 'Parasitic';

  @override
  String get healthDiseaseCatParasiticDesc => 'Diseases caused by parasites';

  @override
  String get healthDiseaseCatFungal => 'Fungal';

  @override
  String get healthDiseaseCatFungalDesc => 'Diseases caused by fungi';

  @override
  String get healthDiseaseCatNutritional => 'Nutritional';

  @override
  String get healthDiseaseCatNutritionalDesc => 'Nutritional deficiencies';

  @override
  String get healthDiseaseCatMetabolic => 'Metabolic';

  @override
  String get healthDiseaseCatMetabolicDesc => 'Metabolic disorders';

  @override
  String get healthDiseaseCatEnvironmental => 'Environmental';

  @override
  String get healthDiseaseCatEnvironmentalDesc =>
      'Caused by environmental factors';

  @override
  String get healthSeverityMild => 'Mild';

  @override
  String get healthSeverityMildDesc => 'Low production impact';

  @override
  String get healthSeverityModerate => 'Moderate';

  @override
  String get healthSeverityModerateDesc => 'Medium production impact';

  @override
  String get healthSeveritySevere => 'Severe';

  @override
  String get healthSeveritySevereDesc =>
      'High impact, requires immediate action';

  @override
  String get healthSeverityCritical => 'Critical';

  @override
  String get healthSeverityCriticalDesc => 'Sanitary emergency';

  @override
  String get healthDiseaseNewcastle => 'Newcastle Disease';

  @override
  String get healthDiseaseGumboro => 'Gumboro Disease (IBD)';

  @override
  String get healthDiseaseMarek => 'Marek\'s Disease';

  @override
  String get healthDiseaseBronchitis => 'Infectious Bronchitis (IB)';

  @override
  String get healthDiseaseAvianFlu => 'Avian Influenza (HPAI/LPAI)';

  @override
  String get healthDiseaseLaryngotracheitis =>
      'Infectious Laryngotracheitis (ILT)';

  @override
  String get healthDiseaseFowlPox => 'Fowl Pox';

  @override
  String get healthDiseaseInfectiousAnemia => 'Chicken Infectious Anemia (CAV)';

  @override
  String get healthDiseaseColibacillosis => 'Colibacillosis (E. coli)';

  @override
  String get healthDiseaseSalmonella => 'Salmonellosis';

  @override
  String get healthDiseaseMycoplasmosis => 'Mycoplasmosis (MG/MS)';

  @override
  String get healthDiseaseFowlCholera => 'Fowl Cholera';

  @override
  String get healthDiseaseCoryza => 'Infectious Coryza';

  @override
  String get healthDiseaseNecroticEnteritis => 'Necrotic Enteritis';

  @override
  String get healthDiseaseCoccidiosis => 'Coccidiosis';

  @override
  String get healthDiseaseRoundworms => 'Roundworms (Ascaridia)';

  @override
  String get healthDiseaseAspergillosis => 'Aspergillosis';

  @override
  String get healthDiseaseAscites => 'Ascites Syndrome';

  @override
  String get healthDiseaseSuddenDeath => 'Sudden Death Syndrome (SDS)';

  @override
  String get healthDiseaseVitEDeficiency => 'Encephalomalacia (Vit E Def.)';

  @override
  String get healthDiseaseRickets => 'Rickets (Vit D/Ca/P Def.)';

  @override
  String get healthMortalityDisease => 'Disease';

  @override
  String get healthMortalityDiseaseDesc => 'Infectious pathology';

  @override
  String get healthMortalityAccident => 'Accident';

  @override
  String get healthMortalityAccidentDesc => 'Trauma or injury';

  @override
  String get healthMortalityMalnutrition => 'Malnutrition';

  @override
  String get healthMortalityMalnutritionDesc => 'Nutrient deficiency';

  @override
  String get healthMortalityStress => 'Stress';

  @override
  String get healthMortalityStressDesc => 'Environmental factors';

  @override
  String get healthMortalityMetabolic => 'Metabolic';

  @override
  String get healthMortalityMetabolicDesc => 'Physiological problems';

  @override
  String get healthMortalityPredation => 'Predation';

  @override
  String get healthMortalityPredationDesc => 'Animal attacks';

  @override
  String get healthMortalitySacrifice => 'Sacrifice';

  @override
  String get healthMortalitySacrificeDesc => 'Death during slaughter';

  @override
  String get healthMortalityOldAge => 'Old Age';

  @override
  String get healthMortalityOldAgeDesc => 'End of productive life';

  @override
  String get healthMortalityUnknown => 'Unknown';

  @override
  String get healthMortalityUnknownDesc => 'Unidentified cause';

  @override
  String get healthMortalityCatSanitary => 'Sanitary';

  @override
  String get healthMortalityCatManagement => 'Management';

  @override
  String get healthMortalityCatNutritional => 'Nutritional';

  @override
  String get healthMortalityCatEnvironmental => 'Environmental';

  @override
  String get healthMortalityCatPhysiological => 'Physiological';

  @override
  String get healthMortalityCatNatural => 'Natural';

  @override
  String get healthMortalityCatUnclassified => 'Unclassified';

  @override
  String get healthActionVetDiagnosis => 'Request veterinary diagnosis';

  @override
  String get healthActionIsolate => 'Isolate affected birds';

  @override
  String get healthActionTreatment => 'Apply treatment if available';

  @override
  String get healthActionBiosecurity => 'Increase biosecurity';

  @override
  String get healthActionVaccinationReview => 'Review vaccination program';

  @override
  String get healthActionInspectFacilities => 'Inspect facilities';

  @override
  String get healthActionRepairEquipment => 'Repair damaged equipment';

  @override
  String get healthActionCheckDensity => 'Check bird density';

  @override
  String get healthActionTrainStaff => 'Train staff in handling';

  @override
  String get healthActionCheckFoodAccess => 'Verify food access';

  @override
  String get healthActionCheckFoodQuality => 'Check food quality';

  @override
  String get healthActionCheckDrinkers => 'Check drinker operation';

  @override
  String get healthActionAdjustNutrition => 'Adjust nutritional program';

  @override
  String get healthActionRegulateTemp => 'Regulate ambient temperature';

  @override
  String get healthActionImproveVentilation => 'Improve ventilation';

  @override
  String get healthActionReduceDensity => 'Reduce density if necessary';

  @override
  String get healthActionConsultNutritionist => 'Consult nutritionist';

  @override
  String get healthActionReviewGrowthProgram => 'Review growth program';

  @override
  String get healthActionAdjustFormula => 'Adjust feed formulation';

  @override
  String get healthActionReinforceFences => 'Reinforce perimeter fences';

  @override
  String get healthActionPestControl => 'Implement pest control';

  @override
  String get healthActionInstallNets => 'Install protective nets';

  @override
  String get healthActionNormalProcess => 'Normal in production process';

  @override
  String get healthActionRequestNecropsy =>
      'Request necropsy if mortality is high';

  @override
  String get healthActionIncreaseMonitoring => 'Increase batch monitoring';

  @override
  String get healthActionConsultVet => 'Consult veterinarian';

  @override
  String get healthRouteOral => 'Oral';

  @override
  String get healthRouteOralDesc => 'Oral administration';

  @override
  String get healthRouteWater => 'In Water';

  @override
  String get healthRouteWaterDesc => 'Dissolved in drinking water';

  @override
  String get healthRouteFood => 'In Feed';

  @override
  String get healthRouteFoodDesc => 'Mixed in feed';

  @override
  String get healthRouteOcular => 'Ocular';

  @override
  String get healthRouteOcularDesc => 'Eye drop';

  @override
  String get healthRouteNasal => 'Nasal';

  @override
  String get healthRouteNasalDesc => 'Nasal spray or drop';

  @override
  String get healthRouteSpray => 'Spray';

  @override
  String get healthRouteSprayDesc => 'Spraying over birds';

  @override
  String get healthRouteSubcutaneous => 'SC Injection';

  @override
  String get healthRouteSubcutaneousDesc => 'Subcutaneous in neck';

  @override
  String get healthRouteIntramuscular => 'IM Injection';

  @override
  String get healthRouteIntramuscularDesc => 'Intramuscular in breast';

  @override
  String get healthRouteWing => 'Wing Web';

  @override
  String get healthRouteWingDesc => 'Wing web puncture';

  @override
  String get healthRouteInOvo => 'In-Ovo';

  @override
  String get healthRouteInOvoDesc => 'Egg injection';

  @override
  String get healthRouteTopical => 'Topical';

  @override
  String get healthRouteTopicalDesc => 'External skin application';

  @override
  String get healthBioStatusPending => 'Pending';

  @override
  String get healthBioStatusCompliant => 'Compliant';

  @override
  String get healthBioStatusNonCompliant => 'Non-Compliant';

  @override
  String get healthBioStatusPartial => 'Partial';

  @override
  String get healthBioStatusNA => 'N/A';

  @override
  String get healthBioCatPersonnel => 'Personnel Access';

  @override
  String get healthBioCatPersonnelDesc => 'Entry and clothing control';

  @override
  String get healthBioCatVehicles => 'Vehicle Access';

  @override
  String get healthBioCatVehiclesDesc => 'Vehicle and equipment control';

  @override
  String get healthBioCatCleaning => 'Cleaning and Disinfection';

  @override
  String get healthBioCatCleaningDesc => 'Hygiene protocols';

  @override
  String get healthBioCatPestControl => 'Pest Control';

  @override
  String get healthBioCatPestControlDesc => 'Rodents, insects, wild birds';

  @override
  String get healthBioCatBirdManagement => 'Bird Management';

  @override
  String get healthBioCatBirdManagementDesc => 'Practices with birds';

  @override
  String get healthBioCatMortality => 'Mortality Management';

  @override
  String get healthBioCatMortalityDesc => 'Dead bird disposal';

  @override
  String get healthBioCatWater => 'Water Quality';

  @override
  String get healthBioCatWaterDesc => 'Potability and chlorination';

  @override
  String get healthBioCatFeed => 'Feed Management';

  @override
  String get healthBioCatFeedDesc => 'Storage and quality';

  @override
  String get healthBioCatFacilities => 'Facilities';

  @override
  String get healthBioCatFacilitiesDesc => 'Shed and equipment condition';

  @override
  String get healthBioCatRecords => 'Records';

  @override
  String get healthBioCatRecordsDesc => 'Documentation and traceability';

  @override
  String get healthInspFreqDaily => 'Daily';

  @override
  String get healthInspFreqWeekly => 'Weekly';

  @override
  String get healthInspFreqBiweekly => 'Biweekly';

  @override
  String get healthInspFreqMonthly => 'Monthly';

  @override
  String get healthInspFreqQuarterly => 'Quarterly';

  @override
  String get healthInspFreqPerBatch => 'Per Batch';

  @override
  String get healthAbCriticallyImportant => 'Critically Important';

  @override
  String get healthAbHighlyImportant => 'Highly Important';

  @override
  String get healthAbImportant => 'Important';

  @override
  String get healthAbUnclassified => 'Unclassified';

  @override
  String get healthAbFamilyFluoroquinolones => 'Fluoroquinolones';

  @override
  String get healthAbFamilyCephalosporins => '3rd/4th gen Cephalosporins';

  @override
  String get healthAbFamilyMacrolides => 'Macrolides';

  @override
  String get healthAbFamilyPolymyxins => 'Polymyxins (Colistin)';

  @override
  String get healthAbFamilyAminoglycosides => 'Aminoglycosides';

  @override
  String get healthAbFamilyPenicillins => 'Penicillins';

  @override
  String get healthAbFamilyTetracyclines => 'Tetracyclines';

  @override
  String get healthAbFamilySulfonamides => 'Sulfonamides';

  @override
  String get healthAbFamilyLincosamides => 'Lincosamides';

  @override
  String get healthAbFamilyPleuromutilins => 'Pleuromutilins';

  @override
  String get healthAbFamilyBacitracin => 'Bacitracin';

  @override
  String get healthAbFamilyIonophores => 'Ionophores';

  @override
  String get healthAbUseTreatment => 'Treatment';

  @override
  String get healthAbUseTreatmentDesc => 'Treatment of diagnosed disease';

  @override
  String get healthAbUseMetaphylaxis => 'Metaphylaxis';

  @override
  String get healthAbUseMetaphylaxisDesc =>
      'Preventive treatment of at-risk group';

  @override
  String get healthAbUseProphylaxis => 'Prophylaxis';

  @override
  String get healthAbUseProphylaxisDesc => 'Prevention in healthy animals';

  @override
  String get healthAbUseGrowthPromoter => 'Growth Promoter';

  @override
  String get healthAbUseGrowthPromoterDesc =>
      'Prohibited use in many countries';

  @override
  String get healthBirdTypeBroiler => 'Broiler';

  @override
  String get healthBirdTypeLayerCommercial => 'Commercial Layer Hen';

  @override
  String get healthBirdTypeLayerFreeRange => 'Free-Range Layer Hen';

  @override
  String get healthBirdTypeHeavyBreeder => 'Heavy Breeder';

  @override
  String get healthBirdTypeLightBreeder => 'Light Breeder';

  @override
  String get healthBirdTypeTurkeyMeat => 'Meat Turkey';

  @override
  String get healthBirdTypeQuail => 'Quail';

  @override
  String get healthBirdTypeDuck => 'Duck';

  @override
  String get farmStatusMaintenance => 'Maintenance';

  @override
  String get farmRoleOwner => 'Owner';

  @override
  String get farmRoleAdmin => 'Administrator';

  @override
  String get farmRoleManager => 'Manager';

  @override
  String get farmRoleOperator => 'Operator';

  @override
  String get farmRoleViewer => 'Viewer';

  @override
  String get farmRoleOwnerDesc => 'Full control, can delete the farm';

  @override
  String get farmRoleAdminDesc => 'Full control except deletion';

  @override
  String get farmRoleManagerDesc => 'Records and invitation management';

  @override
  String get farmRoleOperatorDesc => 'Can only create records';

  @override
  String get farmRoleViewerDesc => 'Read only';

  @override
  String get farmCreating => 'Creating farm...';

  @override
  String get farmUpdating => 'Updating farm...';

  @override
  String get farmDeleting => 'Deleting farm...';

  @override
  String get farmActivating => 'Activating farm...';

  @override
  String get farmSuspending => 'Suspending farm...';

  @override
  String get farmMaintenanceLoading => 'Setting maintenance...';

  @override
  String get farmSearching => 'Searching farms...';

  @override
  String get shedStatusActive => 'Active';

  @override
  String get shedStatusMaintenance => 'Maintenance';

  @override
  String get shedStatusInactive => 'Inactive';

  @override
  String get shedStatusDisinfection => 'Disinfection';

  @override
  String get shedStatusQuarantine => 'Quarantine';

  @override
  String get shedTypeMeat => 'Meat';

  @override
  String get shedTypeMeatDesc => 'Shed for meat production';

  @override
  String get shedTypeEgg => 'Egg';

  @override
  String get shedTypeEggDesc => 'Shed for egg production';

  @override
  String get shedTypeBreeder => 'Breeder';

  @override
  String get shedTypeBreederDesc => 'Shed for fertile egg production';

  @override
  String get shedTypeMixed => 'Mixed';

  @override
  String get shedTypeMixedDesc =>
      'Multi-purpose shed for different production types';

  @override
  String get shedEventDisinfection => 'Disinfection';

  @override
  String get shedEventMaintenance => 'Maintenance';

  @override
  String get shedEventStatusChange => 'Status Change';

  @override
  String get shedEventCreation => 'Creation';

  @override
  String get shedEventBatchAssigned => 'Batch Assigned';

  @override
  String get shedEventBatchReleased => 'Batch Released';

  @override
  String get shedEventOther => 'Other';

  @override
  String get shedCreating => 'Creating shed...';

  @override
  String get shedUpdating => 'Updating shed...';

  @override
  String get shedDeleting => 'Deleting shed...';

  @override
  String get shedChangingStatus => 'Changing status...';

  @override
  String get shedAssigningBatch => 'Assigning batch...';

  @override
  String get shedReleasing => 'Releasing shed...';

  @override
  String get shedSchedulingMaintenance => 'Scheduling maintenance...';

  @override
  String get shedBatchAssignedSuccess => 'Batch assigned successfully';

  @override
  String get shedReleasedSuccess => 'Shed released successfully';

  @override
  String get shedMaintenanceScheduled => 'Maintenance scheduled';

  @override
  String get notifStockLow => 'Low Stock';

  @override
  String get notifStockEmpty => 'Out of Stock';

  @override
  String get notifExpiringSoon => 'Expiring Soon';

  @override
  String get notifExpired => 'Expired';

  @override
  String get notifRestocked => 'Restocked';

  @override
  String get notifInventoryMovement => 'Movement';

  @override
  String get notifMortalityRecorded => 'Mortality Recorded';

  @override
  String get notifMortalityHigh => 'High Mortality';

  @override
  String get notifMortalityCritical => 'Critical Mortality';

  @override
  String get notifNewBatch => 'New Batch';

  @override
  String get notifBatchFinished => 'Batch Finished';

  @override
  String get notifWeightLow => 'Low Weight';

  @override
  String get notifCloseUpcoming => 'Close Upcoming';

  @override
  String get notifConversionAbnormal => 'Abnormal Conversion';

  @override
  String get notifNoRecords => 'No Records';

  @override
  String get notifProduction => 'Production';

  @override
  String get notifProductionLow => 'Low Production';

  @override
  String get notifProductionDrop => 'Production Drop';

  @override
  String get notifFirstEgg => 'First Egg';

  @override
  String get notifRecord => 'Record';

  @override
  String get notifGoalReached => 'Goal Reached';

  @override
  String get notifVaccination => 'Vaccination';

  @override
  String get notifVaccinationTomorrow => 'Vaccination Tomorrow';

  @override
  String get notifPriorityLow => 'Low';

  @override
  String get notifPriorityNormal => 'Normal';

  @override
  String get notifPriorityHigh => 'High';

  @override
  String get notifPriorityUrgent => 'Urgent';

  @override
  String notifTitleStockLow(Object itemName) {
    return '⚠️ Low stock: $itemName';
  }

  @override
  String notifMsgStockLow(Object quantity, Object unit) {
    return 'Only $quantity $unit remaining';
  }

  @override
  String notifTitleStockEmpty(Object itemName) {
    return '🚫 Out of stock: $itemName';
  }

  @override
  String get notifMsgStockEmpty => 'Stock at zero, requires urgent restocking';

  @override
  String notifTitleExpired(Object itemName) {
    return '❌ Expired: $itemName';
  }

  @override
  String notifMsgExpired(Object days) {
    return 'This product expired $days days ago';
  }

  @override
  String notifTitleExpiringSoon(Object itemName) {
    return '📅 Expiring soon: $itemName';
  }

  @override
  String get notifMsgExpiresToday => 'Expires today!';

  @override
  String notifMsgExpiresInDays(Object days) {
    return 'Expires in $days days';
  }

  @override
  String notifTitleRestocked(Object itemName) {
    return '✅ Restocked: $itemName';
  }

  @override
  String notifMsgRestocked(Object quantity, Object unit) {
    return '$quantity $unit added';
  }

  @override
  String notifTitleMortalityCritical(Object batchName) {
    return '🚨 CRITICAL Mortality: $batchName';
  }

  @override
  String notifTitleMortalityHigh(Object batchName) {
    return '⚠️ High mortality: $batchName';
  }

  @override
  String notifTitleMortalityRecorded(Object batchName) {
    return '🐔 Mortality recorded: $batchName';
  }

  @override
  String notifMsgMortalityRecorded(
    Object cause,
    Object count,
    Object percentage,
  ) {
    return '$count birds • Cause: $cause • Accumulated: $percentage%';
  }

  @override
  String notifTitleNewBatch(Object batchName) {
    return '🐤 New batch: $batchName';
  }

  @override
  String notifMsgNewBatch(Object birdCount, Object shedName) {
    return '$birdCount birds in $shedName';
  }

  @override
  String notifTitleBatchFinished(Object batchName) {
    return '✅ Batch finished: $batchName';
  }

  @override
  String notifMsgBatchFinished(Object days) {
    return '$days day cycle';
  }

  @override
  String notifTitleWeightLow(Object batchName) {
    return '⚖️ Low weight: $batchName';
  }

  @override
  String notifTitleConversionAbnormal(Object batchName) {
    return '📊 Abnormal conversion: $batchName';
  }

  @override
  String notifTitleCloseUpcoming(Object batchName) {
    return '📆 Close upcoming: $batchName';
  }

  @override
  String get notifMsgClosesToday => 'Close date is today!';

  @override
  String notifMsgClosesInDays(Object days) {
    return 'Closes in $days days';
  }

  @override
  String get reportTypeBatchProduction => 'Batch Production';

  @override
  String get reportTypeBatchProductionDesc =>
      'Complete summary of production performance';

  @override
  String get reportTypeMortality => 'Mortality';

  @override
  String get reportTypeMortalityDesc => 'Detailed mortality and cause analysis';

  @override
  String get reportTypeFeedConsumption => 'Feed Consumption';

  @override
  String get reportTypeFeedConsumptionDesc =>
      'Feed consumption and conversion analysis';

  @override
  String get reportTypeWeight => 'Weight and Growth';

  @override
  String get reportTypeWeightDesc => 'Weight evolution and growth curves';

  @override
  String get reportTypeCosts => 'Costs';

  @override
  String get reportTypeCostsDesc => 'Expense and operating cost breakdown';

  @override
  String get reportTypeSales => 'Sales';

  @override
  String get reportTypeSalesDesc => 'Sales and revenue summary';

  @override
  String get reportTypeProfitability => 'Profitability';

  @override
  String get reportTypeProfitabilityDesc => 'Utility and margin analysis';

  @override
  String get reportTypeHealth => 'Health';

  @override
  String get reportTypeHealthDesc => 'Treatment and vaccination history';

  @override
  String get reportTypeInventory => 'Inventory';

  @override
  String get reportTypeInventoryDesc => 'Current inventory status';

  @override
  String get reportTypeExecutive => 'Executive Summary';

  @override
  String get reportTypeExecutiveDesc => 'Consolidated view of key indicators';

  @override
  String get reportPeriodWeek => 'Last week';

  @override
  String get reportPeriodMonth => 'Last month';

  @override
  String get reportPeriodQuarter => 'Last quarter';

  @override
  String get reportPeriodSemester => 'Last semester';

  @override
  String get reportPeriodYear => 'Last year';

  @override
  String get reportPeriodCustom => 'Custom';

  @override
  String get reportFormatPdf => 'PDF';

  @override
  String get reportFormatPreview => 'Preview';

  @override
  String get reportPdfHeaderProduction => 'PRODUCTION REPORT';

  @override
  String get reportPdfHeaderExecutive => 'EXECUTIVE SUMMARY';

  @override
  String get reportPdfHeaderCosts => 'COST REPORT';

  @override
  String get reportPdfHeaderSales => 'SALES REPORT';

  @override
  String get reportPdfSectionBatchInfo => 'BATCH INFORMATION';

  @override
  String get reportPdfSectionProductionIndicators => 'PRODUCTION INDICATORS';

  @override
  String get reportPdfSectionFinancialSummary => 'FINANCIAL SUMMARY';

  @override
  String get reportPdfLabelCode => 'Code';

  @override
  String get reportPdfLabelBirdType => 'Bird Type';

  @override
  String get reportPdfLabelShed => 'Shed';

  @override
  String get reportPdfLabelEntryDate => 'Entry Date';

  @override
  String get reportPdfLabelCurrentAge => 'Current Age';

  @override
  String get reportPdfLabelDaysInFarm => 'Days in Farm';

  @override
  String get reportPdfLabelInitialBirds => 'Initial Birds';

  @override
  String get reportPdfLabelCurrentBirds => 'Current Birds';

  @override
  String get reportPdfLabelMortality => 'Mortality';

  @override
  String get reportPdfLabelAvgWeight => 'Average Weight';

  @override
  String get reportPdfLabelTotalConsumption => 'Total Consumption';

  @override
  String get reportPdfLabelConversion => 'Conversion';

  @override
  String get reportPdfLabelBirdCost => 'Bird Cost';

  @override
  String get reportPdfLabelFeedCost => 'Feed Cost';

  @override
  String get reportPdfLabelTotalCosts => 'Total Costs';

  @override
  String get reportPdfLabelSalesRevenue => 'Sales Revenue';

  @override
  String get reportPdfLabelBalance => 'BALANCE';

  @override
  String get reportPdfLabelPeriod => 'PERIOD';

  @override
  String get reportPdfConversionSubtitle => 'kg feed / kg weight';

  @override
  String get reportPageTitle => 'Reports';

  @override
  String get reportSelectType => 'Select report type';

  @override
  String get reportSelectFarm => 'Select a farm';

  @override
  String get reportSelectFarmHint =>
      'To generate reports, you must first select a farm from the home screen.';

  @override
  String get reportPeriodPrefix => 'Period:';

  @override
  String get reportPeriodTitle => 'Report period';

  @override
  String get reportDateFrom => 'From';

  @override
  String get reportDateTo => 'To';

  @override
  String get reportGenerating => 'Generating...';

  @override
  String get reportGeneratePdf => 'Generate PDF Report';

  @override
  String get reportNoFarmSelected => 'No farm selected';

  @override
  String get reportNoActiveBatches =>
      'No active batches to generate the report';

  @override
  String get reportInsufficientData => 'Insufficient data for the report';

  @override
  String get reportGenerateError => 'Error generating report';

  @override
  String get reportGenerated => 'Report Generated';

  @override
  String get reportPrint => 'Print';

  @override
  String get reportShareText => 'Report generated by Smart Granja Aves Pro';

  @override
  String get reportShareError => 'Error sharing';

  @override
  String get reportPrintError => 'Error printing';

  @override
  String get notifPageTitle => 'Notifications';

  @override
  String get notifMarkAllRead => 'Mark all as read';

  @override
  String get notifDeleteRead => 'Delete read';

  @override
  String get notifLoadError => 'Error loading notifications';

  @override
  String get notifAllMarkedRead => 'All marked as read';

  @override
  String get notifDeleteTitle => 'Delete notifications';

  @override
  String get notifDeleteReadConfirm =>
      'Do you want to delete all read notifications?';

  @override
  String get notifDeleted => 'Notifications deleted';

  @override
  String get notifNoDestination =>
      'This notification has no available destination';

  @override
  String get notifSingleDeleted => 'Notification deleted';

  @override
  String get notifAllCaughtUp => 'All caught up!';

  @override
  String get notifEmptyMessage =>
      'You have no pending notifications.\nWe\'ll let you know when something important comes up.';

  @override
  String get notifTooltip => 'Notifications';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get syncTitle => 'Sync & Data';

  @override
  String get syncConnectionStatus => 'Connection Status';

  @override
  String get syncPendingData => 'Pending data';

  @override
  String get syncChangesPending => 'There are changes to sync';

  @override
  String get syncAllSynced => 'All synced';

  @override
  String get syncLastSync => 'Last sync';

  @override
  String get syncCheckConnection => 'Check connection';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get syncForceSync => 'Force sync';

  @override
  String get syncOfflineInfo =>
      'Data is automatically saved to your device and synced when internet connection is available.';

  @override
  String get syncJustNow => 'Just now';

  @override
  String syncMinutesAgo(String n) {
    return '$n minutes ago';
  }

  @override
  String syncHoursAgo(Object n) {
    return '$n hours ago';
  }

  @override
  String syncDaysAgo(Object n) {
    return '$n days ago';
  }

  @override
  String get commonNotSpecified => 'Not specified';

  @override
  String get farmBroiler => 'Broiler';

  @override
  String get farmLayer => 'Layer';

  @override
  String get farmBreeder => 'Breeder';

  @override
  String get farmBird => 'Bird';

  @override
  String get formStepBasic => 'Basic';

  @override
  String get formStepLocation => 'Location';

  @override
  String get formStepContact => 'Contact';

  @override
  String get formStepCapacity => 'Capacity';

  @override
  String get commonLeave => 'Leave';

  @override
  String get commonRestore => 'Restore';

  @override
  String get commonProcessing => 'Processing...';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonDocument => 'Document';

  @override
  String get commonSupplier => 'Supplier';

  @override
  String get commonRegistrationInfo => 'Registration Information';

  @override
  String get commonLastUpdate => 'Last update';

  @override
  String get commonDraftFoundTitle => 'Draft found';

  @override
  String get commonExitWithoutCompleting => 'Leave without completing?';

  @override
  String get commonDataSafe => 'Don\'t worry, your data is safe.';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonFarm => 'Farm';

  @override
  String get commonBatch => 'Lot';

  @override
  String get commonFarmNotFound => 'Farm not found';

  @override
  String get commonBatchNotFound => 'Lot not found';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get monthJanAbbr => 'Jan';

  @override
  String get monthFebAbbr => 'Feb';

  @override
  String get monthMarAbbr => 'Mar';

  @override
  String get monthAprAbbr => 'Apr';

  @override
  String get monthMayAbbr => 'May';

  @override
  String get monthJunAbbr => 'Jun';

  @override
  String get monthJulAbbr => 'Jul';

  @override
  String get monthAugAbbr => 'Aug';

  @override
  String get monthSepAbbr => 'Sep';

  @override
  String get monthOctAbbr => 'Oct';

  @override
  String get monthNovAbbr => 'Nov';

  @override
  String get monthDecAbbr => 'Dec';

  @override
  String get ventaLoteTitle => 'Batch Sales';

  @override
  String get ventaAllTitle => 'All Sales';

  @override
  String get ventaFilterTooltip => 'Filter';

  @override
  String get ventaEmptyTitle => 'No sales registered';

  @override
  String get ventaEmptyDescription =>
      'Register your first sale to start tracking your income';

  @override
  String get ventaEmptyAction => 'Register first sale';

  @override
  String get ventaFilterEmptyTitle => 'No sales found';

  @override
  String get ventaFilterEmptyDescription =>
      'Try modifying the search filters to find the sales you are looking for';

  @override
  String get ventaNewButton => 'New Sale';

  @override
  String get ventaNewTooltip => 'Register new sale';

  @override
  String get ventaDeleteTitle => 'Delete sale?';

  @override
  String get ventaDeleteSuccess => 'Sale deleted successfully';

  @override
  String get ventaFilterTitle => 'Filter sales';

  @override
  String get ventaFilterProductType => 'Product type';

  @override
  String get ventaFilterSaleState => 'Sale status';

  @override
  String get ventaFilterAllStates => 'All statuses';

  @override
  String get ventaStatePending => 'Pending';

  @override
  String get ventaStateConfirmed => 'Confirmed';

  @override
  String get ventaStateSold => 'Sold';

  @override
  String get ventaSheetClient => 'Client';

  @override
  String get ventaSheetDiscount => 'Discount';

  @override
  String get ventaSheetInvoiceNumber => 'Invoice #';

  @override
  String get ventaSheetCarrier => 'Carrier';

  @override
  String get ventaSheetGuideNumber => 'Guide #';

  @override
  String get ventaSheetBirdCount => 'Bird count';

  @override
  String get ventaSheetAvgWeight => 'Average weight';

  @override
  String get ventaSheetPricePerKg => 'Price per kg';

  @override
  String get ventaSheetSlaughteredWeight => 'Slaughtered weight';

  @override
  String get ventaSheetYield => 'Yield';

  @override
  String get ventaSheetTotalEggs => 'Total eggs';

  @override
  String get ventaDetailNotFound => 'Sale not found';

  @override
  String get ventaDetailTitle => 'Sale Detail';

  @override
  String get ventaDetailEditTooltip => 'Edit sale';

  @override
  String get ventaDetailClient => 'Client';

  @override
  String get ventaDetailProductDetails => 'Product Details';

  @override
  String get ventaDetailBirdCount => 'Bird count';

  @override
  String get ventaDetailAvgWeight => 'Average weight';

  @override
  String get ventaDetailPricePerKg => 'Price per kg';

  @override
  String get ventaDetailQuantity => 'Quantity';

  @override
  String get ventaDetailUnitPrice => 'Unit price';

  @override
  String get ventaDetailCarcassYield => 'Carcass yield';

  @override
  String get ventaDetailTotalLabel => 'TOTAL';

  @override
  String get ventaDetailShare => 'Share';

  @override
  String get ventaDetailSlaughteredWeight => 'Slaughtered weight';

  @override
  String get ventaStepProduct => 'Product';

  @override
  String get ventaStepClient => 'Client';

  @override
  String get ventaStepDetails => 'Details';

  @override
  String get ventaDraftFoundMessage =>
      'Do you want to restore the previously saved sale draft?';

  @override
  String get ventaDraftRestored => 'Draft restored';

  @override
  String get ventaDraftJustNow => 'just now';

  @override
  String get ventaExitMessage => 'Don\'t worry, your data is safe.';

  @override
  String get ventaNoEditPermission =>
      'You don\'t have permission to edit sales on this farm';

  @override
  String get ventaNoCreatePermission =>
      'You don\'t have permission to register sales on this farm';

  @override
  String get ventaUpdateSuccess => 'Sale updated successfully';

  @override
  String get ventaCreateSuccess => 'Sale registered successfully!';

  @override
  String get ventaInventoryWarning =>
      'Sale registered, but there was an error updating inventory';

  @override
  String get ventaEditTitle => 'Edit Sale';

  @override
  String get ventaNewTitle => 'New Sale';

  @override
  String get ventaSelectProductFirst => 'Select a product type first';

  @override
  String get ventaDetailsHint => 'Enter quantities, prices and other details';

  @override
  String get ventaNoFarmSelected =>
      'No farm selected. Please select a farm first.';

  @override
  String get ventaLotLabel => 'Batch *';

  @override
  String get ventaNoActiveLots => 'No active batches in this farm.';

  @override
  String get ventaSelectLotHint => 'Select a batch';

  @override
  String get ventaSelectLotError => 'Select a batch';

  @override
  String get ventaSaleDate => 'Sale date';

  @override
  String get ventaBirdCount => 'Bird count';

  @override
  String get ventaBirdCountRequired => 'Enter the bird count';

  @override
  String get ventaTotalWeight => 'Total weight (kg)';

  @override
  String get ventaSlaughteredWeight => 'Total slaughtered weight (kg)';

  @override
  String get ventaWeightRequired => 'Enter the total weight';

  @override
  String ventaPricePerKg(String currency) {
    return 'Price per kg ($currency)';
  }

  @override
  String get ventaPriceRequired => 'Enter the price per kg';

  @override
  String get ventaEggInstructions =>
      'Enter the quantity and price per dozen for each classification';

  @override
  String get ventaEggQuantity => 'Quantity';

  @override
  String ventaEggPricePerDozen(String currency) {
    return '$currency per dozen';
  }

  @override
  String get ventaSaleUnit => 'Sale unit';

  @override
  String get ventaQuantityRequired => 'Enter the quantity';

  @override
  String get ventaPriceRequired2 => 'Enter the price';

  @override
  String get ventaObservations => 'Observations';

  @override
  String get ventaObservationsHint => 'Additional notes (optional)';

  @override
  String get ventaSubmitButton => 'Register Sale';

  @override
  String get ventaEditPageTitle => 'Edit Sale';

  @override
  String get ventaEditNotFound => 'Sale not found';

  @override
  String get ventaEditLoadError => 'Error loading the sale';

  @override
  String get ventaWhatToSell => 'What do you want to sell?';

  @override
  String get ventaSelectProductType => 'Select the product type for this sale';

  @override
  String get ventaDescAvesVivas =>
      'Live birds, ready for transport or breeding';

  @override
  String get ventaDescHuevos => 'Eggs by classification and dozen';

  @override
  String get ventaDescPollinaza => 'Organic fertilizer by bag, sack or ton';

  @override
  String get ventaDescAvesFaenadas => 'Processed birds ready for consumption';

  @override
  String get ventaDescAvesDescarte => 'Cull birds at end of production cycle';

  @override
  String get ventaClientData => 'Client Data';

  @override
  String get ventaClientHint => 'Enter the buyer information';

  @override
  String get ventaClientName => 'Full name';

  @override
  String get ventaClientNameHint => 'E.g.: John Doe';

  @override
  String get ventaClientDocType => 'Document type *';

  @override
  String get ventaClientCE => 'Foreign ID Card';

  @override
  String get ventaClientDocNumber => 'Document number';

  @override
  String get ventaClientDni8 => '8 digits';

  @override
  String get ventaClientRuc11 => '11 digits';

  @override
  String get ventaClientPhone => 'Contact phone';

  @override
  String get ventaClient9Digits => '9 digits';

  @override
  String get ventaClientNameRequired => 'Enter the client\'s name';

  @override
  String get ventaClientNameMinLength => 'Name must be at least 3 characters';

  @override
  String get ventaClientDocRequired => 'Enter the document number';

  @override
  String get ventaClientDniError => 'DNI must have 8 digits';

  @override
  String get ventaClientRucError => 'RUC must have 11 digits';

  @override
  String get ventaClientInvalidNumber => 'Invalid number';

  @override
  String get ventaClientPhoneRequired => 'Enter the contact phone';

  @override
  String get ventaClientPhoneError => 'Phone must have 9 digits';

  @override
  String get ventaSelectLocation => 'Select Location';

  @override
  String get ventaSelectLocationHint =>
      'Select the farm and lot to register the sale';

  @override
  String get ventaNoFarms => 'No farms registered';

  @override
  String get ventaCreateFarmFirst =>
      'You must create a farm before registering a sale';

  @override
  String get ventaFarmLabel => 'Farm *';

  @override
  String get ventaSelectFarmHint => 'Select a farm';

  @override
  String get ventaFarmRequired => 'Please select a farm';

  @override
  String get ventaNoActiveLots2 => 'No active lots';

  @override
  String get ventaNoActiveLotsHint =>
      'This farm has no active lots to register sales';

  @override
  String get ventaLotLabel2 => 'Lot *';

  @override
  String get ventaSelectLotHint2 => 'Select a lot';

  @override
  String get ventaLotRequired => 'Please select a lot';

  @override
  String get ventaFarmLoadError => 'Error loading farms';

  @override
  String get ventaLotLoadError2 => 'Error loading lots';

  @override
  String get ventaSummaryTitle => 'Sales Summary';

  @override
  String get ventaSummaryTotal => 'Total in sales';

  @override
  String get ventaSummaryActive => 'Active';

  @override
  String get ventaSummaryCompleted => 'Completed';

  @override
  String get ventaLoadError => 'Error loading sales';

  @override
  String get ventaLoadErrorDetail => 'There was a problem getting the sales';

  @override
  String get ventaCardBuyer => 'Buyer: ';

  @override
  String get ventaCardProduct => 'Product: ';

  @override
  String get ventaCardBirds => 'birds';

  @override
  String get ventaCardEggs => 'eggs';

  @override
  String get ventaShareReceiptTitle => '📋 SALE RECEIPT';

  @override
  String get costoLoteTitle => 'Lot Costs';

  @override
  String get costoAllTitle => 'All Costs';

  @override
  String get costoFilterTooltip => 'Filter';

  @override
  String get costoEmptyTitle => 'No costs registered';

  @override
  String get costoEmptyDescription =>
      'Register your operating expenses to keep detailed track of production costs';

  @override
  String get costoEmptyAction => 'Register Cost';

  @override
  String get costoFilterEmptyTitle => 'No costs found';

  @override
  String get costoFilterEmptyDescription =>
      'Try adjusting the filters or searching with other terms';

  @override
  String get costoNewButton => 'New Cost';

  @override
  String get costoNewTooltip => 'Register new cost';

  @override
  String get costoRejectTitle => 'Reject Cost';

  @override
  String get costoRejectReasonLabel => 'Rejection reason';

  @override
  String get costoRejectReasonHint => 'Explain why this cost is rejected';

  @override
  String get costoRejectButton => 'Reject';

  @override
  String get costoRejectReasonRequired => 'Enter a rejection reason';

  @override
  String get costoDeleteTitle => 'Delete Cost';

  @override
  String get costoDeleteWarning => 'This action cannot be undone.';

  @override
  String get costoDeleteSuccess => 'Cost deleted successfully';

  @override
  String get costoFilterTitle => 'Filter costs';

  @override
  String get costoFilterExpenseType => 'Expense type';

  @override
  String get costoDetailLoadError => 'We couldn\'t load the cost details';

  @override
  String get costoDetailNotFound => 'Cost not found';

  @override
  String get costoDetailTitle => 'Cost Detail';

  @override
  String get costoDetailEditTooltip => 'Edit cost';

  @override
  String get costoDetailPending => 'Pending';

  @override
  String get costoDetailRejected => 'Rejected';

  @override
  String get costoDetailApproved => 'Approved';

  @override
  String get costoDetailNoStatus => 'No status';

  @override
  String get costoDetailGeneralInfo => 'General Information';

  @override
  String get costoDetailConcept => 'Concept';

  @override
  String get costoDetailInvoiceNo => 'Invoice No.';

  @override
  String get costoDetailDeleteConfirm =>
      'Are you sure you want to delete this cost?';

  @override
  String get costoDetailDeleteWarning => 'This action cannot be undone.';

  @override
  String get costoDetailDeleteError => 'Error deleting';

  @override
  String get costoDetailDeleteSuccess => 'Cost deleted successfully';

  @override
  String get costoStepType => 'Type';

  @override
  String get costoStepAmount => 'Amount';

  @override
  String get costoStepDetails => 'Details';

  @override
  String get costoDraftFoundMessage =>
      'Do you want to restore the previously saved draft?';

  @override
  String get costoTypeRequired => 'Please select an expense type';

  @override
  String get costoNoEditPermission =>
      'You don\'t have permission to edit costs on this farm';

  @override
  String get costoNoCreatePermission =>
      'You don\'t have permission to register costs on this farm';

  @override
  String get costoUpdateSuccess => 'Cost updated successfully';

  @override
  String get costoCreateSuccess => 'Cost registered successfully';

  @override
  String get costoInventoryWarning =>
      'Cost registered, but there was an error updating inventory';

  @override
  String get costoEditTitle => 'Edit Cost';

  @override
  String get costoRegisterTitle => 'Register Cost';

  @override
  String get costoRegisterButton => 'Register';

  @override
  String get costoFarmRequired => 'Please select a farm';

  @override
  String get costoWhatType => 'What type of expense is it?';

  @override
  String get costoSelectCategory =>
      'Select the category that best describes this expense';

  @override
  String get costoAmountTitle => 'Expense Amount';

  @override
  String get costoAmountHint =>
      'Enter the total amount of the expense in soles';

  @override
  String get costoConceptLabel => 'Expense concept';

  @override
  String get costoConceptHint => 'E.g.: Purchase of balanced feed';

  @override
  String get costoConceptRequired => 'Enter the expense concept';

  @override
  String get costoConceptMinLength => 'Concept must be at least 5 characters';

  @override
  String get costoAmountLabel => 'Amount';

  @override
  String get costoAmountRequired => 'Enter the amount';

  @override
  String get costoAmountInvalid => 'Enter a valid amount';

  @override
  String get costoDateLabel => 'Expense date *';

  @override
  String get costoInventoryLinkInfo =>
      'You can link this expense to an inventory product to update stock automatically.';

  @override
  String get costoLinkFood => 'Link to inventory food';

  @override
  String get costoLinkMedicine => 'Link to inventory medicine';

  @override
  String get costoInventorySearchHint => 'Search inventory (optional)...';

  @override
  String get costoLinkedProduct => 'Linked product';

  @override
  String get costoStockUpdateNote => 'Stock will be updated on save';

  @override
  String get costoAdditionalDetails => 'Additional Details';

  @override
  String get costoAdditionalDetailsHint => 'Complementary expense information';

  @override
  String get costoSupplierHint => 'Supplier or company name';

  @override
  String get costoSupplierRequired => 'Enter the supplier name';

  @override
  String get costoSupplierMinLength => 'Name must be at least 3 characters';

  @override
  String get costoInvoiceLabel => 'Invoice/Receipt Number';

  @override
  String get costoObservationsHint => 'Additional notes about this expense';

  @override
  String get costoCardType => 'Type: ';

  @override
  String get costoCardConcept => 'Concept: ';

  @override
  String get costoCardSupplier => 'Supplier: ';

  @override
  String get costoTypeAlimento => 'Feed';

  @override
  String get costoTypeManoDeObra => 'Labor';

  @override
  String get costoTypeEnergia => 'Energy';

  @override
  String get costoTypeMedicamento => 'Medicine';

  @override
  String get costoTypeMantenimiento => 'Maintenance';

  @override
  String get costoTypeAgua => 'Water';

  @override
  String get costoTypeTransporte => 'Transport';

  @override
  String get costoTypeAdministrativo => 'Administrative';

  @override
  String get costoTypeDepreciacion => 'Depreciation';

  @override
  String get costoTypeFinanciero => 'Financial';

  @override
  String get costoTypeOtros => 'Others';

  @override
  String get costoSummaryTitle => 'Costs Summary';

  @override
  String get costoSummaryTotal => 'Total in costs';

  @override
  String get costoSummaryApproved => 'Approved';

  @override
  String get costoSummaryPending => 'Pending';

  @override
  String get costoLoadError => 'Error loading costs';

  @override
  String get inventarioTitle => 'Inventory';

  @override
  String get invFilterByType => 'Filter by type';

  @override
  String get invSearchByNameOrCode => 'Search by name or code...';

  @override
  String get invTabItems => 'Items';

  @override
  String get invTabMovements => 'Movements';

  @override
  String get invNoFarmSelected => 'No farm selected';

  @override
  String get invSelectFarmFromHome => 'Select a farm from the home screen';

  @override
  String get invAddNewItemTooltip => 'Add new inventory item';

  @override
  String get invNewItem => 'New Item';

  @override
  String get invNoResults => 'No results';

  @override
  String get invNoMovements => 'No movements';

  @override
  String get invNoMovementsMatchSearch => 'No movements match your search';

  @override
  String get invNoMovementsYet => 'No movements recorded yet';

  @override
  String get invErrorLoadingMovements => 'Could not load movements';

  @override
  String get invNoItemsInInventory => 'No items in inventory';

  @override
  String get invNoItemsMatchFilters => 'No items match the filters';

  @override
  String get invAddYourFirstItem => 'Add your first inventory item';

  @override
  String get invClearFilters => 'Clear filters';

  @override
  String get invAddItem => 'Add Item';

  @override
  String get invItemDeletedSuccess => 'Item deleted successfully';

  @override
  String get invApplyFilter => 'Apply filter';

  @override
  String get invItemDetail => 'Item Detail';

  @override
  String get invRegisterEntry => 'Register Entry';

  @override
  String get invRegisterExit => 'Register Exit';

  @override
  String get invAdjustStock => 'Adjust Stock';

  @override
  String get invItemNotFound => 'Item not found';

  @override
  String get invErrorLoadingItem => 'Could not load the inventory item';

  @override
  String get invStockDepleted => 'Depleted';

  @override
  String get invStockLow => 'Low Stock';

  @override
  String get invStockAvailable => 'Available';

  @override
  String get invStockCurrent => 'Current Stock';

  @override
  String get invStockMinimum => 'Minimum Stock';

  @override
  String get invTotalValue => 'Total Value';

  @override
  String get invInformation => 'Information';

  @override
  String get invCode => 'Code';

  @override
  String get invDescription => 'Description';

  @override
  String get invUnit => 'Unit';

  @override
  String get invUnitPrice => 'Unit Price';

  @override
  String get invExpiration => 'Expiration';

  @override
  String get invSupplierBatch => 'Supplier Batch';

  @override
  String get invWarehouse => 'Warehouse';

  @override
  String get invAlerts => 'Alerts';

  @override
  String get invAlertStockDepleted => 'Stock depleted';

  @override
  String get invAlertProductExpired => 'Product expired';

  @override
  String get invLastMovements => 'Recent Movements';

  @override
  String get invViewAll => 'View all';

  @override
  String get invNoMovementsRegistered => 'No movements recorded';

  @override
  String get invCouldNotLoadMovements => 'Could not load movements';

  @override
  String get invItemDeleted => 'Item deleted';

  @override
  String get invStepType => 'Type';

  @override
  String get invStepBasic => 'Basic';

  @override
  String get invStepStock => 'Stock';

  @override
  String get invStepDetails => 'Details';

  @override
  String get invDraftFound => 'Draft found';

  @override
  String get invEditItem => 'Edit Item';

  @override
  String get invNewItemTitle => 'New Item';

  @override
  String get invCreateItem => 'Create Item';

  @override
  String get invImageTooLarge => 'Image exceeds 5MB. Choose a smaller one';

  @override
  String get invImageSelected => 'Image selected';

  @override
  String get invErrorSelectingImage => 'Error selecting image';

  @override
  String get invCouldNotUploadImage => 'Could not upload image';

  @override
  String get invItemSavedWithoutImage => 'Item will be saved without image';

  @override
  String get invItemUpdatedSuccess => 'Item updated successfully';

  @override
  String get invDraftAutoSaveMessage =>
      'Don\'t worry, your data is safe. Your progress is saved automatically.';

  @override
  String get invMovementsTitle => 'Movements';

  @override
  String invMovementsOfItem(String item) {
    return 'Movements: $item';
  }

  @override
  String get invFilter => 'Filter';

  @override
  String get invErrorLoadingMovementsPage => 'Error loading movements';

  @override
  String get invNoMovementsWithFilters => 'No movements match these filters';

  @override
  String get invNoMovementsRegisteredHist => 'No movements registered';

  @override
  String get invClearFiltersHist => 'Clear filters';

  @override
  String get invToday => 'Today';

  @override
  String get invYesterday => 'Yesterday';

  @override
  String get invFilterMovements => 'Filter movements';

  @override
  String get invMovementType => 'Movement type';

  @override
  String get invAll => 'All';

  @override
  String get invDateRange => 'Date range';

  @override
  String get invFrom => 'From';

  @override
  String get invUntil => 'Until';

  @override
  String get invClear => 'Clear';

  @override
  String get invDialogRegisterEntry => 'Register Entry';

  @override
  String get invDialogRegisterExit => 'Register Exit';

  @override
  String get invDialogMovementType => 'Movement type';

  @override
  String get invSelectType => 'Select a type';

  @override
  String get invEnterQuantity => 'Enter the quantity';

  @override
  String get invEnterValidNumberGt0 => 'Enter a valid number greater than 0';

  @override
  String get invQuantityExceedsStock => 'Quantity exceeds available stock';

  @override
  String get invTotalCost => 'Total cost';

  @override
  String get invSupplierName => 'Supplier name';

  @override
  String get invObservation => 'Observation';

  @override
  String get invReasonOrObservation => 'Reason or observation';

  @override
  String get invDialogAdjustStock => 'Adjust Stock';

  @override
  String get invEnterNewStock => 'Enter the new stock';

  @override
  String get invEnterValidNumber => 'Enter a valid number';

  @override
  String get invAdjustmentReason => 'Adjustment reason';

  @override
  String get invReasonRequired => 'Reason is required';

  @override
  String get invAdjust => 'Adjust';

  @override
  String get invStockAdjustedSuccess => 'Stock adjusted successfully';

  @override
  String get invEntryRegistered => 'Entry registered successfully';

  @override
  String get invExitRegistered => 'Exit registered successfully';

  @override
  String get invDeleteItem => 'Delete item';

  @override
  String invConfirmDeleteItemName(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get invActionIrreversible => 'This action is irreversible';

  @override
  String get invDeleteWarningDetails =>
      'All movements and associated data will be deleted';

  @override
  String get invTypeNameToConfirm => 'Type the item name to confirm';

  @override
  String get invTypeHere => 'Type here...';

  @override
  String get invCardDepleted => 'Depleted';

  @override
  String get invCardLowStock => 'Low Stock';

  @override
  String get invCardAvailable => 'Available';

  @override
  String get invCardProductExpired => 'Product expired';

  @override
  String get invViewDetails => 'View Details';

  @override
  String get invMoreOptionsItem => 'More item options';

  @override
  String get invCardDetails => 'Details';

  @override
  String get invCardStock => 'Stock';

  @override
  String get invCardMinimum => 'Minimum';

  @override
  String get invCardValue => 'Value';

  @override
  String get invSelectProduct => 'Select product';

  @override
  String get invSearchInventory => 'Search inventory...';

  @override
  String get invSearchProduct => 'Search product...';

  @override
  String get invNoProductsFound => 'No products found';

  @override
  String get invNoProductsAvailable => 'No products available';

  @override
  String get invSelectorStockLow => 'Low stock';

  @override
  String get invErrorLoadingInventory => 'Error loading inventory';

  @override
  String get invStockTitle => 'Stock';

  @override
  String get invConfigureQuantities =>
      'Configure quantities and unit of measure';

  @override
  String get invUnitsFilteredAutomatically =>
      'Units are automatically filtered by the selected product type.';

  @override
  String get invUnitOfMeasure => 'Unit of Measure *';

  @override
  String get invStockActual => 'Current Stock';

  @override
  String get invEnterCurrentStock => 'Enter the current stock';

  @override
  String get invEnterValidNumberStock => 'Enter a valid number';

  @override
  String get invStockMin => 'Minimum Stock';

  @override
  String get invStockMax => 'Maximum Stock';

  @override
  String get invOptional => 'Optional';

  @override
  String get invStockAlerts => 'Stock alerts';

  @override
  String get invStockAlertMessage =>
      'You will receive a notification when stock falls below the configured minimum.';

  @override
  String get invBasicInfo => 'Basic Information';

  @override
  String get invEnterMainData => 'Enter the main item data';

  @override
  String get invItemName => 'Item Name';

  @override
  String get invEnterItemName => 'Enter the item name';

  @override
  String get invNameMinChars => 'Name must be at least 2 characters';

  @override
  String get invCodeSkuOptional => 'Code/SKU (optional)';

  @override
  String get invDescriptionOptional => 'Description (optional)';

  @override
  String get invDescribeProductCharacteristics =>
      'Describe the product features...';

  @override
  String get invSkuHelpsIdentify =>
      'The Code/SKU will help you quickly identify the item in your inventory.';

  @override
  String get invAdditionalDetails => 'Additional Details';

  @override
  String get invOptionalInfoBetterControl =>
      'Optional information for better control';

  @override
  String get invUnitPriceLabel => 'Unit Price';

  @override
  String get invSupplierLabel => 'Supplier';

  @override
  String get invSupplierNameHint => 'Supplier name';

  @override
  String get invWarehouseLocation => 'Warehouse Location';

  @override
  String get invExpirationTitle => 'Expiration';

  @override
  String get invExpirationDateOptional => 'Expiration date (optional)';

  @override
  String get invSelectDate => 'Select date';

  @override
  String get invSupplierBatchLabel => 'Supplier Batch';

  @override
  String get invBatchNumber => 'Batch number';

  @override
  String get invDetailsOptionalHelp =>
      'This data is optional but helps with better inventory control and traceability.';

  @override
  String get invWhatTypeOfItem => 'What type of item is it?';

  @override
  String get invSelectItemCategory => 'Select the inventory item category';

  @override
  String get invDescAlimento =>
      'Concentrates, corn, soy and other poultry feed';

  @override
  String get invDescMedicamento =>
      'Antibiotics, antiparasitics and veterinary treatments';

  @override
  String get invDescVacuna => 'Vaccines and immunization products';

  @override
  String get invDescEquipo => 'Drinkers, feeders, heating equipment and tools';

  @override
  String get invDescInsumo =>
      'Bedding materials, disinfectants and other supplies';

  @override
  String get invDescLimpieza => 'Cleaning and disinfection products';

  @override
  String get invDescOtro => 'Other items that don\'t fit previous categories';

  @override
  String get invProductImage => 'Product Image';

  @override
  String get invTakePhoto => 'Take Photo';

  @override
  String get invGallery => 'Gallery';

  @override
  String get invImageSelectedLabel => 'Image selected';

  @override
  String get invReady => 'Ready';

  @override
  String get invNoImageAdded => 'No image added';

  @override
  String get invCanAddProductPhoto => 'You can add a product photo';

  @override
  String get invStockBefore => 'Previous stock';

  @override
  String get invStockAfter => 'New stock';

  @override
  String get invInventoryLabel => 'Inventory';

  @override
  String get invItemsRegistered => 'items registered';

  @override
  String get invViewAllItems => 'View all';

  @override
  String get invTotalItems => 'Total Items';

  @override
  String get invLowStock => 'Low Stock';

  @override
  String get invDepletedItems => 'Depleted';

  @override
  String get invExpiringSoon => 'Expiring Soon';

  @override
  String get saludFilterAll => 'All';

  @override
  String get saludFilterInTreatment => 'In treatment';

  @override
  String get saludFilterClosed => 'Closed';

  @override
  String get saludRecordsTitle => 'Health Records';

  @override
  String get saludFilterTooltip => 'Filter';

  @override
  String get saludEmptyTitle => 'No health records';

  @override
  String get saludEmptyDescription =>
      'Register treatments, diagnoses and health monitoring for the batch';

  @override
  String get saludRegisterTreatment => 'Register Treatment';

  @override
  String get saludNoRecordsFound => 'No records found';

  @override
  String get saludNoFilterResults => 'No records match the applied filters';

  @override
  String get saludFilterByBatch => 'Filter by batch';

  @override
  String get saludNewTreatment => 'New Treatment';

  @override
  String get saludNewTreatmentTooltip => 'Register new treatment';

  @override
  String get saludFilterRecords => 'Filter records';

  @override
  String get saludTreatmentStatus => 'Treatment status';

  @override
  String get saludDeleteRecordTitle => 'Delete record?';

  @override
  String get saludRecordDeleted => 'Record deleted successfully';

  @override
  String get saludCloseTreatmentTitle => 'Close Treatment';

  @override
  String get saludDescribeResult =>
      'Describe the result of the applied treatment';

  @override
  String get saludResultRequired => 'Result *';

  @override
  String get saludResultHint => 'E.g.: Complete recovery, no symptoms';

  @override
  String get saludResultValidation => 'Result is required';

  @override
  String get saludResultMinLength =>
      'Describe the result (minimum 10 characters)';

  @override
  String get saludFinalObservations => 'Final observations';

  @override
  String get saludAdditionalNotesOptional => 'Additional notes (optional)';

  @override
  String get saludTreatmentClosedSuccess => 'Treatment closed successfully';

  @override
  String get saludStatusInTreatment => 'In treatment';

  @override
  String get saludStatusClosed => 'Closed';

  @override
  String get saludDiagnosis => 'Diagnosis';

  @override
  String get saludSymptoms => 'Symptoms';

  @override
  String get saludTreatment => 'Treatment';

  @override
  String get saludMedications => 'Medications';

  @override
  String get saludDosage => 'Dosage';

  @override
  String get saludDuration => 'Duration';

  @override
  String get saludDays => 'days';

  @override
  String get saludVeterinarian => 'Veterinarian';

  @override
  String get saludResult => 'Result';

  @override
  String get saludCloseDate => 'Close date';

  @override
  String get saludTreatmentDays => 'Treatment days';

  @override
  String get saludAllBatches => 'All';

  @override
  String get saludDetailTitle => 'Record Detail';

  @override
  String get saludRecordNotFound => 'Record not found';

  @override
  String get saludLoadError => 'We could not load the health record';

  @override
  String get saludDetailStatusClosed => 'Closed';

  @override
  String get saludDetailStatusInTreatment => 'In treatment';

  @override
  String get saludDetailDiagnosisSection => 'Diagnosis';

  @override
  String get saludDetailDateLabel => 'Date';

  @override
  String get saludDetailTreatmentSection => 'Treatment';

  @override
  String get saludDetailUser => 'User';

  @override
  String get saludDetailCloseTreatment => 'Close Treatment';

  @override
  String get saludDetailCloseDate => 'Close Date';

  @override
  String get saludDetailResultOptional => 'Result (Optional)';

  @override
  String get saludDetailDescribeResult => 'Describe the treatment result';

  @override
  String get saludDetailDeleteTitle => 'Delete record?';

  @override
  String get saludDetailRecordDeleted => 'Record deleted';

  @override
  String get saludDetailTreatmentClosed => 'Treatment closed';

  @override
  String get saludDetailCloseError => 'Error closing treatment';

  @override
  String get saludDetailDeleteError => 'Error deleting record';

  @override
  String get vacFilterApplied => 'Applied';

  @override
  String get vacFilterPending => 'Pending';

  @override
  String get vacFilterExpired => 'Expired';

  @override
  String get vacFilterUpcoming => 'Upcoming';

  @override
  String get vacTitle => 'Vaccinations';

  @override
  String get vacFilterTooltip => 'Filter';

  @override
  String get vacEmptyTitle => 'No vaccinations scheduled';

  @override
  String get vacEmptyDescription =>
      'Schedule vaccines to maintain batch health';

  @override
  String get vacScheduleVaccination => 'Schedule Vaccination';

  @override
  String get vacNoResults => 'No results';

  @override
  String get vacNoFilterResults =>
      'No vaccinations found with the applied filters';

  @override
  String get vacSchedule => 'Schedule';

  @override
  String get vacScheduleTooltip => 'Schedule new vaccination';

  @override
  String get vacNoFarmSelected => 'No farm selected';

  @override
  String get vacNoFarmDescription =>
      'Select a farm from the main menu to view scheduled vaccinations.';

  @override
  String get vacGoHome => 'Go to home';

  @override
  String get vacFilterTitle => 'Filter vaccinations';

  @override
  String get vacVaccinationStatus => 'Vaccination status';

  @override
  String get vacAllStatuses => 'All statuses';

  @override
  String get vacDeleteTitle => 'Delete vaccination?';

  @override
  String get vacDeleted => 'Vaccination deleted successfully';

  @override
  String get vacMarkAppliedTitle => 'Mark as Applied';

  @override
  String get vacApplicationDetails => 'Register the application details';

  @override
  String get vacAgeWeeksRequired => 'Age (weeks) *';

  @override
  String get vacAgeRequired => 'Age is required';

  @override
  String get vacAgeInvalid => 'Age must be a number greater than 0';

  @override
  String get vacDosisRequired => 'Dosage *';

  @override
  String get vacDosisValidation => 'Dosage is required';

  @override
  String get vacRouteRequired => 'Application route *';

  @override
  String get vacRouteValidation => 'Route is required';

  @override
  String get vacMarkedApplied => 'Vaccine marked as applied';

  @override
  String get vacSheetApplied => 'Applied';

  @override
  String get vacSheetExpired => 'Expired';

  @override
  String get vacSheetUpcoming => 'Upcoming';

  @override
  String get vacSheetPending => 'Pending';

  @override
  String get vacVaccine => 'Vaccine';

  @override
  String get vacScheduledDate => 'Scheduled date';

  @override
  String get vacApplicationDate => 'Application date';

  @override
  String get vacAgeApplication => 'Application age';

  @override
  String get vacWeeks => 'weeks';

  @override
  String get vacDosis => 'Dosage';

  @override
  String get vacRoute => 'Route';

  @override
  String get vacLaboratory => 'Laboratory';

  @override
  String get vacVaccineBatch => 'Vaccine batch';

  @override
  String get vacResponsible => 'Responsible';

  @override
  String get vacNextApplication => 'Next application';

  @override
  String get vacScheduledBy => 'Scheduled by';

  @override
  String get vacMarkAppliedButton => 'Mark Applied';

  @override
  String get vacDeleteButton => 'Delete';

  @override
  String get vacDetailTitle => 'Vaccination Detail';

  @override
  String get vacDetailNotFound => 'Vaccination not found';

  @override
  String get vacDetailLoadError => 'We could not load the vaccination';

  @override
  String get vacDetailStatusApplied => 'Applied';

  @override
  String get vacDetailStatusExpired => 'Expired';

  @override
  String get vacDetailStatusUpcoming => 'Upcoming';

  @override
  String get vacDetailStatusPending => 'Pending';

  @override
  String get vacDetailVaccineInfo => 'Vaccine Information';

  @override
  String get vacDetailScheduledDate => 'Scheduled Date';

  @override
  String get vacDetailAgeApplication => 'Application Age';

  @override
  String get vacDetailVaccineBatch => 'Vaccine Batch';

  @override
  String get vacDetailNextApplication => 'Next Application';

  @override
  String get vacDetailMarkAppliedButton => 'Mark as Applied';

  @override
  String get vacDetailSelectDate => 'Select the application date';

  @override
  String get vacDetailMarkedApplied => 'Vaccination marked as applied';

  @override
  String get vacDetailMarkError => 'Error marking vaccination';

  @override
  String get vacDetailDeleteTitle => 'Delete vaccination?';

  @override
  String get vacDetailDeleted => 'Vaccination deleted';

  @override
  String get vacDetailDeleteError => 'Error deleting vaccination';

  @override
  String get vacDetailMenuMarkApplied => 'Mark Applied';

  @override
  String get vacDetailMenuDelete => 'Delete';

  @override
  String get treatFormStepLocation => 'Location';

  @override
  String get treatFormStepLocationDesc => 'Select farm and batch';

  @override
  String get treatFormStepDiagnosis => 'Diagnosis';

  @override
  String get treatFormStepDiagnosisDesc => 'Diagnosis and symptoms information';

  @override
  String get treatFormStepTreatment => 'Treatment';

  @override
  String get treatFormStepTreatmentDesc => 'Treatment and medication details';

  @override
  String get treatFormStepInfo => 'Information';

  @override
  String get treatFormStepInfoDesc =>
      'Veterinarian and additional observations';

  @override
  String get treatDraftFoundMessage =>
      'Do you want to restore the previously saved treatment draft?';

  @override
  String get treatSavedMomentAgo => 'Saved a moment ago';

  @override
  String get treatExit => 'Leave';

  @override
  String get treatNewTitle => 'New Treatment';

  @override
  String get treatSelectFarmBatch => 'Please select a farm and a batch';

  @override
  String get treatDurationRange => 'Duration must be between 1 and 365 days';

  @override
  String get treatFutureDate => 'Date cannot be in the future';

  @override
  String get treatCompleteRequired => 'Please complete the required fields';

  @override
  String get treatRegisteredSuccess => 'Treatment registered successfully';

  @override
  String get treatRegisteredInventoryError =>
      'Treatment registered, but there was an error updating inventory';

  @override
  String get treatRegisterError => 'Error registering treatment';

  @override
  String get vacFormStepVaccine => 'Vaccine';

  @override
  String get vacFormStepApplication => 'Application';

  @override
  String get vacFormTitle => 'Schedule Vaccination';

  @override
  String get vacFormSubmit => 'Schedule Vaccination';

  @override
  String get vacFormDraftFound => 'Draft found';

  @override
  String get vacFormSelectBatch => 'You must select a batch';

  @override
  String get vacFormSuccess => 'Vaccination scheduled successfully!';

  @override
  String get vacFormInventoryError =>
      'Vaccination registered, but there was an error deducting inventory';

  @override
  String get vacFormError => 'Error scheduling vaccination';

  @override
  String get vacFormScheduleError => 'Error scheduling';

  @override
  String get diseaseCatalogTitle => 'Disease Catalog';

  @override
  String get diseaseCatalogSearchHint => 'Search disease, symptom...';

  @override
  String get diseaseCatalogAll => 'All';

  @override
  String get diseaseCatalogCritical => 'Critical';

  @override
  String get diseaseCatalogSevere => 'Severe';

  @override
  String get diseaseCatalogModerate => 'Moderate';

  @override
  String get diseaseCatalogMild => 'Mild';

  @override
  String get diseaseCatalogMandatoryNotification => 'Mandatory notification';

  @override
  String get diseaseCatalogVaccinable => 'Vaccinable';

  @override
  String get diseaseCatalogCategory => 'Category';

  @override
  String get diseaseCatalogSymptoms => 'Symptoms';

  @override
  String get diseaseCatalogSeverity => 'Severity';

  @override
  String get diseaseCatalogViewDetails => 'View Details';

  @override
  String get diseaseCatalogNoResults => 'No diseases found';

  @override
  String get diseaseCatalogEmpty => 'Empty catalog';

  @override
  String get diseaseCatalogTryOther => 'Try other search terms or filters';

  @override
  String get diseaseCatalogNoneRegistered => 'No diseases registered';

  @override
  String get diseaseCatalogClearFilters => 'Clear filters';

  @override
  String get bioOverviewTitle => 'Biosecurity';

  @override
  String get bioNewInspection => 'New Inspection';

  @override
  String get bioNewInspectionTooltip => 'Create new inspection';

  @override
  String get bioEmptyTitle => 'No inspections registered yet';

  @override
  String get bioMetricInspections => 'Inspections';

  @override
  String get bioMetricAverage => 'Average';

  @override
  String get bioMetricCritical => 'Critical';

  @override
  String get bioMetricLastLevel => 'Last level';

  @override
  String get bioRecentHistory => 'Recent history';

  @override
  String get bioGeneralInspection => 'General inspection';

  @override
  String get bioShedInspection => 'Shed inspection';

  @override
  String get bioScore => 'Score';

  @override
  String get bioNonCompliant => 'Non-compliant';

  @override
  String get bioPending => 'Pending';

  @override
  String get bioLoadError => 'Could not load biosecurity';

  @override
  String get bioNoInspectionYet => 'No inspection completed yet.';

  @override
  String get bioLastInspection => 'Last inspection:';

  @override
  String get bioInspectionTitle => 'Biosecurity Inspection';

  @override
  String get bioInspectionNewTitle => 'New Inspection';

  @override
  String get bioInspectionStepLocation => 'Location';

  @override
  String get bioInspectionStepChecklist => 'Checklist';

  @override
  String get bioInspectionStepSummary => 'Summary';

  @override
  String get bioInspectionSave => 'Save Inspection';

  @override
  String get bioInspectionLoadError => 'Error loading data';

  @override
  String get bioInspectionExitTitle => 'Leave without completing?';

  @override
  String get bioInspectionExitMessage =>
      'You have an inspection in progress. If you leave now, you\'ll lose the changes.';

  @override
  String get bioInspectionSaveMessage =>
      'The inspection will be saved and the corresponding report will be generated.';

  @override
  String get bioInspectionSaveSuccess => 'Inspection saved successfully';

  @override
  String get bioInspectionLoadingFarm => 'Loading farm…';

  @override
  String get bioInspectionMinProgress =>
      'Evaluate at least 50% of items to continue';

  @override
  String get saludSummaryTitle => 'Health Summary';

  @override
  String get saludAllUnderControl => 'Everything under control';

  @override
  String get saludHealthStatus => 'Health status';

  @override
  String get saludActive => 'Active';

  @override
  String get saludClosedCount => 'Closed';

  @override
  String get saludCardActive => 'Active';

  @override
  String get saludCardClosed => 'Closed';

  @override
  String get saludCardDiagnosisPrefix => 'Diagnosis: ';

  @override
  String get saludCardTreatmentPrefix => 'Treatment: ';

  @override
  String get saludErrorTitle => 'Error loading records';

  @override
  String get vacSummaryTitle => 'Vaccination Summary';

  @override
  String get vacSummaryExpiredWarning =>
      'Attention! There are expired vaccines';

  @override
  String get vacSummaryUpcomingWarning =>
      'There are upcoming vaccines to apply';

  @override
  String get vacSummaryUpToDate => 'Vaccinations up to date';

  @override
  String get vacSummaryAllApplied => 'All vaccines applied';

  @override
  String get vacSummaryApplied => 'Applied';

  @override
  String get vacCardStatusApplied => 'Applied';

  @override
  String get vacCardStatusExpired => 'Expired';

  @override
  String get vacCardStatusUpcoming => 'Upcoming';

  @override
  String get vacCardStatusPending => 'Pending';

  @override
  String get vacCardVaccinePrefix => 'Vaccine: ';

  @override
  String get vacCardDosisPrefix => 'Dosage: ';

  @override
  String get vacCardRoutePrefix => 'Route: ';

  @override
  String get vacCardExpiredAgo => 'Expired ago: ';

  @override
  String get vacCardDaysLeft => 'Remaining: ';

  @override
  String get vacErrorTitle => 'Error loading vaccinations';

  @override
  String get vacStepVaccineInfoTitle => 'Vaccine Information';

  @override
  String get vacStepVaccineInfoDesc =>
      'Enter the data for the vaccine to schedule';

  @override
  String get vacStepBatchRequired => 'Batch *';

  @override
  String get vacStepSelectBatch => 'Select a batch';

  @override
  String get vacStepSelectFromInventory => 'Select from inventory';

  @override
  String get vacStepSelectVaccineInventory => 'Select vaccine from inventory';

  @override
  String get vacStepOptionalSelectVaccine =>
      'Optional - Select a registered vaccine';

  @override
  String get vacStepInventoryNote =>
      'If you select from inventory, stock will be automatically deducted.';

  @override
  String get vacStepVaccineName => 'Vaccine name';

  @override
  String get vacStepVaccineNameHint => 'E.g.: Newcastle + Bronchitis';

  @override
  String get vacStepVaccineNameRequired => 'Enter the vaccine name';

  @override
  String get vacStepVaccineNameMinLength =>
      'Name must have at least 3 characters';

  @override
  String get vacStepVaccineBatch => 'Vaccine batch (optional)';

  @override
  String get vacStepVaccineBatchHint => 'E.g.: LOT123456';

  @override
  String get vacStepScheduledDate => 'Scheduled date *';

  @override
  String get vacStepTipTitle => 'Tip';

  @override
  String get vacStepTipMessage =>
      'Schedule vaccinations in advance to keep the health calendar up to date.';

  @override
  String get vacStepAppObsTitle => 'Application and Observations';

  @override
  String get vacStepAppObsDesc =>
      'Record when it was applied and add observations';

  @override
  String get vacStepAppDateOptional => 'Application date (optional)';

  @override
  String get vacStepSelectDate => 'Select date';

  @override
  String get vacStepRemoveDate => 'Remove date';

  @override
  String get vacStepObservationsOptional => 'Observations (optional)';

  @override
  String get vacStepObservationsHint =>
      'Observed reactions, special notes, etc.';

  @override
  String get vacStepVaccineApplied => 'Vaccine applied';

  @override
  String get vacStepAppliedNote =>
      'The vaccination will be registered as applied.';

  @override
  String get vacStepScheduled => 'Vaccination scheduled';

  @override
  String get vacStepScheduledNote =>
      'It will remain pending. You can mark it as applied later.';

  @override
  String get vacStepCalendarReminder =>
      'Scheduled vaccinations will appear in your calendar and you will receive reminders.';

  @override
  String get treatStepDiagTitle => 'Diagnosis and Symptoms';

  @override
  String get treatStepDiagDesc =>
      'Record the diagnosis and symptoms observed in the birds';

  @override
  String get treatStepDiagImportant => 'Important information';

  @override
  String get treatStepDiagImportantMsg =>
      'An accurate diagnosis allows selecting the most effective treatment and preventing spread.';

  @override
  String get treatStepDateRequired => 'Treatment date *';

  @override
  String get treatStepDiagnosis => 'Diagnosis';

  @override
  String get treatStepDiagnosisHint => 'E.g.: Chronic respiratory disease';

  @override
  String get treatStepDiagRequired => 'Diagnosis is required';

  @override
  String get treatStepDiagMinLength => 'Must have at least 5 characters';

  @override
  String get treatStepSymptoms => 'Observed symptoms';

  @override
  String get treatStepSymptomsHint =>
      'Describe symptoms: cough, sneezing, lethargy...';

  @override
  String get treatStepDetailsTitle => 'Treatment Details';

  @override
  String get treatStepDetailsDesc =>
      'Describe the applied treatment and medications';

  @override
  String get treatStepDetailsImportant => 'Important information';

  @override
  String get treatStepDetailsImportantMsg =>
      'If you select a medication from inventory, stock will be automatically deducted on save.';

  @override
  String get treatStepTreatmentDesc => 'Treatment description';

  @override
  String get treatStepTreatmentHint =>
      'Describe the applied treatment protocol';

  @override
  String get treatStepTreatmentRequired => 'Treatment is required';

  @override
  String get treatStepTreatmentMinLength => 'Must have at least 5 characters';

  @override
  String get treatStepInventoryMed => 'Medication from inventory (optional)';

  @override
  String get treatStepSelectMed => 'Select medication from inventory...';

  @override
  String get treatStepAutoDeduct =>
      'Will be automatically deducted from inventory';

  @override
  String get treatStepMedicationsAdditional => 'Additional medications';

  @override
  String get treatStepMedications => 'Medications';

  @override
  String get treatStepMedicationsHint =>
      'E.g.: Enrofloxacin + Vitamins A, D, E';

  @override
  String get treatStepDosis => 'Dosage';

  @override
  String get treatStepDosisHint => 'E.g.: 1ml/L';

  @override
  String get treatStepDuration => 'Duration (days)';

  @override
  String get treatStepDurationHint => 'E.g.: 5';

  @override
  String get treatStepDurationMin => 'Must be > 0';

  @override
  String get treatStepDurationMax => 'Maximum 365';

  @override
  String get treatStepSelectLocationTitle => 'Select Location';

  @override
  String get treatStepSelectBatchTitle => 'Select Batch';

  @override
  String get treatStepSelectLocationDesc =>
      'Select the farm and batch to register the treatment';

  @override
  String get treatStepSelectBatchDesc =>
      'Select the batch to register the treatment';

  @override
  String get treatStepSelectBatchSubDesc =>
      'Select the batch where the treatment will be applied';

  @override
  String get treatStepNoFarms => 'You have no registered farms';

  @override
  String get treatStepNoFarmsDesc =>
      'You must create a farm before registering a treatment';

  @override
  String get treatStepFarmsError => 'Error loading farms';

  @override
  String get treatStepFarmRequired => 'Farm *';

  @override
  String get treatStepSelectFarm => 'Select a farm';

  @override
  String get treatStepFarmValidation => 'Please select a farm';

  @override
  String get treatStepBatchRequired => 'Batch *';

  @override
  String get treatStepSelectBatch => 'Select a batch';

  @override
  String get treatStepBatchValidation => 'Please select a batch';

  @override
  String get treatStepNoActiveBatches => 'No active batches';

  @override
  String get treatStepNoActiveBatchesDesc =>
      'This farm has no active batches to register treatments';

  @override
  String get treatStepBatchesError => 'Error loading batches';

  @override
  String get treatStepAdditionalTitle => 'Additional Information';

  @override
  String get treatStepAdditionalDesc => 'Supplementary treatment data';

  @override
  String get treatStepAdditionalImportant => 'Important information';

  @override
  String get treatStepAdditionalImportantMsg =>
      'These fields are optional but help with better treatment monitoring.';

  @override
  String get treatStepVeterinarian => 'Responsible veterinarian';

  @override
  String get treatStepVetName => 'Veterinarian name';

  @override
  String get treatStepGeneralObs => 'General observations';

  @override
  String get treatStepGeneralObsHint =>
      'Additional notes, expected evolution, etc.';

  @override
  String get bioStepLocationTitle => 'Where will the inspection take place?';

  @override
  String get bioStepLocationDesc =>
      'Select the shed or leave blank for a general inspection.';

  @override
  String get bioStepInspector => 'Inspector';

  @override
  String get bioStepDate => 'Date';

  @override
  String get bioStepShed => 'Shed';

  @override
  String get bioStepShedOptional =>
      'Optional — if you don\'t select, inspection applies to the entire farm.';

  @override
  String get bioStepLoadingFarm => 'Loading farm…';

  @override
  String get bioStepNoSheds =>
      'No sheds registered. A general inspection will be performed.';

  @override
  String get bioStepWholeFarm => 'Whole farm';

  @override
  String get bioChecklistCritical => 'Critical';

  @override
  String get bioChecklistTapToEvaluate => 'Tap to evaluate';

  @override
  String get bioChecklistCompliant => 'Compliant';

  @override
  String get bioChecklistNonCompliant => 'Non-compliant';

  @override
  String get bioChecklistPartial => 'Partial';

  @override
  String get bioChecklistNotApplicable => 'Not applicable';

  @override
  String get bioChecklistPending => 'Pending';

  @override
  String get bioChecklistSelectResult => 'Select the evaluation result';

  @override
  String get bioChecklistObservation => 'Observation';

  @override
  String get bioChecklistObservationHint => 'Write an observation (optional)';

  @override
  String get bioSummaryTitle => 'Inspection summary';

  @override
  String get bioSummarySubtitle => 'Review the results before saving.';

  @override
  String get bioSummaryCumple => 'Compliant';

  @override
  String get bioSummaryParcial => 'Partial';

  @override
  String get bioSummaryNoCumple => 'Non-compliant';

  @override
  String get bioSummaryCriticalItems => 'Critical items not met';

  @override
  String get bioSummaryPendingNote =>
      'You can save, but the score only reflects what was evaluated.';

  @override
  String get bioSummaryGeneralObs => 'General observations';

  @override
  String get bioSummaryGeneralObsHint =>
      'Describe general findings of the inspection…';

  @override
  String get bioSummaryCorrectiveActions => 'Corrective actions';

  @override
  String get bioSummaryCorrectiveHint => 'Describe the actions to implement…';

  @override
  String get bioSummaryRecommended => 'Recommended';

  @override
  String get bioSummaryNote =>
      'A downloadable report will be generated and the history recorded.';

  @override
  String get bioRatingExcellent => 'Excellent';

  @override
  String get bioRatingVeryGood => 'Very Good';

  @override
  String get bioRatingGood => 'Good';

  @override
  String get bioRatingAcceptable => 'Acceptable';

  @override
  String get bioRatingRegular => 'Regular';

  @override
  String get bioRatingPoor => 'Poor';

  @override
  String get saludDialogCancel => 'Cancel';

  @override
  String get saludDialogDelete => 'Delete';

  @override
  String get saludDialogContinue => 'Continue';

  @override
  String get saludDialogConfirm => 'Confirm';

  @override
  String get saludDialogAccept => 'Accept';

  @override
  String get saludDialogProcessing => 'Processing...';

  @override
  String get saludSwipeClose => 'Close';

  @override
  String get saludSwipeApply => 'Apply';

  @override
  String get saludSwipeDelete => 'Delete';

  @override
  String ventaDeleteMessage(Object product) {
    return 'The sale of $product will be deleted. This action cannot be undone.';
  }

  @override
  String ventaDeleteError(Object message) {
    return 'Error deleting: $message';
  }

  @override
  String ventaDetailsOf(Object product) {
    return 'Details of $product';
  }

  @override
  String ventaLotLoadError(Object error) {
    return 'Error loading batches: $error';
  }

  @override
  String costoDeleteError2(Object error) {
    return 'Error deleting: $error';
  }

  @override
  String costoApproveError(Object error) {
    return 'Error approving: $error';
  }

  @override
  String costoRejectError(Object error) {
    return 'Error rejecting: $error';
  }

  @override
  String saludDeleteRecordMessage(String diagnosis) {
    return 'The record \"$diagnosis\" will be deleted. This action cannot be undone.';
  }

  @override
  String saludActiveTreatments(Object count) {
    return '$count active treatment(s)';
  }

  @override
  String saludCardDays(Object count) {
    return '$count days';
  }

  @override
  String bioEmptyDescription(Object farmName) {
    return 'Start the first biosecurity inspection for $farmName and keep a continuous record of health compliance.';
  }

  @override
  String bioChecklistProgress(String evaluated, Object total) {
    return '$evaluated of $total evaluated';
  }

  @override
  String bioSummaryRisk(Object evaluated, Object level, Object total) {
    return 'Risk $level · $evaluated of $total evaluated';
  }

  @override
  String bioSummaryPendingItems(Object count) {
    return '$count pending items';
  }

  @override
  String vacSummaryExpiredBadge(Object count) {
    return '$count expired';
  }

  @override
  String vacSummaryUpcomingBadge(Object count) {
    return '$count upcoming';
  }

  @override
  String vacCardAppliedDate(Object date) {
    return 'Applied: $date';
  }

  @override
  String vacCardDays(Object count) {
    return '$count days';
  }

  @override
  String vacDetailScheduled(Object date) {
    return 'Scheduled: $date';
  }

  @override
  String vacDetailAppliedOn(Object date) {
    return 'Applied on $date';
  }

  @override
  String vacFormDraftMessage(Object date) {
    return 'A saved draft was found from $date.\nDo you want to restore it?';
  }

  @override
  String treatSavedMinAgo(Object count) {
    return 'Saved $count min ago';
  }

  @override
  String treatSavedAtTime(Object time) {
    return 'Saved at $time';
  }

  @override
  String get monthMayFull => 'May';

  @override
  String get commonDiscard2 => 'Discard';

  @override
  String get ventaClientBuyerInfo => 'Enter the buyer\'s information';

  @override
  String get ventaClientNameLabel => 'Full name';

  @override
  String get ventaClientPhoneHint => '9 digits';

  @override
  String get ventaClientDniLength => 'DNI must have 8 digits';

  @override
  String get ventaClientRucLength => 'RUC must have 11 digits';

  @override
  String get ventaClientDocInvalid => 'Invalid number';

  @override
  String get ventaClientPhoneLength => 'Phone must have 9 digits';

  @override
  String get ventaClientForeignCard => 'Foreign ID Card';

  @override
  String get ventaSelectLocationDesc =>
      'Select the farm and batch to register the sale';

  @override
  String get ventaNoFarmsDesc =>
      'You must create a farm before registering a sale';

  @override
  String get ventaErrorLoadingFarms => 'Error loading farms';

  @override
  String get ventaSelectFarmError => 'Please select a farm';

  @override
  String get ventaLoteLabelStar => 'Batch *';

  @override
  String get ventaSelectLoteHint => 'Select a batch';

  @override
  String get ventaSelectLoteError => 'Please select a batch';

  @override
  String get ventaNoActiveLotes => 'No active batches';

  @override
  String get ventaNoActiveLotesDesc =>
      'This farm has no active batches for registering sales';

  @override
  String get ventaErrorLoadingLotes => 'Error loading batches';

  @override
  String get ventaFilterAllTypes => 'All types';

  @override
  String get ventaFilterApply => 'Apply filters';

  @override
  String get ventaFilterClose => 'Close';

  @override
  String get ventaSheetObservations => 'Observations';

  @override
  String get ventaSheetRegistrationDate => 'Registration date';

  @override
  String get ventaDetailLocation => 'Location';

  @override
  String get ventaDetailGranja => 'Farm';

  @override
  String get ventaDetailLote => 'Batch';

  @override
  String get ventaDetailPhone => 'Phone';

  @override
  String get ventaDetailInfoRegistro => 'Registration Information';

  @override
  String get ventaDetailRegisteredBy => 'Registered by';

  @override
  String get ventaDetailRole => 'Role';

  @override
  String get ventaDetailRegistrationDate => 'Registration date';

  @override
  String get ventaDetailError => 'Error';

  @override
  String get ventaDetailMoreOptions => 'More options';

  @override
  String ventaSavedAgo(Object time) {
    return 'Saved $time';
  }

  @override
  String ventaShareDate(Object date) {
    return '📅 Date: $date';
  }

  @override
  String ventaShareType(Object type) {
    return '🏷️ Type: $type';
  }

  @override
  String ventaShareQuantityBirds(Object count) {
    return '📦 Quantity: $count birds';
  }

  @override
  String ventaSharePrice(String currency, String price) {
    return '💵 Price: $currency $price/kg';
  }

  @override
  String ventaShareEggs(Object count) {
    return '📦 Eggs: $count units';
  }

  @override
  String ventaShareQuantityPollinaza(Object count, Object unit) {
    return '📦 Quantity: $count $unit';
  }

  @override
  String ventaShareTotal(Object currency, Object total) {
    return '💰 TOTAL: $currency $total';
  }

  @override
  String ventaShareClient(Object name) {
    return '👤 Client: $name';
  }

  @override
  String ventaShareContact(String contact) {
    return '📞 Contact: $contact';
  }

  @override
  String ventaShareStatus(Object status) {
    return '📍 Status: $status';
  }

  @override
  String get ventaShareAppName => 'Smart Granja Aves Pro';

  @override
  String ventaShareSubject(Object type) {
    return 'Sale - $type';
  }

  @override
  String ventaDateOfLabel(String month, String year, Object day, Object time) {
    return '$month $day, $year • $time';
  }

  @override
  String get bioStepGalpon => 'Shed';

  @override
  String get bioStepGalponHint => 'Select the shed to inspect';

  @override
  String get bioStepNoGalpones => 'No sheds registered in this farm';

  @override
  String get bioStepSelectLocationHint =>
      'Select the location for the biosecurity inspection';

  @override
  String get bioTitle => 'Biosecurity';

  @override
  String get invCodeOptional => 'Code / SKU (optional)';

  @override
  String get invCurrentStock => 'Current stock';

  @override
  String get invDescHerramienta => 'Tools, drinkers, feeders and equipment';

  @override
  String get invDescribeItem => 'Briefly describe the item';

  @override
  String get invInternalCode => 'Internal code or SKU';

  @override
  String get invItemNameRequired => 'Item name *';

  @override
  String get invLocationWarehouse => 'Location / Warehouse';

  @override
  String get invMaximumStock => 'Maximum stock';

  @override
  String get invMinimumStock => 'Minimum stock';

  @override
  String get invNameRequired => 'Name must be at least 2 characters';

  @override
  String get invStepStockTitle => 'Stock and Units';

  @override
  String get invStockAlertDescription =>
      'Set the minimum stock to receive alerts when inventory is low.';

  @override
  String get invSupplierBatchNumber => 'Supplier batch number';

  @override
  String get invSupplierNameLabel => 'Supplier name';

  @override
  String get invWarehouseExample => 'E.g.: Main warehouse, Shed 1';

  @override
  String get ventaAverageWeight => 'Average weight';

  @override
  String get ventaBirdQuantity => 'Bird quantity';

  @override
  String get ventaCarcassYield => 'Carcass yield';

  @override
  String get ventaClient => 'Client';

  @override
  String get ventaClientDocument => 'Document number *';

  @override
  String get ventaClientDocumentInvalid => 'Invalid document';

  @override
  String get ventaClientDocumentRequired => 'Enter the document number';

  @override
  String get ventaDeletedSuccess => 'Sale deleted successfully';

  @override
  String get ventaDocument => 'Document';

  @override
  String get ventaEditTooltip => 'Edit sale';

  @override
  String get ventaNewSaleTitle => 'New Sale';

  @override
  String get ventaNotFound => 'Sale not found';

  @override
  String get ventaPhone => 'Phone';

  @override
  String get ventaProductDescAbono =>
      'Organic fertilizer derived from poultry production';

  @override
  String get ventaProductDescAvesEnPie => 'Sale of live birds by kilogram';

  @override
  String get ventaProductDescAvesFaenadas =>
      'Processed birds ready for consumption';

  @override
  String get ventaProductDescHuevos =>
      'Sale of eggs by classification and dozen';

  @override
  String get ventaProductDescOtro => 'Cull birds or other poultry products';

  @override
  String get ventaProductDetails => 'Product details';

  @override
  String get ventaQuantity => 'Quantity';

  @override
  String get ventaReceiptTitle => 'SALE RECEIPT';

  @override
  String get ventasFilterTitle => 'Filter sales';

  @override
  String get ventaShare => 'Share';

  @override
  String get ventaSlaughterWeight => 'Slaughter weight';

  @override
  String get ventasProductType => 'Product type';

  @override
  String get ventaStepClientTitle => 'Client Information';

  @override
  String get ventaStepNoFarms => 'No farms available';

  @override
  String get ventaStepProductQuestion =>
      'What type of product are you selling?';

  @override
  String get ventaStepSelectLocation => 'Select Farm and Batch';

  @override
  String get ventaStepSelectLocationDesc =>
      'Choose the farm and batch associated with this sale';

  @override
  String get ventaStepSummary => 'Summary';

  @override
  String get ventaSubtotal => 'Subtotal';

  @override
  String get ventaTotalLabel => 'Total';

  @override
  String get ventaUnitPrice => 'Unit price';

  @override
  String get ventasTitle => 'Sales';

  @override
  String get ventasFilter => 'Filter sales';

  @override
  String get ventasEmpty => 'No sales';

  @override
  String get ventasEmptyDescription => 'No registered sales found.';

  @override
  String get ventasNewSale => 'New Sale';

  @override
  String get ventasNoResults => 'No results';

  @override
  String get ventasNoFilterResults => 'No sales found with the applied filters';

  @override
  String get ventasNewSaleTooltip => 'Register new sale';

  @override
  String get bioInspectionSaveButton => 'Save Inspection';

  @override
  String get bioInspectionMinEvaluation => 'Minimum evaluation';

  @override
  String get ventaStepFarmRequired => 'You must select a farm';

  @override
  String get ventaStepSelectFarmFirst => 'Select a farm first';

  @override
  String get ventaStepNoActiveBatches => 'No active batches';

  @override
  String get ventaStepBatchRequired => 'You must select a batch';

  @override
  String get ventaStepSelectBatch => 'Select batch';

  @override
  String get invExpirationDate => 'Expiration date';

  @override
  String get ventaRegister => 'Register Sale';

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
    return 'Vaccination \"$nombre\" will be deleted. This action cannot be undone.';
  }

  @override
  String get commonDraftFound => 'Draft found';

  @override
  String get commonDraftRestoreMessage =>
      'Do you want to restore the previously saved draft?';

  @override
  String get costoTypeManoObra => 'Labor';

  @override
  String get costoUpdatedSuccess => 'Cost updated successfully';

  @override
  String get costoRegisteredSuccess => 'Cost registered successfully';

  @override
  String get batchAvgWeight => 'Average Weight';

  @override
  String get batchFeedConsumption => 'Feed Consumption';

  @override
  String get batchFeedConversionICA => 'Feed Conversion (FCR)';

  @override
  String get batchRegisterWeightTooltip => 'Register batch weight';

  @override
  String get batchOpenRegisterMenu => 'Open register menu';

  @override
  String get shedCapacityTotal => 'Total Capacity';

  @override
  String get shedBirdsDensity => 'Birds/m²';

  @override
  String get shedMinCapacityHint => 'Ex: 1000';

  @override
  String get vacStepVaccine => 'Vaccine';

  @override
  String get vacStepApplication => 'Application';

  @override
  String get vacSelectLote => 'You must select a batch';

  @override
  String get vacErrorScheduling => 'Error scheduling';

  @override
  String get vacScheduledSuccess => 'Vaccination scheduled successfully!';

  @override
  String get vacErrorSchedulingDetail => 'Error scheduling vaccination';

  @override
  String get vacCouldNotLoad => 'Could not load vaccination';

  @override
  String get vacSelectAppDate => 'Select application date';

  @override
  String get vacExitTooltip => 'Exit';

  @override
  String get vacProgramLabel => 'Schedule';

  @override
  String get vacProgramNewTooltip => 'Schedule new vaccination';

  @override
  String get vacAgeWeeksLabel => 'Age (weeks) *';

  @override
  String get vacAgeHint => 'Ex: 4';

  @override
  String get vacDoseHint => 'Ex: 0.5 ml';

  @override
  String get vacRouteLabel => 'Application route *';

  @override
  String get vacRouteHint => 'Ex: Oral, subcutaneous, ocular';

  @override
  String get vacDoseRequired => 'Dose is required';

  @override
  String get treatStepLocation => 'Location';

  @override
  String get treatStepTreatment => 'Treatment';

  @override
  String get treatStepInfo => 'Information';

  @override
  String get treatDraftMessage =>
      'Do you want to restore the previously saved treatment draft?';

  @override
  String get treatFillRequired => 'Please fill in the required fields';

  @override
  String get treatErrorRegistering => 'Error registering treatment';

  @override
  String get treatClosedSuccess => 'Treatment closed';

  @override
  String get treatCloseError => 'Error closing treatment';

  @override
  String get saludDeleteTitle => 'Delete record?';

  @override
  String get saludDeletedSuccess => 'Record deleted';

  @override
  String get saludDeleteError => 'Error deleting record';

  @override
  String get bioExitInProgress =>
      'You have an inspection in progress. If you leave now, you will lose changes.';

  @override
  String get bioSavedSuccess => 'Inspection saved successfully';

  @override
  String get ventaDraftMessage =>
      'Do you want to restore the previously saved sale draft?';

  @override
  String get ventaSelectBatch => 'Select a batch';

  @override
  String ventaQuantityUnit(String unit) {
    return 'Quantity ($unit)';
  }

  @override
  String ventaPricePerUnit(String currency, String unit) {
    return 'Price per $unit ($currency)';
  }

  @override
  String get ventaSaleStatusTitle => 'Sale status';

  @override
  String get ventaAllStatuses => 'All statuses';

  @override
  String get ventaPending => 'Pending';

  @override
  String get ventaConfirmed => 'Confirmed';

  @override
  String get ventaSold => 'Sold';

  @override
  String get ventaSelectFarm => 'Select a farm';

  @override
  String ventaDiscountLabel(String percent) {
    return 'Discount ($percent%)';
  }

  @override
  String get consumoQuantityLabel => 'Quantity';

  @override
  String get consumoTypeLabel => 'Type';

  @override
  String get consumoDateLabel => 'Date';

  @override
  String get consumoPerBirdLabel => 'Consumption per bird';

  @override
  String get consumoAccumulatedLabel => 'Accumulated consumption';

  @override
  String get consumoTotalCostLabel => 'Total cost';

  @override
  String get consumoCostPerBirdLabel => 'Cost per bird';

  @override
  String get consumoObservationsLabel => 'Observations';

  @override
  String get consumoObservationsOptional => 'Observations (optional)';

  @override
  String get consumoRemoveSelection => 'Remove selection';

  @override
  String invQuantityLabel(String unit) {
    return 'Quantity ($unit)';
  }

  @override
  String invNewStockLabel(String unit) {
    return 'New stock ($unit)';
  }

  @override
  String get whatsappMsgSupport =>
      'Hello! I need help with the Smart Granja Aves app. ';

  @override
  String get whatsappMsgBug =>
      'Hello! I want to report a problem in the Smart Granja Aves app: ';

  @override
  String get whatsappMsgSuggest =>
      'Hello! I have a suggestion for the Smart Granja Aves app: ';

  @override
  String get whatsappMsgCollab =>
      'Hello! I\'m interested in a collaboration with Smart Granja Aves. ';

  @override
  String get whatsappMsgPricing =>
      'Hello! I\'d like to know the plans and pricing of Smart Granja Aves. ';

  @override
  String get whatsappMsgGeneral =>
      'Hello! I have a question about Smart Granja Aves. ';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get salesWeightHint => 'E.g.: 250';

  @override
  String get salesPricePerKgHint => 'E.g.: 8.50';

  @override
  String get salesPollinazaQuantityHint => 'E.g.: 10';

  @override
  String get salesPollinazaPriceHint => 'E.g.: 25.00';

  @override
  String get salesPriceGreaterThanZero => 'Price must be greater than 0';

  @override
  String get salesMaxPrice => 'Maximum price is 9,999,999.99';

  @override
  String get salesEnterPricePerKg => 'Enter the price per kg';

  @override
  String get salesEnterPrice => 'Enter the price';

  @override
  String get salesEggInstructions =>
      'Enter the quantity and price per dozen for each classification';

  @override
  String get salesSaleUnit => 'Sale unit';

  @override
  String get salesNoEditPermission =>
      'You don\'t have permission to edit sales on this farm';

  @override
  String get salesNoCreatePermission =>
      'You don\'t have permission to register sales on this farm';

  @override
  String get salesSelectProductFirst => 'Select a product type first';

  @override
  String get salesObservationsLabel => 'Observations';

  @override
  String get salesObservationsHint => 'Additional notes (optional)';

  @override
  String get salesSelectBatchLabel => 'Batch *';

  @override
  String get salesSelectBatchHint => 'Select a batch';

  @override
  String get salesSelectBatchError => 'Select a batch';

  @override
  String salesHuevosName(String name) {
    return 'Eggs $name';
  }

  @override
  String salesSavedAgo(String time) {
    return 'Saved $time';
  }

  @override
  String get ventaListProductType => 'Product type';

  @override
  String get ventaListStatus => 'Status';

  @override
  String get ventaListDocument => 'Document';

  @override
  String get ventaListCarrier => 'Carrier';

  @override
  String get ventaListSubtotal => 'Subtotal';

  @override
  String get clientBuyerInfo => 'Enter the buyer\'s information';

  @override
  String get clientDocType => 'Document type *';

  @override
  String get clientForeignCard => 'Foreigner ID';

  @override
  String get clientDocHint8 => '8 digits';

  @override
  String get clientDocHint11 => '11 digits';

  @override
  String get clientDocHintGeneral => 'Document number';

  @override
  String get clientPhoneHint => '9 digits';

  @override
  String get clientNameRequired => 'Enter the customer\'s name';

  @override
  String get clientNameMinLength => 'Name must be at least 3 characters';

  @override
  String get clientDocRequired => 'Enter the document number';

  @override
  String get clientDniError => 'DNI must have 8 digits';

  @override
  String get clientRucError => 'RUC must have 11 digits';

  @override
  String get clientDocInvalid => 'Invalid number';

  @override
  String get clientPhoneRequired => 'Enter the contact phone number';

  @override
  String get clientPhoneError => 'Phone must have 9 digits';

  @override
  String get selectFarmCreateFirst =>
      'You must create a farm before registering a sale';

  @override
  String get selectFarmLoadError => 'Error loading farms';

  @override
  String get selectFarmHint => 'Select a farm';

  @override
  String get selectFarmNoActiveLots =>
      'This farm has no active batches for registering sales';

  @override
  String get selectLotHint => 'Select a batch';

  @override
  String get selectLotLoadError => 'Error loading batches';

  @override
  String get selectProductHint => 'Select the product type for this sale';

  @override
  String get ventaSheetFaenadoWeight => 'Dressed weight';

  @override
  String get ventaSheetTotalHuevos => 'Total eggs';

  @override
  String get ventaSheetPollinazaQty => 'Quantity';

  @override
  String get ventaSheetUnitPrice => 'Unit price';

  @override
  String get ventaSheetPhone => 'Phone';

  @override
  String ventaDiscountPercent(String percent) {
    return 'Discount ($percent%)';
  }

  @override
  String ventaEmailSubject(String id) {
    return 'Sale - $id';
  }

  @override
  String ventaSaleOf(String product) {
    return 'Sale of $product';
  }

  @override
  String ventaSemantics(String product, String client, String status) {
    return 'Sale of $product, $client, status $status';
  }

  @override
  String ventaDetailsUds(String name, String count) {
    return '$name ($count units)';
  }

  @override
  String get ventaPerDozen => '/dozen';

  @override
  String ventaEggClassifValue(String currency, String cantidad, String precio) {
    return '$cantidad units ($currency $precio/dz)';
  }

  @override
  String costoDeleteConfirm(String name) {
    return 'Are you sure you want to delete the cost \"$name\"?\n\nThis action cannot be undone.';
  }

  @override
  String costoSemantics(String concept, String type, String amount) {
    return 'Cost $concept, type $type, amount $amount';
  }

  @override
  String get costoSheetExpenseType => 'Expense type';

  @override
  String get costoSheetConcept => 'Concept';

  @override
  String get costoSheetProvider => 'Provider';

  @override
  String get costoSheetInvoice => 'Invoice No.';

  @override
  String get costoSheetRejectionReason => 'Rejection reason';

  @override
  String get costoSheetRegistrationDate => 'Registration date';

  @override
  String get costoSheetObservations => 'Observations';

  @override
  String costoAutoFillConcept(String name) {
    return 'Purchase of $name';
  }

  @override
  String get costoSavedMomentAgo => 'Saved a moment ago';

  @override
  String costoSavedMinAgo(String min) {
    return 'Saved $min min ago';
  }

  @override
  String costoSavedAtTime(String time) {
    return 'Saved at $time';
  }

  @override
  String get costoSelectExpenseType => 'Please select an expense type';

  @override
  String get costoSelectFarm => 'Please select a farm';

  @override
  String get costoFieldRequired => 'This field is required';

  @override
  String get costoInvoiceHint => 'F001-00001234';

  @override
  String costoItemCreated(String name) {
    return 'Item \"$name\" created!';
  }

  @override
  String get commonRejected => 'Rejected';

  @override
  String get commonUser => 'User';

  @override
  String get commonSelectDate => 'Select date';

  @override
  String get commonBirds => 'birds';

  @override
  String get commonDays => 'days';

  @override
  String commonSavedAgo(String time) {
    return 'Saved $time';
  }

  @override
  String get commonUserNotAuth => 'User not authenticated';

  @override
  String get commonFarmNotSpecified => 'Farm not specified';

  @override
  String get commonBatchNotSpecified => 'Batch not specified';

  @override
  String commonWeeksAgo(String weeks) {
    return '$weeks week(s) ago';
  }

  @override
  String commonMonthsAgo(String months) {
    return '$months month(s) ago';
  }

  @override
  String commonYearsAgo(String years) {
    return '$years year(s) ago';
  }

  @override
  String commonTodayAtTime(String time) {
    return 'today at $time';
  }

  @override
  String get commonRelativeYesterday => 'yesterday';

  @override
  String commonRelativeDaysAgo(String days) {
    return '$days days ago';
  }

  @override
  String get commonAttention => 'Attention';

  @override
  String get commonCriticalFem => 'Critical';

  @override
  String currencyPrefix(String currency) {
    return '$currency ';
  }

  @override
  String currencyAmount(String currency, String amount) {
    return '$currency $amount';
  }

  @override
  String get galponStatCapacity => 'Total Capacity';

  @override
  String get galponStatTotalBirds => 'Total Birds';

  @override
  String get galponStatOccupancy => 'Occupancy';

  @override
  String get galponBirdDensity => 'Birds/m²';

  @override
  String get galponCapacityHint => 'E.g.: 1000';

  @override
  String get galponAddTag => 'Add tag';

  @override
  String get galponSpecCapacityHint => 'E.g.: 10000';

  @override
  String get galponSpecAreaHint => 'E.g.: 500';

  @override
  String get galponSpecAreaUnit => 'm²';

  @override
  String get galponSpecDrinkersHint => 'E.g.: 50';

  @override
  String get galponSpecFeedersHint => 'E.g.: 50';

  @override
  String get galponSpecNestsHint => 'E.g.: 100';

  @override
  String get galponEnvTempMinHint => 'E.g.: 18';

  @override
  String get galponEnvTempMaxHint => 'E.g.: 28';

  @override
  String get galponEnvHumMinHint => 'E.g.: 50';

  @override
  String get galponEnvHumMaxHint => 'E.g.: 70';

  @override
  String get galponEnvVentMinHint => 'E.g.: 100';

  @override
  String get galponEnvVentMaxHint => 'E.g.: 300';

  @override
  String get galponEnvVentUnit => 'm³/h';

  @override
  String get galponNA => 'N/A';

  @override
  String get galponAvicola => 'Poultry House';

  @override
  String get granjaAvicola => 'Poultry Farm';

  @override
  String get granjaNoAddress => 'No address';

  @override
  String get granjaPppm => 'ppm';

  @override
  String get granjaRucHint => 'J-12345678-9';

  @override
  String get granjaEngorde => 'Broiler';

  @override
  String get granjaPonedora => 'Layer';

  @override
  String get granjaReproductor => 'Breeder';

  @override
  String get granjaAve => 'Bird';

  @override
  String get granjaActive => 'Active';

  @override
  String get granjaInactive => 'Inactive';

  @override
  String get granjaMaintenance => 'Maintenance';

  @override
  String get granjaStatusOperating => 'Operating normally';

  @override
  String get granjaStatusSuspended => 'Operations suspended';

  @override
  String get granjaStatusMaintenance => 'Under maintenance';

  @override
  String get granjaMonthAbbr1 => 'Jan';

  @override
  String get granjaMonthAbbr2 => 'Feb';

  @override
  String get granjaMonthAbbr3 => 'Mar';

  @override
  String get granjaMonthAbbr4 => 'Apr';

  @override
  String get granjaMonthAbbr5 => 'May';

  @override
  String get granjaMonthAbbr6 => 'Jun';

  @override
  String get granjaMonthAbbr7 => 'Jul';

  @override
  String get granjaMonthAbbr8 => 'Aug';

  @override
  String get granjaMonthAbbr9 => 'Sep';

  @override
  String get granjaMonthAbbr10 => 'Oct';

  @override
  String get granjaMonthAbbr11 => 'Nov';

  @override
  String get granjaMonthAbbr12 => 'Dec';

  @override
  String invNewStock(String unit) {
    return 'New stock ($unit)';
  }

  @override
  String get invAdjustReasonHint => 'E.g.: Physical inventory';

  @override
  String get invErrorEntryRegister => 'Error registering inventory entry';

  @override
  String get invErrorExitRegister => 'Error registering inventory exit';

  @override
  String invExpiresInDays(String days) {
    return 'Expires in $days days';
  }

  @override
  String invStockLowAlert(String min, String unit) {
    return 'Low stock (minimum: $min $unit)';
  }

  @override
  String invStockMinLabel(String min, String unit) {
    return 'Minimum: $min $unit';
  }

  @override
  String invRelativeTodayAt(String time) {
    return 'today at $time';
  }

  @override
  String get invRelativeYesterday => 'yesterday';

  @override
  String invRelativeDaysAgo(String days) {
    return '$days days ago';
  }

  @override
  String get invRelativeNow => 'right now';

  @override
  String invRelativeSecsAgo(String secs) {
    return '${secs}s ago';
  }

  @override
  String invRelativeMinsAgo(String mins) {
    return '${mins}m ago';
  }

  @override
  String invRelativeHoursAgo(String hours) {
    return '${hours}h ago';
  }

  @override
  String invItemCreated(String name) {
    return 'Item \"$name\" created!';
  }

  @override
  String get invSkuHelper =>
      'The code/SKU will help you quickly identify the item in your inventory.';

  @override
  String get invDetailsOptional => 'Optional information for better control';

  @override
  String get invTypeSelect => 'Select the inventory item category';

  @override
  String get invTypeVaccines => 'Vaccines and immunization products';

  @override
  String get invTypeDisinfectants => 'Cleaning and disinfection products';

  @override
  String get invUnitApplication => 'Application';

  @override
  String get invUnitVolume => 'Volume';

  @override
  String loteDaysAge(String age) {
    return '$age days';
  }

  @override
  String loteWeeksAndDays(String weeks, String days) {
    return '$weeks weeks ($days days)';
  }

  @override
  String loteBirdsCount(String count) {
    return '$count birds';
  }

  @override
  String loteUnitsCount(String count) {
    return '$count units';
  }

  @override
  String loteCycleDay(String day, String remaining) {
    return 'Day $day of 45 ($remaining days remaining)';
  }

  @override
  String get loteCycleCompleted => 'Day 45 - Cycle completed';

  @override
  String loteCycleExtra(String day, String extra) {
    return 'Day $day ($extra extra days)';
  }

  @override
  String get loteFeedUnit => 'kg feed';

  @override
  String get loteFeedRef => '1.6 - 1.8';

  @override
  String loteCloseOverdue(String days) {
    return 'Close overdue by $days days';
  }

  @override
  String loteCloseUpcoming(String days) {
    return 'Close upcoming in $days days';
  }

  @override
  String loteICAHigh(String value) {
    return 'High feed conversion ratio ($value)';
  }

  @override
  String loteDaysCount(String days) {
    return '$days days';
  }

  @override
  String get loteRazaLinea => 'Breed/Line';

  @override
  String get loteDaysRemaining => 'Days Remaining';

  @override
  String get loteBirdsLabel => 'Birds';

  @override
  String get loteEnterValidQty => 'Enter a valid quantity greater than 0';

  @override
  String get loteSelectNewState => 'Select new status:';

  @override
  String loteConfirmStateChange(String state) {
    return 'Confirm change to $state?';
  }

  @override
  String get loteStateWarning =>
      'This status is permanent and cannot be reversed. The batch data will be archived.';

  @override
  String get loteLocationCode => 'Code';

  @override
  String get loteLocationMaxCapacity => 'Maximum Capacity';

  @override
  String get loteLocationCurrentOccupancy => 'Current Occupancy';

  @override
  String get loteLocationCurrentBirds => 'Current Birds';

  @override
  String loteLocationBirdsCount(String count) {
    return '$count birds';
  }

  @override
  String get loteLocationOccupancyLabel => 'Occupancy';

  @override
  String loteLocationOccupancyPercent(String percent) {
    return '$percent%';
  }

  @override
  String get loteLocationBirdType => 'Bird Type in House';

  @override
  String loteLocationMaxCapacityInfo(String count) {
    return 'Maximum capacity: $count birds';
  }

  @override
  String loteLocationAreaInfo(String area) {
    return 'Area: $area m²';
  }

  @override
  String get loteLocationErrorLoading => 'Error loading houses';

  @override
  String get loteLocationSharedSpace =>
      'The new batch will share the available space.';

  @override
  String get loteTypeLayer => 'Laying hens for egg production';

  @override
  String get loteTypeBroiler => 'Broiler chickens for meat production';

  @override
  String get loteTypeHeavyBreeder => 'Heavy breeder birds for offspring';

  @override
  String get loteTypeLightBreeder => 'Light breeder birds for offspring';

  @override
  String get loteTypeTurkey => 'Turkeys for meat production';

  @override
  String get loteTypeDuck => 'Ducks for meat production';

  @override
  String loteResumenAge(String age) {
    return '$age days';
  }

  @override
  String loteResumenWeeks(String weeks, String days) {
    return '($weeks wk, $days days)';
  }

  @override
  String loteConsumoStockInsufficient(String stock) {
    return 'Insufficient stock. Available: $stock kg';
  }

  @override
  String loteConsumoStockUsage(String percent) {
    return 'You will use $percent% of the available stock';
  }

  @override
  String loteConsumoRecommended(String days, String amount) {
    return 'Recommended for $days days: $amount';
  }

  @override
  String get loteConsumoImportantInfo => 'Important information';

  @override
  String get loteConsumoAutoCalc =>
      'Costs and metrics are calculated automatically when registering consumption.';

  @override
  String get lotePesoEggHint =>
      'Describe egg quality, shell color, size, observed anomalies...';

  @override
  String get lotePesoBirdsWeighed => 'Birds weighed';

  @override
  String lotePesoGainPerDay(String value) {
    return '$value g/day';
  }

  @override
  String get lotePesoCV => 'Coefficient of variation';

  @override
  String get loteConsumoErrorLoading => 'Error loading feed';

  @override
  String get loteLoteDetailEngorde => 'Birds raised for meat production';

  @override
  String get loteLoteDetailPonedora => 'Birds raised for egg production';

  @override
  String get loteLoteDetailRepPesada => 'Heavy line breeder birds';

  @override
  String get loteLoteDetailRepLiviana => 'Light line breeder birds';

  @override
  String get loteAreaUnit => 'm²';

  @override
  String get saludDose => 'Dose';

  @override
  String saludDurationDays(String days) {
    return '$days days';
  }

  @override
  String get saludRegistrationInfo => 'Registration Information';

  @override
  String get saludLastUpdate => 'Last update';

  @override
  String saludDeleteDetail(String name) {
    return 'The record for \"$name\" will be deleted. This action cannot be undone.';
  }

  @override
  String get saludUpcoming => 'Upcoming';

  @override
  String get saludLocationSection => 'Location';

  @override
  String get saludFarm => 'Farm';

  @override
  String get saludBatch => 'Batch';

  @override
  String get saludVaccineInfoSection => 'Vaccine Information';

  @override
  String get saludVaccine => 'Vaccine';

  @override
  String get saludApplicationAge => 'Application Age';

  @override
  String get saludRoute => 'Route';

  @override
  String get saludLaboratory => 'Laboratory';

  @override
  String get saludVaccineBatch => 'Vaccine Batch';

  @override
  String get saludResponsible => 'Responsible';

  @override
  String get saludNextApplication => 'Next Application';

  @override
  String get saludProgramDescription =>
      'Schedule vaccines to maintain batch health';

  @override
  String get saludVacDeleted => 'Vaccination deleted successfully';

  @override
  String get saludRegisterAppDetails => 'Register the application details';

  @override
  String get saludCurrentUser => 'Current User';

  @override
  String get saludVacTableVaccine => 'Vaccine';

  @override
  String get saludVacTableAppDate => 'Application date';

  @override
  String get saludVacTableAppAge => 'Application age';

  @override
  String get saludVacTableNextApp => 'Next application';

  @override
  String get saludTreatStepDescLocation => 'Select farm and batch';

  @override
  String get saludTreatStepDescDiagnosis => 'Diagnosis and symptom information';

  @override
  String get saludTreatStepDescTreatment => 'Treatment and medication details';

  @override
  String get saludTreatStepDescInfo =>
      'Veterinarian and additional observations';

  @override
  String get saludTreatSavedMoment => 'Saved a moment ago';

  @override
  String saludTreatSavedMin(String min) {
    return 'Saved $min min ago';
  }

  @override
  String saludTreatSavedAt(String time) {
    return 'Saved at $time';
  }

  @override
  String get saludTreatSelectFarmBatch => 'Please select a farm and a batch';

  @override
  String get saludTreatDurationRange =>
      'Duration must be between 1 and 365 days';

  @override
  String get saludTreatFutureDate => 'The date cannot be in the future';

  @override
  String get saludVacInventoryWarning =>
      'Vaccination registered, but there was an error deducting inventory';

  @override
  String get saludBioErrorLoading => 'Error loading data';

  @override
  String get saludBioConfirmSave =>
      'The inspection will be saved and the corresponding report will be generated.';

  @override
  String saludBioErrorSaving(String error) {
    return 'Error saving: $error';
  }

  @override
  String get saludBioTitleGeneral => 'General biosecurity inspection';

  @override
  String get saludBioTitleByGalpon => 'Biosecurity inspection by house';

  @override
  String get saludBioNotReviewed => 'Not yet reviewed.';

  @override
  String get saludBioCompliant => 'Correct compliance.';

  @override
  String get saludBioNonCompliant => 'Non-compliance detected.';

  @override
  String get saludBioWithObservations => 'Compliant with observations.';

  @override
  String get saludBioNotApplicable => 'Not applicable for evaluation.';

  @override
  String get saludSwipeHint => 'Swipe for quick actions';

  @override
  String get saludCatalogMandatoryNotification => 'Mandatory notification';

  @override
  String get saludCatalogCategory => 'Category';

  @override
  String get saludCatalogNoResults => 'No diseases found';

  @override
  String get saludCatalogEmpty => 'Empty catalog';

  @override
  String get saludCatalogSearchHint => 'Try other search terms or filters';

  @override
  String get saludCatalogGeneralInfo => 'General Information';

  @override
  String get saludCatalogTransmission => 'Transmission and Diagnosis';

  @override
  String get saludCatalogMainSymptoms => 'Main Symptoms';

  @override
  String get saludCatalogPostmortem => 'Post-mortem Lesions';

  @override
  String get saludCatalogTreatPrevention => 'Treatment and Prevention';

  @override
  String get saludCatalogPreventableVax => 'Preventable by vaccination';

  @override
  String get saludCatalogCausativeAgent => 'Causative Agent';

  @override
  String get saludCatalogNotification => 'Notification';

  @override
  String get saludCatalogTransmissionLabel => 'Transmission';

  @override
  String get saludCatalogDiagnosisLabel => 'Diagnosis';

  @override
  String saludVacDraftMessage(String date) {
    return 'A saved draft from $date was found.\nWould you like to restore it?';
  }

  @override
  String get saludVacProgramTitle => 'Schedule Vaccination';

  @override
  String get whatsappHelp =>
      'Hello! I need help with the Smart Granja Aves app. ';

  @override
  String get whatsappReportBug =>
      'Hello! I want to report a problem in the Smart Granja Aves app: ';

  @override
  String get whatsappSuggestion =>
      'Hello! I have a suggestion for the Smart Granja Aves app: ';

  @override
  String get whatsappCollaboration =>
      'Hello! I\'m interested in collaborating with Smart Granja Aves. ';

  @override
  String get whatsappPricing =>
      'Hello! I\'d like to learn about Smart Granja Aves plans and pricing. ';

  @override
  String get whatsappQuery =>
      'Hello! I have a question about Smart Granja Aves. ';

  @override
  String get homeAppTitle => 'Smart Granja Aves';

  @override
  String get authProBadge => 'PRO';

  @override
  String get perfilLanguage => 'English';

  @override
  String get perfilSyncing => 'Syncing';

  @override
  String get perfilAppTitle => 'Smart Granja Aves Pro';

  @override
  String reportsPeriod(String period) {
    return 'Period: $period';
  }

  @override
  String get reportsDateTo => 'to';

  @override
  String get reportsDateOf => 'of';

  @override
  String reportsFileName(String id) {
    return 'Report_$id.pdf';
  }

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusSold => 'Sold';

  @override
  String get statusApproved => 'Approved';

  @override
  String get treatStepSelectFarmLotDesc => 'Select farm and batch';

  @override
  String get treatStepDiagnosisInfoDesc => 'Diagnosis and symptoms information';

  @override
  String get treatStepTreatmentDetailsDesc =>
      'Treatment and medication details';

  @override
  String get treatStepVetObsDesc => 'Veterinarian and additional observations';

  @override
  String saludDeleteConfirmMsg(String name) {
    return 'The record for \"$name\" will be deleted. This action cannot be undone.';
  }

  @override
  String commonDurationDays(String count) {
    return '$count days';
  }

  @override
  String commonWeeks(String count) {
    return '$count weeks';
  }

  @override
  String get vacLocationTitle => 'Location';

  @override
  String get vacInfoTitle => 'Vaccine Information';

  @override
  String get vacVaccineLabel => 'Vaccine';

  @override
  String get vacDoseLabel => 'Dose';

  @override
  String get vacRouteShort => 'Route';

  @override
  String get vacBatchVaccineLabel => 'Vaccine Batch';

  @override
  String get vacNextApplicationLabel => 'Next Application';

  @override
  String get vacScheduleTitle => 'Schedule Vaccination';

  @override
  String vacDraftFoundMsg(String date) {
    return 'A saved draft from $date was found.\nDo you want to restore it?';
  }

  @override
  String vacDaysAgo(String days) {
    return '$days days ago';
  }

  @override
  String get vacDeletedSuccess => 'Vaccination deleted successfully';

  @override
  String get vacApplyDetails => 'Register the application details';

  @override
  String get vacFilterAll => 'All';

  @override
  String get saludInspectionSaveMsg =>
      'The inspection will be saved and the corresponding report will be generated.';

  @override
  String get saludInspGeneralDesc => 'General biosecurity inspection';

  @override
  String get saludInspShedDesc => 'Shed biosecurity inspection';

  @override
  String get saludCheckNotReviewed => 'Not yet reviewed.';

  @override
  String get saludCheckNonCompliance => 'Non-compliance detected.';

  @override
  String get commonSwipeActions => 'Swipe for quick actions';

  @override
  String get commonGalponAvicola => 'Poultry Shed';

  @override
  String get commonCode => 'Code';

  @override
  String get commonMaxCapacity => 'Maximum Capacity';

  @override
  String get commonImportantInfo => 'Important information';

  @override
  String get commonCostsAutoCalculated =>
      'Costs and metrics are calculated automatically based on the entered data.';

  @override
  String get loteRazaLineaLabel => 'Breed/Line';

  @override
  String get loteDiasRestantes => 'Days Remaining';

  @override
  String loteGdpFormat(String value) {
    return '$value g/day';
  }

  @override
  String get loteCoefVariacion => 'Coefficient of variation';

  @override
  String get loteShedActiveConflict =>
      'This shed already has an active batch. Only one active batch per shed is allowed.';

  @override
  String get commonOptimal => 'Optimal';

  @override
  String get commonCritical => 'Critical';

  @override
  String loteCierreVencido(String days) {
    return 'Closure overdue by $days days';
  }

  @override
  String loteCierreProximo(String days) {
    return 'Closure due in $days days';
  }

  @override
  String loteEdadDias(String days) {
    return '$days days';
  }

  @override
  String loteEdadSemanasDias(String semanas, String dias) {
    return '$semanas weeks ($dias days)';
  }

  @override
  String loteEdadFormat(String edad, String dias) {
    return '$edad ($dias days)';
  }

  @override
  String invStockBajo(String min, String unit) {
    return 'Low stock (minimum: $min $unit)';
  }

  @override
  String invVenceEn(String days) {
    return 'Expires in $days days';
  }

  @override
  String get invSkuHelp =>
      'The code/SKU will help you quickly identify the item in your inventory.';

  @override
  String get invSelectCategory => 'Select the category of the inventory item';

  @override
  String get invCatVaccines => 'Vaccines and immunization products';

  @override
  String get invCatDisinfection => 'Cleaning and disinfection products';

  @override
  String get galponTimeToday => 'Today';

  @override
  String get galponTimeYesterday => 'Yesterday';

  @override
  String galponTimeDaysAgo(String days) {
    return '$days days ago';
  }

  @override
  String loteEdadRegistro(String days) {
    return 'Age: $days days';
  }

  @override
  String get perfilLanguageSpanish => 'Spanish';

  @override
  String vacScheduledFormat(String date) {
    return 'Scheduled: $date';
  }

  @override
  String vacAppliedOnFormat(String date) {
    return 'Applied on $date';
  }

  @override
  String get vacAppliedDate => 'Application date';

  @override
  String get vacCurrentUser => 'Current User';

  @override
  String get vacEmptyDesc => 'Schedule vaccines to maintain batch health';

  @override
  String get commonNoFarmSelected => 'No farm selected';

  @override
  String commonErrorDeleting(String error) {
    return 'Error deleting: $error';
  }

  @override
  String commonErrorApplying(String error) {
    return 'Error applying vaccine: $error';
  }

  @override
  String get vacRegisteredInventoryError =>
      'Vaccination registered, but there was an error deducting inventory';

  @override
  String get commonTimeRightNow => 'right now';

  @override
  String commonTimeSecondsAgo(String count) {
    return '${count}s ago';
  }

  @override
  String commonTimeMinutesAgo(String count) {
    return '${count}m ago';
  }

  @override
  String commonTimeHoursAgo(String count) {
    return '${count}h ago';
  }

  @override
  String get commonErrorLoadingData => 'Error loading data';

  @override
  String get saludCheckCompliance => 'Compliance correct.';

  @override
  String get saludCheckPartial => 'Compliant with observations.';

  @override
  String get saludCheckNA => 'Not applicable.';

  @override
  String get loteProgressCycle => 'Cycle progress';

  @override
  String loteDayOfCycle(String day, String remaining) {
    return 'Day $day of 45 ($remaining days remaining)';
  }

  @override
  String loteExtraDays(String day, String extra) {
    return 'Day $day ($extra extra days)';
  }

  @override
  String get loteAttention => 'Attention';

  @override
  String get loteKeyIndicators => 'Key indicators';

  @override
  String loteMortalityHigh(String rate, String expected) {
    return 'High mortality ($rate% > $expected% expected)';
  }

  @override
  String loteWeightBelow(String percent) {
    return 'Weight below target ($percent% less)';
  }

  @override
  String get loteTrendNormal => 'Normal';

  @override
  String get loteTrendAlto => 'High';

  @override
  String get loteTrendExcellent => 'Excellent';

  @override
  String get loteTrendElevated => 'Elevated';

  @override
  String get loteTrendAcceptable => 'Acceptable';

  @override
  String get loteTrendBajo => 'Low';

  @override
  String get loteTrendBuena => 'Good';

  @override
  String get loteTrendRegular => 'Regular';

  @override
  String get loteTrendBaja => 'Low';

  @override
  String get loteRegister => 'Register';

  @override
  String get loteDashSummary => 'Summary';

  @override
  String get batchInitialFlock => 'Initial flock';

  @override
  String get loteCierreEstimado => 'Estimated Closure';

  @override
  String get loteNotRegistered => 'Not registered';

  @override
  String get loteNotRecorded => 'Not recorded';

  @override
  String get birdDescPolloEngorde => 'Birds raised for meat production';

  @override
  String get birdDescGallinaPonedora => 'Birds raised for egg production';

  @override
  String get birdDescRepPesada => 'Heavy line breeder birds';

  @override
  String get birdDescRepLiviana => 'Light line breeder birds';

  @override
  String get birdDescPavo => 'Turkeys for meat';

  @override
  String get birdDescCodorniz => 'Quail for eggs or meat';

  @override
  String get birdDescPato => 'Ducks for meat';

  @override
  String get birdDescOtro => 'Other bird type';

  @override
  String get birdDescFormPolloEngorde => 'Broiler chickens for meat production';

  @override
  String get birdDescFormGallinaPonedora => 'Laying hens for egg production';

  @override
  String get birdDescFormRepPesada => 'Heavy breeder birds for offspring';

  @override
  String get birdDescFormRepLiviana => 'Light breeder birds for offspring';

  @override
  String get birdDescFormPavo => 'Turkeys for meat production';

  @override
  String get birdDescFormCodorniz => 'Quail for eggs or meat';

  @override
  String get birdDescFormPato => 'Ducks for meat production';

  @override
  String get birdDescFormOtro => 'Other bird type';

  @override
  String loteShedActiveWarning(String code) {
    return 'This shed already has an active batch ($code). The new batch will share the available space.';
  }

  @override
  String get ubicacionCurrentOccupation => 'Current Occupation';

  @override
  String get ubicacionCurrentBirds => 'Current Birds';

  @override
  String get ubicacionAvailableCapacity => 'Available Capacity';

  @override
  String get ubicacionOccupation => 'Occupation';

  @override
  String get ubicacionBirdTypeInShed => 'Bird Type in Shed';

  @override
  String ubicacionBirdsCount(String count) {
    return '$count birds';
  }

  @override
  String ubicacionCapacityInfo(String capacity) {
    return 'Max capacity: $capacity birds';
  }

  @override
  String ubicacionAreaInfo(String area) {
    return 'Area: $area m²';
  }

  @override
  String get commonErrorLoadingShed => 'Error loading sheds';

  @override
  String get consumoSummaryTitle => 'Consumption Summary';

  @override
  String get consumoSummarySubtitle => 'Review the data and add observations';

  @override
  String get consumoObsHint =>
      'E.g.: Birds with good appetite, feed well received...';

  @override
  String get invBasicInfoSubtitle => 'Enter the main item data';

  @override
  String get invOptionalDetails => 'Optional information for better control';

  @override
  String get invOptionalDetailsInfo =>
      'These data are optional but help with better control and inventory traceability.';

  @override
  String get invCatInsumo =>
      'Bedding materials, disinfectants, and other supplies';

  @override
  String get invImageReady => 'Ready';

  @override
  String get invCanAddPhoto => 'You can add a product photo';

  @override
  String loteFormatDays(String count) {
    return '$count days';
  }

  @override
  String loteFormatWeek(String count) {
    return '$count week';
  }

  @override
  String loteFormatWeeks(String count) {
    return '$count weeks';
  }

  @override
  String loteFormatMonth(String count) {
    return '$count month';
  }

  @override
  String loteFormatMonths(String count) {
    return '$count months';
  }

  @override
  String loteFormatWeeksShort(String count) {
    return '$count wk';
  }

  @override
  String get loteTrendOptimal => 'Optimal';

  @override
  String get loteTrendCritical => 'Critical';

  @override
  String get loteTrendCritica => 'Critical';

  @override
  String get loteFeedKg => 'kg feed';

  @override
  String loteFormatMonthAndWeeksShort(String months, String weeks) {
    return '$months month and $weeks wk';
  }

  @override
  String loteFormatMonthsAndWeeksShort(String months, String weeks) {
    return '$months months and $weeks wk';
  }

  @override
  String loteResumenWeeksDays(String weeks, String days) {
    return ' ($weeks wk, $days days)';
  }

  @override
  String loteResumenWeeksParens(String weeks) {
    return ' ($weeks weeks)';
  }

  @override
  String get invCatLimpieza => 'Cleaning and disinfection products';

  @override
  String get invHintExample => 'E.g.: Starter Concentrate';

  @override
  String get commonArea => 'Area';

  @override
  String invStockInfoFormat(String stock, String unit) {
    return 'Current stock: $stock $unit';
  }

  @override
  String get invMotiveHint => 'E.g.: Physical inventory';

  @override
  String ubicacionShedDropdown(String code, String capacity) {
    return '$code - Capacity: $capacity birds';
  }

  @override
  String invDraftFoundMessage(String date) {
    return 'A saved draft from $date was found.\nWould you like to restore it?';
  }

  @override
  String get catalogDiseaseNotifRequired => 'Mandatory notification';

  @override
  String get catalogDiseaseVaccinable => 'Vaccinable';

  @override
  String get commonCategory => 'Category';

  @override
  String get catalogDiseaseSymptoms => 'Symptoms';

  @override
  String get catalogDiseaseSeverity => 'Severity';

  @override
  String get catalogDiseaseNotFound => 'No diseases found';

  @override
  String get catalogDiseaseEmpty => 'Empty catalog';

  @override
  String get catalogDiseaseSearchHint => 'Try other search terms or filters';

  @override
  String get catalogDiseaseNone => 'No diseases registered';

  @override
  String get catalogDiseaseInfoGeneral => 'General Information';

  @override
  String get catalogDiseaseTransDiag => 'Transmission and Diagnosis';

  @override
  String get catalogDiseaseMainSymptoms => 'Main Symptoms';

  @override
  String get catalogDiseasePostmortem => 'Post-mortem Lesions';

  @override
  String get catalogDiseaseTreatPrev => 'Treatment and Prevention';

  @override
  String get catalogDiseaseNotifOblig => 'Mandatory Notification';

  @override
  String get catalogDiseaseVaccinePrevent => 'Preventable by vaccination';

  @override
  String get catalogDiseaseCausalAgent => 'Causal Agent';

  @override
  String get catalogDiseaseContagious => 'Contagious';

  @override
  String get catalogDiseaseNotification => 'Notification';

  @override
  String get catalogDiseaseVaccineAvail => 'Vaccine Available';

  @override
  String get catalogDiseaseTransmission => 'Transmission';

  @override
  String get catalogDiseaseDiagnosis => 'Diagnosis';

  @override
  String get catalogDiseaseViewDetails => 'View Details';

  @override
  String get catalogDiseaseConsultVet => 'Consult your veterinarian';

  @override
  String get batchSelectNewStatusLabel => 'Select new status:';

  @override
  String batchConfirmStatusChange(String status) {
    return 'Confirm change to $status?';
  }

  @override
  String get batchPermanentStatusWarning =>
      'This status is permanent and cannot be reversed. The batch will not be able to change to any other status after this action.';

  @override
  String get batchPermanentStatus => 'Permanent status';

  @override
  String get batchTypePoultryDesc => 'Birds raised for meat production';

  @override
  String get batchTypeLayersDesc => 'Birds raised for egg production';

  @override
  String get batchTypeHeavyBreedersDesc => 'Heavy-line breeder birds';

  @override
  String get batchTypeLightBreedersDesc => 'Light-line breeder birds';

  @override
  String get batchTypeTurkeysDesc => 'Turkeys for meat';

  @override
  String get batchTypeQuailDesc => 'Quail for eggs or meat';

  @override
  String get batchTypeDucksDesc => 'Ducks for meat';

  @override
  String get batchTypeOtherDesc => 'Other type of bird';

  @override
  String get batchNotRecorded => 'Not recorded';

  @override
  String get commonBirdsUnit => 'birds';

  @override
  String batchAgeDaysValue(String count) {
    return '$count days';
  }

  @override
  String batchAgeWeeksDaysValue(String weeks, String days) {
    return '$weeks weeks ($days days)';
  }

  @override
  String get costExpenseType => 'Expense type';

  @override
  String get costProvider => 'Supplier';

  @override
  String get costRejectionReason => 'Rejection reason';

  @override
  String get weightBirdsWeighed => 'Birds weighed';

  @override
  String get weightTotal => 'Total weight';

  @override
  String get weightDailyGain => 'ADG (Average daily gain)';

  @override
  String get weightGramsPerDay => 'g/day';

  @override
  String feedExceedsStock(String stock) {
    return 'The quantity exceeds available stock ($stock kg)';
  }

  @override
  String feedStockPercentUsage(String percent) {
    return 'You will use $percent% of available stock';
  }

  @override
  String feedRecommendedForDays(String days, String type) {
    return 'Recommended for $days days: $type';
  }

  @override
  String get feedConsumptionDate => 'Consumption date';

  @override
  String get feedObsTitle => 'Observations';

  @override
  String get feedObsOptionalHint => 'Optional: Add additional notes';

  @override
  String get feedObsDescribeHint =>
      'Describe supply conditions, bird behavior, feed quality, etc.';

  @override
  String get feedObsHelpText =>
      'Observations help document important details of feed supply and can be useful for future analysis.';

  @override
  String get ventaSelectBatchHint => 'Select a batch';

  @override
  String get ventaBatchLoadError => 'Error loading batches';

  @override
  String get saludRegisteredBy => 'Registered by';

  @override
  String get saludCloseTreatment => 'Close Treatment';

  @override
  String get saludResultOptional => 'Result (Optional)';

  @override
  String get saludMonthNames =>
      'January,February,March,April,May,June,July,August,September,October,November,December';

  @override
  String get saludDateConnector => 'of';

  @override
  String get treatDurationValidation =>
      'Duration must be between 1 and 365 days';

  @override
  String get commonDateCannotBeFuture => 'Date cannot be in the future';

  @override
  String get treatNewTreatment => 'New Treatment';

  @override
  String get commonSaveAction => 'Save';

  @override
  String get costRegisteredInventoryError =>
      'Cost registered, but there was an error updating inventory';

  @override
  String invStockActualLabel(String stock, String unit) {
    return 'Current: $stock $unit';
  }

  @override
  String invStockMinimoLabel(String stock, String unit) {
    return 'Minimum: $stock $unit';
  }

  @override
  String get invEntryError => 'Error registering inventory entry';

  @override
  String get invExitError => 'Error registering inventory exit';

  @override
  String get feedLoadingItems => 'Loading feed items...';

  @override
  String get feedLoadError => 'Error loading feed items';

  @override
  String get photoNoPhotosAdded => 'No photos added';

  @override
  String get photoMax5Hint => 'You can add up to 5 photos';

  @override
  String get farmPoultryFarm => 'Poultry Farm';

  @override
  String get farmNoAddress => 'No address';

  @override
  String get shedAddTagHint => 'Add tag';

  @override
  String get shedCapacityHintExample => 'E.g.: 1000';

  @override
  String get prodObsHint =>
      'Describe egg quality, shell color, environmental conditions, bird behavior, etc.';

  @override
  String get commonAge => 'Age';

  @override
  String get batchQuantityValidation => 'Enter a valid quantity greater than 0';

  @override
  String invStockBajoMinimo(String min, String unit) {
    return 'Low stock (minimum: $min $unit)';
  }

  @override
  String reportsPeriodLabel(String period) {
    return 'Period: $period';
  }

  @override
  String reportsPeriodSameMonth(
    String dayStart,
    String dayEnd,
    String month,
    String year,
  ) {
    return '$dayStart to $dayEnd of $month $year';
  }

  @override
  String reportsPeriodSameYear(
    String dayStart,
    String monthStart,
    String dayEnd,
    String monthEnd,
    String year,
  ) {
    return '$dayStart of $monthStart to $dayEnd of $monthEnd, $year';
  }

  @override
  String reportsPeriodDateRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String get batchShareCode => 'Code';

  @override
  String get batchShareType => 'Type';

  @override
  String get batchShareBreed => 'Breed';

  @override
  String get batchShareStatus => 'Status';

  @override
  String get batchShareBirds => 'Birds';

  @override
  String get batchShareEntry => 'Entry';

  @override
  String get batchShareAge => 'Age';

  @override
  String get batchShareWeight => 'Weight';

  @override
  String get batchShareMortality => 'Mortality';

  @override
  String batchShareBirdsFormat(String current, String total) {
    return '$current of $total';
  }

  @override
  String get enumTipoAlimentoPreIniciador => 'Pre-starter';

  @override
  String get enumTipoAlimentoIniciador => 'Starter';

  @override
  String get enumTipoAlimentoCrecimiento => 'Grower';

  @override
  String get enumTipoAlimentoFinalizador => 'Finisher';

  @override
  String get enumTipoAlimentoPostura => 'Layer';

  @override
  String get enumTipoAlimentoLevante => 'Rearing';

  @override
  String get enumTipoAlimentoMedicado => 'Medicated';

  @override
  String get enumTipoAlimentoConcentrado => 'Concentrate';

  @override
  String get enumTipoAlimentoOtro => 'Other';

  @override
  String get enumTipoAlimentoDescPreIniciador => 'Pre-starter (0-7 days)';

  @override
  String get enumTipoAlimentoDescIniciador => 'Starter (8-21 days)';

  @override
  String get enumTipoAlimentoDescCrecimiento => 'Grower (22-35 days)';

  @override
  String get enumTipoAlimentoDescFinalizador => 'Finisher (36+ days)';

  @override
  String get enumTipoAlimentoRangoPreIniciador => '0-7 days';

  @override
  String get enumTipoAlimentoRangoIniciador => '8-21 days';

  @override
  String get enumTipoAlimentoRangoCrecimiento => '22-35 days';

  @override
  String get enumTipoAlimentoRangoFinalizador => '36+ days';

  @override
  String get enumTipoAlimentoRangoPostura => 'Layer hens';

  @override
  String get enumTipoAlimentoRangoLevante => 'Replacement pullets';

  @override
  String get enumMetodoPesajeManual => 'Manual';

  @override
  String get enumMetodoPesajeBasculaIndividual => 'Individual Scale';

  @override
  String get enumMetodoPesajeBasculaLote => 'Batch Scale';

  @override
  String get enumMetodoPesajeAutomatica => 'Automatic';

  @override
  String get enumMetodoPesajeDescManual => 'Manual with scale';

  @override
  String get enumMetodoPesajeDescBasculaIndividual => 'Individual scale';

  @override
  String get enumMetodoPesajeDescBasculaLote => 'Batch scale';

  @override
  String get enumMetodoPesajeDescAutomatica => 'Automatic system';

  @override
  String get enumMetodoPesajeDetalleManual =>
      'Weighing bird by bird with portable scale';

  @override
  String get enumMetodoPesajeDetalleBasculaIndividual =>
      'Electronic scale for one bird';

  @override
  String get enumMetodoPesajeDetalleBasculaLote =>
      'Group weighing divided by quantity';

  @override
  String get enumMetodoPesajeDetalleAutomatica => 'Integrated automated system';

  @override
  String get enumCausaMortEnfermedad => 'Disease';

  @override
  String get enumCausaMortAccidente => 'Accident';

  @override
  String get enumCausaMortDesnutricion => 'Malnutrition';

  @override
  String get enumCausaMortEstres => 'Stress';

  @override
  String get enumCausaMortMetabolica => 'Metabolic';

  @override
  String get enumCausaMortDepredacion => 'Predation';

  @override
  String get enumCausaMortSacrificio => 'Slaughter';

  @override
  String get enumCausaMortVejez => 'Old Age';

  @override
  String get enumCausaMortDesconocida => 'Unknown';

  @override
  String get enumCausaMortDescEnfermedad => 'Infectious pathology';

  @override
  String get enumCausaMortDescAccidente => 'Trauma or injury';

  @override
  String get enumCausaMortDescDesnutricion => 'Lack of nutrients';

  @override
  String get enumCausaMortDescEstres => 'Environmental factors';

  @override
  String get enumCausaMortDescMetabolica => 'Physiological problems';

  @override
  String get enumCausaMortDescDepredacion => 'Animal attacks';

  @override
  String get enumCausaMortDescSacrificio => 'Death during processing';

  @override
  String get enumCausaMortDescVejez => 'End of productive life';

  @override
  String get enumCausaMortDescDesconocida => 'Unidentified cause';

  @override
  String get enumTipoAlimentoRangoMedicado => 'Under treatment';

  @override
  String get enumTipoAlimentoRangoConcentrado => 'Supplement';

  @override
  String get enumTipoAlimentoRangoOtro => 'General use';

  @override
  String get enumTipoAlimentoDescPostura => 'Layer';

  @override
  String get enumTipoAlimentoDescLevante => 'Rearing';

  @override
  String get enumTipoAlimentoDescMedicado => 'Medicated';

  @override
  String get enumTipoAlimentoDescConcentrado => 'Concentrate';

  @override
  String get enumTipoAlimentoDescOtro => 'Other';

  @override
  String errorSavingGeneric(String error) {
    return 'Error saving: $error';
  }

  @override
  String errorDeletingGeneric(String error) {
    return 'Error deleting: $error';
  }

  @override
  String get errorUserNotAuthenticated => 'User not authenticated';

  @override
  String get errorGeneric => 'Error';

  @override
  String get enumTipoAvePolloEngorde => 'Broiler';

  @override
  String get enumTipoAveGallinaPonedora => 'Layer Hen';

  @override
  String get enumTipoAveReproductoraPesada => 'Heavy Breeder';

  @override
  String get enumTipoAveReproductoraLiviana => 'Light Breeder';

  @override
  String get enumTipoAvePavo => 'Turkey';

  @override
  String get enumTipoAveCodorniz => 'Quail';

  @override
  String get enumTipoAvePato => 'Duck';

  @override
  String get enumTipoAveOtro => 'Other';

  @override
  String get enumTipoAveShortPolloEngorde => 'Broiler';

  @override
  String get enumTipoAveShortGallinaPonedora => 'Layer';

  @override
  String get enumTipoAveShortReproductoraPesada => 'Heavy Br.';

  @override
  String get enumTipoAveShortReproductoraLiviana => 'Light Br.';

  @override
  String get enumTipoAveShortPavo => 'Turkey';

  @override
  String get enumTipoAveShortCodorniz => 'Quail';

  @override
  String get enumTipoAveShortPato => 'Duck';

  @override
  String get enumTipoAveShortOtro => 'Other';

  @override
  String get enumEstadoLoteActivo => 'Active';

  @override
  String get enumEstadoLoteCerrado => 'Closed';

  @override
  String get enumEstadoLoteCuarentena => 'Quarantine';

  @override
  String get enumEstadoLoteVendido => 'Sold';

  @override
  String get enumEstadoLoteEnTransferencia => 'In Transfer';

  @override
  String get enumEstadoLoteSuspendido => 'Suspended';

  @override
  String get enumEstadoLoteDescActivo => 'Batch in normal production';

  @override
  String get enumEstadoLoteDescCerrado => 'Batch finalized';

  @override
  String get enumEstadoLoteDescCuarentena =>
      'Batch isolated for sanitary reasons';

  @override
  String get enumEstadoLoteDescVendido => 'Batch completely sold';

  @override
  String get enumEstadoLoteDescEnTransferencia => 'Batch being transferred';

  @override
  String get enumEstadoLoteDescSuspendido => 'Batch temporarily suspended';

  @override
  String get enumEstadoGalponActivo => 'Active';

  @override
  String get enumEstadoGalponMantenimiento => 'Maintenance';

  @override
  String get enumEstadoGalponInactivo => 'Inactive';

  @override
  String get enumEstadoGalponDesinfeccion => 'Disinfection';

  @override
  String get enumEstadoGalponCuarentena => 'Quarantine';

  @override
  String get enumEstadoGalponDescActivo => 'Operational house';

  @override
  String get enumEstadoGalponDescMantenimiento => 'House under repair';

  @override
  String get enumEstadoGalponDescInactivo => 'Unused house';

  @override
  String get enumEstadoGalponDescDesinfeccion => 'House in sanitary process';

  @override
  String get enumEstadoGalponDescCuarentena => 'House isolated for health';

  @override
  String get enumTipoGalponEngorde => 'Broiler';

  @override
  String get enumTipoGalponPostura => 'Layer';

  @override
  String get enumTipoGalponReproductora => 'Breeder';

  @override
  String get enumTipoGalponMixto => 'Mixed';

  @override
  String get enumTipoGalponDescEngorde => 'House for meat production';

  @override
  String get enumTipoGalponDescPostura => 'House for egg production';

  @override
  String get enumTipoGalponDescReproductora =>
      'House for fertile egg production';

  @override
  String get enumTipoGalponDescMixto =>
      'Multi-purpose house for different production types';

  @override
  String get enumRolGranjaOwner => 'Owner';

  @override
  String get enumRolGranjaAdmin => 'Administrator';

  @override
  String get enumRolGranjaManager => 'Manager';

  @override
  String get enumRolGranjaOperator => 'Operator';

  @override
  String get enumRolGranjaViewer => 'Viewer';

  @override
  String get enumRolGranjaDescOwner => 'Full control, can delete the farm';

  @override
  String get enumRolGranjaDescAdmin => 'Full control except deletion';

  @override
  String get enumRolGranjaDescManager => 'Record and invitation management';

  @override
  String get enumRolGranjaDescOperator => 'Can only create records';

  @override
  String get enumRolGranjaDescViewer => 'Read only';

  @override
  String get savedMomentAgo => 'Saved a moment ago';

  @override
  String savedMinutesAgo(int minutes) {
    return 'Saved $minutes min ago';
  }

  @override
  String savedAtTime(String time) {
    return 'Saved at $time';
  }

  @override
  String get pleaseSelectFarmAndBatch => 'Please select a farm and a batch';

  @override
  String get pleaseSelectExpenseType => 'Please select an expense type';

  @override
  String get noPermissionEditCosts =>
      'You do not have permission to edit costs in this farm';

  @override
  String get noPermissionCreateCosts =>
      'You do not have permission to create costs in this farm';

  @override
  String get errorSelectFarm => 'Please select a farm';

  @override
  String errorClosingTreatment(String error) {
    return 'Error closing treatment: $error';
  }

  @override
  String get couldNotLoadBiosecurity => 'Could not load biosecurity';

  @override
  String purchaseOf(String name) {
    return 'Purchase of $name';
  }

  @override
  String draftFoundMessage(String date) {
    return 'A saved draft from $date was found.\nDo you want to restore it?';
  }

  @override
  String insufficientStock(String available) {
    return 'Insufficient stock. Available: $available kg';
  }

  @override
  String get maxWeightIs => 'Maximum weight is 50,000 kg';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String closedOnDate(String date) {
    return 'Closed on $date';
  }

  @override
  String inventoryOfType(String type) {
    return 'of type $type';
  }

  @override
  String get enumTipoRegistroPeso => 'Weight';

  @override
  String get enumTipoRegistroConsumo => 'Consumption';

  @override
  String get enumTipoRegistroMortalidad => 'Mortality';

  @override
  String get enumTipoRegistroProduccion => 'Production';

  @override
  String get semanticsStatusOpen => 'open';

  @override
  String get semanticsStatusClosed => 'closed';

  @override
  String get semanticsDirectionEntry => 'entry';

  @override
  String get semanticsDirectionExit => 'exit';

  @override
  String get semanticsUnits => 'units';

  @override
  String semanticsHealthRecord(String diagnosis, String date, String status) {
    return 'Health record, $diagnosis, $date, $status';
  }

  @override
  String semanticsVaccination(String name, String date, String status) {
    return 'Vaccination $name, $date, status $status';
  }

  @override
  String semanticsSale(String type, String date, String status) {
    return 'Sale of $type, $date, status $status';
  }

  @override
  String semanticsCost(String concept, String type, String date) {
    return 'Cost $concept, type $type, $date';
  }

  @override
  String semanticsInventoryMovement(
    String type,
    String direction,
    String quantity,
    String units,
  ) {
    return 'Movement $type, $direction of $quantity $units';
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
    return '$month $day, $year • $time';
  }

  @override
  String shareDateLine(String value) {
    return '📅 Date: $value';
  }

  @override
  String shareTypeLine(String value) {
    return '🏷️ Type: $value';
  }

  @override
  String shareQuantityBirdsLine(String count) {
    return '🐔 Quantity: $count birds';
  }

  @override
  String sharePricePerKgLine(String currency, String price) {
    return '💰 Price: $currency $price/kg';
  }

  @override
  String shareEggsLine(String count) {
    return '🥚 Eggs: $count units';
  }

  @override
  String shareQuantityLine(String count, String unit) {
    return '📝 Quantity: $count $unit';
  }

  @override
  String shareTotalLine(String currency, String amount) {
    return '💵 TOTAL: $currency $amount';
  }

  @override
  String shareClientLine(String value) {
    return '👤 Client: $value';
  }

  @override
  String shareContactLine(String value) {
    return '📱 Contact: $value';
  }

  @override
  String shareStatusLine(String value) {
    return '📊 Status: $value';
  }

  @override
  String shareSubjectSale(String type) {
    return 'Sale - $type';
  }

  @override
  String get bultosFallback => 'bags';

  @override
  String get statusRejected => 'Rejected';

  @override
  String birdCountWithPercent(String count, String percent) {
    return '$count birds ($percent%)';
  }

  @override
  String eggCountUnits(String count) {
    return '$count units';
  }

  @override
  String batchDropdownItemCode(String code, String count) {
    return '$code - $count birds';
  }

  @override
  String batchDropdownItemName(String name, String count) {
    return '$name - $count birds';
  }

  @override
  String semanticsLoteSummary(
    String code,
    String type,
    String count,
    String status,
  ) {
    return 'Batch $code, $type, $count birds, $status';
  }

  @override
  String inventoryStockLabel(String value, String unit) {
    return 'Stock: $value $unit';
  }

  @override
  String inventoryExpiresLabel(String date) {
    return 'Expires: $date';
  }

  @override
  String inventoryPriceLabel(String price, String unit) {
    return 'Price: $price/$unit';
  }

  @override
  String get shedDensityFattening => '10-12 birds/m²';

  @override
  String get shedDensityLaying => '8-10 birds/m²';

  @override
  String get shedDensityBreeder => '6-8 birds/m²';

  @override
  String galponTotalCount(String count) {
    return '$count total';
  }

  @override
  String get pollinazaItemName => 'Poultry litter';

  @override
  String get inspectorFallback => 'Inspector';

  @override
  String get collaboratorRoleFallback => 'collaborator';

  @override
  String get reportFilePrefix => 'Report';

  @override
  String get errorOccurredDefault => 'An error occurred';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get unitsFallback => 'units';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get guiasManejoTitle => 'Management Guides';

  @override
  String get guiasManejoSubtitle =>
      'Technical recommendations based on official manuals';

  @override
  String get guiasManejoBotonLabel => 'View management guides';

  @override
  String get guiaLuzTitle => 'Light';

  @override
  String get guiaAlimentacionTitle => 'Feeding';

  @override
  String get guiaPesoTitle => 'Weight';

  @override
  String get guiaAguaTitle => 'Water';

  @override
  String get guiaSemanaCol => 'Wk';

  @override
  String get guiaHorasLuzCol => 'Light hours';

  @override
  String get guiaPesoObjetivoCol => 'Target weight';

  @override
  String get guiaTipoCol => 'Type';

  @override
  String get guiaTotalLote => 'flock total';

  @override
  String get guiaAveAbrev => 'bird';

  @override
  String get guiaDiaAbrev => 'day';

  @override
  String guiaSemanaActualLabel(int semana) {
    return 'Week $semana (current)';
  }

  @override
  String get guiaLuzSubtitle => 'Recommended light hours per day';

  @override
  String guiaAlimentacionSubtitle(String kgDia, int aves) {
    return 'Flock total: $kgDia kg/day for $aves birds';
  }

  @override
  String guiaAguaSubtitle(String litrosDia, int aves) {
    return 'Flock total: $litrosDia L/day for $aves birds';
  }

  @override
  String guiaPesoComparacion(String actual, String objetivo) {
    return 'Current weight: ${actual}g — Target: ${objetivo}g';
  }

  @override
  String get guiaPesoSinDatos => 'No current weight data recorded';

  @override
  String get guiaTipoAlimentoRecomendado => 'Recommended feed';

  @override
  String get guiaFuenteManual => 'Source';

  @override
  String get guiaTemperaturaTitle => 'Temperature';

  @override
  String get guiaHumedadTitle => 'Humidity';

  @override
  String get guiaTemperaturaSubtitle => 'Recommended ambient temperature';

  @override
  String get guiaHumedadSubtitle => 'Recommended relative humidity';

  @override
  String get guiaTemperaturaCol => 'Temp (°C)';

  @override
  String get guiaHumedadCol => 'Humidity (%)';

  @override
  String get vetVirtualTitle => 'Virtual Vet';

  @override
  String get vetVirtualSubtitle => 'AI poultry assistant';

  @override
  String vetVirtualContextoLote(String codigo, String tipoAve) {
    return 'Using context from flock $codigo ($tipoAve)';
  }

  @override
  String get vetVirtualSinContexto =>
      'General consultation without selected flock';

  @override
  String get vetVirtualEligeConsulta => 'What do you need help with?';

  @override
  String get vetVirtualDisclaimer =>
      'This assistant uses AI as a support tool. It does not replace a professional veterinarian\'s diagnosis. Consult in person for emergencies.';

  @override
  String get vetDiagnosticoTitle => 'Diagnosis';

  @override
  String get vetDiagnosticoDesc =>
      'Describe symptoms and get possible diagnoses';

  @override
  String get vetMortalidadTitle => 'Mortality';

  @override
  String get vetMortalidadDesc => 'Analyze mortality rates and possible causes';

  @override
  String get vetVacunacionTitle => 'Vaccination';

  @override
  String get vetVacunacionDesc => 'Vaccination plan based on bird type and age';

  @override
  String get vetNutricionTitle => 'Nutrition';

  @override
  String get vetNutricionDesc => 'Evaluate feeding, weight and feed conversion';

  @override
  String get vetAmbienteTitle => 'Environment';

  @override
  String get vetAmbienteDesc => 'Temperature, humidity and house conditions';

  @override
  String get vetBioseguridadTitle => 'Biosecurity';

  @override
  String get vetBioseguridadDesc => 'Prevention and disinfection protocols';

  @override
  String get vetGeneralTitle => 'General Inquiry';

  @override
  String get vetGeneralDesc => 'Ask anything about poultry production';

  @override
  String get vetChatHint => 'Type your question...';

  @override
  String get vetChatError => 'Could not get a response. Try again.';

  @override
  String get vetChatRetry => 'Retry';

  @override
  String get vetVirtualBotonLabel => 'Virtual Vet AI';

  @override
  String get vetIaLabel => 'Vet AI';

  @override
  String get vetTextoCopied => 'Text copied';

  @override
  String get vetAnalizando => 'Analyzing...';

  @override
  String get vetAttachImage => 'Attach image';

  @override
  String get vetFromCamera => 'Take photo';

  @override
  String get vetFromGallery => 'Choose from gallery';

  @override
  String get vetImageAttach => 'Attach image';

  @override
  String get vetImageSelectSource => 'Select where to get the image from';

  @override
  String get vetStatusProcessing => 'Processing your query...';

  @override
  String get vetStatusAnalyzingImage => 'Analyzing image...';

  @override
  String get vetStatusGenerating => 'Generating response...';

  @override
  String get vetVoiceListening => 'Listening...';

  @override
  String get vetVoiceNotAvailable => 'Voice recognition is not available';

  @override
  String get vetVoiceStart => 'Start dictation';

  @override
  String get vetVoiceStop => 'Stop dictation';

  @override
  String get vetAnalyzeImage => 'Analyze this image';

  @override
  String get legalLastUpdated => 'Last updated: April 2026';

  @override
  String get legalPrivacy1Title => '1. Information we collect';

  @override
  String get legalPrivacy1Body =>
      'We collect information you provide directly: name, email, farm data (name, location, houses, flocks), production records (weight, mortality, production, consumption), images of birds and houses, and animal health data. We also automatically collect app usage data and push notification tokens.';

  @override
  String get legalPrivacy2Title => '2. How we use your information';

  @override
  String get legalPrivacy2Body =>
      'We use your data to: operate and maintain the application, generate reports and production analytics, provide management recommendations through the virtual veterinarian AI, send notifications about health alerts and reminders, and improve our services. We do not sell or share your data with third parties for advertising purposes.';

  @override
  String get legalPrivacy3Title => '3. Storage and security';

  @override
  String get legalPrivacy3Body =>
      'Your data is securely stored on Firebase servers (Google Cloud Platform) with encryption in transit and at rest. We implement technical and organizational security measures to protect your information against unauthorized access, alteration, or destruction.';

  @override
  String get legalPrivacy4Title => '4. Data sharing';

  @override
  String get legalPrivacy4Body =>
      'We only share your farm data with collaborators you explicitly invite. Virtual veterinarian AI queries are processed through Google Gemini; these queries do not contain personally identifiable information beyond the farm context needed for the response.';

  @override
  String get legalPrivacy5Title => '5. Your rights';

  @override
  String get legalPrivacy5Body =>
      'You have the right to: access your personal data, correct inaccurate information, request deletion of your account and data, export your data in standard formats, and withdraw your consent at any time.';

  @override
  String get legalPrivacy6Title => '6. Data retention';

  @override
  String get legalPrivacy6Body =>
      'We retain your data as long as your account is active. If you request account deletion, we will delete your personal data within 30 days, unless the law requires longer retention.';

  @override
  String get legalPrivacy7Title => '7. Contact';

  @override
  String get legalPrivacy7Body =>
      'For privacy inquiries, you can contact us through the help section within the app or by sending an email to soporte@smartgranjaaves.com.';

  @override
  String get legalTerms1Title => '1. Acceptance of terms';

  @override
  String get legalTerms1Body =>
      'By using Smart Granja Aves Pro, you agree to these terms and conditions. If you disagree, please do not use the application.';

  @override
  String get legalTerms2Title => '2. Use of the application';

  @override
  String get legalTerms2Body =>
      'The application is designed as a poultry management tool and decision-making support. The virtual veterinarian AI recommendations are for guidance only and DO NOT replace consultation with an in-person veterinarian. The user is responsible for decisions made based on the information provided.';

  @override
  String get legalTerms3Title => '3. User account';

  @override
  String get legalTerms3Body =>
      'You are responsible for maintaining the confidentiality of your account and password. You must notify us immediately of any unauthorized use of your account.';

  @override
  String get legalTerms4Title => '4. Intellectual property';

  @override
  String get legalTerms4Body =>
      'The data you enter in the application is your property. Smart Granja Aves Pro retains the rights to the software, design, algorithms, and proprietary content of the application.';

  @override
  String get legalTerms5Title => '5. Limitation of liability';

  @override
  String get legalTerms5Body =>
      'The application is provided \"as is\". We do not guarantee that the virtual veterinarian\'s recommendations are infallible. We are not liable for losses arising from the use of the information provided. In case of a health emergency, always consult an in-person veterinarian.';

  @override
  String get legalTerms6Title => '6. Modifications';

  @override
  String get legalTerms6Body =>
      'We reserve the right to modify these terms at any time. We will notify you of significant changes through the application. Continued use after changes constitutes your acceptance of the new terms.';
}
