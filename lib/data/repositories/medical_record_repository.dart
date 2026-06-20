import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/medical_record_model.dart';

class MedicalRecordRepository {
  static MedicalRecordRepository get instance => MedicalRecordRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String cloudName = "dw2ryusc1";
  final String uploadPreset = "afahgahja";

  String? get currentUserId => _auth.currentUser?.uid;

  Future<String> uploadRecordFile(File file, String fileName) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/auto/upload',
    );

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = json.decode(responseData);

        return jsonMap['secure_url'];
      } else {
        throw Exception('Cloudinary API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to upload file, check your internet");
    }
  }

  Future<void> saveRecordMetadata(MedicalRecordModel record) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('medical_records')
        .doc(record.id)
        .set(record.toMap());
  }

  Future<List<MedicalRecordModel>> fetchRecords() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('medical_records')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MedicalRecordModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deleteRecord(String recordId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('medical_records')
        .doc(recordId)
        .delete();
  }
}
