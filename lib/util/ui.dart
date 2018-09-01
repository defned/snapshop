import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildCandyButton(
    {Widget child,
    Color color,
    BoxShape shape = BoxShape.circle,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    GestureTapCallback onTap,
    bool candify = true}) {
  bool colorRotationDirectionInverse =
      (150.0 <= HSLColor.fromColor(color).hue && HSLColor.fromColor(color).hue <= 240.0) ||
          (HSLColor.fromColor(color).lightness < 0.6);

  Color _darker1 = HSLColor.fromColor(color)
      .withSaturation(0.6)
      .withHue(
          (HSLColor.fromColor(color).hue - (35 * (colorRotationDirectionInverse ? -1 : 1))) % 360.0)
      .withLightness(0.7)
      .toColor();

  Color _darker2 = HSLColor.fromColor(color)
      .withSaturation(0.6)
      .withHue(
          (HSLColor.fromColor(color).hue - (50 * (colorRotationDirectionInverse ? -1 : 1))) % 360.0)
      .withLightness(0.7)
      .toColor();

  List<BoxShadow> _shadows = [
    BoxShadow(
        color: candify == true ? _darker2.withOpacity(0.4) : color.withOpacity(0.4),
        spreadRadius: 0.0,
        blurRadius: 5.0,
        offset: Offset(0.0, 7.0)),
  ];

  return Container(
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        color: candify == true ? null : color,
        gradient: candify == true
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, /*0.78,*/ 1.0],
                colors: [
                  color,
                  _darker2,
                ],
              )
            : null,
        boxShadow: _shadows,
      ),
      child: new Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          shape: shape == BoxShape.circle
              ? CircleBorder()
              : RoundedRectangleBorder(borderRadius: borderRadius),
          child: new InkWell(
              splashColor: _darker2,
              highlightColor: _darker1,
              onTap: () {
                if (onTap != null) onTap();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: child),
              ) /*child*/)));
}

int getHue(Color color) {
  return _getHue(color.red, color.green, color.blue);
}

int _getHue(int red, int green, int blue) {
  int _min = min(min(red, green), blue);
  int _max = max(max(red, green), blue);

  if (_min == _max) {
    return 0;
  }

  double hue = 0.0;
  if (_max == red) {
    hue = (green - blue) / (_max - _min);
  } else if (_max == green) {
    hue = 2.0 + (blue - red) / (_max - _min);
  } else {
    hue = 4.0 + (red - green) / (_max - _min);
  }

  hue = hue * 60;
  if (hue < 0) hue = hue + 360;

  return hue.round();
}
