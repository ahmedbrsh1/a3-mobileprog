import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  // Convert timestamp to local time based on timezone
  String _formatTime(int timestamp, int timezoneOffset) {
    final utcTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    final localTime = utcTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(localTime);
  }

  // Determine background gradient based on temperature
  List<Color> _getBackgroundColors(double tempCelsius) {
    if (tempCelsius > 25) {
      return [Colors.orange.shade400, Colors.red.shade400];
    } else if (tempCelsius < 15) {
      return [Colors.blue.shade600, Colors.lightBlue.shade300];
    } else {
      return [Colors.cyan.shade400, Colors.indigo.shade400];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather;

    if (weather == null) return const Scaffold(body: Center(child: Text("No weather data")));

    double temp = weather.temperature;
    double feelsLike = weather.feelsLike;
    String unit = "°C";

    if (!provider.isCelsius) {
      temp = (temp * 9 / 5) + 32;
      feelsLike = (feelsLike * 9 / 5) + 32;
      unit = "°F";
    }

    final bgColors = _getBackgroundColors(weather.temperature);
    final isFavorite = provider.isFavorite(weather.cityName);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          weather.cityName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () => provider.toggleFavorite(weather.cityName),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Weather icon and main info
              Image.network(
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                height: 120,
              ),
              Text(
                '${temp.toStringAsFixed(0)}$unit',
                style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                weather.description.toUpperCase(),
                style: const TextStyle(fontSize: 20, color: Colors.white70, letterSpacing: 1.5),
              ),
              const SizedBox(height: 30),

              // Weather details section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
