import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/shared/styles/styles.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: primaryColor,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    titleTextStyle: titleStyle.copyWith(
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    elevation: 0.0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
  )
);

ThemeData darkTheme = ThemeData(
  primarySwatch: primaryColor,
  appBarTheme: AppBarTheme(
    color: const Color(0xff252526),
    titleTextStyle: titleStyle.copyWith(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white12,
    ),
    elevation: 0.0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Color(0xff252526),
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xff252526),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff252526),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
    )
);
