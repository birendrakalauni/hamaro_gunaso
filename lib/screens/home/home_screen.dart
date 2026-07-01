import 'package:flutter/material.dart';

import '../../widgets/home/about_section.dart';
import '../../widgets/home/contact_section.dart';
import '../../widgets/home/feature_section.dart';
import '../../widgets/home/footer.dart';
import '../../widgets/home/hero_section.dart';
import '../../widgets/home/home_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  final GlobalKey homeKey = GlobalKey();

  final GlobalKey aboutKey = GlobalKey();

  final GlobalKey featureKey = GlobalKey();

  final GlobalKey contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: HomeAppBar(
        onHome: () => scrollTo(homeKey),
        onAbout: () => scrollTo(aboutKey),
        onFeatures: () => scrollTo(featureKey),
        onContact: () => scrollTo(contactKey),
      ),

      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(key: homeKey, child: const HeroSection()),

            Container(key: aboutKey, child: const AboutSection()),

            Container(key: featureKey, child: const FeatureSection()),

            Container(key: contactKey, child: const ContactSection()),

            const Footer(),
          ],
        ),
      ),
    );
  }
}
