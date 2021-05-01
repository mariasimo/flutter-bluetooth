// https://gist.github.com/mikemimik/5ac2fa98fe6d132098603c1bd40263d5
import 'package:flutter/material.dart';

final ThemeData CompanyThemeData = new ThemeData(
  backgroundColor: CompanyColors.grey[500],
  brightness: Brightness.light,
  primarySwatch:
      MaterialColor(CompanyColors.blue[500].value, CompanyColors.blue),
  primaryColor: CompanyColors.blue[500],
  primaryColorBrightness: Brightness.light,
  accentColor: CompanyColors.green[500],
  accentColorBrightness: Brightness.light,

  // Define the default font family.
  fontFamily: 'Poppins',

  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: CompanyColors.grey[900],
    ),
    subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    button: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: CompanyColors.blue[500],
      textStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      padding: EdgeInsets.all(14),
    ),
  ),
);

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const MaterialColor grey =
      MaterialColor(_greyPrimaryValue, <int, Color>{
    50: Color(0xFFF4F5F7),
    100: Color(0xFFDFE6EA),
    200: Color(0xFFA8B0B4),
    300: Color(0xFF859096),
    400: Color(0xFF688191),
    500: Color(_greyPrimaryValue),
    600: Color(0xFF4A5861),
    700: Color(0xFF404E56),
    800: Color(0xFF37444C),
    900: Color(0xFF1F2427),
  });
  static const int _greyPrimaryValue = 0xFF516069;

  static const Map<int, Color> blue = const <int, Color>{
    50: Color(0xFFE8F0FF),
    100: Color(0xFFC5DAFF),
    200: Color(0xFF9EC1FF),
    300: Color(0xFF77A8FF),
    400: Color(0xFF5A95FF),
    500: Color(0xFF3D82FF),
    600: Color(0xFF377AFF),
    700: Color(0xFF2F6FFF),
    800: Color(0xFF2765FF),
    900: Color(0xFF1A52FF),
  };

  static const Map<int, Color> green = const <int, Color>{
    50: Color(0xFFECFCF4),
    100: Color(0xFFD0F7E4),
    200: Color(0xFFB1F1D2),
    300: Color(0xFF91EBC0),
    400: Color(0xFF7AE7B3),
    500: Color(0xFF62E3A5),
    600: Color(0xFF5AE09D),
    700: Color(0xFF50DC93),
    800: Color(0xFF46D88A),
    900: Color(0xFF34D079),
  };
}
