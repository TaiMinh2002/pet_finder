import '../domain/pet_model.dart';
import '../../mock/mock_data.dart';

/// Mock pets repository
class PetsRepository {
  static PetsRepository? _instance;
  static PetsRepository get instance => _instance ??= PetsRepository._();
  PetsRepository._();

  final List<PetModel> _pets = [];
  
  /// Initialize with mock data
  void _initializeMockData() {
    if (_pets.isEmpty) {
      _pets.addAll(MockData.pets.map((pet) => pet.copyWith(
        ownerId: 'current_user_id', // Mock current user as owner
      )));
    }
  }

  /// Get all pets for current user
  Future<List<PetModel>> getUserPets(String userId) async {
    _initializeMockData();
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return _pets.where((pet) => pet.ownerId == userId).toList();
  }

  /// Get pet by ID
  Future<PetModel?> getPetById(String petId) async {
    _initializeMockData();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _pets.firstWhere((pet) => pet.id == petId);
    } catch (e) {
      return null;
    }
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
    await Future.delayed(const Duration(seconds: 1));
    
    // Validation
    if (name.trim().isEmpty) {
      throw Exception('Tên thú cưng không được để trống');
    }
    
    if (breed.trim().isEmpty) {
      throw Exception('Giống thú cưng không được để trống');
    }

    final newPet = PetModel(
      id: 'pet_${DateTime.now().millisecondsSinceEpoch}',
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
      ownerId: ownerId ?? 'current_user_id',
    );

    _pets.add(newPet);
    return newPet;
  }

  /// Update existing pet
  Future<PetModel> updatePet(String petId, {
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
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index == -1) {
      throw Exception('Không tìm thấy thú cưng');
    }

    final currentPet = _pets[index];
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

    _pets[index] = updatedPet;
    return updatedPet;
  }

  /// Delete pet
  Future<void> deletePet(String petId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index == -1) {
      throw Exception('Không tìm thấy thú cưng');
    }

    _pets.removeAt(index);
  }

  /// Search pets by name
  Future<List<PetModel>> searchPets(String query, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.trim().isEmpty) {
      return getUserPets(userId);
    }

    final userPets = await getUserPets(userId);
    final searchQuery = query.toLowerCase();
    
    return userPets.where((pet) =>
        pet.name.toLowerCase().contains(searchQuery) ||
        pet.breed.toLowerCase().contains(searchQuery) ||
        pet.color.toLowerCase().contains(searchQuery)
    ).toList();
  }

  /// Get pets count for user
  Future<int> getPetsCount(String userId) async {
    final userPets = await getUserPets(userId);
    return userPets.length;
  }
}