import 'package:ezshop/ui/widgets/main_side_drawer.dart';
import 'package:ezshop/ui/widgets/padding_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: MainSideDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: PaddedContent(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Show quantity"),
                Consumer<AppProvider>(
                  builder: (ctx, appProvider, _) {
                    return Switch(
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (val) {
                        appProvider.showQuantity = val;
                      },
                      value: appProvider.showQuantity,
                    );
                  },
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
