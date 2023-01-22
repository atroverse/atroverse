import 'package:atroverse/Controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helpers/WidgetHelper.dart';

class ForgetPasswordScreen extends GetView<LoginController> {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: const Text(
          "Forget Password",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            }),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .05,
            ),
            emailInput(),
            SizedBox(
              height: Get.height * .05,
            ),
            WidgetHelper.softButton(
                onTap: () {
                  controller.forgetPassword();
                },
                title: "Send"),
          ],
        ),
      ),
    );
  }

  Widget emailInput() {
    return WidgetHelper.input(
      type: TextInputType.text,
      title: "Email",
      maxLength: 150,
      onTap: () {},
      controller: controller.email,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your Email";
        }
      },
      onChanged: (String value) {},
    );
  }
}
