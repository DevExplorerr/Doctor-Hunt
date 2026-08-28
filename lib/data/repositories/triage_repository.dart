import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/triage_response_model.dart';

class TriageException implements Exception {
  final String message;

  const TriageException(this.message);

  @override
  String toString() => message;
}

class TriageRepository extends GetxService {
  static TriageRepository get instance => Get.find();

  static const String baseUrl = String.fromEnvironment(
    'DOCTOR_HUNT_AI_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration _timeout = Duration(seconds: 60);

  static const String _connectionErrorMessage =
      'Unable to connect to Doctor Hunt AI. Please check your internet '
      'connection and try again.';
  static const String _genericErrorMessage =
      'Doctor Hunt AI is temporarily unavailable. Please try again in a '
      'moment.';
  static const String _timeoutErrorMessage =
      'Doctor Hunt AI is taking longer than expected. Please try again.';
  static const String _rateLimitErrorMessage =
      'You are sending messages too quickly. Please wait a moment and try '
      'again.';

  final http.Client _client = http.Client();

  Future<TriageData> sendChatMessage({
    required String sessionId,
    required String message,
    String language = 'en',
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/api/triage/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'sessionId': sessionId,
              'message': message,
              'language': language,
            }),
          )
          .timeout(_timeout);

      return _parseChatResponse(response);
    } on TriageException {
      rethrow;
    } on SocketException {
      throw const TriageException(_connectionErrorMessage);
    } on TimeoutException {
      throw const TriageException(_timeoutErrorMessage);
    } on http.ClientException {
      throw const TriageException(_connectionErrorMessage);
    } on FormatException {
      throw const TriageException(_genericErrorMessage);
    } catch (_) {
      throw const TriageException(_genericErrorMessage);
    }
  }

  Future<void> resetSession(String sessionId) async {
    try {
      await _client
          .post(
            Uri.parse('$baseUrl/api/triage/reset'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'sessionId': sessionId}),
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  TriageData _parseChatResponse(http.Response response) {
    Map<String, dynamic>? body;
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } on FormatException {
      // Non-JSON body (proxy page, empty body, ...) — handled below.
    }

    if (body == null) {
      throw const TriageException(_genericErrorMessage);
    }

    final triageResponse = TriageResponse.fromJson(body);

    if (!triageResponse.success || triageResponse.data == null) {
      throw TriageException(
        _messageForError(response.statusCode, triageResponse.errorCode),
      );
    }

    return triageResponse.data!;
  }

  String _messageForError(int statusCode, String? errorCode) {
    if (statusCode == 429 || errorCode == 'RATE_LIMITED') {
      return _rateLimitErrorMessage;
    }
    return _genericErrorMessage;
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
}
