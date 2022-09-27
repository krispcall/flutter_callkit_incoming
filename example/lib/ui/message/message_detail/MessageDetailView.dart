import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:graphql/client.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:libphonenumber_plugin/libphonenumber_plugin.dart";
import "package:mvp/BaseStatefulState.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/macros/MacrosProvider.dart";
import "package:mvp/provider/messages/MessageDetailsProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/MacrosRepository.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/ui/common/ChatTextFiledWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/dialog/ChannelSelectionDialog.dart";
import "package:mvp/ui/common/dialog/CustomOverlayToastWidget.dart";
import "package:mvp/ui/common/dialog/DndMuteDialog.dart";
import "package:mvp/ui/common/dialog/DndUnMuteDialog.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/discord/OverlappingPanelsRight.dart";
import "package:mvp/ui/macros/MacrosListView.dart";
import "package:mvp/ui/message/conversation_search/MessageConversationSearchView.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/ui/message/message_detail/MessageDetailSideMenuWidget.dart";
import "package:mvp/ui/message/message_detail/widgets/CallFailedView.dart";
import "package:mvp/ui/message/message_detail/widgets/EmptyConversationWidget.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingCallDeclinedView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingCallInProgress.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingCallMissedView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingCallView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingMessageView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingRecordingView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingRingingView.dart";
import "package:mvp/ui/message/message_detail/widgets/IncomingVoicemailView.dart";
import "package:mvp/ui/message/message_detail/widgets/NotSendMessageView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutGoingCallView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutGoingCallingView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutGoingInProgressView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutGoingMessageView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutGoingRingingView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutgoingCallBusyView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutgoingCallCanceledView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutgoingCallNoAnswerView.dart";
import "package:mvp/ui/message/message_detail/widgets/OutgoingRecordingView.dart";
import "package:mvp/ui/message/message_detail/widgets/PendingMessageView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddContactIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddNotesIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/clientDndResponse/ClientDndResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/getWorkspaceCredit/WorkspaceCredit.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:mvp/viewObject/model/sendMessage/Messages.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:scroll_to_index/scroll_to_index.dart";
import "package:visibility_detector/visibility_detector.dart";

class MessageDetailView extends StatefulWidget {
  const MessageDetailView({
    Key? key,
    this.clientId,
    required this.clientPhoneNumber,
    required this.clientName,
    this.clientProfilePicture,
    required this.lastChatted,
    required this.channelId,
    required this.channelName,
    required this.channelNumber,
    required this.countryId,
    required this.isBlocked,
    // required this.dndMissed,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    required this.onContactBlocked,
  }) : super(key: key);

  final String? clientId;
  final String? clientPhoneNumber;
  final String? clientName;
  final String? clientProfilePicture;
  final String? channelId;
  final String? channelName;
  final String? channelNumber;
  final String? countryId;
  final String? lastChatted;
  final bool? isBlocked;

  // final bool dndMissed;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function(String?, String?, String?, String?, String?, String?, String?,
      String?, String?, String?)? makeCallWithSid;
  final Function(bool)? onContactBlocked;

  @override
  MessageDetailState createState() => MessageDetailState();
}

class MessageDetailState extends BaseStatefulState<MessageDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  AutoScrollController? _scrollController;

  MessageDetailsProvider? messagesProvider;
  MessageDetailsRepository? messagesRepository;

  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;

  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  MacrosRepository? macrosRepository;
  MacrosProvider? macrosProvider;

  ValueHolder? valueHolder;
  bool isBlocked = false;

  bool isSendIconVisible = false;

  final TextEditingController textEditingControllerMessage =
      TextEditingController();
  final FocusNode focusNode = FocusNode();
  String contactId = "";
  String? contactNumber;
  bool blockUpdate = false;
  bool updateAudioplayer = false;

  Stream<QueryResult>? streamSubscriptionCallLogs;
  StreamSubscription? streamSubscriptionOnNetworkChanged;
  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;

  bool isOpen = false;

  final RefreshController _refreshController = RefreshController();

  final _debounce = DeBouncer(milliseconds: 500);

  bool isSearching = false;

  bool shouldScrollDown = false;

  List<RecentConversationEdges> searchList = [];

  String searchQuery = "";

  RecentConversationEdges? selectedSearchItem;

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
    try {
      if (messagesProvider!.pageInfo!.data!.hasPreviousPage!) {
        stopAllPlay();
        final List<MessageDetailsObjectWithType> dump =
            messagesProvider!.listConversationDetails!.data!;
        dump.removeWhere((element) => element.type?.toLowerCase() == "time");
        Utils.cPrint(dump.length.toString());
        final int apiDataLength = dump.length;
        await messagesProvider!
            .doMessageChatListLowerApiCall(
          widget.channelId,
          widget.clientPhoneNumber!,
          apiDataLength,
        )
            .then((value) async {
          if (value.isNotEmpty) {
            setState(() {});
            try {
              await _scrollController!.scrollToIndex(
                messagesProvider!.lengthDiff!.data!,
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
    } catch (e) {
      Utils.cPrint(e.toString());
    }
  }

  Future<void> _onRefresh() async {
    if (messagesProvider!.pageInfo!.data != null &&
        messagesProvider!.pageInfo!.data!.hasNextPage!) {
      stopAllPlay();
      Utils.cPrint("On Refresh");
      await messagesProvider!.doMessageChatListUpperApiCall(
          widget.channelId, widget.clientPhoneNumber!);
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

    isBlocked = widget.isBlocked!;
    contactId = widget.clientId ?? "";
    contactNumber = widget.clientPhoneNumber;

    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    messagesRepository =
        Provider.of<MessageDetailsRepository>(context, listen: false);
    messagesProvider =
        MessageDetailsProvider(messageDetailsRepository: messagesRepository);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(contactRepository: contactRepository);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    loginWorkspaceProvider = LoginWorkspaceProvider(
      loginWorkspaceRepository: loginWorkspaceRepository,
      valueHolder: valueHolder,
    );
    macrosRepository = Provider.of<MacrosRepository>(context, listen: false);

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
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
        // if (mounted) {
        //   setState(() {
        //     // callInProgressOutgoing = true;
        //   });
        // }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallCallQualityWarningsChanged") {
        // if (mounted) {
        //   setState(() {
        //     callInProgressOutgoing = true;
        //   });
        // }
      }
    });

    streamSubscriptionIncomingEvent =
        DashboardView.incomingEvent.on().listen((event) {
      if (event != null && event["incomingEvent"] == "incomingRinging") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingDisconnected") {
        if (mounted) {
          setState(() {
            minutesIncoming = 0;
            secondsIncoming = 0;
          });
        }
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
        if (mounted) {
          setState(() {
            // callInProgressIncoming = true;
          });
        }
      } else if (event != null &&
          event["incomingEvent"] == "incomingCallQualityWarningsChanged") {
        if (mounted) {
          setState(() {
            // callInProgressIncoming = true;
          });
        }
      }
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

  @override
  void dispose() {
    streamSubscriptionCallLogs = null;
    textEditingControllerMessage.dispose();
    streamSubscriptionOnNetworkChanged!.cancel();
    animationController!.dispose();
    _scrollController!.dispose();

    streamSubscriptionIncomingEvent!.cancel();
    streamSubscriptionOutgoingEvent!.cancel();

    super.dispose();
  }

  Future<bool> _requestPop() {
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        if (blockUpdate) {
          Navigator.pop(context, {"data": true, "type": "blockDelete"});
          return Future<bool>.value(true);
        } else {
          Navigator.pop(context, {"data": true, "type": ""});
          return Future<bool>.value(true);
        }
      },
    );
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
            child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ContactsProvider>(
              lazy: false,
              create: (BuildContext context) {
                contactsProvider = ContactsProvider(
                  contactRepository: contactRepository,
                );
                contactsProvider!
                    .doContactDetailByNumberApiCall(widget.clientPhoneNumber)
                    .then((data) {
                  if (contactsProvider!.contactDetailResponse != null &&
                      contactsProvider!.contactDetailResponse?.data != null &&
                      contactsProvider!.contactDetailResponse?.data!.id !=
                          null) {
                    contactId =
                        contactsProvider!.contactDetailResponse?.data!.id ?? "";
                    isBlocked =
                        contactsProvider!.contactDetailResponse!.data!.blocked!;
                  }
                  setState(() {});
                });
                contactsProvider!
                    .doGetLastContactedApiCall(
                        Map.from({"contact": widget.clientPhoneNumber}))
                    .then((value) {
                  setState(() {});
                });
                contactsProvider!
                    .doGetAllNotesApiCall(ContactPinUnpinRequestHolder(
                  channel: widget.channelId,
                  contact: widget.clientPhoneNumber,
                  pinned: false,
                ));
                return contactsProvider!;
              },
            ),
            ChangeNotifierProvider<MessageDetailsProvider>(
              lazy: false,
              create: (BuildContext context) {
                messagesProvider = MessageDetailsProvider(
                  messageDetailsRepository: messagesRepository,
                );
                messagesProvider!.doConversationDetailByContactApiCall(
                  widget.channelId,
                  widget.clientPhoneNumber,
                );
                messagesProvider!.doConversationSeenApiCall(
                  widget.channelId,
                  widget.clientPhoneNumber,
                );
                return messagesProvider!;
              },
            ),
            ChangeNotifierProvider<CountryListProvider>(
              lazy: false,
              create: (BuildContext context) {
                countryListProvider = CountryListProvider(
                  countryListRepository: countryRepository,
                );
                return countryListProvider!;
              },
            ),
            ChangeNotifierProvider<LoginWorkspaceProvider>(
              lazy: false,
              create: (BuildContext context) {
                loginWorkspaceProvider = LoginWorkspaceProvider(
                  loginWorkspaceRepository: loginWorkspaceRepository,
                  valueHolder: valueHolder,
                );
                return loginWorkspaceProvider!;
              },
            ),
            ChangeNotifierProvider<MacrosProvider>(
              lazy: false,
              create: (BuildContext context) {
                macrosProvider = MacrosProvider(
                  repository: macrosRepository!,
                );
                macrosProvider!.getMacros();
                return macrosProvider!;
              },
            ),
          ],
          child: Consumer5<ContactsProvider, MessageDetailsProvider,
              CountryListProvider, LoginWorkspaceProvider, MacrosProvider>(
            builder: (BuildContext? context,
                ContactsProvider? provider1,
                MessageDetailsProvider? provider2,
                CountryListProvider? provider3,
                LoginWorkspaceProvider? provider4,
                MacrosProvider? provider5,
                Widget? child) {
              return OverlappingPanelsRight(
                right: Builder(builder: (context) {
                  return MessageDetailSliderMenuWidget(
                    countryId: widget.countryId,
                    onIncomingTap: () {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap();
                    },
                    // dndMissed: widget.dndMissed,
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
                      widget.makeCallWithSid!(
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
                    isBlocked: isBlocked,
                    clientId: contactsProvider!.contactDetailResponse != null
                        ? (contactsProvider!.contactDetailResponse?.data !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data !=
                                    null &&
                                contactsProvider
                                        ?.contactDetailResponse?.data?.id !=
                                    null
                            ? contactsProvider!.contactDetailResponse!.data!.id!
                            : contactId)
                        : contactId,
                    clientName: contactsProvider!.contactDetailResponse != null
                        ? (contactsProvider!.contactDetailResponse!.data !=
                                    null &&
                                contactsProvider!.contactDetailResponse!.data !=
                                    null &&
                                contactsProvider!
                                        .contactDetailResponse!.data!.name !=
                                    null
                            ? contactsProvider!
                                .contactDetailResponse!.data!.name!
                            : widget.clientName)!
                        : widget.clientPhoneNumber!,
                    clientPhoneNumber: widget.clientPhoneNumber!,
                    onAddContactTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                        context,
                        RoutePaths.newContact,
                        arguments: AddContactIntentHolder(
                          phoneNumber: widget.clientPhoneNumber,
                          defaultCountryCode: await countryListProvider
                              ?.getCountryByIso(widget.clientPhoneNumber!),
                          onIncomingTap: () {
                            widget.onIncomingTap();
                          },
                          onOutgoingTap: () {
                            widget.onOutgoingTap();
                          },
                        ),
                      );
                      if (returnData != null &&
                          returnData["data"] is bool &&
                          returnData["data"] as bool) {
                        contactsProvider
                            ?.doContactDetailApiCall(
                                returnData["clientId"] as String)
                            .then((value) {
                          setState(() {
                            contactId = returnData["clientId"] == null
                                ? ""
                                : returnData["clientId"] as String;
                          });
                        });
                      }
                    },
                    onTapSearchConversation: () async {
                      _scrollController!.jumpTo(
                        0,
                      );
                      final returnData = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space16.r),
                        ),
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return MessageConversationSearchView(
                            channelId: widget.channelId,
                            channelName: widget.channelName,
                            channelNumber: widget.channelNumber,
                            contactNumber:
                                contactsProvider?.contactDetailResponse != null
                                    ? (contactsProvider?.contactDetailResponse
                                                    ?.data !=
                                                null &&
                                            contactsProvider
                                                    ?.contactDetailResponse
                                                    ?.data !=
                                                null
                                        ? contactsProvider
                                            ?.contactDetailResponse
                                            ?.data
                                            ?.number
                                        : widget.clientPhoneNumber)
                                    : widget.clientPhoneNumber,
                            contactName:
                                contactsProvider!.contactDetailResponse != null
                                    ? (contactsProvider!.contactDetailResponse
                                                    ?.data !=
                                                null &&
                                            contactsProvider
                                                    ?.contactDetailResponse
                                                    ?.data !=
                                                null
                                        ? contactsProvider
                                            ?.contactDetailResponse?.data?.name
                                        : widget.clientName)
                                    : widget.clientName,
                            animationController: animationController,
                          );
                        },
                      );
                      if (returnData != null &&
                          returnData["data"] is bool &&
                          returnData["data"] as bool) {
                        if (mounted) {
                          OverlappingPanelsRight.of(context)
                              ?.reveal(RevealSide.main);
                        }

                        Utils.cPrint(returnData.toString());
                        searchList =
                            returnData["list"] as List<RecentConversationEdges>;
                        searchQuery = returnData["query"] as String;
                        setState(() {});

                        messagesProvider
                            ?.doSearchConversationWithCursorApiCall(
                          widget.channelId!,
                          widget.clientPhoneNumber!,
                        )
                            .then((value) async {
                          isSearching = true;
                          selectedSearchItem = searchList[searchList.indexWhere(
                              (element) =>
                                  element.cursor ==
                                  returnData["cursor"] as String)];
                          selectedSearchItemIndex = searchList.indexWhere(
                              (element) =>
                                  element.cursor ==
                                  returnData["cursor"] as String);
                          setState(() {});
                          toSearchItemIndex =
                              await messagesProvider!.getSearchIndex(
                            widget.channelId!,
                            selectedSearchItem!,
                            widget.clientPhoneNumber!,
                          );
                          setState(() {});
                          Utils.cPrint(toSearchItemIndex.toString());
                          FocusScope.of(context).unfocus();
                          _debounce.run(() async {
                            await _scrollController?.scrollToIndex(
                              toSearchItemIndex,
                              preferPosition: AutoScrollPosition.end,
                            );
                          });
                        });
                      }
                    },
                    onNotesTap: () async {
                      if (isBlocked) {
                        Future.delayed(Duration.zero, () {
                          Utils.showWarningToastMessage(
                              Utils.getString("unblockFirst"), context);
                        });
                      } else {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.notesList,
                            arguments: AddNotesIntentHolder(
                              channelId: widget.channelId,
                              clientId: contactId,
                              number: contactsProvider!.contactDetailResponse !=
                                      null
                                  ? (contactsProvider!.contactDetailResponse
                                                  ?.data !=
                                              null &&
                                          contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data !=
                                              null
                                      ? contactsProvider
                                          ?.contactDetailResponse?.data?.number
                                      : widget.clientPhoneNumber)!
                                  : widget.clientPhoneNumber!,
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
                            channel: widget.channelId,
                            contact: contactNumber,
                            pinned: false,
                          );
                          contactsProvider
                              ?.doGetAllNotesApiCall(param)
                              .then((value) {
                            setState(() {
                              contactId = returnData["clientId"] == null
                                  ? ""
                                  : returnData["clientId"] as String;
                              contactsProvider
                                  ?.doContactDetailApiCall(contactId);
                            });
                          });
                        }
                      }
                    },
                    onCallTap: () async {
                      if (messagesProvider!.getChannelList() != null) {
                        if (messagesProvider!.getChannelList()?.length == 1) {
                          widget.makeCallWithSid!(
                            widget.channelNumber,
                            widget.channelName,
                            widget.channelId,
                            widget.clientPhoneNumber,
                            messagesProvider!.getDefaultWorkspace(),
                            messagesProvider!.getMemberId(),
                            messagesProvider!.getVoiceToken(),
                            widget.clientName,
                            widget.clientId,
                            widget.clientProfilePicture,
                          );
                        } else {
                          _channelSelectionDialog(
                            context: context,
                            channelList: messagesProvider!.getChannelList(),
                          );
                        }
                      } else {
                        Utils.showToastMessage(Utils.getString("emptyChannel"));
                      }
                    },
                    onMuteTap: () async {
                      _showMuteDialog(
                          context: context,
                          clientName:
                              contactsProvider!.contactDetailResponse != null
                                  ? (contactsProvider!
                                                  .contactDetailResponse?.data !=
                                              null &&
                                          contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data !=
                                              null
                                      ? contactsProvider
                                          ?.contactDetailResponse?.data?.name
                                      : widget.clientName)
                                  : widget.clientPhoneNumber,
                          onMuteTap: (int minutes, bool value) {
                            onMuteTap(minutes, value);
                          });
                    },
                    onUnMuteTap: () {
                      _showUnMuteDialog(
                        context: context,
                        clientName: contactsProvider!.contactDetailResponse !=
                                null
                            ? (contactsProvider!.contactDetailResponse?.data !=
                                        null &&
                                    contactsProvider
                                            ?.contactDetailResponse?.data !=
                                        null
                                ? contactsProvider
                                    ?.contactDetailResponse?.data?.name
                                : widget.clientName)!
                            : widget.clientPhoneNumber,
                        dndEndTime: (contactsProvider!.contactDetailResponse !=
                                    null &&
                                contactsProvider?.contactDetailResponse?.data !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data
                                        ?.dndInfo?.dndEndtime !=
                                    null)
                            ? contactsProvider!.contactDetailResponse!.data!
                                .dndInfo!.dndEndtime!
                            : 0,
                        onUnMuteTap: (bool value) {
                          onMuteTap(0, value);
                        },
                      );
                    },
                    contactsProvider: contactsProvider!,
                    onContactBlockUnblockTap: (bool value) async {
                      final bool isConnected =
                          await Utils.checkInternetConnectivity();
                      if (isConnected) {
                        await PsProgressDialog.showDialog(this.context,
                            isDissmissable: true);
                        final Resources<BlockContactResponse>
                            responseBlockContact =
                            await contactsProvider!.doBlockContactApiCall(
                          BlockContactRequestHolder(
                            number: widget.clientPhoneNumber!,
                            data: BlockContactRequestParamHolder(
                              isBlock:
                                  (contactsProvider!.contactDetailResponse !=
                                              null &&
                                          contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data !=
                                              null &&
                                          contactsProvider!
                                                  .contactDetailResponse
                                                  ?.data
                                                  ?.blocked !=
                                              null)
                                      ? ((contactsProvider!
                                              .contactDetailResponse!
                                              .data!
                                              .blocked!)
                                          ? false
                                          : true)
                                      : true,
                            ),
                          ),
                        );

                        // Utils.cPrint(responseBlockContact.data!
                        //     .toMap(responseBlockContact.data)
                        //     .toString());
                        if (responseBlockContact.data != null) {
                          await PsProgressDialog.dismissDialog();
                          isBlocked = value;
                          blockUpdate = value;
                          if (contactId.isEmpty) {
                            contactId = responseBlockContact
                                .data?.blockNumber?.data["id"] as String;
                          }
                          setState(() {});
                          contactsProvider
                              ?.doContactDetailApiCall(contactId)
                              .then((value) {
                            setState(() {});
                          });
                        } else if (responseBlockContact.message != null) {
                          await PsProgressDialog.dismissDialog();
                          showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message: responseBlockContact.message,
                              );
                            },
                          );
                        } else {
                          await PsProgressDialog.dismissDialog();
                        }
                      } else {
                        if (!mounted) return;
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    },
                    notes: contactsProvider!.notes != null &&
                            contactsProvider!.notes!.data != null
                        ? contactsProvider!.notes!.data!
                        : null,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                      alignment:
                                                          Alignment.centerLeft,
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
                                                          fontSize:
                                                              Dimens.space14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.normal,
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
                                                    margin: EdgeInsets.fromLTRB(
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    iconColor:
                                                        CustomColors.mainColor,
                                                    iconSize: Dimens.space20,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .transparent,
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
                                                    imageUrl: "",
                                                    onTap: () async {
                                                      if (selectedSearchItemIndex -
                                                              1 <
                                                          0) {
                                                        Utils.cPrint(
                                                            "if lower $selectedSearchItemIndex");
                                                        Utils.cPrint(
                                                            "if lower ${searchList.length}");
                                                      } else {
                                                        Utils.cPrint(
                                                            "else lower $selectedSearchItemIndex");
                                                        Utils.cPrint(
                                                            "else lower ${searchList.length}");
                                                        selectedSearchItem =
                                                            searchList[
                                                                selectedSearchItemIndex -
                                                                    1];
                                                        selectedSearchItemIndex =
                                                            selectedSearchItemIndex -
                                                                1;
                                                        setState(() {});
                                                        toSearchItemIndex =
                                                            await messagesProvider!
                                                                .getSearchIndex(
                                                          widget.channelId!,
                                                          selectedSearchItem!,
                                                          widget
                                                              .clientPhoneNumber!,
                                                        );
                                                        _scrollController
                                                            ?.jumpTo(
                                                          0,
                                                        );
                                                        setState(() {});
                                                        Utils.cPrint(
                                                            "else lower $toSearchItemIndex  ${_scrollController?.isIndexStateInLayoutRange(toSearchItemIndex)}");
                                                        _debounce.run(() async {
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
                                                    iconColor:
                                                        CustomColors.mainColor,
                                                    iconSize: Dimens.space20,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .transparent,
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
                                                    imageUrl: "",
                                                    onTap: () async {
                                                      if (selectedSearchItemIndex +
                                                              1 >=
                                                          searchList.length) {
                                                        Utils.cPrint(
                                                            "if upper $selectedSearchItemIndex");
                                                        Utils.cPrint(
                                                            "if upper ${searchList.length}");
                                                      } else {
                                                        Utils.cPrint(
                                                            "else upper $selectedSearchItemIndex");
                                                        Utils.cPrint(
                                                            "else upper ${searchList.length}");
                                                        selectedSearchItem =
                                                            searchList[
                                                                selectedSearchItemIndex +
                                                                    1];
                                                        selectedSearchItemIndex =
                                                            selectedSearchItemIndex +
                                                                1;
                                                        setState(() {});
                                                        toSearchItemIndex =
                                                            (await messagesProvider
                                                                ?.getSearchIndex(
                                                          widget.channelId!,
                                                          selectedSearchItem!,
                                                          widget
                                                              .clientPhoneNumber!,
                                                        ))!;

                                                        setState(() {});
                                                        Utils.cPrint(
                                                            "else upper $toSearchItemIndex");
                                                        _debounce.run(() async {
                                                          try {
                                                            await _scrollController
                                                                ?.scrollToIndex(
                                                              toSearchItemIndex,
                                                              preferPosition:
                                                                  AutoScrollPosition
                                                                      .end,
                                                            );
                                                          } catch (e) {
                                                            Utils.cPrint(
                                                                e.toString());
                                                          }
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
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
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
                                              messagesProvider!
                                                  .listConversationDetails!
                                                  .data),
                                        ),
                                      ),
                                      Divider(
                                        color: CustomColors.mainDividerColor,
                                        height: Dimens.space1.h,
                                        thickness: Dimens.space1.h,
                                      ),
                                      // Input content
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0,
                                            Dimens.space0,
                                            Dimens.space0,
                                            Dimens.space0.h),
                                        color: CustomColors.white,
                                        child: ChatTextFieldWidgetWithIcon(
                                          listConversationEdge:
                                              messagesProvider!
                                                  .listConversationDetails!
                                                  .data,
                                          animationController:
                                              animationController!,
                                          textEditingController:
                                              textEditingControllerMessage,
                                          customIcon:
                                              CustomIcon.icon_message_send,
                                          isSendIconVisible: isSendIconVisible,
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
                                            doOnSendTap();
                                          },
                                          onMacrosTap: () async {
                                            showMacrosListDialog(context);
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
                                              iconUrl:
                                                  Icons.arrow_downward_rounded,
                                              iconColor:
                                                  CustomColors.textSenaryColor,
                                              iconSize: Dimens.space20,
                                              boxDecorationColor:
                                                  CustomColors.white,
                                              outerCorner: Dimens.space300,
                                              innerCorner: Dimens.space0,
                                              imageUrl: "",
                                              onTap: () {
                                                _scrollController!.jumpTo(
                                                  0,
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
                                              color:
                                                  CustomColors.callDeclineColor,
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
                                                    fontSize: Dimens.space11.sp,
                                                    color: CustomColors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
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
                                                fontFamily: Config.heeboMedium,
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
                                                fontFamily: Config.heeboMedium,
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
                                                CustomColors.bottomAppBarColor!,
                                              ],
                                            ),
                                          ),
                                          child: RoundedNetworkImageHolder(
                                            width: kToolbarHeight.h,
                                            height: kToolbarHeight.h,
                                            iconUrl: CustomIcon.icon_arrow_left,
                                            iconColor:
                                                CustomColors.loadingCircleColor,
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
                                              child: ImageAndTextWidget(
                                                contactsProvider:
                                                    contactsProvider!,
                                                // listConversationEdge:
                                                //     messagesProvider!
                                                //         .listConversationDetails!
                                                //         .data,
                                                isBlocked: isBlocked,
                                                clientName: contactsProvider
                                                            ?.contactDetailResponse !=
                                                        null
                                                    ? (contactsProvider!
                                                                    .contactDetailResponse
                                                                    ?.data !=
                                                                null &&
                                                            contactsProvider
                                                                    ?.contactDetailResponse
                                                                    ?.data
                                                                    ?.name !=
                                                                null &&
                                                            contactsProvider!
                                                                .contactDetailResponse!
                                                                .data!
                                                                .name!
                                                                .isNotEmpty
                                                        ? contactsProvider!
                                                            .contactDetailResponse!
                                                            .data!
                                                            .name
                                                        : widget
                                                            .clientPhoneNumber)!
                                                    : widget.clientPhoneNumber!,
                                                clientNumber:
                                                    widget.clientPhoneNumber!,
                                                clientProfilePicture: contactsProvider!.contactDetailResponse !=
                                                        null
                                                    ? (contactsProvider!.contactDetailResponse!
                                                                    .data !=
                                                                null &&
                                                            contactsProvider!
                                                                    .contactDetailResponse!
                                                                    .data !=
                                                                null
                                                        ? contactsProvider!
                                                            .contactDetailResponse!
                                                            .data!
                                                            .profilePicture
                                                        : widget
                                                            .clientProfilePicture)
                                                    : widget
                                                        .clientProfilePicture,
                                                lastChatted: widget.lastChatted,
                                                onCallIconTap: () async {
                                                  Utils.checkInternetConnectivity()
                                                      .then((data) async {
                                                    if (data) {
                                                      if (messagesProvider!
                                                                  .getChannelList() !=
                                                              null &&
                                                          messagesProvider!
                                                              .getChannelList()!
                                                              .isNotEmpty) {
                                                        if (messagesProvider!
                                                                .getChannelList()!
                                                                .length ==
                                                            1) {
                                                          widget.makeCallWithSid!(
                                                              widget
                                                                  .channelNumber,
                                                              widget
                                                                  .channelName,
                                                              widget.channelId,
                                                              widget
                                                                  .clientPhoneNumber,
                                                              messagesProvider!
                                                                  .getDefaultWorkspace(),
                                                              messagesProvider!
                                                                  .getMemberId(),
                                                              messagesProvider!
                                                                  .getVoiceToken(),
                                                              widget.clientName,
                                                              widget.clientId,
                                                              widget
                                                                  .clientProfilePicture);
                                                        } else {
                                                          _channelSelectionDialog(
                                                            context: context,
                                                            channelList:
                                                                messagesProvider!
                                                                    .getChannelList(),
                                                          );
                                                        }
                                                      } else {
                                                        Utils.showToastMessage(
                                                            Utils.getString(
                                                                "emptyChannel"));
                                                      }
                                                    } else {
                                                      Utils
                                                          .showWarningToastMessage(
                                                              Utils.getString(
                                                                  "noInternet"),
                                                              context);
                                                    }
                                                  });
                                                },
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
                                                ]),
                                          ),
                                          child: RoundedNetworkImageHolder(
                                            width: kToolbarHeight.h,
                                            height: kToolbarHeight.h,
                                            boxFit: BoxFit.contain,
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
                                                    ?.reveal(RevealSide.right);
                                              }
                                              isOpen = !isOpen;
                                              setState(() {});
                                            },
                                          ),
                                        )
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
        )),
      ),
    );
  }

  List<MessageDetailsObjectWithType> tempList = [];

  Widget buildListMessage(
      List<MessageDetailsObjectWithType>? listConversationEdge) {
    if (listConversationEdge != null) {
      if (listConversationEdge.length >= 0) {
        final DateTime now = DateTime.now();
        final String dateTime =
            "${now.toIso8601String()}${now.timeZoneOffset.inHours}:00";
        if (listConversationEdge.isEmpty) {
          listConversationEdge
              .add(MessageDetailsObjectWithType(type: "time", time: dateTime));
        }
        tempList = listConversationEdge.reversed.toList();
        return Container(
          alignment: Alignment.bottomCenter,
          color: CustomColors.white,
          margin: EdgeInsets.fromLTRB(
            Dimens.space0.w,
            Dimens.space0.h,
            Dimens.space0.w,
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
              cacheExtent:
                  messagesProvider!.listConversationDetails!.data!.length *
                      Dimens.space150.h,
              reverse: true,
              shrinkWrap: true,
              itemCount: tempList.length,
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space0.h),
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
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (tempList[index].type == "time") {
                        return Column(
                          children: [
                            if (messagesProvider!.pageInfo != null &&
                                messagesProvider!.pageInfo?.data != null &&
                                messagesProvider!.pageInfo?.data?.hasNextPage !=
                                    null &&
                                !messagesProvider!
                                    .pageInfo!.data!.hasNextPage! &&
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
                                  title:
                                      contactsProvider!.contactDetailResponse !=
                                              null
                                          ? (contactsProvider
                                                      ?.contactDetailResponse
                                                      ?.data !=
                                                  null
                                              ? contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data
                                                  ?.name
                                              : widget.clientName)
                                          : widget.clientName,
                                  message: Utils.getString("beginningMessage"),
                                  imageUrl: contactsProvider!
                                                  .contactDetailResponse !=
                                              null &&
                                          contactsProvider!
                                                  .contactDetailResponse!
                                                  .data !=
                                              null &&
                                          contactsProvider!
                                                  .contactDetailResponse!
                                                  .data !=
                                              null
                                      ? contactsProvider!.contactDetailResponse!
                                          .data!.profilePicture
                                      : widget.clientProfilePicture,
                                  isContact: contactsProvider!
                                                  .contactDetailResponse !=
                                              null &&
                                          contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data !=
                                              null &&
                                          contactsProvider
                                                  ?.contactDetailResponse
                                                  ?.data !=
                                              null
                                      ? true
                                      : false,
                                  clientNumber:
                                      contactsProvider
                                                      ?.contactDetailResponse !=
                                                  null &&
                                              contactsProvider
                                                      ?.contactDetailResponse
                                                      ?.data !=
                                                  null &&
                                              contactsProvider
                                                      ?.contactDetailResponse
                                                      ?.data !=
                                                  null
                                          ? contactsProvider!
                                              .contactDetailResponse!
                                              .data!
                                              .number!
                                          : widget.clientPhoneNumber!,
                                  onAddContactTap: () async {
                                    final dynamic returnData =
                                        await Navigator.pushNamed(
                                      context,
                                      RoutePaths.newContact,
                                      arguments: AddContactIntentHolder(
                                        phoneNumber: widget.clientPhoneNumber,
                                        defaultCountryCode:
                                            await countryListProvider
                                                ?.getCountryByIso(
                                                    widget.clientPhoneNumber!),
                                        onIncomingTap: () {
                                          widget.onIncomingTap();
                                        },
                                        onOutgoingTap: () {
                                          widget.onOutgoingTap();
                                        },
                                      ),
                                    );
                                    if (returnData != null &&
                                        returnData["data"] is bool &&
                                        returnData["data"] as bool) {
                                      contactsProvider
                                          ?.doContactDetailApiCall(
                                              returnData["clientId"] as String)
                                          .then((value) {
                                        setState(() {
                                          contactId =
                                              returnData["clientId"] == null
                                                  ? ""
                                                  : returnData["clientId"]
                                                      as String;
                                        });
                                      });
                                    }
                                  },
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
                            ),
                          ],
                        );
                      } else {
                        return callStateStatus(
                          index != tempList.length - 1
                              ? tempList[index + 1]
                              : null,
                          tempList[index],
                          index,
                          loginWorkspaceProvider!,
                        );
                      }
                    }),
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
                  child: Column(
                    children: [
                      EmptyConversationWidget(
                        title: contactsProvider!.contactDetailResponse != null
                            ? (contactsProvider!.contactDetailResponse?.data !=
                                    null
                                ? contactsProvider!
                                    .contactDetailResponse?.data?.name
                                : widget.clientName)!
                            : widget.clientName,
                        message: Utils.getString("beginningMessage"),
                        imageUrl: contactsProvider!.contactDetailResponse !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data !=
                                    null
                            ? contactsProvider!
                                .contactDetailResponse!.data!.profilePicture!
                            : widget.clientProfilePicture!,
                        isContact: contactsProvider!.contactDetailResponse !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data !=
                                    null &&
                                contactsProvider!.contactDetailResponse?.data !=
                                    null
                            ? true
                            : false,
                        clientNumber:
                            contactsProvider!.contactDetailResponse != null &&
                                    contactsProvider!
                                            .contactDetailResponse!.data !=
                                        null &&
                                    contactsProvider!
                                            .contactDetailResponse!.data !=
                                        null
                                ? contactsProvider!
                                    .contactDetailResponse!.data!.number!
                                : widget.clientPhoneNumber!,
                        onAddContactTap: () async {
                          final dynamic returnData = await Navigator.pushNamed(
                            context!,
                            RoutePaths.newContact,
                            arguments: AddContactIntentHolder(
                              phoneNumber: widget.clientPhoneNumber,
                              defaultCountryCode: await countryListProvider
                                  ?.getCountryByIso(widget.clientPhoneNumber!),
                              onIncomingTap: () {
                                widget.onIncomingTap();
                              },
                              onOutgoingTap: () {
                                widget.onOutgoingTap();
                              },
                            ),
                          );
                          if (returnData != null &&
                              returnData["data"] is bool &&
                              returnData["data"] as bool) {
                            contactsProvider
                                ?.doContactDetailApiCall(
                                    returnData["clientId"] as String)
                                .then((value) {
                              setState(() {
                                contactId = returnData["clientId"] == null
                                    ? ""
                                    : returnData["clientId"] as String;
                              });
                            });
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space200.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        child: SpinKitCircle(
                          color: CustomColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
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
                child: Column(
                  children: [
                    EmptyConversationWidget(
                      title: contactsProvider!.contactDetailResponse != null
                          ? (contactsProvider!.contactDetailResponse?.data !=
                                  null
                              ? contactsProvider!
                                  .contactDetailResponse?.data?.name
                              : widget.clientName)
                          : widget.clientName,
                      message: Utils.getString("beginningMessage"),
                      imageUrl: contactsProvider!.contactDetailResponse !=
                                  null &&
                              contactsProvider!.contactDetailResponse?.data !=
                                  null &&
                              contactsProvider!.contactDetailResponse?.data !=
                                  null
                          ? contactsProvider!
                              .contactDetailResponse!.data!.profilePicture
                          : widget.clientProfilePicture,
                      isContact: contactsProvider!.contactDetailResponse !=
                                  null &&
                              contactsProvider!.contactDetailResponse?.data !=
                                  null &&
                              contactsProvider!.contactDetailResponse?.data !=
                                  null
                          ? true
                          : false,
                      clientNumber:
                          contactsProvider!.contactDetailResponse != null &&
                                  contactsProvider!
                                          .contactDetailResponse!.data !=
                                      null &&
                                  contactsProvider!
                                          .contactDetailResponse!.data !=
                                      null
                              ? contactsProvider!
                                  .contactDetailResponse!.data!.number!
                              : widget.clientPhoneNumber!,
                      onAddContactTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                          context!,
                          RoutePaths.newContact,
                          arguments: AddContactIntentHolder(
                            phoneNumber: widget.clientPhoneNumber,
                            defaultCountryCode: await countryListProvider
                                ?.getCountryByIso(widget.clientPhoneNumber!),
                            onIncomingTap: () {
                              widget.onIncomingTap();
                            },
                            onOutgoingTap: () {
                              widget.onOutgoingTap();
                            },
                          ),
                        );
                        if (returnData != null &&
                            returnData["data"] is bool &&
                            returnData["data"] as bool) {
                          contactsProvider
                              ?.doContactDetailApiCall(
                                  returnData["clientId"] as String)
                              .then((value) {
                            setState(() {
                              contactId = returnData["clientId"] == null
                                  ? ""
                                  : returnData["clientId"] as String;
                            });
                          });
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space200.h,
                        Dimens.space0.w,
                        Dimens.space0.h,
                      ),
                      child: SpinKitCircle(
                        color: CustomColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void showToastMessage(BuildContext context,
      {required Function onUnblockTap}) {
    Toast.show(Utils.getString("unblockFirst"), context, onTap: () {
      onUnblockTap();
    });
  }

  ///Call State logic
  Widget callStateStatus(
    MessageDetailsObjectWithType? prevData,
    MessageDetailsObjectWithType data,
    int index,
    LoginWorkspaceProvider loginWorkspaceProvider,
  ) {
    CallStateOutput callState = CallStateOutput.EMPTY;
    final conversationType =
        data.edges?.recentConversationNodes?.conversationType;
    final conversationStatus =
        data.edges?.recentConversationNodes?.conversationStatus;

    if (data.edges?.recentConversationNodes?.direction ==
        CallStateIndex.Incoming.value) {
      if (conversationType == CallStateIndex.Message.value) {
        callState = CallStateOutput.Incoming_Message;
      } else if (conversationType == CallStateIndex.Call.value) {
        if (data.edges?.recentConversationNodes?.conversationStatus ==
                CallStateIndex.COMPLETED.value &&
            data.edges?.recentConversationNodes?.content != null &&
            data.edges?.recentConversationNodes?.content?.body != null) {
          callState = CallStateOutput.Incoming_RECORDING;
        } else if (data.edges?.recentConversationNodes?.content?.body != null) {
          callState = CallStateOutput.Incoming_VOICEMAIL;
        } else if (conversationStatus == CallStateIndex.NOANSWER.value) {
          callState = CallStateOutput.Incoming_NOANSWER; //used Misscall
        } else if (conversationStatus == CallStateIndex.BUSY.value) {
          callState = CallStateOutput.Incoming_BUSY;
        } else if (conversationStatus == CallStateIndex.COMPLETED.value) {
          callState = CallStateOutput.Incoming_COMPLETED;
        } else if (conversationStatus == CallStateIndex.CANCELED.value) {
          callState = CallStateOutput.Incoming_CANCELED;
        } else if (conversationStatus == CallStateIndex.INPROGRESS.value) {
          callState = CallStateOutput.Incoming_INPROGRESS;
        } else if (conversationStatus == CallStateIndex.REJECTED.value) {
          callState = CallStateOutput.Incoming_REJECTED;
        } else if (conversationStatus == CallStateIndex.RINGING.value) {
          callState = CallStateOutput.Incoming_RINGING;
        } else if (conversationStatus == CallStateIndex.PENDING.value) {
          callState = CallStateOutput.Incoming_RINGING;
        } else if (conversationStatus == CallStateIndex.OnHOLD.value) {
          callState = CallStateOutput.Incoming_INPROGRESS;
        } else if (conversationStatus == CallStateIndex.TRANSFERRING.value) {
          callState = CallStateOutput.Incoming_INPROGRESS;
        } else {
          callState = CallStateOutput.Incoming_COMPLETED;
        }
      } else {
        callState = CallStateOutput.Incoming_COMPLETED;
      }
    } else {
      if (conversationType == CallStateIndex.Message.value) {
        if (conversationStatus == CallStateIndex.DELIVERED.value ||
            conversationStatus == CallStateIndex.SENT.value) {
          callState = CallStateOutput.OutGoing_MessageView;
        } else if (conversationStatus == CallStateIndex.PENDING.value) {
          callState = CallStateOutput.Outgoing_Pending;
        } else {
          callState = CallStateOutput.Outgoing_NOTSENT;
        }
      } else if (conversationType == CallStateIndex.Call.value) {
        if (conversationStatus == CallStateIndex.NOANSWER.value) {
          // if (data.edges.recentConversationNodes.reject != null &&
          //     data.edges.recentConversationNodes.reject) {
          //   callState = CallStateOutput.Outgoing_REJECTED;
          // } else {
          callState = CallStateOutput.Outgoing_NOANSWER;
          // }
        } else if (conversationStatus == CallStateIndex.BUSY.value) {
          callState = CallStateOutput.Outgoing_BUSY;
        }
        // else if (conversationStatus == CallStateIndex.ATTEMPTED.value) {
        //   callState = CallStateOutput.Outgoing_ATTEMPTED;
        // }
        else if (conversationStatus == CallStateIndex.FAILED.value) {
          callState = CallStateOutput.Outgoing_FAILED;
        } else if (conversationStatus == CallStateIndex.CANCELED.value) {
          callState = CallStateOutput.Outgoing_CANCELED;
        } else if (conversationStatus == CallStateIndex.COMPLETED.value) {
          if (data.edges?.recentConversationNodes?.content?.body != null) {
            callState = CallStateOutput.Outgoing_RECORDING;
          } else if (data
                  .edges?.recentConversationNodes?.content?.transferredAudio !=
              null) {
            callState = CallStateOutput.Outgoing_RECORDING;
          } else {
            callState = CallStateOutput.OutGoing_CallView;
          }
        } else if (conversationStatus == CallStateIndex.PENDING.value ||
            conversationStatus == CallStateIndex.CALLING.value) {
          callState = CallStateOutput.Outgoing_CALLING;
        } else if (conversationStatus == CallStateIndex.RINGING.value) {
          callState = CallStateOutput.Outgoing_RINGING;
        } else if (conversationStatus == CallStateIndex.INPROGRESS.value) {
          callState = CallStateOutput.Outgoing_INPROGRESS;
        } else if (conversationStatus == CallStateIndex.OnHOLD.value) {
          callState = CallStateOutput.Outgoing_INPROGRESS;
        }
        // else if (conversationStatus == CallStateIndex.ATTEMPTED.value) {
        //   callState = CallStateOutput.Outgoing_ATTEMPTED;
        // }
        else if (conversationStatus == CallStateIndex.TRANSFERRING.value) {
          callState = CallStateOutput.Outgoing_INPROGRESS;
        } else {
          callState = CallStateOutput.Outgoing_BUSY;
        }
      } else {
        callState = CallStateOutput.EMPTY;
      }
    }
    return callStateStatusView(
        callState, prevData, data, index, loginWorkspaceProvider);
  }

  //Map view according call status
  Widget callStateStatusView(
    CallStateOutput state,
    MessageDetailsObjectWithType? prevData,
    MessageDetailsObjectWithType tempList,
    int index,
    LoginWorkspaceProvider loginWorkspaceProvider,
  ) {
    final conversationEdge = tempList.edges;
    final boxDecorationType = tempList.messageBoxDecorationType;

    ///Converting duration to interger form for second || sec can't be in double
    try {
      final String s =
          conversationEdge!.recentConversationNodes!.content!.duration!;
      conversationEdge.recentConversationNodes!.content!.duration =
          s.substring(0, s.indexOf("."));
      conversationEdge.seekDataTotal =
          conversationEdge.recentConversationNodes?.content?.duration;
    } catch (e) {}
    switch (state) {
      case CallStateOutput.Incoming_Message:
        return IncomingMessageView(
          conversationEdge: conversationEdge,
          boxDecorationType: boxDecorationType,
          searchQuery: searchQuery,
          isSearching: isSearching,
        );

      case CallStateOutput.Incoming_NOANSWER:
        return InComingCallMissedView(
          conversationEdge: conversationEdge!,
          onCallTap: (v) {
            onCallTap(conversationEdge);
          },
        );

      case CallStateOutput.Incoming_REJECTED:
        return IncomingCallDeclinedView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
          callback: (v) {
            onCallTap(conversationEdge!);
          },
        );

      case CallStateOutput.Incoming_BUSY:
        return IncomingCallDeclinedView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
          callback: (v) {
            onCallTap(conversationEdge!);
          },
        );

      case CallStateOutput.Incoming_COMPLETED:
        return IncomingCallView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.Incoming_CANCELED:
        return InComingCallMissedView(
          conversationEdge: conversationEdge!,
          onCallTap: (v) {
            onCallTap(conversationEdge);
          },
        );

      case CallStateOutput.Incoming_INPROGRESS:
        return IncomingCallInProgress(conversationEdge: conversationEdge);

      case CallStateOutput.Incoming_RINGING:
        return IncomingRingingView(
          conversationEdge: conversationEdge,
        );

      case CallStateOutput.Incoming_VOICEMAIL:
        return IncomingVoicemailView(
          title: Utils.getString("voiceMail"),
          conversationEdge: conversationEdge,
          callback: (v) {
            callbackVoice(index);
          },
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.Incoming_RECORDING:
        return IncomingRecordingView(
          title: Utils.getString("recordings"),
          conversationEdge: conversationEdge,
          callback: (v) {
            callbackVoice(index);
          },
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.OutGoing_MessageView:
        return OutGoingMessageView(
          prevConversationEdge: prevData?.edges,
          conversationEdge: conversationEdge,
          boxDecorationType: boxDecorationType,
          loginWorkspaceProvider: loginWorkspaceProvider,
          searchQuery: searchQuery,
          isSearching: isSearching,
        );

      case CallStateOutput.Outgoing_Pending:
        return PendingMessageView(
          conversationEdge: conversationEdge,
          boxDecorationType: boxDecorationType,
          loginWorkspaceProvider: loginWorkspaceProvider,
          searchQuery: searchQuery,
          isSearching: isSearching,
        );

      case CallStateOutput.Outgoing_NOTSENT:
        return NotSendMessageView(
          conversationEdge: conversationEdge,
          onReSendTap: (v) {
            onResendTap(index);
          },
          boxDecorationType: boxDecorationType,
          searchQuery: searchQuery,
          isSearching: isSearching,
        );
      case CallStateOutput.Outgoing_FAILED:
        return CallFailedView(
          conversationEdge: conversationEdge!,
          makeCallWithSid: (v) {
            onCallTap(v);
          },
        );
      case CallStateOutput.Outgoing_NOANSWER:
        return OutgoingCallNoAnswerView(conversationEdge: conversationEdge);
      case CallStateOutput.Outgoing_BUSY:
        return OutGoingCallBusyView(conversationEdge: conversationEdge);
      case CallStateOutput.Outgoing_CANCELED:
        return OutgoingCallCanceledView(conversationEdge: conversationEdge);

      case CallStateOutput.Outgoing_ATTEMPTED:
        return OutGoingCallView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.Outgoing_INPROGRESS:
        return OutGoingInProgressView(conversationEdge: conversationEdge);

      case CallStateOutput.Outgoing_RINGING:
        return OutGoingRingingView(conversationEdge: conversationEdge);

      case CallStateOutput.Outgoing_CALLING:
        return OutGoingCallingView(
          recentConversationEdge: conversationEdge,
        );

      case CallStateOutput.OutGoing_CallView:
        return OutGoingCallView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.Outgoing_REJECTED:
        return OutGoingCallView(
          conversationEdge: conversationEdge,
          loginWorkspaceProvider: loginWorkspaceProvider,
        );

      case CallStateOutput.Outgoing_RECORDING:
        return OutgoingRecordingView(
          title: Utils.getString("recordings"),
          loginWorkspaceProvider: loginWorkspaceProvider,
          conversationEdge: conversationEdge,
          callbackRecording: () {
            Utils.cPrint("I am not here");
            callbackVoice(index);
          },
        );

      default:
        return Container();
    }
  }

  void _channelSelectionDialog({
    BuildContext? context,
    List<WorkspaceChannel>? channelList,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.48,
        child: ChannelSelectionDialog(
          channelList: channelList,
          onChannelTap: (WorkspaceChannel data) {
            widget.makeCallWithSid!(
              data.number,
              data.name,
              data.id,
              widget.clientPhoneNumber,
              messagesProvider!.getDefaultWorkspace(),
              messagesProvider!.getMemberId(),
              messagesProvider!.getVoiceToken(),
              widget.clientName,
              widget.clientId,
              widget.clientProfilePicture,
            );
          },
        ),
      ),
    );
  }

  Future<void> onCallTap(RecentConversationEdges conversationEdge) async {
    if (messagesProvider!.getChannelList()!.length == 1) {
      widget.makeCallWithSid!(
        widget.channelNumber,
        widget.channelName,
        widget.channelId,
        widget.clientPhoneNumber,
        messagesProvider!.getDefaultWorkspace(),
        messagesProvider!.getMemberId(),
        messagesProvider!.getVoiceToken(),
        widget.clientName,
        widget.clientId,
        widget.clientProfilePicture,
      );
    } else {
      _channelSelectionDialog(
        context: context,
        channelList: messagesProvider!.getChannelList(),
      );
    }
  }

  Future<void> onResendTap(int index) async {
    if (textEditingControllerMessage.text.isNotEmpty) {
      final List<WorkspaceChannel> listWorkspaceChannel =
          contactsProvider!.getChannelList()!;
      if (listWorkspaceChannel.isNotEmpty) {
        for (int i = 0; i < listWorkspaceChannel.length; i++) {
          if (listWorkspaceChannel[i].number == widget.clientPhoneNumber) {
            Utils.showToastMessage(Utils.getString("cannotCallThisNumber"));
            return;
          }
        }
      }
      final Resources<WorkspaceCreditResponse> creditResponse =
          await loginWorkspaceProvider!.doWorkspaceCreditApiCall();
      if (creditResponse.data != null &&
          creditResponse.data!.getWorkspaceCredit != null &&
          creditResponse.data!.getWorkspaceCredit!.currentCredit != null &&
          creditResponse
                  .data!.getWorkspaceCredit!.currentCredit!.currentCredit !=
              null &&
          double.parse(creditResponse
                  .data!.getWorkspaceCredit!.currentCredit!.currentCredit!) >
              5) {
        final Resources<Messages> response = await messagesProvider!
            .doSendMessageApiCall(
                widget.channelId!,
                tempList[index].edges!.recentConversationNodes!.content!.body!,
                widget.clientPhoneNumber!);
        if (response.data != null) {
          textEditingControllerMessage.clear();
        }
      } else {
        Utils.showToastMessage(Utils.getString("insufficientCredit"));
      }
    }
  }

  void callbackVoice(int index) {
    for (int i = 0; i < tempList.length; i++) {
      if (i != index) {
        try {
          if (tempList[i].edges?.advancedPlayer != null) {
            setState(() {
              tempList[i].edges?.isPlay = false;
              tempList[i].edges?.advancedPlayer?.stop();
              tempList[i].edges?.seekData = "0";
            });
          }
        } catch (e) {}
      }
    }
  }

  void stopAllPlay() {
    for (int i = 0; i < tempList.length; i++) {
      try {
        if (tempList[i].edges?.advancedPlayer != null) {
          setState(() {
            tempList[i].edges?.isPlay = false;
            tempList[i].edges?.advancedPlayer?.stop();
            tempList[i].edges?.seekData = "0";
          });
        }
      } catch (_) {}
    }
  }

  void _showUnMuteDialog({
    BuildContext? context,
    String? clientName,
    int? dndEndTime,
    Function? onUnMuteTap,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.35,
        child: ClientDndUnMuteDialog(
          name: clientName,
          onUmMuteTap: () {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 300), () {
              onUnMuteTap!(true);
            });
          },
          dndEndTime: dndEndTime,
        ),
      ),
    );
  }

  void _showMuteDialog({
    BuildContext? context,
    String? clientName,
    Function? onMuteTap,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClientDndMuteDialog(
        clientName: clientName,
        onMuteTap: (int minutes, bool value) {
          Navigator.of(context).pop();
          Future.delayed(const Duration(milliseconds: 300), () {
            onMuteTap!(minutes, value);
          });
        },
      ),
    );
  }

  Future<void> onMuteTap(int minutes, bool value) async {
    await PsProgressDialog.showDialog(context, isDissmissable: true);
    final UpdateClientDNDRequestParamHolder updateClientDNDRequestParamHolder =
        UpdateClientDNDRequestParamHolder(
      contact: widget.clientPhoneNumber!,
      minutes: minutes,
      removeFromDND: value,
    );
    final Resources<ClientDndResponse> resource = await contactsProvider
            ?.doClientDndApiCall(updateClientDNDRequestParamHolder)
        as Resources<ClientDndResponse>;
    if (resource.status == Status.ERROR) {
      await PsProgressDialog.dismissDialog();
      Utils.showToastMessage(resource.message!);
    } else {
      await PsProgressDialog.dismissDialog();
      contactsProvider!.doContactDetailApiCall(
          resource.data!.clientDndResponseData!.contacts!.id!);
    }
  }

  Future<void> doSubscriptionUpdate() async {
    streamSubscriptionCallLogs = await messagesProvider
        ?.doSubscriptionConversationChatApiCall("all", widget.channelId);
    if (streamSubscriptionCallLogs != null) {
      streamSubscriptionCallLogs?.listen((event) async {
        if (event.data != null) {
          final RecentConversationNodes recentConversationNodes =
              RecentConversationNodes()
                  .fromMap(event.data!["updateConversation"]["message"])!;
          if (recentConversationNodes.channelInfo?.channelId ==
              widget.channelId) {
            if (recentConversationNodes.clientNumber ==
                widget.clientPhoneNumber) {
              Utils.cPrint(
                  event.data!["updateConversation"]["message"].toString());
              if (!mounted) return;
              if (recentConversationNodes.conversationStatus?.toLowerCase() ==
                  "sent") {
                subCount += 1;
                setState(() {});
              }

              messagesProvider!.updateSubscriptionConversationDetail(
                widget.channelId!,
                widget.clientPhoneNumber!,
                recentConversationNodes,
                isSearching,
              );
            }
          }
        }
      });
    }
  }

  Future<void> doOnSendTap() async {
    final bool connected = await Utils.checkInternetConnectivity();
    if (connected) {
      final List<WorkspaceChannel>? channelList =
          messagesProvider!.getChannelList();
      if (channelList != null && channelList.isNotEmpty) {
        final WorkspaceChannel defaultOne = channelList[channelList
            .indexWhere((element) => element.id == widget.channelId)];
        if (defaultOne.sms != null && defaultOne.sms!) {
          String numberType = "";
          try {
            final PhoneNumber number =
                await PhoneNumber.getRegionInfoFromPhoneNumber(
              defaultOne.number!,
            );
            final String phoneNumber = widget.clientPhoneNumber!;
            final String regionCode = number.isoCode!;

            final tempNumberType =
                await PhoneNumberUtil.getNumberType(phoneNumber, regionCode);
            numberType = tempNumberType.toString();
          } catch (e) {
            Utils.cPrint("PLATFORM EXCEPTION: $e ");
          }
          Utils.cPrint("numberType===> $numberType");
          if (numberType.isNotEmpty &&
              (numberType != "PhoneNumberType.FIXED_LINE")) {
            if (textEditingControllerMessage.text.isNotEmpty) {
              final String dump = textEditingControllerMessage.text;
              textEditingControllerMessage.text;
              textEditingControllerMessage.clear();
              isSendIconVisible = false;
              setState(() {});
              if (channelList.isNotEmpty) {
                for (int i = 0; i < channelList.length; i++) {
                  if (channelList[i].number == widget.clientPhoneNumber) {
                    Utils.showToastMessage(
                        Utils.getString("cannotCallThisNumber"));
                    return;
                  }
                }
              }
              final SubscriptionUpdateConversationDetailRequestHolder
                  subscriptionUpdateConversationDetailRequestHolder =
                  SubscriptionUpdateConversationDetailRequestHolder(
                channelId: defaultOne.id!,
              );

              final Resources<NumberSettings> numberSettings =
                  await loginWorkspaceProvider!.doGetNumberSettings(
                      subscriptionUpdateConversationDetailRequestHolder);

              if (numberSettings.data != null &&
                  numberSettings.data!.internationalCallAndMessages != null &&
                  numberSettings.data!.internationalCallAndMessages!) {
                final Resources<WorkspaceCreditResponse> creditResponse =
                    await loginWorkspaceProvider!.doWorkspaceCreditApiCall();
                if (creditResponse.data != null &&
                    creditResponse.data!.getWorkspaceCredit != null &&
                    creditResponse.data!.getWorkspaceCredit!.currentCredit !=
                        null &&
                    creditResponse.data!.getWorkspaceCredit!.currentCredit!
                            .currentCredit !=
                        null &&
                    double.parse(creditResponse.data!.getWorkspaceCredit!
                            .currentCredit!.currentCredit!) >
                        0.5) {
                  await messagesProvider!.doSendMessageApiCall(
                    defaultOne.id!,
                    dump,
                    widget.clientPhoneNumber!,
                  );
                  contactsProvider!.doGetLastContactedApiCall(
                    Map.from(
                      {
                        "contact": widget.clientPhoneNumber,
                      },
                    ),
                  );
                } else {
                  Utils.showToastMessage(Utils.getString("insufficientCredit"));
                }
              } else {
                final CountryCode a =
                    await countryListProvider!.getCountryByIso(
                  defaultOne.number!,
                );
                final CountryCode b = await countryListProvider!
                    .getCountryByIso(widget.clientPhoneNumber!);
                if (a.dialCode == b.dialCode) {
                  final Resources<WorkspaceCreditResponse> creditResponse =
                      await loginWorkspaceProvider!.doWorkspaceCreditApiCall();
                  if (creditResponse.data != null &&
                      creditResponse.data!.getWorkspaceCredit != null &&
                      creditResponse.data!.getWorkspaceCredit!.currentCredit !=
                          null &&
                      creditResponse.data!.getWorkspaceCredit!.currentCredit!
                              .currentCredit !=
                          null &&
                      double.parse(creditResponse.data!.getWorkspaceCredit!
                              .currentCredit!.currentCredit!) >
                          0.5) {
                    await messagesProvider!.doSendMessageApiCall(
                      defaultOne.id!,
                      dump,
                      widget.clientPhoneNumber!,
                    );
                    contactsProvider!.doGetLastContactedApiCall(
                      Map.from(
                        {
                          "contact": widget.clientPhoneNumber,
                        },
                      ),
                    );
                  } else {
                    Utils.showToastMessage(
                        Utils.getString("insufficientCredit"));
                  }
                } else {
                  Utils.showToastMessage(
                      Utils.getString("internationalCallDisabled"));
                }
              }
            }
          } else {
            if (!mounted) return;
            Utils.showWarningToastMessage(
                Utils.getString("smsNotEnable"), context);
            FocusScope.of(context).unfocus();
          }
        } else {
          if (!mounted) return;
          Utils.showToastMessage(Utils.getString("sendingSmsNotSupport"));
        }
      } else {
        Utils.showToastMessage(Utils.getString("emptyChannelSms"));
      }
    } else {
      if (!mounted) return;
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

  Future<void> showMacrosListDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return SizedBox(
          height: ScreenUtil().screenHeight * 0.9,
          child: Column(
            children: [
              Container(
                  width: Dimens.space80,
                  height: Dimens.space6,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Dimens.space33)),
                    color: CustomColors.white,
                  )),
              const SizedBox(
                height: Dimens.space10,
              ),
              Expanded(
                  child: MacrosListView(
                onBackTap: () {
                  Navigator.of(dialogContext).pop();
                },
                onItemTap: (Macro value) {
                  setState(() {
                    isSendIconVisible = true;
                  });
                  if (textEditingControllerMessage.text.length < 660) {
                    textEditingControllerMessage.text =
                        "${textEditingControllerMessage.text}${value.message} ";
                  }
                  textEditingControllerMessage.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: textEditingControllerMessage.text.length));
                  Navigator.of(dialogContext).pop();
                },
              ))
            ],
          ),
        );
      },
    );
  }
}

// ToolBar Widget
class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.clientNumber,
    required this.clientName,
    required this.clientProfilePicture,
    required this.onCallIconTap,
    required this.lastChatted,
    required this.isBlocked,
    // required this.listConversationEdge,
    required this.contactsProvider,
  }) : super(key: key);

  final String clientNumber;
  final String clientName;
  final String? clientProfilePicture;
  final Function onCallIconTap;
  final String? lastChatted;
  final bool isBlocked;
  // final List<MessageDetailsObjectWithType>? listConversationEdge;
  final ContactsProvider contactsProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      height: kToolbarHeight.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Dimens.space40.w,
            height: Dimens.space40.w,
            margin: EdgeInsets.fromLTRB(
                Dimens.space0.w, Dimens.space0, Dimens.space0, Dimens.space0),
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
              imageUrl: clientProfilePicture ?? "",
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0,
                  Dimens.space0, Dimens.space0),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RichText(
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                              text: Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : clientName,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                            Dimens.space0, Dimens.space0, Dimens.space0),
                        child: FutureBuilder<String>(
                          future: Utils.getFlagUrl(clientNumber),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return RoundedNetworkImageHolder(
                                width: Dimens.space14,
                                height: Dimens.space14,
                                boxFit: BoxFit.contain,
                                containerAlignment: Alignment.bottomCenter,
                                iconUrl: CustomIcon.icon_gallery,
                                iconColor: CustomColors.grey,
                                iconSize: Dimens.space14,
                                boxDecorationColor:
                                    CustomColors.mainBackgroundColor,
                                outerCorner: Dimens.space0,
                                innerCorner: Dimens.space0,
                                imageUrl: PSApp.config!.countryLogoUrl! +
                                    snapshot.data!,
                              );
                            }
                            return const CupertinoActivityIndicator();
                          },
                        ),
                      ),
                      contactsProvider.contactDetailResponse != null &&
                              contactsProvider.contactDetailResponse!.data !=
                                  null &&
                              contactsProvider
                                      .contactDetailResponse!.data!.dndInfo !=
                                  null &&
                              contactsProvider.contactDetailResponse!.data !=
                                  null &&
                              contactsProvider.contactDetailResponse!.data!
                                  .dndInfo!.dndEnabled
                          ? Container(
                              width: Dimens.space20.w,
                              height: Dimens.space20.w,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space8.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.centerRight,
                              child: Icon(CustomIcon.icon_client_dnd,
                                  size: Dimens.space20,
                                  color: CustomColors.textQuinaryColor),
                            )
                          : Container()
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: LayoutBuilder(builder:
                        (BuildContext ctx, BoxConstraints constraints) {
                      if (contactsProvider.lastContactedDate!.data != null) {
                        return Container(
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : "${Utils.getString("lastContacted")} ${contactsProvider.lastContactedDate?.data ?? "N/A"}",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.textPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        );
                      } else {
                        return Container(
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : "${Utils.getString("lastContacted")} ${": N/A"}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.textPrimaryColor,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: RoundedAssetSvgHolder(
              containerWidth: Dimens.space40,
              containerHeight: Dimens.space40,
              imageWidth: Dimens.space40,
              imageHeight: Dimens.space40,
              outerCorner: Dimens.space0,
              innerCorner: Dimens.space0,
              iconUrl: CustomIcon.icon_call,
              iconColor: CustomColors.mainColor!,
              iconSize: Dimens.space16,
              boxDecorationColor: Colors.transparent,
              assetUrl: "assets/images/icon_call.svg",
              onTap: onCallIconTap,
            ),
          ),
        ],
      ),
    );
  }
}
