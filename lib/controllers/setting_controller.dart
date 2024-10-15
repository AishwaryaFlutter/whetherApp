import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final temperatureUnit = 'C'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    temperatureUnit.value = prefs.getString('temperatureUnit') ?? 'C';
  }

  Future<void> setTemperatureUnit(String unit) async {
    temperatureUnit.value = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperatureUnit', unit);
  }
}