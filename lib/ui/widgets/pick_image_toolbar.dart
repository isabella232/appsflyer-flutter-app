import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/ui/screens/photo_screen/photo_screen.dart';
import 'package:ezshop/ui/widgets/text_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PickImageToolbar extends StatelessWidget {
  final picker = ImagePicker();
  AppProvider _appProvider;
  final ShoppingItem item;
  final String listId;

  PickImageToolbar({this.item, this.listId = ""});

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    return Wrap(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextIconBtn(
                iconData: Icons.camera_alt,
                btnText: "Camera",
                onTap: () async {
                  onBtnClick(context, ImageSource.camera);
                },
              ),
              TextIconBtn(
                iconData: Icons.image,
                btnText: "Gallery",
                onTap: () async {
                  onBtnClick(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  onBtnClick(BuildContext context, ImageSource imageSource) async {
    final pickedFile = await getImage(imageSource);
    if (pickedFile != null) {
      _openPictureDialog(context, pickedFile);
    }
  }

  Future<PickedFile> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    return pickedFile;
  }

  void _openPictureDialog(BuildContext ctx, PickedFile pickedFile) {
    PhotoMode photoMode = item != null ? PhotoMode.Item : PhotoMode.Profile;
    String fileName;
    if (item != null) {
      fileName = '$listId/${item.itemId}';
    }

    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PhotoDialogScreen(
          pickedFile: pickedFile.path,
          photoMode: photoMode,
          fileName: fileName,
        );
      },
    ).then((val) async {
      //Refresh the profile picture
      if (photoMode == PhotoMode.Profile) {
        _appProvider.notifyUser();
      } else {
        if (val != null) {
          //if null user aborted the upload or clicked out of the dialog
          item.addImg(val, listId);
        }
      }
    });
  }
}
