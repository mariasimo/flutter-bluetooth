import 'package:flutter/material.dart';
import '../theme/theme.dart' as Theme;
import 'package:flutter_svg/flutter_svg.dart';

class EmptyCard extends StatelessWidget {
  final Function handleButtonPress;
  final String assetName = 'assets/no-device-connected.svg';

  EmptyCard({
    Key key,
    @required this.handleButtonPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.BBColors.grey[100])),
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(21),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 24),
              child: SvgPicture.asset(
                assetName,
                width: 100,
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              child: Text(
                "No estás conectado a ningún dispositivo",
                textAlign: TextAlign.center,
                style: Theme.BBThemeData.textTheme.subtitle1
                    .copyWith(color: Theme.BBColors.grey[400]),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: handleButtonPress,
                    child: Text('Explorar dispositivos vinculados'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
