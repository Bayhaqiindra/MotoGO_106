import 'dart:convert';

class DeletePengeluaranResponseModel {
    final String? message;

    DeletePengeluaranResponseModel({
        this.message,
    });

    factory DeletePengeluaranResponseModel.fromJson(String str) => DeletePengeluaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DeletePengeluaranResponseModel.fromMap(Map<String, dynamic> json) => DeletePengeluaranResponseModel(
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
    };
}
