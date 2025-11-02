import 'package:flutter/material.dart';
import '../models/metro_station.dart';
import '../models/departure.dart';
import '../models/metro_line.dart';
import '../services/vienna_api_service.dart';
import '../widgets/departure_card.dart';
import '../widgets/metro_line_badge.dart';

class LiveDeparturesScreen extends StatefulWidget {
  final MetroStation station;

  const LiveDeparturesScreen({
    super.key,
    required this.station,
  });

  @override
  State<LiveDeparturesScreen> createState() => _LiveDeparturesScreenState();
}

class _LiveDeparturesScreenState extends State<LiveDeparturesScreen> {
  List<Departure> _departures = [];
  bool _isLoading = false;
  String? _error;
  MetroLineType? _selectedLine;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadDepartures();
  }

  Future<void> _loadDepartures({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final departures = await ViennaApiService.getDepartures(
        widget.station.name,
        line: _selectedLine,
        forceRefresh: forceRefresh,
      );

      setState(() {
        _departures = departures;
        _isLoading = false;
        _lastUpdate = DateTime.now();
      });
    } on ApiRateLimitException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load departures';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_lastUpdate != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  _getLastUpdateText(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
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
                Row(
                  children: [
                    const Icon(Icons.directions_transit, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Live Departures',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _isLoading ? null : () => _loadDepartures(forceRefresh: true),
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', _selectedLine == null, () {
                        setState(() {
                          _selectedLine = null;
                        });
                        _loadDepartures();
                      }),
                      ...widget.station.lines.map((line) {
                        return _buildFilterChip(
                          MetroLine.getLineName(line),
                          _selectedLine == line,
                          () {
                            setState(() {
                              _selectedLine = line;
                            });
                            _loadDepartures();
                          },
                          color: MetroLine.getLineColor(line),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _departures.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading departures...'),
          ],
        ),
      );
    }

    if (_error != null && _departures.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _loadDepartures(forceRefresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_departures.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No departures available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadDepartures(forceRefresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _departures.length,
        itemBuilder: (context, index) {
          return DepartureCard(departure: _departures[index]);
        },
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: color?.withOpacity(0.1),
        selectedColor: color ?? Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
      ),
    );
  }

  String _getLastUpdateText() {
    if (_lastUpdate == null) return '';
    
    final difference = DateTime.now().difference(_lastUpdate!);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    }
    return '${difference.inMinutes}m ago';
  }
}
