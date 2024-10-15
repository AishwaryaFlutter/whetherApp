import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/setting_controller.dart';
import '../controllers/wheather_controller.dart';
import '../model/wheather_model.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      appBar: AppBar(
        title: Obx(() => Text('Weather in ${weatherController.currentCity.value}')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final weather = weatherController.currentWeather.value;
        if (weather == null) {
          return Center(child: Text('No weather data available'));
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade300, Colors.blue.shade800],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentWeather(weather),
                    SizedBox(height: 20),
                    Text('5-Day Forecast', 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    _buildForecast(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°${settingsController.temperatureUnit.value}',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Text(weather.description, style: TextStyle(fontSize: 24)),
                  ],
                ),
                Text(
                  weatherController.getWeatherIcon(weather.description),
                  style: TextStyle(fontSize: 64),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Updated: ${DateFormat('MMM d, y HH:mm').format(DateTime.now())}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            _buildWeatherInfo('Humidity', '${weather.humidity}%'),
            _buildWeatherInfo('Wind Speed', '${weather.windSpeed} m/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildForecast() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherController.forecast.length,
        itemBuilder: (context, index) {
          final day = weatherController.forecast[index];
          return Card(
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E, HH:mm').format(DateTime.parse(day.date!)),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    weatherController.getWeatherIcon(day.description),
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${day.temperature.toStringAsFixed(1)}°${settingsController.temperatureUnit.value}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    day.description,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}