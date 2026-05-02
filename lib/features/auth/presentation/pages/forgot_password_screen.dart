import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.forgotPasswordButton,
      icon: Icons.mark_email_read_outlined,
      backgroundColor: AppColors.teal,
    );
    setState(() => _isLoading = false);
    context.goNamed(AppRoute.otp.name);
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 18),
            AppButton(
              label: context.l10n.forgotPasswordButton,
              icon: Icons.arrow_forward,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ],
    );
  }
}
