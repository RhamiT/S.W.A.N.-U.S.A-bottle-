import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'my_app.dart';
import 'widget.dart';

void main() {
  // TODO: add a store for the user widgets
  var app = MyAPP(3);
  runApp(MaterialApp(home: app));
}
