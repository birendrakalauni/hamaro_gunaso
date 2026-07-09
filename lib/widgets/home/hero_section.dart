import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
      child: isMobile ? _mobileLayout(context) : _desktopLayout(context),
    );
  }

  // Desktop Layout

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _leftSection(context)),

        const SizedBox(width: 50),

        Expanded(flex: 5, child: _rightSection()),
      ],
    );
  }

  // Mobile Layout

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        _rightSection(),

        const SizedBox(height: 40),

        _leftSection(context),
      ],
    );
  }

  // Left Content

  Widget _leftSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              height: 1.1,
              fontFamily: 'Roboto', // Optional
            ),
            children: [
              const TextSpan(
                text: "Voices that Shape\n",
                style: TextStyle(color: Color(0xff111827)),
              ),
              const TextSpan(
                text: "Your ",
                style: TextStyle(color: Color(0xff111827)),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xff60A5FA),
                        Color.fromARGB(255, 68, 117, 222),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "Community",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const SizedBox(
          width: 560,
          child: Text(
            "Hamaro Gunaso is a modern online complaint management platform where citizens can submit complaints, track their progress, and receive transparent updates from local authorities.",
            style: TextStyle(
              fontSize: 18,
              height: 1.7,
              color: Color(0xff6B7280),
            ),
          ),
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
                elevation: 6,
                backgroundColor: const Color.fromARGB(255, 87, 132, 228),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(width: 20),

            OutlinedButton.icon(
              onPressed: () {},

              icon: const Icon(Icons.info_outline),

              label: const Text("Learn More"),

              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xff2563EB),

                side: const BorderSide(color: Color(0xff2563EB)),

                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 22,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 55),

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

  // Right Illustration

  Widget _rightSection() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: 520,
            height: 520,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Hero Image
          Transform.rotate(
            angle: -.15,
            child: Image.asset(
              "assets/images/hero_phone.png",
              height: 650,
              fit: BoxFit.contain,
            ),
          ),
        ],
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
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Color(0xff2563EB),
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Color(0xff4B5563)),
          ),
        ],
      ),
    );
  }
}
