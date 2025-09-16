import 'package:petstore/domain/repositories/pet_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_cases/use_case.dart';
import '../../../core/utils/either.dart';
import '../../entities/pet.dart';

class UpdatePet implements UseCase<Pet, Pet> {
  final PetRepository repository;

  UpdatePet(this.repository);

  @override
  Future<Either<Failure, Pet>> call(Pet pet) {
    if (pet.name.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('Pet name cannot be empty')));
    }
    if (pet.id == null) {
      return Future.value(
          Left(ValidationFailure('Pet ID is required for update')));
    }
    return repository.updatePet(pet);
  }
}
