import 'package:get/get.dart';

class ArichveModel {
  ArichveModel({
    this.id,
    this.user,
    this.contentObject,
  });

  int? id;
  int? user;
  ContentObject? contentObject;
  RxBool checked = true.obs;

  factory ArichveModel.fromJson(Map<String, dynamic> json) => ArichveModel(
    id: json["id"],
    user: json["user"],
    contentObject: ContentObject.fromJson(json["content_object"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "content_object": contentObject?.toJson(),
  };
}

class ContentObject {
  ContentObject(
      {this.id,
        this.author,
        this.caption,
        this.sound,
        this.status,
        this.file,
        this.profileInfo,
        this.viewer,
        this.image,
        this.question,
        this.answer,
        this.saved,
        this.saved_id,
        this.archived,
        this.created});

  int? id;
  int? author;
  int? saved_id;
  String? caption;
  String? sound;
  String? status;
  String? file;
  ProfileInfo? profileInfo;
  List<ViewBy>? viewer;
  String? image;
  String? question;
  String? answer;
  String? created;
  bool? saved;
  bool? archived;

  factory ContentObject.fromJson(Map<String, dynamic> json) => ContentObject(
    id: json["id"],
    saved_id: json["saved_id"],
    author: json["author"],
    archived: json["archived"],
    created: json["created"],
    saved: json["saved"],
    caption: json["caption"] == null ? null : json["caption"],
    sound: json["sound"],
    status: json["status"] == null ? null : json["status"],
    file: json["file"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    viewer:
    List<ViewBy>.from(json["viewer"].map((x) => ViewBy.fromJson(x))),
    image: json["image"] == null ? null : json["image"],
    question: json["question"] == null ? null : json["question"],
    answer: json["answer"] == null ? null : json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "archived": archived,
    "author": author,
    "caption": caption == null ? null : caption,
    "sound": sound,
    "status": status == null ? null : status,
    "medias": file,
    "profile_info": profileInfo?.toJson(),
    "viewer": List<ViewBy>.from(viewer!.map((x) => x)),
    "image": image == null ? null : image,
    "question": question == null ? null : question,
    "answer": answer == null ? null : answer,
    "created": created,
    "saved": saved,
  };
}

class ViewBy {
  ViewBy({
    this.id,
    this.user,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.bio,
    this.gender,
    this.birthdate,
  });

  int? id;
  int? user;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? bio;
  String? gender;
  DateTime? birthdate;

  factory ViewBy.fromJson(Map<String, dynamic> json) => ViewBy(
    id: json["id"],
    user: json["user"],
    userName: json["user_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    image: json["image"],
    bio: json["bio"],
    gender: json["gender"],
    birthdate: json["birthdate"] == null
        ? null
        : DateTime.parse(json["birthdate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "user_name": userName,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "image": image,
    "bio": bio,
    "gender": gender,
    "birthdate":
    "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
  };
}

class Media {
  Media({
    this.id,
    this.file,
    this.will,
  });

  int? id;
  String? file;
  int? will;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    file: json["file"],
    will: json["will"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file": file,
    "will": will,
  };
}

class ProfileInfo {
  ProfileInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.user,
    this.userName,
    this.email,
    this.image,
    this.bio,
    this.gender,
  });

  int? id;
  String? firstName;
  String? lastName;
  DateTime? birthdate;
  int? user;
  String? userName;
  String? email;
  String? image;
  String? bio;
  String? gender;

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthdate: json["birthdate"] == null
        ? null
        : DateTime.parse(json["birthdate"]),
    user: json["user"],
    userName: json["user_name"],
    email: json["email"],
    image: json["image"],
    bio: json["bio"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birthdate":
    "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
    "user": user,
    "user_name": userName,
    "email": email,
    "image": image,
    "bio": bio,
    "gender": gender,
  };
}
