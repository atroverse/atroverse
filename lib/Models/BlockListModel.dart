
class BlockListModel {
  BlockListModel({
    this.id,
    this.user,
    this.userName,
    this.firstName,
    this.lastName,
    this.image,
    this.blockId,
  });

  int? id;
  int? user;
  String? userName;
  String? firstName;
  String? lastName;
  String? image;
  int? blockId;

  factory BlockListModel.fromJson(Map<String, dynamic> json) => BlockListModel(
    id: json["id"],
    user: json["user"],
    userName: json["user_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    blockId: json["block_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_name": userName,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
    "block_id": blockId,
  };
}
