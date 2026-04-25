import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String image;
  final double rating;
  final int reviews;
  final double pricePerHour;
  final bool isLive;
  final bool isPopular;
  final bool isFeature;
  final int experience;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.image,
    this.rating = 0.0,
    this.reviews = 0,
    this.pricePerHour = 0.0,
    this.isLive = false,
    this.isPopular = false,
    this.isFeature = false,
    required this.experience,
  });

  factory DoctorModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return DoctorModel(
      id: snapshot.id,
      name: data['name'] ?? 'Unknown Doctor',
      specialty: data['specialty'] ?? 'General',
      image: data['image'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviews: data['reviews'] ?? 0,
      pricePerHour: (data['pricePerHour'] ?? 0.0).toDouble(),
      isLive: data['isLive'] ?? false,
      isPopular: data['isPopular'] ?? false,
      isFeature: data['isFeature'] ?? false,
      experience: data['experience'] ?? 0,
    );
  }
}
