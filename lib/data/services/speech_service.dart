import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService extends GetxService {
  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;
  bool _supportsUrdu = false;

  void Function(String errorCode, String message)? _onError;
  void Function(String status)? _onStatus;

  bool get isInitialized => _isInitialized;
  bool get isAvailable => _isInitialized && _speech.isAvailable;
  bool get isListening => _speech.isListening;
  bool get supportsUrdu => _supportsUrdu;

  Future<bool> initialize({
    void Function(String errorCode, String message)? onError,
    void Function(String status)? onStatus,
  }) async {
    if (_isInitialized) return true;

    _onError = onError;
    _onStatus = onStatus;

    try {
      _isInitialized = await _speech.initialize(
        debugLogging: true,
        options: [
          SpeechToText.androidNoBluetooth,
          SpeechToText.androidIntentLookup,
        ],
        onError: (error) {
          _onError?.call(error.errorMsg, _mapError(error.errorMsg));
        },
        onStatus: (status) {
          _onStatus?.call(status);
        },
      );
    } on PlatformException catch (e) {
      _isInitialized = false;
      _onError?.call(
        e.code,
        'Speech recognition is not available on this device.',
      );
    } catch (e) {
      _isInitialized = false;
      _onError?.call('init_failed', 'Unable to initialize speech recognition.');
    }

    if (_isInitialized) {
      try {
        final locales = await _speech.locales();
        _supportsUrdu = locales.any(
          (l) => l.localeId.toLowerCase().startsWith('ur'),
        );
      } catch (e) {
        _supportsUrdu = false;
      }
    }
    return _isInitialized;
  }

  Future<bool> hasPermission() async {
    try {
      return await _speech.hasPermission;
    } catch (e) {
      return false;
    }
  }

  Future<void> startListening({
    String? localeId,
    required void Function(String words, bool isFinal) onResult,
  }) async {
    if (!_isInitialized) {
      _onError?.call(
        'not_initialized',
        'Speech recognition is not available on this device.',
      );
      return;
    }

    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
        ),
      );
    } on Exception catch (_) {
      _onError?.call(
        'listen_failed',
        'Unable to start voice recognition. Please try again.',
      );
    }
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }

  static String _mapError(String errorCode) {
    switch (errorCode) {
      case 'error_audio_error':
        return 'Microphone error. Please try again.';
      case 'error_permission':
        return 'Microphone permission is required for voice input.';
      case 'error_no_match':
        return 'No speech detected. Please try again.';
      case 'error_speech_timeout':
        return 'No speech detected. Please try again.';
      case 'error_network':
      case 'error_network_timeout':
        return 'Network error during speech recognition.';
      case 'error_language_not_supported':
      case 'error_language_unavailable':
        return 'This language is not available for speech recognition.';
      case 'error_too_many_requests':
        return 'Too many speech requests. Please wait a moment.';
      case 'error_busy':
        return 'Speech recognition is busy. Please try again.';
      case 'error_client':
      case 'error_server':
      case 'error_server_disconnected':
        return 'Unable to start voice recognition. Please try again.';
      default:
        if (errorCode.startsWith('error_')) {
          return 'Voice recognition error ($errorCode).';
        }
        return errorCode;
    }
  }

  @override
  void onClose() {
    cancelListening();
    super.onClose();
  }
}
