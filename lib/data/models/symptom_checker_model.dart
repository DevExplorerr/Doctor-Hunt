class SymptomCheckerModel {
  final String urgency;
  final String recommendedSpecialty;
  final String homeAdvice;

  SymptomCheckerModel({
    required this.urgency,
    required this.recommendedSpecialty,
    required this.homeAdvice,
  });

  factory SymptomCheckerModel.fromJson(Map<String, dynamic> json) {
    return SymptomCheckerModel(
      urgency: json['urgency'] ?? '',
      recommendedSpecialty: json['recommended_specialty'] ?? '',
      homeAdvice: json['home_advice'] ?? '',
    );
  }
}
