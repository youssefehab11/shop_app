// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_cubit/login_cubit.dart';
import 'package:shop_app/modules/login/login_cubit/login_states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/navigation/navigation.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/styles.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void submit(LoginCubit cubit) {
    if (formKey.currentState!.validate()) {
      cubit.loginRequest(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          builder: (BuildContext context, state) {
            LoginCubit cubit = LoginCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: titleStyle,
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an Email';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          context: context,
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.go,
                          context: context,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: cubit.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onPressed: () {
                            cubit.togglePasswordVisibility();
                          },
                          onFieldSummited: (value) {
                            submit(cubit);
                          },
                          isInputVisible: cubit.isPasswordVisible,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Builder(builder: (context) {
                          if (state is LoginLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return defaultButton(
                              label: 'Login',
                              onPressed: () {
                                submit(cubit);
                              },
                              labelFont: 20.0,
                              buttonWidth: double.infinity,
                            );
                          }
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            defaultTextButton(
                              label: 'Register',
                              onPressed: () {
                                navigateTo(
                                  context: context,
                                  widget: RegisterScreen(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (BuildContext context, state) {
            LoginCubit cubit = LoginCubit.get(context);
            if (state is LoginSuccessState) {
              if (cubit.loginModel.status!) {
                CacheHelper.saveData(
                  key: 'token',
                  value: cubit.loginModel.data!.token,
                ).then((value) {
                  showToast(
                      message: cubit.loginModel.message!,
                      state: ToastStates.SUCCESS,
                      toastLength: Toast.LENGTH_SHORT);
                  navigateAndRemove(
                      context: context, widget: const HomeLayout());
                });
              } else {
                showToast(
                  message: cubit.loginModel.message!,
                  state: ToastStates.ERROR,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
