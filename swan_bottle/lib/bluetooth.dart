// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'user.dart';

BluetoothDevice? _connectedDevice;
ScanResult? _connectedScan;
User user = User();

class Bluetooth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Bluetooth();
}

class _Bluetooth extends State<Bluetooth> {
  //variables
  List<ScanResult> devices = [];
  String? remoteId;

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.info, color: false);
    //set up to turn on bluetooth and to start initial scan
    turnOnBluetooth();
    scan();
    // optional
    FlutterBluePlus.logs.listen((String s) {
      print("BOOT-UP: $s"); // rm
    });
  }

  void log(String s) {
    FlutterBluePlus.log("INFO: $s");
  }

  void err(String s) {
    FlutterBluePlus.log("ERR: $s");
  }

  Future<void> sendConf(BluetoothDevice device) async {
    print("entered sendConf");
    log(
      "Device (${device.advName}) connection status is ${device.isConnected}",
    );
  }

  //returns:
  //    -true: if bluetooth is turned on
  //    -false: if bluetooth is not turned on
  Future<bool> turnOnBluetooth() async {
    //check dependencies
    if (await FlutterBluePlus.isSupported == false) {
      err("Bluetooth not supported.");
      return false;
    }

    await FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state != BluetoothAdapterState.on) {
        Platform.isAndroid
            ? FlutterBluePlus.turnOn()
            : err("Bluetooth needs to be turned on");
      }
    });
    return true;
  }

  Future<void> scan() async {
    // change later to scan for specific devices
    devices?.clear();
    if (await turnOnBluetooth()) {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 1));
      var sub = await FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
          var r = results.last;
          setState(() {
            if ((r.advertisementData.advName.contains("berG10") ||
                    r.advertisementData.advName.contains("SWAN-USA")) &&
                !devices.contains(r)) {
              devices.add(r);
            }
          });
        }
      });
    }
    log("${devices.length}");
  }

  Future<bool> connectDevice(BluetoothDevice device) async {
    try {
      device.connect(autoConnect: true);
      log("connecting to device ${device.advName}");
      setState(() {
        _connectedDevice = device;
        // user.msg = user;
        // chk if wrk
      });
      _connectedDevice!.connect(autoConnect: true, mtu: null);
      await device.connectionState
          .where((val) => val == BluetoothConnectionState.connected)
          .first;
      sendConf(device);
    } catch (e) {
      err("failed to connect to device ${device.advName}");
      setState(() {
        _connectedDevice = null;
      });
    }
    //get connected to GATT
    user.bluetoothDevice(device);
    List<BluetoothService> services =
        await FlutterBluePlus.connectedDevices.first.discoverServices();
    BluetoothService _service;
    BluetoothCharacteristic _character;
    for (BluetoothService service in services) {
      print("service uuid ${service.uuid}\n");
      if (service.uuid ==
          Guid.fromString("4fafc201-1fb5-459e-8fcc-c5c9c331914b")) {
        print("yay 4fafc201-1fb5-459e-8fcc-c5c9c331914b was found");
        _service = service;
        user.bluetoothService(_service);
      }
      for (BluetoothCharacteristic c in service.characteristics) {
        print("\t\tCharacteristic ${c.uuid} ${c.descriptors}\n");
        if (c.uuid == Guid.fromString("beb5483e-36e1-4688-b7f5-ea07361b26a8")) {
          print("yay beb5483e-36e1-4688-b7f5-ea07361b26a8 was found");
          _character = c;
          user.bluetoothCharacteristic(_character);
        }
      }
      print("\n\n");
    }

    return device.isConnected;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Devices", selectionColor: Color(0xFF000000)),
        backgroundColor: Color(0xFF2D9FFC),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await scan();
              setState(() async {
                scan();
                if (_connectedScan != null &&
                    !devices.contains(_connectedScan)) {
                  devices.add(_connectedScan!);
                }
              });
            },
            child: Text("refresh"),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: (_connectedScan != null) ? devices.length : devices.length,
        itemBuilder: (context, index) {
          if (_connectedScan != null && !devices.contains(_connectedScan))
            devices.add(_connectedScan!);
          return ListTile(
            title: Text("${devices[index].device.advName}"),

            trailing:
                (_connectedDevice == devices[index].device)
                    ? Text("Un-pair")
                    : Text("Connect"),
            tileColor:
                (_connectedDevice == devices[index].device)
                    ? Color(0xFF7300FF)
                    : Color(0xFFFFFFFF),
            onTap: () async {
              try {
                if (devices[index].device == _connectedDevice) {
                  //disconnecting
                  setState(() {
                    _connectedDevice = null;
                    _connectedScan = null;
                  });
                  await FlutterBluePlus.connectedDevices.first.disconnect();
                } else {
                  if (!await connectDevice(devices[index].device)) {
                    throw Exception();
                  } else {
                    setState(() {
                      _connectedScan = devices[index];
                    });
                    log("device connected successfully");
                  }
                }
              } catch (e) {
                err("failed to connect to ${devices[index].device.advName}");
              }
            },
          );
        },
      ),
    );
  }
}
