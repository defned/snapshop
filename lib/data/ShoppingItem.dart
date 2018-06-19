import 'package:flutter/widgets.dart';

enum Currency { unknown, HUF }

class ShoppingItem implements Comparable<ShoppingItem> {
  DateTime created;
  String name;
  Image image;
  double count;
  double price;
  Currency currency;

  ShoppingItem(this.name, this.image, this.count, this.price, this.currency,
      this.created);

  @override
  int compareTo(ShoppingItem other) => created.compareTo(other.created);
}
