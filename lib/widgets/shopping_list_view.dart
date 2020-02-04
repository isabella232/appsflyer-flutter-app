import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './list_overview_item.dart';
import '../models/shopping_list.dart';
import '../providers/shopping_lists.dart';

class ShoppingListView extends StatelessWidget {
  List<ShoppingList> _lists;

  @override
  Widget build(BuildContext context) {
    final shoppingListsData = Provider.of<ShoppingLists>(context);
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: shoppingListsData.fetchListsAsStream(),
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
            return StreamBuilder(
              stream: dataSnapshot.data,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  _lists = snapshot.data.documents
                      .map((doc) =>
                          ShoppingList.fromMap(doc.data, doc.documentID))
                      .toList();
                  if (_lists.length == 0) {
                    return _buildEmptyListPlaceholder(size);
                  }
                  return ListView.builder(
                    itemBuilder: (ctx, i) => ListOverviewItem(
                        _lists[i].id,
                        _lists[i].title,
                        _lists[i].items,
                        _lists[i].totalChecked()),
                    itemCount: _lists.length,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          }
        }
      },
    );
  }

  Widget _buildEmptyListPlaceholder(Size size) {
    return Center(
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
    );
  }
}
