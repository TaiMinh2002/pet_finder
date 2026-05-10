/// Authentication user model
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    this.isPhoneVerified = false,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isPhoneVerified;

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phoneNumber,
    bool? isPhoneVerified,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          phoneNumber == other.phoneNumber &&
          isPhoneVerified == other.isPhoneVerified;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      phoneNumber.hashCode ^
      isPhoneVerified.hashCode;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, phoneNumber: $phoneNumber, isPhoneVerified: $isPhoneVerified)';
  }
}