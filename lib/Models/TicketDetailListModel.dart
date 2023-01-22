class TicketDetailListModel {
  TicketDetailListModel({
    this.ticket,
    this.fromWho,
    this.body,
    this.created,
  });

  int? ticket;
  String? fromWho;
  String? body;
  DateTime? created;

  factory TicketDetailListModel.fromJson(Map<String, dynamic> json) =>
      TicketDetailListModel(
        ticket: json["ticket"],
        fromWho: json["from_who"],
        body: json["body"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "ticket": ticket,
        "from_who": fromWho,
        "body": body,
        "created": created?.toIso8601String(),
      };
}
