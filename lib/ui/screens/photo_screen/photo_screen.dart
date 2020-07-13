import 'dart:io';

import 'package:ezshop/core/providers/auth/auth.dart';
import 'package:ezshop/ui/screens/photo_screen/uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import 'package:ezshop/ui/widgets/text_icon_btn.dart';
import 'package:ezshop/constants.dart';
import 'package:ezshop/core/providers/app_provider.dart';

enum PhotoMode { Profile, Item }

class PhotoDialogScreen extends StatefulWidget {
  final String pickedFile;
  final PhotoMode photoMode;
  final String fileName;

  PhotoDialogScreen(
      {@required this.pickedFile, @required this.photoMode, this.fileName});

  @override
  _PhotoDialogScreenState createState() => _PhotoDialogScreenState();
}

class _PhotoDialogScreenState extends State<PhotoDialogScreen> {
  String _pickedFile;
  bool _isUploading = false;
  StorageUploadTask _uploadTask;
  String _downloadUrl;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_downloadUrl);
        return Future.value(true);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.DIALOG_BORDER_RADIUS),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Constants.DIALOG_BORDER_RADIUS),
          ),
          child: Wrap(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: _isUploading ? 0.4 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constants.DIALOG_BORDER_RADIUS),
                        ),
                        child: Image.file(
                          File(
                            _pickedFile != null
                                ? _pickedFile
                                : widget.pickedFile,
                          ),
                        ),
                      ),
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Consumer<Auth>(
                          builder: (ctx, auth, _) {
                            return AnimatedOpacity(
                              opacity: _isUploading ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Uploader(
                                _uploadTask,
                                () {
                                  onComplete(
                                      appProvider, auth.getUser().userId);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                _buildBottomBar(appProvider)
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Row _buildBottomBar(AppProvider appProvider) {
    return Row(
      children: <Widget>[
        TextIconBtn(
          iconData: Icons.crop,
          btnText: "Crop",
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Constants.DIALOG_BORDER_RADIUS),
          ),
          onTap: () {
            _cropImage();
          },
        ),
        Consumer<Auth>(builder: (ctx, auth, _) {
          return TextIconBtn(
            iconData: Icons.save,
            btnText: "Save",
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Constants.DIALOG_BORDER_RADIUS),
            ),
            onTap: () {
              _saveImage(appProvider, auth.getUser().userId);
            },
          );
        }),
      ],
    );
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _pickedFile != null ? _pickedFile : widget.pickedFile,
      compressFormat: ImageCompressFormat.jpg,
    );
    if (cropped != null) {
      setState(() {
        _pickedFile = cropped.path;
      });
    }
  }

  Future<void> _saveImage(AppProvider appProvider, String userId) async {
    //Compress image file before uploading to Firebase
    _pickedFile = _pickedFile != null ? _pickedFile : widget.pickedFile;
    var compressedImage = await FlutterImageCompress.compressAndGetFile(
      _pickedFile,
      _pickedFile.substring(0, _pickedFile.length - 4) + "compressed.jpg",
      quality: 70,
    );

    String uploadFileName = getFileName(userId);

    setState(() {
      _isUploading = true;
      _uploadTask = appProvider.uploadImage(uploadFileName, compressedImage);
    });
  }

  String getFileName(String userId) {
    return widget.photoMode == PhotoMode.Profile
        ? '$userId/profile'
        : widget.fileName;
  }

  onComplete(AppProvider appProvider, String userId) async {
    _downloadUrl = await appProvider.getFileUrl(getFileName(userId) + ".png");
  }
}
