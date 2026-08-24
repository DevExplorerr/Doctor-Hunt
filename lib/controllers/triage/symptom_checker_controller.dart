import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymptomCheckerController extends GetxController {
  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var isRecording = false.obs;
  var isTyping = false.obs;
  var isTextEmpty = true.obs;

  var recordDuration = 0.obs;
  Timer? _timer;

  var messages = <Map<String, dynamic>>[
    {
      "isUser": false,
      "text":
          "Hello! I am your AI Symptom Checker. Please describe your symptoms. You can type or tap the microphone to speak in Urdu or English.",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      isTextEmpty.value = textController.text.trim().isEmpty;
    });
  }

  void startRecording() {
    isRecording.value = true;
    recordDuration.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration.value++;
    });
  }

  void stopRecording() {
    isRecording.value = false;
    _timer?.cancel();

    if (recordDuration.value > 0) {
      textController.text =
          "Mujhe kal raat se bukhar hai aur sir mein dard hai";
    }
    recordDuration.value = 0;
  }

  void cancelRecording() {
    isRecording.value = false;
    _timer?.cancel();
    recordDuration.value = 0;
  }

  void sendMessage() async {
    if (textController.text.trim().isEmpty) return;

    // 1. Add user message to UI
    messages.add({"isUser": true, "text": textController.text.trim()});
    textController.clear();
    _scrollToBottom();

    // 2. Mock AI "Thinking" state
    isTyping.value = true;
    _scrollToBottom();

    // TODO (August 26): Send chat history to Qoder API here
    await Future.delayed(const Duration(seconds: 2));

    // 3. Mock AI Follow-up or Routing Action
    isTyping.value = false;
    messages.add({
      "isUser": false,
      "text":
          "Is the fever continuous, or does it come and go? Do you have any body aches?",
    });
    _scrollToBottom();
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

  String get formattedTime {
    int minutes = recordDuration.value ~/ 60;
    int seconds = recordDuration.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
