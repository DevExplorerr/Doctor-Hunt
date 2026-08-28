class Specialties {
  Specialties._();

  static const String dermatologist = 'Dermatologist';
  static const String dentist = 'Dentist';
  static const String generalPhysician = 'General Physician';
  static const String surgeon = 'Surgeon';
  static const String orthopedic = 'Orthopedic';
  static const String psychologist = 'Psychologist';
  static const String gynecologist = 'Gynecologist';
  static const String neurologist = 'Neurologist';
  static const String pediatrician = 'Pediatrician';
  static const String cardiologist = 'Cardiologist';

  static const List<String> all = [
    dermatologist,
    dentist,
    generalPhysician,
    surgeon,
    orthopedic,
    psychologist,
    gynecologist,
    neurologist,
    pediatrician,
    cardiologist,
  ];

  static const String fallback = generalPhysician;

  static bool isValid(String? specialty) =>
      specialty != null && all.contains(specialty);

  static String? sanitize(String? specialty) =>
      isValid(specialty) ? specialty : null;
}
