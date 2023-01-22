import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../Models/TicketDetailListModel.dart';
import '../Models/TicketListModel.dart';

class TicketController extends GetxController {
  RxList<TicketListModel> listOfTicket = <TicketListModel>[].obs;
  RxList<TicketDetailListModel> listOfDetailTicket =
      <TicketDetailListModel>[].obs;

  RxString title = "".obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  List<PopupMenuItem<String>> isPhotoItem =
      ["Report", "Technical", "Support"]
          .map((e) => PopupMenuItem(
                textStyle: const TextStyle(color: Colors.black, fontSize: 14),
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ))
          .toList();

  getTicketList() {
    ViewHelper.showLoading();
    RequestHelper.getTicketList().then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          listOfTicket.clear();
          for (var i in value.data2) {
            listOfTicket.add(TicketListModel.fromJson(i));
          }
        } else {
          Get.back();
          ViewHelper.showErrorDialog("Please try again!");
        }
      },
    );
  }

  @override
  void onInit() {
    getTicketList();
    super.onInit();
  }

  getDetailTicketList(id, Callback callback) {
    ViewHelper.showLoading();
    RequestHelper.getTicketDetail(id: id.toString()).then(
      (value) {
        EasyLoading.dismiss();
        listOfDetailTicket.clear();
        if (value.statusCode == 200) {
          for (var i in value.data2) {
            listOfDetailTicket.add(TicketDetailListModel.fromJson(i));
          }
          callback();
        } else {
          Get.back();
          ViewHelper.showErrorDialog("Please try again!");
        }
      },
    );
  }

  createTicket() {
    ViewHelper.showLoading();
    RequestHelper.ticketCreate(
            title: titleController.text,
            body: bodyController.text,
            type: title.value)
        .then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 201) {
          getTicketList();
          title.value = "";
          titleController.clear();
          bodyController.clear();
          Get.close(0);
        } else {
          ViewHelper.showErrorDialog("Please try again!");
        }
      },
    );
  }

  answerTicket(id) {
    listOfDetailTicket.add(
      TicketDetailListModel(
        body: bodyController.text,
        created: DateTime.now(),
        fromWho: "user",
      ),
    );
    update();
    ViewHelper.showLoading();
    RequestHelper.sendAnswer(
      id: id.toString(),
      body: bodyController.text,
    ).then(
      (value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          bodyController.clear();
        } else {
          ViewHelper.showErrorDialog("Please try again!");
        }
      },
    );
  }
}
