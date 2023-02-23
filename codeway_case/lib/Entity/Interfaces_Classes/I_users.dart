import 'package:get/get.dart';

abstract class IUser extends GetxController {
  String? username;
  String? profilePhotoURL;
  List<dynamic> storiesList = [];
  var isAllStoriesWathed = false.obs;
}
