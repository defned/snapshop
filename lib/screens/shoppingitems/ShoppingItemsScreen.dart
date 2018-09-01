import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter/material.dart';
import 'package:snapshop/data/ShoppingItem.dart';
import 'package:snapshop/main.dart';
import 'package:snapshop/screens/item/NewItemScreen.dart';
import 'package:snapshop/widgets/ExpandableContainer.dart';
import 'package:snapshop/widgets/FadeRoute.dart';
import 'package:snapshop/widgets/SpecialShadow.dart';

class ShoppingItemsScreen extends StatefulWidget {
  ShoppingItemsScreen({Key key, this.title, this.items, this.baseColor})
      : backgroundColor = HSLColor.fromColor(baseColor).withLightness(0.6).toColor(),
        states = Map.fromIterable(items, key: (v) => v, value: (_) => false),
        super(key: key);

  final Color baseColor;
  final Color backgroundColor;
  final String title;
  final List<ShoppingItem> items;
  final Map<ShoppingItem, bool> states;

  @override
  _ShoppingItemsScreenState createState() => new _ShoppingItemsScreenState();
}

class _ShoppingItemsScreenState extends State<ShoppingItemsScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DismissDirection _dismissDirection = DismissDirection.horizontal;

  void handleUndo(ShoppingItem item) {
    final int insertionIndex = lowerBound(widget.items, item);
    setState(() {
      widget.items.insert(insertionIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: widget.backgroundColor,
        elevation: 0.0,
        title: new Text(
          widget.title,
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor,
      body: new Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: ListView(children: widget.items.map(buildItem).toList()),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new FadeRoute(
            builder: (BuildContext context) => new NewItemScreen(items: widget.items),
          ));
        },
        tooltip: 'New Shopping List',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildItem(ShoppingItem item) {
    return Dismissible(
      key: Key(item.hashCode.toString() + widget.baseColor.toString()), //ObjectKey(item),
      direction: _dismissDirection,
      onDismissed: (DismissDirection direction) {
        setState(() {
          widget.items.remove(item);
        });
        final String action = (direction == DismissDirection.endToStart) ? 'deleted' : 'done';
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('${item.name} is $action'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  handleUndo(item);
                })));
      },
      background: Container(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Icon(
                  Icons.check,
                  size: 38.0,
                  color: Colors.green,
                ),
              ))),
      secondaryBackground: Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.delete,
                  size: 38.0,
                  color: Colors.red,
                ),
              ))),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(new FadeRoute(
            builder: (BuildContext context) =>
                new NewItemScreen(item: item, items: widget.items, baseColor: widget.baseColor),
          ));
        },
        child: SpecialShadowWidget(
            shadowColor: Colors.black,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                child: _buildRow(item))),
      ),
    );
  }

  Widget _buildRow(ShoppingItem item) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  if (widget.states[item] == true)
                    widget.states[item] = false;
                  else
                    widget.states[item] = true;
                });
              },
              child: Icon(
                  widget.states[item] ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 40.0,
                  color: Colors.grey.shade600),
              //color: kShrineTextOnAccentLighter),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: kShrineTextOnAccentLighter,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    (item.count * item.price).round().toString() + ".-",
                    style: new TextStyle(
                        fontFamily: 'StTransmission',
                        fontSize: 32.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
          ],
        ),
        ExpandableContainer(
            expanded: widget.states[item],
            child: Row(
              children: <Widget>[
                SizedBox(width: 5.0),
                item.image == null
                    ? Container(
                        width: 50.0,
                        height: 50.0,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black.withOpacity(0.3),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: widget.baseColor.withOpacity(0.6)))
                    : RawImage(image: item.image),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          item.count -= 1.0;
                        });
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          shape:
                              BoxShape.circle, // You can use like this way or like the below line
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.grey, blurRadius: 2.0, offset: Offset(1.3, 1.3)),
                          ],
                          //borderRadius: new BorderRadius.circular(30.0),
                          color: kShrinePink100,
                        ),
                        child: Icon(Icons.remove, color: kShrineTextOnAccent, size: 30.0),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        item.count.round().toString() + "x",
                        style: new TextStyle(
                            fontFamily: 'StTransmission',
                            fontSize: 28.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          item.count += 1.0;
                        });
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          shape:
                              BoxShape.circle, // You can use like this way or like the below line
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.grey, blurRadius: 2.0, offset: Offset(1.3, 1.3)),
                          ],
                          //borderRadius: new BorderRadius.circular(30.0),
                          color: kShrinePink100,
                        ),
                        child: Icon(Icons.add, color: kShrineTextOnAccent, size: 30.0),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: new Text(
                        item.price.round().toString() + ".-",
                        style: new TextStyle(
                            fontFamily: 'StTransmission',
                            fontSize: 28.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
              ],
            )),
      ],
    );
  }
}
