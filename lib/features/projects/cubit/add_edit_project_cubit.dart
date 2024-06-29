import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/repository/project_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class AddEditProjectCubit extends Cubit<BaseState> {
  final repo = getIt.get<ProjectRepository>();

  AddEditProjectCubit() : super(BaseInitialState());

  Future<void> createProject(ProjectModel projectModel) async {
    emit(BaseLoadingState());
    final response = await repo.createProject(projectModel);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    emit(BaseLoadingState());
    final response = await repo.updateProject(projectModel);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> deleteProject(String projectId) async {
    emit(BaseLoadingState());
    final response = await repo.deleteProject(projectId);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState(response: res));
    });
  }
}
