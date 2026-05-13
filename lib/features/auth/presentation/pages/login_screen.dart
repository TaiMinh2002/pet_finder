import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().login(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          showPetSnackBar(
            context,
            context.l10n.loginTitle,
            icon: Icons.lock_open_outlined,
            backgroundColor: AppColors.teal,
          );
          context.goNamed(AppRoute.home.name);
        }
        if (state is AuthError) {
          showPetSnackBar(
            context,
            state.message,
            icon: Icons.error_outline,
            backgroundColor: AppColors.coralDark,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AuthScaffold(
          compact: true,
          leading: AuthIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.safeBackNamed(AppRoute.welcome),
          ),
          title: context.l10n.loginTitle,
          subtitle: context.l10n.loginSubtitle,
          illustration: AuthIllustration(
            imagePath: AppImages.authLogin,
            icon: Icons.lock_outline,
            badgeLabel: context.l10n.authBadgeSavedHelper,
            height: 194,
            accent: AppColors.teal,
          ),
          children: [
            AuthFormCard(
              children: [
                AppTextField(
                  label: context.l10n.authEmailOrPhone,
                  hint: context.l10n.authHintEmail,
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: context.l10n.authPassword,
                  hint: context.l10n.authHintEnterPassword,
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.goNamed(AppRoute.forgotPassword.name),
                    child: Text(
                      context.l10n.authForgotPassword,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.coralDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: context.l10n.loginButton,
                  icon: Icons.arrow_forward,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
            AuthLink(
              text: context.l10n.loginCreateAccountPrompt,
              onTap: () => context.goNamed(AppRoute.signUp.name),
            ),
          ],
        );
      },
    );
  }
}
