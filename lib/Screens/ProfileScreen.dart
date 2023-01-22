import 'package:animations/animations.dart';
import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/FadeInAnimations.dart';
import 'package:atroverse/Helpers/PrefHelpers.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:atroverse/Models/AtroModel.dart';
import 'package:atroverse/Models/WillModel.dart';
import 'package:atroverse/Screens/FriendProfileScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../Helpers/ViewHelpers.dart';
import '../Utils/ProfileAvatar.dart';
import 'CommentScreen.dart';

class ProfileScreen extends StatelessWidget {
  final controller = Get.find<ProfileController>();

  ProfileScreen({Key? key}) : super(key: key) {
    controller.openBio.value = false;
    controller.height.value = 0.0;
    controller.getUserWill();
    controller.getProfile();
    controller.getUserAtroList();
    controller.getFriendList(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZoomDrawer(
        controller: controller.zoomDrawerController,
        menuScreen: _menuScreen(),
        mainScreen: _mainScreen(),
        borderRadius: 24.0,
        isRtl: true,
        // showShadow: true,
        angle: 0.0,
        style: DrawerStyle.defaultStyle,
        androidCloseOnBackTap: true,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    );
  }

  _mainScreen() {
    return GestureDetector(
      onHorizontalDragStart: (a) {
        controller.zoomDrawerController.open!();
      },
      child: Container(
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
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/New Project.png"),
                        ),
                      ),
                      height: Get.height * .65,
                      width: Get.width,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ExpandTapWidget(
                        onTap: () {
                          controller.zoomDrawerController.open!();
                        },
                        tapPadding: const EdgeInsets.all(50),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<ProfileController>(builder: (controller) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: Get.height * .4,
                            ),
                            _buildImageProfile(),
                            _buildName(),
                            _buildNumber(),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                AnimatedContainer(
                  duration: 200.milliseconds,
                  curve: Curves.easeIn,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  color: Colors.white,
                  height: controller.height.value,
                  width: Get.width,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        controller.profile.bio!,
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildTabs(),
              ],
            );
          },
        ),
      ),
    );
  }

  _menuScreen() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(height: Get.height * .02),
          const Center(
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          const Divider(),
          SizedBox(height: Get.height * .1),
          _buildMenuRow(
              onTap: () {
                controller.getProfile();
                Get.toNamed("/editProfile");
              },
              title: "Edit Profile",
              icon: Icons.edit),
          _buildMenuRow(
              onTap: () {
                _buildWalletModal();
              },
              title: "Atroverse",
              icon: Icons.wallet),
          _buildMenuRow(
              onTap: () {
                Get.toNamed("archive");
              },
              title: "Archives",
              icon: Icons.archive_outlined),
          _buildMenuRow(
              onTap: () {
                Get.toNamed("saved");
              },
              title: "Saved",
              icon: Icons.bookmark_border_outlined),
          _buildMenuRow(
              fontWeight: FontWeight.bold,
              onTap: () {
                controller.generateCode();
              },
              title: "Add friend",
              icon: Icons.person_add_alt),
          _buildMenuRow(
              onTap: () {
                controller.onShare("Atroverse Application Invite Link: ",
                    "${controller.profile.invite_code}");
              },
              title: "Share Application",
              icon: Icons.share),
          _buildMenuRow(
              onTap: () {
                _showSettingsModal();
              },
              title: "Settings",
              icon: Icons.settings),
          _buildMenuRow(
              onTap: () {
                _showLogOut();
              },
              title: "Logout",
              icon: Icons.logout_outlined),
        ],
      ),
    );
  }

  _buildTopImage() {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/New Project.png',
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
          if (controller.profile.image == null) {
            _showModal();
          } else {
            _showBigImage(
              controller.profile.image.toString(),
            );
          }
        },
        child: (controller.profile.image == null)
            ? CircleAvatar(
          child: const Center(
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: Colors.black54,
            ),
          ),
          radius: Get.width * .2,
        )
            : ProfileAvatar(path: controller.profile.image.toString()),
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
            controller.profile.userName.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            controller.profile.firstName.toString() +
                " " +
                controller.profile.lastName.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  _buildNumber() {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(
            height: Get.height * .08,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ExpandTapWidget(
                  tapPadding: EdgeInsets.all(30),
                  onTap: () {
                    controller.selectTab.value = true;
                    controller.update();
                  },
                  child: Column(
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
                        controller.profile.atro_count.toString(),
                        style:
                        const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ViewHelper.showLoading();
                    controller.getFriendList(() {
                      // ViewHelper.showLoading();
                      _showFriendModal();
                    });
                  },
                  child: Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Friends",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        (controller.friendList.length == 0)
                            ? Image.asset(
                          "assets/images/triangle-0.png",
                          width: Get.width * .08,
                        )
                            : (controller.friendList.length == 1)
                            ? Image.asset(
                          "assets/images/triangle-1.png",
                          width: Get.width * .08,
                        )
                            : (controller.friendList.length == 2)
                            ? Image.asset(
                          "assets/images/triangle-2.png",
                          width: Get.width * .08,
                        )
                            : (controller.friendList.length == 3)
                            ? Image.asset(
                          "assets/images/triangle-3.png",
                          width: Get.width * .08,
                        )
                            : Image.asset(
                          "assets/images/triangle-3.png",
                          width: Get.width * .08,
                        )
                      ],
                    );
                  }),
                ),
                ExpandTapWidget(
                  tapPadding: const EdgeInsets.all(30),
                  onTap: () {
                    controller.selectTab.value = false;
                    controller.update();
                  },
                  child: Column(
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
                        controller.profile.will_count.toString(),
                        style:
                        const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }

  _buildTabs() {
    return GetBuilder<ProfileController>(builder: (controller) {
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
                tapPadding: const EdgeInsets.all(100),
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
    });
  }

  _buildGridView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (controller.selectTab.isTrue)
            ? controller.userAtroList.length
            : controller.userWillList.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = (controller.selectTab.isTrue)
        ? controller.userAtroList[index]
        : controller.userWillList[index];
    return FadeAnimation(
      0.3,
      OpenContainer(
        closedColor: Colors.white,
        middleColor: Colors.white,
        openColor: Colors.white,
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        openBuilder: (_, w) {
          // return Container();
          return CommentScreen(
            atroModel: item is AtroModel ? item : item,
            archiveId: item is AtroModel ?item.saved_id:item is WillModel?item.saved_id:0,
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
                  if (item is AtroModel) ...{
                    CachedNetworkImage(
                      imageUrl: item.image.toString(),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 1),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  } else if (item is WillModel) ...{
                    CachedNetworkImage(
                      imageUrl: item.file.toString(),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 1),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
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

  _buildMenuRow(
      {String? title,
        IconData? icon,
        Callback? onTap,
        FontWeight fontWeight = FontWeight.normal}) {
    return ExpandTapWidget(
      tapPadding: const EdgeInsets.all(50),
      onTap: onTap!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .025),
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: Get.height * .045,
        width: Get.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  children: [
                    Text(
                      title!,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: fontWeight),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      icon,
                      color: Colors.black,
                      size: Get.width * .05,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  _buildWalletModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .4,
          width: Get.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                    "0/${controller.profile.poten_number}",
                    style: const TextStyle(color: Colors.black, fontSize: 50),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * .22, right: Get.width * .2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      "Atro",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      "Poten",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _showFriendModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Column(
          children: [
            SizedBox(height: Get.width * .05),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * .05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExpandTapWidget(
                    onTap: () {
                      controller.getFriendList(() {});
                      Get.close(0);
                    },
                    tapPadding: const EdgeInsets.all(50),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: controller.friendList
                  .map(
                    (element) => ListTile(
                  onLongPress: () {
                    _showPublishDialog(element.id);
                  },
                  onTap: () {
                    controller.getFriendProfile(
                          () {
                        Get.to(FriendProfileScreen());
                      },
                      element.id.toString(),
                    );
                  },
                  subtitle: Text(
                    element.firstName! + " " + element.lastName!,
                    style:
                    const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  title: Text(
                    element.userName.toString(),
                    style:
                    const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  trailing: SizedBox(
                    height: Get.height * .13,
                    width: Get.width * .42,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (element.friendShipDeleteId == null) {
                                  Get.dialog(
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: Get.height * .15,
                                          width: Get.width * .8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              const Text(
                                                "Do you want delete friend?",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Get.close(0);
                                                    },
                                                    color: Colors.white,
                                                    child: const Center(
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.deleteFriend(
                                                          element.user
                                                              .toString());
                                                      // Get.back();
                                                    },
                                                    color: Colors.white,
                                                    elevation: 0,
                                                    child: const Center(
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  controller.cancelFriend(element
                                      .friendShipDeleteId?[0]
                                      .toString());
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: Get.height * .05,
                                width: Get.width * .15,
                                child: Center(
                                  child: Text(
                                    (element.friendShipDeleteId != null)
                                        ? "Cancel"
                                        : "Remove",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.dialog(
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: Get.height * .15,
                                        width: Get.width * .8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              "Do you want Block friend?",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Get.close(0);
                                                  },
                                                  color: Colors.white,
                                                  child: const Center(
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.block(element
                                                        .user
                                                        .toString());
                                                    Get.back();
                                                  },
                                                  color: Colors.white,
                                                  child: const Center(
                                                    child: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: Get.height * .05,
                                width: Get.width * .15,
                                child: const Center(
                                  child: Text(
                                    "Block",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        (element.friendShipDeleteId != null)
                            ? Text(
                          element.delete_friend_time.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      element.image.toString(),
                    ),
                    radius: Get.width * .06,
                  ),
                ),
              )
                  .toList(),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                showAddFriendModal();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Add Friend  ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Icon(
                    Icons.person_add_alt,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * .08),
          ],
        );
      },
    );
  }

  _showPublishDialog(item) {
    return Get.dialog(
      Container(
        margin: EdgeInsets.symmetric(
          horizontal: Get.width * .05,
          vertical: Get.height * .4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Are you request for publish will posts your friend?",
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white)),
                  onPressed: () {
                    Get.close(0);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white)),
                  onPressed: () {
                    Get.back();
                    controller.createRequest(item.toString());
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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

  _showLogOut() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: Get.height * .2,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Aru you sure you want to logout?",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller.logOut();
                    },
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.close(0);
                    },
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _showQrCode() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .4,
          width: Get.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpandTapWidget(
                onTap: () {
                  controller.shareQrCode();
                },
                tapPadding: const EdgeInsets.all(50),
                child: const Text(
                  "Share QrCode",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              Screenshot(
                controller: controller.screenshotController,
                child: QrImage(
                  size: Get.width * .6,
                  data: controller.profile.friendLink.toString(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return SizedBox(
          height: Get.height * .2,
          width: Get.width,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: AppBar(
                  leading: Container(),
                  title: const Text(
                    "Choose Image",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  elevation: 0,
                  centerTitle: true,
                ),
              ),
              SizedBox(
                height: Get.height * .025,
              ),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.close(0);
                            controller.pickImageWithGallery();
                          },
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.close(0);
                            controller.pickImageWithCamera();
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showSettingsModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .45,
          width: Get.width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Column(
                children: [
                  Obx(
                        () {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Mute Notification",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Switch(
                              activeColor: Colors.blue,
                              value: controller.isOn.value,
                              onChanged: (value) async {
                                if (await PrefHelpers.getMute() == "true") {
                                  controller.isOn.value = false;
                                  await PrefHelpers.setMute(
                                      controller.isOn.value.toString());
                                  await FirebaseMessaging.instance
                                      .deleteToken();
                                } else {
                                  controller.isOn.value = true;
                                  await PrefHelpers.setMute(
                                      controller.isOn.value.toString());
                                  controller.getRegistrationId();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 8),
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/ticketing');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Ticketing",
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.message_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 8),
                    child: TextButton(
                      onPressed: () {
                        _showQrCode();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "My QRCode",
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.qr_code,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 8),
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/blockList');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Block List",
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.block,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 8),
                    child: TextButton(
                      onPressed: () {
                        controller.deleteAccount(
                              () {
                            _showDeleteAccModal();
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _showDeleteAccModal() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .3,
          width: Get.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper.input(
                title: "Verify Code",
                onChanged: (value) {},
                controller: controller.deleteCode,
              ),
              const SizedBox(height: 20),
              WidgetHelper.softButton(
                  onTap: () {
                    controller.deleteAccountVerify();
                  },
                  title: "Send"),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  showAddFriendModal() {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .35,
          width: Get.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper.input(
                title: "Code",
                onChanged: (value) {

                },
                controller: controller.friendCode,
              ),
              const SizedBox(height: 50),
              WidgetHelper.softButton(
                  onTap: () {
                    controller.addFriend();
                  },
                  title: "Add"),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
