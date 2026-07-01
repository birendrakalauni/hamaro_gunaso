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

  @override
  Widget build(BuildContext context) {
    final status = complaint['status'] ?? 'Pending';

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Chip(
                  label: Text(status),
                  backgroundColor: getStatusColor(
                    status,
                  ).withValues(alpha: 0.2),
                ),

                const Divider(height: 30),

                _infoTile("Category", complaint['category'] ?? ''),

                _infoTile("Location", complaint['location'] ?? ''),

                const SizedBox(height: 15),

                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 8),

                Text(
                  complaint['description'] ?? '',
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 20),

                _infoTile(
                  "Created At",
                  complaint['createdAt'] != null
                      ? DateFormat(
                          'dd MMM yyyy, hh:mm a',
                        ).format(DateTime.parse(complaint['createdAt']))
                      : '',
                ),

                const SizedBox(height: 10),

                _infoTile(
                  "Last Updated",
                  complaint['updatedAt'] != null
                      ? DateFormat(
                          'dd MMM yyyy, hh:mm a',
                        ).format(DateTime.parse(complaint['updatedAt']))
                      : '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Row(
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
