class FriendModel {
  FriendModel({
    this.id,
    this.user,
    this.userName,
    this.firstName,
    this.lastName,
    this.image,
    this.bio,
    this.gender,
    this.birthdate,
    this.registerLink,
    this.friendLink,
  });

  int? id;
  int? user;
  String? userName;
  String? firstName;
  String? lastName;
  String? image;
  String? bio;
  String? gender;
  String? birthdate;
  String? registerLink;
  String? friendLink;

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
    id: json["id"],
    user: json["user"],
    userName: json["user_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    bio: json["bio"],
    gender: json["gender"],
    birthdate: json["birthdate"],
    registerLink: json["register_link"],
    friendLink: json["friend_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_name": userName,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
    "bio": bio,
    "gender": gender,
    "birthdate": birthdate,
    "register_link": registerLink,
    "friend_link": friendLink,
  };
}