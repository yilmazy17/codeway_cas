import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

abstract class IActiveStoriesController extends GetxController {
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
