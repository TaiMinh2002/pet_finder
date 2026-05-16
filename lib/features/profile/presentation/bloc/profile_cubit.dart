import 'dart:io';

import '../../../../core/bloc/bloc_exports.dart';
import '../../data/cloudinary_avatar_service.dart';
import '../../data/profile_repository.dart';
import '../../domain/user_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepository.instance,
      super(const ProfileInitial());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.getCurrentProfile();
      emit(ProfileReady(profile));
    } catch (error) {
      emit(ProfileError(_messageFromError(error)));
    }
  }

  Future<void> saveProfile({
    required String name,
    required String phoneNumber,
    required String city,
    required int notificationRadiusKm,
    String? avatarUrl,
  }) async {
    final current = _currentProfile;
    if (current == null) return;
    emit(ProfileReady(current, isSaving: true));
    try {
      final profile = await _repository.updateProfile(
        currentProfile: current,
        name: name,
        phoneNumber: phoneNumber,
        city: city,
        notificationRadiusKm: notificationRadiusKm,
        avatarUrl: avatarUrl,
      );
      emit(ProfileReady(profile));
    } catch (error) {
      emit(ProfileError(_messageFromError(error), profile: current));
    }
  }

  Future<String?> uploadAvatar(File file) async {
    final current = _currentProfile;
    if (current == null) return null;
    emit(ProfileReady(current, isUploading: true));
    try {
      final url = await _repository.uploadAvatar(file);
      emit(ProfileReady(current));
      return url;
    } catch (error) {
      emit(ProfileError(_messageFromError(error), profile: current));
      return null;
    }
  }

  void restoreReadyState() {
    final current = _currentProfile;
    if (current != null) emit(ProfileReady(current));
  }

  void reset() {
    emit(const ProfileInitial());
  }

  UserProfile? get _currentProfile {
    final currentState = state;
    if (currentState is ProfileReady) return currentState.profile;
    if (currentState is ProfileError) return currentState.profile;
    return null;
  }

  String _messageFromError(Object error) {
    if (error is ProfileFailure) return error.message;
    if (error is AvatarUploadFailure) return error.message;
    return 'Có lỗi khi cập nhật hồ sơ. Vui lòng thử lại.';
  }
}
