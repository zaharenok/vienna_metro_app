import 'metro_station.dart';
import 'metro_line.dart';

class RouteSegment {
  final MetroLineType line;
  final List<MetroStation> stations;
  final int duration;

  RouteSegment({
    required this.line,
    required this.stations,
    required this.duration,
  });
}

class RouteInfo {
  final List<RouteSegment> segments;
  final int totalDuration;
  final int totalStations;
  final int transfers;

  RouteInfo({
    required this.segments,
    required this.totalDuration,
    required this.totalStations,
    required this.transfers,
  });

  MetroStation get startStation => segments.first.stations.first;
  MetroStation get endStation => segments.last.stations.last;
}
