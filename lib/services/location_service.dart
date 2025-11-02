import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/station_location.dart';
import 'stations_coordinates.dart';

class LocationService {
  static Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<StationLocation?> findNearestStation() async {
    final position = await getCurrentLocation();
    if (position == null) return null;

    final userLocation = LatLng(position.latitude, position.longitude);
    final allStations = StationsCoordinates.getAllStationLocations();

    if (allStations.isEmpty) return null;

    allStations.sort((a, b) => 
      a.distanceTo(userLocation).compareTo(b.distanceTo(userLocation))
    );

    return allStations.first;
  }

  static Future<List<StationLocation>> findNearbyStations({
    double radiusMeters = 1000,
    int maxResults = 5,
  }) async {
    final position = await getCurrentLocation();
    if (position == null) return [];

    final userLocation = LatLng(position.latitude, position.longitude);
    final allStations = StationsCoordinates.getAllStationLocations();

    final nearbyStations = allStations
        .where((station) => station.distanceTo(userLocation) <= radiusMeters)
        .toList();

    nearbyStations.sort((a, b) => 
      a.distanceTo(userLocation).compareTo(b.distanceTo(userLocation))
    );

    return nearbyStations.take(maxResults).toList();
  }

  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  static bool isNearStation(
    Position userPosition,
    LatLng stationLocation, {
    double thresholdMeters = 200,
  }) {
    const distance = Distance();
    final meters = distance.as(
      LengthUnit.Meter,
      LatLng(userPosition.latitude, userPosition.longitude),
      stationLocation,
    );
    return meters <= thresholdMeters;
  }
}
