// ignore_for_file: prefer_const_constructors

import 'package:codeway_case/Business/Classes/users.dart';
import 'package:codeway_case/Business/Controllers/showed_users_controller.dart';
import 'package:codeway_case/Views/main_page/materials.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MainPageState extends State<MainPage> {
  ShowedUsersController _showedUsersController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showedUsersController.scaffoldKey = _scaffoldKey;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: Container(),
          actions: [Container()],
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Image.asset(
                'assets/codewaylogo.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 80,
              child: ListView.builder(
                itemCount: _showedUsersController.activeUsers.length,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  User currentItem = _showedUsersController.activeUsers[index];
                  return StoryUserAnimatedContainer(
                    user: currentItem,
                    activeIndex: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
