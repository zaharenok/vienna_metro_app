import 'package:latlong2/latlong.dart';
import '../models/metro_station.dart';
import '../models/station_location.dart';
import 'metro_data.dart';

class StationsCoordinates {
  static final Map<String, LatLng> _coordinates = {
    'Leopoldau': LatLng(48.2776, 16.4313),
    'Großfeldsiedlung': LatLng(48.2696, 16.4413),
    'Aderklaaer Straße': LatLng(48.2631, 16.4392),
    'Rennbahnweg': LatLng(48.2565, 16.4358),
    'Kagraner Platz': LatLng(48.2505, 16.4407),
    'Kagran': LatLng(48.2493, 16.4432),
    'Alte Donau': LatLng(48.2396, 16.4284),
    'Kaisermühlen-VIC': LatLng(48.2302, 16.4133),
    'Donauinsel': LatLng(48.2251, 16.4068),
    'Vorgartenstraße': LatLng(48.2216, 16.3956),
    'Praterstern': LatLng(48.2185, 16.3926),
    'Nestroyplatz': LatLng(48.2146, 16.3881),
    'Schwedenplatz': LatLng(48.2113, 16.3747),
    'Stephansplatz': LatLng(48.2085, 16.3727),
    'Karlsplatz': LatLng(48.1988, 16.3697),
    'Taubstummengasse': LatLng(48.1943, 16.3707),
    'Südtiroler Platz-Hauptbahnhof': LatLng(48.1855, 16.3773),
    'Keplerplatz': LatLng(48.1789, 16.3795),
    'Reumannplatz': LatLng(48.1726, 16.3810),
    'Troststraße': LatLng(48.1656, 16.3777),
    'Altes Landgut': LatLng(48.1610, 16.3760),
    'Alaudagasse': LatLng(48.1560, 16.3727),
    'Neulaa': LatLng(48.1519, 16.3811),
    'Oberlaa': LatLng(48.1460, 16.4008),
    
    'Seestadt': LatLng(48.2245, 16.5066),
    'Aspern Nord': LatLng(48.2368, 16.4979),
    'Aspernstraße': LatLng(48.2334, 16.4827),
    'Hausfeldstraße': LatLng(48.2305, 16.4738),
    'Erzherzog-Karl-Straße': LatLng(48.2279, 16.4648),
    'Stadlau': LatLng(48.2226, 16.4498),
    'Hardeggasse': LatLng(48.2200, 16.4379),
    'Donauspital': LatLng(48.2308, 16.4451),
    'Donaumarina': LatLng(48.2306, 16.4182),
    'Donaustadt': LatLng(48.2263, 16.4058),
    'Stadion': LatLng(48.2174, 16.4098),
    'Krieau': LatLng(48.2150, 16.4018),
    'Messe-Prater': LatLng(48.2176, 16.3981),
    'Taborstraße': LatLng(48.2159, 16.3861),
    'Schottenring': LatLng(48.2155, 16.3644),
    'Schottentor': LatLng(48.2148, 16.3561),
    'Rathaus': LatLng(48.2099, 16.3572),
    'Volkstheater': LatLng(48.2054, 16.3571),
    'Museumsquartier': LatLng(48.2021, 16.3586),
    'Kettenbrückengasse': LatLng(48.1925, 16.3552),
    
    'Ottakring': LatLng(48.2141, 16.3090),
    'Kendlerstraße': LatLng(48.2128, 16.3201),
    'Hütteldorfer Straße': LatLng(48.2046, 16.3314),
    'Johnstraße': LatLng(48.2004, 16.3391),
    'Schweglerstraße': LatLng(48.1975, 16.3465),
    'Westbahnhof': LatLng(48.1966, 16.3383),
    'Zieglergasse': LatLng(48.2010, 16.3508),
    'Neubaugasse': LatLng(48.2033, 16.3540),
    'Herrengasse': LatLng(48.2101, 16.3656),
    'Stubentor': LatLng(48.2084, 16.3793),
    'Landstraße': LatLng(48.2032, 16.3839),
    'Rochusgasse': LatLng(48.2015, 16.3942),
    'Kardinal-Nagl-Platz': LatLng(48.1995, 16.4019),
    'Schlachthausgasse': LatLng(48.1928, 16.4082),
    'Erdberg': LatLng(48.1894, 16.4137),
    'Gasometer': LatLng(48.1866, 16.4218),
    'Zippererstraße': LatLng(48.1832, 16.4299),
    'Enkplatz': LatLng(48.1789, 16.4383),
    'Simmering': LatLng(48.1726, 16.4248),
    
    'Heiligenstadt': LatLng(48.2497, 16.3691),
    'Spittelau': LatLng(48.2318, 16.3608),
    'Friedensbrücke': LatLng(48.2251, 16.3746),
    'Rossauer Lände': LatLng(48.2203, 16.3689),
    'Stadtpark': LatLng(48.2032, 16.3794),
    'Pilgramgasse': LatLng(48.1918, 16.3579),
    'Margaretengürtel': LatLng(48.1865, 16.3471),
    'Längenfeldgasse': LatLng(48.1864, 16.3362),
    'Meidling Hauptstraße': LatLng(48.1785, 16.3285),
    'Schönbrunn': LatLng(48.1862, 16.3119),
    'Hietzing': LatLng(48.1898, 16.2992),
    'Unter St.Veit': LatLng(48.1881, 16.2658),
    'Ober St.Veit': LatLng(48.1885, 16.2558),
    'Braunschweiggasse': LatLng(48.1920, 16.2464),
    'Hütteldorf': LatLng(48.1974, 16.2390),
    
    'Siebenhirten': LatLng(48.1267, 16.3216),
    'Perfektastraße': LatLng(48.1358, 16.3262),
    'Erlaaer Straße': LatLng(48.1436, 16.3297),
    'Alterlaa': LatLng(48.1514, 16.3321),
    'Am Schöpfwerk': LatLng(48.1621, 16.3297),
    'Tscherttegasse': LatLng(48.1693, 16.3237),
    'Hetzendorf': LatLng(48.1744, 16.3196),
    'Atzgersdorf': LatLng(48.1575, 16.3136),
    'Gumpendorfer Straße': LatLng(48.1977, 16.3509),
    'Burggasse-Stadthalle': LatLng(48.2049, 16.3366),
    'Josefstädter Straße': LatLng(48.2099, 16.3411),
    'Alser Straße': LatLng(48.2148, 16.3476),
    'Michelbeuern-AKH': LatLng(48.2191, 16.3411),
    'Währinger Straße-Volksoper': LatLng(48.2251, 16.3479),
    'Nussdorfer Straße': LatLng(48.2335, 16.3564),
    'Jägerstraße': LatLng(48.2418, 16.3769),
    'Dresdner Straße': LatLng(48.2453, 16.3874),
    'Handelskai': LatLng(48.2465, 16.3947),
    'Neue Donau': LatLng(48.2517, 16.4073),
    'Floridsdorf': LatLng(48.2549, 16.3984),
  };

  static LatLng? getCoordinates(String stationName) {
    return _coordinates[stationName];
  }

  static List<StationLocation> getAllStationLocations() {
    final allStations = MetroData.getAllStations();
    final stationLocations = <StationLocation>[];

    for (final station in allStations) {
      final coords = getCoordinates(station.name);
      if (coords != null) {
        stationLocations.add(StationLocation(
          station: station,
          coordinates: coords,
        ));
      }
    }

    return stationLocations;
  }

  static StationLocation? getStationLocation(MetroStation station) {
    final coords = getCoordinates(station.name);
    if (coords == null) return null;

    return StationLocation(
      station: station,
      coordinates: coords,
    );
  }
}
