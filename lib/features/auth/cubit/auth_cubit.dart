import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/repository/auth_repository.dart';
import 'package:project_management_app/services/di/service_locator.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class AuthCubit extends Cubit<BaseState> {
  final repo = getIt.get<AuthRepository>();

  AuthCubit() : super(BaseInitialState());

  Future<void> login(String email, String password) async {
    emit(BaseLoadingState());
    final response = await repo.loginWithEmail(email, password);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      // save user data locally
      await AuthLocalDataSource.setUserData(res!.toJson());
      emit(BaseSuccessState(response: res));
    });
  }

  Future<void> register(String fullName, String email, String password) async {
    emit(BaseLoadingState());
    final response = await repo.registerWithEmail(fullName, email, password);
    response
        .fold((failure) => emit(BaseErrorState(message: failure.errorMessage)),
            (res) async {
      // save user data locally
      await AuthLocalDataSource.setUserData(res!.toJson());
      emit(BaseSuccessState(response: res));
    });
  }
}
