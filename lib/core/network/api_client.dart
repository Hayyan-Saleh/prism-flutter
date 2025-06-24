import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, required this.httpClient});

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );

      return handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on FormatException {
      throw ServerException('Invalid response format');
    } on http.ClientException {
      throw NetworkException('Failed to connect to server');
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      );

      return handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on FormatException {
      throw ServerException('Invalid response format');
    } on http.ClientException {
      throw NetworkException('Failed to connect to server');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      );

      return handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on FormatException {
      throw ServerException('Invalid response format');
    } on http.ClientException {
      throw NetworkException('Failed to connect to server');
    }
  }

  static Map<String, dynamic> handleResponse(http.Response response) {
    final Map<String, dynamic> data =
        response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }
    final message = data['message'] as String? ?? 'Request failed';
    throw ServerException(message);
  }
}
