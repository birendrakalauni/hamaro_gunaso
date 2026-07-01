class ComplaintModel {
  final String complaintId;
  final String userId;
  final String title;
  final String category;
  final String description;
  final String location;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String adminResponse;

  final DateTime? responseDate;

  final String updatedBy;

  ComplaintModel({
    required this.complaintId,
    required this.userId,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.adminResponse = '',
    this.responseDate,
    this.updatedBy = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'userId': userId,
      'title': title,
      'category': category,
      'description': description,
      'location': location,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'adminResponse': adminResponse,
      'responseDate': responseDate,
      'updatedBy': updatedBy,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      complaintId: map['complaintId'],
      userId: map['userId'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
      location: map['location'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      adminResponse: map['adminResponse'] ?? '',
      responseDate: map['responseDate']?.toDate(),
      updatedBy: map['updatedBy'] ?? '',
    );
  }
}
