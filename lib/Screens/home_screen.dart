
import 'package:exigence_v6/Actions/AutoAudioRecord.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Actions/ULRshorten.dart';
import '../Actions/countdown.dart';
import '../Widgets/quickCall_widget.dart';
import '../Widgets/map_widget.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';
import 'package:exigence_v6/Actions/AutoPhotoCapture.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ShakeDetector? _shakeDetector;

  late CameraController _cameraController;
  late PhotoCapture _photoCapture;
  late ShakeHandler _shakeHandler;
  late AudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _initializeCamera().then((_) {
      _initializeShakeDetector();
      _photoCapture = PhotoCapture(_cameraController);
      _audioRecorder = AudioRecorder();
    });
  }

  Future<Position> _getCurrentLocation() async {
    final permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } else {
      print("Location permission denied");
      throw Exception('Location permission denied');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _handleSendButtonClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountdownScreen(
          onCountdownFinish: () async {
            Navigator.pop(context); // Pop the countdown screen
            await _sendSMS(); // Send SMS after countdown
          },
        ),
      ),
    );
  }

  void _initializeShakeDetector() {
    bool isShakeEnabled = true;

    _shakeHandler = ShakeHandler(
      onShake: () async {
        try {
          if (isShakeEnabled) {
            isShakeEnabled = false; // Disable shake detection temporarily

            // Create an instance of AudioRecorder
            _audioRecorder = AudioRecorder();

            // Initialize microphone and start recording
            await _audioRecorder.startRecordingAndSaveToFirebase();

            // Capture and save a photo
            await _photoCapture.captureAndSavePhoto();

            _handleSendButtonClick();

            // Enable shake detection after a cooldown period
            Future.delayed(Duration(seconds: 15), () {
              isShakeEnabled = true;
            });
          }
        } catch (e) {
          print('Error during shake detection: $e');
        }
      },
    );
  }


  Future<void> _sendSMS() async {
    try {
      final smsSender = SmsSender();

      // Location
      final position = await _getCurrentLocation();
      final locationMessage =
          "Check out my location and reach here as soon as possible: https://www.google.com/maps?q=${Uri.encodeComponent(position.latitude.toString())},${Uri.encodeComponent(position.longitude.toString())}";

      smsSender.sendSMS(locationMessage);

      // Photo
      final photoUrl = await _photoCapture.captureAndSavePhoto();
      final shortenedPhotoUrl = await shortenUrl(photoUrl!);
      smsSender.sendSMS("I am in big trouble! here is an Auto-captured Photo: $shortenedPhotoUrl");

      // Audio
      final audioUrl = await _audioRecorder.startRecordingAndSaveToFirebase();
      final shortenedAudioUrl = await shortenUrl(audioUrl!);
      smsSender.sendSMS("Surrounding sound record: $shortenedAudioUrl");
    } catch (e) {
      print('Error during SMS sending: $e');
    }
  }










  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final List<QuickCallData> quickCallDataList = [
      QuickCallData(phoneNumber: "111", imageAsset: 'assets/images_call/ambulance.png'),
      QuickCallData(phoneNumber: "333", imageAsset: 'assets/images_call/fireBrigade.png'),
      QuickCallData(phoneNumber: "444", imageAsset: 'assets/images_call/police.png'),
      QuickCallData(phoneNumber: "222", imageAsset: 'assets/images_call/childhelpline.png'),
      QuickCallData(phoneNumber: "555", imageAsset: 'assets/images_call/seniorcitizenhelpline.png'),
      QuickCallData(phoneNumber: "666", imageAsset: 'assets/images_call/womenhelpline.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: MapWidget(),
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Quick Contacts",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: quickCallDataList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: QuickCallWidget(
                      phoneNumber: quickCallDataList[index].phoneNumber,
                      imageAsset: quickCallDataList[index].imageAsset,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickCallData {
  final String phoneNumber;
  final String imageAsset;

  QuickCallData({required this.phoneNumber, required this.imageAsset});
}
