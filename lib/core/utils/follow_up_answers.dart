library;

class FollowUpAnswers {
  FollowUpAnswers._();

  static const int _maxChips = 4;

  static List<String> suggestionsFor(
    List<String> questions, {
    String language = 'en',
  }) {
    final bool urdu = language == 'ur';
    final matched = <List<String>>[];

    for (final question in questions) {
      final options = _optionsFor(question, urdu: urdu);
      if (options == null || options.isEmpty || matched.contains(options)) {
        continue;
      }
      matched.add(options);
      if (matched.length == 2) break;
    }

    if (matched.isEmpty) return const [];

    if (matched.length == 1) {
      return matched.first.take(_maxChips).toList();
    }

    final suggestions = <String>[];
    for (final options in matched) {
      for (final option in options.take(2)) {
        if (suggestions.length < _maxChips && !suggestions.contains(option)) {
          suggestions.add(option);
        }
      }
    }
    return suggestions;
  }

  static List<String>? _optionsFor(String question, {required bool urdu}) {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return null;
    return urdu ? _urduOptionsFor(trimmed) : _englishOptionsFor(trimmed);
  }

  static List<String>? _englishOptionsFor(String question) {
    final q = question.toLowerCase();

    if (_containsAny(q, const [
      'how long',
      'how many days',
      'how many weeks',
      'since when',
      'when did it start',
      'when did the pain start',
      'when did you first',
    ])) {
      return const [
        'Less than a day',
        'A few days',
        'About a week',
        'Several weeks or more',
      ];
    }
    if (_containsAny(q, const [
      'how severe',
      'how bad',
      'how intense',
      'how strong',
      'how painful',
      'how much does it hurt',
      'rate your',
      'rate the',
      'on a scale',
      'scale of',
      'out of 10',
      '1 to 10',
      '1-10',
    ])) {
      return const ['Mild', 'Moderate', 'Severe', 'Very severe'];
    }
    if (_containsAny(q, const [
      'how often',
      'how frequently',
      'how many times',
    ])) {
      return const ['Occasionally', 'A few times a day', 'Constantly'];
    }
    if (_containsAny(q, const [
      'constant or',
      'come and go',
      'comes and goes',
      'on and off',
      'all the time or',
    ])) {
      return const ['Constant', 'It comes and goes', 'Only sometimes'];
    }
    if (_containsAny(q, const [
      'better or worse',
      'getting better',
      'getting worse',
      'has it improved',
      'has it changed',
      'is it improving',
    ])) {
      return const ['Getting better', 'Getting worse', 'About the same'];
    }
    if (q.contains('left or right')) {
      return const ['Left side', 'Right side', 'Both sides'];
    }
    if (_containsAny(q, const ['one side or both', 'which side', 'one side'])) {
      return const ['One side only', 'Both sides'];
    }
    if (q.contains('upper or lower')) {
      return const ['Upper', 'Lower', 'Both'];
    }
    if (_isYesNoQuestion(q)) {
      return const ['Yes', 'No', "I'm not sure"];
    }
    return null;
  }

  static List<String>? _urduOptionsFor(String question) {
    if (_containsAny(question, const [
      'کتنے دن',
      'کتن دن',
      'کب سے',
      'کتنا عرصہ',
      'کتنے عرصہ',
      'کتنے دنوں',
    ])) {
      return const [
        'ایک دن سے کم',
        'چند دنوں سے',
        'تقریباً ایک ہفتہ سے',
        'ایک ہفتے سے زیادہ',
      ];
    }
    if (_containsAny(question, const ['کتنی بار', 'کتنا بار'])) {
      return const ['کبھی کبھی', 'دن میں کئی بار', 'مسلسل'];
    }
    if (_containsAny(question, const ['مسلسل', 'آتا جاتا', 'ہمیشہ'])) {
      return const ['مسلسل رہتا ہے', 'آتا جاتا ہے', 'کبھی کبھی'];
    }
    if (_containsAny(question, const [
      'کتنا شدید',
      'کتنی شدید',
      'کی شدت',
      'کتنا درد',
      'درد کتنا',
    ])) {
      return const ['ہلکا', 'درمیانہ', 'شدید', 'بہت شدید'];
    }
    if (_containsAny(question, const ['بہتر یا بدتر', 'بہتر ہو', 'بدتر ہو'])) {
      return const ['بہتر ہو رہا ہے', 'بدتر ہو رہا ہے', 'ایک جیسا ہے'];
    }
    if (question.contains('دائیں یا بائیں')) {
      return const ['دائیں طرف', 'بائیں طرف', 'دونوں طرف'];
    }
    if (question.startsWith('کیا')) {
      return const ['جی ہاں', 'نہیں', 'مجھے یقین نہیں'];
    }
    return null;
  }

  static bool _isYesNoQuestion(String q) {
    const auxiliaries = {
      'do',
      'does',
      'did',
      'are',
      'is',
      'was',
      'were',
      'have',
      'has',
      'had',
      'can',
      'could',
      'will',
      'would',
      'should',
    };
    final firstWord = q.trim().split(' ').first.toLowerCase();
    final cleaned = firstWord.replaceAll(RegExp(r'[^a-z]'), '');
    return auxiliaries.contains(cleaned);
  }

  static bool _containsAny(String value, List<String> patterns) =>
      patterns.any(value.contains);
}
