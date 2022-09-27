import "dart:async";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_incall_manager/flutter_incall_manager.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:graphql/client.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/call_record/CallRecordProvider.dart";
import "package:mvp/provider/call_transfer/CallTransferProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/CallRecordRepository.dart";
import "package:mvp/repository/CallTransferRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/CallOnProgressMoreOptionDialog.dart";
import "package:mvp/ui/common/dialog/TransferCallDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddNotesIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";

const String tag = "OutgoingCallView";

class OutgoingCallDialog extends StatefulWidget {
  const OutgoingCallDialog({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.onMute,
    required this.onHold,
    required this.sendDigits,
    required this.onSetSpeakerphoneOn,
    required this.onRecord,
    required this.onContactTap,
    required this.onDisconnect,
    required this.dashboardProvider,

    // this.outgoingProfilePicture,
    // this.clientId,
  }) : super(key: key);

  // final String clientId;
  // final String outgoingProfilePicture;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function onMute;
  final Function onHold;
  final Function(String) sendDigits;
  final Function onSetSpeakerphoneOn;
  final Function(bool) onRecord;
  final Function onContactTap;
  final Function onDisconnect;
  final DashboardProvider dashboardProvider;

  @override
  OutgoingCallDialogState createState() => OutgoingCallDialogState();
}

class OutgoingCallDialogState extends State<OutgoingCallDialog>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  IncallManager inCallManager = IncallManager();

  ValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isMicMuted = false;
  bool isSpeakerOn = false;
  bool isRinging = true;
  bool allowRecording = true;

  // bool isRecord = false;
  bool isOnHold = false;
  bool isTransfer = false;

  // bool afterTransfer = false;
  bool isConnected = false;
  bool isKeyboardVisible = false;
  String digits = "";
  String events = Utils.getString("calling");
  int seconds = 0;
  int minutes = 0;
  int secondsRecording = 0;
  int minutesRecording = 0;
  String callSid = "";
  CallRecordProvider? callRecordProvider;
  CallRecordRepository? callRecordRepository;

  ContactsProvider? contactsProvider;
  ContactRepository? contactsRepository;

  CallTransferProvider? callTransferProvider;
  CallTransferRepository? callTransferRepository;

  UserRepository? userRepository;
  UserProvider? userProvider;

  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  String? contactId;
  String? contactNumber;
  bool enableCancel = false;
  bool autoRecord = false;

  StreamSubscription? streamSubscriptionOutgoingEvent;
  StreamSubscription? streamSubscriptionOutgoingRecordingEvent;
  Stream<QueryResult>? streamSubscriptionCallLogs;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    contactId =
        Provider.of<DashboardProvider>(context, listen: false).outgoingId;
    contactNumber =
        Provider.of<DashboardProvider>(context, listen: false).outgoingNumber;

    callTransferRepository =
        Provider.of<CallTransferRepository>(context, listen: false);
    callRecordRepository =
        Provider.of<CallRecordRepository>(context, listen: false);
    contactsRepository = Provider.of<ContactRepository>(context, listen: false);
    userRepository = Provider.of<UserRepository>(context, listen: false);

    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    callLogProvider = CallLogProvider(callLogRepository: callLogRepository);

    autoRecord = widget.dashboardProvider.autoRecord;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DashboardView.subscriptionCallStatusController.stream
          .asBroadcastStream()
          .listen((event) {
        try {
          if (mounted) {
            setState(() {
              enableCancel = true;
            });
          }
        } catch (e) {}
      });

      await Future.delayed(const Duration(milliseconds: 5000)).then((value) {
        if (mounted) {
          setState(() {
            enableCancel = true;
          });
        }
      });
    });

    streamSubscriptionOutgoingEvent =
        DashboardView.outgoingEvent.on().listen((event) {
      if (event != null && event["outgoingEvent"] == "outGoingCallRinging") {
        if (mounted) {
          setState(() {
            callSid =
                event["callSid"] == null ? "" : event["callSid"] as String;
            events = event["state"] == null ? "" : event["state"] as String;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallConnected") {
        if (mounted) {
          setState(() {
            seconds = event["seconds"] as int;
            minutes = event["minutes"] as int;
            isConnected = event["isConnected"] as bool;
            events = event["state"] == null ? "" : event["state"] as String;
            isMicMuted = event["isMicMuted"] as bool;
            isTransfer = event["isTransfer"] as bool;
            // afterTransfer = event["afterTransfer"] as bool;
            isOnHold = event["isOnHold"] as bool;
            isRinging = !(event["isConnected"] as bool);
            digits = event["digits"] as String;
            isSpeakerOn = event["isSpeakerOn"] as bool;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnecting") {
        if (mounted) {
          setState(() {
            events = event["state"] == null ? "" : event["state"] as String;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnected") {
        if (mounted) {
          setState(() {
            events = event["state"] == null ? "" : event["state"] as String;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingTransfer") {
        if (mounted) {
          setState(() {
            events = event["state"] == null ? "" : event["state"] as String;
            isTransfer = true;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallCallQualityWarningsChanged") {
        if (mounted) {
          setState(() {
            events = event["state"] == null ? "" : event["state"] as String;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallInProgress") {
        if (mounted) {
          setState(() {
            events = event["state"] == null ? "" : event["state"] as String;
            if (isTransfer) {
              // afterTransfer = true;
              isTransfer = false;
            }
          });
        }
      }
    });

    streamSubscriptionOutgoingRecordingEvent =
        DashboardView.outgoingEventRecording.on().listen((event) {
      if (event != null && event["outgoingEvent"] == "outGoingCallRecording") {
        if (mounted) {
          setState(() {
            secondsRecording = event["seconds"] as int;
            minutesRecording = event["minutes"] as int;
          });
        }
      }
    });

    if (!isConnectedToInternet) {
      checkConnection();
    }

    inCallManager.enableProximitySensor(true);
    inCallManager.onProximity.stream.listen((event) {
      if (event) {
        inCallManager.turnScreenOff();
      } else {
        inCallManager.turnScreenOn();
      }
    });
  }

  Future<void> doSubscriptionCallLogForOutgoing(String channelId) async {
    streamSubscriptionCallLogs =
        await callLogProvider!.doSubscriptionCallLogsApiCall("all", channelId);
    if (streamSubscriptionCallLogs != null) {
      subscription = streamSubscriptionCallLogs!.listen(
        (event) async {
          if (event.data != null) {
            if (event.data!["updateConversation"]["message"]["conversationType"]
                    .toString()
                    .toUpperCase() ==
                CallStateIndex.Call.value.toUpperCase()) {
              if (event.data!["updateConversation"]["message"]["id"] != null &&
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
                  widget.dashboardProvider.conversationId = event
                      .data!["updateConversation"]["message"]["id"]
                      .toString();
                } else if (event.data!["updateConversation"]["message"]
                            ["conversationStatus"]
                        .toString()
                        .toUpperCase() ==
                    CallStateIndex.INPROGRESS.value.toUpperCase()) {
                  widget.dashboardProvider.isTransfer = false;
                  widget.dashboardProvider.conversationId = event
                      .data!["updateConversation"]["message"]["id"]
                      .toString();
                  DashboardView.outgoingEvent.fire({
                    "outgoingEvent": "outGoingCallInProgress",
                    "state": "inprogress"
                  });
                } else if (event.data!["updateConversation"]["message"]
                            ["conversationStatus"]
                        .toString()
                        .toUpperCase() ==
                    CallStateIndex.COMPLETED.value.toUpperCase()) {
                  DashboardView.incomingEvent
                      .fire({"incomingEvent": "", "state": ""});
                  subscription!.cancel();
                }
              }
            }
          }
        },
        onDone: () {},
        onError: (data) {
          subscription!.cancel();
        },
        cancelOnError: true,
      );
    }
  }

  @override
  void dispose() {
    CustomAppBar.changeStatusColor(CustomColors.white!);
    inCallManager.enableProximitySensor(false);
    streamSubscriptionOutgoingEvent!.cancel();
    streamSubscriptionOutgoingRecordingEvent!.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    CustomAppBar.changeStatusColor(CustomColors.white!);
    Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    return Future<bool>.value(true);
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        // doSubscriptionCallLogForOutgoing(
        //     Provider.of<DashboardProvider>(context, listen: false).channelId);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // doSubscriptionCallLogForOutgoing(
      //     Provider.of<DashboardProvider>(context, listen: false).channelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: MultiProvider(
                providers: <SingleChildWidget>[
                  ChangeNotifierProvider<ContactsProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      contactsProvider = ContactsProvider(
                          contactRepository: contactsRepository);
                      if (contactId != null && contactId!.isNotEmpty) {
                        contactsProvider!.doContactDetailApiCall(contactId!);
                      }
                      return contactsProvider!;
                    },
                  ),
                  ChangeNotifierProvider<CallLogProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      callLogProvider =
                          CallLogProvider(callLogRepository: callLogRepository);
                      doSubscriptionCallLogForOutgoing(
                          widget.dashboardProvider.channelId);
                      return callLogProvider!;
                    },
                  ),
                  ChangeNotifierProvider<CallRecordProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      callRecordProvider = CallRecordProvider(
                          callRecordRepository: callRecordRepository!);
                      return callRecordProvider!;
                    },
                  ),
                  ChangeNotifierProvider<CallTransferProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      callTransferProvider = CallTransferProvider(
                          callTransferRepository: callTransferRepository!);
                      return callTransferProvider!;
                    },
                  ),
                  ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      userProvider = UserProvider(
                          userRepository: userRepository,
                          valueHolder: valueHolder);
                      return userProvider!;
                    },
                  ),
                ],
                child: Consumer<ContactsProvider>(
                  builder: (BuildContext context, ContactsProvider? provider,
                      Widget? child) {
                    return Scaffold(
                      backgroundColor: CustomColors.mainColor,
                      body: SafeArea(
                        child: Container(
                          height: MediaQuery.of(context).size.height.sh,
                          width: MediaQuery.of(context).size.width.sw,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          color: CustomColors.mainColor,
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space120.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Offstage(
                                                offstage: isKeyboardVisible,
                                                child:
                                                    RoundedNetworkImageHolder(
                                                  width: Dimens.space100,
                                                  height: Dimens.space100,
                                                  iconUrl:
                                                      CustomIcon.icon_profile,
                                                  iconColor: CustomColors
                                                      .callInactiveColor,
                                                  iconSize: Dimens.space85,
                                                  boxDecorationColor:
                                                      CustomColors
                                                          .mainDividerColor,
                                                  outerCorner: Dimens.space42,
                                                  innerCorner: Dimens.space42,
                                                  containerAlignment:
                                                      Alignment.bottomCenter,
                                                  imageUrl: Provider.of<
                                                              DashboardProvider>(
                                                          context,
                                                          listen: false)
                                                      .outgoingProfilePicture,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space20.h,
                                                  Dimens.space20.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: ContactNameWidget(
                                                contact: Provider.of<
                                                                DashboardProvider>(
                                                            context,
                                                            listen: false)
                                                        .outgoingName
                                                        .isNotEmpty
                                                    ? Provider.of<
                                                                DashboardProvider>(
                                                            context,
                                                            listen: false)
                                                        .outgoingName
                                                    : Provider.of<
                                                                DashboardProvider>(
                                                            context,
                                                            listen: false)
                                                        .outgoingNumber,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: Dimens.space20.w,
                                                  ),
                                                  Flexible(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                              color: CustomColors
                                                                  .bottomAppBarColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily: Config
                                                                  .manropeMedium,
                                                              fontSize: Dimens
                                                                  .space15.sp,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                        text:
                                                            Config.checkOverFlow
                                                                ? Const.OVERFLOW
                                                                : contactNumber,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space6.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    child:
                                                        FutureBuilder<String>(
                                                      future: Utils.getFlagUrl(
                                                          contactNumber ?? ""),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return RoundedNetworkImageHolder(
                                                            width:
                                                                Dimens.space14,
                                                            height:
                                                                Dimens.space14,
                                                            boxFit:
                                                                BoxFit.contain,
                                                            containerAlignment:
                                                                Alignment
                                                                    .bottomCenter,
                                                            iconUrl: CustomIcon
                                                                .icon_gallery,
                                                            iconColor:
                                                                CustomColors
                                                                    .grey,
                                                            iconSize:
                                                                Dimens.space14,
                                                            boxDecorationColor:
                                                                CustomColors
                                                                    .transparent,
                                                            outerCorner:
                                                                Dimens.space0,
                                                            innerCorner:
                                                                Dimens.space0,
                                                            imageUrl: PSApp
                                                                    .config!
                                                                    .countryLogoUrl! +
                                                                snapshot.data!,
                                                          );
                                                        }
                                                        return const CupertinoActivityIndicator();
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dimens.space20.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Offstage(
                                                    offstage: !isRinging,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      alignment:
                                                          Alignment.center,
                                                      width: Dimens.space100.w,
                                                      child: LogoWidget(
                                                          events: events),
                                                    ),
                                                  ),
                                                  Offstage(
                                                    offstage: isRinging,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      alignment:
                                                          Alignment.center,
                                                      child: TimerWidget(
                                                        seconds: seconds,
                                                        minutes: minutes,
                                                        isOnHold: isOnHold,
                                                        isTransfer: isTransfer,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space35.h,
                                            Dimens.space0.w,
                                            Dimens.space64.h),
                                        padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                        ),
                                        child: AfterCallAcceptButtonWidget(
                                          enableCancel: enableCancel,
                                          // afterTransfer: afterTransfer,
                                          // enableCancel: PsSharedPreferences.instance.shared
                                          //     .getBool(Const.VALUE_HOLDER_IS_CALL_CONNECTED),
                                          isSpeakerOn: isSpeakerOn,
                                          isMicMute: isMicMuted,
                                          isRecord:
                                              Provider.of<DashboardProvider>(
                                                      context,
                                                      listen: false)
                                                  .isRecord,
                                          isOnHold: isOnHold,
                                          isKeyboardVisible: isKeyboardVisible,
                                          digit: digits,
                                          autoRecord: autoRecord,
                                          onSetSpeakerphoneOn: () {
                                            if (isSpeakerOn) {
                                              isSpeakerOn = false;
                                            } else {
                                              isSpeakerOn = true;
                                            }
                                            widget.onSetSpeakerphoneOn();
                                            setState(() {});
                                          },
                                          onSetMicrophoneMute: () {
                                            widget.onMute();
                                          },
                                          onRecord: () async {
                                            if (allowRecording) {
                                              if (!autoRecord) {
                                              } else {
                                                allowRecording = false;
                                                final Resources<PlanRestriction>
                                                    resources =
                                                    await userProvider!
                                                            .doGetPlanRestriction()
                                                        as Resources<
                                                            PlanRestriction>;
                                                if (resources.data != null &&
                                                    resources.data!
                                                            .callRecordingsAndStorage !=
                                                        null &&
                                                    resources
                                                            .data!
                                                            .callRecordingsAndStorage!
                                                            .hasAccess !=
                                                        null &&
                                                    resources
                                                        .data!
                                                        .callRecordingsAndStorage!
                                                        .hasAccess as bool) {
                                                  if (secondsRecording == 0 &&
                                                      minutesRecording == 0) {
                                                    callRecordProvider!
                                                        .callRecord(
                                                      action: "START",
                                                      conversationId: widget
                                                          .dashboardProvider
                                                          .conversationId,
                                                      // callSid: callSid,
                                                      direction: "OUTBOUND",
                                                    )
                                                        .then((data) {
                                                      setState(() {
                                                        widget.dashboardProvider
                                                            .isRecord = true;
                                                      });
                                                      widget.onRecord(true);
                                                    });
                                                  } else if (!widget
                                                      .dashboardProvider
                                                      .isRecord) {
                                                    callRecordProvider!
                                                        .callRecord(
                                                      action: "RESUME",
                                                      conversationId: widget
                                                          .dashboardProvider
                                                          .conversationId,
                                                      // callSid: callSid,
                                                      direction: "OUTBOUND",
                                                    )
                                                        .then((data) {
                                                      setState(() {
                                                        widget.dashboardProvider
                                                            .isRecord = true;
                                                      });
                                                      widget.onRecord(true);
                                                      allowRecording = true;
                                                    });
                                                  } else {
                                                    callRecordProvider!
                                                        .callRecord(
                                                      action: "PAUSE",
                                                      conversationId: widget
                                                          .dashboardProvider
                                                          .conversationId,
                                                      // callSid: callSid,
                                                      direction: "OUTBOUND",
                                                    )
                                                        .then((data) {
                                                      setState(() {
                                                        widget.dashboardProvider
                                                            .isRecord = false;
                                                      });
                                                      widget.onRecord(false);
                                                      allowRecording = true;
                                                    });
                                                  }
                                                } else {
                                                  allowRecording = true;
                                                  Utils.showToastMessage(
                                                      "This feature is available in Standard and Enterprise plan.Please upgrade your plan.");
                                                }
                                              }
                                            } else {
                                              Utils.showToastMessage(
                                                  "Please wait.");
                                            }
                                          },
                                          onHold: () {
                                            widget.onHold(
                                                Provider.of<DashboardProvider>(
                                                        context,
                                                        listen: false)
                                                    .conversationId);
                                          },
                                          onKeyboardVisibilityTap: () {
                                            if (isKeyboardVisible) {
                                              setState(() {
                                                isKeyboardVisible = false;
                                              });
                                            } else {
                                              setState(() {
                                                isKeyboardVisible = true;
                                              });
                                            }
                                          },
                                          onKeyTap: (value) {
                                            widget.sendDigits(value.toString());
                                          },
                                          onMoreTap: () {
                                            if (!isRinging) {
                                              if (isConnected) {
                                                showMoreOptionDialog();
                                              }
                                            } else {
                                              Utils.showToastMessage(
                                                  Utils.getString(
                                                      "cannotSendAction"));
                                            }
                                          },
                                          onDisconnectCall: () {
                                            widget.onDisconnect();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: Dimens.space120.h,
                                left: Dimens.space0.w,
                                child: Provider.of<DashboardProvider>(context,
                                            listen: false)
                                        .isRecord
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        width: Dimens.space130.w,
                                        decoration: BoxDecoration(
                                          color: CustomColors.callDeclineColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                Dimens.space8.w),
                                            bottomRight: Radius.circular(
                                                Dimens.space8.w),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space6.w,
                                                  Dimens.space11.h,
                                                  Dimens.space6.w,
                                                  Dimens.space11.h),
                                              child: RoundedNetworkImageHolder(
                                                width: Dimens.space8,
                                                height: Dimens.space8,
                                                boxFit: BoxFit.contain,
                                                iconUrl:
                                                    Icons.fiber_manual_record,
                                                iconColor: CustomColors.white,
                                                iconSize: Dimens.space8,
                                                boxDecorationColor:
                                                    CustomColors.transparent,
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                imageUrl: "",
                                              ),
                                            ),
                                            Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        color:
                                                            CustomColors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                  text: Config.checkOverFlow
                                                      ? Const.OVERFLOW
                                                      : Utils.getString(
                                                          "recordings"),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              width: Dimens.space20.w,
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : minutesRecording
                                                        .toString()
                                                        .padLeft(2, "0"),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: CustomColors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          Config.heeboMedium,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              width: Dimens.space5.w,
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : ":",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: CustomColors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          Config.heeboMedium,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              width: Dimens.space20.w,
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : secondsRecording
                                                        .toString()
                                                        .padLeft(2, "0"),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: CustomColors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          Config.heeboMedium,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ),
                              Positioned(
                                top: Dimens.space40.h,
                                right: Dimens.space16.w,
                                left: Dimens.space16.w,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space12.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  color: CustomColors.mainColor,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    height: Dimens.space60.h,
                                    width: MediaQuery.of(context).size.width.sw,
                                    decoration: BoxDecoration(
                                      color:
                                          CustomColors.black!.withOpacity(0.15),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.space14.w),
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: Dimens.space0.h,
                                          bottom: Dimens.space0.w,
                                          left: Dimens.space0.w,
                                          child: RoundedNetworkImageHolder(
                                            width: Dimens.space40,
                                            height: Dimens.space20,
                                            boxFit: BoxFit.contain,
                                            iconUrl: CustomIcon.icon_arrow_left,
                                            iconColor: CustomColors.white,
                                            iconSize: Dimens.space20,
                                            boxDecorationColor:
                                                CustomColors.transparent,
                                            outerCorner: Dimens.space0,
                                            innerCorner: Dimens.space0,
                                            imageUrl: "",
                                            onTap: _onWillPop,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space0.h,
                                                  Dimens.space20.w,
                                                  Dimens.space0.h),
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : Provider.of<
                                                                DashboardProvider>(
                                                            context,
                                                            listen: false)
                                                        .channelName,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: CustomColors
                                                          .mainDividerColor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          Config.manropeBold,
                                                      fontSize:
                                                          Dimens.space16.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: Dimens.space20.w,
                                                ),
                                                Flexible(
                                                  child: RichText(
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            color: CustomColors
                                                                .mainDividerColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontFamily: Config
                                                                .heeboRegular,
                                                            fontSize: Dimens
                                                                .space14.sp,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                      text: Config.checkOverFlow
                                                          ? Const.OVERFLOW
                                                          : Provider.of<
                                                                      DashboardProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .channelNumber,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      Dimens.space6.w,
                                                      Dimens.space0.h,
                                                      Dimens.space0.w,
                                                      Dimens.space0.h),
                                                  alignment: Alignment.center,
                                                  child: FutureBuilder<String>(
                                                    future: Utils.getFlagUrl(
                                                        Provider.of<DashboardProvider>(
                                                                context,
                                                                listen: false)
                                                            .channelNumber),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return RoundedNetworkImageHolder(
                                                          width: Dimens.space14,
                                                          height:
                                                              Dimens.space14,
                                                          boxFit:
                                                              BoxFit.contain,
                                                          containerAlignment:
                                                              Alignment
                                                                  .bottomCenter,
                                                          iconUrl: CustomIcon
                                                              .icon_gallery,
                                                          iconColor:
                                                              CustomColors.grey,
                                                          iconSize:
                                                              Dimens.space14,
                                                          boxDecorationColor:
                                                              CustomColors
                                                                  .transparent,
                                                          outerCorner:
                                                              Dimens.space0,
                                                          innerCorner:
                                                              Dimens.space0,
                                                          imageUrl: PSApp
                                                                  .config!
                                                                  .countryLogoUrl! +
                                                              snapshot.data!,
                                                        );
                                                      }
                                                      return const CupertinoActivityIndicator();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dimens.space20.w,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showMoreOptionDialog() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CallOnProgressMoreOptionDialog(
            onAddNoteTap: () async {
              Navigator.of(context).pop();
              final dynamic returnData =
                  await Navigator.pushNamed(context, RoutePaths.notesList,
                      arguments: AddNotesIntentHolder(
                        channelId: widget.dashboardProvider.channelId,
                        clientId: contactId!,
                        number: contactsProvider!.contactDetailResponse!.data !=
                                null
                            ? contactsProvider!
                                .contactDetailResponse!.data!.number!
                            : contactNumber!,
                        onIncomingTap: () {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: () {
                          widget.onOutgoingTap();
                        },
                      ));
              if (returnData != null &&
                  returnData["data"] != null &&
                  returnData["data"] as bool) {
                final ContactPinUnpinRequestHolder param =
                    ContactPinUnpinRequestHolder(
                  channel: contactsProvider!.getDefaultChannel().id,
                  contact: contactNumber,
                  pinned: false,
                );
                return contactsProvider!
                    .doGetAllNotesApiCall(param)
                    .then((value) {
                  setState(() {
                    contactId = returnData["clientId"] as String;
                    contactsProvider!.doContactDetailApiCall(contactId!);
                  });
                });
              }
            },
            onTransferCallTap: () async {
              final Resources<PlanRestriction> resources = await userProvider!
                  .doGetPlanRestriction() as Resources<PlanRestriction>;
              if (!isOnHold) {
                if (resources.data != null &&
                    resources.data!.callTransfer != null &&
                    resources.data!.callTransfer!.hasAccess != null &&
                    resources.data!.callTransfer!.hasAccess as bool) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  showTransferMemberDialog();
                } else {
                  Utils.showToastMessage(
                      "This feature is available in Standard and Enterprise plan.Please upgrade your plan.");
                }
              } else {
                Utils.showToastMessage("Cannot transfer right now.");
              }
            },
            onContactTap: () async {
              widget.onContactTap();
              Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
            },
          );
        });
  }

  Future<void> showTransferMemberDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return TransferCallDialog(
          callTransferProvider: callTransferProvider!,
          animationController: animationController!,
          onCancelTap: () {},
          callerId: contactNumber!,
          direction: "Outgoing",
        );
      },
    );
  }
}

class ContactNameWidget extends StatelessWidget {
  const ContactNameWidget({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final String contact;

  @override
  Widget build(BuildContext context) {
    return Text(
      Config.checkOverFlow ? Const.OVERFLOW : contact,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: CustomColors.white,
            fontStyle: FontStyle.normal,
            fontSize: Dimens.space24.sp,
            fontFamily: Config.manropeBold,
            fontWeight: FontWeight.normal,
          ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
    required this.events,
  }) : super(key: key);

  final String events;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Text(
        Config.checkOverFlow
            ? Const.OVERFLOW
            : events.isNotEmpty
                ? events
                : Utils.getString("connecting"),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: CustomColors.secondaryColor,
              fontStyle: FontStyle.normal,
              fontSize: Dimens.space14.sp,
              fontFamily: Config.manropeMedium,
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key? key,
    required this.isOnHold,
    required this.isTransfer,
    required this.seconds,
    required this.minutes,
  }) : super(key: key);

  final bool isOnHold;
  final int seconds;
  final int minutes;
  final bool isTransfer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space12.w, Dimens.space6.h, Dimens.space12.w, Dimens.space6.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            isOnHold ? CustomColors.warningColor : CustomColors.callAcceptColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space32.r)),
      ),
      width: isTransfer && isOnHold
          ? Dimens.space290.w
          : isTransfer
              ? Dimens.space220.w
              : isOnHold
                  ? Dimens.space180.w
                  : Dimens.space90.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerRight,
            width: Dimens.space30.w,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : minutes.toString().padLeft(2, "0"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.space16.sp,
                    fontFamily: Config.manropeSemiBold,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            width: Dimens.space5.w,
            child: Text(
              Config.checkOverFlow ? Const.OVERFLOW : ":",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.space16.sp,
                    fontFamily: Config.manropeSemiBold,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerLeft,
            width: Dimens.space30.w,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : seconds.toString().padLeft(2, "0"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.space16.sp,
                    fontFamily: Config.manropeSemiBold,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Offstage(
            offstage: !isOnHold,
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: Dimens.space80.w,
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : "- ${Utils.getString("onHold")}",
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: Dimens.space16.sp,
                      fontFamily: Config.manropeSemiBold,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Offstage(
            offstage: !isTransfer,
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: Dimens.space120.w,
              child: Text(
                Config.checkOverFlow ? Const.OVERFLOW : "- Transferring",
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: Dimens.space16.sp,
                      fontFamily: Config.manropeSemiBold,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AfterCallAcceptButtonWidget extends StatelessWidget {
  const AfterCallAcceptButtonWidget(
      {Key? key,
      required this.enableCancel,
      // required this.afterTransfer,
      required this.isMicMute,
      required this.isSpeakerOn,
      required this.isRecord,
      required this.isOnHold,
      required this.isKeyboardVisible,
      required this.onSetMicrophoneMute,
      required this.onSetSpeakerphoneOn,
      required this.onDisconnectCall,
      required this.onRecord,
      required this.onHold,
      required this.onKeyboardVisibilityTap,
      required this.onKeyTap,
      required this.digit,
      required this.onMoreTap,
      required this.autoRecord})
      : super(key: key);

  final bool enableCancel;

  // final bool afterTransfer;
  final bool isMicMute;
  final bool isSpeakerOn;
  final bool isRecord;
  final bool isOnHold;
  final bool isKeyboardVisible;
  final bool autoRecord;

  final String digit;
  final Function onSetMicrophoneMute;
  final Function onSetSpeakerphoneOn;
  final Function onDisconnectCall;
  final Function onRecord;
  final Function onHold;
  final Function onKeyboardVisibilityTap;
  final Function onKeyTap;
  final Function onMoreTap;

  @override
  Widget build(BuildContext context) {
    CustomAppBar.changeStatusColor(CustomColors.mainColor!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Offstage(
            offstage: isKeyboardVisible,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space80,
                          height: Dimens.space80,
                          iconUrl: isRecord
                              ? CustomIcon.icon_stop
                              : CustomIcon.icon_record,
                          iconColor: !autoRecord
                              ? CustomColors.secondaryColor!.withOpacity(0.2)
                              : isRecord
                                  ? CustomColors.callDeclineColor
                                  : CustomColors.secondaryColor,
                          iconSize: Dimens.space20,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space300,
                          boxDecorationColor: isRecord
                              ? CustomColors.white
                              : CustomColors.black!.withOpacity(0.15),
                          imageUrl: "",
                          onTap: () {
                            onRecord();
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                        width: Dimens.space80.w,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : isRecord
                                  ? Utils.getString("stop")
                                  : Utils.getString("record"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.mainDividerColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space80,
                          height: Dimens.space80,
                          iconUrl: isMicMute
                              ? CustomIcon.icon_mic_selected
                              : CustomIcon.icon_mic_unselected,
                          iconColor: !enableCancel
                              ? CustomColors.secondaryColor!.withOpacity(0.2)
                              : isMicMute
                                  ? CustomColors.callDeclineColor
                                  : CustomColors.secondaryColor,
                          iconSize: Dimens.space20,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space300,
                          boxDecorationColor: isMicMute
                              ? CustomColors.white
                              : CustomColors.black!.withOpacity(0.15),
                          imageUrl: "",
                          onTap: () {
                            if (enableCancel) {
                              onSetMicrophoneMute();
                            }
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                        width: Dimens.space80.w,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : isMicMute
                                  ? Utils.getString("unMute")
                                  : Utils.getString("mute"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.mainDividerColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space80,
                          height: Dimens.space80,
                          iconUrl: CustomIcon.icon_speaker,
                          iconColor: isSpeakerOn
                              ? CustomColors.mainColor
                              : CustomColors.secondaryColor,
                          iconSize: Dimens.space20,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space300,
                          boxDecorationColor: !isSpeakerOn
                              ? CustomColors.black!.withOpacity(0.15)
                              : CustomColors.white,
                          imageUrl: "",
                          onTap: () {
                            onSetSpeakerphoneOn();
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                        width: Dimens.space80.w,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("speaker"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.mainDividerColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Offstage(
            offstage: isKeyboardVisible,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space80,
                            height: Dimens.space80,
                            iconUrl: CustomIcon.icon_hold,
                            iconColor: !enableCancel
                                ? CustomColors.secondaryColor!.withOpacity(0.2)
                                : isOnHold
                                    ? CustomColors.mainColor
                                    : CustomColors.secondaryColor,
                            iconSize: Dimens.space20,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space0,
                            boxDecorationColor: isOnHold
                                ? CustomColors.white
                                : CustomColors.black!.withOpacity(0.15),
                            imageUrl: "",
                            onTap: () {
                              if (enableCancel) {
                                onHold();
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Dimens.space80.w,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : isOnHold
                                    ? Utils.getString("resume")
                                    : Utils.getString("hold"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.mainDividerColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space80,
                            height: Dimens.space80,
                            iconUrl: CustomIcon.icon_dialer_selected,
                            iconColor: CustomColors.secondaryColor,
                            iconSize: Dimens.space20,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor:
                                CustomColors.black!.withOpacity(0.15),
                            imageUrl: "",
                            onTap: () async {
                              onKeyboardVisibilityTap();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Dimens.space80.w,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("keypad"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.mainDividerColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space80,
                            height: Dimens.space80,
                            iconUrl: CustomIcon.icon_more,
                            iconColor: CustomColors.secondaryColor,
                            iconSize: Dimens.space20,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor:
                                CustomColors.black!.withOpacity(0.15),
                            imageUrl: "",
                            onTap: () {
                              onMoreTap();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Dimens.space80.w,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("more"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.mainDividerColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Offstage(
            offstage: !isKeyboardVisible,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : digit,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.white,
                          fontFamily: Config.manropeSemiBold,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space24.sp,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space35.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("1");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("1"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("2");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("2"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("abc"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("3");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("3"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("def"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space18.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("4");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("4"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("ghi"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("5");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("5"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("jkl"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("6");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("6"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("mno"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space18.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("7");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("7"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("pqrs"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("8");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("8"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("tuv"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("9");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("9"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("wxyz"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space18.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("*");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("*"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            onKeyTap("0");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("0"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                                Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("+"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space16.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                CustomColors.black!.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space100.r),
                            ),
                          ),
                          onPressed: () {
                            onKeyTap("#");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            width: Dimens.space80.w,
                            height: Dimens.space80.w,
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("#"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space64.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.center,
                width: Dimens.space80.w,
                height: Dimens.space80.w,
              ),
              Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space80,
                    height: Dimens.space80,
                    iconUrl: CustomIcon.icon_call_decline,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space20,
                    outerCorner: Dimens.space300,
                    innerCorner: Dimens.space300,
                    // boxDecorationColor: !PsSharedPreferences.instance.shared
                    //     .getBool(Const.VALUE_HOLDER_IS_CALL_CONNECTED)
                    boxDecorationColor: !enableCancel
                        ? CustomColors.geryColor
                        : CustomColors.callDeclineColor,
                    imageUrl: "",
                    onTap: () {
                      // if(PsSharedPreferences.instance.shared
                      //     .getBool(Const.VALUE_HOLDER_IS_CALL_CONNECTED)){
                      if (enableCancel) {
                        onDisconnectCall();
                      }
                    },
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Dimens.space80.w,
                height: Dimens.space80.w,
                child: Offstage(
                  offstage: !isKeyboardVisible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        width: Dimens.space80.w,
                        height: Dimens.space80.w,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            onKeyboardVisibilityTap();
                          },
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("hide"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.mainDividerColor,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
