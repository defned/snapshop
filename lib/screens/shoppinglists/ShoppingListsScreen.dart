import 'dart:math';

import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter/material.dart';
import 'package:snapshop/data/ShoppingList.dart';
import 'package:snapshop/data/ShoppingList_mock.dart';
import 'package:snapshop/screens/item/NewItemScreen.dart';
import 'package:snapshop/screens/shoppingitems/ShoppingItemsScreen.dart';
import 'package:snapshop/util/ui.dart';
import 'package:snapshop/widgets/ColorSchemas.dart';
import 'package:snapshop/widgets/FadeRoute.dart';
import 'package:snapshop/widgets/SpecialShadow.dart';

class ShoppingListsScreen extends StatefulWidget {
  factory ShoppingListsScreen.forDesignTime() {
    return new ShoppingListsScreen();
  }

  ShoppingListsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingListsScreenState createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DismissDirection _dismissDirection = DismissDirection.horizontal;

  void handleUndo(ShoppingList item) {
    final int insertionIndex = lowerBound(items, item);
    setState(() {
      items.insert(insertionIndex, item);
    });
  }

  Widget buildItem(ShoppingList item) {
    return Dismissible(
      key: ObjectKey(item),
      direction: _dismissDirection,
      onDismissed: (DismissDirection direction) {
        setState(() {
          items.remove(item);
        });
        final String action = (direction == DismissDirection.endToStart) ? 'deleted' : 'done';
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('${item.name} is $action'),
            duration: Duration(seconds: 2),
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
          Navigator.of(context).push(FadeRoute(
            builder: (BuildContext context) => ShoppingItemsScreen(
                title: item.name,
                items: item.items,
                baseColor: ColorHelper.getColorFromAnyString(item.name)),
          ));
        },
        child: SpecialShadowWidget(
          child: Container(
              width: double.infinity,
              height: 70.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(item.name,
                          style: TextStyle(color: Color(0xFFEEEEF9), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: Transform.rotate(
                        angle: pi / 10,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 80.0,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      )),
                  Positioned(
                    right: 20.0,
                    top: 20.0,
                    child: Container(
                      width: 30.0,
                      child: Center(
                        child: Text(item.items.length.toString(),
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2) /*Color(0xFFEEEEF9)*/,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              )),
          color: ColorHelper.getColorFromAnyString(item.name),
          shiny: true,
        ),
      ),
    );
  }

  List<ShoppingList> items;

  void initList() {
    setState(() {
      items = shoppingLists.sublist(0);
    });
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          centerTitle: true,
          leading: Icon(Icons.menu),
          title: Center(
            child: Row(
              children: <Widget>[
                Text(
                  "Sn",
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "apSh",
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.camera_alt, size: 33.0),
                Text(
                  "p",
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
//                Padding(
//                  padding: EdgeInsets.only(left: 2.0),
//                  child: Icon(Icons.shopping_cart, size: 30.0),
//                )
              ],
            ),
          )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: items.isEmpty
          ? Center(
              child: RaisedButton(
                onPressed: () => initList(),
                child: Text('Reset the list'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: ListView(children: items.map(buildItem).toList()),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(FadeRoute(
            builder: (BuildContext context) => NewItemScreen(),
          ));
        },
        tooltip: 'New Shopping List',
        child: Icon(Icons.add),
      ),
    );
  }
}

List<Widget> buildPalette(int value) {
  List<Widget> result = [];
  var v = value;
  for (var rStep = 0; rStep < v; rStep++) {
    Random random = new Random();
    int red = 28 + random.nextInt(100) + 127;
    int green = 28 + random.nextInt(100) + 127;
    int blue = 28 + random.nextInt(100) + 127;

    Color mix = null; //Color(0xFFAAFFFF);
    // mix the color
    if (mix != null) {
      red = ((red + mix.red) / 2).round();
      green = ((green + mix.green) / 2).round();
      blue = ((blue + mix.blue) / 2).round();
    }

    result.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildCandyButton(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Test6",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.grey.shade900.withOpacity(0.95)),
              ),
            ),
          ),
          color: Color.fromRGBO(red, green, blue, 1.0),
          onTap: () {
            print("test");
          }),
    ));
  }

  return result;
}
