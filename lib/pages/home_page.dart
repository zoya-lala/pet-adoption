import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_state.dart';
import '../../model/pet_model.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Pet> allPets = []; // Store all pets
  List<Pet> displayedPets = []; // Filtered pets for UI
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePets(); // Load initial pets
  }

  void _initializePets() {
    // Initially load pets, adoption state will be handled inside BlocBuilder
    allPets = List.generate(
      15,
      (index) => Pet(
        id: 'pet$index',
        name: 'Pet $index',
        age: (index + 1),
        price: (index + 1) * 50,
        image: 'https://picsum.photos/200/200?image=$index',
        isAdopted: false, // Will be updated inside BlocBuilder
      ),
    );

    displayedPets = List.from(allPets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('history'); // Navigate to History Page
        },
        child: const Icon(Icons.history),
      ),
      appBar: AppBar(
        title: const Text("Pet Adoption"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for pets...',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              onChanged: _filterPets,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<AdoptionBloc, AdoptionState>(
          builder: (context, state) {
            final adoptedPets =
                state.adoptedPetsList.map((pet) => pet.id).toSet();

            // Update pets dynamically based on adoption state
            final updatedPets = allPets.map((pet) {
              return pet.copyWith(isAdopted: adoptedPets.contains(pet.id));
            }).toList();

            // Ensure displayedPets matches the search filter with adoption state updates
            displayedPets = updatedPets
                .where((pet) => pet.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                .toList();

            // Handle pagination
            final start = pageIndex * 10;
            final end = (pageIndex + 1) * 10;
            final pagedPets = displayedPets.sublist(
                start, end < displayedPets.length ? end : displayedPets.length);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pagedPets.length,
                    itemBuilder: (context, index) {
                      final pet = pagedPets[index];
                      return PetCard(pet: pet);
                    },
                  ),
                ),
                if (pagedPets.length < displayedPets.length)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          pageIndex++;
                        });
                      },
                      child: const Text('Load More'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Filters pets based on search input
  void _filterPets(String query) {
    setState(() {
      pageIndex = 0; // Reset pagination
    });
  }
}
