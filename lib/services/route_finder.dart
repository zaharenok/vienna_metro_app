import 'dart:collection';
import '../models/metro_station.dart';
import '../models/metro_line.dart';
import '../models/route_info.dart';
import 'metro_data.dart';

class RouteFinder {
  static RouteInfo? findRoute(MetroStation from, MetroStation to) {
    if (from.id == to.id) return null;

    final queue = Queue<_RouteState>();
    final visited = <String>{};
    
    queue.add(_RouteState(
      currentStation: from,
      path: [from],
      currentLine: from.lines.first,
      duration: 0,
      transfers: 0,
    ));

    while (queue.isNotEmpty) {
      final state = queue.removeFirst();
      
      if (state.currentStation.id == to.id) {
        return _buildRouteInfo(state);
      }

      if (visited.contains(state.currentStation.id)) continue;
      visited.add(state.currentStation.id);

      for (final line in state.currentStation.lines) {
        final stations = MetroData.getStationsByLine(line);
        final currentIndex = stations.indexWhere(
          (s) => s.id == state.currentStation.id,
        );

        if (currentIndex != -1) {
          if (currentIndex > 0) {
            final nextStation = stations[currentIndex - 1];
            if (!visited.contains(nextStation.id)) {
              queue.add(_RouteState(
                currentStation: nextStation,
                path: [...state.path, nextStation],
                currentLine: line,
                duration: state.duration + 2,
                transfers: state.transfers + (line != state.currentLine ? 1 : 0),
              ));
            }
          }

          if (currentIndex < stations.length - 1) {
            final nextStation = stations[currentIndex + 1];
            if (!visited.contains(nextStation.id)) {
              queue.add(_RouteState(
                currentStation: nextStation,
                path: [...state.path, nextStation],
                currentLine: line,
                duration: state.duration + 2,
                transfers: state.transfers + (line != state.currentLine ? 1 : 0),
              ));
            }
          }
        }
      }
    }

    return null;
  }

  static RouteInfo _buildRouteInfo(_RouteState state) {
    final segments = <RouteSegment>[];
    var currentLine = state.path.first.lines.first;
    var segmentStations = <MetroStation>[state.path.first];

    for (var i = 1; i < state.path.length; i++) {
      final station = state.path[i];
      
      if (station.lines.contains(currentLine)) {
        segmentStations.add(station);
      } else {
        segments.add(RouteSegment(
          line: currentLine,
          stations: segmentStations,
          duration: (segmentStations.length - 1) * 2,
        ));

        currentLine = station.lines.firstWhere(
          (line) => i + 1 < state.path.length 
              ? state.path[i + 1].lines.contains(line)
              : true,
          orElse: () => station.lines.first,
        );
        segmentStations = [station];
      }
    }

    if (segmentStations.isNotEmpty) {
      segments.add(RouteSegment(
        line: currentLine,
        stations: segmentStations,
        duration: (segmentStations.length - 1) * 2,
      ));
    }

    final totalDuration = segments.fold<int>(
      0,
      (sum, segment) => sum + segment.duration,
    ) + (segments.length - 1) * 3;

    return RouteInfo(
      segments: segments,
      totalDuration: totalDuration,
      totalStations: state.path.length,
      transfers: segments.length - 1,
    );
  }
}

class _RouteState {
  final MetroStation currentStation;
  final List<MetroStation> path;
  final MetroLineType currentLine;
  final int duration;
  final int transfers;

  _RouteState({
    required this.currentStation,
    required this.path,
    required this.currentLine,
    required this.duration,
    required this.transfers,
  });
}
