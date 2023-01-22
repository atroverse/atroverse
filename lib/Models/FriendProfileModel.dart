import 'package:atroverse/Models/AtroModel.dart';
import 'package:atroverse/Utils/StreamAudioPostWidget.dart';

class FriendProfileModel {
  FriendProfileModel(
      {this.id,
        this.user,
        this.userName,
        this.firstName,
        this.lastName,
        this.email,
        this.image,
        this.bio,
        this.gender,
        this.birthdate,
        this.registerLink,
        this.friendLink,
        this.will_count,
        this.potenNumber,
        this.atroCount,
        this.atroes,
        this.wills});

  int? id;
  int? user;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? bio;
  String? gender;
  String? birthdate;
  String? registerLink;
  String? friendLink;
  int? will_count;
  int? potenNumber;
  int? atroCount;
  List<Atroe>? atroes;
  List<WillsModel>? wills;

  factory FriendProfileModel.fromJson(Map<String, dynamic> json) =>
      FriendProfileModel(
        id: json["id"],
        user: json["user"],
        userName: json["user_name"],
        firstName: json["first_name"],
        will_count: json["will_count"],
        lastName: json["last_name"],
        email: json["email"],
        image: json["image"],
        bio: json["bio"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        registerLink: json["register_link"],
        friendLink: json["friend_link"],
        potenNumber: json["poten_number"],
        atroCount: json["atro_count"],
        atroes: List<Atroe>.from(json["atroes"].map((x) => Atroe.fromJson(x))),
        wills: json["wills"] == null?null:List<WillsModel>.from(
            json["wills"].map((x) => WillsModel.fromJson(x))),
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
    "birthdate": birthdate,
    "register_link": registerLink,
    "friend_link": friendLink,
    "poten_number": potenNumber,
    "atro_count": atroCount,
    "atroes": List<dynamic>.from(atroes!.map((x) => x.toJson())),
  };
}

class Atroe extends PageManager{
  Atroe({
    this.id,
    this.author,
    this.image,
    this.question,
    this.answer,
    this.sound,
    this.profileInfo,
    this.viewer,
    this.saved_id,
  }){
    init(sound.toString());
  }

  int? id;
  int? saved_id;
  int? author;
  String? image;
  String? question;
  String? answer;
  String? sound;
  ProfileInfo? profileInfo;
  List<ProfileInfo>? viewer;

  factory Atroe.fromJson(Map<String, dynamic> json) => Atroe(
    id: json["id"],
    author: json["author"],
    saved_id: json["saved_id"],
    image: json["image"],
    question: json["question"],
    answer: json["answer"],
    sound: json["sound"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    viewer: List<ProfileInfo>.from(
        json["viewer"].map((x) => ProfileInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author": author,
    "image": image,
    "question": question,
    "answer": answer,
    "sound": sound,
    "profile_info": profileInfo?.toJson(),
    "viewer": List<dynamic>.from(viewer!.map((x) => x.toJson())),
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
    userName: json["user_name"] == null ? null : json["user_name"],
    email: json["email"],
    image: json["image"] == null ? null : json["image"],
    bio: json["bio"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birthdate": birthdate == null
        ? null
        : "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
    "user": user,
    "user_name": userName,
    "email": email,
    "image": image,
    "bio": bio,
    "gender": gender,
  };
}

class WillsModel extends PageManager{
  WillsModel({
    this.id,
    this.author,
    this.caption,
    this.sound,
    this.status,
    this.file,
    this.profileInfo,
    this.created,
    this.viewer,
    this.saved_id,
    this.saved,
  }){
    init(sound.toString());
  }

  int? id;
  int? saved_id;
  int? author;
  String? caption;
  String? sound;
  String? status;
  String? file;
  ProfileInfo? profileInfo;
  String? created;
  List<ProfileInfo>? viewer;
  bool? saved;

  factory WillsModel.fromJson(Map<String, dynamic> json) => WillsModel(
    id: json["id"],
    author: json["author"],
    saved_id: json["saved_id"],
    caption: json["caption"],
    sound: json["sound"],
    status: json["status"],
    file: json["file"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    created: json["created"],
    viewer: List<ProfileInfo>.from(
        json["viewer"].map((x) => ProfileInfo.fromJson(x))),
    saved: json["saved"],
  );

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
