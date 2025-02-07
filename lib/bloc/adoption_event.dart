import 'package:equatable/equatable.dart';

import '../../../model/pet_model.dart';

abstract class AdoptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdoptPet extends AdoptionEvent {
  final Pet pet;

  AdoptPet(this.pet);

  @override
  List<Object?> get props => [pet];
}

class LoadAdoptedPets extends AdoptionEvent {}
