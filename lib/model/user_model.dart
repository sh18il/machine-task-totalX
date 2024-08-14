class UserModel {
  String? name;
  int? age;
  String? phone;
  String? image;

  UserModel(
      {required this.name,
      required this.age,
      required this.phone,
      required this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    age = json["age"];
    phone = json["phone"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "phone": phone,
      "image": image,
    };
  }
}
