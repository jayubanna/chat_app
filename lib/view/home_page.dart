import 'package:chat_app/helper/login_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import 'components/chat_page.dart';
import 'components/person_page.dart';

class HomePage extends StatefulWidget {
  HomeController controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = const [
    Icon(
      Icons.home,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      Icons.person,
      size: 30,
      color: Colors.white,
    ),
  ];
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () {
          return CurvedNavigationBar(
            backgroundColor: widget.controller.isDark.value
                ? Color(0xff121116)
                : Color(0xffFEF6FE),
            color: widget.controller.isDark.value ? Colors.black : Colors.black26,
            items: items,
            index: bottomNavController.index.value,
            onTap: (value) {
              bottomNavController.changeIndex(value);
            },
          );
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await LoginHelper.loginHelper.signOut();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login_page', (route) => false);
              },
              icon: Icon(
                Icons.logout,
              )),
          Obx(
            () => IconButton(
              icon: Icon(
                  widget.controller.isDark.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: widget.controller.isDark.value
                      ? Colors.white
                      : Colors.black),
              onPressed: () {
                if (Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.light);
                  widget.controller.isDark.value = false;
                } else {
                  Get.changeThemeMode(ThemeMode.dark);
                  widget.controller.isDark.value = true;
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Obx(
          () => bottomNavController.index.value == 0
              ? ChatPage()
              : bottomNavController.index.value == 1
                  ? PersonPage()
                  : ChatPage(),
        ),
      ),
    );
  }
}
