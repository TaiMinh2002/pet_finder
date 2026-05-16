import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
import '../utils/auth_form_validators.dart';
import '../widgets/auth_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) return;
    context.read<AuthCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  bool _validate() {
    final nameError = AuthFormValidators.fullName(_nameController.text);
    final emailError = AuthFormValidators.email(_emailController.text);
    final passwordError = AuthFormValidators.strongPassword(
      _passwordController.text,
    );
    final confirmPasswordError = AuthFormValidators.confirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );
    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
    });
    return [
      nameError,
      emailError,
      passwordError,
      confirmPasswordError,
    ].every((error) => error == null);
  }

  void _clearNameError(String value) {
    if (_nameError == null) return;
    setState(() => _nameError = AuthFormValidators.fullName(value));
  }

  void _clearEmailError(String value) {
    if (_emailError == null) return;
    setState(() => _emailError = AuthFormValidators.email(value));
  }

  void _clearPasswordError(String value) {
    if (_passwordError == null && _confirmPasswordError == null) return;
    setState(() {
      _passwordError = AuthFormValidators.strongPassword(value);
      _confirmPasswordError = AuthFormValidators.confirmPassword(
        _confirmPasswordController.text,
        value,
      );
    });
  }

  void _clearConfirmPasswordError(String value) {
    if (_confirmPasswordError == null) return;
    setState(() {
      _confirmPasswordError = AuthFormValidators.confirmPassword(
        value,
        _passwordController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          showPetSnackBar(
            context,
            context.l10n.signUpButton,
            icon: Icons.verified_outlined,
            backgroundColor: AppColors.coral,
          );
          context.goNamed(AppRoute.accountSuccess.name);
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
          headerVariant: AuthHeaderVariant.registerCompact,
          leading: AuthIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.safeBackNamed(AppRoute.welcome),
          ),
          title: context.l10n.signUpTitle,
          subtitle: context.l10n.signUpSubtitle,
          illustration: AuthIllustration(
            imagePath: AppImages.authSignUp,
            icon: Icons.badge_outlined,
            badgeLabel: context.l10n.authBadgeSafeContact,
            height: 194,
            accent: AppColors.coral,
          ),
          children: [
            AuthFormCard(
              padding: const EdgeInsets.all(18),
              children: [
                AppTextField(
                  label: context.l10n.authFullName,
                  hint: context.l10n.authHintYourName,
                  icon: Icons.person_outline,
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  required: true,
                  errorText: _nameError,
                  onChanged: _clearNameError,
                  dismissKeyboardOnTapOutside: false,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: context.l10n.authEmail,
                  hint: context.l10n.authHintEmail,
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  required: true,
                  errorText: _emailError,
                  onChanged: _clearEmailError,
                  dismissKeyboardOnTapOutside: false,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: context.l10n.authCreatePassword,
                  hint: context.l10n.authHintCreatePassword,
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  required: true,
                  errorText: _passwordError,
                  onChanged: _clearPasswordError,
                  dismissKeyboardOnTapOutside: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: context.l10n.authConfirmPassword,
                  hint: context.l10n.authHintRepeatPassword,
                  icon: Icons.verified_user_outlined,
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  required: true,
                  errorText: _confirmPasswordError,
                  onChanged: _clearConfirmPasswordError,
                  dismissKeyboardOnTapOutside: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: context.l10n.signUpButton,
                  icon: Icons.arrow_forward,
                  height: 52,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
            AuthLink(
              text: context.l10n.signUpLoginPrompt,
              onTap: () => context.goNamed(AppRoute.login.name),
            ),
          ],
        );
      },
    );
  }
}
