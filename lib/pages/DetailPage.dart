import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bluetooth_bridge/components/DeviceBadge.dart';
import 'package:bluetooth_bridge/utils/bluetoothStyledDevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bluetooth_bridge/theme/theme.dart' as Theme;
import 'package:bluetooth_bridge/components/PageHeader.dart';

class DetailPage extends StatefulWidget {
  final BluetoothStyledDevice device;
  const DetailPage({this.device});

  @override
  _DetailPage createState() => new _DetailPage();
}

class _DataFromDevice {
  String dataKey;
  String dataValue;
  _DataFromDevice(this.dataKey, this.dataValue);
}

class _DetailPage extends State<DetailPage> {
  BluetoothConnection connection;
  _DataFromDevice pieceOfData;
  List<_DataFromDevice> dataFromDevice = [];
  List<String> receivedData = [];
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  void _timer() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (this.mounted) {
        setState(() {
          _sendMessage("monitor*");
        });
      }
      _timer();
    });
  }

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.device.values.address)
        .then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      _timer();
      _sendMessage("monitor*");

      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String pageTitle = isConnecting
        ? "Conectando..."
        : isConnected
            ? "Conectado"
            : "Error de conexión";
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PageHeader(
                pageTitle: pageTitle,
                onPressed: () {
                  _sendMessage("monitor*");
                },
                styleHeading: Theme.BBThemeData.textTheme.headline1,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: DeviceBadge(selectedDevice: widget.device)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.device.values.name ?? 'Unknown device',
                            style: Theme.BBThemeData.textTheme.subtitle1
                                .copyWith(color: Theme.BBColors.grey[400]),
                          ),
                          Text(
                            widget.device.values.isConnected
                                ? 'Conectado'
                                : 'Desconectado',
                            style: Theme.BBThemeData.textTheme.subtitle2
                                .copyWith(color: Theme.BBColors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Divider(),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: dataFromDevice.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Theme.BBColors.grey[100])),
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
                          child: ListTile(
                            title: Text(dataFromDevice[index].dataKey,
                                style: Theme.BBThemeData.textTheme.headline3),
                            trailing: Text(
                              dataFromDevice[index].dataValue,
                              style: Theme.BBThemeData.textTheme.bodyText1
                                  .copyWith(color: Theme.BBColors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function that handles data received from ESP32
  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    receivedData.add(dataString);
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(dataString);
    Iterable<List<String>> splittedLines =
        lines.map((line) => line.split(":")).where((x) => x.length >= 2);

    if (this.mounted) {
      setState(() {
        splittedLines.forEach((e) {
          bool isAlreadyInList = dataFromDevice
              .where((element) => element.dataKey == e[0])
              .isNotEmpty;

          if (isAlreadyInList) {
            dataFromDevice = dataFromDevice.map((element) {
              return element.dataKey == e[0]
                  ? _DataFromDevice(e[0], e[1])
                  : element;
            }).toList();
          } else {
            dataFromDevice.add(_DataFromDevice(e[0], e[1]));
          }
        });
      });
    }
  }

  //function that receives "monitor*" message
  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text));
        await connection.output.allSent;

        setState(() {
          print("message sent");
        });
      } catch (e) {
        // Ignore error, but notify state
        print({"error": e});
        setState(() {});
      }
    }
  }
}
