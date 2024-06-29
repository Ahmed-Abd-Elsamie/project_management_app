import 'package:flutter/material.dart';

class CustomTextInputFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final String? initialValue;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final OutlineInputBorder? border;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmit;

  const CustomTextInputFormField({
    super.key,
    required this.title,
    required this.hintText,
    this.initialValue,
    this.isPassword = false,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.border,
    this.controller,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          initialValue: initialValue,
          obscureText: isPassword,
          validator: validator,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onFieldSubmitted: (v) {
            if (onSubmit != null) {
              onSubmit!(v);
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: border ?? const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
