import 'package:flutter/material.dart';

enum MetroLineType {
  u1,
  u2,
  u3,
  u4,
  u6,
}

class MetroLine {
  final MetroLineType type;
  final String name;
  final Color color;
  final List<String> stations;

  MetroLine({
    required this.type,
    required this.name,
    required this.color,
    required this.stations,
  });

  static Color getLineColor(MetroLineType type) {
    switch (type) {
      case MetroLineType.u1:
        return const Color(0xFFE20613);
      case MetroLineType.u2:
        return const Color(0xFFA862A4);
      case MetroLineType.u3:
        return const Color(0xFFF39200);
      case MetroLineType.u4:
        return const Color(0xFF00963F);
      case MetroLineType.u6:
        return const Color(0xFF8B5A3C);
    }
  }

  static String getLineName(MetroLineType type) {
    switch (type) {
      case MetroLineType.u1:
        return 'U1';
      case MetroLineType.u2:
        return 'U2';
      case MetroLineType.u3:
        return 'U3';
      case MetroLineType.u4:
        return 'U4';
      case MetroLineType.u6:
        return 'U6';
    }
  }
}
