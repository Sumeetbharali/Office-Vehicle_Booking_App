import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final String? errorText;// Added validator parameter

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator, //
    this.onChanged,
    this.errorText,// Updated constructor to include validator parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField( // Changed TextField to TextFormField
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          errorText: errorText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        validator: validator,
        onChanged: onChanged,// Set validator property
      ),
    );
  }
}
