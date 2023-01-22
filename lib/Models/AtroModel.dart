import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../Utils/StreamAudioPostWidget.dart';

class AtroPageModel {
  AtroPageModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  String? next;
  String? previous;
  List<AtroModel>? results;

  factory AtroPageModel.fromJson(Map<String, dynamic> json) => AtroPageModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<AtroModel>.from(
        json["results"].map((x) => AtroModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class AtroModel extends PageManager {
  AtroModel({
    this.id,
    this.author,
    this.image,
    this.question,
    this.answer,
    this.sound,
    this.profileInfo,
    this.viewer,
    this.created,
    this.archived,
    this.saved,
    this.saved_id,
    this.status,
    this.comment_count,
  }) {
    init(sound.toString());
  }

  int? id;
  int? author;
  int? saved_id;
  int? comment_count;
  String? image;
  String? question;
  String? answer;
  String? sound;
  ProfileInfo? profileInfo;
  List<ViewBy>? viewer;
  String? created;
  String? status;
  bool? saved;
  bool? archived;
  RxBool sending = false.obs;
  AudioPlayer justAudio = AudioPlayer();

  factory AtroModel.fromJson(Map<String, dynamic> json) => AtroModel(
    id: json["id"],
    author: json["author"],
    saved_id: json["saved_id"],
    status: json["status"],
    archived: json["archived"],
    comment_count: json["comment_count"],
    image: json["image"],
    question: json["question"],
    answer: json["answer"],
    sound: json["sound"],
    created: json["created"],
    saved: json["saved"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    viewer: json["viewer"] == null
        ? null
        : List<ViewBy>.from(json["viewer"].map((x) => ViewBy.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author": author,
    "image": image,
    "question": question,
    "archived": archived,
    "answer": answer,
    "sound": sound,
    "comment_count": comment_count,
    "profile_info": profileInfo?.toJson(),
    "viewer": List<ViewBy>.from(viewer!.map((x) => x)),
    "created": created,
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
  });

  int? id;
  String? firstName;
  String? lastName;
  String? birthdate;
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
    birthdate: json["birthdate"],
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
    "birthdate": birthdate,
    "user": user,
    "user_name": userName,
    "email": email,
    "image": image,
    "bio": bio,
    "gender": gender,
  };
}

class Comment {
  Comment(
      {this.id,
        this.user,
        this.email,
        this.sound,
        this.content,
        this.posted,
        this.replyCount,
        this.mention_id,
        this.parent});

  int? id;
  User? user;
  String? email;
  RxBool isDelete = false.obs;
  RxBool loading = false.obs;
  RxBool loading2 = true.obs;
  RxString message = "show more".obs;
  RxList<Comment> replies = <Comment>[].obs;
  String? sound;
  String? content;
  String? posted;
  RxBool showComments = false.obs;
  int? replyCount;
  String? mention_id;
  int? parent;
  AudioPlayer player = AudioPlayer();
  Duration? duration;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    user: User.fromJson(json["user"]),
    email: json["email"],
    sound: json["sound"],
    mention_id: json["mention_id"],
    parent: json["parent"],
    content: json["content"],
    posted: json["posted"],
    replyCount: json["reply_count"],
    // replies: RxList<Comment>.from(json["replies"].map((x) => Comment.fromJson(x))),
  );

  static getData(data) {
    return List<Comment>.from(data.map((x) => Comment.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "email": email,
    "sound": sound,
    "content": content,
    "posted": posted,
    "reply_count": replyCount,
  };
}

class User {
  User({
    this.id,
    this.email,
    this.profile,
  });

  int? id;
  String? email;
  Profile? profile;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    profile: Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "profile": profile?.toJson(),
  };
}

class Profile {
  Profile({
    this.county,
    this.city,
    this.userName,
    this.bio,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthdate,
    this.image,
  });

  dynamic? county;
  dynamic? city;
  String? userName;
  String? bio;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? gender;
  dynamic? birthdate;
  String? image;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    county: json["county"],
    city: json["city"],
    userName: json["user_name"],
    bio: json["bio"],
    phoneNumber: json["phone_number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    gender: json["gender"],
    birthdate: json["birthdate"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "county": county,
    "city": city,
    "user_name": userName,
    "bio": bio,
    "phone_number": phoneNumber,
    "first_name": firstName,
    "last_name": lastName,
    "gender": gender,
    "birthdate": birthdate,
    "image": image,
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
    gender: json["gender"] ?? null,
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
