import 'package:flutter/material.dart';
import 'package:kifinserv/constants/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.royalBlue,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Poppins',

  colorScheme: const ColorScheme.light(
    primary: AppColors.royalBlue,
    secondary: AppColors.accentGreen,
    background: Colors.white,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.textDark,
    onSurface: AppColors.textDark,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textDark,
    elevation: 1,
    iconTheme: IconThemeData(color: AppColors.textDark),
    titleTextStyle: TextStyle(
      color: AppColors.textDark,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textDark),
    bodyMedium: TextStyle(color: AppColors.textDark),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),

  cardTheme: const CardTheme(
    color: Colors.white,
    shadowColor: Colors.black12,
    elevation: 4,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  iconTheme: const IconThemeData(color: AppColors.royalBlue),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.royalBlue,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.royalBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),

  inputDecorationTheme:  InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
   
    ),
    
    labelStyle: TextStyle(color: AppColors.textDark),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.royalBlue,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: AppColors.textDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),

  dividerColor: Colors.grey[300],
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.royalBlue,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  fontFamily: 'Poppins',

  colorScheme: const ColorScheme.dark(
    primary: AppColors.royalBlue,
    secondary: AppColors.accentGreen,
    background: AppColors.backgroundDark,
    surface: AppColors.cardDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.textLight,
    onSurface: AppColors.textLight,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.textLight,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textLight),
    titleTextStyle: TextStyle(
      color: AppColors.textLight,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textLight),
    bodyMedium: TextStyle(color: AppColors.textLight),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),

  cardTheme: const CardTheme(
    color: AppColors.cardDark,
    shadowColor: Colors.black45,
    elevation: 4,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  iconTheme: const IconThemeData(color: AppColors.textLight),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accentGreen,
    foregroundColor: Colors.black,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.royalBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.cardDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.accentGreen),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.accentGreen),
    ),
    labelStyle: TextStyle(color: AppColors.textLight),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.cardDark,
    selectedItemColor: AppColors.accentGreen,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  dialogTheme: const DialogTheme(
    backgroundColor: AppColors.cardDark,
    titleTextStyle: TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: AppColors.textLight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),

  dividerColor: Colors.grey,
);
