import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  Future <void> sendEmailWithAttachment(String imagePath) async {
    final smtpServer = gmail('debaprasad616@gmail.com', 'deba@616');
    final message = Message()
      ..from = Address('debap616@gmail.com', 'debaprasadklp')
      ..recipients.add('debaprasad616@gmail.com')
      ..subject = 'Emergency Photo'
      ..text = 'An emergency photo has been captured.'
      ..attachments.add(FileAttachment(File(imagePath)));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
