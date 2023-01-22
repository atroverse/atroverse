import 'package:animations/animations.dart';
import 'package:atroverse/Controllers/ProfileController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../Controllers/AtroController.dart';
import '../Models/ArchiveWillModel.dart';
import '../Models/AtroModel.dart' as atro;
import '../Models/WillModel.dart' as will;
import '../Utils/CostumAppBarWidget.dart';
import 'CommentScreen.dart';

class ArchiveScreen extends StatelessWidget {
  final controller = Get.find<ProfileController>();

  ArchiveScreen({Key? key}) : super(key: key) {
    controller.getArchiveList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          child: Obx(() {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomAppBar(
                    height: Get.height * .1,
                    title: "Archive",
                    isBack: true,
                    isOnTap: false,
                  ),
                  pinned: false,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: Get.height * .06,
                        width: Get.width,
                        child: TabBar(
                          controller: controller.tabController,
                          tabs: const [
                            Tab(
                              text: "Atroverse",
                            ),
                            Tab(text: "Will"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            _buildAtro(),
                            _buildWill(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  _buildAtro() {
    return GridView.builder(
      itemCount: controller.willArchiveList1.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        final item = controller.willArchiveList1[index];
        return OpenContainer(
          closedColor: Colors.white,
          middleColor: Colors.white,
          openColor: Colors.white,
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 0,
          openBuilder: (_, w) {
            return CommentScreen(
              checked: item.checked.value,
              archiveId: item.id,
              atroModel: item.contentObject?.file == null
                  ? atro.AtroModel(
                  saved_id: item.contentObject?.saved_id,
                  answer: item.contentObject?.answer,
                  author: item.contentObject?.author,
                  id: item.contentObject?.id,
                  image: item.contentObject?.image,
                  profileInfo: atro.ProfileInfo(
                      image: item.contentObject?.profileInfo?.image,
                      id: item.contentObject?.profileInfo?.id,
                      firstName: item.contentObject?.profileInfo?.firstName,
                      lastName: item.contentObject?.profileInfo?.lastName,
                      user: item.contentObject?.profileInfo?.user,
                      userName: item.contentObject?.profileInfo?.userName),
                  question: item.contentObject?.question,
                  sound: item.contentObject?.sound,
                  viewer: [])
                  : will.WillModel(
                sound: item.contentObject?.sound,
                id: item.contentObject?.id,
                viewer: [
                  will.ViewerBys(
                    id: item.contentObject?.viewer?[index].id,
                    lastName: item.contentObject?.viewer?[index].lastName,
                    firstName:
                    item.contentObject?.viewer?[index].firstName,
                    image: item.contentObject?.viewer?[index].image,
                    user: item.contentObject?.viewer?[index].user,
                    userName: item.contentObject?.viewer?[index].userName,
                    gender: item.contentObject?.viewer?[index].gender,
                    email: item.contentObject?.viewer?[index].email,
                    birthdate:
                    item.contentObject?.viewer?[index].birthdate,
                    bio: item.contentObject?.viewer?[index].bio,
                  )
                ],
                author: item.contentObject?.author,
                caption: item.contentObject?.caption,
                status: item.contentObject?.status,
                profileInfo: will.ProfileInfo(
                    image: item.contentObject?.profileInfo?.image,
                    id: item.contentObject?.profileInfo?.id,
                    bio: item.contentObject?.profileInfo?.bio,
                    email: item.contentObject?.profileInfo?.email,
                    firstName: item.contentObject?.profileInfo?.firstName,
                    gender: item.contentObject?.profileInfo?.gender,
                    lastName: item.contentObject?.profileInfo?.lastName,
                    user: item.contentObject?.profileInfo?.user,
                    userName: item.contentObject?.profileInfo?.userName),
                file: item.contentObject?.file,
              ),
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
                    Image.network(
                      item.contentObject!.image.toString(),
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildWill() {
    return GridView.builder(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: controller.willArchiveList2.length,
      itemBuilder: (context, index) {
        final item = controller.willArchiveList2[index];
        return OpenContainer(
          closedColor: Colors.white,
          middleColor: Colors.white,
          openColor: Colors.white,
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 0,
          openBuilder: (_, w) {
            return CommentScreen(
              checked: item.checked.value,
              archiveId: item.id,
              atroModel: item.contentObject?.file == null
                  ? atro.AtroModel(
                saved_id: item.contentObject?.saved_id,
                answer: item.contentObject?.answer,
                author: item.contentObject?.author,
                id: item.contentObject?.id,
                image: item.contentObject?.image,
                profileInfo: atro.ProfileInfo(
                    image: item.contentObject?.profileInfo?.image,
                    id: item.contentObject?.profileInfo?.id,
                    firstName: item.contentObject?.profileInfo?.firstName,
                    lastName: item.contentObject?.profileInfo?.lastName,
                    user: item.contentObject?.profileInfo?.user,
                    userName: item.contentObject?.profileInfo?.userName),
                question: item.contentObject?.question,
                sound: item.contentObject?.sound,
                viewer: [
                  atro.ViewBy(
                    id: item.contentObject?.viewer?[index].id,
                    lastName: item.contentObject?.viewer?[index].lastName,
                    firstName:
                    item.contentObject?.viewer?[index].firstName,
                    image: item.contentObject?.viewer?[index].image,
                    user: item.contentObject?.viewer?[index].user,
                    userName: item.contentObject?.viewer?[index].userName,
                  )
                ],
              )
                  : will.WillModel(
                  sound: item.contentObject?.sound,
                  id: item.contentObject?.id,
                  viewer: [
                    will.ViewerBys(
                      id: item.contentObject?.viewer?[index].id,
                      lastName: item.contentObject?.viewer?[index].lastName,
                      firstName:
                      item.contentObject?.viewer?[index].firstName,
                      image: item.contentObject?.viewer?[index].image,
                      user: item.contentObject?.viewer?[index].user,
                      userName: item.contentObject?.viewer?[index].userName,
                      bio: item.contentObject?.viewer?[index].bio,
                    )
                  ],
                  author: item.contentObject?.author,
                  caption: item.contentObject?.caption,
                  status: item.contentObject?.status,
                  profileInfo: will.ProfileInfo(
                      image: item.contentObject?.profileInfo?.image,
                      id: item.contentObject?.profileInfo?.id,
                      firstName: item.contentObject?.profileInfo?.firstName,
                      lastName: item.contentObject?.profileInfo?.lastName,
                      user: item.contentObject?.profileInfo?.user,
                      userName: item.contentObject?.profileInfo?.userName),
                  file: item.contentObject?.file),
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
                    Image.network(
                      item.contentObject!.file.toString(),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
