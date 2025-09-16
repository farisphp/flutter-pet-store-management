import 'package:petstore/domain/repositories/pet_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_cases/use_case.dart';
import '../../../core/utils/either.dart';
import '../../entities/pet.dart';

class CreatePet implements UseCase<Pet, Pet> {
  final PetRepository repository;

  CreatePet(this.repository);

  @override
  Future<Either<Failure, Pet>> call(Pet pet) {
    if (pet.name.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('Pet name cannot be empty')));
    }
    return repository.createPet(pet);
  }
}
