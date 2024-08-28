// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/app_cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        if (cubit.profileModel != null) {
          nameController.text = cubit.profileModel!.data!.name!;
          emailController.text = cubit.profileModel!.data!.email!;
          phoneController.text = cubit.profileModel!.data!.phone!;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(130.0),
                  ),
                  height: 180.0,
                  width: 180.0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    image: NetworkImage(
                      cubit.profileModel!.data!.image!,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                defaultTextFormField(
                  controller: nameController,
                  validator: (String? value) {
                    return null;
                  },
                  label: 'Name',
                  textInputType: TextInputType.none,
                  textInputAction: TextInputAction.none,
                  context: context,
                  prefixIcon: Icons.person,
                  isReadOnly: true,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                defaultTextFormField(
                  controller: emailController,
                  validator: (String? value) {
                    return null;
                  },
                  label: 'Email Address',
                  textInputType: TextInputType.none,
                  textInputAction: TextInputAction.none,
                  context: context,
                  prefixIcon: Icons.email,
                  isReadOnly: true,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                defaultTextFormField(
                  controller: phoneController,
                  validator: (String? value) {
                    return null;
                  },
                  label: 'Phone',
                  textInputType: TextInputType.none,
                  textInputAction: TextInputAction.none,
                  context: context,
                  prefixIcon: Icons.phone,
                  isReadOnly: true,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                defaultButton(
                  label: 'Logout',
                  onPressed: () {
                    cubit.logout(context);
                  },
                  labelFont: 18.0,
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
