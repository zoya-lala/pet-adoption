import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_state.dart';
import '../../model/pet_model.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('history'); // Navigate to History Page
        },
        child: const Icon(Icons.history),
      ),
      appBar: AppBar(title: const Text("Pet Adoption")),
      body: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          final adoptedPets =
              state.adoptedPetsList.map((pet) => pet.id).toSet();

          return ListView.builder(
            itemCount: 15, // Load at least 10 pets
            itemBuilder: (context, index) {
              final pet = Pet(
                id: 'pet$index',
                name: 'Pet $index',
                age: (index + 1),
                price: (index + 1) * 50,
                image: 'https://placekitten.com/200/200?image=$index',
                isAdopted: adoptedPets.contains('pet$index'),
              );

              return PetCard(pet: pet);
            },
          );
        },
      ),
    );
  }
}
