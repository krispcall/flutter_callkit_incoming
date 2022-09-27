import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";
import "package:mvp/constant/Constants.dart";

Future awesomeNotificationInit() async {
  return AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_NORMAL,
        channelName: Const.NOTIFICATION_CHANNEL_NORMAL,
        channelDescription: Const.NOTIFICATION_CHANNEL_NORMAL,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: true,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: lowVibrationPattern,
        soundSource: "resource://raw/sms",
      ),
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
          vibrationPattern: highVibrationPattern),
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_SMS,
        channelName: Const.NOTIFICATION_CHANNEL_SMS,
        channelDescription: Const.NOTIFICATION_CHANNEL_SMS,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: true,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: lowVibrationPattern,
        soundSource: "resource://raw/sms",
      ),
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
        channelShowBadge: false,
        enableLights: false,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
        channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
        channelDescription:
            Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: false,
        locked: true,
        channelShowBadge: false,
        enableLights: false,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_MISSED_CALL,
        channelName: Const.NOTIFICATION_CHANNEL_MISSED_CALL,
        channelDescription: Const.NOTIFICATION_CHANNEL_MISSED_CALL,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: true,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: lowVibrationPattern,
        soundSource: "resource://raw/sms",
      ),
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_VOICE_MAIL,
        channelName: Const.NOTIFICATION_CHANNEL_VOICE_MAIL,
        channelDescription: Const.NOTIFICATION_CHANNEL_VOICE_MAIL,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: true,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: lowVibrationPattern,
        soundSource: "resource://raw/sms",
      ),
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE,
        channelName: Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE,
        channelDescription: Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: true,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: lowVibrationPattern,
        soundSource: "resource://raw/sms",
      ),
    ],
  );
}