import 'dart:io';
import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../Models/AtroModel.dart';

class CommentController extends GetxController {
  RxBool isSend = false.obs;
  RxBool isReply = false.obs;
  RxBool isRecording = false.obs;
  RxBool isType = false.obs;
  RxBool isEnd = false.obs;
  RxInt page = 1.obs;
  RxList<Comment> commentList = <Comment>[].obs;
  RxList<Comment> replyList = <Comment>[].obs;
  Comment? replyComment;
  TextEditingController commentInput = TextEditingController();
  ScrollController scrollControllerList = ScrollController();
  FocusNode focusNode = FocusNode();
  String? path;
  String? audioFile;
  String? imagePath;
  late Directory directory;

  getCommentList({String? appName, String? modelId, String? modelName}) {
    RequestHelper.getComments(
        appName: appName, modelId: modelId, modelName: modelName)
        .then(
          (value) {
        if (value.statusCode == 200) {
          commentList.clear();
          for (var i in value.data2) {
            commentList.add(Comment.fromJson(i));
          }
          update();
          scrollDown();
        } else {}
      },
    );
  }

  scrollListener() {
    focusNode.addListener(
          () {
        Future.delayed(const Duration(seconds: 1)).then(
              (value) {
            scrollDown();
          },
        );
      },
    );
  }

  scrollDown() {
    Future.delayed(const Duration(seconds: 1)).then(
          (value) {
        scrollControllerList.animateTo(
            scrollControllerList.position.maxScrollExtent,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 100));
      },
    );
  }


  getReply(
      {String? id,
        String? page,
        int? index,
        RxBool? loading,
        RxBool? loading2,
        RxString? message}) {
    print(index);
    Future.delayed(200.milliseconds).then((value) {
      var pos = scrollControllerList.position.pixels + 100;
      scrollControllerList.animateTo(
          pos,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 100));
    });

    message?.value = "show more";
    RequestHelper.getReplyComments(id: id, page: page).then(
          (value) {
        if (value.statusCode == 200) {
          for (var i in value.data2["results"]) {
            commentList[index!].replies.add(Comment.fromJson(i));
          }
          loading?.value = true;
          loading2?.value = true;
          update();
        } else if (value.statusCode == 404) {
          loading2?.value = false;
          message?.value = "Hide replies";
          update();
        }
      },
    );
  }

  deleteCm({id, appName, modelId, modelName}) {
    ViewHelper.showLoading();
    RequestHelper.deleteCm(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 204) {
          getCommentList(
              appName: appName, modelId: modelId, modelName: modelName);
          update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  Future<void> play({position, player, playerState, String? url}) async {
    player?.setUrl(url);
    Get.find<AtroController>().update();

    final position1 = position;
    if (position1 != null && position1.inMilliseconds > 0) {
      await player.seek(position1);
      Get.find<AtroController>().update();
    }
    await player.resume();
    playerState = PlayerState.PLAYING;
    Get.find<AtroController>().update();
  }

  Future<void> stop({player, playerState, position}) async {
    await player.stop();
    playerState = PlayerState.STOPPED;
    position = Duration.zero;
    Get.find<AtroController>().update();
  }

// @override
// void dispose() {
//   for (var i in atroList) {
//     i.player?.stop();
//   }
//   super.dispose();
// }
//
// @override
// void onClose() {
//   for (var i in atroList) {
//     i.player?.stop();
//   }
//   super.onClose();
// }

  @override
  void onInit() {
    scrollListener();
    super.onInit();
  }
}
