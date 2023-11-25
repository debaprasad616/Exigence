import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  final Function onCountdownFinish;

  CountdownScreen({required this.onCountdownFinish});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}


class _CountdownScreenState extends State<CountdownScreen> with SingleTickerProviderStateMixin {
  int countdown = 555555;
  late AnimationController _linearAnimationController;

  late Animation<double> _linearAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_linearAnimationController);


  @override
  void initState() {
    super.initState();

    _linearAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdown),
    );

    _linearAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_linearAnimationController);

    _linearAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownFinish();
      }
    });

    _linearAnimationController.forward();

    startCountdown();
  }

  void startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
        _linearAnimationController.forward(from: 0); // Restart linear animation for each second
        startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              RotationTransition(
                turns: _linearAnimation,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              AnimatedTextCountdown(
                value: countdown,
                duration: Duration(seconds: 1),
              ),
              SizedBox(height: 16),
              Text(
                'Press "Cancel" to send your location, photo, and audio to your friend or family.',
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
    _linearAnimationController.dispose();
    super.dispose();
  }
}

class AnimatedTextCountdown extends StatelessWidget {
  final int value;
  final Duration duration;

  AnimatedTextCountdown({required this.value, required this.duration});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: value + 1, end: value),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          'Sending in $value seconds',
          style: TextStyle(fontSize: 20),
        );
      },
    );
  }
}
