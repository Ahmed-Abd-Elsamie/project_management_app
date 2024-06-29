import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/tasks/cubit/task_cubit.dart';
import 'package:project_management_app/features/tasks/cubit/task_users_cubit.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:project_management_app/features/tasks/view/add_task_screen.dart';
import 'package:project_management_app/features/tasks/view/edit_task_screen.dart';
import 'package:project_management_app/features/tasks/view/widgets/task_item.dart';

class TasksScreen extends StatefulWidget {
  static const String routeName = "/tasks-screen";
  final ProjectModel project;

  const TasksScreen({super.key, required this.project});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late ProjectModel projectModel;

  @override
  void initState() {
    projectModel = widget.project;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TaskCubit(projectModel.id)),
        BlocProvider(create: (context) => TaskUsersCubit()),
      ],
      child: BlocBuilder<TaskCubit, BaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${projectModel.title} Tasks",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: Builder(builder: (context) {
              if (state is BaseErrorState) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is BaseSuccessState) {
                List<TaskModel> tasks = state.response as List<TaskModel>;
                if (tasks.isEmpty) {
                  return const Center(child: Text("You Don't have any Tasks"));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TaskItem(
                        onDonePress: () {
                          context.read<TaskCubit>().markTaskDone(
                              tasks[index].taskId!, projectModel.id!);
                        },
                        onPress: () {},
                        onEditPress: () {
                          Navigator.pushNamed(
                            context,
                            EditTaskScreen.routeName,
                            arguments: tasks[index],
                          ).then((value) {
                            if (value != null) {
                              context
                                  .read<TaskCubit>()
                                  .getTasksByProject(projectModel.id!);
                            }
                          });
                        },
                        task: tasks[index],
                      ),
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
                Navigator.pushNamed(
                  context,
                  AddTaskScreen.routeName,
                  arguments: projectModel,
                ).then((value) {
                  if (value != null) {
                    context
                        .read<TaskCubit>()
                        .getTasksByProject(projectModel.id!);
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
