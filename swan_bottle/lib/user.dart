// Resource:
//https://resonant-cement-f3c.notion.site/Implementing-Amazon-Cognito-Authentication-in-Flutter-Apps-using-AWS-Amplify-c95ff9d12ac1422f98b88f3f1dbce4ef

import 'dart:convert';
import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'aws-http.dart';
//bluetooth packages
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//internet packages
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
//aws packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

//User class:
//    Used to manage user Authentication and user data such as:
//      - Hydration goals
//      - Sugar goals
class User extends ChangeNotifier {
  // user var
  late String username;
  late String password;
  String? table; //used to hold url for drink table
  double? sugarConcentration = 0;
  String? timeRead = "none";
  double? waterLvl = 0; // 0-100 used to indicate bottles fullness
  double? drunk = 0; // in oz
  List? notifications = [" "];
  bool? update = false; // used to hold string notifications
  // bluetooth var
  BluetoothDevice? _connectedDevice;
  ScanResult? _connectedScan;
  BluetoothService? _service;
  BluetoothCharacteristic? _characteristic;
  String msg = "Bluetooth Data";
  bool newData = false;
  // aws var
  AuthSession? session;
  final auth = AmplifyAuthCognito();
  //storage var
  static const _storage = FlutterSecureStorage();
  //helper var
  static AWS_HTTP helper = AWS_HTTP();

  //creating a singleton
  User._internal();
  static final User _instance = User._internal();
  factory User({String? username, String? password}) {
    // Optionally, you can update properties on first creation or later
    if (username != null) _instance.username = username;
    if (password != null) _instance.password = password;

    return _instance;
  }

  // *************Auth/Login FUNCTIONS START HERE******************* \\
  //AWS init
  Future<void> amplifyInit() async {
    try {
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);

      await Amplify.configure(helper.config);
    } catch (e) {
      print('An error occurred configuring Amplify: $e');
    }

    print("amplify is configured = ${Amplify.isConfigured}");
  }

  // Login, Logout, register functions
  Future<bool> LoginUsr(String username, String password) async {
    print("attempting to login $username using $password");
    try {
      SignInResult result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      print("obtained results");
      if (result is CognitoSignInResult) {
        session = await Amplify.Auth.fetchAuthSession();
        //checking dynamicness rm later
        var tokenGrabber = session!.toJson();
        print(
          "keys: \n ${tokenGrabber.keys.toList().toString()}\n\nValues:\n${tokenGrabber.values.toList().toString()}",
        );
        //User info set
        this.username = username;
        this.password = password;
      } else {
        throw Exception("ERR_LoginUsr: user signin failed");
      }
      saveUser();
      print("Info has been saved");
      notifyListeners();
      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }

  Future<bool> LogoutUsr() async {
    try {
      final result = await Amplify.Auth.signOut();
      if (result is CognitoCompleteSignOut) {
        print("user is loged out");
        _storage.deleteAll();
        // clear running instance var
        this.username = "";
        this.password = "";
        session = null; // throws session out for security
        notifyListeners();
        return true;
      } else {
        throw Exception("sign-out failed");
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> registerUser(
    String username,
    String password,
    String email,
  ) async {
    try {
      SignUpResult results = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: {AuthUserAttributeKey.email: email},
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmUser(String username, String code) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );

      return true;
    } catch (e) {
      print("ERR: $e");
      return false;
    }
  }

  Future<void> resendConf(String user) async {
    Amplify.Auth.resendSignUpCode(username: user);
  }

  // storage functions
  Future<void> saveUser() async {
    await _storage.write(key: "username", value: username);
    await _storage.write(key: "password", value: password);
  }

  // load functions
  static Future<User?> loadUser() async {
    String? username = await _storage.read(key: 'username');
    String? password = await _storage.read(key: 'password');

    if (username == null || password == null) {
      return null;
    }

    User _instance = User(username: username, password: password);
    _instance.username = username;
    _instance.password = password;
    return _instance;
  }

  //**********************Bottle Functions Start Here***********************\\
  //TODO- Complete these functions
  //Initial bluetooth grab function
  Future<void> bluetoothRead() async {
    //check for msg
    if (_characteristic!.properties.read) {
      List<int> data = await _characteristic!.read();
      msg = String.fromCharCodes(data);
      newData = true;
    }

    if (msg == "Bluetooth Data") {
      // no new data found good to exit after checking timer for drink notification
      return;
    }
    //got data
    Map<String, dynamic> data = jsonDecode(msg);

    // parse data from json formate to proper places
    if (data.containsKey("percentage")) {
      // more to come soon
      print("json read percent: $data['percentage']");
      await waterRead(data['percentage']);
    }
    if (data.containsKey("concentration")) {
      //photonics
      await sugar(data['concentration']);
    }
    update = true;
    //clear msg after compleation
    // msg = "Bluetooth Data";
    notifyListeners();
    print(notifications); // rm
    return;
  }

  Future<void> bluetoothDevice(BluetoothDevice device) async {
    _connectedDevice = device;
    notifyListeners();
  }

  Future<void> bluetoothService(BluetoothService service) async {
    _service = service;
    notifyListeners();
  }

  Future<void> bluetoothCharacteristic(
    BluetoothCharacteristic character,
  ) async {
    _characteristic = character;
    notifyListeners();
  }

  // Photonics read for sugar concentration
  Future<void> sugar(double data) async {
    DateTime lastGrabed = DateTime.now();
    timeRead =
        "Last read:\t${lastGrabed.year}-${lastGrabed.month}-${lastGrabed.day} ${lastGrabed.hour}:${lastGrabed.minute}";
    this.sugarConcentration = data;
    update = true;
    if (notifications!.contains("Sugar concentration for beverage is") &&
        newData == true) {
      notifications!.remove(
        notifications!.contains("Sugar concentration for beverage is"),
      );
    }
    notifications!.add(
      "Sugar concentration for beverage is $sugarConcentration",
    );
    notifyListeners();
    newData = false;
  }

  // EE read for water Level
  Future<void> waterRead(double percent) async {
    print("WaterLvl: $percent");
    this.waterLvl = percent;
    this.drunk = (38 * (percent / 100)) + drunk!;
    if (drunk! >= 150 && newData == true) {
      notifications!.remove("Congrats buddy your well hydrated :)");
      notifications!.add("slow down their bud don't want you to drown!!");
    } else if (drunk! >= 64 && newData == true) {
      notifications!.remove("Almost their you got this");
      notifications!.add("Congrats buddy your well hydrated :)");
    } else if (drunk! >= 24 && newData == true) {
      notifications!.remove("Look at you ur making progress");
      notifications!.add("Almost their you got this");
    } else if (drunk! >= 16 && newData == true) {
      notifications!.remove("Time to start drinking for the day");
      notifications!.add("Look at you ur making progress");
    } else {
      notifications!.add("Time to start drinking for the day");
    }
    update = true;
    notifyListeners();
  }

  //**********************Helper Functions Start Here***********************\\
  BluetoothDevice? get device => this._connectedDevice;
  BluetoothService? get service => this._service;
  BluetoothCharacteristic? get character => this._characteristic;
}
