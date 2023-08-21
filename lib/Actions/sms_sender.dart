import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the fluttertoast package

class SmsSender {
  final Telephony telephony = Telephony.instance;

  Future<void> sendSMS(String message) async {
    String contact1 = await _getContact('contact1');
    String contact2 = await _getContact('contact2');

    bool smsSent = false;

    if (contact1.isNotEmpty) {
      smsSent = await _sendSms(contact1, message);
    }

    if (contact2.isNotEmpty && !smsSent) {
      smsSent = await _sendSms(contact2, message);
    }

    _showToast(smsSent);
  }

  Future<bool> _sendSms(String recipient, String message) async {
    try {
      await telephony.sendSms(to: recipient, message: message);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _getContact(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  void _showToast(bool smsSent) {
    if (smsSent) {
      Fluttertoast.showToast(
        msg: 'SMS sent successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to send SMS.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }
}
