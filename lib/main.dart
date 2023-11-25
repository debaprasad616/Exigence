import 'package:exigence_v6/Screens/OnBoardingScreen.dart';
import 'package:exigence_v6/Screens/home_screen.dart';
import 'package:exigence_v6/Screens/register_ScreenF.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Actions/flutterBackgroundServices.dart';
import 'Screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

    // Navigate to the appropriate screen based on registration status
    if (_isRegistered) {
      // If registered, open HomeScreen directly
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // If not registered, open OnboardingScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can return an empty container here as the navigation is done in _checkRegistrationStatus
    return Container();
  }
}
