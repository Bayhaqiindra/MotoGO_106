import 'dart:convert';

import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart';

class StatusBookingDetailResponseModel { // Mengganti nama dari StatusBookingServiceResponseModel agar lebih spesifik
  final String? message;
  final AdmingetallbookingResponseModel? data; // Menggunakan AdmingetallbookingResponseModel sebagai data

  StatusBookingDetailResponseModel({
    this.message,
    this.data,
  });

  factory StatusBookingDetailResponseModel.fromJson(String str) => StatusBookingDetailResponseModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory StatusBookingDetailResponseModel.fromMap(Map<String, dynamic> json) => StatusBookingDetailResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : AdmingetallbookingResponseModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}