// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit/register_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/navigation/navigation.dart';
import 'package:shop_app/shared/styles/styles.dart';

import 'cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void submit(RegisterCubit cubit) {
    if (formKey.currentState!.validate()) {
      cubit.registerRequest(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          builder: (BuildContext context, state) {
            RegisterCubit cubit = RegisterCubit.get(context);
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
                          'Register',
                          style: titleStyle,
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        defaultTextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter user name';
                            }
                            return null;
                          },
                          label: 'User Name',
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          context: context,
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(
                          height: 15.0,
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
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          label: 'Phone Number ',
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          context: context,
                          prefixIcon: Icons.phone,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Builder(
                          builder: (context) {
                            if (state is RegisterLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return defaultButton(
                                label: 'Register',
                                onPressed: () {
                                  submit(cubit);
                                },
                                labelFont: 20.0,
                                buttonWidth: double.infinity,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (BuildContext context, state) {
            RegisterCubit cubit = RegisterCubit.get(context);
            if (state is RegisterSuccessState) {
              if (cubit.registerModel.status!) {
                showToast(
                  message: cubit.registerModel.message!,
                  state: ToastStates.SUCCESS,
                  toastLength: Toast.LENGTH_SHORT,
                );
                navigateAndRemove(context: context, widget: LoginScreen());
              } else {
                showToast(
                  message: cubit.registerModel.message!,
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
