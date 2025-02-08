import 'package:flutter/material.dart';

import '../../model/pet_model.dart';
import '../pages/details_page.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pet.isAdopted
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailsPage(pet: pet)),
              );
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'avatar-${pet.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  pet.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: 'name-${pet.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${pet.age} years old • \$${pet.price}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            pet.isAdopted
                ? Text("Already Adopted", style: TextStyle(color: Colors.grey))
                : IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsPage(pet: pet))),
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).iconTheme.color),
                  ),
          ],
        ),
      ),
    );
  }
}
