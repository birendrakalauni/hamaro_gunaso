import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onFeatures;
  final VoidCallback onContact;

  const HomeAppBar({
    super.key,
    required this.onHome,
    required this.onAbout,
    required this.onFeatures,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 237, 238, 231),
      surfaceTintColor: const Color.fromARGB(255, 83, 69, 231),
      elevation: 1,
      automaticallyImplyLeading: false,

      title: RichText(
        text: const TextSpan(
          style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Roboto'),
          children: [
            TextSpan(
              text: 'Hamaro ',
              style: TextStyle(fontSize: 24, color: Color(0xFF111827)),
            ),
            TextSpan(
              text: 'Gunaso',
              style: TextStyle(fontSize: 26, color: Color(0xFF111827)),
            ),
          ],
        ),
      ),

      actions: [
        _navButton(title: "Home", onTap: onHome),

        _navButton(title: "About", onTap: onAbout),

        _navButton(title: "Features", onTap: onFeatures),

        _navButton(title: "Contact", onTap: onContact),

        const SizedBox(width: 20),

        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Log In / Sign Up",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navButton({required String title, required VoidCallback onTap}) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
