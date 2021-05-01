import 'package:flutter/material.dart';
import './MainPage.dart';
import 'theme/theme.dart' as Theme;

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: Theme.BBThemeData, home: MainPage());
  }
}
