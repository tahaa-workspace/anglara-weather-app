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
    return WeatherModel(
      cityName: city,
      temperature: json['current']['temperature_2m'] ?? 0.0,
      windSpeed: json['current']['wind_speed_10m'] ?? 0.0,
      weatherCode: json['current']['weather_code'] ?? 0,
    );
  }
}
