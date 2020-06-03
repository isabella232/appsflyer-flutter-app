import 'package:ezshop/core/providers/auth/auth.dart';
import 'package:ezshop/core/providers/auth/auth_interface.dart';
import 'package:ezshop/ui/screens/auth_screen/auth_screen.dart';
import 'package:ezshop/ui/screens/list_overview_screen/lists_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = "/landing";

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) {
        Status _status = auth.authStatus;
        if (_status == Status.Authenticated ||
            _status == Status.OpenSourceUser) {
          return ListsOverviewScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
