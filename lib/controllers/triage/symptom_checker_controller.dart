import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:doctor_hunt/core/constants/specialties.dart';
import 'package:doctor_hunt/data/models/triage_response_model.dart';
import 'package:doctor_hunt/data/repositories/triage_repository.dart';
import 'package:doctor_hunt/data/services/speech_service.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/speech_service_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';

class SymptomCheckerController extends GetxController {
  SymptomCheckerController({
    TriageRepository? repository,
    SpeechService? speechService,
  }) : _triageRepository = repository ?? TriageRepository.instance,
       _speechService = speechService ?? Get.find<SpeechService>();

  final TriageRepository _triageRepository;
  final SpeechService _speechService;

  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var isTyping = false.obs;
  var isTextEmpty = true.obs;
  var isListening = false.obs;
  var selectedSttLanguage = 'en'.obs;

  var interimTranscript = ''.obs;

  final RxString recordingPreview = ''.obs;

  final RxInt recordingSeconds = 0.obs;

  var stage = TriageStage.collecting.obs;
  var urgency = TriageUrgency.normal.obs;
  var language = 'en'.obs;

  final specialty = Rxn<String>();
  final homeCare = Rxn<String>();
  final triage = Rxn<TriageResult>();

  final followUpQuestions = <FollowUpQuestion>[].obs;

  var messages = <ChatMessage>[
    const ChatMessage(
      isUser: false,
      text:
          "Hello! I am your AI Symptom Checker. Please describe your symptoms "
          "in English or Urdu, and I will help you find the right specialist.",
    ),
  ].obs;

  late String _sessionId = _generateSessionId();
  bool _isDisposed = false;
  bool _isShowingDialog = false;

  bool _pendingDialogShow = false;

  String? _speechServicePackage;

  int _recordingSession = 0;

  final List<String> _committedSegments = [];

  String _lastFinalSegment = '';

  bool _stopRequested = false;

  Timer? _recordingTimer;

  static final RegExp _urduScriptRegex = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  bool get isCompleted => stage.value == TriageStage.complete;

  bool get isEmergency => urgency.value == TriageUrgency.emergency;

  bool get canSend => !isTyping.value && !isTextEmpty.value && !isCompleted;

  bool get hasChipQuestions => followUpQuestions.any((q) => q.hasChips);

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      isTextEmpty.value = textController.text.trim().isEmpty;
    });
  }

  Future<void> onMicPressed() async {
    if (_isDisposed || isListening.value || isTyping.value || isCompleted) {
      return;
    }

    if (!_speechService.isInitialized) {
      final ok = await _speechService.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
      );
      if (_isDisposed) return;
      if (!ok) return;
    }

    if (!await _speechService.hasPermission()) {
      AppSnackBar.show(
        title: "Permission Required",
        message: "Microphone permission is required for voice input.",
        isError: true,
      );
      return;
    }

    if (_isDisposed) return;
    _startRecordingSession();
  }

  Future<void> _startRecordingSession() async {
    if (_isDisposed) return;

    await _speechService.cancelListening();
    if (_isDisposed) return;

    _recordingSession++;
    _committedSegments.clear();
    _lastFinalSegment = '';
    _stopRequested = false;
    interimTranscript.value = '';
    recordingPreview.value = '';
    recordingSeconds.value = 0;

    isListening.value = true;

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isDisposed) recordingSeconds.value++;
    });

    unawaited(_listenSegment(_recordingSession));
  }

  Future<void> _listenSegment(int session) async {
    if (_isDisposed || _recordingSession != session) return;

    final locale = selectedSttLanguage.value == 'ur' ? 'ur-PK' : 'en-US';

    await _speechService.startListening(
      localeId: locale,
      onResult: (words, isFinal) {
        if (_isDisposed || _recordingSession != session) return;
        if (isFinal) {
          _commitSegment(words);
        } else {
          interimTranscript.value = words;
          _refreshRecordingPreview();
        }
      },
    );

    if (!_isDisposed &&
        _recordingSession != session &&
        _recordingSession == 0) {
      await _speechService.cancelListening();
    }
  }

  void _commitSegment(String words) {
    final segment = words.trim().replaceAll(_whitespaceRegex, ' ');
    interimTranscript.value = '';
    if (segment.isEmpty) return;

    if (_committedSegments.isNotEmpty && segment == _lastFinalSegment) return;

    _committedSegments.add(segment);
    _lastFinalSegment = segment;
    _refreshRecordingPreview();
  }

  void _refreshRecordingPreview() {
    final committed = _committedSegments.join(' ').trim();
    final interim = interimTranscript.value.trim();
    if (committed.isEmpty) {
      recordingPreview.value = interim;
    } else if (interim.isEmpty) {
      recordingPreview.value = committed;
    } else {
      recordingPreview.value = '$committed $interim';
    }
  }

  Future<void> stopRecording() async {
    if (_recordingSession == 0) return;
    _stopRequested = true;

    if (_speechService.isListening) {
      await _speechService.stopListening();
      return;
    }

    _endRecordingSession(discard: false);
  }

  Future<void> cancelRecording() async {
    if (_recordingSession == 0) return;
    await _speechService.cancelListening();
    _endRecordingSession(discard: true);
  }

  void _endRecordingSession({required bool discard}) {
    if (_recordingSession == 0) return;
    _recordingSession = 0;
    _recordingTimer?.cancel();
    _recordingTimer = null;
    isListening.value = false;
    interimTranscript.value = '';
    recordingPreview.value = '';

    final transcript = _committedSegments
        .join(' ')
        .replaceAll(_whitespaceRegex, ' ')
        .trim();
    _committedSegments.clear();
    _lastFinalSegment = '';

    if (!discard && transcript.isNotEmpty) {
      textController.text = transcript;
    }
  }

  void _onSpeechStatus(String status) {
    if (_isDisposed) return;
    if (status != 'done') return;

    final session = _recordingSession;
    if (session == 0) return;

    if (_stopRequested) {
      _endRecordingSession(discard: false);
      return;
    }

    if (!isListening.value) return;

    unawaited(_listenSegment(session));
  }

  void _onSpeechError(String errorCode, String message) {
    if (_isDisposed) return;

    if (errorCode == 'error_no_match' || errorCode == 'error_speech_timeout') {
      _endRecordingSession(discard: false);
      AppSnackBar.show(title: "No Speech", message: message, isError: true);
      return;
    }

    _endRecordingSession(discard: false);

    if (errorCode == 'error_permission') {
      _handlePermissionError();
      return;
    }

    if (errorCode == 'recognizerNotAvailable' ||
        errorCode == 'not_initialized') {
      AppSnackBar.show(
        title: "Speech Unavailable",
        message: "Speech recognition is not available on this device.",
        isError: true,
      );
      return;
    }

    AppSnackBar.show(title: "Voice Error", message: message, isError: true);
  }

  Future<void> _handlePermissionError() async {
    final granted = await _speechService.hasPermission();
    if (_isDisposed) return;

    if (granted) {
      _speechServicePackage ??= await _detectSpeechServicePackage();
      if (_isDisposed) return;
      if (_isShowingDialog) {
        _pendingDialogShow = true;
      } else {
        _showSpeechTroubleshootingDialog();
      }
    } else {
      AppSnackBar.show(
        title: "Permission Required",
        message: "Microphone permission is required for voice input.",
        isError: true,
      );
    }
  }

  // Chat / triage

  Future<void> sendMessage() async {
    if (isTyping.value) return;

    if (isCompleted) {
      if (!isTextEmpty.value) {
        AppSnackBar.show(
          title: "Triage Complete",
          message:
              "Your symptom check is finished. Start a new check to continue "
              "chatting.",
        );
      }
      return;
    }

    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(isUser: true, text: text));
    textController.clear();
    followUpQuestions.clear();
    isTyping.value = true;
    _scrollToBottom();

    try {
      final data = await _triageRepository.sendChatMessage(
        sessionId: _sessionId,
        message: text,
        language: _detectLanguage(text),
      );

      if (_isDisposed) return;
      _applyResponse(data);
    } on TriageException catch (e) {
      if (_isDisposed) return;
      AppSnackBar.show(
        title: "Connection Problem",
        message: e.message,
        isError: true,
      );
    } finally {
      if (!_isDisposed) {
        isTyping.value = false;
        _scrollToBottom();
      }
    }
  }

  void sendFollowUpAnswer(String answer) {
    if (isTyping.value || isCompleted) return;
    textController.text = answer;
    sendMessage();
  }

  void findDoctors() {
    if (!isCompleted || isTyping.value) return;
    if (isEmergency) return;

    final target = specialty.value ?? Specialties.fallback;
    if (!Specialties.isValid(target)) return;

    Get.toNamed(
      '/all-doctors',
      arguments: {'category': target, 'title': target},
    );
  }

  void browseDoctors() {
    Get.toNamed(
      '/all-doctors',
      arguments: {
        'category': Specialties.fallback,
        'title': Specialties.fallback,
      },
    );
  }

  Future<void> startNewTriage() async {
    if (isTyping.value) return;
    if (_recordingSession != 0) {
      await cancelRecording();
    }

    final previousSessionId = _sessionId;

    _sessionId = _generateSessionId();
    language.value = 'en';
    stage.value = TriageStage.collecting;
    urgency.value = TriageUrgency.normal;
    specialty.value = null;
    homeCare.value = null;
    triage.value = null;
    followUpQuestions.clear();

    messages.assignAll([
      const ChatMessage(
        isUser: false,
        text:
            "Let's start again. Please describe your symptoms in English or "
            "Urdu.",
      ),
    ]);
    textController.clear();
    _scrollToBottom();

    unawaited(_triageRepository.resetSession(previousSessionId));
  }

  void toggleSttLanguage() {
    if (isListening.value) return;
    selectedSttLanguage.value = selectedSttLanguage.value == 'en' ? 'ur' : 'en';
  }

  void _applyResponse(TriageData data) {
    language.value = data.language;
    stage.value = data.stage;
    urgency.value = data.urgency;
    specialty.value = Specialties.sanitize(data.specialty);
    homeCare.value = data.homeCare;
    triage.value = data.triage;
    followUpQuestions.assignAll(
      data.stage == TriageStage.collecting
          ? data.followUpQuestions
          : <FollowUpQuestion>[],
    );

    final reply = data.aiMessage.isNotEmpty
        ? data.aiMessage
        : "I need a little more information about your symptoms before I "
              "can suggest the right specialist.";

    messages.add(ChatMessage(isUser: false, text: reply));
    _scrollToBottom();
  }

  String _detectLanguage(String text) {
    if (language.value == 'ur') return 'ur';
    return _urduScriptRegex.hasMatch(text) ? 'ur' : 'en';
  }

  String _generateSessionId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }

  Future<String?> _detectSpeechServicePackage() async {
    const googlePackages = [
      'com.google.android.googlequicksearchbox',
      'com.google.android.apps.search',
    ];
    return googlePackages.first;
  }

  Future<void> openSpeechSettings() async {
    try {
      const channel = MethodChannel('doctor_hunt/speech_settings');
      final opened = await channel.invokeMethod<bool>('openAppSettings', {
        'package': _speechServicePackage,
      });
      if (opened != true) {
        _showManualSettingsHelp();
      }
    } on PlatformException catch (_) {
      _showManualSettingsHelp();
    } catch (_) {
      _showManualSettingsHelp();
    }
  }

  void _showManualSettingsHelp() {
    AppSnackBar.show(
      title: "Settings",
      message:
          "Please open Settings manually, go to Apps \u2192 Google, and allow "
          "Microphone permission.",
      isError: true,
    );
  }

  void _showSpeechTroubleshootingDialog() {
    if (_isShowingDialog || _isDisposed) return;
    _isShowingDialog = true;
    SpeechServiceDialog.show(
      onOpenSettings: openSpeechSettings,
      onTryAgain: retryAfterSpeechServiceDialog,
    ).then((_) {
      _isShowingDialog = false;
      if (_pendingDialogShow && !_isDisposed) {
        _pendingDialogShow = false;
        _showSpeechTroubleshootingDialog();
      }
    });
  }

  Future<void> retryAfterSpeechServiceDialog() async {
    final granted = await _speechService.hasPermission();
    if (_isDisposed) return;

    if (!granted) {
      AppSnackBar.show(
        title: "Permission Required",
        message: "Microphone permission is required for voice input.",
        isError: true,
      );
      return;
    }

    if (!_speechService.isInitialized) {
      final ok = await _speechService.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
      );
      if (!ok) return;
    }

    if (isCompleted) return;
    _startRecordingSession();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _isDisposed = true;
    _recordingSession = 0;
    _recordingTimer?.cancel();
    _speechService.cancelListening();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
