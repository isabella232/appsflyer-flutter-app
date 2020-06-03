import 'package:ezshop/core/models/shopping_list.dart';
import 'package:flutter/material.dart';

class BottomShareList extends StatelessWidget {
  final ShoppingList shoppingList;

  BottomShareList({@required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SelectableText(
                shoppingList.id,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              IconButton(
                onPressed: () {
                  Scaffold.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text("This feature is not yet available"),
                    ),
                  );
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
