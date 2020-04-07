import 'package:ezshop/providers/shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_lists.dart';
import '../widgets/items_list_overview.dart';
import '../models/shopping_list.dart';

class CreateListScreen extends StatefulWidget {
  static final String routeName = "/create-list";

  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

enum Mode {
  CreateMode,
  EditMode,
}

class _CreateListScreenState extends State<CreateListScreen> {
  final _listForm = GlobalKey<FormState>();
  final _itemForm = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  final _itemQtyFocusNode = FocusNode();
  ShoppingList shoppingList;
  bool _firstRun = true;
  String listId;
  String listName;
  Mode mode;
  final itemToAdd = {
    'itemName': '',
    'quantity': 0,
  };

  @override
  void dispose() {
    _itemQtyFocusNode.dispose();
    _listNameController.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) async {
    final isValid = _listForm.currentState.validate();
    if (!isValid) {
      return;
    }

    List<ShoppingItem> items =
        await Provider.of<ShoppingLists>(context).getItems(listId);

    if (items.length == 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Cannot create list. Your list is empty"),
        ),
      );
      return;
    }

    _listForm.currentState.save();

    await Provider.of<ShoppingLists>(context).addList(listId, listName);
    Navigator.of(context).pop(listName);
  }

  void _saveItemForm(BuildContext context) async {
    final isValid = _itemForm.currentState.validate();
    if (!isValid) {
      return;
    }

    _itemForm.currentState.save();
    _itemForm.currentState.reset();
    await Provider.of<ShoppingLists>(context).addItem(
        listId, itemToAdd['itemName'], int.parse(itemToAdd['quantity']));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      final data = ModalRoute.of(context).settings.arguments as Map;
      if (data != null) {
        shoppingList = await Provider.of<ShoppingLists>(context)
            .getListById(data['shoppingListId']);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map;
    if (data != null) {
      mode = Mode.EditMode;
    } else {
      mode = Mode.CreateMode;
    }

    if (shoppingList != null) {
      listId = shoppingList.id;
      _listNameController.text = shoppingList.title;
    }

    if (mode == Mode.CreateMode) {
      if (_firstRun) {
        final shoppingListsData = Provider.of<ShoppingLists>(context);
        listId = shoppingListsData.createList();
      }
      _firstRun = false;
    }

    return WillPopScope(
      onWillPop: () => mode == Mode.CreateMode
          ? showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Are you sure you want to exit?"),
                content: Text("All of the data will be dicarded"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      if (mode == Mode.CreateMode) {
                        Provider.of<ShoppingLists>(context).removeList(listId);
                      }
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  )
                ],
              ),
            )
          : Future.delayed(Duration.zero).then((_) => true),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create new list"),
          actions: <Widget>[
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  _saveForm(ctx);
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      _buildForm(context),
                      _buildItemForm(context),
                      SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: listId == null ? Container() : ItemsListOverview(listId),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _listForm,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "List name",
            ),
            validator: (val) {
              if (val.isEmpty) {
                return "List name cannot be empty";
              } else {
                return null;
              }
            },
            controller: _listNameController,
            onSaved: (val) {
              listName = val;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }

  Form _buildItemForm(BuildContext context) {
    return Form(
      key: _itemForm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _buildItemNameField(),
                _buildQuantityField(context),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          _buildSubmitBtn(context)
        ],
      ),
    );
  }

  TextFormField _buildItemNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Item name",
      ),
      validator: (val) {
        if (val.isEmpty) {
          return "Item name cannot be empty";
        } else {
          return null;
        }
      },
      initialValue: "",
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        _itemQtyFocusNode.requestFocus();
      },
      onSaved: (val) {
        itemToAdd['itemName'] = val;
      },
    );
  }

  TextFormField _buildQuantityField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Item quantity",
      ),
      keyboardType: TextInputType.number,
      focusNode: _itemQtyFocusNode,
      validator: (val) {
        if (val.isEmpty) {
          return "Quantity cannot be empty";
        } else if (int.tryParse(val) == null) {
          return "Not a valid number";
        } else if (int.parse(val) <= 0) {
          return "Quantity has to be greater than zero";
        } else {
          return null;
        }
      },
      initialValue: "1",
      onFieldSubmitted: (_) {
        _saveItemForm(context);
      },
      onSaved: (val) {
        itemToAdd['quantity'] = val;
      },
    );
  }

  RaisedButton _buildSubmitBtn(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {
        //close the keyboard by getting focus on new node
        FocusScope.of(context).requestFocus(FocusNode());
        _saveItemForm(context);
      },
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.add_box,
            color: Colors.white,
          ),
          Text(
            "Add item",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
