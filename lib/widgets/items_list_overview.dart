import 'package:ezshop/providers/shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_lists.dart';
import './items_list_item.dart';

class ItemsListOverview extends StatefulWidget {
  final String listId;

  ItemsListOverview(this.listId);

  @override
  _ItemsListOverviewState createState() => _ItemsListOverviewState();
}

class _ItemsListOverviewState extends State<ItemsListOverview> {
  List<ShoppingItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        child: Container(
          width: double.infinity,
          child: FutureBuilder(
            future: Provider.of<ShoppingLists>(context).getItems(widget.listId),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occured'),
                  );
                } else {
                  items = dataSnapshot.data as List<ShoppingItem>;
                  return Column(
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
                        child: Consumer<ShoppingLists>(
                          builder: (ctx, shoppingData, child) {
                            return ListView.builder(
                              itemBuilder: (_, i) =>
                                  ItemsListItem(items[i], widget.listId),
                              itemCount: items.length,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
