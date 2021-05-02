import 'package:bluetooth_bridge/components/DeviceBadge.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_bridge/theme/theme.dart' as Theme;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bluetooth_bridge/utils/bluetoothStyledDevice.dart';

class BluetoothDeviceListEntry extends Card {
  BluetoothDeviceListEntry({
    @required BluetoothStyledDevice device,
    int rssi,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
  }) : super(
          margin: EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: DeviceBadge(selectedDevice: device)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.values.name ?? 'Unknown device',
                                style: Theme.BBThemeData.textTheme.subtitle1
                                    .copyWith(color: Theme.BBColors.grey[400]),
                              ),
                              Text(
                                device.values.isConnected
                                    ? 'Conectado'
                                    : 'Desconectado',
                                style: Theme.BBThemeData.textTheme.subtitle2
                                    .copyWith(color: Theme.BBColors.grey[400]),
                              ),
                              rssi != null
                                  ? Container(
                                      margin: new EdgeInsets.all(8.0),
                                      child: DefaultTextStyle(
                                        style: _computeTextStyle(rssi),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(rssi.toString()),
                                            Text('dBm'),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(width: 0, height: 0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35)
      return TextStyle(color: Colors.greenAccent[700]);
    else if (rssi >= -45)
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    else if (rssi >= -55)
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    else if (rssi >= -65)
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    else if (rssi >= -75)
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    else if (rssi >= -85)
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    else
      /*code symetry*/
      return TextStyle(color: Colors.redAccent);
  }
}
