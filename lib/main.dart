import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/setting_controller.dart';
import 'controllers/wheather_controller.dart';
import 'screen/home_screen.dart';

void main() {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize controllers
  Get.put(WeatherController());
  Get.put(SettingsController());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather Forecast App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}