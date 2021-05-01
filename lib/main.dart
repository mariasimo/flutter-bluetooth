import 'package:flutter/material.dart';
import './MainPage.dart';
import 'theme/index.dart' as Theme;

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: Theme.CompanyThemeData, home: MainPage());
  }
}
