import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: BluetoothApp()));
}

class BluetoothApp extends StatefulWidget {
  BluetoothApp({Key key}) : super(key: key);

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetoothInstance = FlutterBluetoothSerial.instance;
  BluetoothConnection connection; // Track connection with the remote device
  bool get isConnected =>
      connection != null && connection.isConnected; // still connected to BT
  bool isDisconnecting = false; // disconnection is in progress
  List<BluetoothDevice> devicesList = []; // var for storing the devices list
  int _deviceState;
  BluetoothDevice _device;

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetoothInstance.getBondedDevices();
    } on PlatformException {
      print("Error");
    }
    if (!mounted) return;
    setState(() => devicesList = devices);
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      return true;
    }
    await getPairedDevices();
    return false;
  }

  void _connect() async {
    if (_device == null) {
      // show('No device selected');
    } else {
      // If a device is selected from the
      // dropdown, then use it here
    }
  }

  @override
  void initState() {
    super.initState();

    enableBluetooth();

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
        // For retrieving the paired devices list
        getPairedDevices();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Bluetooth'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              contentPadding: EdgeInsets.all(0),
              title: const Text('Enable Bluetooth'),
              value: bluetoothState.isEnabled,
              onChanged: (bool value) {
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
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Paired devices",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: devicesList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 8),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              title: Text(devicesList[index].name),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('CONNECT'),
                                  onPressed: () {
                                    setState(
                                        () => _device = devicesList[index]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
