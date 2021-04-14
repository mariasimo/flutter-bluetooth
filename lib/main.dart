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

  FlutterBluetoothSerial bluetoothIntance = FlutterBluetoothSerial.instance;

  int deviceState; // used for tracking he Bluetooth device connection state

  List<BluetoothDevice> devicesList = []; // var for storing the devices list

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetoothIntance.getBondedDevices();
    } on PlatformException {
      print("Error");
    }
    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) return;

    // Store the [devices] list in the [_devicesList]
    setState(() {
      devicesList = devices;
    });
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
    // Get current state (ON/OFF)
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetoothState = state;
      });
    });

    deviceState = 0; // neutral
    enableBluetooth(); // request permission to turn on Bluetooth as the app starts up
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Bluetooth'),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Card(
              child: ListTile(
                onTap: () {},
                title: Text(devicesList[index].name),
                leading: CircleAvatar(),
              ),
            ),
          );
        },
      ),
    );
  }
}
