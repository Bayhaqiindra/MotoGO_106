// File: lib/data/model/response/admin/delete_sparepart_response_model.dart

import 'dart:convert';

class DeleteSparepartResponseModel {
  final String? message;

  DeleteSparepartResponseModel({
    this.message,
  });

  // Factory constructor untuk membuat instance dari String JSON
  factory DeleteSparepartResponseModel.fromJson(String str) =>
      DeleteSparepartResponseModel.fromMap(json.decode(str));

  // Method untuk mengubah instance menjadi String JSON
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory DeleteSparepartResponseModel.fromMap(Map<String, dynamic> json) =>
      DeleteSparepartResponseModel(
        message: json["message"],
      );

  // Method untuk mengubah instance menjadi Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "message": message,
      };
}