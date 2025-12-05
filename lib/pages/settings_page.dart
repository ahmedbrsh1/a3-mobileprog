import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: const Text('Use Metric Units (°C)'),
                subtitle: Text(
                  provider.isCelsius
                      ? 'Current: Celsius'
                      : 'Current: Fahrenheit',
                ),
                value: provider.isCelsius,
                onChanged: (value) => provider.toggleUnit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
