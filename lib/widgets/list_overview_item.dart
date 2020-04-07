import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_item.dart';
import '../providers/shopping_lists.dart';
import '../screens/list_detail_screen.dart';
import '../screens/create_list_screen.dart';
import '../models/shopping_list.dart';

class ListOverviewItem extends StatelessWidget {
  final String id;
  final String title;
  final List<ShoppingItem> items;
  final int totalChecked;

  ListOverviewItem(this.id, this.title, this.items, this.totalChecked);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: buildEditBackground(context),
      secondaryBackground: buildDeleteBackground(context),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ListDetailScreen.routeName, arguments: this.id);
        },
        child: ListTile(
          title: Text(title),
          trailing: Text(
              '${totalChecked.toString()}/${items.length.toString()} items'),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
              context: context, builder: (ctx) => buildAlertDialog(ctx));
        } else {
          ShoppingList shoppingList =
              await Provider.of<ShoppingLists>(context).getListById(id);
          Navigator.pushNamed(context, CreateListScreen.routeName, arguments: {
            'edit': true,
            'shoppingListId': shoppingList.id,
          });
          return Future<bool>(() => false);
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<ShoppingLists>(context).removeList(id);
        }
      },
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you want to remove the list from your shopping lists?"),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  Container buildDeleteBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).errorColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
    );
  }

  Container buildEditBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20),
    );
  }
}
