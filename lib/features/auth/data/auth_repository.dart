import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/auth_user.dart';

abstract class AuthRepository {
  static AuthRepository? _instance;
  static AuthRepository get instance => _instance ??= FirebaseAuthRepository();

  static void overrideInstanceForTest(AuthRepository repository) {
    _instance = repository;
  }

  static void resetInstanceForTest() {
    _instance = null;
  }

  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<AuthUser> login(String email, String password);

  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<void> sendOtp(String phoneNumber);

  Future<void> verifyOtp(String otpCode);

  Future<void> resetPassword(String email);

  Future<void> logout();

  Future<AuthUser> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  });
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        throw const AuthFailure('Không thể đăng nhập. Vui lòng thử lại.');
      }
      await _syncUserDocument(user);
      return user;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthFailure.fromFirebase(error);
    } on FirebaseException catch (error) {
      throw AuthFailure.fromFirestore(error);
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      final refreshedUser = _firebaseAuth.currentUser;
      final user = _mapFirebaseUser(refreshedUser)?.copyWith(
        name: name.trim(),
        phoneNumber: phoneNumber?.trim().isEmpty ?? true
            ? null
            : phoneNumber?.trim(),
      );
      if (user == null) {
        throw const AuthFailure('Không thể tạo tài khoản. Vui lòng thử lại.');
      }
      await _createUserDocument(user);
      return user;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthFailure.fromFirebase(error);
    } on FirebaseException catch (error) {
      throw AuthFailure.fromFirestore(error);
    }
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    throw const AuthFailure(
      'Xác minh số điện thoại sẽ được triển khai ở phase sau.',
    );
  }

  @override
  Future<void> verifyOtp(String otpCode) async {
    throw const AuthFailure(
      'Xác minh số điện thoại sẽ được triển khai ở phase sau.',
    );
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthFailure.fromFirebase(error);
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AuthUser> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw const AuthFailure('Người dùng chưa đăng nhập.');
    }

    try {
      if (name != null) {
        await firebaseUser.updateDisplayName(name.trim());
      }
      if (avatarUrl != null) {
        await firebaseUser.updatePhotoURL(avatarUrl);
      }
      final updated = _mapFirebaseUser(_firebaseAuth.currentUser)!.copyWith(
        name: name?.trim(),
        phoneNumber: phoneNumber?.trim(),
        avatarUrl: avatarUrl,
      );
      await _syncUserDocument(updated);
      return updated;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthFailure.fromFirebase(error);
    }
  }

  Future<void> _createUserDocument(AuthUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'phone': user.phoneNumber,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'homeLocation': null,
      'city': null,
      'notificationRadiusKm': 5,
      'isPhoneVerified': user.isPhoneVerified,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _syncUserDocument(AuthUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'phone': user.phoneNumber,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'isPhoneVerified': user.isPhoneVerified,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  AuthUser? _mapFirebaseUser(firebase_auth.User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName?.trim().isNotEmpty ?? false
          ? user.displayName!.trim()
          : (user.email?.split('@').first ?? 'Pet Finder User'),
      avatarUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      isPhoneVerified: user.phoneNumber?.isNotEmpty ?? false,
    );
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  factory AuthFailure.fromFirebase(firebase_auth.FirebaseAuthException error) {
    return AuthFailure(_messageForCode(error.code));
  }

  factory AuthFailure.fromFirestore(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => const AuthFailure(
        'Tài khoản đã được tạo nhưng chưa thể lưu hồ sơ người dùng. Hãy kiểm tra Firestore Rules.',
      ),
      _ => const AuthFailure(
        'Không thể lưu hồ sơ người dùng. Vui lòng thử lại.',
      ),
    };
  }

  static String _messageForCode(String code) {
    return switch (code) {
      'invalid-email' => 'Email không hợp lệ.',
      'user-disabled' => 'Tài khoản này đã bị vô hiệu hóa.',
      'user-not-found' => 'Không tìm thấy tài khoản với email này.',
      'wrong-password' ||
      'invalid-credential' => 'Email hoặc mật khẩu không đúng.',
      'email-already-in-use' => 'Email này đã được sử dụng.',
      'operation-not-allowed' => 'Phương thức đăng nhập này chưa được bật.',
      'weak-password' => 'Mật khẩu cần mạnh hơn.',
      'too-many-requests' =>
        'Bạn thao tác quá nhiều lần. Vui lòng thử lại sau.',
      'network-request-failed' => 'Không thể kết nối mạng. Vui lòng thử lại.',
      _ => 'Có lỗi xác thực. Vui lòng thử lại.',
    };
  }

  @override
  String toString() => message;
}
