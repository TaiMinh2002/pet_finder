import '../../../../core/bloc/bloc_exports.dart';
import '../../data/pets_repository.dart';
import '../../domain/pet_model.dart';
import 'pets_state.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit({PetsRepository? petsRepository})
      : _petsRepository = petsRepository ?? PetsRepository.instance,
        super(const PetsInitial());

  final PetsRepository _petsRepository;
  String? _currentUserId;

  /// Set current user ID
  void setUserId(String userId) {
    _currentUserId = userId;
  }

  /// Load user pets
  Future<void> loadUserPets([String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) {
      emit(const PetsError('Người dùng chưa đăng nhập'));
      return;
    }

    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      final pets = await _petsRepository.getUserPets(uid);
      
      if (pets.isEmpty) {
        emit(const PetsEmpty());
      } else {
        emit(PetsLoaded(pets));
      }
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Load single pet by ID
  Future<void> loadPet(String petId) async {
    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      final pet = await _petsRepository.getPetById(petId);
      
      if (pet != null) {
        emit(PetLoaded(pet));
      } else {
        emit(const PetsError('Không tìm thấy thú cưng'));
      }
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Add new pet
  Future<void> addPet({
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
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const PetsError('Người dùng chưa đăng nhập'));
      return;
    }

    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      final newPet = await _petsRepository.addPet(
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
        photoUrl: photoUrl,
        ownerId: uid,
      );

      emit(PetOperationSuccess('Thêm thú cưng thành công', pet: newPet));
      
      // Reload pets list
      loadUserPets();
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Update existing pet
  Future<void> updatePet(
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
    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      final updatedPet = await _petsRepository.updatePet(
        petId,
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

      emit(PetOperationSuccess('Cập nhật thú cưng thành công', pet: updatedPet));
      
      // Reload pets list
      if (_currentUserId != null) {
        loadUserPets();
      }
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Delete pet
  Future<void> deletePet(String petId) async {
    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      await _petsRepository.deletePet(petId);
      
      emit(const PetOperationSuccess('Xóa thú cưng thành công'));
      
      // Reload pets list
      if (_currentUserId != null) {
        loadUserPets();
      }
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Search pets
  Future<void> searchPets(String query) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const PetsError('Người dùng chưa đăng nhập'));
      return;
    }

    if (state is PetsLoading) return;

    emit(const PetsLoading());

    try {
      final pets = await _petsRepository.searchPets(query, uid);
      
      if (pets.isEmpty) {
        if (query.trim().isEmpty) {
          emit(const PetsEmpty());
        } else {
          emit(const PetsError('Không tìm thấy thú cưng nào'));
        }
      } else {
        emit(PetsLoaded(pets));
      }
    } catch (error) {
      emit(PetsError(error.toString()));
    }
  }

  /// Get pets count
  Future<int> getPetsCount() async {
    final uid = _currentUserId;
    if (uid == null) return 0;

    try {
      return await _petsRepository.getPetsCount(uid);
    } catch (error) {
      return 0;
    }
  }

  /// Clear error state
  void clearError() {
    if (state is PetsError) {
      if (_currentUserId != null) {
        loadUserPets();
      } else {
        emit(const PetsInitial());
      }
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const PetsInitial());
  }
}