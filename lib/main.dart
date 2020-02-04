import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import './screens/lists_overview_screen.dart';
import './screens/list_detail_screen.dart';
import './screens/create_list_screen.dart';
import './screens/auth_screen.dart';
import './screens/about_screen.dart';
import './providers/auth.dart';
import './providers/shopping_lists.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('app_settings');
  //Set up appsflyer sdk
  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: GlobalConfiguration().getString("devKey"),
    appId: GlobalConfiguration().getString("appId"),
    showDebug: true,
  );
  runApp(MyApp(appsFlyerOptions: options));
}

class MyApp extends StatelessWidget {
  AppsflyerSdk appsflyerSdk;

  MyApp({appsFlyerOptions}) {
    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth.instance(),
        ),
        ChangeNotifierProxyProvider<Auth, ShoppingLists>(
          create: (_) => ShoppingLists(),
          update: (_, auth, lists) => lists..firebaseUser = auth.user,
        ),
      ],
      child: MaterialApp(
        title: 'Shopping list',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amber,
          fontFamily: 'Lato',
        ),
        home: Consumer<Auth>(
          builder: (ctx, auth, _) =>
              auth.user == null ? AuthScreen() : ListsOverviewScreen(),
        ),
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
