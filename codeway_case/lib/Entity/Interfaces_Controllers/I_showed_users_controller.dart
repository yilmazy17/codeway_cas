import 'package:codeway_case/Business/Classes/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IShowedUsersController extends GetxController {
  var activeUsers = [].obs;
  GlobalKey<ScaffoldState>? scaffoldKey;
}
