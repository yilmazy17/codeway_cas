// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/stroy_material_controller.dart';
import 'package:codeway_case/Business/Controllers/user_stories_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class StoryWatchPage extends StatefulWidget {
  StoryWatchPage({super.key, required this.story, required this.controller});
  CarouselSliderController controller;
  Story story;

  @override
  State<StoryWatchPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StoryWatchPage> {
  VideoPlayerController? _controller;
  StoryMaterialController _storyMaterialController = Get.find();
  ShowedUsersController _showedUsersController = Get.find();
  ActiveStoriesController _activeStoriesController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.story.type == StoryEnum.video) {
      _controller = widget.story.itemController!;
    }
  }

  _onTapUpFunc(details) async {
    _activeStoriesController.progressPercentage.value = 0.0;
    _activeStoriesController.isUserTapped = false;

    final double screenWidth = Get.width / 2;
    final double dx = details.globalPosition.dx;
    UserStoriesController userStories = _activeStoriesController
        .activeStories[_activeStoriesController.activeStoryIndex.value];
    bool isUserStoryGroupOnEndPosition =
        userStories.activeUserStoryIndex == userStories.stories.length - 1;
    bool isUserStoryGroupOnStartPosition =
        userStories.activeUserStoryIndex == 0;
    bool isStoriesOnEndPosition =
        _activeStoriesController.activeStoryIndex.value ==
            _activeStoriesController.activeStories.length - 1;
    bool isStoriesOnStartPosition =
        _activeStoriesController.activeStoryIndex.value == 0;
    if (dx > screenWidth / 2) {
      if (isUserStoryGroupOnEndPosition) {
        if (isStoriesOnEndPosition) {
          if (widget.story.type == StoryEnum.video) {
            await _controller!.pause();
            await _controller!.seekTo(const Duration(seconds: 0));
          }

          // await _activeStoriesController.setInitialPosition();
          _activeStoriesController.isStoryWatching = false;
          Get.back();
        } else {
          if (widget.story.type == StoryEnum.video) {
            await _controller!.pause();
            await _controller!.seekTo(const Duration(seconds: 0));
          }

          UserStoriesController userStories = _activeStoriesController
              .activeStories[_activeStoriesController.activeStoryIndex.value];
          Story story =
              userStories.stories[userStories.activeUserStoryIndex.value];
          userStories.activeUserStoryIndex.value = 0;
          _activeStoriesController.previousStoryIndex.value =
              _activeStoriesController.activeStoryIndex.value;
          _activeStoriesController.activeStoryIndex++;
          _activeStoriesController.setActiveStories(
              _activeStoriesController.activeStoryIndex.value);
          userStories = _activeStoriesController
              .activeStories[_activeStoriesController.activeStoryIndex.value];
          story = userStories.stories[userStories.activeUserStoryIndex.value];
          widget.controller.nextPage();
        }
      } else {
        if (widget.story.type == StoryEnum.video) {
          await _controller!.pause();
          await _controller!.seekTo(const Duration(seconds: 0));
        }
        userStories.activeUserStoryIndex.value++;
      }
    } else {
      if (isUserStoryGroupOnStartPosition) {
        if (isStoriesOnStartPosition) {
        } else {
          if (widget.story.type == StoryEnum.video) {
            await _controller!.pause();
            await _controller!.seekTo(const Duration(seconds: 0));
          }
          _activeStoriesController.activeStoryIndex--;
          _activeStoriesController.setActiveStories(
              _activeStoriesController.activeStoryIndex.value);
          UserStoriesController userStories = _activeStoriesController
              .activeStories[_activeStoriesController.activeStoryIndex.value];
          Story story =
              userStories.stories[userStories.activeUserStoryIndex.value];
          widget.controller.previousPage();
        }
      } else {
        if (widget.story.type == StoryEnum.video) {
          await _controller!.pause();
          await _controller!.seekTo(const Duration(seconds: 0));
        }
        userStories.activeUserStoryIndex.value--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.story.type == StoryEnum.video) {
      _controller = widget.story.itemController!;
    }
    return WillPopScope(
      child: GestureDetector(
          onLongPressEnd: (details) {
            _activeStoriesController.isUserTapped = false;
            if (widget.story.type == StoryEnum.video) {
              _controller!.play();
            }
          },
          onTapUp: _onTapUpFunc,
          onTapDown: (details) {
            if (this.mounted) {
              _activeStoriesController.isUserTapped = true;
              if (widget.story.type == StoryEnum.video) {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              }
            }
          },
          child: (widget.story.type == StoryEnum.video)
              ? Center(
                  child: _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Stack(
                            children: [
                              VideoPlayer(_controller!),
                              // Obx(
                              //   () => Visibility(
                              //     visible: !_storyMaterialController
                              //         .isProgressIndicatorEnable.value,
                              //     child: Center(
                              //       child: Transform.scale(
                              //           scale: 1.5,
                              //           child: const CircularProgressIndicator(
                              //             strokeWidth: 2,
                              //             color: Colors.grey,
                              //           )),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ))
                      : Container(),
                )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(widget.story.contentURL!),
                )),
      onWillPop: () async => false,
    );
  }
}