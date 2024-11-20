import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class InventoryProvider with ChangeNotifier {
  final List<InventoryItem> _items = [];

  List<InventoryItem> get items => _items;

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateItem(InventoryItem updatedItem) {
    int index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
