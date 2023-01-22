import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Models/ExplorModel.dart';

class ExplorController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  Rx<ExploreModel> listOfExplore = ExploreModel().obs;
  RxInt page = 1.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RxString uri = "null".obs;
  RxString isNull = "".obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    getExploreListOnRef();
    super.onInit();
  }

  getExploreListOnRef() {
    RequestHelper.getExploreList(uri: "null").then(
      (value) {
        if (value.statusCode == 200) {
          listOfExplore.value = ExploreModel.fromJson(value.data);
          uri.value = value.data['next'].toString();
          isNull.value = value.data['next'].toString();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getExploreListLoadMore() {
    RequestHelper.getExploreList(uri: uri.value == "null" ? " " : uri.value)
        .then(
      (value) {
        if (value.statusCode == 200) {
          listOfExplore.value = ExploreModel.fromJson(value.data);
          isNull.value = listOfExplore.value.next.toString();
          if (listOfExplore.value.next != null) {
            uri.value = listOfExplore.value.next;
          }
          refreshController.loadComplete();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }
}
