import 'package:petstore/domain/repositories/pet_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_cases/use_case.dart';
import '../../../core/utils/either.dart';

class DeletePet implements UseCase<void, int> {
  final PetRepository repository;

  DeletePet(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    if (id <= 0) {
      return Future.value(Left(ValidationFailure('Invalid pet ID')));
    }
    return repository.deletePet(id);
  }
}
