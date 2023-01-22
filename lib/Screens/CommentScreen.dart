import 'package:atroverse/Controllers/CommentController.dart';
import 'package:atroverse/Controllers/CreateController.dart';
import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Models/FriendProfileModel.dart';
import 'package:atroverse/Models/WillModel.dart';
import 'package:atroverse/Plugins/lib/src/widgets/audio_bubble.dart';
import 'package:atroverse/Screens/CreateScreen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:swipe_to/swipe_to.dart';

import '../Controllers/AtroController.dart';
import '../Controllers/MainController.dart';
import '../Helpers/PrefHelpers.dart';
import '../Helpers/ViewHelpers.dart';
import '../Helpers/WidgetHelper.dart';
import '../Models/AtroModel.dart';
import '../Utils/CostumAppBarWidget.dart';
import '../Utils/StreamAudioPostWidget.dart';
import 'FriendProfileScreen.dart';

class CommentScreen extends StatefulWidget {
  var atroModel;
  AtroController? atroController;
  bool? checked = true;
  int? archiveId;

  CommentScreen(
      {this.atroModel, this.atroController, this.checked, this.archiveId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentController = Get.put(CommentController());

  final profile = Get.find<ProfileController>();

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  create(
      {String? comment,
        String? model_name,
        String? model_id,
        String? app_name,
        String? mention_id,
        String? filePath,
        RxBool? sending,
        String? parent_id}) {
    ViewHelper.showLoading();
    Future.delayed(2.seconds).then((value) async {
      print(filePath);
      await createComment(
        app_name: app_name,
        comment: comment,
        filePath: filePath,
        model_id: model_id,
        sending: sending,
        model_name: model_name,
        mention_id: mention_id,
        parent_id: parent_id,
      );
    });
  }

  // commentController.replyComment is Comment
  // ? commentController.replyComment?.user?.profile?.userName.toString()
  //     : "",

  createComment(
      {String? comment,
        String? model_name,
        String? model_id,
        String? app_name,
        String? filePath,
        String? mention_id,
        RxBool? sending,
        String? parent_id}) async {
    commentController.isType.value = false;
    print(filePath);
    print(
        "http://162.254.32.119/api/comments/create/?model_name=$model_name&model_id=$model_id&app_name=$app_name&parent_id=${parent_id == null || parent_id == "null" ? "" : parent_id}");
    var postUri = Uri.parse(
        "http://162.254.32.119/api/comments/create/?model_name=$model_name&model_id=$model_id&app_name=$app_name&parent_id=${parent_id == null || parent_id == "null" ? "" : parent_id}");
    var request = http.MultipartRequest("POST", postUri);
    request.fields["content"] = comment.toString();
    request.fields["mention_id"] = mention_id.toString();
    if (filePath != "") {
      request.files.add(
        await http.MultipartFile.fromPath(
          'sound',
          filePath.toString(),
        ),
      );
    }
    print(request.files);
    request.headers
        .addAll({"Authorization": "Token ${await PrefHelpers.getToken()}"});
    request.send().then(
          (response) async {
        EasyLoading.dismiss();
        final respStr = await response.stream.bytesToString();
        print(respStr);
        if (response.statusCode == 200 || response.statusCode == 201) {
          get();

          commentController.commentInput.clear();
          filePath = "";
          commentController.replyComment = Comment();
          commentController.imagePath = "";
          commentController.isRecording.value = false;
          commentController.isEnd.value = false;
          commentController.update();
        } else {
          ViewHelper.showErrorDialog("please try again");
        }
      },
    );
  }

  get() {
    if (widget.atroModel is AtroModel || widget.atroModel is Atroe) {
      Get.find<AtroController>().getAtroDetail(widget.atroModel.id.toString());
    }
    commentController.getCommentList(
      modelName: (widget.atroModel is AtroModel)
          ? "atro"
          : widget.atroModel is Atroe
          ? "atro"
          : (widget.atroModel is WillsModel)
          ? "will"
          : "",
      modelId: (widget.atroModel is AtroModel)
          ? widget.atroModel.id.toString()
          : (widget.atroModel is WillModel)
          ? widget.atroModel.id.toString()
          : widget.atroModel is Atroe
          ? widget.atroModel.id.toString()
          : (widget.atroModel is WillsModel)
          ? widget.atroModel.id.toString()
          : "",
      appName: (widget.atroModel is AtroModel)
          ? "atro"
          : widget.atroModel is Atroe
          ? "atro"
          : (widget.atroModel is WillsModel)
          ? "wills"
          : "wills",
    );
    // commentController.scrollControllerList.position.jumpTo(commentController.scrollControllerList.position.maxScrollExtent);
  }

  onPop() {
    widget.atroController?.getAtroListOnRef();
    commentController.replyComment = Comment();
    if (widget.atroModel is WillModel) {
      widget.atroModel.pause();
      Get.back();
    } else if (widget.atroModel is AtroModel) {
      widget.atroModel.pause();
      Get.back();
    } else if (widget.atroModel is Atroe) {
      widget.atroModel.pause();
      Get.back();
    } else if (widget.atroModel is WillsModel) {
      widget.atroModel.pause();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => onPop(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: _buildBottomNav(),
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: commentController.scrollControllerList,
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomAppBar2(
                      height: Get.height * .1,
                      onTap: () {
                        onPop();
                      },
                      title: "Comments",
                      isBack: true,
                      isOnTap: false),
                  pinned: true,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (widget.atroModel is AtroModel) ...[
                        _buildContainer(widget.atroModel!),
                        buildCommentListModal(
                            commentController.commentList, widget.atroModel!),
                      ] else if (widget.atroModel is WillModel) ...[
                        _buildContainer(widget.atroModel),
                        buildCommentListModal(
                            commentController.commentList, widget.atroModel!),
                      ] else if (widget.atroModel is Atroe) ...[
                        _buildContainer(widget.atroModel!),
                        buildCommentListModal(
                            commentController.commentList, widget.atroModel!),
                      ] else if (widget.atroModel is WillsModel) ...[
                        _buildContainer(widget.atroModel!),
                        buildCommentListModal(
                            commentController.commentList, widget.atroModel!),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildContainer(var item) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(
        minHeight: Get.height * .5,
      ),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GetBuilder<AtroController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * .06,
              width: Get.width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ExpandTapWidget(
                        tapPadding: const EdgeInsets.all(50),
                        onTap: () {
                          Get.find<ProfileController>().getFriendProfile(() {
                            Get.to(FriendProfileScreen());
                          }, item.profileInfo?.id.toString());
                        },
                        child: Row(
                          children: [
                            (item.profileInfo!.image != null)
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  item.profileInfo!.image.toString()),
                            )
                                : const CircleAvatar(
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * .03,
                            ),
                            Text(
                              item.profileInfo!.userName.toString(),
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            (Get.find<AtroController>().atro != null)
                                ? Get.find<AtroController>().atro!.created!
                                : (item is WillModel || item is WillsModel)
                                ? item.created.toString()
                                : "",
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ExpandTapWidget(
                            onTap: () {
                              _buildShowMoreModal(item);
                            },
                            tapPadding: const EdgeInsets.all(60),
                            child: const Icon(Icons.more_vert_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Get.width,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: (item is AtroModel)
                            ? item.image.toString()
                            : (item is WillModel || item is WillsModel)
                            ? item.file!
                            : (item is Atroe)
                            ? item.image
                            : item,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            enabled: true,
                            child: Container(
                              height: Get.height * .3,
                              width: Get.width,
                              color: Colors.grey.shade200,
                            ),
                            baseColor: Colors.grey.shade200,
                            highlightColor: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (item is AtroModel && item.sound == null ||
                item is WillModel && item.sound == null ||
                item is WillsModel && item.sound == null)
                ? const SizedBox()
                : SizedBox(
              width: Get.width,
              height: Get.height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<ButtonState>(
                    valueListenable: item.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 40.0,
                              height: Get.height * .1,
                              child: Lottie.asset(
                                  "assets/anims/loading.json"));
                        case ButtonState.paused:
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            iconSize: 32.0,
                            color: Colors.black,
                            onPressed: () {
                              commentController.commentList
                                  .forEach((element) {
                                element.player.stop();
                                element.replies.forEach((element) {
                                  element.player.stop();
                                });
                              });
                              item.play();
                            },
                          );
                        case ButtonState.playing:
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            iconSize: 32.0,
                            color: Colors.black,
                            onPressed: item.pause,
                          );
                      }
                    },
                  ),
                  ValueListenableBuilder<ProgressBarState>(
                    valueListenable: item.progressNotifier,
                    builder: (_, value, __) {
                      return SizedBox(
                        height: Get.height * .08,
                        width: Get.width * .75,
                        child: ProgressBar(
                          thumbRadius: 7,
                          barHeight: 3,
                          onDragUpdate: (value) {},
                          baseBarColor: Colors.grey.withOpacity(0.7),
                          progressBarColor: Colors.blue,
                          bufferedBarColor: Colors.blue.shade100,
                          thumbColor: Colors.black,
                          timeLabelLocation: TimeLabelLocation.sides,
                          progress: value.current,
                          buffered: value.buffered,
                          total: value.total,
                          onSeek: item.seek,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width * .03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  (item is AtroModel || item is Atroe)
                      ? ReadMoreText(
                    controller.atro!.question! +
                        "\n"
                            "${controller.atro?.answer}",
                    trimLines: 5000,
                    trimLength: 500000,
                    preDataTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    textDirection: TextDirection.ltr,
                    trimCollapsedText: 'See more',
                    trimExpandedText: '',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black),
                    moreStyle:
                    const TextStyle(fontSize: 10, color: Colors.red),
                  )
                      : (item is WillModel || item is WillsModel)
                      ? ReadMoreText(
                    item.caption.toString(),
                    trimLines: 5000,
                    trimLength: 500000,
                    preDataTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    textDirection: TextDirection.ltr,
                    trimCollapsedText: 'See more',
                    trimExpandedText: '',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black),
                    moreStyle: const TextStyle(
                        fontSize: 10, color: Colors.red),
                  )
                      : const SizedBox(),
                  const Divider(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  _showReportDialog(id, model) {
    return showCupertinoModalBottomSheet(
        context: Get.context!,
        builder: (_) {
          return Container(
            height: Get.height * .15,
            width: Get.width * .8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "do you want to report this post?",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.close(0);
                      },
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.find<MainController>().report(id, model);
                        Get.close(0);
                      },
                      color: Colors.red,
                      child: const Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _buildTextField(String? id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GetBuilder<AtroController>(
        builder: (c) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                ),
                top: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.atroModel?.profileInfo!.image == null
                      ? const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage:
                    NetworkImage(profile.profile.image.toString()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, top: 10, right: 50),
                  child: WidgetHelper.inputComment(
                      title: "Type Comment",
                      onChanged: (value) {
                        commentController.isType.value = false;
                        if (value.isEmpty) {
                          commentController.isType.value = false;
                          commentController.update();
                        } else {
                          commentController.isType.value = true;
                          commentController.update();
                        }
                      },
                      controller: commentController.commentInput,
                      maxLine: 5,
                      maxLength: null,
                      type: TextInputType.multiline),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () async {
                        FocusScope.of(Get.context!).unfocus();
                        create(
                            filePath: "",
                            model_name: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? "atro"
                                : "will",
                            model_id: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? widget.atroModel.id.toString()
                                : (widget.atroModel is WillModel ||
                                widget.atroModel is WillsModel)
                                ? widget.atroModel.id.toString()
                                : "1",
                            app_name: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? "atro"
                                : "wills",
                            parent_id:
                            commentController.replyComment is Comment &&
                                commentController.replyComment?.parent !=
                                    null
                                ? commentController.replyComment?.parent
                                .toString()
                                : commentController
                                .replyComment?.id
                                .toString(),
                            mention_id:
                            commentController.replyComment is Comment
                                ? commentController
                                .replyComment?.user?.profile?.userName
                                .toString()
                                : "",
                            comment: commentController.commentInput.text);
                        commentController.commentInput.clear();
                        // commentController.replyComment = Comment();
                        commentController.isReply.value = false;
                        commentController.update();
                      },
                      icon: commentController.isType.isTrue
                          ? const Icon(
                        Icons.send,
                        color: Colors.blue,
                      )
                          : Container(),
                    ),
                  ),
                ),
                (commentController.isType.isTrue)
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SocialMediaRecorder(
                      recordIconBackGroundColor: Colors.white,
                      backGroundColor: Colors.white,
                      sendRequestFunction: (soundFile) {
                        commentController.audioFile = soundFile.path;
                        commentController.isEnd.value = true;
                        commentController.isRecording.value = false;
                        create(
                            filePath: soundFile.absolute.path,
                            model_name: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? "atro"
                                : "will",
                            model_id: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? widget.atroModel.id.toString()
                                : (widget.atroModel is WillModel ||
                                widget.atroModel is WillsModel)
                                ? widget.atroModel.id.toString()
                                : "1",
                            app_name: (widget.atroModel is AtroModel ||
                                widget.atroModel is Atroe)
                                ? "atro"
                                : "wills",
                            parent_id:
                            commentController.replyComment is Comment &&
                                commentController.replyComment?.parent !=
                                    null
                                ? commentController.replyComment?.parent
                                .toString()
                                : commentController.replyComment?.id
                                .toString(),
                            mention_id:
                            commentController.replyComment is Comment
                                ? commentController.replyComment?.user
                                ?.profile?.userName
                                .toString()
                                : "",
                            comment: "voice");
                        commentController.isReply.value = false;
                        commentController.update();
                      },
                      encode: AudioEncoderType.AAC,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  buildCommentListModal(RxList<Comment> cmList, var atro) {
    return GetBuilder<AtroController>(
      builder: (c) {
        return Column(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: Get.height * .1),
              width: Get.width,
              child: SingleChildScrollView(
                child: _buildCommentList(
                  cmList,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildCommentList(RxList<Comment> list) {
    return Obx(
          () {
        return Column(
          children: list.reversed
              .map(
                (e) => buildComment(e, list, list.indexOf(e)),
          )
              .toList(),
        );
      },
    );
    return Obx(() {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = list[index];
          return buildComment(comment, list, index);
        },
      );
    });
  }

  _buildCommentList2(RxList<Comment> list, id, index2) {
    return Obx(
          () {
        return Column(
          children: list
              .map(
                (e) => _buildReplyComment(list, e, list.indexOf(e), id, index2),
          )
              .whereType<Widget>()
              .toList(),
        );
      },
    );
    return Obx(() {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        // reverse: true,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = list[index];
          return _buildReplyComment(list, list[index], index, id, index2);
        },
      );
    });
  }

  Widget buildComment(Comment comment, List<Comment> list, index) {
    return GetBuilder<CommentController>(
      builder: (c) {
        return Column(
          children: [
            AnimationConfiguration.staggeredList(
              position: list.indexOf(comment),
              duration: const Duration(milliseconds: 100),
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    comment.isDelete.value = false;
                    c.update();
                  },
                  onLongPress: () {
                    comment.isDelete.value = true;
                    c.update();
                  },
                  child: SwipeTo(
                    onRightSwipe: () {
                      c.commentInput.clear();
                      c.isReply.value = false;
                      c.replyComment = comment;
                      c.isReply.value = true;
                      c.update();
                    },
                    iconOnLeftSwipe: Icons.replay,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        color: (comment.isDelete.isFalse)
                            ? Colors.transparent
                            : Colors.blue.shade200,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // const SizedBox(
                                //   width: 16.0,
                                // ),
                                (comment.isDelete.isFalse)
                                    ? Container()
                                    : IconButton(
                                    onPressed: () {
                                      c.deleteCm(
                                        id: comment.id.toString(),
                                        modelName:
                                        (widget.atroModel is AtroModel)
                                            ? "atro"
                                            : "will",
                                        modelId: (widget.atroModel
                                        is AtroModel)
                                            ? widget.atroModel.id.toString()
                                            : (widget.atroModel
                                        is WillModel)
                                            ? widget.atroModel.id
                                            .toString()
                                            : "1",
                                        appName:
                                        (widget.atroModel is AtroModel)
                                            ? "atro"
                                            : "wills",
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.all(Get.width * .01),
                                          child: Text(
                                            comment.user!.profile!.userName
                                                .toString(),
                                            textDirection: TextDirection.ltr,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        (comment.content != "voice")
                                            ? Padding(
                                          padding: EdgeInsets.all(
                                              Get.width * .01),
                                          child: AutoSizeText(
                                            comment.content!,
                                            maxLines: null,
                                            maxFontSize: 24,
                                            minFontSize: 6,
                                            textDirection:
                                            TextDirection.ltr,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                            : SizedBox(
                                          height: Get.height * .08,
                                          child: Directionality(
                                              textDirection:
                                              TextDirection.ltr,
                                              child: AudioBubble(
                                                isCreate: false,
                                                list: list,
                                                model: widget.atroModel,
                                                player: comment.player,
                                                filepath: comment.sound
                                                    .toString(),
                                                isNetwork: true,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ExpandTapWidget(
                                  tapPadding: const EdgeInsets.all(5),
                                  onTap: () {
                                    Get.find<ProfileController>()
                                        .getFriendProfile(() {
                                      Get.to(FriendProfileScreen());
                                    }, comment.user?.id.toString());
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      RequestHelper.BaseUrl +
                                          comment.user!.profile!.image
                                              .toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    comment.posted.toString().substring(11, 17),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: Get.width * .05,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        comment.showComments.value =
                                        !comment.showComments.value;
                                        commentController.page.value = 1;
                                        if (comment.showComments.isTrue) {
                                          comment.replies.clear();
                                          comment.loading.value = false;
                                          commentController.getReply(
                                              loading2: comment.loading2,
                                              loading: comment.loading,
                                              message: comment.message,
                                              index: index,
                                              id: comment.id.toString(),
                                              page: commentController.page.value
                                                  .toString());
                                        }
                                      },
                                      // tapPadding: const EdgeInsets.all(40),
                                      child: comment.showComments.isTrue
                                          ? RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Hide ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                            TextSpan(
                                              text: comment.replyCount
                                                  ?.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            const TextSpan(
                                              text: " Replies",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      )
                                          : RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "View ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                            TextSpan(
                                              text: comment.replyCount
                                                  ?.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            const TextSpan(
                                              text: " Replies",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpandTapWidget(
                                      tapPadding: const EdgeInsets.all(50),
                                      onTap: () {
                                        c.commentInput.clear();
                                        commentController.isReply.value = false;
                                        commentController.replyComment =
                                            comment;
                                        commentController.isReply.value = true;
                                        commentController.update();
                                      },
                                      child: const Text(
                                        "Reply",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * .1,
                                  ),
                                ],
                              );
                            }),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
                  () => AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                duration: const Duration(milliseconds: 100),
                child: comment.showComments.isTrue
                    ? (comment.loading.isFalse)
                    ? const CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 2,
                )
                    : _buildCommentList2(
                    comment.replies, comment.id, list.indexOf(comment))
                    : Material(
                  child: Container(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildReplyComment(
      List<Comment> replies, Comment comment, int index, id, index2) {
    return GetBuilder<CommentController>(builder: (c) {
      return Padding(
        padding: const EdgeInsets.only(left: 50),
        child: AnimationConfiguration.staggeredList(
          position: replies.indexOf(comment),
          duration: const Duration(milliseconds: 100),
          child: FadeInAnimation(
            child: GestureDetector(
              onTap: () {
                comment.isDelete.value = false;
                c.update();
              },
              onLongPress: () {
                comment.isDelete.value = true;
                c.update();
              },
              child: SwipeTo(
                onRightSwipe: () {
                  c.commentInput.clear();
                  c.isReply.value = false;
                  c.replyComment = comment;
                  c.isReply.value = true;
                  c.update();
                },
                iconOnLeftSwipe: Icons.replay,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    color: (comment.isDelete.isFalse)
                        ? Colors.transparent
                        : Colors.blue.shade200,
                    // height: (replies.indexOf(comment) == replies.length - 1)
                    //     ? Get.height / 7
                    //     : Get.height / 8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            (comment.isDelete.isFalse)
                                ? Container()
                                : IconButton(
                                onPressed: () {
                                  c.deleteCm(
                                    id: comment.id.toString(),
                                    modelName:
                                    (widget.atroModel is AtroModel)
                                        ? "atro"
                                        : "will",
                                    modelId: (widget.atroModel is AtroModel)
                                        ? widget.atroModel.id.toString()
                                        : (widget.atroModel is WillModel)
                                        ? widget.atroModel.id.toString()
                                        : "1",
                                    appName: (widget.atroModel is AtroModel)
                                        ? "atro"
                                        : "wills",
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(Get.width * .005),
                                      child: Text(
                                        comment.user!.profile!.userName
                                            .toString(),
                                        textDirection: TextDirection.ltr,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    (comment.content != "voice")
                                        ? Padding(
                                      padding: EdgeInsets.all(
                                          Get.width * .005),
                                      child: Text.rich(
                                          textDirection:
                                          TextDirection.ltr,
                                          TextSpan(children: [
                                            TextSpan(
                                              text: (comment.mention_id ==
                                                  null)
                                                  ? ""
                                                  : "${comment.mention_id.toString()}   ",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: comment.content
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            )
                                          ])),
                                    )
                                        : SizedBox(
                                      height: Get.height * .08,
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: AudioBubble(
                                          isCreate: false,
                                          model: widget.atroModel,
                                          list: replies,
                                          player: comment.player,
                                          filepath:
                                          comment.sound.toString(),
                                          isNetwork: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: ExpandTapWidget(
                                tapPadding: const EdgeInsets.all(5),
                                onTap: () {
                                  Get.find<ProfileController>()
                                      .getFriendProfile(() {
                                    Get.to(FriendProfileScreen());
                                  }, comment.user?.id.toString());
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    RequestHelper.BaseUrl +
                                        comment.user!.profile!.image.toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                comment.posted.toString().substring(11, 17),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              SizedBox(
                                width: Get.width * .05,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpandTapWidget(
                                  tapPadding: const EdgeInsets.all(50),
                                  onTap: () {
                                    c.commentInput.clear();
                                    commentController.isReply.value = false;
                                    commentController.replyComment = comment;
                                    commentController.isReply.value = true;
                                    commentController.update();
                                  },
                                  child: const Text(
                                    "Reply",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * .05,
                              ),
                            ],
                          ),
                        ),
                        if (replies.indexOf(comment) == replies.length - 1)
                          Column(
                            children: [
                              SizedBox(
                                height: Get.width * .05,
                              ),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 1,
                                      width: Get.width * .2,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (comment.message.value !=
                                            "Hide replies") {
                                          comment.loading2.value = false;
                                          commentController.page += 1;
                                          print(commentController
                                              .commentList[index2]
                                              .showComments
                                              .value);
                                          commentController.getReply(
                                              index: index2,
                                              message: comment.message,
                                              loading2: comment.loading2,
                                              loading: comment.loading,
                                              page: commentController.page.value
                                                  .toString(),
                                              id: id.toString());
                                          Future.delayed(8.seconds)
                                              .then((value) {
                                            comment.loading2.value = true;
                                          });
                                        } else {
                                          print(commentController
                                              .commentList[index2]
                                              .showComments
                                              .value);
                                          comment.loading2.value = true;
                                          comment.loading.value = false;
                                          commentController.commentList[index2]
                                              .showComments.value = false;
                                          commentController.update();
                                        }
                                      },
                                      child: (comment.loading2.isFalse)
                                          ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.grey,
                                            strokeWidth: 2,
                                          ))
                                          : Text(
                                        comment.message.value,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 1,
                                      width: Get.width * .2,
                                      color: Colors.grey,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          )
                        else
                          const Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _buildShowMoreModal(var item) {
    print(item.archived);
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
            height: (item.profileInfo!.userName ==
                Get.find<ProfileController>().profile.userName)
                ? Get.height * .4
                : Get.height * .2,
            width: Get.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (item.profileInfo!.userName ==
                    Get.find<ProfileController>().profile.userName)
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (item is AtroModel) {
                          Get.find<CreateController>().question.text =
                          Get.find<AtroController>().atro!.question!;
                          Get.find<CreateController>().answer.text =
                          Get.find<AtroController>().atro!.answer!;
                          Get.find<CreateController>().update();
                        } else if (item is WillModel) {
                          Get.find<CreateController>().caption.text =
                          item.caption!;
                          Get.find<CreateController>().update();
                          profile.getWillList();
                        }
                        CreateScreen(
                          id: item is AtroModel || item is Atroe
                              ? item.id.toString()
                              : (item is WillModel || item is WillsModel)
                              ? item.id.toString()
                              : 0.toString(),
                          isEdit: true,
                        ).showCreateModal(
                            title:
                            item is AtroModel ? "Atroverse" : "Will");
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showDelete(item);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (item is AtroModel) {
                          Get.back();
                          if (Get.find<AtroController>().atro!.saved ==
                              true) {
                            profile.deleteMark(
                                widget.archiveId.toString(),
                                item.id.toString());
                          } else {
                            Get.back();
                            profile.createMark(
                                item.id.toString(), "atro");
                          }
                        } else if (item is WillModel) {
                          Get.back();
                          if (item.saved == true) {
                            profile.deleteMark(
                                widget.archiveId.toString(),
                                item.id.toString());
                          } else {
                            Get.back();
                            profile.createMark(
                                item.id.toString(), "will");
                          }
                        }
                      },
                      child: Text(
                        (item is WillModel && item.saved == true)
                            ? "UnSave"
                            : (item is AtroModel &&
                            Get.find<AtroController>()
                                .atro!
                                .saved ==
                                true)
                            ? "UnSave"
                            : "Save",
                        style: const TextStyle(color: Colors.black),
                      ),
                      // child: Card(
                      //   shadowColor: Colors.grey.shade200,
                      //   elevation: 5,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(25.0),
                      //     child: Icon(
                      //       (item is WillModel && item.archived == true)
                      //           ? Icons.unarchive_outlined
                      //           : (item is AtroModel &&
                      //                   Get.find<AtroController>().atro!.archived ==
                      //                       true)
                      //               ? Icons.unarchive_outlined
                      //               : Icons.archive_outlined,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (Get.find<AtroController>().atro?.status ==
                            "public") {
                          Get.find<AtroController>()
                              .updateAtro(item.id.toString(), "private");
                        } else if (Get.find<AtroController>()
                            .atro
                            ?.status ==
                            "private") {
                          Get.find<AtroController>()
                              .updateAtro(item.id.toString(), "public");
                        }
                        Get.find<CreateController>().update();
                      },
                      child: Text(
                        (Get.find<AtroController>().atro?.status ==
                            "public")
                            ? "Hide from explore"
                            : "Show in explore",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (item is AtroModel) {
                          Get.back();
                          if (Get.find<AtroController>().atro!.archived ==
                              true) {
                            profile.deleteArchive(
                                widget.archiveId.toString());
                          } else {
                            profile.createArchive(
                                item.id.toString(), "atro");
                          }
                        } else if (item is WillModel) {
                          Get.back();
                          if (item.archived == true) {
                            profile.deleteArchive(
                                widget.archiveId.toString());
                          } else {
                            profile.createArchive(
                                item.id.toString(), "will");
                          }
                        }
                      },
                      child: Text(
                        (item is WillModel && item.archived == true)
                            ? "Unarchive"
                            : (item is AtroModel &&
                            Get.find<AtroController>()
                                .atro!
                                .archived ==
                                true)
                            ? "Unarchive"
                            : "Archive",
                        style: const TextStyle(color: Colors.black),
                      ),
                      // child: Card(
                      //   shadowColor: Colors.grey.shade200,
                      //   elevation: 5,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(25.0),
                      //     child: Icon(
                      //       (item is WillModel && item.archived == true)
                      //           ? Icons.unarchive_outlined
                      //           : (item is AtroModel &&
                      //                   Get.find<AtroController>().atro!.archived ==
                      //                       true)
                      //               ? Icons.unarchive_outlined
                      //               : Icons.archive_outlined,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        if (item is AtroModel) {
                          Get.back();
                          if (Get.find<AtroController>().atro!.saved ==
                              true) {
                            profile.deleteMark(
                                widget.archiveId.toString(),
                                item.id.toString());
                          } else {
                            Get.back();
                            profile.createMark(
                                item.id.toString(), "atro");
                          }
                        } else if (item is WillModel) {
                          Get.back();
                          if (item.saved == true) {
                            profile.deleteMark(
                                widget.archiveId.toString(),
                                item.id.toString());
                          } else {
                            Get.back();
                            profile.createMark(
                                item.id.toString(), "will");
                          }
                        }
                      },
                      child: Text(
                        (item is WillModel && item.saved == true)
                            ? "UnSave"
                            : (item is AtroModel &&
                            Get.find<AtroController>()
                                .atro!
                                .saved ==
                                true)
                            ? "UnSave"
                            : "Save",
                        style: const TextStyle(color: Colors.black),
                      ),
                      // child: Card(
                      //   shadowColor: Colors.grey.shade200,
                      //   elevation: 5,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(25.0),
                      //     child: Icon(
                      //       (item is WillModel && item.archived == true)
                      //           ? Icons.unarchive_outlined
                      //           : (item is AtroModel &&
                      //                   Get.find<AtroController>().atro!.archived ==
                      //                       true)
                      //               ? Icons.unarchive_outlined
                      //               : Icons.archive_outlined,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (item is AtroModel || item is Atroe) {
                          Get.back();
                          _showReportDialog(item.id.toString(), "atro");
                        } else if (item is WillModel ||
                            item is WillsModel) {
                          Get.back();
                          _showReportDialog(item.id.toString(), "will");
                        }
                      },
                      child: const Text(
                        "Report",
                        style: TextStyle(color: Colors.black),
                      ),
                      // child: Card(
                      //   shadowColor: Colors.grey.shade200,
                      //   elevation: 5,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(25.0),
                      //     child: Icon(
                      //       (item is WillModel && item.archived == true)
                      //           ? Icons.unarchive_outlined
                      //           : (item is AtroModel &&
                      //                   Get.find<AtroController>().atro!.archived ==
                      //                       true)
                      //               ? Icons.unarchive_outlined
                      //               : Icons.archive_outlined,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                )
              ],
            ));
      },
    );
  }

  _buildBottomNav() {
    return GetBuilder<CommentController>(
      builder: (commentController) {
        return Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          height: commentController.isReply.value == true
              ? Get.height * .15
              : Get.height * .1,
          width: Get.width,
          child: Column(
            children: [
              (commentController.isReply.value == false)
                  ? Container()
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        commentController.commentInput.clear();
                        commentController.isReply.value = false;
                        commentController.update();
                        commentController.update();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          (commentController.replyComment!.user == null)
                              ? ""
                              : RequestHelper.BaseUrl +
                              commentController
                                  .replyComment!.user!.profile!.image
                                  .toString()),
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
                      height: Get.height * .05,
                      width: Get.width * .7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AutoSizeText(
                        commentController.replyComment is Comment
                            ? commentController.replyComment!.content
                            .toString()
                            : '',
                        maxLines: 1,
                        maxFontSize: 24,
                        minFontSize: 10,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextField(
                widget.atroModel?.id.toString(),
              ),
            ],
          ),
        );
      },
    );
  }

  _showDelete(item) {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: Get.height * .2,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Do you want delete your post?",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                      if (item is AtroModel || item is Atroe) {
                        Get.find<AtroController>()
                            .deleteAtro(item.id.toString());
                      } else if (item is WillModel || item is WillsModel) {
                        Get.back();
                        profile.deleteWill(item.id.toString());
                      }
                    },
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
