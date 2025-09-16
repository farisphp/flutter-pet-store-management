import '../../../core/error/failure.dart';
import '../../../core/utils/either.dart';
import '../../../domain/entities/pet.dart';

abstract class PetRepository {
  Future<Either<Failure, List<Pet>>> getPetsByStatus(PetStatus status);
  Future<Either<Failure, Pet>> getPetById(int id);
  Future<Either<Failure, Pet>> createPet(Pet pet);
  Future<Either<Failure, Pet>> updatePet(Pet pet);
  Future<Either<Failure, void>> deletePet(int id);
}
