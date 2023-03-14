// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, sized_box_for_whitespace

import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Views/user_story_page/user_story_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  ShowedUsersController _showedUsersController = Get.find();
  ActiveStoryController _activeStoryController = Get.find();
  int sliderIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: Get.height * 0.8,
            child: CarouselSlider.builder(
                onSlideEnd: _activeStoryController.sliderSlideEnded,
                onSlideChanged: _activeStoryController.sliderSlideChanged,
                initialPage: _activeStoryController.activeStoryIndex.value,
                autoSliderTransitionTime: Duration(milliseconds: 400),
                controller: _activeStoryController.carouselSliderController,
                slideTransform: CubeTransform(),
                slideBuilder: (index) {
                  return UserStoryPage(
                      userIndex: index,
                      controller:
                          _activeStoryController.carouselSliderController,
                      storyDetail: _activeStoryController.activeStories[index]);
                },
                itemCount: _showedUsersController.activeUsers.length),
          ),
        ],
      )),
    );
  }
}
