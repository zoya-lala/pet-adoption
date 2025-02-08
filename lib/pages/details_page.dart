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

  const DetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
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
    await Future.delayed(const Duration(seconds: 2));

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
        title: const Text("Congratulations!"),
        content: Text("You've adopted ${widget.pet.name}!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.blueAccent,
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "PET",
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 16),

                // Name & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.pet.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Text(
                      "\$${widget.pet.price}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Pet Details: Origin, Height, Age, Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Text("Origin:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 5),
                        Text("Female",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueAccent,
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
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Age:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(width: 5),
                        Text("${widget.pet.age} years",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Weight:",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(width: 5),
                        const Text("10 kg",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),

                // Adopt Me Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.pet.isAdopted ? null : _handleAdoption,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      widget.pet.isAdopted ? "Already Adopted" : "Adopt Me",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
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
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(color: Colors.blueAccent),
          pageController: PageController(),
        ),
      ),
    );
  }
}
