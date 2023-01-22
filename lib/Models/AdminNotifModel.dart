class AdminNotifModel {
  AdminNotifModel({
    this.id,
    this.text,
    this.confirm,
    this.userInfo,
    this.friendRequest,
    this.receiver,
  });

  int? id;
  String? text;
  bool? confirm;
  UserInfo? userInfo;
  int? friendRequest;
  int? receiver;

  factory AdminNotifModel.fromJson(Map<String, dynamic> json) =>
      AdminNotifModel(
        id: json["id"],
        text: json["text"],
        confirm: json["confirm"],
        userInfo: UserInfo.fromJson(json["user_info"]),
        friendRequest: json["friend_request"],
        receiver: json["receiver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "confirm": confirm,
        "user_info": userInfo!.toJson(),
        "friend_request": friendRequest,
        "receiver": receiver,
      };
}

class UserInfo {
  UserInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.user,
    this.userName,
    this.image,
  });

  int? id;
  String? firstName;
  String? lastName;
  int? user;
  String? userName;
  String? image;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        user: json["user"],
        userName: json["user_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "user": user,
        "user_name": userName,
        "image": image,
      };
}
