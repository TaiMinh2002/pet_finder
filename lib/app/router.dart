import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/account_success_screen.dart';
import '../features/auth/presentation/pages/forgot_password_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/otp_verification_screen.dart';
import '../features/auth/presentation/pages/sign_up_screen.dart';
import '../features/auth/presentation/pages/welcome_screen.dart';
import '../features/chat/presentation/pages/chat_detail_screen.dart';
import '../features/chat/presentation/pages/chat_list_screen.dart';
import '../features/community/presentation/pages/community_empty_screen.dart';
import '../features/community/presentation/pages/community_feed_screen.dart';
import '../features/community/presentation/pages/community_post_detail_screen.dart';
import '../features/community/presentation/pages/create_community_post_screen.dart';
import '../features/home/presentation/pages/home_dashboard_screen.dart';
import '../features/language/presentation/pages/language_screen.dart';
import '../features/map/presentation/pages/nearby_alerts_map_screen.dart';
import '../features/notifications/presentation/pages/notifications_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../features/onboarding/presentation/pages/splash_screen.dart';
import '../features/onboarding/domain/onboarding_controller.dart';
import '../features/pets/presentation/pages/add_pet_profile_screen.dart';
import '../features/pets/presentation/pages/edit_pet_profile_screen.dart';
import '../features/pets/presentation/pages/my_pets_empty_screen.dart';
import '../features/pets/presentation/pages/my_pets_list_screen.dart';
import '../features/pets/presentation/pages/pet_profile_detail_screen.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';
import '../features/profile/presentation/pages/help_support_screen.dart';
import '../features/profile/presentation/pages/my_reports_screen.dart';
import '../features/profile/presentation/pages/profile_overview_screen.dart';
import '../features/profile/presentation/pages/saved_reports_screen.dart';
import '../features/profile/presentation/pages/settings_screen.dart';
import '../features/reminders/presentation/pages/add_reminder_screen.dart';
import '../features/reminders/presentation/pages/reminder_completed_screen.dart';
import '../features/reminders/presentation/pages/reminder_detail_screen.dart';
import '../features/reminders/presentation/pages/reminders_overview_screen.dart';
import '../features/reports/domain/pet_report_model.dart';
import '../features/reports/presentation/pages/report_detail_screen.dart';
import '../features/reports/presentation/pages/report_flow_screen.dart';

enum AppRoute {
  splash('/', 'splash'),
  onboarding('/onboarding', 'onboarding'),
  welcome('/auth/welcome', 'authWelcome'),
  login('/auth/login', 'login'),
  signUp('/auth/sign-up', 'signUp'),
  forgotPassword('/auth/forgot-password', 'forgotPassword'),
  otp('/auth/otp', 'otp'),
  accountSuccess('/auth/success', 'accountSuccess'),
  home('/home', 'home'),
  mapNearby('/map', 'mapNearby'),
  notifications('/notifications', 'notifications'),
  reportCreate('/reports/create', 'reportCreate'),
  reportDetail('/reports/:reportId', 'reportDetail'),
  petsList('/pets', 'petsList'),
  petsAdd('/pets/add', 'petsAdd'),
  petsDetail('/pets/:petId', 'petsDetail'),
  petsEdit('/pets/:petId/edit', 'petsEdit'),
  petsEmpty('/pets-empty', 'petsEmpty'),
  profileOverview('/profile', 'profileOverview'),
  profileEdit('/profile/edit', 'profileEdit'),
  settings('/profile/settings', 'settings'),
  language('/profile/language', 'language'),
  helpSupport('/profile/help', 'helpSupport'),
  savedReports('/profile/saved-reports', 'savedReports'),
  myReports('/profile/my-reports', 'myReports'),
  chatList('/chat', 'chatList'),
  chatDetail('/chat/:chatId', 'chatDetail'),
  communityFeed('/community', 'communityFeed'),
  communityDetail('/community/:postId', 'communityDetail'),
  communityCreate('/community/create', 'communityCreate'),
  communityEmpty('/community-empty', 'communityEmpty'),
  remindersOverview('/reminders', 'remindersOverview'),
  remindersAdd('/reminders/add', 'remindersAdd'),
  remindersDetail('/reminders/:reminderId', 'remindersDetail'),
  remindersEdit('/reminders/:reminderId/edit', 'remindersEdit'),
  remindersCompleted('/reminders/completed', 'remindersCompleted');

  const AppRoute(this.path, this.name);

  final String path;
  final String name;
}

class MockAuthController extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void signIn() {
    if (_isAuthenticated) return;
    _isAuthenticated = true;
    notifyListeners();
  }

  void signOut() {
    if (!_isAuthenticated) return;
    _isAuthenticated = false;
    notifyListeners();
  }
}

final mockAuth = MockAuthController();

const _publicRouteNames = {
  'splash',
  'onboarding',
  'authWelcome',
  'login',
  'signUp',
  'forgotPassword',
  'otp',
  'accountSuccess',
};

const _authenticatedRouteNames = {
  'home',
  'mapNearby',
  'notifications',
  'reportCreate',
  'reportDetail',
  'petsList',
  'petsAdd',
  'petsDetail',
  'petsEdit',
  'petsEmpty',
  'profileOverview',
  'profileEdit',
  'settings',
  'language',
  'helpSupport',
  'savedReports',
  'myReports',
  'chatList',
  'chatDetail',
  'communityFeed',
  'communityDetail',
  'communityCreate',
  'communityEmpty',
  'remindersOverview',
  'remindersAdd',
  'remindersDetail',
  'remindersEdit',
  'remindersCompleted',
};

final appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  refreshListenable: Listenable.merge([mockAuth, onboardingController]),
  redirect: (context, state) {
    final routeName = state.topRoute?.name;
    final isAuthenticated = mockAuth.isAuthenticated;
    final isPublic = _publicRouteNames.contains(routeName);
    final isProtected = _authenticatedRouteNames.contains(routeName);

    if (!isAuthenticated && isProtected) {
      return AppRoute.welcome.path;
    }

    if (isAuthenticated && isPublic) {
      return AppRoute.home.path;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      name: AppRoute.splash.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashScreen()),
    ),
    GoRoute(
      path: AppRoute.onboarding.path,
      name: AppRoute.onboarding.name,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoute.welcome.path,
      name: AppRoute.welcome.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: WelcomeScreen()),
    ),
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoute.signUp.path,
      name: AppRoute.signUp.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SignUpScreen()),
    ),
    GoRoute(
      path: AppRoute.forgotPassword.path,
      name: AppRoute.forgotPassword.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ForgotPasswordScreen()),
    ),
    GoRoute(
      path: AppRoute.otp.path,
      name: AppRoute.otp.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: OtpVerificationScreen()),
    ),
    GoRoute(
      path: AppRoute.accountSuccess.path,
      name: AppRoute.accountSuccess.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AccountSuccessScreen()),
    ),
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomeDashboardScreen()),
    ),
    GoRoute(
      path: AppRoute.mapNearby.path,
      name: AppRoute.mapNearby.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: NearbyAlertsMapScreen()),
    ),
    GoRoute(
      path: AppRoute.notifications.path,
      name: AppRoute.notifications.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: NotificationsScreen()),
    ),
    GoRoute(
      path: AppRoute.reportCreate.path,
      name: AppRoute.reportCreate.name,
      pageBuilder: (context, state) {
        final typeParam = state.uri.queryParameters['type'];
        final initialType = switch (typeParam) {
          'found' => PetReportType.found,
          'lost' => PetReportType.lost,
          _ => null,
        };
        return NoTransitionPage(
          child: ReportFlowScreen(initialType: initialType),
        );
      },
    ),
    GoRoute(
      path: AppRoute.reportDetail.path,
      name: AppRoute.reportDetail.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: ReportDetailScreen(
          reportId: state.pathParameters['reportId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.petsList.path,
      name: AppRoute.petsList.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MyPetsListScreen()),
    ),
    GoRoute(
      path: AppRoute.petsAdd.path,
      name: AppRoute.petsAdd.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AddPetProfileScreen()),
    ),
    GoRoute(
      path: AppRoute.petsDetail.path,
      name: AppRoute.petsDetail.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: PetProfileDetailScreen(
          petId: state.pathParameters['petId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.petsEdit.path,
      name: AppRoute.petsEdit.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: EditPetProfileScreen(petId: state.pathParameters['petId'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoute.petsEmpty.path,
      name: AppRoute.petsEmpty.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MyPetsEmptyScreen()),
    ),
    GoRoute(
      path: AppRoute.profileOverview.path,
      name: AppRoute.profileOverview.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ProfileOverviewScreen()),
    ),
    GoRoute(
      path: AppRoute.profileEdit.path,
      name: AppRoute.profileEdit.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: EditProfileScreen()),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      name: AppRoute.settings.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SettingsScreen()),
    ),
    GoRoute(
      path: AppRoute.language.path,
      name: AppRoute.language.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LanguageScreen()),
    ),
    GoRoute(
      path: AppRoute.helpSupport.path,
      name: AppRoute.helpSupport.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HelpSupportScreen()),
    ),
    GoRoute(
      path: AppRoute.savedReports.path,
      name: AppRoute.savedReports.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SavedReportsScreen()),
    ),
    GoRoute(
      path: AppRoute.myReports.path,
      name: AppRoute.myReports.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MyReportsScreen()),
    ),
    GoRoute(
      path: AppRoute.chatList.path,
      name: AppRoute.chatList.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ChatListScreen()),
    ),
    GoRoute(
      path: AppRoute.chatDetail.path,
      name: AppRoute.chatDetail.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: ChatDetailScreen(chatId: state.pathParameters['chatId'] ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoute.communityFeed.path,
      name: AppRoute.communityFeed.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CommunityFeedScreen()),
    ),
    GoRoute(
      path: AppRoute.communityDetail.path,
      name: AppRoute.communityDetail.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: CommunityPostDetailScreen(
          postId: state.pathParameters['postId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.communityCreate.path,
      name: AppRoute.communityCreate.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CreateCommunityPostScreen()),
    ),
    GoRoute(
      path: AppRoute.communityEmpty.path,
      name: AppRoute.communityEmpty.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CommunityEmptyScreen()),
    ),
    GoRoute(
      path: AppRoute.remindersOverview.path,
      name: AppRoute.remindersOverview.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: RemindersOverviewScreen()),
    ),
    GoRoute(
      path: AppRoute.remindersAdd.path,
      name: AppRoute.remindersAdd.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AddReminderScreen()),
    ),
    GoRoute(
      path: AppRoute.remindersDetail.path,
      name: AppRoute.remindersDetail.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: ReminderDetailScreen(
          reminderId: state.pathParameters['reminderId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.remindersEdit.path,
      name: AppRoute.remindersEdit.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: AddReminderScreen(
          reminderId: state.pathParameters['reminderId'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.remindersCompleted.path,
      name: AppRoute.remindersCompleted.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ReminderCompletedScreen()),
    ),
  ],
  errorBuilder: (context, state) => const SplashScreen(),
);
