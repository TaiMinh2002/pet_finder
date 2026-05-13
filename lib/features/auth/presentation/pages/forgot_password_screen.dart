import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().resetPassword(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          showPetSnackBar(
            context,
            context.l10n.forgotPasswordButton,
            icon: Icons.mark_email_read_outlined,
            backgroundColor: AppColors.teal,
          );
          context.safeBackNamed(AppRoute.login);
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
          leading: AuthIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.safeBackNamed(AppRoute.welcome),
          ),
          title: context.l10n.forgotPasswordTitle,
          subtitle: context.l10n.forgotPasswordSubtitle,
          illustration: AuthIllustration(
            imagePath: AppImages.authForgot,
            icon: Icons.mark_email_read_outlined,
            badgeLabel: context.l10n.authBadgeSecureMail,
            accent: AppColors.teal,
          ),
          children: [
            AuthFormCard(
              children: [
                AppTextField(
                  label: context.l10n.authEmailOrPhone,
                  hint: context.l10n.authHintEmail,
                  icon: Icons.alternate_email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: context.l10n.forgotPasswordButton,
                  icon: Icons.arrow_forward,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
