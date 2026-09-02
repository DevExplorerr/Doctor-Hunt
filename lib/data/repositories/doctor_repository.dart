import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/doctor_model.dart';

class SlotReservation {
  final String doctorId;
  final String date;
  final String time;
  final String appointmentId;
  final String userId;

  SlotReservation({
    required this.doctorId,
    required this.date,
    required this.time,
    required this.appointmentId,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
    'doctorId': doctorId,
    'date': date,
    'time': time,
    'appointmentId': appointmentId,
    'userId': userId,
  };
}

class DoctorRepository extends GetxService {
  static DoctorRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getPopularDoctors() async =>
      _fetchSimple('isPopular', true, 5);
  Future<List<DoctorModel>> getFeatureDoctors() async =>
      _fetchSimple('isFeature', true, 5);

  Future<List<DoctorModel>> _fetchSimple(
    String field,
    dynamic value, [
    int? limit,
  ]) async {
    try {
      Query query = _db.collection('doctors').where(field, isEqualTo: value);
      if (limit != null) query = query.limit(limit);
      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => DoctorModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      throw "Fetch Error ($field): $e";
    }
  }

  Future<Map<String, dynamic>> getAllDoctors({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    String? type,
  }) async {
    try {
      Query query = _db.collection('doctors');

      if (type == 'popular') {
        query = query.where('isPopular', isEqualTo: true);
      } else if (type == 'feature') {
        query = query.where('isFeature', isEqualTo: true);
      }

      query = query.orderBy('name');

      if (lastDocument != null) query = query.startAfterDocument(lastDocument);
      query = query.limit(limit);

      final snapshot = await query.get();
      final doctors = snapshot.docs
          .map(
            (doc) => DoctorModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      return {
        'doctors': doctors,
        'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      };
    } catch (e) {
      throw "Could not fetch doctors list.";
    }
  }

  Future<List<DoctorModel>> getDoctorsByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where('specialty', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch $category doctors.";
    }
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      final doc = await _db.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        return DoctorModel.fromSnapshot(doc);
      }
      throw "Doctor not found";
    } catch (e) {
      throw "Fetch Doctor Error: $e";
    }
  }

  Future<List<String>> getDoctorTimeSlots(String doctorId) async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('time_slots')
          .get();

      return snapshot.docs.map((doc) => doc['time'] as String).toList();
    } catch (e) {
      throw "Could not fetch time slots: $e";
    }
  }

  Future<void> manageSlotsForBooking({
    required String userId,
    SlotReservation? newSlot,
    SlotReservation? oldSlot,
    Map<String, dynamic>? appointmentData,
    String? reschedulingAppointmentId,
  }) async {
    await _db.runTransaction((transaction) async {
      if (newSlot != null) {
        final newKey = buildBookingKey(newSlot.date, newSlot.time);
        final newRef = _db
            .collection('doctors')
            .doc(newSlot.doctorId)
            .collection('booked_slots')
            .doc(newKey);

        final newDoc = await transaction.get(newRef);
        if (newDoc.exists) {
          throw 'This time slot is no longer available. It may have been booked by another user. Please select a different time.';
        }

        final bool isNewOccurrence =
            oldSlot == null ||
            oldSlot.date != newSlot.date ||
            oldSlot.time != newSlot.time;

        if (isNewOccurrence) {
          transaction.set(newRef, newSlot.toMap());
        }
      }

      if (oldSlot != null) {
        final bool shouldRelease =
            newSlot == null ||
            newSlot.date != oldSlot.date ||
            newSlot.time != oldSlot.time;

        if (shouldRelease) {
          final oldKey = buildBookingKey(oldSlot.date, oldSlot.time);
          final oldRef = _db
              .collection('doctors')
              .doc(oldSlot.doctorId)
              .collection('booked_slots')
              .doc(oldKey);
          transaction.delete(oldRef);
        }
      }

      if (reschedulingAppointmentId != null && appointmentData != null) {
        final apptRef = _db
            .collection('users')
            .doc(userId)
            .collection('appointments')
            .doc(reschedulingAppointmentId);
        transaction.update(apptRef, {
          'date': appointmentData['date'],
          'time': appointmentData['time'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (appointmentData != null) {
        final apptRef = _db
            .collection('users')
            .doc(userId)
            .collection('appointments')
            .doc();
        transaction.set(apptRef, appointmentData);
      }
    });
  }

  static String buildBookingKey(String dateStr, String timeStr) {
    final date = DateTime.parse(dateStr);
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final time = DateFormat('hh:mm a').parse(timeStr);
    final timeKey = DateFormat('HH-mm').format(time);
    return '${dateKey}_$timeKey';
  }

  Future<void> cancelAppointmentTransactionally({
    required String userId,
    required String appointmentId,
  }) async {
    final apptRef = _db
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .doc(appointmentId);

    await _db.runTransaction((transaction) async {
      final apptDoc = await transaction.get(apptRef);

      if (!apptDoc.exists || apptDoc.data() == null) {
        throw 'Appointment not found. It may have already been removed.';
      }

      final data = apptDoc.data()!;

      final doctorId = data['doctorId'] as String?;
      final dateStr = data['date'] as String?;
      final time = data['time'] as String?;

      DocumentReference? reservationRef;
      if (doctorId != null && dateStr != null && time != null) {
        try {
          final dateOnly = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(dateStr));
          reservationRef = _db
              .collection('doctors')
              .doc(doctorId)
              .collection('booked_slots')
              .doc(buildBookingKey(dateOnly, time));
        } catch (_) {
          // Malformed date — reservation is unidentifiable, cancel anyway
        }
      }

      // 1. Mark the appointment canceled
      transaction.update(apptRef, {
        'status': 'canceled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (reservationRef != null) {
        transaction.delete(reservationRef);
      }
    });
  }

  Future<void> saveAppointment(
    String userId,
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .add(appointmentData);
    } catch (e) {
      throw "Booking failed: $e";
    }
  }

  Future<bool> updateAppointmentTime(
    String appointmentId,
    String newDate,
    String newTime,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _db
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .doc(appointmentId)
          .update({
            'date': newDate,
            'time': newTime,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingAppointments() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .where('status', isEqualTo: 'upcoming')
          .get();

      if (snapshot.docs.isEmpty) return [];

      List<Map<String, dynamic>> appointments = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final now = DateTime.now();
      final DateFormat timeParser = DateFormat("hh:mm a");

      appointments.retainWhere((appt) {
        try {
          DateTime apptDate = DateTime.parse(appt['date']);
          String timeString = appt['time'] ?? "12:00 AM";
          DateTime parsedTime = timeParser.parse(timeString);
          DateTime exactApptMoment = DateTime(
            apptDate.year,
            apptDate.month,
            apptDate.day,
            parsedTime.hour,
            parsedTime.minute,
          );

          return exactApptMoment.isAfter(now);
        } catch (e) {
          DateTime fallbackDate = DateTime.parse(appt['date']);
          return fallbackDate.isAfter(now);
        }
      });

      if (appointments.isEmpty) return [];

      appointments.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      return appointments.take(3).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateAppointmentStatus(
    String appointmentId,
    String newStatus,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _db
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': newStatus});
      return true;
    } catch (e) {
      return false;
    }
  }
}
