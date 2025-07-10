import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceHttp {
  final String baseUrl = 'http://10.0.2.2:8000/api/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({
    bool includeAuth = true,
    bool isJson = true,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final token = await secureStorage.read(key: 'authToken');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// ========== SAFE REQUEST HANDLER ==========
  Future<http.Response> safeRequest(Future<http.Response> Function() requestFn) async {
    try {
      final response = await requestFn();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw HttpException(
          'HTTP Error: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('[ERROR] $e');
      rethrow;
    }
  }

  /// ========== HTTP METHODS ==========
  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    print('[DEBUG] GET $url');
    return await http.get(url, headers: headers);
  }

  Future<http.Response> getWithQuery(
    String endpoint,
    Map<String, dynamic> queryParams, {
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())),
    );
    final headers = await _getHeaders(includeAuth: includeAuth);
    print('[DEBUG] GET (query) $uri');
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    final encodedBody = jsonEncode(body ?? {});
    print('[DEBUG] POST $url');
    return await http.post(url, headers: headers, body: encodedBody);
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    final encodedBody = jsonEncode(body ?? {});
    print('[DEBUG] PUT $url');
    return await http.put(url, headers: headers, body: encodedBody);
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    final encodedBody = jsonEncode(body ?? {});
    print('[DEBUG] PATCH $url');
    return await http.patch(url, headers: headers, body: encodedBody);
  }

  Future<http.Response> delete(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    print('[DEBUG] DELETE $url');
    return await http.delete(url, headers: headers);
  }

  Future<http.Response> sendMultipartRequest(
    String method,
    String endpoint, {
    Map<String, String>? fields,
    File? file,
    String fileFieldName = 'file',
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest(method, url);

    final headers = await _getHeaders(
      includeAuth: includeAuth,
      isJson: false,
    );
    request.headers.addAll(headers);

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
      ));
    }

    print('[DEBUG] MULTIPART $method $url');
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
