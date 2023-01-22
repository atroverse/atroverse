class FavoritModel {
  FavoritModel({
    this.id,
    this.cover,
    this.caption,
  });

  int? id;
  String? cover;
  String? caption;

  factory FavoritModel.fromJson(Map<String, dynamic> json) => FavoritModel(
    id: json["id"],
    cover: json["cover"],
    caption: json["caption"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cover": cover,
    "caption": caption,
  };
}