import 'dart:developer';
import 'dart:io';

import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/PrefHelpers.dart';
import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../Helpers/WidgetHelper.dart';
import '../Models/ProfileModel.dart';
import 'AtroController.dart';
import 'ExplorController.dart';
import 'FavoriteController.dart';
import 'HomeController.dart';

class LoginController extends GetxController with StateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rPassword = TextEditingController();
  TextEditingController emailCode = TextEditingController();
  TextEditingController link = TextEditingController(text: "");
  RxBool isBody = false.obs;
  RxBool isRegister = false.obs;
  RxBool isOpen = false.obs;
  RxBool isCheck = false.obs;
  RxString linked = "".obs;
  RxString ruleText = "".obs;
  var selectedDate = DateTime.now();

  getRule() {
    RequestHelper.getRule().then((value) {
      if (value.statusCode == 200) {
        print("*******");
        ruleText.value = value.data2['text'];
      } else {}
    });
  }

  RxString fcmToken = "".obs;

  getRegistrationId() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmToken.value = (await messaging.getToken())!;
    log(fcmToken.value);
    RequestHelper.sendFcm(fcm: fcmToken.value).then((value) {});
    await PrefHelpers.setMute(true.toString());
    print("****************************************************");
  }

  emailVerifySend() {
    RequestHelper.emailVerifySend().then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          ViewHelper.showSuccessDialog("New code sent");
        } else {
          ViewHelper.showErrorDialog(value.message.toString());
        }
      },
    );
  }

  login() {
    ViewHelper.showLoading();
    RequestHelper.login(email: email.text, password: password.text).then(
      (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          PrefHelpers.setToken(value.data2["token"].toString());
          Get.offAllNamed("/main");
          Get.put(HomeController());
          Get.put(AtroController());
          Get.put(ProfileController());
          Get.put(FavoriteController());
          Get.put(ExplorController());
          getRegistrationId();
        } else {
          ViewHelper.showErrorDialog(value.message.toString());
        }
      },
    );
  }

  login2(OnData<Function>? callback) {
    ViewHelper.showLoading();
    RequestHelper.login(email: email.text, password: password.text).then(
      (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          PrefHelpers.setToken(value.data2["token"].toString());
          getRegistrationId();
        } else {
          ViewHelper.showErrorDialog(value.message.toString());
        }
      },
    );
  }

  forgetPassword() {
    ViewHelper.showLoading();
    RequestHelper.forgetPassword(
      email: email.text,
    ).then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          ViewHelper.showSuccessDialog("Send lint to email");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  register(OnData<Function>? callback) {
    ViewHelper.showLoading();
    RequestHelper.register(
      url: linked.value,
      email: email.text,
      password: password.text,
      // code:
    ).then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          print(value.data2['token']);
          PrefHelpers.setToken(value.data2['token'].toString());
          Get.back();
          getRegistrationId();
          showModal();
        } else {
          ViewHelper.showErrorDialog(value.message.toString());
        }
      },
    );
  }

  late ProfileModel profile;
  File? pickedImageFile;
  TextEditingController fNameInput = TextEditingController();
  TextEditingController lNameInput = TextEditingController();
  TextEditingController biotInput = TextEditingController();
  TextEditingController uNameInput = TextEditingController();

  getProfile() {
    ViewHelper.showLoading();
    RequestHelper.getProfile().then(
      (value) {
        profile = ProfileModel.fromJson(value.data);
        update();
        EasyLoading.dismiss();
        if (value.isDone!) {
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  updateProfile() {
    ViewHelper.showLoading();
    RequestHelper.updateProfile(
            bio: biotInput.text,
            first_name: fNameInput.text,
            last_name: lNameInput.text,
            user_name: uNameInput.text)
        .then((value) {
      EasyLoading.dismiss();
      if (value.isDone!) {
        profile = profile = ProfileModel.fromJson(value.data);
        update();
        ViewHelper.showSuccessDialog("Profile updated");
        Get.offAllNamed("/main");
      } else {
        ViewHelper.showErrorDialog(value.message.toString());
      }
    });
  }

  uploadImage() async {
    ViewHelper.showLoading();
    var postUri = Uri.parse("http://162.254.32.119/profiles/api/");
    var request = http.MultipartRequest("PUT", postUri);
    request.headers.addAll(
      {"Authorization": "Token ${await PrefHelpers.getToken()}"},
    );
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedImageFile!.path));

    request.send().then(
      (response) async {
        print(response.request);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("send");
          EasyLoading.dismiss();
          ViewHelper.showSuccessDialog("Image uploaded");
          final respStr = await response.stream.bytesToString();
          print("*********************");
          print(respStr);
          print("*********************");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  void pickImageWithGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    pickedImageFile = File(pickedImage!.path);
    uploadImage();
    update();
  }

  void pickImageWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    pickedImageFile = File(pickedImage!.path);
    uploadImage();
    update();
  }

  verifyEmail() {
    RequestHelper.verifyEmail(code: emailCode.text).then(
      (value) {
        if (value.statusCode == 200) {
          ViewHelper.showSuccessDialog("Email is verified");
          Get.put(HomeController());
          Get.put(AtroController());
          Get.put(ProfileController());
          Get.put(ExplorController());
          Get.put(FavoriteController());
          Get.offAllNamed("/main");
        } else {
          ViewHelper.showErrorDialog(value.message.toString());
        }
      },
    );
  }

  onPop() {}

  showModal() {
    return showCupertinoModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: Get.context!,
      builder: (_) {
        return WillPopScope(
          onWillPop: () => onPop(),
          child: Container(
            height: Get.height * .47,
            width: Get.width,
            margin: MediaQuery.of(Get.context!).viewInsets,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * .05,
                ),
                codeInput(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "a verification code has been sent to your email: ${email.text}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      emailVerifySend();
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(color: Colors.blue),
                    )),
                SizedBox(
                  height: Get.height * .05,
                ),
                WidgetHelper.softButton(
                  title: "Verify",
                  onTap: () {
                    verifyEmail();
                  },
                ),
                SizedBox(
                  height: Get.height * .05,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget codeInput() {
    return WidgetHelper.input(
      type: TextInputType.text,
      title: "Verify Code",
      maxLength: 150,
      onTap: () {},
      controller: emailCode,
      validate: (value) {
        if (value!.isEmpty) {
          return "Enter Your verify code";
        }
      },
      onChanged: (String value) {},
    );
  }

  @override
  void onInit() {
    getRule();
    super.onInit();
  }
}
