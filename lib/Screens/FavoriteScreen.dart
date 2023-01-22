import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/FavoriteController.dart';
import '../Plugins/lib2/examples/animated_header.dart';

class FavoriteScreen extends StatelessWidget {
  final controller = Get.find<FavoriteController>();

  FavoriteScreen({Key? key}) : super(key: key) {
    controller.getNotifList();
    controller.getRequestList();
    controller.dailyNotif();
  }

  @override
  Widget build(BuildContext context) {
    return const AnimatedHeaderExample();
  }
}
