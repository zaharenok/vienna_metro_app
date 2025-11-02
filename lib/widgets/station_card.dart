import 'package:flutter/material.dart';
import '../models/metro_station.dart';
import 'metro_line_badge.dart';

class StationCard extends StatelessWidget {
  final MetroStation station;
  final VoidCallback? onTap;

  const StationCard({
    super.key,
    required this.station,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (station.isTransferStation())
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Transfer Station',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                children: station.lines
                    .map((line) => MetroLineBadge(
                          line: line,
                          size: 28,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
