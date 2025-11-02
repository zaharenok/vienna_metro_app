import 'metro_line.dart';

class MetroStation {
  final String id;
  final String name;
  final List<MetroLineType> lines;
  final Map<String, int> connections;

  MetroStation({
    required this.id,
    required this.name,
    required this.lines,
    this.connections = const {},
  });

  bool isTransferStation() => lines.length > 1;

  bool hasLine(MetroLineType line) => lines.contains(line);
}
