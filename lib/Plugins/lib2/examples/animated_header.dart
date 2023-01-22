import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Controllers/FavoriteController.dart';
import 'package:atroverse/Models/AdminNotifModel.dart';
import 'package:atroverse/Models/NotifModel.dart';
import 'package:atroverse/Screens/CommentScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../../../Models/AtroModel.dart' as atro;
import '../../../Utils/CostumAppBarWidget.dart';
import '../common.dart';

class AnimatedHeaderExample extends StatelessWidget {
  const AnimatedHeaderExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(1.seconds).then((value) {
          Get.find<FavoriteController>().getNotifList();
          Get.find<FavoriteController>().dailyNotif();
        });
      },
      child: const AppScaffold(
        title: "",
        slivers: [
          // SliverPersistentHeader(
          //   delegate: CustomAppBar(
          //       height: Get.height * .1,
          //       title: "Notification",
          //       isBack: false,
          //       isOnTap: false),
          //   pinned: false,
          //   floating: true,
          // ),
          _StickyHeaderList(index: 0),
          _StickyHeaderList(index: 1),
          _StickyHeaderList(index: 2),
        ],
      ),
    );
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader.builder(
      builder: (context, state) => _AnimatedHeader(
        state: state,
        index: index,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var item = (this.index == 0)
                ? Get.find<FavoriteController>().listOfNotif[index]
                : (this.index == 1)
                    ? Get.find<FavoriteController>().listOfDalyNotif[index]
                    : (this.index == 2)
                        ? Get.find<FavoriteController>().listOfRequest[index]
                        : [][index];
            return (item is AdminNotifModel)
                ? SizedBox(
                    height: Get.height * .09,
                    width: Get.width,
                    child: ListTile(
                      leading: item.userInfo!.image.toString() == 'null'
                          ? CircleAvatar(
                              child: Container(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: CachedNetworkImage(
                                imageUrl: item.userInfo!.image.toString(),
                                height: 40,
                                width: 40,
                                fadeInDuration: const Duration(seconds: 10),
                                fit: BoxFit.cover,
                              )),
                      title: Text(item.userInfo!.userName.toString()),
                      subtitle: Text(item.text.toString()),
                      trailing: SizedBox(
                        height: Get.height * .09,
                        width: Get.width * .4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.white)),
                              onPressed: () {
                                Get.find<FavoriteController>()
                                    .adminUpdate(item.id.toString(), "true");
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : (item is NotifModel)
                    ? ListTile(
                        leading: item.contentObject == null
                            ? CircleAvatar(
                                child: Container(),
                              )
                            : item.contentObject!.image == null
                                ? CircleAvatar(
                                    child: Container(),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          item.contentObject!.image.toString(),
                                      height: 40,
                                      width: 40,
                                      fadeInDuration: const Duration(milliseconds: 1),
                                      fit: BoxFit.cover,
                                    )),
                        onTap: () {
                          Get.to(
                            CommentScreen(
                              atroController: Get.find<AtroController>(),
                              atroModel: atro.AtroModel(
                                id: item.contentObject?.id,
                                image: item.contentObject?.image,
                                question: item.contentObject?.question,
                                answer: item.contentObject?.answer,
                                sound: item.contentObject?.sound,
                                profileInfo: atro.ProfileInfo(
                                  image: item.contentObject?.profileInfo?.image,
                                  id: item.contentObject?.profileInfo?.id,
                                  userName:
                                      item.contentObject?.profileInfo?.userName,
                                  user: item.contentObject?.profileInfo?.user,
                                  firstName: item
                                      .contentObject?.profileInfo?.firstName,
                                  lastName:
                                      item.contentObject?.profileInfo?.userName,
                                ),
                              ),
                            ),
                          );
                        },
                        title: (item.contentObject == null)
                            ? const Text("")
                            : Text(item.contentObject!.profileInfo!.userName
                                .toString()),
                        subtitle: Text(item.message.toString()),
                      )
                    : (item is DayliNotifModel)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.message.toString(),
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const Divider(),
                            ],
                          )
                        : Container();
          },
          childCount: (index == 0)
              ? Get.find<FavoriteController>().listOfNotif.reversed.length
              : (index == 1)
                  ? Get.find<FavoriteController>()
                      .listOfDalyNotif
                      .reversed
                      .length
                  : (this.index == 2)
                      ? Get.find<FavoriteController>()
                          .listOfRequest
                          .reversed
                          .length
                      : 0,
        ),
      ),
    );
  }
}

class _AnimatedHeader extends StatelessWidget {
  const _AnimatedHeader({
    Key? key,
    this.state,
    this.index,
  }) : super(key: key);

  final int? index;
  final SliverStickyHeaderState? state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DayliNotifModel {
  DayliNotifModel({
    this.id,
    this.message,
  });

  int? id;
  String? message;
  final translator = GoogleTranslator();

  factory DayliNotifModel.fromJson(Map<String, dynamic> json) =>
      DayliNotifModel(
        id: json["id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
      };
}
