import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whether/controllers/setting_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Obx(() => ListView(
        children: [
          ListTile(
            title: Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: settingsController.temperatureUnit.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsController.setTemperatureUnit(newValue);
                }
              },
              items: ['C', 'F'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      )),
    );
  }
}