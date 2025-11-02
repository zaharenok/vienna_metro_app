import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/metro_line.dart';
import '../models/station_location.dart';
import '../services/location_service.dart';
import '../services/stations_coordinates.dart';
import 'live_departures_screen.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  Position? _userPosition;
  StationLocation? _nearestStation;
  bool _isLoadingLocation = false;
  String? _locationError;

  static const LatLng _viennaCenter = LatLng(48.2082, 16.3738);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      
      if (position != null) {
        setState(() {
          _userPosition = position;
          _isLoadingLocation = false;
        });

        _mapController.move(
          LatLng(position.latitude, position.longitude),
          14,
        );

        final nearest = await LocationService.findNearestStation();
        setState(() {
          _nearestStation = nearest;
        });
      } else {
        setState(() {
          _locationError = 'Location permission denied';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationError = 'Failed to get location';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metro Map'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _isLoadingLocation ? null : _getUserLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userPosition != null
                  ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
                  : _viennaCenter,
              initialZoom: 13,
              minZoom: 11,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.vienna_metro',
              ),
              MarkerLayer(
                markers: _buildStationMarkers(),
              ),
              if (_userPosition != null)
                MarkerLayer(
                  markers: [_buildUserMarker()],
                ),
            ],
          ),
          if (_isLoadingLocation)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Getting your location...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_nearestStation != null && _userPosition != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildNearestStationCard(),
            ),
        ],
      ),
    );
  }

  List<Marker> _buildStationMarkers() {
    final stationLocations = StationsCoordinates.getAllStationLocations();
    
    return stationLocations.map((stationLocation) {
      final isNearest = _nearestStation?.station.id == stationLocation.station.id;
      
      return Marker(
        point: stationLocation.coordinates,
        width: isNearest ? 60 : 40,
        height: isNearest ? 60 : 40,
        child: GestureDetector(
          onTap: () {
            _showStationDialog(stationLocation);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isNearest)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              Container(
                width: isNearest ? 40 : 30,
                height: isNearest ? 40 : 30,
                decoration: BoxDecoration(
                  color: _getStationColor(stationLocation),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: isNearest ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    MetroLine.getLineName(stationLocation.station.lines.first).substring(1),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isNearest ? 16 : 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Marker _buildUserMarker() {
    return Marker(
      point: LatLng(_userPosition!.latitude, _userPosition!.longitude),
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearestStationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.near_me, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Nearest Station',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nearestStation!.station.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _nearestStation!.distanceToText(
                          LatLng(_userPosition!.latitude, _userPosition!.longitude),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveDeparturesScreen(
                          station: _nearestStation!.station,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Departures'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStationDialog(StationLocation stationLocation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stationLocation.station.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lines:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: stationLocation.station.lines
                  .map((line) => Chip(
                        label: Text(
                          MetroLine.getLineName(line),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: MetroLine.getLineColor(line),
                      ))
                  .toList(),
            ),
            if (_userPosition != null) ...[
              const SizedBox(height: 12),
              Text(
                'Distance: ${stationLocation.distanceToText(
                  LatLng(_userPosition!.latitude, _userPosition!.longitude),
                )}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveDeparturesScreen(
                    station: stationLocation.station,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Live Departures'),
          ),
        ],
      ),
    );
  }

  Color _getStationColor(StationLocation stationLocation) {
    return MetroLine.getLineColor(stationLocation.station.lines.first);
  }
}
