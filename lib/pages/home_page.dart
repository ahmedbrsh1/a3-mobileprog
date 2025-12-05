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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.error ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Weather Checker'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Large icon at top left
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.cloud,
                size: 120,
                color: Colors.blueAccent.shade100,
              ),
            ),
            const SizedBox(height: 20),
            // Search input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
            const SizedBox(height: 20),
            // Loading indicator
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
