import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/screens/create_list_screen/create_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CreateNewListForm extends StatefulWidget {
  @override
  _CreateNewListFormState createState() => _CreateNewListFormState();
}

class _CreateNewListFormState extends State<CreateNewListForm> {
  final _form = GlobalKey<FormState>();
  int selectedIndex = -1;
  List<ShoppingList> templates = List<ShoppingList>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      templates = await Provider.of<ShoppingLists>(context)
          .fetchLists(getTemplates: true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Create new List from a template",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer<ShoppingLists>(builder: (ctx, shopListsProvider, _) {
              return Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, i) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = i;
                      });
                    },
                    child: Container(
                      color: i == selectedIndex
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            templates[i].title,
                            style: TextStyle(
                              color: i == selectedIndex
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${templates[i].items.length.toString()} items',
                            style: TextStyle(
                              color: i == selectedIndex
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                  ),
                  itemCount: templates.length,
                ),
              );
            }),
            Spacer(),
            Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: Text(
                        "Create from template",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedIndex == -1
                              ? Colors.white54
                              : Colors.white,
                        ),
                      ),
                      onPressed: selectedIndex == -1
                          ? null
                          : () {
                              Navigator.of(context)
                                  .pop(templates[selectedIndex]);
                            },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Text(
                        "Create from scratch",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop("none");
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
