import "dart:async";

import "package:android_alarm_manager_plus/android_alarm_manager_plus.dart";
import "package:easy_dynamic_theme/easy_dynamic_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_libphonenumber/flutter_libphonenumber.dart";
// import "package:flutter_stetho/flutter_stetho.dart";
import "package:mvp/AppConfig.dart";
import "package:mvp/AppConstant.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/viewObject/common/Language.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await FlutterLibphonenumber().init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  FirebaseMessaging.instance.setAutoInitEnabled(false);
  // GestureBinding.instance.resamplingEnabled = false;
  AndroidAlarmManager.initialize();
  // if (kDebugMode) {
  //   Stetho.initialize();
  // }
  // AwesomeNotificationInit.awesomeNotificationInit();

  final configuredApp = AppConfig(
    liveUrl: "https://dev.inboxsure.com/api/v1/graphql/",
    socketUrl: "wss://dev.inboxsure.com/api/v1/graphql",
    appSubscriptionEndpoint: "wss://dev.inboxsure.com/api/v1/graphql/ws",
    imageUrl: "https://dev.inboxsure.com",
    countryLogoUrl: "https://krispcall-prod.sgp1.digitaloceanspaces.com",
    nameConfig: AppConstant.DEVELOPMENT,
    child: EasyLocalization(
      // data: data,
      // assetLoader: CsvAssetLoader(),
      path: "assets/langs",
      supportedLocales: getSupportedLanguages(),
      child: EasyDynamicThemeWidget(
        child: PSApp(),
      ),
    ),
  );
  // runZonedGuarded(()
  // {
  runApp(configuredApp);
  // }, FirebaseCrashlytics.instance.recordError);
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in Config.psSupportedLanguageMap.values.toList()) {
    localeList.add(Locale(lang.languageCode!, lang.countryCode));
  }
  return localeList;
}

