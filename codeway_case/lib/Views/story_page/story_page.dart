// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/user_stories_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:codeway_case/Views/story_watch_page/storyWatchPage.dart';
import 'package:codeway_case/Views/user_story_page_Initialized/user_story_page_Initialized.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  ShowedUsersController _showedUsersController = Get.find();
  ActiveStoriesController _activeStoriesController = Get.find();
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
                onSlideEnd: () {
                  UserStoriesController userStories =
                      _activeStoriesController.activeStories[
                          _activeStoriesController.activeStoryIndex.value];
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  if (story.type == StoryEnum.video) {
                    story.itemController!.play();
                  }
                  _activeStoriesController.isUserTapped = false;
                },
                onSlideChanged: (value) {
                  _activeStoriesController.progressPercentage.value = 0;
                  UserStoriesController userStories =
                      _activeStoriesController.activeStories[
                          _activeStoriesController.activeStoryIndex.value];
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  if (story.type == StoryEnum.video) {
                    story.itemController!.pause();
                    story.itemController!.seekTo(Duration(seconds: 0));
                  }

                  _activeStoriesController.activeStoryIndex.value = value;
                  userStories = _activeStoriesController.activeStories[
                      _activeStoriesController.activeStoryIndex.value];
                  story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  if (story.type == StoryEnum.video) {
                    story.itemController!.play();
                  }
                },
                initialPage: _activeStoriesController.activeStoryIndex.value,
                autoSliderTransitionTime: Duration(milliseconds: 400),
                controller: _activeStoriesController.carouselSliderController,
                slideTransform: CubeTransform(),
                slideBuilder: (index) {
                  return UserStoryPage(
                      controller:
                          _activeStoriesController.carouselSliderController,
                      storyDetail:
                          _activeStoriesController.activeStories[index]);
                },
                itemCount: _showedUsersController.activeUsers.length),
          ),
        ],
      )),
    );
  }
}
