import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  bool _isCelsius = true;
  List<String> _favorites = [];

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCelsius => _isCelsius;
  List<String> get favorites => _favorites;

  WeatherProvider() {
    _loadPreferences();
  }

  // Fetch Weather
  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _apiService.getWeather(city);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle Units
  void toggleUnit() {
    _isCelsius = !_isCelsius;
    _savePreferences();
    notifyListeners();
  }

  // Favorites Management
  void toggleFavorite(String city) {
    if (_favorites.contains(city)) {
      _favorites.remove(city);
    } else {
      _favorites.add(city);
    }
    _savePreferences();
    notifyListeners();
  }

  bool isFavorite(String city) {
    return _favorites.contains(city);
  }

  // Persistence
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isCelsius = prefs.getBool('isCelsius') ?? true;
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCelsius', _isCelsius);
    prefs.setStringList('favorites', _favorites);
  }
}