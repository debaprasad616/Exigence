

import 'package:exigence_v6/Screens/cameraScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Actions/flutterBackgroundServices.dart';
import 'Screens/home_screen.dart';
import 'Screens/register_screen.dart';


void main() async{
  runApp(MyApp());
  // await initializeService();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Use a consistent font family
      ),
      home: AppStart(),
    );
  }
}

class AppStart extends StatefulWidget {
  @override
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final registered = prefs.getBool('registered') ?? false;

    setState(() {
      _isRegistered = registered;
    });
  }


  @override
  Widget build(BuildContext context) {
    return _isRegistered ? HomeScreen() : RegistrationScreen();
    // return RegistrationScreen();
  }

}
