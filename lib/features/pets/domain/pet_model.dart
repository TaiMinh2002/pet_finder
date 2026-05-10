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
  final String? photoUrl;
  final String? ownerId;

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
      photoUrl.hashCode ^
      ownerId.hashCode;

  @override
  String toString() {
    return 'PetModel(id: $id, name: $name, type: $type, breed: $breed, gender: $gender, ageLabel: $ageLabel, color: $color, weightLabel: $weightLabel, specialMarks: $specialMarks, profileStatus: $profileStatus, careStatus: $careStatus, birthLabel: $birthLabel, microchipNumber: $microchipNumber, vaccinationStatus: $vaccinationStatus, medicalNotes: $medicalNotes, reminderLabel: $reminderLabel, photoUrl: $photoUrl, ownerId: $ownerId)';
  }
}
