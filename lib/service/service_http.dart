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
      headers['Content-Type'] = 'application/json'; // Tambahkan hanya untuk JSON
    }

    if (includeAuth) {
      final token = await secureStorage.read(key: 'authToken');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    print('[DEBUG] GET $url');
    print('[DEBUG] Headers: $headers');
    return await http.get(url, headers: headers);
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
    print('[DEBUG] Headers: $headers');
    print('[DEBUG] Body: $encodedBody');
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
    print('[DEBUG] Headers: $headers');
    print('[DEBUG] Body: $encodedBody');
    return await http.put(url, headers: headers, body: encodedBody);
  }

  Future<http.Response> delete(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);
    print('[DEBUG] DELETE $url');
    print('[DEBUG] Headers: $headers');
    return await http.delete(url, headers: headers);
  }

  /// Multipart request (misalnya untuk upload foto)
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
      isJson: false, // multipart tidak butuh Content-Type: application/json
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
    print('[DEBUG] Headers: ${request.headers}');
    print('[DEBUG] Fields: ${request.fields}');
    print('[DEBUG] File: ${file?.path}');

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
