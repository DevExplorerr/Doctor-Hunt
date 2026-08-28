import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:doctor_hunt/core/constants/specialties.dart';
import 'package:doctor_hunt/core/utils/follow_up_answers.dart';
import 'package:doctor_hunt/data/models/triage_response_model.dart';
import 'package:doctor_hunt/data/repositories/triage_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';

class SymptomCheckerController extends GetxController {
  SymptomCheckerController({TriageRepository? repository})
    : _triageRepository = repository ?? TriageRepository.instance;

  final TriageRepository _triageRepository;

  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var isTyping = false.obs;
  var isTextEmpty = true.obs;

  var stage = TriageStage.collecting.obs;
  var urgency = TriageUrgency.normal.obs;
  var language = 'en'.obs;

  final specialty = Rxn<String>();
  final homeCare = Rxn<String>();
  final triage = Rxn<TriageResult>();

  final quickReplies = <String>[].obs;

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

  static final RegExp _urduScriptRegex = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  bool get isCompleted => stage.value == TriageStage.complete;

  bool get isEmergency => urgency.value == TriageUrgency.emergency;

  bool get canSend => !isTyping.value && !isTextEmpty.value && !isCompleted;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      isTextEmpty.value = textController.text.trim().isEmpty;
    });
  }

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
    quickReplies.clear();
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

  void sendQuickReply(String reply) {
    if (isTyping.value || isCompleted) return;
    textController.text = reply;
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

    final previousSessionId = _sessionId;

    _sessionId = _generateSessionId();
    language.value = 'en';
    stage.value = TriageStage.collecting;
    urgency.value = TriageUrgency.normal;
    specialty.value = null;
    homeCare.value = null;
    triage.value = null;
    quickReplies.clear();

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

  void onMicPressed() {
    AppSnackBar.show(
      title: "Coming Soon",
      message: "Voice input is coming soon. Please type your symptoms.",
    );
  }

  void _applyResponse(TriageData data) {
    language.value = data.language;
    stage.value = data.stage;
    urgency.value = data.urgency;
    specialty.value = Specialties.sanitize(data.specialty);
    homeCare.value = data.homeCare;
    triage.value = data.triage;
    quickReplies.assignAll(
      data.stage == TriageStage.collecting
          ? FollowUpAnswers.suggestionsFor(
              data.followUpQuestions,
              language: data.language,
            )
          : <String>[],
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
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
