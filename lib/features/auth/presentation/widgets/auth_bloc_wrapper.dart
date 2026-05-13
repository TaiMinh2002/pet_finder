import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

/// Example wrapper showing how to use AuthCubit in widgets
class AuthBlocWrapper extends StatelessWidget {
  const AuthBlocWrapper({
    required this.child,
    this.showLoading = false,
    this.onError,
    super.key,
  });

  final Widget child;
  final bool showLoading;
  final void Function(String error)? onError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError && onError != null) {
          onError!(state.message);
        }
      },
      builder: (context, state) {
        if (showLoading && state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return child;
      },
    );
  }
}

/// Helper extension to access AuthCubit easily
extension AuthContext on BuildContext {
  AuthCubit get authCubit => read<AuthCubit>();
  AuthState get authState => watch<AuthCubit>().state;
  bool get isAuthenticated => authState is AuthAuthenticated;
}
