import 'package:exigence_v6/Screens/home_screen.dart';
import 'package:exigence_v6/Widgets/emergencyContactField_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/button_widget.dart';

class RegistrationScreenF extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreenF> {
  List<TextEditingController> contactControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the form

  @override
  void dispose() {
    for (var controller in contactControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<String> _getContact(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }


  bool isValidPhoneNumber(String input) {
    final RegExp phoneRegExp = RegExp(r'^\d{10}$'); // Assumes a 10-digit phone number
    return phoneRegExp.hasMatch(input);
  }

  void _saveContacts() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      for (var i = 0; i < contactControllers.length; i++) {
        await prefs.setString('contact${i + 1}', contactControllers[i].text);
      }
      await prefs.setBool('registered', true); // Mark as registered

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _addContactField() {
    setState(() {
      contactControllers.add(TextEditingController());
    });
  }

  void _deleteContactField(int index) {
    if (index >= 2) {
      setState(() {
        contactControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Registration',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              for (var i = 0; i < contactControllers.length; i++)
                Container(
                  height: 50, // Set a fixed height for the contact field
                  child: Row(
                    children: [
                      Expanded(
                        child: EmergencyContactField(
                          controller: contactControllers[i],
                          labelText: 'Emergency Contact ${i + 1}',
                        ),
                      ),
                      if (i >= 2) // Show delete icon only for user-created fields
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteContactField(i),
                        ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addContactField,
                icon: Icon(Icons.add),
                label: Text('Add Emergency Contact'),
              ),
              SizedBox(height: 30),
              Button(
                onPressed: _saveContacts,
                buttonText: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
