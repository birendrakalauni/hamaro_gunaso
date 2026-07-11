import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;
  final Map<String, dynamic> complaint;

  const AdminComplaintDetailsScreen({
    super.key,
    required this.complaintId,
    required this.complaint,
  });

  @override
  State<AdminComplaintDetailsScreen> createState() =>
      _AdminComplaintDetailsScreenState();
}

class _AdminComplaintDetailsScreenState
    extends State<AdminComplaintDetailsScreen> {
  late String selectedStatus;
  late TextEditingController responseController;
  bool isSaving = false;

  /// NEW
  bool responseAlreadySaved = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint["status"] ?? "Pending";
    responseController = TextEditingController(
      text: widget.complaint["adminResponse"] ?? "",
    );
    responseAlreadySaved = (widget.complaint["adminResponse"] ?? "")
        .toString()
        .trim()
        .isNotEmpty;
  }

  @override
  void dispose() {
    responseController.dispose();
    super.dispose();
  }

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
      return DateFormat("dd MMM yyyy • hh:mm a").format(DateTime.parse(value));
    }
    return value.toString();
  }

  Future<void> saveResponse() async {
    if (responseAlreadySaved) return;

    setState(() {
      isSaving = true;
    });

    await FirebaseFirestore.instance
        .collection("complaints")
        .doc(widget.complaintId)
        .update({
          "status": selectedStatus,
          "adminResponse": responseController.text.trim(),
          "responseDate": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });

    setState(() {
      isSaving = false;
      responseAlreadySaved = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Response submitted successfully.")),
    );
  }

  Future<void> deleteComplaint() async {
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
        .doc(widget.complaintId)
        .delete();

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Complaint deleted")));
  }

  Widget buildInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.complaint;

    final imageUrl = data["imageUrl"] ?? "";

    final bool complaintClosed =
        selectedStatus == "Resolved" || selectedStatus == "Rejected";

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  data["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: getStatusColor(selectedStatus).withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    selectedStatus,
                    style: TextStyle(
                      color: getStatusColor(selectedStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                if (imageUrl.toString().isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),

                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],

                buildInfo(Icons.category, "Category", data["category"] ?? ""),

                buildInfo(
                  Icons.location_on,
                  "Location",
                  data["location"] ?? "",
                ),

                buildInfo(
                  Icons.calendar_today,
                  "Created",
                  formatDate(data["createdAt"]),
                ),

                buildInfo(
                  Icons.update,
                  "Updated",
                  formatDate(data["updatedAt"]),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Complaint Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  data["description"] ?? "",
                  style: const TextStyle(height: 1.6),
                ),

                const SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  value: selectedStatus,

                  decoration: InputDecoration(
                    labelText: "Complaint Status",
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

                    DropdownMenuItem(
                      value: "Resolved",
                      child: Text("Resolved"),
                    ),

                    DropdownMenuItem(
                      value: "Rejected",
                      child: Text("Rejected"),
                    ),
                  ],

                  onChanged: complaintClosed
                      ? null
                      : (value) {
                          if (value == null) return;

                          setState(() {
                            selectedStatus = value;
                          });
                        },
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: responseController,

                  readOnly: responseAlreadySaved || complaintClosed,

                  maxLines: 5,

                  decoration: InputDecoration(
                    labelText: "Admin Response",

                    hintText: "Write response for citizen...",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,

                  child: FilledButton.icon(
                    onPressed:
                        responseAlreadySaved || complaintClosed || isSaving
                        ? null
                        : saveResponse,

                    icon: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            responseAlreadySaved
                                ? Icons.check_circle
                                : complaintClosed
                                ? Icons.lock
                                : Icons.send,
                          ),

                    label: Text(
                      responseAlreadySaved
                          ? "Response Submitted"
                          : complaintClosed
                          ? "Complaint Closed"
                          : "Save Response",
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,

                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),

                    onPressed: deleteComplaint,

                    icon: const Icon(Icons.delete),

                    label: const Text("Delete Complaint"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
