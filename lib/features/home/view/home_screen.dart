import 'package:flutter/material.dart';
import 'package:project_management_app/core/config/constants/app_colors.dart';
import 'package:project_management_app/features/analytics/view/analytic_screen.dart';
import 'package:project_management_app/features/profile/view/profile_screen.dart';
import 'package:project_management_app/features/projects/view/projects_screen.dart';
import 'package:project_management_app/features/home/view/widgets/home_item.dart';
import 'package:project_management_app/features/tasks/view/all_tasks_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Projects Management",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: HomeItem(
                    title: "Projects",
                    color: AppColors.primaryColor,
                    icon: const Icon(
                      Icons.create_new_folder,
                      size: 50,
                    ),
                    press: () {
                      Navigator.pushNamed(context, ProjectsScreen.routeName);
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: HomeItem(
                    title: "Profile",
                    color: AppColors.primaryColor,
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      size: 50,
                    ),
                    press: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: HomeItem(
                    title: "Tasks",
                    color: AppColors.primaryColor,
                    icon: const Icon(
                      Icons.task,
                      size: 50,
                    ),
                    press: () {
                      Navigator.pushNamed(context, AllTasksScreen.routeName);
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: HomeItem(
                    title: "Analytics",
                    color: AppColors.primaryColor,
                    icon: const Icon(
                      Icons.analytics_outlined,
                      size: 50,
                    ),
                    press: () {
                      Navigator.pushNamed(context, AnalyticScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
