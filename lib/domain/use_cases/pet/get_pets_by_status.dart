import 'package:petstore/domain/repositories/pet_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_cases/use_case.dart';
import '../../../core/utils/either.dart';
import '../../entities/pet.dart';

class GetPetsByStatus implements UseCase<List<Pet>, PetStatus> {
  final PetRepository repository;

  GetPetsByStatus(this.repository);

  @override
  Future<Either<Failure, List<Pet>>> call(PetStatus status) {
    return repository.getPetsByStatus(status);
  }
}
