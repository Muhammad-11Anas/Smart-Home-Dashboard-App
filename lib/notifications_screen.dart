import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts & Notifications"),
        backgroundColor: const Color(0xFF020617),
      ),
      backgroundColor: const Color(0xFF050816),
      body: const Center(
        child: Text(
          "No alerts right now.\n\n"
          "Later, we can show device warnings here.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
