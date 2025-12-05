import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config/config.dart'; // import the API key

class ApiService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&units=metric&appid=${Config.apiKey}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Network error or invalid city');
    }
  }
}
