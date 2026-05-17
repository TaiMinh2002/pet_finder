import 'dart:io';

import '../../../../core/bloc/bloc_exports.dart';
import '../../data/cloudinary_avatar_service.dart';
import '../../data/profile_repository.dart';
import '../../domain/profile_overview_stats.dart';
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
      emit(ProfileReady(profile, isStatsLoading: true));
      await _loadOverviewStats(profile);
    } catch (error) {
      emit(ProfileError(_messageFromError(error)));
    }
  }

  Future<void> _loadOverviewStats(UserProfile profile) async {
    try {
      final stats = await _repository.getOverviewStats(profile.id);
      emit(ProfileReady(profile, stats: stats));
    } catch (_) {
      emit(ProfileReady(profile));
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
    final stats = _currentStats;
    emit(
      ProfileReady(
        current,
        stats: stats,
        isStatsLoading: _isStatsLoading,
        isSaving: true,
      ),
    );
    try {
      final profile = await _repository.updateProfile(
        currentProfile: current,
        name: name,
        phoneNumber: phoneNumber,
        city: city,
        notificationRadiusKm: notificationRadiusKm,
        avatarUrl: avatarUrl,
      );
      emit(
        ProfileReady(profile, stats: stats, isStatsLoading: _isStatsLoading),
      );
    } catch (error) {
      emit(
        ProfileError(_messageFromError(error), profile: current, stats: stats),
      );
    }
  }

  Future<String?> uploadAvatar(File file) async {
    final current = _currentProfile;
    if (current == null) return null;
    final stats = _currentStats;
    emit(
      ProfileReady(
        current,
        stats: stats,
        isStatsLoading: _isStatsLoading,
        isUploading: true,
      ),
    );
    try {
      final url = await _repository.uploadAvatar(file);
      emit(
        ProfileReady(current, stats: stats, isStatsLoading: _isStatsLoading),
      );
      return url;
    } catch (error) {
      emit(
        ProfileError(_messageFromError(error), profile: current, stats: stats),
      );
      return null;
    }
  }

  void restoreReadyState() {
    final current = _currentProfile;
    if (current != null) emit(ProfileReady(current, stats: _currentStats));
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

  ProfileOverviewStats get _currentStats {
    final currentState = state;
    if (currentState is ProfileReady) return currentState.stats;
    if (currentState is ProfileError) return currentState.stats;
    return const ProfileOverviewStats.empty();
  }

  bool get _isStatsLoading {
    final currentState = state;
    return currentState is ProfileReady && currentState.isStatsLoading;
  }

  String _messageFromError(Object error) {
    if (error is ProfileFailure) return error.message;
    if (error is AvatarUploadFailure) return error.message;
    return 'Có lỗi khi cập nhật hồ sơ. Vui lòng thử lại.';
  }
}
