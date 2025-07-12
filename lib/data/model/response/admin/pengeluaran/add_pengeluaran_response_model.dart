import 'dart:convert';

class AddPengeluaranResponseModel {
    final String? message;
    final Data? data;

    AddPengeluaranResponseModel({
        this.message,
        this.data,
    });

    factory AddPengeluaranResponseModel.fromJson(String str) => AddPengeluaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddPengeluaranResponseModel.fromMap(Map<String, dynamic> json) => AddPengeluaranResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final String? categoryPengeluaran;
    final int? jumlahPengeluaran;
    final String? deskripsiPengeluaran;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? pengeluaranId;

    Data({
        this.categoryPengeluaran,
        this.jumlahPengeluaran,
        this.deskripsiPengeluaran,
        this.updatedAt,
        this.createdAt,
        this.pengeluaranId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        categoryPengeluaran: json["category_pengeluaran"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        pengeluaranId: json["pengeluaran_id"],
    );

    Map<String, dynamic> toMap() => {
        "category_pengeluaran": categoryPengeluaran,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "pengeluaran_id": pengeluaranId,
    };
}
