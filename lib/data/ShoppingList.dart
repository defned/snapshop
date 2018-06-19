import 'package:snapshop/data/ShoppingItem.dart';

class ShoppingList implements Comparable<ShoppingList> {
  String name;
  DateTime created;
  bool done;
  List<ShoppingItem> items;

  ShoppingList(this.name, this.created, this.done, this.items);

  @override
  int compareTo(ShoppingList other) => created.compareTo(other.created);
}
