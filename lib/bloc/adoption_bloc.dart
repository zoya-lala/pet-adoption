import 'dart:async'; // Import this for Completer

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/pet_model.dart';
import 'adoption_event.dart';
import 'adoption_state.dart';

class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  static const String adoptedPetsBoxKey = 'adopted_pets';
  Box<Pet>? adoptedPetsBox; // ✅ Changed from `late` to nullable (`Box<Pet>?`)

  AdoptionBloc() : super(AdoptionState(adoptedPetsList: [])) {
    _initializeHiveBox(); // Initialize the box when the bloc is created
    on<AdoptPet>(_onAdoptPet);
    on<LoadAdoptedPets>(_onLoadAdoptedPets);
  }

  // ✅ Ensure Hive Box is initialized only once
  Future<void> _initializeHiveBox() async {
    if (adoptedPetsBox == null) {
      print("📦 Initializing Hive Box...");
      adoptedPetsBox = await Hive.openBox<Pet>(adoptedPetsBoxKey);
      print("✅ Hive Box Initialized: ${adoptedPetsBox!.length} pets loaded.");
    }
  }

  // ✅ Adopt Pet event handler
  void _onAdoptPet(AdoptPet event, Emitter<AdoptionState> emit) async {
    print("🟢 AdoptPet event received: ${event.pet.name}");

    try {
      await _initializeHiveBox(); // ✅ Ensure box is initialized

      if (adoptedPetsBox == null) {
        print("❌ Hive Box not initialized.");
        return;
      }

      // ✅ Check if pet is already adopted
      if (!state.adoptedPetsList.any((pet) => pet.id == event.pet.id)) {
        final updatedPet = event.pet.copyWith(isAdopted: true);
        final updatedList = [...state.adoptedPetsList, updatedPet];

        await adoptedPetsBox!.put(updatedPet.id, updatedPet);

        // ✅ Debugging logs
        print(
            "✅ Pet Adopted: ${updatedPet.id}, isAdopted: ${updatedPet.isAdopted}");
        print("✅ Adopted Pets Updated: $updatedList");

        emit(state.copyWith(adoptedPetsList: updatedList));
      } else {
        print("⚠️ Pet ${event.pet.name} is already adopted!");
      }
    } catch (e) {
      print("❌ Error during adoption in Bloc: $e");
      emit(state.copyWith(
          adoptedPetsList:
              state.adoptedPetsList)); // Emit previous state in case of error
    }
  }

  // ✅ Load adopted pets
  void _onLoadAdoptedPets(
      LoadAdoptedPets event, Emitter<AdoptionState> emit) async {
    await _initializeHiveBox();

    if (adoptedPetsBox == null) {
      print("❌ Hive Box not initialized.");
      return;
    }

    try {
      final adoptedPets = adoptedPetsBox!.values.toList();
      print("✅ Loaded Adopted Pets from Hive: $adoptedPets");

      emit(state.copyWith(adoptedPetsList: adoptedPets));
    } catch (e) {
      print("❌ Error loading adopted pets: $e");
    }
  }
}
