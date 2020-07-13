import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:flutter/foundation.dart';

class ShoppingItem extends ShoppingLists {
  String itemId;
  final String name;
  final int quantity;
  String imgUrl;
  bool isChecked;

  ShoppingItem({
    @required this.itemId,
    @required this.name,
    @required this.quantity,
    this.isChecked = false,
    this.imgUrl,
  });

  ShoppingItem.fromMap(Map item, String listId)
      : itemId = item['id'] ?? '',
        name = item['name'] ?? '',
        quantity = item['quantity'] ?? 1,
        isChecked = item['isChecked'] ?? false,
        imgUrl = item['imgUrl'] ?? null;

  toggleIsChecked() {
    isChecked = !isChecked;

    notifyListeners();
  }

  addImg(String imgUrl, String listId) async {
    this.imgUrl = imgUrl;
    ShoppingList data = await getListById(listId);
    data.items.firstWhere((item) => item.itemId == this.itemId).imgUrl = imgUrl;
    await updateList(data, listId);
    notifyListeners();
  }

  toJson() {
    return {
      "id": itemId,
      "name": name,
      "quantity": quantity,
      "isChecked": isChecked,
      "imgUrl": imgUrl,
    };
  }
}
