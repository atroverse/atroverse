import 'dart:async';

import 'package:animations/animations.dart';
import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Models/AtroModel.dart';
import 'package:atroverse/Screens/CommentScreen.dart';
import 'package:atroverse/Screens/FriendProfileScreen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as ref;
import 'package:readmore/readmore.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../Controllers/AtroController.dart';
import '../Controllers/CreateController.dart';
import '../Controllers/MainController.dart';
import '../Utils/StreamAudioPostWidget.dart';
import 'CreateScreen.dart';

class HomeScreen extends StatelessWidget {
  final atroController = Get.put(AtroController());

  HomeScreen({Key? key}) : super(key: key) {
    atroController.getAtroListOnRef();
    for (var i in atroController.atroList) {
      i.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                  child: ref.SmartRefresher(
                    controller: atroController.refreshController,
                    onLoading: () {
                      if (atroController.isNull.value != "null") {
                        atroController.getAtroListOnMore();
                      }
                      Future.delayed(2.seconds).then((value) {
                        atroController.refreshController.loadComplete();
                      });
                    },
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      atroController.getAtroListOnRef();
                      Future.delayed(2.seconds).then((value) {
                        atroController.refreshController.refreshCompleted();
                      });
                    },
                    header: ref.CustomHeader(
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
                    footer: ref.CustomFooter(
                      builder: (BuildContext context, mode) {
                        Widget body;
                        if (mode == ref.LoadStatus.idle) {
                          body = Container();
                        } else if (mode == ref.LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == ref.LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == ref.LoadStatus.canLoading) {
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
                    child: ListView.builder(
                      controller: Get.find<MainController>().scrollController,
                      itemBuilder: itemBuilder,
                      itemCount: atroController.atroList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = atroController.atroList[index];
    return _buildContainer(item);
  }

  _buildContainer(AtroModel item) {
    return GetBuilder<AtroController>(
      builder: (atroController) {
        return VisibilityDetector(
          key: Key('visible-video--key-${item.id}-1'),
          onVisibilityChanged: (VisibilityInfo info) {
            var visiblePercentage = info.visibleFraction * 100;
            if (visiblePercentage < 1) {
              for (var i in atroController.atroList) {
                i.pause();
              }
            }
            atroController.update();
          },
          child: Container(
            width: Get.width,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * .06,
                  width: Get.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ExpandTapWidget(
                            tapPadding: const EdgeInsets.all(50),
                            onTap: () {
                              Get.find<ProfileController>().getFriendProfile(
                                  () {
                                Get.to(FriendProfileScreen());
                              }, item.profileInfo?.id.toString());
                            },
                            child: Row(
                              children: [
                                (item.profileInfo!.image != null)
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              item.profileInfo!.image.toString(),
                                          height: 40,
                                          width: 40,
                                          fadeInDuration:
                                              const Duration(milliseconds: 1),
                                          fit: BoxFit.cover,
                                        ),
                                    )
                                    : const CircleAvatar(
                                        child: Icon(
                                          Icons.person,
                                        ),
                                      ),
                                SizedBox(
                                  width: Get.width * .03,
                                ),
                                Text(
                                  item.profileInfo!.userName.toString(),
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                item.created!,
                                style: const TextStyle(fontSize: 10),
                              ),
                              ExpandTapWidget(
                                tapPadding: const EdgeInsets.all(50),
                                onTap: () {
                                  _showMoreModal(item);
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: item.image.toString(),
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                (item.sound == null)
                    ? const SizedBox()
                    : SizedBox(
                        width: Get.width,
                        height: Get.height * .08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<ButtonState>(
                              valueListenable: item.buttonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return Container(
                                        margin: const EdgeInsets.all(8.0),
                                        width: 40.0,
                                        height: Get.height * .1,
                                        child: Lottie.asset(
                                            "assets/anims/loading.json"));
                                  case ButtonState.paused:
                                    return IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      iconSize: 32.0,
                                      color: Colors.black,
                                      onPressed: () {
                                        for (var i in atroController.atroList) {
                                          i.pause();
                                        }
                                        item.play();
                                      },
                                    );
                                  case ButtonState.playing:
                                    return IconButton(
                                      icon: const Icon(Icons.pause),
                                      iconSize: 32.0,
                                      color: Colors.black,
                                      onPressed: () {
                                        for (var i in atroController.atroList) {
                                          i.pause();
                                        }
                                        item.pause();
                                      },
                                    );
                                }
                              },
                            ),
                            ValueListenableBuilder<ProgressBarState>(
                              valueListenable: item.progressNotifier,
                              builder: (_, value, __) {
                                return SizedBox(
                                  height: Get.height * .08,
                                  width: Get.width * .75,
                                  child: ProgressBar(
                                    thumbRadius: 7,
                                    barHeight: 3,
                                    baseBarColor: Colors.grey.withOpacity(0.7),
                                    progressBarColor: Colors.blue,
                                    bufferedBarColor: Colors.blue.shade100,
                                    thumbColor: Colors.black,
                                    timeLabelLocation: TimeLabelLocation.sides,
                                    progress: value.current,
                                    buffered: value.buffered,
                                    total: value.total,
                                    onSeek: item.seek,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          OpenContainer(
                            closedColor: Colors.white,
                            middleColor: Colors.white,
                            openColor: Colors.white,
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedElevation: 0,
                            openBuilder: (_, w) {
                              // return Container();
                              return CommentScreen(
                                archiveId: item.saved_id,
                                atroModel: item,
                                atroController: atroController,
                              );
                            },
                            closedBuilder:
                                (BuildContext context, void Function() action) {
                              return Row(
                                children: [
                                  Text(
                                    item.comment_count.toString() + " ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.asset(
                                    "assets/images/comment (1).png",
                                    color: Colors.black,
                                    width: Get.width * .07,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ExpandTapWidget(
                            tapPadding: const EdgeInsets.all(2),
                            onTap: () {
                              _showViewer(item.viewer!);
                            },
                            child: SizedBox(
                              height: Get.height * .03,
                              width: Get.width * .25,
                              child: Row(
                                children: [
                                  Text(
                                    item.viewer!.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 2.5,
                                  ),
                                  Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black.withOpacity(0.75),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (item.saved == false) {
                            atroController.createMark(
                                item.id.toString(), "atro");
                            atroController.update();
                          } else {
                            atroController.deleteMark(item.saved_id.toString());
                            atroController.update();
                          }
                          item.saved = !item.saved!;
                        },
                        icon: (item.saved == true)
                            ? const Icon(
                                Icons.bookmark_added,
                                color: Colors.black,
                                size: 25,
                              )
                            : const Icon(
                                Icons.bookmark_border_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * .03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      ReadMoreText(
                        item.question! +
                            "\n"
                                "${item.answer}",
                        trimLines: 5000,
                        trimLength: 500000,
                        preDataTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14),
                        textDirection: TextDirection.ltr,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'See more',
                        trimExpandedText: '',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        moreStyle:
                            const TextStyle(fontSize: 10, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showViewer(List<ViewBy> list) {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          child: ListView(
            children: list
                .map(
                  (e) => ListTile(
                    title: Text(e.userName.toString()),
                    subtitle: Text(
                        e.firstName.toString() + " " + e.lastName.toString()),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "http://162.254.32.119" + e.image.toString())),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  _showReportDialog(id, model, userId) {
    return Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.height * .15,
            width: Get.width * .8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "do you want to report this post?",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.close(0);
                      },
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.find<MainController>().report(id, model);
                        Get.close(0);
                      },
                      color: Colors.yellow,
                      child: const Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// _buildRow({String? title}) {
//   return Container(
//     height: Get.height * .065,
//     width: Get.width * .8,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//             color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 12),
//       ],
//     ),
//     child: Row(
//       children: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.link,
//             color: Colors.black,
//           ),
//         ),
//         Text(
//           title!,
//           style: const TextStyle(color: Colors.black,fontSize: 18),
//         ),
//       ],
//     ),
//   );
// }

  _showMoreModal(AtroModel item) {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: (item.profileInfo!.userName !=
                  Get.find<ProfileController>().profile.userName)
              ? Get.height * .1
              : Get.height * .36,
          width: Get.width,
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              (item.profileInfo!.userName ==
                      Get.find<ProfileController>().profile.userName)
                  ? const SizedBox()
                  : Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            _showReportDialog(item.id.toString(), "atro",
                                item.profileInfo?.id.toString());
                          },
                          child: const Text(
                            "Report",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
              (item.profileInfo!.userName ==
                      Get.find<ProfileController>().profile.userName)
                  ? Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            _showDelete(item);
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () {
                            Get.find<CreateController>().question.text =
                                item.question!;
                            Get.find<CreateController>().answer.text =
                                item.answer!;
                            Get.find<CreateController>().update();
                            CreateScreen(
                              id: item.id.toString(),
                              isEdit: true,
                            ).showCreateModal(title: "Atroverse");
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () {
                            if (item.status == "public") {
                              atroController.updateAtro(
                                  item.id.toString(), "private");
                            } else if (item.status == "private") {
                              atroController.updateAtro(
                                  item.id.toString(), "public");
                            }
                            Get.find<CreateController>().update();
                          },
                          child: Text(
                            (item.status == "public")
                                ? "Hide from explore"
                                : "Show in explore",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.find<ProfileController>()
                                .createArchive(item.id.toString(), "atro");
                          },
                          child: const Text(
                            "Archive",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  _showDelete(item) {
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
                "Do you want delete your post?",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                      Get.find<AtroController>().deleteAtro(item.id.toString());
                    },
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        "Yes",
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
}
