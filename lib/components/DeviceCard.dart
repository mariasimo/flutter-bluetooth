import 'package:bluetooth_bridge/utils/bluetoothStyledDevice.dart';
import 'package:bluetooth_bridge/utils/deviceDetail.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_bridge/pages/DetailPage.dart';
import 'package:bluetooth_bridge/components/DeviceBadge.dart';
import '../theme/theme.dart' as Theme;

class DeviceCard extends StatefulWidget {
  final BluetoothStyledDevice selectedDevice;
  final Function handleExploreDevicesButton;
  final Function closeDeviceConnection;

  DeviceCard({
    Key key,
    @required this.selectedDevice,
    @required this.handleExploreDevicesButton,
    @required this.closeDeviceConnection,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Dispositivo seleccionado",
            style: Theme.BBThemeData.textTheme.headline4,
          ),
        ),
        Card(
          child: Container(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: widget.closeDeviceConnection,
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(30, 30),
                        alignment: Alignment.center),
                    child: Icon(
                      Icons.close,
                      color: Theme.BBColors.grey[500],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(21, 0, 21, 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: DeviceBadge(
                            selectedDevice: widget.selectedDevice, size: "big"),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedDevice.values.name,
                              style: Theme.BBThemeData.textTheme.subtitle1
                                  .copyWith(color: Theme.BBColors.grey[400]),
                            ),
                            Text(
                              widget.selectedDevice.values.isConnected
                                  ? "Conectado"
                                  : "Desconectado. Revise que su dispositivo está operativo",
                              style: Theme.BBThemeData.textTheme.bodyText1
                                  .copyWith(color: Theme.BBColors.grey[400]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Theme.BBColors.grey[200],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(21, 12, 21, 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.settings, size: 30),
                          style: widget.selectedDevice.isConnected
                              ? ElevatedButton.styleFrom(
                                  primary: Theme.BBThemeData.primaryColor,
                                  onPrimary: Theme.BBColors.blue[100],
                                  padding: EdgeInsets.all(14),
                                )
                              : ElevatedButton.styleFrom(
                                  primary: Theme.BBColors.grey[100],
                                  onPrimary: Theme.BBColors.grey[300],
                                  padding: EdgeInsets.all(14),
                                )),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => DeviceDetail(
                                  context: context,
                                  device: widget.selectedDevice)
                              .goToPage(),
                          child: Text('Monitorizar'),
                          style: widget.selectedDevice.isConnected
                              ? null
                              : ElevatedButton.styleFrom(
                                  primary: Theme.BBColors.grey[300],
                                  onPrimary: Theme.BBColors.grey[100],
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                    onPressed: widget.handleExploreDevicesButton,
                    child: Text('Explorar dispositivos vinculados'),
                    style: TextButton.styleFrom(
                      primary: Theme.BBThemeData.primaryColor,
                      backgroundColor: Theme.BBColors.blue[100],
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
