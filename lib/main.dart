
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/home_screen.dart';
import 'Screens/register_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    return RegistrationScreen();
  }
}
