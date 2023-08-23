// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
//
// class AutoPhotoCaptureWidget extends StatefulWidget {
//   @override
//   _AutoPhotoCaptureWidgetState createState() => _AutoPhotoCaptureWidgetState();
// }
//
// class _AutoPhotoCaptureWidgetState extends State<AutoPhotoCaptureWidget> {
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
//
//     if (_isCameraInitialized) {
//       // Take a photo automatically after initializing the camera
//       _takeAutoPhoto();
//     }
//   }
//
//   Future<void> _takeAutoPhoto() async {
//     if (!_controller.value.isInitialized) {
//       return;
//     }
//
//     // Capture the photo
//     final XFile image = await _controller.takePicture();
//
//     // Save the image to the gallery
//     final String imagePath = image.path;
//     final result = await ImageGallerySaver.saveFile(imagePath);
//
//     if (result['isSuccess']) {
//       print('Photo saved to gallery: ${result['filePath']}');
//     } else {
//       print('Error saving photo to gallery');
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
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Auto Photo Capture'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Auto Photo Capture'),
//       ),
//       body: Center(
//         child: CameraPreview(_controller),
//       ),
//     );
//   }
// }
