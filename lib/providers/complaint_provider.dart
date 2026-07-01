import 'package:flutter/material.dart';

import '../core/services/complaint_service.dart';

class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _service = ComplaintService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> addComplaint({
    required String title,
    required String category,
    required String description,
    required String location,
  }) async {
    try {
      setLoading(true);

      await _service.addComplaint(
        title: title,
        category: category,
        description: description,
        location: location,
      );

      return true;
    } catch (e) {
      debugPrint("Complaint Error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateComplaint({
    required String complaintId,
    required String status,
    required String response,
  }) async {
    _isLoading = true;
    notifyListeners();

    await _service.updateComplaint(
      complaintId: complaintId,
      status: status,
      response: response,
    );

    _isLoading = false;
    notifyListeners();
  }
}
