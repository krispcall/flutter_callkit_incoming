import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:graphql/client.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/ui/call_logs/CallLogListItemView.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/dialog/ChannelSelectionDialog.dart";
import "package:mvp/ui/common/indicator/CustomLinearProgressIndicator.dart";
import "package:mvp/ui/common/shimmer/CallLogShimmer.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:provider/provider.dart";

class AllCallLogsView extends StatefulWidget {
  const AllCallLogsView({
    Key? key,
    required this.animationController,
    required this.onCallTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    this.onStartConversationTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onCallTap;
  final Function? onStartConversationTap;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;

  @override
  AllCallLogsViewState createState() => AllCallLogsViewState();
}

class AllCallLogsViewState extends State<AllCallLogsView> {
  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  ValueHolder? valueHolder;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isLoading = false;

  final SlidableController slidAbleController = SlidableController();
  final ScrollController _scrollController = ScrollController();

  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;

  Stream<QueryResult>? streamSubscriptionCallLogs;
  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;

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
        internetConnectionStatus = InternetConnectionStatus.connected;
        doSubscriptionUpdate();
        setState(() {});
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnection();

    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    callLogProvider = CallLogProvider(callLogRepository: callLogRepository);

    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(contactRepository: contactRepository);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        callLogProvider!.doNextCallLogsApiCall("all");
      }
    });

    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      callLogProvider!.doEmptyCallLogsOnChannelChanged();
      callLogProvider!.doGetCallLogsAndPinnedConversationLogsApiCall("all");
      doSubscriptionUpdate();
      setState(() {});
    });
    doSubscriptionUpdate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    streamSubscriptionOnWorkspaceOrChannelChanged?.cancel();
    streamSubscriptionOnNetworkChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CallLogProvider>(
          lazy: false,
          create: (BuildContext context) {
            callLogProvider = CallLogProvider(callLogRepository: callLogRepository);
            callLogProvider!.doEmptyCallLogsOnChannelChanged();
            callLogProvider!.doGetCallLogsAndPinnedConversationLogsApiCall("all");
            return callLogProvider!;
          },
        ),
        ChangeNotifierProvider<ContactsProvider>(
          lazy: false,
          create: (BuildContext context) {
            contactsProvider = ContactsProvider(contactRepository: contactRepository);
            return contactsProvider!;
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.white,
        body: Consumer<CallLogProvider>(
          builder:
              (BuildContext context, CallLogProvider? provider, Widget? child) {
            widget.animationController.forward();

            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve:
                    const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn),
              ),
            );
            if (isLoading == false) {
              if (callLogProvider!.callLogs != null &&
                  callLogProvider!.callLogs!.data != null) {
                if (callLogProvider!.callLogs!.data!.isNotEmpty) {
                  return Container(
                    color: CustomColors.white,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space12.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RefreshIndicator(
                          color: CustomColors.mainColor,
                          backgroundColor: CustomColors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount:
                                      callLogProvider!.callLogs!.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count =
                                        callLogProvider!.callLogs!.data!.length;
                                    widget.animationController.forward();
                                    return Column(
                                      children: [
                                        index == 0 &&
                                                callLogProvider!
                                                        .callLogs!
                                                        .data![0]
                                                        .recentConversationNodes!
                                                        .contactPinned !=
                                                    null &&
                                                callLogProvider!
                                                    .callLogs!
                                                    .data![0]
                                                    .recentConversationNodes!
                                                    .contactPinned!
                                            ? Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space0.h,
                                                  Dimens.space20.w,
                                                  Dimens.space0.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      Config.checkOverFlow
                                                          ? Const.OVERFLOW
                                                          : Utils.getString(
                                                              "pinned"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            color: CustomColors
                                                                .textTertiaryColor,
                                                            fontFamily: Config
                                                                .manropeSemiBold,
                                                            fontSize: Dimens
                                                                .space14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.space6.w,
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                      width: Dimens.space18,
                                                      height: Dimens.space18,
                                                      iconUrl:
                                                          CustomIcon.icon_pin,
                                                      iconColor: CustomColors
                                                          .textQuinaryColor,
                                                      iconSize: Dimens.space12,
                                                      outerCorner:
                                                          Dimens.space0,
                                                      innerCorner:
                                                          Dimens.space0,
                                                      boxDecorationColor:
                                                          CustomColors
                                                              .transparent,
                                                      imageUrl: "",
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        CallLogVerticalListItem(
                                          memberId:
                                              callLogProvider!.getMemberId(),
                                          slidAbleController:
                                              slidAbleController,
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          callLog: callLogProvider!
                                              .callLogs!.data![index],
                                          index: index,
                                          onPressed: () async {
                                            final dynamic returnData =
                                                await Navigator.pushNamed(
                                              context,
                                              RoutePaths.messageDetail,
                                              arguments:
                                                  MessageDetailIntentHolder(
                                                      clientName: callLogProvider!.callLogs!.data![index].recentConversationNodes!.clientInfo != null
                                                          ? callLogProvider!
                                                              .callLogs!
                                                              .data![index]
                                                              .recentConversationNodes!
                                                              .clientInfo!
                                                              .name
                                                          : callLogProvider!
                                                              .callLogs!
                                                              .data![index]
                                                              .recentConversationNodes!
                                                              .clientNumber,
                                                      clientPhoneNumber: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientNumber,
                                                      clientProfilePicture: callLogProvider!.callLogs!.data![index].recentConversationNodes!.clientInfo != null
                                                          ? callLogProvider!
                                                              .callLogs!
                                                              .data![index]
                                                              .recentConversationNodes!
                                                              .clientInfo!
                                                              .profilePicture
                                                          : "",
                                                      countryId: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientCountry,
                                                      isBlocked: callLogProvider!
                                                                  .callLogs!
                                                                  .data![index]
                                                                  .recentConversationNodes!
                                                                  .clientInfo !=
                                                              null
                                                          ? callLogProvider!
                                                                  .callLogs!
                                                                  .data![index]
                                                                  .recentConversationNodes!
                                                                  .clientInfo!
                                                                  .blocked ??
                                                              false
                                                          : false,
                                                      lastChatted: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .createdAt,
                                                      channelId: callLogProvider!
                                                          .getDefaultChannel()
                                                          .id,
                                                      channelName: callLogProvider!.getDefaultChannel().name,
                                                      channelNumber: callLogProvider!.getDefaultChannel().number,
                                                      clientId: callLogProvider!.callLogs!.data![index].recentConversationNodes!.clientInfo != null ? callLogProvider!.callLogs!.data![index].recentConversationNodes!.clientInfo!.id : null,
                                                      // dndMissed: callLogProvider.callLogs.data[index].recentConversationNodes.personalizedInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.personalizedInfo.dndMissed : false,
                                                      isContact: callLogProvider!.callLogs!.data![index].recentConversationNodes!.clientInfo != null ? true : false,
                                                      onIncomingTap: () {
                                                        widget.onIncomingTap();
                                                      },
                                                      onOutgoingTap: () {
                                                        widget.onOutgoingTap();
                                                      },
                                                      makeCallWithSid: (channelNumber, channelName, channelSid, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingProfilePicture) {
                                                        widget.makeCallWithSid(
                                                          channelNumber!,
                                                          channelName!,
                                                          channelSid!,
                                                          outgoingNumber!,
                                                          workspaceSid!,
                                                          memberId!,
                                                          voiceToken!,
                                                          outgoingName!,
                                                          outgoingId ?? "",
                                                          outgoingProfilePicture ??
                                                              "",
                                                        );
                                                      },
                                                      onContactBlocked: (bool) {}),
                                            );
                                            if (returnData != null &&
                                                returnData["data"] is bool &&
                                                returnData["data"] as bool &&
                                                returnData["type"] ==
                                                    "blockDelete") {
                                              isLoading = true;
                                              setState(() {});
                                              callLogProvider!
                                                  .doGetCallLogsAndPinnedConversationLogsApiCall(
                                                      "all")
                                                  .then((value) {
                                                isLoading = false;
                                                setState(() {});
                                              });
                                            } else if (returnData != null &&
                                                returnData["data"] is bool &&
                                                returnData["data"] as bool &&
                                                returnData["type"] == "") {
                                              callLogProvider!
                                                  .doGetCallLogsAndPinnedConversationLogsApiCall(
                                                      "all")
                                                  .then((value) {
                                                isLoading = false;
                                                setState(() {});
                                              });
                                            }
                                          },
                                          onCallTap:
                                              (clientName, clientNumber) {
                                            slidAbleController.activeState!
                                                .close();
                                            Utils.checkInternetConnectivity()
                                                .then((value) {
                                              if (value) {
                                                if (callLogProvider!
                                                        .getChannelList()!
                                                        .length ==
                                                    1) {
                                                  widget.makeCallWithSid(
                                                      callLogProvider!
                                                          .getDefaultChannel()
                                                          .number!,
                                                      callLogProvider!
                                                          .getDefaultChannel()
                                                          .name!,
                                                      callLogProvider!
                                                          .getDefaultChannel()
                                                          .id!,
                                                      clientNumber!,
                                                      callLogProvider!
                                                          .getDefaultWorkspace(),
                                                      callLogProvider!
                                                          .getMemberId(),
                                                      callLogProvider!
                                                          .getVoiceToken()!,
                                                      clientName!,
                                                      callLogProvider!
                                                                  .callLogs!
                                                                  .data![index]
                                                                  .recentConversationNodes!
                                                                  .clientInfo !=
                                                              null
                                                          ? callLogProvider!
                                                              .callLogs!
                                                              .data![index]
                                                              .recentConversationNodes!
                                                              .clientInfo!
                                                              .id!
                                                          : "",
                                                      callLogProvider!
                                                                  .callLogs!
                                                                  .data![index]
                                                                  .recentConversationNodes!
                                                                  .clientInfo !=
                                                              null
                                                          ? callLogProvider!
                                                                  .callLogs!
                                                                  .data![index]
                                                                  .recentConversationNodes!
                                                                  .clientInfo!
                                                                  .profilePicture ??
                                                              ""
                                                          : "");
                                                } else {
                                                  _channelSelectionDialog(
                                                    channelList:
                                                        callLogProvider!
                                                            .getChannelList(),
                                                    clientId: callLogProvider!
                                                                .callLogs!
                                                                .data![index]
                                                                .recentConversationNodes!
                                                                .clientInfo !=
                                                            null
                                                        ? callLogProvider!
                                                            .callLogs!
                                                            .data![index]
                                                            .recentConversationNodes!
                                                            .clientInfo!
                                                            .id!
                                                        : null,
                                                    clientName: clientName,
                                                    clientNumber: clientNumber,
                                                    clientProfilePicture: callLogProvider!
                                                                .callLogs!
                                                                .data![index]
                                                                .recentConversationNodes!
                                                                .clientInfo !=
                                                            null
                                                        ? callLogProvider!
                                                            .callLogs!
                                                            .data![index]
                                                            .recentConversationNodes!
                                                            .clientInfo!
                                                            .profilePicture
                                                        : "",
                                                  );
                                                }
                                              } else {
                                                Utils.showWarningToastMessage(
                                                    Utils.getString(
                                                        "noInternet"),
                                                    context);
                                              }
                                            });
                                          },
                                          onPinTap:
                                              (contactNumber, value) async {
                                            slidAbleController.activeState!
                                                .close();
                                            Utils.checkInternetConnectivity()
                                                .then((data) async {
                                              if (data) {
                                                final ContactPinUnpinRequestHolder
                                                    params =
                                                    ContactPinUnpinRequestHolder(
                                                  channel: callLogProvider!
                                                      .getDefaultChannel()
                                                      .id!,
                                                  contact: contactNumber,
                                                  pinned: value ? false : true,
                                                );
                                                final status =
                                                    await callLogProvider!
                                                        .doContactPinUnpinApiCall(
                                                            params);
                                                bool statusData = false;
                                                if (status.data == null) {
                                                  statusData = false;
                                                } else {
                                                  statusData = true;
                                                }
                                                if (statusData) {
                                                  callLogProvider!
                                                      .doGetCallLogsAndPinnedConversationLogsApiCall(
                                                          "all");
                                                } else {
                                                  Utils.showToastMessage(status!
                                                      .message! as String);
                                                }
                                              } else {
                                                Utils.showWarningToastMessage(
                                                    Utils.getString(
                                                        "noInternet"),
                                                    context);
                                              }
                                            });
                                          },
                                          type: CallType.All,
                                        )
                                      ],
                                    );
                                  },
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          onRefresh: () {
                            return callLogProvider!
                                .doGetCallLogsAndPinnedConversationLogsApiCall(
                                    "all");
                          },
                        ),
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: CustomLinearProgressIndicator(
                            callLogProvider!.callLogs!.status!,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return AnimatedBuilder(
                    animation: widget.animationController,
                    builder: (BuildContext context, Widget? child) {
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - animation.value), 0.0),
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space12.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: EmptyViewUiWidget(
                              assetUrl: "assets/images/no_conversation.png",
                              title: Utils.getString("noCallLogs"),
                              desc: Utils.getString("noCallLogsDescription"),
                              buttonTitle: Utils.getString("startConversation"),
                              icon: Icons.add_circle_outline,
                              onPressed: () {
                                widget.onStartConversationTap!();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              } else {
                return Container(
                  color: CustomColors.white,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return const CallLogShimmer();
                    },
                  ),
                );
              }
            } else {
              return Container(
                color: CustomColors.white,
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return const CallLogShimmer();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _channelSelectionDialog({
    List<WorkspaceChannel>? channelList,
    String? clientNumber,
    String? clientName,
    String? clientId,
    String? clientProfilePicture,
  }) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.48,
        child: ChannelSelectionDialog(
          channelList: channelList,
          onChannelTap: (WorkspaceChannel data) {
            widget.makeCallWithSid(
              data.number!,
              data.name!,
              data.id!,
              clientNumber!,
              callLogProvider!.getDefaultWorkspace(),
              callLogProvider!.getMemberId(),
              callLogProvider!.getVoiceToken()!,
              clientName!,
              clientId ?? "",
              clientProfilePicture ?? "",
            );
          },
        ),
      ),
    );
  }

  Future<void> doSubscriptionUpdate() async {
    try {
      streamSubscriptionCallLogs = await callLogProvider!
          .doSubscriptionCallLogsApiCall(
              "all", callLogProvider!.getDefaultChannel().id);
      if (streamSubscriptionCallLogs != null) {
        streamSubscriptionCallLogs!.listen((event) async {
          if (event.data != null) {
            final RecentConversationNodes recentConversationNodes =
                RecentConversationNodes()
                    .fromMap(event.data!["updateConversation"]["message"])!;
            Utils.cPrint(
                event.data!["updateConversation"]["message"].toString());
            if (recentConversationNodes.channelInfo!.channelId! ==
                callLogProvider!.getDefaultChannel().id) {
              callLogProvider!.doUpdateSubscriptionCallLogs("all", recentConversationNodes);
            }
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
