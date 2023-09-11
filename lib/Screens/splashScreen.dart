import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can change the background color
      body: Center(
        child: Image.asset('assets/Image_Onboarding/SplashScreen.png'), // Use the path to your splash image
      ),
    );
  }
}
