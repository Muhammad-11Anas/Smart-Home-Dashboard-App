import 'package:flutter/material.dart';

import 'device.dart';

class EnergyScreen extends StatelessWidget {
  final List<Device> devices;

  const EnergyScreen({super.key, required this.devices});

  int _countForType(String type) {
    int count = 0;
    for (final d in devices) {
      if (d.type == type && d.isOn == true) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    int lightsOn = _countForType("Light");
    int fansOn = _countForType("Fan");
    int acOn = _countForType("AC");

    int maxValue = lightsOn;
    if (fansOn > maxValue) {
      maxValue = fansOn;
    }
    if (acOn > maxValue) {
      maxValue = acOn;
    }
    if (maxValue == 0) {
      maxValue = 1; // avoid division by zero
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy Overview"),
        backgroundColor: const Color(0xFF020617),
      ),
      backgroundColor: const Color(0xFF050816),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Approximate usage by device type",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBar(
                    label: "Lights",
                    value: lightsOn,
                    maxValue: maxValue,
                    color: const Color(0xFFFACC15),
                  ),
                  _buildBar(
                    label: "Fans",
                    value: fansOn,
                    maxValue: maxValue,
                    color: const Color(0xFF22C55E),
                  ),
                  _buildBar(
                    label: "AC",
                    value: acOn,
                    maxValue: maxValue,
                    color: const Color(0xFF38BDF8),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Note: Bars represent number of devices currently ON in each category.\n"
              "In a real industrial system, this would be based on actual power data.",
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    double heightFactor = value / maxValue;
    double barHeight = 150 * heightFactor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: barHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 160),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 120),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$value",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
