import 'package:atroverse/Controllers/FavoriteController.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/MainController.dart';
import 'CreateScreen.dart';
import 'ExplorScreen.dart';
import 'FavoriteScreen.dart';
import 'HomeScreen.dart';
import 'ProfileScreen.dart';
import 'ToDoApp/TodoScreen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: GetBuilder<MainController>(
        builder: (logic) {
          return BottomNavigationBar(
            currentIndex: logic.activePage.value,
            onTap: (page) {
              logic.activePage.value = page;
              logic.pageController.jumpToPage(page);
              logic.update();
              if (page == 0) {
                controller.scrollController.animateTo(0.0,
                    duration: 500.milliseconds, curve: Curves.easeIn);
              }
            },
            fixedColor: Colors.white,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.blue,
                  size: Get.width * .08,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                  size: Get.width * .08,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  activeIcon: Badge(
                    showBadge:
                        Get.find<FavoriteController>().notifCount.value != 0
                            ? true
                            : false,
                    child: Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: Get.width * .08,
                    ),
                  ),
                  icon: Badge(
                    showBadge:
                        Get.find<FavoriteController>().notifCount.value != 0
                            ? true
                            : false,
                    // badgeContent: Get.find<FavoriteController>().notifCount.value != 0?const Text("1"):const Text("2"),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: Get.width * .08,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  activeIcon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.blue,
                    size: Get.width * .1,
                  ),
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.black,
                    size: Get.width * .1,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  activeIcon: Image.asset(
                    "assets/images/edit (1).png",
                    color: Colors.blue,
                    width: Get.width * .07,
                  ),
                  icon: Image.asset(
                    "assets/images/pen.png",
                    width: Get.width * .07,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  activeIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: Get.width * .08,
                  ),
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                    size: Get.width * .08,
                  ),
                  label: ""),
            ],
          );
        },
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<MainController>(builder: (ctrl) {
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: ctrl.pageController,
                  onPageChanged: (page) {
                    ctrl.activePage.value = page;
                    ctrl.update();
                  },
                  children: [
                    HomeScreen(),
                    ExplorScreen(),
                    CreateScreen(isEdit: false),
                    const TodoScreen(),
                    ProfileScreen(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
