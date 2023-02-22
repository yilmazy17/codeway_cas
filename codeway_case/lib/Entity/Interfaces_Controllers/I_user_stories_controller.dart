import 'package:codeway_case/Business/Classes/story.dart';
import 'package:get/get.dart';

abstract class IUserStoriesController extends GetxController {
  List<Story> stories = [];
  String? username;
  int? storyCount;
  var activeUserStoryIndex = 0.obs;
  var isUserStoriesInitialized = false.obs;
}
