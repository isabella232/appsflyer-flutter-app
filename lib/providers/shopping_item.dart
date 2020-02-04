import 'package:flutter/foundation.dart';

class ShoppingItem with ChangeNotifier {
  String itemId;
  final String name;
  final int quantity;
  bool isChecked;

  ShoppingItem(
      {@required this.itemId,
      @required this.name,
      @required this.quantity,
      this.isChecked = false});

  ShoppingItem.fromMap(Map item, String listId)
      : itemId = item['id'] ?? '',
        name = item['name'] ?? '',
        quantity = item['quantity'] ?? 1,
        isChecked = item['isChecked'] ?? false;

  toggleIsChecked() {
    isChecked = !isChecked;

    notifyListeners();
  }

  toJson() {
    return {
      "id": itemId,
      "name": name,
      "quantity": quantity,
      "isChecked": isChecked,
    };
  }
}
