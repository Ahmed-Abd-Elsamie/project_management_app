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
import 'package:project_management_app/features/projects/cubit/add_edit_project_cubit.dart';
import 'package:project_management_app/features/projects/cubit/project_users_cubit.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/services/local/auth_local_data_source.dart';

class EditProjectScreen extends StatefulWidget {
  static const String routeName = "/edit-project";
  final ProjectModel project;

  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late ProjectModel projectModel;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    projectModel = widget.project;
    _titleController.text = projectModel.title!;
    _descriptionController.text = projectModel.description!;
    printInfo(projectModel.projectUsers.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AddEditProjectCubit()),
          BlocProvider(
              create: (context) =>
                  ProjectUsersCubit(projectModel.projectUsers)),
        ],
        child: BlocConsumer<AddEditProjectCubit, BaseState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Update Project",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context
                          .read<AddEditProjectCubit>()
                          .deleteProject(projectModel.id!);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextInputFormField(
                        controller: _titleController,
                        title: "Project Title",
                        hintText: "Project Title",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextInputFormField(
                        title: "Description",
                        hintText: "Description",
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
                      BlocBuilder<ProjectUsersCubit, BaseState>(
                        builder: (context, state) {
                          if (state is BaseSuccessState) {
                            return DropdownSearch<UserModel>.multiSelection(
                              items: state.response.allUsers,
                              selectedItems: state.response.selectedUsers,
                              itemAsString: (user) => user.fullName!,
                              onChanged: (List<UserModel> selectedUsers) {
                                context
                                    .read<ProjectUsersCubit>()
                                    .selectedUsers = selectedUsers;
                                printDone(selectedUsers.toString());
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration:
                                    InputDecoration(labelText: "Select User"),
                              ),
                              popupProps: PopupPropsMultiSelection.menu(
                                disabledItemFn: (UserModel u) =>
                                    u.email ==
                                    AuthLocalDataSource.getUserData()['email'],
                              ),
                            );
                          }
                          if (state is BaseErrorState) {
                            return Center(
                              child: Text(state.message),
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
                            context.read<AddEditProjectCubit>().updateProject(
                                ProjectModel(
                                    id: projectModel.id,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    userId: projectModel.userId,
                                    projectUsers: context
                                        .read<ProjectUsersCubit>()
                                        .selectedUsers!
                                        .map((e) => e.id)
                                        .toList()));
                          }
                        },
                        text: "Update",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is BaseLoadingState) {
              showLoading(context);
            }
            if (state is BaseSuccessState) {
              showSuccessToast("Project Updated Successfully");
              hideLoading(context);
              Navigator.pop(context, true);
            }
            if (state is BaseErrorState) {
              showErrorToast(state.message);
              hideLoading(context);
            }
          },
        ));
  }
}
