import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/dashboard_service.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../widgets/dashboard_card.dart';

import '../auth/login_screen.dart';
import 'manage_complaints_screen.dart';
import 'users_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardService dashboardService = DashboardService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
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
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              final authProvider = Provider.of<app_auth.AuthProvider>(
                context,
                listen: false,
              );

              await authProvider.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<Map<String, int>>(
        stream: dashboardService.getDashboardStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final stats =
              snapshot.data ??
              {
                'total': 0,
                'pending': 0,
                'inProgress': 0,
                'resolved': 0,
                'rejected': 0,
                'users': 0,
              };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    DashboardCard(
                      title: "Total Complaints",
                      value: stats['total'].toString(),
                      icon: Icons.description,
                      color: Colors.blue,
                    ),

                    DashboardCard(
                      title: "Pending",
                      value: stats['pending'].toString(),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),

                    DashboardCard(
                      title: "In Progress",
                      value: stats['inProgress'].toString(),
                      icon: Icons.sync,
                      color: Colors.amber,
                    ),

                    DashboardCard(
                      title: "Resolved",
                      value: stats['resolved'].toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),

                    DashboardCard(
                      title: "Rejected",
                      value: stats['rejected'].toString(),
                      icon: Icons.cancel,
                      color: Colors.red,
                    ),

                    DashboardCard(
                      title: "Total Users",
                      value: stats['users'].toString(),
                      icon: Icons.people,
                      color: Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.report_problem),
                    label: const Text("Manage Complaints"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageComplaintsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.people),
                    label: const Text("View Users"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
