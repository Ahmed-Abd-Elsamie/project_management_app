import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/helpers/loading_dialog.dart';
import 'package:project_management_app/core/helpers/toast_messages.dart';
import 'package:project_management_app/core/shared/widgets/custom_button.dart';
import 'package:project_management_app/core/shared/widgets/custom_text_input_form_field.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:project_management_app/features/auth/view/login_screen.dart';
import 'package:project_management_app/features/home/view/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "/register-screen";

  final _txtName = TextEditingController();
  final _txtEmail = TextEditingController();
  final _txtPass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => AuthCubit(),
          child: Form(
            key: _formKey,
            child: BlocConsumer<AuthCubit, BaseState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextInputFormField(
                      controller: _txtName,
                      title: "Full Name",
                      hintText: "Full Name",
                      isPassword: false,
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field is Required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextInputFormField(
                      controller: _txtEmail,
                      title: "Email",
                      hintText: "Email",
                      isPassword: false,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field is Required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextInputFormField(
                      controller: _txtPass,
                      title: "Password",
                      hintText: "Password",
                      isPassword: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field is Required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      onPress: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().register(
                                _txtName.text,
                                _txtEmail.text,
                                _txtPass.text,
                              );
                        }
                      },
                      text: "Register",
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                );
              },
              listener: (context, state) {
                if (state is BaseLoadingState) {
                  showLoading(context);
                }
                if (state is BaseSuccessState) {
                  hideLoading(context);
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                }
                if (state is BaseErrorState) {
                  showErrorToast(state.message);
                  hideLoading(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
