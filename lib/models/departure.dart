import 'metro_line.dart';

class Departure {
  final String stationName;
  final MetroLineType line;
  final String towards;
  final int countdown;
  final String? platform;
  final DateTime timestamp;

  Departure({
    required this.stationName,
    required this.line,
    required this.towards,
    required this.countdown,
    this.platform,
    required this.timestamp,
  });

  factory Departure.fromJson(Map<String, dynamic> json, String stationName) {
    return Departure(
      stationName: stationName,
      line: _parseLineType(json['name'] as String? ?? ''),
      towards: json['towards'] as String? ?? 'Unknown',
      countdown: int.tryParse(json['countdown']?.toString() ?? '0') ?? 0,
      platform: json['platform']?.toString(),
      timestamp: DateTime.now(),
    );
  }

  static MetroLineType _parseLineType(String lineName) {
    final upperLine = lineName.toUpperCase();
    if (upperLine.contains('U1')) return MetroLineType.u1;
    if (upperLine.contains('U2')) return MetroLineType.u2;
    if (upperLine.contains('U3')) return MetroLineType.u3;
    if (upperLine.contains('U4')) return MetroLineType.u4;
    if (upperLine.contains('U6')) return MetroLineType.u6;
    return MetroLineType.u1;
  }

  bool isExpired(int maxAgeSeconds) {
    return DateTime.now().difference(timestamp).inSeconds > maxAgeSeconds;
  }

  String get countdownText {
    if (countdown == 0) return 'Now';
    if (countdown == 1) return '1 min';
    return '$countdown min';
  }
}
