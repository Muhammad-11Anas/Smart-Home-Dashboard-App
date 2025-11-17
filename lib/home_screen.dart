import 'package:flutter/material.dart';

import 'device.dart';
import 'device_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Device> devices;
  final VoidCallback onDevicesChanged;
  final void Function(Device) onAddDevice;

  const HomeScreen({
    super.key,
    required this.devices,
    required this.onDevicesChanged,
    required this.onAddDevice,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get _devicesOnCount {
    int count = 0;
    for (final d in widget.devices) {
      if (d.isOn == true) {
        count++;
      }
    }
    return count;
  }

  void _toggleDevice(Device device, bool value) {
    setState(() {
      device.isOn = value;
    });
    widget.onDevicesChanged();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width > 600) {
      crossAxisCount = 3;
    }
    if (width > 900) {
      crossAxisCount = 4;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // later: Add-device dialog will be here
        },
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatusCard(
                    title: "Total Devices",
                    value: widget.devices.length.toString(),
                    icon: Icons.devices,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusCard(
                    title: "Devices ON",
                    value: _devicesOnCount.toString(),
                    icon: Icons.power,
                    color: const Color(0xFF22C55E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: widget.devices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final device = widget.devices[index];
                  return _DeviceCard(
                    device: device,
                    onToggle: (value) => _toggleDevice(device, value),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeviceDetailsScreen(device: device),
                        ),
                      ).then((_) {
                        setState(() {});
                        widget.onDevicesChanged();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4C1D95), Color(0xFF0EA5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: const Text(
        "Smart Home Dashboard",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu, color: Colors.white),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// ----------------- STATUS CARD -----------------

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = color.withValues(alpha: 80);
    Color glowColor = color.withValues(alpha: 120);
    Color bgColor = color.withValues(alpha: 40);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: glowColor, blurRadius: 14, spreadRadius: 1),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: bgColor,
                child: Icon(icon, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- DEVICE CARD -----------------

class _DeviceCard extends StatelessWidget {
  final Device device;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const _DeviceCard({
    required this.device,
    required this.onToggle,
    required this.onTap,
  });

  IconData _getIcon() {
    if (device.type == "Light") {
      return Icons.lightbulb;
    } else if (device.type == "Fan") {
      return Icons.toys;
    } else if (device.type == "AC") {
      return Icons.ac_unit;
    }
    return Icons.device_hub;
  }

  Color _iconColor() {
    if (device.isOn == true) {
      return const Color(0xFFFACC15);
    } else {
      return Colors.white70;
    }
  }

  Color _borderColor() {
    if (device.isOn == true) {
      return const Color(0xFF22C55E);
    } else {
      return Colors.white12;
    }
  }

  List<BoxShadow> _glowShadow() {
    if (device.isOn == true) {
      return [
        BoxShadow(
          color: const Color(0xFF22C55E).withValues(alpha: 120),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
    } else {
      return [];
    }
  }

  String _statusText() {
    if (device.isOn == true) {
      return "ON";
    } else {
      return "OFF";
    }
  }

  Color _statusChipColor() {
    if (device.isOn == true) {
      return const Color(0xFF16A34A);
    } else {
      return const Color(0xFF4B5563);
    }
  }

  IconData _statusIcon() {
    if (device.isOn == true) {
      return Icons.bolt;
    } else {
      return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _borderColor(), width: 1.2),
          boxShadow: _glowShadow(), // this changes when isOn flips
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(_getIcon(), size: 32, color: _iconColor()),
                    Switch(
                      value: device.isOn,
                      onChanged: onToggle,
                      activeThumbColor: const Color(0xFF22C55E), // Thumb ON
                      activeTrackColor: const Color(
                        0xFF22C55E,
                      ).withValues(alpha: 80), // Track ON
                      inactiveThumbColor: const Color(
                        0xFFB0B0B0,
                      ), // Thumb OFF (soft grey)
                      inactiveTrackColor: const Color(
                        0xFF3A3A3A,
                      ), // Track OFF (subtle dark grey)
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  device.room,
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusChipColor(),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(), size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "Status: ${_statusText()}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
