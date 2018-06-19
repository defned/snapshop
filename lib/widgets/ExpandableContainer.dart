import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 65.0,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        //width: screenWidth,
        height: expandedHeight,
        child: Container(child: child),
      );
    } else {
      return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          //width: screenWidth,
          height: collapsedHeight,
          child: Container(child: child));
    }
  }
}
