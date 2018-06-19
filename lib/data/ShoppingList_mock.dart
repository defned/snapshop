import 'package:snapshop/data/ShoppingItem_mock.dart';
import 'package:snapshop/data/ShoppingList.dart';

final List<ShoppingList> shoppingLists = [
  new ShoppingList('First', new DateTime.now(), false, shoppingItemList),
  new ShoppingList('Second', new DateTime.now(), false, shoppingItemList),
  new ShoppingList('Third', new DateTime.now(), false, shoppingItemList),
];
