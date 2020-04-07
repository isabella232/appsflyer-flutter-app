import 'package:ezshop/providers/shopping_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_item.dart';

class ItemsListItem extends StatelessWidget {
  final ShoppingItem item;
  final String listId;

  ItemsListItem(this.item, this.listId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: buildDismissibleBackground(context),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        //remove item from list
        await Provider.of<ShoppingLists>(context).removeItem(listId, item);
      },
      key: ValueKey(item.itemId),
      child: ListTile(
        title: item.name != null ? Text(item.name) : Text("null"),
        trailing: Text('x${item.quantity.toString()}'),
      ),
    );
  }

  Container buildDismissibleBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).errorColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Swipe to delete",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
    );
  }
}
