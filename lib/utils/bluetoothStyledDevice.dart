import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:core';

class BluetoothStyledDevice extends BluetoothDevice {
  BluetoothDevice values;
  List<Color> colorCombo;
  int iconNumber;
  BluetoothStyledDevice({this.values, this.colorCombo, this.iconNumber});
}
