import 'package:flutter/foundation.dart';
import '../providers/shopping_item.dart';

class ShoppingList {
  final String id;
  final String timestampId;
  String title;
  final List<ShoppingItem> items;

  ShoppingList(
      {@required this.id,
      @required this.title,
      this.items,
      this.timestampId = ""});

//  ShoppingList.fromJson(Map<String, dynamic> json)

  ShoppingList.fromMap(Map snapshot, String id)
      : id = id ?? '',
        timestampId = snapshot['timeStampId'] ?? '',
        title = snapshot['title'] ?? '',
        items = snapshot['items'] != null
            ? (snapshot['items'] as List)
                .map((item) => ShoppingItem.fromMap(item, id))
                .toList()
            : List<ShoppingItem>();

  toJson() {
    return {
      "timeStampId": timestampId,
      "title": title,
      "items": items.map((item) => item.toJson()).toList(),
    };
  }

  int totalChecked() {
    int sum = 0;
    items.forEach((item) {
      if (item.isChecked) {
        sum++;
      }
    });
    return sum;
  }
}
