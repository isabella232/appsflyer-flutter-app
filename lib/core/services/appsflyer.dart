import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppsFlyerService {
  AppsflyerSdk _appsflyerSdk;

  AppsflyerSdk get appsFlyerSdk => _appsflyerSdk;

  Future initSdk(
      {AppsFlyerOptions options,
      bool registerOnAppOpenAttribution,
      bool registerConversionData}) {
    _appsflyerSdk = AppsflyerSdk(options);
    return _appsflyerSdk.initSdk(
        registerOnAppOpenAttributionCallback: registerOnAppOpenAttribution,
        registerConversionDataCallback: registerConversionData);
  }
}
