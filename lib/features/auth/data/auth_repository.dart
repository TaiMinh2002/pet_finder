import '../domain/auth_user.dart';

/// Mock authentication repository
class AuthRepository {
  static AuthRepository? _instance;
  static AuthRepository get instance => _instance ??= AuthRepository._();
  AuthRepository._();

  AuthUser? _currentUser;

  /// Get current authenticated user
  AuthUser? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Login with email and password
  Future<AuthUser> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email và mật khẩu không được để trống');
    }

    if (!email.contains('@')) {
      throw Exception('Email không hợp lệ');
    }

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Mock successful login
    _currentUser = AuthUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@').first,
      avatarUrl: null,
      phoneNumber: null,
      isPhoneVerified: false,
    );

    return _currentUser!;
  }

  /// Register new user
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('Vui lòng điền đầy đủ thông tin');
    }

    if (!email.contains('@')) {
      throw Exception('Email không hợp lệ');
    }

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Mock successful registration
    _currentUser = AuthUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      avatarUrl: null,
      phoneNumber: phoneNumber,
      isPhoneVerified: false,
    );

    return _currentUser!;
  }

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    if (phoneNumber.isEmpty) {
      throw Exception('Số điện thoại không được để trống');
    }

    // Mock OTP sent successfully
  }

  /// Verify OTP code
  Future<void> verifyOtp(String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otpCode.isEmpty || otpCode.length != 6) {
      throw Exception('Mã OTP phải có 6 số');
    }

    // Mock OTP verification (accept any 6-digit code for testing)
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isPhoneVerified: true);
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email không hợp lệ');
    }

    // Mock password reset email sent
  }

  /// Logout current user
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  /// Update user profile
  Future<AuthUser> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
      avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
    );

    return _currentUser!;
  }
}
