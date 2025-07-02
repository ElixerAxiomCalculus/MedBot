import 'package:flutter/material.dart';

final ThemeData medTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFFF5656),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Lexend',
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontFamily: 'MuseoModerno', color: Colors.redAccent),
    headlineMedium: TextStyle(fontFamily: 'Kodchasan', color: Colors.black),
    titleMedium: TextStyle(fontFamily: 'Comfortaa', color: Colors.black87),
    bodyLarge: TextStyle(fontFamily: 'Quicksand', color: Colors.black87),
    bodyMedium: TextStyle(fontFamily: 'Quicksand', color: Colors.black54),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Color(0xFFFF5656),
    primary: Color(0xFFFF5656),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);
