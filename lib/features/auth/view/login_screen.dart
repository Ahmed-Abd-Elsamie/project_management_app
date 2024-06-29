import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/helpers/loading_dialog.dart';
import 'package:project_management_app/core/helpers/toast_messages.dart';
import 'package:project_management_app/core/shared/widgets/custom_button.dart';
import 'package:project_management_app/core/shared/widgets/custom_text_input_form_field.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/auth/cubit/auth_cubit.dart';
import 'package:project_management_app/features/auth/view/register_screen.dart';
import 'package:project_management_app/features/home/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login-screen";

  final _txtEmail = TextEditingController();
  final _txtPass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => AuthCubit(),
          child: BlocConsumer<AuthCubit, BaseState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
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
                          context
                              .read<AuthCubit>()
                              .login(_txtEmail.text, _txtPass.text);
                        }
                      },
                      text: "Login",
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
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
    );
  }
}
