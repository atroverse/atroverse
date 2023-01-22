import 'dart:io';

import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:atroverse/Plugins/lib/src/widgets/audio_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../Controllers/CreateController.dart';
import '../Utils/CostumAppBarWidget.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({Key? key, required this.isEdit, this.id}) : super(key: key);
  bool isEdit = false;
  String? id = "";
  final controller = Get.put(CreateController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverPersistentHeader(
              delegate: CustomAppBar(
                  height: Get.height * .1,
                  title: "Create",
                  isBack: false,
                  isOnTap: false),
              pinned: false,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: Get.height * .1),
                height: Get.height * .3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      "assets/images/icon.png",
                      scale: Get.width * .005,
                    ),
                    Positioned.fill(
                      bottom: Get.height * .04,
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Re-create yourself",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * .225),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: Get.height * .1,
                      width: Get.width * .4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 3,
                                blurRadius: 12)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue.shade200)),
                          onPressed: () {
                            controller.isExplore.value = false;
                            showCreateModal(title: "Atroverse");
                          },
                          child: Image.asset(
                            "assets/images/a1.png",
                            scale: 10,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: Get.height * .1,
                      width: Get.width * .4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 3,
                                blurRadius: 12)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue.shade200)),
                          onPressed: () {
                            showCreateModal(title: "Will");
                          },
                          child: Image.asset(
                            "assets/images/w2.png",
                            scale: 10,
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
  }

  showCreateModal({String? title}) {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      enableDrag: false,
      isDismissible: false,
      animationCurve: Curves.easeIn,
      builder: (_) {
        return GetBuilder<CreateController>(
          dispose: (state) {
            controller.isEnd.value = false;
            controller.isExplore.value = false;
            controller.caption.clear();
            controller.question.clear();
            controller.answer.clear();
            // controller.isRecording.value = false;
            controller.file = File("");
          },
          builder: (controller) {
            return SizedBox(
              height: Get.height,
              width: Get.width,
              child: ListView(
                children: [
                  _appBarModal(title),
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  if (title == "Will") ...[
                    _buildCaption()
                  ] else ...[
                    _buildQuestion(),
                    SizedBox(
                      height: Get.height * .03,
                    ),
                    _buildAnswer(),
                  ],
                  SizedBox(
                    height: Get.height * .03,
                  ),
                  if (isEdit == false) ...[
                    _buildImage(),
                    if (controller.isEnd.isTrue) ...[
                      Padding(
                        padding:
                        EdgeInsets.only(left: Get.width * .15, top: 15),
                        child: AudioBubble(
                            isCreate: true,
                            list: [],
                            player: AudioPlayer(),
                            filepath: controller.audioFile.value,
                            isNetwork: false),
                      ),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: (controller.isEnd.isTrue)
                          ? Container()
                          : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * .08, vertical: 10),
                        child: SocialMediaRecorder(
                          recordIconBackGroundColor: Colors.white,
                          backGroundColor: Colors.white,
                          sendRequestFunction: (soundFile) {
                            controller.audioFile.value = soundFile.path;
                            controller.isEnd.value = true;
                            controller.isRecording.value = false;
                            controller.update();
                          },
                          encode: AudioEncoderType.AAC,
                        ),
                      ),
                    ),
                    if(title != 'Will')...{
                      // SizedBox(height: Get.height * .03),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: controller.isExplore.value,
                          onChanged: (value) {
                            controller.isExplore.value = value!;
                            controller.update();
                          },
                          title: const Text(
                            "Show in explore",
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    },
                    SizedBox(height: Get.height * .05),
                    WidgetHelper.softButton(
                        title: "Post",
                        color: Colors.blue,
                        onTap: () {
                          if (title != "Will") {
                            if (controller.question.text.isEmpty) {
                              ViewHelper.showErrorDialog(
                                  "Please write question");
                            } else if (controller.answer.text.isEmpty) {
                              ViewHelper.showErrorDialog("Please write answer");
                            } else if (controller.file!.existsSync() == false) {
                              ViewHelper.showErrorDialog("Please pick photo");
                            } else {
                              controller.requestCameraPermission(false);
                            }
                          } else {
                            if (controller.caption.text.isEmpty) {
                              ViewHelper.showErrorDialog(
                                  "Please write caption");
                            } else if (controller.isEnd.isFalse) {
                              ViewHelper.showErrorDialog("Please record voice");
                            } else if (controller.file!.existsSync() == false) {
                              ViewHelper.showErrorDialog("Please pick photo");
                            } else {
                              controller.requestCameraPermission(true);
                            }
                          }
                        }),
                  ] else if (isEdit == true) ...[
                    SizedBox(height: Get.height * .1),
                    WidgetHelper.softButton(
                        title: "Post",
                        color: Colors.blue,
                        onTap: () {
                          if (title != "Will") {
                            if (controller.question.text.isEmpty) {
                              ViewHelper.showErrorDialog(
                                  "Please write question");
                            } else if (controller.answer.text.isEmpty) {
                              ViewHelper.showErrorDialog("Please write answer");
                            } else {
                              controller.updateAtro(id);
                            }
                          } else {
                            if (controller.caption.text.isEmpty) {
                              ViewHelper.showErrorDialog(
                                  "Please write caption");
                            } else {
                              controller.updateWill(id);
                            }
                          }
                        })
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  _appBarModal(title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * .1),
      height: Get.height * .05,
      width: Get.width * .8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 12, spreadRadius: 3),
          ]),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () async {
                controller.path = "";
                controller.imagePath = "";
                controller.isRecording.value = false;
                Get.close(0);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title!,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  _buildQuestion() {
    return SizedBox(
      height: Get.height * .15,
      width: Get.width,
      child: KeyboardActions(
        config: controller.buildConfig(Get.context!, controller.nodeText1),
        child: WidgetHelper.input(
          focusNode: controller.nodeText1,
          title: "What is your story?",
          onChanged: (value) {},
          controller: controller.question,
          maxLine: null,
          minLine: 5,
          type: TextInputType.multiline,
        ),
      ),
    );
  }

  _buildAnswer() {
    return SizedBox(
      height: Get.height * .15,
      width: Get.width,
      child: KeyboardActions(
        config: controller.buildConfig(Get.context!, controller.nodeText2),
        child: WidgetHelper.input(
          focusNode: controller.nodeText2,
          title: "Result",
          onChanged: (value) {},
          controller: controller.answer,
          maxLine: null,
          minLine: 5,
          type: TextInputType.multiline,
        ),
      ),
    );
  }

  _buildCaption() {
    return SizedBox(
      height: Get.height * .3,
      width: Get.width,
      child: KeyboardActions(
        config: controller.buildConfig(Get.context!, controller.nodeText3),
        child: WidgetHelper.input(
          focusNode: controller.nodeText3,
          title: "Caption",
          controller: controller.caption,
          onChanged: (value) {},
          maxLine: null,
          minLine: 10,
          type: TextInputType.multiline,
        ),
      ),
    );
  }

  //
  // _buildVoice() {
  //   return GetBuilder<CreateController>(builder: (controller) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         AnimatedSwitcher(
  //           duration: const Duration(milliseconds: 200),
  //           child: controller.isRecording.isTrue
  //               ? AudioWaveforms(
  //                   enableGesture: true,
  //                   size:
  //                       Size(MediaQuery.of(Get.context!).size.width * .84, 50),
  //                   recorderController: controller.recorderController,
  //                   waveStyle: const WaveStyle(
  //                     waveColor: Colors.red,
  //                     extendWaveform: true,
  //                     showMiddleLine: false,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12.0),
  //                     color: const Color(0xFF1E1B26),
  //                   ),
  //                   padding: const EdgeInsets.only(left: 18),
  //                   margin: const EdgeInsets.symmetric(horizontal: 15),
  //                 )
  //               : Container(),
  //         ),
  //         const SizedBox(width: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             IconButton(
  //               onPressed: controller.startOrStopRecording,
  //               icon: Icon(
  //                   controller.isRecording.isTrue ? Icons.stop : Icons.mic),
  //               color: Colors.blue,
  //               iconSize: 28,
  //             ),
  //             IconButton(
  //               onPressed: controller.refreshWave,
  //               icon: const Icon(
  //                 Icons.refresh,
  //                 color: Colors.red,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     );
  //   });
  // }

  _buildImage() {
    return Container(
      height: Get.height * .2,
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: TextButton(
        style: ButtonStyle(
            overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.blue)),
        onPressed: () {
          controller.getGallery();
          print(controller.file);
        },
        child: (controller.file != null && controller.file!.existsSync())
            ? Image.file(
          controller.file!,
          fit: BoxFit.cover,
        )
            : const Center(
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
