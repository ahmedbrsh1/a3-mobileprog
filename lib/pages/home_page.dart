import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'details_page.dart';
import 'favorites_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  // Trigger weather search for entered city
  void _searchWeather() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    final provider = Provider.of<WeatherProvider>(context, listen: false);
    await provider.fetchWeather(_controller.text);

    if (context.mounted && provider.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailsPage()),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to fetch weather')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Weather Checker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Updated modern purple-blue gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main weather icon
              const Icon(Icons.cloud_queue_rounded, size: 120, color: Colors.white70),
              const SizedBox(height: 20),
              
              const Text(
                "Discover Weather",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 35),

              // Search bar container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type city name (e.g., London)',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF6A11CB)),
                      onPressed: _searchWeather,
                    ),
                  ),
                  onSubmitted: (_) => _searchWeather(),
                ),
              ),

              // Show loading indicator when fetching weather
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
