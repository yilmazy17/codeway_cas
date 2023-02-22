import 'dart:async';

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/active_stories_controller.dart';
import 'package:codeway_case/Business/Controllers/user_stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryUserAnimatedContainer extends StatefulWidget {
  StoryUserAnimatedContainer(
      {super.key, required this.user, required this.activeIndex});
  User user;
  int activeIndex;

  @override
  State<StoryUserAnimatedContainer> createState() =>
      _StoryUserAnimatedStateContainer();
}

class _StoryUserAnimatedStateContainer
    extends State<StoryUserAnimatedContainer> {
  double borderWidth = 1;
  Color borderColor = Colors.red;
  bool isSelected = false;
  ActiveStoriesController _activeStoriesController = Get.find();
  whenSelected() async {
    isSelected = true;
    if (isSelected) {
      borderWidth = (borderWidth == 1) ? 5 : 1;
      borderColor = (borderColor == Colors.red) ? Colors.blue : Colors.red;
      setState(() {});
    } else {
      borderWidth = 1;
      borderColor = Colors.red;
      setState(() {});
    }
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (isSelected) {
        borderWidth = (borderWidth == 1) ? 5 : 1;
        borderColor = (borderColor == Colors.red) ? Colors.blue : Colors.red;
        setState(() {});
      } else {
        borderWidth = 1;
        borderColor = Colors.red;
        setState(() {});
        timer.cancel();
      }
    });
    _activeStoriesController.activeStoryIndex.value = widget.activeIndex;
    await _activeStoriesController.setActiveStories(widget.activeIndex);
    UserStoriesController userStories = _activeStoriesController
        .activeStories[_activeStoriesController.activeStoryIndex.value];
    Story story = userStories.stories[userStories.activeUserStoryIndex.value];
    _activeStoriesController.isStoryWatching = true;
    _activeStoriesController.startTimer();
    _activeStoriesController.progressPercentage.value = 0.0;

    isSelected = false;

    Get.toNamed('/storyPage');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          whenSelected();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            )),
        child: CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(widget.user.profilePhotoURL!),
        ),
      ),
    );
  }
}
