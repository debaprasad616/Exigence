import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'ULRshorten.dart';
import '../Actions/firebaseSave.dart'; // Import your Firebase service class here

class AudioRecorder {
  late FlutterSoundRecorder _audioRecorder;

  AudioRecorder() {
    _initializeAudioRecorder();
  }

  void _initializeAudioRecorder() {
    _audioRecorder = FlutterSoundRecorder();
  }

  Future<String?> startRecordingAndSaveToFirebase() async {
    try {
      // Request permission to access the microphone
      var status = await Permission.microphone.request();
      if (status.isDenied) {
        // Handle permissions not granted
        Fluttertoast.showToast(
          msg: 'Microphone permission denied',
          gravity: ToastGravity.CENTER,
        );
        return null;
      }

      // Open audio session
      await _audioRecorder.openRecorder();

      // Get the directory for saving audio files
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Start recording
      String fileName =
          '$appDocPath/audio_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder.startRecorder(
        toFile: fileName,
        codec: Codec.aacADTS,
      );

      Fluttertoast.showToast(
        msg: 'Recording started',
        gravity: ToastGravity.CENTER,
      );

      // Record for 5 seconds (adjust as needed)
      await Future.delayed(const Duration(seconds: 5));

      // Stop recording
      await _audioRecorder.stopRecorder();

      Fluttertoast.showToast(
        msg: 'Recording stopped',
        gravity: ToastGravity.CENTER,
      );

      // Get URL for the recorded audio
      final audioUrl = fileName;

      // Save the audio to Firebase Storage
      final File audioFile = File(audioUrl);
      return await FirebaseService.uploadAudio(audioFile); // Modify this line based on your Firebase service method for uploading audio
    } catch (e, stackTrace) {
      print('Error during recording: $e');
      print('StackTrace: $stackTrace');
      Fluttertoast.showToast(
        msg: 'Error during recording',
        gravity: ToastGravity.CENTER,
      );
      return null;
    } finally {
      // Close the audio session
      await _audioRecorder.closeRecorder();
    }
  }

  Future<void> createUrlForCapturedAudio(String fileName) async {
    // Assume RecordAndSaveAudio is a function that returns the URL for the recorded audio
    final audioUrl = fileName;
    final shortenedAudioUrl = await shortenUrl(audioUrl);
    print('URL for captured audio: $shortenedAudioUrl');
  }
}



// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class AudioRecorder {
//   late FlutterSoundRecorder _audioRecorder;
//   bool _isRecording = false;
//
//   AudioRecorder() {
//     _audioRecorder = FlutterSoundRecorder();
//   }
//
//   Future<void> startRecording() async {
//     try {
//       // Request permission to access the microphone
//       var status = await Permission.microphone.request();
//       if (status.isDenied) {
//         // Handle permissions not granted
//         Fluttertoast.showToast(
//           msg: 'Microphone permission denied',
//           gravity: ToastGravity.CENTER,
//         );
//         return;
//       }
//
//       // Open audio session
//       await _audioRecorder.openRecorder();
//
//       // Start recording
//       String fileName =
//           'audio_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
//       await _audioRecorder.startRecorder(
//         toFile: fileName,
//         codec: Codec.aacADTS,
//       );
//
//       Fluttertoast.showToast(
//         msg: 'Recording started',
//         gravity: ToastGravity.CENTER,
//       );
//
//       _isRecording = true;
//
//       // Record for 5 seconds (adjust as needed)
//       await Future.delayed(const Duration(seconds: 5));
//
//       // Stop recording
//       await _audioRecorder.stopRecorder();
//
//       Fluttertoast.showToast(
//         msg: 'Recording stopped',
//         gravity: ToastGravity.CENTER,
//       );
//     } catch (e, stackTrace) {
//       print('Error during recording: $e');
//       print('StackTrace: $stackTrace');
//       Fluttertoast.showToast(
//         msg: 'Error during recording',
//         gravity: ToastGravity.CENTER,
//       );
//     } finally {
//       // Close the audio session
//       await _audioRecorder.closeRecorder();
//
//       _isRecording = false;
//     }
//   }
//
// // Add any additional methods or logic as needed
// }
