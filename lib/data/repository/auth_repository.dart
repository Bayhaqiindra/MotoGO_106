import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tugas_akhir/data/model/request/auth/login_request_model.dart';
import 'package:tugas_akhir/data/model/request/auth/register_request_model.dart';
import 'package:tugas_akhir/data/model/response/auth/login_response_model.dart';
import 'package:tugas_akhir/data/model/response/auth/register_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

class AuthRepository {
  final ServiceHttp _serviceHttp;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttp);

  Future<Either<String, LoginResponseModel>> login(
      LoginRequestModel requestModel) async {
    try {
      final response = await _serviceHttp.post(
        "login",
        body: requestModel.toMap(),
        includeAuth: false,
      );

      final jsonResponse = json.decode(response.body);
      final loginData = LoginResponseModel.fromMap(jsonResponse);

      if (response.statusCode == 200 && loginData.data?.token != null) {
        await secureStorage.write(
          key: 'authToken',
          value: loginData.data!.token!,
        );
        await secureStorage.write(
          key: 'userRole',
          value: loginData.data!.role ?? '',
        );
        return Right(loginData);
      } else {
        String errorMsg = loginData.message ?? 'Login gagal';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((k, v) {
            errorMsg += "\n${(v as List).join(', ')}";
          });
        }
        return Left(errorMsg);
      }
    } catch (e) {
      return Left("Login error: $e");
    }
  }

  Future<Either<String, RegisterResponseModel>> register(
      RegisterRequestModel requestModel) async {
    try {
      final response = await _serviceHttp.post(
        "register",
        body: requestModel.toMap(),
        includeAuth: false,
      );

      final jsonResponse = json.decode(response.body);
      final registerData = RegisterResponseModel.fromMap(jsonResponse);

      if (response.statusCode == 201) {
        return Right(registerData);
      } else {
        String errorMsg = registerData.message ?? 'Registrasi gagal';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((k, v) {
            errorMsg += "\n${(v as List).join(', ')}";
          });
        }
        return Left(errorMsg);
      }
    } catch (e) {
      return Left("Register error: $e");
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final response = await _serviceHttp.post(
        "logout",
        includeAuth: true,
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        await secureStorage.deleteAll();
        return Right(jsonResponse['message'] ?? "Logout berhasil.");
      } else {
        return Left(jsonResponse['message'] ?? "Logout gagal.");
      }
    } catch (e) {
      return Left("Logout error: $e");
    }
  }

  Future<String?> getStoredToken() => secureStorage.read(key: "authToken");
  Future<String?> getStoredRole() => secureStorage.read(key: "userRole");
}
