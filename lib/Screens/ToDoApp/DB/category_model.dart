import 'base_model.dart';

class CategoryModel extends BaseModel {
  @override
  Map<String, DbDataTypes> fields() {
    return {
      'title': DbDataTypes.Text,
      'name': DbDataTypes.Text,
    };
  }

  @override
  String primaryKey() {
    return 'id';
  }

  // returns the id of the added row
  static Future<int> add({
    required String title,
    required String name,
  }) async {
    return await CategoryModel().insert({
      'title': title,
      'name': name,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    return await CategoryModel().getAll();
  }
}


class CatModel {
  CatModel({
    this.id,
    this.title,
    this.name,
  });

  int? id;
  String? title;
  String? name;

  factory CatModel.fromJson(Map<String, dynamic> json) => CatModel(
    id: json["id"],
    title: json["title"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
  };
}

