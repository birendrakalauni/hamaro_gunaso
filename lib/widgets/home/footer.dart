import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          const Text(
            "Hamaro Gunaso",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Empowering Citizens through Transparent Complaint Management",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 30),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Terms & Conditions",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Help",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const Divider(color: Colors.white30, height: 40),

          const Text(
            "© 2026 Hamaro Gunaso. All Rights Reserved.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 8),

          const Text(
            "Developed by TriFusion-NRB",
            style: TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
