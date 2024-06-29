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

class AddProjectScreen extends StatelessWidget {
  static const String routeName = "/add-project";
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddEditProjectCubit()),
        BlocProvider(create: (context) => ProjectUsersCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create New Project",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddEditProjectCubit, BaseState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            context.read<AddEditProjectCubit>().createProject(
                                ProjectModel(
                                    id: '',
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    projectUsers: context
                                        .read<ProjectUsersCubit>()
                                        .selectedUsers!
                                        .map((e) => e.id)
                                        .toList()));
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
                showSuccessToast("Project Created Successfully");
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
