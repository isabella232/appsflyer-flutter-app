import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../providers/shopping_lists.dart';
import '../widgets/shopping_list_item.dart';
import '../models/shopping_list.dart';
import './create_list_screen.dart';

///This class is responsible of the ui of the detailed list screen
///From this screen you can edit the chosen list
///You get the list id as an argument
class ListDetailScreen extends StatelessWidget {
  static final String routeName = '/list-detail-screen';

  @override
  Widget build(BuildContext context) {
    ShoppingList shoppingList;
    final listId = ModalRoute.of(context).settings.arguments as String;

    return FutureBuilder(
      future: Provider.of<ShoppingLists>(context).getListById(listId),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          if (dataSnapshot.error != null) {
            return buildErrorWidget();
          } else {
            shoppingList = dataSnapshot.data as ShoppingList;
            return Scaffold(
              appBar: AppBar(
                title: Text(shoppingList.title),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        CreateListScreen.routeName,
                        arguments: {
                          'edit': true,
                          'shoppingListId': shoppingList.id,
                        },
                      );
                    },
                  ),
                ],
              ),
              bottomNavigationBar: Builder(
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
                                content:
                                    Text("This feature is not yet available"),
                              ),
                            );
//                          Share.share('sharing',
//                              subject: 'sharing from EZShop');
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
              ),
              body: ListView.builder(
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: shoppingList.items[i],
                  child: ShoppingListItem(shoppingList),
                ),
                itemCount: shoppingList.items.length,
              ),
            );
          }
        }
      },
    );
  }

  Scaffold buildErrorWidget() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("an error occurred"),
      ),
    );
  }

  Scaffold buildLoadingWidget() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 12,
            ),
            Text("Loading..."),
          ],
        ),
      ),
    );
  }
}
