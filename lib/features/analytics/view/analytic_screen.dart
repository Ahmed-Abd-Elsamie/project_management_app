import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/analytics/cubit/analytic_cubit.dart';
import 'package:project_management_app/features/analytics/view/project_analytic_screen.dart';
import 'package:project_management_app/features/analytics/view/widgets/analytic_project_item.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';

class AnalyticScreen extends StatelessWidget {
  static const String routeName = "/analytics";

  const AnalyticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnalyticCubit()),
      ],
      child: BlocBuilder<AnalyticCubit, BaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Projects Analytics",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Builder(builder: (context) {
              if (state is BaseErrorState) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is BaseSuccessState) {
                List<ProjectModel> projects =
                    state.response as List<ProjectModel>;
                if (projects.isEmpty) {
                  return const Center(
                      child: Text("You Don't have any Projects"));
                }
                return ListView.builder(
                  itemCount: projects.length,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnalyticProjectItem(
                        onPress: () {
                          Navigator.pushNamed(
                            context,
                            ProjectAnalyticScreen.routeName,
                            arguments: projects[index],
                          );
                        },
                        projectModel: projects[index],
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          );
        },
      ),
    );
  }
}
