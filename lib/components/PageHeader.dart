import 'dart:core';
import 'package:flutter/material.dart';
import 'package:bluetooth_bridge/theme/theme.dart' as Theme;

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key key,
    @required this.pageTitle,
    this.onPressed,
    this.styleHeading,
  }) : super(key: key);

  final String pageTitle;
  final Function onPressed;
  final TextStyle styleHeading;

  @override
  Widget build(BuildContext context) {
    final bool hasButton = this.onPressed != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pageTitle,
            style: styleHeading ?? Theme.BBThemeData.textTheme.headline2,
          ),
          hasButton
              ? ElevatedButton(
                  onPressed: onPressed,
                  child: Icon(Icons.replay, size: 30),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.BBColors.blue[100],
                    onPrimary: Theme.BBColors.blue[500],
                    padding: EdgeInsets.all(14),
                  ),
                )
              : SizedBox(width: 0),
        ],
      ),
    );
  }
}
