class Chat {
  String? message;
  String? senderId;
  String? senderName;
  int? createdMillis;

  Chat({this.message, this.senderId, this.senderName, this.createdMillis});

  Chat.fromJson(Map<String, dynamic> json) {
    this.message = json["message"];
    this.senderId = json["sender_id"];
    this.senderName = json["sender_name"];

    if (json["created_millis"] is String)
      this.createdMillis = int.tryParse(json["created_millis"]);
    if (json["created_millis"] is int)
      this.createdMillis = json["created_millis"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["message"] = this.message;
    data["sender_id"] = this.senderId;
    data["sender_name"] = this.senderName;
    data["created_millis"] = this.createdMillis.toString();
    return data;
  }
}
