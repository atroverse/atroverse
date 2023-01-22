import 'dart:convert';
import 'dart:io';
import 'package:atroverse/Controllers/AtroController.dart';
import 'package:dio/dio.dart' as d;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../Helpers/PrefHelpers.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/ViewHelpers.dart';
import 'MainController.dart';
import 'ProfileController.dart';

class CreateController extends GetxController {
  TextEditingController caption = TextEditingController();
  TextEditingController answer = TextEditingController();
  TextEditingController question = TextEditingController();

  // AudioPlayer audioPlayer = AudioPlayer();
  final FocusNode nodeText1 = FocusNode();
  final FocusNode nodeText2 = FocusNode();
  final FocusNode nodeText3 = FocusNode();
  RxBool isRecording = false.obs;
  RxBool isEnd = false.obs;
  RxBool isExplore = false.obs;
  String? path;
  RxString audioFile = "".obs;
  String? imagePath;
  late Directory directory;

  FilePickerResult? result;
  File? file;
  File? compressFile;

  getGallery() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: false, type: FileType.image, allowCompression: true);

    if (result != null) {
      file = File(result!.files.single.path!);
      compressFile = await FlutterNativeImage.compressImage(
        file!.absolute.path,
        quality: 25,
      );
      update();
    } else {
      // User canceled the picker
    }
  }

  updateAtro(id) {
    ViewHelper.showLoading();
    RequestHelper.editAtro(id: id, question: question.text, answer: answer.text)
        .then((value) {
      EasyLoading.dismiss();
      if (value.isDone!) {
        Get.close(0);
        Get.close(0);
        ViewHelper.showSuccessDialog("Post updated");
        Get.find<AtroController>().getAtroDetail(id);
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  updateWill(id) {
    ViewHelper.showLoading();
    RequestHelper.editWill(id: id, caption: caption.text).then((value) {
      EasyLoading.dismiss();
      if (value.isDone!) {
        Get.close(0);
        ViewHelper.showSuccessDialog("Post updated");
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  void requestCameraPermission(bool isWill) async {
      if (isWill == true) {
        createWill();
      } else if (isWill == false) {
        createAtro();
      }
  }

  createAtro() async {
    print(audioFile.toString());
    ViewHelper.showLoading();
    var postUri = Uri.parse("http://162.254.32.119/atro/api/create/");
    var request = http.MultipartRequest("POST", postUri);
    print(request);
    request.fields['question'] = question.text;
    request.fields['answer'] = answer.text;
    request.fields['status'] = isExplore.isTrue?"public":"private";
    if (audioFile.value != "") {
      request.files.add(
        await http.MultipartFile.fromPath(
          'sound',
          audioFile.value,
        ),
      );
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        compressFile!.path.toString(),
      ),
    );
    print(request.files.map((e) => e.filename));
    request.fields.forEach((key, value) {
      print(key);
      print(value);
    });
    request.headers
        .addAll({"Authorization": "Token ${await PrefHelpers.getToken()}"});
    request.send().then(
          (response) async {
        final respStr = await response.stream.bytesToString();
        print(respStr);
        EasyLoading.dismiss();
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.back();
          Get.find<MainController>().activePage.value = 0;
          Get.find<MainController>().pageController.jumpToPage(0);
          Get.find<AtroController>().getAtroListOnRef();
          question.clear();
          answer.clear();
          path = "";
          imagePath = "";
          isRecording.value = false;
          isEnd.value = false;
          ViewHelper.showSuccessDialog("successful");
        } else {
          ViewHelper.showErrorDialog("please try again");
        }
      },
    );
  }

  createWill() async {
    Get.back();
    print(audioFile.toString());
    ViewHelper.showLoading();
    var postUri = Uri.parse("http://162.254.32.119/wills/api/create/");
    var request = http.MultipartRequest("POST", postUri);
    print(request);
    request.fields['caption'] = caption.text;
    request.fields['status'] = 'private';
    if (audioFile.value != "") {
      request.files.add(
        await http.MultipartFile.fromPath(
          'sound',
          audioFile.value,
        ),
      );
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        compressFile!.path.toString(),
      ),
    );
    print(request.files.map((e) => e.filename));
    request.fields.forEach((key, value) {
      print(key);
      print(value);
    });
    request.headers
        .addAll({"Authorization": "Token ${await PrefHelpers.getToken()}"});
    request.send().then(
          (response) async {
        final respStr = await response.stream.bytesToString();
        print(respStr);
        EasyLoading.dismiss();
        if (response.statusCode == 200 || response.statusCode == 201) {
          ViewHelper.showSuccessDialog("successful");
          Get.find<MainController>().activePage.value = 0;
          Get.find<MainController>().pageController.jumpToPage(0);
          Get.find<ProfileController>().getUserWill();
          caption.clear();
          path = "";
          imagePath = "";
          isRecording.value = false;
          isEnd.value = false;
          ViewHelper.showSuccessDialog("successful");
        } else {
          ViewHelper.showErrorDialog("please try again");
        }
      },
    );
  }

  KeyboardActionsConfig buildConfig(BuildContext context, FocusNode node) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: node,
          toolbarButtons: [
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
