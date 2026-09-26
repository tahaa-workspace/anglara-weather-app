import 'package:flutter/material.dart';

class WeatherModel {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current'] as Map<String, dynamic>;

    return WeatherModel(
      cityName: city,
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  String get condition {
    if (weatherCode == 0) return 'Clear Sky';
    if (weatherCode == 1 || weatherCode == 2) return 'Partly Cloudy';
    if (weatherCode == 3) return 'Overcast';
    if (weatherCode == 45 || weatherCode == 48) return 'Fog';
    if (weatherCode >= 51 && weatherCode <= 57) return 'Drizzle';
    if (weatherCode >= 61 && weatherCode <= 67) return 'Rain';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snow';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Rain Showers';
    if (weatherCode == 85 || weatherCode == 86) return 'Snow Showers';
    if (weatherCode == 95) return 'Thunderstorm';
    if (weatherCode == 96 || weatherCode == 99) {
      return 'Thunderstorm with Hail';
    }
    return 'Unknown';
  }

  IconData get conditionIcon {
    if (weatherCode == 0) return Icons.wb_sunny_rounded;
    if (weatherCode <= 3) return Icons.cloud_queue_rounded;
    if (weatherCode == 45 || weatherCode == 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 57) return Icons.grain;
    if (weatherCode >= 61 && weatherCode <= 67) {
      return Icons.water_drop_rounded;
    }
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit_rounded;
    if (weatherCode >= 80 && weatherCode <= 82) {
      return Icons.umbrella_rounded;
    }
    if (weatherCode == 85 || weatherCode == 86) return Icons.ac_unit_rounded;
    if (weatherCode >= 95) return Icons.thunderstorm_rounded;
    return Icons.cloud_rounded;
  }
}
