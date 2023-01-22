import 'package:animations/animations.dart';
import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/FadeInAnimations.dart';
import 'package:atroverse/Models/FriendProfileModel.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'CommentScreen.dart';

class FriendProfileScreen extends StatelessWidget {
  final controller = Get.find<ProfileController>();

  FriendProfileScreen({Key? key}) : super(key: key) {
    controller.openBio.value = false;
    controller.height.value = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _mainScreen(),
    );
  }

  _mainScreen() {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Obx(
            () {
          return ListView(
            // physics: const BouncingScrollPhysics(),
            controller: controller.scrollController,
            children: [
              SizedBox(
                height: Get.height * .65,
                width: Get.width,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildTopImage(),
                    ExpandTapWidget(
                      tapPadding: const EdgeInsets.all(50),
                      onTap: () {
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: Get.width * .06,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildImageProfile(),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildName(),
                        _buildNumber(),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: 200.milliseconds,
                curve: Curves.easeIn,
                padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                color: Colors.white,
                height: controller.height.value,
                width: Get.width,
                child: Text(
                  controller.friendProfile.bio!,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              _buildTabs(),
            ],
          );
        },
      ),
    );
  }

  _buildTopImage() {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/New Project.png',
        fit: BoxFit.cover,
      ),
      opacity: 0.6,
      color: Colors.grey.shade400,
      offset: const Offset(5, 5),
      sigma: 7,
    );
  }

  _buildImageProfile() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          _showBigImage(
            controller.friendProfile.image.toString(),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            controller.friendProfile.image.toString(),
          ),
          child: (controller.friendProfile.image == null)
              ? const Center(
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: Colors.black54,
            ),
          )
              : Container(),
          radius: Get.width * .18,
        ),
      ),
    );
  }

  _buildName() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            controller.friendProfile.userName.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            controller.friendProfile.firstName.toString() +
                " " +
                controller.friendProfile.lastName.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  _buildNumber() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          height: Get.height * .08,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Atro",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    controller.friendProfile.atroCount!.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Friends",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Image.asset(
                      "assets/images/triangle-0.png",
                      width: Get.width * .08,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Will",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    controller.friendProfile.will_count.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _buildTabs() {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExpandTapWidget(
                    onTap: () {
                      controller.selectTab.value = true;
                      controller.update();
                    },
                    tapPadding: const EdgeInsets.all(80),
                    child: (controller.selectTab.isTrue)
                        ? Image.asset(
                      "assets/images/a (1).png",
                      width: Get.width * .05,
                      color: Colors.blue,
                    )
                        : Image.asset(
                      "assets/images/a1.png",
                      width: Get.width * .05,
                    )),
                ExpandTapWidget(
                  tapPadding: const EdgeInsets.all(80),
                  onTap: () {
                    controller.openBio.value = !controller.openBio.value;
                    if (controller.openBio.isTrue) {
                      controller.height.value = Get.height * .2;
                      controller.scrollController.animateTo(300,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    } else {
                      controller.height.value = 0.0;
                      controller.scrollController.animateTo(-300,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    }
                    controller.update();
                  },
                  child: controller.openBio.isTrue
                      ? const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black,
                  )
                      : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                ExpandTapWidget(
                    tapPadding: const EdgeInsets.all(50),
                    onTap: () {
                      controller.selectTab.value = false;
                      controller.update();
                    },
                    child: (controller.selectTab.isFalse)
                        ? Image.asset(
                      "assets/images/w (1).png",
                      width: Get.width * .05,
                      color: Colors.blue,
                    )
                        : Image.asset(
                      "assets/images/w2.png",
                      width: Get.width * .05,
                    )),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            _buildGridView(),
          ],
        );
      },
    );
  }

  _buildGridView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: (controller.selectTab.isTrue)
              ? controller.friendProfile.atroes?.length
              : controller.friendProfile.wills?.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: itemBuilder),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = (controller.selectTab.isTrue)
        ? controller.friendProfile.atroes![index]
        : controller.friendProfile.wills![index];
    return FadeAnimation(
      0.3,
      OpenContainer(
        closedColor: Colors.white,
        middleColor: Colors.white,
        openColor: Colors.white,
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        openBuilder: (_, w) {
          return CommentScreen(
            atroModel: item is Atroe
                ? item
                : item is WillsModel
                ? item
                : item,
            archiveId: item is Atroe ?item.saved_id:item is WillsModel?item.saved_id:0,
            atroController: Get.find<AtroController>(),
          );
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 5,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item is WillsModel) ...{
                    Image.network(
                      item.file.toString(),
                      fit: BoxFit.cover,
                    ),
                  } else if (item is Atroe) ...{
                    Image.network(
                      item.image.toString(),
                      fit: BoxFit.cover,
                    ),
                  }
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _showBigImage(image) {
    return Get.dialog(
      GestureDetector(
        onVerticalDragDown: (_) {
          Get.close(0);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(image),
          ],
        ),
      ),
    );
  }
}
