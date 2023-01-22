class NotifModel {
  NotifModel({
    this.creator,
    this.receiver,
    this.contentObject,
    this.message,
  });

  int? creator;
  List<int?>? receiver;
  ContentObject? contentObject;
  String? message;

  factory NotifModel.fromJson(Map<String, dynamic> json) => NotifModel(
    creator: json["creator"],
    receiver: json["receiver"] == null ? [] : List<int?>.from(json["receiver"]!.map((x) => x)),
    contentObject: json["content_object"] == null?null:ContentObject.fromJson(json["content_object"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "creator": creator,
    "receiver": receiver == null ? [] : List<dynamic>.from(receiver!.map((x) => x)),
    "content_object": contentObject!.toJson(),
    "message": message,
  };
}

class ContentObject {
  ContentObject({
    this.id,
    this.author,
    this.image,
    this.question,
    this.answer,
    this.sound,
    this.profileInfo,
    this.viewer,
    this.created,
    this.saved,
    this.saved_id,
    this.archived,
    this.commentCount,
  });

  int? id;
  int? author;
  int? saved_id;
  String? image;
  String? question;
  String? answer;
  String? sound;
  ProfileInfo? profileInfo;
  List<ProfileInfo?>? viewer;
  String? created;
  bool? saved;
  bool? archived;
  int? commentCount;

  factory ContentObject.fromJson(Map<String, dynamic> json) => ContentObject(
    id: json["id"],
    author: json["author"],
    saved_id: json["saved_id"],
    image: json["image"],
    question: json["question"],
    answer: json["answer"],
    sound: json["sound"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    viewer: json["viewer"] == null ? [] : List<ProfileInfo?>.from(json["viewer"]!.map((x) => ProfileInfo.fromJson(x))),
    created: json["created"],
    saved: json["saved"],
    archived: json["archived"],
    commentCount: json["comment_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author": author,
    "image": image,
    "question": question,
    "answer": answer,
    "sound": sound,
    "profile_info": profileInfo!.toJson(),
    "viewer": viewer == null ? [] : List<dynamic>.from(viewer!.map((x) => x!.toJson())),
    "created": created,
    "saved": saved,
    "archived": archived,
    "comment_count": commentCount,
  };
}

class ProfileInfo {
  ProfileInfo({
    this.id,
    this.user,
    this.userName,
    this.firstName,
    this.lastName,
    this.image,
  });

  int? id;
  int? user;
  String? userName;
  String? firstName;
  String? lastName;
  String? image;

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
    id: json["id"],
    user: json["user"],
    userName: json["user_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_name": userName,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
  };
}
