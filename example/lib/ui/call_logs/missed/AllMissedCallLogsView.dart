import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:graphql/client.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/ui/call_logs/CallLogListItemView.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
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

class AllMissedCallLogsView extends StatefulWidget {
  const AllMissedCallLogsView({
    Key? key,
    required this.animationController,
    required this.onCallTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    this.onStartConversationTap,
  }) : super(key: key);

  final AnimationController? animationController;
  final Function? onCallTap;
  final Function? onStartConversationTap;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String?, String) makeCallWithSid;

  @override
  _AllMissedCallLogsViewState createState() => _AllMissedCallLogsViewState();
}

class _AllMissedCallLogsViewState extends State<AllMissedCallLogsView> {
  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;

  ValueHolder? valueHolder;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isLoading = false;

  final SlidableController slidAbleController = SlidableController();
  final ScrollController _scrollController = ScrollController();

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
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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
        callLogProvider!.doNextCallLogsApiCall("missed");
      }
    });

    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      callLogProvider!.doEmptyCallLogsOnChannelChanged();
      callLogProvider!.doGetCallLogsAndPinnedConversationLogsApiCall("missed");
      doSubscriptionUpdate();
    });

    doSubscriptionUpdate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    streamSubscriptionOnWorkspaceOrChannelChanged!.cancel();
    streamSubscriptionOnNetworkChanged!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CallLogProvider?>(
          lazy: false,
          create: (BuildContext context) {
            callLogProvider =
                CallLogProvider(callLogRepository: callLogRepository);
            callLogProvider!.doEmptyCallLogsOnChannelChanged();
            callLogProvider!
                .doGetCallLogsAndPinnedConversationLogsApiCall("missed");
            return callLogProvider;
          },
        ),
        ChangeNotifierProvider<ContactsProvider?>(
          lazy: false,
          create: (BuildContext context) {
            contactsProvider =
                ContactsProvider(contactRepository: contactRepository);
            return contactsProvider;
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.white,
        body: Consumer<CallLogProvider>(builder:
            (BuildContext context, CallLogProvider? provider, Widget? child) {
          widget.animationController!.forward();
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn),
          ));
          if (isLoading == false) {
            if (callLogProvider!.callLogs != null &&
                callLogProvider!.callLogs!.data != null) {
              if (callLogProvider!.callLogs!.data!.isNotEmpty) {
                return Container(
                  color: CustomColors.white,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RefreshIndicator(
                        color: CustomColors.mainColor,
                        backgroundColor: CustomColors.white,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: callLogProvider!.callLogs!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final int count =
                                callLogProvider!.callLogs!.data!.length;
                            widget.animationController!.forward();
                            return CallLogVerticalListItem(
                              memberId: callLogProvider!.getMemberId(),
                              slidAbleController: slidAbleController,
                              animationController: widget.animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              callLog: callLogProvider!.callLogs!.data![index],
                              index: index,
                              onPressed: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                  context,
                                  RoutePaths.messageDetail,
                                  arguments: MessageDetailIntentHolder(
                                    clientName: callLogProvider!
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
                                            .blocked
                                        : false,
                                    lastChatted: callLogProvider!
                                        .callLogs!
                                        .data![index]
                                        .recentConversationNodes!
                                        .createdAt,
                                    channelId:
                                        callLogProvider!.getDefaultChannel().id,
                                    channelName: callLogProvider!
                                        .getDefaultChannel()
                                        .name,
                                    channelNumber: callLogProvider!
                                        .getDefaultChannel()
                                        .number,
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
                                            .id
                                        : null,
                                    // dndMissed: callLogProvider
                                    //             .callLogs
                                    //             .data[index]
                                    //             .recentConversationNodes
                                    //             .personalizedInfo !=
                                    //         null
                                    //     ? callLogProvider
                                    //         .callLogs
                                    //         .data[index]
                                    //         .recentConversationNodes
                                    //         .personalizedInfo
                                    //         .dndMissed
                                    //     : false,
                                    isContact: callLogProvider!
                                                .callLogs!
                                                .data![index]
                                                .recentConversationNodes!
                                                .clientInfo !=
                                            null
                                        ? true
                                        : false,
                                    onIncomingTap: () {
                                      widget.onIncomingTap!();
                                    },
                                    onOutgoingTap: () {
                                      widget.onOutgoingTap!();
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
                                      widget.makeCallWithSid(
                                        channelNumber!,
                                        channelName!,
                                        channelSid!,
                                        outgoingNumber!,
                                        workspaceSid!,
                                        memberId!,
                                        voiceToken!,
                                        outgoingName!,
                                        outgoingId,
                                        outgoingProfilePicture!,
                                      );
                                    },
                                    onContactBlocked: (bool value) {},
                                  ),
                                );
                                if (returnData != null &&
                                    returnData["data"] is bool &&
                                    returnData["data"] as bool &&
                                    returnData["type"] == "blockDelete") {
                                  isLoading = true;
                                  setState(() {});
                                  callLogProvider!
                                      .doGetCallLogsAndPinnedConversationLogsApiCall(
                                          "missed")
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
                                          "missed")
                                      .then((value) {
                                    isLoading = false;
                                    setState(() {});
                                  });
                                }
                              },
                              onCallTap: (clientName, clientNumber) {
                                slidAbleController.activeState!.close();
                                Utils.checkInternetConnectivity().then((value) {
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
                                          callLogProvider!.getMemberId(),
                                          callLogProvider!.getVoiceToken()!,
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
                                            callLogProvider!.getChannelList(),
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
                                                .id
                                            : null,
                                        clientName: clientName!,
                                        clientNumber: clientNumber!,
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
                                        Utils.getString("noInternet"), context);
                                  }
                                });
                              },
                              onPinTap: (contactNumber, value) async {
                                slidAbleController.activeState!.close();
                                Utils.checkInternetConnectivity()
                                    .then((data) async {
                                  if (data) {
                                    // PsProgressDialog.showDialog(context);
                                    final ContactPinUnpinRequestHolder params =
                                        ContactPinUnpinRequestHolder(
                                      channel: callLogProvider!
                                          .getDefaultChannel()
                                          .id,
                                      contact: contactNumber,
                                      pinned: value ? false : true,
                                    );
                                    final Resources<bool> status =
                                        await callLogProvider!
                                            .doContactPinUnpinApiCall(
                                                params) as Resources<bool>;
                                    if (status.data != null) {
                                      // PsProgressDialog.dismissDialog();
                                      callLogProvider!
                                          .doGetCallLogsAndPinnedConversationLogsApiCall(
                                              "missed");
                                    } else {
                                      // PsProgressDialog.dismissDialog();
                                      Utils.showToastMessage(status.message!);
                                    }
                                  } else {
                                    Utils.showWarningToastMessage(
                                        Utils.getString("noInternet"), context);
                                  }
                                });
                              },
                              type: CallType.Missed,
                            );
                          },
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                        ),
                        onRefresh: () {
                          return callLogProvider!
                              .doGetCallLogsAndPinnedConversationLogsApiCall(
                                  "missed");
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: CustomLinearProgressIndicator(
                          callLogProvider!.callLogs!.status!,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return AnimatedBuilder(
                  animation: widget.animationController!,
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
                          alignment: Alignment.center,
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
        }),
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
              clientId,
              clientProfilePicture!,
            );
          },
        ),
      ),
    );
  }

  Future<void> doSubscriptionUpdate() async {
    streamSubscriptionCallLogs = await callLogProvider!
        .doSubscriptionCallLogsApiCall(
            "missed", callLogProvider!.getDefaultChannel().id);

    if (streamSubscriptionCallLogs != null) {
      streamSubscriptionCallLogs!.listen((event) async {
        if (event.data != null) {
          final RecentConversationNodes recentConversationNodes =
              RecentConversationNodes()
                  .fromMap(event.data!["updateConversation"]["message"])!;
          if (recentConversationNodes.channelInfo!.channelId ==
              callLogProvider!.getDefaultChannel().id) {
            callLogProvider!
                .doGetCallLogsAndPinnedConversationLogsApiCall("missed");
          }
        }
      });
    }
  }
}
