import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/SplashController.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  SplashController controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/images/logo file4-ai.png",width: Get.width * .7,))
    );
  }
}
