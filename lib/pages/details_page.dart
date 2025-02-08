import 'dart:math'; // Import for pi

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/bloc/adoption_bloc.dart';
import 'package:pet_adoption/bloc/adoption_event.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../model/pet_model.dart';

class DetailsPage extends StatefulWidget {
  final Pet pet;

  DetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAdoption() async {
    if (mounted) {
      _confettiController.play();
    }
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      _showCongratulationsDialog();
    }

    if (!widget.pet.isAdopted) {
      BlocProvider.of<AdoptionBloc>(context, listen: false)
          .add(AdoptPet(widget.pet));
    }
  }

  Future<void> _showCongratulationsDialog() async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Congratulations!"),
        content: Text("You've adopted ${widget.pet.name}!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "PET",
          style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                fontSize: 22,
                letterSpacing: 2.0,
                // fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pet Image with Zoom
                GestureDetector(
                  onTap: () => _showImageViewer(context),
                  child: Hero(
                    tag: 'avatar-${widget.pet.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.pet.image,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Name & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.pet.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    Text(
                      "\$${widget.pet.price}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Pet Details: Origin, Height, Age, Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Origin:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 5),
                        Text("Female",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Height:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 5),
                        Text("10 cm",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Age:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 5),
                        Text(
                          "${widget.pet.age} years",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Weight:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 5),
                        Text("10 kg",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 24),

                // Adopt Me Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.pet.isAdopted ? null : _handleAdoption,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                    ),
                    child: Text(
                      widget.pet.isAdopted ? "Already Adopted" : "Adopt Me",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti Celebration at the Top Center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Confetti falls downward
              emissionFrequency: 0.05, // Frequency of confetti emission
              numberOfParticles: 30, // Increase for better effect
              maxBlastForce: 10, // Adjust for better spread
              minBlastForce: 5,
              gravity: 0.3, // Controls how fast it falls
              shouldLoop: false, // Play once per adoption
            ),
          ),
        ],
      ),
    );
  }

  void _showImageViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: PhotoViewGallery.builder(
          itemCount: 1,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.pet.image),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered,
            );
          },
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration:
              BoxDecoration(color: Theme.of(context).primaryColor),
          pageController: PageController(),
        ),
      ),
    );
  }
}
