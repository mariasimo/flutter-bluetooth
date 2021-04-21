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
  List<BluetoothDevice> devicesList = []; // var for storing the devices list
  BluetoothConnection connection; // Track connection with the remote device
  bool get isConnected =>
      connection != null && connection.isConnected; // still connected to BT
  bool isDisconnecting = false; // disconnection is in progress

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
    print({devicesList});
    setState(() => devicesList = devices);
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    await getPairedDevices();
  }

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      print({"initState", state});
      setState(() {
        bluetoothState = state;
      });
    });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: bluetoothState.isEnabled,
              onChanged: (bool value) {
                print({'isBTEnabled', value});
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  print({'isBTEnabled', value});
                  setState(() {});
                });
              },
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: devicesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                        onTap: () {}, title: Text(devicesList[index].name)),
                  );
                })
          ],
        ),
      ),
    );
  }
}
