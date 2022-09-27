import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:graphql/client.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/BaseStatefulState.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/memberChatProvider/MemberMessageDetailsProvider.dart";
import "package:mvp/repository/MemberMessageDetailsRepository.dart";
import "package:mvp/ui/common/ChatTextFiledWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/discord/OverlappingPanelsRight.dart";
import "package:mvp/ui/members/memberMessageDetail/MemberMessageDetailSideMenuWidget.dart";
import "package:mvp/ui/members/memberMessageDetail/widgets/EmptyConversationWidget.dart";
import "package:mvp/ui/members/memberMessageDetail/widgets/IncomingMessageView.dart";
import "package:mvp/ui/members/memberMessageDetail/widgets/OutGoingMessageView.dart";
import "package:mvp/ui/members/member_conversation_search/MemberConversationSearchView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/sendMessage/Messages.dart";
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:scroll_to_index/scroll_to_index.dart";
import "package:visibility_detector/visibility_detector.dart";

class MemberMessageDetailView extends StatefulWidget {
  const MemberMessageDetailView({
    Key? key,
    required this.clientId,
    required this.clientName,
    required this.clientProfilePicture,
    required this.onlineStatus,
    required this.clientEmail,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final String clientId;
  final String clientName;
  final String clientProfilePicture;
  final bool onlineStatus;
  final String clientEmail;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  MemberMessageDetailState createState() => MemberMessageDetailState();
}

class MemberMessageDetailState
    extends BaseStatefulState<MemberMessageDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  MemberMessageDetailsProvider? memberMessageDetailsProvider;
  MemberMessageDetailsRepository? memberMessageDetailsRepository;

  AutoScrollController? _scrollController;
  ValueHolder? valueHolder;

  bool isSendIconVisible = false;
  final TextEditingController textEditingControllerMessage =
      TextEditingController();
  String? contactId;

  Stream<QueryResult>? streamSubscriptionUpdateMemberChatDetail;
  StreamSubscription? streamSubscriptionOnNetworkChanged;
  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;

  bool isOpen = false;

  final RefreshController _refreshController = RefreshController();

  final _debounce = DeBouncer(milliseconds: 500);

  bool isSearching = false;

  bool shouldScrollDown = false;

  List<RecentConversationMemberEdge> searchList = [];

  String searchQuery = "";

  RecentConversationMemberEdge? selectedSearchItem;

  int selectedSearchItemIndex = 0;

  int toSearchItemIndex = 0;

  int subCount = 0;

  // bool callInProgressOutgoing = false;
  // bool callInProgressIncoming = false;
  int secondsOutgoing = 0;
  int minutesOutgoing = 0;
  int secondsIncoming = 0;
  int minutesIncoming = 0;

  StreamSubscription? streamSubscriptionIncomingEvent;
  StreamSubscription? streamSubscriptionOutgoingEvent;

  Future<void> _onLoading() async {
    final bool hasPreviousPage =
        memberMessageDetailsProvider!.pageInfo!.data!.hasPreviousPage!;
    if (hasPreviousPage) {
      final List<MemberMessageDetailsObjectWithType> dump =
          memberMessageDetailsProvider!.listMemberConversationDetails!.data!;
      dump.removeWhere((element) => element.type!.toLowerCase() == "time");
      Utils.cPrint(dump.length.toString());
      final int apiDataLength = dump.length;
      await memberMessageDetailsProvider!
          .doMemberChatListLowerApiCall(
        widget.clientId,
        apiDataLength,
      )
          .then((value) async {
        if (value.isNotEmpty) {
          setState(() {});
          try {
            await _scrollController!.scrollToIndex(
              memberMessageDetailsProvider!.lengthDiff!.data!,
              preferPosition: AutoScrollPosition.begin,
            );
          } catch (e) {
            ///Do Nothing
          }
        }
      });
      if (mounted) setState(() {});
      _refreshController.refreshCompleted();
    } else {
      if (mounted) setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  Future<void> _onRefresh() async {
    final bool hasNextPage =
        memberMessageDetailsProvider!.pageInfo!.data!.hasNextPage!;
    if (hasNextPage) {
      Utils.cPrint("On Refresh");
      await memberMessageDetailsProvider?.doMemberChatListUpperApiCall(
        widget.clientId,
      );
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    } else {
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    doCheckConnection();
    contactId = widget.clientId;

    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    memberMessageDetailsRepository =
        Provider.of<MemberMessageDetailsRepository>(context, listen: false);
    memberMessageDetailsProvider = MemberMessageDetailsProvider(
        memberMessageDetailsRepository: memberMessageDetailsRepository);

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      axis: Axis.vertical,
    );
    doSubscriptionUpdate();

    streamSubscriptionOutgoingEvent =
        DashboardView.outgoingEvent.on().listen((event) {
      if (event != null && event["outgoingEvent"] == "outGoingCallRinging") {
        // if (mounted) {
        //   setState(() {
        //     callInProgressOutgoing = true;
        //   });
        // }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallDisconnected") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = false;
            minutesOutgoing = 0;
            secondsOutgoing = 0;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallConnected") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = true;
            minutesOutgoing = event["minutes"] as int;
            secondsOutgoing = event["seconds"] as int;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallConnectFailure") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = false;
            minutesOutgoing = 0;
            secondsOutgoing = 0;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnecting") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = true;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnected") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = true;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallCallQualityWarningsChanged") {
        if (mounted) {
          setState(() {
            // callInProgressOutgoing = true;
          });
        }
      }
    });

    streamSubscriptionIncomingEvent =
        DashboardView.incomingEvent.on().listen((event) {
      if (event != null && event["incomingEvent"] == "incomingRinging") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingDisconnected") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingConnected") {
        if (mounted) {
          setState(() {
            minutesIncoming = event["minutes"] as int;
            secondsIncoming = event["seconds"] as int;
          });
        }
      } else if (event != null &&
          event["incomingEvent"] == "incomingConnectFailure") {
        if (mounted) {
          setState(() {
            minutesIncoming = 0;
            secondsIncoming = 0;
          });
        }
      } else if (event != null &&
          event["incomingEvent"] == "incomingReconnecting") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingReconnected") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingCallQualityWarningsChanged") {}
    });
  }

  void doCheckConnection() {
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
        setState(() {});
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        setState(() {});
      }
    });
  }

  /// upper first and after send end cursor  and change end cursor only update has next
  /// lower last and before send start cursor  and change start cursor only update has previous

  @override
  void dispose() {
    streamSubscriptionUpdateMemberChatDetail = null;
    textEditingControllerMessage.dispose();
    streamSubscriptionOnNetworkChanged?.cancel();
    animationController?.dispose();
    _scrollController?.dispose();

    streamSubscriptionIncomingEvent?.cancel();
    streamSubscriptionOutgoingEvent?.cancel();

    super.dispose();
  }

  Future<bool> _requestPop() {
    animationController?.reverse().then<dynamic>((void data) {
      if (!mounted) {
        Utils.cPrint(" i am here ");
        return Future<bool>.value(false);
      } else {
        Utils.cPrint(" i was here ");
        Navigator.pop(context, {"data": true, "type": ""});
        return Future<bool>.value(true);
      }
    });
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.bottomAppBarColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ChangeNotifierProvider<MemberMessageDetailsProvider>(
            lazy: false,
            create: (BuildContext context) {
              memberMessageDetailsProvider?.doConversationDetailByMemberApiCall(
                widget.clientId,
              );
              return memberMessageDetailsProvider!;
            },
            child: Consumer<MemberMessageDetailsProvider>(
              builder: (BuildContext? context,
                  MemberMessageDetailsProvider? provider, Widget? child) {
                return OverlappingPanelsRight(
                  right: Builder(builder: (context) {
                    return MemberMessageDetailSliderMenuWidget(
                      onlineStatus: widget.onlineStatus,
                      clientEmail: widget.clientEmail,
                      onTapSearchConversation: () async {
                        final returnData = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.space16.r),
                          ),
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return MemberConversationSearchView(
                              clientName: widget.clientName,
                              clientId: widget.clientId,
                              animationController: animationController!,
                              memberId: widget.clientId,
                            );
                          },
                        );
                        if (returnData != null &&
                            returnData["data"] is bool &&
                            returnData["data"] as bool) {
                          if (mounted) {
                            OverlappingPanelsRight.of(context)
                                ?.reveal(RevealSide.main);
                            FocusScope.of(context).unfocus();
                          }

                          searchList = returnData["list"]
                              as List<RecentConversationMemberEdge>;
                          searchQuery = returnData["query"] as String;
                          setState(() {});
                          memberMessageDetailsProvider
                              ?.doSearchConversationWithCursorApiCall(
                            widget.clientId,
                          )
                              .then((value) async {
                            isSearching = true;
                            selectedSearchItem = searchList[
                                searchList.indexWhere((element) =>
                                    element.cursor ==
                                    returnData["cursor"] as String)];
                            selectedSearchItemIndex = searchList.indexWhere(
                                (element) =>
                                    element.cursor ==
                                    returnData["cursor"] as String);
                            setState(() {});
                            toSearchItemIndex =
                                (await memberMessageDetailsProvider
                                    ?.getSearchIndex(
                                        selectedSearchItem!, widget.clientId))!;

                            setState(() {});
                            Utils.cPrint(toSearchItemIndex.toString());
                            _debounce.run(() async {
                              await _scrollController?.scrollToIndex(
                                toSearchItemIndex,
                                duration: const Duration(milliseconds: 1),
                                preferPosition: AutoScrollPosition.end,
                              );
                            });
                          });
                        }
                      },
                      clientId: contactId!,
                      clientName: widget.clientName,
                      clientProfilePicture: widget.clientProfilePicture.trim(),
                    );
                  }),
                  main: Builder(
                    builder: (context) {
                      return Consumer<DashboardProvider>(
                        builder: (context, data, _) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                color: CustomColors.bottomAppBarColor,
                                height: double.maxFinite,
                                width: double.maxFinite,
                                margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  internetConnectionStatus ==
                                          InternetConnectionStatus.connected
                                      ? (data.outgoingIsCallConnected ||
                                              data.incomingIsCallConnected)
                                          ? (kToolbarHeight * 2).h
                                          : kToolbarHeight.h
                                      : (data.outgoingIsCallConnected ||
                                              data.incomingIsCallConnected)
                                          ? (kToolbarHeight * 2).h +
                                              Dimens.space26.h
                                          : kToolbarHeight.h + Dimens.space26.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                ),
                                padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isSearching
                                            ? Container(
                                                alignment: Alignment.topCenter,
                                                padding: EdgeInsets.fromLTRB(
                                                  Dimens.space16.w,
                                                  Dimens.space8.h,
                                                  Dimens.space16.w,
                                                  Dimens.space8.h,
                                                ),
                                                margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                ),
                                                color: CustomColors
                                                    .bottomAppBarColor,
                                                height: Dimens.space40.h,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                          Dimens.space0.w,
                                                          Dimens.space0.h,
                                                          Dimens.space0.w,
                                                          Dimens.space0.h,
                                                        ),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                          Dimens.space0.w,
                                                          Dimens.space0.h,
                                                          Dimens.space0.w,
                                                          Dimens.space0.h,
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          Config.checkOverFlow
                                                              ? Const.OVERFLOW
                                                              : searchQuery,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: CustomColors
                                                                .mainColor,
                                                            fontFamily: Config
                                                                .manropeSemiBold,
                                                            fontSize: Dimens
                                                                .space14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                      ),
                                                      child: Text(
                                                        Config.checkOverFlow
                                                            ? Const.OVERFLOW
                                                            : "${selectedSearchItemIndex + 1}/${searchList.length}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .mainColor,
                                                          fontFamily: Config
                                                              .manropeSemiBold,
                                                          fontSize:
                                                              Dimens.space14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.space20.w,
                                                      height: Dimens.space1.h,
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                      width: Dimens.space20,
                                                      height: Dimens.space20,
                                                      iconUrl: CustomIcon
                                                          .icon_arrow_down,
                                                      iconColor: CustomColors
                                                          .mainColor,
                                                      iconSize: Dimens.space20,
                                                      boxDecorationColor:
                                                          CustomColors
                                                              .transparent,
                                                      outerCorner:
                                                          Dimens.space0,
                                                      innerCorner:
                                                          Dimens.space0,
                                                      imageUrl: "",
                                                      onTap: () async {
                                                        if (selectedSearchItemIndex -
                                                                1 <
                                                            0) {
                                                        } else {
                                                          selectedSearchItem =
                                                              searchList[
                                                                  selectedSearchItemIndex -
                                                                      1];
                                                          selectedSearchItemIndex =
                                                              selectedSearchItemIndex -
                                                                  1;
                                                          setState(() {});
                                                          toSearchItemIndex =
                                                              (await memberMessageDetailsProvider
                                                                  ?.getSearchIndex(
                                                                      selectedSearchItem!,
                                                                      widget
                                                                          .clientId))!;

                                                          setState(() {});
                                                          _debounce
                                                              .run(() async {
                                                            await _scrollController
                                                                ?.scrollToIndex(
                                                              toSearchItemIndex,
                                                              preferPosition:
                                                                  AutoScrollPosition
                                                                      .end,
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.space10.w,
                                                      height: Dimens.space1.h,
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                      width: Dimens.space20,
                                                      height: Dimens.space20,
                                                      iconUrl: CustomIcon
                                                          .icon_arrow_up,
                                                      iconColor: CustomColors
                                                          .mainColor,
                                                      iconSize: Dimens.space20,
                                                      boxDecorationColor:
                                                          CustomColors
                                                              .transparent,
                                                      outerCorner:
                                                          Dimens.space0,
                                                      innerCorner:
                                                          Dimens.space0,
                                                      imageUrl: "",
                                                      onTap: () async {
                                                        if (selectedSearchItemIndex +
                                                                1 >=
                                                            searchList.length) {
                                                          Utils.cPrint(
                                                              selectedSearchItemIndex
                                                                  .toString());
                                                          Utils.cPrint(
                                                              searchList.length
                                                                  .toString());
                                                        } else {
                                                          selectedSearchItem =
                                                              searchList[
                                                                  selectedSearchItemIndex +
                                                                      1];
                                                          selectedSearchItemIndex =
                                                              selectedSearchItemIndex +
                                                                  1;
                                                          setState(() {});
                                                          toSearchItemIndex =
                                                              (await memberMessageDetailsProvider
                                                                  ?.getSearchIndex(
                                                            selectedSearchItem!,
                                                            widget.clientId,
                                                          ))!;

                                                          setState(() {});
                                                          _debounce
                                                              .run(() async {
                                                            await _scrollController
                                                                ?.scrollToIndex(
                                                              toSearchItemIndex,
                                                              preferPosition:
                                                                  AutoScrollPosition
                                                                      .end,
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.space25.w,
                                                      height: Dimens.space1.h,
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                      width: Dimens.space20,
                                                      height: Dimens.space20,
                                                      iconUrl:
                                                          CustomIcon.icon_close,
                                                      iconColor: CustomColors
                                                          .callDeclineColor,
                                                      iconSize: Dimens.space10,
                                                      boxDecorationColor:
                                                          CustomColors
                                                              .transparent,
                                                      outerCorner:
                                                          Dimens.space0,
                                                      innerCorner:
                                                          Dimens.space0,
                                                      imageUrl: "",
                                                      onTap: () {
                                                        isSearching = false;
                                                        searchQuery = "";
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                            ),
                                            color: CustomColors.white,
                                            child: buildListMessage(
                                                memberMessageDetailsProvider!
                                                    .listMemberConversationDetails!
                                                    .data),
                                          ),
                                        ),
                                        // Input content
                                        Divider(
                                          color: CustomColors.mainDividerColor,
                                          height: Dimens.space1.h,
                                          thickness: Dimens.space1.h,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0,
                                              Dimens.space0,
                                              Dimens.space0,
                                              Dimens.space0.h),
                                          color: CustomColors.white,
                                          child:
                                              MemberChatTextFieldWidgetWithIcon(
                                            isFromMemberChatScreen: true,
                                            listConversationEdge:
                                                memberMessageDetailsProvider!
                                                    .listMemberConversationDetails!
                                                    .data,
                                            animationController:
                                                animationController!,
                                            textEditingController:
                                                textEditingControllerMessage,
                                            customIcon:
                                                CustomIcon.icon_message_send,
                                            isSendIconVisible:
                                                isSendIconVisible,
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  isSendIconVisible = true;
                                                });
                                              } else {
                                                setState(() {
                                                  isSendIconVisible = false;
                                                });
                                              }
                                            },
                                            onSendTap: () async {
                                              if (textEditingControllerMessage
                                                  .text.isNotEmpty) {
                                                final String dump =
                                                    textEditingControllerMessage
                                                        .text;
                                                textEditingControllerMessage
                                                    .clear();
                                                isSendIconVisible = false;
                                                setState(() {});
                                                memberMessageDetailsProvider
                                                    ?.doSendChatMessageApiCall(
                                                  dump,
                                                  widget.clientId,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: Dimens.space20.w,
                                      bottom: Dimens.space80.h,
                                      child: shouldScrollDown
                                          ? Container(
                                              height: Dimens.space43.w,
                                              width: Dimens.space43.w,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: CustomColors
                                                    .bottomAppBarColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space300.r),
                                                ),
                                                border: Border.all(
                                                  color:
                                                      CustomColors.transparent!,
                                                  width: Dimens.space0.r,
                                                ),
                                              ),
                                              child: RoundedNetworkImageHolder(
                                                width: Dimens.space40,
                                                height: Dimens.space40,
                                                boxFit: BoxFit.contain,
                                                iconUrl: Icons
                                                    .arrow_downward_rounded,
                                                iconColor: CustomColors
                                                    .textSenaryColor,
                                                iconSize: Dimens.space20,
                                                boxDecorationColor:
                                                    CustomColors.white,
                                                outerCorner: Dimens.space300,
                                                innerCorner: Dimens.space0,
                                                imageUrl: "",
                                                onTap: () async {
                                                  await _scrollController
                                                      ?.scrollToIndex(
                                                    0,
                                                    preferPosition:
                                                        AutoScrollPosition.end,
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    Positioned(
                                      right: Dimens.space30.w,
                                      bottom: Dimens.space110.h,
                                      child: shouldScrollDown && subCount != 0
                                          ? Container(
                                              height: Dimens.space20.w,
                                              width: Dimens.space20.w,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: CustomColors
                                                    .callDeclineColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      Dimens.space8.r),
                                                  bottomLeft: Radius.circular(
                                                      Dimens.space8.r),
                                                  bottomRight: Radius.circular(
                                                      Dimens.space8.r),
                                                  topRight: Radius.circular(
                                                      Dimens.space8.r),
                                                ),
                                              ),
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : subCount > 9
                                                        ? "9+"
                                                        : subCount.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.copyWith(
                                                      fontFamily:
                                                          Config.manropeBold,
                                                      fontSize:
                                                          Dimens.space11.sp,
                                                      color: CustomColors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                width: double.infinity,
                                color: CustomColors.white,
                                height: internetConnectionStatus ==
                                        InternetConnectionStatus.connected
                                    ? (data.outgoingIsCallConnected ||
                                            data.incomingIsCallConnected)
                                        ? (kToolbarHeight * 2).h
                                        : kToolbarHeight.h
                                    : (data.outgoingIsCallConnected ||
                                            data.incomingIsCallConnected)
                                        ? (kToolbarHeight * 2).h +
                                            Dimens.space26.h
                                        : kToolbarHeight.h + Dimens.space26.h,
                                padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customViewNoInternet(),
                                    Offstage(
                                      offstage: !data.outgoingIsCallConnected,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space10.w,
                                              Dimens.space0.h,
                                              Dimens.space10.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.callOnProgressColor,
                                          alignment: Alignment.center,
                                          shape: const RoundedRectangleBorder(),
                                        ),
                                        onPressed: () {
                                          widget.onOutgoingTap();
                                        },
                                        child: Container(
                                          height: kToolbarHeight.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            Config.checkOverFlow
                                                ? Const.OVERFLOW
                                                : "${Utils.getString("touchToReturnCall")} ${minutesOutgoing.toString().padLeft(2, "0")}:${secondsOutgoing.toString().padLeft(2, "0")}",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: CustomColors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily:
                                                      Config.heeboMedium,
                                                  fontSize: Dimens.space14.sp,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Offstage(
                                      offstage: !data.incomingIsCallConnected,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space10.w,
                                              Dimens.space0.h,
                                              Dimens.space10.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.callOnProgressColor,
                                          alignment: Alignment.center,
                                          shape: const RoundedRectangleBorder(),
                                        ),
                                        onPressed: () {
                                          widget.onIncomingTap();
                                        },
                                        child: Container(
                                          height: kToolbarHeight.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            Config.checkOverFlow
                                                ? Const.OVERFLOW
                                                : "${Utils.getString("touchToReturnCall")} ${minutesIncoming.toString().padLeft(2, "0")}:${secondsIncoming.toString().padLeft(2, "0")}",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: CustomColors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily:
                                                      Config.heeboMedium,
                                                  fontSize: Dimens.space14.sp,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      width: double.infinity,
                                      color: CustomColors.white,
                                      height: kToolbarHeight.h,
                                      padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: kToolbarHeight.h,
                                            height: kToolbarHeight.h,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  CustomColors.white!,
                                                  CustomColors.white!,
                                                  CustomColors
                                                      .bottomAppBarColor!,
                                                ],
                                              ),
                                            ),
                                            child: RoundedNetworkImageHolder(
                                              width: kToolbarHeight.h,
                                              height: kToolbarHeight.h,
                                              iconUrl:
                                                  CustomIcon.icon_arrow_left,
                                              iconColor: CustomColors
                                                  .loadingCircleColor,
                                              iconSize: Dimens.space24,
                                              boxDecorationColor:
                                                  CustomColors.transparent,
                                              outerCorner: Dimens.space0,
                                              innerCorner: Dimens.space0,
                                              imageUrl: "",
                                              onTap: () {
                                                _requestPop();
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: kToolbarHeight.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    CustomColors.white!,
                                                    CustomColors.white!,
                                                    CustomColors
                                                        .bottomAppBarColor!,
                                                  ],
                                                ),
                                              ),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: kToolbarHeight.h,
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: ImageAndTextWidget(
                                                  onlineStatus:
                                                      widget.onlineStatus,
                                                  clientName: widget.clientName,
                                                  clientProfilePicture: widget
                                                      .clientProfilePicture
                                                      .trim(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: kToolbarHeight.h,
                                            height: kToolbarHeight.h,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  CustomColors.white!,
                                                  CustomColors.white!,
                                                  CustomColors
                                                      .bottomAppBarColor!,
                                                ],
                                              ),
                                            ),
                                            child: RoundedNetworkImageHolder(
                                              width: kToolbarHeight.h,
                                              height: kToolbarHeight.h,
                                              iconUrl:
                                                  CustomIcon.icon_more_vertical,
                                              iconColor: CustomColors.mainColor,
                                              iconSize: Dimens.space24,
                                              boxDecorationColor:
                                                  CustomColors.transparent,
                                              outerCorner: Dimens.space0,
                                              innerCorner: Dimens.space0,
                                              imageUrl: "",
                                              onTap: () {
                                                if (isOpen) {
                                                  OverlappingPanelsRight.of(
                                                          context)
                                                      ?.reveal(RevealSide.main);
                                                } else {
                                                  OverlappingPanelsRight.of(
                                                          context)
                                                      ?.reveal(
                                                          RevealSide.right);
                                                }
                                                isOpen = !isOpen;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onSideChange: (side) {
                    if (side == RevealSide.main) {
                      isOpen = false;
                    } else {
                      isOpen = true;
                    }
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListMessage(
      List<MemberMessageDetailsObjectWithType>? listConversationEdge) {
    if (listConversationEdge != null) {
      final List<MemberMessageDetailsObjectWithType> tempList =
          listConversationEdge.reversed.toList();
      return Container(
        alignment: Alignment.bottomCenter,
        color: CustomColors.white,
        margin: EdgeInsets.fromLTRB(
          Dimens.space16.w,
          Dimens.space0.h,
          Dimens.space16.w,
          Dimens.space10.h,
        ),
        padding: EdgeInsets.fromLTRB(
          Dimens.space0.w,
          Dimens.space0.h,
          Dimens.space0.w,
          Dimens.space0.h,
        ),
        child: SmartRefresher(
          enablePullUp: true,
          header: CustomHeader(
            height: Dimens.space25.h,
            builder: (BuildContext? context, RefreshStatus? mode) {
              Widget body;
              if (mode == RefreshStatus.idle) {
                body = Container();
              } else if (mode == RefreshStatus.refreshing) {
                body = Container(
                  height: Dimens.space20.h,
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(
                    backgroundColor: CustomColors.white,
                    color: CustomColors.mainColor,
                  ),
                );
              } else if (mode == RefreshStatus.failed) {
                body = Container();
              } else if (mode == RefreshStatus.canRefresh) {
                body = Container();
              } else {
                body = Container();
              }
              return body;
            },
          ),
          footer: CustomFooter(
            height: Dimens.space5.h,
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Container();
              } else if (mode == LoadStatus.loading) {
                body = Container(
                  alignment: Alignment.center,
                  child: LinearProgressIndicator(
                    backgroundColor: CustomColors.white,
                    color: CustomColors.mainColor,
                  ),
                );
              } else if (mode == LoadStatus.failed) {
                body = Container();
              } else if (mode == LoadStatus.canLoading) {
                body = Container();
              } else {
                body = Container();
              }
              return body;
            },
          ),
          controller: _refreshController,
          onRefresh: _onLoading,
          onLoading: _onRefresh,
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: tempList.length,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            itemBuilder: (context, index) {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: _scrollController!,
                index: index,
                highlightColor: CustomColors.transparent,
                child: VisibilityDetector(
                  key: Key(index.toString()),
                  onVisibilityChanged: (visibilityInfo) {
                    if (index > 15) {
                      shouldScrollDown = true;
                    } else {
                      shouldScrollDown = false;
                    }
                    if (index == 0) {
                      subCount = 0;
                    }
                    setState(() {});
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool hasNextPage = memberMessageDetailsProvider!
                          .pageInfo!.data!.hasNextPage!;
                      if (tempList[index].type == "time") {
                        return Column(
                          children: [
                            if (memberMessageDetailsProvider?.pageInfo !=
                                    null &&
                                memberMessageDetailsProvider?.pageInfo?.data !=
                                    null &&
                                memberMessageDetailsProvider
                                        ?.pageInfo?.data?.hasNextPage !=
                                    null &&
                                !hasNextPage &&
                                index == tempList.length - 1)
                              Container(
                                color: CustomColors.white,
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space36.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                ),
                                padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                ),
                                child: EmptyConversationWidget(
                                  title: widget.clientName,
                                  message: Utils.getString("beginningMessage"),
                                  imageUrl: widget.clientProfilePicture.trim(),
                                ),
                              )
                            else
                              Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Dimens.space5.w),
                                          topRight:
                                              Radius.circular(Dimens.space5.w),
                                          bottomLeft:
                                              Radius.circular(Dimens.space5.w),
                                          bottomRight:
                                              Radius.circular(Dimens.space5.w),
                                        ),
                                        color: CustomColors.bottomAppBarColor,
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space12.w,
                                          Dimens.space6.h,
                                          Dimens.space12.w,
                                          Dimens.space6.h),
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          internetConnectionStatus !=
                                                  InternetConnectionStatus
                                                      .connected
                                              ? Dimens.space25.h
                                              : Dimens.space16.h,
                                          Dimens.space0.w,
                                          Dimens.space5.h),
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : Utils.convertDateTime(
                                                tempList[index]
                                                    .time!
                                                    .split("T")[0],
                                                DateFormat("yyyy-MM-dd")),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: CustomColors.mainColor,
                                          fontFamily: Config.heeboRegular,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        if (tempList[index]
                                    .edges
                                    ?.recentConversationMemberNodes
                                    ?.sender !=
                                null &&
                            tempList[index]
                                    .edges
                                    ?.recentConversationMemberNodes
                                    ?.sender
                                    ?.id !=
                                memberMessageDetailsProvider?.getMemberId()) {
                          return IncomingMessageView(
                            conversationEdge: tempList[index].edges!,
                            query: searchQuery,
                            isSearching: isSearching,
                          );
                        } else {
                          return OutBoundListHandlerView(
                            query: searchQuery,
                            conversationEdge: tempList[index].edges!,
                            isSearching: isSearching,
                            onResendTap: () async {
                              if (textEditingControllerMessage
                                  .text.isNotEmpty) {
                                final Resources<Messages> response =
                                    await memberMessageDetailsProvider!
                                        .doSendChatMessageApiCall(
                                            tempList[index]
                                                .edges!
                                                .recentConversationMemberNodes!
                                                .message!,
                                            widget.clientId) as Resources<
                                        Messages>;
                                if (response.data != null) {
                                  textEditingControllerMessage.clear();
                                }
                              }
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      animationController?.forward();
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: animationController!,
              curve:
                  const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
      return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext? context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: Container(
                color: CustomColors.white,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Dimens.space0.w,
                  Dimens.space36.h,
                  Dimens.space0.w,
                  Dimens.space0.h,
                ),
                padding: EdgeInsets.fromLTRB(
                  Dimens.space0.w,
                  Dimens.space0.h,
                  Dimens.space0.w,
                  Dimens.space0.h,
                ),
                child: EmptyConversationWidget(
                  title: widget.clientName,
                  message: Utils.getString("beginningMessage"),
                  imageUrl: widget.clientProfilePicture.trim(),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> doSubscriptionUpdate() async {
    streamSubscriptionUpdateMemberChatDetail ??=
        await memberMessageDetailsProvider?.doSubscriptionWorkspaceChatDetail();
    if (streamSubscriptionUpdateMemberChatDetail != null) {
      streamSubscriptionUpdateMemberChatDetail?.listen((event) async {
        if (event.data != null) {
          final RecentConversationMemberNodes recentConversationMemberNodes =
              RecentConversationMemberNodes()
                  .fromMap(event.data?["workspaceChat"]["message"])!;
          Utils.cPrint(event.data!["workspaceChat"].toString());
          if ((recentConversationMemberNodes.sender?.id ==
                      memberMessageDetailsProvider?.getMemberId() &&
                  recentConversationMemberNodes.receiver?.id ==
                      widget.clientId) ||
              (recentConversationMemberNodes.sender?.id == widget.clientId &&
                  recentConversationMemberNodes.receiver?.id ==
                      memberMessageDetailsProvider?.getMemberId())) {
            if (!mounted) return;
            subCount += 1;
            setState(() {});
            memberMessageDetailsProvider
                ?.updateSubscriptionMemberChatConversationDetail(
              memberMessageDetailsProvider!.getMemberId(),
              widget.clientId,
              recentConversationMemberNodes,
              isSearching,
            );
          }
        }
      });
    }
  }
}

/*----------------------------------------------------------------------------------------------------------------*/

// ToolBar Widget
class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.clientName,
    required this.clientProfilePicture,
    required this.onlineStatus,
  }) : super(key: key);

  final String clientName;
  final String clientProfilePicture;
  final bool onlineStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      height: kToolbarHeight.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Dimens.space40.w,
            height: Dimens.space40.w,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: RoundedNetworkImageHolder(
              width: Dimens.space40,
              height: Dimens.space40,
              containerAlignment: Alignment.bottomCenter,
              iconUrl: CustomIcon.icon_profile,
              iconColor: CustomColors.callInactiveColor,
              iconSize: Dimens.space34,
              boxDecorationColor: CustomColors.mainDividerColor,
              outerCorner: Dimens.space14,
              innerCorner: Dimens.space14,
              imageUrl: clientProfilePicture != null
                  ? clientProfilePicture.trim()
                  : "",
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : clientName,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                  if (onlineStatus)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (onlineStatus)
                          Container(
                            width: Dimens.space10.w,
                            height: Dimens.space10.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: CustomColors.callAcceptColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                          )
                        else
                          Container(),
                        SizedBox(
                          width: Dimens.space6.w,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : onlineStatus
                                      ? Utils.getString("activeNow")
                                      : "",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space13.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*----------------------------------------------------------------------------------------------------------------*/
