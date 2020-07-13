import 'package:ezshop/core/providers/shopping_item.dart';
import 'package:ezshop/locator.dart';
import 'package:ezshop/ui/screens/about_screen/about_screen.dart';
import 'package:ezshop/ui/screens/landing_screen/landing_screen.dart';
import 'package:ezshop/ui/screens/settings_screen/settings_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './core/providers/app_provider.dart';
import './core/providers/auth/auth.dart';
import './core/providers/shopping_lists.dart';
import 'ui/screens/auth_screen/auth_screen.dart';
import 'ui/screens/create_list_screen/create_list_screen.dart';
import 'ui/screens/list_detail_screen/list_detail_screen.dart';
import 'ui/screens/list_overview_screen/lists_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
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
        home: LandingScreen(),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ListsOverviewScreen.routeName: (ctx) => ListsOverviewScreen(),
          ListDetailScreen.routeName: (ctx) => ListDetailScreen(),
          CreateListScreen.routeName: (ctx) => CreateListScreen(),
          AboutScreen.routeName: (ctx) => AboutScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          LandingScreen.routeName: (ctx) => LandingScreen(),
        },
      ),
    );
  }
}
