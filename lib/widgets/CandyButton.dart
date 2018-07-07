import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CandyButton extends StatefulWidget {
  Color color;
  String text;
  double elevation;

  CandyButton({this.color, this.text, this.elevation = 5.0});

  @override
  _CandyButtonState createState() => _CandyButtonState();
}

class _CandyButtonState extends State<CandyButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: new Text(widget.text),
        ),
        shadowColor: widget.color.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        elevation: widget.elevation,
        color: widget.color);
  }
}
