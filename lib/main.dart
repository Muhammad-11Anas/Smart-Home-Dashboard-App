import 'package:flutter/material.dart';

import 'device.dart'; // we’ll pull Device to its own file in a moment
import 'energy_screen.dart'; // placeholder, we’ll create this
import 'home_screen.dart';
import 'notifications_screen.dart'; // placeholder

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF050816),
        cardTheme: const CardThemeData(
          color: Color(0xFF0B1120),
          elevation: 6,
          margin: EdgeInsets.all(6),
        ),
      ),
      home: const MainShell(),
    );
  }
}

/// This widget owns:
/// - The list of devices (shared across tabs)
/// - The current bottom-nav index
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // 🔹 Shared device list for the whole app
  final List<Device> _devices = [
    Device(name: 'Living Room Light', type: 'Light', room: 'Living Room'),
    Device(name: 'Bedroom AC', type: 'AC', room: 'Bedroom'),
    Device(name: 'Kitchen Fan', type: 'Fan', room: 'Kitchen'),
    Device(name: 'Garage Light', type: 'Light', room: 'Garage'),
    Device(name: 'Hallway Light', type: 'Light', room: 'Hallway'),
    Device(name: 'Study Lamp', type: 'Light', room: 'Study Room'),
  ];

  void _onDeviceChanged() {
    // Just call setState so counts / UI refresh everywhere
    setState(() {});
  }

  void _onAddDevice(Device device) {
    setState(() {
      _devices.add(device);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        devices: _devices,
        onDevicesChanged: _onDeviceChanged,
        onAddDevice: _onAddDevice,
      ),
      EnergyScreen(devices: _devices),
      const NotificationsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF020617),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined),
            label: 'Energy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
