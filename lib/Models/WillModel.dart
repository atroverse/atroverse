

import 'package:atroverse/Models/ArchiveWillModel.dart';
import 'package:atroverse/Models/AtroModel.dart';
import 'package:atroverse/Utils/StreamAudioPostWidget.dart';

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



class WillModel extends PageManager{
  WillModel({
    this.id,
    this.author,
    this.caption,
    this.sound,
    this.status,
    this.file,
    this.profileInfo,
    this.saved_id,
    this.created,
    this.viewer,
    this.saved,
    this.archived,
  }){
    init(sound.toString());
  }

  int? id;
  int? author;
  int? saved_id;
  String? caption;
  String? sound;
  String? status;
  ProfileInfo? profileInfo;
  String? created;
  String? file;
  List<ViewerBys>? viewer;
  bool? saved;
  bool? archived;

  factory WillModel.fromJson(Map<String, dynamic> json) => WillModel(
    id: json["id"],
    author: json["author"],
    saved_id: json["saved_id"],
    caption: json["caption"],
    sound: json["sound"],
    status: json["status"],
    file: json["file"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    created: json["created"],
    viewer: List<ViewerBys>.from(json["viewer"].map((x) => ViewerBys.fromJson(x))),
    saved: json["saved"],
    archived: json["archived"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author": author,
    "archived": archived,
    "caption": caption,
    "sound": sound,
    "status": status,
    "medias": file,
    "profile_info": profileInfo?.toJson(),
    "created": created,
    "viewer": List<ViewerBys>.from(viewer!.map((x) => x.toJson())),
    "saved": saved,
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
    this.county,
    this.city,
  });

  int? id;
  String? firstName;
  String? lastName;
  dynamic? birthdate;
  int? user;
  String? userName;
  String? email;
  String? image;
  String? bio;
  String? gender;
  String? county;
  String? city;

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthdate: json["birthdate"],
    user: json["user"],
    userName: json["user_name"],
    email: json["email"],
    image: json["image"] == null ? null : json["image"],
    bio: json["bio"],
    gender: json["gender"],
    county: json["county"] == null ? null : json["county"],
    city: json["city"] == null ? null : json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birthdate": birthdate,
    "user": user,
    "user_name": userName,
    "email": email,
    "image": image == null ? null : image,
    "bio": bio,
    "gender": gender,
    "county": county == null ? null : county,
    "city": city == null ? null : city,
  };
}

class ViewerBys {
  ViewerBys({
    this.id,
    this.user,
    this.county,
    this.city,
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
  String? county;
  String? city;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? bio;
  String? gender;
  dynamic birthdate;

  factory ViewerBys.fromJson(Map<String, dynamic> json) => ViewerBys(
    id: json["id"],
    user: json["user"],
    county: json["county"],
    city: json["city"],
    userName: json["user_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    image: json["image"],
    bio: json["bio"],
    gender: json["gender"],
    birthdate: json["birthdate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "county": county,
    "city": city,
    "user_name": userName,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "image": image,
    "bio": bio,
    "gender": gender,
    "birthdate": birthdate,
  };
}
