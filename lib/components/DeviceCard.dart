import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../theme/theme.dart' as Theme;
import 'package:flutter_svg/flutter_svg.dart';

class DeviceCard extends StatelessWidget {
  final BluetoothDevice selectedDevice;
  final String assetName = 'assets/no-device-connected.svg';

  DeviceCard({
    Key key,
    @required this.selectedDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Dispositivo conectado",
            style: Theme.BBThemeData.textTheme.headline3,
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Theme.BBColors.grey[100])),
          elevation: 0,
          margin: EdgeInsets.all(0),
          child: Container(
            padding: EdgeInsets.all(21),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 24),
                  title: Text(
                    selectedDevice.name,
                    style: Theme.BBThemeData.textTheme.subtitle1
                        .copyWith(color: Theme.BBColors.grey[400]),
                  ),
                  leading: SvgPicture.asset(
                    assetName,
                    width: 100,
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {},
                        child: Icon(Icons.settings, size: 30),
                        style: TextButton.styleFrom(
                          primary: Theme.BBThemeData.primaryColor,
                          backgroundColor: Theme.BBColors.blue[100],
                          padding: EdgeInsets.all(14),
                        )),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Monitorizar'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
