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
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,

      title: const Text(
        "Hamaro Gunaso",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 24,
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
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Log In / Sign Up"),
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
