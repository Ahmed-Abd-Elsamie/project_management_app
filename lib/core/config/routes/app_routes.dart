import 'package:flutter/material.dart';
import 'package:project_management_app/features/analytics/view/analytic_screen.dart';
import 'package:project_management_app/features/analytics/view/project_analytic_screen.dart';
import 'package:project_management_app/features/auth/view/login_screen.dart';
import 'package:project_management_app/features/auth/view/register_screen.dart';
import 'package:project_management_app/features/home/view/home_screen.dart';
import 'package:project_management_app/features/profile/view/profile_screen.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/view/add_project_screen.dart';
import 'package:project_management_app/features/projects/view/edit_project_screen.dart';
import 'package:project_management_app/features/projects/view/projects_screen.dart';
import 'package:project_management_app/features/splash/view/splash_screen.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/features/tasks/view/add_task_screen.dart';
import 'package:project_management_app/features/tasks/view/all_tasks_screen.dart';
import 'package:project_management_app/features/tasks/view/edit_task_screen.dart';
import 'package:project_management_app/features/tasks/view/tasks_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    SplashScreen.routeName: (context) => const SplashScreen(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    RegisterScreen.routeName: (context) => RegisterScreen(),
    AddProjectScreen.routeName: (context) => AddProjectScreen(),
    ProjectsScreen.routeName: (context) => const ProjectsScreen(),
    EditProjectScreen.routeName: (context) {
      final project =
          ModalRoute.of(context)!.settings.arguments as ProjectModel;
      return EditProjectScreen(
        project: project,
      );
    },
    ProfileScreen.routeName: (context) => const ProfileScreen(),
    TasksScreen.routeName: (context) {
      final project =
          ModalRoute.of(context)!.settings.arguments as ProjectModel;
      return TasksScreen(
        project: project,
      );
    },
    AddTaskScreen.routeName: (context) {
      final project =
          ModalRoute.of(context)!.settings.arguments as ProjectModel;
      return AddTaskScreen(
        project: project,
      );
    },
    EditTaskScreen.routeName: (context) {
      final task = ModalRoute.of(context)!.settings.arguments as TaskModel;
      return EditTaskScreen(
        task: task,
      );
    },
    AllTasksScreen.routeName: (context) => const AllTasksScreen(),
    AnalyticScreen.routeName: (context) => const AnalyticScreen(),
    ProjectAnalyticScreen.routeName: (context) {
      final project =
          ModalRoute.of(context)!.settings.arguments as ProjectModel;
      return ProjectAnalyticScreen(
        project: project,
      );
    },
  };
}
