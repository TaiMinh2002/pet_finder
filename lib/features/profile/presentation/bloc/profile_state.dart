import '../../../../core/bloc/bloc_exports.dart';
import '../../domain/user_profile.dart';

abstract class ProfileState extends BaseState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileReady extends ProfileState {
  const ProfileReady(
    this.profile, {
    this.isSaving = false,
    this.isUploading = false,
  });

  final UserProfile profile;
  final bool isSaving;
  final bool isUploading;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message, {this.profile});

  final String message;
  final UserProfile? profile;
}
