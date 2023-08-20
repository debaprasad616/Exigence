// import 'package:flutter_sms/flutter_sms.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
// // ...
//
// void _sendSMS() async {
//   final PermissionStatus permissionStatus = await Permission.sms.request();
//
//   if (permissionStatus.isGranted) {
//     List<String> recipients = ["7008786967"];
//     String message = "Hi";
//
//     await sendSMS(message: message, recipients: recipients)
//         .catchError((onError) {
//       // Handle sending failure
//       print("Failed to send SMS: $onError");
//     });
//   } else {
//     // Handle permission denied
//     print("SMS permission denied");
//     // You can show a dialog or snackbar to inform the user about permission denial
//   }
// }
//
