import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_controller.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });
}

class NetworkCaller {
  static Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (AuthController.accessToken != null)
      'token': AuthController.accessToken!,
  };

  static Future<NetworkResponse> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: _headers());
      return _handleResponse(response);
    } catch (e) {
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers(),
        body: jsonEncode(body ?? {}),
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> patchRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: _headers(),
        body: jsonEncode(body ?? {}),
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> deleteRequest(String url) async {
    try {
      final response = await http.delete(Uri.parse(url), headers: _headers());
      return _handleResponse(response);
    } catch (e) {
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static NetworkResponse _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: decoded,
      );
    } else {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: decoded['msg'] ?? 'Something went wrong',
      );
    }
  }
}