import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef =
      storage.ref().child('Live_Images/${DateTime.now()}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        return await storageRef.getDownloadURL();
      } else {
        print('Failed to upload photo to Firebase Storage.');
        return null;
      }
    } catch (e) {
      print('Error uploading photo to Firebase Storage: $e');
      return null;
    }
  }

  static Future<String?> uploadAudio(File audioFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef =
      storage.ref().child('Live_Audios/${DateTime.now()}.aac');

      final uploadTask = storageRef.putFile(audioFile);
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        return await storageRef.getDownloadURL();
      } else {
        print('Failed to upload audio to Firebase Storage.');
        return null;
      }
    } catch (e) {
      print('Error uploading audio to Firebase Storage: $e');
      return null;
    }
  }
}
