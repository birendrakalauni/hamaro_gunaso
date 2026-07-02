import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'complaint_details_screen.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  String searchQuery = "";
  String selectedStatus = "All";
  String selectedCategory = "All";
  String sortBy = "Newest";

  final List<String> statuses = [
    "All",
    "Pending",
    "In Progress",
    "Resolved",
    "Rejected",
  ];

  final List<String> categories = [
    "All",
    "Road",
    "Water",
    "Electricity",
    "Sanitation",
    "Health",
    "Education",
    "Infrastructure",
    "Environment",
    "Public Safety",
    "Other",
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "In Progress":
        return Colors.orange;

      case "Pending":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Complaints")),

      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search complaints...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),

          /// FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,

                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),

                    items: statuses
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,

                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),

                    items: categories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// SORT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: DropdownButtonFormField<String>(
              value: sortBy,

              decoration: const InputDecoration(
                labelText: "Sort",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "Newest", child: Text("Newest First")),

                DropdownMenuItem(value: "Oldest", child: Text("Oldest First")),
              ],

              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("complaints")
                  .where("userId", isEqualTo: currentUser?.uid)
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.inbox, size: 90, color: Colors.grey),

                        SizedBox(height: 15),

                        Text(
                          "No complaints found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                List<DocumentSnapshot> complaints = snapshot.data!.docs.where((
                  doc,
                ) {
                  final data = doc.data() as Map<String, dynamic>;

                  final title = data["title"].toString().toLowerCase();

                  final status = data["status"];

                  final category = data["category"];

                  return title.contains(searchQuery) &&
                      (selectedStatus == "All"
                          ? true
                          : status == selectedStatus) &&
                      (selectedCategory == "All"
                          ? true
                          : category == selectedCategory);
                }).toList();

                complaints.sort((a, b) {
                  Timestamp aTime = a["createdAt"];

                  Timestamp bTime = b["createdAt"];

                  if (sortBy == "Newest") {
                    return bTime.compareTo(aTime);
                  }

                  return aTime.compareTo(bTime);
                });

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text("No matching complaints found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: complaints.length,

                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    final data = complaint.data() as Map<String, dynamic>;

                    return buildComplaintCard(context, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// --- COMPLAINT CARD WIDGET ---
Widget buildComplaintCard(BuildContext context, Map<String, dynamic> data) {
  final String status = data["status"] ?? "Pending";
  final String imageUrl = data["imageUrl"] ?? "";

  // Helper method to resolve colors within the independent builder method
  Color localGetStatusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "In Progress":
        return Colors.orange;
      case "Pending":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Helper method to format date within the independent builder method
  String localFormatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ComplaintDetailsScreen(complaint: data),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Complaint Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    data["title"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.category, size: 18, color: Colors.blue),
                      const SizedBox(width: 6),
                      Expanded(child: Text(data["category"] ?? "")),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data["location"] ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      /// Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: localGetStatusColor(status).withOpacity(.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: localGetStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Spacer(),

                      if (data["createdAt"] != null)
                        Text(
                          localFormatDate(data["createdAt"]),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            // Dynamic formatting local to function
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ComplaintDetailsScreen(complaint: data),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text("View Details"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
