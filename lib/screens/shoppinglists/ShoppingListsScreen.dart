import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter/material.dart';
import 'package:snapshop/data/ShoppingList.dart';
import 'package:snapshop/data/ShoppingList_mock.dart';
import 'package:snapshop/main.dart';
import 'package:snapshop/screens/item/NewItemScreen.dart';
import 'package:snapshop/screens/shoppingitems/ShoppingItemsScreen.dart';
import 'package:snapshop/widgets/FadeRoute.dart';

class ShoppingListsScreen extends StatefulWidget {
  ShoppingListsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingListsScreenState createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

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
        final String action =
            (direction == DismissDirection.endToStart) ? 'deleted' : 'done';
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
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(FadeRoute(
                  builder: (BuildContext context) =>
                      ShoppingItemsScreen(title: item.name, items: item.items),
                ));
          },
          child: Card(
              elevation: 30.0,
              color: kShrinePink50,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      size: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        item.name,
                        style: TextStyle(
                            color: kShrineTextOnAccentLighter,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )),
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
              padding: EdgeInsets.all(8.0),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
