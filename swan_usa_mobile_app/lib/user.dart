import 'dart:ffi';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

//classes
import "widget.dart";
import "bottle.dart";

class User {
//variables
  String? user;
  Uint8? layout;
  List<Uint16>? widgets;
  String? theme;

  //functions
  void add_widget(Uint16 w) {
    widgets?.add(w);
  }

  void remove_Widget(Uint16 w, Uint8 lvl) {
    widgets?.remove(w);
  }

  void update_Theme(String themeCode) {
    theme = themeCode;
  }
}
