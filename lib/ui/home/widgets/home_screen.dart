import 'package:flutter/material.dart';
import 'package:petstore/core/di/service_locator.dart';
import 'package:petstore/domain/entities/pet.dart';
import 'package:petstore/ui/bloc/pet/pet_bloc.dart';
import 'package:petstore/ui/bloc/pet/pet_event.dart';
import 'package:petstore/ui/bloc/pet/pet_state.dart';
import 'package:petstore/ui/home/widgets/home_pet_card.dart';
import 'package:petstore/ui/home/widgets/home_pet_dialog.dart';

class PetStoreHomePage extends StatefulWidget {
  @override
  _PetStoreHomePageState createState() => _PetStoreHomePageState();
}

class _PetStoreHomePageState extends State<PetStoreHomePage> {
  late final PetBloc _petBloc;
  PetStatus _selectedStatus = PetStatus.available;

  @override
  void initState() {
    super.initState();
    _petBloc = ServiceLocator().get<PetBloc>();
    _petBloc.addListener(_onStateChange);
    _loadPets();
  }

  void _onStateChange(PetState state) {
    if (mounted) {
      setState(() {});

      if (state is PetError) {
        _showSnackBar(state.message, Colors.red);
      } else if (state is PetOperationSuccess) {
        _showSnackBar(state.message, Colors.green);
        _loadPets(); // Reload after successful operation
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _loadPets() {
    _petBloc.add(LoadPetsByStatus(_selectedStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Store Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButton<PetStatus>(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              value: _selectedStatus,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              underline: Container(),
              items: PetStatus.values.map((PetStatus status) {
                return DropdownMenuItem<PetStatus>(
                  value: status,
                  child: Text(status.value.toUpperCase()),
                );
              }).toList(),
              onChanged: (PetStatus? newValue) {
                if (newValue != null && newValue != _selectedStatus) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                  _loadPets();
                }
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPetDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }

  Widget _buildBody() {
    final state = _petBloc.state;

    if (state is PetLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading pets...'),
          ],
        ),
      );
    } else if (state is PetLoaded) {
      if (state.pets.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No pets found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${_selectedStatus.value.toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => _loadPets(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.pets.length,
          itemBuilder: (context, index) {
            final pet = state.pets[index];
            return PetCard(
              pet: pet,
              onEdit: () => _showPetDialog(pet: pet),
              onDelete: () => _showDeleteConfirmation(pet.id!),
            );
          },
        ),
      );
    } else if (state is PetError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red.shade600,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPets,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Pet Store',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Select a status to view pets',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  void _showPetDialog({Pet? pet}) {
    showDialog(
      context: context,
      builder: (context) => PetDialog(
        pet: pet,
        onSave: (Pet savedPet) {
          if (pet == null) {
            _petBloc.add(CreatePetEvent(savedPet));
          } else {
            _petBloc.add(UpdatePetEvent(savedPet));
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: const Text(
            'Are you sure you want to delete this pet? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _petBloc.add(DeletePetEvent(id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _petBloc.removeListener(_onStateChange);
    super.dispose();
  }
}
