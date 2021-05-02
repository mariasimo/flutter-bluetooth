// https://gist.github.com/mikemimik/5ac2fa98fe6d132098603c1bd40263d5
import 'package:flutter/material.dart';

final ThemeData BBThemeData = new ThemeData(
  backgroundColor: BBColors.grey[50],
  brightness: Brightness.light,
  primarySwatch: MaterialColor(BBColors.blue[500].value, BBColors.blue),
  primaryColor: BBColors.blue[500],
  primaryColorBrightness: Brightness.light,
  accentColor: BBColors.green[500],
  accentColorBrightness: Brightness.light,

  // Define the default font family.
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: BBColors.grey[900],
    ),
    headline2: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w600,
      color: BBColors.grey[900],
    ),
    headline3: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: BBColors.grey[900],
    ),
    subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    button: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: BBColors.blue[500],
      textStyle: TextStyle(
          color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
    ),
  ),
  dividerTheme: DividerThemeData(color: BBColors.grey[300]),
  cardTheme: CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: BBColors.grey[100]),
    ),
    margin: EdgeInsets.all(0),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: BBColors.grey[50],
    elevation: 0,
  ),
  scaffoldBackgroundColor: BBColors.grey[50],
);

class BBColors {
  BBColors._(); // this basically makes it so you can instantiate this class

  static const Map<int, Color> grey = const <int, Color>{
    50: Color(0xFFF4F5F7),
    100: Color(0xFFDFE6EA),
    200: Color(0xFFA8B0B4),
    300: Color(0xFF859096),
    400: Color(0xFF688191),
    500: Color(0xFF516069),
    600: Color(0xFF4A5861),
    700: Color(0xFF404E56),
    800: Color(0xFF37444C),
    900: Color(0xFF1F2427),
  };

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

  static const Map<int, Color> navy = const <int, Color>{
    50: Color(0xFFE1E7F0),
    100: Color(0xFFB3C2D9),
    200: Color(0xFF8099BF),
    300: Color(0xFF4D70A5),
    400: Color(0xFF275292),
    500: Color(0xFF01337F),
    600: Color(0xFF012E77),
    700: Color(0xFF01276C),
    800: Color(0xFF012062),
    900: Color(0xFF00144F),
  };

  static const Map<int, Color> ruby = const <int, Color>{
    50: Color(0xFFFFEBEC),
    100: Color(0xFFFFCDD0),
    200: Color(0xFFFFACB1),
    300: Color(0xFFFE8B92),
    400: Color(0xFFFE727A),
    500: Color(0xFFFE5963),
    600: Color(0xFFFE515B),
    700: Color(0xFFFE4851),
    800: Color(0xFFFE3E47),
    900: Color(0xFFFD2E35),
  };

  static const Map<int, Color> yellow = const <int, Color>{
    50: Color(0xFFFEF5EA),
    100: Color(0xFFFEE5CB),
    200: Color(0xFFFDD4A9),
    300: Color(0xFFFCC387),
    400: Color(0xFFFBB66D),
    500: Color(0xFFFAA953),
    600: Color(0xFFF9A24C),
    700: Color(0xFFF99842),
    800: Color(0xFFF88F39),
    900: Color(0xFFF67E29),
  };
}
