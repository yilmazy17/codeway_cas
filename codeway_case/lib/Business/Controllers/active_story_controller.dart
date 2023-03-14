// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/story_group_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:codeway_case/Entity/Interfaces_Controllers/I_active_story_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ActiveStoryController extends IActiveStoryController {
  initializeActiveStories() {
    ShowedUsersController _showedUserController = Get.find();
    for (var element in _showedUserController.activeUsers) {
      StoryGroupController storyGroup = StoryGroupController();
      storyGroup.user = element;
      activeStories.add(storyGroup);
    }
  }

  Future setInitialPosition() async {
    activeStories.clear();
    activeStoryIndex.value = -1;
    ShowedUsersController _showedUserController = Get.find();
    for (var element in _showedUserController.activeUsers) {
      StoryGroupController storyGroup = StoryGroupController();
      storyGroup.user = element;
      activeStories.add(storyGroup);
    }
  }

  Future setActiveStories(int index) async {
    try {
      ShowedUsersController showedUsersController = Get.find();
      StoryGroupController? tempStoryGroup;
      User? user;
      if (index > 0) {
        tempStoryGroup = activeStories[index - 1];
        if (!tempStoryGroup!.isUserStoriesInitialized.value) {
          user = showedUsersController.activeUsers[index - 1];
          await tempStoryGroup.addStories(storyURLList: user!.storiesList);
        }
      }

      tempStoryGroup = activeStories[index];
      if (!tempStoryGroup!.isUserStoriesInitialized.value) {
        user = showedUsersController.activeUsers[index];
        await tempStoryGroup.addStories(storyURLList: user!.storiesList);
      }

      if (index < activeStories.length - 1) {
        tempStoryGroup = activeStories[index + 1];
        if (!tempStoryGroup!.isUserStoriesInitialized.value) {
          user = showedUsersController.activeUsers[index + 1];
          await tempStoryGroup.addStories(storyURLList: user!.storiesList);
        }
      }
    } catch (e) {
      print(e.toString());
      await setInitialPosition();
      Get.back();
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  Future startTimer() async {
    Timer.periodic(Duration(milliseconds: 200), (timer) async {
      try {
        StoryGroupController storyGroup = activeStories[activeStoryIndex.value];
        if (storyGroup.storyCount.value > 0) {
          Story story = storyGroup.getActiveStory();

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
                    storyGroup.activeUserStoryIndex ==
                        storyGroup.stories.length - 1;
                bool isStoriesOnEndPosition =
                    activeStoryIndex.value == activeStories.length - 1;
                if (isUserStoryGroupOnEndPosition) {
                  if (isStoriesOnEndPosition) {
                    Story story = storyGroup.getActiveStory();
                    await story.itemController!.seekTo(Duration(seconds: 0));
                    storyGroup.activeUserStoryIndex.value = 0;
                    isStoryWatching = false;
                    Get.back();
                  } else {
                    StoryGroupController storyGroup =
                        activeStories[activeStoryIndex.value];
                    Story story = storyGroup.getActiveStory();
                    await story.itemController!.seekTo(Duration(seconds: 0));
                    // userStories.activeUserStoryIndex.value = 0;
                    await carouselSliderController.nextPage();
                    activeStoryIndex++;
                    setActiveStories(activeStoryIndex.value);
                    storyGroup = activeStories[activeStoryIndex.value];
                    story = storyGroup.getActiveStory();
                  }
                } else {
                  Story story = storyGroup.getActiveStory();
                  await story.itemController!.seekTo(Duration(seconds: 0));
                  storyGroup.activeUserStoryIndex.value++;
                  if (storyGroup.activeUserStoryIndex.value ==
                      storyGroup.stories.length - 1) {
                    ShowedUsersController showedUsersController = Get.find();
                    User user = showedUsersController
                        .activeUsers[activeStoryIndex.value];
                    user.setAllwatchedValue();
                  }
                  story = storyGroup.getActiveStory();
                }
              }
            } else {
              double tempPerc = progressPercentage.value;
              if (tempPerc + (0.2 / 5.0) < 1.0) {
                progressPercentage.value =
                    progressPercentage.value + (0.2 / 5.0);
              }

              if (tempPerc + (0.2 / 5.0) > 1) {
                progressPercentage.value = 0;
                bool isUserStoryGroupOnEndPosition =
                    storyGroup.activeUserStoryIndex ==
                        storyGroup.stories.length - 1;
                bool isStoriesOnEndPosition =
                    activeStoryIndex.value == activeStories.length - 1;
                if (isUserStoryGroupOnEndPosition) {
                  if (isStoriesOnEndPosition) {
                    storyGroup.activeUserStoryIndex.value = 0;
                    isStoryWatching = false;
                    Get.back();
                  } else {
                    await carouselSliderController.nextPage();

                    activeStoryIndex++;
                    setActiveStories(activeStoryIndex.value);
                  }
                } else {
                  storyGroup.activeUserStoryIndex.value++;
                  if (storyGroup.activeUserStoryIndex.value ==
                      storyGroup.stories.length - 1) {
                    ShowedUsersController showedUsersController = Get.find();
                    User user = showedUsersController
                        .activeUsers[activeStoryIndex.value];
                    user.setAllwatchedValue();
                  }
                  story = storyGroup.getActiveStory();
                }
              }
            }
          } else {
            timer.cancel();
          }
        }
      } catch (e) {
        print(e.toString());
        await setInitialPosition();
        Get.back();
        Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          title: 'Error',
          message: e.toString(),
          backgroundColor: Colors.red,
        );
      }
    });
  }

  Future sliderSlideChanged(value) async {
    try {
      progressPercentage.value = 0;
      StoryGroupController storyGroup = activeStories[activeStoryIndex.value];
      if (storyGroup.storyCount.value > 0) {
        Story story = storyGroup.getActiveStory();
        if (story.type == StoryEnum.video) {
          story.itemController!.pause();
          story.itemController!.seekTo(Duration(seconds: 0));
        }

        activeStoryIndex.value = value;
        storyGroup = activeStories[activeStoryIndex.value];

        if (story.type == StoryEnum.video) {
          story.itemController!.play();
        }
      }
    } catch (e) {
      print(e.toString());
      setInitialPosition();
      Get.back();
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  Future sliderSlideEnded() async {
    try {
      setActiveStories(activeStoryIndex.value);
    } catch (e) {
      setInitialPosition();
      Get.back();
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  Future selectStory(int activeIndex) async {
    activeStoryIndex.value = activeIndex;
    await setActiveStories(activeIndex);
    isStoryWatching = true;
    await startTimer();
    progressPercentage.value = 0.0;
  }

  onTapUpFunc(
      {required var details,
      required Story widgetStory,
      VideoPlayerController? videoController,
      required CarouselSliderController sliderController}) async {
    try {
      progressPercentage.value = 0.0;
      isUserTapped = false;
      final double screenWidth = Get.width / 2;
      final double dx = details.globalPosition.dx;
      StoryGroupController storyGroup = activeStories[activeStoryIndex.value];
      bool isUserStoryGroupOnEndPosition =
          storyGroup.activeUserStoryIndex == storyGroup.stories.length - 1;
      bool isUserStoryGroupOnStartPosition =
          storyGroup.activeUserStoryIndex == 0;
      bool isStoriesOnEndPosition =
          activeStoryIndex.value == activeStories.length - 1;
      bool isStoriesOnStartPosition = activeStoryIndex.value == 0;
      if (dx > screenWidth / 2) {
        if (isUserStoryGroupOnEndPosition) {
          if (isStoriesOnEndPosition) {
            if (widgetStory.type == StoryEnum.video) {
              await videoController!.pause();
              await videoController.seekTo(const Duration(seconds: 0));
            }

            // await _activeStoriesController.setInitialPosition();
            isStoryWatching = false;
            Get.back();
          } else {
            if (widgetStory.type == StoryEnum.video) {
              await videoController!.pause();
              await videoController.seekTo(const Duration(seconds: 0));
            }
            activeStoryIndex++;
            await sliderController.nextPage();
          }
        } else {
          if (widgetStory.type == StoryEnum.video) {
            await videoController!.pause();
            await videoController.seekTo(const Duration(seconds: 0));
          }
          storyGroup.activeUserStoryIndex.value++;
          if (storyGroup.activeUserStoryIndex.value ==
              storyGroup.stories.length - 1) {
            ShowedUsersController showedUsersController = Get.find();
            User user =
                showedUsersController.activeUsers[activeStoryIndex.value];
            user.setAllwatchedValue();
          }
        }
      } else {
        if (isUserStoryGroupOnStartPosition) {
          if (isStoriesOnStartPosition) {
          } else {
            if (widgetStory.type == StoryEnum.video) {
              await videoController!.pause();
              await videoController.seekTo(const Duration(seconds: 0));
            }
            activeStoryIndex--;
            sliderController.previousPage();
          }
        } else {
          if (widgetStory.type == StoryEnum.video) {
            await videoController!.pause();
            await videoController.seekTo(const Duration(seconds: 0));
          }
          storyGroup.activeUserStoryIndex.value--;
        }
      }
    } catch (e) {
      setInitialPosition();
      Get.back();
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  Future closeStory(StoryGroupController storyDetail) async {
    StoryGroupController storyGroup = storyDetail;
    if (storyGroup.isUserStoriesInitialized.value) {
      Story story = storyGroup.getActiveStory();
      if (story.type == StoryEnum.video) {
        VideoPlayerController _controller = story.itemController!;
        await _controller.pause();
        await _controller.seekTo(const Duration(seconds: 0));
      }
    }
    isStoryWatching = false;
    Get.back();
  }
}
