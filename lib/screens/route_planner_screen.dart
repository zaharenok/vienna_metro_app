import 'package:flutter/material.dart';
import '../models/metro_station.dart';
import '../models/route_info.dart';
import '../services/metro_data.dart';
import '../services/route_finder.dart';
import '../widgets/metro_line_badge.dart';

class RoutePlannerScreen extends StatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  State<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen> {
  MetroStation? _fromStation;
  MetroStation? _toStation;
  RouteInfo? _routeInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Route'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStationSelector(
                  label: 'From',
                  station: _fromStation,
                  icon: Icons.trip_origin,
                  onTap: () => _selectStation(true),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.swap_vert),
                      onPressed: _swapStations,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStationSelector(
                  label: 'To',
                  station: _toStation,
                  icon: Icons.location_on,
                  onTap: () => _selectStation(false),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _fromStation != null && _toStation != null
                        ? _findRoute
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Find Route',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _routeInfo == null
                ? _buildEmptyState()
                : _buildRouteResult(_routeInfo!),
          ),
        ],
      ),
    );
  }

  Widget _buildStationSelector({
    required String label,
    required MetroStation? station,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station?.name ?? 'Select station',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: station != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (station != null)
              Wrap(
                spacing: 4,
                children: station.lines
                    .map((line) => MetroLineBadge(line: line, size: 24))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_transit,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Select stations to find a route',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteResult(RouteInfo route) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.timer,
                    label: 'Duration',
                    value: '${route.totalDuration} min',
                  ),
                  _buildStatItem(
                    icon: Icons.swap_horiz,
                    label: 'Transfers',
                    value: '${route.transfers}',
                  ),
                  _buildStatItem(
                    icon: Icons.location_city,
                    label: 'Stations',
                    value: '${route.totalStations}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Route Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...route.segments.asMap().entries.map((entry) {
            final index = entry.key;
            final segment = entry.value;
            return Column(
              children: [
                _buildSegmentCard(segment),
                if (index < route.segments.length - 1)
                  _buildTransferIndicator(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentCard(segment) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MetroLineBadge(line: segment.line),
                const SizedBox(width: 12),
                Text(
                  '${segment.duration} minutes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...segment.stations.asMap().entries.map((entry) {
              final index = entry.key;
              final station = entry.value;
              final isFirst = index == 0;
              final isLast = index == segment.stations.length - 1;

              return Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        isFirst
                            ? Icons.trip_origin
                            : isLast
                                ? Icons.location_on
                                : Icons.circle,
                        size: isFirst || isLast ? 20 : 12,
                        color: Colors.green,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 24,
                          color: Colors.green.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        station.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isFirst || isLast
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.transfer_within_a_station, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Text(
            'Transfer',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _selectStation(bool isFrom) async {
    final result = await showSearch(
      context: context,
      delegate: StationSearchDelegate(),
    );

    if (result != null) {
      setState(() {
        if (isFrom) {
          _fromStation = result;
        } else {
          _toStation = result;
        }
        _routeInfo = null;
      });
    }
  }

  void _swapStations() {
    setState(() {
      final temp = _fromStation;
      _fromStation = _toStation;
      _toStation = temp;
      _routeInfo = null;
    });
  }

  void _findRoute() {
    if (_fromStation == null || _toStation == null) return;

    final route = RouteFinder.findRoute(_fromStation!, _toStation!);
    
    setState(() {
      _routeInfo = route;
    });

    if (route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No route found between these stations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class StationSearchDelegate extends SearchDelegate<MetroStation?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildStationsList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildStationsList();
  }

  Widget _buildStationsList() {
    final stations = query.isEmpty
        ? MetroData.getAllStations()
        : MetroData.searchStations(query);

    stations.sort((a, b) => a.name.compareTo(b.name));

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return ListTile(
          leading: const Icon(Icons.subway),
          title: Text(station.name),
          trailing: Wrap(
            spacing: 4,
            children: station.lines
                .map((line) => MetroLineBadge(line: line, size: 24))
                .toList(),
          ),
          onTap: () {
            close(context, station);
          },
        );
      },
    );
  }
}
