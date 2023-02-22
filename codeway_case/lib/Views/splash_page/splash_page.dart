// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_field, prefer_final_fields

import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ShowedUsersController _showedUsersController = Get.find();
  ActiveStoriesController _activeStoriesController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await splashFunc();
      Get.offAndToNamed('/mainPage');
    });
  }

  Future splashFunc() async {
    await _showedUsersController.getShowedUsers(context);
    await _activeStoriesController.initializeActiveStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/codewaylogo.png',
          ),
        ),
      ),
    );
  }
}
