import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/view/login_screen.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';
import 'package:project_management_app/services/local/config_local_data_source.dart';

class ProfileCubit extends Cubit<BaseState> {
  ProfileCubit() : super(BaseInitialState());

  Future<void> logOutUser(BuildContext context) async {
    await Future.wait([
      AuthLocalDataSource.clearAuthLocalDataSource(),
      ConfigLocalDataSource.clearConfigLocalDataSource(),
    ]);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }
}
