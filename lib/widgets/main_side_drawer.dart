import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';
import '../screens/about_screen.dart';
import '../screens/lists_overview_screen.dart';

class MainSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(12.0),
            child: Consumer<Auth>(
              builder: (ctx, auth, _) {
                print(auth.user.email);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(
                        Icons.perm_identity,
                        size: 72,
                      ),
                      radius: 44,
                    ),
                    Text(
                      auth.user.email,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          _buildMenuListItem(
              context, ListsOverviewScreen.routeName, Icons.list, 'My lists'),
          _buildMenuListItem(
              context, AboutScreen.routeName, Icons.info, 'About'),
          Divider(),
          _buildLogOutItem(context),
        ],
      ),
    );
  }

  ListTile _buildLogOutItem(BuildContext context) {
    return ListTile(
      onTap: () async {
        await Provider.of<Auth>(context, listen: false).signOut();
        Navigator.of(context).pop();
      },
      title: Text('Log out'),
      leading: Icon(
        Icons.exit_to_app,
      ),
    );
  }

  ListTile _buildMenuListItem(
      BuildContext context, String routeName, IconData icon, String text) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      title: Text(text),
      leading: Icon(
        icon,
      ),
    );
  }
}
