import 'dart:async';
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

  String? _activeLocale;
  void Function(String words, bool isFinal)? _activeOnResult;
  bool _busyRetried = false;

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
        debugLogging: false,
        options: [
          SpeechToText.androidNoBluetooth,
          SpeechToText.androidIntentLookup,
        ],
        onError: (error) {
          final code = error.errorMsg;

          if (code == 'error_busy' &&
              _activeOnResult != null &&
              !_busyRetried) {
            _busyRetried = true;
            unawaited(_retryAfterBusy());
            return;
          }

          _busyRetried = false;

          if (code != 'error_speech_timeout' && code != 'error_no_match') {
            _activeOnResult = null;
          }

          _onError?.call(code, _mapError(code));
        },
        onStatus: (status) {
          _onStatus?.call(status);
        },
      );
    } on PlatformException catch (e) {
      _isInitialized = false;
      _activeOnResult = null;

      _onError?.call(
        e.code,
        'Speech recognition is not available on this device.',
      );
    } catch (e) {
      _isInitialized = false;
      _activeOnResult = null;

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

    _activeLocale = localeId;
    _activeOnResult = onResult;
    _busyRetried = false;

    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.dictation,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 6),
        ),
      );
    } on Exception catch (_) {
      _activeOnResult = null;

      _onError?.call(
        'listen_failed',
        'Unable to start voice recognition. Please try again.',
      );
    }
  }

  Future<void> _retryAfterBusy() async {
    await Future.delayed(const Duration(milliseconds: 300));

    await _speech.cancel();

    await Future.delayed(const Duration(milliseconds: 150));

    final onResult = _activeOnResult;
    final locale = _activeLocale;

    if (onResult == null || !_isInitialized) {
      _activeOnResult = null;

      _onError?.call(
        'error_busy',
        'Speech recognition is busy. Please try again.',
      );
      return;
    }

    _busyRetried = false;

    await startListening(localeId: locale, onResult: onResult);
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> cancelListening() async {
    _activeOnResult = null;
    await _speech.cancel();
  }

  static String _mapError(String errorCode) {
    switch (errorCode) {
      case 'error_audio_error':
        return 'Microphone error. Please try again.';

      case 'error_permission':
        return 'Microphone permission is required for voice input.';

      case 'error_no_match':
        return 'No speech detected.';

      case 'error_speech_timeout':
        return 'Speech recognition paused.';

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
