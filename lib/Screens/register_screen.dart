import 'package:exigence_v6/Screens/home_screen.dart';
import 'package:exigence_v6/Widgets/emergencyContactField_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/button_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _contact1Controller = TextEditingController();
  TextEditingController _contact2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the form
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void dispose() {
    _contact1Controller.dispose();
    _contact2Controller.dispose();
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
      final contact1 = _contact1Controller.text;
      final contact2 = _contact2Controller.text;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('contact1', contact1);
      await prefs.setString('contact2', contact2);
      await prefs.setBool('registered', true); // Mark as registered

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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
              EmergencyContactField(controller: _contact1Controller, labelText: 'Emergency Contact 1'),
              SizedBox(height: 20),
              EmergencyContactField(controller: _contact2Controller, labelText: 'Emergency Contact 2'),
              SizedBox(height: 30),
              Button(
                onPressed: _saveContacts,
                buttonText: 'Register',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
