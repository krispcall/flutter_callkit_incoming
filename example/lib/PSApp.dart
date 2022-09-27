import "dart:convert";

import "package:easy_dynamic_theme/easy_dynamic_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:local_rollbar/flutter_rollbar.dart";
import "package:mvp/AppConfig.dart";
import "package:mvp/AppConstant.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/config/Router.dart" as router;
import "package:mvp/constant/Constants.dart";
import "package:mvp/provider/ps_provider_dependencies.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:no_context_navigation/no_context_navigation.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stetho_a1/flutter_stetho.dart";
import "package:voice/twiliovoice.dart";
import "package:web_socket_channel/web_socket_channel.dart";

VoiceClient voiceClient = VoiceClient("abc");
WebSocketChannel? channel;
const iOSLocalizedLabels = false;

Future<void> backgroundRollbarInit() async {
  var accessToken = Const.ROLLBAR_CONFIGURATION;
  SharedPreferences preferences = await Utils.getSharedPreference();
  var env = preferences.getString(AppConstant.ENVIRONMENT.name);

  if (env == AppConstant.PRODUCTION.name) {
    accessToken = Const.ROLLBAR_CONFIGURATION_PRODUCTION;
  } else if (env == AppConstant.MVP.name) {
    accessToken = Const.ROLLBAR_CONFIGURATION_MVP;
  } else {
    accessToken = Const.ROLLBAR_CONFIGURATION;
  }

  Rollbar()
    ..accessToken = accessToken
    ..environment = env.toString().split(".").last;
  await RollbarLogging().initialize();
}

Future<RollbarPerson?> getPerson() async {
  final SharedPreferences preferences = await Utils.getSharedPreference();

  final userEmail = preferences.getString(Const.VALUE_HOLDER_USER_EMAIL);
  final userName = preferences.getString(Const.VALUE_HOLDER_USER_NAME);

  return RollbarPerson(id: userEmail, email: userEmail, username: userName);
}

Future<String> getWorkspaceChannelInfoBackgroundRollbar() async {
  String data = "";
  try {
    final SharedPreferences psSharePref = await Utils.getSharedPreference();
    final memberId = psSharePref.getString(Const.VALUE_HOLDER_MEMBER_ID);
    final userEmail = psSharePref.getString(Const.VALUE_HOLDER_USER_EMAIL);
    final LoginWorkspace currentWorkSpace = LoginWorkspace.fromJson(
        jsonDecode(psSharePref.getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL)!)
            as Map<String, dynamic>);
    final WorkspaceChannel defaultChannel = WorkspaceChannel.fromJson(
        jsonDecode(psSharePref.getString(Const.VALUE_HOLDER_DEFAULT_CHANNEL)!)
            as Map<String, dynamic>);

    const String info = "\n\n**********INFO**********\n";
    final String userEmailData = "Email id:- $userEmail";
    final String memberIdData = "Member id:- $memberId";
    final String workSpaceData =
        "WorkSpace id:- ${currentWorkSpace.id} \nWorkspace name:- ${currentWorkSpace.title}";
    final String defaultChannelData =
        "Channel id:- ${defaultChannel.id} \nChannel name:- ${defaultChannel.name} \nChannel number:- ${defaultChannel.number}";
    data =
        "$info \n$userEmailData  \n$memberIdData \n$workSpaceData \n$defaultChannelData";
  } catch (e) {
    data = "";
  }
  return data;
}

class PSApp extends StatelessWidget {
  static AppConfig? config;
  static Rollbar? rollbar;

  @override
  Widget build(BuildContext context) {
    config = AppConfig.of(context);
    configRollBar();
    if (kDebugMode) {
      Stetho.initialize();
    }
    CustomColors.loadColor(context);
    return MultiProvider(
      providers: <SingleChildWidget>[
        ...providers,
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (child, __) {
          return GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "KrispCall Mvp",
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: EasyDynamicTheme.of(context).themeMode,
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                EasyLocalization.of(context)!.delegate,
              ],
              navigatorKey: NavigationService.navigationKey,
              supportedLocales: EasyLocalization.of(context)!.supportedLocales,
              locale: EasyLocalization.of(context)!.locale,
              initialRoute: "/",
              routes: router.routes,
              builder: (BuildContext? context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context!).copyWith(textScaleFactor: 1),
                  child: AppBuilder(
                    builder: (context) {
                      return child!;
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> configRollBar() async {
    SharedPreferences preferences = await Utils.getSharedPreference();
    if (config!.nameConfig == AppConstant.PRODUCTION) {
      preferences.setString(
          AppConstant.ENVIRONMENT.name, AppConstant.PRODUCTION.name);

      ///https://rollbar.com/krispcall/Mobile_Production/
      Rollbar()
        ..accessToken = Const.ROLLBAR_CONFIGURATION_PRODUCTION
        ..environment = config!.nameConfig.toString().split(".").last;
      await RollbarLogging().initialize();
    } else if (config!.nameConfig == AppConstant.MVP) {
      preferences.setString(AppConstant.ENVIRONMENT.name, AppConstant.MVP.name);

      ///https://rollbar.com/krispcall/Mobile_Production/
      Rollbar()
        ..accessToken = Const.ROLLBAR_CONFIGURATION_MVP
        ..environment = config!.nameConfig.toString().split(".").last;
      await RollbarLogging().initialize();
    } else {
      preferences.setString(AppConstant.ENVIRONMENT.name, AppConstant.QA.name);
      Rollbar()
        ..accessToken = Const.ROLLBAR_CONFIGURATION
        ..environment = config!.nameConfig.toString().split(".").last;
      await RollbarLogging().initialize();
    }
  }
}

class AppBuilder extends StatefulWidget {
  final Widget Function(BuildContext)? builder;

  const AppBuilder({Key? key, this.builder}) : super(key: key);

  @override
  AppBuilderState createState() => AppBuilderState();

  static AppBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppBuilderState>();
  }
}

class AppBuilderState extends State<AppBuilder> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context);
  }

  void rebuild() {
    setState(() {});
  }
}
