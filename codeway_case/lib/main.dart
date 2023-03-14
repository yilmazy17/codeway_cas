import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/story_group_controller.dart';
import 'package:codeway_case/Views/main_page/mainPage.dart';
import 'package:codeway_case/Views/splash_page/splash_page.dart';
import 'package:codeway_case/Views/story_page/story_page.dart';
import 'package:codeway_case/Views/story_watch_page/storyWatchPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
  initializeControllers();
}

initializeControllers() {
  Get.put(ShowedUsersController(), permanent: true);
  Get.put(ActiveStoryController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: EasyLoading.init(),
      // initialRoute: RouteManagementConstants.loginpage1Route,
      onInit: () {
        precacheImage(AssetImage("assets/codewaylogo.png"), context);
      },
      initialRoute: 'splashPage',
      debugShowCheckedModeBanner: false,
      title: 'Codeway Case',
      locale: Get.deviceLocale, // translations will be displayed in that locale
      fallbackLocale: Locale('en', 'US'),
      // theme: ThemeData(
      //   bottomAppBarTheme:
      //       BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
      //   textTheme:
      //       TextTheme(bodyMedium: TextStyle(fontWeight: FontWeight.w500)),
      //   fontFamily: 'Inter',
      // ),
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(name: '/mainPage', page: () => const MainPage()),
        GetPage(name: '/splashPage', page: () => const SplashPage()),
        GetPage(
            name: '/storyPage',
            page: () => const StoryPage(),
            transition: Transition.circularReveal,
            curve: Curves.bounceIn),
      ],
    );
  }
}
