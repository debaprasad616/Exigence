// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   final AndroidNotificationChannel channel = AndroidNotificationChannel(
//     "Exigence",
//     "foreGroundService",
//     importance: Importance.high,
//   );
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//
//   await service.configure(
//     iosConfiguration: IosConfiguration(),
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//       notificationChannelId: "Exigence",
//       initialNotificationTitle: "Initializing",
//       foregroundServiceNotificationId: 616,
//     ),
//   );
//
//   service.startService();
// }
//
// @pragma('vm-entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   print("Foreground service onStart() called");
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       print("Setting service as foreground");
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((event) {
//       print("Stopping service");
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   Timer.periodic(Duration(seconds: 3), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         print("Service is in the foreground");
//         flutterLocalNotificationsPlugin.show(
//           616,
//           "womensafety app",
//           "shake feature enabled",
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               "Exigence",
//               "foreGroundService",
//               importance: Importance.high,
//               ongoing: true,
//             ),
//           ),
//         );
//       }
//     }
//   });
// }
