class ProfileModel {
  ProfileModel(
      {this.id,
      this.user,
      this.atro_count,
      this.will_count,
      this.userName,
      this.firstName,
      this.lastName,
      this.image,
      this.bio,
      this.gender,
      this.birthdate,
      this.registerLink,
      this.friendLink,
      this.poten_number,
      this.invite_code,
      this.friend_code,
      this.verified,
      this.country,
      this.city,
      this.done,
      this.email,
      this.friend_ship_id,
      this.friendShipDeleteId,
      this.delete_friend_time,
      this.state});

  int? id;
  int? user;
  int? atro_count;
  int? will_count;
  int? poten_number;
  String? userName;
  String? firstName;
  String? invite_code;
  String? friend_code;
  String? lastName;
  String? image;
  String? bio;
  String? gender;
  DateTime? birthdate;
  String? registerLink;
  String? friendLink;
  String? country;
  String? email;
  String? city;
  String? state;
  String? delete_friend_time;
  int? friend_ship_id;
  List<int>? friendShipDeleteId;
  bool? verified;
  bool? done;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        user: json["user"],
        done: json["done"],
        atro_count: json["atro_count"],
        will_count: json["will_count"],
    friend_code: json["friend_code"],
        country: json["county"],
    friendShipDeleteId: json["friend_ship_delete_id"] == null?null:List<int>.from(json["friend_ship_delete_id"].map((x) => x)),
        friend_ship_id: json["friend_ship_id"],
        delete_friend_time: json["delete_friend_time"],
        state: json["state"],
        email: json["email"],
        city: json["city"],
        verified: json["verified"],
        invite_code: json["invite_code"],
        userName: json["user_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        bio: json["bio"],
        poten_number: json["poten_number"],
        gender: json["gender"],
        birthdate: (json["birthdate"] == null)
            ? null
            : DateTime.parse(json["birthdate"]),
        registerLink: json["register_link"],
        friendLink: json["friend_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "done": done,
        "email": email,
    "friend_ship_delete_id": List<dynamic>.from(friendShipDeleteId!.map((x) => x)),
        "user_name": userName,
        "friend_code": friend_code,
        "delete_friend_time": delete_friend_time,
        "state": state,
        "city": city,
        "friend_ship_id": friend_ship_id,
        "country": country,
        "invite_code": invite_code,
        "first_name": firstName,
        "verified": verified,
        "last_name": lastName,
        "image": image,
        "bio": bio,
        "poten_number": poten_number,
        "gender": gender,
        "birthdate":
            "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
        "register_link": registerLink,
        "friend_link": friendLink,
      };
}
