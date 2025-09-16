import 'package:petstore/domain/entities/pet.dart';

abstract class PetEvent {
  const PetEvent();
}

class LoadPetsByStatus extends PetEvent {
  final PetStatus status;

  const LoadPetsByStatus(this.status);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadPetsByStatus &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;
}

class CreatePetEvent extends PetEvent {
  final Pet pet;

  const CreatePetEvent(this.pet);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePetEvent &&
          runtimeType == other.runtimeType &&
          pet == other.pet;

  @override
  int get hashCode => pet.hashCode;
}

class UpdatePetEvent extends PetEvent {
  final Pet pet;

  const UpdatePetEvent(this.pet);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdatePetEvent &&
          runtimeType == other.runtimeType &&
          pet == other.pet;

  @override
  int get hashCode => pet.hashCode;
}

class DeletePetEvent extends PetEvent {
  final int id;

  const DeletePetEvent(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletePetEvent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
