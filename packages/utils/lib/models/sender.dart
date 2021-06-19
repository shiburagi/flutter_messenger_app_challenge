class Sender {
  String? name;
  String? lastMessage;
  int? updatedMillis;
  String? senderId;

  Sender({this.name, this.lastMessage, this.updatedMillis, this.senderId});

  Sender.fromJson(Map<String, dynamic> json) {
    this.name = json["name"];
    this.lastMessage = json["last_message"];
    this.updatedMillis = json["updated_millis"];
    this.senderId = json["sender_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["last_message"] = this.lastMessage;
    data["updated_millis"] = this.updatedMillis;
    data["sender_id"] = this.senderId;
    return data;
  }
}
