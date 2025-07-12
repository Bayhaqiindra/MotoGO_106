// lib/data/model/common/pelanggan/pelanggan_model.dart
import 'dart:convert';

class Pelanggan {
    final int? idPelanggan;
    final int? userId;
    final String? name;
    final String? phone;
    final String? profilePicture;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? address;

    Pelanggan({
        this.idPelanggan,
        this.userId,
        this.name,
        this.phone,
        this.profilePicture,
        this.createdAt,
        this.updatedAt,
        this.address,
    });

    factory Pelanggan.fromJson(String str) => Pelanggan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pelanggan.fromMap(Map<String, dynamic> json) => Pelanggan(
        idPelanggan: json["id_pelanggan"],
        userId: json["user_id"],
        name: json["name"],
        phone: json["phone"],
        profilePicture: json["profile_picture"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        address: json["address"],
    );

    Map<String, dynamic> toMap() => {
        "id_pelanggan": idPelanggan,
        "user_id": userId,
        "name": name,
        "phone": phone,
        "profile_picture": profilePicture,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "address": address,
    };
}