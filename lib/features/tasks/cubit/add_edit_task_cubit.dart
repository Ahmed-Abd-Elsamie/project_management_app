import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/features/tasks/repository/task_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class AddEditTaskCubit extends Cubit<BaseState> {
  final repo = getIt.get<TaskRepository>();
  DateTime? selectedDeadLine;

  AddEditTaskCubit() : super(BaseInitialState());

  Future<void> createTask(TaskModel taskModel) async {
    emit(BaseLoadingState());
    final response = await repo.createTask(taskModel);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> updateTask(TaskModel taskModel) async {
    emit(BaseLoadingState());
    final response = await repo.updateTask(taskModel);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> deleteTask(String taskId) async {
    emit(BaseLoadingState());
    final response = await repo.deleteTask(taskId);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDeadLine) {
      selectedDeadLine = picked;
    }
  }
}
