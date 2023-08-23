// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class CameraWidget extends StatefulWidget {
//   @override
//   _CameraWidgetState createState() => _CameraWidgetState();
// }
//
// class _CameraWidgetState extends State<CameraWidget> {
//   late CameraController _controller;
//   late List<CameraDescription> _cameras;
//   bool _isCameraInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//
//     if (_cameras.isEmpty) {
//       print('No available cameras');
//       return;
//     }
//
//     _controller = CameraController(_cameras[0], ResolutionPreset.medium);
//
//     try {
//       await _controller.initialize();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     if (_isCameraInitialized) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isCameraInitialized) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     return Card(
//       elevation: 4,
//       child: AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: CameraPreview(_controller),
//       ),
//     );
//   }
// }
