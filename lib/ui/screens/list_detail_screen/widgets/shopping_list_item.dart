import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/widgets/main_side_drawer/widgets/image_preview_dialog.dart';
import 'package:ezshop/ui/widgets/pick_image_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingList shoppingList;
  final int index;
  final bool showQuantity;

  ShoppingListItem(this.shoppingList, this.index, this.showQuantity);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ShoppingItem>(context);
    final EdgeInsets itemPadding = shoppingList.template
        ? EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0)
        : EdgeInsets.all(8.0);
    double opacity = 1.0;

    return InkWell(
      onTap: () async {
        opacity = 0.0;
        item.toggleIsChecked();
        writeToDb(context);
      },
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: opacity,
            child: Container(
              color: index % 2 == 0
                  ? Colors.white
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: <Widget>[
                  item.imgUrl != null
                      ? GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(item.imgUrl),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return ImagePreviewDialog(
                                  url: item.imgUrl,
                                  canEdit: true,
                                  item: item,
                                  listId: shoppingList.id,
                                );
                              },
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  addItemImage(context, item);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Visibility(
                    child: Checkbox(
                      onChanged: (val) async {
                        item.toggleIsChecked();
                        await Provider.of<ShoppingLists>(context)
                            .updateList(shoppingList, shoppingList.id);
                      },
                      value: item.isChecked,
                    ),
                    visible: !shoppingList.template,
                  ),
                  Expanded(
                    child: Padding(
                      padding: itemPadding,
                      child: Text(
                        item.name,
                        style: TextStyle(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ),
                  Spacer(),
                  showQuantity
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "x" + item.quantity.toString(),
                          ),
                        )
                      : Center()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addItemImage(BuildContext ctx, ShoppingItem item) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return PickImageToolbar(
          item: item,
          listId: shoppingList.id,
        );
      },
    ).then((val) async {
      writeToDb(ctx);
    });
  }

  Future<void> writeToDb(BuildContext ctx) async {
    await Provider.of<ShoppingLists>(ctx)
        .updateList(shoppingList, shoppingList.id);
  }
}
