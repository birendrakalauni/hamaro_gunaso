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
      return DateFormat("dd MMM yyyy • hh:mm a").format(value.toDate());
    }

    if (value is String) {
      try {
        return DateFormat(
          "dd MMM yyyy • hh:mm a",
        ).format(DateTime.parse(value));
      } catch (_) {
        return value;
      }
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String status = complaint["status"] ?? "Pending";
    final String imageUrl = complaint["imageUrl"] ?? "";
    final String adminResponse = complaint["adminResponse"] ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TITLE
                Text(
                  complaint["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                /// STATUS
                Chip(
                  avatar: const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.white,
                  ),
                  label: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: getStatusColor(status),
                ),

                const SizedBox(height: 25),

                /// IMAGE
                const Text(
                  "Complaint Image",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                if (imageUrl.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(),

                            body: InteractiveViewer(
                              child: Center(
                                child: Image.network(
                                  imageUrl,
                                  errorBuilder: (_, __, ___) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 80),
                                    );
                                  },
                                ),
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
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,

                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: 220,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 70),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text("No Image Uploaded"),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                const Divider(),

                _infoTile(
                  Icons.category,
                  "Category",
                  complaint["category"] ?? "",
                ),

                const SizedBox(height: 12),

                _infoTile(
                  Icons.location_on,
                  "Location",
                  complaint["location"] ?? "",
                ),

                const SizedBox(height: 20),

                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),

                const SizedBox(height: 8),

                Text(
                  complaint["description"] ?? "",
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),

                const SizedBox(height: 25),

                const Divider(),

                _infoTile(
                  Icons.calendar_today,
                  "Created At",
                  formatDate(complaint["createdAt"]),
                ),

                const SizedBox(height: 12),

                _infoTile(
                  Icons.update,
                  "Last Updated",
                  formatDate(complaint["updatedAt"]),
                ),

                /// ===========================
                /// ADMIN RESPONSE
                /// ===========================
                if (adminResponse.isNotEmpty) ...[
                  const SizedBox(height: 30),

                  const Divider(),

                  const SizedBox(height: 15),

                  const Text(
                    "Admin Response",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: const [
                            Icon(Icons.support_agent, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              "Official Response",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          adminResponse,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),

                        const SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Responded: ${formatDate(complaint["responseDate"])}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(icon, color: Colors.blue, size: 20),

        const SizedBox(width: 10),

        SizedBox(
          width: 110,
          child: Text(
            "$title:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(child: Text(value, style: const TextStyle(height: 1.4))),
      ],
    );
  }
}
