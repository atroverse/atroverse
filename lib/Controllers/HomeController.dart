import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/ViewHelpers.dart';
import '../Models/WillModel.dart';
import '../Utils/ShimerWidget.dart';

class HomeController extends GetxController with StateMixin {
  RxBool loading = false.obs;
  int activeIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  postLoadingTimer() {
    return Future.delayed(const Duration(seconds: 3)).then((value) {
      loading.value = true;
      update();
    });
  }

  postLoading() {
    return const ShimmerLoading();
  }

}
