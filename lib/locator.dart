import 'package:get_it/get_it.dart';

import './core/services/appsflyer.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppsFlyerService());
}
