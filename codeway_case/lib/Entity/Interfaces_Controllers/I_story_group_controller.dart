import 'package:codeway_case/Business/Classes/story.dart';
import 'package:codeway_case/Business/Classes/users.dart';
import 'package:get/get.dart';

abstract class IStoryGroupController extends GetxController {
  List<Story> stories = [];

  User? user;
  var storyCount = 0.obs;
  var activeUserStoryIndex = 0.obs;
  var isUserStoriesInitialized = false.obs;
  bool isStoryInitializeProcessStarted = false;
}
