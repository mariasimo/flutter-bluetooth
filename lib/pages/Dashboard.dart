import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'SelectBondedDevicePage.dart';
import 'DetailPage.dart';
import '../theme/theme.dart' as Theme;
import '../components/EmptyCard.dart';
import '../components/DeviceCard.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice _selectedDevice;
  bool _hasSelectedDevice = false;

  @override
  void initState() {
    super.initState();

    print(_selectedDevice);

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {});

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  void seePairedDevices() async {
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SelectBondedDevicePage(checkAvailability: false);
        },
      ),
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      // _deviceDetail(context, selectedDevice);
      setState(() {
        _selectedDevice = selectedDevice;
        _hasSelectedDevice = true;
      });
    } else {
      print('Connect -> no device selected');
    }
  }

  void handleBTEnablement(bool value) {
    // Do the request and update with the true value then
    future() async {
      // async lambda seems to not working
      if (value)
        await FlutterBluetoothSerial.instance.requestEnable();
      else
        await FlutterBluetoothSerial.instance.requestDisable();
    }

    future().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.BBColors.grey[50],
      appBar: AppBar(
        backgroundColor: Theme.BBColors.grey[50],
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Dashboard',
                  style: Theme.BBThemeData.textTheme.headline1,
                ),
                padding: EdgeInsets.only(bottom: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _hasSelectedDevice
                    ? new DeviceCard(selectedDevice: _selectedDevice)
                    : new EmptyCard(handleButtonPress: seePairedDevices),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Ajustes Bluetooth",
                  style: Theme.BBThemeData.textTheme.headline3,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.BBColors.grey[100])),
                elevation: 0,
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: SwitchListTile(
                    title: _bluetoothState.isEnabled
                        ? Text(
                            'Activado',
                            style: Theme.BBThemeData.textTheme.subtitle2
                                .copyWith(color: Theme.BBColors.grey[300]),
                          )
                        : Text('Desactivado',
                            style: Theme.BBThemeData.textTheme.subtitle2
                                .copyWith(color: Theme.BBColors.grey[300])),
                    value: _bluetoothState.isEnabled,
                    onChanged: handleBTEnablement,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: FlutterBluetoothSerial.instance.openSettings,
                      label: Text('Vincular dispositivos'),
                      icon: Icon(
                        Icons.search,
                        size: 24,
                      ),
                      style: TextButton.styleFrom(
                        primary: Theme.BBThemeData.primaryColor,
                        backgroundColor: Theme.BBColors.blue[100],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deviceDetail(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailPage(server: server);
        },
      ),
    );
  }
}
