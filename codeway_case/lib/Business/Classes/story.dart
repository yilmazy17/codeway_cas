import 'package:codeway_case/Entity/Interfaces_Classes/I_story.dart';
import 'package:video_player/video_player.dart';

class Story extends IStory {
  Story(
      {required StoryEnum type,
      required String contentURL,
      VideoPlayerController? itemController}) {
    this.contentURL = contentURL;
    this.itemController = itemController;
    this.type = type;
  }
}
