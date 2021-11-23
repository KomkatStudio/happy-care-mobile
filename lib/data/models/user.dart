// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.profile,
    required this.id,
    required this.email,
    required this.role,
    this.specializations,
    this.background,
  });

  Profile? profile;
  late String id;
  late String email;
  late String role;
  late List<String?>? specializations;
  late List<Background?>? background;

  User.init();

  factory User.fromJson(Map<String, dynamic> json) => User(
        profile: Profile.fromJson(json["profile"]),
        id: json["_id"],
        email: json["email"],
        role: json["role"],
        specializations:
            List<String>.from(json["specializations"].map((x) => x)),
        background: List<Background>.from(
            json["background"].map((x) => Background.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile?.toJson(),
        "_id": id,
        "email": email,
        "role": role,
        "specializations": List<dynamic>.from(specializations!.map((x) => x)),
        "background": List<dynamic>.from(background!.map((x) => x?.toJson())),
      };
}

class Background {
  Background({
    this.description,
    this.id,
  });

  String? description;
  String? id;

  String? get degree => description?.split("  ").first;
  String? get workLocation => description?.split("  ")[1];

  factory Background.fromJson(Map<String, dynamic> json) => Background(
        description: json["description"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "_id": id,
      };
}

class Profile {
  Profile({
    this.fullname,
    this.gender,
    this.age,
    this.phone,
    this.address,
  });

  String? fullname;
  String? gender;
  int? age;
  String? phone;
  String? address;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        fullname: json["fullname"],
        gender: json["gender"],
        age: json["age"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "gender": gender,
        "age": age,
        "phone": phone,
        "address": address,
      };
}
