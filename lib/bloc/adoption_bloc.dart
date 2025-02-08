import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/pet_model.dart';
import 'adoption_event.dart';
import 'adoption_state.dart';

class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  static const String adoptedPetsBoxKey = 'adopted_pets';
  Box<Pet>? adoptedPetsBox;

  AdoptionBloc() : super(AdoptionState(adoptedPetsList: [])) {
    _initializeHiveBox();
    on<AdoptPet>(_onAdoptPet);
    on<LoadAdoptedPets>(_onLoadAdoptedPets);
  }

  Future<void> _initializeHiveBox() async {
    if (adoptedPetsBox == null) {
      adoptedPetsBox = await Hive.openBox<Pet>(adoptedPetsBoxKey);
    }
  }

  void _onAdoptPet(AdoptPet event, Emitter<AdoptionState> emit) async {
    try {
      await _initializeHiveBox();

      if (adoptedPetsBox == null) {
        return;
      }

      if (!state.adoptedPetsList.any((pet) => pet.id == event.pet.id)) {
        final updatedPet = event.pet.copyWith(isAdopted: true);
        final updatedList = [...state.adoptedPetsList, updatedPet];

        await adoptedPetsBox!.put(updatedPet.id, updatedPet);

        emit(state.copyWith(adoptedPetsList: updatedList));
      }
    } catch (e) {
      emit(state.copyWith(adoptedPetsList: state.adoptedPetsList));
    }
  }

  void _onLoadAdoptedPets(
      LoadAdoptedPets event, Emitter<AdoptionState> emit) async {
    await _initializeHiveBox();

    if (adoptedPetsBox == null) {
      return;
    }

    try {
      final adoptedPets = adoptedPetsBox!.values.toList();
      emit(state.copyWith(adoptedPetsList: adoptedPets));
    } catch (e) {}
  }
}
