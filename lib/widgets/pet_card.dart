import 'package:flutter/material.dart';

import '../../model/pet_model.dart';
import '../pages/details_page.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(pet.image)),
        title: Text(pet.name),
        subtitle: Text("${pet.age} years old • \$${pet.price}"),
        trailing: pet.isAdopted
            ? const Text("Already Adopted",
                style: TextStyle(color: Colors.grey))
            : const Icon(Icons.arrow_forward),
        onTap: pet.isAdopted
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailsPage(pet: pet)),
                );
              },
      ),
    );
  }
}
