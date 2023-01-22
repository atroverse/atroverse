import 'dart:developer';
import 'dart:io';

import 'package:atroverse/Controllers/AtroController.dart';
import 'package:atroverse/Models/FriendProfileModel.dart';
import 'package:atroverse/Models/ProfileModel.dart';
import 'package:atroverse/Models/WillModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../Helpers/PrefHelpers.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/ViewHelpers.dart';
import '../Helpers/WidgetHelper.dart';
import '../Models/ArchiveWillModel.dart';
import '../Models/AtroModel.dart';
import '../Models/BlockListModel.dart';
import '../Utils/ProfileUpdate.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<WillModel> willList = <WillModel>[].obs;
  RxList<WillModel> userWillList = <WillModel>[].obs;
  RxList<AtroModel> userAtroList = <AtroModel>[].obs;
  RxList<ArichveModel> willArchiveList = <ArichveModel>[].obs;
  RxList<ArichveModel> willArchiveList1 = <ArichveModel>[].obs;
  RxList<ArichveModel> willArchiveList2 = <ArichveModel>[].obs;
  RxList<ArichveModel> atroMarkList = <ArichveModel>[].obs;
  RxList<ArichveModel> atroMarkList1 = <ArichveModel>[].obs;
  RxList<ArichveModel> atroMarkList2 = <ArichveModel>[].obs;
  RxList<ProfileModel> friendList = <ProfileModel>[].obs;
  late ProfileModel profile;
  RxList<AtroModel> atroList = <AtroModel>[].obs;
  late FriendProfileModel friendProfile;
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  File? pickedImageFile = File("");
  late TextEditingController fNameInput;
  late TextEditingController lNameInput;
  late TextEditingController biotInput;
  late TextEditingController uNameInput;
  late TextEditingController newPass = TextEditingController();
  late TextEditingController deleteCode = TextEditingController();
  late TextEditingController reNewPass = TextEditingController();
  late TextEditingController oldPass = TextEditingController();
  late TextEditingController newEmail = TextEditingController();
  late TextEditingController emailCode = TextEditingController();
  late TextEditingController friendCode = TextEditingController();
  var selectedDate;
  RxBool selectTab = false.obs;
  RxBool openBio = false.obs;
  RxBool isUpdate = false.obs;
  RxString country = "".obs;
  RxString state = "".obs;
  RxString city = "".obs;
  RxString imageProfile = "".obs;
  RxDouble height = 0.0.obs;
  final zoomDrawerController = ZoomDrawerController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScreenshotController screenshotController = ScreenshotController();

  onShare(text, subject) async {
    final box = Get.context?.findRenderObject() as RenderBox?;
    await Share.share(
      text + ": " + subject,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  shareQrCode() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.png').create();
          if (imagePath != null) {
            await imagePath.writeAsBytes(image);
            Share.shareFiles([imagePath.path]);
          }
        } catch (error) {}
      }
    }).catchError((onError) {
      print('Error --->> $onError');
    });
  }

  FriendDelete? dateTime;

  deleteFriend(String id) {
    Get.back();
    ViewHelper.showLoading();
    RequestHelper.deleteFriend(toUser: id).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 201) {
        dateTime = FriendDelete.fromJson(value.data2);
        ViewHelper.showSuccessDialog("Success");
        getFriendList(() {});
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }



  deleteAccount(Callback callback) {
    ViewHelper.showLoading();
    RequestHelper.deleteAccount().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          callback();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  deleteAccountVerify() {
    ViewHelper.showLoading();
    RequestHelper.delete_account_verify(code: deleteCode.text).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          PrefHelpers.removeToken();
          Future.delayed(1.seconds).then(
                (value) async {
              await Get.deleteAll(force: true);
              Phoenix.rebirth(Get.context!);
              Get.reset();
            },
          );
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  RxString fcmToken = "".obs;
  RxBool isOn = true.obs;

  getRegistrationId() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmToken.value = (await messaging.getToken())!;
    log(fcmToken.value);
    RequestHelper.sendFcm(fcm: fcmToken.value).then((value) {});
    print("****************************************************");
  }

  createRequest(id) {
    ViewHelper.showLoading();
    RequestHelper.createRequest(id: id.toString()).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
        ViewHelper.showSuccessDialog("Success");
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  changePassWord() {
    ViewHelper.showLoading();
    RequestHelper.changePassWord(newPass: newPass.text, oldPass: oldPass.text)
        .then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          Get.back();
          ViewHelper.showSuccessDialog("success");
          reNewPass.clear();
          oldPass.clear();
          newPass.clear();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  changeEmail() {
    ViewHelper.showLoading();
    RequestHelper.changeEmail(email: profile.email).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 204) {
          ViewHelper.showSuccessDialog(
              "Verify link send to your email,please check email");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  logOut() {
    ViewHelper.showLoading();
    RequestHelper.logOut().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          PrefHelpers.removeToken();
          Future.delayed(1.seconds).then((value) async {
            await Get.deleteAll(force: true);
            Phoenix.rebirth(Get.context!);
            Get.reset();
          });
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  @override
  void onInit() {
    getProfile();
    getWillList();
    getArchiveList();
    getMarkList();
    getUserAtroList();
    getFriendList(
          () {},
    );
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  pop() {}

  getProfile() {
    RequestHelper.getProfile().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          profile = ProfileModel.fromJson(value.data);
          fNameInput = TextEditingController(text: profile.firstName);
          lNameInput = TextEditingController(text: profile.lastName);
          biotInput = TextEditingController(text: profile.bio);
          uNameInput = TextEditingController(text: profile.userName);
          state.value = profile.state.toString();
          city.value = profile.city.toString();
          country.value = profile.country.toString();
          if (profile.birthdate != null) {
            selectedDate = profile.birthdate;
          }
          update();
          getUserWill();
          if (profile.done == false) {
            return showCupertinoModalBottomSheet(
              context: Get.context!,
              enableDrag: false,
              isDismissible: false,
              backgroundColor: Colors.white,
              builder: (_) {
                return WillPopScope(
                  onWillPop: () => pop(),
                  child: SizedBox(
                    height: Get.height * .2,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Please complete your profile for get start",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Get.to(ProfileUpdate());
                              },
                              color: Colors.blue,
                              child: const Center(
                                child: Text(
                                  "Go",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (profile.verified == false) {
            return showCupertinoModalBottomSheet(
              context: Get.context!,
              enableDrag: false,
              isDismissible: false,
              backgroundColor: Colors.white,
              builder: (_) {
                return WillPopScope(
                  onWillPop: () => pop(),
                  child: SizedBox(
                    height: Get.height * .2,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Please verified your email for get start",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                emailVerifySend();
                              },
                              color: Colors.blue,
                              child: const Center(
                                child: Text(
                                  "Send Code",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  onPop() {}

  emailVerifySend() {
    Get.back();
    ViewHelper.showLoading();
    RequestHelper.emailVerifySend().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          showModal();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

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
                    "a verification code has been sent to your email: ${profile.email}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                      onPressed: () {
                        emailVerifySend();
                      },
                      child: const Text(
                        "Resend Code",
                        style: TextStyle(color: Colors.blue),
                      )),
                ),
                SizedBox(
                  height: Get.height * .05,
                ),
                WidgetHelper.softButton(
                  title: "Verify",
                  onTap: () {
                    verifyEmail();
                    Get.back();
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

  verifyEmail() {
    RequestHelper.verifyEmail(code: emailCode.text).then(
          (value) async {
        if (value.statusCode == 200) {
          ViewHelper.showSuccessDialog("Email is verified");
          await Get.deleteAll(force: true);
          Phoenix.rebirth(Get.context!);
          Get.reset();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  addFriend() {
    ViewHelper.showLoading();
    Get.back();
    RequestHelper.addFriend(code: friendCode.text).then(
          (value) async {
        Get.back();
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          ViewHelper.showSuccessDialog(value.message!);
          getFriendList(() {});
          getProfile();
          friendCode.clear();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
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

  getWillList() {
    RequestHelper.getWillList().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          willList.clear();
          for (var i in value.data) {
            willList.add(WillModel.fromJson(i));
          }
          update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getUserWill() {
    RequestHelper.getUserWill().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          userWillList.clear();
          for (var i in value.data) {
            userWillList.add(WillModel.fromJson(i));
          }
          update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getUserAtroList() {
    RequestHelper.getUserAtroList().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          userAtroList.clear();
          for (var i in value.data) {
            userAtroList.add(AtroModel.fromJson(i));
          }
          update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  generateCode() {
    ViewHelper.showLoading();
    RequestHelper.generateCode().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          onShare("Atroverse Application Invite close friend Link: ",
              value.data['friend_code']);
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  deleteWill(String? id) {
    ViewHelper.showLoading();
    RequestHelper.deleteWill(id: id.toString()).then((value) {
      EasyLoading.dismiss();
      if (value.isDone!) {
        Get.back();
        getUserWill();
        ViewHelper.showSuccessDialog("Post deleted");
      } else {
        ViewHelper.showErrorDialog("Please try again");
      }
    });
  }

  updateProfile() {
    ViewHelper.showLoading();
    RequestHelper.updateProfile(
        city: city.value,
        country: country.value,
        state: state.value,
        bio: biotInput.text,
        first_name: fNameInput.text,
        last_name: lNameInput.text,
        user_name: uNameInput.text,
        bDate: selectedDate.toString().substring(0, 10))
    // "${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}")
        .then(
          (value) async {
        EasyLoading.dismiss();
        if (value.isDone!) {
          Get.back();
          update();
          ViewHelper.showSuccessDialog("Profile updated");
          if (isUpdate.isTrue) {
            await Get.deleteAll(force: true);
            Phoenix.rebirth(Get.context!);
            Get.reset();
          } else {
            profile = profile = ProfileModel.fromJson(value.data);
          }
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
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

    print(request.url);
    request.send().then(
          (response) async {
        print(response.request);
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (isUpdate.isFalse) {
            getProfile();
          }
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

  FilePickerResult? result;
  File? file;

  pickImageWithGallery() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: false, type: FileType.image, allowCompression: true);
    if (result != null) {
      file = File(result!.files.single.path!);
      update();
      Get.to(UploadImageHelper(
        pickImage: file,
        isCamera: false,
      ));
      update();
    } else {
      // User canceled the picker
    }
  }

  // void pickImageWithGallery() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   pickedImageFile = File(pickedImage!.path);
  //
  //   // uploadImage();
  //   update();
  // }

  void pickImageWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 25);
    pickedImageFile = File(pickedImage!.path);
    // uploadImage();
    Get.to(UploadImageHelper(
      pickImage: pickedImageFile,
      isCamera: true,
    ));
    update();
  }

  createArchive([id, model]) {
    ViewHelper.showLoading();
    RequestHelper.createArchive(id: id, model: model).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          getUserWill();
          Get.find<AtroController>().getAtroListOnRef();
          getArchiveList();
          Get.back();
          ViewHelper.showSuccessDialog("success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  deleteArchive([id]) {
    ViewHelper.showLoading();
    RequestHelper.deleteArchive(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          willArchiveList.clear();
          willArchiveList1.clear();
          willArchiveList2.clear();
          getUserWill();
          Get.find<AtroController>().getAtroListOnRef();
          getArchiveList();
          Get.back();
          ViewHelper.showSuccessDialog("success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  createMark([id, model]) {
    RequestHelper.createMark(id: id, model: model).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          getMarkList();
          Get.find<AtroController>().getAtroDetail(id);
          ViewHelper.showSuccessDialog("success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  deleteMark(id,uid) {
    ViewHelper.showLoading();
    RequestHelper.deleteMark(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          Get.find<AtroController>().getAtroDetail(uid);
          getMarkList();
          update();
          // Get.back();
          ViewHelper.showSuccessDialog("Success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }



  unBlock([id]) {
    ViewHelper.showLoading();
    RequestHelper.unBlock(id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          blocklist();
          update();
          ViewHelper.showSuccessDialog("Success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  cancelFriend([id]) {
    Get.back();
    ViewHelper.showLoading();
    RequestHelper.cancelFriend(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 204) {
          getFriendList(() {});
          Get.back();
          update();
          ViewHelper.showSuccessDialog("Success");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getArchiveList() {
    ViewHelper.showLoading();
    RequestHelper.getArchiveList().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          willArchiveList.clear();
          for (var i in value.data) {
            willArchiveList.add(ArichveModel.fromJson(i));
          }
          willArchiveList1.clear();
          willArchiveList2.clear();
          willArchiveList.forEach(
                (element) {
              if (element.contentObject!.file == null ||
                  element.contentObject!.file!.isEmpty) {
                willArchiveList1.add(element);
              } else {
                willArchiveList2.add(element);
              }
            },
          );
        } else {
          Get.close(0);
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getMarkList() {
    ViewHelper.showLoading();
    RequestHelper.getMarkList().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          atroMarkList.clear();
          for (var i in value.data) {
            atroMarkList.add(ArichveModel.fromJson(i));
          }
          atroMarkList1.clear();
          atroMarkList2.clear();
          for (var element in atroMarkList) {
            if (element.contentObject!.file == null ||
                element.contentObject!.file!.isEmpty) {
              atroMarkList1.add(element);
            } else {
              atroMarkList2.add(element);
            }
          }
          update();
        } else {
          Get.close(0);
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  RxList<BlockListModel> listOfBlock = <BlockListModel>[].obs;

  blocklist() {
    ViewHelper.showLoading();
    RequestHelper.blocklist().then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          listOfBlock.clear();
          for (var i in value.data) {
            listOfBlock.add(BlockListModel.fromJson(i));
          }
          update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  block(id) {
    ViewHelper.showLoading();
    RequestHelper.block(id: id.toString()).then(
          (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          ViewHelper.showSuccessDialog("User blocked");
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getFriendList(Callback callback) {
    RequestHelper.getFriendList().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          friendList.clear();
          for (var i in value.data) {
            friendList.add(ProfileModel.fromJson(i));
          }
          callback();
        } else {
          Get.close(0);
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  getFriendProfile(Callback callback, id) {
    ViewHelper.showLoading();
    RequestHelper.getFriendProfile(id: id).then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          friendProfile = FriendProfileModel.fromJson(value.data);
          callback();
        } else {
          Get.close(0);
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }
}

class UploadImageHelper extends StatefulWidget {
  UploadImageHelper({Key? key, this.pickImage, this.isCamera, this.callBack})
      : super(key: key);

  File? pickImage;
  bool? isCamera;
  Function? callBack;

  @override
  State<UploadImageHelper> createState() => _UploadImageHelperState();
}

class _UploadImageHelperState extends State<UploadImageHelper> {
  CroppedFile? _croppedFile;

  @override
  void initState() {
    _cropImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Container();
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (widget.pickImage != null) {
      final path = widget.pickImage!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  File? compressFile;

  Future<void> _cropImage() async {
    print("**************************");
    print(widget.pickImage!.path);
    print("**************************");
    if (widget.pickImage!.existsSync()) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.pickImage!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null && mounted) {
        _croppedFile = croppedFile;
        compressFile = await FlutterNativeImage.compressImage(
          croppedFile.path,
          quality: 25,
        );
        uploadImage();
        Get.close(0);
        setState(() {});
      }
    }
  }

  getProfile() {
    RequestHelper.getProfile().then(
          (value) {
        EasyLoading.dismiss();
        if (value.isDone!) {
          Get.find<ProfileController>().imageProfile.value =
          value.data['image'];
          Get.find<ProfileController>().update();
        } else {
          ViewHelper.showErrorDialog("Please try again");
        }
      },
    );
  }

  void _clear() {
    setState(() {
      widget.pickImage = null;
      _croppedFile = null;
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
        .add(await http.MultipartFile.fromPath('image', compressFile!.path));
    print(request.url);
    print(request.files.map((e) => e.filename));
    request.send().then(
          (response) async {
        print(response.request);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getProfile();
          if (Get.find<ProfileController>().isUpdate.isFalse) {
            Get.find<ProfileController>().getProfile();
          }
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

  pickImageWithGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    widget.pickImage = File(pickedImage!.path);
  }

  pickImageWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    widget.pickImage = File(pickedImage!.path);
  }
}

class FriendDelete {
  FriendDelete({
    this.id,
    this.fromUser,
    this.toUser,
    this.accepted,
    this.remainTime,
  });

  int? id;
  int? fromUser;
  int? toUser;
  bool? accepted;
  String? remainTime;

  factory FriendDelete.fromJson(Map<String, dynamic> json) => FriendDelete(
    id: json["id"],
    fromUser: json["from_user"],
    toUser: json["to_user"],
    accepted: json["accepted"],
    remainTime: json["remain_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_user": fromUser,
    "to_user": toUser,
    "accepted": accepted,
    "remain_time": remainTime,
  };
}
