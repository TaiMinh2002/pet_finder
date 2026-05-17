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
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _cityError;
  String? _radiusError;

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
                  title: Text(context.l10n.editProfilePickFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatar(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(context.l10n.editProfileTakePhoto),
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
    FocusManager.instance.primaryFocus?.unfocus();
    final radius = int.tryParse(_radiusController.text.trim());
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final city = _cityController.text.trim();

    final nameError = name.isEmpty
        ? context.l10n.editProfileNameRequired
        : null;
    final phoneError = _validatePhone(phone);
    final emailError = _validateEmail(email);
    final cityError = city.isEmpty
        ? context.l10n.editProfileCityRequired
        : null;
    final radiusError = _validateRadius(radius);

    setState(() {
      _nameError = nameError;
      _phoneError = phoneError;
      _emailError = emailError;
      _cityError = cityError;
      _radiusError = radiusError;
    });

    if (nameError != null ||
        phoneError != null ||
        emailError != null ||
        cityError != null ||
        radiusError != null) {
      showPetSnackBar(
        context,
        context.l10n.editProfileRequiredFieldsError,
        icon: Icons.error_outline,
        backgroundColor: AppColors.coralDark,
      );
      return;
    }

    _isSavingRequested = true;
    await context.read<ProfileCubit>().saveProfile(
      name: name,
      phoneNumber: phone,
      city: city,
      notificationRadiusKm: radius!,
      avatarUrl: _avatarUrl,
    );
  }

  String? _validatePhone(String value) {
    if (value.isEmpty) return context.l10n.editProfilePhoneRequired;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9 || digits.length > 15) {
      return context.l10n.editProfilePhoneInvalid;
    }
    if (!RegExp(r'^\+?[0-9\s().-]+$').hasMatch(value)) {
      return context.l10n.editProfilePhoneInvalid;
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return context.l10n.editProfileEmailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return context.l10n.editProfileEmailInvalid;
    }
    return null;
  }

  String? _validateRadius(int? value) {
    if (value == null) return context.l10n.editProfileRadiusNumberRequired;
    if (value < 1 || value > 100) {
      return context.l10n.editProfileRadiusRangeError;
    }
    return null;
  }

  void _clearFieldError(String field) {
    setState(() {
      switch (field) {
        case 'name':
          _nameError = null;
          break;
        case 'phone':
          _phoneError = null;
          break;
        case 'city':
          _cityError = null;
          break;
        case 'radius':
          _radiusError = null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileReady &&
            !state.isSaving &&
            _didHydrate &&
            _isSavingRequested) {
          _isSavingRequested = false;
          showPetSnackBar(
            context,
            context.l10n.editProfileSaved,
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
                message: context.l10n.editProfileLoading,
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

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ProfileScaffold(
            bottomNav: false,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: _EditProfileBottomAction(
              isSaving: readyState.isSaving,
              isUploading: readyState.isUploading,
              onPressed: _saveProfile,
            ),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenNarrow,
                    18,
                    AppSpacing.screenNarrow,
                    148,
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
                        color: AppColors.white,
                        radius: 24,
                        shadow: AppShadows.raisedCard,
                        border: Border.all(color: AppColors.peach),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            _EditableAvatar(
                              avatarUrl: _avatarUrl,
                              isUploading: readyState.isUploading,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nameController.text.trim().isEmpty
                                        ? context.l10n.editProfileAvatarHint
                                        : _nameController.text.trim(),
                                    style: AppTextStyles.bodyStrong,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.editProfilePhotoDesc,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: readyState.isUploading
                                        ? null
                                        : _showAvatarSourceSheet,
                                    icon: const Icon(
                                      Icons.photo_camera_outlined,
                                      size: 18,
                                    ),
                                    label: Text(
                                      context.l10n.editProfileChangePhoto,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        color: AppColors.white,
                        radius: 24,
                        shadow: AppShadows.softCard,
                        border: Border.all(color: AppColors.peach),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.editProfileContactInfo,
                              style: AppTextStyles.bodyStrong.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            AppTextField(
                              label: context.l10n.editProfileName,
                              hint: context.l10n.editProfileNameHint,
                              icon: Icons.person_outline,
                              controller: _nameController,
                              required: true,
                              errorText: _nameError,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => _clearFieldError('name'),
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              label: context.l10n.editProfilePhone,
                              hint: context.l10n.editProfilePhoneHint,
                              icon: Icons.call_outlined,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              required: true,
                              errorText: _phoneError,
                              onChanged: (_) => _clearFieldError('phone'),
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              label: context.l10n.editProfileEmail,
                              hint: context.l10n.editProfileEmailHint,
                              icon: Icons.mail_outline,
                              controller: _emailController,
                              readOnly: true,
                              required: true,
                              errorText: _emailError,
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              label: context.l10n.editProfileCity,
                              hint: context.l10n.editProfileCityHint,
                              icon: Icons.place_outlined,
                              controller: _cityController,
                              required: true,
                              errorText: _cityError,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => _clearFieldError('city'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        color: AppColors.charcoal,
                        radius: 24,
                        shadow: AppShadows.floating,
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.editProfileAlertOptions,
                              style: AppTextStyles.bodyStrong.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            AppTextField(
                              label: context.l10n.editProfileRadius,
                              labelColor: AppColors.white,
                              hint: context.l10n.editProfileRadiusHint,
                              icon: Icons.radar_outlined,
                              controller: _radiusController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              required: true,
                              errorText: _radiusError,
                              onChanged: (_) => _clearFieldError('radius'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EditProfileBottomAction extends StatelessWidget {
  const _EditProfileBottomAction({
    required this.isSaving,
    required this.isUploading,
    required this.onPressed,
  });

  final bool isSaving;
  final bool isUploading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenNarrow,
          12,
          AppSpacing.screenNarrow,
          28,
        ),
        child: AppButton(
          label: context.l10n.petEditSaveBtn,
          icon: Icons.check_circle_outline,
          isLoading: isSaving,
          onPressed: isSaving || isUploading ? null : onPressed,
        ),
      ),
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
