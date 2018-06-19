import 'package:flutter/widgets.dart';
import 'package:snapshop/data/ShoppingItem.dart';

final List<ShoppingItem> shoppingItemList = [
  new ShoppingItem('Női farmerkabát', Image.asset('assets/images/jacket.png'),
      1.0, 3999.0, Currency.HUF, DateTime.now()),
  new ShoppingItem('Morning Glory 2', Image.asset('assets/images/drink.png'),
      2.0, 5499.0, Currency.HUF, DateTime.now()),
  new ShoppingItem(
      'Morning Glory 3', null, 3.0, 2999.0, Currency.HUF, DateTime.now()),
  new ShoppingItem(
      'Morning Glory 4', null, 4.0, 5499.0, Currency.HUF, DateTime.now()),
  new ShoppingItem(
      'Morning Glory 5', null, 5.0, 5499.0, Currency.HUF, DateTime.now()),
  new ShoppingItem(
      'Morning Glory 6', null, 6.0, 5499.0, Currency.HUF, DateTime.now()),
];
