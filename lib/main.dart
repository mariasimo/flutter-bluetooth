import 'package:flutter/material.dart';
import 'package:bluetooth_bridge/pages/Dashboard.dart';
import 'package:bluetooth_bridge/pages/SplashScreen.dart';
import 'theme/theme.dart' as Theme;

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.BBThemeData,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SplashScreen(),
        '/home': (BuildContext context) => Dashboard(),
      },
    );
  }
}
