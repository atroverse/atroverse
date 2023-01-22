import 'package:atroverse/Controllers/TicketController.dart';
import 'package:atroverse/Models/TicketDetailListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/CostumAppBarWidget.dart';

class SingleTicketScreen extends StatelessWidget {
  SingleTicketScreen({Key? key}) : super(key: key);

  final controller = Get.find<TicketController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: "Type message",
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.answerTicket(Get.arguments['id']);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  )),
            ),
          ),
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          child: Obx(() {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomAppBar(
                      height: Get.height * .1,
                      title: "Ticket List",
                      isBack: true,
                      isOnTap: false),
                  pinned: false,
                  floating: true,
                ),
                _buildList(),
              ],
            );
          }),
        ),
      ),
    );
  }

  _buildList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.listOfDetailTicket.length,
        (context, index) {
          final item = controller.listOfDetailTicket[index];
          return (item.fromWho == "admin") ? inBubble(item) : outBubble(item);
        },
      ),
    );
  }

  inBubble(TicketDetailListModel item) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * .8),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            // topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                item.body.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "${item.created?.hour}:${item.created?.minute}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  outBubble(TicketDetailListModel item) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * .8),
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            // topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                item.body.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "${item.created?.hour}:${item.created?.minute}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
