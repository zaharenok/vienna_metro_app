import '../models/metro_station.dart';
import '../models/metro_line.dart';

class MetroData {
  static final Map<String, MetroStation> _stations = {};
  
  static void initialize() {
    _addU1Stations();
    _addU2Stations();
    _addU3Stations();
    _addU4Stations();
    _addU6Stations();
  }

  static void _addU1Stations() {
    final u1Stations = [
      'Leopoldau',
      'Großfeldsiedlung',
      'Aderklaaer Straße',
      'Rennbahnweg',
      'Kagraner Platz',
      'Kagran',
      'Alte Donau',
      'Kaisermühlen-VIC',
      'Donauinsel',
      'Vorgartenstraße',
      'Praterstern',
      'Nestroyplatz',
      'Schwedenplatz',
      'Stephansplatz',
      'Karlsplatz',
      'Taubstummengasse',
      'Südtiroler Platz-Hauptbahnhof',
      'Keplerplatz',
      'Reumannplatz',
      'Troststraße',
      'Altes Landgut',
      'Alaudagasse',
      'Neulaa',
      'Oberlaa',
    ];

    for (var name in u1Stations) {
      final id = 'u1_${name.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_')}';
      _stations[id] = MetroStation(
        id: id,
        name: name,
        lines: [MetroLineType.u1],
      );
    }
  }

  static void _addU2Stations() {
    final u2Stations = [
      'Seestadt',
      'Aspern Nord',
      'Aspernstraße',
      'Hausfeldstraße',
      'Erzherzog-Karl-Straße',
      'Stadlau',
      'Hardeggasse',
      'Donauspital',
      'Donaumarina',
      'Donaustadt',
      'Stadion',
      'Krieau',
      'Messe-Prater',
      'Praterstern',
      'Taborstraße',
      'Nestroyplatz',
      'Schwedenplatz',
      'Schottenring',
      'Schottentor',
      'Rathaus',
      'Volkstheater',
      'Museumsquartier',
      'Karlsplatz',
      'Kettenbrückengasse',
    ];

    for (var name in u2Stations) {
      final id = 'u2_${name.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_')}';
      final existingStation = _findStation(name);
      if (existingStation != null) {
        existingStation.lines.add(MetroLineType.u2);
      } else {
        _stations[id] = MetroStation(
          id: id,
          name: name,
          lines: [MetroLineType.u2],
        );
      }
    }
  }

  static void _addU3Stations() {
    final u3Stations = [
      'Ottakring',
      'Kendlerstraße',
      'Hütteldorfer Straße',
      'Johnstraße',
      'Schweglerstraße',
      'Westbahnhof',
      'Zieglergasse',
      'Neubaugasse',
      'Volkstheater',
      'Herrengasse',
      'Stephansplatz',
      'Stubentor',
      'Landstraße',
      'Rochusgasse',
      'Kardinal-Nagl-Platz',
      'Schlachthausgasse',
      'Erdberg',
      'Gasometer',
      'Zippererstraße',
      'Enkplatz',
      'Simmering',
    ];

    for (var name in u3Stations) {
      final id = 'u3_${name.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_')}';
      final existingStation = _findStation(name);
      if (existingStation != null) {
        existingStation.lines.add(MetroLineType.u3);
      } else {
        _stations[id] = MetroStation(
          id: id,
          name: name,
          lines: [MetroLineType.u3],
        );
      }
    }
  }

  static void _addU4Stations() {
    final u4Stations = [
      'Heiligenstadt',
      'Spittelau',
      'Friedensbrücke',
      'Rossauer Lände',
      'Schottenring',
      'Schwedenplatz',
      'Landstraße',
      'Stadtpark',
      'Karlsplatz',
      'Kettenbrückengasse',
      'Pilgramgasse',
      'Margaretengürtel',
      'Längenfeldgasse',
      'Meidling Hauptstraße',
      'Schönbrunn',
      'Hietzing',
      'Unter St.Veit',
      'Ober St.Veit',
      'Braunschweiggasse',
      'Hütteldorf',
    ];

    for (var name in u4Stations) {
      final id = 'u4_${name.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_').replaceAll('.', '')}';
      final existingStation = _findStation(name);
      if (existingStation != null) {
        existingStation.lines.add(MetroLineType.u4);
      } else {
        _stations[id] = MetroStation(
          id: id,
          name: name,
          lines: [MetroLineType.u4],
        );
      }
    }
  }

  static void _addU6Stations() {
    final u6Stations = [
      'Siebenhirten',
      'Perfektastraße',
      'Erlaaer Straße',
      'Alterlaa',
      'Am Schöpfwerk',
      'Tscherttegasse',
      'Hetzendorf',
      'Atzgersdorf',
      'Meidling Hauptstraße',
      'Längenfeldgasse',
      'Gumpendorfer Straße',
      'Westbahnhof',
      'Burggasse-Stadthalle',
      'Josefstädter Straße',
      'Alser Straße',
      'Michelbeuern-AKH',
      'Währinger Straße-Volksoper',
      'Nussdorfer Straße',
      'Spittelau',
      'Jägerstraße',
      'Dresdner Straße',
      'Handelskai',
      'Neue Donau',
      'Floridsdorf',
    ];

    for (var name in u6Stations) {
      final id = 'u6_${name.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_').replaceAll('.', '')}';
      final existingStation = _findStation(name);
      if (existingStation != null) {
        existingStation.lines.add(MetroLineType.u6);
      } else {
        _stations[id] = MetroStation(
          id: id,
          name: name,
          lines: [MetroLineType.u6],
        );
      }
    }
  }

  static MetroStation? _findStation(String name) {
    return _stations.values.firstWhere(
      (station) => station.name == name,
      orElse: () => null as MetroStation,
    );
  }

  static List<MetroStation> getAllStations() {
    return _stations.values.toList();
  }

  static MetroStation? getStationById(String id) {
    return _stations[id];
  }

  static List<MetroStation> searchStations(String query) {
    final lowerQuery = query.toLowerCase();
    return _stations.values
        .where((station) => station.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static List<MetroStation> getTransferStations() {
    return _stations.values
        .where((station) => station.isTransferStation())
        .toList();
  }

  static List<MetroStation> getStationsByLine(MetroLineType line) {
    return _stations.values
        .where((station) => station.hasLine(line))
        .toList();
  }
}
