import 'package:ezshop/ui/widgets/main_side_drawer.dart';
import 'package:ezshop/ui/widgets/padding_content.dart';
import 'package:flutter/material.dart';

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
              children: <Widget>[
                Text("Show quantity"),
                Switch(
                  onChanged: (val) {},
                  value: true,
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
