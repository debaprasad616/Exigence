import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import '../Actions/firebaseSave.dart';
import 'ULRshorten.dart';

class PhotoCapture {
  final CameraController cameraController;

  // Add this line to initialize _cameraController
  late CameraController _cameraController;

  PhotoCapture(this.cameraController) {
    _initializeCamera();
  }

  // Replace initState with a regular constructor
  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  Future<String?> captureAndSavePhoto() async {
    if (!_cameraController.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    final XFile image = await _cameraController.takePicture();
    final imagePath = image.path;

    // Save the image locally
    await ImageGallerySaver.saveFile(imagePath);

    print('Photo captured and saved locally: $imagePath');

    // Upload the image to Firebase Storage
    final File imageFile = File(imagePath);
    return await FirebaseService.uploadImage(imageFile);
  }

  Future<void> capturePhotoAndPrintUrl() async {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }

    final photoUrl = await captureAndSavePhoto();
    final shortenedPhotoUrl = await shortenUrl(photoUrl!);
    print('Photo captured and saved locally: $shortenedPhotoUrl');
  }
}
