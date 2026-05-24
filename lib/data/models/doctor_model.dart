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
  final List<String> services;
  final int running;
  final int patients;

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
    required this.services,
    required this.running,
    required this.patients,
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
      services: List<String>.from(data['services'] ?? []),
      running: data['running'] ?? 0,
      patients: data['patients'] ?? 0,
    );
  }

  factory DoctorModel.fromMap(Map<String, dynamic> data, String documentId) {
    return DoctorModel(
      id: documentId,
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
      services: List<String>.from(data['services'] ?? []),
      running: data['running'] ?? 0,
      patients: data['patients'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'image': image,
      'rating': rating,
      'reviews': reviews,
      'pricePerHour': pricePerHour,
      'isLive': isLive,
      'isPopular': isPopular,
      'isFeature': isFeature,
      'experience': experience,
      'services': services,
      'running': running,
      'patients': patients,
    };
  }
}
