import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DetailPage extends StatefulWidget {
  final BluetoothDevice server;
  const DetailPage({this.server});

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
          print("1 second passed");
          _sendMessage("monitor*");
        });
      }
      _timer();
    });
  }

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
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
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting to ' + widget.server.name + '...')
              : isConnected
                  ? Text('Data from device ' + widget.server.name)
                  : Text('Not connected:' + widget.server.name))),
      body: Column(
        children: <Widget>[
          Text(widget.server.isConnected ? "con" : "not"),
          ElevatedButton(
            onPressed: () {
              _sendMessage("monitor*");
            },
            child: Text("Refrescar"),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: dataFromDevice.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[800],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataFromDevice[index].dataKey,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          dataFromDevice[index].dataValue,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
