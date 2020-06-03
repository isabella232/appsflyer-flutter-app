import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../providers/shopping_item.dart';

class ShoppingList {
  String id;
  final String timestampId;
  String title;
  final List<ShoppingItem> items;
  bool template;

  ShoppingList(
      {@required this.id,
      @required this.title,
      this.items,
      this.timestampId = "",
      this.template = false});

//  ShoppingList.fromJson(Map<String, dynamic> json)

  ShoppingList.fromMap(Map snapshot, String id)
      : id = id ?? '',
        timestampId = snapshot['timeStampId'] ?? '',
        title = snapshot['title'] ?? '',
        template = snapshot['template'] ?? false,
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
      "template": template,
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

  static ShoppingList copy(ShoppingList template) {
    return ShoppingList(
      id: 'temp${DateTime.now().toIso8601String()}',
      title: 'Copy of ${template.title}',
      template: false,
      items: List<ShoppingItem>.from(template.items),
      timestampId: DateTime.now().toIso8601String(),
    );
  }
}
