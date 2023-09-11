import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/quickCall_widget.dart';
import '../Widgets/camera_widget.dart';
import '../Widgets/map_widget.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';
import 'package:exigence_v6/Actions/AutoPhotoCapture.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

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
  late CameraController _cameraController;
  ShakeDetector? _shakeDetector;
  late PhotoCapture _photoCapture;

  @override
  void initState() {
    super.initState();
    _initializeCamera().then((_) {
      _initializeShakeDetector();
      _photoCapture = PhotoCapture(_cameraController);
    });
  }

  Future<String> shortenUrl(String longUrl) async {
    final response = await http.get(Uri.parse('http://tinyurl.com/api-create.php?url=$longUrl'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to shorten URL');
    }
  }


  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector(
      onShake: () async {
        _capturePhotoAndSendSMSAndEmail();
        print('Shaking detected!');
      },
    );
    _shakeDetector!.startListening();
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



  void _capturePhotoAndSendSMSAndEmail() async {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }

    final photoUrl = await _photoCapture.captureAndSavePhoto(); // Capture and get the photo URL
    final shortenedUrl = await shortenUrl(photoUrl!); // Shorten the URL

    final position = await _getCurrentLocation(); // Get the current location
    final locationMessage = "My current location is: https://www.google.com/maps?q=${position.latitude},${position.longitude}";

    final smsSender = SmsSender();
    smsSender.sendSMS(locationMessage); // Send the current location as an SMS message
    smsSender.sendSMS("Checkout this recent Auto captured Photo: $shortenedUrl"); // Include the shortened URL in the SMS message
    print('SMS sent with shortened URL: $shortenedUrl');
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
