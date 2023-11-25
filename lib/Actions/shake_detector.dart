import 'package:sensors/sensors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShakeDetector {
  final Function() onShake;

  ShakeDetector({required this.onShake});

  void startListening() {
    accelerometerEvents.listen((event) {
      final acceleration = event.x * event.x + event.y * event.y + event.z * event.z;
      if (acceleration > 30 * 30) {
        onShake();

        // Show a toast when shaking is detected
        Fluttertoast.showToast(
          msg: 'Phone shaken!!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

}

class ShakeHandler {
  ShakeDetector? _shakeDetector;

  ShakeHandler({
    required Function() onShake,
  }) {
    _shakeDetector = ShakeDetector(
      onShake: () async {
        onShake();
        print('Shaking detected!');
      },
    );
    _shakeDetector!.startListening();
  }
}
