import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({Key? key, this.path}) : super(key: key);

  String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .22,
      width: Get.width * .4,
      decoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(path.toString()),
          )),
    );
  }
}

class ProfileAvatar2 extends StatelessWidget {
  ProfileAvatar2({Key? key, this.path}) : super(key: key);

  String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .2,
      width: Get.width * .4,
      decoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(path.toString()),
          )),
    );
  }
}
