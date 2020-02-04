import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_lists.dart';
import '../widgets/main_side_drawer.dart';
import '../widgets/shopping_list_view.dart';
import './create_list_screen.dart';
import '../widgets/search_list_form.dart';

class ListsOverviewScreen extends StatelessWidget {
  static final String routeName = '/lists-overview-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      drawer: MainSideDrawer(),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text("My Lists"),
            Expanded(
              child: ShoppingListView(),
            ),
            BottomBarListButtons()
          ],
        ),
      ),
    );
  }
}

class BottomBarListButtons extends StatelessWidget {
  const BottomBarListButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).primaryColorLight,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Create New List"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreateListScreen.routeName)
                    .then(
                  (val) {
                    if (val != null) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added the list $val'),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FlatButton.icon(
              icon: Icon(Icons.search),
              label: Text("Search List"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    elevation: 10.0,
                    child: SearchListForm(),
                  ),
                ).then((val) {
                  Provider.of<ShoppingLists>(context)
                      .searchList(val)
                      .then((isFound) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: isFound
                          ? Text('Added a new shopping list to your shortlist')
                          : Text(
                              'Did not find any shopping list with the id $val'),
                    ));
                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
