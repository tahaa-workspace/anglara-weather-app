import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/weather_controller.dart';

class WeatherView extends StatelessWidget {
  WeatherView({super.key});

  final WeatherController controller = Get.put(WeatherController());
  final TextEditingController searchController = TextEditingController();

  void _searchCity() {
    final city = searchController.text.trim();
    if (city.isNotEmpty) {
      controller.fetchWeather(city);
      searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.isRefreshing.value
                  ? null
                  : controller.refreshWeather,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchCity(),
              decoration: InputDecoration(
                labelText: 'Search City',
                hintText: 'e.g. Vadodara',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _searchCity,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.fetchCurrentLocationWeather,
                icon: const Icon(Icons.my_location),
                label: Obx(
                  () => Text(
                    controller.isGettingLocation.value
                        ? 'Getting Location...'
                        : 'Use Current Location',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final weather = controller.weather.value;

                if (controller.isLoading.value && weather == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (weather == null) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value.isEmpty
                          ? 'Search for a city to view weather.'
                          : controller.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshWeather,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (controller.errorMessage.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      if (controller.isRefreshing.value)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        weather.conditionIcon,
                        size: 90,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.condition,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        weather.temperature.toStringAsFixed(1) + '°C',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.air),
                              title: const Text('Wind Speed'),
                              trailing: Text(
                                weather.windSpeed.toStringAsFixed(1) + ' km/h',
                              ),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.cloud),
                              title: const Text('Weather Condition'),
                              trailing: Text(weather.condition),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
