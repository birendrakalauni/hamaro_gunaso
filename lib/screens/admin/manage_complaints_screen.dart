import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({super.key});

  @override
  State<ManageComplaintsScreen> createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  String searchQuery = "";
  String selectedStatus = "All";

  final List<String> statuses = [
    "All",
    "Pending",
    "In Progress",
    "Resolved",
    "Rejected",
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

  String formatDate(dynamic value) {
    if (value == null) return "N/A";

    if (value is Timestamp) {
      return DateFormat("dd MMM yyyy • hh:mm a").format(value.toDate());
    }

    return value.toString();
  }

  Future<void> updateStatus(String complaintId, String status) async {
    await FirebaseFirestore.instance
        .collection("complaints")
        .doc(complaintId)
        .update({"status": status, "updatedAt": FieldValue.serverTimestamp()});

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Complaint marked as $status")));
  }

  Future<void> deleteComplaint(String complaintId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Complaint"),
        content: const Text(
          "Are you sure you want to permanently delete this complaint?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection("complaints")
        .doc(complaintId)
        .delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint deleted successfully.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Complaints"), centerTitle: true),

      body: Column(
        children: [
          /// ==============================
          /// SEARCH BAR
          /// ==============================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search complaints...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),

          /// ==============================
          /// STATUS FILTER
          /// ==============================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: statuses.map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 15),

          /// ==============================
          /// COMPLAINT LIST
          /// ==============================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("complaints")
                  .orderBy("createdAt", descending: true)
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
                        Icon(Icons.inbox, size: 80, color: Colors.grey),

                        SizedBox(height: 12),

                        Text(
                          "No complaints available",
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

                  final title = (data["title"] ?? "").toString().toLowerCase();

                  final status = data["status"] ?? "Pending";

                  final searchMatch = title.contains(searchQuery);

                  final statusMatch = selectedStatus == "All"
                      ? true
                      : status == selectedStatus;

                  return searchMatch && statusMatch;
                }).toList();

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      "No matching complaints found.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),

                  itemCount: complaints.length,

                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    final data = complaint.data() as Map<String, dynamic>;

                    return buildComplaintCard(complaint.id, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComplaintCard(String complaintId, Map<String, dynamic> data) {
    final String status = data["status"] ?? "Pending";
    final String imageUrl = data["imageUrl"] ?? "";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(12),

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 65,
                      height: 65,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                )
              : Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image),
                ),
        ),

        title: Text(
          data["title"] ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.blue),

                const SizedBox(width: 5),

                Text(data["category"] ?? ""),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    data["location"] ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: getStatusColor(status).withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: getStatusColor(status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),

        children: [
          const Divider(),

          const SizedBox(height: 10),

          const Text(
            "Complaint Description",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 6),

          Text(data["description"] ?? "", style: const TextStyle(height: 1.5)),

          const SizedBox(height: 20),

          if (imageUrl.isNotEmpty) ...[
            const Text(
              "Complaint Image",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text("Complaint Image")),
                      body: InteractiveViewer(
                        child: Center(child: Image.network(imageUrl)),
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
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),

              const SizedBox(width: 8),

              Expanded(
                child: Text("Created: ${formatDate(data["createdAt"])}"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (data["updatedAt"] != null)
            Row(
              children: [
                const Icon(Icons.update, size: 18),

                const SizedBox(width: 8),

                Expanded(
                  child: Text("Updated: ${formatDate(data["updatedAt"])}"),
                ),
              ],
            ),

          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            value: status,

            decoration: InputDecoration(
              labelText: "Update Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            items: const [
              DropdownMenuItem(value: "Pending", child: Text("Pending")),

              DropdownMenuItem(
                value: "In Progress",
                child: Text("In Progress"),
              ),

              DropdownMenuItem(value: "Resolved", child: Text("Resolved")),

              DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
            ],

            onChanged: (value) {
              if (value == null) return;

              updateStatus(complaintId, value);
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                deleteComplaint(complaintId);
              },
              icon: const Icon(Icons.delete),
              label: const Text("Delete Complaint"),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
