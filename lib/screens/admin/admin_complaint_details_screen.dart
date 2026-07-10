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

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.complaint["status"] ?? "Pending";

    responseController = TextEditingController(
      text: widget.complaint["adminResponse"] ?? "",
    );
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
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint updated successfully")),
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

  @override
  Widget build(BuildContext context) {
    final data = widget.complaint;
    final imageUrl = data["imageUrl"] ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  data["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Chip(
                  label: Text(selectedStatus),
                  backgroundColor: getStatusColor(
                    selectedStatus,
                  ).withOpacity(.15),
                  side: BorderSide(color: getStatusColor(selectedStatus)),
                ),

                const SizedBox(height: 25),

                /// IMAGE
                const Text(
                  "Complaint Image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 12),

                if (imageUrl.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(),

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
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 60),
                        SizedBox(height: 10),
                        Text("No Image Uploaded"),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                const Divider(),

                buildInfo("Category", data["category"]),

                buildInfo("Location", data["location"]),

                buildInfo("Created", formatDate(data["createdAt"])),

                buildInfo("Updated", formatDate(data["updatedAt"])),

                const SizedBox(height: 20),

                const Text(
                  "Complaint Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(
                  data["description"] ?? "",
                  style: const TextStyle(height: 1.6),
                ),

                const SizedBox(height: 25),

                const Divider(),

                DropdownButtonFormField<String>(
                  value: selectedStatus,

                  decoration: const InputDecoration(
                    labelText: "Update Status",
                    border: OutlineInputBorder(),
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

                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: responseController,
                  maxLines: 5,

                  decoration: const InputDecoration(
                    labelText: "Admin Response",
                    hintText: "Write your response...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,

                  child: FilledButton.icon(
                    onPressed: isSaving ? null : saveResponse,

                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: const Text("Save Response"),
                  ),
                ),

                const SizedBox(height: 12),

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

  Widget buildInfo(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value?.toString() ?? "")),
        ],
      ),
    );
  }
}
