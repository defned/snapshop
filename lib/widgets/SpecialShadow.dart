import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SpecialShadowWidget extends StatelessWidget {
  Color _shadowColor;
  Color _color;
  final Widget child;
  Color _gradient;
  //final BoxShape _shape;
  final double radius;

  final ui.TextStyle _textStyle = ui.TextStyle();
  final Duration animationDuration = kThemeChangeDuration;
  final MaterialType type = MaterialType.canvas;
  final double elevation = 0.0;
  final ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));

  Color get shadowColor => _shadowColor;
  Color get color => _color;
  ui.TextStyle get textStyle => _textStyle;

  SpecialShadowWidget({
    this.child,
    this.radius = 10.0,
    Color shadowColor,
    Color color = Colors.white,
    Color gradient,
    bool shiny = false,
    /*this.shape = BoxShape.rectangle*/
  }) {
    //assert(gradient != null && shiny == true);
    _gradient = color;
    _shadowColor = shadowColor;
    if (_shadowColor == null) _shadowColor = _gradient;

    if (shiny) {
//      Color _darker1 = HSLColor.fromColor(color)
//          .withSaturation(0.6)
//          .withHue((HSLColor.fromColor(color).hue - (15 * (false ? -1 : 1))) % 360.0)
//          .withLightness(0.71)
//          .toColor();

      bool colorRotationDirectionInverse =
          (190.0 <= HSLColor.fromColor(color).hue && HSLColor.fromColor(color).hue <= 210.0) ||
              (0.0 <= HSLColor.fromColor(color).hue && HSLColor.fromColor(color).hue <= 150.0);

      Color _darker1 = HSLColor.fromColor(color)
          .withSaturation(0.66)
          .withHue(
              (HSLColor.fromColor(color).hue - (30 * (colorRotationDirectionInverse ? -1 : 1))) %
                  360.0)
          .withLightness(0.68)
          .toColor();

      _color = _darker1;
      _gradient = color;
    } else if (gradient == null) {
      _color = color;
      _gradient = color;
    } else {
      _gradient = color;
      _color = gradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 15.0),
      child: CustomPaint(
          painter: SpecialShadow(
              radius: radius,
              //shape: shape,
              shadowColor: _shadowColor,
              color: this._color,
              gradientColor: _gradient),
          child: this.child),
    );
  }
}

class SpecialShadow extends CustomPainter {
  final Color shadowColor;
  final Color color;
  final Color gradientColor;
  final double radius;
  //final BoxShape shape;

  BoxDecoration _decoration;

  SpecialShadow(
      {
      //this.shape = BoxShape.rectangle,
      this.radius = 10.0,
      this.shadowColor,
      this.color = Colors.white,
      this.gradientColor = Colors.white}) {
    _decoration = BoxDecoration(
      //shape: shape,
      //borderRadius: shape == BoxShape.rectangle ? BorderRadius.all(Radius.circular(10.0)) : null,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      gradient: new LinearGradient(
        begin: Alignment.topRight,
        end: new Alignment(-0.5, 1.0), // 10% of the width, so there are ten blinds.
        colors: [color, gradientColor], // whitish to gray
        //tileMode: TileMode.repeated, // repeats the gradient over the canvas
      ),
      boxShadow: [
        BoxShadow(
            color: shadowColor.withOpacity(0.7),
            spreadRadius: 5.0,
            blurRadius: 13.0,
            offset: Offset(0.0, 5.0)),
      ],
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    double _deltaX = size.width - 30;
    double _deltaY = 10.0;

    Rect rect = Offset.zero & size;
    canvas.save();
    //canvas.clipRRect(new RRect.fromRectXY(rect, 100.0, 100.0));

    _paintShadows(
        canvas,
        RRect.fromRectXY(
            Rect.fromPoints(
                Offset(_deltaX, _deltaY), Offset(size.width - _deltaX, size.height - 1)),
            size.width / 2,
            size.height / 35),
        TextDirection.ltr);

    RRect _aRRect = RRect.fromRectAndRadius(
        Rect.fromPoints(Offset(0.0, 0.0), Offset(size.width, size.height)),
        Radius.circular(radius));

    final gradientPaint = new Paint()
      ..shader = _decoration.gradient
          .createShader(Rect.fromPoints(Offset(0.0, 0.0), Offset(size.width, size.height)));

    _paintBox(canvas, _aRRect, gradientPaint, TextDirection.ltr);

    //canvas.clipRRect(_aRRect);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SpecialShadow oldDelegate) {
    return this.radius == oldDelegate.radius;
  }

  void _paintBox(Canvas canvas, RRect rect, Paint paint, TextDirection textDirection) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, paint);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius == null) {
          canvas.drawRRect(rect, paint);
        } else {
          //canvas.drawRRect(_decoration.borderRadius.resolve(textDirection).toRRect(rect), paint);
          canvas.drawRRect(rect, paint);
        }
        break;
    }
  }

  void _paintShadows(Canvas canvas, RRect rect, TextDirection textDirection) {
    if (_decoration.boxShadow == null) return;
    for (BoxShadow boxShadow in _decoration.boxShadow) {
      final Paint paint = boxShadow.toPaint();
      final RRect bounds = rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }
}
