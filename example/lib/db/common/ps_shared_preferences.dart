import "dart:async";

import "package:mvp/constant/Constants.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:shared_preferences/shared_preferences.dart";

class PsSharedPreferences {
  PsSharedPreferences() {
    futureShared = SharedPreferences.getInstance();
    futureShared?.then((SharedPreferences shared) {
      this.shared = shared;
      loadValueHolder();
    });
  }

  Future<SharedPreferences>? futureShared;
  SharedPreferences? shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences();

  // Singleton accessor
  static PsSharedPreferences? get instance => _singleton;

  final StreamController<ValueHolder> _valueController =
      StreamController<ValueHolder>();

  Stream<ValueHolder>? get valueHolder => _valueController.stream;

  void loadValueHolder() {
    final String? loginUserId = shared!.getString(Const.VALUE_HOLDER_USER_ID);
    final String? memberId = shared!.getString(Const.VALUE_HOLDER_MEMBER_ID);
    final String? apiToken = shared!.getString(Const.VALUE_HOLDER_API_TOKEN);
    final String? refreshToken =
        shared!.getString(Const.VALUE_HOLDER_REFRESH_TOKEN);
    final String? callAccessToken =
        shared!.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
    final String? assignedNumber =
        shared!.getString(Const.VALUE_HOLDER_ASSIGNED_NUMBER);
    final String? defaultCountryCode =
        shared!.getString(Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE);
    final String? defaultWorkSpace =
        shared!.getString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE);
    final String? workspaceDetail =
        shared!.getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL);
    final String? defaultChannel =
        shared!.getString(Const.VALUE_HOLDER_DEFAULT_CHANNEL);
    final List<String>? channelList =
        shared!.getStringList(Const.VALUE_HOLDER_CHANNEL_LIST);

    final String? userName = shared!.getString(Const.VALUE_HOLDER_USER_NAME);
    final String? userFirstName =
        shared!.getString(Const.VALUE_HOLDER_USER_FIRST_NAME);
    final String? userLastName =
        shared!.getString(Const.VALUE_HOLDER_USER_LAST_NAME);
    final String? userEmail = shared!.getString(Const.VALUE_HOLDER_USER_EMAIL);
    final String? userPassword =
        shared!.getString(Const.VALUE_HOLDER_USER_PASSWORD);
    final String? notificationToken =
        shared!.getString(Const.VALUE_HOLDER_NOTIFICATION_TOKEN);
    final String? sessionId = shared!.getString(Const.VALUE_HOLDER_SESSION_ID);
    final String? selectedSound =
        shared!.getString(Const.VALUE_HOLDER_SELECTED_SOUND);
    final String? userProfilePicture =
        shared!.getString(Const.VALUE_HOLDER_PROFILE_PICTURE);
    final String? voiceToken =
        shared!.getString(Const.VALUE_HOLDER_VOICE_TOKEN);

    final bool? smsNotificationSetting =
        shared!.getBool(Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING);
    final bool? missedCallNotificationSetting =
        shared!.getBool(Const.VALUE_HOLDER_MISSED_CALL_NOTIFICATION_SETTING);
    final bool? voiceMailNotificationSetting =
        shared!.getBool(Const.VALUE_HOLDER_VOICE_MAIL_NOTIFICATION_SETTING);
    final bool? chatMessageNotificationSetting =
        shared!.getBool(Const.VALUE_HOLDER_CHAT_MESSAGE_NOTIFICATION_SETTING);

    final bool? userOnlineStatus =
        shared!.getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS);
    final bool? memberOnlineStatus =
        shared!.getBool(Const.VALUE_HOLDER_MEMBER_ONLINE_STATUS);
    final String? intercomId =
        shared!.getString(Const.VALUE_HOLDER_INTERCOM_ID);

    final ValueHolder valueHolder = ValueHolder(
      loginUserId: loginUserId,
      memberId: memberId,
      apiToken: apiToken,
      refreshToken: refreshToken,
      callAccessToken: callAccessToken,
      assignedNumber: assignedNumber,
      defaultWorkSpace: defaultWorkSpace,
      workspaceDetail: workspaceDetail,
      defaultChannel: defaultChannel,
      channelList: channelList,
      defaultCountryCode: defaultCountryCode,
      userName: userName,
      userFirstName: userFirstName,
      userLastName: userLastName,
      userEmail: userEmail,
      userPassword: userPassword,
      fcmToken: notificationToken,
      sessionId: sessionId,
      selectedSound: selectedSound,
      userProfilePicture: userProfilePicture,
      voiceToken: voiceToken,
      smsNotificationSetting: smsNotificationSetting,
      missedCallNotificationSetting: missedCallNotificationSetting,
      voiceMailNotificationSetting: voiceMailNotificationSetting,
      chatMessageNotificationSetting: chatMessageNotificationSetting,
      userOnlineStatus: userOnlineStatus,
      memberOnlineStatus: memberOnlineStatus,
      intercomId: intercomId,
    );

    _valueController.add(valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_ID, loginUserId);

    loadValueHolder();
  }

  String? getLoginUserId() {
    return shared!.getString(Const.VALUE_HOLDER_USER_ID);
  }

  Future<dynamic> replaceMemberId(String memberId) async {
    await shared!.setString(Const.VALUE_HOLDER_MEMBER_ID, memberId);

    loadValueHolder();
  }

  void clearPrefrence() {
    shared!.clear();
  }

  String getMemberId() {
    return shared!.getString(Const.VALUE_HOLDER_MEMBER_ID)!;
  }

  Future<void> replaceUserOnlineStatus({bool onlineStatus = false}) async {
    await shared!.setBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS, onlineStatus);
    loadValueHolder();
  }

  bool getUserOnlineStatus() {
    return shared!.getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS)!;
  }

  Future<void> replaceMemberOnlineStatus({bool onlineStatus = false}) async {
    await shared!
        .setBool(Const.VALUE_HOLDER_MEMBER_ONLINE_STATUS, onlineStatus);

    loadValueHolder();
  }

  bool getMemberOnlineStatus() {
    return shared!.getBool(Const.VALUE_HOLDER_MEMBER_ONLINE_STATUS)!;
  }

  Future<dynamic> replaceUserName(String userName) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_NAME, userName);

    loadValueHolder();
  }

  String getUserName() {
    return shared!.getString(Const.VALUE_HOLDER_USER_NAME)!;
  }

  Future<dynamic> replaceUserFirstName(String userFirstName) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_FIRST_NAME, userFirstName);

    loadValueHolder();
  }

  String getUserFirstName() {
    return shared!.getString(Const.VALUE_HOLDER_USER_FIRST_NAME)!;
  }

  Future<dynamic> replaceUserLastName(String userLastName) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_LAST_NAME, userLastName);

    loadValueHolder();
  }

  String getUserLastName() {
    return shared!.getString(Const.VALUE_HOLDER_USER_LAST_NAME)!;
  }

  Future<dynamic> replaceUserEmail(String userEmail) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_EMAIL, userEmail);

    loadValueHolder();
  }

  String getUserEmail() {
    return shared!.getString(Const.VALUE_HOLDER_USER_EMAIL)!;
  }

  Future<dynamic> replaceUserPassword(String userPassword) async {
    await shared!.setString(Const.VALUE_HOLDER_USER_PASSWORD, userPassword);

    loadValueHolder();
  }

  String getUserPassword() {
    return shared!.getString(Const.VALUE_HOLDER_USER_PASSWORD)!;
  }

  Future<dynamic> replaceApiToken(String apiToken) async {
    await shared!.setString(Const.VALUE_HOLDER_API_TOKEN, apiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceIntercomId(String id) async {
    await shared!.setString(Const.VALUE_HOLDER_INTERCOM_ID, id);

    loadValueHolder();
  }

  String getIntercomId() {
    return shared!.getString(Const.VALUE_HOLDER_INTERCOM_ID)!;
  }

  String getApiToken() {
    return shared!.getString(Const.VALUE_HOLDER_API_TOKEN)!;
  }

  Future<dynamic> replaceCallAccessToken(String callAccessToken) async {
    await shared!
        .setString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN, callAccessToken);

    loadValueHolder();
  }

  String getCallAccessToken() {
    return shared!.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!;
  }

  Future<dynamic> replaceNotificationToken(String notificationToken) async {
    await shared!
        .setString(Const.VALUE_HOLDER_NOTIFICATION_TOKEN, notificationToken);

    loadValueHolder();
  }

  String getNotificationToken() {
    return shared!.getString(Const.VALUE_HOLDER_NOTIFICATION_TOKEN)!;
  }

  Future<dynamic> replaceAssignedNumber(String assignedNumber) async {
    await shared!.setString(Const.VALUE_HOLDER_ASSIGNED_NUMBER, assignedNumber);

    loadValueHolder();
  }

  String getAssignedNumber() {
    return shared!.getString(Const.VALUE_HOLDER_ASSIGNED_NUMBER)!;
  }

  Future<dynamic> replaceDefaultCountryCode(String defaultCountryCode) async {
    await shared!
        .setString(Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE, defaultCountryCode);

    loadValueHolder();
  }

  String getDefaultCountryCode() {
    return shared!.getString(Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE)!;
  }

  Future<dynamic> replaceSmsNotificationSetting(
      bool smsNotificationSetting) async {
    await shared!.setBool(
        Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING, smsNotificationSetting);

    loadValueHolder();
  }

  bool getSmsNotificationSetting() {
    return shared!.getBool(Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING)!;
  }

  Future<dynamic> replaceMissedCallNotificationSetting(
      bool missedCallNotificationSetting) async {
    await shared!.setBool(Const.VALUE_HOLDER_MISSED_CALL_NOTIFICATION_SETTING,
        missedCallNotificationSetting);

    loadValueHolder();
  }

  bool getMissedCallNotificationSetting() {
    return shared!
        .getBool(Const.VALUE_HOLDER_MISSED_CALL_NOTIFICATION_SETTING)!;
  }

  Future<dynamic> replaceVoiceMailNotificationSetting(
      bool voiceMailNotificationSetting) async {
    await shared!.setBool(Const.VALUE_HOLDER_VOICE_MAIL_NOTIFICATION_SETTING,
        voiceMailNotificationSetting);

    loadValueHolder();
  }

  bool getVoiceMailNotificationSetting() {
    return shared!.getBool(Const.VALUE_HOLDER_VOICE_MAIL_NOTIFICATION_SETTING)!;
  }

  Future<dynamic> replaceChatMessageNotificationSetting(
      bool chatMessageNotificationSetting) async {
    await shared!.setBool(Const.VALUE_HOLDER_CHAT_MESSAGE_NOTIFICATION_SETTING,
        chatMessageNotificationSetting);

    loadValueHolder();
  }

  bool getChatMessageNotificationSetting() {
    return shared!
        .getBool(Const.VALUE_HOLDER_CHAT_MESSAGE_NOTIFICATION_SETTING)!;
  }

  Future<dynamic> replaceDefaultWorkspace(String defaultWorkSpace) async {
    await shared!
        .setString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE, defaultWorkSpace);

    loadValueHolder();
  }

  String getDefaultWorkspace() {
    return shared!.getString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE)!;
  }

  Future<dynamic> replaceWorkspaceDetail(String workspaceDetail) async {
    await shared!
        .setString(Const.VALUE_HOLDER_WORKSPACE_DETAIL, workspaceDetail);
    loadValueHolder();
  }

  String getWorkspaceDetail() {
    return shared!.getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL)!;
  }

  Future<dynamic> replaceDefaultChannel(String? defaultChannel) async {
    if (defaultChannel != null) {
      await shared!
          .setString(Const.VALUE_HOLDER_DEFAULT_CHANNEL, defaultChannel);
      loadValueHolder();
    } else {
      await shared!.setString(Const.VALUE_HOLDER_DEFAULT_CHANNEL, "{}");
      loadValueHolder();
    }
  }

  String getDefaultChannel() {
    return shared!.getString(Const.VALUE_HOLDER_DEFAULT_CHANNEL)!;
  }

  Future<dynamic> replaceWorkspaceList(List<String> workspaceList) async {
    await shared!
        .setStringList(Const.VALUE_HOLDER_WORKSPACE_LIST, workspaceList);

    loadValueHolder();
  }

  List<String> getWorkspaceList() {
    return shared!.getStringList(Const.VALUE_HOLDER_WORKSPACE_LIST)!;
  }

  Future<dynamic> replaceChannelList(List<String> channelList) async {
    await shared!.setStringList(Const.VALUE_HOLDER_CHANNEL_LIST, channelList);

    loadValueHolder();
  }

  List<String> getChannelList() {
    return shared!.getStringList(Const.VALUE_HOLDER_CHANNEL_LIST)!;
  }

  Future<dynamic> replaceVoiceToken(String defaultChannel) async {
    await shared!.setString(Const.VALUE_HOLDER_VOICE_TOKEN, defaultChannel);

    loadValueHolder();
  }

  String? getVoiceToken() {
    return shared!.getString(Const.VALUE_HOLDER_VOICE_TOKEN);
  }

  Future<dynamic> replaceUserProfilePicture(String profilePic) async {
    await shared!.setString(Const.VALUE_HOLDER_PROFILE_PICTURE, profilePic);

    loadValueHolder();
  }

  String getUserProfilePicture() {
    return shared!.getString(Const.VALUE_HOLDER_PROFILE_PICTURE)!;
  }

  Future<dynamic> replaceSessionId(String sessionId) async {
    await shared!.setString(Const.VALUE_HOLDER_SESSION_ID, sessionId);

    loadValueHolder();
  }

  String getSessionId() {
    return shared!.getString(Const.VALUE_HOLDER_SESSION_ID)!;
  }

  Future<dynamic> replaceRefreshToken(String token) async {
    await shared!.setString(Const.VALUE_HOLDER_REFRESH_TOKEN, token);
    loadValueHolder();
  }

  String getRefreshToken() {
    return shared!.getString(Const.VALUE_HOLDER_REFRESH_TOKEN)!;
  }

  Future<dynamic> replaceSelectedSound(String selectedSound) async {
    await shared!.setString(Const.VALUE_HOLDER_SELECTED_SOUND, selectedSound);
    loadValueHolder();
  }

  String getSelectedSound() {
    return shared!.getString(Const.VALUE_HOLDER_SELECTED_SOUND) ?? "";
  }

  Future<dynamic> replaceContactsList(String selectedSound) async {
    await shared!.setString(Const.VALUE_HOLDER_CONTACT_LIST, selectedSound);
    loadValueHolder();
  }

  String getContactList() {
    return shared!.getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
  }

  ///Plan Overview Pref
  Future<dynamic> replacePlanOverview(String planOverview) async {
    if (planOverview != null) {
      await shared!.setString(Const.VALUE_HOLDER_PLAN_OVERVIEW, planOverview);
      loadValueHolder();
    } else {
      await shared!.setString(Const.VALUE_HOLDER_PLAN_OVERVIEW, "{}");
      loadValueHolder();
    }
  }

  String getPlanOverview() {
    return shared!.getString(Const.VALUE_HOLDER_PLAN_OVERVIEW)!;
  }

  ///Permissions Pref
  ///
  ///
  Future<dynamic> replaceAllowWorkspaceViewSwitchWorkspace(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_VIEW_SWITCH_WORKSPACE, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceViewSwitchWorkspace() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_VIEW_SWITCH_WORKSPACE)!;
  }

  Future<dynamic> replaceAllowWorkspaceCreateWorkspace(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_CREATE_NEW_WORKSPACE, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceCreateWorkspace() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_CREATE_NEW_WORKSPACE)!;
  }

  Future<dynamic> replaceAllowWorkspaceEditWorkspace(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_EDIT_WORKSPACE, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceEditWorkspace() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_EDIT_WORKSPACE)!;
  }

  Future<dynamic> replaceAllowNavigationSearch(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_SEARCH, value);
    loadValueHolder();
  }

  bool getAllowNavigationSearch() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_SEARCH)!;
  }

  Future<dynamic> replaceAllowNavigationShowDialer(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_SHOW_DIALER, value);
    loadValueHolder();
  }

  bool getAllowNavigationShowDialer() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_SHOW_DIALER)!;
  }

  Future<dynamic> replaceAllowNavigationShowDashboard(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_SHOW_DASHBOARD, value);
    loadValueHolder();
  }

  bool getAllowNavigationShowDashboard() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_SHOW_DASHBOARD)!;
  }

  Future<dynamic> replaceAllowNavigationShowContact(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_SHOW_CONTACT, value);
    loadValueHolder();
  }

  bool getAllowNavigationShowContact() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_SHOW_CONTACT)!;
  }

  Future<dynamic> replaceAllowNavigationShowSetting(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_SHOW_SETTING, value);
    loadValueHolder();
  }

  bool getAllowNavigationShowSetting() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_SHOW_SETTING)!;
  }

  Future<dynamic> replaceAllowNavigationAddNewNumber(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_ADD_NEW_NUMBER, value);
    loadValueHolder();
  }

  bool getAllowNavigationAddNewNumber() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_ADD_NEW_NUMBER)!;
  }

  Future<dynamic> replaceAllowNavigationViewNumberDetails(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_VIEW_NUMBER_DETAILS, value);
    loadValueHolder();
  }

  bool getAllowNavigationViewNumberDetails() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_VIEW_NUMBER_DETAILS)!;
  }

  Future<dynamic> replaceAllowNavigationNumberDnd(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_NUMBER_DND, value);
    loadValueHolder();
  }

  bool getAllowNavigationNumberDnd() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_NUMBER_DND)!;
  }

  Future<dynamic> replaceAllowNavigationNumberSetting(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_NUMBER_SETTINGS, value);
    loadValueHolder();
  }

  bool getAllowNavigationNumberSetting() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_NUMBER_SETTINGS)!;
  }

  Future<dynamic> replaceAllowNavigationAddNewMember(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_ADD_NEW_MEMBER, value);
    loadValueHolder();
  }

  bool getAllowNavigationAddNewMember() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_ADD_NEW_MEMBER)!;
  }

  Future<dynamic> replaceAllowNavigationAddNewTeam(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_ADD_NEW_TEAM, value);
    loadValueHolder();
  }

  bool getAllowNavigationAddNewTeam() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_ADD_NEW_TEAM)!;
  }

  Future<dynamic> replaceAllowNavigationViewTagDetails(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_VIEW_TAG_DETAILS, value);
    loadValueHolder();
  }

  bool getAllowNavigationViewTagDetails() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_VIEW_TAG_DETAILS)!;
  }

  Future<dynamic> replaceAllowNavigationAddNewTags(bool value) async {
    await shared!.setBool(Const.ALLOW_NAVIGATION_ADD_NEW_TAGS, value);
    loadValueHolder();
  }

  bool getAllowNavigationAddNewTags() {
    return shared!.getBool(Const.ALLOW_NAVIGATION_ADD_NEW_TAGS)!;
  }

  Future<dynamic> replaceAllowContactSearchContact(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_SEARCH_CONTACT, value);
    loadValueHolder();
  }

  bool getAllowContactSearchContact() {
    return shared!.getBool(Const.ALLOW_CONTACT_SEARCH_CONTACT)!;
  }

  Future<dynamic> replaceAllowContactAddNewContact(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_ADD_NEW_CONTACT, value);
    loadValueHolder();
  }

  bool getAllowContactAddNewContact() {
    return shared!.getBool(Const.ALLOW_CONTACT_ADD_NEW_CONTACT)!;
  }

  Future<dynamic> replaceAllowContactCSVImport(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_CSV_IMPORT, value);
    loadValueHolder();
  }

  bool getAllowContactCSVImport() {
    return shared!.getBool(Const.ALLOW_CONTACT_CSV_IMPORT)!;
  }

  Future<dynamic> replaceAllowShowTableView(bool value) async {
    await shared!.setBool(Const.ALLOW_SHOW_TABLE_VIEW, value);
    loadValueHolder();
  }

  bool getAllowShowTableView() {
    return shared!.getBool(Const.ALLOW_SHOW_TABLE_VIEW)!;
  }

  Future<dynamic> replaceAllowProfileEditFullName(bool value) async {
    await shared!.setBool(Const.ALLOW_PROFILE_EDIT_FULL_NAME, value);
    loadValueHolder();
  }

  bool getAllowProfileEditFullName() {
    return shared!.getBool(Const.ALLOW_PROFILE_EDIT_FULL_NAME)!;
  }

  Future<dynamic> replaceAllowProfileEditEmail(bool value) async {
    await shared!.setBool(Const.ALLOW_PROFILE_EDIT_EMAIL, value);
    loadValueHolder();
  }

  bool getAllowProfileEditEmail() {
    return shared!.getBool(Const.ALLOW_PROFILE_EDIT_EMAIL)!;
  }

  Future<dynamic> replaceAllowProfileChangePassword(bool value) async {
    await shared!.setBool(Const.ALLOW_PROFILE_CHANGE_PASSWORD, value);
    loadValueHolder();
  }

  bool getAllowProfileChangePassword() {
    return shared!.getBool(Const.ALLOW_PROFILE_CHANGE_PASSWORD)!;
  }

  Future<dynamic> replaceAllowProfileChangeProfilePicture(bool value) async {
    await shared!.setBool(Const.ALLOW_PROFILE_CHANGE_PROFILE_PICTURE, value);
    loadValueHolder();
  }

  bool getAllowProfileChangeProfilePicture() {
    return shared!.getBool(Const.ALLOW_PROFILE_CHANGE_PROFILE_PICTURE)!;
  }

  Future<dynamic> replaceAllowMyNumberPortConfig(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_PORT_CONFIG, value);
    loadValueHolder();
  }

  bool getAllowMyNumberPortConfig() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_PORT_CONFIG)!;
  }

  Future<dynamic> replaceAllowMyNumberAddNewNumber(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_ADD_NEW_NUMBER, value);
    loadValueHolder();
  }

  bool getAllowMyNumberAddNewNumber() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_ADD_NEW_NUMBER)!;
  }

  Future<dynamic> replaceAllowMyNumberViewNumberList(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_VIEW_NUMBER_LIST, value);
    loadValueHolder();
  }

  bool getAllowMyNumberViewNumberList() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_VIEW_NUMBER_LIST)!;
  }

  Future<dynamic> replaceAllowMyNumberEditDetails(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_EDIT_DETAILS, value);
    loadValueHolder();
  }

  bool getAllowMyNumberEditDetails() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_EDIT_DETAILS)!;
  }

  Future<dynamic> replaceAllowMyNumberAutoRecord(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_AUTO_RECORD, value);
    loadValueHolder();
  }

  bool getAllowMyNumberAutoRecord() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_AUTO_RECORD)!;
  }

  Future<dynamic> replaceAllowMyNumberInternationalCall(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_INTERNATIONAL_CALL, value);
    loadValueHolder();
  }

  bool getAllowMyNumberInternationalCall() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_INTERNATIONAL_CALL)!;
  }

  Future<dynamic> replaceAllowMyNumberShareAccess(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_SHARE_ACCESS, value);
    loadValueHolder();
  }

  bool getAllowMyNumberShareAccess() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_SHARE_ACCESS)!;
  }

  Future<dynamic> replaceAllowMyNumberAutoVoiceMailTranscription(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_MY_NUMBER_AUTO_VOICE_MAIL_TRANSCRIPTION, value);
    loadValueHolder();
  }

  bool getAllowMyNumberAutoVoiceMailTranscription() {
    return shared!
        .getBool(Const.ALLOW_MY_NUMBER_AUTO_VOICE_MAIL_TRANSCRIPTION)!;
  }

  Future<dynamic> replaceAllowMyNumberDelete(bool value) async {
    await shared!.setBool(Const.ALLOW_MY_NUMBER_DELETE, value);
    loadValueHolder();
  }

  bool getAllowMyNumberDelete() {
    return shared!.getBool(Const.ALLOW_MY_NUMBER_DELETE)!;
  }

  Future<dynamic> replaceAllowMemberAddNewMember(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_ADD_NEW_MEMBER, value);
    loadValueHolder();
  }

  bool getAllowMemberAddNewMember() {
    return shared!.getBool(Const.ALLOW_MEMBER_ADD_NEW_MEMBER)!;
  }

  Future<dynamic> replaceAllowMemberMemberList(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_MEMBER_LIST, value);
    loadValueHolder();
  }

  bool getAllowMemberMemberList() {
    return shared!.getBool(Const.ALLOW_MEMBER_MEMBER_LIST)!;
  }

  Future<dynamic> replaceAllowMemberViewAssignedNumber(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_VIEW_ASSIGNED_NUMBER, value);
    loadValueHolder();
  }

  bool getAllowMemberViewAssignedNumber() {
    return shared!.getBool(Const.ALLOW_MEMBER_VIEW_ASSIGNED_NUMBER)!;
  }

  Future<dynamic> replaceAllowMemberDeleteMember(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_DELETE_MEMBER, value);
    loadValueHolder();
  }

  bool getAllowMemberDeleteMember() {
    return shared!.getBool(Const.ALLOW_MEMBER_DELETE_MEMBER)!;
  }

  Future<dynamic> replaceAllowMemberInvite(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_INVITE, value);
    loadValueHolder();
  }

  bool getAllowMemberInvite() {
    return shared!.getBool(Const.ALLOW_MEMBER_INVITE)!;
  }

  Future<dynamic> replaceAllowMemberReInvite(bool value) async {
    await shared!.setBool(Const.ALLOW_MEMBER_RE_INVITE, value);
    loadValueHolder();
  }

  bool getAllowMemberReInvite() {
    return shared!.getBool(Const.ALLOW_MEMBER_RE_INVITE)!;
  }

  Future<dynamic> replaceAllowTeamCreateTeam(bool value) async {
    await shared!.setBool(Const.ALLOW_TEAM_CREATE_TEAM, value);
    loadValueHolder();
  }

  bool getAllowTeamCreateTeam() {
    return shared!.getBool(Const.ALLOW_TEAM_CREATE_TEAM)!;
  }

  Future<dynamic> replaceAllowTeamTeamList(bool value) async {
    await shared!.setBool(Const.ALLOW_TEAM_TEAM_LIST, value);
    loadValueHolder();
  }

  bool getAllowTeamTeamList() {
    return shared!.getBool(Const.ALLOW_TEAM_TEAM_LIST)!;
  }

  Future<dynamic> replaceAllowTeamEdit(bool value) async {
    await shared!.setBool(Const.ALLOW_TEAM_EDIT, value);
    loadValueHolder();
  }

  bool getAllowTeamEdit() {
    return shared!.getBool(Const.ALLOW_TEAM_EDIT)!;
  }

  Future<dynamic> replaceAllowTeamDelete(bool value) async {
    await shared!.setBool(Const.ALLOW_TEAM_DELETE, value);
    loadValueHolder();
  }

  bool getAllowTeamDelete() {
    return shared!.getBool(Const.ALLOW_TEAM_DELETE)!;
  }

  Future<dynamic> replaceAllowContactAddNewIntegration(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_ADD_NEW_INTEGRATION, value);
    loadValueHolder();
  }

  bool getAllowContactAddNewIntegration() {
    return shared!.getBool(Const.ALLOW_CONTACT_ADD_NEW_INTEGRATION)!;
  }

  Future<dynamic> replaceAllowContactIntegrationGoogle(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_INTEGRATION_GOOGLE, value);
    loadValueHolder();
  }

  bool getAllowContactIntegrationGoogle() {
    return shared!.getBool(Const.ALLOW_CONTACT_INTEGRATION_GOOGLE)!;
  }

  Future<dynamic> replaceAllowContactIntegrationPipeDrive(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_INTEGRATION_PIPE_DRIVE, value);
    loadValueHolder();
  }

  bool getAllowContactIntegrationPipeDrive() {
    return shared!.getBool(Const.ALLOW_CONTACT_INTEGRATION_PIPE_DRIVE)!;
  }

  Future<dynamic> replaceAllowContactImportCsv(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_IMPORT_CSV, value);
    loadValueHolder();
  }

  bool getAllowContactImportCsv() {
    return shared!.getBool(Const.ALLOW_CONTACT_IMPORT_CSV)!;
  }

  Future<dynamic> replaceAllowContactDeleteContacts(bool value) async {
    await shared!.setBool(Const.ALLOW_CONTACT_DELETE_CONTACTS, value);
    loadValueHolder();
  }

  bool getAllowContactDeleteContacts() {
    return shared!.getBool(Const.ALLOW_CONTACT_DELETE_CONTACTS)!;
  }

  Future<dynamic> replaceAllowWorkspaceUpdateProfilePicture(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_UPDATE_PROFILE_PICTURE, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceUpdateProfilePicture() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_UPDATE_PROFILE_PICTURE)!;
  }

  Future<dynamic> replaceAllowWorkspaceChangeName(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_CHANGE_NAME, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceChangeName() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_CHANGE_NAME)!;
  }

  Future<dynamic> replaceAllowWorkspaceEnableNotification(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_ENABLE_NOTIFICATION, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceEnableNotification() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_ENABLE_NOTIFICATION)!;
  }

  Future<dynamic> replaceAllowWorkspaceDelete(bool value) async {
    await shared!.setBool(Const.ALLOW_WORKSPACE_DELETE, value);
    loadValueHolder();
  }

  bool getAllowWorkspaceDelete() {
    return shared!.getBool(Const.ALLOW_WORKSPACE_DELETE)!;
  }

  Future<dynamic> replaceAllowIntegrationEnabled(bool value) async {
    await shared!.setBool(Const.ALLOW_INTEGRATION_ENABLED, value);
    loadValueHolder();
  }

  bool getAllowIntegrationEnabled() {
    return shared!.getBool(Const.ALLOW_INTEGRATION_ENABLED)!;
  }

  Future<dynamic> replaceAllowIntegrationOtherIntegration(bool value) async {
    await shared!.setBool(Const.ALLOW_INTEGRATION_OTHER_INTEGRATION, value);
    loadValueHolder();
  }

  bool getAllowIntegrationOtherIntegration() {
    return shared!.getBool(Const.ALLOW_INTEGRATION_OTHER_INTEGRATION)!;
  }

  Future<dynamic> replaceAllowBillingOverviewChangePlan(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_OVERVIEW_CHANGE_PLAN, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewChangePlan() {
    return shared!.getBool(Const.ALLOW_BILLING_OVERVIEW_CHANGE_PLAN)!;
  }

  Future<dynamic> replaceAllowBillingOverviewPurchaseCredit(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_OVERVIEW_PURCHASE_CREDIT, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewPurchaseCredit() {
    return shared!.getBool(Const.ALLOW_BILLING_OVERVIEW_PURCHASE_CREDIT)!;
  }

  Future<dynamic> replaceAllowBillingOverviewManageCardAdd(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_OVERVIEW_MANAGE_CARD_ADD, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewManageCardAdd() {
    return shared!.getBool(Const.ALLOW_BILLING_OVERVIEW_MANAGE_CARD_ADD)!;
  }

  Future<dynamic> replaceAllowBillingOverviewManageCardDelete(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_BILLING_OVERVIEW_MANAGE_CARD_DELETE, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewManageCardDelete() {
    return shared!.getBool(Const.ALLOW_BILLING_OVERVIEW_MANAGE_CARD_DELETE)!;
  }

  Future<dynamic> replaceAllowBillingOverviewHideKrispcallBranding(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_BILLING_OVERVIEW_HIDE_KRISPCALL_BRANDING, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewHideKrispcallBranding() {
    return shared!
        .getBool(Const.ALLOW_BILLING_OVERVIEW_HIDE_KRISPCALL_BRANDING)!;
  }

  Future<dynamic> replaceAllowBillingOverviewNotificationAutoRecharge(
      bool value) async {
    await shared!.setBool(
        Const.ALLOW_BILLING_OVERVIEW_NOTIFICATION_AUTO_RECHARGE, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewNotificationAutoRecharge() {
    return shared!
        .getBool(Const.ALLOW_BILLING_OVERVIEW_NOTIFICATION_AUTO_RECHARGE)!;
  }

  Future<dynamic> replaceAllowBillingOverviewCancelSubscription(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_BILLING_OVERVIEW_CANCEL_SUBSCRIPTION, value);
    loadValueHolder();
  }

  bool getAllowBillingOverviewCancelSubscription() {
    return shared!.getBool(Const.ALLOW_BILLING_OVERVIEW_CANCEL_SUBSCRIPTION)!;
  }

  Future<dynamic> replaceAllowBillingSaveBillingInfo(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_SAVE_BILLING_INFO, value);
    loadValueHolder();
  }

  bool getAllowBillingSaveBillingInfo() {
    return shared!.getBool(Const.ALLOW_BILLING_SAVE_BILLING_INFO)!;
  }

  Future<dynamic> replaceAllowBillingReceiptsViewList(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_RECEIPTS_VIEW_LIST, value);
    loadValueHolder();
  }

  bool getAllowBillingReceiptsViewList() {
    return shared!.getBool(Const.ALLOW_BILLING_RECEIPTS_VIEW_LIST)!;
  }

  Future<dynamic> replaceAllowBillingReceiptsViewInvoice(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_RECEIPTS_VIEW_INVOICE, value);
    loadValueHolder();
  }

  bool getAllowBillingReceiptsViewInvoice() {
    return shared!.getBool(Const.ALLOW_BILLING_RECEIPTS_VIEW_INVOICE)!;
  }

  Future<dynamic> replaceAllowBillingReceiptsDownloadInvoice(bool value) async {
    await shared!.setBool(Const.ALLOW_BILLING_RECEIPTS_DOWNLOAD_INVOICE, value);
    loadValueHolder();
  }

  bool getAllowBillingReceiptsDownloadInvoice() {
    return shared!.getBool(Const.ALLOW_BILLING_RECEIPTS_DOWNLOAD_INVOICE)!;
  }

  Future<dynamic> replaceAllowDeviceSelectInputDevice(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_SELECT_INPUT_DEVICE, value);
    loadValueHolder();
  }

  bool getAllowDeviceSelectInputDevice() {
    return shared!.getBool(Const.ALLOW_DEVICE_SELECT_INPUT_DEVICE)!;
  }

  Future<dynamic> replaceAllowDeviceSelectOutputDevice(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_SELECT_OUTPUT_DEVICE, value);
    loadValueHolder();
  }

  bool getAllowDeviceSelectOutputDevice() {
    return shared!.getBool(Const.ALLOW_DEVICE_SELECT_OUTPUT_DEVICE)!;
  }

  Future<dynamic> replaceAllowDeviceAdjustInputVolume(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_ADJUST_INPUT_VOLUME, value);
    loadValueHolder();
  }

  bool getAllowDeviceAdjustInputVolume() {
    return shared!.getBool(Const.ALLOW_DEVICE_ADJUST_INPUT_VOLUME)!;
  }

  Future<dynamic> replaceAllowDeviceAdjustOutputVolume(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_ADJUST_OUTPUT_VOLUME, value);
    loadValueHolder();
  }

  bool getAllowDeviceAdjustOutputVolume() {
    return shared!.getBool(Const.ALLOW_DEVICE_ADJUST_OUTPUT_VOLUME)!;
  }

  Future<dynamic> replaceAllowDeviceMicTest(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_MIC_TEST, value);
    loadValueHolder();
  }

  bool getAllowDeviceMicTest() {
    return shared!.getBool(Const.ALLOW_DEVICE_MIC_TEST)!;
  }

  Future<dynamic> replaceAllowDeviceCancelEcho(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_CANCEL_ECHO, value);
    loadValueHolder();
  }

  bool getAllowDeviceCancelEcho() {
    return shared!.getBool(Const.ALLOW_DEVICE_CANCEL_ECHO)!;
  }

  Future<dynamic> replaceAllowDeviceReduceNoise(bool value) async {
    await shared!.setBool(Const.ALLOW_DEVICE_REDUCE_NOISE, value);
    loadValueHolder();
  }

  bool getAllowDeviceReduceNoise() {
    return shared!.getBool(Const.ALLOW_DEVICE_REDUCE_NOISE)!;
  }

  Future<dynamic> replaceAllowNotificationEnableDesktopNotification(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_NOTIFICATION_ENABLE_DESKTOP_NOTIFICATION, value);
    loadValueHolder();
  }

  bool getAllowNotificationEnableDesktopNotification() {
    return shared!
        .getBool(Const.ALLOW_NOTIFICATION_ENABLE_DESKTOP_NOTIFICATION)!;
  }

  Future<dynamic> replaceAllowNotificationEnableNewCallMessage(
      bool value) async {
    await shared!
        .setBool(Const.ALLOW_NOTIFICATION_ENABLE_NEW_CALL_MESSAGE, value);
    loadValueHolder();
  }

  bool getAllowNotificationEnableNewCallMessage() {
    return shared!.getBool(Const.ALLOW_NOTIFICATION_ENABLE_NEW_CALL_MESSAGE)!;
  }

  Future<dynamic> replaceAllowNotificationEnableNewLeads(bool value) async {
    await shared!.setBool(Const.ALLOW_NOTIFICATION_ENABLE_NEW_LEADS, value);
    loadValueHolder();
  }

  bool getAllowNotificationEnableNewLeads() {
    return shared!.getBool(Const.ALLOW_NOTIFICATION_ENABLE_NEW_LEADS)!;
  }

  Future<dynamic> replaceAllowNotificationEnableFlashTaskBar(bool value) async {
    await shared!
        .setBool(Const.ALLOW_NOTIFICATION_ENABLE_FLASH_TASK_BAR, value);
    loadValueHolder();
  }

  bool getAllowNotificationEnableFlashTaskBar() {
    return shared!.getBool(Const.ALLOW_NOTIFICATION_ENABLE_FLASH_TASK_BAR)!;
  }

  Future<dynamic> replaceAllowLanguageSwitch(bool value) async {
    await shared!.setBool(Const.ALLOW_LANGUAGE_SWITCH, value);
    loadValueHolder();
  }

  bool getAllowLanguageSwitch() {
    return shared!.getBool(Const.ALLOW_LANGUAGE_SWITCH)!;
  }

  Future<void> replaceDefaultWorkspaceDetails(String json) async {
    await shared!.setString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE_DETAILS, json);
  }

  void setUserDndTimeList(String json) {
    shared!.setString(Const.VALUE_HOLDER_USER_DND_TIME_LIST, json);
  }

  String getUserDndTimeList() {
    return shared!.get(Const.VALUE_HOLDER_USER_DND_TIME_LIST)! as String;
  }

  void setUserDndEnabledTimeValue(String value) {
    shared!.setString(Const.VALUE_HOLDER_USER_DND_TIME_VALUE, value);
  }

  String getUserDndEnabledTimeValue() {
    return shared!.get(Const.VALUE_HOLDER_USER_DND_TIME_VALUE) != null
        ? shared!.get(Const.VALUE_HOLDER_USER_DND_TIME_VALUE)! as String
        : "";
  }

  void setChannelDndTimeList(String json) {
    shared!.setString(Const.VALUE_HOLDER_CHANNEL_DND_TIME_LIST, json);
  }

  String getChannelDndTimeList() {
    return shared!.get(Const.VALUE_HOLDER_CHANNEL_DND_TIME_LIST)! as String;
  }
}
