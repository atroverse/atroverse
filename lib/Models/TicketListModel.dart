class TicketListModel {
  TicketListModel({
    this.id,
    this.user,
    this.title,
    this.type,
    this.status,
    this.closedAt,
    this.code,
  });

  int? id;
  int? user;
  String? title;
  String? type;
  String? status;
  DateTime? closedAt;
  String? code;

  factory TicketListModel.fromJson(Map<String, dynamic> json) =>
      TicketListModel(
        id: json["id"],
        user: json["user"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        closedAt: json["closed_at"] == null
            ? null
            : DateTime.parse(json["closed_at"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "title": title,
        "type": type,
        "status": status,
        "closed_at": closedAt?.toIso8601String(),
        "code": code,
      };
}
