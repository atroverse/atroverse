import 'package:atroverse/Models/WillModel.dart';
import 'package:atroverse/Plugins/lib2/examples/animated_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import '../Helpers/RequestHelper.dart';
import '../Helpers/ViewHelpers.dart';
import '../Models/AdminNotifModel.dart';
import '../Models/FavoriteModel.dart';
import '../Models/NotifModel.dart';
import '../Models/RequestModel.dart';
import 'ProfileController.dart';

class FavoriteController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<NotifModel> listOfNotif = <NotifModel>[].obs;
  RxList<AdminNotifModel> listOfRequest = <AdminNotifModel>[].obs;
  RxList<DayliNotifModel> listOfDalyNotif = <DayliNotifModel>[].obs;
  var notifCount = 0.obs;

  getNotifList() {
    RequestHelper.getNotifList().then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          notifCount.value = value.data2["unread_count"];
          listOfNotif.clear();
          for (var i in value.data) {
            listOfNotif.add(NotifModel.fromJson(i));
          }
          update();
        } else {}
      },
    );
  }

  getRequestList() {
    RequestHelper.getRequestList().then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          listOfRequest.clear();
          for (var i in value.data) {
            listOfRequest.add(AdminNotifModel.fromJson(i));
          }
          update();
        } else {}
      },
    );
  }

  dailyNotif() {
    RequestHelper.getDailyNotif().then(
      (value) {
        if (value.statusCode == 200) {
          listOfDalyNotif.clear();
          for (var i in value.data) {
            listOfDalyNotif.add(DayliNotifModel.fromJson(i));
          }
        } else {}
      },
    );
  }

  adminUpdate(id, confirm) {
    RequestHelper.adminUpdate(confirm: confirm.toString(), id: id.toString())
        .then(
      (value) {
        EasyLoading.dismiss();
        Get.find<ProfileController>().getProfile();
        getRequestList();
        if (value.isDone!) {
          ViewHelper.showSuccessDialog("success");
        } else {
          ViewHelper.showErrorDialog("try again");
        }
      },
    );
  }

  @override
  void onInit() {
    getRequestList();
    getNotifList();
    dailyNotif();
    super.onInit();
  }
}
