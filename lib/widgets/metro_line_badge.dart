import 'package:flutter/material.dart';
import '../models/metro_line.dart';

class MetroLineBadge extends StatelessWidget {
  final MetroLineType line;
  final double size;

  const MetroLineBadge({
    super.key,
    required this.line,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: MetroLine.getLineColor(line),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          MetroLine.getLineName(line),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
