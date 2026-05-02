import 'package:flutter/material.dart';
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
import '../widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.loginTitle,
      icon: Icons.lock_open_outlined,
      backgroundColor: AppColors.teal,
    );
    setState(() => _isLoading = false);
    context.goNamed(AppRoute.accountSuccess.name);
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: context.l10n.authPassword,
              hint: context.l10n.authHintEnterPassword,
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.goNamed(AppRoute.forgotPassword.name),
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
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
        AuthLink(
          text: context.l10n.loginCreateAccountPrompt,
          onTap: () => context.goNamed(AppRoute.signUp.name),
        ),
      ],
    );
  }
}
