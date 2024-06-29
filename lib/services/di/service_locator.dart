import 'package:get_it/get_it.dart';
import 'package:project_management_app/features/auth/repository/auth_repository.dart';
import 'package:project_management_app/features/projects/repository/project_repository.dart';
import 'package:project_management_app/features/tasks/repository/task_repository.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static init() {
    getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
    getIt.registerSingleton<ProjectRepository>(ProjectRepositoryImpl());
    getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  }
}
