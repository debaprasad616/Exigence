import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class QuickCallWidget extends StatefulWidget {
  final String phoneNumber;

  QuickCallWidget({required this.phoneNumber});

  @override
  _QuickCallWidgetState createState() => _QuickCallWidgetState();
}

class _QuickCallWidgetState extends State<QuickCallWidget> {
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCallPermission();
  }

  Future<void> _checkCallPermission() async {
    final PermissionStatus permissionStatus = await Permission.phone.request();
    setState(() {
      _isPermissionGranted = permissionStatus.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isPermissionGranted) {
          await FlutterPhoneDirectCaller.callNumber(widget.phoneNumber);
        } else {
          print("Phone call permission denied");
        }
      },
      child: Card(
        elevation: 5, // Add elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Match the card's border radius
          child: Image.asset(
            'assets/images_call/ambulance.png', // Replace with your image asset
            width: 60, // Match the width of the Card
            height: 60, // Match the height of the Card
            fit: BoxFit.cover, // Fit the image within the ClipRRect
          ),
        ),
      ),
    );
  }
}
