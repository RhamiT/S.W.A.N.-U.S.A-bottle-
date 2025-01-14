import 'dart:ffi';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

//classes

class Bottle {
  //variables
  Uint64? id;

  //function
  Uint64? get_id() {
    return id;
  }

  void set_id(Uint64 Id) {
    id = Id;
  }
}
