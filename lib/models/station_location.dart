import 'package:latlong2/latlong.dart';
import 'metro_station.dart';

class StationLocation {
  final MetroStation station;
  final LatLng coordinates;

  StationLocation({
    required this.station,
    required this.coordinates,
  });

  double distanceTo(LatLng userLocation) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, coordinates, userLocation);
  }

  String distanceToText(LatLng userLocation) {
    final meters = distanceTo(userLocation);
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}
