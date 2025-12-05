import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  String _formatTime(int timestamp, int timezoneOffset) {
    final utcTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    final localTime = utcTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather;

    if (weather == null)
      return const Scaffold(body: Center(child: Text("No weather data")));

    double temp = weather.temperature;
    double feelsLike = weather.feelsLike;
    String unit = "°C";

    if (!provider.isCelsius) {
      temp = (temp * 9 / 5) + 32;
      feelsLike = (feelsLike * 9 / 5) + 32;
      unit = "°F";
    }

    final isFavorite = provider.isFavorite(weather.cityName);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(weather.cityName),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => provider.toggleFavorite(weather.cityName),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section: Weather icon + temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  '${temp.toStringAsFixed(0)}$unit',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                weather.description.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailTile(
                    Icons.thermostat,
                    "Feels Like",
                    "${feelsLike.toStringAsFixed(1)}$unit",
                  ),
                  _buildDetailTile(
                    Icons.water_drop,
                    "Humidity",
                    "${weather.humidity}%",
                  ),
                  _buildDetailTile(
                    Icons.air,
                    "Wind",
                    "${weather.windSpeed} m/s",
                  ),
                  _buildDetailTile(
                    Icons.wb_sunny_outlined,
                    "Sunrise",
                    _formatTime(weather.sunrise, weather.timezone),
                  ),
                  _buildDetailTile(
                    Icons.nightlight_round,
                    "Sunset",
                    _formatTime(weather.sunset, weather.timezone),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
