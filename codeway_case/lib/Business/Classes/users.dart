import 'package:codeway_case/Entity/Interfaces_Classes/I_users.dart';

class User extends IUser {
  User(
      {required String profilePhotoURL,
      required List<dynamic> stroiesList,
      required String username}) {
    this.username = username;
    this.profilePhotoURL = profilePhotoURL;
    this.stroiesList = stroiesList;
  }
}
