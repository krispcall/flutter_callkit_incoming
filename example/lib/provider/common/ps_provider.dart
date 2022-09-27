import "dart:convert";

import "package:flutter/foundation.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/overview/OverviewData.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class Provider extends ChangeNotifier {
  Provider(this.psRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  Repository psRepository;

  int offset = 0;
  int limit = Config.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
    psRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
    psRepository.replaceLoginUserId(loginUserId);
  }

  String? getLoginUserId() {
    return psRepository.getLoginUserId();
  }

  Future<void> replaceIntercomId(String id) async {
    psRepository.replaceIntercomId(id);
  }

  String getIntercomId() {
    return psRepository.getIntercomId();
  }

  Future<void> replaceMemberId(String memberId) async {
    psRepository.replaceMemberId(memberId);
  }

  String getMemberId() {
    return psRepository.getMemberId();
  }

  Future<void> replaceUserOnlineStatus(bool onlineStatus) async {
    psRepository.replaceUserOnlineStatus(onlineStatus);
  }

  bool getUserOnlineStatus() {
    return (psRepository.getUserOnlineStatus())
        ? psRepository.getUserOnlineStatus()
        : false;
  }

  Future<void> replaceMemberOnlineStatus(bool onlineStatus) async {
    psRepository.replaceMemberOnlineStatus(onlineStatus);
  }

  bool getMemberOnlineStatus() {
    return (psRepository.getMemberOnlineStatus())
        ? psRepository.getMemberOnlineStatus()
        : false;
  }

  Future<void> replaceUserName(String userName) async {
    psRepository.replaceUserName(userName);
  }

  String getUserName() {
    return psRepository.getUserName();
  }

  Future<void> replaceUserFirstName(String userFirstName) async {
    psRepository.replaceUserFirstName(userFirstName);
  }

  String getUserFirstName() {
    return psRepository.getUserFirstName();
  }

  Future<void> replaceUserLastName(String userName) async {
    psRepository.replaceUserLastName(userName);
  }

  String getUserLastName() {
    return psRepository.getUserLastName();
  }

  Future<void> replaceUserEmail(String userEmail) async {
    psRepository.replaceUserEmail(userEmail);
  }

  String getUserEmail() {
    return psRepository.getUserEmail();
  }

  Future<void> replaceUserPassword(String userPassword) async {
    psRepository.replaceUserPassword(userPassword);
  }

  String getUserPassword() {
    return psRepository.getUserPassword();
  }

  Future<void> replaceApiToken(String apiToken) async {
    psRepository.replaceApiToken(apiToken);
  }

  String getApiToken() {
    return psRepository.getApiToken();
  }

  Future<void> replaceCallAccessToken(String callAccessToken) async {
    psRepository.replaceCallAccessToken(callAccessToken);
  }

  String getCallAccessToken() {
    return psRepository.getCallAccessToken();
  }

  Future<void> replaceNotificationToken(String notificationToken) async {
    psRepository.replaceNotificationToken(notificationToken);
  }

  String getNotificationToken() {
    return psRepository.getNotificationToken();
  }

  Future<void> replaceAssignedNumber(String assignedNumber) async {
    psRepository.replaceAssignedNumber(assignedNumber);
  }

  String getAssignedNumber() {
    return psRepository.getAssignedNumber();
  }

  Future<void> replaceDefaultCountryCode(String defaultCountryCode) async {
    psRepository.replaceDefaultCountryCode(defaultCountryCode);
  }

  Future<void> replaceSmsNotificationSetting(
      bool smsNotificationSetting) async {
    psRepository.replaceSmsNotificationSetting(smsNotificationSetting);
  }

  bool getSmsNotificationSetting() {
    return psRepository.getSmsNotificationSetting();
  }

  Future<void> replaceMissedCallNotificationSetting(
      bool missedCallNotificationSetting) async {
    psRepository
        .replaceMissedCallNotificationSetting(missedCallNotificationSetting);
  }

  bool getMissedCallNotificationSetting() {
    return psRepository.getMissedCallNotificationSetting();
  }

  Future<void> replaceVoiceMailNotificationSetting(
      bool voiceMailNotificationSetting) async {
    psRepository
        .replaceVoiceMailNotificationSetting(voiceMailNotificationSetting);
  }

  bool getVoiceMailNotificationSetting() {
    return psRepository.getVoiceMailNotificationSetting();
  }

  Future<void> replaceChatMessageNotificationSetting(
      bool chatMessageNotificationSetting) async {
    psRepository
        .replaceChatMessageNotificationSetting(chatMessageNotificationSetting);
  }

  bool getChatMessageNotificationSetting() {
    return psRepository.getChatMessageNotificationSetting();
  }

  Future<void> replaceDefaultWorkspace(String? defaultWorkSpace) async {
    psRepository.replaceDefaultWorkspace(defaultWorkSpace!);
  }

  String getDefaultWorkspace() {
    return psRepository.getDefaultWorkspace();
  }

  Future<void> replaceWorkspaceDetail(LoginWorkspace workspaceDetail) async {
    psRepository.replaceWorkspaceDetail(
        json.encode(LoginWorkspace().toMap(workspaceDetail)));
  }

  LoginWorkspace getWorkspaceDetail() {
    return psRepository.getWorkspaceDetail()!;
  }

  Future<void> replaceDefaultChannel(String defaultChannel) async {
    psRepository.replaceDefaultChannel(defaultChannel);
  }

  WorkspaceChannel getDefaultChannel() {
    return psRepository.getDefaultChannel();
  }

  Future<void> replaceWorkspaceList(List<LoginWorkspace> workspaceList) async {
    psRepository.replaceWorkspaceList(workspaceList);
  }

  List<LoginWorkspace>? getWorkspaceList() {
    return psRepository.getWorkspaceList();
  }

  List<WorkspaceChannel>? getChannelList() {
    return psRepository.getChannelList();
  }

  void replaceVoiceToken(String voiceToken) {
    psRepository.replaceVoiceToken(voiceToken);
  }

  String? getVoiceToken() {
    return psRepository.getVoiceToken();
  }

  Future<void> replaceUserProfilePicture(String profilePicture) async {
    psRepository.replaceUserProfilePicture(profilePicture);
  }

  String getUserProfilePicture() {
    return psRepository.getUserProfilePicture();
  }

  void replaceSessionId(String sessionId) {
    psRepository.replaceSessionId(sessionId);
  }

  void replaceRefreshToken(String refreshToken) {
    psRepository.replaceRefreshToken(refreshToken);
  }

  void replaceSelectedSound(String selectedSound) {
    psRepository.replaceSelectedSound(selectedSound);
  }

  String getSelectedSound() {
    return psRepository.getSelectedSound();
  }

  void replaceContactsList(String contactListJson) {
    psRepository.replaceContactsList(contactListJson);
  }

  String getContactList() {
    return psRepository.getContactList();
  }

  ///Plan Overview Pref
  Future<void> replacePlanOverview(OverViewData overViewData) async {
    psRepository.replacePlanOverview(overViewData);
  }

  OverViewData getPlanOverview() {
    return psRepository.getPlanOverview()!;
  }

  ///Permission Pref
  ///
  ///
  Future<void> replaceAllowWorkspaceViewSwitchWorkspace(bool value) async {
    psRepository.replaceAllowWorkspaceViewSwitchWorkspace(value);
  }

  bool getAllowWorkspaceViewSwitchWorkspace() {
    return psRepository.getAllowWorkspaceViewSwitchWorkspace();
  }

  void replaceAllowWorkspaceCreateWorkspace(bool value) {
    psRepository.replaceAllowWorkspaceCreateWorkspace(value);
  }

  bool getAllowWorkspaceCreateWorkspace() {
    return psRepository.getAllowWorkspaceCreateWorkspace();
  }

  void replaceAllowWorkspaceEditWorkspace(bool value) {
    psRepository.replaceAllowWorkspaceEditWorkspace(value);
  }

  bool getAllowWorkspaceEditWorkspace() {
    return psRepository.getAllowWorkspaceEditWorkspace();
  }

  void replaceAllowNavigationSearch(bool value) {
    psRepository.replaceAllowNavigationSearch(value);
  }

  bool getAllowNavigationSearch() {
    return psRepository.getAllowNavigationSearch();
  }

  void replaceAllowNavigationShowDialer(bool value) {
    psRepository.replaceAllowNavigationShowDialer(value);
  }

  bool getAllowNavigationShowDialer() {
    return psRepository.getAllowNavigationShowDialer();
  }

  void replaceAllowNavigationShowDashboard(bool value) {
    psRepository.replaceAllowNavigationShowDashboard(value);
  }

  bool getAllowNavigationShowDashboard() {
    return psRepository.getAllowNavigationShowDashboard();
  }

  void replaceAllowNavigationShowContact(bool value) {
    psRepository.replaceAllowNavigationShowContact(value);
  }

  bool getAllowNavigationShowContact() {
    return psRepository.getAllowNavigationShowContact();
  }

  void replaceAllowNavigationShowSetting(bool value) {
    psRepository.replaceAllowNavigationShowSetting(value);
  }

  bool getAllowNavigationShowSetting() {
    return psRepository.getAllowNavigationShowSetting();
  }

  void replaceAllowNavigationAddNewNumber(bool value) {
    psRepository.replaceAllowNavigationAddNewNumber(value);
  }

  bool getAllowNavigationAddNewNumber() {
    return psRepository.getAllowNavigationAddNewNumber();
  }

  void replaceAllowNavigationViewNumberDetails(bool value) {
    psRepository.replaceAllowNavigationViewNumberDetails(value);
  }

  bool getAllowNavigationViewNumberDetails() {
    return psRepository.getAllowNavigationViewNumberDetails();
  }

  void replaceAllowNavigationNumberDnd(bool value) {
    psRepository.replaceAllowNavigationNumberDnd(value);
  }

  bool getAllowNavigationNumberDnd() {
    return psRepository.getAllowNavigationNumberDnd();
  }

  void replaceAllowNavigationNumberSetting(bool value) {
    psRepository.replaceAllowNavigationNumberSetting(value);
  }

  bool getAllowNavigationNumberSetting() {
    return psRepository.getAllowNavigationNumberSetting();
  }

  void replaceAllowNavigationAddNewMember(bool value) {
    psRepository.replaceAllowNavigationAddNewMember(value);
  }

  bool getAllowNavigationAddNewMember() {
    return psRepository.getAllowNavigationAddNewMember();
  }

  void replaceAllowNavigationAddNewTeam(bool value) {
    psRepository.replaceAllowNavigationAddNewTeam(value);
  }

  bool getAllowNavigationAddNewTeam() {
    return psRepository.getAllowNavigationAddNewTeam();
  }

  void replaceAllowNavigationViewTagDetails(bool value) {
    psRepository.replaceAllowNavigationViewTagDetails(value);
  }

  bool getAllowNavigationViewTagDetails() {
    return psRepository.getAllowNavigationViewTagDetails();
  }

  void replaceAllowNavigationAddNewTags(bool value) {
    psRepository.replaceAllowNavigationAddNewTags(value);
  }

  bool getAllowNavigationAddNewTags() {
    return psRepository.getAllowNavigationAddNewTags();
  }

  void replaceAllowContactSearchContact(bool value) {
    psRepository.replaceAllowContactSearchContact(value);
  }

  bool getAllowContactSearchContact() {
    return psRepository.getAllowContactSearchContact();
  }

  void replaceAllowContactAddNewContact(bool value) {
    psRepository.replaceAllowContactAddNewContact(value);
  }

  bool getAllowContactAddNewContact() {
    return psRepository.getAllowContactAddNewContact();
  }

  void replaceAllowContactCSVImport(bool value) {
    psRepository.replaceAllowContactCSVImport(value);
  }

  bool getAllowContactCSVImport() {
    return psRepository.getAllowContactCSVImport();
  }

  void replaceAllowShowTableView(bool value) {
    psRepository.replaceAllowShowTableView(value);
  }

  bool getAllowShowTableView() {
    return psRepository.getAllowShowTableView();
  }

  void replaceAllowProfileEditFullName(bool value) {
    psRepository.replaceAllowProfileEditFullName(value);
  }

  bool getAllowProfileEditFullName() {
    return psRepository.getAllowProfileEditFullName();
  }

  void replaceAllowProfileEditEmail(bool value) {
    psRepository.replaceAllowProfileEditEmail(value);
  }

  bool getAllowProfileEditEmail() {
    return psRepository.getAllowProfileEditEmail();
  }

  void replaceAllowProfileChangePassword(bool value) {
    psRepository.replaceAllowProfileChangePassword(value);
  }

  bool getAllowProfileChangePassword() {
    return psRepository.getAllowProfileChangePassword();
  }

  void replaceAllowProfileChangeProfilePicture(bool value) {
    psRepository.replaceAllowProfileChangeProfilePicture(value);
  }

  bool getAllowProfileChangeProfilePicture() {
    return psRepository.getAllowProfileChangeProfilePicture();
  }

  void replaceAllowMyNumberPortConfig(bool value) {
    psRepository.replaceAllowMyNumberPortConfig(value);
  }

  bool getAllowMyNumberPortConfig() {
    return psRepository.getAllowMyNumberPortConfig();
  }

  void replaceAllowMyNumberAddNewNumber(bool value) {
    psRepository.replaceAllowMyNumberAddNewNumber(value);
  }

  bool getAllowMyNumberAddNewNumber() {
    return psRepository.getAllowMyNumberAddNewNumber();
  }

  void replaceAllowMyNumberViewNumberList(bool value) {
    psRepository.replaceAllowMyNumberViewNumberList(value);
  }

  bool getAllowMyNumberViewNumberList() {
    return psRepository.getAllowMyNumberViewNumberList();
  }

  void replaceAllowMyNumberEditDetails(bool value) {
    psRepository.replaceAllowMyNumberEditDetails(value);
  }

  bool getAllowMyNumberEditDetails() {
    return psRepository.getAllowMyNumberEditDetails();
  }

  void replaceAllowMyNumberAutoRecord(bool value) {
    psRepository.replaceAllowMyNumberAutoRecord(value);
  }

  bool getAllowMyNumberAutoRecord() {
    return psRepository.getAllowMyNumberAutoRecord();
  }

  void replaceAllowMyNumberInternationalCall(bool value) {
    psRepository.replaceAllowMyNumberInternationalCall(value);
  }

  bool getAllowMyNumberInternationalCall() {
    return psRepository.getAllowMyNumberInternationalCall();
  }

  void replaceAllowMyNumberShareAccess(bool value) {
    psRepository.replaceAllowMyNumberShareAccess(value);
  }

  bool getAllowMyNumberShareAccess() {
    return psRepository.getAllowMyNumberShareAccess();
  }

  void replaceAllowMyNumberAutoVoiceMailTranscription(bool value) {
    psRepository.replaceAllowMyNumberAutoVoiceMailTranscription(value);
  }

  bool getAllowMyNumberAutoVoiceMailTranscription() {
    return psRepository.getAllowMyNumberAutoVoiceMailTranscription();
  }

  void replaceAllowMyNumberDelete(bool value) {
    psRepository.replaceAllowMyNumberDelete(value);
  }

  bool getAllowMyNumberDelete() {
    return psRepository.getAllowMyNumberDelete();
  }

  void replaceAllowMemberAddNewMember(bool value) {
    psRepository.replaceAllowMemberAddNewMember(value);
  }

  bool getAllowMemberAddNewMember() {
    return psRepository.getAllowMemberAddNewMember();
  }

  void replaceAllowMemberMemberList(bool value) {
    psRepository.replaceAllowMemberMemberList(value);
  }

  bool getAllowMemberMemberList() {
    return psRepository.getAllowMemberMemberList();
  }

  void replaceAllowMemberViewAssignedNumber(bool value) {
    psRepository.replaceAllowMemberViewAssignedNumber(value);
  }

  bool getAllowMemberViewAssignedNumber() {
    return psRepository.getAllowMemberViewAssignedNumber();
  }

  void replaceAllowMemberDeleteMember(bool value) {
    psRepository.replaceAllowMemberDeleteMember(value);
  }

  bool getAllowMemberDeleteMember() {
    return psRepository.getAllowMemberDeleteMember();
  }

  void replaceAllowMemberInvite(bool value) {
    psRepository.replaceAllowMemberInvite(value);
  }

  bool getAllowMemberInvite() {
    return psRepository.getAllowMemberInvite();
  }

  void replaceAllowMemberReInvite(bool value) {
    psRepository.replaceAllowMemberReInvite(value);
  }

  bool getAllowMemberReInvite() {
    return psRepository.getAllowMemberReInvite();
  }

  void replaceAllowTeamCreateTeam(bool value) {
    psRepository.replaceAllowTeamCreateTeam(value);
  }

  bool getAllowTeamCreateTeam() {
    return psRepository.getAllowTeamCreateTeam();
  }

  void replaceAllowTeamTeamList(bool value) {
    psRepository.replaceAllowTeamTeamList(value);
  }

  bool getAllowTeamTeamList() {
    return psRepository.getAllowTeamTeamList();
  }

  void replaceAllowTeamEdit(bool value) {
    psRepository.replaceAllowTeamEdit(value);
  }

  bool getAllowTeamEdit() {
    return psRepository.getAllowTeamEdit();
  }

  void replaceAllowTeamDelete(bool value) {
    psRepository.replaceAllowTeamDelete(value);
  }

  bool getAllowTeamDelete() {
    return psRepository.getAllowTeamDelete();
  }

  void replaceAllowContactAddNewIntegration(bool value) {
    psRepository.replaceAllowContactAddNewIntegration(value);
  }

  bool getAllowContactAddNewIntegration() {
    return psRepository.getAllowContactAddNewIntegration();
  }

  void replaceAllowContactIntegrationGoogle(bool value) {
    psRepository.replaceAllowContactIntegrationGoogle(value);
  }

  bool getAllowContactIntegrationGoogle() {
    return psRepository.getAllowContactIntegrationGoogle();
  }

  void replaceAllowContactIntegrationPipeDrive(bool value) {
    psRepository.replaceAllowContactIntegrationPipeDrive(value);
  }

  bool getAllowContactIntegrationPipeDrive() {
    return psRepository.getAllowContactIntegrationPipeDrive();
  }

  void replaceAllowContactImportCsv(bool value) {
    psRepository.replaceAllowContactImportCsv(value);
  }

  bool getAllowContactImportCsv() {
    return psRepository.getAllowContactImportCsv();
  }

  void replaceAllowContactDeleteContacts(bool value) {
    psRepository.replaceAllowContactDeleteContacts(value);
  }

  bool getAllowContactDeleteContacts() {
    return psRepository.getAllowContactDeleteContacts();
  }

  void replaceAllowWorkspaceUpdateProfilePicture(bool value) {
    psRepository.replaceAllowWorkspaceUpdateProfilePicture(value);
  }

  bool getAllowWorkspaceUpdateProfilePicture() {
    return psRepository.getAllowWorkspaceUpdateProfilePicture();
  }

  void replaceAllowWorkspaceChangeName(bool value) {
    psRepository.replaceAllowWorkspaceChangeName(value);
  }

  bool getAllowWorkspaceChangeName() {
    return psRepository.getAllowWorkspaceChangeName();
  }

  void replaceAllowWorkspaceEnableNotification(bool value) {
    psRepository.replaceAllowWorkspaceEnableNotification(value);
  }

  bool getAllowWorkspaceEnableNotification() {
    return psRepository.getAllowWorkspaceEnableNotification();
  }

  void replaceAllowWorkspaceDelete(bool value) {
    psRepository.replaceAllowWorkspaceDelete(value);
  }

  bool getAllowWorkspaceDelete() {
    return psRepository.getAllowWorkspaceDelete();
  }

  void replaceAllowIntegrationEnabled(bool value) {
    psRepository.replaceAllowIntegrationEnabled(value);
  }

  bool getAllowIntegrationEnabled() {
    return psRepository.getAllowIntegrationEnabled();
  }

  void replaceAllowIntegrationOtherIntegration(bool value) {
    psRepository.replaceAllowIntegrationOtherIntegration(value);
  }

  bool getAllowIntegrationOtherIntegration() {
    return psRepository.getAllowIntegrationOtherIntegration();
  }

  void replaceAllowBillingOverviewChangePlan(bool value) {
    psRepository.replaceAllowBillingOverviewChangePlan(value);
  }

  bool getAllowBillingOverviewChangePlan() {
    return psRepository.getAllowBillingOverviewChangePlan();
  }

  void replaceAllowBillingOverviewPurchaseCredit(bool value) {
    psRepository.replaceAllowBillingOverviewPurchaseCredit(value);
  }

  bool getAllowBillingOverviewPurchaseCredit() {
    return psRepository.getAllowBillingOverviewPurchaseCredit();
  }

  void replaceAllowBillingOverviewManageCardAdd(bool value) {
    psRepository.replaceAllowBillingOverviewManageCardAdd(value);
  }

  bool getAllowBillingOverviewManageCardAdd() {
    return psRepository.getAllowBillingOverviewManageCardAdd();
  }

  void replaceAllowBillingOverviewManageCardDelete(bool value) {
    psRepository.replaceAllowBillingOverviewManageCardDelete(value);
  }

  bool getAllowBillingOverviewManageCardDelete() {
    return psRepository.getAllowBillingOverviewManageCardDelete();
  }

  void replaceAllowBillingOverviewHideKrispcallBranding(bool value) {
    psRepository.replaceAllowBillingOverviewHideKrispcallBranding(value);
  }

  bool getAllowBillingOverviewHideKrispcallBranding() {
    return psRepository.getAllowBillingOverviewHideKrispcallBranding();
  }

  void replaceAllowBillingOverviewNotificationAutoRecharge(bool value) {
    psRepository.replaceAllowBillingOverviewNotificationAutoRecharge(value);
  }

  bool getAllowBillingOverviewNotificationAutoRecharge() {
    return psRepository.getAllowBillingOverviewNotificationAutoRecharge();
  }

  void replaceAllowBillingOverviewCancelSubscription(bool value) {
    psRepository.replaceAllowBillingOverviewCancelSubscription(value);
  }

  bool getAllowBillingOverviewCancelSubscription() {
    return psRepository.getAllowBillingOverviewCancelSubscription();
  }

  void replaceAllowBillingSaveBillingInfo(bool value) {
    psRepository.replaceAllowBillingSaveBillingInfo(value);
  }

  bool getAllowBillingSaveBillingInfo() {
    return psRepository.getAllowBillingSaveBillingInfo();
  }

  void replaceAllowBillingReceiptsViewList(bool value) {
    psRepository.replaceAllowBillingReceiptsViewList(value);
  }

  bool getAllowBillingReceiptsViewList() {
    return psRepository.getAllowBillingReceiptsViewList();
  }

  void replaceAllowBillingReceiptsViewInvoice(bool value) {
    psRepository.replaceAllowBillingReceiptsViewInvoice(value);
  }

  bool getAllowBillingReceiptsViewInvoice() {
    return psRepository.getAllowBillingReceiptsViewInvoice();
  }

  void replaceAllowBillingReceiptsDownloadInvoice(bool value) {
    psRepository.replaceAllowBillingReceiptsDownloadInvoice(value);
  }

  bool getAllowBillingReceiptsDownloadInvoice() {
    return psRepository.getAllowBillingReceiptsDownloadInvoice();
  }

  void replaceAllowDeviceSelectInputDevice(bool value) {
    psRepository.replaceAllowDeviceSelectInputDevice(value);
  }

  bool getAllowDeviceSelectInputDevice() {
    return psRepository.getAllowDeviceSelectInputDevice();
  }

  void replaceAllowDeviceSelectOutputDevice(bool value) {
    psRepository.replaceAllowDeviceSelectOutputDevice(value);
  }

  bool getAllowDeviceSelectOutputDevice() {
    return psRepository.getAllowDeviceSelectOutputDevice();
  }

  void replaceAllowDeviceAdjustInputVolume(bool value) {
    psRepository.replaceAllowDeviceAdjustInputVolume(value);
  }

  bool getAllowDeviceAdjustInputVolume() {
    return psRepository.getAllowDeviceAdjustInputVolume();
  }

  void replaceAllowDeviceAdjustOutputVolume(bool value) {
    psRepository.replaceAllowDeviceAdjustOutputVolume(value);
  }

  bool getAllowDeviceAdjustOutputVolume() {
    return psRepository.getAllowDeviceAdjustOutputVolume();
  }

  void replaceAllowDeviceMicTest(bool value) {
    psRepository.replaceAllowDeviceMicTest(value);
  }

  bool getAllowDeviceMicTest() {
    return psRepository.getAllowDeviceMicTest();
  }

  void replaceAllowDeviceCancelEcho(bool value) {
    psRepository.replaceAllowDeviceCancelEcho(value);
  }

  bool getAllowDeviceCancelEcho() {
    return psRepository.getAllowDeviceCancelEcho();
  }

  void replaceAllowDeviceReduceNoise(bool value) {
    psRepository.replaceAllowDeviceReduceNoise(value);
  }

  bool getAllowDeviceReduceNoise() {
    return psRepository.getAllowDeviceReduceNoise();
  }

  void replaceAllowNotificationEnableDesktopNotification(bool value) {
    psRepository.replaceAllowNotificationEnableDesktopNotification(value);
  }

  bool getAllowNotificationEnableDesktopNotification() {
    return psRepository.getAllowNotificationEnableDesktopNotification();
  }

  void replaceAllowNotificationEnableNewCallMessage(bool value) {
    psRepository.replaceAllowNotificationEnableNewCallMessage(value);
  }

  bool getAllowNotificationEnableNewCallMessage() {
    return psRepository.getAllowNotificationEnableNewCallMessage();
  }

  void replaceAllowNotificationEnableNewLeads(bool value) {
    psRepository.replaceAllowNotificationEnableNewLeads(value);
  }

  bool getAllowNotificationEnableNewLeads() {
    return psRepository.getAllowNotificationEnableNewLeads();
  }

  void replaceAllowNotificationEnableFlashTaskBar(bool value) {
    psRepository.replaceAllowNotificationEnableFlashTaskBar(value);
  }

  bool getAllowNotificationEnableFlashTaskBar() {
    return psRepository.getAllowNotificationEnableFlashTaskBar();
  }

  void replaceAllowLanguageSwitch(bool value) {
    psRepository.replaceAllowLanguageSwitch(value);
  }

  bool getAllowLanguageSwitch() {
    return psRepository.getAllowLanguageSwitch();
  }
}
