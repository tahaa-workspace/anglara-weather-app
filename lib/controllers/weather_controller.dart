import 'package:get/get.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();

  var isLoading = false.obs;
  var weather = Rxn<WeatherModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchWeather('Ahmedabad');
  }

  void fetchWeather(String cityName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _weatherService.fetchWeather(cityName);
      weather.value = result;
    } catch (e) {
      errorMessage.value = 'Could not fetch weather';
    } finally {
      isLoading.value = false;
    }
  }
}
