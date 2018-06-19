import 'package:flutter/widgets.dart';

void addIfNonNull(Widget child, List<Widget> children) {
  if (child != null) {
    children.add(child);
  }
}
