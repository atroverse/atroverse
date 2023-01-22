class RequestModel {
  RequestModel({
    this.owner,
    this.id,
  });

  int? owner;
  int? id;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    owner: json["owner"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "owner": owner,
    "id": id,
  };
}
