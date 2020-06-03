import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/widgets/padding_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_overview_item.dart';
import 'lists_overview_shopping_list_view.dart';

class ShoppingListView extends StatefulWidget {
  @override
  _ShoppingListViewState createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  List<ShoppingList> _lists;
  bool _hasTemplateLists;

  @override
  void initState() {
    super.initState();
    _hasTemplateLists = false;
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListsData = Provider.of<ShoppingLists>(context);
    final size = MediaQuery.of(context).size;
    final AppMode appMode = Provider.of<AppProvider>(context).appMode;

    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: shoppingListsData.fetchLists(getTemplates: false),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text("an error occurred"),
                  );
                } else {
                  if (dataSnapshot.data == null) {
                    //The user is not registered in our db yet
                    return _buildEmptyListPlaceholder(size);
                  }
                  return buildListViewFromDataSnapshot(
                      dataSnapshot, "My Lists");
                }
              }
            },
          ),
        ),
        FutureBuilder(
          future: shoppingListsData.fetchLists(getTemplates: true),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text("an error occurred"),
                );
              } else {
                if (dataSnapshot.data == null) {
                  //The user is not registered in our db yet
                  return Expanded(
                    child: buildListViewFromDataSnapshot(
                        dataSnapshot, "Template Lists"),
                  );
                }

                return Expanded(
                  child: buildListViewFromDataSnapshot(
                      dataSnapshot, "Template Lists"),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyListPlaceholder(Size size) {
    return PaddedContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/empty-shopping-cart.png',
              fit: BoxFit.cover,
              width: size.width * 0.3,
              color: Colors.black38,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Your don\'t have any list yet. You can add one by either creating or searching an existing list',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget buildListViewFromDataSnapshot(
      AsyncSnapshot dataSnapshot, String title) {
    _lists = dataSnapshot.data;
    return PaddedContent(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _lists != null && _lists.length > 0
                ? Expanded(
                    child: ListsOverviewListView(list: _lists),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        "There are no template lists yet. Add one by pressing on Create New List",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  List<List<ShoppingList>> filterList(List<ShoppingList> lists) {
    List<List<ShoppingList>> filteredLists = List<List<ShoppingList>>();
    List<ShoppingList> templateLists = List<ShoppingList>();
    List<ShoppingList> regularLists = List<ShoppingList>();
    lists.forEach((list) {
      if (list.template) {
        templateLists.add(list);
      } else {
        regularLists.add(list);
      }
    });

    filteredLists.add(regularLists);
    filteredLists.add(templateLists);
    return filteredLists;
  }
}
