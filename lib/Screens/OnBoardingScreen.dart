import 'package:exigence_v6/Screens/home_screen.dart';
import 'package:exigence_v6/Screens/register_ScreenF.dart';
import 'package:exigence_v6/Screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> _requestPermissionsForFeature(int featureIndex) async {
  switch (featureIndex) {
    case 0: // Send Instant Message (SMS permission)
      final status = await Permission.sms.request();
      // Handle the permission status (granted, denied, etc.)
      break;

    case 1: // Send Location (Location permission)
      final status = await Permission.location.request();
      // Handle the permission status
      break;

    case 2: // Capture & Send Photos (Camera permission)
      final status = await Permission.camera.request();
      // Handle the permission status
      break;

    case 3: // Record Surrounding Sound (Microphone permission)
      final status = await Permission.microphone.request();
      // Handle the permission status
      break;

    case 4: // Dial Emergency Contact with One Tap (Phone permission)
      final status = await Permission.phone.request();
      // Handle the permission status
      break;

    default:
    // Handle other cases or feature indices if needed
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

// Add the new feature to the features list
  final List<OnboardingFeature> features = [
    OnboardingFeature(
      title: "Send Instant Message",
      description: "Easily Send emergency message.",
      image: "assets/Image_Onboarding/message.png",
    ),
    OnboardingFeature(
      title: "Send Location",
      description: "Easily share your live location with others.",
      image: "assets/Image_Onboarding/location.png",
    ),
    OnboardingFeature(
      title: "Capture & Send Photos",
      description: "Take and share photos instantly.",
      image: "assets/Image_Onboarding/camera.png",
    ),
    OnboardingFeature(
      title: "Record Surrounding Sound",
      description: "Record and send surrounding audio.",
      image: "assets/Image_Onboarding/sound.png",
    ),
    OnboardingFeature(
      title: "Dial Emergency Contact with One Tap",
      description: "Call instantly for help.",
      image: "assets/Image_Onboarding/emergencyContact.png",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: features.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });

              // Request permissions for the current feature
              _requestPermissionsForFeature(index);
            },


            itemBuilder: (context, index) {
              return FeaturePage(features[index]);
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Row(
              children: List.generate(
                features.length,
                    (index) => _buildIndicator(index),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _currentPage == features.length - 1
                ? ElevatedButton(
              onPressed: () {
                // Navigate to the home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreenF(), // Replace HomeScreen() with your home screen widget
                  ));
              },
              child: Text("Get Started"),
            )

                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}


class OnboardingFeature {
  final String title;
  final String description;
  final String image;

  OnboardingFeature({
    required this.title,
    required this.description,
    required this.image,
  });
}

class FeaturePage extends StatelessWidget {
  final OnboardingFeature feature;

  FeaturePage(this.feature);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          feature.image,
          width: 200,
          height: 200,
        ),
        SizedBox(height: 20),
        Text(
          feature.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          feature.description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
