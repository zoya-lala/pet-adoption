import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_adoption/bloc/adoption_bloc.dart';
import 'package:pet_adoption/model/pet_model.dart';
import 'package:pet_adoption/router.dart';
import 'package:pet_adoption/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());

  // if (!Hive.isBoxOpen('adopted_pets')) {
  //   await Hive.openBox('adopted_pets');
  // } // Ensure Box is opened

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdoptionBloc(),
      child: MaterialApp.router(
        theme: AppTheme.lightTheme, // Use the light theme here
        darkTheme: AppTheme.darkTheme, // Use the dark theme
        themeMode: ThemeMode.system, // Set the theme mode (light/dark)
        debugShowCheckedModeBanner: false,
        // theme: lightTheme,
        // darkTheme: darkTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
