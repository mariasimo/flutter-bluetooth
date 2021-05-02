import 'package:bluetooth_bridge/utils/bluetoothStyledDevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bluetooth_bridge/components/BluetoothDeviceListEntry.dart';
import 'package:bluetooth_bridge/constants.dart';
import 'package:bluetooth_bridge/theme/theme.dart' as Theme;
import 'package:bluetooth_bridge/components/PageHeader.dart';

class SelectBondedDevicePage extends StatefulWidget {
  const SelectBondedDevicePage();
  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  _SelectBondedDevicePage();
  List<BluetoothStyledDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _resetBondedDevicesList();
  }

  void _resetBondedDevicesList() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .asMap()
            .entries
            .map(
              (device) => BluetoothStyledDevice(
                  values: device.value,
                  colorCombo: colorsList[device.key],
                  iconNumber: device.key + 1),
            )
            .toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device,
              onTap: () {
                Navigator.of(context).pop(_device);
              },
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                pageTitle: "Seleccionar dispositivo",
                onPressed: _resetBondedDevicesList,
              ),
              Expanded(
                child: ListView(children: list),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Ajustes Bluetooth",
                  style: Theme.BBThemeData.textTheme.headline3,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: FlutterBluetoothSerial.instance.openSettings,
                      label: Text('Vincular dispositivos'),
                      icon: Icon(
                        Icons.bluetooth,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 100)
                ],
              ), // ListView(children: list)
            ],
          ),
        ),
      ),
    );
  }
}
