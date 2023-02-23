import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:codeway_case/Entity/Interfaces_Controllers/I_user_stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class UserStoriesController extends IUserStoriesController {
  Future addStories({
    required List<dynamic> storyURLList,
  }) async {
    try {
      if (!isStoryInitializeProcessStarted) {
        for (var element in storyURLList) {
          stories.add(Story(
              contentURL: element['url'],
              type: (element['type'] == 'video')
                  ? StoryEnum.video
                  : StoryEnum.image,
              itemController: (element['type'] == 'video'
                  ? VideoPlayerController.network(element['url'])
                  : null)));
        }
        await initializeStories();
        storyCount.value = storyURLList.length;
        isUserStoriesInitialized.value = true;
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future initializeStories() async {
    try {
      isStoryInitializeProcessStarted = true;
      ShowedUsersController showedUsersController = Get.find();
      if (!isUserStoriesInitialized.value) {
        for (var element in stories) {
          Story item = element;
          if (item.type == StoryEnum.image) {
            await precacheImage(NetworkImage(item.contentURL!),
                showedUsersController.scaffoldKey!.currentContext!);
          } else if (item.type == StoryEnum.video) {
            await item.itemController!.initialize();
          }
        }
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
