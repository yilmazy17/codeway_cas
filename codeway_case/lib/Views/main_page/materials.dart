import 'dart:async';

import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/story_group_controller.dart';
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
  double borderWidth = 2;
  Color borderColor = Colors.red;
  bool isSelected = false;
  ShowedUsersController _showedUsersController = Get.find();
  ActiveStoryController _activeStoryController = Get.find();
  selectionAnimationBuilder() async {
    isSelected = true;
    if (isSelected) {
      borderWidth = (borderWidth == 2) ? 5 : 2;
      borderColor = (borderColor == Colors.red) ? Colors.blue : Colors.red;
      setState(() {});
    } else {
      borderWidth = 2;
      borderColor = Colors.red;
      setState(() {});
    }
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (isSelected) {
        borderWidth = (borderWidth == 2) ? 5 : 2;
        borderColor = (borderColor == Colors.red) ? Colors.blue : Colors.red;
        setState(() {});
      } else {
        borderWidth = 2;
        borderColor = Colors.red;
        setState(() {});
        timer.cancel();
      }
    });
  }

  selectStory() async {
    if (!isSelected) {
      selectionAnimationBuilder();
      await _activeStoryController.selectStory(widget.activeIndex);
      isSelected = false;
      Get.toNamed('/storyPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectStory();
      },
      child: Obx(
        () => AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: borderWidth,
                color: isSelected
                    ? borderColor
                    : _showedUsersController.activeUsers[widget.activeIndex]
                            .isAllStoriesWathed.value
                        ? Colors.grey
                        : Colors.red,
              )),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(widget.user.profilePhotoURL!),
          ),
        ),
      ),
    );
  }
}
