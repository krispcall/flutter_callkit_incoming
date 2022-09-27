import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_switch/flutter_switch.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/DndMuteDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:provider/provider.dart";

class ChannelNotificationView extends StatefulWidget {
  const ChannelNotificationView({Key? key}) : super(key: key);

  @override
  _ChannelNotificationViewState createState() {
    return _ChannelNotificationViewState();
  }
}

class _ChannelNotificationViewState extends State<ChannelNotificationView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;
  ValueHolder? valueHolder;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    Future<bool> _requestPop() {
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

    return Scaffold(
      body: CustomAppBar<LoginWorkspaceProvider>(
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
                  margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
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
                                : Utils.getString("back"),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
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
          // widget.onIncomingTap();
        },
        onOutgoingTap: () {
          // widget.onOutgoingTap();
        },
        initProvider: () {
          return LoginWorkspaceProvider(
              loginWorkspaceRepository: loginWorkspaceRepository,
              valueHolder: valueHolder);
        },
        onProviderReady: (LoginWorkspaceProvider provider) async {
          loginWorkspaceProvider = provider;
          loginWorkspaceProvider!.doGetNumberSettings(
              SubscriptionUpdateConversationDetailRequestHolder(
                channelId: provider.getDefaultChannel().id!,
              ),
              isFromServer: false);
        },
        builder: (BuildContext? context, LoginWorkspaceProvider? provider,
            Widget? child) {
          return Container(
            color: CustomColors.mainBackgroundColor,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CustomColors.mainDividerColor!,
                          ),
                        ),
                        color: Colors.white),
                    child: TextButton(
                      onPressed: () {
                        _showMuteDialog(
                            context: context!,
                            name: loginWorkspaceProvider!
                                .getDefaultChannel()
                                .name!,
                            onMuteTap: (int time, bool status) {});
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
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
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("notifications"),
                                maxLines: 1,
                                style: Theme.of(context!)
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
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
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
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
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CustomColors.mainDividerColor!,
                          ),
                        ),
                        color: CustomColors.white),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space16.h,
                              Dimens.space16.w,
                              Dimens.space16.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: CustomColors.transparent,
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Expanded(
                              child: ImageAndTextTile(
                                assetUrl: "assets/images/email.png",
                                title: Utils.getString("email"),
                                subTitle: Utils.getString("emailDesc"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: FlutterSwitch(
                                value: provider!.numberSettings!.data!
                                        .emailNotification! ||
                                    false,
                                width: Dimens.space52.w,
                                height: Dimens.space32.h,
                                padding: Dimens.space3.w,
                                toggleSize: Dimens.space26.w,
                                activeColor: CustomColors.mainColor!,
                                onToggle: (bool value) {
                                  _updateEmailSettings(value);
                                },
                              ),
                            ),
                          ],
                        ))),
                Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CustomColors.mainDividerColor!,
                          ),
                        ),
                        color: CustomColors.white),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space16.h,
                              Dimens.space16.w,
                              Dimens.space16.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: CustomColors.transparent,
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Expanded(
                              child: ImageAndTextTile(
                                assetUrl: "assets/images/auto_records.png",
                                title: Utils.getString("autoRecordsAndCall"),
                                subTitle:
                                    Utils.getString("autoRecordsAndCallDesc"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: FlutterSwitch(
                                value: provider.numberSettings!.data!
                                        .autoRecordCalls! ||
                                    false,
                                width: Dimens.space52.w,
                                height: Dimens.space32.h,
                                padding: Dimens.space3.w,
                                toggleSize: Dimens.space26.w,
                                activeColor: CustomColors.mainColor!,
                                onToggle: (bool value) {
                                  _updateAutoRecordSettings(value);
                                },
                              ),
                            ),
                          ],
                        ))),
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
                      color: CustomColors.white),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: CustomColors.transparent,
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: ImageAndTextTile(
                            assetUrl: "assets/images/intl_call_messages.png",
                            title: Utils.getString("intcallAndMessages"),
                            subTitle: Utils.getString("intcallAndMessagesDesc"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space10.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: FlutterSwitch(
                            value: provider.numberSettings!.data!
                                    .internationalCallAndMessages! ||
                                false,
                            width: Dimens.space52.w,
                            height: Dimens.space32.h,
                            padding: Dimens.space3.w,
                            toggleSize: Dimens.space26.w,
                            activeColor: CustomColors.mainColor!,
                            onToggle: (bool value) {
                              _updateIntlCallAndRecordSetting(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMuteDialog(
      {BuildContext? context, String? name, Function? onMuteTap}) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.57,
        child: ClientDndMuteDialog(
          clientName: name,
          onMuteTap: (int minutes, bool value) {
            Navigator.of(context).pop();
            onMuteTap!(minutes, value);
          },
        ),
      ),
    );
  }

  Future<void> _updateEmailSettings(bool value) async {}

  Future<void> _updateAutoRecordSettings(bool value) async {}

  Future<void> _updateIntlCallAndRecordSetting(bool value) async {}
}

class ImageAndTextTile extends StatelessWidget {
  const ImageAndTextTile({Key? key, this.assetUrl, this.title, this.subTitle})
      : super(key: key);

  final String? assetUrl;
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: Dimens.space48.w,
          height: Dimens.space48.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: RoundedAssetImageHolder(
            assetUrl: assetUrl!,
            width: Dimens.space48,
            height: Dimens.space48,
            containerAlignment: Alignment.bottomCenter,
            outerCorner: Dimens.space15,
            innerCorner: Dimens.space20,
            iconSize: Dimens.space41,
            iconUrl: CustomIcon.icon_profile,
            iconColor: CustomColors.mainDividerColor!,
            boxDecorationColor: CustomColors.startButtonColor!,
            applyFactor: true,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : title!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeExtraBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.zero,
                    child: Text(
                      Config.checkOverFlow ? Const.OVERFLOW : subTitle!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontSize: Dimens.space14.sp,
                            fontFamily: Config.heeboRegular,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
