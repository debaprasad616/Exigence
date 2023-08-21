import 'package:flutter/material.dart';

class EmergencyContactField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool validatorRequired;

  const EmergencyContactField({
    required this.controller,
    required this.labelText,
    this.validatorRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (validatorRequired && value!.isEmpty) {
          return 'Please enter a phone number';
        } else if (validatorRequired && !isValidPhoneNumber(value!)) {
          return 'Invalid phone number';
        }
        return null;
      },
    );
  }

  bool isValidPhoneNumber(String input) {
    final RegExp phoneRegExp = RegExp(r'^\d{10}$'); // Assumes a 10-digit phone number
    return phoneRegExp.hasMatch(input);
  }
}
