import 'dart:async';

import 'package:atroverse/Controllers/ExplorController.dart';
import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Models/AtroModel.dart';
import '../Utils/ShimerWidget.dart';

class AtroController extends GetxController with StateMixin {
  // Rx<AtroPageModel> atroList = AtroPageModel().obs;
  RxList<AtroModel> atroList = <AtroModel>[].obs;
  RxBool loading = false.obs;
  int activeIndex = 0;
  AtroModel? atro;
  RxBool loadMore = false.obs;
  RxInt page = 1.obs;
  RxString uri = "null".obs;
  RxString isNull = "".obs;
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  postLoading() {
    return const ShimmerLoading();
  }


  deleteMark([id]) {
    ViewHelper.showLoading();
    RequestHelper.deleteMark(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          getAtroListOnRef();
          update();
          // Get.back();
          ViewHelper.showSuccessDialog("Success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  updateAtro(id, status) {
    ViewHelper.showLoading();
    RequestHelper.editAtro2(id: id, status: status).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
        Get.back();
        Get.back();
        ViewHelper.showSuccessDialog("Post updated");
        Get.find<AtroController>().getAtroListOnRef();
        Get.find<ExplorController>().getExploreListOnRef();
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  @override
  void onInit() {
    page.value = 1;
    getAtroListOnRef();
    super.onInit();
  }

  getAtroDetail(id) {
    RequestHelper.getAtroDetail(id: id.toString()).then(
          (value) {
        if (value.isDone!) {
          loading.value = true;
          atro = AtroModel.fromJson(value.data);
          update();
        } else {
          loading.value = false;
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  block(id) {
    ViewHelper.showLoading();
    RequestHelper.block(id: id.toString()).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          ViewHelper.showSuccessDialog("User blocked");
          getAtroListOnRef();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  deleteAtro(String? id) {
    ViewHelper.showLoading();
    RequestHelper.deleteAtro(id: id.toString()).then((value) {
      EasyLoading.dismiss();
      if (value.isDone!) {
        Get.back();
        getAtroListOnRef();
        ViewHelper.showSuccessDialog("Post deleted");
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  getAtroListOnMore() {
    RequestHelper.getAtroList(uri: uri.value == "null" ? " " : uri.value)
        .then((value) {
      if (value.isDone!) {
        for (var i in value.data["results"]) {
          atroList.add(AtroModel.fromJson(i));
        }
        isNull.value = value.data['next'].toString();
        if (value.data['next'] != null) {
          uri.value = value.data['next'];
        }
        update();
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  getAtroListOnRef() {
    loading.value = false;
    RequestHelper.getAtroList(uri: "null").then((value) {
      if (value.isDone!) {
        atroList.clear();
        for (var i in value.data!["results"]) {
          atroList.add(AtroModel.fromJson(i));
        }
        uri.value = value.data['next'];
        isNull.value = value.data['next'].toString();
        loading.value = true;
        loadMore.value = false;
        update();
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  createMark([id, model]) {
    RequestHelper.createMark(id: id, model: model).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          ViewHelper.showSuccessDialog("success");
          getAtroListOnRef();
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

  @override
  void dispose() {
    // for (var i in atroList) {
    //   i.player?.stop();
    // }
    super.dispose();
  }

  @override
  void onClose() {
    // for (var i in atroList) {
    //   i.player?.stop();
    // }
    super.onClose();
  }
}
