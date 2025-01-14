import "main.dart";

import "widget.dart";
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

class MyAPP extends StatelessWidget {
  var appWidgets = List<List<myWidget>>; // row <= 3, Col <= 2
  var numSections;
  var SwanWidgets = myWidget();

  // constructor
  MyAPP(this.numSections);
  MyAPP.origin() : numSections = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(child: SwanWidgets.battery(80, "1 hr\n18 min")),
            Expanded(
                child: SwanWidgets.nutrition(
                    "Calories:\t\tvitamins\n25\t\tA,B,C\n\nServings:\n4")),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: SwanWidgets.beverageLvl(
                    "Day:\n20 oz\n\nWeek:\n360 oz", 80)),
            Expanded(
                child: SwanWidgets.Graph(
                    "https://imgs.search.brave.com/PEiB9gmkJtp2XKInUG8csVkc7iOxQ7nc8Xadu58-cdU/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAzLzI2Lzc3Lzk3/LzM2MF9GXzMyNjc3/OTc3Nl92VFdGU2hr/czV3SGxaSjNUS0Jq/bk85RkhWM1NCNUZQ/ci5qcGc")),
          ],
        )),
        Expanded(child: SwanWidgets.drinkData("")),
        // Expanded(child: SwanWidgets.loadWidget(0))
      ],
    );
  }

  // add functions for IOS and android devices
}
