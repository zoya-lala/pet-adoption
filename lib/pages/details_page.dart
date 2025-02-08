import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/bloc/adoption_bloc.dart';
import 'package:pet_adoption/bloc/adoption_event.dart';

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
    print("Adoption button clicked!");

    try {
      // Start playing the confetti animation
      if (mounted) {
        print("Playing confetti animation...");
        _confettiController.play();
      }

      // Wait for the confetti animation to complete before showing the dialog
      await Future.delayed(const Duration(
          seconds: 2)); // Match the duration of confetti animation

      // Show the congratulations dialog after confetti is done
      if (mounted) {
        print("Confetti completed, showing dialog...");
        await _showCongratulationsDialog(); // Wait for the dialog to close before continuing
      }

      // Adding a small delay before dispatching the event to ensure UI flow
      await Future.delayed(const Duration(
          milliseconds: 300)); // Small delay to allow UI to update

      // Check if the pet is already adopted to prevent dispatching if unnecessary
      if (!widget.pet.isAdopted) {
        print("Dispatching AdoptPet event...");
        BlocProvider.of<AdoptionBloc>(context, listen: false)
            .add(AdoptPet(widget.pet));
      }
    } catch (e, stackTrace) {
      print("Error during adoption: $e\n$stackTrace");
      if (mounted) {
        _showErrorDialog(e);
      }
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
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.name)),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  onPressed: widget.pet.isAdopted ? null : _handleAdoption,
                  child: Text(
                      widget.pet.isAdopted ? "Already Adopted" : "Adopt Me"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -1.5,
              shouldLoop: false,
            ),
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
        content: Text("Something went wrong: $error"),
      ),
    );
  }
}
