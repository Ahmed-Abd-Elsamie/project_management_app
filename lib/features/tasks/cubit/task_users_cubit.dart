import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';
import 'package:project_management_app/features/tasks/repository/task_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class TaskUsersCubit extends Cubit<BaseState> {
  final repo = getIt.get<TaskRepository>();

  late UserModel? selectedUser = UserModel();

  TaskUsersCubit() : super(BaseInitialState()) {
    getTaskUsers();
  }

  Future<void> getTaskUsers() async {
    emit(BaseLoadingState());
    final response = await repo.getTaskUsers();
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) {
      emit(BaseSuccessState(response: res));
    });
  }
}
