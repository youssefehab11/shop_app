// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constans.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'modules/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Object? onBoarding = CacheHelper.getData('onBoarding');
  TOKEN = CacheHelper.getData('token');
  print('Token: $TOKEN');
  late Widget startWidget;
  if (onBoarding != null) {
    if (TOKEN != null) {
      startWidget = const HomeLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnboardingScreen();
  }
  runApp(
    MyApp(
      isOnboarding: onBoarding,
      startWidget: startWidget,
    ),
  );
}

class MyApp extends StatelessWidget {
  Object? isOnboarding;
  Widget startWidget;

  MyApp({
    super.key,
    required this.isOnboarding,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: startWidget,
    );
  }
}
