import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shakeDetector = ShakeDetector(
      onShake: () {
        // Action to perform when shaking is detected
        print('Shaking detected!');

        // Send an SMS when shaking is detected
        // SmsSender.sendSms();
      },
    );


    shakeDetector.startListening();

    return Scaffold(
      appBar: AppBar(title: Text('Emergency App')),
      body: Column(
        children: [
          Expanded(
            flex: 1, // Take the top half of the screen
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(16),
              child: Center(child: Text('Map Widget')),
            ),
          ),
          Expanded(
            flex: 1, // Take the bottom half of the screen
            child: Container(
              color: Colors.grey[200], // Placeholder color
              // Your other widgets here for the bottom half
            ),
          ),
        ],
      ),
    );
  }
}
