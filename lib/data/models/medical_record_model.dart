import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordModel {
  final String id;
  final String title;
  final String fileUrl;
  final String recordType;
  final DateTime createdAt;

  MedicalRecordModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.recordType,
    required this.createdAt,
  });

  factory MedicalRecordModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return MedicalRecordModel(
      id: documentId,
      title: data['title'] ?? 'Untitled Record',
      fileUrl: data['fileUrl'] ?? '',
      recordType: data['recordType'] ?? 'Document',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'recordType': recordType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
