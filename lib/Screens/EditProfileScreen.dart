import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../Utils/CostumAppBarWidget.dart';
import '../Utils/ProfileAvatar.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: Get.height,
          width: Get.width,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomAppBar(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.updateProfile();
                      }
                    },
                    height: Get.height * .1,
                    title: "Edit Profile",
                    isBack: true,
                    isOnTap: true),
                pinned: false,
                floating: true,
              ),
              SliverToBoxAdapter(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.formKey,
                  child: GetBuilder<ProfileController>(builder: (controller) {
                    return Column(
                      children: [
                        _buildImageUploader(),
                        _buildBio(),
                        SizedBox(height: Get.height * .01),
                        _buildName(),
                        SizedBox(height: Get.height * .01),
                        _buildLName(),
                        SizedBox(height: Get.height * .01),
                        _buildUsername(),
                        SizedBox(height: Get.height * .01),
                        _buildDateTinBtn(),
                        SizedBox(height: Get.height * .01),
                        _buildRow(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * .05, vertical: 10),
                          child: GetBuilder<ProfileController>(builder: (c) {
                            return CSCPicker(
                              showCities: true,
                              showStates: true,
                              countryDropdownLabel:
                              controller.country.isEmpty == ""
                                  ? ""
                                  : controller.country.value,
                              stateDropdownLabel:
                              controller.state.isEmpty == ""
                                  ? ""
                                  :  controller.state.value,
                              cityDropdownLabel:
                              controller.city.isEmpty == ""
                                  ? ""
                                  : controller.city.value,
                              onCountryChanged: (value) {
                                controller.country.value = value;
                                controller.update();
                              },
                              onStateChanged: (value) {
                                controller.state.value = value.toString();
                                controller.update();
                              },
                              onCityChanged: (value) {
                                controller.city.value = value.toString();
                                controller.update();
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        WidgetHelper.softButton(
                            onTap: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.updateProfile();
                              }
                            },
                            title: "Update Profile"),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildImageUploader() {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: Get.height * .28,
          width: Get.width * .6,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: Get.height * .21,
                  width: Get.width * .6,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 3,
                          blurRadius: 15)
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        child: GestureDetector(
                          onTap: () {
                            _showModal();
                          },
                          child: (controller.profile.image != null)
                              ? ProfileAvatar2(
                            path: controller.profile.image.toString(),
                          )
                              : CircleAvatar(
                              radius: Get.width * .2,
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: Colors.grey,
                                size: Get.width * .1,
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showModal();
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: Get.height * .06,
                            width: Get.width * .3,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 3,
                                    blurRadius: 15)
                              ],
                              shape: BoxShape.circle,
                              color: Colors.blue.shade200,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.linked_camera_outlined,
                                color: Colors.black,
                                size: Get.width * .06,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _showModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return SizedBox(
          height: Get.height * .2,
          width: Get.width,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: AppBar(
                  leading: Container(),
                  title: const Text(
                    "Choose Image",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  elevation: 0,
                  centerTitle: true,
                ),
              ),
              SizedBox(
                height: Get.height * .025,
              ),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.close(0);
                            controller.pickImageWithGallery();
                          },
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.close(0);
                            controller.pickImageWithCamera();
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
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

  _buildName() {
    return WidgetHelper.input(
        title: "Name",
        controller: controller.fNameInput,
        onChanged: (value) {},
        type: TextInputType.text,
        validate: (value) {
          if (value!.isEmpty) {
            return "please enter name";
          }
        });
  }

  _buildLName() {
    return WidgetHelper.input(
        title: "Family name",
        controller: controller.lNameInput,
        onChanged: (value) {},
        type: TextInputType.text,
        validate: (value) {
          if (value!.isEmpty) {
            return "please enter Family name";
          }
        });
  }

  _buildUsername() {
    return WidgetHelper.input(
        title: "User name",
        hint: "type in english",
        controller: controller.uNameInput,
        onChanged: (value) {},
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
        ],
        type: TextInputType.text,
        validate: (value) {
          if (value!.isEmpty) {
            return "please enter Username";
          }
        });
  }

  _buildBio() {
    return WidgetHelper.input(
      title: "Bio",
      maxLength: 150,
      controller: controller.biotInput,
      maxLine: 4,
      textInputAction: TextInputAction.newline,
      onChanged: (value) {},
      type: TextInputType.multiline,
      validate: (value) {
        if (value!.isEmpty) {
          return "please enter Bio";
        }
      },
    );
  }

  _buildDateTime() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          height: Get.height * .5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  )
                ],
              ),
              CalendarDatePicker2(
                onValueChanged: (value) {
                  controller.selectedDate = value[0]!;
                  controller.update();
                },
                config: CalendarDatePicker2Config(
                    lastDate: DateTime(2010, 01, 01),
                    calendarType: CalendarDatePicker2Type.single),
                initialValue: [],
              ),
            ],
          ),
        );
      },
    );
  }

  _buildDateTinBtn() {
    return GetBuilder<ProfileController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          if (FocusScope.of(Get.context!).hasFocus) {
            FocusScope.of(Get.context!).unfocus();
          }
          _buildDateTime();
        },
        child: Container(
          height: Get.height * .06,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
          padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              if (controller.profile.birthdate != null) ...[
                Text(
                  "BirthDate:    ${controller.selectedDate.year}/${controller.selectedDate.month}/${controller.selectedDate.day}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )
              ] else if (controller.selectedDate == null) ...[
                const Text(
                  "Select BirthDate",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ] else ...[
                Text(
                  "BirthDate:    ${controller.selectedDate.year}/${controller.selectedDate.month}/${controller.selectedDate.day}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  _buildRow() {
    return Container(
      height: Get.height * .06,
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: Get.height * .06,
            width: Get.width * .44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () {
                controller.changeEmail();
              },
              child: const Center(
                child: Text(
                  "Change Email",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
          Container(
            height: Get.height * .06,
            width: Get.width * .44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () {
                _showChangePassModal();
              },
              child: const Center(
                child: Text(
                  "Change password",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showChangePassModal() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          height: Get.height * .4,
          width: Get.width,
          color: Colors.white,
          margin: MediaQuery.of(Get.context!).viewInsets,
          child: GetBuilder<ProfileController>(builder: (controller) {
            return Column(
              children: [
                const SizedBox(height: 15),
                InputPassword(
                  show: false.obs,
                  title: "Old password",
                  onChanged: (v) {},
                  type: TextInputType.text,
                  controller: controller.oldPass,
                ),
                const SizedBox(height: 15),
                InputPassword(
                  show: false.obs,
                  title: "New password",
                  onChanged: (v) {},
                  type: TextInputType.text,
                  controller: controller.newPass,
                ),
                const SizedBox(height: 15),
                InputPassword(
                  show: false.obs,
                  controller: controller.reNewPass,
                  title: "Confirm password",
                  onChanged: (v) {},
                  type: TextInputType.text,
                ),
                const Spacer(),
                WidgetHelper.softButton(
                  title: "Change",
                  onTap: () {
                    if (controller.oldPass.text.isEmpty) {
                      ViewHelper.showErrorDialog("Please enter old password");
                    } else if (controller.newPass.text.isEmpty) {
                      ViewHelper.showErrorDialog("Please enter new password");
                    } else if (controller.reNewPass.text.isEmpty) {
                      ViewHelper.showErrorDialog(
                          "Please enter confirm password");
                    } else {
                      if (controller.reNewPass.text ==
                          controller.newPass.text) {
                        controller.changePassWord();
                      } else {
                        ViewHelper.showErrorDialog(
                            "Confirm password incorrect");
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            );
          }),
        );
      },
    );
  }

// _showChangeEmailModal() {
//   return showCupertinoModalBottomSheet(
//     context: Get.context!,
//     barrierColor: Colors.black38,
//     builder: (_) {
//       return Container(
//         height: Get.height * .3,
//         width: Get.width,
//         color: Colors.white,
//         margin: MediaQuery
//             .of(Get.context!)
//             .viewInsets,
//         child: Column(
//           children: [
//             const SizedBox(height: 15),
//             WidgetHelper.input(
//               show: true,
//               title: "New Email",
//               onChanged: (v) {},
//               type: TextInputType.emailAddress,
//               controller: controller.newEmail,
//             ),
//             const SizedBox(height: 15),
//             WidgetHelper.input(
//               show: true,
//               controller: controller.emailCode,
//               title: "Verify code",
//               onChanged: (v) {},
//               type: TextInputType.text,
//             ),
//             const Spacer(),
//             WidgetHelper.softButton(
//               title: "Change",
//               onTap: () {
//                 if (controller.newEmail.text.isEmpty) {
//                   ViewHelper.showErrorDialog("Please enter old password");
//                 } else if (controller.emailCode.text.isEmpty) {
//                   ViewHelper.showErrorDialog("Please enter new password");
//                 } else {
//                   controller.changeEmailVerify(
//                       controller.newEmail.text, controller.emailCode.text);
//                 }
//               },
//             ),
//             const SizedBox(
//               height: 25,
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
}
