import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/notification_provider/NotificationProvider.dart";
import "package:mvp/repository/Common/NotificationRepository.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/SoundListDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:provider/provider.dart";

class SoundSettingsView extends StatefulWidget {
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;

  const SoundSettingsView({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  @override
  _SoundSettingsViewState createState() => _SoundSettingsViewState();
}

class _SoundSettingsViewState extends State<SoundSettingsView>
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
                                  : Utils.getString("profile"),
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
                        : Utils.getString("soundSettings"),
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
            widget.onIncomingTap!();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap!();
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
                ShowSoundSettingWidget(
                  onTap: () {
                    showSoundListDialog();
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                // Container(
                //   width: double.infinity,
                //   color: CustomColors.bottomAppBarColor,
                //   margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                //       Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                //   padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                //       Dimens.space15.h, Dimens.space16.w, Dimens.space15.h),
                //   child: Text(
                //     Config.checkOverFlow
                //         ? Const.OVERFLOW
                //         : Utils.getString("doNotDisturb").toUpperCase(),
                //     textAlign: TextAlign.left,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 1,
                //     style: Theme.of(context).textTheme.button.copyWith(
                //           color: CustomColors.textPrimaryLightColor,
                //           fontFamily: Config.manropeBold,
                //           fontWeight: FontWeight.normal,
                //           fontSize: Dimens.space14.sp,
                //           fontStyle: FontStyle.normal,
                //         ),
                //   ),
                // ),
                // Divider(
                //   height: Dimens.space1,
                //   thickness: Dimens.space1,
                //   color: CustomColors.mainDividerColor,
                // ),
                // ShowNoNotificationWhileOnCallWidget(
                //   onTap: () async {
                //     FlutterDnd.gotoPolicySettings();
                //   },
                // ),
                // Divider(
                //   height: Dimens.space1,
                //   thickness: Dimens.space1,
                //   color: CustomColors.mainDividerColor,
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showSoundListDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space15.r),
          topRight: Radius.circular(Dimens.space15.r),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext dialogContext) {
        return SizedBox(
          height: ScreenUtil().screenHeight * 0.90,
          child: SoundListDialog(
            notificationProvider: notificationProvider!,
            animationController: animationController!,
            onItemTap: (selectedContact) {},
          ),
        );
      },
    );
  }
}

class ShowSoundSettingWidget extends StatelessWidget {
  const ShowSoundSettingWidget({
    required this.onTap,
  });

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
      onPressed: () {
        onTap();
      },
      child: Container(
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
                      : Utils.getString("phoneRingtone"),
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
              child: Icon(
                CustomIcon.icon_arrow_right,
                size: Dimens.space24.w,
                color: CustomColors.textQuinaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowNoNotificationWhileOnCallWidget extends StatelessWidget {
  const ShowNoNotificationWhileOnCallWidget({
    required this.onTap,
  });

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
      onPressed: () {
        onTap();
      },
      child: Container(
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
                      : Utils.getString("doNotDisturb"),
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
              child: Icon(
                CustomIcon.icon_arrow_right,
                size: Dimens.space24.w,
                color: CustomColors.textQuinaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
