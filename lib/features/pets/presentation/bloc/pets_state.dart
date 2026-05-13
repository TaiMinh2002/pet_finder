import '../../../../core/bloc/bloc_exports.dart';
import '../../domain/pet_model.dart';

/// Pets states
abstract class PetsState extends BaseState {
  const PetsState();
}

/// Initial pets state
class PetsInitial extends PetsState {
  const PetsInitial();

  @override
  bool operator ==(Object other) => other is PetsInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Loading pets
class PetsLoading extends PetsState {
  const PetsLoading();

  @override
  bool operator ==(Object other) => other is PetsLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Pets loaded successfully
class PetsLoaded extends PetsState {
  const PetsLoaded(this.pets);

  final List<PetModel> pets;

  @override
  bool operator ==(Object other) =>
      other is PetsLoaded &&
      other.pets.length == pets.length &&
      other.pets.every((pet) => pets.contains(pet));

  @override
  int get hashCode => pets.hashCode;
}

/// Single pet loaded
class PetLoaded extends PetsState {
  const PetLoaded(this.pet);

  final PetModel pet;

  @override
  bool operator ==(Object other) => other is PetLoaded && other.pet == pet;

  @override
  int get hashCode => pet.hashCode;
}

/// Pet operation success (add/update/delete)
class PetOperationSuccess extends PetsState {
  const PetOperationSuccess(this.message, {this.pet});

  final String message;
  final PetModel? pet;

  @override
  bool operator ==(Object other) =>
      other is PetOperationSuccess &&
      other.message == message &&
      other.pet == pet;

  @override
  int get hashCode => Object.hash(message, pet);
}

/// Pets error state
class PetsError extends PetsState {
  const PetsError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      other is PetsError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Empty pets state
class PetsEmpty extends PetsState {
  const PetsEmpty();

  @override
  bool operator ==(Object other) => other is PetsEmpty;

  @override
  int get hashCode => runtimeType.hashCode;
}
