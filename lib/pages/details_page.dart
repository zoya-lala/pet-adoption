import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../model/pet_model.dart';

class DetailsPage extends StatefulWidget {
  final Pet pet;

  const DetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.name)),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: widget.pet.id,
                child: Image.network(widget.pet.image, height: 250),
              ),
              const SizedBox(height: 16),
              Text("${widget.pet.age} years old",
                  style: const TextStyle(fontSize: 18)),
              Text("\$${widget.pet.price}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.pet.isAdopted
                    ? null
                    : () async {
                        print("Button Pressed: Starting adoption process");
                        try {
                          // Play confetti animation in the background
                          _confettiController.play();

                          // Add pet adoption event to BLoC (in background)
                          print("Dispatching AdoptPet event...");
                          BlocProvider.of<AdoptionBloc>(context)
                              .add(AdoptPet(widget.pet));

                          // Wait for state change to complete before showing dialog
                          await Future.delayed(Duration(seconds: 2));

                          print("Confetti complete, showing dialog");

                          // Show the congratulatory dialog after everything has processed
                          _showCongratulationsDialog();
                        } catch (e) {
                          print("Error during adoption: $e");
                          // Show error dialog if needed
                          _showErrorDialog(e);
                        }
                      },
                child:
                    Text(widget.pet.isAdopted ? "Already Adopted" : "Adopt Me"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -1.5, // Upward
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Congratulations!"),
        content: Text("You've adopted ${widget.pet.name}!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(dynamic error) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Error"),
            ));
  }
}
