library;

enum TriageStage { collecting, complete }

enum TriageUrgency { normal, elevated, urgent, emergency }

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
  final List<String> followUpQuestions;
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
      followUpQuestions: _stringList(json['followUpQuestions']),
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
