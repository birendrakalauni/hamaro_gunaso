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
  String searchQuery = '';

  String selectedStatus = 'All';

  String selectedCategory = 'All';

  String sortBy = 'Newest';

  final List<String> statuses = [
    'All',
    'Pending',
    'In Progress',
    'Resolved',
    'Rejected',
  ];

  final List<String> categories = [
    'All',
    'Road',
    'Water',
    'Electricity',
    'Sanitation',
    'Internet',
    'Other',
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

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Complaints")),
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
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                    items: statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
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
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
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
                  .collection('complaints')
                  .where('userId', isEqualTo: currentUser?.uid)
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
                        SizedBox(height: 10),
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

                  final title = data['title'].toString().toLowerCase();

                  final status = data['status'];

                  final category = data['category'];

                  final searchMatch = title.contains(searchQuery);

                  final statusMatch = selectedStatus == 'All'
                      ? true
                      : status == selectedStatus;

                  final categoryMatch = selectedCategory == 'All'
                      ? true
                      : category == selectedCategory;

                  return searchMatch && statusMatch && categoryMatch;
                }).toList();

                complaints.sort((a, b) {
                  Timestamp aTime = a['createdAt'];

                  Timestamp bTime = b['createdAt'];

                  if (sortBy == 'Newest') {
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
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    final data = complaint.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getStatusColor(
                            data['status'] ?? 'Pending',
                          ),
                          child: const Icon(
                            Icons.report_problem,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(data['title'] ?? ''),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['category'] ?? ''),

                            const SizedBox(height: 5),

                            Chip(
                              label: Text(data['status'] ?? 'Pending'),
                              backgroundColor: getStatusColor(
                                data['status'] ?? 'Pending',
                              ).withAlpha(40),
                            ),
                          ],
                        ),

                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ComplaintDetailsScreen(complaint: data),
                            ),
                          );
                        },
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
