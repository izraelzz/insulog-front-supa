import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:insulog/services/local/api_ip_service.dart';

class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();

  factory ApiService() => _instance;

  final ApiIpService _apiIpService = ApiIpService();

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> post(String endPoint, Map<String, dynamic> body) async {
    final uri = await _buildUri(endPoint);
    var data;

    try {
      _logRequest('POST', uri, body: body);

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      data = _decodeResponseBody(response.body);
      _logResponse('POST', uri, response.statusCode, data);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final message = _readErrorMessage(data, response.statusCode);
        _logApiError('POST', uri, response.statusCode, message);

        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      _logApiError('POST', uri, 408, 'Tempo de resposta excedido.');

      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      _logApiError('POST', uri, 503, 'Nao foi possivel conectar ao servidor.');

      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }

  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    final uri = await _buildUri(endPoint);
    var data;

    try {
      _logRequest('PUT', uri, body: body);

      final response = await http
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      data = _decodeResponseBody(response.body);
      _logResponse('PUT', uri, response.statusCode, data);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final message = _readErrorMessage(data, response.statusCode);
        _logApiError('PUT', uri, response.statusCode, message);

        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      _logApiError('PUT', uri, 408, 'Tempo de resposta excedido.');

      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      _logApiError('PUT', uri, 503, 'Nao foi possivel conectar ao servidor.');

      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }

  Future<dynamic> get(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final formattedQueryParameters = queryParameters
        ?.map((key, value) => MapEntry(key, value?.toString()))
        .entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .fold<Map<String, String>>(
          {},
          (params, entry) => params..[entry.key] = entry.value!,
        );

    final uri = (await _buildUri(endPoint)).replace(
      queryParameters: formattedQueryParameters?.isEmpty == true
          ? null
          : formattedQueryParameters,
    );
    var data;

    try {
      _logRequest('GET', uri);

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      data = _decodeResponseBody(response.body);
      _logResponse('GET', uri, response.statusCode, data);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final message = _readErrorMessage(data, response.statusCode);
        _logApiError('GET', uri, response.statusCode, message);

        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      _logApiError('GET', uri, 408, 'Tempo de resposta excedido.');

      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      _logApiError('GET', uri, 503, 'Nao foi possivel conectar ao servidor.');

      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }

  Future<dynamic> delete(String endPoint) async {
    final uri = await _buildUri(endPoint);
    var data;

    try {
      _logRequest('DELETE', uri);

      final response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      data = _decodeResponseBody(response.body);
      _logResponse('DELETE', uri, response.statusCode, data);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        final message = _readErrorMessage(data, response.statusCode);
        _logApiError('DELETE', uri, response.statusCode, message);

        throw ApiException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      _logApiError('DELETE', uri, 408, 'Tempo de resposta excedido.');

      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      _logApiError('DELETE', uri, 503, 'Nao foi possivel conectar ao servidor.');

      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }

  Future<Uri> _buildUri(String endPoint) async {
    final baseUrl = await _apiIpService.getBaseUrl();
    return Uri.parse('$baseUrl/$endPoint');
  }

  String _readErrorMessage(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return 'Erro na API $statusCode';
  }

  dynamic _decodeResponseBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  void _logRequest(String method, Uri uri, {Map<String, dynamic>? body}) {
    debugPrint('[API][$method] -> $uri');

    if (body != null) {
      debugPrint('[API][$method] body: ${jsonEncode(_sanitizePayload(body))}');
    }
  }

  void _logResponse(String method, Uri uri, int statusCode, dynamic data) {
    debugPrint('[API][$method] <- $statusCode $uri');
    debugPrint('[API][$method] response: ${_formatLogData(data)}');
  }

  void _logApiError(String method, Uri uri, int statusCode, String message) {
    debugPrint('[API][$method] error $statusCode $uri');
    debugPrint('[API][$method] message: $message');
  }

  String _formatLogData(dynamic data) {
    if (data == null) {
      return 'null';
    }

    try {
      return jsonEncode(_sanitizePayload(data));
    } catch (_) {
      return data.toString();
    }
  }

  dynamic _sanitizePayload(dynamic payload) {
    if (payload is Map) {
      return payload.map((key, value) {
        final keyText = key.toString().toLowerCase();
        final shouldMask =
            keyText.contains('senha') ||
            keyText.contains('password') ||
            keyText.contains('token');

        return MapEntry(key, shouldMask ? '***' : _sanitizePayload(value));
      });
    }

    if (payload is List) {
      return payload.map(_sanitizePayload).toList();
    }

    return payload;
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message (Status code: $statusCode)';
  }
}
