import 'package:bluetooth_bridge/utils/bluetoothStyledDevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeviceBadge extends StatelessWidget {
  const DeviceBadge({
    Key key,
    @required this.selectedDevice,
    this.size = "small",
  }) : super(key: key);

  final BluetoothStyledDevice selectedDevice;
  final String size;

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == 'small';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmall ? 8 : 24),
      ),
      color: selectedDevice.colorCombo[0],
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 16 : 32),
        child: SvgPicture.asset(
          'assets/device-${selectedDevice.iconNumber}.svg',
          width: isSmall ? 25 : 40,
          color: selectedDevice.colorCombo[1],
        ),
      ),
    );
  }
}
