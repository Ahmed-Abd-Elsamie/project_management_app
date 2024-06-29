import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/projects/cubit/project_cubit.dart';
import 'package:project_management_app/features/projects/cubit/project_users_cubit.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/projects/view/add_project_screen.dart';
import 'package:project_management_app/features/projects/view/edit_project_screen.dart';
import 'package:project_management_app/features/projects/view/widgets/project_item.dart';
import 'package:project_management_app/features/tasks/view/tasks_screen.dart';

class ProjectsScreen extends StatelessWidget {
  static const String routeName = "/projects";

  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProjectCubit()),
          BlocProvider(create: (context) => ProjectUsersCubit()),
        ],
        child: BlocBuilder<ProjectCubit, BaseState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "All Projects",
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
                  return BlocBuilder<ProjectUsersCubit, BaseState>(
                    builder: (context, projectUserState) {
                      return ListView.builder(
                        itemCount: projects.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProjectItem(
                              onEditPress: () {
                                context
                                    .read<ProjectUsersCubit>()
                                    .selectedUsers!
                                    .clear();
                                Navigator.pushNamed(
                                  context,
                                  EditProjectScreen.routeName,
                                  arguments: state.response[index],
                                ).then((value) {
                                  if (value != null) {
                                    context
                                        .read<ProjectCubit>()
                                        .getAllProjects();
                                  }
                                });
                              },
                              onPress: () {
                                Navigator.pushNamed(
                                  context,
                                  TasksScreen.routeName,
                                  arguments: projects[index],
                                );
                              },
                              projectModel: projects[index],
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddProjectScreen.routeName)
                      .then((value) {
                    if (value != null) {
                      context.read<ProjectCubit>().getAllProjects();
                    }
                  });
                },
                child: const Icon(Icons.add),
              ),
            );
          },
        ));
  }
}
