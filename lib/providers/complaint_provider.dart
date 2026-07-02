import 'dart:io';

import 'package:flutter/material.dart';

import '../core/services/cloudinary_service.dart';
import '../core/services/complaint_service.dart';

class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _service = ComplaintService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

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
    File? image,
  }) async {
    try {
      setLoading(true);

      String? imageUrl;

      // Upload image to Cloudinary
      if (image != null) {
        imageUrl = await _cloudinaryService.uploadImage(image);
      }

      // Save complaint to Firestore
      await _service.addComplaint(
        title: title,
        category: category,
        description: description,
        location: location,
        imageUrl: imageUrl,
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
    try {
      setLoading(true);

      await _service.updateComplaint(
        complaintId: complaintId,
        status: status,
        response: response,
      );
    } catch (e) {
      debugPrint("Update Complaint Error: $e");
    } finally {
      setLoading(false);
    }
  }
}
