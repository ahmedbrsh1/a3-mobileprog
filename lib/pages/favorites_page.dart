import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Cities'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'You haven’t added any favorites yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final city = favorites[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      city,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    leading: const Icon(Icons.location_city, color: Colors.teal),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      // Fetch weather for selected city
                      await provider.fetchWeather(city);

                      // Navigate to details page if no error occurred
                      if (context.mounted && provider.error == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DetailsPage()),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
