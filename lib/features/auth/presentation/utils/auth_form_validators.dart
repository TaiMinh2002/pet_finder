abstract final class AuthFormValidators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _upperCaseRegex = RegExp(r'[A-Z]');
  static final _lowerCaseRegex = RegExp(r'[a-z]');
  static final _numberRegex = RegExp(r'\d');
  static final _specialRegex = RegExp(r'[^A-Za-z0-9]');

  static String? requiredText(String value, String label) {
    if (value.trim().isEmpty) return '$label không được để trống.';
    return null;
  }

  static String? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Email không được để trống.';
    if (!_emailRegex.hasMatch(trimmed)) return 'Email không đúng định dạng.';
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Mật khẩu không được để trống.';
    if (value.length < 8) return 'Mật khẩu cần ít nhất 8 ký tự.';
    return null;
  }

  static String? strongPassword(String value) {
    final baseError = password(value);
    if (baseError != null) return baseError;

    final hasUpper = _upperCaseRegex.hasMatch(value);
    final hasLower = _lowerCaseRegex.hasMatch(value);
    final hasNumber = _numberRegex.hasMatch(value);
    final hasSpecial = _specialRegex.hasMatch(value);
    if (!hasUpper || !hasLower || (!hasNumber && !hasSpecial)) {
      return 'Mật khẩu cần có chữ hoa, chữ thường và số hoặc ký tự đặc biệt.';
    }
    return null;
  }

  static String? confirmPassword(String value, String password) {
    if (value.isEmpty) return 'Xác nhận mật khẩu không được để trống.';
    if (value != password) return 'Mật khẩu xác nhận không khớp.';
    return null;
  }

  static String? fullName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Họ tên không được để trống.';
    if (trimmed.length < 2) return 'Họ tên cần ít nhất 2 ký tự.';
    return null;
  }
}
