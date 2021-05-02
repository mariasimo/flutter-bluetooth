import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../BluetoothDeviceListEntry.dart';
import 'package:bluetooth_bridge/constants.dart';
import '../theme/theme.dart' as Theme;

class SelectBondedDevicePage extends StatefulWidget {
  const SelectBondedDevicePage();
  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  int rssi;

  _DeviceWithAvailability(this.device, [this.rssi]);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = [];
  bool _isDiscovering = false;
  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map((device) => _DeviceWithAvailability(device))
            .toList();
      });
    });
  }

  void _restartDiscovery() {
    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      print("bondedDevices");
      print(bondedDevices);
      setState(() {
        devices = bondedDevices
            .map((device) => _DeviceWithAvailability(device))
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
        .asMap()
        .entries
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.value.device,
              rssi: _device.value.rssi,
              onTap: () {
                Navigator.of(context).pop(_device.value.device);
              },
              colorCombo: colorsList[_device.key],
              iconNumber: _device.key + 1,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seleccionar dispositivo',
                      style: Theme.BBThemeData.textTheme.headline2,
                    ),
                    _isDiscovering
                        ? FittedBox(
                            child: Container(
                              margin: new EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.replay),
                            onPressed: _restartDiscovery,
                          )
                  ],
                ),
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
