import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    blockConfig myConfigs = new blockConfig();

    return MaterialApp(
      home: Scaffold(
        appBar: swanAppBar(),
        body: Column(
          children: [
            Expanded(child: myConfigs.First_config()),
            Expanded(child: myConfigs.Second_config()),
            Expanded(child: myConfigs.Third_config())
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget swanAppBar() {
    const String name = 'Swan USA';
    const int defaultColor = 0xEEA4DEEA;
    return AppBar(
      title: const Text(name),
      backgroundColor: const Color(defaultColor),
    );
  }
}

class blockConfig {
//config one
  Column First_config() {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Expanded(child: test('Filter 1', Color(0xB9C2FF28))),
                Expanded(child: test('Filter 2', Color(0xB9C2FF28))),
                Expanded(child: test('Filter 3', Color(0xB9C2FF28)))
              ],
            )),
            Expanded(child: test("beverage Info", Color(0xFF64FFAC)))
          ],
        ))
      ],
    );
  }

  Row Second_config() {
    return Row(
      children: [
        Expanded(child: test('data loader', Color(0xFFFFFFFF))),
        Expanded(child: test('bottle power', Color(0xF1FFE167)))
      ],
    );
  }

  Row Third_config() {
    return Row(children: [
      Expanded(child: test('information', Color.fromARGB(255, 30, 169, 255)))
    ]);
  }

  PreferredSizeWidget test(String name, Color color) {
    return AppBar(
      title: Text(name),
      backgroundColor: color,
    );
  }
}
