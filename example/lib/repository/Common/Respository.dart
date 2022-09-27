import "dart:convert";

import "package:awesome_notifications/awesome_notifications.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/utils/encryption.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/overview/OverviewData.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class Repository {
  void loadValueHolder() {
    PsSharedPreferences.instance!.loadValueHolder();
  }

  void replaceLoginUserId(String loginUserId) {
    PsSharedPreferences.instance!.replaceLoginUserId(loginUserId);
  }

  String? getLoginUserId() {
    return PsSharedPreferences.instance!.getLoginUserId();
  }

  void replaceMemberId(String memberId) {
    PsSharedPreferences.instance!.replaceMemberId(memberId);
  }

  String getMemberId() {
    return PsSharedPreferences.instance!.getMemberId();
  }

  void replaceUserOnlineStatus(bool? onlineStatus) {
    if (onlineStatus != null) {
      PsSharedPreferences.instance!
          .replaceUserOnlineStatus(onlineStatus: onlineStatus);
    } else {
      PsSharedPreferences.instance!.replaceUserOnlineStatus();
    }
  }

  bool getUserOnlineStatus() {
    return PsSharedPreferences.instance!.getUserOnlineStatus();
  }

  void replaceMemberOnlineStatus(bool? onlineStatus) {
    PsSharedPreferences.instance!
        .replaceMemberOnlineStatus(onlineStatus: onlineStatus!);
  }

  bool getMemberOnlineStatus() {
    return PsSharedPreferences.instance!.getMemberOnlineStatus();
  }

  void replaceUserName(String userName) {
    PsSharedPreferences.instance!.replaceUserName(userName);
  }

  String getUserName() {
    return PsSharedPreferences.instance!.getUserName();
  }

  void replaceUserFirstName(String userFirstName) {
    PsSharedPreferences.instance!.replaceUserFirstName(userFirstName);
  }

  String getUserFirstName() {
    return PsSharedPreferences.instance!.getUserFirstName();
  }

  void replaceUserLastName(String userLastName) {
    PsSharedPreferences.instance!.replaceUserLastName(userLastName);
  }

  String getUserLastName() {
    return PsSharedPreferences.instance!.getUserLastName();
  }

  void replaceUserEmail(String userEmail) {
    PsSharedPreferences.instance!.replaceUserEmail(userEmail);
  }

  String getUserEmail() {
    return PsSharedPreferences.instance!.getUserEmail();
  }

  void replaceUserPassword(String userPassword) {
    PsSharedPreferences.instance!.replaceUserPassword(userPassword);
  }

  String getUserPassword() {
    return PsSharedPreferences.instance!.getUserPassword();
  }

  void replaceIntercomId(String id) {
    PsSharedPreferences.instance!.replaceIntercomId(id);
  }

  String getIntercomId() {
    return PsSharedPreferences.instance!.getIntercomId();
  }

  void replaceApiToken(String apiToken) {
    PsSharedPreferences.instance!.replaceApiToken(apiToken);
  }

  String getApiToken() {
    return PsSharedPreferences.instance!.getApiToken();
  }

  void replaceCallAccessToken(String callAccessToken) {
    PsSharedPreferences.instance!.replaceCallAccessToken(callAccessToken);
  }

  String getCallAccessToken() {
    return PsSharedPreferences.instance!.getCallAccessToken();
  }

  void replaceNotificationToken(String notificationToken) {
    PsSharedPreferences.instance!.replaceNotificationToken(notificationToken);
  }

  String getNotificationToken() {
    return PsSharedPreferences.instance!.getNotificationToken();
  }

  void replaceAssignedNumber(String assignedNumber) {
    PsSharedPreferences.instance!.replaceAssignedNumber(assignedNumber);
  }

  String getAssignedNumber() {
    return PsSharedPreferences.instance!.getAssignedNumber();
  }

  void replaceDefaultCountryCode(String defaultDialCode) {
    PsSharedPreferences.instance!.replaceDefaultCountryCode(defaultDialCode);
  }

  String getDefaultCountryCode() {
    return PsSharedPreferences.instance!.getDefaultCountryCode();
  }

  void replaceSmsNotificationSetting(bool? smsNotificationSetting) {
    if (smsNotificationSetting!) {
      AwesomeNotifications().setChannel(
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
      );
      FirebaseMessaging.instance
          .subscribeToTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
    } else {
      AwesomeNotifications().removeChannel(Const.NOTIFICATION_CHANNEL_SMS);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
    }
    PsSharedPreferences.instance!
        .replaceSmsNotificationSetting(smsNotificationSetting);
  }

  bool getSmsNotificationSetting() {
    return PsSharedPreferences.instance!.getSmsNotificationSetting();
  }

  void replaceMissedCallNotificationSetting(
      bool missedCallNotificationSetting) {
    if (missedCallNotificationSetting) {
      AwesomeNotifications().setChannel(
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
      );
      FirebaseMessaging.instance
          .subscribeToTopic(Const.NOTIFICATION_CHANNEL_MISSED_CALL_TOPIC);
    } else {
      AwesomeNotifications()
          .removeChannel(Const.NOTIFICATION_CHANNEL_MISSED_CALL);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_MISSED_CALL_TOPIC);
    }
    PsSharedPreferences.instance!
        .replaceMissedCallNotificationSetting(missedCallNotificationSetting);
  }

  bool getMissedCallNotificationSetting() {
    return PsSharedPreferences.instance!.getMissedCallNotificationSetting();
  }

  void replaceVoiceMailNotificationSetting(bool? voiceMailNotificationSetting) {
    if (voiceMailNotificationSetting!) {
      AwesomeNotifications().setChannel(
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
      );
      FirebaseMessaging.instance
          .subscribeToTopic(Const.NOTIFICATION_CHANNEL_VOICE_MAIL_TOPIC);
    } else {
      AwesomeNotifications()
          .removeChannel(Const.NOTIFICATION_CHANNEL_VOICE_MAIL);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_VOICE_MAIL_TOPIC);
    }
    PsSharedPreferences.instance!
        .replaceVoiceMailNotificationSetting(voiceMailNotificationSetting);
  }

  bool getVoiceMailNotificationSetting() {
    return PsSharedPreferences.instance!.getVoiceMailNotificationSetting();
  }

  void replaceChatMessageNotificationSetting(
      bool chatMessageNotificationSetting) {
    if (chatMessageNotificationSetting) {
      AwesomeNotifications().setChannel(
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
      );
      FirebaseMessaging.instance
          .subscribeToTopic(Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE_TOPIC);
    } else {
      AwesomeNotifications()
          .removeChannel(Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE_TOPIC);
    }
    PsSharedPreferences.instance!
        .replaceChatMessageNotificationSetting(chatMessageNotificationSetting);
  }

  bool getChatMessageNotificationSetting() {
    return PsSharedPreferences.instance!.getChatMessageNotificationSetting();
  }

  void replaceDefaultWorkspace(String defaultWorkSpace) {
    PsSharedPreferences.instance!.replaceDefaultWorkspace(defaultWorkSpace);
  }

  String getDefaultWorkspace() {
    return PsSharedPreferences.instance!.getDefaultWorkspace();
  }

  void replaceWorkspaceDetail(String? defaultWorkSpace) {
    PsSharedPreferences.instance!.replaceWorkspaceDetail(defaultWorkSpace!);
  }

  LoginWorkspace? getWorkspaceDetail() {
    if (PsSharedPreferences.instance!.getWorkspaceDetail().isNotEmpty) {
      final LoginWorkspace workspaceDetail = LoginWorkspace().fromMap(
          json.decode(PsSharedPreferences.instance!.getWorkspaceDetail()))!;
      return workspaceDetail;
    } else {
      return null;
    }
  }

  void replaceDefaultChannel(String? defaultChannel) {
    PsSharedPreferences.instance!.replaceDefaultChannel(defaultChannel);
  }

  void clearPrefrence() {
    PsSharedPreferences.instance!.clearPrefrence();
  }

  WorkspaceChannel getDefaultChannel() {
    if (PsSharedPreferences.instance!.getDefaultChannel().isNotEmpty) {
      final WorkspaceChannel defaultChannel = WorkspaceChannel().fromMap(
          json.decode(PsSharedPreferences.instance!.getDefaultChannel())
              as Map<String, dynamic>)!;
      return defaultChannel;
    } else {
      return WorkspaceChannel(number: "");
    }
  }

  void replaceWorkspaceList(List<LoginWorkspace>? workspaceList) {
    if (workspaceList != null && workspaceList.isNotEmpty) {
      final List<String> workspace = [];
      for (final element in workspaceList) {
        workspace.add(json.encode(element.toJson()));
      }
      PsSharedPreferences.instance!.replaceWorkspaceList(workspace);
    } else {
      PsSharedPreferences.instance!.replaceWorkspaceList([]);
    }
  }

  List<LoginWorkspace>? getWorkspaceList() {
    if (PsSharedPreferences.instance!.getWorkspaceList().isNotEmpty) {
      final List<LoginWorkspace> listWorkspace = [];
      final List<String> listString =
          PsSharedPreferences.instance!.getWorkspaceList();
      for (int i = 0; i < listString.length; i++) {
        listWorkspace.add(LoginWorkspace.fromJson(
            json.decode(listString[i]) as Map<String, dynamic>));
      }
      return listWorkspace;
    } else {
      return null;
    }
  }

  void replaceChannelList(List<WorkspaceChannel>? channelList) {
    if (channelList != null && channelList.isNotEmpty) {
      final List<String> dump = [];
      for (final element in channelList) {
        dump.add(json.encode(element.toJson()));
      }
      PsSharedPreferences.instance!.replaceChannelList(dump);
    } else {
      PsSharedPreferences.instance!.replaceChannelList([]);
    }
  }

  List<WorkspaceChannel>? getChannelList() {
    if (PsSharedPreferences.instance!.getChannelList().isNotEmpty) {
      final List<WorkspaceChannel> listWorkspaceChannel = [];
      final List<String> listString =
          PsSharedPreferences.instance!.getChannelList();
      for (int i = 0; i < listString.length; i++) {
        listWorkspaceChannel.add(WorkspaceChannel()
            .fromMap(json.decode(listString[i]) as Map<String, dynamic>)!);
      }
      return listWorkspaceChannel;
    } else {
      return null;
    }
  }

  void replaceVoiceToken(String voiceToken) {
    final String decryptVoiceToken = EncryptionDecryption.decrypt(voiceToken);
    PsSharedPreferences.instance!.replaceVoiceToken(decryptVoiceToken);
  }

  String? getVoiceToken() {
    return PsSharedPreferences.instance!.getVoiceToken();
  }

  void replaceUserProfilePicture(String profilePicture) {
    PsSharedPreferences.instance!.replaceUserProfilePicture(profilePicture);
  }

  String getUserProfilePicture() {
    return PsSharedPreferences.instance!.getUserProfilePicture();
  }

  void replaceSessionId(String sessionId) {
    PsSharedPreferences.instance!.replaceSessionId(sessionId);
  }

  void replaceRefreshToken(String refreshToken) {
    PsSharedPreferences.instance!.replaceRefreshToken(refreshToken);
  }

  void replaceSelectedSound(String selectedSound) {
    PsSharedPreferences.instance!.replaceSelectedSound(selectedSound);
  }

  String getSelectedSound() {
    return PsSharedPreferences.instance!.getSelectedSound();
  }

  void replaceContactsList(String contactListJson) {
    PsSharedPreferences.instance!.replaceContactsList(contactListJson);
  }

  String getContactList() {
    return PsSharedPreferences.instance!.getContactList();
  }

  ///Plan Overview Pref
  void replacePlanOverview(OverViewData overViewData) {
    PsSharedPreferences.instance!
        .replacePlanOverview(json.encode(OverViewData().toMap(overViewData)));
  }

  OverViewData? getPlanOverview() {
    if (PsSharedPreferences.instance!.getPlanOverview().isNotEmpty) {
      final OverViewData overViewData = OverViewData().fromMap(
          json.decode(PsSharedPreferences.instance!.getPlanOverview()))!;
      return overViewData;
    } else {
      return null;
    }
  }

  ///Permissions Pref
  ///
  ///
  void replaceAllowWorkspaceViewSwitchWorkspace(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowWorkspaceViewSwitchWorkspace(value!);
  }

  bool getAllowWorkspaceViewSwitchWorkspace() {
    return PsSharedPreferences.instance!.getAllowWorkspaceViewSwitchWorkspace();
  }

  void replaceAllowWorkspaceCreateWorkspace(bool? value) {
    PsSharedPreferences.instance!.replaceAllowWorkspaceCreateWorkspace(value!);
  }

  bool getAllowWorkspaceCreateWorkspace() {
    return PsSharedPreferences.instance!.getAllowWorkspaceCreateWorkspace();
  }

  void replaceAllowWorkspaceEditWorkspace(bool? value) {
    PsSharedPreferences.instance!.replaceAllowWorkspaceEditWorkspace(value!);
  }

  bool getAllowWorkspaceEditWorkspace() {
    return PsSharedPreferences.instance!.getAllowWorkspaceEditWorkspace();
  }

  void replaceAllowNavigationSearch(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationSearch(value!);
  }

  bool getAllowNavigationSearch() {
    return PsSharedPreferences.instance!.getAllowNavigationSearch();
  }

  void replaceAllowNavigationShowDialer(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationShowDialer(value!);
  }

  bool getAllowNavigationShowDialer() {
    return PsSharedPreferences.instance!.getAllowNavigationShowDialer();
  }

  void replaceAllowNavigationShowDashboard(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationShowDashboard(value!);
  }

  bool getAllowNavigationShowDashboard() {
    return PsSharedPreferences.instance!.getAllowNavigationShowDashboard();
  }

  void replaceAllowNavigationShowContact(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationShowContact(value!);
  }

  bool getAllowNavigationShowContact() {
    return PsSharedPreferences.instance!.getAllowNavigationShowContact();
  }

  void replaceAllowNavigationShowSetting(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationShowSetting(value!);
  }

  bool getAllowNavigationShowSetting() {
    return PsSharedPreferences.instance!.getAllowNavigationShowSetting();
  }

  void replaceAllowNavigationAddNewNumber(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationAddNewNumber(value!);
  }

  bool getAllowNavigationAddNewNumber() {
    return PsSharedPreferences.instance!.getAllowNavigationAddNewNumber();
  }

  void replaceAllowNavigationViewNumberDetails(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowNavigationViewNumberDetails(value!);
  }

  bool getAllowNavigationViewNumberDetails() {
    return PsSharedPreferences.instance!.getAllowNavigationViewNumberDetails();
  }

  void replaceAllowNavigationNumberDnd(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationNumberDnd(value!);
  }

  bool getAllowNavigationNumberDnd() {
    return PsSharedPreferences.instance!.getAllowNavigationNumberDnd();
  }

  void replaceAllowNavigationNumberSetting(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationNumberSetting(value!);
  }

  bool getAllowNavigationNumberSetting() {
    return PsSharedPreferences.instance!.getAllowNavigationNumberSetting();
  }

  void replaceAllowNavigationAddNewMember(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationAddNewMember(value!);
  }

  bool getAllowNavigationAddNewMember() {
    return PsSharedPreferences.instance!.getAllowNavigationAddNewMember();
  }

  void replaceAllowNavigationAddNewTeam(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationAddNewTeam(value!);
  }

  bool getAllowNavigationAddNewTeam() {
    return PsSharedPreferences.instance!.getAllowNavigationAddNewTeam();
  }

  void replaceAllowNavigationViewTagDetails(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationViewTagDetails(value!);
  }

  bool getAllowNavigationViewTagDetails() {
    return PsSharedPreferences.instance!.getAllowNavigationViewTagDetails();
  }

  void replaceAllowNavigationAddNewTags(bool? value) {
    PsSharedPreferences.instance!.replaceAllowNavigationAddNewTags(value!);
  }

  bool getAllowNavigationAddNewTags() {
    return PsSharedPreferences.instance!.getAllowNavigationAddNewTags();
  }

  void replaceAllowContactSearchContact(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactSearchContact(value!);
  }

  bool getAllowContactSearchContact() {
    return PsSharedPreferences.instance!.getAllowContactSearchContact();
  }

  void replaceAllowContactAddNewContact(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactAddNewContact(value!);
  }

  bool getAllowContactAddNewContact() {
    return PsSharedPreferences.instance!.getAllowContactAddNewContact();
  }

  void replaceAllowContactCSVImport(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactCSVImport(value!);
  }

  bool getAllowContactCSVImport() {
    return PsSharedPreferences.instance!.getAllowContactCSVImport();
  }

  void replaceAllowShowTableView(bool? value) {
    if (value != null) {
      PsSharedPreferences.instance!.replaceAllowShowTableView(value);
    }
  }

  bool getAllowShowTableView() {
    return PsSharedPreferences.instance!.getAllowShowTableView();
  }

  void replaceAllowProfileEditFullName(bool? value) {
    PsSharedPreferences.instance!.replaceAllowProfileEditFullName(value!);
  }

  bool getAllowProfileEditFullName() {
    return PsSharedPreferences.instance!.getAllowProfileEditFullName();
  }

  void replaceAllowProfileEditEmail(bool? value) {
    PsSharedPreferences.instance!.replaceAllowProfileEditEmail(value!);
  }

  bool getAllowProfileEditEmail() {
    return PsSharedPreferences.instance!.getAllowProfileEditEmail();
  }

  void replaceAllowProfileChangePassword(bool? value) {
    PsSharedPreferences.instance!.replaceAllowProfileChangePassword(value!);
  }

  bool getAllowProfileChangePassword() {
    return PsSharedPreferences.instance!.getAllowProfileChangePassword();
  }

  void replaceAllowProfileChangeProfilePicture(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowProfileChangeProfilePicture(value!);
  }

  bool getAllowProfileChangeProfilePicture() {
    return PsSharedPreferences.instance!.getAllowProfileChangeProfilePicture();
  }

  void replaceAllowMyNumberPortConfig(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberPortConfig(value!);
  }

  bool getAllowMyNumberPortConfig() {
    return PsSharedPreferences.instance!.getAllowMyNumberPortConfig();
  }

  void replaceAllowMyNumberAddNewNumber(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberAddNewNumber(value!);
  }

  bool getAllowMyNumberAddNewNumber() {
    return PsSharedPreferences.instance!.getAllowMyNumberAddNewNumber();
  }

  void replaceAllowMyNumberViewNumberList(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberViewNumberList(value!);
  }

  bool getAllowMyNumberViewNumberList() {
    return PsSharedPreferences.instance!.getAllowMyNumberViewNumberList();
  }

  void replaceAllowMyNumberEditDetails(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberEditDetails(value!);
  }

  bool getAllowMyNumberEditDetails() {
    return PsSharedPreferences.instance!.getAllowMyNumberEditDetails();
  }

  void replaceAllowMyNumberAutoRecord(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberAutoRecord(value!);
  }

  bool getAllowMyNumberAutoRecord() {
    return PsSharedPreferences.instance!.getAllowMyNumberAutoRecord();
  }

  void replaceAllowMyNumberInternationalCall(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberInternationalCall(value!);
  }

  bool getAllowMyNumberInternationalCall() {
    return PsSharedPreferences.instance!.getAllowMyNumberInternationalCall();
  }

  void replaceAllowMyNumberShareAccess(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberShareAccess(value!);
  }

  bool getAllowMyNumberShareAccess() {
    return PsSharedPreferences.instance!.getAllowMyNumberShareAccess();
  }

  void replaceAllowMyNumberAutoVoiceMailTranscription(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowMyNumberAutoVoiceMailTranscription(value!);
  }

  bool getAllowMyNumberAutoVoiceMailTranscription() {
    return PsSharedPreferences.instance!
        .getAllowMyNumberAutoVoiceMailTranscription();
  }

  void replaceAllowMyNumberDelete(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMyNumberDelete(value!);
  }

  bool getAllowMyNumberDelete() {
    return PsSharedPreferences.instance!.getAllowMyNumberDelete();
  }

  void replaceAllowMemberAddNewMember(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberAddNewMember(value!);
  }

  bool getAllowMemberAddNewMember() {
    return PsSharedPreferences.instance!.getAllowMemberAddNewMember();
  }

  void replaceAllowMemberMemberList(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberMemberList(value!);
  }

  bool getAllowMemberMemberList() {
    return PsSharedPreferences.instance!.getAllowMemberMemberList();
  }

  void replaceAllowMemberViewAssignedNumber(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberViewAssignedNumber(value!);
  }

  bool getAllowMemberViewAssignedNumber() {
    return PsSharedPreferences.instance!.getAllowMemberViewAssignedNumber();
  }

  void replaceAllowMemberDeleteMember(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberDeleteMember(value!);
  }

  bool getAllowMemberDeleteMember() {
    return PsSharedPreferences.instance!.getAllowMemberDeleteMember();
  }

  void replaceAllowMemberInvite(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberInvite(value!);
  }

  bool getAllowMemberInvite() {
    return PsSharedPreferences.instance!.getAllowMemberInvite();
  }

  void replaceAllowMemberReInvite(bool? value) {
    PsSharedPreferences.instance!.replaceAllowMemberReInvite(value!);
  }

  bool getAllowMemberReInvite() {
    return PsSharedPreferences.instance!.getAllowMemberReInvite();
  }

  void replaceAllowTeamCreateTeam(bool? value) {
    PsSharedPreferences.instance!.replaceAllowTeamCreateTeam(value!);
  }

  bool getAllowTeamCreateTeam() {
    return PsSharedPreferences.instance!.getAllowTeamCreateTeam();
  }

  void replaceAllowTeamTeamList(bool? value) {
    PsSharedPreferences.instance!.replaceAllowTeamTeamList(value!);
  }

  bool getAllowTeamTeamList() {
    return PsSharedPreferences.instance!.getAllowTeamTeamList();
  }

  void replaceAllowTeamEdit(bool? value) {
    PsSharedPreferences.instance!.replaceAllowTeamEdit(value!);
  }

  bool getAllowTeamEdit() {
    return PsSharedPreferences.instance!.getAllowTeamEdit();
  }

  void replaceAllowTeamDelete(bool? value) {
    PsSharedPreferences.instance!.replaceAllowTeamDelete(value!);
  }

  bool getAllowTeamDelete() {
    return PsSharedPreferences.instance!.getAllowTeamDelete();
  }

  void replaceAllowContactAddNewIntegration(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactAddNewIntegration(value!);
  }

  bool getAllowContactAddNewIntegration() {
    return PsSharedPreferences.instance!.getAllowContactAddNewIntegration();
  }

  void replaceAllowContactIntegrationGoogle(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactIntegrationGoogle(value!);
  }

  bool getAllowContactIntegrationGoogle() {
    return PsSharedPreferences.instance!.getAllowContactIntegrationGoogle();
  }

  void replaceAllowContactIntegrationPipeDrive(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowContactIntegrationPipeDrive(value!);
  }

  bool getAllowContactIntegrationPipeDrive() {
    return PsSharedPreferences.instance!.getAllowContactIntegrationPipeDrive();
  }

  void replaceAllowContactImportCsv(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactImportCsv(value!);
  }

  bool getAllowContactImportCsv() {
    return PsSharedPreferences.instance!.getAllowContactImportCsv();
  }

  void replaceAllowContactDeleteContacts(bool? value) {
    PsSharedPreferences.instance!.replaceAllowContactDeleteContacts(value!);
  }

  bool getAllowContactDeleteContacts() {
    return PsSharedPreferences.instance!.getAllowContactDeleteContacts();
  }

  void replaceAllowWorkspaceUpdateProfilePicture(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowWorkspaceUpdateProfilePicture(value!);
  }

  bool getAllowWorkspaceUpdateProfilePicture() {
    return PsSharedPreferences.instance!
        .getAllowWorkspaceUpdateProfilePicture();
  }

  void replaceAllowWorkspaceChangeName(bool? value) {
    PsSharedPreferences.instance!.replaceAllowWorkspaceChangeName(value!);
  }

  bool getAllowWorkspaceChangeName() {
    return PsSharedPreferences.instance!.getAllowWorkspaceChangeName();
  }

  void replaceAllowWorkspaceEnableNotification(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowWorkspaceEnableNotification(value!);
  }

  bool getAllowWorkspaceEnableNotification() {
    return PsSharedPreferences.instance!.getAllowWorkspaceEnableNotification();
  }

  void replaceAllowWorkspaceDelete(bool? value) {
    PsSharedPreferences.instance!.replaceAllowWorkspaceDelete(value!);
  }

  bool getAllowWorkspaceDelete() {
    return PsSharedPreferences.instance!.getAllowWorkspaceDelete();
  }

  void replaceAllowIntegrationEnabled(bool? value) {
    PsSharedPreferences.instance!.replaceAllowIntegrationEnabled(value!);
  }

  bool getAllowIntegrationEnabled() {
    return PsSharedPreferences.instance!.getAllowIntegrationEnabled();
  }

  void replaceAllowIntegrationOtherIntegration(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowIntegrationOtherIntegration(value!);
  }

  bool getAllowIntegrationOtherIntegration() {
    return PsSharedPreferences.instance!.getAllowIntegrationOtherIntegration();
  }

  void replaceAllowBillingOverviewChangePlan(bool? value) {
    PsSharedPreferences.instance!.replaceAllowBillingOverviewChangePlan(value!);
  }

  bool getAllowBillingOverviewChangePlan() {
    return PsSharedPreferences.instance!.getAllowBillingOverviewChangePlan();
  }

  void replaceAllowBillingOverviewPurchaseCredit(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewPurchaseCredit(value!);
  }

  bool getAllowBillingOverviewPurchaseCredit() {
    return PsSharedPreferences.instance!
        .getAllowBillingOverviewPurchaseCredit();
  }

  void replaceAllowBillingOverviewManageCardAdd(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewManageCardAdd(value!);
  }

  bool getAllowBillingOverviewManageCardAdd() {
    return PsSharedPreferences.instance!.getAllowBillingOverviewManageCardAdd();
  }

  void replaceAllowBillingOverviewManageCardDelete(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewManageCardDelete(value!);
  }

  bool getAllowBillingOverviewManageCardDelete() {
    return PsSharedPreferences.instance!
        .getAllowBillingOverviewManageCardDelete();
  }

  void replaceAllowBillingOverviewHideKrispcallBranding(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewHideKrispcallBranding(value!);
  }

  bool getAllowBillingOverviewHideKrispcallBranding() {
    return PsSharedPreferences.instance!
        .getAllowBillingOverviewHideKrispcallBranding();
  }

  void replaceAllowBillingOverviewNotificationAutoRecharge(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewNotificationAutoRecharge(value!);
  }

  bool getAllowBillingOverviewNotificationAutoRecharge() {
    return PsSharedPreferences.instance!
        .getAllowBillingOverviewNotificationAutoRecharge();
  }

  void replaceAllowBillingOverviewCancelSubscription(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingOverviewCancelSubscription(value!);
  }

  bool getAllowBillingOverviewCancelSubscription() {
    return PsSharedPreferences.instance!
        .getAllowBillingOverviewCancelSubscription();
  }

  void replaceAllowBillingSaveBillingInfo(bool? value) {
    PsSharedPreferences.instance!.replaceAllowBillingSaveBillingInfo(value!);
  }

  bool getAllowBillingSaveBillingInfo() {
    return PsSharedPreferences.instance!.getAllowBillingSaveBillingInfo();
  }

  void replaceAllowBillingReceiptsViewList(bool? value) {
    PsSharedPreferences.instance!.replaceAllowBillingReceiptsViewList(value!);
  }

  bool getAllowBillingReceiptsViewList() {
    return PsSharedPreferences.instance!.getAllowBillingReceiptsViewList();
  }

  void replaceAllowBillingReceiptsViewInvoice(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingReceiptsViewInvoice(value!);
  }

  bool getAllowBillingReceiptsViewInvoice() {
    return PsSharedPreferences.instance!.getAllowBillingReceiptsViewInvoice();
  }

  void replaceAllowBillingReceiptsDownloadInvoice(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowBillingReceiptsDownloadInvoice(value!);
  }

  bool getAllowBillingReceiptsDownloadInvoice() {
    return PsSharedPreferences.instance!
        .getAllowBillingReceiptsDownloadInvoice();
  }

  void replaceAllowDeviceSelectInputDevice(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceSelectInputDevice(value!);
  }

  bool getAllowDeviceSelectInputDevice() {
    return PsSharedPreferences.instance!.getAllowDeviceSelectInputDevice();
  }

  void replaceAllowDeviceSelectOutputDevice(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceSelectOutputDevice(value!);
  }

  bool getAllowDeviceSelectOutputDevice() {
    return PsSharedPreferences.instance!.getAllowDeviceSelectOutputDevice();
  }

  void replaceAllowDeviceAdjustInputVolume(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceAdjustInputVolume(value!);
  }

  bool getAllowDeviceAdjustInputVolume() {
    return PsSharedPreferences.instance!.getAllowDeviceAdjustInputVolume();
  }

  void replaceAllowDeviceAdjustOutputVolume(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceAdjustOutputVolume(value!);
  }

  bool getAllowDeviceAdjustOutputVolume() {
    return PsSharedPreferences.instance!.getAllowDeviceAdjustOutputVolume();
  }

  void replaceAllowDeviceMicTest(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceMicTest(value!);
  }

  bool getAllowDeviceMicTest() {
    return PsSharedPreferences.instance!.getAllowDeviceMicTest();
  }

  void replaceAllowDeviceCancelEcho(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceCancelEcho(value!);
  }

  bool getAllowDeviceCancelEcho() {
    return PsSharedPreferences.instance!.getAllowDeviceCancelEcho();
  }

  void replaceAllowDeviceReduceNoise(bool? value) {
    PsSharedPreferences.instance!.replaceAllowDeviceReduceNoise(value!);
  }

  bool getAllowDeviceReduceNoise() {
    return PsSharedPreferences.instance!.getAllowDeviceReduceNoise();
  }

  void replaceAllowNotificationEnableDesktopNotification(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowNotificationEnableDesktopNotification(value!);
  }

  bool getAllowNotificationEnableDesktopNotification() {
    return PsSharedPreferences.instance!
        .getAllowNotificationEnableDesktopNotification();
  }

  void replaceAllowNotificationEnableNewCallMessage(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowNotificationEnableNewCallMessage(value!);
  }

  bool getAllowNotificationEnableNewCallMessage() {
    return PsSharedPreferences.instance!
        .getAllowNotificationEnableNewCallMessage();
  }

  void replaceAllowNotificationEnableNewLeads(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowNotificationEnableNewLeads(value!);
  }

  bool getAllowNotificationEnableNewLeads() {
    return PsSharedPreferences.instance!.getAllowNotificationEnableNewLeads();
  }

  void replaceAllowNotificationEnableFlashTaskBar(bool? value) {
    PsSharedPreferences.instance!
        .replaceAllowNotificationEnableFlashTaskBar(value!);
  }

  bool getAllowNotificationEnableFlashTaskBar() {
    return PsSharedPreferences.instance!
        .getAllowNotificationEnableFlashTaskBar();
  }

  void replaceAllowLanguageSwitch(bool? value) {
    PsSharedPreferences.instance!.replaceAllowLanguageSwitch(value!);
  }

  bool getAllowLanguageSwitch() {
    return PsSharedPreferences.instance!.getAllowLanguageSwitch();
  }
}
