import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:ezshop/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/lists_overview_screen.dart';
import './screens/list_detail_screen.dart';
import './screens/create_list_screen.dart';
import './screens/auth_screen.dart';
import './screens/about_screen.dart';
import './providers/auth/auth.dart';
import './providers/shopping_lists.dart';
import './providers/auth/auth_interface.dart';
import './providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppProvider(),
        ),
        ChangeNotifierProxyProvider<AppProvider, Auth>(
          create: (_) => Auth(),
          update: (_, app, auth) => auth..instance = app.appMode,
        ),
        ChangeNotifierProxyProvider<Auth, ShoppingLists>(
          create: (_) => ShoppingLists(),
          update: (_, auth, lists) {
            lists..user = auth.getUser();
            return lists..appMode = auth.appMode;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Shopping list',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amber,
          fontFamily: 'Lato',
        ),
        home: Consumer<Auth>(builder: (ctx, auth, _) {
          Status _status = auth.getStatus();
          return _status == Status.Authenticated ||
                  _status == Status.OpenSourceUser
              ? ListsOverviewScreen()
              : AuthScreen();
        }),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ListsOverviewScreen.routeName: (ctx) => ListsOverviewScreen(),
          ListDetailScreen.routeName: (ctx) => ListDetailScreen(),
          CreateListScreen.routeName: (ctx) => CreateListScreen(),
          AboutScreen.routeName: (ctx) => AboutScreen(),
        },
      ),
    );
  }
}
