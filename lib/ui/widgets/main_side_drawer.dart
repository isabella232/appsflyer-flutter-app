import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/core/providers/auth/auth.dart';
import 'package:ezshop/ui/screens/about_screen/about_screen.dart';
import 'package:ezshop/ui/screens/landing_screen/landing_screen.dart';
import 'package:ezshop/ui/screens/list_overview_screen/lists_overview_screen.dart';
import 'package:ezshop/ui/screens/settings_screen/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

const DRAWER_HEIGHT = 240.0;

class MainSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: DRAWER_HEIGHT,
            child: Consumer<Auth>(
              builder: (ctx, auth, _) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/supermarket-background.jpg',
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              size: 72,
                            ),
                            radius: 44,
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Text(
                              auth.getUser() != null
                                  ? auth.getUser().email
                                  : "",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildMenuListItem(
              context, ListsOverviewScreen.routeName, Icons.list, 'My lists'),
          _buildMenuListItem(
              context, SettingsScreen.routeName, Icons.settings, 'Settings'),
          _buildMenuListItem(
              context, AboutScreen.routeName, Icons.info, 'About'),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          _buildLogOutItem(context),
        ],
      ),
    );
  }

  ListTile _buildLogOutItem(BuildContext context) {
    return ListTile(
      onTap: () async {
        if (Provider.of<AppProvider>(context, listen: false).appMode ==
            AppMode.OpenSource) {
          Navigator.of(context).pop();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Cant logout, you are on Open Source version"),
          ));
          return;
        }
        Provider.of<Auth>(context, listen: false).signOut();
        Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
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
        Navigator.of(context).popAndPushNamed(routeName);
      },
      title: Text(text),
      leading: Icon(
        icon,
      ),
    );
  }
}
