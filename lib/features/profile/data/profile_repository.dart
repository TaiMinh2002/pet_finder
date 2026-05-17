import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/data/auth_repository.dart';
import '../domain/profile_overview_stats.dart';
import '../domain/user_profile.dart';
import 'cloudinary_avatar_service.dart';

class ProfileRepository {
  ProfileRepository({
    FirebaseFirestore? firestore,
    AuthRepository? authRepository,
    CloudinaryAvatarService? avatarService,
  }) : _firestore = firestore,
       _authRepository = authRepository,
       _avatarService = avatarService;

  static ProfileRepository? _instance;
  static ProfileRepository get instance => _instance ??= ProfileRepository();

  final FirebaseFirestore? _firestore;
  final AuthRepository? _authRepository;
  final CloudinaryAvatarService? _avatarService;

  FirebaseFirestore get _resolvedFirestore =>
      _firestore ?? FirebaseFirestore.instance;
  AuthRepository get _resolvedAuthRepository =>
      _authRepository ?? AuthRepository.instance;
  CloudinaryAvatarService get _resolvedAvatarService =>
      _avatarService ?? CloudinaryAvatarService();

  Future<UserProfile> getCurrentProfile() async {
    final authUser = _resolvedAuthRepository.currentUser;
    if (authUser == null) {
      throw const ProfileFailure('Người dùng chưa đăng nhập.');
    }

    try {
      final document = await _resolvedFirestore
          .collection('users')
          .doc(authUser.id)
          .get();
      if (document.exists && document.data() != null) {
        return UserProfile.fromJson(
          document.id,
          document.data()!,
          fallbackName: authUser.name,
          fallbackEmail: authUser.email,
          fallbackPhoneNumber: authUser.phoneNumber,
          fallbackAvatarUrl: authUser.avatarUrl,
          fallbackIsPhoneVerified: authUser.isPhoneVerified,
        );
      }
    } on FirebaseException catch (error) {
      if (error.code != 'no-app') rethrow;
    }

    final fallback = UserProfile(
      id: authUser.id,
      name: authUser.name,
      email: authUser.email,
      phoneNumber: authUser.phoneNumber,
      avatarUrl: authUser.avatarUrl,
      notificationRadiusKm: 5,
      isPhoneVerified: authUser.isPhoneVerified,
    );
    try {
      await _resolvedFirestore.collection('users').doc(authUser.id).set({
        ...fallback.toJson(),
        'homeLocation': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      if (error.code != 'no-app') rethrow;
    }
    return fallback;
  }

  Future<UserProfile> updateProfile({
    required UserProfile currentProfile,
    required String name,
    required String phoneNumber,
    required String city,
    required int notificationRadiusKm,
    String? avatarUrl,
  }) async {
    final updatedProfile = currentProfile.copyWith(
      name: name.trim(),
      phoneNumber: phoneNumber.trim().isEmpty ? null : phoneNumber.trim(),
      city: city.trim().isEmpty ? null : city.trim(),
      notificationRadiusKm: notificationRadiusKm,
      avatarUrl: avatarUrl ?? currentProfile.avatarUrl,
      updatedAt: DateTime.now(),
    );

    await _resolvedFirestore.collection('users').doc(currentProfile.id).set({
      ...updatedProfile.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _resolvedAuthRepository.updateProfile(
      name: updatedProfile.name,
      phoneNumber: updatedProfile.phoneNumber,
      avatarUrl: avatarUrl,
    );
    return updatedProfile;
  }

  Future<String> uploadAvatar(File file) {
    return _resolvedAvatarService.uploadAvatar(file);
  }

  Future<ProfileOverviewStats> getOverviewStats(String userId) async {
    final pets = _resolvedFirestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .count()
        .get();
    final activeLostReports = _resolvedFirestore
        .collection('lost_reports')
        .where('ownerId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .count()
        .get();
    final activeFoundReports = _resolvedFirestore
        .collection('found_reports')
        .where('reporterId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .count()
        .get();
    final communityPosts = _resolvedFirestore
        .collection('community_posts')
        .where('authorId', isEqualTo: userId)
        .count()
        .get();
    final resolvedLostReports = _resolvedFirestore
        .collection('lost_reports')
        .where('ownerId', isEqualTo: userId)
        .where('status', isEqualTo: 'resolved')
        .count()
        .get();
    final resolvedFoundReports = _resolvedFirestore
        .collection('found_reports')
        .where('reporterId', isEqualTo: userId)
        .where('status', isEqualTo: 'resolved')
        .count()
        .get();

    final results = await Future.wait([
      pets,
      activeLostReports,
      activeFoundReports,
      communityPosts,
      resolvedLostReports,
      resolvedFoundReports,
    ]);

    return ProfileOverviewStats(
      petsCount: results[0].count ?? 0,
      activeReportsCount: (results[1].count ?? 0) + (results[2].count ?? 0),
      communityPostsCount: results[3].count ?? 0,
      helpedCasesCount: (results[4].count ?? 0) + (results[5].count ?? 0),
    );
  }
}

class ProfileFailure implements Exception {
  const ProfileFailure(this.message);

  final String message;
}
