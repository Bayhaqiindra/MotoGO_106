import 'dart:convert';

class TotalPengeluaranResponseModel {
    final String? message;
    final String? totalPengeluaran;

    TotalPengeluaranResponseModel({
        this.message,
        this.totalPengeluaran,
    });

    factory TotalPengeluaranResponseModel.fromJson(String str) => TotalPengeluaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TotalPengeluaranResponseModel.fromMap(Map<String, dynamic> json) => TotalPengeluaranResponseModel(
        message: json["message"],
        totalPengeluaran: json["total_pengeluaran"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "total_pengeluaran": totalPengeluaran,
    };
}
