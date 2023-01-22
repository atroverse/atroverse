import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../Helpers/RequestHelper.dart';
import '../Helpers/ViewHelpers.dart';

class MainController extends GetxController {
  PageController pageController = PageController();
  RxInt activePage = 0.obs;
  ScrollController scrollController = ScrollController();

  report(id, model) {
    ViewHelper.showLoading();
    RequestHelper.report(id: id, model: model).then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          ViewHelper.showSuccessDialog("The post was reported");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }
}
