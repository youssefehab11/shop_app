// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/styles/styles.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String?)? validator,
  required String label,
  required TextInputType textInputType,
  required TextInputAction textInputAction,
  required BuildContext context,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isInputVisible = true,
  bool isReadOnly = false,
  Function(String)? onChange,
  Function(String)? onFieldSummited,
  void Function()? onPressed,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      label: Text(
        label,
      ),
      prefixIcon: Icon(
        prefixIcon,
      ),
      suffixIcon: IconButton(
        onPressed: onPressed,
        icon: Icon(
          suffixIcon,
        ),
        splashColor: Colors.transparent,
      ),
    ),
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    obscureText: !isInputVisible,
    readOnly: isReadOnly,
    onChanged: onChange,
    onFieldSubmitted: onFieldSummited,
    onTapOutside: (event) {
      FocusScope.of(context).unfocus();
    },
  );
}

Widget defaultButton({
  required String label,
  required void Function()? onPressed,
  required double labelFont,
  required double buttonWidth,
}){
  return SizedBox(
    width: buttonWidth,
    height: 50.0,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: labelFont,
        ),
      ),
    ),
  );
}

Widget defaultTextButton({
  required String label,
  required void Function()? onPressed
}){
  return TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
  );
}

Future<bool?> showToast({
  required String message,
  ToastStates state = ToastStates.DEFAULT,
  Toast toastLength = Toast.LENGTH_LONG,
}){
  return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: toastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

enum ToastStates{SUCCESS, WARNING, ERROR, DEFAULT}

Color toastColor(ToastStates state){
  switch(state){
    case ToastStates.SUCCESS: return Colors.green;
    case ToastStates.WARNING: return Colors.amber;
    case ToastStates.ERROR: return Colors.red;
    case ToastStates.DEFAULT: return Colors.grey;
  }
}

Widget defaultTitle({
  required String title,
  EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
}){
  return Padding(
    padding: padding,
    child: Text(
      title,
      style: titleStyle,
    ),
  );
}

Widget myDivider(){
  return Container(
    color: Colors.grey[300],
    width: double.infinity,
    height: 1.0,
  );
}