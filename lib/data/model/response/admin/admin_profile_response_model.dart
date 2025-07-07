import 'dart:convert';

class AdminProfileResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    AdminProfileResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory AdminProfileResponseModel.fromJson(String str) => AdminProfileResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdminProfileResponseModel.fromMap(Map<String, dynamic> json) => AdminProfileResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
    };
}

class Data {
    final int? idAdmin;
    final String? name;
    final String? profilePicture;

    Data({
        this.idAdmin,
        this.name,
        this.profilePicture,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        idAdmin: json["id_admin"],
        name: json["name"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toMap() => {
        "id_admin": idAdmin,
        "name": name,
        "profile_picture": profilePicture,
    };
}
