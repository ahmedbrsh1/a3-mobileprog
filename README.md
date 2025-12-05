Got it! Here’s the entire README content in one single Markdown snippet that you can copy-paste directly into README.md:

# Weather Checker App

## App Description

Weather Checker is a Flutter mobile application that allows users to search for real-time weather information for cities worldwide. Users can view detailed weather data, manage favorite cities, and switch between metric (°C) and imperial (°F) units. The app uses the OpenWeatherMap API to fetch accurate weather data.

---

## Features

- Search for weather by city name
- View detailed weather information:
  - Temperature & feels like
  - Humidity
  - Wind speed
  - Sunrise and sunset times
- Mark cities as favorites for quick access
- Toggle between Celsius and Fahrenheit units
- Clean, modern UI with responsive design

---

## Setup Steps

1. Clone the repository:

```bash
git clone <https://github.com/ahmedbrsh1/a3-mobileprog>
cd <project-folder>
```

Install Flutter dependencies:

```bash
flutter pub get
```

Add your OpenWeatherMap API key:

Create a new file: lib/config/config.dart

```dart
class Config {
  static const String apiKey = 'YOUR_API_KEY_HERE';
}
```

Run the app:

```bash
flutter run
```

API Usage

The app uses the OpenWeatherMap API
to fetch weather data.

Base URL: https://api.openweathermap.org/data/2.5/weather

Query parameters:

appid: your API key

Example request:

https://api.openweathermap.org/data/2.5/weather?q=Cairo&appid=YOUR_API_KEY
