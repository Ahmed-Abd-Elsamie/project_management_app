import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_management_app/core/config/constants/local_boxes.dart';
import 'package:project_management_app/core/config/routes/app_routes.dart';
import 'package:project_management_app/core/config/theme/app_theme.dart';
import 'package:project_management_app/features/projects/cubit/add_edit_project_cubit.dart';
import 'package:project_management_app/features/projects/cubit/project_cubit.dart';
import 'package:project_management_app/features/splash/view/splash_screen.dart';
import 'package:project_management_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // local storage
  await Hive.initFlutter();
  await Hive.openBox(LocalDataSourceBoxes.authBox);
  await Hive.openBox(LocalDataSourceBoxes.configBox);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize dependency injection
  ServiceLocator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Management',
      theme: appTheme(),
      initialRoute: SplashScreen.routeName,
      routes: AppRoutes.routes,
    );
  }
}
