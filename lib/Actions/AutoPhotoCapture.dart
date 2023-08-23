import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class PhotoCapture {
  final CameraController cameraController;

  PhotoCapture(this.cameraController);

  Future<String> captureAndSavePhoto() async {
    if (!cameraController.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    final XFile image = await cameraController.takePicture();
    final imagePath = image.path;
    await ImageGallerySaver.saveFile(imagePath);

    print('Photo captured and saved!');

    return imagePath; // Return the image path
  }
}

