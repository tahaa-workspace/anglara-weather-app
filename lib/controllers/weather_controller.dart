import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/location_service.dart';
import 'package:weather_app/data/services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isGettingLocation = false.obs;
  final weather = Rxn<WeatherModel>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeather('Ahmedabad');
  }

  Future<void> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;

    final hasExistingWeather = weather.value != null;

    if (hasExistingWeather) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }

    errorMessage.value = '';

    try {
      final result = await _weatherService.fetchWeather(cityName.trim());
      weather.value = result;
    } catch (e) {
      errorMessage.value = _getUserMessage(e);
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshWeather() async {
    final currentWeather = weather.value;

    if (currentWeather == null) {
      await fetchWeather('Ahmedabad');
      return;
    }

    await fetchWeather(currentWeather.cityName);
  }

  Future<void> fetchCurrentLocationWeather() async {
    try {
      errorMessage.value = '';
      isGettingLocation.value = true;

      final position = await _locationService.getCurrentPosition();

      final result = await _weatherService.fetchWeatherByCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: 'Current Location',
      );

      weather.value = result;
    } catch (e) {
      errorMessage.value = _getUserMessage(e);
    } finally {
      isGettingLocation.value = false;
    }
  }

  String _getUserMessage(Object error) {
    if (error is WeatherServiceException) {
      return error.message;
    }

    if (error is LocationServiceException) {
      return error.message;
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Request timed out. Please try again.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network.';
      }

      if (error.response?.statusCode == 429) {
        return 'Too many requests. Please try again later.';
      }

      return 'Unable to update weather. Please try again.';
    }

    return 'Unable to update weather. Please try again.';
  }
}
