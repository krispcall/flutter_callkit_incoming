import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ChannelDndDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/NumberSettingIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/channelDnd/ChannelDndParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDndResponse.dart";
import "package:provider/provider.dart";

class NumberSettingView extends StatefulWidget {
  const NumberSettingView({
    Key? key,
    this.animationController,
    this.onIncomingTap,
    this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController? animationController;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;

  @override
  NumberSettingViewState createState() => NumberSettingViewState();
}

class NumberSettingViewState extends State<NumberSettingView>
    with SingleTickerProviderStateMixin {
  ValueHolder? valueHolder;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  void initState() {
    super.initState();
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();

    return CustomAppBar<LoginWorkspaceProvider>(
      elevation: 0,
      removeHeight: true,
      onIncomingTap: () {
        widget.onIncomingTap!();
      },
      onOutgoingTap: () {
        widget.onOutgoingTap!();
      },
      titleWidget: Container(),
      leadingWidget: Container(),
      initProvider: () {
        return LoginWorkspaceProvider(
          loginWorkspaceRepository: loginWorkspaceRepository,
          valueHolder: valueHolder,
        );
      },
      onProviderReady: (LoginWorkspaceProvider provider) {
        loginWorkspaceProvider = provider;
        loginWorkspaceProvider!.doGetNumberSettings(
            SubscriptionUpdateConversationDetailRequestHolder(
          channelId: loginWorkspaceProvider!.getDefaultChannel().id,
        ));
        loginWorkspaceProvider!
            .getChannelInfo(loginWorkspaceProvider!.getDefaultChannel().id);
        loginWorkspaceProvider!.doChannelListOnlyApiCall(
            loginWorkspaceProvider!.getCallAccessToken());
      },
      builder: (BuildContext? context, LoginWorkspaceProvider? provider,
          Widget? child) {
        return Container(
          color: CustomColors.white,
          padding: EdgeInsets.zero,
          child: NumberSettingDetailWidget(
            animationController: widget.animationController!,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / 4) * 2, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            ),
            loginWorkspaceProvider: loginWorkspaceProvider!,
            onIncomingTap: () {
              widget.onIncomingTap!();
            },
            onOutgoingTap: () {
              widget.onOutgoingTap!();
            },
          ),
        );
      },
    );
  }
}

class NumberSettingDetailWidget extends StatefulWidget {
  const NumberSettingDetailWidget({
    Key? key,
    this.animationController,
    this.animation,
    required this.loginWorkspaceProvider,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final LoginWorkspaceProvider loginWorkspaceProvider;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  NumberSettingDetailWidgetState createState() =>
      NumberSettingDetailWidgetState();
}

class NumberSettingDetailWidgetState extends State<NumberSettingDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height.h,
      alignment: Alignment.topCenter,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            HeaderImageAndTextWidget(
              loginWorkspaceProvider: widget.loginWorkspaceProvider,
            ),
            DetailWidget(
              loginWorkspaceProvider: widget.loginWorkspaceProvider,
              onUpdateCallback: () {
                // Navigator.of(context).pop();
                DashboardView.subscriptionConversationSeen.fire(
                  SubscriptionConversationSeenEvent(
                    isSeen: true,
                  ),
                );

                setState(() {});
              },
              onIncomingTap: () {
                widget.onIncomingTap();
              },
              onOutgoingTap: () {
                widget.onOutgoingTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderImageAndTextWidget extends StatelessWidget {
  const HeaderImageAndTextWidget({this.loginWorkspaceProvider});

  final LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(Dimens.space0,
          Utils.getStatusBarHeight(context), Dimens.space0, Dimens.space0),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.w, Dimens.space0, Dimens.space20.w),
      alignment: Alignment.topLeft,
      color: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space2, Dimens.space0, Dimens.space2),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                Dimens.space16.w, Dimens.space0),
            child: FutureBuilder<String>(
              future: Utils.getFlagUrl(
                  loginWorkspaceProvider!.getDefaultChannel().number),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AppBarNetworkImageHolder(
                    width: Dimens.space50,
                    height: Dimens.space50,
                    boxFit: BoxFit.contain,
                    containerAlignment: Alignment.bottomCenter,
                    iconUrl: CustomIcon.icon_gallery,
                    iconColor: CustomColors.grey,
                    iconSize: Dimens.space27,
                    boxDecorationColor: CustomColors.mainBackgroundColor,
                    outerCorner: Dimens.space40,
                    innerCorner: Dimens.space5,
                    imageUrl: PSApp.config!.countryLogoUrl! + snapshot.data!,
                  );
                }
                return const CupertinoActivityIndicator();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h,
                Dimens.space0, Dimens.space12.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                Dimens.space16.w, Dimens.space0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : loginWorkspaceProvider!.getDefaultChannel() != null
                          ? loginWorkspaceProvider!.getDefaultChannel().name ??
                              Utils.getString("appName")
                          : Utils.getString("appName"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeExtraBold,
                      fontSize: Dimens.space20.sp,
                      fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                  onLongPress: (){
                    Clipboard.setData(ClipboardData(text:Config.checkOverFlow
                        ? Const.OVERFLOW
                        : loginWorkspaceProvider!.getDefaultChannel() != null
                        ? loginWorkspaceProvider!
                        .getDefaultChannel()
                        .number ??
                        Utils.getString("appName")
                        : Utils.getString("appName"))).then((_){
                      Utils.showCopyToastMessage("Phone number copied", context);
                    });

                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h,
                        Dimens.space0, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : loginWorkspaceProvider!.getDefaultChannel() != null
                          ? loginWorkspaceProvider!
                          .getDefaultChannel()
                          .number ??
                          Utils.getString("appName")
                          : Utils.getString("appName"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textTertiaryColor,
                        fontSize: Dimens.space15.sp,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final LoginWorkspaceProvider loginWorkspaceProvider;
  final VoidCallback onUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const DetailWidget({
    required this.loginWorkspaceProvider,
    required this.onUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space15.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("generalSettings").toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.button!.copyWith(
                    color: CustomColors.textPrimaryLightColor,
                    fontFamily: Config.manropeBold,
                    fontWeight: FontWeight.normal,
                    fontSize: Dimens.space14.sp,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor!,
                      ),
                    ),
                  ),
                  child: AbsorbPointer(
                    absorbing: loginWorkspaceProvider
                                .getWorkspaceDetail()
                                .loginMemberRole !=
                            null &&
                        loginWorkspaceProvider
                                .getWorkspaceDetail()
                                .loginMemberRole!
                                .role !=
                            null &&
                        loginWorkspaceProvider
                            .getWorkspaceDetail()
                            .loginMemberRole!
                            .role!
                            .isNotEmpty &&
                        loginWorkspaceProvider
                                .getWorkspaceDetail()
                                .loginMemberRole!
                                .role ==
                            "Member",
                    child: TextButton(
                      onPressed: () {
                        showUpdateChannelView(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space16.h,
                            Dimens.space16.w,
                            Dimens.space16.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
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
                                    : Utils.getString("numberName"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                CustomColors.textTertiaryColor,
                                            fontFamily: Config.manropeSemiBold,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                      text: Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : loginWorkspaceProvider
                                                      .getDefaultChannel() !=
                                                  null
                                              ? loginWorkspaceProvider
                                                      .getDefaultChannel()
                                                      .name ??
                                                  Utils.getString("appName")
                                              : Utils.getString("appName"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (loginWorkspaceProvider
                                      .getWorkspaceDetail()
                                      .loginMemberRole !=
                                  null &&
                              loginWorkspaceProvider
                                      .getWorkspaceDetail()
                                      .loginMemberRole!
                                      .role !=
                                  null &&
                              loginWorkspaceProvider
                                  .getWorkspaceDetail()
                                  .loginMemberRole!
                                  .role!
                                  .isNotEmpty &&
                              loginWorkspaceProvider
                                      .getWorkspaceDetail()
                                      .loginMemberRole!
                                      .role ==
                                  "Member")
                            Container()
                          else
                            Icon(
                              CustomIcon.icon_arrow_right,
                              size: Dimens.space24.w,
                              color: CustomColors.textQuinaryColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor!,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (loginWorkspaceProvider.getDefaultChannel() != null &&
                          loginWorkspaceProvider.getDefaultChannel().id !=
                              null) {
                        _showChannelDndDialog(
                          context: context,
                          clientName: (loginWorkspaceProvider
                                      .getDefaultChannel()
                                      .name !=
                                  null)
                              ? loginWorkspaceProvider.getDefaultChannel().name
                              : Utils.getString("appName"),
                          dndEndTime: loginWorkspaceProvider
                                  .channelDnd!.data!.dndEndtime ??
                              0,
                          dndEnabled: loginWorkspaceProvider
                                  .channelDnd!.data!.dndEnabled ??
                              false,
                          onMuteTap: (int time, bool value) {
                            onMuteTap(
                                context: context,
                                minutes: time,
                                value: value,
                                onUpdate: onUpdateCallback);
                          },
                          onRemoveDnd: () {
                            _removeDnd(context, onUpdateCallback);
                          },
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: CustomColors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
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
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.4),
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("doNotDisturb"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.5),
                            child: Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              padding: EdgeInsets.fromLTRB(
                                Dimens.space10.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              child: loginWorkspaceProvider.channelDnd !=
                                          null &&
                                      loginWorkspaceProvider.channelDnd!.data !=
                                          null
                                  ? Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : loginWorkspaceProvider.getDndTime(
                                              loginWorkspaceProvider
                                                  .channelDnd!,
                                            ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                CustomColors.textTertiaryColor,
                                            fontFamily: Config.manropeSemiBold,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                    )
                                  : Container(
                                      width: Dimens.space30,
                                      alignment: Alignment.centerRight,
                                      child: SpinKitCircle(
                                        size: 20,
                                        color: CustomColors.textQuinaryColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChannelDndDialog({
    BuildContext? context,
    String? clientName,
    int? dndEndTime,
    bool? dndEnabled,
    Function? onMuteTap,
    Function? onRemoveDnd,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => ChannelDndDialog(
        clientName: clientName,
        onSetRemoveTap: (time, value) {
          Navigator.of(dialogContext).pop();
          Future.delayed(const Duration(milliseconds: 300), () {
            if (time == -1) {
              onRemoveDnd!();
            } else {
              onMuteTap!(time, value);
            }
          });
        },
      ),
    );
  }

  Future<void> onMuteTap(
      {BuildContext? context,
      int? minutes,
      bool? value,
      VoidCallback? onUpdate}) async {
    await PsProgressDialog.showDialog(context!, isDissmissable: true);
    final ChannelDndHolder holder = ChannelDndHolder(
      id: loginWorkspaceProvider.getDefaultChannel().id!,
      minutes: minutes,
    );
    final Resources<ChannelDndResponse> resource =
        await loginWorkspaceProvider.doSetChannelDndApiCall(holder);
    if (resource.status == Status.ERROR) {
      await PsProgressDialog.dismissDialog();
      Future.delayed(Duration.zero, () {
        Utils.showWarningToastMessage(resource.message!, context);
      });
    } else {
      await PsProgressDialog.dismissDialog();
    }
  }

  Future<void> _removeDnd(BuildContext context, VoidCallback onUpdate) async {
    await PsProgressDialog.showDialog(context, isDissmissable: true);
    final ChannelDndHolder holder = ChannelDndHolder(
      id: loginWorkspaceProvider.getDefaultChannel().id!,
    );
    final Resources<ChannelDndResponse> resource =
        await loginWorkspaceProvider.doOnRemoveDndApiCall(holder);
    if (resource.status == Status.ERROR) {
      await PsProgressDialog.dismissDialog();
      Future.delayed(Duration.zero, () {
        Utils.showWarningToastMessage(resource.message!, context);
      });
    } else {
      await PsProgressDialog.dismissDialog();
    }
  }

  void showUpdateChannelView(BuildContext context) {
    Navigator.of(context).pushNamed(
      RoutePaths.editChannelName,
      arguments: NumberSettingIntentHolder(
        onUpdateCallback: () {
          onUpdateCallback();
        },
        channel: loginWorkspaceProvider.getDefaultChannel(),
        onIncomingTap: () {
          onIncomingTap();
        },
        onOutgoingTap: () {
          onOutgoingTap();
        },
      ),
    );
  }
}
