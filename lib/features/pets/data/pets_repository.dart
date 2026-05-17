import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/pet_model.dart';

class PetsRepository {
  PetsRepository({FirebaseFirestore? firestore}) : _firestore = firestore;

  static PetsRepository? _instance;
  static PetsRepository get instance => _instance ??= PetsRepository();

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _resolvedFirestore =>
      _firestore ?? FirebaseFirestore.instance;

  /// Get all pets for current user
  Future<List<PetModel>> getUserPets(String userId) async {
    final snapshot = await _resolvedFirestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((document) => PetModel.fromJson(document.id, document.data()))
        .toList();
  }

  /// Get pet by ID
  Future<PetModel?> getPetById(String petId) async {
    final document = await _resolvedFirestore
        .collection('pets')
        .doc(petId)
        .get();
    final data = document.data();
    if (!document.exists || data == null) return null;
    return PetModel.fromJson(document.id, data);
  }

  /// Add new pet
  Future<PetModel> addPet({
    required String name,
    required PetType type,
    required String breed,
    required String gender,
    required String ageLabel,
    required String color,
    required String weightLabel,
    required String specialMarks,
    required String birthLabel,
    String? microchipNumber,
    String? photoUrl,
    String? ownerId,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Tên thú cưng không được để trống');
    }

    if (breed.trim().isEmpty) {
      throw Exception('Giống thú cưng không được để trống');
    }

    final document = _resolvedFirestore.collection('pets').doc();
    final newPet = PetModel(
      id: document.id,
      name: name.trim(),
      type: type,
      breed: breed.trim(),
      gender: gender,
      ageLabel: ageLabel,
      color: color,
      weightLabel: weightLabel,
      specialMarks: specialMarks,
      profileStatus: 'Hoàn chỉnh',
      careStatus: 'Khỏe mạnh',
      birthLabel: birthLabel,
      microchipNumber: microchipNumber ?? '',
      vaccinationStatus: 'Đã tiêm đầy đủ',
      medicalNotes: '',
      reminderLabel: 'Không có nhắc nhở',
      photoUrl: photoUrl,
      ownerId: ownerId,
    );

    await document.set({
      ...newPet.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return newPet;
  }

  /// Update existing pet
  Future<PetModel> updatePet(
    String petId, {
    String? name,
    PetType? type,
    String? breed,
    String? gender,
    String? ageLabel,
    String? color,
    String? weightLabel,
    String? specialMarks,
    String? birthLabel,
    String? microchipNumber,
    String? vaccinationStatus,
    String? medicalNotes,
    String? photoUrl,
  }) async {
    final currentPet = await getPetById(petId);
    if (currentPet == null) {
      throw Exception('Không tìm thấy thú cưng');
    }

    final updatedPet = currentPet.copyWith(
      name: name,
      type: type,
      breed: breed,
      gender: gender,
      ageLabel: ageLabel,
      color: color,
      weightLabel: weightLabel,
      specialMarks: specialMarks,
      birthLabel: birthLabel,
      microchipNumber: microchipNumber,
      vaccinationStatus: vaccinationStatus,
      medicalNotes: medicalNotes,
      photoUrl: photoUrl,
    );

    await _resolvedFirestore.collection('pets').doc(petId).set({
      ...updatedPet.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return updatedPet;
  }

  /// Delete pet
  Future<void> deletePet(String petId) async {
    final currentPet = await getPetById(petId);
    if (currentPet == null) {
      throw Exception('Không tìm thấy thú cưng');
    }
    await _resolvedFirestore.collection('pets').doc(petId).delete();
  }

  /// Search pets by name
  Future<List<PetModel>> searchPets(String query, String userId) async {
    if (query.trim().isEmpty) {
      return getUserPets(userId);
    }

    final userPets = await getUserPets(userId);
    final searchQuery = query.toLowerCase();

    return userPets
        .where(
          (pet) =>
              pet.name.toLowerCase().contains(searchQuery) ||
              pet.breed.toLowerCase().contains(searchQuery) ||
              pet.color.toLowerCase().contains(searchQuery),
        )
        .toList();
  }

  /// Get pets count for user
  Future<int> getPetsCount(String userId) async {
    final snapshot = await _resolvedFirestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
