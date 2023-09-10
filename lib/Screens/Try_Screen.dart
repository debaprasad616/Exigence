import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class MessageInputScreen extends StatefulWidget {
  @override
  _MessageInputScreenState createState() => _MessageInputScreenState();
}

class _MessageInputScreenState extends State<MessageInputScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _saveMessage() {
    final message = _messageController.text;
    final databaseReference = FirebaseDatabase.instance.reference().child('messages');

    // Push a new message with a unique key
    databaseReference.push().set({
      'text': message,
      'timestamp': ServerValue.timestamp, // Include a timestamp if needed
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Message saved to Firebase'),
      ));
      _messageController.clear(); // Clear the text field
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving message: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Message'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveMessage,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
