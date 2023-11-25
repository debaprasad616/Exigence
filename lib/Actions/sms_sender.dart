import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SmsSender {
  final Telephony telephony = Telephony.instance;

  Future<void> sendSMS(String message) async {
    List<String> contacts = [
      await _getContact('contact1'),
      await _getContact('contact2'),
      // Add more contacts as needed
    ];

    bool smsSent = false;

    for (String contact in contacts) {
      if (contact.isNotEmpty) {
        try {
          await telephony.sendSms(to: contact, message: message);
          smsSent = true;
          // Break the loop if SMS is sent successfully to any contact
          break;
        } catch (e) {
          print('Error sending SMS to $contact: $e');
          smsSent = false;
        }
      }
    }
  }

  Future<String> _getContact(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

}
