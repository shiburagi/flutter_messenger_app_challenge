class User {
  String? name;
  String? mobileNumber;

  User({this.name, this.mobileNumber});

  User.fromJson(Map<String, dynamic> json) {
    this.name = json["name"];
    this.mobileNumber = json["mobile_number"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["mobile_number"] = this.mobileNumber;
    return data;
  }
}
