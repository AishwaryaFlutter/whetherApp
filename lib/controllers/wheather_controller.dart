import 'package:get/get.dart';

import '../model/wheather_model.dart';
import 'whether_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  final currentWeather = Rx<Weather?>(null);
  final forecast = <Weather>[].obs;
  final recentSearches = <String>[].obs;
  final isLoading = false.obs;
  final currentCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeather('London'); 
  }

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    try {
      final weather = await _weatherService.getCurrentWeather(city);
      currentWeather.value = weather;
      forecast.value = await _weatherService.getForecast(city);
      currentCity.value = city;
      if (!recentSearches.contains(city)) {
        recentSearches.insert(0, city);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather data for $city');
    } finally {
      isLoading.value = false;
    }
  }

  String getWeatherIcon(String description) {
    // You can expand this method to return appropriate weather icons
    if (description.contains('clear')) {
      return '☀️';
    } else if (description.contains('cloud')) {
      return '☁️';
    } else if (description.contains('rain')) {
      return '🌧️';
    } else {
      return '❓';
    }
  }
}