import 'package:badges/badges.dart';
import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/core/providers/auth/auth.dart';
import 'package:ezshop/ui/widgets/main_side_drawer/widgets/image_preview_dialog.dart';
import 'package:ezshop/ui/widgets/pick_image_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final userId = auth.getUser().userId;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Badge(
            badgeContent: ClipOval(
              child: Material(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    await addImage(context);
                  },
                  splashColor: Colors.red,
                ),
                color: Colors.black.withOpacity(
                  0.7,
                ),
              ),
            ),
            position: BadgePosition.bottomRight(),
            child: Consumer<AppProvider>(
              builder: (ctx, appProvider, _) {
                return FutureBuilder(
                  future: appProvider.getProfilePic(userId),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String url = snapshot.data;
                      if (url == null) {
                        return CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            size: 72,
                          ),
                          radius: Constants.AVATAR_RADIUS,
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            //Open image in a new dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return ImagePreviewDialog(url: url);
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: Image.network(
                              url,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: SpinKitDoubleBounce(
                                  color: Colors.white,
                                ));
                              },
                            ).image,
                            radius: Constants.AVATAR_RADIUS,
                          ),
                        );
                      }
                    } else {
                      return CircleAvatar(
                        radius: Constants.AVATAR_RADIUS,
                        child: Center(
                          child: SpinKitDoubleBounce(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            badgeColor: Colors.black.withOpacity(0.7),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              auth.getUser() != null ? auth.getUser().email : "",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Open BottomSheet for choosing the source of the photo that will be added
  Future addImage(ctx) async {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return PickImageToolbar();
      },
    );
  }
}
