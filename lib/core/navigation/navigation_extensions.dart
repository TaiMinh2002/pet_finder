import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';

extension NavigationExtensions on BuildContext {
  void safeBack({
    AppRoute? fallbackRoute,
    String? fallbackLocation,
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
      return;
    }

    if (fallbackRoute != null) {
      router.goNamed(
        fallbackRoute.name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
      return;
    }

    if (fallbackLocation != null) {
      router.go(fallbackLocation);
    }
  }

  void safeBackNamed(
    AppRoute fallbackRoute, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) {
    safeBack(
      fallbackRoute: fallbackRoute,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  void safeClose<T extends Object?>([T? result]) {
    final navigator = Navigator.maybeOf(this);
    if (navigator?.canPop() ?? false) {
      navigator!.pop(result);
    }
  }
}
