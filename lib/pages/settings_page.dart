import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: ListView(
            children: [
              // Toggle between Celsius and Fahrenheit
              SwitchListTile(
                title: const Text('Metric Units (°C)'),
                subtitle: Text(provider.isCelsius ? 'Currently: Celsius' : 'Currently: Fahrenheit'),
                value: provider.isCelsius,
                activeColor: Colors.teal,
                onChanged: (value) => provider.toggleUnit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
