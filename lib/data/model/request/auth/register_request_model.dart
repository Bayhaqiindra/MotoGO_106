import 'dart:convert';

class RegisterRequestModel {
    final String? email;
    final String? password;

    RegisterRequestModel({
        this.email,
        this.password,
    });

    factory RegisterRequestModel.fromJson(String str) => RegisterRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterRequestModel.fromMap(Map<String, dynamic> json) => RegisterRequestModel(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
    };
}
