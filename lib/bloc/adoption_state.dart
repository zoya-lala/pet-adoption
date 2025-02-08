import 'package:equatable/equatable.dart';

import '../../../model/pet_model.dart';

class AdoptionState extends Equatable {
  final List<Pet> adoptedPetsList;

  const AdoptionState({required this.adoptedPetsList});

  List<Pet> get adoptedPets =>
      adoptedPetsList.where((pet) => pet.isAdopted).toList();

  AdoptionState copyWith({List<Pet>? adoptedPetsList}) {
    return AdoptionState(
      adoptedPetsList: adoptedPetsList ?? this.adoptedPetsList,
    );
  }

  @override
  List<Object?> get props => [adoptedPetsList];
}
