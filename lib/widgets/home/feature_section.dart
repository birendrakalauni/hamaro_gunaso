import 'package:flutter/material.dart';

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      child: Column(
        children: [
          const Text(
            "Key Features",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Text(
            "Everything you need for efficient complaint management.",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 50),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            childAspectRatio: isMobile ? 2.8 : 1.2,
            children: const [
              FeatureCard(
                icon: Icons.report_problem,
                color: Colors.red,
                title: "Easy Complaint",
                description:
                    "Submit complaints quickly with detailed information.",
              ),
              FeatureCard(
                icon: Icons.track_changes,
                color: Colors.blue,
                title: "Track Progress",
                description:
                    "Monitor complaint status from submission to resolution.",
              ),
              FeatureCard(
                icon: Icons.notifications_active,
                color: Colors.orange,
                title: "Notifications",
                description:
                    "Receive instant updates whenever your complaint changes.",
              ),
              FeatureCard(
                icon: Icons.admin_panel_settings,
                color: Colors.green,
                title: "Admin Management",
                description:
                    "Municipality officials manage complaints efficiently.",
              ),
              FeatureCard(
                icon: Icons.analytics,
                color: Colors.purple,
                title: "Analytics",
                description:
                    "Dashboard provides complaint statistics and reports.",
              ),
              FeatureCard(
                icon: Icons.verified,
                color: Colors.teal,
                title: "Transparency",
                description:
                    "Promotes accountability through transparent complaint tracking.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isHovered
              ? widget.color.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isHovered ? widget.color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: widget.color.withValues(alpha: 0.15),
              child: Icon(widget.icon, color: widget.color, size: 35),
            ),

            const SizedBox(height: 20),

            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.6,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
