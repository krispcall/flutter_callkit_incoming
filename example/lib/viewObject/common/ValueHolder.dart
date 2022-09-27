
class ValueHolder {
  ValueHolder({
    this.loginUserId,
    this.memberId,
    this.apiToken,
    this.callAccessToken,
    this.assignedNumber,
    this.userName,
    this.userFirstName,
    this.userLastName,
    this.userEmail,
    this.userPassword,
    this.userProfilePicture,
    this.voiceToken,
    this.fcmToken,
    this.refreshToken,
    this.sessionId,
    this.selectedSound,
    this.defaultWorkSpace,
    this.workspaceDetail,
    this.defaultChannel,
    this.channelList,
    this.defaultCountryCode,
    this.smsNotificationSetting,
    this.missedCallNotificationSetting,
    this.voiceMailNotificationSetting,
    this.chatMessageNotificationSetting,
    this.userOnlineStatus,
    this.memberOnlineStatus,
    this.intercomId,
  });

  String? loginUserId;
  String? memberId;
  String? apiToken;
  String? callAccessToken;
  String? assignedNumber;
  String? userName;
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userPassword;
  String? userProfilePicture;
  String? voiceToken;
  String? fcmToken;
  String? outGoingNumber;
  String? outGoingContactName;
  String? refreshToken;
  String? sessionId;
  String? selectedSound;
  bool? smsNotificationSetting;
  bool? missedCallNotificationSetting;
  bool? voiceMailNotificationSetting;
  bool? chatMessageNotificationSetting;
  String? defaultWorkSpace;
  String? workspaceDetail;
  String? defaultChannel;
  List<String>? channelList;
  String? defaultCountryCode;
  bool? userOnlineStatus;
  bool? memberOnlineStatus;
  String? intercomId;
}
