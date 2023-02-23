// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/user_stories_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:codeway_case/Entity/Interfaces_Controllers/I_active_stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ActiveStoriesController extends IActiveStoriesController {
  initializeActiveStories() {
    ShowedUsersController _showedUserController = Get.find();
    for (var element in _showedUserController.activeUsers) {
      UserStoriesController userStories = UserStoriesController();
      userStories.user = element;
      activeStories.add(userStories);
    }
  }

  Future setInitialPosition() async {
    activeStories.clear();
    activeStoryIndex.value = -1;
    ShowedUsersController _showedUserController = Get.find();
    for (var element in _showedUserController.activeUsers) {
      UserStoriesController userStories = UserStoriesController();
      userStories.user = element;
      activeStories.add(userStories);
    }
  }

  Future setActiveStories(int index) async {
    ShowedUsersController showedUsersController = Get.find();
    UserStoriesController? tempItem;
    User? user;
    if (index > 0) {
      tempItem = activeStories[index - 1];
      if (!tempItem!.isUserStoriesInitialized.value) {
        user = showedUsersController.activeUsers[index - 1];
        await tempItem.addStories(storyURLList: user!.storiesList);
      }
    }

    tempItem = activeStories[index];
    if (!tempItem!.isUserStoriesInitialized.value) {
      user = showedUsersController.activeUsers[index];
      await tempItem.addStories(storyURLList: user!.storiesList);
    }

    if (index < activeStories.length - 1) {
      tempItem = activeStories[index + 1];
      if (!tempItem!.isUserStoriesInitialized.value) {
        user = showedUsersController.activeUsers[index + 1];
        await tempItem.addStories(storyURLList: user!.storiesList);
      }
    }
  }

  Future startTimer() async {
    Timer.periodic(Duration(milliseconds: 200), (timer) async {
      UserStoriesController userStories = activeStories[activeStoryIndex.value];
      if (userStories.storyCount.value > 0) {
        Story story =
            userStories.stories[userStories.activeUserStoryIndex.value];

        if (isStoryWatching) {
          if (story.type == StoryEnum.video) {
            VideoPlayerController _controller = story.itemController!;
            if (!_controller.value.isPlaying &&
                !(_controller.value.position == _controller.value.duration) &&
                !isUserTapped) {
              await _controller.play();
            }
            if (_controller.value.position.inMicroseconds == 0.0) {
              progressPercentage.value = 0.0;
            } else {
              progressPercentage.value =
                  (_controller.value.position.inMicroseconds /
                      _controller.value.duration.inMicroseconds);
            }

            if (_controller.value.position == _controller.value.duration) {
              progressPercentage.value = 0;
              bool isUserStoryGroupOnEndPosition =
                  userStories.activeUserStoryIndex ==
                      userStories.stories.length - 1;
              bool isStoriesOnEndPosition =
                  activeStoryIndex.value == activeStories.length - 1;
              if (isUserStoryGroupOnEndPosition) {
                if (isStoriesOnEndPosition) {
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  // await _activeStoriesController.setInitialPosition();
                  await story.itemController!.seekTo(Duration(seconds: 0));
                  userStories.activeUserStoryIndex.value = 0;
                  isStoryWatching = false;
                  Get.back();
                } else {
                  UserStoriesController userStories =
                      activeStories[activeStoryIndex.value];
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  await story.itemController!.seekTo(Duration(seconds: 0));
                  // userStories.activeUserStoryIndex.value = 0;

                  activeStoryIndex++;
                  setActiveStories(activeStoryIndex.value);
                  userStories = activeStories[activeStoryIndex.value];
                  story = userStories
                      .stories[userStories.activeUserStoryIndex.value];

                  await carouselSliderController.nextPage();
                }
              } else {
                Story story =
                    userStories.stories[userStories.activeUserStoryIndex.value];
                await story.itemController!.seekTo(Duration(seconds: 0));
                userStories.activeUserStoryIndex.value++;
                if (userStories.activeUserStoryIndex.value ==
                    userStories.stories.length - 1) {
                  ShowedUsersController showedUsersController = Get.find();
                  User user =
                      showedUsersController.activeUsers[activeStoryIndex.value];
                  user.setAllwatchedValue();
                }
                story =
                    userStories.stories[userStories.activeUserStoryIndex.value];
              }
            }
          } else {
            double tempPerc = progressPercentage.value;
            if (tempPerc + (0.2 / 5.0) < 1.0) {
              progressPercentage.value = progressPercentage.value + (0.2 / 5.0);
            }

            if (tempPerc + (0.2 / 5.0) > 1) {
              progressPercentage.value = 0;
              bool isUserStoryGroupOnEndPosition =
                  userStories.activeUserStoryIndex ==
                      userStories.stories.length - 1;
              bool isStoriesOnEndPosition =
                  activeStoryIndex.value == activeStories.length - 1;
              if (isUserStoryGroupOnEndPosition) {
                if (isStoriesOnEndPosition) {
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  userStories.activeUserStoryIndex.value = 0;
                  isStoryWatching = false;
                  Get.back();
                } else {
                  UserStoriesController userStories =
                      activeStories[activeStoryIndex.value];
                  Story story = userStories
                      .stories[userStories.activeUserStoryIndex.value];

                  userStories.activeUserStoryIndex.value = 0;

                  activeStoryIndex++;

                  setActiveStories(activeStoryIndex.value);
                  userStories = activeStories[activeStoryIndex.value];
                  story = userStories
                      .stories[userStories.activeUserStoryIndex.value];
                  await carouselSliderController.nextPage();
                }
              } else {
                Story story =
                    userStories.stories[userStories.activeUserStoryIndex.value];
                userStories.activeUserStoryIndex.value++;
                if (userStories.activeUserStoryIndex.value ==
                    userStories.stories.length - 1) {
                  ShowedUsersController showedUsersController = Get.find();
                  User user =
                      showedUsersController.activeUsers[activeStoryIndex.value];
                  user.setAllwatchedValue();
                }
                story =
                    userStories.stories[userStories.activeUserStoryIndex.value];
              }
            }
          }
        } else {
          timer.cancel();
        }
      }
    });
  }
}
