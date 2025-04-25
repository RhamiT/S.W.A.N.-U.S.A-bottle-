// ignore_for_file: await_only_futures, avoid_print

import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import 'user.dart';
import 'user.dart';

User user = User();
// used for bluetooth comms
final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

class MyWidget {
  // variables
  //******************************Debug apps widgets***********************************/
  Widget bTest() {
    if (user.device != null) {
      String msg;
      user.bluetoothRead();

      return zone(
        ListView(
          children: [
            Column(children: [Text("${user.device!.advName}")]),
            Column(children: [Text("servUUID:${user.service!.uuid}")]),
            Column(children: [Text("charUUID:${user.character!.uuid}")]),
            Column(children: [Text("${user.msg}")]),
          ],
        ),
      );
    }
    return zone(Center(child: Text("${user.msg}")));
  }

  //******************************Actual apps widgets***********************************/
  //HELPER FUNCTIONS
  //helps create initial zone for the widgets
  Widget zone(Widget data) {
    // creates outer boarder and filled with data which is passed from the function itself
    return Expanded(child: Card(child: Container(child: data)));
  }

  // APP WIDGET FUNCTIONS
  //Main header used to display notifications
  Widget mainHeader() {
    // use List tile to show each notification
    return zone(
      Scaffold(
        appBar: AppBar(
          title: Text("Notification Center"),
          backgroundColor: Color(0xEDE9E9D3),
          centerTitle: true,
        ),
        body: Card(
          child:
              (user.notifications!.isEmpty)
                  ? Text("no notifications")
                  : ListView.builder(
                    itemCount: user.notifications!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(user.notifications!.elementAt(index)),
                        onTap: () {
                          user.notifications!.remove(
                            user.notifications!.elementAt(index),
                          );
                        },
                      );
                    },
                  ),
        ),
      ),
    );
  }

  //Displays photonics sections data
  Widget sugarConcentration(double data) {
    // should sugar concetration from spectrometer alongside when it was grabbed
    DateTime lastGrabed = DateTime.now(); // may need to update
    int sugarConcentration = 0; // update later with json data
    return zone(
      Scaffold(
        appBar: AppBar(
          title: Text("sugar concentration reading"),
          backgroundColor: Color(0xEDE9E9D3),
          centerTitle: true,
        ),
        body: Card(
          child: Text(
            "Sugar Concentration:\t${user.sugarConcentration}\n\n\n${user.timeRead}",
          ),
        ),
      ),
    );
  }

  //Displays EE sections data
  Widget bvgLvl() {
    //Should show a bottle icon with filled area for level alongside number for how full it is
    user.bluetoothRead();
    double? data = user.waterLvl!;
    print("data: $data");
    print("bvgLvl data: $data"); //rm
    List<String> lvlIndicator = [
      "assets/images/BatteryFull.jpg",
      "assets/images/Battery3Quarters.jpg",
      "assets/images/BatteryHalf.jpg",
      "assets/images/BatteryQuarter.jpg",
    ]; // stores valid jpgs from image file
    String selectedImg;
    if (data >= 75.5) {
      selectedImg = lvlIndicator[0];
    } else if (data <= 75.4 && data >= 50.5) {
      selectedImg = lvlIndicator[1];
    } else if (data <= 50.4 && data >= 25.5) {
      selectedImg = lvlIndicator[2];
    } else {
      selectedImg = lvlIndicator[3];
    }
    return zone(
      Card(
        color: Color(0xFFFFFFFF),
        // height: 250,
        // width: 250,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Bottle"),
            backgroundColor: Color(0xEDE9E9D3),
            centerTitle: true,
          ),
          body: Row(
            children: [
              Expanded(child: Text("${data.toString()}%")),
              Expanded(child: Image.asset("$selectedImg", fit: BoxFit.contain)),
            ],
          ),
        ),
      ),
    );
  }

  //Displays table for user selected bvg

  Widget bvgInfo() {
    //Header should have a button to let user select from menu of already known drinks
    // the widget should then load url for aws bucket to show already gen tabled
    List<String> drinks = ["RedBull", "Monster", "Rockstar"];
    List<String> drinkTables = [
      "assets/images/RedBull.jpeg",
      "assets/images/Monster.png",
      "assets/images/Rockstar.jpg",
    ]; // switch latter to AWS S3
    List<DropdownMenuEntry<String>> validDrinks = [];
    String loadedImg = "";
    int i = 0;
    for (String drink in drinkTables) {
      validDrinks.add(DropdownMenuEntry(value: drink, label: drinks[i]));
      i++;
    }
    return zone(
      Card(
        child: Scaffold(
          appBar: AppBar(
            title: Text("beverage Information"),
            actions: [
              DropdownMenu(
                dropdownMenuEntries: validDrinks,
                onSelected: (value) => loadedImg = value!,
              ),
            ],
            backgroundColor: Color(0xEDE9E9D3),
            centerTitle: true,
          ),
          body: Image.asset("value", fit: BoxFit.contain),
        ),
      ),
    );
  }

  // Used to show time till next reading
  Widget nxtRead() {
    return Container();
  }
}
