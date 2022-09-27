import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:flutter_switch/flutter_switch.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/notification_provider/NotificationProvider.dart";
import "package:mvp/repository/Common/NotificationRepository.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:provider/provider.dart";

class NotificationSettingView extends StatefulWidget {
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const NotificationSettingView({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView>
    with SingleTickerProviderStateMixin {
  NotificationRepository? notificationRepository;
  NotificationProvider? notificationProvider;
  ValueHolder? valueHolder;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController!.forward();
    notificationRepository =
        Provider.of<NotificationRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
  }

  Future<bool> _requestPop() {
    CustomAppBar.changeStatusColor(CustomColors.mainColor!);
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, {"data": false, "clientId": null});
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<NotificationProvider>(
          titleWidget: PreferredSize(
            preferredSize:
                Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: CustomColors.white,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space8.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: TextButton(
                      onPressed: _requestPop,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CustomIcon.icon_arrow_left,
                            color: CustomColors.loadingCircleColor,
                            size: Dimens.space22.w,
                          ),
                          Expanded(
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("cancel"),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: CustomColors.loadingCircleColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("notifications"),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          leadingWidget: null,
          elevation: 1,
          onIncomingTap: () {
            widget.onIncomingTap();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap();
          },
          initProvider: () {
            return NotificationProvider(
                repo: notificationRepository!, valueHolder: valueHolder);
          },
          onProviderReady: (NotificationProvider provider) async {
            notificationProvider = provider;
          },
          builder: (BuildContext? context, NotificationProvider? provider,
              Widget? child) {
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: const Interval(0.5 * 1, 1.0,
                        curve: Curves.fastOutSlowIn)));
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: CustomColors.bottomAppBarColor,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space15.h, Dimens.space16.w, Dimens.space15.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("showNotificationFor").toUpperCase(),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context!).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                ShowSmsNotificationSettingWidget(
                  isSwitched: notificationProvider!.getSmsNotificationSetting(),
                  onToggle: (value) async {
                    if (value) {
                      notificationProvider!.replaceSmsNotificationSetting(true);
                    } else {
                      notificationProvider!
                          .replaceSmsNotificationSetting(false);
                    }
                    setState(() {});
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                ShowMissedCallNotificationSettingWidget(
                  isSwitched:
                      notificationProvider!.getMissedCallNotificationSetting(),
                  onToggle: (value) async {
                    if (value) {
                      notificationProvider!
                          .replaceMissedCallNotificationSetting(true);
                    } else {
                      notificationProvider!
                          .replaceMissedCallNotificationSetting(false);
                    }
                    setState(() {});
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                ShowVoiceMailNotificationSettingWidget(
                  isSwitched:
                      notificationProvider!.getVoiceMailNotificationSetting(),
                  onToggle: (value) async {
                    if (value) {
                      notificationProvider!
                          .replaceVoiceMailNotificationSetting(true);
                    } else {
                      notificationProvider!
                          .replaceVoiceMailNotificationSetting(false);
                    }
                    setState(() {});
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                ShowChatMessageNotificationSettingWidget(
                  isSwitched:
                      notificationProvider!.getChatMessageNotificationSetting(),
                  onToggle: (value) async {
                    if (value) {
                      notificationProvider!
                          .replaceChatMessageNotificationSetting(true);
                    } else {
                      notificationProvider!
                          .replaceChatMessageNotificationSetting(false);
                    }
                    setState(() {});
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShowCallMessageNotificationSettingWidget extends StatelessWidget {
  const ShowCallMessageNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("newCallsAndMessages"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space24.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space18.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                Utils.checkInternetConnectivity().then((bool onValue) {
                  if (onValue) {
                    onToggle(value);
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
    );
  }
}

class ShowNewLeadsNotificationSettingWidget extends StatelessWidget {
  const ShowNewLeadsNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("newLeads"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space24.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space18.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                Utils.checkInternetConnectivity().then((bool onValue) {
                  if (onValue) {
                    onToggle(value);
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
    );
  }
}

class ShowSmsNotificationSettingWidget extends StatelessWidget {
  const ShowSmsNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow ? Const.OVERFLOW : Utils.getString("sms"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space30.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space20.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                onToggle(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShowMissedCallNotificationSettingWidget extends StatelessWidget {
  const ShowMissedCallNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("missedCall"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space30.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space20.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                onToggle(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShowVoiceMailNotificationSettingWidget extends StatelessWidget {
  const ShowVoiceMailNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("voiceMail"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space30.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space20.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                onToggle(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShowChatMessageNotificationSettingWidget extends StatelessWidget {
  const ShowChatMessageNotificationSettingWidget({
    required this.onToggle,
    required this.isSwitched,
  });

  final bool isSwitched;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
          Dimens.space16.w, Dimens.space14.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("memberChat"),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: FlutterSwitch(
              value: isSwitched,
              width: Dimens.space40.w,
              height: Dimens.space30.h,
              padding: Dimens.space3.w,
              toggleSize: Dimens.space20.w,
              activeColor: CustomColors.mainColor!,
              onToggle: (bool value) {
                onToggle(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
