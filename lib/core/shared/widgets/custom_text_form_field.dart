import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final String hint;
  final String initVal;
  final bool obscure;
  final onSave;
  final validator;
  final TextInputType inputType;

  CustomTextFormField({
    this.text = '',
    this.hint = '',
    required this.obscure,
    required this.onSave,
    required this.validator,
    this.inputType = TextInputType.text,
    this.initVal = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomText(
          text: text,
          fontSize: 18,
          color: Colors.grey.shade900,
          alignment: Alignment.center,
        ),
        TextFormField(
          textAlign: TextAlign.center,
          initialValue: initVal,
          obscureText: obscure,
          keyboardType: inputType,
          onSaved: onSave,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            fillColor: Colors.white,
          ),
        )
      ],
    );
  }
}
