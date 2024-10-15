import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

import '../controllers/wheather_controller.dart';
import 'setting_screen.dart';
import 'wheather_screen.dart';

class HomeScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();
  final places = GoogleMapsPlaces(apiKey: 'AIzaSyDhVZ0H87v4uY7itBdBrxcDfGX3tiDkUnM');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Weather Forecast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Get.to(() => SettingsScreen()),
          ),
        ],
      ),
      body: Stack(
        children: [
          WeatherBg(
            weatherType: WeatherType.sunnyNight,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Obx(() {
            if (weatherController.isLoading.value) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            }
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Autocomplete<Prediction>(
                          optionsBuilder: (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text == '') {
                              return const Iterable<Prediction>.empty();
                            }
                            PlacesAutocompleteResponse response = await places.autocomplete(
                              textEditingValue.text,
                              types: ['(cities)'],
                            );
                            return response.predictions;
                          },
                          onSelected: (Prediction prediction) {
                            weatherController.fetchWeather(prediction.description!);
                          },
                          displayStringForOption: (Prediction option) => option.description!,
                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                              FocusNode focusNode, VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: 'Search for a city',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.search, color: Colors.blue),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (String value) {
                                onFieldSubmitted();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: weatherController.recentSearches.length,
                      itemBuilder: (context, index) {
                        final city = weatherController.recentSearches[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.white.withOpacity(0.7),
                          child: ListTile(
                            leading: Icon(Icons.location_city, color: Colors.blue),
                            title: Text(city, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            trailing: Icon(Icons.chevron_right, color: Colors.blue),
                            onTap: () {
                              weatherController.fetchWeather(city);
                              Get.to(() => WeatherDetailsScreen());
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}