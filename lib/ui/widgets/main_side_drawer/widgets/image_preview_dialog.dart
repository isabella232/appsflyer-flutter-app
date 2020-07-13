import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/core/providers/shopping_lists.dart';
import 'package:ezshop/ui/widgets/pick_image_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagePreviewDialog extends StatelessWidget {
  final String url;
  final bool canEdit;
  final ShoppingItem item;
  final String listId;

  ImagePreviewDialog({this.url, this.canEdit = false, this.listId, this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: <Widget>[
          Consumer<ShoppingLists>(
            builder: (ctx, shoppingLists, _) {
              return Stack(
                children: <Widget>[
                  Image.network(
                    item != null ? item.imgUrl : url,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Visibility(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return PickImageToolbar(
                                  item: item,
                                  listId: listId,
                                );
                              },
                            ).then(
                              (val) {
                                shoppingLists.notify();
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            color: Colors.black.withOpacity(
                              0.7,
                            ),
                            child: Wrap(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        visible: canEdit,
                      ),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
