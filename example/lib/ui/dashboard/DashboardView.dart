import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:isolate";

import "package:android_alarm_manager_plus/android_alarm_manager_plus.dart";
import "package:awesome_notifications/awesome_notifications.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:event_bus/event_bus.dart";
import "package:fcm_unrealistic_heartbeat/fcm_unrealistic_heartbeat.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart" show timeDilation;
import "package:flutter/services.dart";
import "package:flutter_callkit_incoming/flutter_callkit_incoming.dart";
import "package:flutter_incall_manager/flutter_incall_manager.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:graphql/client.dart";
import "package:intercom_flutter/intercom_flutter.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/RollbarConstant.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/WebSocketController.dart";
import "package:mvp/api/common/AwesomeNotificationInit.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/isolate/Isolate.dart";
import "package:mvp/provider/app_info/AppInfoProvider.dart";
import "package:mvp/provider/area_code/AreaCodeProvider.dart";
import "package:mvp/provider/call_hold/CallHoldProvider.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/call_rating/CallRatingProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/provider/messages/MessageDetailsProvider.dart";
import "package:mvp/provider/user/UserDetailProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/AppInfoRepository.dart";
import "package:mvp/repository/AreaCodeRepository.dart";
import "package:mvp/repository/CallHoldRepository.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/Common/CallRatingRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/call_logs/CallLogsView.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/DrawerView.dart";
import "package:mvp/ui/common/ForceUpdate.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/CallInProgressErrorLogoutDialog.dart";
import "package:mvp/ui/common/dialog/ConfirmDialogView.dart";
import "package:mvp/ui/common/dialog/call_rating/CallRatingDialog.dart";
import "package:mvp/ui/common/dialog/feedback/FeedbackDialog.dart";
import "package:mvp/ui/common/dialog/incoming_call_dialog/IncomingCallDialog.dart";
import "package:mvp/ui/common/dialog/outgoing_call_dialog/OutgoingCallDialog.dart";
import "package:mvp/ui/contacts/contact_view/ContactListView.dart";
import "package:mvp/ui/dialer/DialerView.dart";
import "package:mvp/ui/discord/ZoomDrawer.dart";
import "package:mvp/ui/members/MemberListView.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/ui/number_setting/NumberSettingView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/encryption.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MemberMessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/VoiceTokenPlatformParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/WorkSpaceRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/createDeviceInfo/RegisterFcmParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/appInfo/AppVersion.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/getWorkspaceCredit/WorkspaceCredit.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:mvp/viewObject/model/notification/NotificationMessage.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:mvp/viewObject/model/refreshToken/RefreshTokenResponse.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:new_version/new_version.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:voice/twiliovoice.dart";
import "package:wakelock/wakelock.dart";
import "package:workmanager/workmanager.dart";

const String tag = "DashBoard";

@pragma("vm:entry-point")
void callbackDispatcher() {
  final SendPort? sendPortCallInvite =
      IsolateManagerCallInvite.lookupPortByName();
  final SendPort? sendPortCallCancelled =
      IsolateManagerCallCancelled.lookupPortByName();

  final SendPort? sendPortOutgoingCallConnected =
      IsolateManagerOutgoingCallConnected.lookupPortByName();
  final SendPort? sendPortOutgoingCallDisconnected =
      IsolateManagerOutgoingCallDisconnected.lookupPortByName();
  final SendPort? sendPortOutgoingCallConnectionFailure =
      IsolateManagerOutgoingCallConnectionFailure.lookupPortByName();
  final SendPort? sendPortOutgoingCallQualityWarning =
      IsolateManagerOutgoingCallQualityWarningsChanged.lookupPortByName();
  final SendPort? sendPortOutgoingCallRinging =
      IsolateManagerOutgoingCallRinging.lookupPortByName();
  final SendPort? sendPortOutgoingCallReconnecting =
      IsolateManagerOutgoingCallReconnecting.lookupPortByName();
  final SendPort? sendPortOutgoingCallReconnected =
      IsolateManagerOutgoingCallReconnected.lookupPortByName();

  final SendPort? sendPortIncomingCallConnected =
      IsolateManagerIncomingCallConnected.lookupPortByName();
  final SendPort? sendPortIncomingCallDisconnected =
      IsolateManagerIncomingCallDisconnected.lookupPortByName();
  final SendPort? sendPortIncomingCallConnectionFailure =
      IsolateManagerIncomingCallConnectionFailure.lookupPortByName();
  final SendPort? sendPortIncomingCallQualityWarning =
      IsolateManagerIncomingCallQualityWarningsChanged.lookupPortByName();
  final SendPort? sendPortIncomingCallRinging =
      IsolateManagerIncomingCallRinging.lookupPortByName();
  final SendPort? sendPortIncomingCallReconnecting =
      IsolateManagerIncomingCallReconnecting.lookupPortByName();
  final SendPort? sendPortIncomingCallReconnected =
      IsolateManagerIncomingCallReconnected.lookupPortByName();
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "onCallInvite":
        sendPortCallInvite!.send(inputData);
        break;
      case "onCancelledCallInvite":
        sendPortCallCancelled!.send(inputData);
        break;
      case "incomingConnected":
        sendPortIncomingCallConnected!.send(inputData);
        break;
      case "incomingDisconnected":
        sendPortIncomingCallDisconnected!.send(inputData);
        break;
      case "incomingConnectFailure":
        sendPortIncomingCallConnectionFailure!.send(inputData);
        break;
      case "incomingCallQualityWarningsChanged":
        sendPortIncomingCallQualityWarning!.send(inputData);
        break;
      case "incomingRinging":
        sendPortIncomingCallRinging!.send(inputData);
        break;
      case "incomingReconnecting":
        sendPortIncomingCallReconnecting!.send(inputData);
        break;
      case "incomingReconnected":
        sendPortIncomingCallReconnected!.send(inputData);
        break;
      case "outGoingCallConnected":
        sendPortOutgoingCallConnected!.send(inputData);
        break;
      case "outGoingCallDisconnected":
        sendPortOutgoingCallDisconnected!.send(inputData);
        break;
      case "outGoingCallConnectFailure":
        sendPortOutgoingCallConnectionFailure!.send(inputData);
        break;
      case "outGoingCallCallQualityWarningsChanged":
        sendPortOutgoingCallQualityWarning!.send(inputData);
        break;
      case "outGoingCallRinging":
        sendPortOutgoingCallRinging!.send(inputData);
        break;
      case "outGoingCallReconnecting":
        sendPortOutgoingCallReconnecting!.send(inputData);
        break;
      case "outGoingCallReconnected":
        sendPortOutgoingCallReconnected!.send(inputData);
        break;
    }
    return Future.value(true);
  });
}

class DashboardView extends StatefulWidget {
  static EventBus workspaceOrChannelChanged = EventBus();
  static EventBus outgoingEvent = EventBus();
  static EventBus outgoingEventRecording = EventBus();
  static EventBus incomingEvent = EventBus();
  static EventBus incomingEventRecording = EventBus();
  static EventBus subscriptionMemberOnline = EventBus();

  ///Conversation Seen Event for channel Count
  static EventBus subscriptionConversationSeen = EventBus();
  static EventBus expireTokenLogin = EventBus();
  static StreamController<RecentConversationNodes>
      subscriptionCallStatusController =
      StreamController<RecentConversationNodes>.broadcast();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin {
  AnimationController? animationController;
  int currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
  bool bottomAppBarToggleVisibility = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  WebSocketController webSocketController = WebSocketController();
  ApiService apiService = ApiService();
  List<CountryCode>? countryCodeList;
  Timer? timerFcmConfigure;
  bool isOnline = true;
  Duration duration = const Duration(seconds: 1);
  Intercom intercom = Intercom.instance;
  bool forceIOSUpdate = false;
  final DeBouncer deBouncer = DeBouncer(milliseconds: 5000);

  UserRepository? userRepository;
  UserProvider? userProvider;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;

  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  MemberRepository? memberRepository;
  MemberProvider? memberProvider;

  MessageDetailsRepository? messagesRepository;
  MessageDetailsProvider? messagesProvider;

  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  CallHoldProvider? callHoldProvider;
  CallHoldRepository? callHoldRepository;

  CallRatingProvider? callRatingProvider;
  CallRatingRepository? callRatingRepository;

  AreaCodeProvider? areaCodeProvider;
  AreaCodeRepository? areaCodeRepository;

  DashboardProvider? dashboardProvider;
  UserDetailProvider? userDetailProvider;

  AppInfoRepository? appInfoRepository;
  AppInfoProvider? appInfoProvider;

  bool iOSCanUpdate = false;
  String appStoreVersion = "";
  String appLocalVersion = "";

  ValueHolder? valueHolder;

  bool error = false;
  String errorText = "";
  String uniqueKey = "";

  NotificationMessage notificationMessage = NotificationMessage();

  IncallManager inCallManager = IncallManager();

  ///Outgoing Receiver
  ReceivePort receiverPortOutgoingOnCallConnected = ReceivePort();
  ReceivePort receiverPortOutgoingOnCallDisconnected = ReceivePort();
  ReceivePort receiverPortOutgoingCallConnectionFailure = ReceivePort();
  ReceivePort receiverPortOutgoingCallQualityWarningsChanged = ReceivePort();
  ReceivePort receiverPortOutgoingCallRinging = ReceivePort();
  ReceivePort receiverPortOutgoingCallReconnecting = ReceivePort();
  ReceivePort receiverPortOutgoingCallReconnected = ReceivePort();

  ///Incoming Receiver
  ReceivePort receiverPortIncomingOnCallConnected = ReceivePort();
  ReceivePort receiverPortIncomingOnCallDisconnected = ReceivePort();
  ReceivePort receiverPortIncomingCallConnectionFailure = ReceivePort();
  ReceivePort receiverPortIncomingCallQualityWarningsChanged = ReceivePort();
  ReceivePort receiverPortIncomingCallRinging = ReceivePort();
  ReceivePort receiverPortIncomingCallReconnecting = ReceivePort();
  ReceivePort receiverPortIncomingCallReconnected = ReceivePort();

  DateTime? callAcceptDateTime;
  DateTime? incomingNotificationTime;

  bool? memberOnline;
  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;
  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;
  StreamSubscription? streamSubscriptionMessage;
  StreamSubscription? streamSubscriptionIncomingEvent;
  Stream<QueryResult>? streamUpdateMemberOnline;
  StreamSubscription? streamSubscriptionUpdateMemberOnline;

  // RecentConversationNodes callLogStatus;

  StreamSubscription? streamSubscriptionOnNetworkChanged;
  Stream<QueryResult>? streamSubscriptionCallLogs;
  List<Stream<QueryResult>>? streamSubscriptionCallLogsList = [];

  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  String defaultChannelId = "";
  String defaultChannelName = "";
  String defaultChannelNumber = "";

  @override
  bool get wantKeepAlive => true;

  Future<void> alarmManager() async {
    if (Platform.isAndroid) {
      const int helloAlarmID = 0;
      await AndroidAlarmManager.initialize();
      await AndroidAlarmManager.periodic(
          const Duration(minutes: 1), helloAlarmID, printHello);
    }
  }

  void printHello() {}

  Future<void> initializeIntercom() async {
    if (kDebugMode) {
      await intercom.initialize(
        "c7le4bjs",
        androidApiKey: "android_sdk-0b6be20ae15b197734b4db4be05a74f3c30926c2",
        iosApiKey: "ios_sdk-2edf64b4aa4d751b01065bdfed4aa2b4835979bc",
      );
    } else {
      await intercom.initialize(
        "a4gmrz0e",
        androidApiKey: "android_sdk-3834c28d50dff1df5d3c782f6d57cdf3bd32a50f",
        iosApiKey: "ios_sdk-15fe7e37f5466107f5ef7f0d3823b2742edb190d",
      );
    }
  }

  Future<void> registerIntercomUser() async {
    await intercom.loginIdentifiedUser(email: userProvider!.getUserEmail());
    await intercom.setUserHash(userProvider!.getIntercomId() ?? "");
    await intercom.updateUser(
      name: userProvider!.getUserName(),
    );
  }

  String log = "";

  Future<void> checkIOSUpdate() async {
    if (await Utils.checkInternetConnectivity()) {
      if (Platform.isIOS) {
        final newVersion = NewVersion(
          iOSId: "app.krispcall",
          androidId: "",
        );
        final status = await newVersion.getVersionStatus();
        if (status != null) {
          iOSCanUpdate = status.canUpdate;
          appStoreVersion = status.storeVersion;
          appLocalVersion = status.localVersion;
        }
      }
    }
  }

  // Future<void> _showUpdateDialog(BuildContext context) async {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return CupertinoAlertDialog(
  //           title: Column(
  //             children: const <Widget>[
  //               Text(
  //                 "Update App?",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           content: Column(
  //             children: <Widget>[
  //               Text(
  //                 "A new version of KrispCall is available! Version "
  //                 "$appStoreVersion is now available-you have "
  //                 "$appLocalVersion.",
  //                 style: const TextStyle(fontSize: 15),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               const Text(
  //                 "Would you like to update it now?",
  //                 style: TextStyle(fontSize: 15),
  //               ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: const Text(
  //                 "Later",
  //                 style: TextStyle(fontSize: 17),
  //               ),
  //               onPressed: () {
  //                 Utils.checkInternetConnectivity().then((bool onValue) async {
  //                   if (onValue) {
  //                     Navigator.of(context).pop({"updateApp": false});
  //                   } else {
  //                     Utils.showWarningToastMessage(
  //                         Utils.getString("noInternet"), context);
  //                   }
  //                 });
  //                 // Navigator.of(context).pop();
  //               },
  //             ),
  //             CupertinoDialogAction(
  //               child: const Text(
  //                 "UPDATE NOW",
  //                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
  //               ),
  //               onPressed: () {
  //                 Utils.checkInternetConnectivity().then((bool onValue) async {
  //                   if (onValue) {
  //                     Navigator.of(context).pop({"updateApp": true});
  //                   } else {
  //                     Utils.showWarningToastMessage(
  //                         Utils.getString("noInternet"), context);
  //                   }
  //                 });
  //               },
  //             ),
  //           ],
  //         );
  //       }).then((data) async {
  //     if (data != null &&
  //         data["updateApp"] != null &&
  //         data["updateApp"] == true) {
  //       await Utils.lunchWebUrl(
  //           url: Platform.isIOS
  //               ? EndPoints.APPSTORE_URL
  //               : EndPoints.PLAYSTORE_URL,
  //           context: context);
  //     }
  //   });
  // }

  Future<void> _showUpdateDialog(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space21.w, Dimens.space0.h,
                Dimens.space21.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            color: CustomColors.transparent,
            child: Padding(
              padding: EdgeInsets.only(bottom: Dimens.space160.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space16.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space24.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: PlainAssetImageHolder(
                            assetUrl: "assets/images/updateApp.png",
                            height: Dimens.space64,
                            width: Dimens.space64,
                            assetWidth: Dimens.space64,
                            assetHeight: Dimens.space64,
                            boxFit: BoxFit.contain,
                            iconUrl: CustomIcon.icon_person,
                            iconSize: Dimens.space10,
                            iconColor: CustomColors.mainColor,
                            boxDecorationColor: CustomColors.transparent,
                            outerCorner: Dimens.space0,
                            innerCorner: Dimens.space0,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space21.w,
                              Dimens.space20.h,
                              Dimens.space21.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("updateKrispCall"),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space20.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space21.w,
                              Dimens.space10.h,
                              Dimens.space21.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("updateTheLatestVersion"),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space10.h,
                              Dimens.space0.w,
                              Dimens.space8.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedButtonWidget(
                            width: double.maxFinite,
                            buttonBackgroundColor: CustomColors.white!,
                            buttonTextColor: CustomColors.loadingCircleColor!,
                            corner: Dimens.space10,
                            buttonBorderColor: CustomColors.white!,
                            buttonFontFamily: Config.manropeSemiBold,
                            buttonFontSize: Dimens.space15,
                            buttonText: Utils.getString("updateNow"),
                            onPressed: () async {
                              Utils.checkInternetConnectivity()
                                  .then((bool onValue) async {
                                if (onValue) {
                                  Navigator.of(context)
                                      .pop({"updateApp": true});
                                } else {
                                  Utils.showWarningToastMessage(
                                      Utils.getString("noInternet"), context);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space16.h, Dimens.space0.w, Dimens.space30.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedButtonWidget(
                      width: double.maxFinite,
                      buttonBackgroundColor: CustomColors.white!,
                      buttonTextColor: CustomColors.textPrimaryColor!,
                      corner: Dimens.space16,
                      buttonBorderColor: CustomColors.white!,
                      buttonFontFamily: Config.manropeSemiBold,
                      buttonFontSize: Dimens.space15,
                      buttonText: Utils.getString("noThanks"),
                      onPressed: () {
                        Utils.checkInternetConnectivity()
                            .then((bool onValue) async {
                          if (onValue) {
                            Navigator.of(context).pop({"updateApp": false});
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((data) async {
      if (data != null &&
          data["updateApp"] != null &&
          data["updateApp"] == true) {
        await Utils.lunchWebUrl(
            url: Platform.isIOS
                ? EndPoints.APPSTORE_URL
                : EndPoints.PLAYSTORE_URL,
            context: context);
      }
    });
  }

  Future iosUpdate() async {
    if (Platform.isIOS) {
      await checkIOSUpdate();
      appInfoRepository =
          Provider.of<AppInfoRepository>(context, listen: false);
      appInfoProvider = AppInfoProvider(repository: appInfoRepository);
      if (await Utils.checkInternetConnectivity()) {
        final Resources<AppVersion>? _psAppInfo =
            await appInfoProvider?.doVersionApiCall();
        if (iOSCanUpdate && !voiceClient.isOnCall) {
          if (_psAppInfo?.data?.versionForceUpdate != null &&
              _psAppInfo!.data!.versionForceUpdate!) {
            forceIOSUpdate = true;
            setState(() {});
          } else {
            _showUpdateDialog(context);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    iosUpdate();
    initializeIntercom();
    awesomeNotificationInit();
    PsSharedPreferences.instance!.shared!
        .setBool(Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, false);
    PsSharedPreferences.instance!.shared!.setBool(Const.enableCancel, false);
    requestPermission();
    alarmManager();
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    userRepository = Provider.of<UserRepository>(context, listen: false);
    userProvider =
        UserProvider(userRepository: userRepository, valueHolder: valueHolder);
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    userDetailProvider =
        Provider.of<UserDetailProvider>(context, listen: false);
    messagesRepository =
        Provider.of<MessageDetailsRepository>(context, listen: false);
    messagesProvider =
        MessageDetailsProvider(messageDetailsRepository: messagesRepository);

    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    memberProvider = MemberProvider(memberRepository: memberRepository);

    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    loginWorkspaceProvider = LoginWorkspaceProvider(
      loginWorkspaceRepository: loginWorkspaceRepository,
      valueHolder: valueHolder,
    );

    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);

    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    callLogProvider = CallLogProvider(callLogRepository: callLogRepository);

    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(contactRepository: contactRepository);

    callHoldRepository =
        Provider.of<CallHoldRepository>(context, listen: false);
    callHoldProvider =
        CallHoldProvider(callHoldRepository: callHoldRepository!);

    callRatingRepository =
        Provider.of<CallRatingRepository>(context, listen: false);
    callRatingProvider =
        CallRatingProvider(callRatingRepository: callRatingRepository!);

    areaCodeRepository =
        Provider.of<AreaCodeRepository>(context, listen: false);
    areaCodeProvider =
        AreaCodeProvider(areaCodeRepository: areaCodeRepository!);

    refreshVoiceToken();
    checkConnection();
    // initializeIntercom();
    listenerEvent();
    Utils.getSharedPreference().then((psSharePref) async {
      Utils.cPrint("this is working");
      await psSharePref.reload();
      final bool callIsConnecting =
          psSharePref.getBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING) ?? false;
      if (callIsConnecting) {
        psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
        psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
        Utils.cPrint("Call is connected ${json.decode(
          psSharePref.getString(Const.VALUE_HOLDER_CALL_DATA)!,
        )}");
        final Data? data = Data().fromMap(
          json.decode(
            psSharePref.getString(Const.VALUE_HOLDER_CALL_DATA)!,
          ),
        );
        notificationMessage.data = data;
        dashboardProvider!.channelId =
            notificationMessage.data!.customParameters!.channelSid!;
        dashboardProvider!.conversationSid =
            notificationMessage.data!.customParameters!.conversationSid!;

        acceptCallSequence();
        showIncomingBottomSheet();
      }
    });

    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      if (event.event!.toLowerCase() == "workspaceChanged".toLowerCase()) {
        refreshVoiceToken();
      } else if (event.event!.toLowerCase() == "channelChanged".toLowerCase()) {
        defaultChannelId = contactRepository!.getDefaultChannel().id!;
        defaultChannelName = contactRepository!.getDefaultChannel().name!;
        defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
        setState(() {});
      }
      doSubscriptionUpdateOnline();
    });
    doSubscriptionUpdateOnline();

    streamSubscriptionIncomingEvent =
        DashboardView.incomingEvent.on().listen((event) {
      if (event != null && event["incomingEvent"] == "incomingRinging") {
        Utils.cPrint("this is incoming event bus $event");
        if (mounted) {
          setState(() {});
        }
      }
    });

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider.isTokenExpire = false;
      DashboardView.expireTokenLogin.on().listen((event) {
        if (UserProvider.boolIsTokenChanged) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePaths.home, (Route<dynamic> route) => false);
        } else {
          if (isClickAble()) {
            zoomDrawerController.toggle!();
          }
        }
      });

      zoomDrawerController.stateNotifier!.addListener(() {
        final drawerValue =
            zoomDrawerController.stateNotifier!.value.toString();
        if (drawerValue.toLowerCase() == "DrawerState.opening".toLowerCase() ||
            drawerValue.toLowerCase() == "drawerstate.open".toLowerCase()) {
          CustomAppBar.changeStatusColor(CustomColors.mainColor!);
        } else {
          CustomAppBar.changeStatusColor(CustomColors.white!, setDelay: true);
        }
      });
    });

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    if (userRepository!.getLoginUserId() != null &&
        userRepository!.getLoginUserId()!.isNotEmpty) {
      try {
        AwesomeNotifications().createdStream.listen((receivedNotification) {});

        AwesomeNotifications()
            .displayedStream
            .listen((receivedNotification) {});

        AwesomeNotifications().dismissedStream.listen((receivedNotification) {
          if (receivedNotification.channelKey ==
              Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING) {
            if (Platform.isIOS) {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .outgoingIsCallConnected) {
                Utils.showCallInProgressNotificationOutgoing();
              }
            }
          }
          if (receivedNotification.channelKey ==
              Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING) {
            if (Platform.isIOS) {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsCallConnected) {
                Utils.showCallInProgressNotificationIncoming(
                    notificationMessage);
              }
            }
          }
        });

        AwesomeNotifications().actionStream.listen((receivedNotification) {
          registerBackgroundPort();
          processDefaultActionClickEvent(receivedNotification);
        });
      } catch (e) {}
    }

    getUniQueKey();

    IsolateManagerOutgoingCallDisconnected.registerPortWithName(
        receiverPortOutgoingOnCallDisconnected.sendPort);
    IsolateManagerOutgoingCallConnected.registerPortWithName(
        receiverPortOutgoingOnCallConnected.sendPort);
    IsolateManagerOutgoingCallConnectionFailure.registerPortWithName(
        receiverPortOutgoingCallConnectionFailure.sendPort);
    IsolateManagerOutgoingCallQualityWarningsChanged.registerPortWithName(
        receiverPortOutgoingCallQualityWarningsChanged.sendPort);
    IsolateManagerOutgoingCallRinging.registerPortWithName(
        receiverPortOutgoingCallRinging.sendPort);
    IsolateManagerOutgoingCallReconnecting.registerPortWithName(
        receiverPortOutgoingCallReconnecting.sendPort);
    IsolateManagerOutgoingCallReconnected.registerPortWithName(
        receiverPortOutgoingCallReconnected.sendPort);
    IsolateManagerIncomingCallDisconnected.registerPortWithName(
        receiverPortIncomingOnCallDisconnected.sendPort);
    IsolateManagerIncomingCallConnected.registerPortWithName(
        receiverPortIncomingOnCallConnected.sendPort);
    IsolateManagerIncomingCallConnectionFailure.registerPortWithName(
        receiverPortIncomingCallConnectionFailure.sendPort);
    IsolateManagerIncomingCallQualityWarningsChanged.registerPortWithName(
        receiverPortIncomingCallQualityWarningsChanged.sendPort);
    IsolateManagerIncomingCallRinging.registerPortWithName(
        receiverPortIncomingCallRinging.sendPort);
    IsolateManagerIncomingCallReconnecting.registerPortWithName(
        receiverPortIncomingCallReconnecting.sendPort);
    IsolateManagerIncomingCallReconnected.registerPortWithName(
        receiverPortIncomingCallReconnected.sendPort);

    Workmanager().initialize(
      callbackDispatcher,
    );

    voiceClient.onCancelledCallInvite?.listen((event) {
      callCancelledSequence();
      FlutterCallkitIncoming.endAllCalls();
    });

    if (Platform.isIOS) {
      voiceClient.onCallInvite?.listen((callBackData) async {
        final String to = callBackData.to ?? "";
        final String from = callBackData.from ?? "";
        final Map customParam = callBackData.customParameters ?? {};
        final Map channelInfo = callBackData.channelInfo ?? {};
        final String callSid = callBackData.callSid ?? "";
        log = {
          "to": to,
          "from": from,
          "customParam": customParam,
          "channelInfo": channelInfo,
          "callSid": callSid,
        }.toString();
        // setState(() {});
        Utils.cPrint(
            "this is receiverPortOnCallInvite ${callBackData.customParameters}");
        dashboardProvider!.channelId =
            (callBackData.customParameters!["channel_sid"] == null
                ? null
                : callBackData.customParameters!["channel_sid"] as String)!;
        dashboardProvider!.conversationSid =
            (callBackData.customParameters!["conversation_sid"] == null
                ? null
                : callBackData.customParameters!["conversation_sid"]
                    as String)!;
        dashboardProvider!.afterTransfer =
            callBackData.customParameters!["after_transfer"] == null
                ? false
                : callBackData.customParameters!["after_transfer"] as String ==
                        "True"
                    ? true
                    : false;
        final Data data = Data(
          id: 1,
          twiFrom: callBackData.from,
          twiTo: callBackData.to,
          twiCallSid: callBackData.callSid,
          customParameters: CustomParameters(
            // afterHold: callBackData.customParameters["after_hold"] as String,
            afterTransfer: callBackData.customParameters!["after_transfer"] ==
                    null
                ? false
                : callBackData.customParameters!["after_transfer"] as String ==
                        "True"
                    ? true
                    : false,
            from: callBackData.customParameters!["from"] == null
                ? null
                : callBackData.customParameters!["from"] as String,
            channelSid: callBackData.customParameters!["channel_sid"] == null
                ? null
                : callBackData.customParameters!["channel_sid"] as String,
            contactName: "Unknown",
            contactNumber: callBackData.channelInfo!["number"] == null
                ? null
                : callBackData.channelInfo!["number"] as String,
            conversationSid:
                callBackData.customParameters!["conversation_sid"] == null
                    ? null
                    : callBackData.customParameters!["conversation_sid"]
                        as String,
          ),
          channelInfo: ChannelInfo(
            id: callBackData.channelInfo!["id"] == null
                ? null
                : callBackData.channelInfo!["id"] as String,
            number: callBackData.channelInfo!["number"] == null
                ? null
                : callBackData.channelInfo!["number"] as String,
            countryLogo: callBackData.channelInfo!["country_logo"] == null
                ? null
                : callBackData.channelInfo!["country_logo"] as String,
            countryCode: callBackData.channelInfo!["country_code"] == null
                ? null
                : callBackData.channelInfo!["country_code"] as String,
            name: callBackData.channelInfo!["name"] == null
                ? null
                : callBackData.channelInfo!["name"] as String,
            country: callBackData.channelInfo!["country"] == null
                ? null
                : callBackData.channelInfo!["country"] as String,
            numberSid: "abc",
          ),
        );
        notificationMessage.data = data;
      });
      voiceClient.onAnswerCall?.listen((event) async {
        dashboardProvider!.incomingIsCallConnected = true;
        dashboardProvider!.afterTransfer = event
                    .customParameters!["after_transfer"]
                    .toString()
                    .toUpperCase() ==
                "TRUE"
            ? true
            : false;
        dashboardProvider!.conversationSid =
            event.customParameters!["conversation_sid"] as String;
        final Data data = Data(
          id: 1,
          twiFrom: event.from,
          twiTo: event.to,
          twiCallSid: event.callSid,
          customParameters: CustomParameters(
            // afterHold: callBackData.customParameters["after_hold"] as String,
            afterTransfer: event.customParameters!["after_transfer"] == null
                ? false
                : event.customParameters!["after_transfer"] as String == "True"
                    ? true
                    : false,
            from: event.customParameters!["from"] == null
                ? null
                : event.customParameters!["from"] as String,
            channelSid: event.customParameters!["channel_sid"] == null
                ? null
                : event.customParameters!["channel_sid"] as String,
            contactName: "Unknown",
            contactNumber: event.channelInfo!["number"] == null
                ? null
                : event.channelInfo!["number"] as String,
            conversationSid: event.customParameters!["conversation_sid"] == null
                ? null
                : event.customParameters!["conversation_sid"] as String,
          ),
          channelInfo: ChannelInfo(
            id: event.channelInfo!["id"] == null
                ? null
                : event.channelInfo!["id"] as String,
            number: event.channelInfo!["number"] == null
                ? null
                : event.channelInfo!["number"] as String,
            countryLogo: event.channelInfo!["country_logo"] == null
                ? null
                : event.channelInfo!["country_logo"] as String,
            countryCode: event.channelInfo!["country_code"] == null
                ? null
                : event.channelInfo!["country_code"] as String,
            name: event.channelInfo!["name"] == null
                ? null
                : event.channelInfo!["name"] as String,
            country: event.channelInfo!["country"] == null
                ? null
                : event.channelInfo!["country"] as String,
            numberSid: "abc",
          ),
        );
        notificationMessage.data = data;
        setState(() {});
        Wakelock.enable();
        final SubscriptionUpdateConversationDetailRequestHolder
            subscriptionUpdateConversationDetailRequestHolder =
            SubscriptionUpdateConversationDetailRequestHolder(
          channelId: notificationMessage.data!.channelInfo!.id!,
        );

        /// Start Incoming Timer
        if (Provider.of<DashboardProvider>(context, listen: false)
            .incomingIsCallConnected) {
          dashboardProvider!.startIncomingTimer();
        }

        ///Start Call In progress Notificaiton
        if (Provider.of<DashboardProvider>(context, listen: false)
            .incomingIsCallConnected) {
          Utils.showCallInProgressNotificationIncoming(notificationMessage);
        }
        if (Platform.isIOS) {
          showIncomingBottomSheet();
        }

        Future.wait(
          [
            userProvider!.doGetPlanRestriction(),
            loginWorkspaceProvider!.doGetNumberSettings(
              subscriptionUpdateConversationDetailRequestHolder,
            ),
          ],
        ).then(
          (v) {
            final Resources<PlanRestriction> resources =
                v[0] as Resources<PlanRestriction>;
            final Resources<NumberSettings> numberSettings =
                v[1] as Resources<NumberSettings>;
            if (resources.data != null &&
                resources.data!.callRecordingsAndStorage != null &&
                resources.data!.callRecordingsAndStorage!.hasAccess != null &&
                resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
              dashboardProvider!.autoRecord =
                  numberSettings.data!.autoRecordCalls!;
              dashboardProvider!.isRecord =
                  numberSettings.data!.autoRecordCalls!;
              setState(() {});

              ///Start Incoming Record Timer
              if (Provider.of<DashboardProvider>(context, listen: false)
                      .incomingIsCallConnected &&
                  Provider.of<DashboardProvider>(context, listen: false)
                      .autoRecord) {
                dashboardProvider!.startIncomingRecordTimer();
              }
            }
          },
          onError: (err) async {
            dashboardProvider!.autoRecord = false;
            dashboardProvider!.isRecord = false;
            setState(() {});
          },
        );
      });
    }

    ///Outgoing Events Foreground
    handleForegroundOutgoingEvents();

    ///Outgoing Event Background
    handleBackgroundOutgoingEvents();

    ///Incoming Event Foreground
    handleForegroundIncomingEvents();

    ///Incoming Event Background
    handleBackgroundIncomingEvents();

    Future.delayed(const Duration(seconds: 20), () {
      webSocketController.initWebSocketConnection();
      getOnlineConnection();
      webSocketController.sendData("Dashboard View");
      fcmWake();
    });

    if (valueHolder != null &&
        valueHolder!.loginUserId != null &&
        valueHolder!.loginUserId != "") {
      getCountryCodeListFromDB();
    }
  }

  ///Refresh voice according to ttl
  void refreshVoiceToken() {
    Utils.cPrint("Refresh Voice Token");
    fcmConfigure();
    timerFcmConfigure = Timer.periodic(const Duration(minutes: 15), (Timer t) {
      fcmConfigure();
    });
  }

  ///Check internet auto detect internet connection
  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      if (onValue) {
        internetConnectionStatus = InternetConnectionStatus.connected;
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
      }
      setState(() {});
    });

    streamSubscriptionOnNetworkChanged = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      if (status != InternetConnectionStatus.disconnected &&
          internetConnectionStatus == InternetConnectionStatus.disconnected) {
        userProvider!.getUserProfileDetails().then((data) {
          memberProvider!
              .doGetAllWorkspaceMembersApiCall(memberProvider!.getMemberId())
              .then((data) {
            userProvider!.updateNetworkDisconnected(true);
            internetConnectionStatus = InternetConnectionStatus.connected;
            webSocketController.initWebSocketConnection();
            getOnlineConnection();
            webSocketController.sendData("Dashboard View");
            setState(() {});
          });
        });
      } else {
        if (status != InternetConnectionStatus.connected) {
          webSocketController.onClose();
        }
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        userProvider!.updateNetworkDisconnected(false);
        setState(() {});
      }
    });
  }

  ///Fcm Wake
  void fcmWake() {
    Timer.periodic(const Duration(minutes: 1), (Timer t) async {
      final s = await FcmUnrealisticHeartbeat.init ?? "Can not Init";
    });
  }

  Future<void> getOnlineConnection() async {
    deBouncer.run(() async {
      // await memberProvider
      //     .doGetAllWorkspaceMembersApiCall(memberProvider.getMemberId());
      final bool onlineConnection = memberProvider!.getMemberOnlineStatus();
      final bool stayOnline = PsSharedPreferences.instance!.shared!
          .getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS)!;
      webSocketController.send(sendScreen: "Dashboard");
    });
  }

  Future<void> doSubscriptionUpdateOnline() async {
    streamUpdateMemberOnline =
        await memberProvider!.doSubscriptionOnlineMemberStatus(
      memberProvider!.getWorkspaceDetail().id!,
      memberProvider!.getMemberId(),
    );

    if (streamUpdateMemberOnline != null) {
      streamSubscriptionUpdateMemberOnline =
          streamUpdateMemberOnline!.listen((event) async {
        Utils.cPrint("this is member online sub dashboard $event");
        if (event.data != null) {
          final MemberStatus? memberStatus = MemberStatus()
              .fromMap(event.data!["onlineMemberStatus"]["message"]);
          if (memberStatus != null) {
            if (memberStatus.id == memberProvider!.getMemberId()) {
              memberProvider!
                  .replaceMemberOnlineStatus(memberStatus.online! || false);
            }
            // memberProvider.updateSubscriptionMemberOnline(
            //     memberStatus,
            //     memberProvider.getWorkspaceDetail().id,
            //     memberProvider.getMemberId());
          }
        }
      });
    }
  }

  @override
  Future<void> dispose() async {
    Utils.cPrint("dasboard dispose");
    try {
      if (Platform.isIOS) {
        voiceClient.disConnect();
        final String? dump = await FirebaseMessaging.instance.getToken();
        userRepository!.replaceDefaultChannel(null);
        try {
          await voiceClient.unregisterForNotification(
              loginWorkspaceProvider!.getVoiceToken()!, dump!);
        } catch (e) {
          Utils.cPrint(e.toString());
        }
      }
      webSocketController.onClose();
      dashboardProvider!.setDefault();
      WidgetsBinding.instance.removeObserver(this);
      timerFcmConfigure?.cancel();
      AwesomeNotifications().createdSink.close();
      AwesomeNotifications().displayedSink.close();
      AwesomeNotifications().dismissedSink.close();
      AwesomeNotifications().actionSink.close();
      streamSubscriptionOnWorkspaceOrChannelChanged!.cancel();
      streamSubscriptionOnNetworkChanged!.cancel();
      streamSubscriptionMessage!.cancel();
      streamSubscriptionIncomingEvent!.cancel();
      streamSubscriptionUpdateMemberOnline!.cancel();
    } catch (e) {
      Utils.cPrint(e.toString());
    }
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    Utils.cPrint("dispose_called_>> $state");
    if (state == AppLifecycleState.detached) {
      FlutterCallkitIncoming.endAllCalls();
      print("app is detached");
      Utils.getSharedPreference().then((psSharePref) async {
        psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
        psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
      });
    } else if (state == AppLifecycleState.inactive) {
      print("app is inactive");
      if (Platform.isIOS) {
        // voiceClient.disConnect();
      }
    } else if (state == AppLifecycleState.resumed) {
      print("app is resumed");
      Future.delayed(const Duration(milliseconds: 500), () {
        Utils.getSharedPreference().then((psSharePref) async {
          await psSharePref.reload();
          final bool callIsConnecting =
              psSharePref.getBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING) ??
                  false;
          if (callIsConnecting) {
            psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
            psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
            Utils.cPrint("Call is connected ${json.decode(
              psSharePref.getString(Const.VALUE_HOLDER_CALL_DATA)!,
            )}");
            final Data? data = Data().fromMap(
              json.decode(
                psSharePref.getString(Const.VALUE_HOLDER_CALL_DATA)!,
              ),
            );
            notificationMessage.data = data;
            dashboardProvider!.channelId =
                notificationMessage.data!.customParameters!.channelSid!;
            dashboardProvider!.conversationSid =
                notificationMessage.data!.customParameters!.conversationSid!;

            acceptCallSequence().then((_) {
              showIncomingBottomSheet();
            });
          }
        });
      });
    } else if (state == AppLifecycleState.paused) {
      print("app is paused");
    }

    registerBackgroundPort();
  }

  ///on click notification call function click event
  Future<void> processDefaultActionClickEvent(
      ReceivedAction receivedNotification) async {
    if (receivedNotification.buttonKeyPressed == "reject") {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => rejectCallSequence());
    } else if (receivedNotification.buttonKeyPressed == "accept") {
      final Data data = Data().fromMap(receivedNotification.payload)!;
      notificationMessage.data = data;
      dashboardProvider!.channelId =
          notificationMessage.data!.customParameters!.channelSid!;
      dashboardProvider!.conversationSid =
          notificationMessage.data!.customParameters!.conversationSid!;

      acceptCallSequence();
      showIncomingBottomSheet();
    } else if (receivedNotification.buttonKeyPressed == "view") {
      if (receivedNotification.channelKey == Const.NOTIFICATION_CHANNEL_SMS) {
        Utils.cancelSMSNotification();
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
            onContactBlocked: (bool value) {},
          ),
        );
        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_MISSED_CALL) {
        Utils.cancelMissedCallNotification();
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
          ),
        );
        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_VOICE_MAIL) {
        Utils.cancelVoiceMailNotification();
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
            onContactBlocked: (bool) {},
          ),
        );

        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE) {
        Utils.cancelChatMessageNotification();
        await Navigator.pushNamed(
          context,
          RoutePaths.memberMessageDetail,
          arguments: MemberMessageDetailIntentHolder(
            onlineStatus:
                receivedNotification.payload!["onlineStatus"].toLowerCase() ==
                    "true",
            clientName: receivedNotification.payload!["sender"] as String,
            clientProfilePicture:
                receivedNotification.payload!["messageIcon"] as String,
            clientEmail: receivedNotification.payload!["email"] as String,
            clientId: receivedNotification.payload!["senderId"] as String,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
          ),
        );
      } else {}
      if (!mounted) return;
      Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    } else {
      if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_INCOMING) {
        final Data? data = Data().fromMap(receivedNotification.payload);
        notificationMessage.data = data;
        Utils.cancelIncomingNotification();
        showIncomingBottomSheet();
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING) {
        if (Platform.isIOS) {
          if (Provider.of<DashboardProvider>(context, listen: false)
              .outgoingIsCallConnected) {
            Utils.showCallInProgressNotificationOutgoing();
          }
        }
        if (Provider.of<DashboardProvider>(context, listen: false)
            .outgoingIsCallConnected) {
          showOutgoingBottomSheet();
        }
      }
      if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING) {
        final Data data = Data().fromMap(receivedNotification.payload)!;
        notificationMessage.data = data;
        if (Platform.isIOS) {
          if (Provider.of<DashboardProvider>(context, listen: false)
              .incomingIsCallConnected) {
            Utils.showCallInProgressNotificationIncoming(notificationMessage);
          }
        }
        showIncomingBottomSheet();
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_SMS) {
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
            onContactBlocked: (bool) {},
          ),
        );
        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_VOICE_MAIL) {
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
          ),
        );
        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_MISSED_CALL) {
        final CountryCode? country = await countryListProvider!
            .getCountryCodeByNumber(
                receivedNotification.payload!["clientNumber"] as String);
        if (!mounted) return;
        final dynamic returnedData = await Navigator.pushNamed(
          context,
          RoutePaths.messageDetail,
          arguments: MessageDetailIntentHolder(
            channelId: receivedNotification.payload!["channelId"].toString(),
            channelName:
                receivedNotification.payload!["channelName"].toString(),
            channelNumber:
                receivedNotification.payload!["channelNumber"].toString(),
            clientName: receivedNotification.payload!["clientNumber"] as String,
            clientPhoneNumber:
                receivedNotification.payload!["clientNumber"] as String,
            countryId: country!.id,
            clientProfilePicture: null,
            isBlocked: false,
            lastChatted: null,
            clientId: null,
            // dndMissed: false,
            isContact: false,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
            makeCallWithSid: (channelNumber,
                channelName,
                channelSid,
                outgoingNumber,
                workspaceSid,
                memberId,
                voiceToken,
                outgoingName,
                outgoingId,
                outgoingProfilePicture) {
              makeCallWithSid(
                channelNumber!,
                channelName!,
                channelSid!,
                outgoingNumber!,
                workspaceSid!,
                memberId!,
                voiceToken!,
                outgoingName!,
                outgoingId ?? "",
                outgoingProfilePicture!,
              );
            },
          ),
        );
        if (returnedData != null) {
          defaultChannelId = contactRepository!.getDefaultChannel().id!;
          defaultChannelName = contactRepository!.getDefaultChannel().name!;
          defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "channelChanged",
              workspaceChannel: loginWorkspaceProvider!.getDefaultChannel(),
            ),
          );
          setState(() {});
        }
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CHAT_MESSAGE) {
        await Navigator.pushNamed(
          context,
          RoutePaths.memberMessageDetail,
          arguments: MemberMessageDetailIntentHolder(
            onlineStatus:
                receivedNotification.payload!["onlineStatus"].toLowerCase() ==
                    "true",
            clientName: receivedNotification.payload!["sender"] as String,
            clientProfilePicture:
                receivedNotification.payload!["messageIcon"] as String,
            clientEmail: receivedNotification.payload!["email"] as String,
            clientId: receivedNotification.payload!["senderId"] as String,
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
          ),
        );
      }
    }
  }

  int getBottomNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case Const.REQUEST_CODE_MENU_CALLS_FRAGMENT:
        index = 0;
        break;
      case Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT:
        index = 1;
        break;
      case Const.REQUEST_CODE_MENU_DIALER_FRAGMENT:
        index = 2;
        break;
      case Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT:
        index = 3;
        break;
      case Const.REQUEST_CODE_MENU_NUMBER_SETTING:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  void getIndexFromBottomNavigationIndex(int param) {
    switch (param) {
      case 0:
        currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
        break;
      case 1:
        currentIndex = Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT;
        break;
      case 2:
        currentIndex = Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
        break;
      case 3:
        currentIndex = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
        break;
      case 4:
        currentIndex = Const.REQUEST_CODE_MENU_NUMBER_SETTING;
        break;
      default:
        currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
        break;
    }
    setState(() {});
  }

  Future<void> getUniQueKey() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        uniqueKey = iosInfo.identifierForVendor!;
      });
    } else {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        uniqueKey = androidInfo.id!;
      });
    }
  }

  void onCallAccept(Data event) {
    acceptCallSequence();
    // doSubscriptionCallLogForOutgoing(
    //     event.customParameters["channel_sid"] as String);
    dashboardProvider!.incomingIsCallConnected = true;
    dashboardProvider!.afterTransfer =
        event.customParameters!.afterTransfer.toString().toUpperCase() == "TRUE"
            ? true
            : false;
    dashboardProvider!.conversationSid =
        event.customParameters!.conversationSid!;
    final Data data = Data(
      id: 1,
      twiFrom: event.twiFrom,
      twiTo: event.twiTo,
      twiCallSid: event.twiCallSid,
      customParameters: CustomParameters(
        // afterHold: event.customParameters["after_hold"] as String,
        afterTransfer:
            event.customParameters!.afterTransfer.toString().toUpperCase() ==
                    "TRUE"
                ? true
                : false,
        from: event.customParameters!.from,
        channelSid: event.customParameters!.channelSid,
        contactName: "Unknown",
        contactNumber: event.channelInfo!.number,
        conversationSid: event.customParameters!.conversationSid,
      ),
      channelInfo: ChannelInfo(
        id: event.channelInfo!.id,
        number: event.channelInfo!.number,
        countryLogo: event.channelInfo!.countryLogo,
        countryCode: event.channelInfo!.countryCode,
        name: event.channelInfo!.name,
        country: event.channelInfo!.country,
        numberSid: "abc",
      ),
    );
    dashboardProvider!.notificationMessage.data = data;
    setState(() {});
    Wakelock.enable();
    Utils.cPrint("call is connected1");
    final SubscriptionUpdateConversationDetailRequestHolder
        subscriptionUpdateConversationDetailRequestHolder =
        SubscriptionUpdateConversationDetailRequestHolder(
      channelId: event.channelInfo!.id!,
    );

    /// Start Incoming Timer
    if (Provider.of<DashboardProvider>(context, listen: false)
        .incomingIsCallConnected) {
      dashboardProvider!.startIncomingTimer();
    }
    Utils.cPrint("call is connected3");

    ///Start Call In progress Notificaiton
    if (Provider.of<DashboardProvider>(context, listen: false)
        .incomingIsCallConnected) {
      Future.delayed(const Duration(seconds: 5), () {
        Utils.showCallInProgressNotificationIncoming(
            dashboardProvider!.notificationMessage);
      });
    }
    Utils.cPrint("call is connected4");
    // if (Platform.isIOS) {
    showIncomingBottomSheet(); // }
    // CallKeep.setCurrentCallActive("1");

    Future.wait(
      [
        userProvider!.doGetPlanRestriction(),
        loginWorkspaceProvider!.doGetNumberSettings(
          subscriptionUpdateConversationDetailRequestHolder,
        ),
      ],
    ).then(
      (v) {
        final Resources<PlanRestriction> resources =
            v[0] as Resources<PlanRestriction>;
        final Resources<NumberSettings> numberSettings =
            v[1] as Resources<NumberSettings>;
        if (resources.data != null &&
            resources.data!.callRecordingsAndStorage != null &&
            resources.data!.callRecordingsAndStorage!.hasAccess != null &&
            resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
          dashboardProvider!.autoRecord = numberSettings.data!.autoRecordCalls!;
          dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
          setState(() {});

          ///Start Incoming Record Timer
          if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsCallConnected &&
              Provider.of<DashboardProvider>(context, listen: false)
                  .autoRecord) {
            dashboardProvider!.startIncomingRecordTimer();
          }
        }
        FlutterCallkitIncoming.endAllCalls();
      },
      onError: (err) async {
        dashboardProvider!.autoRecord = false;
        dashboardProvider!.isRecord = false;
        setState(() {});
      },
    );
  }

  Future<void> showIncomingCall(
      Data data, String name, String imageUrl, String selectedSound) async {
    final params = <String, dynamic>{
      "id": data.id.toString(),
      "nameCaller": name,
      "channelName": data.channelInfo!.name,
      "channelNumber": "+${data.channelInfo!.number}",
      "appName": "KrispCall",
      "avatar": imageUrl,
      "handle": "",
      "type": 0,
      "duration": 40000,
      "textAccept": "Accept",
      "textDecline": "Decline",
      "textMissedCall": "Missed call",
      "textCallback": "Call back",
      "extra": Data().toMap(data),
      "headers": <String, dynamic>{"apiKey": "Abc@123!", "platform": "flutter"},
      "android": <String, dynamic>{
        "incomingCallNotificationChannelName":
            Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        "missedCallNotificationChannelName":
            Const.NOTIFICATION_CHANNEL_MISSED_CALL,
        "isCustomNotification": true,
        "isShowLogo": true,
        "isShowCallback": true,
        "isShowMissedCallNotification": false,
        "ringtonePath": selectedSound.isNotEmpty
            ? selectedSound
            : "system_ringtone_default",
        "backgroundColor": "#390179",
        "background": "",
        "actionColor": ""
      }
    };
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  void onEndCall(String uuid) {
    FlutterCallkitIncoming.endAllCalls();
    voiceClient.disConnect();
    Utils.getSharedPreference().then((psSharePref) async {
      await psSharePref.reload();
      psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
      psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
      dashboardProvider!.incomingIsCallConnected = false;
      psSharePref.setBool(
          Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
      setState(() {});
    });
    Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
  }

  Future<void> listenerEvent() async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        switch (event!.name) {
          case CallEvent.ACTION_CALL_INCOMING:
            // TODO: received an incoming call
            break;
          case CallEvent.ACTION_CALL_START:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case CallEvent.ACTION_CALL_ACCEPT:
            final Data? data = Data().fromMap(event.body["extra"]);
            notificationMessage.data = data;
            dashboardProvider!.channelId =
                notificationMessage.data!.customParameters!.channelSid!;
            dashboardProvider!.conversationSid =
                notificationMessage.data!.customParameters!.conversationSid!;

            acceptCallSequence();
            showIncomingBottomSheet();
            break;
          case CallEvent.ACTION_CALL_DECLINE:
            Future.delayed(const Duration(seconds: 1))
                .then((value) => rejectCallSequence());
            break;
          case CallEvent.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
            break;
          case CallEvent.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            break;
          case CallEvent.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
        }
        // if (callback != null) {
        //   callback(event.toString());
        // }
      });
    } on Exception {}
  }

  Future<void> fcmConfigure() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // await FirebaseMessaging.instance.requestPermission(
    //   sound: true,
    //   badge: true,
    //   alert: true,
    //   provisional: false,
    //   criticalAlert: true,
    // );
    await AwesomeNotifications()
        .requestPermissionToSendNotifications(permissions: [
      NotificationPermission.Alert,
      NotificationPermission.Sound,
      NotificationPermission.Badge,
      NotificationPermission.Vibration,
      NotificationPermission.Light,
      NotificationPermission.FullScreenIntent
    ]);
    final String? toBeDumped = await FirebaseMessaging.instance.getToken();
    if (loginWorkspaceProvider!.getVoiceToken() != null) {
      voiceClient.unregisterForNotification(
          loginWorkspaceProvider!.getVoiceToken()!, toBeDumped!);
    }

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      Utils.cPrint(e.toString());
    }
    streamSubscriptionMessage?.cancel();
    FirebaseMessaging.instance.onTokenRefresh;

    final String? dump = await FirebaseMessaging.instance.getToken();

    final Resources<RefreshTokenResponse> refreshAccessToken =
        await loginWorkspaceProvider!.doRefreshTokenApiCall();

    if (refreshAccessToken.data != null &&
        refreshAccessToken.data!.refreshTokenResponseData != null &&
        refreshAccessToken.data!.refreshTokenResponseData!.data != null &&
        refreshAccessToken.data!.refreshTokenResponseData!.data!.accessToken !=
            null &&
        refreshAccessToken
            .data!.refreshTokenResponseData!.data!.accessToken!.isNotEmpty) {
      /// Re fetch Voice Token

      final VoiceTokenPlatformParamHolder voiceTokenPlatformParamHolder =
          VoiceTokenPlatformParamHolder(
              platform: Platform.isIOS ? "IPHONE" : "ANDROID");
      final Resources<String> voiceToken = await loginWorkspaceProvider!
              .doVoiceTokenApiCall(voiceTokenPlatformParamHolder.toMap())
          as Resources<String>;

      voiceClient ??= VoiceClient(voiceToken.data!);
      if (voiceToken.data != null) {
        voiceClient
            .registerForNotification(
                EncryptionDecryption.decrypt(voiceToken.data!), dump!)
            .then((value) async {
          if (value) {
            loginWorkspaceProvider!.replaceVoiceToken(voiceToken.data!);
            final RegisterFcmParamHolder registerFcmParamHolder =
                RegisterFcmParamHolder(
              fcmRegistrationId: await FirebaseMessaging.instance.getToken(),
              version: Config.appVersion,
              platform: Platform.isIOS
                  ? Utils.getString("ios")
                  : Utils.getString("android"),
            );
            loginWorkspaceProvider!
                .doDeviceRegisterApiCall(registerFcmParamHolder.toMap());

            /// Re fetch Voice Token
            intercom.sendTokenToIntercom(Platform.isIOS
                ? FirebaseMessaging.instance.getAPNSToken().toString()
                : FirebaseMessaging.instance.getToken().toString());
            FirebaseMessaging.instance.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_INCOMING_TOPIC);
            FirebaseMessaging.instance.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_OUTGOING);
            FirebaseMessaging.instance.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_INCOMING);
            FirebaseMessaging.instance
                .subscribeToTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
            FirebaseMessaging.instance
                .subscribeToTopic(Const.NOTIFICATION_CHANNEL_MISSED_CALL_TOPIC);
            FirebaseMessaging.instance
                .subscribeToTopic(Const.NOTIFICATION_CHANNEL_VOICE_MAIL_TOPIC);
            FirebaseMessaging.instance.subscribeToTopic("TEST");
            streamSubscriptionMessage =
                FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              print("RemoteMessage Foreground ${message.data.toString()}");
              if (message.data.containsKey("twi_account_sid")) {
                Utils.logRollBar(RollbarConstant.INFO,
                    "Foreground Incoming Call Notification: \n${message.data}");
                if (!isRedundantNotification(DateTime.now())) {
                  if (Provider.of<DashboardProvider>(context, listen: false)
                          .outgoingIsCallConnected ||
                      Provider.of<DashboardProvider>(context, listen: false)
                          .incomingIsCallConnected) {
                    final Map<String, dynamic> map = {};
                    map["data"] = message.data;
                    Utils.showToastMessage("Already in a call");
                    voiceClient.handleMessage(map).then((value) {
                      voiceClient.rejectCall();
                    });
                  } else {
                    final Map<String, dynamic> map = {};
                    map["data"] = message.data;
                    voiceClient.handleMessage(map).then((result) {
                      final Data? data = Data().fromMap(result);
                      data!.channelInfo!.numberSid = "abcde";
                      data.customParameters!.contactName = "Unknown";
                      notificationMessage.data = data;
                      dashboardProvider!.afterTransfer = notificationMessage
                          .data!.customParameters!.afterTransfer!;
                      dashboardProvider!.channelId = notificationMessage
                          .data!.customParameters!.channelSid!;
                      dashboardProvider!.conversationSid = notificationMessage
                          .data!.customParameters!.conversationSid!;
                      // Utils.playRingTone();
                      // Utils.showNotificationWithActionButtons(
                      //     notificationMessage);
                      Future.delayed(const Duration(seconds: 40)).then((value) {
                        // Utils.cancelIncomingNotification();
                        // FlutterCallkitIncoming.endAllCalls();
                      });
                      Utils.getSharedPreference().then((psSharedPref) async {
                        await psSharedPref.reload();
                        dashboardProvider!.incomingIsCallConnected = false;
                        psSharedPref.setBool(
                            Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS,
                            false);
                        final String contactList = psSharedPref
                            .getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
                        final List decodeContactList =
                            jsonDecode(contactList) as List;
                        setState(() {});
                        final List filterContact = decodeContactList.where((z) {
                          if (z["number"].trim() ==
                              "+${data.customParameters!.from!.trim()}") {
                            return true;
                          } else {
                            return false;
                          }
                        }).toList();
                        showIncomingCall(
                          data,
                          filterContact.isEmpty
                              ? "+${data.customParameters!.from}"
                              : filterContact[0]["name"].toString().trim(),
                          filterContact.isEmpty
                              ? "+${data.customParameters!.from}"
                              : filterContact[0]["imageUrl"].toString().trim(),
                          psSharedPref.getString(
                                          Const.VALUE_HOLDER_SELECTED_SOUND) !=
                                      null &&
                                  psSharedPref
                                      .getString(
                                          Const.VALUE_HOLDER_SELECTED_SOUND)!
                                      .isNotEmpty
                              ? psSharedPref
                                  .getString(Const.VALUE_HOLDER_SELECTED_SOUND)!
                              : "",
                        );
                      });
                    });
                  }
                }
              } else if (message.data.containsKey("topic")) {
                Utils.cPrint(message.data["topic"].toString());
                if (message.data["topic"] == "message") {
                  Utils.showSmsNotification(
                    title: message.data["title"] as String,
                    body: message.data["body"] as String,
                    clientNumber: message.data["client_number"] as String,
                    channelId: message.data["channel_id"] as String,
                    channelNumber: message.data["channel_number"] as String,
                    channelName: message.data["channel_name"] as String,
                  );
                } else if (message.data["topic"] == "missed_call") {
                  Utils.showMissedCallNotification(
                    title: message.data["title"] as String,
                    body: message.data["body"] as String,
                    clientNumber: message.data["client_number"] as String,
                    channelId: message.data["channel_id"] as String,
                    channelNumber: message.data["channel_number"] as String,
                    channelName: message.data["channel_name"] as String,
                  );
                } else if (message.data["topic"] == "voicemail") {
                  Utils.showVoiceMailNotification(
                    title: message.data["title"] as String,
                    body: message.data["body"] as String,
                    clientNumber: message.data["client_number"] as String,
                    channelId: message.data["channel_id"] as String,
                    channelNumber: message.data["channel_number"] as String,
                    channelName: message.data["channel_name"] as String,
                  );
                } else if (message.data["topic"] == "chat_message") {
                  Utils.showChatMessageNotification(
                    title: message.data["title"] as String,
                    body: message.data["body"] as String,
                    sender: message.data["sender"] as String,
                    email: message.data["email"] as String,
                    senderId: message.data["sender_id"] as String,
                    onlineStatus: message.data["online_status"] as String,
                    messageIcon: message.data["message_icon"] as String,
                  );
                } else if (message.data["topic"] == "call") {
                  /// for call do nothing
                }
              } else if (message.data.containsKey("intercom_push_type")) {
                /// Intercom Notification Disable for foreground
              } else {
                Utils.showNormalNotification(
                  title: message.data["title"] as String,
                  body: message.data["body"] as String,
                );
              }
            });
            FirebaseMessaging.onMessageOpenedApp.listen((event) {
              Utils.cPrint("Dump Dump Dump");
            });
            FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
          } else {
            fcmConfigure();
          }
        });
      }
    }
  }

  Future<void> _switchWorkSpace(LoginWorkspace loginWorkspace) async {
    final bool connectivity = await Utils.checkInternetConnectivity();
    if (connectivity) {
      Utils.cancelIncomingNotification();
      Utils.cancelCallInProgressNotification();
      Utils.cancelSMSNotification();
      Utils.cancelVoiceMailNotification();
      Utils.cancelMissedCallNotification();
      Utils.cancelChatMessageNotification();
      voiceClient.disConnect();
      Utils.switchWorkspace("Redirecting to your active workspace", context);
      await PsProgressDialog.showDialog(context, isDissmissable: false);

      final Resources<Member>? workspaceLoginData =
          await loginWorkspaceProvider!.doWorkSpaceLogin(
        WorkSpaceRequestParamHolder(
          authToken: loginWorkspaceProvider!.getApiToken(),
          workspaceId: loginWorkspace.id!,
          memberId: loginWorkspace.memberId!,
        ).toMap(),
      );

      if (workspaceLoginData!.data != null &&
          workspaceLoginData.data!.data != null &&
          workspaceLoginData.data!.data!.data != null) {
        webSocketController.onClose();

        ///Refresh Permission
        await loginWorkspaceProvider!.doGetUserPermissions();

        ///Refresh Plan Restriction
        await userProvider!.doGetPlanRestriction();

        ///Refresh Workspace List
        await loginWorkspaceProvider!.doGetWorkSpaceListApiCall(
            loginWorkspaceProvider!.getLoginUserId());

        ///Refresh Plan OverView
        await loginWorkspaceProvider!.doPlanOverViewApiCall();

        ///Refresh Workspace Detail
        final Resources<Workspace>? workspaceDetail =
            await loginWorkspaceProvider!.doWorkSpaceDetailApiCall(
          workspaceLoginData.data!.data!.data!.accessToken!,
        );

        if (workspaceDetail != null &&
            workspaceDetail.data != null &&
            workspaceDetail.data!.workspace != null &&
            workspaceDetail.data!.workspace!.data != null) {
          ///Refresh User Detail
          final Resources<UserProfileData> profileData = await userProvider!
              .getUserProfileDetails() as Resources<UserProfileData>;

          if (profileData.data != null) {
            webSocketController.initWebSocketConnection();
            getOnlineConnection();
            webSocketController.sendData("Dashboard View");
          }
          final Resources<ChannelData>? channelList =
              await loginWorkspaceProvider!.doChannelListApiCall(
                  loginWorkspaceProvider!.getCallAccessToken());
          if (channelList != null &&
              channelList.data != null &&
              channelList.data!.data != null) {
            setState(() {});
            if (channelList.data != null &&
                channelList.data!.data != null &&
                channelList.data!.data!.isNotEmpty) {
              DashboardView.workspaceOrChannelChanged.fire(
                SubscriptionWorkspaceOrChannelChanged(
                  event: "workspaceChanged",
                  workspaceChannel: channelList.data!.data![0],
                ),
              );
            } else {
              DashboardView.workspaceOrChannelChanged.fire(
                SubscriptionWorkspaceOrChannelChanged(
                  event: "workspaceChanged",
                ),
              );
            }
            setState(() {});
            PsProgressDialog.dismissDialog();
          } else {
            DashboardView.workspaceOrChannelChanged.fire(
              SubscriptionWorkspaceOrChannelChanged(
                event: "workspaceChanged",
              ),
            );
            setState(() {});
            PsProgressDialog.dismissDialog();
          }
        } else {
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "workspaceChanged",
            ),
          );
          setState(() {});
          PsProgressDialog.dismissDialog();
        }
      } else {
        setState(() {});
        PsProgressDialog.dismissDialog();
      }
      CustomAppBar.changeStatusColor(CustomColors.white!);
      Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    } else {
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);

    timeDilation = 1.0;

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _requestPop,
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<CountryListProvider>(
            lazy: false,
            create: (BuildContext context) {
              countryListProvider =
                  CountryListProvider(countryListRepository: countryRepository);
              countryListProvider!.getCountryListFromDb();
              return countryListProvider!;
            },
          ),
          ChangeNotifierProvider<AreaCodeProvider>(
            lazy: false,
            create: (BuildContext context) {
              areaCodeProvider =
                  AreaCodeProvider(areaCodeRepository: areaCodeRepository!);
              areaCodeProvider!.getAllAreaCodes().then((getAllAreaCode) {
                dashboardProvider!.areaCode = StateCodeResponse()
                    .toMap(getAllAreaCode.data!.stateCodeResponse)!;
              });
              return areaCodeProvider!;
            },
          ),
          ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                userRepository: userRepository,
                valueHolder: valueHolder,
              );
              final String tempWorkspaceId =
                  userProvider!.getDefaultWorkspace();
              userProvider!.doGetPlanRestriction();
              userProvider!.getUserProfileDetails().then((_) {
                if (userProvider!.getDefaultWorkspace() != tempWorkspaceId) {
                  userDetailProvider!.defaultWorkspaceId =
                      userProvider!.getDefaultWorkspace();

                  _switchWorkSpace(loginWorkspaceProvider!
                      .loginWorkspaceList!.data!.data!
                      .where((element) =>
                          element.id == userDetailProvider!.defaultWorkspaceId)
                      .first);
                }
                userProvider!.doSubscriptionUserProfile(
                  context,
                  switchWorkspace: (LoginWorkspace data) {
                    _switchWorkSpace(data);
                  },
                );
              });
              return userProvider!;
            },
          ),
          ChangeNotifierProvider<CallHoldProvider>(
            lazy: false,
            create: (BuildContext context) {
              callHoldProvider =
                  CallHoldProvider(callHoldRepository: callHoldRepository!);
              return callHoldProvider!;
            },
          ),
          ChangeNotifierProvider<LoginWorkspaceProvider>(
            lazy: false,
            create: (BuildContext context) {
              loginWorkspaceProvider = LoginWorkspaceProvider(
                loginWorkspaceRepository: loginWorkspaceRepository,
                valueHolder: valueHolder,
              );
              loginWorkspaceProvider!
                  .doGetWorkSpaceListApiCall(
                      loginWorkspaceProvider!.getLoginUserId())
                  .then((value) {
                setState(() {});
              });
              loginWorkspaceProvider!.doWorkSpaceDetailApiCall(
                  loginWorkspaceProvider!.getCallAccessToken());
              loginWorkspaceProvider!.doChannelListForDashboardApiCall(
                loginWorkspaceProvider!.getCallAccessToken(),
              );
              loginWorkspaceProvider!.doPlanOverViewApiCall();
              loginWorkspaceProvider!.doGetUserPermissions();
              return loginWorkspaceProvider!;
            },
          ),
          ChangeNotifierProvider<CallLogProvider>(
            lazy: false,
            create: (BuildContext context) {
              callLogProvider =
                  CallLogProvider(callLogRepository: callLogRepository);
              // doSubscriptionCallLogForOutgoing();
              doSubscriptionAllChannels();
              return callLogProvider!;
            },
          ),
          ChangeNotifierProvider<MemberProvider>(
            lazy: false,
            create: (BuildContext context) {
              memberProvider =
                  MemberProvider(memberRepository: memberRepository);
              memberProvider!.doGetAllWorkspaceMembersApiCall(
                  memberProvider!.getMemberId());
              registerIntercomUser();
              return memberProvider!;
            },
          ),
          ChangeNotifierProvider<MessageDetailsProvider>(
            lazy: false,
            create: (BuildContext context) {
              messagesProvider = MessageDetailsProvider(
                  messageDetailsRepository: messagesRepository);
              return messagesProvider!;
            },
          ),
          ChangeNotifierProvider<ContactsProvider>(
            lazy: false,
            create: (BuildContext context) {
              contactsProvider = ContactsProvider(
                contactRepository: contactRepository,
              );
              contactsProvider!.doAllContactApiCall();
              return contactsProvider!;
            },
          ),
        ],
        child: forceIOSUpdate
            ? const ForceUpdate()
            : Consumer<CountryListProvider>(
                builder: (BuildContext context, CountryListProvider provider,
                    Widget? child) {
                  return ZoomDrawer(
                    controller: zoomDrawerController,
                    borderRadius: Dimens.space16.r,
                    openCurve: Curves.easeOut,
                    disableGesture: true,
                    slideWidth: MediaQuery.of(context).size.width.w * 2,
                    duration: const Duration(milliseconds: 200),
                    showShadow: true,
                    angle: 0.0,
                    mainScreenScale: 1,
                    mainScreen: Scaffold(
                      key: scaffoldKey,
                      extendBody: true,
                      resizeToAvoidBottomInset: true,
                      backgroundColor: CustomColors.white,
                      bottomNavigationBar: currentIndex ==
                                  Const.REQUEST_CODE_MENU_HOME_FRAGMENT ||
                              currentIndex ==
                                  Const.REQUEST_CODE_MENU_CALLS_FRAGMENT ||
                              currentIndex ==
                                  Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT ||
                              currentIndex ==
                                  Const
                                      .REQUEST_CODE_MENU_NUMBER_SETTING || //go to profile
                              currentIndex ==
                                  Const.REQUEST_CODE_MENU_DIALER_FRAGMENT ||
                              currentIndex ==
                                  Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT
                          ? Visibility(
                              visible: bottomAppBarToggleVisibility,
                              child: BottomAppBar(
                                color: CustomColors.white,
                                shape: const CircularNotchedRectangle(),
                                notchMargin: 0.01,
                                elevation: Dimens.space1.r,
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  height: Dimens.space70.h,
                                  color: CustomColors.white,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Divider(
                                        color: CustomColors.mainDividerColor,
                                        height: Dimens.space1.h,
                                        thickness: Dimens.space1.h,
                                      ),
                                      Expanded(
                                        child: BottomNavigationBar(
                                          type: BottomNavigationBarType.fixed,
                                          currentIndex:
                                              getBottomNavigationIndex(
                                                  currentIndex),
                                          showUnselectedLabels: true,
                                          backgroundColor: CustomColors.white,
                                          selectedItemColor:
                                              CustomColors.mainColor,
                                          elevation: 0,
                                          iconSize: Dimens.space24.w,
                                          selectedLabelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: CustomColors.mainColor,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space12.sp,
                                              ),
                                          unselectedLabelStyle:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    color: CustomColors
                                                        .textSecondaryColor,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        Config.manropeSemiBold,
                                                    fontSize: Dimens.space12.sp,
                                                  ),
                                          selectedFontSize: Dimens.space12.sp,
                                          unselectedFontSize: Dimens.space12.sp,
                                          unselectedItemColor:
                                              CustomColors.textSecondaryColor,
                                          showSelectedLabels: true,
                                          onTap: (int index) {
                                            getIndexFromBottomNavigationIndex(
                                                index);
                                          },
                                          items: <BottomNavigationBarItem>[
                                            BottomNavigationBarItem(
                                              icon: Icon(
                                                CustomIcon
                                                    .icon_activity_unselected,
                                                size: Dimens.space24.w,
                                              ),
                                              activeIcon: Icon(
                                                CustomIcon
                                                    .icon_activity_selected,
                                                size: Dimens.space24.w,
                                              ),
                                              label: Utils.getString("calls"),
                                            ),
                                            BottomNavigationBarItem(
                                              activeIcon: Icon(
                                                CustomIcon
                                                    .icon_contact_selected,
                                                size: Dimens.space24.w,
                                              ),
                                              icon: Icon(
                                                CustomIcon
                                                    .icon_contact_unselected,
                                                size: Dimens.space24.w,
                                              ),
                                              label: Utils.getString("members"),
                                            ),
                                            BottomNavigationBarItem(
                                              activeIcon: Icon(
                                                CustomIcon.icon_dialer_selected,
                                                size: Dimens.space24.w,
                                              ),
                                              icon: Icon(
                                                CustomIcon
                                                    .icon_dialer_unselected,
                                                size: Dimens.space24.w,
                                              ),
                                              label: Utils.getString("dialer"),
                                            ),
                                            BottomNavigationBarItem(
                                              activeIcon: Icon(
                                                CustomIcon
                                                    .icon_contacts_selected,
                                                size: Dimens.space24.w,
                                              ),
                                              icon: Icon(
                                                CustomIcon
                                                    .icon_contacts_unselected,
                                                size: Dimens.space24.w,
                                              ),
                                              label:
                                                  Utils.getString("contacts"),
                                            ),
                                            BottomNavigationBarItem(
                                              activeIcon: Icon(
                                                CustomIcon.icon_mores_selected,
                                                size: Dimens.space24.w,
                                              ),
                                              icon: Icon(
                                                CustomIcon
                                                    .icon_mores_unselected,
                                                size: Dimens.space24.w,
                                              ),
                                              label: Utils.getString("more"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : null,
                      body: LayoutBuilder(
                        builder: (context, constraints) {
                          if (currentIndex ==
                              Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT) {
                            animationController!.forward();
                            return ContactListView(
                              animationController: animationController!,
                              channelId: defaultChannelId.isNotEmpty
                                  ? defaultChannelId
                                  : loginWorkspaceProvider!
                                      .getDefaultChannel()
                                      .id,
                              channelName: defaultChannelName.isNotEmpty
                                  ? defaultChannelName
                                  : loginWorkspaceProvider!
                                      .getDefaultChannel()
                                      .name,
                              channelNumber: defaultChannelNumber.isNotEmpty
                                  ? defaultChannelNumber
                                  : loginWorkspaceProvider!
                                      .getDefaultChannel()
                                      .number,
                              onLeadingTap: () {
                                if (isClickAble()) {
                                  zoomDrawerController.toggle!();
                                }
                              },
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                              makeCallWithSid: (channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture) {
                                makeCallWithSid(
                                  channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture,
                                );
                              },
                            );
                          } else if (currentIndex ==
                              Const.REQUEST_CODE_MENU_CALLS_FRAGMENT) {
                            animationController!.forward();
                            return CallLogsView(
                              animationController: animationController,
                              onLeadingTap: () {
                                if (isClickAble()) {
                                  zoomDrawerController.toggle!();
                                }
                              },
                              onCallTap: () {
                                setState(() {
                                  currentIndex =
                                      Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
                                });
                              },
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                              makeCallWithSid: (channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture) {
                                makeCallWithSid(
                                  channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture,
                                );
                              },
                              loginWorkspaceProvider: loginWorkspaceProvider,
                            );
                          } else if (currentIndex ==
                              Const.REQUEST_CODE_MENU_NUMBER_SETTING) {
                            animationController!.forward();

                            return NumberSettingView(
                              animationController: animationController,
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                            );
                          } else if (currentIndex ==
                              Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT) {
                            return MemberListView(
                              animationController: animationController!,
                              onLeadingTap: () {
                                if (isClickAble()) {
                                  zoomDrawerController.toggle!();
                                }
                              },
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                            );
                          } else if (currentIndex ==
                              Const.REQUEST_CODE_MENU_DIALER_FRAGMENT) {
                            animationController!.forward();
                            return DialerView(
                              animationController: animationController,
                              countryList:
                                  countryListProvider!.countryList!.data,
                              onLeadingTap: () {
                                if (isClickAble()) {
                                  zoomDrawerController.toggle!();
                                }
                              },
                              defaultCountryCode:
                                  countryListProvider!.getDefaultCountryCode(),
                              makeCallWithSid: (channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture) {
                                makeCallWithSid(
                                  channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId ?? "",
                                  outgoingProfilePicture,
                                );
                              },
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                              loginWorkspaceProvider: loginWorkspaceProvider,
                            );
                          } else {
                            animationController!.forward();
                            return CallLogsView(
                              animationController: animationController,
                              onLeadingTap: () {
                                if (isClickAble()) {
                                  zoomDrawerController.toggle!();
                                }
                              },
                              onCallTap: () {
                                setState(() {
                                  currentIndex =
                                      Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
                                });
                              },
                              onIncomingTap: () {
                                showIncomingBottomSheet();
                              },
                              onOutgoingTap: () {
                                showOutgoingBottomSheet();
                              },
                              makeCallWithSid: (channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture) {
                                makeCallWithSid(
                                  channelNumber,
                                  channelName,
                                  channelSid,
                                  outgoingNumber,
                                  workspaceSid,
                                  memberId,
                                  voiceToken,
                                  outgoingName,
                                  outgoingId,
                                  outgoingProfilePicture,
                                );
                              },
                              loginWorkspaceProvider: loginWorkspaceProvider,
                            );
                          }
                        },
                      ),
                    ),
                    menuScreen: DrawerView(
                      zoomDrawerController: zoomDrawerController,
                      animationController: animationController,
                      animation: animation,
                      loginWorkspaceProvider: loginWorkspaceProvider,
                      userProvider: userProvider,
                      memberProvider: memberProvider,
                      countryListProvider: countryListProvider,
                      contactsProvider: contactsProvider,
                      onIncomingTap: () {
                        showIncomingBottomSheet();
                      },
                      onOutgoingTap: () {
                        showOutgoingBottomSheet();
                      },
                      onLogout: () {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          // await Navigator.of(context).pop();
                          if (Provider.of<DashboardProvider>(context,
                                      listen: false)
                                  .outgoingIsCallConnected ||
                              Provider.of<DashboardProvider>(context,
                                      listen: false)
                                  .incomingIsCallConnected) {
                            showCallInProgressErrorLogoutDialog(() {
                              // This is logout error
                              voiceClient.disConnect();
                              userProvider!.onLogout(context: context);
                            });
                          } else {
                            // This is okay
                            userProvider!.onLogout(context: context);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> showCallInProgressErrorLogoutDialog(
      VoidCallback callback) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CallInProgressErrorLogoutDialog(
          onTap: () {
            Navigator.of(context).pop();
            callback();
          },
        );
      },
    );
  }

  Future<bool> _requestPop() {
    showExitDialog();
    return Future<bool>.value(false);
  }

  Future<void> showExitDialog() async {
    await showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialogView(
          description: Utils.getString("areYouSureToExit"),
          leftButtonText: Utils.getString("cancel"),
          rightButtonText: Utils.getString("ok").toUpperCase(),
          onAgreeTap: () {
            voiceClient.disConnect();
            dashboardProvider!.setDefault();
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              Utils.cancelIncomingNotification();
              Utils.cancelCallInProgressNotification();
              Utils.cancelSMSNotification();
            });
            SystemNavigator.pop();
          },
        );
      },
    );
  }

  Future<void> makeCallWithSid(
    String channelNumber,
    String channelName,
    String channelSid,
    String outgoingNumber,
    String workspaceSid,
    String memberId,
    String voiceToken,
    String outgoingName,
    String outgoingId,
    String outgoingProfilePicture,
  ) async {
    if (Provider.of<DashboardProvider>(context, listen: false)
            .outgoingIsCallConnected ||
        Provider.of<DashboardProvider>(context, listen: false)
            .incomingIsCallConnected) {
      Utils.showToastMessage("Already in a call");
    } else {
      Utils.cPrint("Here Here Here");
      final bool val = await requestRecordPermission();
      Utils.cPrint(val.toString());
      if (val) {
        final List<WorkspaceChannel> listWorkspaceChannel =
            contactsProvider!.getChannelList()!;

        if (listWorkspaceChannel.isNotEmpty) {
          if (listWorkspaceChannel.isNotEmpty) {
            for (int i = 0; i < listWorkspaceChannel.length; i++) {
              if (listWorkspaceChannel[i].number == outgoingNumber) {
                Utils.showToastMessage(Utils.getString("cannotCallThisNumber"));
                return;
              }
            }
          }

          Utils.cPrint("Here Here Here 1");

          final Resources<WorkspaceCreditResponse> creditResponse =
              await loginWorkspaceProvider!.doWorkspaceCreditApiCall();
          if (creditResponse.data != null &&
              creditResponse.data!.getWorkspaceCredit != null &&
              double.parse(creditResponse.data!.getWorkspaceCredit!
                      .currentCredit!.currentCredit!) >
                  0.5) {
            final SubscriptionUpdateConversationDetailRequestHolder
                subscriptionUpdateConversationDetailRequestHolder =
                SubscriptionUpdateConversationDetailRequestHolder(
              channelId: channelSid,
            );
            final Resources<NumberSettings> numberSettings =
                await loginWorkspaceProvider!.doGetNumberSettings(
                    subscriptionUpdateConversationDetailRequestHolder);
            dashboardProvider!.autoRecord =
                numberSettings.data!.autoRecordCalls!;
            dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
            setState(() {});
            if (numberSettings.data != null &&
                numberSettings.data!.numberAbilities != null &&
                numberSettings.data!.numberAbilities!.call != null &&
                numberSettings.data!.numberAbilities!.call!) {
              if (numberSettings.data != null &&
                  numberSettings.data!.internationalCallAndMessages != null &&
                  numberSettings.data!.internationalCallAndMessages!) {
                final Resources<Contacts> contacts = await contactsProvider!
                    .doContactDetailByNumberApiCall(outgoingNumber);
                if (contacts.data != null && contacts.data!.id != null) {
                  dashboardProvider!.outgoingId = contacts.data!.id!;
                  dashboardProvider!.outgoingProfilePicture =
                      contacts.data!.profilePicture ?? "";
                  dashboardProvider!.outgoingNumber = outgoingNumber;
                  dashboardProvider!.channelName = channelName;
                  dashboardProvider!.channelNumber = channelNumber;
                  dashboardProvider!.channelId = channelSid;
                  dashboardProvider!.outgoingName = contacts.data!.name!;
                  setState(() {});
                } else {
                  dashboardProvider!.outgoingId = outgoingId;
                  dashboardProvider!.outgoingProfilePicture =
                      outgoingProfilePicture;
                  dashboardProvider!.outgoingNumber = outgoingNumber;
                  dashboardProvider!.channelName = channelName;
                  dashboardProvider!.channelNumber = channelNumber;
                  dashboardProvider!.channelId = channelSid;
                  dashboardProvider!.outgoingName = outgoingName;
                  setState(() {});
                }

                ///TODO Sushan Change this
                if (dashboardProvider?.selectedCountryCode != null) {
                  final SharedPreferences prefs =
                      await Utils.getSharedPreference();
                  prefs.setString(
                      Const.VALUE_HOLDER_SELECTED_COUNTRY_CODE,
                      json.encode(CountryCode()
                          .toMap(dashboardProvider!.selectedCountryCode)));
                }
                voiceClient.makeCallWithSid(
                  outgoingNumber,
                  channelNumber,
                  workspaceSid,
                  channelSid,
                  memberId,
                  voiceToken,
                );
                showOutgoingBottomSheet();
              } else {
                final CountryCode a =
                    await countryListProvider!.getCountryByIso(channelNumber);
                final CountryCode b =
                    await countryListProvider!.getCountryByIso(outgoingNumber);
                if (a.dialCode == b.dialCode) {
                  voiceClient.makeCallWithSid(
                    outgoingNumber,
                    channelNumber,
                    workspaceSid,
                    channelSid,
                    memberId,
                    voiceToken,
                  );
                  dashboardProvider!.outgoingId = outgoingId;
                  dashboardProvider!.outgoingProfilePicture =
                      outgoingProfilePicture;
                  dashboardProvider!.outgoingNumber = outgoingNumber;
                  dashboardProvider!.channelName = channelName;
                  dashboardProvider!.channelNumber = channelNumber;
                  dashboardProvider!.channelId = channelSid;
                  dashboardProvider!.outgoingName = outgoingName;
                  setState(() {});

                  showOutgoingBottomSheet();
                } else {
                  Utils.showToastMessage(
                      Utils.getString("internationalCallDisabled"));
                }
              }
            } else {
              Utils.showToastMessage(Utils.getString("callingNotSupported"));
            }
          } else {
            Utils.showToastMessage(Utils.getString("insufficientCredit"));
          }
        } else {
          Utils.showToastMessage(Utils.getString("emptyChannel"));
        }
      } else {
        Utils.showToastMessage(
            "You need to allow record permission to make calls");
        openAppSettings();
      }
    }
  }

  Future<bool> requestPermission() async {
    final Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.microphone,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
      Permission.phone,
      Permission.storage,
      Permission.notification,
      // Permission.camera,
      Permission.ignoreBatteryOptimizations,
    ].request();

    for (int i = 0; i < permissionStatus.length; i++) {
      if (permissionStatus[i]?.isGranted ?? false) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<bool> requestRecordPermission() async {
    final PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getCountryCodeListFromDB() async {
    countryCodeList =
        await countryListProvider!.getCountryListFromDb() as List<CountryCode>;
  }

  void handleForegroundOutgoingEvents() {
    voiceClient.outGoingCallRinging?.listen((event) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallRinging",
        "callSid": event.callSid,
        "state": Utils.getString("ringing")
      });
    });

    voiceClient.outGoingCallConnected?.listen((event) async {
      setState(() {});
      Wakelock.enable();
      dashboardProvider!.outgoingIsCallConnected = true;
      Utils.showToastMessage("Connected");
      final SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder =
          SubscriptionUpdateConversationDetailRequestHolder(
        channelId:
            Provider.of<DashboardProvider>(context, listen: false).channelId,
      );

      ///Start Outgoing Timer
      if (Provider.of<DashboardProvider>(context, listen: false)
          .outgoingIsCallConnected) {
        dashboardProvider!.startOutgoingTimer();
      }

      ///Start Outgoing In progress Notification
      if (Provider.of<DashboardProvider>(context, listen: false)
          .outgoingIsCallConnected) {
        Utils.showCallInProgressNotificationOutgoing();
      }

      Future.wait(
        [
          userProvider!.doGetPlanRestriction(),
          loginWorkspaceProvider!.doGetNumberSettings(
            subscriptionUpdateConversationDetailRequestHolder,
          ),
        ],
      ).then(
        (v) {
          final Resources<PlanRestriction> resources =
              v[0] as Resources<PlanRestriction>;
          final Resources<NumberSettings> numberSettings =
              v[1] as Resources<NumberSettings>;
          if (resources.data != null &&
              resources.data!.callRecordingsAndStorage != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
            dashboardProvider!.autoRecord =
                numberSettings.data!.autoRecordCalls!;
            dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
            setState(() {});

            ///Start Outgoing Record Timer
            if (Provider.of<DashboardProvider>(context, listen: false)
                    .outgoingIsCallConnected &&
                Provider.of<DashboardProvider>(context, listen: false)
                    .autoRecord) {
              dashboardProvider!.startOutgoingRecordTimer();
            }
          }
        },
        onError: (err) async {
          dashboardProvider!.autoRecord = false;
          dashboardProvider!.isRecord = false;
          setState(() {});
        },
      );
    });

    voiceClient.outGoingCallDisconnected?.listen((event) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      /// Stop Outgoing Timer
      dashboardProvider!.stopOutgoingTimer();

      /// Stop Outgoing  Record Timer
      dashboardProvider?.stopOutgoingRecordTimer();

      /// Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Utils.cancelCallInProgressNotification();
      });

      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "afterTransfer": false,
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      // if (!dashboardProvider.afterTransfer) {
      showOutgoingRatingDialog();
      // }

      if (event.error != null) {
        Utils.logRollBar(RollbarConstant.ERROR,
            "Foreground OutGoing Call Connect Failure: \n${Data().toMap(notificationMessage.data)}");
      }
    });

    voiceClient.outGoingCallConnectFailure?.listen((event) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      ///Stop Outgoing Timer
      dashboardProvider!.stopOutgoingTimer();

      ///Stop Outgoing Record Timer
      dashboardProvider?.stopOutgoingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      ///Reset Call Info
      dashboardProvider!.setDefault();

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Utils.cancelCallInProgressNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      Utils.logRollBar(RollbarConstant.ERROR,
          "Foreground OutGoing Call Connect Failure: \n${Data().toMap(notificationMessage.data)}");
    });

    voiceClient.outGoingCallReconnecting?.listen((event) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnecting"});
    });

    voiceClient.outGoingCallReconnected?.listen((event) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnected"});
    });

    voiceClient.outGoingCallCallQualityWarningsChanged?.listen((event) {
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallCallQualityWarningsChanged"});
    });
  }

  void handleBackgroundOutgoingEvents() {
    receiverPortOutgoingCallRinging.listen((message) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallRinging",
        "callSid": message["twi_call_sid"],
        "state": Utils.getString("ringing")
      });
    });

    receiverPortOutgoingOnCallConnected.listen((callBackData) async {
      setState(() {});
      Wakelock.enable();
      dashboardProvider!.outgoingIsCallConnected = true;
      Utils.showToastMessage("Connected");
      final SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder =
          SubscriptionUpdateConversationDetailRequestHolder(
        channelId:
            Provider.of<DashboardProvider>(context, listen: false).channelId,
      );

      ///Start Outgoing Timer
      if (Provider.of<DashboardProvider>(context, listen: false)
          .outgoingIsCallConnected) {
        dashboardProvider!.startOutgoingTimer();
      }

      ///Start Outgoing In progress Notification
      if (Provider.of<DashboardProvider>(context, listen: false)
          .outgoingIsCallConnected) {
        Utils.showCallInProgressNotificationOutgoing();
      }

      Future.wait(
        [
          userProvider!.doGetPlanRestriction(),
          loginWorkspaceProvider!.doGetNumberSettings(
            subscriptionUpdateConversationDetailRequestHolder,
          ),
        ],
      ).then(
        (v) {
          final Resources<PlanRestriction> resources =
              v[0] as Resources<PlanRestriction>;
          final Resources<NumberSettings> numberSettings =
              v[1] as Resources<NumberSettings>;
          if (resources.data != null &&
              resources.data!.callRecordingsAndStorage != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
            dashboardProvider!.autoRecord =
                numberSettings.data!.autoRecordCalls!;
            dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
            setState(() {});

            ///Start Outgoing Record Timer
            if (Provider.of<DashboardProvider>(context, listen: false)
                    .outgoingIsCallConnected &&
                Provider.of<DashboardProvider>(context, listen: false)
                    .autoRecord) {
              dashboardProvider!.startOutgoingRecordTimer();
            }
          }
        },
        onError: (err) async {
          dashboardProvider!.autoRecord = false;
          dashboardProvider!.isRecord = false;
          setState(() {});
        },
      );
    });

    receiverPortOutgoingOnCallDisconnected.listen((callBackData) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      ///Stop Outgoing Timer
      dashboardProvider!.stopOutgoingTimer();

      ///Stop Outgoing Recording Timer
      dashboardProvider?.stopOutgoingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Utils.cancelCallInProgressNotification();
      });

      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "afterTransfer": false,
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      // if (!dashboardProvider.afterTransfer) {
      showOutgoingRatingDialog();
      // }
    });

    receiverPortOutgoingCallConnectionFailure.listen((message) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      ///Stop Outgoing Timer
      dashboardProvider!.stopOutgoingTimer();

      ///Stop Outgoing Record Timer
      dashboardProvider?.stopOutgoingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      ///Reset Call Info
      dashboardProvider!.setDefault();

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Utils.cancelCallInProgressNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
    });

    receiverPortOutgoingCallReconnecting.listen((message) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnecting"});
    });

    receiverPortOutgoingCallReconnected.listen((message) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnected"});
    });

    receiverPortOutgoingCallQualityWarningsChanged.listen((message) {
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallCallQualityWarningsChanged"});
    });
  }

  void handleForegroundIncomingEvents() {
    voiceClient.incomingRinging?.listen((event) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingRinging",
        "state": Utils.getString("ringing"),
      });
    });

    voiceClient.incomingDisconnected?.listen((event) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      ///Stop Incoming Timer
      dashboardProvider!.stopIncomingTimer();

      ///Stop Incoming Record Timer
      dashboardProvider!.stopIncomingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        Utils.cancelCallInProgressNotification();
        Utils.cancelIncomingNotification();
        Utils.getSharedPreference().then((psSharedPref) async {
          await psSharedPref.reload();
          psSharedPref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
          psSharedPref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
          dashboardProvider!.incomingIsCallConnected = false;
          psSharedPref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
          setState(() {});
        });
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingDisconnected",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      if (!dashboardProvider!.afterTransfer) {
        showIncomingRatingDialog();
      }

      if (event.error != null) {
        Utils.logRollBar(RollbarConstant.ERROR,
            "Foreground Incoming Connect Failure: \n${Data().toMap(notificationMessage.data)} \n${event.error}");
      }
    });

    voiceClient.incomingConnected?.listen((event) async {
      Wakelock.enable();
      dashboardProvider!.incomingIsCallConnected = true;
      final SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder =
          SubscriptionUpdateConversationDetailRequestHolder(
        channelId: notificationMessage.data!.channelInfo!.id!,
      );

      /// Start Incoming Timer
      if (Provider.of<DashboardProvider>(context, listen: false)
          .incomingIsCallConnected) {
        dashboardProvider!.startIncomingTimer();
      }

      ///Show Call In Progress Notification
      if (Provider.of<DashboardProvider>(context, listen: false)
          .incomingIsCallConnected) {
        Utils.showCallInProgressNotificationIncoming(notificationMessage);
      }
      if (Platform.isIOS) {
        showIncomingBottomSheet();
      }

      Future.wait(
        [
          userProvider!.doGetPlanRestriction(),
          loginWorkspaceProvider!.doGetNumberSettings(
            subscriptionUpdateConversationDetailRequestHolder,
          ),
        ],
      ).then(
        (v) {
          final Resources<PlanRestriction> resources =
              v[0] as Resources<PlanRestriction>;
          final Resources<NumberSettings> numberSettings =
              v[1] as Resources<NumberSettings>;
          if (resources.data != null &&
              resources.data!.callRecordingsAndStorage != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
            dashboardProvider!.autoRecord =
                numberSettings.data!.autoRecordCalls!;
            dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
            setState(() {});

            ///Start Incoming Record Timer
            if (Provider.of<DashboardProvider>(context, listen: false)
                    .incomingIsCallConnected &&
                Provider.of<DashboardProvider>(context, listen: false)
                    .autoRecord) {
              dashboardProvider!.startIncomingRecordTimer();
            }
          }
        },
        onError: (err) async {
          dashboardProvider!.autoRecord = false;
          dashboardProvider!.isRecord = false;
          setState(() {});
        },
      );
    });

    voiceClient.incomingConnectFailure?.listen((event) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Connection Failure");
      Wakelock.disable();

      ///Stop Incoming Timer
      dashboardProvider!.stopIncomingTimer();

      ///Stop Incoming Record Timer
      dashboardProvider!.stopIncomingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      ///Reset Call Info
      dashboardProvider!.setDefault();

      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        Utils.cancelCallInProgressNotification();
        Utils.cancelIncomingNotification();
        Utils.getSharedPreference().then((psSharedPref) async {
          await psSharedPref.reload();
          dashboardProvider!.incomingIsCallConnected = false;
          psSharedPref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
        });
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingConnectFailure",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      Utils.logRollBar(RollbarConstant.ERROR,
          "Foreground Incoming Connect Failure: \n${Data().toMap(notificationMessage.data)} \n${event.error}");
    });

    voiceClient.incomingReconnecting?.listen((event) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnecting",
        "state": Utils.getString("reconnecting")
      });
    });

    voiceClient.incomingReconnected?.listen((event) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnected",
        "state": Utils.getString("connected")
      });
    });

    voiceClient.incomingCallQualityWarningsChanged?.listen((event) {
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingCallQualityWarningsChanged",
        "state": Utils.getString("warningInternetConnection")
      });
    });
  }

  void handleBackgroundIncomingEvents() {
    receiverPortIncomingCallRinging.listen((message) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingRinging",
        "state": Utils.getString("ringing"),
      });
    });

    receiverPortIncomingOnCallDisconnected.listen((callBackData) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Disconnected");
      Wakelock.disable();

      ///Stop Incoming Timer
      dashboardProvider!.stopIncomingTimer();

      ///Stop Incoming Record Timer
      dashboardProvider!.stopIncomingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        Utils.cancelCallInProgressNotification();
        Utils.cancelIncomingNotification();
        Utils.getSharedPreference().then((psSharedPref) async {
          await psSharedPref.reload();
          dashboardProvider!.incomingIsCallConnected = false;
          psSharedPref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
          setState(() {});
        });
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingDisconnected",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
      if (!dashboardProvider!.afterTransfer) {
        showIncomingRatingDialog();
      }
    });

    receiverPortIncomingOnCallConnected.listen((callBackData) async {
      Wakelock.enable();
      dashboardProvider!.incomingIsCallConnected = true;
      final SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder =
          SubscriptionUpdateConversationDetailRequestHolder(
        channelId: notificationMessage.data!.channelInfo!.id!,
      );

      /// Start Incoming Timer
      if (Provider.of<DashboardProvider>(context, listen: false)
          .incomingIsCallConnected) {
        dashboardProvider!.startIncomingTimer();
      }

      ///Show Call In Progress Notification
      if (Provider.of<DashboardProvider>(context, listen: false)
          .incomingIsCallConnected) {
        Utils.showCallInProgressNotificationIncoming(notificationMessage);
      }
      if (Platform.isIOS) {
        showIncomingBottomSheet();
      }

      Future.wait(
        [
          userProvider!.doGetPlanRestriction(),
          loginWorkspaceProvider!.doGetNumberSettings(
            subscriptionUpdateConversationDetailRequestHolder,
          ),
        ],
      ).then(
        (v) {
          final Resources<PlanRestriction> resources =
              v[0] as Resources<PlanRestriction>;
          final Resources<NumberSettings> numberSettings =
              v[1] as Resources<NumberSettings>;
          if (resources.data != null &&
              resources.data!.callRecordingsAndStorage != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess != null &&
              resources.data!.callRecordingsAndStorage!.hasAccess as bool) {
            dashboardProvider!.autoRecord =
                numberSettings.data!.autoRecordCalls!;
            dashboardProvider!.isRecord = numberSettings.data!.autoRecordCalls!;
            setState(() {});

            ///Start Incoming Record Timer
            if (Provider.of<DashboardProvider>(context, listen: false)
                    .incomingIsCallConnected &&
                Provider.of<DashboardProvider>(context, listen: false)
                    .autoRecord) {
              dashboardProvider!.startIncomingRecordTimer();
            }
          }
        },
        onError: (err) async {
          dashboardProvider!.autoRecord = false;
          dashboardProvider!.isRecord = false;
          setState(() {});
        },
      );
    });

    receiverPortIncomingCallConnectionFailure.listen((message) {
      defaultChannelId = contactRepository!.getDefaultChannel().id!;
      defaultChannelName = contactRepository!.getDefaultChannel().name!;
      defaultChannelNumber = contactRepository!.getDefaultChannel().number!;
      setState(() {});

      Utils.showToastMessage("Connection Failure");
      Wakelock.disable();

      ///Stop Incoming Timer
      dashboardProvider!.stopIncomingTimer();

      ///Stop Incoming Record Timer
      dashboardProvider!.stopIncomingRecordTimer();

      ///Reset Speaker
      inCallManager.setSpeakerphoneOn(false);

      ///Reset Call Info
      dashboardProvider!.setDefault();

      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        Utils.cancelCallInProgressNotification();
        Utils.cancelIncomingNotification();
        Utils.getSharedPreference().then((psSharedPref) async {
          await psSharedPref.reload();
          dashboardProvider!.incomingIsCallConnected = false;
          psSharedPref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
          setState(() {});
        });
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingConnectFailure",
        "state": Utils.getString("disconnected")
      });
      if (loginWorkspaceRepository!.getLoginUserId() != null &&
          loginWorkspaceRepository!.getLoginUserId()!.isNotEmpty) {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      }
      if (userDetailProvider!.changeWorkspace) {
        if (userProvider!.getDefaultWorkspace() !=
            userDetailProvider!.defaultWorkspaceId) {
          userProvider!
              .replaceDefaultWorkspace(userDetailProvider!.defaultWorkspaceId);
          if (!dashboardProvider!.outgoingIsCallConnected &&
              !dashboardProvider!.incomingIsCallConnected) {
            userProvider!.replaceDefaultWorkspace(
                userDetailProvider!.defaultWorkspaceId);
            userDetailProvider!.changeWorkspace = false;
            _switchWorkSpace(loginWorkspaceProvider!
                .loginWorkspaceList!.data!.data!
                .where((element) =>
                    element.id == userDetailProvider!.defaultWorkspaceId)
                .first);
          }
        }
      }
    });

    receiverPortIncomingCallReconnecting.listen((message) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnecting",
        "state": Utils.getString("reconnecting")
      });
    });

    receiverPortIncomingCallReconnected.listen((message) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnected",
        "state": Utils.getString("connected")
      });
    });

    receiverPortIncomingCallQualityWarningsChanged.listen((message) {
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingCallQualityWarningsChanged",
        "state": Utils.getString("warningInternetConnection")
      });
    });
  }

  Future<void> showIncomingBottomSheet() async {
    Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space0.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future<bool>.value(false);
          },
          child: IncomingCallDialog(
            dashboardProvider: dashboardProvider!,
            notificationMessage: notificationMessage,
            onReject: (String conversationId) {
              Utils.getSharedPreference().then((psSharePref) async {
                await psSharePref.reload();
                dashboardProvider!.incomingIsCallConnected = false;
                psSharePref.setBool(
                    Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
                setState(() {});
              });
              rejectCallSequence();
              if (mounted) {
                userProvider!.rejectCall(conversationId);
              }
            },
            onAccept: () {
              Utils.getSharedPreference().then((psSharePref) async {
                await psSharePref.reload();
                psSharePref.setBool(
                    Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, true);
                setState(() {});
              });
              acceptCallSequence();
            },
            onDisconnect: () {
              voiceClient.disConnect();
              Utils.getSharedPreference().then((psSharePref) async {
                await psSharePref.reload();
                dashboardProvider!.incomingIsCallConnected = false;
                psSharePref.setBool(
                    Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
                setState(() {});
              });
              Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
            },
            onMute: () {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsMuted) {
                dashboardProvider!.incomingIsMuted = false;
                voiceClient.mute();
              } else {
                dashboardProvider!.incomingIsMuted = true;
                voiceClient.mute();
              }
            },
            onHold: () async {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsCallConnected) {
                if (Provider.of<DashboardProvider>(context, listen: false)
                    .incomingIsOnHold) {
                  dashboardProvider!.incomingIsOnHold = false;

                  callHoldProvider!
                      .callHold(
                    action: "UNHOLD",
                    direction: "INBOUND",
                    conversationSid:
                        Provider.of<DashboardProvider>(context, listen: false)
                            .conversationSid,
                    channelId:
                        Provider.of<DashboardProvider>(context, listen: false)
                            .channelId,
                  )
                      .then((data) {
                    if (data.status != Status.SUCCESS) {
                      dashboardProvider!.incomingIsOnHold = true;
                    }
                  });
                } else {
                  dashboardProvider!.incomingIsOnHold = true;
                  callHoldProvider!
                      .callHold(
                    action: "HOLD",
                    direction: "INBOUND",
                    conversationSid:
                        Provider.of<DashboardProvider>(context, listen: false)
                            .conversationSid,
                    channelId:
                        Provider.of<DashboardProvider>(context, listen: false)
                            .channelId,
                  )
                      .then((data) {
                    if (data.status != Status.SUCCESS) {
                      dashboardProvider!.incomingIsOnHold = false;
                    }
                  });
                }
              } else {
                Utils.showToastMessage(Utils.getString("cannotHold"));
              }
            },
            sendDigits: (value) {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsCallConnected) {
                dashboardProvider!.incomingDigits =
                    dashboardProvider!.incomingDigits + value;
                voiceClient.sendDigit(value);
              } else {
                Utils.showToastMessage(Utils.getString("cannotSendDigit"));
              }
            },
            onSetSpeakerphoneOn: () {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .incomingIsSpeakerOn) {
                inCallManager.setSpeakerphoneOn(false);
                dashboardProvider!.incomingIsSpeakerOn = false;
              } else {
                inCallManager.setSpeakerphoneOn(true);
                dashboardProvider!.incomingIsSpeakerOn = true;
              }
            },
            onRecord: (value) {
              setState(() {
                dashboardProvider!.isRecord = value;
              });
              if (value) {
                dashboardProvider!.resumeIncomingRecordTimer();
              } else {
                dashboardProvider!.pauseIncomingRecordTimer();
              }
            },
            onContactTap: () {
              setState(() {
                defaultChannelId = notificationMessage.data!.channelInfo!.id!;
                defaultChannelName =
                    notificationMessage.data!.channelInfo!.name!;
                defaultChannelNumber =
                    notificationMessage.data!.channelInfo!.number!;
                currentIndex = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
              });
            },
            onIncomingTap: () {
              showIncomingBottomSheet();
            },
            onOutgoingTap: () {
              showOutgoingBottomSheet();
            },
          ),
        );
      },
    );
  }

  Future<void> showOutgoingBottomSheet() async {
    Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space0.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return OutgoingCallDialog(
          // outgoingNumber: outgoingNumber,
          // outgoingName: outgoingName,
          // clientId: outgoingId,
          // outgoingProfilePicture: outgoingProfilePicture,
          dashboardProvider: dashboardProvider!,
          onDisconnect: () async {
            PsSharedPreferences.instance!.shared!
                .setBool(Const.enableCancel, false);
            Utils.getSharedPreference().then((psSharePref) async {
              await psSharePref.reload();
              dashboardProvider!.outgoingIsCallConnected = false;
              psSharePref.setBool(
                  Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, false);
              setState(() {});
            });
            voiceClient.disConnect();

            // Utils.cPrint(
            //     "this is conversation id when disconnected ${dashboardProvider.conversationId}");
            // Utils.cPrint(
            //     "this is conversation id when disconnected ${callLogStatus.conversationStatus.toLowerCase()}");
            // if (callLogStatus != null) {
            //   if (callLogStatus.conversationStatus.toLowerCase() == "ringing" ||
            //       callLogStatus.conversationStatus.toLowerCase() == "pending" ||
            //       callLogStatus.conversationStatus.toLowerCase() ==
            //           "inprogress") {
            //     // userProvider.callCancelApi(dashboardProvider.conversationId);
            //   }
            // }
          },

          onMute: () {
            if (Provider.of<DashboardProvider>(context, listen: false)
                .outgoingIsMuted) {
              dashboardProvider!.outgoingIsMuted = false;
              voiceClient.mute();
            } else {
              dashboardProvider!.outgoingIsMuted = true;
              voiceClient.mute();
            }
          },
          onHold: (String conversationId) {
            if (Provider.of<DashboardProvider>(context, listen: false)
                .outgoingIsCallConnected) {
              if (Provider.of<DashboardProvider>(context, listen: false)
                  .outgoingIsOnHold) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .outgoingIsOnHold = false;
                callHoldProvider!
                    .callHold(
                  action: "UNHOLD",
                  direction: "OUTBOUND",
                  conversationId: conversationId,
                  channelId:
                      Provider.of<DashboardProvider>(context, listen: false)
                          .channelId,
                )
                    .then((data) {
                  if (data.status != Status.SUCCESS) {
                    dashboardProvider!.outgoingIsOnHold = true;
                  }
                });
              } else {
                dashboardProvider!.outgoingIsOnHold = true;
                callHoldProvider!
                    .callHold(
                  action: "HOLD",
                  direction: "OUTBOUND",
                  conversationId: conversationId,
                  channelId:
                      Provider.of<DashboardProvider>(context, listen: false)
                          .channelId,
                )
                    .then((data) {
                  if (data.status != Status.SUCCESS) {
                    dashboardProvider!.outgoingIsOnHold = false;
                  }
                });
              }
            } else {
              Utils.showToastMessage(Utils.getString("cannotHold"));
            }
          },
          sendDigits: (value) {
            if (Provider.of<DashboardProvider>(context, listen: false)
                .outgoingIsCallConnected) {
              dashboardProvider!.outgoingDigits =
                  dashboardProvider!.outgoingDigits + value;
              voiceClient.sendDigit(value);
            } else {
              Utils.showToastMessage(Utils.getString("cannotSendDigit"));
            }
          },
          onSetSpeakerphoneOn: () {
            if (Provider.of<DashboardProvider>(context, listen: false)
                .outgoingSpeaker) {
              inCallManager.setSpeakerphoneOn(false);
              dashboardProvider!.outgoingSpeaker = false;
            } else {
              inCallManager.setSpeakerphoneOn(true);
              dashboardProvider!.outgoingSpeaker = true;
            }
          },
          onRecord: (value) {
            setState(() {
              dashboardProvider!.isRecord = value;
            });
            if (value) {
              dashboardProvider!.resumeOutgoingRecordTimer();
            } else {
              dashboardProvider!.pauseOutgoingRecordTimer();
            }
          },
          onContactTap: () {
            setState(() {
              defaultChannelId = dashboardProvider!.channelId;
              defaultChannelName = dashboardProvider!.channelName;
              defaultChannelNumber = dashboardProvider!.channelNumber;
              currentIndex = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
            });
          },
          onIncomingTap: () {
            showIncomingBottomSheet();
          },
          onOutgoingTap: () {
            showOutgoingBottomSheet();
          },
        );
      },
    );
  }

  Future<void> showOutgoingRatingDialog() async {
    if (dashboardProvider!.secondsPassedOutgoing > 45) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CallRatingDialog(
            onRatingTap: (rating) {
              Navigator.of(context).pop();
              showFeedbackDialog(rating);
            },
          );
        },
      );
    } else {
      dashboardProvider!.resetOutgoingSecondPassed();
      dashboardProvider!.setDefault();
    }
  }

  Future<void> showIncomingRatingDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CallRatingDialog(
          onRatingTap: (rating) {
            Navigator.of(context).pop();
            showFeedbackDialog(rating);
          },
        );
      },
    );
  }

  Future<void> showFeedbackDialog(int rating) async {
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const FeedbackDialog();
        },
      );
    });

    await callRatingProvider!.callRating(
      rating: rating,
      conversationId: dashboardProvider!.conversationId,
    );
    dashboardProvider!.resetIncomingSecondPassed();
    dashboardProvider!.resetOutgoingSecondPassed();
    dashboardProvider!.setDefault();
  }

  bool isRedundantClick(DateTime currentTime) {
    if (callAcceptDateTime != null &&
        currentTime.difference(callAcceptDateTime!).inSeconds < 5) {
      return true;
    } else {
      setState(() {
        callAcceptDateTime = currentTime;
      });
      return false;
    }
  }

  bool isRedundantNotification(DateTime currentTime) {
    if (incomingNotificationTime != null &&
        currentTime.difference(incomingNotificationTime!).inSeconds < 5) {
      return true;
    } else {
      setState(() {
        incomingNotificationTime = currentTime;
      });
      return false;
    }
  }

  void callCancelledSequence() {
    Utils.cancelIncomingNotification();
    Utils.cancelCallInProgressNotification();
    Utils.showToastMessage("Disconnected");
    Utils.getSharedPreference().then((psSharePref) async {
      await psSharePref.reload();
      dashboardProvider!.incomingIsCallConnected = false;
      psSharePref.setBool(
          Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
    });
    if (mounted) {
      Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    }
  }

  Future<void> rejectCallSequence() async {
    Utils.cPrint("Step 1");
    voiceClient.rejectCall();
    Utils.cPrint("Step 2");
    Utils.cancelIncomingNotification();
    Utils.cPrint("Step 3");
    Utils.cancelCallInProgressNotification();
    Utils.cPrint("Step 4");
    Utils.cPrint("Step 5");
    Utils.showToastMessage(Utils.getString("disConnected"));
    Utils.cPrint("Step 6");
    Utils.getSharedPreference().then((psSharePref) async {
      Utils.cPrint("Step 7");
      psSharePref.reload();
      dashboardProvider!.incomingIsCallConnected = false;
      psSharePref.setBool(
          Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
      Utils.cPrint("Step 8");
    });
    Utils.cPrint("Step 9");
    if (mounted) {
      Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    }
  }

  Future<void> acceptCallSequence() async {
    final bool val = await requestRecordPermission();
    if (val) {
      if (!isRedundantClick(DateTime.now())) {
        voiceClient.acceptCall();
        Utils.cancelIncomingNotification();
        Utils.showToastMessage("Connected");
        Utils.getSharedPreference().then((psSharePref) async {
          await psSharePref.reload();
          dashboardProvider!.incomingIsCallConnected = true;
          psSharePref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, true);
          setState(() {});
        });
      }
    } else {
      Utils.showToastMessage(
          "You need to allow record permission to make calls");
      openAppSettings();
    }
  }

  Future<void> doSubscriptionAllChannels() async {
    try {
      if (callLogProvider!.getChannelList()!.isNotEmpty) {
        final List<WorkspaceChannel>? channelList =
            callLogProvider!.getChannelList();

        for (int i = 0; i < channelList!.length; i++) {
          callLogProvider!
              .doSubscriptionCallLogsApiCall("all", channelList[i].id!)
              .then((value) {
            value!.listen((event) async {
              if (event.data != null) {
                if (event.data!["updateConversation"]["message"]
                            ["conversationType"]
                        .toString()
                        .toUpperCase() ==
                    CallStateIndex.Call.value.toUpperCase()) {
                  if (event.data!["updateConversation"]["message"]["id"] !=
                          null &&
                      event.data!["id"] != "" &&
                      event.data!["updateConversation"]["message"]["direction"]
                              .toString()
                              .toUpperCase() ==
                          CallStateIndex.Outgoing.value.toUpperCase()) {
                    if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.RINGING.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.INPROGRESS.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.TRANSFERRING.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.TRANSFERRED.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    }
                  } else {
                    if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.RINGING.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.INPROGRESS.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                      dashboardProvider!.isTransfer = false;
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.TRANSFERRING.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.TRANSFERRED.value.toUpperCase()) {
                      dashboardProvider!.conversationId = event
                          .data!["updateConversation"]["message"]["id"]
                          .toString();
                    } else if (event.data!["updateConversation"]["message"]
                                ["conversationStatus"]
                            .toString()
                            .toUpperCase() ==
                        CallStateIndex.COMPLETED.value.toUpperCase()) {
                      DashboardView.incomingEvent
                          .fire({"incomingEvent": "", "state": ""});
                      if (!Provider.of<DashboardProvider>(context,
                              listen: false)
                          .afterTransfer) {
                        dashboardProvider!.setDefault();
                      }
                    }
                  }
                }
              }
            });
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool isClickAble() {
    if (loginWorkspaceProvider!.getWorkspaceDetail().plan != null &&
        loginWorkspaceProvider!.getWorkspaceDetail().plan!.subscriptionActive !=
            null &&
        loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "active") {
      return true;
    } else {
      return false;
    }
  }

  void registerBackgroundPort() {
    final ReceivePort receiverPortOnCallInvite = ReceivePort();
    IsolateManagerCallInvite.registerPortWithName(
        receiverPortOnCallInvite.sendPort);
    receiverPortOnCallInvite.listen((callBackData) async {
      if (callBackData != null) {
        Utils.cPrint(callBackData.toString());

        dashboardProvider!.channelId = callBackData["twi_call_sid"] as String;
        dashboardProvider!.afterTransfer =
            callBackData["after_transfer"].toString().toUpperCase() == "TRUE"
                ? true
                : false;
        final Data data = Data(
          id: 1,
          twiFrom: callBackData["twi_from"] as String,
          twiTo: callBackData["twi_to"] as String,
          twiCallSid: callBackData["twi_call_sid"] as String,
          customParameters: CustomParameters(
            // afterHold: callBackData["after_hold"] as String,
            afterTransfer:
                callBackData["after_transfer"].toString().toUpperCase() ==
                        "TRUE"
                    ? true
                    : false,
            from: callBackData["from"] as String,
            channelSid: callBackData["channel_sid"] as String,
            contactName: callBackData["contact_name"] as String,
            contactNumber: callBackData["number"] as String,
            conversationSid: callBackData["conversation_sid"] as String,
          ),
          channelInfo: ChannelInfo(
            id: callBackData["id"] as String,
            number: callBackData["number"] as String,
            countryLogo: callBackData["country_logo"] as String,
            countryCode: callBackData["country_code"] as String,
            name: callBackData["name"] as String,
            country: callBackData["country"] as String,
            numberSid: callBackData["number_sid"] as String,
          ),
        );
        notificationMessage.data = data;
        // showIncomingBottomSheet();
      }
    });

    final ReceivePort receiverPortOnCallCancelled = ReceivePort();
    IsolateManagerCallCancelled.registerPortWithName(
        receiverPortOnCallCancelled.sendPort);
    receiverPortOnCallCancelled.listen((callBackData) {
      Utils.cPrint(
          "-------------------------------------------------------------------------------------------------------------");
      callCancelledSequence();
    });

    Workmanager().initialize(
      callbackDispatcher,
    );
  }
}

DateTime? incomingNotificationTime;

///Incoming
@pragma("vm:entry-point")
Future<dynamic> onBackgroundMessage(RemoteMessage message) async {
  print("RemoteMessage Background ${message.data.toString()}");
  await Firebase.initializeApp();
  // if (await intercom.isIntercomPush(message.data)) {
  //   // Map<String, dynamic> data = Map();
  //   // data = message.data;
  //   // if (Platform.isAndroid) {
  //   //   Utils.playSmsTone();
  //   // }
  //   // await Intercom.handlePush(data);
  //   // return;
  // } else {

  await backgroundRollbarInit();

  Workmanager().initialize(
    callbackDispatcher,
  );
  FlutterCallkitIncoming.onEvent.listen((event) async {
    switch (event!.name) {
      case CallEvent.ACTION_CALL_DECLINE:
        Utils.cPrint("Step 1");
        Utils.cPrint("Step 2");
        Utils.cancelIncomingNotification();
        Utils.cPrint("Step 3");
        Utils.cancelCallInProgressNotification();
        Utils.cPrint("Step 4");
        Utils.cPrint("Step 5");
        Utils.showToastMessage("Disconnected");
        Utils.cPrint("Step 6");
        Utils.getSharedPreference().then((psSharePref) async {
          psSharePref.setBool(
              Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
          psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, false);
          psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, false);
          voiceClient.rejectCall();
        });
        break;
      case CallEvent.ACTION_CALL_ACCEPT:
        Utils.getSharedPreference().then((psSharePref) async {
          psSharePref.setBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND, true);
          psSharePref.setBool(Const.VALUE_HOLDER_CALL_IS_CONNECTING, true);
        });
        break;
    }

    // if (callback != null) {
    //   callback(event.toString());
    // }
  });

  Utils.getSharedPreference().then((psSharePref) async {
    Utils.cPrint("this is working");
    await psSharePref.reload();
    if (message.data.containsKey("twi_account_sid")) {
      Utils.logRollBar(RollbarConstant.INFO,
          "Background Incoming Call Notification: \n${message.data}");
      if (!isRedundantNotification(DateTime.now())) {
        if (psSharePref.getBool(
                    Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS) !=
                null &&
            psSharePref
                .getBool(Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS)!) {
          final Map<String, dynamic> map = {};
          map["data"] = message.data;
          voiceClient.handleMessage(map).then((result) {
            voiceClient.rejectCall();
          });
          Utils.showToastMessage("Already in a call outgoing");
        } else if (psSharePref.getBool(
                    Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS) !=
                null &&
            psSharePref
                .getBool(Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS)!) {
          final Map<String, dynamic> map = {};
          map["data"] = message.data;
          voiceClient.handleMessage(map).then((result) {
            voiceClient.rejectCall();
          });
          Utils.showToastMessage("Already in a call incoming");
        } else {
          final Map<String, dynamic> map = {};
          map["data"] = message.data;

          voiceClient.handleMessage(map).then((result) {
            final Data data = Data.fromJson(
                json.decode(json.encode(result)) as Map<String, dynamic>);
            data.channelInfo!.numberSid = "abcde";
            data.customParameters!.contactName = "Unknown";
            final NotificationMessage notificationMessage =
                NotificationMessage();
            notificationMessage.data = data;
            final Map<String, dynamic> map = {};
            map["twi_call_sid"] = data.twiCallSid;
            map["twi_to"] = data.twiTo;
            map["twi_from"] = data.twiFrom;
            map["conversation_sid"] = data.customParameters!.conversationSid;
            // map["after_hold"] = data.customParameters!.afterHold;
            map["after_transfer"] = data.customParameters!.afterTransfer;
            map["from"] = data.customParameters!.from;
            map["contact_number"] = data.customParameters!.contactNumber ?? "";
            map["contact_name"] = data.customParameters!.contactName;
            map["channel_sid"] = data.customParameters!.channelSid;
            map["number"] = data.channelInfo!.number;
            map["country"] = data.channelInfo!.country;
            map["country_code"] = data.channelInfo!.countryCode;
            map["name"] = data.channelInfo!.name;
            map["id"] = data.channelInfo!.id;
            map["number_sid"] = data.channelInfo!.numberSid;
            map["country_logo"] = data.channelInfo!.countryLogo;
            // if (Platform.isAndroid) {
            //   Utils.playRingTone();
            // }
            // Utils.showNotificationWithActionButtons(notificationMessage);
            Future.delayed(const Duration(seconds: 40)).then((value) {
              // Utils.cancelIncomingNotification();
            });
            Workmanager().registerOneOffTask(
              "1",
              "onCallInvite",
              inputData: map,
            );
            final String encodedData =
                json.encode(Data().toMap(notificationMessage.data));
            psSharePref.setString(Const.VALUE_HOLDER_CALL_DATA, encodedData);
            final String contactList =
                psSharePref.getString(Const.VALUE_HOLDER_CONTACT_LIST)!;
            final List decodeContactList = jsonDecode(contactList) as List;
            final List filterContact = decodeContactList.where((z) {
              if (z["number"].trim() ==
                  "+${data.customParameters!.from!.trim()}") {
                return true;
              } else {
                return false;
              }
            }).toList();
            showIncomingCall(
              data,
              filterContact.isEmpty
                  ? "+${data.customParameters!.from}"
                  : filterContact[0]["name"].toString().trim(),
              filterContact.isEmpty
                  ? "+${data.customParameters!.from}"
                  : filterContact[0]["imageUrl"].toString().trim(),
              psSharePref.getString(Const.VALUE_HOLDER_SELECTED_SOUND) !=
                          null &&
                      psSharePref
                          .getString(Const.VALUE_HOLDER_SELECTED_SOUND)!
                          .isNotEmpty
                  ? psSharePref.getString(Const.VALUE_HOLDER_SELECTED_SOUND)!
                  : "",
            );
          });

          voiceClient.onCancelledCallInvite?.listen((event) {
            final Map<String, dynamic> map = {};
            map["twi_call_sid"] = event.callSid;
            map["twi_to"] = event.to;
            map["twi_from"] = event.from;
            // Utils.cancelIncomingNotification();
            FlutterCallkitIncoming.endAllCalls();
            Workmanager().registerOneOffTask(
              "2",
              "onCancelledCallInvite",
              initialDelay: const Duration(milliseconds: 10),
              inputData: map,
              backoffPolicy: BackoffPolicy.exponential,
              backoffPolicyDelay: const Duration(milliseconds: 10),
              existingWorkPolicy: ExistingWorkPolicy.replace,
            );
          });
        }
      }
    } else if (message.data.containsKey("topic")) {
      if (message.data["topic"] == "message") {
        Utils.showSmsNotification(
          title: message.data["title"] as String,
          body: message.data["body"] as String,
          clientNumber: message.data["client_number"] as String,
          channelId: message.data["channel_id"] as String,
          channelNumber: message.data["channel_number"] as String,
          channelName: message.data["channel_name"] as String,
        );
      } else if (message.data["topic"] == "missed_call") {
        Utils.showMissedCallNotification(
          title: message.data["title"] as String,
          body: message.data["body"] as String,
          clientNumber: message.data["client_number"] as String,
          channelId: message.data["channel_id"] as String,
          channelNumber: message.data["channel_number"] as String,
          channelName: message.data["channel_name"] as String,
        );
      } else if (message.data["topic"] == "voicemail") {
        Utils.showVoiceMailNotification(
          title: message.data["title"] as String,
          body: message.data["body"] as String,
          clientNumber: message.data["client_number"] as String,
          channelId: message.data["channel_id"] as String,
          channelNumber: message.data["channel_number"] as String,
          channelName: message.data["channel_name"] as String,
        );
      } else if (message.data["topic"] == "chat_message") {
        Utils.showChatMessageNotification(
          title: message.data["title"] as String,
          body: message.data["body"] as String,
          sender: message.data["sender"] as String,
          email: message.data["email"] as String,
          senderId: message.data["sender_id"] as String,
          onlineStatus: message.data["online_status"] as String,
          messageIcon: message.data["message_icon"] as String,
          workspaceId: message.data["workspace"] as String,
          channelNo: message.data["channel_no"] as String,
        );
      }
    } else if (message.data["topic"] == "call") {
      /// for call do nothing
    } else {
      Utils.showNormalNotification(
        title: message.data["title"] as String,
        body: message.data["body"] as String,
      );
    }

    voiceClient.incomingConnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      psSharePref.setBool(
          Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, true);
      Workmanager()
          .registerOneOffTask("3", "incomingConnected", inputData: map);
    });

    voiceClient.incomingDisconnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        psSharePref.setBool(
            Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
      });
      Workmanager()
          .registerOneOffTask("4", "incomingDisconnected", inputData: map);

      if (event.error != null) {
        Utils.logRollBar(RollbarConstant.ERROR,
            "Background Incoming Connect Failure: \n${message.data} \n${event.error}");
      }
    });

    voiceClient.incomingConnectFailure?.listen((event) async {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        psSharePref.setBool(
            Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
      });
      Workmanager().registerOneOffTask(
        "5",
        "incomingConnectFailure",
        inputData: map,
      );

      Utils.logRollBar(RollbarConstant.ERROR,
          "Background Incoming Connect Failure: \n${message.data} \n${event.error}");
    });

    voiceClient.incomingCallQualityWarningsChanged?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask(
        "6",
        "incomingCallQualityWarningsChanged",
        inputData: map,
      );
    });

    voiceClient.incomingRinging?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask(
        "7",
        "incomingRinging",
        inputData: map,
      );
    });

    voiceClient.incomingReconnecting?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask(
        "8",
        "incomingReconnecting",
        inputData: map,
      );
    });

    voiceClient.incomingReconnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager()
          .registerOneOffTask("9", "incomingReconnected", inputData: map);
    });

    voiceClient.outGoingCallConnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      psSharePref.setBool(
          Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, true);
      Workmanager()
          .registerOneOffTask("10", "outGoingCallConnected", inputData: map);
    });

    voiceClient.outGoingCallDisconnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        psSharePref.setBool(
            Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, false);
      });
      Workmanager().registerOneOffTask(
        "11",
        "outGoingCallDisconnected",
        inputData: map,
      );
      if (event.error != null) {
        Utils.logRollBar(RollbarConstant.ERROR,
            "Background OutGoing Call Connect Failure: \n${message.data} \n${event.error}");
      }
    });

    voiceClient.outGoingCallConnectFailure?.listen((event) async {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        psSharePref.setBool(
            Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, false);
      });
      Workmanager().registerOneOffTask("12", "outGoingCallConnectFailure",
          inputData: map);

      Utils.logRollBar(RollbarConstant.ERROR,
          "Background OutGoing Call Connect Failure: \n${message.data} \n${event.error}");
    });

    voiceClient.outGoingCallCallQualityWarningsChanged?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Workmanager().registerOneOffTask(
        "13",
        "outGoingCallCallQualityWarningsChanged",
        inputData: map,
      );
    });

    voiceClient.outGoingCallRinging?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Workmanager()
          .registerOneOffTask("14", "outGoingCallRinging", inputData: map);
    });

    voiceClient.outGoingCallReconnecting?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Workmanager()
          .registerOneOffTask("15", "outGoingCallReconnecting", inputData: map);
    });

    voiceClient.outGoingCallReconnected?.listen((event) {
      final Map<String, dynamic> map = {};
      map["twi_call_sid"] = event.callSid != null && event.callSid!.isNotEmpty
          ? event.callSid
          : "";
      map["twi_to"] = event.to != null
          ? event.to!.isNotEmpty
              ? event.to
              : ""
          : "";
      map["twi_from"] = event.from != null
          ? event.from!.isNotEmpty
              ? event.from
              : ""
          : "";
      Workmanager()
          .registerOneOffTask("16", "outGoingCallReconnected", inputData: map);
    });
  });
  // }
}

bool isRedundantNotification(DateTime currentTime) {
  if (incomingNotificationTime != null &&
      currentTime.difference(incomingNotificationTime!).inSeconds < 5) {
    return true;
  } else {
    incomingNotificationTime = currentTime;
    return false;
  }
}

Future<void> showIncomingCall(
    Data data, String name, String imageUrl, String selectedSound) async {
  final params = <String, dynamic>{
    "id": data.id.toString(),
    "nameCaller": name,
    "channelName": data.channelInfo!.name,
    "channelNumber": "+${data.channelInfo!.number}",
    "appName": "KrispCall",
    "avatar": imageUrl,
    "handle": "",
    "type": 0,
    "duration": 40000,
    "textAccept": "Accept",
    "textDecline": "Decline",
    "textMissedCall": "Missed call",
    "textCallback": "Call back",
    "extra": Data().toMap(data),
    "headers": <String, dynamic>{"apiKey": "Abc@123!", "platform": "flutter"},
    "android": <String, dynamic>{
      "incomingCallNotificationChannelName":
          Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
      "missedCallNotificationChannelName":
          Const.NOTIFICATION_CHANNEL_MISSED_CALL,
      "isCustomNotification": true,
      "isShowLogo": true,
      "isShowCallback": true,
      "isShowMissedCallNotification": false,
      "ringtonePath":
          selectedSound.isNotEmpty ? selectedSound : "system_ringtone_default",
      "backgroundColor": "#390179",
      "background": "",
      "actionColor": ""
    }
  };
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}
