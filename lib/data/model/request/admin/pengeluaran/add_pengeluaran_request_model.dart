import 'dart:convert';

class AddPengeluaranRequestModel {
    final String? categoryPengeluaran;
    final int? jumlahPengeluaran;
    final String? deskripsiPengeluaran;

    AddPengeluaranRequestModel({
        this.categoryPengeluaran,
        this.jumlahPengeluaran,
        this.deskripsiPengeluaran,
    });

    factory AddPengeluaranRequestModel.fromJson(String str) => AddPengeluaranRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddPengeluaranRequestModel.fromMap(Map<String, dynamic> json) => AddPengeluaranRequestModel(
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
