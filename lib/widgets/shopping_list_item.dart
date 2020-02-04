import 'package:ezshop/models/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_item.dart';
import '../providers/shopping_lists.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingList shoppingList;

  ShoppingListItem(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ShoppingItem>(context);

    return InkWell(
      onTap: () async {
        item.toggleIsChecked();
        await Provider.of<ShoppingLists>(context)
            .updateList(shoppingList, shoppingList.id);
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              item.name,
              style: TextStyle(
                  decoration: item.isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            subtitle: Text("x" + item.quantity.toString()),
            trailing: Checkbox(
              onChanged: (val) async {
                item.toggleIsChecked();
                await Provider.of<ShoppingLists>(context)
                    .updateList(shoppingList, shoppingList.id);
              },
              value: item.isChecked,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
