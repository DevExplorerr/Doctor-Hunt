import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/decoder_response_model.dart';

class DecoderException implements Exception {
  final String message;

  const DecoderException(this.message);

  @override
  String toString() => message;
}

class DecoderRepository extends GetxService {
  static DecoderRepository get instance => Get.find();

  static const String baseUrl = String.fromEnvironment(
    'DOCTOR_HUNT_AI_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration _timeout = Duration(seconds: 90);

  static const String _connectionErrorMessage =
      'Unable to connect to Doctor Hunt AI. Please check your internet '
      'connection and try again.';
  static const String _genericErrorMessage =
      'Document analysis is temporarily unavailable. Please try again in a '
      'moment.';
  static const String _timeoutErrorMessage =
      'Analysis is taking longer than expected. Please try again.';
  static const String _rateLimitErrorMessage =
      'You are sending requests too quickly. Please wait a moment and try '
      'again.';

  final http.Client _client = http.Client();

  Future<DecoderAnalysis> analyzeDocument(String imageUrl) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/api/decoder/analyze'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'imageUrl': imageUrl}),
          )
          .timeout(_timeout);

      return _parseResponse(response);
    } on DecoderException {
      rethrow;
    } on SocketException {
      throw const DecoderException(_connectionErrorMessage);
    } on TimeoutException {
      throw const DecoderException(_timeoutErrorMessage);
    } on http.ClientException {
      throw const DecoderException(_connectionErrorMessage);
    } on FormatException {
      throw const DecoderException(_genericErrorMessage);
    } catch (_) {
      throw const DecoderException(_genericErrorMessage);
    }
  }

  DecoderAnalysis _parseResponse(http.Response response) {
    Map<String, dynamic>? body;
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } on FormatException {
      // Non-JSON body — handled below.
    }

    if (body == null) {
      throw const DecoderException(_genericErrorMessage);
    }

    final decoderResponse = DecoderResponse.fromJson(body);

    if (!decoderResponse.success || decoderResponse.data == null) {
      throw DecoderException(
        _messageForError(response.statusCode, decoderResponse.errorCode),
      );
    }

    return decoderResponse.data!;
  }

  String _messageForError(int statusCode, String? errorCode) {
    if (statusCode == 429 || errorCode == 'RATE_LIMITED') {
      return _rateLimitErrorMessage;
    }
    if (statusCode == 502 || errorCode == 'ANALYSIS_FAILED') {
      return _genericErrorMessage;
    }
    return _genericErrorMessage;
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
}
