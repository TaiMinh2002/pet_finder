import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/auth_repository.dart';
import '../../domain/auth_user.dart';

class AuthSessionController extends ChangeNotifier {
  AuthSessionController({AuthRepository? authRepository})
    : _authRepository = authRepository;

  AuthRepository? _authRepository;
  StreamSubscription<AuthUser?>? _subscription;
  AuthUser? _user;
  var _isReady = false;

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isReady => _isReady;

  void start({AuthRepository? authRepository}) {
    _authRepository =
        authRepository ?? _authRepository ?? AuthRepository.instance;
    _subscription?.cancel();
    _user = _authRepository!.currentUser;
    _isReady = true;
    _subscription = _authRepository!.authStateChanges().listen((user) {
      _user = user;
      _isReady = true;
      notifyListeners();
    });
    notifyListeners();
  }

  void setUserForTest(AuthUser? user) {
    _subscription?.cancel();
    _user = user;
    _isReady = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authSession = AuthSessionController();
