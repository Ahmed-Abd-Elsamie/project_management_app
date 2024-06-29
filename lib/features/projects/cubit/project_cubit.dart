import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/repository/project_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';

class ProjectCubit extends Cubit<BaseState> {
  final repo = getIt.get<ProjectRepository>();

  ProjectCubit() : super(BaseInitialState()) {
    getAllProjects();
  }

  Future<void> getAllProjects() async {
    emit(BaseLoadingState());
    final response = await repo.getAllProjects();
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      emit(BaseSuccessState<List<ProjectModel>>(response: res));
    });
  }
}
