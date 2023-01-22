import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CustomAppBar extends SliverPersistentHeaderDelegate {
  final double height;
  final String title;
  final bool isBack;
  final bool isOnTap;
  Callback? onTap;

  CustomAppBar(
      {required this.height,
      required this.title,
      required this.isBack,
      required this.isOnTap,
      this.onTap});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: Get.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, -6),
                )
              ],
            ),
          ),
          Align(
            alignment: (isBack == false)
                ? Alignment(-0.9, -.55)
                : Alignment(-0.6, -.55),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          (isBack == false)
              ? Container()
              : Align(
                  alignment: const Alignment(-0.9, -1.7),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                    width: MediaQuery.of(context).size.width / 13,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
          (isOnTap == false)
              ? Container()
              : Align(
                  alignment: const Alignment(0.9, -1.7),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                    width: MediaQuery.of(context).size.width / 13,
                    child: InkWell(
                      onTap: () {
                        onTap!();
                      },
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CustomAppBar1 extends SliverPersistentHeaderDelegate {
  final double height;
  final String title;
  final bool isBack;
  final bool isOnTap;
  Callback? onTap;

  CustomAppBar1(
      {required this.height,
      required this.title,
      required this.isBack,
      required this.isOnTap,
      this.onTap});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: Get.height * 0.06,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, -6),
              )
            ]),
          ),
          Align(
            alignment: (isBack == true)
                ? Alignment(-0.2, -.55)
                : Alignment(-0.6, -.55),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          (isBack == false)
              ? Container()
              : Align(
                  alignment: const Alignment(-0.9, -1.7),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                    width: MediaQuery.of(context).size.width / 13,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
          (isOnTap == false)
              ? Container()
              : Align(
                  alignment: const Alignment(0.9, -1.7),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                    width: MediaQuery.of(context).size.width / 13,
                    child: InkWell(
                      onTap: () {
                        onTap!();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


class CustomAppBar2 extends SliverPersistentHeaderDelegate {
  final double height;
  final String title;
  final bool isBack;
  final bool isOnTap;
  Callback? onTap;

  CustomAppBar2(
      {required this.height,
        required this.title,
        required this.isBack,
        required this.isOnTap,
        this.onTap});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: Get.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, -6),
                )
              ],
            ),
          ),
          Align(
            alignment: (isBack == false)
                ? Alignment(-0.9, -.55)
                : Alignment(-0.6, -.55),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          (isBack == false)
              ? Container()
              : Align(
            alignment: const Alignment(-0.9, -1.7),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 13,
              width: MediaQuery.of(context).size.width / 13,
              child: InkWell(
                onTap: () {
                  onTap!();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          (isOnTap == false)
              ? Container()
              : Align(
            alignment: const Alignment(0.9, -1.7),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 13,
              width: MediaQuery.of(context).size.width / 13,
              child: InkWell(
                onTap: () {
                  onTap!();
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


class CustomAppBar3 extends StatelessWidget {
  final double height;
  final String title;
  final bool isBack;
  final bool isOnTap;
  Callback? onTap;

  CustomAppBar3(
      {required this.height,
        required this.title,
        required this.isBack,
        required this.isOnTap,
        this.onTap});

  @override
  Widget build(
      BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: Get.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, -6),
                )
              ],
            ),
          ),
          Align(
            alignment: (isBack == false)
                ? Alignment(-0.9, -.55)
                : Alignment(-0.6, -.55),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          (isBack == false)
              ? Container()
              : Align(
            alignment: const Alignment(-0.9, -1.7),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 13,
              width: MediaQuery.of(context).size.width / 13,
              child: InkWell(
                onTap: () {
                  onTap!();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          (isOnTap == false)
              ? Container()
              : Align(
            alignment: const Alignment(0.9, -1.7),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 13,
              width: MediaQuery.of(context).size.width / 13,
              child: InkWell(
                onTap: () {
                  onTap!();
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
