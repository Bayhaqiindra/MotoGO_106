import 'dart:convert';

class GetAllPengeluaranResponseModel {
    final String? message;
    final List<Datum>? data;

    GetAllPengeluaranResponseModel({
        this.message,
        this.data,
    });

    factory GetAllPengeluaranResponseModel.fromJson(String str) => GetAllPengeluaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllPengeluaranResponseModel.fromMap(Map<String, dynamic> json) => GetAllPengeluaranResponseModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final int? pengeluaranId;
    final String? jumlahPengeluaran;
    final String? deskripsiPengeluaran;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? categoryPengeluaran;

    Datum({
        this.pengeluaranId,
        this.jumlahPengeluaran,
        this.deskripsiPengeluaran,
        this.createdAt,
        this.updatedAt,
        this.categoryPengeluaran,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
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
