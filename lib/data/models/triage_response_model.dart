library;

enum TriageStage { collecting, complete }

enum TriageUrgency { normal, elevated, urgent, emergency }

enum FollowUpAnswerType { singleChoice, freeText }

class FollowUpQuestion {
  final String id;
  final String question;
  final FollowUpAnswerType answerType;
  final List<String> options;

  const FollowUpQuestion({
    required this.id,
    required this.question,
    required this.answerType,
    this.options = const [],
  });

  bool get hasChips =>
      answerType == FollowUpAnswerType.singleChoice && options.isNotEmpty;

  factory FollowUpQuestion.fromJson(dynamic json) {
    if (json is String) {
      final question = json.trim();
      return FollowUpQuestion(
        id: 'legacy',
        question: question,
        answerType: FollowUpAnswerType.freeText,
      );
    }
    if (json is! Map<String, dynamic>) {
      return const FollowUpQuestion(
        id: 'invalid',
        question: '',
        answerType: FollowUpAnswerType.freeText,
      );
    }

    final question = json['question'] is String
        ? (json['question'] as String).trim()
        : '';

    var answerType = FollowUpAnswerType.freeText;
    if (json['answerType'] == 'single_choice') {
      answerType = FollowUpAnswerType.singleChoice;
    }

    var options = _stringList(json['options']);

    if (answerType == FollowUpAnswerType.singleChoice && options.length < 2) {
      answerType = FollowUpAnswerType.freeText;
      options = const [];
    }

    final id = json['id'] is String && (json['id'] as String).trim().isNotEmpty
        ? (json['id'] as String).trim()
        : 'question';

    return FollowUpQuestion(
      id: id,
      question: question,
      answerType: answerType,
      options: options,
    );
  }
}

class ChatMessage {
  final bool isUser;
  final String text;

  const ChatMessage({required this.isUser, required this.text});
}

class TriageResult {
  final List<String> symptomSummary;
  final List<String> redFlags;

  const TriageResult({
    this.symptomSummary = const [],
    this.redFlags = const [],
  });

  factory TriageResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TriageResult();
    return TriageResult(
      symptomSummary: _stringList(json['symptomSummary']),
      redFlags: _stringList(json['redFlags']),
    );
  }
}

class TriageData {
  final String sessionId;
  final TriageStage stage;
  final String aiMessage;
  final String language;
  final TriageUrgency urgency;
  final String? specialty;
  final List<FollowUpQuestion> followUpQuestions;
  final TriageResult? triage;
  final String? homeCare;

  const TriageData({
    required this.sessionId,
    required this.stage,
    required this.aiMessage,
    required this.language,
    required this.urgency,
    required this.specialty,
    required this.followUpQuestions,
    required this.triage,
    required this.homeCare,
  });

  factory TriageData.fromJson(Map<String, dynamic> json) {
    final dynamic triageJson = json['triage'];
    return TriageData(
      sessionId: json['sessionId'] is String ? json['sessionId'] as String : '',
      stage: json['stage'] == 'complete'
          ? TriageStage.complete
          : TriageStage.collecting,
      aiMessage: json['aiMessage'] is String
          ? (json['aiMessage'] as String).trim()
          : '',
      language: json['language'] == 'ur' ? 'ur' : 'en',
      urgency: _parseUrgency(json['urgency']),
      specialty: json['specialty'] is String
          ? json['specialty'] as String
          : null,
      followUpQuestions: _followUpList(json['followUpQuestions']),
      triage: triageJson is Map<String, dynamic>
          ? TriageResult.fromJson(triageJson)
          : null,
      homeCare: json['homeCare'] is String
          ? (json['homeCare'] as String).trim()
          : null,
    );
  }

  static TriageUrgency _parseUrgency(dynamic value) {
    switch (value) {
      case 'elevated':
        return TriageUrgency.elevated;
      case 'urgent':
        return TriageUrgency.urgent;
      case 'emergency':
        return TriageUrgency.emergency;
      default:
        return TriageUrgency.normal;
    }
  }
}

class TriageResponse {
  final bool success;
  final TriageData? data;
  final String? errorCode;
  final String? errorMessage;

  const TriageResponse({
    required this.success,
    this.data,
    this.errorCode,
    this.errorMessage,
  });

  factory TriageResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataJson = json['data'];
    return TriageResponse(
      success: json['success'] == true,
      data: dataJson is Map<String, dynamic>
          ? TriageData.fromJson(dataJson)
          : null,
      errorCode: json['error'] is String ? json['error'] as String : null,
      errorMessage: json['message'] is String
          ? json['message'] as String
          : null,
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  return const [];
}

List<FollowUpQuestion> _followUpList(dynamic value) {
  if (value is! List) return const [];
  return value
      .map(FollowUpQuestion.fromJson)
      .where((q) => q.question.isNotEmpty)
      .take(2)
      .toList();
}
