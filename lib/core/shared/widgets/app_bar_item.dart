import 'package:flutter/material.dart';
import 'package:project_management_app/core/config/constants/app_colors.dart';

class AppBarItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPress;

  const AppBarItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      icon: Icon(
        icon,
        color: AppColors.primaryColor,
      ),
      label: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.normal, fontSize: 18, color: Colors.black),
      ),
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        animationDuration: const Duration(seconds: 1),
      ),
    );
  }
}
