import 'package:video_player/video_player.dart';

enum StoryEnum { video, image, unknown }

abstract class IStory {
  StoryEnum? type;
  String? contentURL;
  VideoPlayerController? itemController;
}
