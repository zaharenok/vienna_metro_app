import 'package:flutter/material.dart';
import '../services/metro_data.dart';
import '../services/location_service.dart';
import 'route_planner_screen.dart';
import 'stations_list_screen.dart';
import 'map_screen.dart';
import 'live_departures_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.subway,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vienna Metro',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Navigate Vienna\'s metro system',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        context,
                        icon: Icons.near_me,
                        title: 'Nearest Station',
                        subtitle: 'Find stations near you with live times',
                        color: Colors.purple,
                        onTap: () async {
                          final nearest = await LocationService.findNearestStation();
                          if (nearest != null && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveDeparturesScreen(
                                  station: nearest.station,
                                ),
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Location permission required'),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        context,
                        icon: Icons.map_outlined,
                        title: 'Interactive Map',
                        subtitle: 'Live map with your GPS location',
                        color: Colors.teal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InteractiveMapScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        context,
                        icon: Icons.map,
                        title: 'Metro Map',
                        subtitle: 'View the complete metro network',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MetroMapScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        context,
                        icon: Icons.directions,
                        title: 'Plan Route',
                        subtitle: 'Find the best way to your destination',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoutePlannerScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        context,
                        icon: Icons.list,
                        title: 'All Stations',
                        subtitle: 'Browse ${MetroData.getAllStations().length} stations',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StationsListScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MetroMapScreen extends StatelessWidget {
  const MetroMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metro Map'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.asset(
            'assets/images/largemap-s-wien-h.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
