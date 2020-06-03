import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingList shoppingList;
  final int index;

  ShoppingListItem(this.shoppingList, this.index);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ShoppingItem>(context);
    final EdgeInsets itemPadding = shoppingList.template
        ? EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0)
        : EdgeInsets.all(8.0);
    double opacity = 1.0;

    return InkWell(
      onTap: () async {
        opacity = 0.0;
        item.toggleIsChecked();
        await Provider.of<ShoppingLists>(context)
            .updateList(shoppingList, shoppingList.id);
      },
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: opacity,
            child: Container(
              color: index % 2 == 0
                  ? Colors.white
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: <Widget>[
                  Visibility(
                    child: Checkbox(
                      onChanged: (val) async {
                        item.toggleIsChecked();
                        await Provider.of<ShoppingLists>(context)
                            .updateList(shoppingList, shoppingList.id);
                      },
                      value: item.isChecked,
                    ),
                    visible: !shoppingList.template,
                  ),
                  Expanded(
                    child: Padding(
                      padding: itemPadding,
                      child: Text(
                        item.name,
                        style: TextStyle(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "x" + item.quantity.toString(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
