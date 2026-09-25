import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/weather_controller.dart';

class WeatherView extends StatelessWidget {
  WeatherView({super.key});

  final WeatherController controller = Get.put(WeatherController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              if (controller.weather.value != null) {
                controller.fetchWeather(controller.weather.value!.cityName);
              } else {
                controller.fetchWeather('Ahmedabad');
              }
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search City',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      controller.fetchWeather(searchController.text.trim());
                      searchController.clear();
                    }
                  },
                  icon: Icon(Icons.search),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.fetchWeather(value.trim());
                  searchController.clear();
                }
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final weather = controller.weather.value;
                if (weather == null) {
                  return const Center(
                    child: Text('Search for a city to view weather.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.fetchWeather(weather.cityName);
                  },
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          '${weather.temperature}°C',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w300,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.air,
                                  color: Colors.blue,
                                ),
                                title: const Text('Wind Speed'),
                                trailing: Text(
                                  "${weather.windSpeed} km/h",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.code, color: Colors.blue),
                                title: Text('Weather Condition Code'),
                                trailing: Text(
                                  "${weather.weatherCode}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
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
