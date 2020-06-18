import 'package:ezshop/constants.dart';
import 'package:ezshop/core/services/appsflyer.dart';
import 'package:ezshop/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:global_configuration/global_configuration.dart';

enum AppMode { Full, OpenSource }
enum AppsFlyerSdkMode { Uninitialized, Initialized }

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
  AppsFlyerSdkMode appsFlyerSdkMode = AppsFlyerSdkMode.Uninitialized;
  var appsFlyerService = locator<AppsFlyerService>();

  bool _showQuantity = true;

  bool get showQuantity {
    return _showQuantity;
  }

  set showQuantity(bool show) {
    _showQuantity = show;
    notifyListeners();
  }

  AppProvider() {
    _initAppsFylerSdk().then((_) {
      _getConversionData();
    });

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

  Future _initAppsFylerSdk() async {
    await GlobalConfiguration().loadFromAsset('app_settings');
    AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: GlobalConfiguration().getString('devKey'),
      showDebug: true,
      appId: GlobalConfiguration().getString('appId'),
    );

    await appsFlyerService.initSdk(
        options: options,
        registerConversionData: true,
        registerOnAppOpenAttribution: true);

    appsFlyerSdkMode = AppsFlyerSdkMode.Initialized;
    notifyListeners();
    return;
  }

  void _getConversionData() {
    appsFlyerService.appsFlyerSdk.conversionDataStream.listen((data) {
      //handle conversion data here
      print(data);
    });

    appsFlyerService.appsFlyerSdk.appOpenAttributionStream.listen((data) {
      //handle on app open attribution here
      print(data);
    });
  }
}
