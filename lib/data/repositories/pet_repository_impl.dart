import 'package:petstore/core/error/exception.dart';
import 'package:petstore/core/error/failure.dart';
import 'package:petstore/core/utils/either.dart';
import 'package:petstore/data/data_source/pet_remote_data_source.dart';
import 'package:petstore/data/models/pet_model.dart';
import 'package:petstore/domain/entities/pet.dart';
import 'package:petstore/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;

  PetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Pet>>> getPetsByStatus(PetStatus status) async {
    try {
      final petModels = await remoteDataSource.getPetsByStatus(status.value);
      final pets = petModels.map((model) => model.toDomain()).toList();
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Pet>> getPetById(int id) async {
    try {
      final petModel = await remoteDataSource.getPetById(id);
      return Right(petModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Pet>> createPet(Pet pet) async {
    try {
      final petModel = PetModel.fromDomain(pet);
      final createdPetModel = await remoteDataSource.createPet(petModel);
      return Right(createdPetModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Pet>> updatePet(Pet pet) async {
    try {
      final petModel = PetModel.fromDomain(pet);
      final updatedPetModel = await remoteDataSource.updatePet(petModel);
      return Right(updatedPetModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePet(int id) async {
    try {
      await remoteDataSource.deletePet(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
