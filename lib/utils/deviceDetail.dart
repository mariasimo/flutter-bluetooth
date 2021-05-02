import 'package:flutter/material.dart';
import 'package:bluetooth_bridge/pages/DetailPage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceDetail {
  BuildContext context;
  BluetoothDevice server;

  DeviceDetail({this.context, this.server});

  void goToPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailPage(server: server);
        },
      ),
    );
  }
}
