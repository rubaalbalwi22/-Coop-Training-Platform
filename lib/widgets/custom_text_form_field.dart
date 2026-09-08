import 'package:flutter/material.dart';


class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;


  const TextFieldWidget({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
         suffixIcon: suffixIcon,
      ),
    );
  }
}