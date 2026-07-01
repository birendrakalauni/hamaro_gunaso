import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: isMobile ? _mobileLayout(context) : _desktopLayout(context),
    );
  }

  // -------------------------------
  // Desktop Layout
  // -------------------------------

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 5, child: _leftSection(context)),

        const SizedBox(width: 50),

        Expanded(flex: 5, child: _rightSection()),
      ],
    );
  }

  // -------------------------------
  // Mobile Layout
  // -------------------------------

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        _leftSection(context),

        const SizedBox(height: 40),

        _rightSection(),
      ],
    );
  }

  // -------------------------------
  // Left Content
  // -------------------------------

  Widget _leftSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Voices that Shape\nYour Community",
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Hamaro Gunaso is a modern online complaint management platform where citizens can submit complaints, track their progress, and receive transparent updates from local authorities.",
          style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.7),
        ),

        const SizedBox(height: 35),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.login),
              label: const Text("Get Started"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 18,
                ),
              ),
            ),

            const SizedBox(width: 15),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              label: const Text("Learn More"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 18,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        Wrap(
          spacing: 25,
          runSpacing: 20,
          children: const [
            _StatCard(number: "100+", label: "Complaints"),
            _StatCard(number: "85+", label: "Resolved"),
            _StatCard(number: "24/7", label: "Support"),
          ],
        ),
      ],
    );
  }

  // -------------------------------
  // Right Illustration
  // -------------------------------

  Widget _rightSection() {
    return Center(
      child: Image.asset(
        "assets/images/AppLogo.png",
        height: 420,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 350,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign, size: 120, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  "Hero Image",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Replace assets/images/AppLogo.png",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
