import 'dart:convert';

class UpdatePengeluaranRequestModel {
    final String? categoryPengeluaran;
    final int? jumlahPengeluaran;
    final String? deskripsiPengeluaran;

    UpdatePengeluaranRequestModel({
        this.categoryPengeluaran,
        this.jumlahPengeluaran,
        this.deskripsiPengeluaran,
    });

    factory UpdatePengeluaranRequestModel.fromJson(String str) => UpdatePengeluaranRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdatePengeluaranRequestModel.fromMap(Map<String, dynamic> json) => UpdatePengeluaranRequestModel(
        categoryPengeluaran: json["category_pengeluaran"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
    );

    Map<String, dynamic> toMap() => {
        "category_pengeluaran": categoryPengeluaran,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
    };
}
