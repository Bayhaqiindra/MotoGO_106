import 'dart:convert';

class PelangganProfileResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    PelangganProfileResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory PelangganProfileResponseModel.fromJson(String str) => PelangganProfileResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PelangganProfileResponseModel.fromMap(Map<String, dynamic> json) => PelangganProfileResponseModel(
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
    final int? idPelanggan;
    final String? name;
    final String? phone;
    final String? address;
    final String? profilePicture;

    Data({
        this.idPelanggan,
        this.name,
        this.phone,
        this.address,
        this.profilePicture,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        idPelanggan: json["id_pelanggan"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toMap() => {
        "id_pelanggan": idPelanggan,
        "name": name,
        "phone": phone,
        "address": address,
        "profile_picture": profilePicture,
    };
}
