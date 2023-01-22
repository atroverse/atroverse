import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/CostumAppBarWidget.dart';

class BlockListScreen extends StatelessWidget {
  final controller = Get.find<ProfileController>();

  BlockListScreen({Key? key}) : super(key: key) {
    controller.blocklist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomAppBar(
                  height: Get.height * .1,
                  title: "Block List",
                  isBack: true,
                  isOnTap: false),
              pinned: false,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: controller.listOfBlock.length,
                              itemBuilder: itemBuilder),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),);
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = controller.listOfBlock[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300,blurRadius: 10,spreadRadius: 1),
        ]
      ),
      height: Get.height * .08,
      width: Get.width,
      child: ListTile(
        trailing: SizedBox(
          height: Get.height * .05,
          width: Get.width * .25,
          child: MaterialButton(
            color: Colors.red,
            onPressed: () {
              controller.unBlock(item.blockId.toString());
            },
            child: const Center(
                child: Text(
              "UnBlock",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
        subtitle: Text(
          item.firstName.toString() + " " + item.lastName.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        title: Text(
          item.userName.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
