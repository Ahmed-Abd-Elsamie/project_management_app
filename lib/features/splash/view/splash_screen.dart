import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_management_app/core/config/constants/app_colors.dart';
import 'package:project_management_app/features/auth/view/login_screen.dart';
import 'package:project_management_app/features/home/view/home_screen.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash-screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (AuthLocalDataSource.getUserData().isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Splash Screen",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
