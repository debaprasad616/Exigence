import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmsSender {
  final Telephony telephony = Telephony.instance;

  Future<void> sendSMS(String message) async {
    String contact1 = await _getContact('contact1');
    String contact2 = await _getContact('contact2');

    if (contact1.isNotEmpty) {
      await telephony.sendSms(to: contact1, message: message);
    }

    if (contact2.isNotEmpty) {
      await telephony.sendSms(to: contact2, message: message);
    }
  }

  Future<String> _getContact(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }
}
