import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:flutter/material.dart';

import 'items_list_item.dart';

class ItemsListOverview extends StatelessWidget {
  final List<ShoppingItem> listItems;
  final String listId;

  ItemsListOverview({this.listItems, this.listId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Swipe left to delete",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, i) => ItemsListItem(listItems[i], listId),
                  itemCount: listItems.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
