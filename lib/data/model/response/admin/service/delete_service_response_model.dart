import 'dart:convert';

class DeleteServiceResponseModel {
    final String? message;
    final int? statusCode;
    final dynamic data;

    DeleteServiceResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory DeleteServiceResponseModel.fromJson(String str) => DeleteServiceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DeleteServiceResponseModel.fromMap(Map<String, dynamic> json) => DeleteServiceResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data,
    };
}
