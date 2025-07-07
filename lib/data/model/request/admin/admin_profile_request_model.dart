import 'dart:convert';

class AdminProfileRequestModel {
    final String? name;
    final String? profilePicture;

    AdminProfileRequestModel({
        this.name,
        this.profilePicture,
    });

    factory AdminProfileRequestModel.fromJson(String str) => AdminProfileRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdminProfileRequestModel.fromMap(Map<String, dynamic> json) => AdminProfileRequestModel(
        name: json["name"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "profile_picture": profilePicture,
    };
}
