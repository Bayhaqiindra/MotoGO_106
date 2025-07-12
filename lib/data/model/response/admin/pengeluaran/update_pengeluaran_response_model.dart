import 'dart:convert';

class UpdatePengeluaranResponseModel {
    final String? message;
    final Data? data;

    UpdatePengeluaranResponseModel({
        this.message,
        this.data,
    });

    factory UpdatePengeluaranResponseModel.fromJson(String str) => UpdatePengeluaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdatePengeluaranResponseModel.fromMap(Map<String, dynamic> json) => UpdatePengeluaranResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? pengeluaranId;
    final int? jumlahPengeluaran;
    final String? deskripsiPengeluaran;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? categoryPengeluaran;

    Data({
        this.pengeluaranId,
        this.jumlahPengeluaran,
        this.deskripsiPengeluaran,
        this.createdAt,
        this.updatedAt,
        this.categoryPengeluaran,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        pengeluaranId: json["pengeluaran_id"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        categoryPengeluaran: json["category_pengeluaran"],
    );

    Map<String, dynamic> toMap() => {
        "pengeluaran_id": pengeluaranId,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category_pengeluaran": categoryPengeluaran,
    };
}
