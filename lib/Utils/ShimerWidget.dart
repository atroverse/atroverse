import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white12.withOpacity(0.1),
      child: Container(
          height: Get.height * .5,
          width: Get.width,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
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
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/stock-photo-159533631-1500x1000.jpg"),
                            ),
                            SizedBox(
                              width: Get.width * .03,
                            ),
                            Container(
                              height: Get.height * .025,
                              width: Get.width * .7,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: Get.height * .34,
                  width: Get.width,
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  height: Get.height * .025,
                  width: Get.width * .4,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: Get.height * .025,
                  width: Get.width * .7,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ],
          )),
    );
  }
}
