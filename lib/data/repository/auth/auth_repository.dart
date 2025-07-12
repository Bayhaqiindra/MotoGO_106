import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tugas_akhir/data/model/request/auth/login_request_model.dart';
import 'package:tugas_akhir/data/model/request/auth/register_request_model.dart';
import 'package:tugas_akhir/data/model/response/auth/login_response_model.dart';
import 'package:tugas_akhir/data/model/response/auth/register_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

class AuthRepository {
  final ServiceHttp _serviceHttp;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttp);

  Future<Either<String, LoginResponseModel>> login(
      LoginRequestModel requestModel) async {
    try {
      if (kDebugMode) {
        print('AuthRepository: Attempting login for email: ${requestModel.email}');
      }
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
        if (kDebugMode) {
          print('AuthRepository: Login successful!');
          print('AuthRepository: Stored Token: ${loginData.data!.token!}');
          print('AuthRepository: Stored Role: ${loginData.data!.role ?? 'N/A'}');
        }
        return Right(loginData);
      } else {
        String errorMsg = loginData.message ?? 'Login gagal';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((k, v) {
            errorMsg += "\n${(v as List).join(', ')}";
          });
        }
        if (kDebugMode) {
          print('AuthRepository: Login failed! Status: ${response.statusCode}, Message: $errorMsg');
          print('AuthRepository: Full API Response Body on failure: ${response.body}');
        }
        return Left(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthRepository: Login error caught: $e');
      }
      return Left("Login error: $e");
    }
  }

  Future<Either<String, RegisterResponseModel>> register(
      RegisterRequestModel requestModel) async {
    try {
      if (kDebugMode) {
        print('AuthRepository: Attempting registration for email: ${requestModel.email}');
      }
      final response = await _serviceHttp.post(
        "register",
        body: requestModel.toMap(),
        includeAuth: false,
      );

      final jsonResponse = json.decode(response.body);
      final registerData = RegisterResponseModel.fromMap(jsonResponse);

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('AuthRepository: Registration successful!');
        }
        return Right(registerData);
      } else {
        String errorMsg = registerData.message ?? 'Registrasi gagal';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((k, v) {
            errorMsg += "\n${(v as List).join(', ')}";
          });
        }
        if (kDebugMode) {
          print('AuthRepository: Registration failed! Status: ${response.statusCode}, Message: $errorMsg');
          print('AuthRepository: Full API Response Body on failure: ${response.body}');
        }
        return Left(errorMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthRepository: Register error caught: $e');
      }
      return Left("Register error: $e");
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      if (kDebugMode) {
        print('AuthRepository: Attempting logout...');
      }
      final response = await _serviceHttp.post(
        "logout",
        includeAuth: true,
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        await secureStorage.deleteAll();
        if (kDebugMode) {
          print('AuthRepository: Logout successful! All stored data cleared.');
        }
        return Right(jsonResponse['message'] ?? "Logout berhasil.");
      } else {
        if (kDebugMode) {
          print('AuthRepository: Logout failed! Status: ${response.statusCode}, Message: ${jsonResponse['message'] ?? "Unknown"}');
        }
        return Left(jsonResponse['message'] ?? "Logout gagal.");
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthRepository: Logout error caught: $e');
      }
      return Left("Logout error: $e");
    }
  }

  Future<String?> getStoredToken() async {
    final token = await secureStorage.read(key: "authToken");
    if (kDebugMode) {
      print('AuthRepository: Retrieved Token from storage: ${token != null ? 'Exists' : 'NULL'}');
    }
    return token;
  }

  Future<String?> getStoredRole() async {
    final role = await secureStorage.read(key: "userRole");
    if (kDebugMode) {
      print('AuthRepository: Retrieved Role from storage: ${role ?? 'NULL'}');
    }
    return role;
  }
}