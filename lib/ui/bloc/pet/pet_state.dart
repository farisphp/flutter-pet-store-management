import 'package:petstore/domain/entities/pet.dart';

abstract class PetState {
  const PetState();
}

class PetInitial extends PetState {
  const PetInitial();
}

class PetLoading extends PetState {
  const PetLoading();
}

class PetLoaded extends PetState {
  final List<Pet> pets;
  final PetStatus currentStatus;

  const PetLoaded(this.pets, this.currentStatus);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetLoaded &&
          runtimeType == other.runtimeType &&
          pets == other.pets &&
          currentStatus == other.currentStatus;

  @override
  int get hashCode => pets.hashCode ^ currentStatus.hashCode;
}

class PetError extends PetState {
  final String message;

  const PetError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class PetOperationSuccess extends PetState {
  final String message;

  const PetOperationSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetOperationSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
