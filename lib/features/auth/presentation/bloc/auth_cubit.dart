import 'dart:async';

import '../../../../core/bloc/bloc_exports.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository.instance,
      super(const AuthInitial()) {
    _subscription = _authRepository.authStateChanges().listen((user) {
      if (isClosed) return;
      if (user == null) {
        emit(const AuthInitial());
      } else {
        emit(AuthAuthenticated(user));
      }
    });
    _checkAuthStatus();
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<AuthUser?> _subscription;

  /// Check current authentication status
  void _checkAuthStatus() {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthInitial());
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final user = await _authRepository.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      await _authRepository.sendOtp(phoneNumber);
      emit(AuthOtpSent(phoneNumber));
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Verify OTP code
  Future<void> verifyOtp(String otpCode) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      await _authRepository.verifyOtp(otpCode);
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Không thể xác thực người dùng'));
      }
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      await _authRepository.resetPassword(email);
      emit(AuthPasswordResetSent(email));
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    try {
      await _authRepository.logout();
      emit(const AuthInitial());
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    if (state is AuthLoading) return;
    if (state is! AuthAuthenticated) {
      emit(const AuthError('Người dùng chưa đăng nhập'));
      return;
    }

    emit(const AuthLoading());

    try {
      final user = await _authRepository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_messageFromError(error)));
    }
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthInitial());
      }
    }
  }

  /// Get current user
  AuthUser? get currentUser => _authRepository.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _authRepository.isLoggedIn;

  String _messageFromError(Object error) {
    if (error is AuthFailure) return error.message;
    return error.toString();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
