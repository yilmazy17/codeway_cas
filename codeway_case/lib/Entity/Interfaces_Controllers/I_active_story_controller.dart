import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

abstract class IActiveStoryController extends GetxController {
  List<dynamic> activeStories = [];
  var activeStoryIndex = (-1).obs;
  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  bool isStoryWatching = false;
  bool isFirstItemLoaded = false;
  List<dynamic> storyInitPipeline = [];

  bool isUserTapped = false;
  var progressPercentage = 0.0.obs;
}
