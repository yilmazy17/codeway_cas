// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
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
    try {
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
            _activeStoriesController.activeStoryIndex++;
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
          if (userStories.activeUserStoryIndex.value ==
              userStories.stories.length - 1) {
            ShowedUsersController showedUsersController = Get.find();
            User user = showedUsersController
                .activeUsers[_activeStoriesController.activeStoryIndex.value];
            user.setAllwatchedValue();
          }
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
    } catch (e) {
      print(e.toString());
      _activeStoriesController.setInitialPosition();
      Get.back();
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.story.type == StoryEnum.video) {
      _controller = widget.story.itemController!;
    }
    return WillPopScope(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressEnd: (details) {
          try {
            _activeStoriesController.isUserTapped = false;
            if (widget.story.type == StoryEnum.video) {
              _controller!.play();
            }
          } catch (e) {
            print(e.toString());
            _activeStoriesController.setInitialPosition();
            Get.back();
            Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              title: 'Error',
              message: e.toString(),
              backgroundColor: Colors.red,
            );
          }
        },
        onTapUp: _onTapUpFunc,
        onTapDown: (details) {
          try {
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
          } catch (e) {
            print(e.toString());
            _activeStoriesController.setInitialPosition();
            Get.back();
            Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              title: 'Error',
              message: e.toString(),
              backgroundColor: Colors.red,
            );
          }
        },
        child: (widget.story.type == StoryEnum.video)
            ? Center(
                child: _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!))
                    : Container(),
              )
            : AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(widget.story.contentURL!),
              ),
      ),
      onWillPop: () async => false,
    );
  }
}
