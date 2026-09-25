import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();

  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      final geoResponse = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {'name': cityName, 'count': 1},
      );
      print("geoResponse = ${geoResponse.data}");

      if (geoResponse.data['results'] == null ||
          (geoResponse.data['results'] as List).isEmpty) {
        throw Exception('City Not Found');
      }

      final cityData = geoResponse.data['results'][0];
      final lat = cityData['latitude'];
      final lon = cityData['longitude'];
      final name = cityData['name'];

      final weatherResponse = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,weather_code,wind_speed_10m',
        },
      );
      print('weatherResponse = ${weatherResponse.data}');

      return WeatherModel.fromJson(weatherResponse.data, name);
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}
