//base packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'widgets.dart';
import 'loginPage.dart';
import 'user.dart';
import 'bluetooth.dart';
//internet packages
// import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

//aws packages
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_authenticator/amplify_authenticator.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
User user = User();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
  } catch (e) {
    // ignore: prefer_interpolation_to_compose_strings, avoid_print
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swan Bottle USA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Swan Bottle USA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyWidget swanWidget = MyWidget();
  LoginPage login = LoginPage();
  List? notifications = [];

  @override
  void initState() {
    super.initState();
    user.amplifyInit();
  }

  Widget mainHeader() {
    // use List tile to show each notification
    return Scaffold(
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
                      title: user.notifications!.elementAt(index),
                    );
                  },
                ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swan Bottle"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                if (value == "Login") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else if (value == "Logout") {
                  user.LogoutUsr();
                } else if (value == "Blutooth") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bluetooth()),
                  );
                }
              });
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Login',
                    child: Text('Login'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Logout',
                    child: Text('Logout'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Blutooth',
                    child: Text('Bluetooth'),
                  ),
                ],
          ),
        ],
      ),
      body: NotificationListener(
        onNotification: (notification) {
          setState(() {
            print("hello");
          });
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              child: swanWidget.mainHeader(),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 3),
            ),
            // Container(
            //   child: swanWidget.bvgInfo(),
            //   width: MediaQuery.of(context).size.width,
            //   height: (MediaQuery.of(context).size.height / 3),
            // ),
            Container(
              child: swanWidget.bvgLvl(),
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height / 3),
            ),
            Container(
              child: swanWidget.sugarConcentration(user.sugarConcentration!),
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height / 3),
            ),
            Container(
              child: swanWidget.bTest(),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 3),
            ),
          ],
        ),
      ),
    );
  }
}
