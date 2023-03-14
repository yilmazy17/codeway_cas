import 'package:codeway_case/Business/Controllers/active_story_controller.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Business/Controllers/story_group_controller.dart';
import 'package:codeway_case/Entity/Interfaces_Classes/I_users.dart';
import 'package:get/get.dart';

class User extends IUser {
  User(
      {required String profilePhotoURL,
      required List<dynamic> storiesList,
      required String username}) {
    this.username = username;
    this.profilePhotoURL = profilePhotoURL;
    this.storiesList = storiesList;
  }

  setAllwatchedValue() {
    //The value "isAllStoriesWathed" is set to true
    //if all of the user's stories have been watched. The part I
    //took in the comment line below was useful to put all the
    //watched story groups at the end, but I kept a separate list
    // for the story groups and a separate list for the visible users,
    // so I left it in the comment line.
    isAllStoriesWathed.value = true;
    // ShowedUsersController showedUsersController = Get.find();
    // ActiveStoriesController activeStoriesController = Get.find();
    // int shift = showedUsersController.activeUsers.length - 1;
    // if (showedUsersController.activeUsers.contains(this)) {
    //   int index = showedUsersController.activeUsers.indexOf(this);
    //   UserStoriesController userStoriesController =
    //       activeStoriesController.activeStories[index];
    //   showedUsersController.activeUsers.removeAt(index);
    //   showedUsersController.activeUsers.add(this);
    //   activeStoriesController.activeStories.removeAt(index);
    //   activeStoriesController.activeStories.add(userStoriesController);
    // }
    // showedUsersController.refresh();
  }
}
