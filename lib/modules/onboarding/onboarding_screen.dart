// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/navigation/navigation.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageModel {
  String image;
  String title;
  String description;

  OnboardingPageModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      image: 'assets/images/onboarding_one.png',
      title: 'Welcome Aboard!',
      description:
          'Dive into a seamless onboarding experience that introduces you to a world of possibilities. Get ready for a journey tailored just for you.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_two.png',
      title: 'Online Shopping',
      description:
          'Explore trendy styles, shop conveniently from rome, find your perfect look, ond embrace fashion-forward choices online.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_three.png',
      title: 'Shop From Your Favorite Store',
      description:
          'Discover A World Of Convenience And Endless Choices Get Ready To Experience The Best Of Online Shopping Right At Your Fingertips.',
    ),
  ];

  PageController pageController = PageController();

  bool isLast = false;

  void onBoardingFinish(BuildContext context){
    CacheHelper.saveData(key: 'onBoarding', value: true);
    navigateAndRemove(
      context: context,
      widget: LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            label: 'Skip',
            onPressed: () {
              onBoardingFinish(context);
            },
          ),
        ],
      ),
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (index == onboardingPages.length - 1) {
            isLast = true;
          } else {
            isLast = false;
          }
        },
        itemBuilder: (context, index) =>
            onboardingPage(onboardingPages[index], context),
        controller: pageController,
        itemCount: onboardingPages.length,
      ),
    );
  }

  Widget onboardingPage(OnboardingPageModel pageModel, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(pageModel.image),
            ),
            Text(
              pageModel.title,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              pageModel.description,
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: onboardingPages.length,
                  effect: const ExpandingDotsEffect(
                      expansionFactor: 4,
                      dotHeight: 14,
                      dotWidth: 14,
                      spacing: 6,
                      activeDotColor: Colors.teal),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      onBoardingFinish(context);
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      );
}
