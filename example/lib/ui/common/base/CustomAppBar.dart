import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart";
import "package:mvp/BaseStatefulState.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:provider/provider.dart";

class CustomAppBar<T extends ChangeNotifier> extends StatefulWidget {
  const CustomAppBar(
      {Key? key,
      required this.builder,
      required this.initProvider,
      required this.elevation,
      required this.titleWidget,
      required this.leadingWidget,
      required this.onIncomingTap,
      required this.onOutgoingTap,
      this.child,
      this.statusBarColor,
      this.centerTitle = false,
      this.onProviderReady,
      this.actions = const <Widget>[],
      this.removeHeight = false})
      : super(key: key);

  final Widget Function(BuildContext? context, T? provider, Widget? child)
      builder;
  final Function? initProvider;
  final Widget? child;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final Function(T)? onProviderReady;
  final List<Widget> actions;
  final double? elevation;
  final bool? centerTitle;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final Color? statusBarColor;
  final bool? removeHeight;

  @override
  CustomAppBarState<T> createState() => CustomAppBarState<T>();

  static changeStatusColor(Color color, {bool setDelay = false}) async {
    try {
      if (setDelay) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      await FlutterStatusbarcolor.setStatusBarColor(color);
      if (useWhiteForeground(color)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}

class CustomAppBarState<T extends ChangeNotifier>
    extends BaseStatefulState<CustomAppBar<T>> {
  // bool callInProgressOutgoing = false;
  // bool callInProgressIncoming = false;
  int secondsOutgoing = 0;
  int minutesOutgoing = 0;
  int secondsIncoming = 0;
  int minutesIncoming = 0;

  StreamSubscription? streamSubscriptionIncomingEvent;
  StreamSubscription? streamSubscriptionOutgoingEvent;

  @override
  void initState() {
    super.initState();
    streamSubscriptionOutgoingEvent =
        DashboardView.outgoingEvent.on().listen((event) {
      if (event != null && event["outgoingEvent"] == "outGoingCallRinging") {
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallDisconnected") {
        if (mounted) {
          setState(() {
            minutesOutgoing = 0;
            secondsOutgoing = 0;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallConnected") {
        if (mounted) {
          setState(() {
            minutesOutgoing = event["minutes"] as int;
            secondsOutgoing = event["seconds"] as int;
          });
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallConnectFailure") {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              minutesOutgoing = 0;
              secondsOutgoing = 0;
            });
          }
        });
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnecting") {
        if (mounted) {
          setState(() {});
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallReconnected") {
        if (mounted) {
          setState(() {});
        }
      } else if (event != null &&
          event["outgoingEvent"] == "outGoingCallCallQualityWarningsChanged") {
        if (mounted) {
          setState(() {});
        }
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
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              minutesIncoming = 0;
              secondsIncoming = 0;
            });
          }
        });
      } else if (event != null &&
          event["incomingEvent"] == "incomingReconnecting") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingReconnected") {
      } else if (event != null &&
          event["incomingEvent"] == "incomingCallQualityWarningsChanged") {}
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.statusBarColor != null) {
        await CustomAppBar.changeStatusColor(widget.statusBarColor!);
      } else {
        await CustomAppBar.changeStatusColor(CustomColors.white!);
      }
    });
  }

  @override
  void dispose() {
    streamSubscriptionIncomingEvent!.cancel();
    streamSubscriptionOutgoingEvent!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.leadingWidget != null
          ? Consumer<DashboardProvider>(
              builder: (context, data, _) {
                return Scaffold(
                  backgroundColor: CustomColors.white,
                  resizeToAvoidBottomInset: true,
                  appBar: PreferredSize(
                    preferredSize: Size(
                      MediaQuery.of(context).size.width.w,
                      isConnectedToInternet
                          ? (data.outgoingIsCallConnected ||
                                  data.incomingIsCallConnected)
                              ? (kToolbarHeight * 2).h
                              : widget.removeHeight!
                                  ? Dimens.space26.h
                                  : kToolbarHeight.h
                          : (data.outgoingIsCallConnected ||
                                  data.incomingIsCallConnected)
                              ? (kToolbarHeight * 2).h + Dimens.space26.h
                              : widget.removeHeight!
                                  ? Dimens.space26.h
                                  : kToolbarHeight.h + Dimens.space26.h,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width.w,
                      child: Column(
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    CustomColors.callOnProgressColor,
                                alignment: Alignment.center,
                                shape: const RoundedRectangleBorder(),
                              ),
                              onPressed: () {
                                widget.onOutgoingTap!();
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    CustomColors.callOnProgressColor,
                                alignment: Alignment.center,
                                shape: const RoundedRectangleBorder(),
                              ),
                              onPressed: () {
                                widget.onIncomingTap!();
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
                                        fontWeight: FontWeight.normal,
                                        fontFamily: Config.heeboMedium,
                                        fontSize: Dimens.space14.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          AppBar(
                            toolbarHeight:
                                widget.removeHeight! ? 0 : kToolbarHeight.h,
                            automaticallyImplyLeading: false,
                            backgroundColor: CustomColors.white,
                            iconTheme: IconThemeData(
                                color: CustomColors.mainIconColor),
                            titleSpacing: 0,
                            title: widget.titleWidget,
                            actions: widget.actions,
                            centerTitle: widget.centerTitle,
                            elevation: widget.elevation,
                            leading: widget.leadingWidget,
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: ChangeNotifierProvider<T>(
                    lazy: false,
                    create: (BuildContext context) {
                      final T providerObj = widget.initProvider!() as T;
                      if (widget.onProviderReady != null) {
                        widget.onProviderReady!(providerObj);
                      }
                      return providerObj;
                    },
                    child: Consumer<T>(
                        builder: widget.builder, child: widget.child),
                  ),
                );
              },
            )
          : Consumer<DashboardProvider>(
              builder: (context, data, _) {
                return Scaffold(
                  backgroundColor: CustomColors.white,
                  resizeToAvoidBottomInset: true,
                  appBar: PreferredSize(
                    preferredSize: Size(
                      MediaQuery.of(context).size.width.w,
                      isConnectedToInternet
                          ? (data.outgoingIsCallConnected ||
                                  data.incomingIsCallConnected)
                              ? (kToolbarHeight * 2).h
                              : kToolbarHeight.h
                          : (data.outgoingIsCallConnected ||
                                  data.incomingIsCallConnected)
                              ? (kToolbarHeight * 2).h + Dimens.space26.h
                              : kToolbarHeight.h + Dimens.space26.h,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    CustomColors.callOnProgressColor,
                                alignment: Alignment.center,
                                shape: const RoundedRectangleBorder(),
                              ),
                              onPressed: () {
                                widget.onOutgoingTap!();
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    CustomColors.callOnProgressColor,
                                alignment: Alignment.center,
                                shape: const RoundedRectangleBorder(),
                              ),
                              onPressed: () {
                                widget.onIncomingTap!();
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
                                        fontWeight: FontWeight.normal,
                                        fontFamily: Config.heeboMedium,
                                        fontSize: Dimens.space14.sp,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          AppBar(
                            toolbarHeight: kToolbarHeight.h,
                            automaticallyImplyLeading: false,
                            backgroundColor: CustomColors.white,
                            iconTheme: IconThemeData(
                                color: CustomColors.mainIconColor),
                            titleSpacing: 0,
                            title: widget.titleWidget,
                            actions: widget.actions,
                            centerTitle: widget.centerTitle,
                            elevation: widget.elevation,
                            leading: widget.leadingWidget,
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: ChangeNotifierProvider<T>(
                    lazy: false,
                    create: (BuildContext context) {
                      final T providerObj = widget.initProvider!() as T;
                      if (widget.onProviderReady != null) {
                        widget.onProviderReady!(providerObj);
                      }
                      return providerObj;
                    },
                    child: Consumer<T>(
                        builder: widget.builder, child: widget.child),
                  ),
                );
              },
            ),
    );
  }
}
