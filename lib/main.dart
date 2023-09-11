

import 'package:exigence_v6/Screens/OnBoardingScreen.dart';
import 'package:exigence_v6/Screens/Try_Screen.dart';
import 'package:exigence_v6/Screens/register_ScreenF.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Actions/flutterBackgroundServices.dart';
import 'Screens/home_screen.dart';
import 'Screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      // Use a Future.delayed to display the SplashScreen for a few seconds.
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3), () => true), // Adjust the duration as needed
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show the SplashScreen while waiting
          } else {
            return HomeScreen(); // Navigate to your main screen
          }
        },
      ),
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
    return _isRegistered ? HomeScreen() : OnboardingScreen();
    // return RegistrationScreen();
  }

}
