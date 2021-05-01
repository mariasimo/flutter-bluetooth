import 'package:flutter/material.dart';
import '../theme/index.dart' as Theme;

Card emptyCard(seePairedDevices) {
  return Card(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.CompanyColors.grey[100])),
    elevation: 0,
    margin: EdgeInsets.all(0),
    child: Container(
      padding: EdgeInsets.all(21),
      child: Column(
        children: <Widget>[
          Text(
            "No estás conectado a ningún dispositivo",
            textAlign: TextAlign.center,
            style: Theme.CompanyThemeData.textTheme.subtitle1
                .copyWith(color: Theme.CompanyColors.grey[400]),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: seePairedDevices,
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
