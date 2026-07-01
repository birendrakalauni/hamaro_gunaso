import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      child: Column(
        children: [
          const Text(
            "About Hamaro Gunaso",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 850,
            child: Text(
              "Hamaro Gunaso is a digital complaint management platform designed to strengthen communication between citizens and local government. Citizens can easily report public issues, track complaint progress, and receive transparent updates while administrators efficiently monitor and resolve complaints.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                height: 1.7,
              ),
            ),
          ),

          const SizedBox(height: 60),

          isMobile
              ? Column(
                  children: const [
                    _AboutCard(
                      icon: Icons.flag,
                      title: "Our Mission",
                      description:
                          "To simplify the complaint submission process through technology and improve public service delivery.",
                    ),

                    SizedBox(height: 20),

                    _AboutCard(
                      icon: Icons.visibility,
                      title: "Our Vision",
                      description:
                          "To create transparent, accountable and citizen-centric governance for every municipality.",
                    ),

                    SizedBox(height: 20),

                    _AboutCard(
                      icon: Icons.verified_user,
                      title: "Transparency",
                      description:
                          "Citizens can monitor complaint status in real time, ensuring trust and accountability.",
                    ),
                  ],
                )
              : Row(
                  children: const [
                    Expanded(
                      child: _AboutCard(
                        icon: Icons.flag,
                        title: "Our Mission",
                        description:
                            "To simplify the complaint submission process through technology and improve public service delivery.",
                      ),
                    ),

                    SizedBox(width: 25),

                    Expanded(
                      child: _AboutCard(
                        icon: Icons.visibility,
                        title: "Our Vision",
                        description:
                            "To create transparent, accountable and citizen-centric governance for every municipality.",
                      ),
                    ),

                    SizedBox(width: 25),

                    Expanded(
                      child: _AboutCard(
                        icon: Icons.verified_user,
                        title: "Transparency",
                        description:
                            "Citizens can monitor complaint status in real time, ensuring trust and accountability.",
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AboutCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, color: Colors.blue, size: 36),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
