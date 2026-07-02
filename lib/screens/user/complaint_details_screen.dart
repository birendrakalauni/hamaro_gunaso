import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  Color getStatusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "In Progress":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String formatDate(dynamic value) {
    if (value == null) return "N/A";

    if (value is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(value.toDate());
    }

    if (value is String) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(value));
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final status = complaint['status'] ?? "Pending";
    final imageUrl = complaint['imageUrl'];

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint['title'] ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Chip(
                  label: Text(status),
                  backgroundColor: getStatusColor(status).withOpacity(0.15),
                  side: BorderSide(color: getStatusColor(status)),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Complaint Image",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                if (imageUrl != null && imageUrl.toString().isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(),
                            body: Center(
                              child: InteractiveViewer(
                                child: Image.network(imageUrl),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text("No Image Uploaded"),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                const Divider(),

                _infoTile("Category", complaint['category'] ?? ""),

                const SizedBox(height: 10),

                _infoTile("Location", complaint['location'] ?? ""),

                const SizedBox(height: 20),

                const Text(
                  "Description",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  complaint['description'] ?? "",
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 25),

                const Divider(),

                _infoTile("Created At", formatDate(complaint['createdAt'])),

                const SizedBox(height: 10),

                _infoTile("Last Updated", formatDate(complaint['updatedAt'])),

                if (complaint['response'] != null &&
                    complaint['response'].toString().isNotEmpty) ...[
                  const SizedBox(height: 25),

                  const Divider(),

                  const Text(
                    "Admin Response",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    complaint['response'],
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$title:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
