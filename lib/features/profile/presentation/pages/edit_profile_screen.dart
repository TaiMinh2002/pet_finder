import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _imagePicker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _radiusController = TextEditingController();

  String? _avatarUrl;
  bool _didHydrate = false;
  bool _isSavingRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<ProfileCubit>().state;
      if (state is ProfileInitial) {
        context.read<ProfileCubit>().loadProfile();
      }
    });
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

  void _hydrate(ProfileReady state) {
    if (_didHydrate) return;
    final profile = state.profile;
    _nameController.text = profile.name;
    _phoneController.text = profile.phoneNumber ?? '';
    _emailController.text = profile.email;
    _cityController.text = profile.city ?? '';
    _radiusController.text = profile.notificationRadiusKm.toString();
    _avatarUrl = profile.avatarUrl;
    _didHydrate = true;
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1200,
    );
    if (image == null || !mounted) return;

    final uploadedUrl = await context.read<ProfileCubit>().uploadAvatar(
      File(image.path),
    );
    if (!mounted || uploadedUrl == null) return;
    setState(() => _avatarUrl = uploadedUrl);
  }

  Future<void> _showAvatarSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Chọn từ thư viện'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatar(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Chụp ảnh mới'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatar(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final radius = int.tryParse(_radiusController.text.trim());
    if (_nameController.text.trim().isEmpty) {
      showPetSnackBar(
        context,
        'Tên không được để trống.',
        icon: Icons.error_outline,
        backgroundColor: AppColors.coralDark,
      );
      return;
    }
    if (radius == null || radius <= 0) {
      showPetSnackBar(
        context,
        'Bán kính cần là số lớn hơn 0.',
        icon: Icons.error_outline,
        backgroundColor: AppColors.coralDark,
      );
      return;
    }

    _isSavingRequested = true;
    await context.read<ProfileCubit>().saveProfile(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      city: _cityController.text,
      notificationRadiusKm: radius,
      avatarUrl: _avatarUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileReady &&
            !state.isSaving &&
            _didHydrate &&
            _isSavingRequested) {
          _isSavingRequested = false;
          showPetSnackBar(
            context,
            'Profile saved successfully.',
            icon: Icons.check_circle_outline,
            backgroundColor: AppColors.green,
          );
          context.goNamed(AppRoute.profileOverview.name);
        }
        if (state is ProfileError) {
          _isSavingRequested = false;
          showPetSnackBar(
            context,
            state.message,
            icon: Icons.error_outline,
            backgroundColor: AppColors.coralDark,
          );
          context.read<ProfileCubit>().restoreReadyState();
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return ProfileScaffold(
            bottomNav: false,
            child: Center(
              child: AppLoadingState(
                title: context.l10n.editProfileTitle,
                message: 'Đang tải hồ sơ của bạn...',
              ),
            ),
          );
        }
        if (state is ProfileError && state.profile == null) {
          return ProfileScaffold(
            bottomNav: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenNarrow),
                child: AppErrorState(
                  title: context.l10n.editProfileTitle,
                  message: state.message,
                  onRetry: () => context.read<ProfileCubit>().loadProfile(),
                ),
              ),
            ),
          );
        }

        final readyState = state is ProfileReady
            ? state
            : ProfileReady((state as ProfileError).profile!);
        _hydrate(readyState);

        return ProfileScaffold(
          bottomNav: false,
          child: Stack(
            children: [
              CustomScrollView(
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
                              _EditableAvatar(
                                avatarUrl: _avatarUrl,
                                isUploading: readyState.isUploading,
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
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: readyState.isUploading
                                    ? null
                                    : _showAvatarSourceSheet,
                                icon: const Icon(Icons.photo_camera_outlined),
                                label: const Text('Đổi ảnh đại diện'),
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
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          label: context.l10n.editProfileEmail,
                          hint: 'Email address',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          readOnly: true,
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
                          keyboardType: TextInputType.number,
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
                  isLoading: readyState.isSaving,
                  onPressed: readyState.isSaving || readyState.isUploading
                      ? null
                      : _saveProfile,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({required this.avatarUrl, required this.isUploading});

  final String? avatarUrl;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(34),
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarUrl == null || avatarUrl!.isEmpty
              ? const Icon(Icons.person, color: AppColors.coral, size: 46)
              : Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    color: AppColors.coral,
                    size: 46,
                  ),
                ),
        ),
        if (isUploading)
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.32),
              borderRadius: BorderRadius.circular(34),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          ),
      ],
    );
  }
}
