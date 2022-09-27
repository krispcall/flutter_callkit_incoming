import "dart:collection";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:awesome_notifications/android_foreground_service.dart";
import "package:awesome_notifications/awesome_notifications.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:launch_review/launch_review.dart";
import "package:libphonenumber/libphonenumber.dart";
import 'package:local_rollbar/flutter_rollbar.dart';
import "package:mvp/PSApp.dart";
import "package:mvp/RollbarConstant.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/notification/NotificationMessage.dart";
import "package:package_info/package_info.dart";
// import "package:rollbar_dart/src/api/payload/level.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:url_launcher/url_launcher.dart";

class Utils {
  Utils._();

  static String getString(String key) {
    if (key != "") {
      return tr(key);
    } else {
      return "";
    }
  }

  static DateTime? previous;

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    return InternetConnectionChecker().hasConnection;
  }

  static Future<Stream<InternetConnectionStatus>>
      checkInternetConnectivityStatus() async {
    return InternetConnectionChecker().onStatusChange;
  }

  static dynamic launchURL() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String url =
        "https://play.google.com/store/apps/details?id=${packageInfo.packageName}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNotchHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static dynamic showNotificationWithActionButtons(
      NotificationMessage notificationMessage) async {
    final String contact = notificationMessage.data!.twiFrom!;
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        channelName: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        channelDescription: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: false,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: highVibrationPattern,
      ),
    );

    cPrint("Incoming call Payload ${notificationMessage.data!.toJson()}");
    AndroidForegroundService.startForeground(
      content: NotificationContent(
        id: Const.NOTIFICATION_CHANNEL_ID_CALL_INCOMING,
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        title: "Krispcall Audio",
        body: contact,
        payload: notificationMessage.data!.toJson(),

        category: NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,

        locked: true,
        showWhen: true,
        // createdDate: DateTime.now().toString(),
        // createdSource: NotificationSource.Firebase,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: false,

        // category: NotificationCategory.Call
      ),
      actionButtons: [
        NotificationActionButton(
          key: "reject",
          label: "Reject",
          autoDismissible: true,
        ),
        NotificationActionButton(
            key: "accept", label: "Accept", autoDismissible: false)
      ],
    );
  }

  static dynamic showCallInProgressNotificationOutgoing() async {
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
        channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
        channelDescription:
            Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: false,
        locked: true,
        channelShowBadge: true,
        enableLights: false,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: false,
      ),
    );
    if (Platform.isAndroid) {
      AndroidForegroundService.startForeground(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
          title: "Call In Progress",
          body: "",
          payload: {},
          locked: true,
          showWhen: true,
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
          title: "Call In Progress",
          body: "Call In Progress",
          payload: {},
          locked: true,
          showWhen: true,
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }

  static dynamic showCallInProgressNotificationIncoming(
      NotificationMessage notificationMessage) async {
    await AwesomeNotifications().setChannel(NotificationChannel(
      channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      channelDescription: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      importance: NotificationImportance.Max,
      defaultColor: Colors.purple,
      ledColor: Colors.purple,
      playSound: false,
      locked: true,
      channelShowBadge: true,
      enableLights: false,
      groupAlertBehavior: GroupAlertBehavior.All,
      defaultPrivacy: NotificationPrivacy.Private,
      onlyAlertOnce: false,
      enableVibration: false,
    ));
    if (Platform.isAndroid) {
      AndroidForegroundService.startForeground(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
          title: "Call In Progress",
          body: "",
          wakeUpScreen: true,
          payload: notificationMessage.data!.toJson(),
          locked: true,
          showWhen: true,
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Local,
          autoDismissible: false,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING,
            channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
            title: "Call In Progress",
            body: "Call In Progress",
            payload: notificationMessage.data!.toJson(),
            locked: true,
            wakeUpScreen: true,
            showWhen: true,
            // createdDate: DateTime.now().toString(),
            // createdSource: NotificationSource.Local,
            notificationLayout: NotificationLayout.Default,
            // category: NotificationCategory.Call,
            ticker: "hello",
            autoDismissible: false),
      );
    }
  }

  static dynamic showNormalNotification({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Const.NOTIFICATION_CHANNEL_ID_NORMAL,
        channelKey: Const.NOTIFICATION_CHANNEL_NORMAL,
        title: Const.NOTIFICATION_CHANNEL_NORMAL,
        body: body,
        payload: {
          "title": title,
          "body": body,
        },
        locked: true,
        showWhen: true,
        customSound: "resource://raw/sms",
        // createdDate: DateTime.now().toString(),
        // createdSource: NotificationSource.Firebase,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "view",
          label: "View",
          autoDismissible: false,
        ),
      ],
    );
  }

  static dynamic showSmsNotification(
      {String? title,
      String? body,
      String? clientNumber,
      String? channelId,
      String? channelNumber,
      String? channelName}) async {
    Utils.getSharedPreference().then((psSharedPref) async {
      await psSharedPref.reload();
      final String contactList =
          psSharedPref.getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
      final List decodeContactList = jsonDecode(contactList) as List;
      final List filterContact = decodeContactList.where((z) {
        if (z["number"].trim() == clientNumber!.trim()) {
          return true;
        } else {
          return false;
        }
      }).toList();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_SMS,
          channelKey: Const.NOTIFICATION_CHANNEL_SMS,
          title: filterContact.isEmpty
              ? clientNumber
              : filterContact[0]["name"].toString().trim(),
          body: body,
          payload: {
            "title": filterContact.isEmpty
                ? clientNumber
                : filterContact[0]["name"].toString().trim(),
            "body": body,
            "clientNumber": clientNumber ?? "",
            "channelId": channelId ?? "",
            "channelNumber": channelNumber ?? "",
            "channelName": channelName ?? "",
          },
          locked: true,
          showWhen: true,
          customSound: "resource://raw/sms",
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Firebase,
          notificationLayout: NotificationLayout.Default,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "view",
            label: "View",
            autoDismissible: false,
          ),
        ],
      );
    });
  }

  static dynamic showMissedCallNotification(
      {String? title,
      String? body,
      String? clientNumber,
      String? channelId,
      String? channelNumber,
      String? channelName}) async {
    Utils.getSharedPreference().then((psSharedPref) async {
      await psSharedPref.reload();
      final String contactList =
          psSharedPref.getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
      final List decodeContactList = jsonDecode(contactList) as List;
      final List filterContact = decodeContactList.where((z) {
        if (z["number"].trim() == clientNumber!.trim()) {
          return true;
        } else {
          return false;
        }
      }).toList();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_MISSED_CALL,
          channelKey: Const.NOTIFICATION_CHANNEL_MISSED_CALL,
          title: filterContact.isEmpty
              ? clientNumber
              : filterContact[0]["name"].toString().trim(),
          body:
              "You missed call from ${filterContact.isEmpty ? clientNumber : filterContact[0]["name"].toString().trim()}",
          payload: {
            "title": filterContact.isEmpty
                ? clientNumber
                : filterContact[0]["name"].toString().trim(),
            "body":
                "You missed call from ${filterContact.isEmpty ? clientNumber : filterContact[0]["name"].toString().trim()}",
            "clientNumber": clientNumber ?? "",
            "channelId": channelId ?? "",
            "channelNumber": channelNumber ?? "",
            "channelName": channelName ?? "",
          },
          locked: true,
          showWhen: true,
          customSound: "resource://raw/sms",
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Firebase,
          notificationLayout: NotificationLayout.Default,
          // category: NotificationCategory.MissedCall
        ),
        actionButtons: [
          NotificationActionButton(
            key: "view",
            label: "View",
            autoDismissible: false,
          ),
        ],
      );
    });
  }

  static dynamic showVoiceMailNotification(
      {String? title,
      String? body,
      String? clientNumber,
      String? channelId,
      String? channelNumber,
      String? channelName}) async {
    Utils.getSharedPreference().then((psSharedPref) async {
      await psSharedPref.reload();
      final String contactList =
          psSharedPref.getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
      final List decodeContactList = jsonDecode(contactList) as List;
      final List filterContact = decodeContactList.where((z) {
        if (z["number"].trim() == clientNumber!.trim()) {
          return true;
        } else {
          return false;
        }
      }).toList();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_VOICE_MAIL,
          channelKey: Const.NOTIFICATION_CHANNEL_VOICE_MAIL,
          title: filterContact.isEmpty
              ? clientNumber
              : filterContact[0]["name"].toString().trim(),
          body:
              "You received voicemail from ${filterContact.isEmpty ? clientNumber : filterContact[0]["name"].toString().trim()}",
          payload: {
            "title": filterContact.isEmpty
                ? clientNumber
                : filterContact[0]["name"].toString().trim(),
            "body":
                "You received voicemail from ${filterContact.isEmpty ? clientNumber : filterContact[0]["name"].toString().trim()}",
            "clientNumber": clientNumber ?? "",
            "channelId": channelId ?? "",
            "channelNumber": channelNumber ?? "",
            "channelName": channelName ?? "",
          },
          locked: true,
          showWhen: true,
          customSound: "resource://raw/sms",
          // createdDate: DateTime.now().toString(),
          // createdSource: NotificationSource.Firebase,
          notificationLayout: NotificationLayout.Default,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "view",
            label: "View",
            autoDismissible: false,
          ),
        ],
      );
    });
  }

  static dynamic showChatMessageNotification(
      {String? title,
      String? body,
      String? email,
      String? senderId,
      String? onlineStatus,
      String? messageIcon,
      String? sender,
      String? workspaceId,
      String? channelNo}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Const.NOTIFICATION_CHANNEL_ID_CHAT_MESSAGE,
        channelKey: Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE,
        title: sender,
        body: body,
        payload: {
          "title": title,
          "body": body,
          "email": email,
          "senderId": senderId,
          "onlineStatus": onlineStatus,
          "messageIcon": messageIcon ?? "",
          "sender": sender,
          "workspaceId": workspaceId ?? "",
          "channelNo": channelNo ?? "",
        },
        locked: true,
        showWhen: true,
        customSound: "resource://raw/sms",
        // createdDate: DateTime.now().toString(),
        // createdSource: NotificationSource.Firebase,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "view",
          label: "View",
          autoDismissible: false,
        ),
      ],
    );
  }

  static dynamic cancelIncomingNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_INCOMING);
    AndroidForegroundService.stopForeground();
  }

  static dynamic cancelSMSNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_SMS);
  }

  static dynamic cancelMissedCallNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_MISSED_CALL);
  }

  static dynamic cancelVoiceMailNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_VOICE_MAIL);
  }

  static dynamic cancelChatMessageNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_CHAT_MESSAGE);
  }

  static dynamic cancelCallInProgressNotification() {
    AndroidForegroundService.stopForeground();
    AwesomeNotifications()
        .cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING);
    AwesomeNotifications()
        .cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING);
  }

  static dynamic launchAppStoreURL({String? iOSAppId}) async {
    LaunchReview.launch(writeReview: false, iOSAppId: iOSAppId);
  }

  static String checkUserLoginId(ValueHolder valueHolder) {
    if (valueHolder.loginUserId == null) {
      return "nologinuser";
    } else {
      return valueHolder.loginUserId!;
    }
  }

  static Color hexToColor(String code) {
    if (code != "") {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return CustomColors.white!;
    }
  }

  static Resources<List<T>> removeDuplicateObj<T>(Resources<List<T>> resource) {
    final Map<String, String> keyMap = HashMap<String, String>();
    final List<T> tmpDataList = <T>[];

    if (resource.data != null) {
      for (final T obj in resource.data!) {
        if (obj is Object) {
          final String primaryKey = obj.getPrimaryKey()!;
          if (!keyMap.containsKey(primaryKey)) {
            keyMap[primaryKey] = primaryKey;
            tmpDataList.add(obj);
          }
        }
      }
    }
    resource.data = tmpDataList;
    return resource;
  }

  static Future<void> showToastMessage(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<void> showWarningToastMessage(
      String message, BuildContext context) async {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            CustomColors.d_text_senary_color_sec,
            CustomColors.d_text_senary_color_sec,
            CustomColors.textSenaryColor!,
            CustomColors.textSenaryColor!
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/no_internet_icon.svg",
            fit: BoxFit.cover,
            clipBehavior: Clip.antiAlias,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: RichText(
              overflow: TextOverflow.fade,
              softWrap: false,
              textAlign: TextAlign.left,
              maxLines: 1,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                text: Config.checkOverFlow ? Const.OVERFLOW : message,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static Future<void> showCopyToastMessage(
      String message, BuildContext context) async {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: Dimens.space48.h),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF10003A)),
      child: RichText(
        overflow: TextOverflow.fade,
        softWrap: false,
        textAlign: TextAlign.left,
        maxLines: 1,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
                fontFamily: Config.manropeSemiBold,
                fontSize: Dimens.space15.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
          text: Config.checkOverFlow ? Const.OVERFLOW : message,
        ),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static Future<void> switchWorkspace(
      String message, BuildContext context) async {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            CustomColors.d_text_senary_color_sec,
            CustomColors.d_text_senary_color_sec,
            CustomColors.textSenaryColor!,
            CustomColors.textSenaryColor!
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/icon_sync.svg",
            fit: BoxFit.cover,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: RichText(
              overflow: TextOverflow.fade,
              softWrap: false,
              textAlign: TextAlign.left,
              maxLines: 1,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                text: Config.checkOverFlow ? Const.OVERFLOW : message,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 10),
    );
  }

  static String dateFullMonthYearTimeWithAt(String dateFormat, String input) {
    try {
      return "${DateFormat(Config.dateFullMonthYearAndTimeFormat).format(DateTime.parse(DateFormat(dateFormat).parse(input).toString()))} ${Utils.getString("at")} ${Utils.convertDateToTime(input)}";
    } catch (e) {
      return "";
    }
  }

  static int formDateToUnixTimeStamp(String dateFormat, String input) {
    return DateFormat(dateFormat).parse(input).millisecondsSinceEpoch;
  }

  static String fromUnixTimeStampToDate(String dateFormat, int input) {
    return DateFormat(dateFormat)
        .format(DateTime.fromMillisecondsSinceEpoch(input * 1000));
  }

  static String readTimestamp(String timestamp, DateFormat inputFormat) {
    if (timestamp != null) {
      try {
        final now = DateTime.now();
        var date = inputFormat.parse(timestamp.split("+")[0]);
        final strToDateTime = DateTime.parse("${timestamp.split("+")[0]}Z");
        final convertLocal = strToDateTime.toLocal();
        date = convertLocal;
        final diff = now.difference(date);
        var time = "";
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = DateFormat("hh:mm a").format(date);
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else if (diff.inDays == 2) {
            time = "2d";
          } else if (diff.inDays == 3) {
            time = "3d";
          } else if (diff.inDays == 4) {
            time = "4d";
          } else if (diff.inDays == 5) {
            time = "5d";
          } else if (diff.inDays == 6) {
            time = "6d";
          } else if (diff.inDays == 7) {
            time = "1W";
          } else if (diff.inDays <= 14) {
            time = "2W";
          } else if (diff.inDays <= 21) {
            time = "3W";
          } else if (diff.inDays <= 28) {
            time = "4W";
          } else {
            final date = inputFormat.parse(timestamp);
            time = DateFormat("dd MMM").format(date);
          }
        } else {
          final date = inputFormat.parse(timestamp);
          time = DateFormat("dd MMM").format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String convertDateTime(String timestamp, DateFormat inputFormat) {
    if (timestamp != null) {
      try {
        final now = DateTime.now();
        final date = inputFormat.parse(timestamp.split("+")[0]);
        final diff = now.difference(date);
        var time = "";
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = "Today";
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else {
            final date = inputFormat.parse(timestamp);
            time = DateFormat("dd MMM").format(date);
          }
        } else {
          final date = inputFormat.parse(timestamp);
          time = DateFormat("dd MMM").format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String formatTimeStamp(DateFormat dateFormat, String timestamp) {
    try {
      final date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      return DateFormat("HH:mm a").format(date);
    } catch (e) {
      return "";
    }
  }

  static String formatTimeStampToReadableDate(
      int timeStamp, String outputFormat) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final formattedDate = DateFormat(outputFormat).format(date);
    return formattedDate;
  }

  static Map<String, String> convertImageToBase64String(
      String key, File imageFile) {
    final Map<String, String> base64ImageMap = {};
    final List<int> imageBytes = imageFile.readAsBytesSync();
    final String base64Image = base64Encode(imageBytes);
    log(base64Image);
    base64ImageMap.putIfAbsent(key, () => "data:image/png;base64,$base64Image");
    return base64ImageMap;
  }

  static bool validatePhoneNumbers(String phone) {
    if (phone.isNotEmpty) {
      final RegExp regExp = RegExp(r"^(?:[+0][1-9])?[0-9]{10,12}$");
      return regExp.hasMatch(phone);
    } else {
      return false;
    }
  }

  static BoxDecoration setInboundMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
        color: CustomColors.bottomAppBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space15.w),
          topRight: Radius.circular(Dimens.space15.w),
          bottomRight: Radius.circular(Dimens.space15.w),
        ),
      );
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
        color: CustomColors.bottomAppBarColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimens.space15.w),
          bottomRight: Radius.circular(Dimens.space15.w),
        ),
      );
    } else {
      return BoxDecoration(
        color: CustomColors.bottomAppBarColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimens.space15.w),
          bottomLeft: Radius.circular(Dimens.space15.w),
          bottomRight: Radius.circular(Dimens.space15.w),
        ),
      );
    }
  }

  static BoxDecoration setOutBoundMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            topRight: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.space15.w),
              bottomLeft: Radius.circular(Dimens.space15.w),
              bottomRight: Radius.circular(Dimens.space15.w)));
    }
  }

  static BoxDecoration setFailedMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
          color: CustomColors.redButtonColor!.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            topRight: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
          color: CustomColors.redButtonColor!.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else {
      return BoxDecoration(
          color: CustomColors.redButtonColor!.withOpacity(0.2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.space15.w),
              bottomLeft: Radius.circular(Dimens.space15.w),
              bottomRight: Radius.circular(Dimens.space15.w)));
    }
  }

  static EdgeInsets setMessageViewMarginByMessageDecorationType(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space4.h,
        Dimens.space0.w,
        Dimens.space4.h,
      );
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space4.h,
        Dimens.space0.w,
        Dimens.space4.h,
      );
    } else {
      return EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space4.h,
        Dimens.space0.w,
        Dimens.space4.h,
      );
    }
  }

  static Future<void> cPrint(String object) async {
    if (kDebugMode) {
      const int defaultPrintLength = 1020;
      if (object.length <= defaultPrintLength) {
        print(object);
      } else {
        final String log = object;
        int start = 0;
        int endIndex = defaultPrintLength;
        final int logLength = log.length;
        int tmpLogLength = log.length;
        while (endIndex < logLength) {
          print(log.substring(start, endIndex));
          endIndex += defaultPrintLength;
          start += defaultPrintLength;
          tmpLogLength -= defaultPrintLength;
        }
        if (tmpLogLength > 0) {
          print(log.substring(start, logLength));
        }
      }
    }
  }

  static bool validEmail(String value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String convertCamelCasing(String value) {
    return value
        .replaceAll(RegExp(" +"), " ")
        .split(" ")
        .map((str) => convertCamelCasingFirst(str))
        .join(" ");
  }

  static String convertCamelCasingFirst(String value) {
    return value.isNotEmpty
        ? "${value[0].toUpperCase()}${value.substring(1)}"
        : "";
  }

  static String convertDateToTime(String dateTime) {
    String time = "";
    try {
      final strToDateTime = DateTime.parse(dateTime);
      final convertLocal = strToDateTime.toLocal();
      time = DateFormat.jm().format(convertLocal);
      // time = DateFormat.jm().format(DateTime.parse(convertLocal));
    } catch (e) {
      cPrint(e.toString());
    }
    return time;
  }

  static String convertCallTime(
      String callTime, String inputFormat, String outputFormat) {
    if (callTime != null) {
      String date = "";
      try {
        final dateFormat = DateFormat(outputFormat);
        final String createdDate =
            dateFormat.format(DateTime.parse("${callTime}Z").toLocal());
        date = createdDate;
      } on Exception catch (_) {}
      return date;
    } else {
      return "";
    }
  }

  static void removeKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<SharedPreferences> getSharedPreference() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.reload();
    return instance;
  }

  static List<String> canadaList = [
    "204",
    "226",
    "236",
    "249",
    "250",
    "263",
    "289",
    "306",
    "343",
    "354",
    "365",
    "368",
    "367",
    "382",
    "403",
    "416",
    "418",
    "428",
    "431",
    "437",
    "438",
    "450",
    "468",
    "474",
    "506",
    "514",
    "519",
    "548",
    "579",
    "581",
    "584",
    "587",
    "604",
    "613",
    "639",
    "647",
    "672",
    "683",
    "705",
    "709",
    "742",
    "753",
    "778",
    "780",
    "782",
    "807",
    "819",
    "825",
    "867",
    "873",
    "879",
    "902",
    "905",
  ];

  static Map dialList = {
    "data": [
      {
        "dialCode": "+65",
        "code": "65",
        "country": "Singapore",
        "alphaTwoCode": "SG",
        "state": "Singapore",
        "stateCenter": "Asia/Singapore",
        "dialingCode": "+65",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/sg.png"
      },
      {
        "dialCode": "+63",
        "code": "63",
        "country": "Philippines",
        "alphaTwoCode": "PH",
        "state": "Manila",
        "stateCenter": "Asia/Manila",
        "dialingCode": "+63",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ph.png"
      },
      {
        "dialCode": "+91",
        "code": "91",
        "country": "India",
        "alphaTwoCode": "IN",
        "state": "Kolkata",
        "stateCenter": "Asia/Kolkata",
        "dialingCode": "+91",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/in.png"
      },
      {
        "dialCode": "+81",
        "code": "81",
        "country": "Japan",
        "alphaTwoCode": "JP",
        "state": "Tokyo",
        "stateCenter": "Asia/Tokyo",
        "dialingCode": "+81",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/jp.png"
      },
      {
        "dialCode": "+49",
        "code": "49",
        "country": "Germany",
        "alphaTwoCode": "DE",
        "state": "Berlin",
        "stateCenter": "Europe/Berlin",
        "dialingCode": "+49",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/de.png"
      },
      {
        "dialCode": "+31",
        "code": "31",
        "country": "Netherlands",
        "alphaTwoCode": "NL",
        "state": "Amsterdam",
        "stateCenter": "Europe/Amsterdam",
        "dialingCode": "+31",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/nl.png"
      },
      {
        "dialCode": "+353",
        "code": "353",
        "country": "Ireland",
        "alphaTwoCode": "IE",
        "state": "Dublin",
        "stateCenter": "Europe/Dublin",
        "dialingCode": "+353",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ie.png"
      },
      {
        "dialCode": "+44",
        "code": "44",
        "country": "UK",
        "alphaTwoCode": "GB",
        "state": "London",
        "stateCenter": "Europe/London",
        "dialingCode": "+44",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/gb.png"
      },
      {
        "dialCode": "+977",
        "code": "977",
        "country": "Nepal",
        "alphaTwoCode": "NP",
        "state": "Kathmandu",
        "stateCenter": "Asia/Kathmandu",
        "dialingCode": "+977",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/np.png"
      },
      {
        "dialCode": "+1204",
        "code": "204",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Manitoba",
        "stateCenter": "America/Winnipeg",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1226",
        "code": "226",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1236",
        "code": "236",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1249",
        "code": "249",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1250",
        "code": "250",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1263",
        "code": "263",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1289",
        "code": "289",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1306",
        "code": "306",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Saskatchewan",
        "stateCenter": "America/Regina",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1343",
        "code": "343",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1354",
        "code": "354",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1365",
        "code": "365",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1367",
        "code": "367",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1368",
        "code": "368",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Alberta",
        "stateCenter": "America/Edmonton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1382",
        "code": "382",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1403",
        "code": "403",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Alberta",
        "stateCenter": "America/Edmonton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1416",
        "code": "416",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1418",
        "code": "418",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1428",
        "code": "428",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "New Brunswick",
        "stateCenter": "America/Moncton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1431",
        "code": "431",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Manitoba",
        "stateCenter": "America/Winnipeg",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1437",
        "code": "437",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1438",
        "code": "438",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1450",
        "code": "450",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1468",
        "code": "468",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1474",
        "code": "474",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Saskatchewan",
        "stateCenter": "America/Regina",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1506",
        "code": "506",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "New Brunswick",
        "stateCenter": "America/Moncton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1514",
        "code": "514",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1519",
        "code": "519",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1548",
        "code": "548",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1579",
        "code": "579",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1581",
        "code": "581",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1584",
        "code": "584",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Manitoba",
        "stateCenter": "America/Winnipeg",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1587",
        "code": "587",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Alberta",
        "stateCenter": "America/Edmonton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1604",
        "code": "604",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1613",
        "code": "613",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1639",
        "code": "639",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Saskatchewan",
        "stateCenter": "America/Regina",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1647",
        "code": "647",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1672",
        "code": "672",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1683",
        "code": "683",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1705",
        "code": "705",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1709",
        "code": "709",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Newfoundland",
        "stateCenter": "Canada/Newfoundland",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1742",
        "code": "742",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1753",
        "code": "753",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1778",
        "code": "778",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1780",
        "code": "780",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Alberta",
        "stateCenter": "America/Edmonton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1782",
        "code": "782",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "New Brunswick",
        "stateCenter": "America/Moncton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1807",
        "code": "807",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1819",
        "code": "819",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1825",
        "code": "825",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Alberta",
        "stateCenter": "America/Edmonton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1867",
        "code": "867",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "British Columbia",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1873",
        "code": "873",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1879",
        "code": "879",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Newfoundland",
        "stateCenter": "Canada/Newfoundland",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1902",
        "code": "902",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "New Brunswick",
        "stateCenter": "America/Moncton",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1905",
        "code": "905",
        "country": "Canada",
        "alphaTwoCode": "CA",
        "state": "Ontario",
        "stateCenter": "America/Toronto",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/ca.png"
      },
      {
        "dialCode": "+1205",
        "code": "205",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1251",
        "code": "251",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1256",
        "code": "256",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1334",
        "code": "334",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1659",
        "code": "659",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1938",
        "code": "938",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alabama",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1907",
        "code": "907",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Alaska",
        "stateCenter": "America/Nome",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1480",
        "code": "480",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arizona",
        "stateCenter": "America/Phoenix",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1520",
        "code": "520",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arizona",
        "stateCenter": "America/Phoenix",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1602",
        "code": "602",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arizona",
        "stateCenter": "America/Phoenix",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1623",
        "code": "623",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arizona",
        "stateCenter": "America/Phoenix",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1928",
        "code": "928",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arizona",
        "stateCenter": "America/Phoenix",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1327",
        "code": "327",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arkansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1479",
        "code": "479",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arkansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1501",
        "code": "501",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arkansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1870",
        "code": "870",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Arkansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1209",
        "code": "209",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1213",
        "code": "213",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1279",
        "code": "279",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1310",
        "code": "310",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1323",
        "code": "323",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1341",
        "code": "341",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1350",
        "code": "350",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1408",
        "code": "408",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1415",
        "code": "415",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1424",
        "code": "424",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1442",
        "code": "442",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1510",
        "code": "510",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1530",
        "code": "530",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1559",
        "code": "559",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1562",
        "code": "562",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1619",
        "code": "619",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1626",
        "code": "626",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1628",
        "code": "628",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1650",
        "code": "650",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1657",
        "code": "657",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1661",
        "code": "661",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1669",
        "code": "669",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1707",
        "code": "707",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1714",
        "code": "714",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1747",
        "code": "747",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1760",
        "code": "760",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1805",
        "code": "805",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1818",
        "code": "818",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1820",
        "code": "820",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1831",
        "code": "831",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1840",
        "code": "840",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1858",
        "code": "858",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1909",
        "code": "909",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1916",
        "code": "916",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1925",
        "code": "925",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1949",
        "code": "949",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1951",
        "code": "951",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "California",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1303",
        "code": "303",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Colorado",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1719",
        "code": "719",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Colorado",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1720",
        "code": "720",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Colorado",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1970",
        "code": "970",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Colorado",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1983",
        "code": "983",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Colorado",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1203",
        "code": "203",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Connecticut",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1475",
        "code": "475",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Connecticut",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1860",
        "code": "860",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Connecticut",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1959",
        "code": "959",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Connecticut",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1302",
        "code": "302",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Delaware",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1239",
        "code": "239",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1305",
        "code": "305",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1321",
        "code": "321",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1352",
        "code": "352",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1386",
        "code": "386",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1407",
        "code": "407",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1448",
        "code": "448",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1561",
        "code": "561",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1645",
        "code": "645",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1656",
        "code": "656",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1689",
        "code": "689",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1727",
        "code": "727",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1728",
        "code": "728",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1754",
        "code": "754",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1772",
        "code": "772",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1786",
        "code": "786",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1813",
        "code": "813",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1850",
        "code": "850",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1863",
        "code": "863",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1904",
        "code": "904",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1941",
        "code": "941",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1954",
        "code": "954",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Florida",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1229",
        "code": "229",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1404",
        "code": "404",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1470",
        "code": "470",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1478",
        "code": "478",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1678",
        "code": "678",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1706",
        "code": "706",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1762",
        "code": "762",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1770",
        "code": "770",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1912",
        "code": "912",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Georgia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1808",
        "code": "808",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Hawaii",
        "stateCenter": "Pacific/Honolulu",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1208",
        "code": "208",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Idaho",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1986",
        "code": "986",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Idaho",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1217",
        "code": "217",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1224",
        "code": "224",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1309",
        "code": "309",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1312",
        "code": "312",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1331",
        "code": "331",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1447",
        "code": "447",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1464",
        "code": "464",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1618",
        "code": "618",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1630",
        "code": "630",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1708",
        "code": "708",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1730",
        "code": "730",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1773",
        "code": "773",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1779",
        "code": "779",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1815",
        "code": "815",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1847",
        "code": "847",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1861",
        "code": "861",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1872",
        "code": "872",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Illinois",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1219",
        "code": "219",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1260",
        "code": "260",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1317",
        "code": "317",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1463",
        "code": "463",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1574",
        "code": "574",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1765",
        "code": "765",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1812",
        "code": "812",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1930",
        "code": "930",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Indiana",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1319",
        "code": "319",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Iowa",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1515",
        "code": "515",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Iowa",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1563",
        "code": "563",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Iowa",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1641",
        "code": "641",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Iowa",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1712",
        "code": "712",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Iowa",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1316",
        "code": "316",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1620",
        "code": "620",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1785",
        "code": "785",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1913",
        "code": "913",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kansas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1270",
        "code": "270",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kentucky",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1364",
        "code": "364",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kentucky",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1502",
        "code": "502",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kentucky",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1606",
        "code": "606",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kentucky",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1859",
        "code": "859",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Kentucky",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1225",
        "code": "225",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Louisiana",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1318",
        "code": "318",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Louisiana",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1337",
        "code": "337",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Louisiana",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1504",
        "code": "504",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Louisiana",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1985",
        "code": "985",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Louisiana",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1207",
        "code": "207",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maine",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1240",
        "code": "240",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maryland",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1301",
        "code": "301",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maryland",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1410",
        "code": "410",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maryland",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1443",
        "code": "443",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maryland",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1667",
        "code": "667",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Maryland",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1339",
        "code": "339",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1351",
        "code": "351",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1413",
        "code": "413",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1508",
        "code": "508",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1617",
        "code": "617",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1774",
        "code": "774",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1781",
        "code": "781",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1857",
        "code": "857",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1978",
        "code": "978",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Massachusetts",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1231",
        "code": "231",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1248",
        "code": "248",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1269",
        "code": "269",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1313",
        "code": "313",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1517",
        "code": "517",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1586",
        "code": "586",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1616",
        "code": "616",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1734",
        "code": "734",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1810",
        "code": "810",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1906",
        "code": "906",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1947",
        "code": "947",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1989",
        "code": "989",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Michigan",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1218",
        "code": "218",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1320",
        "code": "320",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1507",
        "code": "507",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1612",
        "code": "612",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1651",
        "code": "651",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1763",
        "code": "763",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1952",
        "code": "952",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Minnesota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1228",
        "code": "228",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Mississippi",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1601",
        "code": "601",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Mississippi",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1662",
        "code": "662",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Mississippi",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1769",
        "code": "769",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Mississippi",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1235",
        "code": "235",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1314",
        "code": "314",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1417",
        "code": "417",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1557",
        "code": "557",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1573",
        "code": "573",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1636",
        "code": "636",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1660",
        "code": "660",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1816",
        "code": "816",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1975",
        "code": "975",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Missouri",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1406",
        "code": "406",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Montana",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1308",
        "code": "308",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nebraska",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1402",
        "code": "402",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nebraska",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1531",
        "code": "531",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nebraska",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1702",
        "code": "702",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nevada",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1725",
        "code": "725",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nevada",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1775",
        "code": "775",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Nevada",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1603",
        "code": "603",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Hampshire",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1201",
        "code": "201",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1551",
        "code": "551",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1609",
        "code": "609",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1640",
        "code": "640",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1732",
        "code": "732",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1848",
        "code": "848",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1856",
        "code": "856",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1862",
        "code": "862",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1908",
        "code": "908",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1973",
        "code": "973",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Jersey",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1505",
        "code": "505",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Mexico",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1575",
        "code": "575",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New Mexico",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1212",
        "code": "212",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1315",
        "code": "315",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1329",
        "code": "329",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1332",
        "code": "332",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1347",
        "code": "347",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1363",
        "code": "363",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1516",
        "code": "516",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1518",
        "code": "518",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1585",
        "code": "585",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1607",
        "code": "607",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1631",
        "code": "631",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1646",
        "code": "646",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1680",
        "code": "680",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1716",
        "code": "716",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1718",
        "code": "718",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1787",
        "code": "787",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1838",
        "code": "838",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1845",
        "code": "845",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1914",
        "code": "914",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1917",
        "code": "917",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1929",
        "code": "929",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1934",
        "code": "934",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1939",
        "code": "939",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "New York",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1252",
        "code": "252",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1336",
        "code": "336",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1447",
        "code": "447",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1472",
        "code": "472",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1704",
        "code": "704",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1743",
        "code": "743",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1828",
        "code": "828",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1910",
        "code": "910",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1919",
        "code": "919",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1980",
        "code": "980",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1984",
        "code": "984",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1701",
        "code": "701",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "North Dakota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1216",
        "code": "216",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1220",
        "code": "220",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1234",
        "code": "234",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1283",
        "code": "283",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1326",
        "code": "326",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1330",
        "code": "330",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1380",
        "code": "380",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1419",
        "code": "419",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1440",
        "code": "440",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1513",
        "code": "513",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1567",
        "code": "567",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1614",
        "code": "614",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1740",
        "code": "740",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1937",
        "code": "937",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Ohio",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1405",
        "code": "405",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oklahoma",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1539",
        "code": "539",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oklahoma",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1572",
        "code": "572",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oklahoma",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1580",
        "code": "580",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oklahoma",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1918",
        "code": "918",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oklahoma",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1458",
        "code": "458",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oregon",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1503",
        "code": "503",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oregon",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1541",
        "code": "541",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oregon",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1971",
        "code": "971",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Oregon",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1215",
        "code": "215",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1223",
        "code": "223",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1267",
        "code": "267",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1272",
        "code": "272",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1412",
        "code": "412",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1445",
        "code": "445",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1484",
        "code": "484",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1570",
        "code": "570",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1582",
        "code": "582",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1610",
        "code": "610",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1717",
        "code": "717",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1724",
        "code": "724",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1814",
        "code": "814",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1835",
        "code": "835",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1878",
        "code": "878",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Pennsylvania",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1401",
        "code": "401",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Rhode Island",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1803",
        "code": "803",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1839",
        "code": "839",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1843",
        "code": "843",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1854",
        "code": "854",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1864",
        "code": "864",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Carolina",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1605",
        "code": "605",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "South Dakota",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1423",
        "code": "423",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1615",
        "code": "615",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1629",
        "code": "629",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1731",
        "code": "731",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1865",
        "code": "865",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1901",
        "code": "901",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1931",
        "code": "931",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Tennessee",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1210",
        "code": "210",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1214",
        "code": "214",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1254",
        "code": "254",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1281",
        "code": "281",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1325",
        "code": "325",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1346",
        "code": "346",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1361",
        "code": "361",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1409",
        "code": "409",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1430",
        "code": "430",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1432",
        "code": "432",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1469",
        "code": "469",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1512",
        "code": "512",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1682",
        "code": "682",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1713",
        "code": "713",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1726",
        "code": "726",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1737",
        "code": "737",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1806",
        "code": "806",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1817",
        "code": "817",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1830",
        "code": "830",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1832",
        "code": "832",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1903",
        "code": "903",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1915",
        "code": "915",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1936",
        "code": "936",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1940",
        "code": "940",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1945",
        "code": "945",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1956",
        "code": "956",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1972",
        "code": "972",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1979",
        "code": "979",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Texas",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1385",
        "code": "385",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Utah",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1435",
        "code": "435",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Utah",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1801",
        "code": "801",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Utah",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1802",
        "code": "802",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Vermont",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1276",
        "code": "276",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1434",
        "code": "434",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1540",
        "code": "540",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1571",
        "code": "571",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1703",
        "code": "703",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1757",
        "code": "757",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1804",
        "code": "804",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1826",
        "code": "826",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1948",
        "code": "948",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1206",
        "code": "206",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1253",
        "code": "253",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1360",
        "code": "360",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1425",
        "code": "425",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1509",
        "code": "509",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1564",
        "code": "564",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington",
        "stateCenter": "America/Vancouver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1202",
        "code": "202",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington,DC",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1771",
        "code": "771",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Washington,DC",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1304",
        "code": "304",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "West Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1681",
        "code": "681",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "West Virginia",
        "stateCenter": "America/Detroit",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1262",
        "code": "262",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1274",
        "code": "274",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1414",
        "code": "414",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1534",
        "code": "534",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1608",
        "code": "608",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1715",
        "code": "715",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1920",
        "code": "920",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wisconsin",
        "stateCenter": "America/Chicago",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+1307",
        "code": "307",
        "country": "USA",
        "alphaTwoCode": "US",
        "state": "Wyoming",
        "stateCenter": "America/Denver",
        "dialingCode": "+1",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/us.png"
      },
      {
        "dialCode": "+34928",
        "code": "928",
        "country": "Spain",
        "alphaTwoCode": "ES",
        "state": "Las Palmas",
        "stateCenter": "Atlantic/Canary",
        "dialingCode": "+34",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/es.png"
      },
      {
        "dialCode": "+34922",
        "code": "922",
        "country": "Spain",
        "alphaTwoCode": "ES",
        "state": "Tenerife",
        "stateCenter": "Atlantic/Canary",
        "dialingCode": "+34",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/es.png"
      },
      {
        "dialCode": "+34",
        "code": "34",
        "country": "Spain",
        "alphaTwoCode": "ES",
        "state": "Zaragoza",
        "stateCenter": "Europe/Vienna",
        "dialingCode": "+34",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/es.png"
      },
      {
        "dialCode": "+6102",
        "code": "02",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Australian Capital Territory",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+612",
        "code": "2",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Australian Capital Territory",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+6103",
        "code": "03",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Australian Capital Territory",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+613",
        "code": "3",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Australian Capital Territory",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+6104",
        "code": "04",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Northern Territory",
        "stateCenter": "Australia/Darwin",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+614",
        "code": "4",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Northern Territory",
        "stateCenter": "Australia/Darwin",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+6107",
        "code": "07",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "North East",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+617",
        "code": "7",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "North East",
        "stateCenter": "Australia/Brisbane",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+6108",
        "code": "08",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Western Australia",
        "stateCenter": "Australia/Perth",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+618",
        "code": "8",
        "country": "Australia",
        "alphaTwoCode": "AU",
        "state": "Western Australia",
        "stateCenter": "Australia/Perth",
        "dialingCode": "+61",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/au.png"
      },
      {
        "dialCode": "+33",
        "code": "33",
        "country": "France",
        "alphaTwoCode": "FR",
        "state": "Paris",
        "stateCenter": "Europe/Paris",
        "dialingCode": "+33",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/fr.png"
      },
      {
        "dialCode": "+5591",
        "code": "91",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Santarem",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5562",
        "code": "62",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Goiania",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5579",
        "code": "79",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Aracaju",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5514",
        "code": "14",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Bauru",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5531",
        "code": "31",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Contagem",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5595",
        "code": "95",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Boa Vista",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5561",
        "code": "61",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Brasilia",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5519",
        "code": "19",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Piracicaba",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5567",
        "code": "67",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Campo Grande",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5551",
        "code": "51",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Porto Alegre",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5511",
        "code": "11",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sao Paulo",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5527",
        "code": "27",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Vitoria",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5554",
        "code": "54",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Caxias do Sul",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5565",
        "code": "65",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Varzea Grande",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5541",
        "code": "41",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Curitiba",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5521",
        "code": "21",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sao Joao de Meriti",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5575",
        "code": "75",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Feira de Santana",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5548",
        "code": "48",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Florianopolis",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5588",
        "code": "88",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Fortaleza",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5545",
        "code": "45",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Foz do Iguacu",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5516",
        "code": "16",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Ribeirao Preto",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5573",
        "code": "73",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Ilheus",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5583",
        "code": "83",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Joao Pessoa",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5547",
        "code": "47",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Joinville",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5532",
        "code": "32",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Juiz de Fora",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5543",
        "code": "43",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Londrina",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5596",
        "code": "96",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Macapa",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5582",
        "code": "82",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Maceio",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5592",
        "code": "92",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Manaus",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5544",
        "code": "44",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Maringa",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5538",
        "code": "38",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Montes Claros",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5584",
        "code": "84",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Natal",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5581",
        "code": "81",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Recife",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5553",
        "code": "53",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Pelotas",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5524",
        "code": "24",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Volta Redonda",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5569",
        "code": "69",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Porto Velho",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5568",
        "code": "68",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Rio Branco",
        "stateCenter": "America/Rio_Branco",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5571",
        "code": "71",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Salvador",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5555",
        "code": "55",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Santa Maria",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5513",
        "code": "13",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sao Vicente",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5512",
        "code": "12",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Taubate",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5517",
        "code": "17",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sao Jose de Rio Preto",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5598",
        "code": "98",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sao Luis",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5515",
        "code": "15",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sorocaba",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5515",
        "code": "15",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Sorocaba",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5585",
        "code": "85",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Greater Fortaleza",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5586",
        "code": "86",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Teresina",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5587",
        "code": "87",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Petrolina",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5589",
        "code": "89",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Floriano",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5534",
        "code": "34",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Uberlandia",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5577",
        "code": "77",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Vitoria da Conquista",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5593",
        "code": "93",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Altamira",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5594",
        "code": "94",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Marabá",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5597",
        "code": "97",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Coari",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5599",
        "code": "99",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Imperatriz",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5522",
        "code": "22",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Campos dos Goytacazes",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5528",
        "code": "28",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Cachoeiro de Itapemirim",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5533",
        "code": "33",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Governador Valadares",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5535",
        "code": "35",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Poços de Caldas",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5536",
        "code": "36",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Divinópolis",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5537",
        "code": "37",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Divinópolis",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5539",
        "code": "39",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Divinópolis",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5542",
        "code": "42",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Ponta Grossa",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5546",
        "code": "46",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Francisco Beltrão",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5549",
        "code": "49",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Lages",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5566",
        "code": "66",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Rondonópolis",
        "stateCenter": "America/Boa_Vista",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5574",
        "code": "74",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Juazeiro",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5563",
        "code": "63",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Santa Rosa",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5564",
        "code": "64",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Rio Verde",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
      {
        "dialCode": "+5518",
        "code": "18",
        "country": "Brazil",
        "alphaTwoCode": "BR",
        "state": "Presidente Prudente",
        "stateCenter": "America/Santarem",
        "dialingCode": "+55",
        "flagUrl":
            "https://krispcall-prod.sgp1.digitaloceanspaces.com/storage/flags/br.png"
      },
    ]
  };

  static List<String> australiaList = [
    "89162",
    "89164",
  ];

  static List<String> norkforkIlandList = [
    "32",
    "35",
  ];

  static List<String> anterticaCodeList = ["10", "11", "12", "13"];

  //Voice Mail Duration Trim
  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes =
        twoDigits(int.parse(duration.inMinutes.remainder(60).toString()));
    final String twoDigitSeconds =
        twoDigits(int.parse(duration.inSeconds.remainder(60).toString()));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  //Voice Mail Duration Trim
  static String printDurationTotalRemaning(
      Duration subtractionDuration, Duration totalDuration) {
    final min = totalDuration.inMinutes.remainder(60) -
        subtractionDuration.inMinutes.remainder(60);
    final seconds = totalDuration.inSeconds.remainder(60) -
        subtractionDuration.inSeconds.remainder(60);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(int.parse(min.toString()).abs());
    final String twoDigitSeconds =
        twoDigits(int.parse(seconds.toString()).abs());
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

//Voice Call Duration Trim
  static String printCallTimeDuration(
    RecentConversationNodes data,
  ) {
    String msg = "";
    try {
      final Duration duration =
          Duration(seconds: int.parse(data.content!.duration!));
      if (duration.inSeconds > 0) {
        if (duration.inSeconds < 5) {
          msg = "a few seconds";
        } else if (duration.inSeconds > 5 && duration.inSeconds < 60) {
          msg = "${duration.inSeconds} seconds";
        } else if (duration.inSeconds >= 60) {
          msg = "${duration.inMinutes} mins";
        }
      }
    } catch (e) {
      cPrint(e.toString());
    }

    if (msg.isNotEmpty) {
      msg = "$msg - ";
    }
    return "$msg${Utils.convertCallTime(data.createdAt!.split("+")[0], "yyyy-MM-ddThh:mm:ss.SSSSSS", "hh:mm a")}";
  }

  static String callTimeDurationAndTime(
    RecentConversationNodes? data,
  ) {
    String msg = "";
    msg = timeAgo(dateString: data!.createdAt!);
    return "$msg - ${Utils.convertCallTime(data.createdAt!.split("+")[0], "yyyy-MM-ddThh:mm:ss.SSSSSS", "HH:mm")}";
  }

  static bool check48Hours(String createdAt) {
    final int differenceInHours =
        DateTime.now().difference(DateTime.parse(createdAt)).inSeconds ~/ 365;
    return differenceInHours < 48;
  }

  static String timeAgo({String? dateString, bool showAgo = true}) {
    // returns format eg: 1 mnth ago, 1h ago
    // const seconds = Math.floor((new Date().valueOf() - new Date(dateString).valueOf()) / 1000);
    final int seconds =
        DateTime.now().difference(DateTime.parse(dateString!)).inSeconds;
    var interval = seconds / 31536000;
    if (interval > 1) {
      return "${interval.toInt()}y ${showAgo ? 'ago' : ''}";
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return "${interval.toInt()}mth ${showAgo ? 'ago' : ''}";
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return "${interval.toInt()}d ${showAgo ? 'ago' : ''}";
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return "${interval.toInt()}h ${showAgo ? 'ago' : ''}";
    }
    interval = seconds / 60;
    if (interval > 1) {
      return "${interval.toInt()}m ${showAgo ? "ago" : ""}";
    }
    return "a few seconds ${showAgo ? "ago" : ""}";
  }

  static Future<void> lunchWebUrl(
      {@required String? url, @required BuildContext? context}) async {
    final bool isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await canLaunchUrl(Uri.parse(url!))
          ? await launchUrl(Uri.parse(url))
          : throw "Could not launch $url";
    } else {
      await Utils.showWarningToastMessage(
          Utils.getString("noInternet"), context!);
    }
  }

  static Future<String> getFlagUrl(String? contactNumber) async {
    try {
      if (contactNumber != null) {
        bool isNumberFormatOk = true;
        try {} catch (e) {
          isNumberFormatOk = false;
        }
        if (isNumberFormatOk) {
          try {
            final PhoneNumber phoneNumber =
                await PhoneNumber.getRegionInfoFromPhoneNumber(
                    contactNumber, "US");

            return "/storage/flags/${phoneNumber.isoCode!.toLowerCase()}.png";
          } catch (e) {
            return "";
          }
        } else {
          return "";
        }
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<CountryCode> getCountryCode(String contactNumber) async {
    final CountryCode code = CountryCode();
    code.dialCode = "+1";
    code.code = "US";
    code.dialCode = "+1";
    try {
      final PhoneNumber phoneNumber =
          await PhoneNumber.getRegionInfoFromPhoneNumber(contactNumber, "US");
      code.dialCode = phoneNumber.dialCode;
      code.code = phoneNumber.isoCode;
    } catch (e) {}
    return Future.value(code);
  }

  static CountryCode? checkCountryCodeExist(
      String query, List<CountryCode> data) {
    CountryCode? countryCode;
    for (final element in data) {
      if (query.contains(element.dialCode!)) {
        countryCode = element;
      }
    }
    return countryCode;
  }

  static Future<bool> checkValidPhoneNumber(
      CountryCode selectedCountryCode, String phone) async {
    bool? isValid = false;
    try {
      isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: phone, isoCode: selectedCountryCode.code!);
    } on PlatformException catch (e) {
      print(e.message);
    }
    return Future.value(isValid);
  }

  static bool checkEmergencyNumber(String text) {
    return Config.psSupportedEmergencyNumberMap
        .containsValue(text.replaceAll("+", ""));
  }

  static void logRollBar(RollbarConstant rollbarConstant, dynamic message,
      {RollbarLogLevel? level, bool isLogin = false}) async {
    if (!isLogin) {
      Rollbar().person = await getPerson();
    }

    switch (rollbarConstant) {
      case RollbarConstant.DEBUG:
        Rollbar().level = RollbarLogLevel.DEBUG;
        await Rollbar().publishReport(
            message:
                "$message  ${await getWorkspaceChannelInfoBackgroundRollbar()}");
        break;
      case RollbarConstant.INFO:
        Rollbar().level = RollbarLogLevel.INFO;
        await Rollbar().publishReport(
            message:
                "$message  ${await getWorkspaceChannelInfoBackgroundRollbar()}");
        break;
      case RollbarConstant.WARNING:
        Rollbar().level = RollbarLogLevel.WARNING;
        await Rollbar().publishReport(
            message:
                "$message  ${await getWorkspaceChannelInfoBackgroundRollbar()}");
        break;
      case RollbarConstant.ERROR:
        Rollbar().level = RollbarLogLevel.ERROR;
        await Rollbar().publishReport(
            message:
                "$message  ${await getWorkspaceChannelInfoBackgroundRollbar()}");
        break;
      case RollbarConstant.CRITICAL:
        Rollbar().level = RollbarLogLevel.CRITICAL;
        await Rollbar().publishReport(
            message:
                "$message  ${await getWorkspaceChannelInfoBackgroundRollbar()}");
        break;
    }
  }
}
