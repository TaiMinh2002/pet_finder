import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.notificationRadiusKm,
    required this.isPhoneVerified,
    this.phoneNumber,
    this.avatarUrl,
    this.city,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? city;
  final int notificationRadiusKm;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromJson(String id, Map<String, dynamic> json) {
    return UserProfile(
      id: id,
      name: (json['name'] as String?)?.trim().isNotEmpty ?? false
          ? (json['name'] as String).trim()
          : 'Pet Finder User',
      email: (json['email'] as String?) ?? '',
      phoneNumber: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      city: json['city'] as String?,
      notificationRadiusKm:
          (json['notificationRadiusKm'] as num?)?.round() ?? 5,
      isPhoneVerified: (json['isPhoneVerified'] as bool?) ?? false,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'avatarUrl': avatarUrl,
      'city': city,
      'notificationRadiusKm': notificationRadiusKm,
      'isPhoneVerified': isPhoneVerified,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? city,
    int? notificationRadiusKm,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      notificationRadiusKm: notificationRadiusKm ?? this.notificationRadiusKm,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
