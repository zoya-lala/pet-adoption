import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/pet_model.dart';
import 'adoption_event.dart';
import 'adoption_state.dart';

class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  static const String adoptedPetsBoxKey = 'adopted_pets';
  late final Box<Pet> adoptedPetsBox; // Late initialization

  AdoptionBloc() : super(AdoptionState(adoptedPetsList: [])) {
    _initializeHiveBox(); // Initialize the box when the bloc is created.
    on<AdoptPet>(_onAdoptPet);
    on<LoadAdoptedPets>(_onLoadAdoptedPets);
  }

  // Method to initialize the Hive box
  Future<void> _initializeHiveBox() async {
    if (!Hive.isBoxOpen(adoptedPetsBoxKey)) {
      await Hive.openBox<Pet>(
          adoptedPetsBoxKey); // Open the box if not already opened.
    }
    adoptedPetsBox =
        Hive.box<Pet>(adoptedPetsBoxKey); // Now it can safely access the box
  }

  void _onAdoptPet(AdoptPet event, Emitter<AdoptionState> emit) {
    if (!state.adoptedPetsList.contains(event.pet)) {
      final updatedList = [...state.adoptedPetsList, event.pet];
      adoptedPetsBox.put(event.pet.id, event.pet.copyWith(isAdopted: true));
      emit(state.copyWith(adoptedPetsList: updatedList));
    }
  }

  void _onLoadAdoptedPets(
      LoadAdoptedPets event, Emitter<AdoptionState> emit) async {
    // Ensure the box is initialized before using it
    await _initializeHiveBox();
    final adoptedPets = adoptedPetsBox.values.toList();
    emit(state.copyWith(adoptedPetsList: adoptedPets));
  }
}
