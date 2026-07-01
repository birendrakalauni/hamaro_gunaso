class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// class UserModel {
//   final String uid;
//   final String name;
//   final String email;
//   final String role; // 'user' or 'admin'
//   final String? photoUrl;
//   final String? phone;
//   final DateTime createdAt;
//   final DateTime? updatedAt;

//   const UserModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.role,
//     this.photoUrl,
//     this.phone,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   bool get isAdmin => role == 'admin';

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'] as String,
//       name: map['name'] as String,
//       email: map['email'] as String,
//       role: (map['role'] as String?) ?? 'user',
//       photoUrl: map['photoUrl'] as String?,
//       phone: map['phone'] as String?,
//       createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
//     );
//   }

//   factory UserModel.fromDoc(DocumentSnapshot doc) =>
//       UserModel.fromMap(doc.data() as Map<String, dynamic>);

//   Map<String, dynamic> toMap() => {
//         'uid': uid,
//         'name': name,
//         'email': email,
//         'role': role,
//         'photoUrl': photoUrl,
//         'phone': phone,
//         'createdAt': Timestamp.fromDate(createdAt),
//         'updatedAt':
//             updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
//       };

//   UserModel copyWith({
//     String? name,
//     String? photoUrl,
//     String? phone,
//     DateTime? updatedAt,
//   }) {
//     return UserModel(
//       uid: uid,
//       name: name ?? this.name,
//       email: email,
//       role: role,
//       photoUrl: photoUrl ?? this.photoUrl,
//       phone: phone ?? this.phone,
//       createdAt: createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }
