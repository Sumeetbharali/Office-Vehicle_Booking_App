import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isDateTimeField;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool enabled; // Added enabled property

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.isDateTimeField,
    this.validator,
    this.prefixIcon,
    this.enabled = true, // Default value set to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: isDateTimeField ? TextInputType.datetime : TextInputType.text,
      enabled: enabled, // Set enabled property
    );
  }
}
