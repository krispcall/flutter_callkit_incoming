import "dart:async";
import "dart:io";

import "package:awesome_notifications/awesome_notifications.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/RollbarConstant.dart";
import "package:mvp/api/WebSocketController.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/socket/SocketIoManager.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/Language.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/cancelCall/CancelCallResponseData.dart";
import "package:mvp/viewObject/model/checkDuplicateLogin/CheckDuplicateLogin.dart";
import "package:mvp/viewObject/model/dnd/UserDnd.dart";
import "package:mvp/viewObject/model/login/LoginDataDetails.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/login/User.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:mvp/viewObject/model/profile/EditProfile.dart";
import "package:mvp/viewObject/model/userDnd/Dnd.dart";
import "package:mvp/viewObject/model/userDnd/UserDndResponse.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";
import "package:no_context_navigation/no_context_navigation.dart";
import "package:web_socket_channel/status.dart" as status;

class UserProvider extends Provider {
  UserProvider({
    this.userRepository,
    this.valueHolder,
    int limit = 0,
  }) : super(userRepository!, limit) {
    isDispose = false;
    streamLoginUser = StreamController<Resources<LoginDataDetails>>.broadcast();
    subscriptionLoginUser =
        streamLoginUser!.stream.listen((Resources<LoginDataDetails> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _loginUser = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamUserProfile =
        StreamController<Resources<UserProfileData>>.broadcast();
    subscriptionUserProfile =
        streamUserProfile!.stream.listen((Resources<UserProfileData> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _userProfile = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerPlanRestriction =
        StreamController<Resources<PlanRestriction>>.broadcast();
    subscriptionPlanRestriction = streamControllerPlanRestriction!.stream
        .listen((Resources<PlanRestriction> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _planRestriction = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerUserDndTimeList =
        StreamController<List<UserDnd>>.broadcast();
    subscriptionUserDndTimeList =
        streamControllerUserDndTimeList!.stream.listen((List<UserDnd> data) {
      {
        _userDndTimeList = data;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerUpdatedUserDnd =
        StreamController<Resources<Dnd>>.broadcast();
    subscriptionUserUpdatedDnd =
        streamControllerUpdatedUserDnd!.stream.listen((Resources<Dnd> data) {
      {
        _userDnd = data;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamOnlineStatus = StreamController<bool>.broadcast();
    subscriptionOnlineStatus =
        streamOnlineStatus!.stream.listen((bool resource) {
      _onlineStatus = resource;
      isLoading = false;

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  static bool? isTokenExpire = false;
  UserRepository? userRepository;
  ValueHolder? valueHolder;

  Resources<LoginDataDetails> _loginUser =
      Resources<LoginDataDetails>(Status.NO_ACTION, "", null);
  Resources<CheckDuplicateLogin> _checkDuplicateLoginModel =
      Resources<CheckDuplicateLogin>(Status.NO_ACTION, "", null);

  Resources<LoginDataDetails>? get loginUser => _loginUser;

  StreamSubscription<Resources<LoginDataDetails>>? subscriptionLoginUser;
  StreamController<Resources<LoginDataDetails>>? streamLoginUser;

  Resources<UserProfileData> _userProfile =
      Resources<UserProfileData>(Status.NO_ACTION, "", null);

  Resources<UserProfileData>? get userProfile => _userProfile;

  Resources<EditProfile>? _editProfile =
      Resources<EditProfile>(Status.NO_ACTION, "", null);

  Resources<EditProfile>? get editProfile => _editProfile;

  StreamSubscription<Resources<UserProfileData>>? subscriptionUserProfile;
  StreamController<Resources<UserProfileData>>? streamUserProfile;

  Resources<CancelCallResponseData> _callCancel =
      Resources<CancelCallResponseData>(Status.NO_ACTION, "", null);

  Resources<CancelCallResponseData>? get callCancel => _callCancel;

  List<Language>? _languageList = <Language>[];

  List<Language>? get languageList => _languageList;

  StreamController<Resources<PlanRestriction>>? streamControllerPlanRestriction;
  StreamSubscription<Resources<PlanRestriction>>? subscriptionPlanRestriction;
  Resources<PlanRestriction>? _planRestriction =
      Resources<PlanRestriction>(Status.NO_ACTION, "", null);

  Resources<PlanRestriction>? get planRestriction => _planRestriction;

  StreamController<List<UserDnd>>? streamControllerUserDndTimeList;
  StreamSubscription<List<UserDnd>>? subscriptionUserDndTimeList;
  List<UserDnd>? _userDndTimeList = [];

  List<UserDnd>? get userDndTimeList => _userDndTimeList;

  StreamController<Resources<Dnd>>? streamControllerUpdatedUserDnd;
  StreamSubscription<Resources<Dnd>>? subscriptionUserUpdatedDnd;
  Resources<Dnd>? _userDnd = Resources<Dnd>(Status.NO_ACTION, "", null);

  Resources<Dnd>? get userDnd => _userDnd;

  StreamController<bool>? streamOnlineStatus;
  StreamSubscription<bool>? subscriptionOnlineStatus;
  bool? _onlineStatus = false;

  bool? get onlineStatus => _onlineStatus;

  Language? currentLanguage = Config.defaultLanguage;
  String? currentCountryCode = "";
  String? currentLanguageName = "";

  @override
  void dispose() {
    subscriptionLoginUser!.cancel();
    streamLoginUser!.close();

    subscriptionUserProfile!.cancel();
    streamUserProfile!.close();

    streamControllerPlanRestriction!.close();
    subscriptionPlanRestriction!.cancel();

    streamControllerUserDndTimeList!.close();
    subscriptionUserDndTimeList!.cancel();

    // streamControllerUpdatedUserDnd.close();
    subscriptionUserUpdatedDnd!.cancel();

    streamOnlineStatus!.close();
    subscriptionOnlineStatus!.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doCheckDuplicateLogin(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _checkDuplicateLoginModel = await userRepository!.doCheckDuplicateLogin(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);

    return _checkDuplicateLoginModel;
  }

  Future<Resources<LoginDataDetails>> doUserLoginApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _loginUser = await userRepository!.doUserLoginApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);

    return _loginUser;
  }

  Future<Resources<UserProfileData>> getUserProfileDetails() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _userProfile = await userRepository!.getUserProfileDetails(
        isConnectedToInternet,
        Status.PROGRESS_LOADING,
        streamControllerUpdatedUserDnd!,
        streamOnlineStatus!);

    return _userProfile;
  }

  Future<dynamic> changeProfilePicture(Map<String, String> param) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _userProfile = await userRepository!.changeProfilePicture(
        param,
        streamControllerUpdatedUserDnd!,
        streamOnlineStatus!,
        isConnectedToInternet) as Resources<UserProfileData>;
    return _userProfile;
  }

  Future<Resources<EditProfile>> editUsernameApiCall(
      Map<String, dynamic> json) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _editProfile = await userRepository!.editUsernameApiCall(
        isConnectedToInternet, Status.PROGRESS_LOADING, json);
    return _editProfile!;
  }

  Future<dynamic> changeEmail(Map<String, dynamic> json) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<UpdateUserEmail> response = await userRepository!
        .changeEmail(json, isConnectedToInternet) as Resources<UpdateUserEmail>;
    return response;
  }

  static bool boolIsTokenChanged = false;
  static bool boolIsTokenChangedLoop = false;
  static bool checkLoop = false;
  WebSocketController webSocketController = WebSocketController();

  Future<void> onLogout(
      {bool isTokenError = false,
      BuildContext? context,
      bool onlyClearLoginData = false}) async {
    final String? dump = await FirebaseMessaging.instance.getToken();

    if (getVoiceToken() != null) {
      try {
        await voiceClient.unregisterForNotification(getVoiceToken()!, dump!);
      } catch (e) {
        Utils.logRollBar(RollbarConstant.ERROR,
            "Twilio Token Unregister on logout ${e.toString()}");
        Utils.cPrint(e.toString());
      }
    }

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      Utils.logRollBar(RollbarConstant.ERROR,
          "Firebase Token Unregister on logout ${e.toString()}");
      Utils.cPrint(e.toString());
    }

    replaceLoginUserId("");
    replaceCallAccessToken("");
    replaceRefreshToken("");
    replaceUserProfilePicture("");

    userRepository!.replaceDefaultChannel(null);
    userRepository!.clearPrefrence();

    FirebaseMessaging.instance.onTokenRefresh;
    FirebaseMessaging.instance
        .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_CALL_INCOMING_TOPIC);
    FirebaseMessaging.instance.unsubscribeFromTopic(
        Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_OUTGOING);
    FirebaseMessaging.instance.unsubscribeFromTopic(
        Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_INCOMING);
    FirebaseMessaging.instance
        .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
    FirebaseMessaging.instance
        .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_MISSED_CALL_TOPIC);
    FirebaseMessaging.instance
        .unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_VOICE_MAIL_TOPIC);

    if (channel != null) {
      channel!.sink.add(SocketIoManager.socketEvents["loggedOut"]);
      channel!.sink.close(status.goingAway);
      replaceSmsNotificationSetting(false);
      replaceMissedCallNotificationSetting(false);
      replaceVoiceMailNotificationSetting(false);
      replaceChatMessageNotificationSetting(false);
    }
    // webSocketController.onClose();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().dismissedSink.close();
    AwesomeNotifications().actionSink.close();
    webSocketController.onClose();

    Utils.cancelIncomingNotification();
    Utils.cancelCallInProgressNotification();
    Utils.cancelSMSNotification();
    Utils.cancelMissedCallNotification();
    Utils.cancelVoiceMailNotification();

    if (!onlyClearLoginData) {
      if (isTokenError) {
        boolIsTokenChanged = true;
        if (!isTokenExpire!) {
          NavigationService.navigationKey.currentState!
              .pushNamedAndRemoveUntil(RoutePaths.loginView, (route) => false);
        }
        isTokenExpire = true;
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
      } else {
        boolIsTokenChanged = false;
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
        NavigationService.navigationKey.currentState!
            .pushNamedAndRemoveUntil(RoutePaths.loginView, (route) => false);
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
      }
    }
  }

  Future<dynamic> callCancelApi(String conversationId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Map requestData = {"conversationId": conversationId};
    _callCancel =
        await userRepository!.callCancelApi(requestData, isConnectedToInternet)
            as Resources<CancelCallResponseData>;
    return _callCancel;
  }

  Future<dynamic> rejectCall(String id) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _callCancel = await userRepository!.rejectCall(id, isConnectedToInternet)
        as Resources<CancelCallResponseData>;
    return _callCancel;
  }

  Future<dynamic> doUserForgotPasswordApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return userRepository!.doUserForgotPasswordApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<void> updateEmail(String text) async {
    psRepository.replaceUserEmail(text);
  }

  Future<dynamic> addLanguage(Language language) async {
    currentLanguage = language;
    return userRepository!.addLanguage(language);
  }

  Language getLanguage() {
    currentLanguage = userRepository!.getLanguage();
    return currentLanguage!;
  }

  List<dynamic> getLanguageList() {
    _languageList = Config.psSupportedLanguageMap.values.toList();
    return _languageList!;
  }

  Future<void> doSubscriptionUserProfile(BuildContext? context,
      {Function(LoginWorkspace)? switchWorkspace}) async {
    if (getLoginUserId() != null && getLoginUserId()!.isNotEmpty) {
      await userRepository!.doSubscriptionUserProfile(
          streamUserProfile!,
          streamControllerUserDndTimeList!,
          streamOnlineStatus!,
          isConnectedToInternet,
          Status.PROGRESS_LOADING,
          context,
          // userProvider: userProvider,
          switchWorkspace: (data) {
        switchWorkspace!(data);
      });
    }
  }

  Future<Resources<PlanRestriction>> doGetPlanRestriction() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<PlanRestriction> resources =
        await userRepository!.doGetPlanRestriction(
      limit,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );

    if (resources.status == Status.SUCCESS) {
      if (resources.data != null) {
        if (!streamControllerPlanRestriction!.isClosed) {
          streamControllerPlanRestriction!.sink.add(resources);
        }
      }
    }
    return resources;
  }

  Future<bool> getUserDndTimelist(bool userStatus) async {
    userRepository!
        .getUserDndTimeList(streamControllerUserDndTimeList!, userStatus);
    return Future.value(true);
  }

  void setUserDndTimeList(int i, UserDnd data) {
    userRepository!.setUserDndTimeList(i, data);
  }

  void resetUserDndTimeList() {
    userRepository!.resetUserDndTimeList();
  }

  Future<Resources<UserDndResponse>> doSetUserDndApiCall(
      int time, bool value) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return userRepository!.onSetUserDnd(
      time,
      value,
      isConnectedToInternet,
      streamControllerUpdatedUserDnd!,
    );
  }

  UserDnd? getUserDndTimeValue() {
    return userRepository!.getUserDndTimeValue();
  }

  void getUserDndEnabledValue() {
    userRepository!.getUserDndEnabledValue(streamControllerUpdatedUserDnd!);
  }

  void updateUserDndStatus(bool online) {
    userRepository!.sinkUserOnlineStatus(streamOnlineStatus!, online);
  }

  void updateNetworkDisconnected(bool value) {
    userRepository!.sinkUserOnlineStatus(streamOnlineStatus!, value);
  }
}
