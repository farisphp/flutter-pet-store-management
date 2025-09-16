import 'package:petstore/domain/use_cases/pet/create_pet.dart';
import 'package:petstore/domain/use_cases/pet/delete_pet.dart';
import 'package:petstore/domain/use_cases/pet/get_pets_by_status.dart';
import 'package:petstore/domain/use_cases/pet/update_pet.dart';
import 'package:petstore/ui/bloc/pet/pet_event.dart';
import 'package:petstore/ui/bloc/pet/pet_state.dart';

class PetBloc {
  final GetPetsByStatus getPetsByStatus;
  final CreatePet createPet;
  final UpdatePet updatePet;
  final DeletePet deletePet;

  PetState _state = const PetInitial();
  PetState get state => _state;

  final List<Function(PetState)> _listeners = [];

  PetBloc({
    required this.getPetsByStatus,
    required this.createPet,
    required this.updatePet,
    required this.deletePet,
  });

  void addListener(Function(PetState) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(PetState) listener) {
    _listeners.remove(listener);
  }

  void _emit(PetState state) {
    _state = state;
    for (final listener in _listeners) {
      listener(state);
    }
  }

  Future<void> add(PetEvent event) async {
    if (event is LoadPetsByStatus) {
      await _handleLoadPetsByStatus(event);
    } else if (event is CreatePetEvent) {
      await _handleCreatePet(event);
    } else if (event is UpdatePetEvent) {
      await _handleUpdatePet(event);
    } else if (event is DeletePetEvent) {
      await _handleDeletePet(event);
    }
  }

  Future<void> _handleLoadPetsByStatus(LoadPetsByStatus event) async {
    _emit(const PetLoading());
    final result = await getPetsByStatus(event.status);
    result.fold(
      (failure) => _emit(PetError(failure.message)),
      (pets) => _emit(PetLoaded(pets, event.status)),
    );
  }

  Future<void> _handleCreatePet(CreatePetEvent event) async {
    final result = await createPet(event.pet);
    result.fold(
      (failure) => _emit(PetError(failure.message)),
      (_) => _emit(const PetOperationSuccess('Pet created successfully')),
    );
  }

  Future<void> _handleUpdatePet(UpdatePetEvent event) async {
    final result = await updatePet(event.pet);
    result.fold(
      (failure) => _emit(PetError(failure.message)),
      (_) => _emit(const PetOperationSuccess('Pet updated successfully')),
    );
  }

  Future<void> _handleDeletePet(DeletePetEvent event) async {
    final result = await deletePet(event.id);
    result.fold(
      (failure) => _emit(PetError(failure.message)),
      (_) => _emit(const PetOperationSuccess('Pet deleted successfully')),
    );
  }

  void dispose() {
    _listeners.clear();
  }
}
