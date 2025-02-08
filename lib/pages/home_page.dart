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
  List<Pet> allPets = [];
  List<Pet> displayedPets = [];
  int pageIndex = 0;
  final int pageSize = 10; // Number of pets per page

  @override
  void initState() {
    super.initState();
    _initializePets();
  }

  void _initializePets() {
    allPets = List.generate(
      15,
      (index) => Pet(
        id: 'pet$index',
        name: 'Pet $index',
        age: (index + 1),
        price: (index + 1) * 50,
        image: 'https://picsum.photos/200/200?image=$index',
        isAdopted: false,
      ),
    );
    displayedPets = List.from(allPets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('history');
        },
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Icon(Icons.history,
            color: Theme.of(context)
                .floatingActionButtonTheme
                .foregroundColor), // Dark blue icon
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Light shadow color
                    blurRadius: 8, // Soft blur effect
                    offset: Offset(0, 4), // Moves shadow slightly down
                  ),
                ],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search for pets...',
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                ),
                onChanged: _filterPets,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            // Rounded Rectangular Box
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adopt your favorite pet",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                          // style: TextStyle(
                          //   fontSize: 18,
                          //   fontWeight: FontWeight.bold,
                          //   color: Theme.of(context)
                          //       .bodyMedium,
                          // ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Find your furry friend and give them a home!",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  // fontSize: 18,
                                  // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    "https://cdn-icons-png.flaticon.com/512/616/616554.png",
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ),

            // Pet List with Pagination
            Expanded(
              child: BlocBuilder<AdoptionBloc, AdoptionState>(
                builder: (context, state) {
                  final adoptedPets =
                      state.adoptedPetsList.map((pet) => pet.id).toSet();
                  final updatedPets = allPets.map((pet) {
                    return pet.copyWith(
                        isAdopted: adoptedPets.contains(pet.id));
                  }).toList();

                  displayedPets = updatedPets
                      .where((pet) => pet.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();

                  final start = pageIndex * pageSize;
                  final end = (pageIndex + 1) * pageSize;
                  final pagedPets = displayedPets.sublist(start,
                      end < displayedPets.length ? end : displayedPets.length);

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Load More Button
                          if (end < displayedPets.length)
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    pageIndex++;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .floatingActionButtonTheme
                                      .backgroundColor, // Light blue background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 24.0), // Added padding
                                ),
                                child: Text(
                                  'Load More',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .foregroundColor,
                                      fontWeight:
                                          FontWeight.w500), // Dark blue text
                                ),
                              ),
                            ),
                          // Load Less Button (Only visible if we moved forward)
                          if (pageIndex > 0)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    pageIndex--;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .floatingActionButtonTheme
                                      .backgroundColor, // Light blue background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 24.0), // Added padding
                                ),
                                child: Text(
                                  'Load Less',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .floatingActionButtonTheme
                                        .foregroundColor,
                                  ), // Dark blue text
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterPets(String query) {
    setState(() {
      pageIndex = 0;
    });
  }
}
