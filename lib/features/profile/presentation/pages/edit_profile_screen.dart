import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../mock/mock_data.dart';
import '../widgets/profile_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _radiusController;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: MockData.profileName);
    _phoneController = TextEditingController(text: MockData.profilePhone);
    _emailController = TextEditingController(text: MockData.profileEmail);
    _cityController = TextEditingController(text: MockData.profileCity);
    _radiusController = TextEditingController(text: MockData.alertRadiusLabel);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 380));
    if (!mounted) return;
    showPetSnackBar(
      context,
      'Profile saved successfully.',
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.green,
    );
    setState(() => _isSaving = false);
    context.goNamed(AppRoute.profileOverview.name);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return ProfileScaffold(
      bottomNav: false,
      child: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  18,
                  AppSpacing.screenNarrow,
                  126 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    ProfileHeader(
                      title: context.l10n.editProfileTitle,
                      subtitle: context.l10n.editProfileSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () =>
                            // Use explicit navigation to avoid popping an empty stack
                            context.goNamed(AppRoute.profileOverview.name),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      color: AppColors.glass,
                      radius: 30,
                      shadow: AppShadows.raisedCard,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.peach,
                                  AppColors.cream,
                                  AppColors.white,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(34),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.coral,
                              size: 46,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.editProfileAvatarHint,
                            style: AppTextStyles.bodyStrong,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.editProfilePhotoDesc,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: context.l10n.editProfileName,
                      hint: 'Your full name',
                      icon: Icons.person_outline,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: context.l10n.editProfilePhone,
                      hint: 'Phone number',
                      icon: Icons.call_outlined,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: context.l10n.editProfileEmail,
                      hint: 'Email address',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: context.l10n.editProfileCity,
                      hint: 'Your city',
                      icon: Icons.place_outlined,
                      controller: _cityController,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: context.l10n.editProfileRadius,
                      hint: 'How far nearby alerts should feel relevant',
                      icon: Icons.radar_outlined,
                      controller: _radiusController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: AppSpacing.screenNarrow,
            right: AppSpacing.screenNarrow,
            bottom: 28 + bottomInset,
            child: AppButton(
              label: context.l10n.petEditSaveBtn,
              icon: Icons.check_circle_outline,
              isLoading: _isSaving,
              onPressed: _saveProfile,
            ),
          ),
        ],
      ),
    );
  }
}
