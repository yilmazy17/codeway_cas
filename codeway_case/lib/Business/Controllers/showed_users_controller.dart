import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Entity/Constant_Classes/UsersAndVideoURLs.dart';
import 'package:codeway_case/Entity/Interfaces_Controllers/I_showed_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowedUsersController extends IShowedUsersController {
  // To manage user story list on the main page it is different from active story controller's list
  Future getShowedUsers(BuildContext context) async {
    // This part should be data access line it can be http rest or ProtoBuf etc..
    try {
      for (var element in UsersAndVideoURLs.URL_List) {
        if (element['storyURLList'].length > 0) {
          var user = User(
              username: element['username'],
              profilePhotoURL: element['photoURL'],
              storiesList: element['storyURLList']);
          await precacheImage(NetworkImage(user.profilePhotoURL!),
              context); // to load user profile photo
          activeUsers.add(user);
        }
      }
    } catch (e) {
      print(e.toString());
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }
}
