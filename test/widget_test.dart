import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/app/app.dart';
import 'package:pet_finder/app/router.dart';
import 'package:pet_finder/core/localization/locale_controller.dart';
import 'package:pet_finder/features/auth/data/auth_repository.dart';
import 'package:pet_finder/features/auth/domain/auth_user.dart';
import 'package:pet_finder/features/auth/presentation/bloc/auth_session_controller.dart';
import 'package:pet_finder/features/mock/mock_data.dart';
import 'package:pet_finder/features/onboarding/domain/onboarding_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(PetFinderApp(localeController: appLocaleController));
  await tester.pump();
}

void main() {
  late FakeAuthRepository fakeAuthRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeAuthRepository = FakeAuthRepository();
    AuthRepository.overrideInstanceForTest(fakeAuthRepository);
    authSession.start(authRepository: fakeAuthRepository);
    await appLocaleController.updateLocale(const Locale('en'));
    onboardingController.resetForTest();
    appRouter.goNamed(AppRoute.splash.name);
  });

  testWidgets('app launches with splash screen', (tester) async {
    await pumpApp(tester);

    expect(find.text('Pet Finder'), findsOneWidget);
    expect(find.text('Helping pets find their way home'), findsOneWidget);
  });

  testWidgets('splash leads to onboarding', (tester) async {
    await pumpApp(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Report a lost pet in seconds'), findsOneWidget);
  });

  testWidgets('splash skips onboarding after completion', (tester) async {
    await onboardingController.complete();
    appRouter.goNamed(AppRoute.splash.name);

    await pumpApp(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome home'), findsOneWidget);
    expect(find.text('Report a lost pet in seconds'), findsNothing);
  });

  testWidgets('home renders for authenticated users', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
    expect(find.text('Report Lost Pet'), findsOneWidget);
    expect(find.text('Report Found Pet'), findsOneWidget);
  });

  testWidgets('report flow renders', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.reportCreate.name);
    await tester.pumpAndSettle();

    expect(find.text('I lost my pet'), findsOneWidget);
    expect(find.text('I found a pet'), findsOneWidget);
  });

  testWidgets('bottom navigation routes to pets list', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pets').last);
    await tester.pumpAndSettle();

    expect(find.text('Your little family'), findsOneWidget);
  });

  testWidgets('profile settings render', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.profileOverview.name);
    await tester.pumpAndSettle();

    expect(find.text('Profile & Care'), findsOneWidget);

    appRouter.goNamed(AppRoute.settings.name);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Nearby lost pet alerts'), findsOneWidget);
  });

  testWidgets('login back button falls back to welcome', (tester) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.login.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Welcome home'), findsOneWidget);
  });

  testWidgets('register back button falls back to welcome', (tester) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.signUp.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Welcome home'), findsOneWidget);
  });

  testWidgets('login form authenticates with repository', (tester) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.login.name);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.ensureVisible(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
  });

  testWidgets('login form validates required fields before submit', (
    tester,
  ) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.login.name);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Log in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Email không được để trống.'), findsOneWidget);
    expect(find.text('Mật khẩu không được để trống.'), findsOneWidget);
    expect(fakeAuthRepository.currentUser, isNull);
  });

  testWidgets('auth input dismisses keyboard when tapping outside', (
    tester,
  ) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.login.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).first);
    await tester.pump();
    final inputState = tester.state<EditableTextState>(
      find.byType(EditableText).first,
    );
    expect(inputState.widget.focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Welcome back'));
    await tester.pump();

    expect(inputState.widget.focusNode.hasFocus, isFalse);
  });

  testWidgets('sign up form validates password strength', (tester) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.signUp.name);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.enterText(find.byType(TextField).at(3), 'password');
    await tester.ensureVisible(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Mật khẩu cần có chữ hoa, chữ thường và số hoặc ký tự đặc biệt.',
      ),
      findsOneWidget,
    );
    expect(fakeAuthRepository.currentUser, isNull);
  });

  testWidgets('forgot password form shows success state', (tester) async {
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.forgotPassword.name);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'test@example.com');
    await tester.tap(find.text('Send Reset Code'));
    await tester.pumpAndSettle();

    expect(fakeAuthRepository.passwordResetEmail, 'test@example.com');
  });

  testWidgets('notifications back button falls back to home', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.notifications.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
  });

  testWidgets('report detail back button falls back to home', (tester) async {
    fakeAuthRepository.setUser(FakeAuthRepository.testUser);
    await pumpApp(tester);
    appRouter.goNamed(
      AppRoute.reportDetail.name,
      pathParameters: {'reportId': MockData.allReports.first.id},
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
  });

  test('maps Firebase auth errors to user-facing messages', () {
    final invalidEmail = AuthFailure.fromFirebase(
      firebase_auth.FirebaseAuthException(code: 'invalid-email'),
    );
    final duplicateEmail = AuthFailure.fromFirebase(
      firebase_auth.FirebaseAuthException(code: 'email-already-in-use'),
    );

    expect(invalidEmail.message, 'Email không hợp lệ.');
    expect(duplicateEmail.message, 'Email này đã được sử dụng.');
  });
}

class FakeAuthRepository implements AuthRepository {
  static const testUser = AuthUser(
    id: 'test-user',
    email: 'test@example.com',
    name: 'Test User',
  );

  final _controller = Stream<AuthUser?>.multi((controller) {});
  AuthUser? _currentUser;
  String? passwordResetEmail;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  bool get isLoggedIn => _currentUser != null;

  @override
  Stream<AuthUser?> authStateChanges() => _controller;

  void setUser(AuthUser? user) {
    _currentUser = user;
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    _currentUser = testUser;
    return testUser;
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    _currentUser = testUser;
    return testUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<void> resetPassword(String email) async {
    passwordResetEmail = email;
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {}

  @override
  Future<void> verifyOtp(String otpCode) async {}

  @override
  Future<AuthUser> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    _currentUser = _currentUser?.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
    return _currentUser ?? testUser;
  }
}
