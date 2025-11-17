import 'package:flutter/material.dart';

import 'device.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  double _level = 0.5;

  @override
  Widget build(BuildContext context) {
    final Device device = widget.device;

    Color iconColor;
    if (device.isOn == true) {
      iconColor = const Color(0xFFFACC15);
    } else {
      iconColor = Colors.white54;
    }

    String statusLine;
    Color statusColor;
    if (device.isOn == true) {
      statusLine = "The device is currently ON.";
      statusColor = const Color(0xFF22C55E);
    } else {
      statusLine = "The device is currently OFF.";
      statusColor = const Color(0xFFF97373);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        backgroundColor: const Color(0xFF111827),
      ),
      backgroundColor: const Color(0xFF050816),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconForType(device.type), size: 44, color: iconColor),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.type,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Room: ${device.room}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Power Status:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: device.isOn,
                  activeThumbColor: const Color(0xFF22C55E),
                  onChanged: (bool value) {
                    setState(() {
                      device.isOn = value;
                    });
                  },
                ),
              ],
            ),

            Text(
              statusLine,
              style: TextStyle(fontSize: 14, color: statusColor),
            ),

            const SizedBox(height: 24),

            const Text(
              "Level (Brightness / Speed)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

            Slider(
              value: _level,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: Colors.white24,
              onChanged: (double value) {
                setState(() {
                  _level = value;
                });
              },
            ),

            Text(
              "Level: ${(_level * 100).round()}%",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),

            const Spacer(),

            const Text(
              "This screen represents detailed control for a single device.\n"
              "In an industrial app, more options like schedules, timers, and\n"
              "safety limits could be added here.",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    if (type == "Light") {
      return Icons.lightbulb;
    } else if (type == "Fan") {
      return Icons.toys;
    } else if (type == "AC") {
      return Icons.ac_unit;
    }
    return Icons.device_hub;
  }
}
