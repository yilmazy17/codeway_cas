// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/user_stories_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:codeway_case/Views/story_watch_page/storyWatchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';

class UserStoryPage extends StatefulWidget {
  UserStoryPage(
      {super.key, required this.storyDetail, required this.controller});
  UserStoriesController storyDetail;
  CarouselSliderController controller;
  @override
  State<UserStoryPage> createState() => _UserStoryPageState();
}

class _UserStoryPageState extends State<UserStoryPage> {
  ActiveStoriesController _activeStoriesController = Get.find();
  ShowedUsersController _showedUsersController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Container(
                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                child: Row(
                  children: widget.storyDetail.stories.asMap().entries.map((e) {
                    if (e.key < widget.storyDetail.activeUserStoryIndex.value) {
                      return Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            barRadius: Radius.circular(10),
                            lineHeight: 5.0,
                            percent: 1,
                            animation: false,
                            backgroundColor: Colors.grey.shade100,
                            progressColor: Colors.white,
                          ),
                        ),
                      );
                    } else if (e.key ==
                        widget.storyDetail.activeUserStoryIndex.value) {
                      return Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                          child: Obx(
                            () => LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              barRadius: Radius.circular(10),
                              lineHeight: 5.0,
                              animation: true,
                              animateFromLastPercent: true,
                              restartAnimation: false,
                              percent: _activeStoriesController
                                  .progressPercentage.value,
                              backgroundColor: Colors.grey,
                              progressColor: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                          )),
                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            barRadius: Radius.circular(10),
                            lineHeight: 5.0,
                            percent: 0,
                            animation: false,
                            backgroundColor: Colors.grey,
                            progressColor: Colors.grey.shade100,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
              )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(_showedUsersController
                              .activeUsers[_activeStoriesController
                                  .activeStoryIndex.value]
                              .profilePhotoURL!),
                        ),
                      ),
                      Text(
                        _showedUsersController
                            .activeUsers[
                                _activeStoriesController.activeStoryIndex.value]
                            .username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    UserStoriesController userStories = widget.storyDetail;
                    if (userStories.isUserStoriesInitialized.value) {
                      Story story = userStories
                          .stories[userStories.activeUserStoryIndex.value];
                      if (story.type == StoryEnum.video) {
                        VideoPlayerController _controller =
                            story.itemController!;
                        await _controller.pause();
                        await _controller.seekTo(const Duration(seconds: 0));
                      }
                    }

                    // await _activeStoriesController.setInitialPosition();
                    _activeStoriesController.isStoryWatching = false;
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(() {
            return Expanded(
              child: StoryWatchPage(
                  controller: widget.controller,
                  story: widget.storyDetail
                      .stories[widget.storyDetail.activeUserStoryIndex.value]),
            );
          }),
        ],
      ),
    );
  }
}
