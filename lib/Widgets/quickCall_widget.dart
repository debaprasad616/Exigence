import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class QuickCallData {
  final String phoneNumber;
  final String imageAsset;

  QuickCallData({required this.phoneNumber, required this.imageAsset});
}

class QuickCallWidget extends StatelessWidget {
  final String phoneNumber;
  final String imageAsset;

  QuickCallWidget({required this.phoneNumber, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    bool isPermissionGranted = false;

    return FutureBuilder<PermissionStatus>(
      future: Permission.phone.request(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data == PermissionStatus.granted) {
          isPermissionGranted = true;
        }

        return GestureDetector(
          onTap: () async {
            if (isPermissionGranted) {
              await FlutterPhoneDirectCaller.callNumber(phoneNumber);
            } else {
              print("Phone call permission denied");
            }
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
