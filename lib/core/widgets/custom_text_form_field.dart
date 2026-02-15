import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      decoration: InputDecoration(hintText: hint),
      obscureText: obscureText,
      readOnly: readOnly,
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hint is required';
        }
        return null;
      },
    );
  }
}
