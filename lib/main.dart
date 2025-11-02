import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/metro_data.dart';

void main() {
  MetroData.initialize();
  runApp(const ViennaMetroApp());
}

class ViennaMetroApp extends StatelessWidget {
  const ViennaMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vienna Metro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
