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

class AddTaskScreen extends StatefulWidget {
  static const String routeName = "/add-task";
  final ProjectModel project;

  const AddTaskScreen({super.key, required this.project});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
        BlocProvider(create: (context) => AddEditTaskCubit()),
        BlocProvider(create: (context) => TaskUsersCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Assign Task",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddEditTaskCubit, BaseState>(
            builder: (context, state) {
              return Form(
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
                          context.read<AddEditTaskCubit>().selectDate(context);
                        },
                        title: const Text("Select Dead Line"),
                        subtitle: Text(
                            context.read<AddEditTaskCubit>().selectedDeadLine ==
                                    null
                                ? ""
                                : context
                                    .read<AddEditTaskCubit>()
                                    .selectedDeadLine
                                    .toString()),
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
                            if (context
                                    .read<AddEditTaskCubit>()
                                    .selectedDeadLine ==
                                null) {
                              showErrorToast("Select Deadline first");
                              return;
                            }
                            context.read<AddEditTaskCubit>().createTask(
                                  TaskModel(
                                    taskId: '',
                                    taskName: _titleController.text,
                                    taskDescription:
                                        _descriptionController.text,
                                    createdAt: '',
                                    deadLine: context
                                        .read<AddEditTaskCubit>()
                                        .selectedDeadLine
                                        .toString(),
                                    projectId: projectModel.id,
                                    userId: '',
                                    assignedTo: context
                                        .read<TaskUsersCubit>()
                                        .selectedUser!
                                        .id,
                                    state: "0",
                                  ),
                                );
                          }
                        },
                        text: "Create",
                      ),
                    ],
                  ),
                ),
              );
            },
            listener: (context, state) {
              if (state is BaseLoadingState) {
                showLoading(context);
              }
              if (state is BaseSuccessState) {
                showSuccessToast("Task Created Successfully");
                hideLoading(context);
                Navigator.pop(context, true);
              }
              if (state is BaseErrorState) {
                showErrorToast(state.message);
                hideLoading(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
