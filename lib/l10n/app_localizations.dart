import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Pet Finder'**
  String get appTitle;

  /// No description provided for @commonHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get commonHome;

  /// No description provided for @commonMap.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get commonMap;

  /// No description provided for @commonPets.
  ///
  /// In vi, this message translates to:
  /// **'Thú cưng'**
  String get commonPets;

  /// No description provided for @commonProfile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get commonProfile;

  /// No description provided for @commonCommunity.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get commonCommunity;

  /// No description provided for @commonMessages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get commonMessages;

  /// No description provided for @commonNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get commonNotifications;

  /// No description provided for @commonSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get commonSettings;

  /// No description provided for @commonLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get commonLanguage;

  /// No description provided for @commonHelpSupport.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & hỗ trợ'**
  String get commonHelpSupport;

  /// No description provided for @commonMyReports.
  ///
  /// In vi, this message translates to:
  /// **'Tin của tôi'**
  String get commonMyReports;

  /// No description provided for @commonSavedReports.
  ///
  /// In vi, this message translates to:
  /// **'Tin đã lưu'**
  String get commonSavedReports;

  /// No description provided for @commonApply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get commonApply;

  /// No description provided for @commonSearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get commonSearch;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get commonContinue;

  /// No description provided for @commonNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get commonNext;

  /// No description provided for @commonBackToHome.
  ///
  /// In vi, this message translates to:
  /// **'Về Trang chủ'**
  String get commonBackToHome;

  /// No description provided for @commonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải'**
  String get commonLoading;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Giúp thú cưng tìm đường về nhà'**
  String get splashTagline;

  /// No description provided for @splashSearchingNeighborhood.
  ///
  /// In vi, this message translates to:
  /// **'Đang tìm quanh khu vực...'**
  String get splashSearchingNeighborhood;

  /// No description provided for @onboardingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get onboardingGetStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In vi, this message translates to:
  /// **'Báo mất thú cưng chỉ trong vài giây'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cảnh báo chi tiết với ảnh, vị trí và thông tin liên hệ để người ở gần có thể giúp đỡ.'**
  String get onboarding1Body;

  /// No description provided for @onboarding1Chip.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ an toàn'**
  String get onboarding1Chip;

  /// No description provided for @onboarding2Title.
  ///
  /// In vi, this message translates to:
  /// **'Nhận trợ giúp từ những người xung quanh'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In vi, this message translates to:
  /// **'Nhận cảnh báo theo thời gian thực và để cộng đồng báo lại những lần nhìn thấy gần bạn.'**
  String get onboarding2Body;

  /// No description provided for @onboarding2Chip.
  ///
  /// In vi, this message translates to:
  /// **'23 người hỗ trợ gần đây'**
  String get onboarding2Chip;

  /// No description provided for @onboarding3Title.
  ///
  /// In vi, this message translates to:
  /// **'Cùng nhau đưa thú cưng về nhà'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi các lần nhìn thấy, nhắn tin với người hỗ trợ và chia sẻ niềm vui đoàn tụ.'**
  String get onboarding3Body;

  /// No description provided for @onboarding3Chip.
  ///
  /// In vi, this message translates to:
  /// **'Đoàn tụ hạnh phúc'**
  String get onboarding3Chip;

  /// No description provided for @welcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng về nhà'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia cùng những người yêu thú cưng gần bạn để giúp thú cưng thất lạc quay về an toàn.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTrustedAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo đáng tin cậy'**
  String get welcomeTrustedAlerts;

  /// No description provided for @welcomeCreateAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get welcomeCreateAccount;

  /// No description provided for @welcomeLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get welcomeLogin;

  /// No description provided for @welcomeTrustNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Mạng lưới khu dân cư tin cậy'**
  String get welcomeTrustNetwork;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng quay lại'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để theo dõi cảnh báo, nhắn tin với người hỗ trợ và cập nhật tin đăng.'**
  String get loginSubtitle;

  /// No description provided for @authEmailOrPhone.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc số điện thoại'**
  String get authEmailOrPhone;

  /// No description provided for @authPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get authForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginButton;

  /// No description provided for @loginCreateAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Bạn mới đến? Tạo tài khoản'**
  String get loginCreateAccountPrompt;

  /// No description provided for @signUpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản của bạn'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập hồ sơ an toàn trước khi đăng cảnh báo hoặc liên hệ người hỗ trợ.'**
  String get signUpSubtitle;

  /// No description provided for @authFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get authFullName;

  /// No description provided for @authEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authCreatePassword.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu'**
  String get authCreatePassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get authConfirmPassword;

  /// No description provided for @signUpButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get signUpButton;

  /// No description provided for @signUpLoginPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? Đăng nhập'**
  String get signUpLoginPrompt;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email hoặc số điện thoại, chúng tôi sẽ gửi mã đặt lại an toàn để đưa bạn quay lại.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã đặt lại'**
  String get forgotPasswordButton;

  /// No description provided for @otpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã xác minh'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi mã 6 chữ số tới name@example.com. Hãy nhập mã bên dưới để giữ an toàn cho tài khoản.'**
  String get otpSubtitle;

  /// No description provided for @otpResendCountdown.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã sau 00:28'**
  String get otpResendCountdown;

  /// No description provided for @otpButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mã'**
  String get otpButton;

  /// No description provided for @authSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mọi thứ đã sẵn sàng'**
  String get authSuccessTitle;

  /// No description provided for @authSuccessSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn đã sẵn sàng để theo dõi cảnh báo, chăm sóc thú cưng và hỗ trợ cộng đồng gần bạn.'**
  String get authSuccessSubtitle;

  /// No description provided for @authSuccessButton.
  ///
  /// In vi, this message translates to:
  /// **'Vào ứng dụng'**
  String get authSuccessButton;

  /// No description provided for @homeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng, Minh'**
  String get homeGreeting;

  /// No description provided for @homeReadyToHelp.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng giúp một thú cưng gần bạn?'**
  String get homeReadyToHelp;

  /// No description provided for @homeCommunityStatsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng đang theo dõi'**
  String get homeCommunityStatsTitle;

  /// No description provided for @homeCommunityStatsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Những người yêu thú cưng gần bạn đang phản hồi các trường hợp thất lạc trong hôm nay.'**
  String get homeCommunityStatsSubtitle;

  /// No description provided for @homeHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn vừa mất hoặc tìm thấy một thú cưng?'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cảnh báo gần đây với ảnh, vị trí và thông tin liên hệ an toàn.'**
  String get homeHeroSubtitle;

  /// No description provided for @reportLostPet.
  ///
  /// In vi, this message translates to:
  /// **'Báo mất thú cưng'**
  String get reportLostPet;

  /// No description provided for @reportFoundPet.
  ///
  /// In vi, this message translates to:
  /// **'Báo tìm thấy thú cưng'**
  String get reportFoundPet;

  /// No description provided for @homeSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo giống, màu sắc hoặc vị trí'**
  String get homeSearchHint;

  /// No description provided for @homeSearchNearby.
  ///
  /// In vi, this message translates to:
  /// **'Tìm gần đây'**
  String get homeSearchNearby;

  /// No description provided for @homeQuickMyPets.
  ///
  /// In vi, this message translates to:
  /// **'Thú cưng của tôi'**
  String get homeQuickMyPets;

  /// No description provided for @homeQuickCommunity.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get homeQuickCommunity;

  /// No description provided for @homeQuickReminders.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lịch chăm sóc'**
  String get homeQuickReminders;

  /// No description provided for @homeNearbyUrgentAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo khẩn gần đây'**
  String get homeNearbyUrgentAlerts;

  /// No description provided for @homeViewMap.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản đồ'**
  String get homeViewMap;

  /// No description provided for @homeNoUrgentAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cảnh báo khẩn'**
  String get homeNoUrgentAlerts;

  /// No description provided for @homeNoUrgentAlertsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khi có tin báo mất thú cưng ở gần, cảnh báo khẩn sẽ xuất hiện tại đây.'**
  String get homeNoUrgentAlertsMessage;

  /// No description provided for @homeCategoryAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get homeCategoryAll;

  /// No description provided for @homeCategoryLost.
  ///
  /// In vi, this message translates to:
  /// **'Thất lạc'**
  String get homeCategoryLost;

  /// No description provided for @homeCategoryFound.
  ///
  /// In vi, this message translates to:
  /// **'Đã tìm thấy'**
  String get homeCategoryFound;

  /// No description provided for @homeCategoryReunited.
  ///
  /// In vi, this message translates to:
  /// **'Đoàn tụ'**
  String get homeCategoryReunited;

  /// No description provided for @homeCategoryNearMe.
  ///
  /// In vi, this message translates to:
  /// **'Gần tôi'**
  String get homeCategoryNearMe;

  /// No description provided for @homeLatestReports.
  ///
  /// In vi, this message translates to:
  /// **'Tin thất lạc & tìm thấy mới nhất'**
  String get homeLatestReports;

  /// No description provided for @homeNoReports.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nội dung để hiển thị'**
  String get homeNoReports;

  /// No description provided for @homeNoReportsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các tin thất lạc và tìm thấy sẽ xuất hiện tại đây khi nguồn cấp có hoạt động.'**
  String get homeNoReportsMessage;

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ bạn muốn sử dụng'**
  String get languageSubtitle;

  /// No description provided for @languageChooseTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languageChooseTitle;

  /// No description provided for @languageChooseBody.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ giúp bạn phản hồi nhanh nhất khi thú cưng cần được giúp đỡ.'**
  String get languageChooseBody;

  /// No description provided for @languageCurrentCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ hiện tại'**
  String get languageCurrentCardTitle;

  /// No description provided for @languageActiveBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đang dùng'**
  String get languageActiveBadge;

  /// No description provided for @languageSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm ngôn ngữ'**
  String get languageSearchHint;

  /// No description provided for @languageNoResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy ngôn ngữ'**
  String get languageNoResultTitle;

  /// No description provided for @languageNoResultMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thử từ khóa khác để tìm ngôn ngữ bạn cần.'**
  String get languageNoResultMessage;

  /// No description provided for @languageApplyButton.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng ngôn ngữ'**
  String get languageApplyButton;

  /// No description provided for @languageHelperNote.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể thay đổi lại bất cứ lúc nào trong Cài đặt.'**
  String get languageHelperNote;

  /// No description provided for @languageUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật ngôn ngữ'**
  String get languageUpdated;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân & chăm sóc'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luôn sẵn sàng tài khoản, cảnh báo và tùy chọn an toàn của bạn.'**
  String get profileSubtitle;

  /// No description provided for @profileHelpedCases.
  ///
  /// In vi, this message translates to:
  /// **'Ca đã hỗ trợ'**
  String get profileHelpedCases;

  /// No description provided for @profileAccountSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get profileAccountSection;

  /// No description provided for @profilePreferencesSection.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn'**
  String get profilePreferencesSection;

  /// No description provided for @profileSessionSection.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập'**
  String get profileSessionSection;

  /// No description provided for @profileMyReportsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi các cảnh báo thất lạc và tìm thấy của bạn'**
  String get profileMyReportsSubtitle;

  /// No description provided for @profileSavedReportsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại các trường hợp gần bạn'**
  String get profileSavedReportsSubtitle;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo gần đây, cập nhật và nhắc theo dõi nhanh'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo, vị trí, quyền riêng tư và giao diện'**
  String get profileSettingsSubtitle;

  /// No description provided for @profileHelpSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'FAQ, hướng dẫn an toàn và liên hệ hỗ trợ'**
  String get profileHelpSubtitle;

  /// No description provided for @profilePrivacySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại hiển thị vị trí và thông tin liên hệ'**
  String get profilePrivacySubtitle;

  /// No description provided for @profileLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get profileLogout;

  /// No description provided for @profileLogoutSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại luồng chào mừng'**
  String get profileLogoutSubtitle;

  /// No description provided for @profileSignedOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thành công.'**
  String get profileSignedOut;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tinh chỉnh cảnh báo, quyền riêng tư và cách ứng dụng hoạt động.'**
  String get settingsSubtitle;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsNearbyAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo thú cưng thất lạc gần bạn'**
  String get settingsNearbyAlerts;

  /// No description provided for @settingsNearbyAlertsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận cập nhật trường hợp địa phương trước tiên'**
  String get settingsNearbyAlertsSubtitle;

  /// No description provided for @settingsChatNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo tin nhắn'**
  String get settingsChatNotifications;

  /// No description provided for @settingsChatNotificationsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luôn theo sát các cuộc trò chuyện đang hoạt động'**
  String get settingsChatNotificationsSubtitle;

  /// No description provided for @settingsLocationSection.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí'**
  String get settingsLocationSection;

  /// No description provided for @settingsAlertRadius.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính cảnh báo'**
  String get settingsAlertRadius;

  /// No description provided for @settingsDefaultCity.
  ///
  /// In vi, this message translates to:
  /// **'Thành phố mặc định'**
  String get settingsDefaultCity;

  /// No description provided for @settingsPrivacySection.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get settingsPrivacySection;

  /// No description provided for @settingsShowExactLocation.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị vị trí chính xác'**
  String get settingsShowExactLocation;

  /// No description provided for @settingsShowExactLocationSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ dùng ghim chính xác khi thật sự cần'**
  String get settingsShowExactLocationSubtitle;

  /// No description provided for @settingsContactVisibility.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị liên hệ'**
  String get settingsContactVisibility;

  /// No description provided for @settingsSafeMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ an toàn'**
  String get settingsSafeMode;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsDarkMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn giao diện giả lập cho hiện tại'**
  String get settingsDarkModeSubtitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguageSection;

  /// No description provided for @settingsAppLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ ứng dụng'**
  String get settingsAppLanguage;

  /// No description provided for @settingsAlertRadiusSection.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính cảnh báo'**
  String get settingsAlertRadiusSection;

  /// No description provided for @settingsNearbySearchDistance.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách tìm kiếm gần đây'**
  String get settingsNearbySearchDistance;

  /// No description provided for @settingsSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu cài đặt'**
  String get settingsSaveButton;

  /// No description provided for @settingsSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu cài đặt.'**
  String get settingsSaved;

  /// No description provided for @reportFlowStepCounter.
  ///
  /// In vi, this message translates to:
  /// **'{current}/{total}'**
  String reportFlowStepCounter(int current, int total);

  /// No description provided for @reportFlowStep1Title.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra chuyện gì?'**
  String get reportFlowStep1Title;

  /// No description provided for @reportFlowStep1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tình huống phù hợp nhất. Chúng tôi sẽ hướng dẫn bạn điền đúng thông tin.'**
  String get reportFlowStep1Subtitle;

  /// No description provided for @reportFlowLostTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tôi bị mất thú cưng'**
  String get reportFlowLostTitle;

  /// No description provided for @reportFlowLostDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cảnh báo khẩn cấp cho hàng xóm và người hỗ trợ gần bạn.'**
  String get reportFlowLostDescription;

  /// No description provided for @reportFlowFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tôi tìm thấy thú cưng'**
  String get reportFlowFoundTitle;

  /// No description provided for @reportFlowFoundDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ thông tin an toàn để giúp thú cưng đoàn tụ với gia đình.'**
  String get reportFlowFoundDescription;

  /// No description provided for @reportFlowGuidedEditable.
  ///
  /// In vi, this message translates to:
  /// **'Có hướng dẫn và có thể chỉnh sửa'**
  String get reportFlowGuidedEditable;

  /// No description provided for @reportFlowEditableNote.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể chỉnh sửa thông tin trước khi đăng báo cáo.'**
  String get reportFlowEditableNote;

  /// No description provided for @reportFlowStep2Title.
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh thú cưng lên'**
  String get reportFlowStep2Title;

  /// No description provided for @reportFlowStep2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh rõ mặt và toàn thân sẽ giúp mọi người nhận diện nhanh hơn.'**
  String get reportFlowStep2Subtitle;

  /// No description provided for @reportFlowUploadTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh thú cưng lên'**
  String get reportFlowUploadTitle;

  /// No description provided for @reportFlowUploadHint.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh rõ mặt, vòng cổ hoặc toàn thân để cộng đồng nhận diện nhanh hơn.'**
  String get reportFlowUploadHint;

  /// No description provided for @reportFlowCamera.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get reportFlowCamera;

  /// No description provided for @reportFlowGallery.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get reportFlowGallery;

  /// No description provided for @reportFlowPhotoFace.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh mặt'**
  String get reportFlowPhotoFace;

  /// No description provided for @reportFlowPhotoFullBody.
  ///
  /// In vi, this message translates to:
  /// **'Toàn thân'**
  String get reportFlowPhotoFullBody;

  /// No description provided for @reportFlowClearTips.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo ảnh rõ nét'**
  String get reportFlowClearTips;

  /// No description provided for @reportFlowClearTipsBody.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh rõ mặt và toàn thân sẽ giúp người khác nhận ra thú cưng nhanh hơn.'**
  String get reportFlowClearTipsBody;

  /// No description provided for @reportFlowStep3Title.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thú cưng'**
  String get reportFlowStep3Title;

  /// No description provided for @reportFlowStep3Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Một vài chi tiết quen thuộc sẽ giúp mọi người nhận diện đúng thú cưng.'**
  String get reportFlowStep3Subtitle;

  /// No description provided for @reportFlowPetName.
  ///
  /// In vi, this message translates to:
  /// **'Tên thú cưng'**
  String get reportFlowPetName;

  /// No description provided for @reportFlowPetNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Luna'**
  String get reportFlowPetNameHint;

  /// No description provided for @reportFlowType.
  ///
  /// In vi, this message translates to:
  /// **'Loài'**
  String get reportFlowType;

  /// No description provided for @reportFlowGender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get reportFlowGender;

  /// No description provided for @reportFlowPetTypeDog.
  ///
  /// In vi, this message translates to:
  /// **'Chó'**
  String get reportFlowPetTypeDog;

  /// No description provided for @reportFlowPetTypeCat.
  ///
  /// In vi, this message translates to:
  /// **'Mèo'**
  String get reportFlowPetTypeCat;

  /// No description provided for @reportFlowPetTypeOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get reportFlowPetTypeOther;

  /// No description provided for @reportFlowGenderFemale.
  ///
  /// In vi, this message translates to:
  /// **'Cái'**
  String get reportFlowGenderFemale;

  /// No description provided for @reportFlowGenderMale.
  ///
  /// In vi, this message translates to:
  /// **'Đực'**
  String get reportFlowGenderMale;

  /// No description provided for @reportFlowBreed.
  ///
  /// In vi, this message translates to:
  /// **'Giống'**
  String get reportFlowBreed;

  /// No description provided for @reportFlowBreedHint.
  ///
  /// In vi, this message translates to:
  /// **'Golden Retriever'**
  String get reportFlowBreedHint;

  /// No description provided for @reportFlowColor.
  ///
  /// In vi, this message translates to:
  /// **'Màu sắc'**
  String get reportFlowColor;

  /// No description provided for @reportFlowColorHint.
  ///
  /// In vi, this message translates to:
  /// **'Vàng mật ong'**
  String get reportFlowColorHint;

  /// No description provided for @reportFlowSpecialMarks.
  ///
  /// In vi, this message translates to:
  /// **'Dấu hiệu nhận dạng'**
  String get reportFlowSpecialMarks;

  /// No description provided for @reportFlowSpecialMarksHint.
  ///
  /// In vi, this message translates to:
  /// **'Mảng lông trắng ở ngực và vòng cổ xanh ngọc'**
  String get reportFlowSpecialMarksHint;

  /// No description provided for @reportFlowDetailsHelpMatch.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết giúp đối chiếu'**
  String get reportFlowDetailsHelpMatch;

  /// No description provided for @reportFlowStep4Title.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí và thời gian'**
  String get reportFlowStep4Title;

  /// No description provided for @reportFlowStep4Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu nơi nhìn thấy lần cuối để những người ở gần có thể phản hồi đúng bối cảnh.'**
  String get reportFlowStep4Subtitle;

  /// No description provided for @reportFlowAddressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ hoặc mốc địa danh'**
  String get reportFlowAddressLabel;

  /// No description provided for @reportFlowAddressHint.
  ///
  /// In vi, this message translates to:
  /// **'Công viên Maple, Quận 2'**
  String get reportFlowAddressHint;

  /// No description provided for @reportFlowDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get reportFlowDate;

  /// No description provided for @reportFlowTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get reportFlowTime;

  /// No description provided for @reportFlowUseLocation.
  ///
  /// In vi, this message translates to:
  /// **'Dùng vị trí hiện tại'**
  String get reportFlowUseLocation;

  /// No description provided for @reportFlowApproxArea.
  ///
  /// In vi, this message translates to:
  /// **'Khu vực gần đúng'**
  String get reportFlowApproxArea;

  /// No description provided for @reportFlowToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get reportFlowToday;

  /// No description provided for @reportFlowYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get reportFlowYesterday;

  /// No description provided for @reportFlowAccurateLocationHelp.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin vị trí chính xác giúp người ở gần phản hồi nhanh hơn.'**
  String get reportFlowAccurateLocationHelp;

  /// No description provided for @reportFlowStep5Title.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin liên hệ'**
  String get reportFlowStep5Title;

  /// No description provided for @reportFlowStep5Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cách liên hệ an toàn để người hỗ trợ gần bạn có thể phản hồi nhanh chóng.'**
  String get reportFlowStep5Subtitle;

  /// No description provided for @reportFlowStayReachableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luôn sẵn sàng liên hệ'**
  String get reportFlowStayReachableTitle;

  /// No description provided for @reportFlowStayReachableSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thông tin liên hệ mà bạn thấy thoải mái khi chia sẻ trong báo cáo.'**
  String get reportFlowStayReachableSubtitle;

  /// No description provided for @reportFlowPhoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get reportFlowPhoneLabel;

  /// No description provided for @reportFlowPhoneHint.
  ///
  /// In vi, this message translates to:
  /// **'+84 901 234 567'**
  String get reportFlowPhoneHint;

  /// No description provided for @reportFlowAltLabel.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ thay thế'**
  String get reportFlowAltLabel;

  /// No description provided for @reportFlowAltHint.
  ///
  /// In vi, this message translates to:
  /// **'@petfinder.minh'**
  String get reportFlowAltHint;

  /// No description provided for @reportFlowPhoneVisible.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị số điện thoại'**
  String get reportFlowPhoneVisible;

  /// No description provided for @reportFlowHidePhone.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn số điện thoại'**
  String get reportFlowHidePhone;

  /// No description provided for @reportFlowContinueReview.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục xem lại'**
  String get reportFlowContinueReview;

  /// No description provided for @reportFlowPhoneVisibleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại hiển thị với người hỗ trợ'**
  String get reportFlowPhoneVisibleLabel;

  /// No description provided for @reportFlowVisibilityControl.
  ///
  /// In vi, this message translates to:
  /// **'Bạn kiểm soát quyền hiển thị'**
  String get reportFlowVisibilityControl;

  /// No description provided for @reportFlowStep6Title.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại báo cáo'**
  String get reportFlowStep6Title;

  /// No description provided for @reportFlowStep6Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chắc rằng thông tin đã chính xác trước khi chúng tôi thông báo cho người hỗ trợ gần bạn.'**
  String get reportFlowStep6Subtitle;

  /// No description provided for @reportFlowPublish.
  ///
  /// In vi, this message translates to:
  /// **'Đăng báo cáo'**
  String get reportFlowPublish;

  /// No description provided for @reportFlowPetDetails.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thú cưng'**
  String get reportFlowPetDetails;

  /// No description provided for @reportFlowLocationTime.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí và thời gian'**
  String get reportFlowLocationTime;

  /// No description provided for @reportFlowContact.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin liên hệ'**
  String get reportFlowContact;

  /// No description provided for @reportFlowContactAlternate.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ thay thế'**
  String get reportFlowContactAlternate;

  /// No description provided for @reportFlowVisibility.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị'**
  String get reportFlowVisibility;

  /// No description provided for @reportFlowPhoneHiddenLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã ẩn số điện thoại'**
  String get reportFlowPhoneHiddenLabel;

  /// No description provided for @reportFlowUpdatePauseNote.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể cập nhật hoặc tạm dừng báo cáo này bất cứ lúc nào.'**
  String get reportFlowUpdatePauseNote;

  /// No description provided for @reportFlowSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã được đăng'**
  String get reportFlowSuccessTitle;

  /// No description provided for @reportFlowSuccessLostSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mọi người gần khu vực này đã có thể nhìn thấy thông tin và hỗ trợ tìm kiếm.'**
  String get reportFlowSuccessLostSubtitle;

  /// No description provided for @reportFlowSuccessFoundSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chủ nuôi gần khu vực này giờ đã có thể nhìn thấy thông tin để nhận lại thú cưng.'**
  String get reportFlowSuccessFoundSubtitle;

  /// No description provided for @reportFlowSuccessNearbyResponse.
  ///
  /// In vi, this message translates to:
  /// **'Người ở gần có thể bắt đầu phản hồi ngay khi họ nhìn thấy bài đăng của bạn.'**
  String get reportFlowSuccessNearbyResponse;

  /// No description provided for @reportFlowViewReport.
  ///
  /// In vi, this message translates to:
  /// **'Xem báo cáo'**
  String get reportFlowViewReport;

  /// No description provided for @reportFlowNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get reportFlowNext;

  /// No description provided for @reportFlowTagLost.
  ///
  /// In vi, this message translates to:
  /// **'THẤT LẠC'**
  String get reportFlowTagLost;

  /// No description provided for @reportFlowTagFound.
  ///
  /// In vi, this message translates to:
  /// **'TÌM THẤY'**
  String get reportFlowTagFound;

  /// No description provided for @reportFlowPublishSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã được đăng và người hỗ trợ gần bạn đã có thể nhìn thấy.'**
  String get reportFlowPublishSuccess;

  /// No description provided for @chatDetailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Những cuộc trò chuyện an toàn và ấm áp giúp chủ nuôi và người hỗ trợ phối hợp nhanh hơn khi từng phút đều quan trọng.'**
  String get chatDetailSubtitle;

  /// No description provided for @chatSendPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Gửi ảnh'**
  String get chatSendPhoto;

  /// No description provided for @chatShareLocation.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ vị trí'**
  String get chatShareLocation;

  /// No description provided for @chatViewReport.
  ///
  /// In vi, this message translates to:
  /// **'Xem báo cáo'**
  String get chatViewReport;

  /// No description provided for @chatKeepLeadClose.
  ///
  /// In vi, this message translates to:
  /// **'Giữ mọi đầu mối trong tầm tay'**
  String get chatKeepLeadClose;

  /// No description provided for @chatCall.
  ///
  /// In vi, this message translates to:
  /// **'Gọi điện'**
  String get chatCall;

  /// No description provided for @chatListEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện nào'**
  String get chatListEmptyTitle;

  /// No description provided for @petAddSaveBtn.
  ///
  /// In vi, this message translates to:
  /// **'Lưu hồ sơ thú cưng'**
  String get petAddSaveBtn;

  /// No description provided for @petAddTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thú cưng mới'**
  String get petAddTitle;

  /// No description provided for @petAddSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo hồ sơ ngay bây giờ để bạn có thể đăng cảnh báo khẩn cấp chỉ trong vài giây sau này.'**
  String get petAddSubtitle;

  /// No description provided for @petListSummary.
  ///
  /// In vi, this message translates to:
  /// **'2 hồ sơ đã sẵn sàng • 1 nhắc lịch chăm sóc sắp đến'**
  String get petListSummary;

  /// No description provided for @petListKeepSafe.
  ///
  /// In vi, this message translates to:
  /// **'Giữ sẵn hồ sơ thú cưng'**
  String get petListKeepSafe;

  /// No description provided for @petListSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ hồ sơ thú cưng luôn sẵn sàng phòng khi các bé cần được giúp đỡ.'**
  String get petListSubtitle;

  /// No description provided for @petListPreviewEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước trạng thái trống'**
  String get petListPreviewEmpty;

  /// No description provided for @petEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình nhỏ của bạn'**
  String get petEmptyTitle;

  /// No description provided for @petListAddBtn.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thú cưng'**
  String get petListAddBtn;

  /// No description provided for @petDetailNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy hồ sơ thú cưng'**
  String get petDetailNotFoundTitle;

  /// No description provided for @petDetailNotFoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ này có thể đã bị xóa hoặc liên kết không còn hoạt động.'**
  String get petDetailNotFoundDesc;

  /// No description provided for @petDetailOpenReminders.
  ///
  /// In vi, this message translates to:
  /// **'Mở Nhắc lịch chăm sóc'**
  String get petDetailOpenReminders;

  /// No description provided for @petDetailIdSection.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết nhận dạng'**
  String get petDetailIdSection;

  /// No description provided for @petDetailBasicSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get petDetailBasicSection;

  /// No description provided for @reminderOverviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lịch chăm sóc'**
  String get reminderOverviewTitle;

  /// No description provided for @petDetailHealthSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sức khỏe'**
  String get petDetailHealthSection;

  /// No description provided for @petEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ thú cưng'**
  String get petEditTitle;

  /// No description provided for @petEditSaveBtn.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get petEditSaveBtn;

  /// No description provided for @petEditSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ thông tin luôn mới để hồ sơ thú cưng của bạn sẵn sàng khi cần.'**
  String get petEditSubtitle;

  /// No description provided for @petWidgetKeepInfo.
  ///
  /// In vi, this message translates to:
  /// **'Giữ sẵn thông tin thú cưng để bạn có thể hành động nhanh nếu các bé cần được giúp đỡ.'**
  String get petWidgetKeepInfo;

  /// No description provided for @petWidgetTypeOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get petWidgetTypeOther;

  /// No description provided for @petWidgetHealthCare.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe & chăm sóc'**
  String get petWidgetHealthCare;

  /// No description provided for @petWidgetType.
  ///
  /// In vi, this message translates to:
  /// **'Loài'**
  String get petWidgetType;

  /// No description provided for @petWidgetAge.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh hoặc tuổi'**
  String get petWidgetAge;

  /// No description provided for @petWidgetMarks.
  ///
  /// In vi, this message translates to:
  /// **'Dấu hiệu nhận dạng'**
  String get petWidgetMarks;

  /// No description provided for @petWidgetAddBtn.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thú cưng'**
  String get petWidgetAddBtn;

  /// No description provided for @petWidgetGenderMale.
  ///
  /// In vi, this message translates to:
  /// **'Đực'**
  String get petWidgetGenderMale;

  /// No description provided for @petWidgetGender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get petWidgetGender;

  /// No description provided for @petWidgetCamera.
  ///
  /// In vi, this message translates to:
  /// **'Máy ảnh'**
  String get petWidgetCamera;

  /// No description provided for @petWidgetMissingAlert.
  ///
  /// In vi, this message translates to:
  /// **'Nếu thú cưng của bạn bị lạc, hãy tạo cảnh báo ngay lập tức.'**
  String get petWidgetMissingAlert;

  /// No description provided for @petWidgetVaccination.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng tiêm phòng'**
  String get petWidgetVaccination;

  /// No description provided for @petWidgetMicrochip.
  ///
  /// In vi, this message translates to:
  /// **'Số microchip'**
  String get petWidgetMicrochip;

  /// No description provided for @petWidgetPhotosDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh rõ mặt và toàn thân sẽ giúp tạo cảnh báo khẩn cấp nhanh hơn nhiều sau này.'**
  String get petWidgetPhotosDesc;

  /// No description provided for @petWidgetReminderOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt nhắc lịch'**
  String get petWidgetReminderOff;

  /// No description provided for @petWidgetEditBtn.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get petWidgetEditBtn;

  /// No description provided for @petWidgetBreed.
  ///
  /// In vi, this message translates to:
  /// **'Giống'**
  String get petWidgetBreed;

  /// No description provided for @petWidgetPrefillDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ điền sẵn các thông tin cần thiết để người hỗ trợ gần bạn nhận diện thú cưng nhanh hơn.'**
  String get petWidgetPrefillDesc;

  /// No description provided for @petWidgetRemindersDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lịch tùy chọn giúp bạn theo kịp lịch tiêm phòng, grooming và khám thú y.'**
  String get petWidgetRemindersDesc;

  /// No description provided for @petWidgetAddFirst.
  ///
  /// In vi, this message translates to:
  /// **'Thêm hồ sơ thú cưng đầu tiên'**
  String get petWidgetAddFirst;

  /// No description provided for @petWidgetGenderFemale.
  ///
  /// In vi, this message translates to:
  /// **'Cái'**
  String get petWidgetGenderFemale;

  /// No description provided for @petWidgetColor.
  ///
  /// In vi, this message translates to:
  /// **'Màu sắc'**
  String get petWidgetColor;

  /// No description provided for @petWidgetBasicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get petWidgetBasicInfo;

  /// No description provided for @petWidgetName.
  ///
  /// In vi, this message translates to:
  /// **'Tên thú cưng'**
  String get petWidgetName;

  /// No description provided for @petWidgetWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng'**
  String get petWidgetWeight;

  /// No description provided for @petWidgetReportLost.
  ///
  /// In vi, this message translates to:
  /// **'Báo mất thú cưng'**
  String get petWidgetReportLost;

  /// No description provided for @petWidgetReminderOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật nhắc lịch'**
  String get petWidgetReminderOn;

  /// No description provided for @petWidgetMedicalNotes.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú y tế'**
  String get petWidgetMedicalNotes;

  /// No description provided for @petWidgetTypeDog.
  ///
  /// In vi, this message translates to:
  /// **'Chó'**
  String get petWidgetTypeDog;

  /// No description provided for @petWidgetIdDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết nhận dạng'**
  String get petWidgetIdDetails;

  /// No description provided for @petWidgetAddPhotos.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh thú cưng'**
  String get petWidgetAddPhotos;

  /// No description provided for @petWidgetGallery.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get petWidgetGallery;

  /// No description provided for @petWidgetTypeCat.
  ///
  /// In vi, this message translates to:
  /// **'Mèo'**
  String get petWidgetTypeCat;

  /// No description provided for @mapRadius5km.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính 5 km'**
  String get mapRadius5km;

  /// No description provided for @mapEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Các cảnh báo thất lạc và tìm thấy gần bạn sẽ xuất hiện tại đây khi nguồn cấp có hoạt động.'**
  String get mapEmptyDesc;

  /// No description provided for @mapFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get mapFilterAll;

  /// No description provided for @mapFilterFound.
  ///
  /// In vi, this message translates to:
  /// **'Đã tìm thấy'**
  String get mapFilterFound;

  /// No description provided for @mapNavHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get mapNavHome;

  /// No description provided for @mapNavPets.
  ///
  /// In vi, this message translates to:
  /// **'Thú cưng'**
  String get mapNavPets;

  /// No description provided for @mapApproximateView.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ gần đúng cho các báo cáo mất và tìm thấy gần bạn.'**
  String get mapApproximateView;

  /// No description provided for @mapNearbyAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo gần đây'**
  String get mapNearbyAlerts;

  /// No description provided for @mapNavMap.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get mapNavMap;

  /// No description provided for @mapNavProfile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get mapNavProfile;

  /// No description provided for @mapNearbyList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách gần đây'**
  String get mapNearbyList;

  /// No description provided for @mapFilterLost.
  ///
  /// In vi, this message translates to:
  /// **'Thất lạc'**
  String get mapFilterLost;

  /// No description provided for @mapEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có báo cáo nào gần bạn'**
  String get mapEmptyTitle;

  /// No description provided for @mapSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm đường phố và công viên gần đây'**
  String get mapSearchHint;

  /// No description provided for @mapSubmitSighting.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thông tin nhìn thấy'**
  String get mapSubmitSighting;

  /// No description provided for @profilePrivacySafety.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư & an toàn'**
  String get profilePrivacySafety;

  /// No description provided for @myReportsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Di chuyển giữa các tab đang hoạt động, đã đoàn tụ và đã đóng để xem lại lịch sử cảnh báo của bạn.'**
  String get myReportsSubtitle;

  /// No description provided for @myReportsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có báo cáo nào ở mục này'**
  String get myReportsEmpty;

  /// No description provided for @myReportsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin của tôi'**
  String get myReportsTitle;

  /// No description provided for @myReportsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem những cảnh báo nào vẫn cần chú ý và cảnh báo nào đã được giải quyết.'**
  String get myReportsDesc;

  /// No description provided for @editProfilePhone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get editProfilePhone;

  /// No description provided for @editProfileName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get editProfileName;

  /// No description provided for @editProfilePhotoDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hãy dùng ảnh hồ sơ ấm áp và dễ nhận ra sau.'**
  String get editProfilePhotoDesc;

  /// No description provided for @editProfileRadius.
  ///
  /// In vi, this message translates to:
  /// **'Bán kính nhận cảnh báo'**
  String get editProfileRadius;

  /// No description provided for @editProfileCity.
  ///
  /// In vi, this message translates to:
  /// **'Thành phố'**
  String get editProfileCity;

  /// No description provided for @editProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfileTitle;

  /// No description provided for @editProfileAvatarHint.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện'**
  String get editProfileAvatarHint;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin để cảnh báo luôn hữu ích và an toàn.'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get editProfileEmail;

  /// No description provided for @savedReportsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có báo cáo đã lưu'**
  String get savedReportsEmpty;

  /// No description provided for @savedReportsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại các trường hợp bạn muốn xem lại, theo dõi hoặc hỗ trợ sau.'**
  String get savedReportsSubtitle;

  /// No description provided for @savedReportsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giữ các trường hợp gần bạn trong danh sách đã lưu để theo dõi nhanh.'**
  String get savedReportsDesc;

  /// No description provided for @savedReportsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin đã lưu'**
  String get savedReportsTitle;

  /// No description provided for @helpSupportDesc1.
  ///
  /// In vi, this message translates to:
  /// **'Nhận trợ giúp về tài khoản, cảnh báo hoặc các câu hỏi về ứng dụng'**
  String get helpSupportDesc1;

  /// No description provided for @helpSupportDesc2.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn để báo cáo bình tĩnh hơn, xử lý an toàn hơn và kết nối hỗ trợ địa phương.'**
  String get helpSupportDesc2;

  /// No description provided for @helpReportProblem.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo sự cố'**
  String get helpReportProblem;

  /// No description provided for @helpContactSupport.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ hỗ trợ'**
  String get helpContactSupport;

  /// No description provided for @helpPetSafety.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ an toàn cho thú cưng'**
  String get helpPetSafety;

  /// No description provided for @helpFlagBug.
  ///
  /// In vi, this message translates to:
  /// **'Báo lỗi, bước gây khó hiểu hoặc bài đăng không an toàn'**
  String get helpFlagBug;

  /// No description provided for @helpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & hỗ trợ'**
  String get helpTitle;

  /// No description provided for @helpEmergencyTips.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo khẩn cấp'**
  String get helpEmergencyTips;

  /// No description provided for @helpEmergencyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nên làm gì nếu thú cưng bị thương hoặc gặp nguy hiểm ngay lập tức'**
  String get helpEmergencyDesc;

  /// No description provided for @helpSafetyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Những lưu ý nhanh để xử lý và di chuyển thú cưng an toàn'**
  String get helpSafetyDesc;

  /// No description provided for @communityEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Một nơi để chia sẻ chăm sóc địa phương, hỗ trợ và những cập nhật đầy hy vọng.'**
  String get communityEmptyDesc;

  /// No description provided for @communityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng thú cưng'**
  String get communityTitle;

  /// No description provided for @communitySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm mẹo, câu chuyện hoặc hỗ trợ cứu hộ'**
  String get communitySearchHint;

  /// No description provided for @communitySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ cập nhật, mẹo an toàn, câu chuyện đoàn tụ và hỗ trợ thú cưng gần bạn.'**
  String get communitySubtitle;

  /// No description provided for @communityCreatePostBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết'**
  String get communityCreatePostBtn;

  /// No description provided for @communityCreateSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ điều gì đó hữu ích, đầy hy vọng và dễ hành động.'**
  String get communityCreateSubtitle;

  /// No description provided for @communityCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết'**
  String get communityCreateTitle;

  /// No description provided for @communityPublishBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng bài'**
  String get communityPublishBtn;

  /// No description provided for @communityRelatedPosts.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết liên quan'**
  String get communityRelatedPosts;

  /// No description provided for @communityCreateOwnBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bài viết của bạn'**
  String get communityCreateOwnBtn;

  /// No description provided for @communityStoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện cộng đồng'**
  String get communityStoryTitle;

  /// No description provided for @communityStoryDesc.
  ///
  /// In vi, this message translates to:
  /// **'Một cập nhật tích cực, mẹo hữu ích hoặc ghi chú hỗ trợ địa phương.'**
  String get communityStoryDesc;

  /// No description provided for @communityPostNotFoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết cộng đồng này có thể đã bị xóa hoặc liên kết không còn hoạt động.'**
  String get communityPostNotFoundDesc;

  /// No description provided for @communityPostNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài viết'**
  String get communityPostNotFoundTitle;

  /// No description provided for @communityComments.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get communityComments;

  /// No description provided for @communityWidgetEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết cộng đồng'**
  String get communityWidgetEmpty;

  /// No description provided for @communityWidgetPhotoHint.
  ///
  /// In vi, this message translates to:
  /// **'Sau này hãy dùng ảnh đầy hy vọng, khoảnh khắc đoàn tụ hoặc vùng minh họa hữu ích tại đây.'**
  String get communityWidgetPhotoHint;

  /// No description provided for @communityWidgetTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get communityWidgetTitleLabel;

  /// No description provided for @communityWidgetContentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung bài viết'**
  String get communityWidgetContentLabel;

  /// No description provided for @communityWidgetTellHint.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ với khu vực của bạn điều gì đó hữu ích'**
  String get communityWidgetTellHint;

  /// No description provided for @communityWidgetFeatured.
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện nổi bật'**
  String get communityWidgetFeatured;

  /// No description provided for @communityWidgetLocal.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng địa phương'**
  String get communityWidgetLocal;

  /// No description provided for @communityWidgetWiderArea.
  ///
  /// In vi, this message translates to:
  /// **'Khu vực rộng hơn'**
  String get communityWidgetWiderArea;

  /// No description provided for @communityWidgetFirstShare.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên chia sẻ một mẹo, cập nhật hoặc tin vui đoàn tụ.'**
  String get communityWidgetFirstShare;

  /// No description provided for @communityWidgetTips.
  ///
  /// In vi, this message translates to:
  /// **'Giữ nội dung ấm áp, gần gũi và dễ hành động. Mẹo chăm sóc, cập nhật đoàn tụ, hỗ trợ cứu hộ và câu chuyện nhận nuôi phù hợp nhất ở đây.'**
  String get communityWidgetTips;

  /// No description provided for @notiSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo gần bạn, cập nhật báo cáo và lời nhắc theo dõi nhanh.'**
  String get notiSubtitle;

  /// No description provided for @notiEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo nào'**
  String get notiEmptyTitle;

  /// No description provided for @notiEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo gần bạn và cập nhật báo cáo sẽ xuất hiện tại đây khi có hoạt động.'**
  String get notiEmptyDesc;

  /// No description provided for @notiOpenReport.
  ///
  /// In vi, this message translates to:
  /// **'Mở báo cáo'**
  String get notiOpenReport;

  /// No description provided for @notiTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notiTitle;

  /// No description provided for @reminderCompletedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Một việc nhỏ đã xong, bớt đi một điều phải lo lắng.'**
  String get reminderCompletedDesc;

  /// No description provided for @reminderCompletedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành chăm sóc'**
  String get reminderCompletedTitle;

  /// No description provided for @reminderOverviewSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đừng bỏ lỡ những thời điểm quan trọng của thú cưng.'**
  String get reminderOverviewSubtitle;

  /// No description provided for @reminderAddBtn.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhắc lịch'**
  String get reminderAddBtn;

  /// No description provided for @reminderNotes.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get reminderNotes;

  /// No description provided for @reminderDetailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Một nơi nhẹ nhàng để xem kế hoạch chăm sóc và các bước tiếp theo.'**
  String get reminderDetailSubtitle;

  /// No description provided for @reminderSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch trình'**
  String get reminderSchedule;

  /// No description provided for @reminderDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết nhắc lịch'**
  String get reminderDetailTitle;

  /// No description provided for @reminderNotFoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lịch này có thể đã bị xóa hoặc liên kết không còn hoạt động.'**
  String get reminderNotFoundDesc;

  /// No description provided for @reminderNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy nhắc lịch'**
  String get reminderNotFoundTitle;

  /// No description provided for @reminderAddSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ kế hoạch nhẹ nhàng, rõ ràng và dễ theo dõi.'**
  String get reminderAddSubtitle;

  /// No description provided for @reminderAddHelpfulNotes.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú hữu ích'**
  String get reminderAddHelpfulNotes;

  /// No description provided for @reminderAddTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get reminderAddTime;

  /// No description provided for @reminderAddWhat.
  ///
  /// In vi, this message translates to:
  /// **'Cần thực hiện điều gì?'**
  String get reminderAddWhat;

  /// No description provided for @reminderAddWhen.
  ///
  /// In vi, this message translates to:
  /// **'Khi nào nên nhắc bạn?'**
  String get reminderAddWhen;

  /// No description provided for @reminderAddRepeatHint.
  ///
  /// In vi, this message translates to:
  /// **'Giữ phần lặp lại đơn giản cho MVP. Đây hiện chỉ là UI mô phỏng.'**
  String get reminderAddRepeatHint;

  /// No description provided for @reminderAddPet.
  ///
  /// In vi, this message translates to:
  /// **'Thú cưng'**
  String get reminderAddPet;

  /// No description provided for @reminderAddType.
  ///
  /// In vi, this message translates to:
  /// **'Loại nhắc lịch'**
  String get reminderAddType;

  /// No description provided for @reminderAddRepeat.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn lặp lại'**
  String get reminderAddRepeat;

  /// No description provided for @reminderAddDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get reminderAddDate;

  /// No description provided for @reminderDetailDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa nhắc lịch'**
  String get reminderDetailDelete;

  /// No description provided for @reminderDetailBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Nhắc lịch'**
  String get reminderDetailBack;

  /// No description provided for @reminderDetailEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa nhắc lịch'**
  String get reminderDetailEdit;

  /// No description provided for @reminderDetailMarkCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn thành'**
  String get reminderDetailMarkCompleted;

  /// No description provided for @reminderTypeGrooming.
  ///
  /// In vi, this message translates to:
  /// **'Grooming'**
  String get reminderTypeGrooming;

  /// No description provided for @reminderWidgetKeepReady.
  ///
  /// In vi, this message translates to:
  /// **'Giữ lịch tiêm phòng, grooming và khám thú y luôn sẵn sàng cho thú cưng bạn yêu quý.'**
  String get reminderWidgetKeepReady;

  /// No description provided for @reminderTypeDeworming.
  ///
  /// In vi, this message translates to:
  /// **'Tẩy giun'**
  String get reminderTypeDeworming;

  /// No description provided for @reminderTypeMedication.
  ///
  /// In vi, this message translates to:
  /// **'Thuốc'**
  String get reminderTypeMedication;

  /// No description provided for @reminderWidgetSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi nhắc nhở nhẹ nhàng'**
  String get reminderWidgetSend;

  /// No description provided for @reminderWidgetTrack.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi tiêm phòng, grooming, thuốc và lịch khám thú y trong một nơi dịu dàng.'**
  String get reminderWidgetTrack;

  /// No description provided for @reminderWidgetPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tạm thời dùng placeholder cho thông báo cục bộ.'**
  String get reminderWidgetPlaceholder;

  /// No description provided for @reminderTypeVaccination.
  ///
  /// In vi, this message translates to:
  /// **'Tiêm phòng'**
  String get reminderTypeVaccination;

  /// No description provided for @reminderWidgetCalmPlan.
  ///
  /// In vi, this message translates to:
  /// **'Một kế hoạch chăm sóc nhẹ nhàng'**
  String get reminderWidgetCalmPlan;

  /// No description provided for @reminderWidgetAddFirst.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhắc lịch đầu tiên'**
  String get reminderWidgetAddFirst;

  /// No description provided for @reminderTypeVetVisit.
  ///
  /// In vi, this message translates to:
  /// **'Khám thú y'**
  String get reminderTypeVetVisit;

  /// No description provided for @splashLocalHelpers.
  ///
  /// In vi, this message translates to:
  /// **'Có người hỗ trợ gần bạn'**
  String get splashLocalHelpers;

  /// No description provided for @reportNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy báo cáo'**
  String get reportNotFoundTitle;

  /// No description provided for @reportContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ'**
  String get reportContact;

  /// No description provided for @reportViewMap.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản đồ'**
  String get reportViewMap;

  /// No description provided for @reportStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get reportStatus;

  /// No description provided for @reportDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết báo cáo'**
  String get reportDetailTitle;

  /// No description provided for @reportNotFoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo này có thể đã bị xóa hoặc liên kết không còn hoạt động.'**
  String get reportNotFoundDesc;

  /// No description provided for @reportKeyDetails.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin chính'**
  String get reportKeyDetails;

  /// No description provided for @reportLastUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật gần nhất'**
  String get reportLastUpdate;

  /// No description provided for @reportApproxArea.
  ///
  /// In vi, this message translates to:
  /// **'Khu vực gần đúng'**
  String get reportApproxArea;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @commonEmptyStateIllustration.
  ///
  /// In vi, this message translates to:
  /// **'Minh họa trạng thái trống'**
  String get commonEmptyStateIllustration;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get languageJapanese;

  /// No description provided for @languageKorean.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Hàn'**
  String get languageKorean;

  /// No description provided for @languageChinese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Trung'**
  String get languageChinese;

  /// No description provided for @authBadgeSavedHelper.
  ///
  /// In vi, this message translates to:
  /// **'Người hỗ trợ đã lưu'**
  String get authBadgeSavedHelper;

  /// No description provided for @authBadgeSafeContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ an toàn'**
  String get authBadgeSafeContact;

  /// No description provided for @authBadgeSecureMail.
  ///
  /// In vi, this message translates to:
  /// **'Email bảo mật'**
  String get authBadgeSecureMail;

  /// No description provided for @authBadgeSecureCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã cứu hộ an toàn'**
  String get authBadgeSecureCode;

  /// No description provided for @authBadgeReadyToHelp.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng hỗ trợ'**
  String get authBadgeReadyToHelp;

  /// No description provided for @splashCaseAlert.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo trường hợp gần đây'**
  String get splashCaseAlert;

  /// No description provided for @splashLiveTrail.
  ///
  /// In vi, this message translates to:
  /// **'Dấu vết trực tiếp'**
  String get splashLiveTrail;

  /// No description provided for @chatHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ mọi đầu mối trong tầm tay'**
  String get chatHeroTitle;

  /// No description provided for @chatHeroBody.
  ///
  /// In vi, this message translates to:
  /// **'Những cuộc trò chuyện an toàn và ấm áp giúp chủ nuôi và người hỗ trợ phối hợp nhanh hơn khi từng phút đều quan trọng.'**
  String get chatHeroBody;

  /// No description provided for @chatConversationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện'**
  String get chatConversationTitle;

  /// No description provided for @chatConversationSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật an toàn và phối hợp nhanh quanh một báo cáo.'**
  String get chatConversationSubtitle;

  /// No description provided for @chatConversationUnavailableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không mở được cuộc trò chuyện'**
  String get chatConversationUnavailableTitle;

  /// No description provided for @chatConversationUnavailableDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện này có thể đã bị xóa hoặc không còn tồn tại.'**
  String get chatConversationUnavailableDesc;

  /// No description provided for @chatBackToMessages.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Tin nhắn'**
  String get chatBackToMessages;

  /// No description provided for @chatAlreadyInThread.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang ở trong cuộc trò chuyện này rồi.'**
  String get chatAlreadyInThread;

  /// No description provided for @chatShareLocationReady.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí gần đây đã sẵn sàng để gửi.'**
  String get chatShareLocationReady;

  /// No description provided for @chatPhotoPickerLater.
  ///
  /// In vi, this message translates to:
  /// **'Trình chọn ảnh sẽ được mở ở đây sau.'**
  String get chatPhotoPickerLater;

  /// No description provided for @chatMessageSentTo.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi tin nhắn cho {name}.'**
  String chatMessageSentTo(Object name);

  /// No description provided for @chatCallingName.
  ///
  /// In vi, this message translates to:
  /// **'Đang gọi cho {name}...'**
  String chatCallingName(Object name);

  /// No description provided for @chatOpeningSmsComposer.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở trình soạn SMS...'**
  String get chatOpeningSmsComposer;

  /// No description provided for @chatSharingReport.
  ///
  /// In vi, this message translates to:
  /// **'Đang chia sẻ báo cáo...'**
  String get chatSharingReport;

  /// No description provided for @mapSightingFlowLater.
  ///
  /// In vi, this message translates to:
  /// **'Luồng gửi thông tin nhìn thấy sẽ được mở ở đây sau.'**
  String get mapSightingFlowLater;

  /// No description provided for @communityBackToFeed.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Cộng đồng'**
  String get communityBackToFeed;

  /// No description provided for @communityPostShared.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết cộng đồng đã được chia sẻ.'**
  String get communityPostShared;

  /// No description provided for @communityCategorySafetyTips.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo an toàn'**
  String get communityCategorySafetyTips;

  /// No description provided for @communityCategoryReunionStories.
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện đoàn tụ'**
  String get communityCategoryReunionStories;

  /// No description provided for @communityCategoryLostPetAwareness.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thức về thú cưng thất lạc'**
  String get communityCategoryLostPetAwareness;

  /// No description provided for @communityCategoryRescueSupport.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ cứu hộ'**
  String get communityCategoryRescueSupport;

  /// No description provided for @communityCategoryAdoption.
  ///
  /// In vi, this message translates to:
  /// **'Nhận nuôi'**
  String get communityCategoryAdoption;

  /// No description provided for @profileReportsTabActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get profileReportsTabActive;

  /// No description provided for @profileReportsTabReunited.
  ///
  /// In vi, this message translates to:
  /// **'Đã đoàn tụ'**
  String get profileReportsTabReunited;

  /// No description provided for @profileReportsTabClosed.
  ///
  /// In vi, this message translates to:
  /// **'Đã đóng'**
  String get profileReportsTabClosed;

  /// No description provided for @reminderMarkedCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu nhắc lịch là hoàn thành.'**
  String get reminderMarkedCompleted;

  /// No description provided for @reminderDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa nhắc lịch.'**
  String get reminderDeleted;

  /// No description provided for @reminderNotificationsEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get reminderNotificationsEnabled;

  /// No description provided for @reminderNotificationsMuted.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt'**
  String get reminderNotificationsMuted;

  /// No description provided for @reminderCareNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú chăm sóc'**
  String get reminderCareNote;

  /// No description provided for @petHintName.
  ///
  /// In vi, this message translates to:
  /// **'Luna'**
  String get petHintName;

  /// No description provided for @petHintBreed.
  ///
  /// In vi, this message translates to:
  /// **'Golden Retriever'**
  String get petHintBreed;

  /// No description provided for @petHintColor.
  ///
  /// In vi, this message translates to:
  /// **'Vàng mật ong'**
  String get petHintColor;

  /// No description provided for @petHintWeight.
  ///
  /// In vi, this message translates to:
  /// **'28 kg'**
  String get petHintWeight;

  /// No description provided for @petHintMarks.
  ///
  /// In vi, this message translates to:
  /// **'Mảng lông trắng ở ngực và vòng cổ xanh ngọc'**
  String get petHintMarks;

  /// No description provided for @petHintMicrochip.
  ///
  /// In vi, this message translates to:
  /// **'985141000123456'**
  String get petHintMicrochip;

  /// No description provided for @petHintVaccination.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật đầy đủ'**
  String get petHintVaccination;

  /// No description provided for @petHintMedicalNotes.
  ///
  /// In vi, this message translates to:
  /// **'Dị ứng, thuốc đang dùng, ghi chú thú y'**
  String get petHintMedicalNotes;

  /// No description provided for @petAgeTwoYears.
  ///
  /// In vi, this message translates to:
  /// **'2 tuổi'**
  String get petAgeTwoYears;

  /// No description provided for @petAgeElevenMonths.
  ///
  /// In vi, this message translates to:
  /// **'11 tháng tuổi'**
  String get petAgeElevenMonths;

  /// No description provided for @authHintEmail.
  ///
  /// In vi, this message translates to:
  /// **'ban@example.com'**
  String get authHintEmail;

  /// No description provided for @authHintEnterPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu của bạn'**
  String get authHintEnterPassword;

  /// No description provided for @authHintYourName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên của bạn'**
  String get authHintYourName;

  /// No description provided for @authHintCreatePassword.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu an toàn'**
  String get authHintCreatePassword;

  /// No description provided for @authHintRepeatPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get authHintRepeatPassword;

  /// No description provided for @chatTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luôn kết nối với chủ nuôi, người báo tin và người hỗ trợ.'**
  String get chatSubtitle;

  /// No description provided for @chatSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm cuộc trò chuyện'**
  String get chatSearchHint;

  /// No description provided for @chatComposerHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết một cập nhật ấm áp và hữu ích'**
  String get chatComposerHint;

  /// No description provided for @chatActionSms.
  ///
  /// In vi, this message translates to:
  /// **'Gửi SMS'**
  String get chatActionSms;

  /// No description provided for @chatActionInApp.
  ///
  /// In vi, this message translates to:
  /// **'Chat trong app'**
  String get chatActionInApp;

  /// No description provided for @chatActionShareReport.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ báo cáo'**
  String get chatActionShareReport;

  /// No description provided for @chatActionActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get chatActionActive;

  /// No description provided for @chatStatusResolved.
  ///
  /// In vi, this message translates to:
  /// **'Đã giải quyết'**
  String get chatStatusResolved;

  /// No description provided for @chatStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get chatStatusActive;

  /// No description provided for @chatStatusPossibleMatch.
  ///
  /// In vi, this message translates to:
  /// **'Có thể trùng khớp'**
  String get chatStatusPossibleMatch;

  /// No description provided for @chatStatusReported.
  ///
  /// In vi, this message translates to:
  /// **'Đã báo cáo'**
  String get chatStatusReported;

  /// No description provided for @chatEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy bắt đầu cuộc trò chuyện khi có đầu mối mới xuất hiện gần bạn.'**
  String get chatEmptyMessage;

  /// No description provided for @chatDistanceAway.
  ///
  /// In vi, this message translates to:
  /// **'Cách {distance} km'**
  String chatDistanceAway(Object distance);

  /// No description provided for @chatRoleOwner.
  ///
  /// In vi, this message translates to:
  /// **'Chủ nuôi'**
  String get chatRoleOwner;

  /// No description provided for @chatRoleReporter.
  ///
  /// In vi, this message translates to:
  /// **'Người báo tin'**
  String get chatRoleReporter;

  /// No description provided for @chatRoleHelper.
  ///
  /// In vi, this message translates to:
  /// **'Người hỗ trợ'**
  String get chatRoleHelper;

  /// No description provided for @remindersSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu nhắc lịch.'**
  String get remindersSaved;

  /// No description provided for @remindersEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa nhắc lịch'**
  String get remindersEditTitle;

  /// No description provided for @remindersAddTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhắc lịch'**
  String get remindersAddTitle;

  /// No description provided for @remindersTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Tiêm nhắc dại'**
  String get remindersTitleHint;

  /// No description provided for @remindersNotesHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú hữu ích: mang theo sổ thú cưng và món ăn vặt yêu thích.'**
  String get remindersNotesHint;

  /// No description provided for @remindersSaveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get remindersSaveChanges;

  /// No description provided for @remindersSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nhắc lịch'**
  String get remindersSave;

  /// No description provided for @remindersRepeat.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại'**
  String get remindersRepeat;

  /// No description provided for @remindersStatusUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới'**
  String get remindersStatusUpcoming;

  /// No description provided for @remindersStatusDueSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp đến hạn'**
  String get remindersStatusDueSoon;

  /// No description provided for @remindersStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get remindersStatusCompleted;

  /// No description provided for @remindersActiveLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang theo dõi'**
  String get remindersActiveLabel;

  /// No description provided for @remindersDueTodayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đến hạn hôm nay'**
  String get remindersDueTodayLabel;

  /// No description provided for @remindersCompletedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get remindersCompletedLabel;

  /// No description provided for @remindersBucketToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get remindersBucketToday;

  /// No description provided for @remindersBucketTomorrow.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mai'**
  String get remindersBucketTomorrow;

  /// No description provided for @remindersBucketThisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get remindersBucketThisWeek;

  /// No description provided for @remindersBucketLater.
  ///
  /// In vi, this message translates to:
  /// **'Sau đó'**
  String get remindersBucketLater;

  /// No description provided for @helpFaq1Question.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để tạo cảnh báo mất thú cưng hiệu quả?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In vi, this message translates to:
  /// **'Hãy dùng ảnh rõ ràng, vị trí nhìn thấy lần cuối, thời gian thất lạc và thông tin liên hệ an toàn. Giữ mô tả ngắn gọn, chính xác và dễ đọc.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In vi, this message translates to:
  /// **'Khi nào tôi nên ẩn vị trí chính xác?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In vi, this message translates to:
  /// **'Nếu thú cưng có giá trị cao, bị thương hoặc ở khu vực rủi ro, hãy bắt đầu với vị trí rộng hơn và chỉ chia sẻ ghim chính xác khi liên hệ trực tiếp.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In vi, this message translates to:
  /// **'Tôi nên làm gì trước khi tiếp cận một thú cưng đang sợ hãi?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chậm lại, hạ thấp người, tránh nhìn chằm chằm và để thú cưng tự quyết định có tiến lại gần hay không. Thức ăn và nước uống có thể giúp ích.'**
  String get helpFaq3Answer;

  /// No description provided for @savedReportsExploreNearby.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá báo cáo gần đây'**
  String get savedReportsExploreNearby;

  /// No description provided for @commonBackToProfile.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Cá nhân'**
  String get commonBackToProfile;

  /// No description provided for @notiMockNearbyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thú cưng thất lạc gần bạn'**
  String get notiMockNearbyTitle;

  /// No description provided for @notiMockNearbyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Luna vừa được báo mất cách bạn 1,2 km.'**
  String get notiMockNearbyMessage;

  /// No description provided for @notiMockFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tìm thấy đã được cập nhật'**
  String get notiMockFoundTitle;

  /// No description provided for @notiMockFoundMessage.
  ///
  /// In vi, this message translates to:
  /// **'Một báo cáo mèo mướp cam gần bạn vừa có ảnh rõ hơn.'**
  String get notiMockFoundMessage;

  /// No description provided for @notiMockReminderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có nhắc lịch trong hôm nay'**
  String get notiMockReminderTitle;

  /// No description provided for @notiMockReminderMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lịch grooming của Luna được đặt vào tối nay.'**
  String get notiMockReminderMessage;

  /// No description provided for @timeNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get timeNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String timeHoursAgo(int count);

  /// No description provided for @mapFilterSeen.
  ///
  /// In vi, this message translates to:
  /// **'Đã thấy'**
  String get mapFilterSeen;

  /// No description provided for @mapFilterUrgent.
  ///
  /// In vi, this message translates to:
  /// **'Khẩn cấp'**
  String get mapFilterUrgent;

  /// No description provided for @mapLoadingLocation.
  ///
  /// In vi, this message translates to:
  /// **'Đang tìm vị trí...'**
  String get mapLoadingLocation;

  /// No description provided for @mapLocationPermissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền truy cập vị trí'**
  String get mapLocationPermissionRequired;

  /// No description provided for @mapLocationPermissionDeniedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cho phép truy cập vị trí để xem các cảnh báo thú cưng thất lạc gần bạn.'**
  String get mapLocationPermissionDeniedDesc;

  /// No description provided for @mapLocationPermissionDeniedForeverDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng vào Cài đặt để cấp quyền.'**
  String get mapLocationPermissionDeniedForeverDesc;

  /// No description provided for @mapLocationServiceDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Dịch vụ vị trí bị tắt'**
  String get mapLocationServiceDisabled;

  /// No description provided for @mapLocationServiceDisabledDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật dịch vụ vị trí để sử dụng bản đồ.'**
  String get mapLocationServiceDisabledDesc;

  /// No description provided for @mapOpenSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt'**
  String get mapOpenSettings;

  /// No description provided for @mapRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get mapRetry;

  /// No description provided for @mapReportsNearby.
  ///
  /// In vi, this message translates to:
  /// **'{count} báo cáo gần đây'**
  String mapReportsNearby(int count);

  /// No description provided for @mapBadgeLost.
  ///
  /// In vi, this message translates to:
  /// **'THẤT LẠC'**
  String get mapBadgeLost;

  /// No description provided for @mapBadgeFound.
  ///
  /// In vi, this message translates to:
  /// **'TÌM THẤY'**
  String get mapBadgeFound;

  /// No description provided for @mapBadgeUrgent.
  ///
  /// In vi, this message translates to:
  /// **'KHẨN CẤP'**
  String get mapBadgeUrgent;

  /// No description provided for @mapBadgeReunited.
  ///
  /// In vi, this message translates to:
  /// **'ĐOÀN TỤ'**
  String get mapBadgeReunited;

  /// No description provided for @mapAway.
  ///
  /// In vi, this message translates to:
  /// **'cách đây'**
  String get mapAway;

  /// No description provided for @mapView.
  ///
  /// In vi, this message translates to:
  /// **'Xem'**
  String get mapView;

  /// No description provided for @mapViewDetails.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get mapViewDetails;

  /// No description provided for @mapContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ'**
  String get mapContact;

  /// No description provided for @mapNavigate.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ đường'**
  String get mapNavigate;

  /// No description provided for @mapUrgentNearbyAlert.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo khẩn cấp gần đây'**
  String get mapUrgentNearbyAlert;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
