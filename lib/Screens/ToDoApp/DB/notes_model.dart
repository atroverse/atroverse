import 'dart:convert';
import 'package:flutter/material.dart';
import 'base_model.dart';

class NotesModel extends BaseModel {
  @override
  Map<String, DbDataTypes> fields() {
    return {
      'title': DbDataTypes.Text,
      'category_id': DbDataTypes.Text,
      'fromDate': DbDataTypes.Text,
      'toDate': DbDataTypes.Text,
      'day': DbDataTypes.Text,
      'note': DbDataTypes.Text,
      'color': DbDataTypes.Text,
      'listOfCheckBox': DbDataTypes.Text,
      'isChecked': DbDataTypes.Integer, // 0 is no 1 is  yes
    };
  }

  @override
  String primaryKey() {
    return 'id';
  }

  // returns the id of the added row
  static Future<int> add({
    required String title,
    required String category_id,
    required String fromDate,
    required String toDate,
    required String day,
    required String note,
    required String color,
    required List<CheckBoxModel> listOfCheckBox,
    required bool isChecked,
  }) async {
    return await NotesModel().insert({
      'title': title,
      'category_id': category_id,
      'fromDate': fromDate,
      'toDate': toDate,
      'day': day,
      'note': note,
      'color': color,
      'listOfCheckBox': jsonEncode(listOfCheckBox),
      'isChecked': isChecked ? 1 : 0, // 0 is no 1 is  yes
    });
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    return await NotesModel().getAll();
  }

  static Future<int> remove(id) async {
    return await NotesModel().delete(id);
  }

  static Future<int> updateItem(
      {required String title,
      required String category_id,
      required String fromDate,
      required String toDate,
      required String note,
      required String color,
      required String day,
      required List<CheckBoxModel> listOfCheckBox,
      required bool isChecked,
      required int id}) async {
    return await NotesModel().update(id, {
      'title': title,
      'category_id': category_id,
      'fromDate': fromDate,
      'color': color,
      'day': day,
      'toDate': toDate,
      'note': note,
      'listOfCheckBox': jsonEncode(listOfCheckBox),
      'isChecked': isChecked ? 1 : 0, // 0 is no 1 is  yes
    });
  }
}

class NoteModel {
  NoteModel({
    this.id,
    this.title,
    this.categoryId,
    this.fromDate,
    this.toDate,
    this.listOfCheckBox,
    this.isChecked,
    this.day,
    this.note,
    required this.color
  });

  int? id;
  String? title;
  String? categoryId;
  String? fromDate;
  String? toDate;
  String? day;
  String? note;
  String color = "0xffFFFFFFFF";
  List<CheckBoxModel>? listOfCheckBox;
  int? isChecked;

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        title: json["title"],
        note: json["note"],
    color: json["color"],
        categoryId: json["category_id"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
        day: json["day"],
        listOfCheckBox:
            CheckBoxModel.listFromJson(jsonDecode(json["listOfCheckBox"])),
        isChecked: json["isChecked"] as int,
      );

  static List<NoteModel> listFromJson(List data) {
    print(data);
    return List<NoteModel>.from(data.map((x) => NoteModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "note": note,
        "color": color,
        "category_id": categoryId,
        "fromDate": fromDate,
        "toDate": toDate,
        "day": day,
        "listOfCheckBox":
            List<dynamic>.from(listOfCheckBox!.map((x) => x.toJson())),
        "isChecked": isChecked,
      };
}

class CheckBoxModel extends BaseModel {
  @override
  Map<String, DbDataTypes> fields() {
    return {
      'title': DbDataTypes.Text,
      'category_id': DbDataTypes.Text,
      'isChecked': DbDataTypes.Integer, // 0 is no 1 is  yes
    };
  }

  @override
  String primaryKey() {
    return 'id';
  }

  // returns the id of the added row
  static Future<int> add({
    required String title,
    required String category_id,
    required bool isChecked,
  }) async {
    return await CheckBoxModel().insert({
      'title': title,
      'category_id': category_id,
      'isChecked': isChecked ? 1 : 0, // 0 is no 1 is  yes
    });
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    return await CheckBoxModel().getAll();
  }

  static Future<int> removeItem(id) async {
    return await CheckBoxModel().delete(id);
  }

  static Future getItem(id) async {
    return await CheckBoxModel().get(id);
  }

  static Future<int> updateItem({id, title, category_id, isChecked}) async {
    return await CheckBoxModel().update(id, {
      'title': title,
      'category_id': category_id,
      'isChecked': isChecked ? 1 : 0,
    });
  }

  CheckBoxModel({
    this.id,
    this.title,
    this.categoryId,
    this.isChecked,
  });

  int? id;
  String? title;
  var categoryId;
  int? isChecked;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  factory CheckBoxModel.fromJson(Map<String, dynamic> json) => CheckBoxModel(
        id: json["id"],
        title: json["title"],
        categoryId: json["category_id"],
        isChecked: json["isChecked"] as int,
      );

  static List<CheckBoxModel> listFromJson(List data) {
    print(data);
    return List<CheckBoxModel>.from(data.map((x) => CheckBoxModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_id": categoryId,
        "isChecked": isChecked,
      };
}
