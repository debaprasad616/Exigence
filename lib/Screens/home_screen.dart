import 'package:exigence_v6/Widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';

import '../Widgets/quickCall_widget.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: MapWidget(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display three widgets in a row
                  mainAxisSpacing: 8, // Adjust spacing between rows
                  crossAxisSpacing: 8, // Adjust spacing between columns
                ),
                itemCount: 3, // Display three widgets
                itemBuilder: (context, index) {
                  return QuickCallWidget(phoneNumber: "7008786967");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}