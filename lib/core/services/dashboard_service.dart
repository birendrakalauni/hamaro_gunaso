import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, int>> getDashboardStats() {
    return _firestore.collection('complaints').snapshots().asyncMap((
      snapshot,
    ) async {
      int total = snapshot.docs.length;
      int pending = 0;
      int inProgress = 0;
      int resolved = 0;
      int rejected = 0;

      for (var doc in snapshot.docs) {
        final status = doc['status'];

        switch (status) {
          case 'Pending':
            pending++;
            break;

          case 'In Progress':
            inProgress++;
            break;

          case 'Resolved':
            resolved++;
            break;

          case 'Rejected':
            rejected++;
            break;
        }
      }

      final usersSnapshot = await _firestore.collection('users').get();

      return {
        'total': total,
        'pending': pending,
        'inProgress': inProgress,
        'resolved': resolved,
        'rejected': rejected,
        'users': usersSnapshot.docs.length,
      };
    });
  }
}
