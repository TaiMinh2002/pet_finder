import '../../../../core/bloc/bloc_exports.dart';
import '../../domain/auth_user.dart';

/// Authentication states
abstract class AuthState extends BaseState {
  const AuthState();
}

/// Initial/unauthenticated state
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) => other is AuthInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final AuthUser user;

  @override
  bool operator ==(Object other) =>
      other is AuthAuthenticated && other.user == user;

  @override
  int get hashCode => user.hashCode;
}

/// Authentication loading state
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) => other is AuthLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Authentication error state
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      other is AuthError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// OTP sent successfully
class AuthOtpSent extends AuthState {
  const AuthOtpSent(this.phoneNumber);

  final String phoneNumber;

  @override
  bool operator ==(Object other) =>
      other is AuthOtpSent && other.phoneNumber == phoneNumber;

  @override
  int get hashCode => phoneNumber.hashCode;
}

/// Password reset email sent
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent(this.email);

  final String email;

  @override
  bool operator ==(Object other) =>
      other is AuthPasswordResetSent && other.email == email;

  @override
  int get hashCode => email.hashCode;
}
