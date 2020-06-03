import 'package:ezshop/core/models/shopping_list.dart';
import 'package:flutter/material.dart';

import 'list_overview_item.dart';

class ListsOverviewListView extends StatelessWidget {
  final List<ShoppingList> list;

  ListsOverviewListView({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, i) => Divider(
        height: 1,
        color: Theme.of(context).primaryColor.withOpacity(0.7),
      ),
      itemBuilder: (ctx, i) => ListOverviewItem(
        list[i].id,
        list[i].title,
        list[i].items,
        list[i].totalChecked(),
        showTotalItems: !list[i].template,
      ),
      itemCount: list.length,
    );
  }
}
