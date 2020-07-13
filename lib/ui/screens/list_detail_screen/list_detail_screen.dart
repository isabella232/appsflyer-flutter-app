import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/screens/list_detail_screen/widgets/bottom_share_list.dart';
import 'package:ezshop/ui/screens/list_detail_screen/widgets/shopping_list_detail_view.dart';
import 'package:ezshop/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../create_list_screen/create_list_screen.dart';

enum Mode { All, Unchecked, Checked }

///This class is responsible of the ui of the detailed list screen
///From this screen you can edit the chosen list
///You get the list id as an argument
class ListDetailScreen extends StatefulWidget {
  static final String routeName = '/list-detail-screen';

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  Mode _mode;

  @override
  void initState() {
    super.initState();
    _mode = Mode.Unchecked;
  }

  @override
  Widget build(BuildContext context) {
    ShoppingList shoppingList;
    final listId = ModalRoute.of(context).settings.arguments as String;

    return FutureBuilder(
      future: Provider.of<ShoppingLists>(context, listen: false)
          .getListById(listId),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
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
              bottomNavigationBar: BottomShareList(
                shoppingList: shoppingList,
              ),
              body: Column(
                children: <Widget>[
                  Visibility(
                    child: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: buildModeRow(context),
                    ),
                    visible: !shoppingList.template,
                  ),
                  Expanded(
                    child: Consumer<ShoppingLists>(
                      builder: (BuildContext ctx, shoppingLists, _) {
                        return FutureBuilder(
                          future: shoppingLists.getListById(listId),
                          builder: (BuildContext ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ShoppingListDetailView(
                                mode: _mode,
                                shoppingList: shoppingList,
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              //return loader
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SpinKitDoubleBounce(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text("Loading..."),
                                ],
                              );
                            }
                            return Center();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Row buildModeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_mode != Mode.All) {
                setState(() {
                  _mode = Mode.All;
                });
              }
            },
            child: Container(
              child: Center(
                child: Text(
                  "All",
                  style: TextStyle(
                    color: _mode == Mode.All ? Colors.white : Colors.black,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: _mode == Mode.All
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_mode != Mode.Unchecked) {
                setState(() {
                  _mode = Mode.Unchecked;
                });
              }
            },
            child: Container(
              child: Center(
                child: Text(
                  "Unchecked",
                  style: TextStyle(
                    color:
                        _mode == Mode.Unchecked ? Colors.white : Colors.black,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: _mode == Mode.Unchecked
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
              padding: EdgeInsets.all(11),
              margin: EdgeInsets.only(left: 1),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_mode != Mode.Checked) {
                setState(() {
                  _mode = Mode.Checked;
                });
              }
            },
            child: Container(
                child: Center(
                  child: Text(
                    "Checked",
                    style: TextStyle(
                      color:
                          _mode == Mode.Checked ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: _mode == Mode.Checked
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.all(11),
                margin: EdgeInsets.only(left: 1)),
          ),
        ),
      ],
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
}
