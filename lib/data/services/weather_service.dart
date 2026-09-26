import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<WeatherModel> fetchWeather(String cityName) async {
    final geoResponse = await _dio.get(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: {
        'name': cityName,
        'count': 1,
      },
    );

    final results = geoResponse.data['results'];

    if (results == null || (results as List).isEmpty) {
      throw const WeatherServiceException('City not found');
    }

    final cityData = results[0] as Map<String, dynamic>;

    return fetchWeatherByCoordinates(
      latitude: (cityData['latitude'] as num).toDouble(),
      longitude: (cityData['longitude'] as num).toDouble(),
      cityName: cityData['name'] as String,
    );
  }

  Future<WeatherModel> fetchWeatherByCoordinates({
    required double latitude,
    required double longitude,
    required String cityName,
  }) async {
    final response = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,weather_code,wind_speed_10m',
      },
    );

    return WeatherModel.fromJson(response.data, cityName);
  }
}

class WeatherServiceException implements Exception {
  final String message;

  const WeatherServiceException(this.message);

  @override
  String toString() => message;
}
