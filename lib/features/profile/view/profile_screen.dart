import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/shared/widgets/custom_button.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/profile/cubit/profile_cubit.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile-screen";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  AuthLocalDataSource.getUserData()['fullName'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  AuthLocalDataSource.getUserData()['email'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                BlocBuilder<ProfileCubit, BaseState>(
                  builder: (context, state) {
                    if (state is BaseLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: CustomButton(
                        onPress: () {
                          context.read<ProfileCubit>().logOutUser(context);
                        },
                        text: "Logout",
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
