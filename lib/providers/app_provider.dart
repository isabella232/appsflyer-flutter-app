import 'package:ezshop/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;

enum AppMode { Full, OpenSource }

class AppModeHelper {
  static String getValue(AppMode appMode) {
    switch (appMode) {
      case AppMode.Full:
        return "Full Version";
        break;
      case AppMode.OpenSource:
        return "Open Source Version";
        break;
    }
  }
}

class AppProvider with ChangeNotifier {
  AppMode appMode;

  AppProvider() {
    //Todo: Add AppsFlyerSDK
    if (_hasFirebase()) {
      appMode = AppMode.Full;
    } else {
      appMode = AppMode.OpenSource;
    }

    notifyListeners();
  }

  bool _hasFirebase() {
    return Constants.HAS_FIREBASE;
  }
}
