import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

abstract class IActiveStoriesController extends GetxController {
  List<dynamic> activeStories = [];
  var activeStoryIndex = (-1).obs;
  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  bool isStoryWatching = false;
  bool isFirstItemLoaded = false;
  bool isUserTapped = false;
  var progressPercentage = 0.0.obs;
  var previousStoryIndex = (-1).obs;
}
