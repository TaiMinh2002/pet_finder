import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum PetType { dog, cat, other }

extension PetTypeExtension on PetType {
  String get displayName {
    switch (this) {
      case PetType.dog:
        return 'Chó';
      case PetType.cat:
        return 'Mèo';
      case PetType.other:
        return 'Khác';
    }
  }
}

class PetModel {
  const PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.ageLabel,
    required this.color,
    required this.weightLabel,
    required this.specialMarks,
    required this.profileStatus,
    required this.careStatus,
    required this.birthLabel,
    required this.microchipNumber,
    required this.vaccinationStatus,
    required this.medicalNotes,
    required this.reminderLabel,
    this.birthDate,
    this.photoUrl,
    this.ownerId,
  });

  final String id;
  final String name;
  final PetType type;
  final String breed;
  final String gender;
  final String ageLabel;
  final String color;
  final String weightLabel;
  final String specialMarks;
  final String profileStatus;
  final String careStatus;
  final String birthLabel;
  final String microchipNumber;
  final String vaccinationStatus;
  final String medicalNotes;
  final String reminderLabel;
  final DateTime? birthDate;
  final String? photoUrl;
  final String? ownerId;

  factory PetModel.fromJson(String id, Map<String, dynamic> json) {
    final birthDate = _parseDate(json['birthDate']);
    return PetModel(
      id: id,
      name: (json['name'] as String?) ?? '',
      type: _parseType(json['type']),
      breed: (json['breed'] as String?) ?? '',
      gender: (json['gender'] as String?) ?? '',
      ageLabel: _readText(json['ageLabel']) ?? _formatAge(birthDate),
      color: (json['color'] as String?) ?? '',
      weightLabel: _readText(json['weightLabel']) ?? 'Chưa cập nhật',
      specialMarks: (json['specialMarks'] as String?) ?? '',
      profileStatus:
          _readText(json['profileStatus']) ?? _profileStatusFrom(json),
      careStatus: _readText(json['careStatus']) ?? 'Chưa cập nhật chăm sóc',
      birthLabel: _readText(json['birthLabel']) ?? _formatBirthDate(birthDate),
      microchipNumber: (json['microchipNumber'] as String?) ?? '',
      vaccinationStatus:
          _readText(json['vaccinationStatus']) ?? 'Chưa cập nhật',
      medicalNotes: _readText(json['medicalNotes']) ?? 'Chưa cập nhật',
      reminderLabel: _readText(json['reminderLabel']) ?? 'Chưa có nhắc lịch',
      photoUrl:
          _firstPhotoUrl(json['photoUrls']) ?? json['photoUrl'] as String?,
      ownerId: json['ownerId'] as String?,
      birthDate: birthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'type': type.name,
      'breed': breed,
      'gender': gender,
      'birthDate': birthDate,
      'ageLabel': ageLabel,
      'color': color,
      'weightLabel': weightLabel,
      'specialMarks': specialMarks,
      'profileStatus': profileStatus,
      'careStatus': careStatus,
      'birthLabel': birthLabel,
      'microchipNumber': microchipNumber,
      'vaccinationStatus': vaccinationStatus,
      'medicalNotes': medicalNotes,
      'reminderLabel': reminderLabel,
      'photoUrl': photoUrl,
      'photoUrls': photoUrl == null ? const <String>[] : [photoUrl],
    };
  }

  PetModel copyWith({
    String? id,
    String? name,
    PetType? type,
    String? breed,
    String? gender,
    String? ageLabel,
    String? color,
    String? weightLabel,
    String? specialMarks,
    String? profileStatus,
    String? careStatus,
    String? birthLabel,
    String? microchipNumber,
    String? vaccinationStatus,
    String? medicalNotes,
    String? reminderLabel,
    DateTime? birthDate,
    String? photoUrl,
    String? ownerId,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      ageLabel: ageLabel ?? this.ageLabel,
      color: color ?? this.color,
      weightLabel: weightLabel ?? this.weightLabel,
      specialMarks: specialMarks ?? this.specialMarks,
      profileStatus: profileStatus ?? this.profileStatus,
      careStatus: careStatus ?? this.careStatus,
      birthLabel: birthLabel ?? this.birthLabel,
      microchipNumber: microchipNumber ?? this.microchipNumber,
      vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      reminderLabel: reminderLabel ?? this.reminderLabel,
      birthDate: birthDate ?? this.birthDate,
      photoUrl: photoUrl ?? this.photoUrl,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          breed == other.breed &&
          gender == other.gender &&
          ageLabel == other.ageLabel &&
          color == other.color &&
          weightLabel == other.weightLabel &&
          specialMarks == other.specialMarks &&
          profileStatus == other.profileStatus &&
          careStatus == other.careStatus &&
          birthLabel == other.birthLabel &&
          microchipNumber == other.microchipNumber &&
          vaccinationStatus == other.vaccinationStatus &&
          medicalNotes == other.medicalNotes &&
          reminderLabel == other.reminderLabel &&
          birthDate == other.birthDate &&
          photoUrl == other.photoUrl &&
          ownerId == other.ownerId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      breed.hashCode ^
      gender.hashCode ^
      ageLabel.hashCode ^
      color.hashCode ^
      weightLabel.hashCode ^
      specialMarks.hashCode ^
      profileStatus.hashCode ^
      careStatus.hashCode ^
      birthLabel.hashCode ^
      microchipNumber.hashCode ^
      vaccinationStatus.hashCode ^
      medicalNotes.hashCode ^
      reminderLabel.hashCode ^
      birthDate.hashCode ^
      photoUrl.hashCode ^
      ownerId.hashCode;

  @override
  String toString() {
    return 'PetModel(id: $id, name: $name, type: $type, breed: $breed, gender: $gender, ageLabel: $ageLabel, color: $color, weightLabel: $weightLabel, specialMarks: $specialMarks, profileStatus: $profileStatus, careStatus: $careStatus, birthLabel: $birthLabel, microchipNumber: $microchipNumber, vaccinationStatus: $vaccinationStatus, medicalNotes: $medicalNotes, reminderLabel: $reminderLabel, photoUrl: $photoUrl, ownerId: $ownerId)';
  }

  static PetType _parseType(Object? value) {
    return switch (value) {
      'dog' => PetType.dog,
      'cat' => PetType.cat,
      _ => PetType.other,
    };
  }

  static String? _firstPhotoUrl(Object? value) {
    if (value is List && value.isNotEmpty && value.first is String) {
      return value.first as String;
    }
    return null;
  }

  static String? _readText(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static String _formatBirthDate(DateTime? birthDate) {
    if (birthDate == null) return 'Chưa cập nhật';
    return DateFormat('dd/MM/yyyy').format(birthDate);
  }

  static String _formatAge(DateTime? birthDate) {
    if (birthDate == null) return 'Chưa cập nhật';
    final now = DateTime.now();
    var months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) months--;
    if (months < 0) return 'Chưa cập nhật';
    if (months < 12) return '$months tháng';
    final years = months ~/ 12;
    return '$years tuổi';
  }

  static String _profileStatusFrom(Map<String, dynamic> json) {
    final requiredValues = [
      json['name'],
      json['type'],
      json['breed'],
      json['gender'],
      json['color'],
    ];
    return requiredValues.every((value) => _readText(value) != null)
        ? 'Hồ sơ sẵn sàng'
        : 'Cần bổ sung';
  }
}
