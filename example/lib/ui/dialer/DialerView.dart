import "dart:async";
import "dart:convert";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:intercom_flutter/intercom_flutter.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/BaseStatefulState.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/area_code/AreaCodeProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/AreaCodeRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/dialog/ChannelSelectionDialog.dart";
import "package:mvp/ui/common/dialog/ContactListDialog.dart";
import "package:mvp/ui/common/dialog/CountryCodeSelectorDialog.dart";
import "package:mvp/ui/common/dialog/EmergencyCallWidgetDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddContactIntentHolder.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:provider/provider.dart";
import "package:rich_text_controller/rich_text_controller.dart";
import "package:shared_preferences/shared_preferences.dart";

class DialerView extends StatefulWidget {
  const DialerView({
    Key? key,
    required this.onLeadingTap,
    required this.makeCallWithSid,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    this.animationController,
    this.countryList,
    this.defaultCountryCode,
    this.loginWorkspaceProvider,
  }) : super(key: key);

  final AnimationController? animationController;
  final List<CountryCode>? countryList;
  final CountryCode? defaultCountryCode;
  final Function(String, String, String, String, String, String, String, String,
      String?, String) makeCallWithSid;
  final Function onLeadingTap;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  _DialerViewState createState() => _DialerViewState();
}

class _DialerViewState extends BaseStatefulState<DialerView>
    with SingleTickerProviderStateMixin {
  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;
  AreaCodeProvider? areaCodeProvider;
  AreaCodeRepository? areaCodeRepository;
  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;
  ValueHolder? valueHolder;

  bool isConnectedToInternet = false;
  bool isEditEnabled = false;

  CountryCode? selectedCountryCode;
  Contacts? selectedContact;
  Animation<double>? animation;
  final deBouncer = DeBouncer(milliseconds: 500);
  bool isLoading = false;
  StreamSubscription? streamSubscriptionOnNetworkChanged;
  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;

  // Add a controller
  RichTextController? controllerNumber;

  int cursor = 0;

  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;

  StreamSubscription? streamSubscriptionIncomingEvent;
  StreamSubscription? streamSubscriptionOutgoingEvent;

  int secondsOutgoing = 0;
  int minutesOutgoing = 0;
  int secondsIncoming = 0;
  int minutesIncoming = 0;

  @override
  void initState() {
    doCheckConnection();

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    areaCodeRepository =
        Provider.of<AreaCodeRepository>(context, listen: false);
    areaCodeProvider = AreaCodeProvider(areaCodeRepository: areaCodeRepository);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(contactRepository: contactRepository);

    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);

    initController();

    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      /// toolbar title wont changes so need this
      setState(() {});
    });

    super.initState();

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

  @override
  void dispose() {
    streamSubscriptionOnNetworkChanged?.cancel();
    streamSubscriptionOnWorkspaceOrChannelChanged?.cancel();
    controllerNumber?.dispose();

    streamSubscriptionIncomingEvent?.cancel();
    streamSubscriptionOutgoingEvent?.cancel();

    super.dispose();
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

  Future<bool> _requestPop() {
    widget.animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, true);
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.white,
          body: ChangeNotifierProvider<ContactsProvider>(
            lazy: false,
            create: (BuildContext context) {
              contactsProvider = ContactsProvider(
                contactRepository: contactRepository,
              );
              contactsProvider!.doAllContactApiCall();
              return contactsProvider!;
            },
            child: Consumer<ContactsProvider>(
              builder: (BuildContext context, ContactsProvider? provider1,
                  Widget? child) {
                return AnimatedBuilder(
                  animation: widget.animationController!,
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                      opacity: animation!,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1 - animation!.value), 0.0),
                        child: Container(
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
                          color: CustomColors.white,
                          alignment: Alignment.center,
                          child: Consumer<DashboardProvider>(
                            builder: (context, data, _) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: double.infinity,
                                    color: CustomColors.white,
                                    height: internetConnectionStatus ==
                                            InternetConnectionStatus.connected
                                        ? (data.outgoingIsCallConnected ||
                                                data.incomingIsCallConnected)
                                            ? kToolbarHeight.h
                                            : Dimens.space0.h
                                        : (data.outgoingIsCallConnected ||
                                                data.incomingIsCallConnected)
                                            ? kToolbarHeight.h +
                                                Dimens.space26.h
                                            : Dimens.space26.h,
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        customViewNoInternet(),
                                        Offstage(
                                          offstage:
                                              !data.outgoingIsCallConnected,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space0.h),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              backgroundColor: CustomColors
                                                  .callOnProgressColor,
                                              alignment: Alignment.center,
                                              shape:
                                                  const RoundedRectangleBorder(),
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
                                          ),
                                        ),
                                        Offstage(
                                          offstage:
                                              !data.incomingIsCallConnected,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space0.h),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              backgroundColor: CustomColors
                                                  .callOnProgressColor,
                                              alignment: Alignment.center,
                                              shape:
                                                  const RoundedRectangleBorder(),
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
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
                                      color: CustomColors.white,
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space60.w,
                                                  Dimens.space0.h,
                                                  Dimens.space60.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: Dimens.space43.w,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                      ),
                                                      onPressed: () {
                                                        showCountryCodeSelectorDialog(
                                                            onSelectCountryCode:
                                                                (CountryCode
                                                                    countryCode) {
                                                          updateContact(
                                                              countryCode,
                                                              contactsProvider!
                                                                  .dialCode,
                                                              controllerNumber!);
                                                          controllerNumber!
                                                                  .selection =
                                                              TextSelection
                                                                  .fromPosition(
                                                            TextPosition(
                                                                offset:
                                                                    controllerNumber!
                                                                        .text
                                                                        .length),
                                                          );
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          StreamBuilder(
                                                            stream: contactsProvider!
                                                                .streamControllerCountryFlagUrl!
                                                                .stream,
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        String>
                                                                    snapshot) {
                                                              String flagUri =
                                                                  "";
                                                              if (snapshot
                                                                      .hasData &&
                                                                  snapshot.data !=
                                                                      null) {
                                                                flagUri =
                                                                    snapshot
                                                                        .data!;
                                                              }
                                                              return Container(
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    RoundedNetworkImageHolder(
                                                                  width: Dimens
                                                                      .space26,
                                                                  height: Dimens
                                                                      .space26,
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                  iconUrl:
                                                                      CustomIcon
                                                                          .icon_gallery,
                                                                  iconColor:
                                                                      CustomColors
                                                                          .grey,
                                                                  iconSize: Dimens
                                                                      .space20,
                                                                  boxDecorationColor:
                                                                      CustomColors
                                                                          .mainBackgroundColor,
                                                                  outerCorner:
                                                                      Dimens
                                                                          .space0,
                                                                  innerCorner:
                                                                      Dimens
                                                                          .space0,
                                                                  imageUrl:
                                                                      flagUri,
                                                                  onTap: () {
                                                                    showCountryCodeSelectorDialog(
                                                                      onSelectCountryCode:
                                                                          (CountryCode
                                                                              countryCode) {
                                                                        updateContact(
                                                                          countryCode,
                                                                          contactsProvider!
                                                                              .dialCode,
                                                                          controllerNumber!,
                                                                        );
                                                                        controllerNumber!.selection =
                                                                            TextSelection.fromPosition(
                                                                          TextPosition(
                                                                              offset: controllerNumber!.text.length),
                                                                        );
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space9
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              CustomIcon
                                                                  .icon_drop_down,
                                                              color: CustomColors
                                                                  .textQuinaryColor,
                                                              size: Dimens
                                                                  .space5.w,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space8.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: StreamBuilder(
                                                        stream: contactsProvider!
                                                            .phoneNumberStream!
                                                            .stream,
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    String>
                                                                snapshot) {
                                                          return Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            height: Dimens
                                                                .space52.h,
                                                            child: TextField(
                                                              controller:
                                                                  controllerNumber,
                                                              showCursor: true,
                                                              selectionControls:
                                                                  FlutterSelectionControls(
                                                                toolBarItems: [
                                                                  ToolBarItem(
                                                                      item:
                                                                          const Text(
                                                                        "Select All",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      itemControl:
                                                                          ToolBarItemControl
                                                                              .selectAll),
                                                                  ToolBarItem(
                                                                      item:
                                                                          const Text(
                                                                        "Copy",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      itemControl:
                                                                          ToolBarItemControl
                                                                              .copy),
                                                                  ToolBarItem(
                                                                      item:
                                                                          const Text(
                                                                        "Cut",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      itemControl:
                                                                          ToolBarItemControl
                                                                              .cut),
                                                                  ToolBarItem(
                                                                      item:
                                                                          const Text(
                                                                        "Paste",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      itemControl:
                                                                          ToolBarItemControl
                                                                              .paste),
                                                                ],
                                                              ),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: contactsProvider!.dialCode !=
                                                                            null
                                                                        ? (controllerNumber!.text.length >
                                                                                contactsProvider!.dialCode!.dialCode!.length
                                                                            ? controllerNumber!.text.substring(contactsProvider!.dialCode!.dialCode!.length).isNotEmpty
                                                                                ? CustomColors.textPrimaryColor
                                                                                : CustomColors.textQuinaryColor
                                                                            : CustomColors.textQuinaryColor)
                                                                        : CustomColors.textQuinaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontSize: Dimens
                                                                        .space24
                                                                        .sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  ),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                ),
                                                                isDense: false,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                disabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: CustomColors
                                                                        .transparent!,
                                                                    width: Dimens
                                                                        .space0
                                                                        .w,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        Dimens
                                                                            .space0
                                                                            .r),
                                                                  ),
                                                                ),
                                                                filled: true,
                                                                fillColor:
                                                                    CustomColors
                                                                        .transparent,
                                                                prefixIconConstraints:
                                                                    BoxConstraints(
                                                                  minWidth:
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                  maxWidth:
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                  maxHeight:
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                  minHeight:
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                ),
                                                                hintText: Utils
                                                                    .getString(
                                                                        "enterNumber"),
                                                                hintStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      color: CustomColors
                                                                          .textQuinaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .manropeSemiBold,
                                                                      fontSize: Dimens
                                                                          .space24
                                                                          .sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                    ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .none,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .search,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space14.h,
                                                  Dimens.space0.w,
                                                  Dimens.space20.h),
                                              alignment: Alignment.center,
                                              child: StreamBuilder(
                                                stream: contactsProvider!
                                                    .validContactStream!.stream,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<bool>
                                                        snapshot) {
                                                  bool isValid = false;
                                                  if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    isValid = snapshot.data!;
                                                  }
                                                  if (isValid &&
                                                      contactsProvider!
                                                              .selectedContact
                                                              .data !=
                                                          null &&
                                                      contactsProvider!
                                                          .selectedContact
                                                          .data!
                                                          .isNotEmpty) {
                                                    return InkWell(
                                                      onTap: () async {},
                                                      child: RichText(
                                                        softWrap: false,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textTertiaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeRegular,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space15
                                                                        .sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                          text: Config
                                                                  .checkOverFlow
                                                              ? Const.OVERFLOW
                                                              : contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .name!
                                                                          .length >
                                                                      35
                                                                  ? "${contactsProvider!.selectedContact.data![0].name!.substring(0, 35)}..."
                                                                  : contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .name ??
                                                                      Utils.getString(
                                                                          "Unknown"),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  controllerNumber!
                                                                          .text =
                                                                      contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .number!;
                                                                  cursor =
                                                                      controllerNumber!
                                                                          .text
                                                                          .length;
                                                                  controllerNumber!
                                                                          .selection =
                                                                      TextSelection
                                                                          .fromPosition(
                                                                    TextPosition(
                                                                      offset:
                                                                          cursor,
                                                                    ),
                                                                  );
                                                                },
                                                          children: [
                                                            contactsProvider!
                                                                        .selectedContact
                                                                        .data!
                                                                        .length ==
                                                                    1
                                                                ? TextSpan(
                                                                    text: "",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .button!
                                                                        .copyWith(
                                                                          color:
                                                                              CustomColors.loadingCircleColor,
                                                                          fontFamily:
                                                                              Config.manropeRegular,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize: Dimens
                                                                              .space15
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {},
                                                                  )
                                                                : TextSpan(
                                                                    text:
                                                                        "  +${contactsProvider!.selectedContact.data!.length - 1} more",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .button!
                                                                        .copyWith(
                                                                          color:
                                                                              CustomColors.loadingCircleColor,
                                                                          fontFamily:
                                                                              Config.manropeRegular,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize: Dimens
                                                                              .space15
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            showContactDialog(contactsProvider!.selectedContact.data);
                                                                          },
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else if (isValid &&
                                                      contactsProvider!
                                                              .selectedContact
                                                              .data !=
                                                          null &&
                                                      contactsProvider!
                                                          .selectedContact
                                                          .data!
                                                          .isEmpty) {
                                                    return InkWell(
                                                      onTap: () async {
                                                        final dynamic
                                                            returnData =
                                                            await Navigator
                                                                .pushNamed(
                                                          context,
                                                          RoutePaths.newContact,
                                                          arguments:
                                                              AddContactIntentHolder(
                                                            phoneNumber:
                                                                controllerNumber!
                                                                    .text,
                                                            defaultCountryCode:
                                                                contactsProvider!
                                                                    .dialCode,
                                                            onIncomingTap: () {
                                                              widget
                                                                  .onIncomingTap();
                                                            },
                                                            onOutgoingTap: () {
                                                              widget
                                                                  .onOutgoingTap();
                                                            },
                                                          ),
                                                        );
                                                        if (returnData !=
                                                                null &&
                                                            returnData["data"]
                                                                as bool) {
                                                          controllerNumber!
                                                                  .text =
                                                              selectedCountryCode!
                                                                  .dialCode!;
                                                          setState(() {});
                                                          contactsProvider!
                                                              .doAllContactApiCall();
                                                        }
                                                      },
                                                      child: (contactsProvider!
                                                                      .dialCode !=
                                                                  null &&
                                                              contactsProvider!
                                                                  .checkIsEmergencyNumber(
                                                                      contactsProvider!
                                                                          .phoneNumber))
                                                          ? Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          ""),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                                  color: CustomColors
                                                                      .loadingCircleColor,
                                                                  fontFamily: Config
                                                                      .manropeSemiBold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: Dimens
                                                                      .space15
                                                                      .sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            )
                                                          : Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils.getString(
                                                                      "addContacts"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .button!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .loadingCircleColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeRegular,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space15
                                                                        .sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                    );
                                                  } else if (!isValid &&
                                                      contactsProvider!
                                                              .selectedContact
                                                              .data !=
                                                          null &&
                                                      contactsProvider!
                                                          .selectedContact
                                                          .data!
                                                          .isNotEmpty) {
                                                    return InkWell(
                                                      onTap: () async {},
                                                      child: RichText(
                                                        softWrap: false,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textTertiaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeRegular,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space15
                                                                        .sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                          text: Config
                                                                  .checkOverFlow
                                                              ? Const.OVERFLOW
                                                              : contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .name!
                                                                          .length >
                                                                      30
                                                                  ? "${contactsProvider!.selectedContact.data![0].name!.substring(0, 30)}..."
                                                                  : contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .name ??
                                                                      Utils.getString(
                                                                          "Unknown"),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  controllerNumber!
                                                                          .text =
                                                                      contactsProvider!
                                                                          .selectedContact
                                                                          .data![
                                                                              0]
                                                                          .number!;
                                                                  cursor =
                                                                      controllerNumber!
                                                                          .text
                                                                          .length;
                                                                  controllerNumber!
                                                                          .selection =
                                                                      TextSelection
                                                                          .fromPosition(
                                                                    TextPosition(
                                                                      offset:
                                                                          cursor,
                                                                    ),
                                                                  );
                                                                },
                                                          children: [
                                                            contactsProvider!
                                                                        .selectedContact
                                                                        .data!
                                                                        .length ==
                                                                    1
                                                                ? TextSpan(
                                                                    text: "",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .button!
                                                                        .copyWith(
                                                                          color:
                                                                              CustomColors.loadingCircleColor,
                                                                          fontFamily:
                                                                              Config.manropeRegular,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize: Dimens
                                                                              .space15
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {},
                                                                  )
                                                                : TextSpan(
                                                                    text:
                                                                        "  +${contactsProvider!.selectedContact.data!.length - 1} more",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .button!
                                                                        .copyWith(
                                                                          color:
                                                                              CustomColors.loadingCircleColor,
                                                                          fontFamily:
                                                                              Config.manropeRegular,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize: Dimens
                                                                              .space15
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            showContactDialog(contactsProvider!.selectedContact.data);
                                                                          },
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .button!
                                                          .copyWith(
                                                            color: CustomColors
                                                                .textPrimaryColor,
                                                            fontFamily: Config
                                                                .manropeSemiBold,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: Dimens
                                                                .space15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space14.h,
                                                  Dimens.space0.w,
                                                  Dimens.space14.h),
                                              alignment: Alignment.center,
                                              height: Dimens.space30.h,
                                              color: contactsProvider!
                                                      .timeZone.isNotEmpty
                                                  ? CustomColors.timezoneColor
                                                  : CustomColors.transparent,
                                              child: RichText(
                                                softWrap: false,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button!
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textTertiaryColor,
                                                        fontFamily: Config
                                                            .manropeRegular,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize:
                                                            Dimens.space15.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  text: Config.checkOverFlow
                                                      ? Const.OVERFLOW
                                                      : contactsProvider!
                                                              .timeZone
                                                              .isNotEmpty
                                                          ? contactsProvider!
                                                              .timeZone
                                                          : "",
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: Dimens.space10.h),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space16.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("1");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Text(
                                                          Config.checkOverFlow
                                                              ? Const.OVERFLOW
                                                              : Utils.getString(
                                                                  "1"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("2");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "2"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "abc"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("3");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "3"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "def"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
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
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space16.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("4");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "4"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "ghi"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("5");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "5"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "jkl"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("6");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "6"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "mno"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
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
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space16.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("7");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "7"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "pqrs"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1
                                                                        .h,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("8");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "8"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "tuv"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space100
                                                                      .r),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        validate("9");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "9"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .manropeSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space32
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1andHalf
                                                                        .h,
                                                                  ),
                                                            ),
                                                            Text(
                                                              Config.checkOverFlow
                                                                  ? Const
                                                                      .OVERFLOW
                                                                  : Utils
                                                                      .getString(
                                                                          "wxyz"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    color: CustomColors
                                                                        .textSenaryColor,
                                                                    fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize: Dimens
                                                                        .space12
                                                                        .sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    height: Dimens
                                                                        .space1,
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
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space16.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space70
                                                                      .r),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                      onPressed: () {
                                                        validate("*");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                Config.checkOverFlow
                                                                    ? Const
                                                                        .OVERFLOW
                                                                    : Utils
                                                                        .getString(
                                                                            "*"),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      color: CustomColors
                                                                          .textSenaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .manropeSemiBold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: Dimens
                                                                          .space32
                                                                          .sp,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      height: Dimens
                                                                          .space1andHalf
                                                                          .h,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space70
                                                                      .r),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                      onLongPress: () {
                                                        validate("+");
                                                      },
                                                      onPressed: () {
                                                        validate("0");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                Config.checkOverFlow
                                                                    ? Const
                                                                        .OVERFLOW
                                                                    : Utils
                                                                        .getString(
                                                                            "0"),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      color: CustomColors
                                                                          .textSenaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .manropeSemiBold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: Dimens
                                                                          .space32
                                                                          .sp,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      height: Dimens
                                                                          .space1andHalf
                                                                          .h,
                                                                    ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                Config.checkOverFlow
                                                                    ? Const
                                                                        .OVERFLOW
                                                                    : Utils
                                                                        .getString(
                                                                            "+"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      color: CustomColors
                                                                          .textSenaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .heeboMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: Dimens
                                                                          .space16
                                                                          .sp,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      height: Dimens
                                                                          .space1
                                                                          .h,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .space70
                                                                      .r),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                      onPressed: () {
                                                        validate("#");
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        alignment:
                                                            Alignment.center,
                                                        width: Dimens.space80.w,
                                                        height:
                                                            Dimens.space80.w,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                Config.checkOverFlow
                                                                    ? Const
                                                                        .OVERFLOW
                                                                    : Utils
                                                                        .getString(
                                                                            "#"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                      color: CustomColors
                                                                          .textSenaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .manropeSemiBold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: Dimens
                                                                          .space32
                                                                          .sp,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      height: Dimens
                                                                          .space1andHalf
                                                                          .h,
                                                                    ),
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
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space10.w,
                                                  Dimens.space0.h,
                                                  Dimens.space10.w,
                                                  Dimens.space16.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: StreamBuilder(
                                                      stream: contactsProvider!
                                                          .validContactStream!
                                                          .stream,
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshot) {
                                                        if (contactsProvider!
                                                            .checkIsEmergencyNumber(
                                                                contactsProvider!
                                                                    .phoneNumber)) {
                                                          return TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              backgroundColor:
                                                                  CustomColors
                                                                      .callAcceptColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(Dimens
                                                                            .space100
                                                                            .r),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              initCallForEmergencyNumber();
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: Dimens
                                                                  .space80.w,
                                                              height: Dimens
                                                                  .space80.w,
                                                              child: Icon(
                                                                CustomIcon
                                                                    .icon_call,
                                                                size: Dimens
                                                                    .space32.w,
                                                                color:
                                                                    CustomColors
                                                                        .white,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return AbsorbPointer(
                                                            absorbing: false,
                                                            child: TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                backgroundColor:
                                                                    CustomColors
                                                                        .callAcceptColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(Dimens
                                                                          .space100
                                                                          .r),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                initCallForNormalNumber();
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: Dimens
                                                                    .space80.w,
                                                                height: Dimens
                                                                    .space80.w,
                                                                child: Icon(
                                                                  CustomIcon
                                                                      .icon_call,
                                                                  size: Dimens
                                                                      .space32
                                                                      .w,
                                                                  color:
                                                                      CustomColors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    width: Dimens.space80.w,
                                                    height: Dimens.space80.w,
                                                    child: Offstage(
                                                      offstage:
                                                          controllerNumber !=
                                                                  null &&
                                                              controllerNumber!
                                                                  .text
                                                                  .isNotEmpty &&
                                                              controllerNumber!
                                                                      .text ==
                                                                  "+",
                                                      child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                          ),
                                                          tapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          backgroundColor:
                                                              CustomColors
                                                                  .bottomAppBarColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(Dimens
                                                                        .space100
                                                                        .r),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          if (controllerNumber!
                                                              .text
                                                              .isNotEmpty) {
                                                            final String
                                                                before =
                                                                controllerNumber!
                                                                    .text
                                                                    .substring(
                                                                        0,
                                                                        cursor);
                                                            final String after =
                                                                controllerNumber!
                                                                    .text
                                                                    .substring(
                                                              cursor,
                                                              controllerNumber!
                                                                  .text.length,
                                                            );

                                                            if (before
                                                                .isEmpty) {
                                                              Utils.cPrint(
                                                                  "Validate if");
                                                              Utils.cPrint(
                                                                  before);
                                                              Utils.cPrint(
                                                                  after);
                                                              validate("");
                                                            } else {
                                                              Utils.cPrint(
                                                                  "Validate else");
                                                              Utils.cPrint(
                                                                  before);
                                                              Utils.cPrint(
                                                                  after);
                                                              Utils.cPrint(before
                                                                  .substring(
                                                                      0,
                                                                      before.length -
                                                                          1));
                                                              controllerNumber!
                                                                  .text = before
                                                                      .substring(
                                                                          0,
                                                                          before.length -
                                                                              1) +
                                                                  after;
                                                              Utils.cPrint(
                                                                  "Controller Text ${controllerNumber!.text}");
                                                              cursor =
                                                                  cursor - 1;
                                                            }
                                                          } else {
                                                            Utils.cPrint(
                                                                "Validate Empty");
                                                            validate("");
                                                          }
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                          alignment:
                                                              Alignment.center,
                                                          width:
                                                              Dimens.space80.w,
                                                          height:
                                                              Dimens.space80.w,
                                                          child: Icon(
                                                            CustomIcon
                                                                .icon_back_space,
                                                            color: CustomColors
                                                                .textQuaternaryColor,
                                                            size: Dimens
                                                                .space26.w,
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
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void updateContact(CountryCode selectedCode, CountryCode? previousCode,
      TextEditingController controller) {
    String number;
    final String text = controller.text;
    if (text.isNotEmpty) {
      if (text.contains(selectedCode.dialCode!)) {
        number = text.replaceRange(
            0, selectedCode.dialCode!.length, selectedCode.dialCode!);
      } else {
        if (text.length > selectedCode.dialCode!.length) {
          number = text.replaceRange(
              0, selectedCode.dialCode!.length, selectedCode.dialCode!);
        } else {
          number = selectedCode.dialCode!;
        }
      }
    } else {
      number = selectedCode.dialCode!;
    }
    isEditEnabled = false;
    selectedCountryCode = selectedCode;
    controllerNumber!.text = number;
  }

  Future<void> showCountryCodeSelectorDialog(
      {required Function(CountryCode) onSelectCountryCode}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space10.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return CountryCodeSelectorDialog(
          countryCodeList: widget.countryList,
          selectedCountryCode: selectedCountryCode,
          onSelectCountryCode: onSelectCountryCode,
        );
      },
    );
  }

  void _channelSelectionDialog({
    BuildContext? context,
    List<WorkspaceChannel>? channelList,
    Function(WorkspaceChannel)? onChannelTap,
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
          onChannelTap: onChannelTap,
        ),
      ),
    );
  }

  Future<void> initController() async {
    final List<CountryCode> dump =
        await countryListProvider!.getCountryListFromDb() as List<CountryCode>;
    final Map<RegExp, TextStyle> dumpReg = {};
    for (final element in dump) {
      dumpReg.addAll({
        RegExp("\\${element.dialCode}", caseSensitive: false): TextStyle(
          color: CustomColors.textQuinaryColor,
          fontFamily: Config.manropeSemiBold,
          fontSize: Dimens.space24.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        )
      });
    }
    controllerNumber = RichTextController(
      patternMatchMap: dumpReg,
      //* starting v1.2.0
      // Now you have the option to add string Matching!
      //! Assertion: Only one of the two matching options can be given at a time!

      //* starting v1.1.0
      //* Now you have an onMatch callback that gives you access to a List<String>
      //* which contains all matched strings
      onMatch: (List<String> matches) {},
      deleteOnBack: true,
    );

    controllerNumber!.addListener(() async {
      if (selectedCountryCode != null) {
        if (controllerNumber!.text.isNotEmpty) {
          if (controllerNumber!.text.length <
              selectedCountryCode!.dialCode!.length) {
            isEditEnabled = true;
          }
        }
      }

      contactsProvider!.validatePhoneNumber(context, controllerNumber!.text,
          countryCode: isEditEnabled ? selectedCountryCode : null);

      contactsProvider!.validateTimeZone(controllerNumber!.text, context);

      if (controllerNumber!.value.selection.start != -1) {
        cursor = controllerNumber!.value.selection.start;
      } else {
        Future.delayed(
          const Duration(
            milliseconds: 20,
          ),
        ).then(
          (value) {
            Utils.cPrint("Controller Text ${controllerNumber!.text}");
            controllerNumber!.selection = TextSelection.fromPosition(
              TextPosition(
                offset: cursor,
              ),
            );
            Utils.cPrint("On changed set cursor $cursor");
          },
        );
      }
      Utils.cPrint("On Changed ${controllerNumber!.value.selection.start}");
    });

    final SharedPreferences prefs = await Utils.getSharedPreference();
    final String selectedCountry =
        prefs.getString(Const.VALUE_HOLDER_SELECTED_COUNTRY_CODE) ?? "";
    if (selectedCountry.length > 1) {
      controllerNumber!.text =
          CountryCode().fromMap(jsonDecode(selectedCountry))!.dialCode!;
    } else {
      if (widget.loginWorkspaceProvider!.getDefaultChannel() != null) {
        controllerNumber!.text =
            widget.loginWorkspaceProvider!.getDefaultChannel().countryCode!;
      } else {
        controllerNumber!.text = "+1";
      }
    }

    cursor = controllerNumber!.text.length;

    controllerNumber!.selection = TextSelection.fromPosition(
      TextPosition(offset: controllerNumber!.text.length),
    );

    Utils.cPrint("Cursor $cursor");
  }

  Future<void> validate(String number, {bool shouldDecrease = false}) async {
    if (number.isNotEmpty) {
      if (controllerNumber!.text.length < 15) {
        final String before = controllerNumber!.text.substring(0, cursor);
        final String after = controllerNumber!.text
            .substring(cursor, controllerNumber!.text.length);
        controllerNumber!.text = before + number + after;

        if (number.isEmpty && !shouldDecrease) {
          updateCursor(cursor);
        } else if (number.isEmpty && !shouldDecrease) {
          updateCursor(cursor - 1);
        } else {
          updateCursor(cursor + 1);
        }
      }
    } else {
      if (number.isEmpty && !shouldDecrease) {
        updateCursor(cursor);
      } else {
        updateCursor(cursor - 1);
      }
    }
  }

  void updateCursor(int number) {
    cursor = number;
    controllerNumber!.selection = TextSelection.fromPosition(
      TextPosition(
        offset: cursor,
      ),
    );
    Utils.cPrint("Final cursor $cursor");
  }

  Future<void> showContactDialog(List<Contacts>? contacts) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space10.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext dialogContext) {
        return SizedBox(
          height: ScreenUtil().screenHeight * 0.90,
          child: ContactListDialog(
            animationController: widget.animationController!,
            contacts: contacts!,
            onItemTap: (selectedContact) {
              controllerNumber!.text = selectedContact.number!;
              cursor = controllerNumber!.text.length;
              controllerNumber!.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: cursor,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> initCallForEmergencyNumber() async {
    Utils.checkInternetConnectivity().then(
      (value) async {
        if (value) {
          if (contactsProvider!.phoneNumber != null &&
              contactsProvider!
                  .checkIsEmergencyNumber(contactsProvider!.phoneNumber)) {
            await showModalBottomSheet(
              context: context,
              elevation: 0,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (dialogContext) => SizedBox(
                height: ScreenUtil().screenHeight * 0.42,
                child: EmergencyCallWidgetDialog(
                  onTap: () async {
                    if (value) {
                      Navigator.of(dialogContext).pop();

                      deBouncer.run(() async {
                        Intercom.instance.displayMessenger();
                      });
                    } else {
                      Utils.showWarningToastMessage(
                          Utils.getString("noInternet"), context);
                    }
                  },
                ),
              ),
            );
          } else {
            if (contactsProvider!.getChannelList() != null &&
                contactsProvider!.getChannelList()!.isNotEmpty) {
              if (contactsProvider!.getChannelList()!.length == 1) {
                widget.makeCallWithSid(
                  contactsProvider!.getDefaultChannel().number!,
                  contactsProvider!.getDefaultChannel().name!,
                  contactsProvider!.getDefaultChannel().id!,
                  controllerNumber!.text,
                  contactsProvider!.getDefaultWorkspace(),
                  contactsProvider!.getMemberId(),
                  contactsProvider!.getVoiceToken()!,
                  selectedContact != null
                      ? selectedContact!.name!
                      : selectedContact!.number!,
                  selectedContact != null ? selectedContact!.id! : "",
                  selectedContact != null
                      ? selectedContact!.profilePicture!
                      : "",
                );
              } else {
                _channelSelectionDialog(
                    context: context,
                    channelList: contactsProvider!.getChannelList(),
                    onChannelTap: (WorkspaceChannel data) {
                      widget.makeCallWithSid(
                        data.number!,
                        data.name!,
                        data.id!,
                        controllerNumber!.text,
                        contactsProvider!.getDefaultWorkspace(),
                        contactsProvider!.getMemberId(),
                        contactsProvider!.getVoiceToken()!,
                        selectedContact != null
                            ? selectedContact!.name!
                            : selectedContact!.number!,
                        selectedContact != null ? selectedContact!.id : null,
                        selectedContact != null
                            ? selectedContact!.profilePicture!
                            : "",
                      );
                    });
              }
            } else {
              Utils.showToastMessage(Utils.getString("emptyChannel"));
            }
          }
        } else {
          Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
        }
      },
    );
  }

  Future<void> initCallForNormalNumber() async {
    if (!contactsProvider!.isValidContact!) {
      if (controllerNumber!.text.contains("+31")) {
        final RegExp regExp = RegExp(r"^[+31][0-9]{11,15}$");
        if (!regExp.hasMatch(controllerNumber!.text)) {
          Utils.showToastMessage(Utils.getString("invalidPhoneNumber"));
          return;
        }
      } else if (controllerNumber!.text.contains("+372")) {
        final RegExp regExp = RegExp(r"^[+372][0-9]{10,12}$");
        if (!regExp.hasMatch(controllerNumber!.text)) {
          Utils.showToastMessage(Utils.getString("invalidPhoneNumber"));
          return;
        }
      } else {
        Utils.showToastMessage(Utils.getString("invalidPhoneNumber"));
        return;
      }
    }
    final RegExp regExp = RegExp(r"^[+][0-9]+$");
    if (!regExp.hasMatch(controllerNumber!.text)) {
      Utils.showToastMessage(Utils.getString("invalidPhoneNumber"));
      return;
    }

    Utils.checkInternetConnectivity().then((value) async {
      if (value) {
        if (contactsProvider!.phoneNumber != null &&
            contactsProvider!
                .checkIsEmergencyNumber(contactsProvider!.phoneNumber)) {
          await showModalBottomSheet(
            context: context,
            elevation: 0,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (dialogContext) => SizedBox(
              height: ScreenUtil().screenHeight * 0.42,
              child: EmergencyCallWidgetDialog(
                onTap: () async {
                  if (value) {
                    Navigator.of(dialogContext).pop();

                    deBouncer.run(() async {
                      Intercom.instance.displayMessenger();
                    });
                  } else {
                    Utils.showWarningToastMessage(
                        Utils.getString("noInternet"), context);
                  }
                },
              ),
            ),
          );
        } else {
          if (contactsProvider!.getChannelList() != null &&
              contactsProvider!.getChannelList()!.isNotEmpty) {
            if (contactsProvider!.getChannelList()!.length == 1) {
              widget.makeCallWithSid(
                contactsProvider!.getDefaultChannel().number!,
                contactsProvider!.getDefaultChannel().name!,
                contactsProvider!.getDefaultChannel().id!,
                controllerNumber!.text,
                contactsProvider!.getDefaultWorkspace(),
                contactsProvider!.getMemberId(),
                contactsProvider!.getVoiceToken()!,
                selectedContact != null ? selectedContact!.name! : "",
                selectedContact != null ? selectedContact!.id! : "",
                selectedContact != null ? selectedContact!.profilePicture! : "",
              );
            } else {
              _channelSelectionDialog(
                  context: context,
                  channelList: contactsProvider!.getChannelList(),
                  onChannelTap: (WorkspaceChannel data) {
                    widget.makeCallWithSid(
                      data.number!,
                      data.name!,
                      data.id!,
                      controllerNumber!.text,
                      contactsProvider!.getDefaultWorkspace(),
                      contactsProvider!.getMemberId(),
                      contactsProvider!.getVoiceToken()!,
                      selectedContact != null
                          ? selectedContact!.name!
                          : Utils.getString("unknown"),
                      selectedContact != null ? selectedContact!.id : null,
                      selectedContact != null
                          ? selectedContact!.profilePicture!
                          : "",
                    );
                  });
            }
          } else {
            Utils.showToastMessage(Utils.getString("emptyChannel"));
          }
        }
      } else {
        Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
      }
    });
  }
}

class FlutterSelectionControls extends MaterialTextSelectionControls {
  /// FlutterSelectionControls takes a list of ToolBarItem(s) as arguments
  /// The ToolBarItems takes a widget as an argument and it will be shown on the tool bar when the text is selected
  ///
  ///
  FlutterSelectionControls(
      {required this.toolBarItems,
      this.horizontalPadding = 16,
      this.verticalPadding = 10})
      : assert(toolBarItems.isNotEmpty);
  final List<ToolBarItem> toolBarItems;

  /// This controls the amount of horizontal space between each tool bar item
  final double horizontalPadding;

  /// This controls the amount of vertical space between each tool bar item and the text selection tool bar
  final double verticalPadding;

  // This controlls the padding between the toolbar and the anchor.
  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;

  /// This is called when a [ToolBarItem] is tapped or pressed
  Future<void> _onItemSelected({
    required ToolBarItem? item,
    required TextSelectionDelegate delegate,
    required ClipboardStatusNotifier clipboardStatus,
  }) async {
    /// Handles the callback if the itemControl was passed as an argument to the pressed [ToolBarItem]
    if (item!.itemControl != null) {
      final ToolBarItemControl control = item.itemControl!;

      /// Handle the callback if the itemControl passed is of type [ToolBarItemControl.copy]
      if (control == ToolBarItemControl.copy) {
        if (canCopy(delegate)) return handleCopy(delegate, clipboardStatus);
        return;
      }

      /// Handle the callback if the itemControl passed is of type [ToolBarItemControl.selectAll]
      if (control == ToolBarItemControl.selectAll) {
        if (canSelectAll(delegate)) return handleSelectAll(delegate);
        return;
      }

      /// Handle the callback if the itemControl passed is of type [ToolBarItemControl.paste]
      if (control == ToolBarItemControl.paste) {
        bool shouldPaste = true;
        final ClipboardData? cdata =
            await Clipboard.getData(Clipboard.kTextPlain);
        final String dump = cdata!.text!;
        if (dump == null) {
          shouldPaste = false;
        } else {
          Utils.cPrint("Clip Board $dump");
          final RegExp regExp = RegExp(r"^[+0-9]+$");
          shouldPaste = regExp.hasMatch(dump);
        }
        if (canPaste(delegate) && shouldPaste) return handlePaste(delegate);
        Utils.showToastMessage("Invalid Phone Number");
        return;
      }

      /// Handle the callback if the itemControl passed is of type [ToolBarItemControl.cut]
      if (control == ToolBarItemControl.cut) {
        if (canCut(delegate)) return handleCut(delegate);
        return;
      }
      return;
    }

    /// If the argument [onItemPressed] was passed instead of the [itemControl] argument...
    /// ..we return a [void Function(String, int, int)] which will have:
    /// 1. The Highlighted Text
    /// 2. The start index of the highlighted text
    /// 3. The end index of the highlighted text
    ///
    final TextEditingValue value = delegate.textEditingValue;

    /// This is the highlighted text
    final String highlighted =
        value.text.substring(value.selection.start, value.selection.end);
    delegate.userUpdateTextEditingValue(
      TextEditingValue(
        text: value.text,
        selection: TextSelection.collapsed(offset: value.selection.end),
      ),
      SelectionChangedCause.toolbar,
    );
    delegate.hideToolbar();
    return item.onItemPressed!(
        highlighted, value.selection.start, value.selection.end);
  }

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect? globalEditableRegion,
    double? textLineHeight,
    Offset? selectionMidpoint,
    List<TextSelectionPoint>? endpoints,
    TextSelectionDelegate? delegate,
    ClipboardStatusNotifier? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final TextSelectionPoint startTextSelectionPoint = endpoints![0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(
        globalEditableRegion!.left + (selectionMidpoint ?? Offset.zero).dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight! -
            _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + (selectionMidpoint ?? Offset.zero).dx,
      globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );
    return _SelectionToolBar(
        anchorAbove: anchorAbove,
        anchorBelow: anchorBelow,
        clipboardStatus: clipboardStatus!,
        toolBarItems: toolBarItems,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        canCopy: canCopy(delegate!),
        canCut: canCut(delegate),
        canPaste: canPaste(delegate),
        canSelectAll: canSelectAll(delegate),
        onItemSelected: (ToolBarItem item) => _onItemSelected(
            item: item, delegate: delegate, clipboardStatus: clipboardStatus));
  }
}

class _SelectionToolBar extends StatefulWidget {
  const _SelectionToolBar({
    Key? key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.clipboardStatus,
    required this.toolBarItems,
    required this.onItemSelected,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.canCopy,
    required this.canCut,
    required this.canPaste,
    required this.canSelectAll,
  }) : super(key: key);

  /// The focal point above which the toolbar attempts to position itself.
  final Offset anchorAbove;

  /// The focal point below which the toolbar attempts to position itself, if it doesn't fit above [anchorAbove].
  final Offset anchorBelow;

  ///A [ValueNotifier] whose [value] indicates whether the current contents of the clipboard can be pasted.
  final ClipboardStatusNotifier clipboardStatus;

  /// Widgets to be displayed on the text selection tool bar
  final List<ToolBarItem> toolBarItems;

  /// A callback function when a [ToolBarItem] is pressed
  final Function(ToolBarItem) onItemSelected;

  /// This controls the amount of vertical space between each tool bar item
  final double horizontalPadding;

  /// This controls the amount of vertical space between each tool bar item and the text selection tool bar
  final double verticalPadding;

  /// Check if the highlighted text can be copied
  final bool canCopy;

  /// Check if the highlighted text can be cut
  final bool canCut;

  /// Check if paste command can be executed
  final bool canPaste;

  /// Check if select all command can be executed
  final bool canSelectAll;

  @override
  __SelectionToolBarState createState() => __SelectionToolBarState();
}

class __SelectionToolBarState extends State<_SelectionToolBar> {
  void _onChangedClipboardStatus() {
    if (mounted) {
      setState(() {
        // Inform the widget that the value of clipboardStatus has changed.
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(_SelectionToolBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///TODO GIVE OPTION TO SWITCH BETWEEN CUPERTINO AND MATERIAL TEXT SELECTION TOOL BAR TYPES
    // return CupertinoTextSelectionToolbar(
    //     anchorAbove: widget.anchorAbove,
    //     anchorBelow: widget.anchorBelow,
    //     toolbarBuilder:
    //         (BuildContext context, Offset offset, bool value, Widget child) {
    //       return Card(child: child);
    //     },
    //     children:
    //         widget.toolBarItems.map((item) => itemButton(item: item)).toList());
    return TextSelectionToolbar(
        anchorAbove: widget.anchorAbove,
        anchorBelow: widget.anchorBelow,
        toolbarBuilder: (BuildContext context, Widget child) {
          return Card(
            color: Colors.black87,
            child: child,
          );
        },
        children: widget.toolBarItems.map((item) {
          if (item.itemControl != null) {
            if (item.itemControl == ToolBarItemControl.copy &&
                !widget.canCopy) {
              return const SizedBox();
            }
            if (item.itemControl == ToolBarItemControl.cut && !widget.canCut) {
              return const SizedBox();
            }
            if (item.itemControl == ToolBarItemControl.paste &&
                !widget.canPaste) return const SizedBox();
            if (item.itemControl == ToolBarItemControl.selectAll &&
                !widget.canSelectAll) return const SizedBox();
          }
          return itemButton(
              item: item,
              horizontalPadding: widget.horizontalPadding,
              verticalPadding: widget.verticalPadding);
        }).toList());
  }

  Widget itemButton({
    required ToolBarItem item,
    required double horizontalPadding,
    required double verticalPadding,
  }) {
    return InkWell(
      onTap: () => widget.onItemSelected(item),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        child: item.item,
      ),
    );
  }
}

/// ToolBarItem
/// This requires a widget[item] which will be shown on the text selection tool bar when a text is highlighted
/// This class also gives you an option to choose between...
/// ... flutter text selection controls[copy, paste, cut, select all] or custom controls
class ToolBarItem {
  ToolBarItem({required this.item, this.onItemPressed, this.itemControl})
      : assert(
            onItemPressed == null ? itemControl != null : itemControl == null);

  /// The widget which will be shown on the text selection tool bar when a text is highlighted
  final Widget item;

  /// This gives access the highlighted text, the start index and the end index of the highlighted text
  final Function(String highlightedText, int startIndex, int endIndex)?
      onItemPressed;

  /// This gives you the option to use flutter text selection controls on your custom widget
  /// For instance, instead of having the text [Copy] on the tool bar,...
  /// ...you can have the [Icon(Icons.copy)] as the widget...
  /// ...and use [ToolBarItemControl.copy] control to copy the highlighted text when the icon is tapped
  final ToolBarItemControl? itemControl;
}

enum ToolBarItemControl { copy, paste, cut, selectAll }
