import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/screens/list_overview_screen/widgets/create_new_list_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../widgets/main_side_drawer/main_side_drawer.dart';
import 'widgets/shopping_list_view_wrapper.dart';
import '../create_list_screen/create_list_screen.dart';
import 'widgets/search_list_form.dart';

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
        child: Column(
          children: <Widget>[
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
    final shoppingListsData = Provider.of<ShoppingLists>(context);
    AppMode appMode = Provider.of<AppProvider>(context).appMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                "Create New List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (appMode == AppMode.OpenSource) {
                  List<ShoppingList> lists =
                      await shoppingListsData.fetchLists(getTemplates: false);
                  if (lists != null &&
                      lists.length == Constants.MAXIMUM_NUMBER_OF_LISTS) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "You've reached your limit of ${Constants.MAXIMUM_NUMBER_OF_LISTS} lists. Try the full version for unlimited number of lists"),
                      ),
                    );
                    return;
                  }
                } else {
                  List<ShoppingList> templates =
                      await Provider.of<ShoppingLists>(context)
                          .fetchLists(getTemplates: true);
                  if (templates != null && templates.length > 0) {
                    final template = await showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        elevation: 10.0,
                        child: CreateNewListForm(),
                      ),
                    );

                    if (template == "none") {
                      openBlankList(context);
                    } else if (template is ShoppingList) {
                      openBlankList(context, template: template);
                    }
                  } else {
                    openBlankList(context);
                  }
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (ctx, app, _) => FlatButton.icon(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: Text(
                  "Search List",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  app.appMode == AppMode.Full
                      ? showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            elevation: 10.0,
                            child: SearchListForm(),
                          ),
                        ).then(
                          (val) {
                            Provider.of<ShoppingLists>(context)
                                .searchList(val)
                                .then(
                              (isFound) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: isFound
                                        ? Text(
                                            'Added a new shopping list to your shortlist')
                                        : Text(
                                            'Did not find any shopping list with the id $val'),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "This feature is not available in the open source version"),
                          ),
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void openBlankList(BuildContext context, {ShoppingList template}) {
    ShoppingList copy;
    if (template != null) {
      copy = ShoppingList.copy(template);
    }

    Navigator.of(context)
        .pushNamed(CreateListScreen.routeName, arguments: copy)
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
  }
}
