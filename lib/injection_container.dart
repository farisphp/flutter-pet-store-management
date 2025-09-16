import 'package:http/http.dart' as http;
import 'package:petstore/core/di/service_locator.dart';
import 'package:petstore/data/data_source/pet_remote_data_source.dart';
import 'package:petstore/data/repositories/pet_repository_impl.dart';
import 'package:petstore/domain/repositories/pet_repository.dart';
import 'package:petstore/domain/use_cases/pet/create_pet.dart';
import 'package:petstore/domain/use_cases/pet/delete_pet.dart';
import 'package:petstore/domain/use_cases/pet/get_pets_by_status.dart';
import 'package:petstore/domain/use_cases/pet/update_pet.dart';
import 'package:petstore/ui/bloc/pet/pet_bloc.dart';

void setupDependencies() {
  final sl = ServiceLocator();

  // External
  sl.registerSingleton<http.Client>(http.Client());

  // Data sources
  sl.registerSingleton<PetRemoteDataSource>(
    PetRemoteDataSourceImpl(client: sl.get<http.Client>()),
  );

  // Repository
  sl.registerSingleton<PetRepository>(
    PetRepositoryImpl(remoteDataSource: sl.get<PetRemoteDataSource>()),
  );

  // Use cases
  sl.registerSingleton<GetPetsByStatus>(
    GetPetsByStatus(sl.get<PetRepository>()),
  );
  sl.registerSingleton<CreatePet>(
    CreatePet(sl.get<PetRepository>()),
  );
  sl.registerSingleton<UpdatePet>(
    UpdatePet(sl.get<PetRepository>()),
  );
  sl.registerSingleton<DeletePet>(
    DeletePet(sl.get<PetRepository>()),
  );

  // BLoC
  sl.registerSingleton<PetBloc>(
    PetBloc(
      getPetsByStatus: sl.get<GetPetsByStatus>(),
      createPet: sl.get<CreatePet>(),
      updatePet: sl.get<UpdatePet>(),
      deletePet: sl.get<DeletePet>(),
    ),
  );
}
