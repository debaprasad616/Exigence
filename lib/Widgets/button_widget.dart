import 'package:flutter/material.dart';
class Button extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText; // Add this parameter

  Button({required this.onPressed, required this.buttonText}); // Modify constructor

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _shakingDetected = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _shakingDetected ? Colors.grey : Color(0xFF0C4492),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: InkWell(
        onTap: widget.onPressed,
        child: Text(
          widget.buttonText, // Use the buttonText parameter here
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
