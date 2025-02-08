import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    secondaryHeaderColor: Colors.lightBlue.shade100,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100], // Updated property
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[100],
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlue,
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.lightBlue,
    ),
    textTheme: TextTheme(
      // Updated text theme properties for new Flutter versions
      titleLarge: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 18), // Formerly headline6
      bodyLarge: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.w500,
      ), // Formerly bodyText1
      bodyMedium: TextStyle(color: Colors.black), // Formerly bodyText2
    ),
    iconTheme: IconThemeData(color: Colors.blueAccent),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black87,
    secondaryHeaderColor: Colors.black87,

    scaffoldBackgroundColor: Colors.grey[900], // Updated property
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.black87,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18), // Formerly headline6
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ), // Formerly bodyText1
      bodyMedium: TextStyle(color: Colors.white), // Formerly bodyText2
    ),
    iconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
