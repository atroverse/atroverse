import 'package:animations/animations.dart';
import 'package:atroverse/Helpers/ViewHelpers.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:atroverse/Screens/ToDoApp/DB/notes_model.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../Utils/CostumAppBarWidget.dart';

class TaskListScreen extends StatefulWidget {
  TaskListScreen({Key? key, required this.rawName, required this.catId})
      : super(key: key);
  String rawName;
  String catId;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  onPop() {
    Get.back();
  }

  List<NoteModel> listOfNotes = [];
  List<NoteModel> listOfNotes2 = [];

  getData() async {
    listOfNotes.clear();
    List<Map<String, dynamic>> listOfNote = [];
    listOfNote = await NotesModel.getAllData();
    listOfNotes.addAll(NoteModel.listFromJson(listOfNote));
    listOfNotes2.clear();
    for (var element in listOfNotes) {
      if (widget.catId == element.categoryId) {
        listOfNotes2.add(element);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onPop(),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: OpenContainer(
            onClosed: (n) {
              getData();
            },
            closedElevation: 0,
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (_, c) {
              return Container(
                height: Get.height * .1,
                width: Get.width * .18,
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              );
            },
            openBuilder: (_, c) {
              return AddBox(
                day: "",
                list: [],
                rawName: widget.rawName,
                isEdit: false,
                catId: widget.catId,
                id: listOfNotes.isEmpty
                    ? "1"
                    : (listOfNotes.length + 1).toString(),
                note: NoteModel(color: "0xffFFFFFFFF"),
              );
            },
          ),
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomAppBar(
                    height: Get.height * .1,
                    title: widget.rawName == "1"
                        ? "ToDay"
                        : (widget.rawName == "Free")
                            ? "${widget.rawName} Notes"
                            : (widget.rawName == "365")
                                ? "Year"
                                : (widget.rawName == "30")
                                    ? "Month"
                                    : (widget.rawName == "7")
                                        ? "Week"
                                        : "",
                    isBack: true,
                    isOnTap: false,
                  ),
                  pinned: false,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildGridView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildGridView() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: listOfNotes2.length,
      itemBuilder: (_, index) {
        final note = listOfNotes2[index];
        return GestureDetector(
          onLongPress: () {
            _showDelete(note.id);
          },
          child: OpenContainer(
              openElevation: 0,
              onClosed: (n) {
                getData();
              },
              closedColor: Colors.white,
              middleColor: Colors.white,
              closedElevation: 0,
              openColor: Colors.white,
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (_, c) {
                return Container(
                  decoration: BoxDecoration(
                    color: note.isChecked == 1 && widget.rawName != "Free"
                        ? Colors.black
                        : Color(int.parse(note.color)),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 3,
                        blurRadius: 6,
                      )
                    ],
                  ),
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.rawName == "Free") ...{
                        SizedBox(height: Get.height * .005),
                      },
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          note.title.toString(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: note.isChecked == 1 &&
                                      widget.rawName != "Free"
                                  ? Colors.white
                                  : (note.color == "0xffFF0000" ||
                                          note.color == "0xff0000FF" ||
                                          note.color == "0xff000000")
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (widget.rawName == "Free" || widget.rawName == "1")
                              ? Container()
                              : Text(
                                  note.toDate!,
                                  style: TextStyle(
                                    color: note.isChecked == 1
                                        ? Colors.white
                                        : (note.color == "0xffFF0000" ||
                                                note.color == "0xff0000FF" ||
                                                note.color == "0xff000000")
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          (widget.rawName == "Free")
                              ? Container()
                              : (widget.rawName == "1")
                                  ? Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            note.fromDate!,
                                            style: TextStyle(
                                              color: note.isChecked == 1
                                                  ? Colors.white
                                                  : (note.color ==
                                                              "0xffFF0000" ||
                                                          note.color ==
                                                              "0xff0000FF" ||
                                                          note.color ==
                                                              "0xff000000")
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          note.day!,
                                          style: TextStyle(
                                            color: note.isChecked == 1
                                                ? Colors.white
                                                : (note.color == "0xffFF0000" ||
                                                        note.color ==
                                                            "0xff0000FF" ||
                                                        note.color ==
                                                            "0xff000000")
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    )
                                  : Text(
                                      note.fromDate!,
                                      style: TextStyle(
                                        color: note.isChecked == 1
                                            ? Colors.white
                                            : (note.color == "0xffFF0000" ||
                                                    note.color ==
                                                        "0xff0000FF" ||
                                                    note.color == "0xff000000")
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                        ],
                      )
                    ],
                  ),
                );
              },
              openBuilder: (_, c) {
                return AddBox(
                  day: note.day.toString(),
                  rawName: widget.rawName,
                  note: note,
                  catId: widget.catId,
                  id: note.id.toString(),
                  isEdit: true,
                  list: note.listOfCheckBox!,
                );
              }),
        );
      },
    );
  }

  _showDelete(id) {
    return Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                  "Do you want to delete your workbook?",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.close(0);
                      },
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        NotesModel.remove(id);
                        getData();
                        Get.back();
                      },
                      color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

class AddBox extends StatefulWidget {
  AddBox(
      {Key? key,
      required this.list,
      required this.id,
      required this.note,
      required this.isEdit,
      required this.rawName,
      required this.day,
      required this.catId})
      : super(key: key);
  NoteModel note;
  String id;
  String rawName;
  bool isEdit;
  String catId;
  String day;
  List<CheckBoxModel> list;

  @override
  State<AddBox> createState() => _AddBoxState();
}

class _AddBoxState extends State<AddBox> {
  late TextEditingController to;
  late TextEditingController from;
  late TextEditingController title;
  late TextEditingController note;
  late TextEditingController day;
  String color = "0xffFFFFFFFF";
  List<MyModel> colors = [
    MyModel(
      color: "0xffFF0000",
      selected: false,
    ),
    MyModel(
      color: "0xffFFFF00",
      selected: false,
    ),
    MyModel(
      color: "0xff00FF00",
      selected: false,
    ),
    MyModel(
      color: "0xff0000FF",
      selected: false,
    ),
    MyModel(
      color: "0xffFF00FF",
      selected: false,
    ),
    MyModel(
      color: "0xffC0C0C0",
      selected: false,
    ),
    MyModel(
      color: "0xff808080",
      selected: false,
    ),
    MyModel(
      color: "0xff000000",
      selected: false,
    ),
  ];

  onPop() async {
    ViewHelper.showLoading();
    if (widget.isEdit == false) {
      for (var element in listOfFalse) {
        listOfCheckBox.add(element);
      }
      for (var element in listOfTrue) {
        listOfCheckBox.add(element);
      }
      Future.delayed(2.seconds).then((value) async {
        await NotesModel.add(
            note: note.text,
            day: day.text,
            color: color.toString(),
            title: title.text,
            category_id: widget.catId,
            fromDate: from.text,
            toDate: to.text,
            listOfCheckBox: listOfCheckBox,
            isChecked: false);
        EasyLoading.dismiss();
        Navigator.pop(context);
      });
    } else if (widget.isEdit == true) {
      ViewHelper.showLoading();
      for (var element in listOfFalse) {
        listOfCheckBox.add(element);
      }
      for (var element in listOfTrue) {
        listOfCheckBox.add(element);
      }
      Future.delayed(2.seconds).then((value) async {
        await NotesModel.updateItem(
            note: note.text,
            color: color.toString(),
            id: widget.note.id!,
            title: title.text,
            day: day.text,
            category_id: widget.catId,
            fromDate: from.text,
            toDate: to.text,
            listOfCheckBox: listOfCheckBox,
            isChecked: (listOfFalse.isEmpty) ? true : false);
        EasyLoading.dismiss();
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    to = TextEditingController(text: widget.note.toDate);
    from = TextEditingController(text: widget.note.fromDate);
    title = TextEditingController(text: widget.note.title);
    note = TextEditingController(text: widget.note.note);
    day = TextEditingController(text: widget.note.day);
    color = widget.note.color.toString();
    getData();
    super.initState();
  }

  List<CheckBoxModel> listOfCheckBox = [];
  List<CheckBoxModel> listOfTrue = [];
  List<CheckBoxModel> listOfFalse = [];

  getData() async {
    listOfFalse.clear();
    listOfTrue.clear();
    for (var element in widget.list) {
      if (element.isChecked == 0 && element.categoryId == widget.id) {
        listOfFalse.add(element);
      } else if (element.isChecked == 1 && element.categoryId == widget.id) {
        listOfTrue.add(element);
      }
    }
    setState(() {});
  }

  pop() {
    if (title.text.isNotEmpty) {
      onPop();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => pop(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2.5,
            leading: ExpandTapWidget(
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onTap: () {
                if (title.text.isNotEmpty) {
                  onPop();
                } else {
                  Get.back();
                }
              },
              tapPadding: const EdgeInsets.all(50),
            ),
          ),
          body: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white,
            child: ListView(
              children: [
                SizedBox(
                  height: Get.height * .1,
                  width: Get.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {
                          for (var element in colors) {
                            element.selected = false;
                          }
                          colors[i].selected = true;
                          color = colors[i].color!;
                          setState(() {});
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            border: colors[i].selected == false
                                ? Border.all(
                                    color: Colors.transparent,
                                  )
                                : Border.all(color: Colors.black, width: 2),
                            color: (colors[i].color == colors.last.color)
                                ? Color(int.parse(colors[i].color!))
                                    .withOpacity(0.7)
                                : Color(int.parse(colors[i].color!)),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                _buildTitle(title),
                const SizedBox(height: 25),
                (widget.rawName == "Free")
                    ? Container()
                    : Row(
                        children: [
                          _buildFromDate(from),
                          (widget.rawName != "1")
                              ? Container()
                              : _buildDay(day),
                        ],
                      ),
                const SizedBox(height: 25),
                (widget.rawName == "Free" || widget.rawName == "1")
                    ? Container()
                    : _buildToDate(to),
                (widget.rawName == "Free")
                    ? _buildNote(note)
                    : Column(
                        children: [
                          ReorderableListView.builder(
                            key: ValueKey(listOfFalse),
                            itemBuilder: (context, i) {
                              var item = listOfFalse[i];
                              return ListTile(
                                key: ValueKey(i),
                                title: TextField(
                                  maxLines: null,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  focusNode: item.focusNode,
                                  // autofocus: true,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  controller:
                                      TextEditingController(text: item.title),
                                  onChanged: (value) {
                                    item.title = value;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Task Or Note"),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    item.isChecked = 0;
                                    listOfFalse.removeAt(i);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                ),
                                leading: Checkbox(
                                  value: item.isChecked == 0 ? false : true,
                                  onChanged: (val) async {
                                    item.isChecked = 1;
                                    listOfFalse.removeAt(i);
                                    listOfTrue.add(CheckBoxModel(
                                        id: i,
                                        title: item.title,
                                        categoryId: widget.id,
                                        isChecked: 1));
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: listOfFalse.length,
                            physics: const NeverScrollableScrollPhysics(),
                            onReorder: (int oldIndex, int newIndex) async {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final items = listOfFalse.removeAt(oldIndex);
                              listOfFalse.insert(newIndex, items);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                (widget.rawName == "Free")
                    ? Container()
                    : TextButton(
                        onPressed: () async {
                          if (listOfFalse.isNotEmpty) {
                            listOfFalse.update(
                              listOfFalse.last.id! - 1,
                              CheckBoxModel(
                                title: listOfFalse.last.title,
                                categoryId: widget.id,
                                isChecked: 0,
                                id: listOfFalse.last.id,
                              ),
                            );
                          }
                          listOfFalse.add(
                            CheckBoxModel(
                              title: "",
                              categoryId: widget.id,
                              isChecked: 0,
                              id: listOfFalse.isEmpty
                                  ? 1
                                  : (listOfFalse.length + 1),
                            ),
                          );
                          FocusScope.of(context).unfocus();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(
                                listOfFalse[listOfFalse.length - 1].focusNode);
                          });

                          setState(() {});
                        },
                        child: Container(
                          height: Get.height * .04,
                          width: Get.width * .1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                              shape: BoxShape.rectangle),
                          child: const Center(
                            child: Text(
                              "+",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        )),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listOfTrue.length,
                      itemBuilder: (context, i) {
                        final item = listOfTrue[i];
                        return ListTile(
                          title: Text(
                            item == null ? "" : item.title!,
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              item.isChecked = 0;
                              listOfTrue.removeAt(i);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                          leading: Checkbox(
                            value: item.isChecked == 0 ? false : true,
                            onChanged: (val) async {
                              item.isChecked = 0;
                              listOfTrue.removeAt(i);
                              listOfFalse.add(CheckBoxModel(
                                  isChecked: 0,
                                  categoryId: widget.id,
                                  title: item.title,
                                  id: i));
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildFromDate(controller) {
    return SizedBox(
      height: Get.height * .06,
      width: (widget.rawName != "1") ? Get.width : Get.width * .5,
      child: WidgetHelper.dateInput(
        title: (widget.rawName == "1") ? "Date" : "From date",
        hint: "DD/MM/YYYY",
        controller: controller,
        onChanged: (value) {},
      ),
    );
  }

  _buildDay(controller) {
    return SizedBox(
      height: Get.height * .06,
      width: Get.width * .5,
      child: WidgetHelper.dateInputNoBorder(
        title: "Day",
        hint: "Type day",
        textInputAction: TextInputAction.next,
        type: TextInputType.text,
        controller: controller,
        onChanged: (value) {},
      ),
    );
  }

  _buildToDate(controller) {
    return WidgetHelper.dateInput(
      title: "To Date",
      hint: "DD/MM/YYYY",
      controller: controller,
      onChanged: (value) {},
    );
  }

  _buildNote(controller) {
    return WidgetHelper.dateInputNoBorder(
      title: "Note",
      hint: "type notes...",
      maxLine: 50,
      minLine: 50,
      type: TextInputType.multiline,
      controller: controller,
      onChanged: (value) {},
    );
  }

  _buildTitle(controller) {
    return WidgetHelper.dateInputNoBorder(
      title: "Title",
      hint: "type title",
      maxLine: 5,
      minLine: 1,
      type: TextInputType.multiline,
      controller: controller,
      onChanged: (value) {},
    );
  }
}

extension ListUpdate<CheckBoxModel> on List<CheckBoxModel> {
  List<CheckBoxModel> update(int pos, CheckBoxModel t) {
    List<CheckBoxModel> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

class MyModel {
  String? color;
  bool? selected;

  MyModel({this.color, this.selected});
}
