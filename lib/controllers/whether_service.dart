import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/wheather_model.dart';

class WeatherService {
  final String apiKey = '84920b5a03a7f86b1284599f100a47a8'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Weather>> getForecast(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      return list.map((item) => Weather.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}