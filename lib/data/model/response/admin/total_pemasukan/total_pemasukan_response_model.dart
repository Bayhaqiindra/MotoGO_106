import 'dart:convert';

class TotalPemasukanResponseModel {
    final String? message;
    final String? pemasukanSparepart;
    final String? pemasukanService;
    final int? totalPemasukan;

    TotalPemasukanResponseModel({
        this.message,
        this.pemasukanSparepart,
        this.pemasukanService,
        this.totalPemasukan,
    });

    factory TotalPemasukanResponseModel.fromJson(String str) => TotalPemasukanResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TotalPemasukanResponseModel.fromMap(Map<String, dynamic> json) => TotalPemasukanResponseModel(
        message: json["message"],
        pemasukanSparepart: json["pemasukan_sparepart"],
        pemasukanService: json["pemasukan_service"],
        totalPemasukan: json["total_pemasukan"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "pemasukan_sparepart": pemasukanSparepart,
        "pemasukan_service": pemasukanService,
        "total_pemasukan": totalPemasukan,
    };
}
