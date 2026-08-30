enum DecoderDocumentType { prescription, labReport, medicalDocument }

enum DecoderConfidence { high, medium, low }

class DecodedMedication {
  final String name;
  final String purpose;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const DecodedMedication({
    required this.name,
    this.purpose = '',
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.instructions = '',
  });

  bool get hasDetails =>
      dosage.isNotEmpty || frequency.isNotEmpty || duration.isNotEmpty;

  factory DecodedMedication.fromJson(Map<String, dynamic> json) {
    return DecodedMedication(
      name: _str(json['name']),
      purpose: _str(json['purpose']),
      dosage: _str(json['dosage']),
      frequency: _str(json['frequency']),
      duration: _str(json['duration']),
      instructions: _str(json['instructions']),
    );
  }
}

class DecodedLabFinding {
  final String testName;
  final String value;
  final String unit;
  final String referenceRange;
  final String interpretation;
  final bool isOutOfRange;

  const DecodedLabFinding({
    required this.testName,
    required this.value,
    this.unit = '',
    this.referenceRange = '',
    this.interpretation = '',
    this.isOutOfRange = false,
  });

  String get displayValue => unit.isNotEmpty ? '$value $unit' : value;

  factory DecodedLabFinding.fromJson(Map<String, dynamic> json) {
    return DecodedLabFinding(
      testName: _str(json['testName']),
      value: _str(json['value']),
      unit: _str(json['unit']),
      referenceRange: _str(json['referenceRange']),
      interpretation: _str(json['interpretation']),
      isOutOfRange: json['isOutOfRange'] == true,
    );
  }
}

class DecoderAnalysis {
  final DecoderDocumentType documentType;
  final String summary;
  final List<DecodedMedication> medications;
  final List<DecodedLabFinding> labFindings;
  final List<String> keyFindings;
  final List<String> warnings;
  final String disclaimer;
  final DecoderConfidence confidence;
  final String readabilityNotes;

  const DecoderAnalysis({
    required this.documentType,
    required this.summary,
    this.medications = const [],
    this.labFindings = const [],
    this.keyFindings = const [],
    this.warnings = const [],
    required this.disclaimer,
    required this.confidence,
    this.readabilityNotes = '',
  });

  bool get isPrescription => documentType == DecoderDocumentType.prescription;
  bool get isLabReport => documentType == DecoderDocumentType.labReport;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasReadabilityNotes => readabilityNotes.isNotEmpty;

  String get documentTypeLabel {
    switch (documentType) {
      case DecoderDocumentType.prescription:
        return 'Prescription';
      case DecoderDocumentType.labReport:
        return 'Lab Report';
      case DecoderDocumentType.medicalDocument:
        return 'Medical Document';
    }
  }

  String get confidenceLabel {
    switch (confidence) {
      case DecoderConfidence.high:
        return 'High confidence';
      case DecoderConfidence.medium:
        return 'Medium confidence';
      case DecoderConfidence.low:
        return 'Low confidence';
    }
  }

  String toPlainText() {
    final buffer = StringBuffer();

    buffer.writeln('Document Type: $documentTypeLabel');
    buffer.writeln('Confidence: $confidenceLabel');
    buffer.writeln();
    buffer.writeln('Summary');
    buffer.writeln(summary);
    buffer.writeln();

    if (medications.isNotEmpty) {
      buffer.writeln('Medications');
      for (final med in medications) {
        buffer.writeln('• ${med.name}');
        if (med.purpose.isNotEmpty) buffer.writeln('  Purpose: ${med.purpose}');
        if (med.dosage.isNotEmpty) buffer.writeln('  Dosage: ${med.dosage}');
        if (med.frequency.isNotEmpty) {
          buffer.writeln('  Frequency: ${med.frequency}');
        }
        if (med.duration.isNotEmpty) {
          buffer.writeln('  Duration: ${med.duration}');
        }
        if (med.instructions.isNotEmpty) {
          buffer.writeln('  Instructions: ${med.instructions}');
        }
        buffer.writeln();
      }
    }

    if (labFindings.isNotEmpty) {
      buffer.writeln('Lab Findings');
      for (final finding in labFindings) {
        buffer.writeln('• ${finding.testName}: ${finding.displayValue}');
        if (finding.referenceRange.isNotEmpty) {
          buffer.writeln('  Reference Range: ${finding.referenceRange}');
        }
        if (finding.interpretation.isNotEmpty) {
          buffer.writeln('  Interpretation: ${finding.interpretation}');
        }
        if (finding.isOutOfRange) {
          buffer.writeln('  ⚠ Out of reference range');
        }
        buffer.writeln();
      }
    }

    if (keyFindings.isNotEmpty) {
      buffer.writeln('Key Findings');
      for (final finding in keyFindings) {
        buffer.writeln('• $finding');
      }
      buffer.writeln();
    }

    if (warnings.isNotEmpty) {
      buffer.writeln('Warnings');
      for (final warning in warnings) {
        buffer.writeln('• $warning');
      }
      buffer.writeln();
    }

    if (readabilityNotes.isNotEmpty) {
      buffer.writeln('Readability Notes');
      buffer.writeln(readabilityNotes);
      buffer.writeln();
    }

    buffer.writeln('Disclaimer');
    buffer.writeln(disclaimer);

    return buffer.toString();
  }

  factory DecoderAnalysis.fromJson(Map<String, dynamic> json) {
    return DecoderAnalysis(
      documentType: _parseDocumentType(json['documentType']),
      summary: _str(json['summary']) != ''
          ? _str(json['summary'])
          : 'Document analysis completed.',
      medications: _medicationList(json['medications']),
      labFindings: _labFindingList(json['labFindings']),
      keyFindings: _stringList(json['keyFindings']),
      warnings: _stringList(json['warnings']),
      disclaimer: _str(json['disclaimer']) != ''
          ? _str(json['disclaimer'])
          : 'This analysis is for informational purposes only and is not a substitute for professional medical advice. Please consult your doctor or pharmacist for proper interpretation.',
      confidence: _parseConfidence(json['confidence']),
      readabilityNotes: _str(json['readabilityNotes']),
    );
  }
}

class DecoderResponse {
  final bool success;
  final DecoderAnalysis? data;
  final String? errorCode;
  final String? errorMessage;

  const DecoderResponse({
    required this.success,
    this.data,
    this.errorCode,
    this.errorMessage,
  });

  factory DecoderResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return DecoderResponse(
      success: json['success'] == true,
      data: dataJson is Map<String, dynamic>
          ? DecoderAnalysis.fromJson(dataJson)
          : null,
      errorCode: json['error'] is String ? json['error'] as String : null,
      errorMessage: json['message'] is String
          ? json['message'] as String
          : null,
    );
  }
}

DecoderDocumentType _parseDocumentType(dynamic value) {
  switch (value) {
    case 'prescription':
      return DecoderDocumentType.prescription;
    case 'lab_report':
      return DecoderDocumentType.labReport;
    default:
      return DecoderDocumentType.medicalDocument;
  }
}

DecoderConfidence _parseConfidence(dynamic value) {
  switch (value) {
    case 'high':
      return DecoderConfidence.high;
    case 'low':
      return DecoderConfidence.low;
    default:
      return DecoderConfidence.medium;
  }
}

String _str(dynamic value) {
  if (value is String) return value.trim();
  return '';
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<String>()
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

List<DecodedMedication> _medicationList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map<String, dynamic>>()
      .map(DecodedMedication.fromJson)
      .where((m) => m.name.isNotEmpty)
      .toList();
}

List<DecodedLabFinding> _labFindingList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map<String, dynamic>>()
      .map(DecodedLabFinding.fromJson)
      .where((f) => f.testName.isNotEmpty)
      .toList();
}
