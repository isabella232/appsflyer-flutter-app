import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/ui/screens/list_detail_screen/list_detail_screen.dart';
import 'package:ezshop/ui/screens/list_detail_screen/widgets/shopping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListDetailView extends StatelessWidget {
  final ShoppingList shoppingList;
  final Mode mode;
  final List<ShoppingItem> filteredList = List<ShoppingItem>();

  ShoppingListDetailView({this.shoppingList, this.mode}) {
    if (mode == Mode.All) {
      filteredList.addAll(shoppingList.items);
    }
    shoppingList.items.forEach((item) {
      if (mode == Mode.Unchecked) {
        if (!item.isChecked) {
          filteredList.add(item);
        }
      }
      if (mode == Mode.Checked) {
        if (item.isChecked) {
          filteredList.add(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: filteredList[i],
        child: ShoppingListItem(shoppingList, i),
      ),
      itemCount: filteredList.length,
    );
  }
}
