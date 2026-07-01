import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/complaint_provider.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({super.key});

  @override
  State<ManageComplaintsScreen> createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  String searchQuery = '';

  String selectedStatus = 'All';

  final List<String> statuses = [
    'All',
    'Pending',
    'In Progress',
    'Resolved',
    'Rejected',
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;

      case 'Rejected':
        return Colors.red;

      case 'In Progress':
        return Colors.orange;

      case 'Pending':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  Future<void> deleteComplaint(String complaintId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Complaint"),
        content: const Text("Are you sure you want to delete this complaint?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(complaintId)
        .delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint deleted successfully.")),
    );
  }

  Future<void> showUpdateDialog(Map<String, dynamic> complaint) async {
    final provider = Provider.of<ComplaintProvider>(context, listen: false);

    final responseController = TextEditingController(
      text: complaint['adminResponse'] ?? '',
    );

    String status = complaint['status'] ?? 'Pending';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Update Complaint"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                        labelText: "Complaint Status",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'Resolved',
                          child: Text('Resolved'),
                        ),
                        DropdownMenuItem(
                          value: 'Rejected',
                          child: Text('Rejected'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          status = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: responseController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Admin Response",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await provider.updateComplaint(
                      complaintId: complaint['complaintId'],
                      status: status,
                      response: responseController.text.trim(),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Complaint updated successfully."),
                      ),
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Complaints")),
      body: Column(
        children: [
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Filter Status",
                border: OutlineInputBorder(),
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

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No complaints found."));
                }

                final complaints = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final title = (data['title'] ?? '').toString().toLowerCase();

                  final status = data['status'] ?? 'Pending';

                  final matchesSearch = title.contains(searchQuery);

                  final matchesStatus = selectedStatus == 'All'
                      ? true
                      : status == selectedStatus;

                  return matchesSearch && matchesStatus;
                }).toList();

                if (complaints.isEmpty) {
                  return const Center(child: Text("No matching complaints."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    final data = complaint.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 3,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: getStatusColor(
                            data['status'] ?? 'Pending',
                          ),
                          child: const Icon(
                            Icons.report_problem,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          data['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),

                            Text(data['category'] ?? ''),

                            const SizedBox(height: 6),

                            Chip(
                              label: Text(data['status'] ?? 'Pending'),
                              backgroundColor: getStatusColor(
                                data['status'] ?? 'Pending',
                              ).withAlpha(40),
                            ),
                          ],
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 5),

                                Text(data['description'] ?? ''),

                                const SizedBox(height: 15),

                                const Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 5),

                                Text(data['location'] ?? ''),

                                const SizedBox(height: 15),

                                if ((data['adminResponse'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                                  const Text(
                                    "Admin Response",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(data['adminResponse']),
                                  ),

                                  const SizedBox(height: 15),
                                ],

                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.edit),
                                        label: const Text("Update"),
                                        onPressed: () {
                                          showUpdateDialog(data);
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(Icons.delete),
                                        label: const Text("Delete"),
                                        onPressed: () {
                                          deleteComplaint(complaint.id);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
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
