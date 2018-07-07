import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter/material.dart';
import 'package:snapshop/data/ShoppingList.dart';
import 'package:snapshop/data/ShoppingList_mock.dart';
import 'package:snapshop/main.dart';
import 'package:snapshop/screens/item/NewItemScreen.dart';
import 'package:snapshop/screens/shoppingitems/ShoppingItemsScreen.dart';
import 'package:snapshop/widgets/FadeRoute.dart';

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
      backgroundColor:
          Colors.white, //Theme.of(context).scaffoldBackgroundColor,
      body: items.isEmpty
          ? Center(
              child: RaisedButton(
                onPressed: () => initList(),
                child: Text('Reset the list'),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView(children: /*items.map(buildItem).toList() + */
                  [
                //SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: new Text(
                          "Test1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.grey.shade900.withOpacity(0.95)),
                        ),
                      ),
                    ),
                    color: Color(0xFFEFA7CB),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: new Text(
                            "Test2",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.grey.shade900.withOpacity(0.95)),
                          ),
                        ),
                      ),
                      color: Color(0xFF9CF6FF)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: new Text(
                          "Test3",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.grey.shade900.withOpacity(0.95)),
                        ),
                      ),
                    ),
                    color: Color(0xFFFB9A86),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: new Text(
                            "Test4",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.grey.shade900.withOpacity(0.95)),
                          ),
                        ),
                      ),
                      color: Color(0xFF8DC6FD)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: new Text(
                            "Test5",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.grey.shade900.withOpacity(0.95)),
                          ),
                        ),
                      ),
                      color: Color(0xFFFEC56A)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCandyButton(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: new Text(
                            "Test6",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.grey.shade900.withOpacity(0.95)),
                          ),
                        ),
                      ),
                      color: Color(0xFF39EDA4)),
                ),
              ]),
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

Widget buildCandyButton(
    {Widget child,
    Color color,
    BoxShape shape = BoxShape.circle,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(5.0))}) {
  bool colorRotationDirectionInverse = 150.0 <= HSLColor.fromColor(color).hue &&
      HSLColor.fromColor(color).hue <= 250.0;

  Color _darker1 = HSLColor
      .fromColor(color)
      .withSaturation(0.6)
      .withHue((HSLColor.fromColor(color).hue -
              (35 * (colorRotationDirectionInverse ? -1 : 1))) %
          360.0)
      .withLightness(0.7)
      .toColor();

  Color _darker2 = HSLColor
      .fromColor(color)
      .withSaturation(0.6)
      .withHue((HSLColor.fromColor(color).hue -
              (50 * (colorRotationDirectionInverse ? -1 : 1))) %
          360.0)
      .withLightness(0.7)
      .toColor();

  return InkWell(
    onTap: () {},
    child: Container(
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.78, 1.0],
            colors: [
              color,
              _darker1,
              _darker2,
            ],
          ),
          boxShadow: [
            BoxShadow(
                color: _darker2.withOpacity(0.6),
                spreadRadius: 0.0,
                blurRadius: 10.0,
                offset: Offset(0.0, 5.0)),
          ],
        ),
        child: child),
  );
}
