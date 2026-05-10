enum PetType { dog, cat, other }

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
}
