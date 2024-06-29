import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/repository/project_repository.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/features/tasks/repository/task_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class AnalyticCubit extends Cubit<BaseState> {
  final projectRepo = getIt.get<ProjectRepository>();
  final taskRepo = getIt.get<TaskRepository>();

  AnalyticCubit([String? id]) : super(BaseInitialState()) {
    if (id == null) {
      getAllProjects();
    } else {
      getTasksByProject(id);
    }
  }

  Future<void> getAllProjects() async {
    emit(BaseLoadingState());
    final response = await projectRepo.getAllProjects();
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<List<ProjectModel>>(response: res));
    });
  }

  Future<void> getTasksByProject(String projectId) async {
    emit(BaseLoadingState());
    final response = await taskRepo.getTasksByProjectId(projectId);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<List<TaskModel>>(response: res));
    });
  }
}
