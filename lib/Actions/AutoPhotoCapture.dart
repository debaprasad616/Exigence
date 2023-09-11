import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'dart:io';

class PhotoCapture {
  final CameraController cameraController;

  PhotoCapture(this.cameraController);

  Future<String?> captureAndSavePhoto() async {
    if (!cameraController.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    final XFile image = await cameraController.takePicture();
    final imagePath = image.path;

    // Save the image locally
    await ImageGallerySaver.saveFile(imagePath);

    print('Photo captured and saved locally: $imagePath');

    // Upload the image to Firebase Storage
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child('Live_Images/${DateTime.now()}.jpg');
    final File imageFile = File(imagePath);

    try {
      final uploadTask = storageRef.putFile(imageFile);

      // Await the completion of the upload task
      final TaskSnapshot taskSnapshot = await uploadTask;

      // Check if the upload was successful
      if (taskSnapshot.state == TaskState.success) {
        final downloadURL = await storageRef.getDownloadURL();
        print('Photo uploaded to Firebase Storage. Download URL: $downloadURL');
        return downloadURL;
      } else {
        print('Failed to upload photo to Firebase Storage.');
        return null;
      }
    } catch (e) {
      print('Error uploading photo to Firebase Storage: $e');
      return null; // Handle the error as needed
    }
  }

}
