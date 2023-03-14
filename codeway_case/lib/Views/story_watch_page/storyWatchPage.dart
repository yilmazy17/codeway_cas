// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
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
  ActiveStoryController _activeStoryController = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.story.type == StoryEnum.video) {
      _controller = widget.story.itemController!;
    }
  }

  _onTapUpFunc(details) async {
    _activeStoryController.onTapUpFunc(
        details: details,
        widgetStory: widget.story,
        sliderController: widget.controller,
        videoController: _controller);
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
            _activeStoryController.isUserTapped = false;
            if (widget.story.type == StoryEnum.video) {
              _controller!.play();
            }
          } catch (e) {
            print(e.toString());
            _activeStoryController.setInitialPosition();
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
              _activeStoryController.isUserTapped = true;
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
            _activeStoryController.setInitialPosition();
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
