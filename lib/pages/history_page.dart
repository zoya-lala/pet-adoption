import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/bloc/adoption_state.dart';

import '../../bloc/adoption_bloc.dart';
import '../../model/pet_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Adoption History',
        style: TextStyle(
          letterSpacing: 1.0,
          color: Theme.of(context).appBarTheme.titleTextStyle!.color,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          if (state.adoptedPets.isEmpty) {
            return const Center(
              child: Text('No pets have been adopted yet.'),
            );
          }
          return ListView.builder(
            itemCount: state.adoptedPets.length,
            itemBuilder: (context, index) {
              final Pet pet = state.adoptedPets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(pet.image),
                ),
                title: Text(pet.name),
                subtitle: Text('${pet.age} years old - \$${pet.price}'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
