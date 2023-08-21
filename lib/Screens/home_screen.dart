import 'package:exigence_v6/Widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SmsSender smsSender = SmsSender();
    final shakeDetector = ShakeDetector(
      onShake: () {
        smsSender.sendSMS("Hey are you there");
        print('Shaking detected!');
      },
    );

    shakeDetector.startListening();

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: MapWidget(),
          ),
          Expanded(
            flex: 3,
            child: Container(

            ),
          ),
        ],
      ),
    );
  }
}


