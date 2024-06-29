import 'package:flutter/material.dart';
import 'package:project_management_app/core/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPress;

  const CustomButton({
    super.key,
    required this.onPress,
    this.text = 'Write text ',
    this.color = AppColors.primaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          fixedSize: const MaterialStatePropertyAll(Size(double.maxFinite, 60)),
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(const EdgeInsets.all(18))),
      onPressed: onPress,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
