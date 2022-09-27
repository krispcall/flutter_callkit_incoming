import "dart:io";

import "package:graphql/client.dart";
import "package:mvp/api/common/Api.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/query/QueryMutation.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/CommonRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:mvp/viewObject/holder/request_holder/contactDetailRequestParamHolder/ContactDetailRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationSeenRequestParamHolder/ConversationSeenRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editWorkspaceRequestParamHolder/EditWorkspaceRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/memberChatRequestParamHolder/MemberChatRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/pageRequestParamHolder/PageRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/recentConversationRequestParamHolder/RecentConversationRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/teamsMemberListRequestParamHolder/TeamsMemberListRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/teamsMemberListUpdateRequestParamHolder/TeamsMemberListUpdateRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateUserNotificationSettingParameterHolder/UpdateUserNotificationSettingParameterHolder.dart";
import "package:mvp/viewObject/model/addContact/AddContactResponse.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContact.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContactResponse.dart";
import "package:mvp/viewObject/model/addNoteByNumber/AddNoteByNumberResponse.dart";
import "package:mvp/viewObject/model/addNotes/AddNoteResponse.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponse.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/allNotes/AllNotesResponse.dart";
import "package:mvp/viewObject/model/appInfo/AppInfo.dart";
import "package:mvp/viewObject/model/blockContact/BlockContactListResponse.dart";
import "package:mvp/viewObject/model/call/RecentConversationResponse.dart";
import "package:mvp/viewObject/model/call/pinnedContact/PinnedConversationResponse.dart";
import "package:mvp/viewObject/model/callHold/CallHoldResponse.dart";
import "package:mvp/viewObject/model/callRating/CallRatingResponse.dart";
import "package:mvp/viewObject/model/cancelCall/CancelCallResponse.dart";
import "package:mvp/viewObject/model/channel/ChannelInfoResponse.dart";
import "package:mvp/viewObject/model/channel/ChannelResponse.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDndResponse.dart";
import "package:mvp/viewObject/model/checkDuplicateLogin/CheckDuplicateLogin.dart";
import "package:mvp/viewObject/model/clientDndResponse/ClientDndResponse.dart";
import "package:mvp/viewObject/model/contactDetail/ContactDetailResponse.dart";
import "package:mvp/viewObject/model/conversationSeen/ConversationSeenResponse.dart";
import "package:mvp/viewObject/model/conversation_detail/ConversationDetailResponse.dart";
import "package:mvp/viewObject/model/country/CountryList.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessageResponse.dart";
import "package:mvp/viewObject/model/deviceInfo/DeviceInfoResponse.dart";
import "package:mvp/viewObject/model/editContact/EditContactResponse.dart";
import "package:mvp/viewObject/model/editWorkspace/EditWorkspaceNameResponse.dart";
import "package:mvp/viewObject/model/editWorkspaceImage/EditWorkspaceImageResponse.dart";
import "package:mvp/viewObject/model/forgotPassword/ForgotPasswordResponse.dart";
import "package:mvp/viewObject/model/getWorkspaceCredit/WorkspaceCredit.dart";
import "package:mvp/viewObject/model/last_contacted/LastContactedResponse.dart";
import "package:mvp/viewObject/model/login/User.dart";
import "package:mvp/viewObject/model/macros/addMacros/AddMacrosResponse.dart";
import "package:mvp/viewObject/model/macros/list/MacrosResponse.dart";
import "package:mvp/viewObject/model/macros/removeMacros/RemoveMacros.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:mvp/viewObject/model/member_conversation_detail/MemberConversationDetailResponse.dart";
import "package:mvp/viewObject/model/members/MemberChatSeenResponse.dart";
import "package:mvp/viewObject/model/members/MembersResponse.dart";
import "package:mvp/viewObject/model/members/SubscriptionOnlineMemberStatus.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettingsResponse.dart";
import "package:mvp/viewObject/model/numberSettings/UpdateNumberSettingResponse.dart";
import "package:mvp/viewObject/model/numbers/NumberResponse.dart";
import "package:mvp/viewObject/model/onlineStatus/onlineStatusResponse.dart";
import "package:mvp/viewObject/model/overview/OverViewResponse.dart";
import "package:mvp/viewObject/model/pinContact/PinContactResponse.dart";
import "package:mvp/viewObject/model/profile/EditProfile.dart";
import "package:mvp/viewObject/model/profile/Profile.dart";
import "package:mvp/viewObject/model/profile/changeProfilePicture.dart";
import "package:mvp/viewObject/model/recording/CallRecordResponse.dart";
import "package:mvp/viewObject/model/refreshToken/RefreshTokenResponse.dart";
import "package:mvp/viewObject/model/sendMessage/SendMessageResponse.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";
import "package:mvp/viewObject/model/subscriptionConversationDetail/SubscriptionConversationDetailResponse.dart";
import "package:mvp/viewObject/model/subscriptionWorkspaceChatDetail/SubscriptionWorkspaceChatDetailResponse.dart";
import "package:mvp/viewObject/model/teams/TeamsResponse.dart";
import "package:mvp/viewObject/model/teamsMemberList/TeamsMemberListResponse.dart";
import "package:mvp/viewObject/model/transfer/TransferResponse.dart";
import "package:mvp/viewObject/model/updateTeamsMemberList/UpdateTeamResponse.dart";
import "package:mvp/viewObject/model/updateUserNotificationSetting/UpdateUserNotificationSettingResponse.dart";
import "package:mvp/viewObject/model/userDnd/UserDndResponse.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSettingResponse.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissionsResponse.dart";
import "package:mvp/viewObject/model/userPlanRestriction/UserPlanRestrictionResponse.dart";
import "package:mvp/viewObject/model/voiceToken/VoiceTokenResponse.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListResponse.dart";

class ApiService extends Api {
  ///
  Future<Resources<AppInfo>> doVersionApiCall(String appType) async {
    return doServerCallMutationWithoutAuth<AppInfo, AppInfo>(
      AppInfo(),
      {
        "app_type": appType,
      },
      QueryMutation().queryAppInfo(),
      "appRegisterInfo",
    );
  }

  ///
  /// User Login
  ///
  Future<Resources<User>> doUserLoginApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithoutAuth<User, User>(
      User(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationLogin(),
      "login",
    );
  }

  ///
  /// User CheckDuplicateLogin
  ///
  Future<Resources<CheckDuplicateLogin>> doCheckDuplicateLogin(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithoutAuth<CheckDuplicateLogin,
        CheckDuplicateLogin>(
      CheckDuplicateLogin(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().checkDuplicateLogin(),
      "checkDuplicateLogin",
    );
  }

  ///
  /// User Call Access and Refresh Token
  ///
  Future<Resources<Member>> doWorkSpaceLoginApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithApiAuth<Member, Member>(
      Member(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationMemberLogin(),
      "memberLogin",
    );
  }

  ///
  /// User Voice Token
  ///
  Future<Resources<VoiceTokenResponse>> doVoiceTokenApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithAuth<VoiceTokenResponse, VoiceTokenResponse>(
      VoiceTokenResponse(),
      jsonMap as Map<String, dynamic>,
      QueryMutation().queryVoiceToken(),
      "getVoiceToken",
    );
  }

  ///
  /// User Login
  ///
  Future<Resources<DeviceInfoResponse>> doDeviceRegisterApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithApiAuth<DeviceInfoResponse,
        DeviceInfoResponse>(
      DeviceInfoResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationCreateDeviceInfo(),
      "deviceRegister",
    );
  }

  ///
  /// User WorkSpace Detail
  ///
  Future<Resources<Workspace>> doWorkSpaceDetailApiCall(
      String accessToken) async {
    return doServerCallQueryWithCallAccessTokenParam<Workspace, Workspace>(
      Workspace(),
      QueryMutation().queryWorkspaceDetail(),
      accessToken,
      "workspace",
    );
  }

  ///
  /// Channel List
  ///
  Future<Resources<ChannelResponse>> doChannelListApiCall(
      String accessToken) async {
    return doServerCallQueryWithCallAccessTokenParam<ChannelResponse,
        ChannelResponse>(
      ChannelResponse(),
      QueryMutation().queryChannelList(),
      accessToken,
      "channels",
    );
  }

  ///
  /// User Profile Details for Profile APi
  ///
  Future<Resources<Profile>> getUserProfileDetails() async {
    return doServerCallQueryWithAuth<Profile, Profile>(
      Profile(),
      QueryMutation().getUserProfileDetails(),
      "profile",
    );
  }

  Future<Stream<QueryResult>> doSubscriptionUserProfile(
      Map<String, dynamic> jsonMap) async {
    return doSubscriptionUserProfileApiCall<Profile, Profile>(
      Profile(),
      jsonMap,
      QueryMutation().subscriptionUserProfile(),
    );
  }

  ///
  /// User Change Password
  ///
  // Future<Resources<ChangePassword>> postChangePassword(Map<dynamic, dynamic> jsonMap) async
  // {
  //   return  postDataMutation<ChangePassword, ChangePassword>(
  //       ChangePassword(),
  //       CommonRequestHolder(data: jsonMap).toMap(),
  //       QueryMutation().mutationChangePassword(),
  //       PsSharedPreferences.instance.shared
  //           .getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  ///
  /// User name Update
  ///
  // Future<Resources<ChangeProfileName>> postUserNameUpdate(Map<dynamic, dynamic> jsonMap) async
  // {
  //   return  postDataMutation<ChangeProfileName, ChangeProfileName>(
  //       ChangeProfileName(),
  //       CommonRequestHolder(data: jsonMap).toMap(),
  //       QueryMutation().mutationEditProfileName(),
  //       PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  ///

  ///
  /// User name Update
  ///
  // Future<Resources<UpdateUserProfilePicture>> postUserProfileImageUpdate(String userId, String platformName, File imageFile) async
  // {
  //   Map<String, dynamic> imageBase64Map = Utils.convertImageToBase64String("photo_upload", imageFile);
  //   return  postDataMutation<UpdateUserProfilePicture, UpdateUserProfilePicture>(
  //       UpdateUserProfilePicture(),
  //       imageBase64Map,
  //       QueryMutation().mutationUploadProfileImage(),
  //       PsSharedPreferences.instance.shared
  //           .getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  Future<Resources<RecentConversationResponse>> doCallLogsApiCall(
      RecentConversationRequestHolder param) async {
    return doServerCallMutationWithAuth<RecentConversationResponse,
        RecentConversationResponse>(
      RecentConversationResponse(),
      param.toMap(),
      QueryMutation().queryCallLogs(),
      "recentConversation",
    );
  }

  Future<Resources<PinnedConversationResponse>> doPinnedCallLogsApiCall(
      RecentConversationRequestHolder param) async {
    return doServerCallMutationWithAuth<PinnedConversationResponse,
        PinnedConversationResponse>(
      PinnedConversationResponse(),
      param.toMap(),
      QueryMutation().queryPinnedCallLogs(),
      "contactPinnedConversation",
    );
  }

  Future<Resources<PinContactResponse>> doContactPinUnpinApiCall(
      ContactPinUnpinRequestHolder param) async {
    return doServerCallMutationWithAuth<PinContactResponse, PinContactResponse>(
      PinContactResponse(),
      CommonRequestHolder(data: param.toMap()).toMap(),
      QueryMutation().mutationPinConversationContact(),
      "addPinned",
    );
  }

  Future<Resources<AllContactResponse>> doAllContactApiCall() async {
    return doServerCallQueryWithAuthQueryAndVariable<AllContactResponse,
        AllContactResponse>(
      AllContactResponse(),
      QueryMutation().getAllContacts(),
      {
        "tags": [],
      },
      "newContacts",
    );
  }

  Future<Resources<ContactDetailResponse>> doContactDetailApiCall(
      ContactDetailRequestParamHolder jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<ContactDetailResponse,
        ContactDetailResponse>(
      ContactDetailResponse(),
      QueryMutation().queryContactDetail(),
      jsonMap.toMap() as Map<String, dynamic>,
      "contact",
    );
  }

  Future<Resources<ClientDetailResponse>> doContactDetailByNumberApiCall(
      ContactDetailByNumberRequestParamHolder jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<ClientDetailResponse,
        ClientDetailResponse>(
      ClientDetailResponse(),
      QueryMutation().queryContactDetailByNumber(),
      jsonMap.toMap() as Map<String, dynamic>,
      "clientDetail",
    );
  }

  Future<Resources<AllNotesResponse>> doGetAllNotesApiCall(ContactPinUnpinRequestHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable<AllNotesResponse,
        AllNotesResponse>(
      AllNotesResponse(),
      QueryMutation().queryClientNotes(),
      param.toMap(),
      "clientNotes",
    );
  }

  Future<Resources<EditContactResponse>> doUpdateContactProfilePicture(
      Map<String, String> param, String contactId) async {
    final Map<String, dynamic> dump = {
      "id": contactId,
      "data": param,
    };
    return doServerCallQueryWithAuthQueryAndVariable<EditContactResponse,
        EditContactResponse>(
      EditContactResponse(),
      QueryMutation().mutationAddTagsToContact(),
      dump,
      "editContact",
    );
  }

  Future<Resources<EditContactResponse>> editContactApiCall(
      EditContactRequestHolder jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<EditContactResponse,
        EditContactResponse>(
      EditContactResponse(),
      QueryMutation().mutationAddTagsToContact(),
      jsonMap.toMap(),
      "editContact",
    );
  }

  Future<Resources<UploadPhoneContactResponse>> doUploadContactsApiCall(
      UploadPhoneContact jsonMap) async {
    return doServerCallMutationWithAuth<UploadPhoneContactResponse,
        UploadPhoneContactResponse>(
      UploadPhoneContactResponse(),
      CommonRequestHolder(data: jsonMap.toJson()).toMap(),
      QueryMutation().mutationUploadContacts(),
      "uploadBulkContacts",
    );
  }

  Future<Resources<AddContactResponse>> doAddContactsApiCall(
      AddContactRequestParamHolder jsonMap, File file) async {
    final Map<String, dynamic> imageBase64Map =
        Utils.convertImageToBase64String("photoUpload", file);
    jsonMap.toMap().addAll(imageBase64Map);
    return doServerCallMutationWithAuth<AddContactResponse, AddContactResponse>(
      AddContactResponse(),
      CommonRequestHolder(data: jsonMap.toMap()).toMap(),
      QueryMutation().mutationAddNewContacts(),
      "addContact",
    );
  }

  Future<Resources<AddContactResponse>> postAddContacts(
      Map<dynamic, dynamic> jsonMap, File? file) async {
    if (file != null) {
      final Map<String, dynamic> imageBase64Map =
          Utils.convertImageToBase64String("photoUpload", file);
      jsonMap.addAll(imageBase64Map);
    }
    return doServerCallMutationWithAuth<AddContactResponse, AddContactResponse>(
      AddContactResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationAddNewContacts(),
      "addContact",
    );
  }

  Future<Resources<DeleteContactResponse>> deleteContact(
      List<String> jsonMap) async {
    return doServerCallMutationWithAuth<DeleteContactResponse,
        DeleteContactResponse>(
      DeleteContactResponse(),
      {
        "data": {"contacts": jsonMap},
      },
      QueryMutation().mutationDeleteContacts(),
      "deleteContacts",
    );
  }

  Future<Resources<BlockContactResponse>> doBlockContactApiCall(
    BlockContactRequestHolder blockContactRequestHolder,
  ) async {
    return doServerCallMutationWithAuth<BlockContactResponse,
        BlockContactResponse>(
      BlockContactResponse(),
      blockContactRequestHolder.toMap(),
      // isContact
      // ? QueryMutation().mutationBlockContact()
      // : QueryMutation().mutationBlockNumber(),
      QueryMutation().mutationBlockNumber(),
      "blockNumber",
    );
  }

  Future<Resources<CountryList>> getAllCountries(int limit, int offset) async {
    return doServerCallQueryWithAuth<CountryList, CountryList>(
      CountryList(),
      QueryMutation().getAllCountries(),
      "allCountries",
    );
  }

  Future<Resources<AreaCode>> getAllAreaCodes() async {
    return doServerCallQueryWithAuth<AreaCode, AreaCode>(
      AreaCode(),
      QueryMutation().getAllAreaCodes(),
      "allAreaCodes",
    );
  }

  Future<Resources<SendMessageResponse>> doSendMessageApiCall(
      SendMessageRequestHolder jsonMap) async {
    return doServerCallMutationWithAuth<SendMessageResponse,
        SendMessageResponse>(
      SendMessageResponse(),
      CommonRequestHolder(data: jsonMap.toMap()).toMap(),
      QueryMutation().mutationSendNewMessage(),
      "sendMessage",
    );
  }

  Future<Resources<CreateChatMessageResponse>> doSendChatMessageApiCall(
      Map<String, dynamic> jsonMap) async {
    return doServerCallMutationWithAuth<CreateChatMessageResponse,
        CreateChatMessageResponse>(
      CreateChatMessageResponse(),
      jsonMap,
      QueryMutation().mutationSendChatMessage(),
      "createChatMessage",
    );
  }

  Future<Resources<ConversationDetailResponse>>
      doConversationDetailByContactApiCall(
          ConversationDetailRequestHolder param) async {
    return doServerCallMutationWithAuth<ConversationDetailResponse,
        ConversationDetailResponse>(
      ConversationDetailResponse(),
      param.toMap(),
      QueryMutation().queryConversationByContactNumber(),
      "conversation",
    );
  }

  Future<Resources<MemberConversationDetailResponse>>
      doConversationDetailByMemberApiCall(
          MemberChatRequestHolder memberChatRequestHolder) async {
    return doServerCallMutationWithAuth<MemberConversationDetailResponse,
        MemberConversationDetailResponse>(
      MemberConversationDetailResponse(),
      memberChatRequestHolder.toMap(),
      QueryMutation().queryConversationByMember(),
      "chatHistory",
    );
  }

  Future<Resources> doRecordingApiCall(
      ConversationDetailRequestHolder param) async {
    return mServerCallMutationWithAuth(
      param.toMap(),
      QueryMutation().queryRecordingByContactNumber(),
      "clientRecordings",
    );
  }

  Future<Stream<QueryResult>> subscriptionCallLogsApiCall(
      SubscriptionUpdateConversationDetailRequestHolder jsonMap) async {
    return doSubscriptionCallLogsApiCall<SubscriptionConversationDetailResponse,
        SubscriptionConversationDetailResponse>(
      SubscriptionConversationDetailResponse(),
      jsonMap.toMap(),
      QueryMutation().subscriptionUpdateConversationDetail(),
    );
  }

  Future<Stream<QueryResult>> subscriptionConversationChatApiCall(
      SubscriptionUpdateConversationDetailRequestHolder jsonMap) async {
    return doSubscriptionConversationChatApiCall<
        SubscriptionConversationDetailResponse,
        SubscriptionConversationDetailResponse>(
      SubscriptionConversationDetailResponse(),
      jsonMap.toMap(),
      QueryMutation().subscriptionUpdateConversationDetail(),
    );
  }

  Future<Stream<QueryResult>> doSubscriptionOnlineMemberStatus(
      String workspaceId) async {
    return doSubscriptionOnlineMemberStatusApiCall<
        SubscriptionOnlineMemberStatusResponse,
        SubscriptionOnlineMemberStatusResponse>(
      SubscriptionOnlineMemberStatusResponse(),
      {"workspace": workspaceId},
      QueryMutation().subscriptionOnlineMemberStatus(),
    );
  }

  Future<Stream<QueryResult>> doSubscriptionWorkspaceChat() async {
    return doSubscriptionWorkspaceChatApiCall<
        SubscriptionWorkspaceChatDetailResponse,
        SubscriptionWorkspaceChatDetailResponse>(
      SubscriptionWorkspaceChatDetailResponse(),
      QueryMutation().subscriptionWorkspaceChatDetail(),
    );
  }

  Future<Stream<QueryResult>> doSubscriptionWorkspaceChatDetail() async {
    return doSubscriptionWorkspaceChatDetailApiCall<
        SubscriptionWorkspaceChatDetailResponse,
        SubscriptionWorkspaceChatDetailResponse>(
      SubscriptionWorkspaceChatDetailResponse(),
      QueryMutation().subscriptionWorkspaceChatDetail(),
    );
  }

  Future<Resources<ClientDndResponse>>
      doRequestToMuteConversationByClientNumber(
          UpdateClientDNDRequestParamHolder paramHolder) async {
    return doServerCallQueryWithAuthQueryAndVariable<ClientDndResponse,
        ClientDndResponse>(
      ClientDndResponse(),
      QueryMutation().mutationUpdateClientDnd(),
      CommonRequestHolder(data: paramHolder.toMap()).toMap(),
      "updateClientDND",
    );
  }

  Future<Resources<CallRecordResponse>> callRecord(
      Map<String, dynamic> jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<CallRecordResponse,
        CallRecordResponse>(
      CallRecordResponse(),
      QueryMutation().callRecord(),
      CommonRequestHolder(data: jsonMap).toMap(),
      "callRecording",
    );
  }

  Future<Resources<WorkspaceCreditResponse>> getWorkspaceCredit() async {
    return doServerCallQueryWithCallAccessToken<WorkspaceCreditResponse,
        WorkspaceCreditResponse>(
      WorkspaceCreditResponse(),
      QueryMutation().getWorkspaceCredit(),
      "getWorkspaceCredit",
    );
  }

  Future<Resources<MembersResponse>> doGetAllWorkspaceMembersApiCall(
      PageRequestHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      MembersResponse(),
      QueryMutation().queryGetAllWorkSpaceMembers(),
      param.toMap(),
      "allWorkspaceMembers",
    );
  }

  Future<Resources<MemberChatSeenResponse>> doEditMemberChatSeenApiCall(
      Map<String, dynamic> param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      MemberChatSeenResponse(),
      QueryMutation().mutationEditMemberChatSeen(),
      param,
      "editMemberChatSeen",
    );
  }

  Future<Resources<ConversationDetailResponse>> searchConversationApiCall(
      SearchConversationRequestHolder param) async {
    Utils.cPrint("SearchParam");
    Utils.cPrint(param.toMap().toString());

    return doServerCallMutationWithAuth<ConversationDetailResponse,
        ConversationDetailResponse>(
      ConversationDetailResponse(),
      param.toMap(),
      QueryMutation().queryConversationByContactNumber(),
      "conversation",
    );
  }

  Future<Resources<ConversationDetailResponse>>
      searchConversationWithCursorApiCall(
          ConversationDetailRequestHolder param) async {
    return doServerCallMutationWithAuth<ConversationDetailResponse,
        ConversationDetailResponse>(
      ConversationDetailResponse(),
      param.toMap(),
      QueryMutation().queryConversationByContactNumber(),
      "conversation",
    );
  }

  Future<Resources<AddNoteResponse>> doAddNoteToContactApiCall(
      AddNoteToContactRequestHolder jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<AddNoteResponse,
        AddNoteResponse>(
      AddNoteResponse(),
      QueryMutation().mutationAddNoteToContact(),
      jsonMap.toMap(),
      "addNote",
    );
  }

  Future<Resources<AddNoteByNumberResponse>> doAddNoteByNumberApiCall(
      AddNoteByNumberRequestHolder jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<AddNoteByNumberResponse,
        AddNoteByNumberResponse>(
      AddNoteByNumberResponse(),
      QueryMutation().mutationAddNoteByNumber(),
      jsonMap.toMap(),
      "addNoteByContact",
    );
  }

  Future<Resources<TransferResponse>> transferCall(
      Map<String, dynamic> param) async {
    return doServerCallQueryWithAuthQueryAndVariable<TransferResponse,
        TransferResponse>(
      TransferResponse(),
      QueryMutation().warmTransferCall(),
      param,
      "warmTransfer",
    );
  }

  Future<Resources<CallHoldResponse>> callHold(
      Map<String, dynamic> param) async {
    return doServerCallMutationWithAuth<CallHoldResponse, CallHoldResponse>(
      CallHoldResponse(),
      param,
      QueryMutation().callHold(),
      "callHold",
    );
  }

  Future<Resources<OnlineStatusResponse>> onlineStatus(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithApiAuth<OnlineStatusResponse,
        OnlineStatusResponse>(
      OnlineStatusResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().updateOnlineStatus(),
      "updateOnlineStatus",
    );
  }

  Future<Resources<EditProfile>> editUsernameApiCall(
      Map<String, dynamic> jsonMap) async {
    return doServerCallMutationWithApiAuth<EditProfile, EditProfile>(
      EditProfile(),
      jsonMap,
      QueryMutation().mutationEditProfileName(),
      "changeProfileNames",
    );
  }

  Future<Resources<ChangeProfilePicture>> changeProfilePicture(
      Map<String, String> param) async {
    return doServerCallMutationWithApiAuth<ChangeProfilePicture,
        ChangeProfilePicture>(
      ChangeProfilePicture(),
      param,
      QueryMutation().changeProfilePicture(),
      "changeProfilePicture",
    );
  }

  /// User email Update
  ///
  Future<Resources<UpdateUserEmail>> postUserEmailUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithApiAuth<UpdateUserEmail, UpdateUserEmail>(
      UpdateUserEmail(),
      jsonMap as Map<String, dynamic>,
      QueryMutation().mutationEditUserEmail(),
      "changeEmail",
    );
  }

  Future<Resources<CancelCallResponse>> cancelOutgoingCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithAuth<CancelCallResponse, CancelCallResponse>(
      CancelCallResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().cancelOutgoingCall(),
      "cancelOutgoingCall",
    );
  }

  Future<Resources<CancelCallResponse>> rejectCall(String id) async {
    final Map<String, dynamic> requestData = {
      "conversation_sid": id,
      "by_sid": true,
    };
    return doServerCallMutationWithAuth<CancelCallResponse, CancelCallResponse>(
      CancelCallResponse(),
      CommonRequestHolder(data: requestData).toMap(),
      QueryMutation().rejectCall(),
      "rejectConversation",
    );
  }

  Future<Resources<TeamsResponse>> getTeamList(
      Map<String, dynamic> jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<TeamsResponse,
        TeamsResponse>(
      TeamsResponse(),
      QueryMutation().queryTeams(),
      jsonMap,
      "teams",
    );
  }

  Future<Resources<NumberResponse>> getMyNumbers() async {
    return doServerCallQueryWithCallAccessToken<NumberResponse, NumberResponse>(
      NumberResponse(),
      QueryMutation().queryMyNumbers(),
      "numbers",
    );
  }

  Future<Resources<OverviewResponse>> doPlanOverViewApiCall() async {
    return doServerCallQueryWithCallAccessToken<OverviewResponse,
        OverviewResponse>(
      OverviewResponse(),
      QueryMutation().planOverView(),
      "planOverview",
    );
  }

  Future<Resources<WorkspaceListResponse>> doGetWorkSpaceListApiCall() async {
    return doServerCallQueryWithAuth<WorkspaceListResponse,
        WorkspaceListResponse>(
      WorkspaceListResponse(),
      QueryMutation().queryWorkSpaces(),
      "workspaces",
    );
  }

  Future<Resources<EditWorkspaceImageResponse>> doEditWorkspaceImageApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<EditWorkspaceImageResponse,
        EditWorkspaceImageResponse>(
      EditWorkspaceImageResponse(),
      QueryMutation().changeWorkSpacePhoto(),
      jsonMap as Map<String, dynamic>,
      "changeWorkspacePhoto",
    );
  }

  Future<Resources<RefreshTokenResponse>> doRefreshTokenApiCall() async {
    return doServerCallQueryWithRefreshToken<RefreshTokenResponse,
        RefreshTokenResponse>(
      RefreshTokenResponse(),
      QueryMutation().mutationRefreshToken(),
      "refreshToken",
    );
  }

  ///
  /// User Forgot Password
  ///
  Future<Resources<ForgotPasswordResponse>> doUserForgotPasswordApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return doServerCallMutationWithoutAuth<ForgotPasswordResponse,
        ForgotPasswordResponse>(
      ForgotPasswordResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationForgotPassword(),
      "forgotPassword",
    );
  }

  Future<Resources<LastContactedResponse>> doGetLastContactedDate(
      Map<String, dynamic> jsonMap) async {
    return doServerCallQueryWithAuthQueryAndVariable<LastContactedResponse,
        LastContactedResponse>(
      LastContactedResponse(),
      QueryMutation().queryGetLastContactedDate(),
      jsonMap,
      "lastContactedTime",
    );
  }

  Future<Resources<UserNotificationSettingResponse>>
      doGetUserNotificationSettingApiCall() async {
    return doServerCallQueryWithCallAccessToken<UserNotificationSettingResponse,
        UserNotificationSettingResponse>(
      UserNotificationSettingResponse(),
      QueryMutation().queryGetUserNotificationSetting(),
      "notificationSettings",
    );
  }

  Future<Resources<UpdateUserNotificationSettingResponse>>
      doUpdateUserNotificationSettingApiCall(
          UpdateUserNotificationSettingParameterHolder param) async {
    return doServerCallMutationWithAuth<UpdateUserNotificationSettingResponse,
        UpdateUserNotificationSettingResponse>(
      UpdateUserNotificationSettingResponse(),
      CommonRequestHolder(data: param.toMap()).toMap(),
      QueryMutation().mutationUpdateUserNotificationSetting(),
      "updateNotificationSettings",
    );
  }

  Future<Resources<UserPermissionsResponse>>
      doGetUserPermissionsApiCall() async {
    return doServerCallQueryWithCallAccessToken<UserPermissionsResponse,
        UserPermissionsResponse>(
      UserPermissionsResponse(),
      QueryMutation().queryGetUserPermissions(),
      "permissions",
    );
  }

  Future<Resources<NumberSettingsResponse>> doGetNumberSettingsApiCall(
      SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder) async {
    return doServerCallQueryWithAuthQueryAndVariable<NumberSettingsResponse,
        NumberSettingsResponse>(
      NumberSettingsResponse(),
      QueryMutation().mutationNumberSetting(),
      subscriptionUpdateConversationDetailRequestHolder.toMap(),
      "numberSettings",
    );
  }

  Future<Resources<UserPlanRestrictionResponse>>
      doGetPlanRestrictionApiCall() async {
    return doServerCallQueryWithCallAccessToken<UserPlanRestrictionResponse,
        UserPlanRestrictionResponse>(
      UserPlanRestrictionResponse(),
      QueryMutation().queryPlanRestriction(),
      "planRestrictionData",
    );
  }

  Future<Resources<UserDndResponse>> onSetUserDnd(
      Map<String, dynamic> map) async {
    return doServerCallMutationWithApiAuth<UserDndResponse, UserDndResponse>(
      UserDndResponse(),
      map,
      QueryMutation().mutuationUserDnd(),
      "setUserDND",
    );
  }

  Future<Resources<UpdateNumberSettingResponse>> updateChannelDetails(
      Map<String, dynamic> map) async {
    return doServerCallQueryWithAuthQueryAndVariable<
        UpdateNumberSettingResponse, UpdateNumberSettingResponse>(
      UpdateNumberSettingResponse(),
      QueryMutation().updateGeneralSettings(),
      map,
      "updateGeneralSettings",
    );
  }

  Future<Resources<TeamsMemberListResponse>> doGetAllTeamsMemberApiCall(
      TeamsMemberListRequestParamHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      TeamsMemberListResponse(),
      QueryMutation().queryGetAllTeamsMember(),
      param.toMap(),
      "teamMembersList",
    );
  }

  Future<Resources<UpdateTeamResponse>> doUpdateTeamsMemberApiCall(
      TeamsMemberListUpdateRequestParamHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      UpdateTeamResponse(),
      QueryMutation().mutationUpdateTeamsMember(),
      param.toMap(),
      "updateTeam",
    );
  }

  Future<Resources<CallRatingResponse>> doCallRatingApiCall(
      Map<String, dynamic> param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      CallRatingResponse(),
      QueryMutation().callRating(),
      param,
      "callRating",
    );
  }

  Future<Resources<ChannelDndResponse>> onSetChannelDnd(
      Map<String, dynamic> map) async {
    return doServerCallQueryWithAuthQueryAndVariable<ChannelDndResponse,
        ChannelDndResponse>(
      ChannelDndResponse(),
      QueryMutation().setChannelDnd(),
      map,
      "setChannelDnd",
    );
  }

  Future<Resources<ChannelDndResponse>> onRemoveDnd(
      Map<String, dynamic> map) async {
    return doServerCallQueryWithAuthQueryAndVariable<ChannelDndResponse,
        ChannelDndResponse>(
      ChannelDndResponse(),
      QueryMutation().removeChannelDnd(),
      map,
      "removeChannelDnd",
    );
  }

  Future<Resources<EditWorkspaceNameResponse>> doEditWorkspaceNameApiCall(
      EditWorkspaceRequestParamHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      EditWorkspaceNameResponse(),
      QueryMutation().mutationEditWorkspace(),
      CommonRequestHolder(data: param.toMap()).toMap(),
      "editWorkspace",
    );
  }

  Future<Resources<ConversationSeenResponse>> doConversationSeenApiCall(
      ConversationSeenRequestParamHolder param) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      ConversationSeenResponse(),
      QueryMutation().mutationConversationSeen(),
      param.toMap(),
      "conversationSeen",
    );
  }

  Future<Resources<ChannelInfoResponse>> doGetChannelInfo(
      String? channel) async {
    return doServerCallQueryWithAuthQueryAndVariable(
      ChannelInfoResponse(),
      QueryMutation().queryChannelInfo(),
      Map.from({"channel": channel}),
      "channelInfo",
    );
  }

  Future<Resources<BlockContactListResponse>>
      doBlockContactListApiCall() async {
    return doServerCallQueryWithCallAccessToken(
      BlockContactListResponse(),
      QueryMutation().blockContacts(),
      "blockedContacts",
    );
  }

  Future<Resources<MacrosResponse>> getMacros() async {
    return doServerCallQueryWithCallAccessToken(
      MacrosResponse(),
      QueryMutation().getMacros(),
      "macros",
    );
  }

  Future<Resources<AddMacrosResponse>> doAddMacrosApiCall(
      Map<String, dynamic> param) async {
    return doServerCallMutationWithApiAuth(
      AddMacrosResponse(),
      param,
      QueryMutation().addMacros(),
      "addMacros",
    );
  }

  Future<Resources<RemoveMacros>> doRemoveMacros(
      Map<String, dynamic> param) async {
    return doServerCallMutationWithApiAuth(
      RemoveMacros(),
      param,
      QueryMutation().addMacros(),
      "addMacros",
    );
  }
}
