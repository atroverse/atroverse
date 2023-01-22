import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:atroverse/Screens/SingleTicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/TicketController.dart';
import '../Utils/CostumAppBarWidget.dart';

class TicketScreen extends StatelessWidget {
  TicketScreen({Key? key}) : super(key: key);

  final controller = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: Get.height,
        width: Get.width,
        child: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomAppBar1(
                    height: Get.height * .1,
                    title: "Ticketing",
                    isBack: true,
                    onTap: () {
                      Get.to(CreateTicketScreen());
                    },
                    isOnTap: true),
                pinned: false,
                floating: true,
              ),
              _buildList(),
            ],
          );
        }),
      ),
    );
  }

  _buildList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.listOfTicket.length,
        (context, index) {
          final item = controller.listOfTicket[index];
          return Container(
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * .025, vertical: Get.height * .01),
            height: Get.height * .1,
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2)
                ]),
            child: TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue.shade200)),
              onPressed: () {
                controller.getDetailTicketList(item.id, () {
                  Get.to(SingleTicketScreen(),
                      arguments: {"id": item.id.toString()});
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title: " + item.title.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        "Type: " + item.type.toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(width: Get.width * .05),
                  Container(
                    height: Get.height * .1,
                    width: 1,
                    color: Colors.black12,
                  ),
                  SizedBox(width: Get.width * .05),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status: " + item.status!,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      Text(
                        (item.closedAt == null)
                            ? ""
                            : "closed At: " +
                                item.closedAt.toString().substring(0, 10),
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreateTicketScreen extends StatelessWidget {
  CreateTicketScreen({Key? key}) : super(key: key);

  final controller = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return _showCreateTicket();
  }

  _showCreateTicket() {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(5),
          child: WidgetHelper.softButton(
            title: "Send",
            onTap: () {
              if (controller.title.value == "") {
                ViewHelper.showErrorDialog("Please choose type");
              } else if (controller.titleController.text.isEmpty) {
                ViewHelper.showErrorDialog("Please type title");
              } else if (controller.bodyController.text.isEmpty) {
                ViewHelper.showErrorDialog("Please type message");
              } else {
                controller.createTicket();
              }
            },
          ),
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomAppBar(
                    height: Get.height * .1,
                    title: "Create Ticket",
                    isBack: true,
                    onTap: () {
                      if (controller.title.value == "") {
                        ViewHelper.showErrorDialog("Please choose type");
                      } else if (controller.titleController.text.isEmpty) {
                        ViewHelper.showErrorDialog("Please type title");
                      } else if (controller.bodyController.text.isEmpty) {
                        ViewHelper.showErrorDialog("Please type message");
                      } else {
                        controller.createTicket();
                      }
                    },
                    isOnTap: true),
                pinned: false,
                floating: true,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * .05,
                    ),
                    _buildType(),
                    SizedBox(
                      height: Get.height * .025,
                    ),
                    _buildTitle(),
                    SizedBox(
                      height: Get.height * .025,
                    ),
                    _buildBody(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return WidgetHelper.dateInputNoBorder(
      title: "Title",
      maxLength: 25,
      onChanged: (value) {},
      type: TextInputType.text,
      controller: controller.titleController,
      hint: '',
    );
  }

  _buildBody() {
    return WidgetHelper.dateInputNoBorder(
      title: "Message",
      onChanged: (value) {},
      maxLine: null,
      isUnderLine: true,
      type: TextInputType.multiline,
      controller: controller.bodyController,
      hint: '',
    );
  }

  final GlobalKey<PopupMenuButtonState<String>> _key = GlobalKey();

  _buildType() {
    return GestureDetector(
      onTap: () {
        _key.currentState?.showButtonMenu();
      },
      child: Container(
        height: Get.height * .045,
        width: Get.width * .9,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GetBuilder<TicketController>(
          builder: (logic) {
            return Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_drop_down, color: Colors.blue),
                PopupMenuButton<String>(
                  key: _key,
                  onSelected: (value) {
                    logic.title.value = value;
                    logic.update();
                  },
                  child: Center(
                    child: Text(
                      textDirection: TextDirection.rtl,
                      logic.title.value == ""
                          ? "Select Type"
                          : logic.title.value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  itemBuilder: (_) => logic.isPhotoItem,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
