import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar')
  ];

  /// No description provided for @welcomeToPrism.
  ///
  /// In en, this message translates to:
  /// **'welcome to prism'**
  String get welcomeToPrism;

  /// No description provided for @iPreferToUseArabic.
  ///
  /// In en, this message translates to:
  /// **'I prefer to use Arabic'**
  String get iPreferToUseArabic;

  /// No description provided for @letsCreatePosts.
  ///
  /// In en, this message translates to:
  /// **'let\'s create posts'**
  String get letsCreatePosts;

  /// No description provided for @joinGroups.
  ///
  /// In en, this message translates to:
  /// **'join groups'**
  String get joinGroups;

  /// No description provided for @linkWithOthers.
  ///
  /// In en, this message translates to:
  /// **'link with others'**
  String get linkWithOthers;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'let\'s start!'**
  String get letsStart;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @continueWithDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'continue with dark theme'**
  String get continueWithDarkTheme;

  /// No description provided for @continueToApp.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get continueToApp;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait...'**
  String get wait;

  /// No description provided for @codeValidOneHour.
  ///
  /// In en, this message translates to:
  /// **'Code is valid for one hour only'**
  String get codeValidOneHour;

  /// No description provided for @resendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Resend verification code'**
  String get resendVerificationCode;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @validEmailErrMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailErrMsg;

  /// No description provided for @validPasswordErrMsg.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validPasswordErrMsg;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match...'**
  String get passwordsDontMatch;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signupToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started:'**
  String get signupToGetStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signinToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account:'**
  String get signinToYourAccount;

  /// No description provided for @newEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'New email is required'**
  String get newEmailRequired;

  /// No description provided for @newEmailValid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid New email address'**
  String get newEmailValid;

  /// No description provided for @oldPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Old password is required'**
  String get oldPasswordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// No description provided for @confirmNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password is required'**
  String get confirmNewPasswordRequired;

  /// No description provided for @verificationInfo1.
  ///
  /// In en, this message translates to:
  /// **'* The verification code was sent to '**
  String get verificationInfo1;

  /// No description provided for @verificationInfo2.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get verificationInfo2;

  /// No description provided for @verificationInfoOld.
  ///
  /// In en, this message translates to:
  /// **'* The verification code was sent to your old email'**
  String get verificationInfoOld;

  /// No description provided for @recently.
  ///
  /// In en, this message translates to:
  /// **'recently'**
  String get recently;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note :'**
  String get note;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @doneResendCode.
  ///
  /// In en, this message translates to:
  /// **'Code Resent Successfully!'**
  String get doneResendCode;

  /// No description provided for @didntRecieveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t recieve code? '**
  String get didntRecieveCode;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @goBackToSignIn1.
  ///
  /// In en, this message translates to:
  /// **'Go Back To Sign in'**
  String get goBackToSignIn1;

  /// No description provided for @goBackToSignIn2.
  ///
  /// In en, this message translates to:
  /// **'Done! now you can go back to sign in'**
  String get goBackToSignIn2;

  /// No description provided for @enterEmailToVerify.
  ///
  /// In en, this message translates to:
  /// **'Enter Email to Verify'**
  String get enterEmailToVerify;

  /// No description provided for @addVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Add Verification Code'**
  String get addVerificationCode;

  /// No description provided for @addNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Add New Password'**
  String get addNewPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @changeYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Change Your Password'**
  String get changeYourPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'The Password has been changed successfully!'**
  String get passwordChanged;

  /// No description provided for @privacyNote1.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you agree to our'**
  String get privacyNote1;

  /// No description provided for @privacyNote2.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service and Privacy Policy'**
  String get privacyNote2;

  /// No description provided for @prismPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Prism Privacry Policy'**
  String get prismPrivacyPolicy;

  /// No description provided for @detailedPolicy.
  ///
  /// In en, this message translates to:
  /// **'Prism, a startup social media platform, collects minimal user data (e.g., name, email) to enhance your experience. Data is shared with select partners for analytics and marketing, only with your permission. You can access, modify, or delete your data through your account settings anytime. Review our full Terms of Service and Privacy Policy for more information.'**
  String get detailedPolicy;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available to be shown.'**
  String get noData;

  /// No description provided for @followingTitle.
  ///
  /// In en, this message translates to:
  /// **'Following {fullName}'**
  String followingTitle(Object fullName);

  /// No description provided for @followersTitle.
  ///
  /// In en, this message translates to:
  /// **'Followers {fullName}'**
  String followersTitle(Object fullName);

  /// No description provided for @errorLoadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error loading video: {errorMessage}'**
  String errorLoadingVideo(Object errorMessage);

  /// No description provided for @cameraAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access has been denied.'**
  String get cameraAccessDenied;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @textOnly.
  ///
  /// In en, this message translates to:
  /// **'Text Only'**
  String get textOnly;

  /// No description provided for @cameraImage.
  ///
  /// In en, this message translates to:
  /// **'Take Image'**
  String get cameraImage;

  /// No description provided for @cameraVideo.
  ///
  /// In en, this message translates to:
  /// **'Take Video'**
  String get cameraVideo;

  /// No description provided for @addStatusDetails.
  ///
  /// In en, this message translates to:
  /// **'Please add some details to your status'**
  String get addStatusDetails;

  /// No description provided for @enterYourStatus.
  ///
  /// In en, this message translates to:
  /// **'Enter your status...'**
  String get enterYourStatus;

  /// No description provided for @noVideoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No video available'**
  String get noVideoAvailable;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading: {progress}%'**
  String uploading(Object progress);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Undo Request'**
  String get pending;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @requestToFollow.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestToFollow;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @errorPleaseRefresh.
  ///
  /// In en, this message translates to:
  /// **'Error, please refresh'**
  String get errorPleaseRefresh;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @postsSection.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsSection;

  /// No description provided for @hiddenUserPrivacy.
  ///
  /// In en, this message translates to:
  /// **'This account is private'**
  String get hiddenUserPrivacy;

  /// No description provided for @hiddenUserBlock.
  ///
  /// In en, this message translates to:
  /// **'This account is blocked by YOU'**
  String get hiddenUserBlock;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noStatusesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No statuses available'**
  String get noStatusesAvailable;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @enterAccountName.
  ///
  /// In en, this message translates to:
  /// **'Enter your account name'**
  String get enterAccountName;

  /// No description provided for @enterUniqueAccountName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a unique account name'**
  String get enterUniqueAccountName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @fullNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., John Doe'**
  String get fullNameExample;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @addExtraDetails.
  ///
  /// In en, this message translates to:
  /// **'Add extra details'**
  String get addExtraDetails;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title {index}'**
  String title(Object index);

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail {index}'**
  String detail(Object index);

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @accountNameNotValid.
  ///
  /// In en, this message translates to:
  /// **'Account name is not valid'**
  String get accountNameNotValid;

  /// No description provided for @accountNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., john_doe'**
  String get accountNameExample;

  /// No description provided for @errorAccessingGallery.
  ///
  /// In en, this message translates to:
  /// **'Error accessing gallery: {error}'**
  String errorAccessingGallery(Object error);

  /// No description provided for @noAlbumsFound.
  ///
  /// In en, this message translates to:
  /// **'No albums found in your gallery.'**
  String get noAlbumsFound;

  /// No description provided for @errorLoadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error loading media: {error}'**
  String errorLoadingMedia(Object error);

  /// No description provided for @errorSelectingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error selecting media: {error}'**
  String errorSelectingMedia(Object error);

  /// No description provided for @noMediaFound.
  ///
  /// In en, this message translates to:
  /// **'No media found in your gallery.'**
  String get noMediaFound;

  /// No description provided for @galleryAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Gallery access has been denied.'**
  String get galleryAccessDenied;

  /// No description provided for @requestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Permission'**
  String get requestPermission;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'{userName}\'s Personal Info'**
  String personalInfoTitle(Object userName);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This Field is Required!'**
  String get fieldRequired;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'You must enter your Full Name'**
  String get enterYourFullName;

  /// No description provided for @prism.
  ///
  /// In en, this message translates to:
  /// **'Prism'**
  String get prism;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @savedPosts.
  ///
  /// In en, this message translates to:
  /// **'Saved Posts'**
  String get savedPosts;

  /// No description provided for @noSavedPostsFound.
  ///
  /// In en, this message translates to:
  /// **'No saved posts found'**
  String get noSavedPostsFound;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action is irreversible.'**
  String get deleteAccountConfirmation;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @blockUserConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user? They will not be able to see your profile or interact with you.'**
  String get blockUserConfirmation;

  /// No description provided for @userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked successfully.'**
  String get userBlocked;

  /// Confirmation question for blocking a user.
  ///
  /// In en, this message translates to:
  /// **'Block {fullName}?'**
  String blockUserQuestion(String fullName);

  /// No description provided for @blockUserExplanation.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to find your profile, posts, or story on Prism. Prism won\'t let them know you blocked them.'**
  String get blockUserExplanation;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblockUser;

  /// No description provided for @blockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Blocked Accounts'**
  String get blockedAccounts;

  /// No description provided for @noBlockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'You have no blocked accounts.'**
  String get noBlockedAccounts;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @requestHandledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request handled successfully.'**
  String get requestHandledSuccessfully;

  /// No description provided for @noNewRequests.
  ///
  /// In en, this message translates to:
  /// **'No new requests.'**
  String get noNewRequests;

  /// No description provided for @requestedToFollowYou.
  ///
  /// In en, this message translates to:
  /// **'Requested to follow you'**
  String get requestedToFollowYou;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @likers.
  ///
  /// In en, this message translates to:
  /// **'Likers'**
  String get likers;

  /// No description provided for @personalAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Personal account not found.'**
  String get personalAccountNotFound;

  /// No description provided for @archivedStatuses.
  ///
  /// In en, this message translates to:
  /// **'Archived Statuses'**
  String get archivedStatuses;

  /// Message shown when statuses are selected for a highlight.
  ///
  /// In en, this message translates to:
  /// **'{count} statuses selected for highlight.'**
  String statusesSelectedForHighlight(int count);

  /// No description provided for @noArchivedStatuses.
  ///
  /// In en, this message translates to:
  /// **'No archived statuses.'**
  String get noArchivedStatuses;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @older.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// No description provided for @noStatusesMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No statuses match your filter.'**
  String get noStatusesMatchFilter;

  /// No description provided for @noText.
  ///
  /// In en, this message translates to:
  /// **'No Text'**
  String get noText;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @highlightCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Highlight created successfully'**
  String get highlightCreatedSuccessfully;

  /// No description provided for @failedToCreateHighlight.
  ///
  /// In en, this message translates to:
  /// **'Failed to create highlight'**
  String get failedToCreateHighlight;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get pickFromGallery;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @addCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Add Cover Image'**
  String get addCoverImage;

  /// No description provided for @highlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Highlight Title'**
  String get highlightTitle;

  /// No description provided for @pleaseEnterAtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterAtitle;

  /// No description provided for @createHighlight.
  ///
  /// In en, this message translates to:
  /// **'Create Highlight'**
  String get createHighlight;

  /// No description provided for @editHighlight.
  ///
  /// In en, this message translates to:
  /// **'Edit Highlight'**
  String get editHighlight;

  /// No description provided for @updateCover.
  ///
  /// In en, this message translates to:
  /// **'Update Cover'**
  String get updateCover;

  /// No description provided for @pleaseSelectAnImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image.'**
  String get pleaseSelectAnImage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @selectAnImageFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select an image from gallery'**
  String get selectAnImageFromGallery;

  /// No description provided for @addToHighlight.
  ///
  /// In en, this message translates to:
  /// **'Add to Highlight'**
  String get addToHighlight;

  /// No description provided for @noHighlightsFound.
  ///
  /// In en, this message translates to:
  /// **'No highlights found.'**
  String get noHighlightsFound;

  /// No description provided for @failedToAddToHighlight.
  ///
  /// In en, this message translates to:
  /// **'Failed to add to highlight: {message}'**
  String failedToAddToHighlight(String message);

  /// No description provided for @statusAddedToHighlight.
  ///
  /// In en, this message translates to:
  /// **'Status added to highlight successfully!'**
  String get statusAddedToHighlight;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @groupCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupCreatedSuccessfully;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @pleaseEnterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name'**
  String get pleaseEnterGroupName;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @myFollowedGroups.
  ///
  /// In en, this message translates to:
  /// **'My Followed Groups'**
  String get myFollowedGroups;

  /// No description provided for @myOwnedGroups.
  ///
  /// In en, this message translates to:
  /// **'My Owned Groups'**
  String get myOwnedGroups;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

  /// No description provided for @updateGroup.
  ///
  /// In en, this message translates to:
  /// **'Update Group'**
  String get updateGroup;

  /// No description provided for @groupBio.
  ///
  /// In en, this message translates to:
  /// **'Group Bio'**
  String get groupBio;

  /// No description provided for @privateGroup.
  ///
  /// In en, this message translates to:
  /// **'Private Group'**
  String get privateGroup;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @groupUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group Updated Successfully'**
  String get groupUpdatedSuccessfully;

  /// No description provided for @deleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroupTitle;

  /// No description provided for @deleteGroupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group? This action cannot be undone.'**
  String get deleteGroupConfirmation;

  /// No description provided for @deleteGroupName.
  ///
  /// In en, this message translates to:
  /// **'Delete {groupName}'**
  String deleteGroupName(String groupName);

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Members'**
  String membersCount(int count);

  /// No description provided for @noGroupsHere.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any groups here.'**
  String get noGroupsHere;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get noPostsYet;

  /// No description provided for @groupPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupPageTitle;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// No description provided for @groupBioText.
  ///
  /// In en, this message translates to:
  /// **'{bio} group'**
  String groupBioText(String bio);

  /// No description provided for @noGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any groups here.'**
  String get noGroupsFound;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @exploreGroups.
  ///
  /// In en, this message translates to:
  /// **'Explore Groups'**
  String get exploreGroups;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'{groupName} Members'**
  String groupMembers(String groupName);

  /// No description provided for @requestJoin.
  ///
  /// In en, this message translates to:
  /// **'Request Join'**
  String get requestJoin;

  /// No description provided for @groupRequests.
  ///
  /// In en, this message translates to:
  /// **'Group Requests'**
  String get groupRequests;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @requestedToJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'requested to join {groupName}'**
  String requestedToJoinGroup(String groupName);

  /// No description provided for @hiddenGroupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'This group is private. Join to view content.'**
  String get hiddenGroupPrivacy;

  /// No description provided for @promoteToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Promote to Admin'**
  String get promoteToAdmin;

  /// No description provided for @demoteToMember.
  ///
  /// In en, this message translates to:
  /// **'Demote to Member'**
  String get demoteToMember;

  /// No description provided for @noLiveStreamsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No live streams available at the moment.'**
  String get noLiveStreamsAvailable;

  /// No description provided for @startLiveStream.
  ///
  /// In en, this message translates to:
  /// **'Start Live Stream'**
  String get startLiveStream;

  /// No description provided for @readyToStream.
  ///
  /// In en, this message translates to:
  /// **'Ready to start your live stream?'**
  String get readyToStream;

  /// No description provided for @selectCamera.
  ///
  /// In en, this message translates to:
  /// **'Select Camera'**
  String get selectCamera;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @enableAudio.
  ///
  /// In en, this message translates to:
  /// **'Enable Audio'**
  String get enableAudio;

  /// No description provided for @readyToGo.
  ///
  /// In en, this message translates to:
  /// **'Ready to Go!'**
  String get readyToGo;

  /// No description provided for @sendMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get sendMessageHint;

  /// No description provided for @myStream.
  ///
  /// In en, this message translates to:
  /// **'My Stream'**
  String get myStream;

  /// No description provided for @viewers.
  ///
  /// In en, this message translates to:
  /// **'{count} viewers'**
  String viewers(int count);

  /// No description provided for @hideChat.
  ///
  /// In en, this message translates to:
  /// **'Hide Chat'**
  String get hideChat;

  /// No description provided for @showChat.
  ///
  /// In en, this message translates to:
  /// **'Show Chat'**
  String get showChat;

  /// No description provided for @stopStreaming.
  ///
  /// In en, this message translates to:
  /// **'Stop Streaming'**
  String get stopStreaming;

  /// No description provided for @enableNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications?'**
  String get enableNotificationsTitle;

  /// No description provided for @enableNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to enable notifications to stay updated?'**
  String get enableNotificationsBody;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @groupsSection.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsSection;

  /// No description provided for @contentSection.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentSection;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
