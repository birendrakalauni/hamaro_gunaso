import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../models/complaint_model.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addComplaint({
    required String title,
    required String category,
    required String description,
    required String location,
    String? imageUrl,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final complaintId = const Uuid().v4();

    final complaint = ComplaintModel(
      complaintId: complaintId,
      userId: user.uid,
      title: title,
      category: category,
      description: description,
      location: location,
      status: "Pending",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: imageUrl,
    );

    await _firestore
        .collection('complaints')
        .doc(complaintId)
        .set(complaint.toMap());
  }

  Stream<QuerySnapshot> getUserComplaints(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
  }) async {
    await _firestore.collection('complaints').doc(complaintId).update({
      'status': status,
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> deleteComplaint(String complaintId) async {
    await _firestore.collection('complaints').doc(complaintId).delete();
  }

  Future<void> updateComplaint({
    required String complaintId,
    required String status,
    required String response,
  }) async {
    await _firestore.collection('complaints').doc(complaintId).update({
      'status': status,
      'adminResponse': response,
      'responseDate': DateTime.now(),
      'updatedBy': _auth.currentUser!.uid,
      'updatedAt': DateTime.now(),
    });
  }
}
