import 'package:flutter/widgets.dart';

class ExpandableListViewItem extends StatefulWidget {
  const ExpandableListViewItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _ExpandableListViewItemState createState() => _ExpandableListViewItemState();
}

class _ExpandableListViewItemState extends State<ExpandableListViewItem> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
