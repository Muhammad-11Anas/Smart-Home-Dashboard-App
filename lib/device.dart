class Device {
  final String name;
  final String type;
  final String room;
  bool isOn;

  Device({
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
  });
}
