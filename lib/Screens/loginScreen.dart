import 'dart:io';
import 'package:atroverse/Controllers/LoginController.dart';
import 'package:atroverse/Helpers/FadeInAnimations.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helpers/ViewHelpers.dart';
import '../Helpers/WidgetHelper.dart';
import 'ForgetPasswordScreen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: MediaQuery.of(Get.context!).viewInsets,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: GetBuilder<LoginController>(builder: (controller) {
                return FadeAnimation(
                  0.5,
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/logo file4-ai.png",
                      ),
                      emailInput(),
                      SizedBox(
                        height: Get.height * .01,
                      ),
                      passwordInput(),
                      SizedBox(
                        height: Get.height * .015,
                      ),
                      WidgetHelper.softButton(
                          onTap: () {
                            controller.login();
                          },
                          title: "Login"),
                      SizedBox(
                        height: Get.height * .015,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const ForgetPasswordScreen());
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .015,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: Get.height * .0025,
                            width: Get.width * .45,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const Text("or"),
                          Container(
                            height: Get.height * .0025,
                            width: Get.width * .45,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * .015,
                      ),
                      WidgetHelper.softButton(
                          onTap: () {
                            showRegisterModal();
                          },
                          color: Colors.black,
                          title: "Register Via Link"),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Registration on Atroverse require \ninvite code from one of your friend",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      ExpandTapWidget(
                        onTap: () {
                          showRule();
                        },
                        tapPadding: const EdgeInsets.all(50),
                        child: const Text(
                          "Terms and Policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailInput() {
    return WidgetHelper.input(
      type: TextInputType.emailAddress,
      title: "Email",
      maxLength: 150,
      onTap: () {},
      show: true,
      controller: controller.email,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your Email";
        }
      },
      onChanged: (String value) {},
    );
  }

  Widget passwordInput() {
    return InputPassword(
      type: TextInputType.text,
      title: "Password",
      maxLength: 25,
      show: false.obs,
      onTap: () {},
      controller: controller.password,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your Password";
        } else if (value.length < 8) {
          return "The password must not be less than 8 digits";
        }
      },
      onChanged: (String value) {},
    );
  }

  Widget rPasswordInput() {
    return InputPassword(
      type: TextInputType.text,
      title: "Confirm Password",
      maxLength: 25,
      onTap: () {},
      show: false.obs,
      controller: controller.rPassword,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your Confirm Password";
        } else if (value != controller.password.text) {
          return "Dose not mach password";
        } else if (value.length < 8) {
          return "The password must not be less than 8 digits";
        }
      },
      onChanged: (String value) {},
    );
  }

  Widget linkInput() {
    return WidgetHelper.input(
      type: TextInputType.text,
      title: "Invite Code",
      maxLength: 500,
      onTap: () {},
      controller: controller.link,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your Link";
        }
      },
      onChanged: (String value) {
        controller.linked.value = value;
        controller.update();
      },
    );
  }

  showLinkModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      barrierColor: Colors.black38,
      builder: (_) {
        return GetBuilder<LoginController>(builder: (controller) {
          return Padding(
            padding: MediaQuery.of(Get.context!).viewInsets,
            child: SizedBox(
              height: Get.height * .4,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.height * .05,
                  ),
                  linkInput(),
                  SizedBox(
                    height: Get.height * .025,
                  ),
                  WidgetHelper.softButton(
                    onTap: () {
                      print(controller.link.text.contains("register"));
                      if (controller.link.text.contains("register") == true) {
                        controller.isOpen.value = true;
                        showRegisterModal();
                        controller.update();
                        // controller.link = TextEditingController();
                      } else {
                        controller.register(
                          (data) {
                            showRegisterModal();
                          },
                        );
                      }
                    },
                    title: "Check Link",
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  showRegisterModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      barrierColor: Colors.black38,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(Get.context!).viewInsets,
          child: GetBuilder<LoginController>(
            builder: (controller) {
              return SizedBox(
                height: Get.height * .55,
                width: Get.width,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * .05,
                      ),
                      emailInput(),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      passwordInput(),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      rPasswordInput(),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      linkInput(),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: controller.isCheck.value,
                          onChanged: (value) {
                            controller.isCheck.value = value!;
                            controller.update();
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "I`ve read & agreed with ",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      'https://www.atroverse.com/terms'));
                                },
                                child: const Text(
                                  "Atroverse terms and privacy policy",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      WidgetHelper.softButton(
                        onTap: () {
                          controller.isBody.value = true;
                          controller.update();
                          if (controller.isCheck.isFalse) {
                            ViewHelper.showErrorDialog(
                                "Please agree terms and privacy policy");
                          } else {
                            controller.register(
                              (data) {
                                controller.login2(
                                  (data) {
                                    Get.toNamed("editProfile");
                                  },
                                );
                              },
                            );
                          }
                        },
                        title: "Register",
                      ),
                      SizedBox(
                        height: Get.height * .05,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  showRule() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return SizedBox(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              SizedBox(height: Get.width * .05),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * .05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ExpandTapWidget(
                      onTap: () {
                        Get.close(0);
                      },
                      tapPadding: const EdgeInsets.all(50),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        controller.ruleText.value,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
