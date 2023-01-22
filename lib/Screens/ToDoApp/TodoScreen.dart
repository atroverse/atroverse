import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:atroverse/Screens/ToDoApp/TaskListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Utils/CostumAppBarWidget.dart';
import 'DB/base_model.dart';
import 'DB/category_model.dart';
import 'DB/notes_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool loading = false;
  List<CatModel> listOfCategory = [];

  getData() async {
    listOfCategory.clear();
    List<Map<String, dynamic>> listOfCat = [];
    listOfCat.clear();
    listOfCat = await CategoryModel.getAllData();
    listOfCat.forEach((element) {
      listOfCategory.add(CatModel.fromJson(element));
      print(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    onCreate();
    super.initState();
  }

  onCreate() async {
    getData();
    Future.delayed(3.seconds).then(
      (value) async {
        if (listOfCategory.isEmpty) {
          CategoryModel.add(title: "Free", name: "Free");
          CategoryModel.add(title: "1", name: "1");
          CategoryModel.add(title: "7", name: "7");
          CategoryModel.add(title: "30", name: "30");
          CategoryModel.add(title: "365", name: "365");
          getData();
          loading = true;
          setState(() {});
        }
        loading = true;
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false && listOfCategory.isEmpty) {
      return Center(
        child: Lottie.asset("assets/anims/loading.json", width: Get.width * .3),
      );
    }
    return SafeArea(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomAppBar(
                  height: Get.height * .1,
                  title: "Todo",
                  isBack: false,
                  isOnTap: false),
              pinned: false,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Get.height * .72,
                width: Get.width,
                child: Column(
                  children: [
                    _buildGridList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildGridList() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(top: Get.height * .02),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Get.height * .15,
              width: Get.width * .9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 3,
                      blurRadius: 6)
                ],
              ),
              child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade200)),
                onPressed: () async {
                  Get.to(
                    TaskListScreen(
                      catId: "1",
                      rawName: "Free",
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    listOfCategory[0].title.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 20,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: Get.height * .3,
                width: Get.width * .4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 3,
                        blurRadius: 6)
                  ],
                ),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue.shade200,
                    ),
                  ),
                  onPressed: () {
                    Get.to(TaskListScreen(
                      catId: "5",
                      rawName: "365",
                    ));
                  },
                  child: Center(
                    child: Text(
                      listOfCategory[4].title.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 60,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            right: 20,
            bottom: Get.height * .12,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: Get.height * .18,
                width: Get.width * .425,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 3,
                          blurRadius: 6)
                    ]),
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade200)),
                  onPressed: () {
                    Get.to(TaskListScreen(
                      catId: "4",
                      rawName: "30",
                    ));
                  },
                  child: Center(
                    child: Text(
                      listOfCategory[3].title.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 80,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 20,
            top: Get.height * .05,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: Get.height * .18,
                width: Get.width * .4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 3,
                          blurRadius: 6)
                    ]),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade200),
                  ),
                  onPressed: () {
                    Get.to(TaskListScreen(
                      catId: "2",
                      rawName: "1",
                    ));
                  },
                  child: Center(
                    child: Text(
                      listOfCategory[1].title.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 110,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            right: 20,
            top: Get.height * .02,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: Get.height * .3,
                width: Get.width * .425,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 3,
                      blurRadius: 6,
                    )
                  ],
                ),
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade200)),
                  onPressed: () {
                    Get.to(TaskListScreen(
                      catId: "3",
                      rawName: "7",
                    ));
                  },
                  child: Center(
                    child: Text(
                      listOfCategory[2].title.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 90,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
