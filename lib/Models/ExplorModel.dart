class ExploreModel {
  ExploreModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic next;
  dynamic previous;
  List<Result?>? results;

  factory ExploreModel.fromJson(Map<String, dynamic> json) => ExploreModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null
        ? []
        : List<Result?>.from(
        json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x!.toJson())),
  };
}

class Result {
  Result({
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    author: json["author"],
    image: json["image"],
    saved_id: json["saved_id"],
    question: json["question"],
    answer: json["answer"],
    sound: json["sound"],
    profileInfo: ProfileInfo.fromJson(json["profile_info"]),
    viewer: json["viewer"] == null
        ? []
        : List<ProfileInfo?>.from(
        json["viewer"]!.map((x) => ProfileInfo.fromJson(x))),
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
    "viewer": viewer == null
        ? []
        : List<dynamic>.from(viewer!.map((x) => x!.toJson())),
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
