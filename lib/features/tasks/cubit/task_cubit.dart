import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/features/tasks/repository/task_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class TaskCubit extends Cubit<BaseState> {
  final repo = getIt.get<TaskRepository>();

  TaskCubit([String? projectId]) : super(BaseInitialState()) {
    if (projectId == null) {
      getAllTasks();
    } else {
      getTasksByProject(projectId);
    }
  }

  Future<void> getAllTasks() async {
    emit(BaseLoadingState());
    final response = await repo.getAllTasks();
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<List<TaskModel>>(response: res));
    });
  }

  Future<void> getTasksByProject(String projectId) async {
    emit(BaseLoadingState());
    final response = await repo.getTasksByProjectId(projectId);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<List<TaskModel>>(response: res));
    });
  }

  Future<void> markTaskDone(String taskId, [String? projectId]) async {
    emit(BaseLoadingState());
    final response = await repo.markTaskDone(taskId);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      if (projectId == null) {
        getAllTasks();
      } else {
        getTasksByProject(projectId);
      }
    });
  }
}
