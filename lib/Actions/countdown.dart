import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  final Function onCountdownFinish;

  CountdownScreen({required this.onCountdownFinish});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with SingleTickerProviderStateMixin {
  int countdown = 5;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdown),
    )..forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownFinish();
      }
    });

    startCountdown();
  }

  void startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
        _animationController.forward(from: 0); // Restart animation for each second
        startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _animationController.value;

    return WillPopScope(
      onWillPop: () async {
        _cancelCountdown();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '$countdown',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 16),
              Text(
                'Press "Cancel" to cancle sending your location, photo, and audio to your friends or family.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cancelCountdown,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Change button color to red
                ),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelCountdown() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
