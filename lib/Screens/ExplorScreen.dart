import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Controllers/FavoriteController.dart';
import 'package:atroverse/Models/AtroModel.dart' as atro;
import 'package:atroverse/Screens/CommentScreen.dart';
import 'package:atroverse/Screens/FavoriteScreen.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Controllers/ExplorController.dart';
import '../Utils/CostumAppBarWidget.dart';

class ExplorScreen extends StatelessWidget {
  final controller = Get.find<ExplorController>();

  ExplorScreen({Key? key}) : super(key: key) {
    controller.getExploreListOnRef();
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
                    height: Get.height * .05,
                    title: "",
                    isBack: false,
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
                          tabs: [
                            const Tab(
                              text: "Explore",
                            ),
                            Tab(
                              child: Badge(
                                  showBadge: Get.find<FavoriteController>()
                                              .notifCount
                                              .value ==
                                          0
                                      ? false
                                      : true,
                                  badgeContent: Text(
                                      Get.find<FavoriteController>()
                                          .notifCount
                                          .value
                                          .toString()),
                                  child: const Text(
                                    "Notification   ",
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            _buildExplor(),
                            FavoriteScreen(),
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

  _buildExplor() {
    // if (controller.listOfExplore.value.results!.isEmpty) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Center(
    //           child: Lottie.asset("assets/anims/loading.json",
    //               width: Get.width * .3)),
    //     ],
    //   );
    // }
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              controller: controller.refreshController,
              onLoading: () {
                if (controller.isNull.value != "null") {
                  controller.getExploreListLoadMore();
                }
                Future.delayed(2.seconds).then((value) {
                  controller.refreshController.loadComplete();
                });
              },
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.getExploreListOnRef();
                Future.delayed(2.seconds).then((value) {
                  controller.refreshController.refreshCompleted();
                });
              },
              header: CustomHeader(
                builder: (BuildContext context, mode) {
                  return const SizedBox(
                    height: 55.0,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
              footer: CustomFooter(
                builder: (BuildContext context, mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Container();
                  } else if (mode == LoadStatus.loading) {
                    body = const CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text("release to load more");
                  } else {
                    body = const Text("No more Data");
                  }
                  return SizedBox(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: GridView.builder(
                // reverse: true,
                padding: EdgeInsets.only(bottom: (Get.height * .2) + 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: controller.listOfExplore.value.results?.length,
                itemBuilder: itemBuilder,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = controller.listOfExplore.value.results?[index];
    return GestureDetector(
      onTap: () {
        Get.to(CommentScreen(
          atroController: Get.find<AtroController>(),
          atroModel: atro.AtroModel(
            image: item?.image,
            id: item?.id,
            sound: item?.sound,
            saved_id: item?.saved_id,
            answer: item?.answer,
            question: item?.question,
            profileInfo: atro.ProfileInfo(
              id: item?.profileInfo?.id,
              image: item?.profileInfo?.image,
              lastName: item?.profileInfo?.lastName,
              firstName: item?.profileInfo?.firstName,
              user: item?.profileInfo?.user,
              userName: item?.profileInfo?.userName,
            ),
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        height: Get.height * .2,
        width: Get.width * .2,
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              height: Get.height * .2,
              width: Get.width * .4,
              margin: const EdgeInsets.all(20),
              child: CachedNetworkImage(
                imageUrl: item!.image.toString(),
                fit: BoxFit.contain,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                fadeInDuration: const Duration(milliseconds: 1),
                filterQuality: FilterQuality.low,
                repeat: ImageRepeat.noRepeat,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * .055,
                width: Get.width * .3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    item.question.toString(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
