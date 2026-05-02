import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/app/app.dart';
import 'package:pet_finder/app/router.dart';
import 'package:pet_finder/core/localization/locale_controller.dart';
import 'package:pet_finder/features/mock/mock_data.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(PetFinderApp(localeController: appLocaleController));
  await tester.pump();
}

void main() {
  setUp(() {
    mockAuth.signOut();
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

  testWidgets('home renders for authenticated users', (tester) async {
    mockAuth.signIn();
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
    expect(find.text('Report Lost Pet'), findsOneWidget);
    expect(find.text('Report Found Pet'), findsOneWidget);
  });

  testWidgets('report flow renders', (tester) async {
    mockAuth.signIn();
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.reportCreate.name);
    await tester.pumpAndSettle();

    expect(find.text('I lost my pet'), findsOneWidget);
    expect(find.text('I found a pet'), findsOneWidget);
  });

  testWidgets('bottom navigation routes to pets list', (tester) async {
    mockAuth.signIn();
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pets').last);
    await tester.pumpAndSettle();

    expect(find.text('Your little family'), findsOneWidget);
  });

  testWidgets('profile settings render', (tester) async {
    mockAuth.signIn();
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

  testWidgets('notifications back button falls back to home', (tester) async {
    mockAuth.signIn();
    await pumpApp(tester);
    appRouter.goNamed(AppRoute.notifications.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Lost or found a pet?'), findsOneWidget);
  });

  testWidgets('report detail back button falls back to home', (tester) async {
    mockAuth.signIn();
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
}
