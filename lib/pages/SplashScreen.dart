// https://stackoverflow.com/questions/43879103/adding-a-splash-screen-to-flutter-apps
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart' as Theme;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).popAndPushNamed('/home');
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.BBColors.navy[500],
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: new Image.asset(
              'assets/splash-background.png',
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Text(
                  "A SCE Product".toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1),
                ),
              )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/splash-icon.png',
                height: 100,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 40),
              Text(
                "Bluetooth Bridge",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
