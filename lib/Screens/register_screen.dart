import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/button_widget.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _contact1Controller = TextEditingController();
  TextEditingController _contact2Controller = TextEditingController();

  @override
  void dispose() {
    _contact1Controller.dispose();
    _contact2Controller.dispose();
    super.dispose();
  }

  void _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('contact1', _contact1Controller.text);
    prefs.setString('contact2', _contact2Controller.text);
    prefs.setBool('registered', true); // Set registered status to true
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  // void _sendSMS() async {
  //   List<String> recipients = ['7008786967'];
  //   String message = 'Hi';
  //
  //   await sendSMS(message: message, recipients: recipients)
  //       .catchError((onError) {
  //     // Handle sending failure
  //     print('Failed to send SMS: $onError');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _contact1Controller,
              decoration: InputDecoration(labelText: 'Emergency Contact 1'),
            ),
            TextField(
              controller: _contact2Controller,
              decoration: InputDecoration(labelText: 'Emergency Contact 2'),
            ),
            const SizedBox(height: 20),
            Button(onPressed: _saveContacts, buttonText: 'Register'),
            const SizedBox(height: 20),
            // Button(onPressed: _sendSMS, buttonText: 'Send'),
          ],
        ),
      ),
    );
  }
}
