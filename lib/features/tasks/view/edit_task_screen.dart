import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/helpers/loading_dialog.dart';
import 'package:project_management_app/core/helpers/toast_messages.dart';
import 'package:project_management_app/core/shared/widgets/custom_button.dart';
import 'package:project_management_app/core/shared/widgets/custom_text_input_form_field.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/core/utils/debug_prints.dart';
import 'package:project_management_app/features/auth/model/user_model.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/tasks/cubit/add_edit_task_cubit.dart';
import 'package:project_management_app/features/tasks/cubit/task_users_cubit.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = "/edit-task";
  final TaskModel task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late TaskModel taskModel;

  @override
  void initState() {
    taskModel = widget.task;
    _titleController.text = taskModel.taskName!;
    _descriptionController.text = taskModel.taskDescription!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddEditTaskCubit()),
        BlocProvider(create: (context) => TaskUsersCubit()),
      ],
      child: BlocConsumer<AddEditTaskCubit, BaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Edit Task",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context
                        .read<AddEditTaskCubit>()
                        .deleteTask(taskModel.taskId!);
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextInputFormField(
                          controller: _titleController,
                          title: "Task Name",
                          hintText: "Task Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextInputFormField(
                          title: "Task Details",
                          hintText: "Task Details",
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ListTile(
                          onTap: () {
                            context
                                .read<AddEditTaskCubit>()
                                .selectDate(context);
                          },
                          title: const Text("Select Dead Line"),
                          subtitle: Builder(
                            builder: (context) {
                              if (context
                                      .read<AddEditTaskCubit>()
                                      .selectedDeadLine ==
                                  null) {
                                context
                                        .read<AddEditTaskCubit>()
                                        .selectedDeadLine =
                                    DateTime.parse(taskModel.deadLine!);
                              }
                              return Text(DateTime.parse(taskModel.deadLine!)
                                  .toString());
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        BlocBuilder<TaskUsersCubit, BaseState>(
                          builder: (context, usersState) {
                            if (usersState is BaseSuccessState) {
                              return DropdownSearch<UserModel>(
                                items: usersState.response,
                                itemAsString: (user) => user.fullName!,
                                onChanged: (UserModel? data) {
                                  context.read<TaskUsersCubit>().selectedUser =
                                      data;
                                  printDone(data.toString());
                                },
                                selectedItem:
                                    (usersState.response as List<UserModel>)
                                        .where((element) =>
                                            element.id == taskModel.assignedTo)
                                        .first,
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      InputDecoration(labelText: "Select User"),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return "Assign the task to a user";
                                  }
                                  return null;
                                },
                              );
                            }
                            if (usersState is BaseErrorState) {
                              return Center(
                                child: Text(usersState.message),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 20.0),
                        CustomButton(
                          onPress: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              String? assignedToId = "";
                              if (context
                                      .read<TaskUsersCubit>()
                                      .selectedUser
                                      ?.id ==
                                  null) {
                                assignedToId = taskModel.assignedTo;
                              } else {
                                assignedToId = context
                                    .read<TaskUsersCubit>()
                                    .selectedUser!
                                    .id;
                              }
                              context.read<AddEditTaskCubit>().updateTask(
                                    TaskModel(
                                      taskId: taskModel.taskId,
                                      taskName: _titleController.text,
                                      taskDescription:
                                          _descriptionController.text,
                                      createdAt: taskModel.createdAt,
                                      deadLine: context
                                          .read<AddEditTaskCubit>()
                                          .selectedDeadLine
                                          .toString(),
                                      projectId: taskModel.projectId,
                                      userId: taskModel.userId,
                                      assignedTo: assignedToId,
                                      state: taskModel.state ?? "0",
                                    ),
                                  );
                            }
                          },
                          text: "Update",
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
        listener: (context, state) {
          if (state is BaseLoadingState) {
            showLoading(context);
          }
          if (state is BaseSuccessState) {
            showSuccessToast("Task Updated Successfully");
            hideLoading(context);
            Navigator.pop(context, true);
          }
          if (state is BaseErrorState) {
            showErrorToast(state.message);
            hideLoading(context);
          }
        },
      ),
    );
  }
}
