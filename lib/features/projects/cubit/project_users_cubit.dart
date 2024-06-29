import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';
import 'package:project_management_app/features/projects/model/project_users_response.dart';
import 'package:project_management_app/features/projects/repository/project_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class ProjectUsersCubit extends Cubit<BaseState> {
  final repo = getIt.get<ProjectRepository>();
  List<UserModel>? selectedUsers = [];

  ProjectUsersCubit([List<String?>? ids]) : super(BaseInitialState()) {
    getProjectUsers(ids);
  }

  Future<void> getProjectUsers([List<String?>? ids]) async {
    emit(BaseLoadingState());
    final response = await repo.getProjectUsers(ids);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<ProjectUsersResponse>(
          response: ProjectUsersResponse(
              allUsers: res.allUsers, selectedUsers: res.selectedUsers)));
    });
  }
}
