import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_libphonenumber/flutter_libphonenumber.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class WorkspaceNumberListItemView extends StatelessWidget {

  const WorkspaceNumberListItemView({
    Key? key,
    required this.workspaceChannel,
    required this.animationController,
    required this.animation,
    required this.selectedChannel,
    required this.count,
    required this.onChannelTap,
    required this.isWorkspaceSubscriptionActive,
  }) : super(key: key);


  final WorkspaceChannel workspaceChannel;
  final AnimationController animationController;
  final Animation<double> animation;
  final WorkspaceChannel selectedChannel;
  final int count;
  final Function onChannelTap;
  final bool isWorkspaceSubscriptionActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: workspaceChannel.number))
                    .then((_) {
                  Utils.showCopyToastMessage("Phone number copied", context);
                });
              },
              onPressed: () {
                onChannelTap();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(
                  Dimens.space0.w,
                  Dimens.space0.h,
                  Dimens.space0.w,
                  Dimens.space0.h,
                ),
                padding: EdgeInsets.fromLTRB(
                  Dimens.space9.w,
                  Dimens.space9.h,
                  Dimens.space10.w,
                  Dimens.space9.h,
                ),
                decoration: isWorkspaceSubscriptionActive
                    ? const BoxDecoration()
                    : (selectedChannel.id == workspaceChannel.id
                        ? BoxDecoration(
                            color: CustomColors.mainColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space8.r),
                            ),
                          )
                        : BoxDecoration(
                            color: CustomColors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space8.r),
                            ),
                          )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space12.w,
                        Dimens.space0.h,
                      ),
                      padding: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space0.w,
                        Dimens.space0.h,
                      ),
                      child: FutureBuilder<String>(
                        future: Utils.getFlagUrl(workspaceChannel.number),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AppBarNetworkImageHolder(
                              width: Dimens.space35,
                              height: Dimens.space35,
                              boxFit: BoxFit.scaleDown,
                              containerAlignment: Alignment.bottomCenter,
                              iconUrl: CustomIcon.icon_gallery,
                              iconColor: CustomColors.grey,
                              iconSize: Dimens.space20,
                              boxDecorationColor:
                                  selectedChannel.id == workspaceChannel.id
                                      ? !isWorkspaceSubscriptionActive
                                          ? CustomColors.mainSecondaryColor
                                          : CustomColors.coreSecondaryColor
                                      : CustomColors.coreSecondaryColor,
                              outerCorner: Dimens.space30,
                              innerCorner: Dimens.space0,
                              imageUrl: PSApp.config!.countryLogoUrl! +
                                  snapshot.data!,
                            );
                          }
                          return const CupertinoActivityIndicator();
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
                                    : workspaceChannel.name!,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: selectedChannel.id ==
                                              workspaceChannel.id
                                          ? (isWorkspaceSubscriptionActive
                                              ? CustomColors.textQuinaryColor
                                              : CustomColors.white)
                                          : (isWorkspaceSubscriptionActive
                                              ? CustomColors.textQuinaryColor
                                              : CustomColors
                                                  .textSecondaryColor),
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                          ),
                          Container(
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
                                  : FlutterLibphonenumber().formatNumberSync(
                                      workspaceChannel.number!),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: selectedChannel.id ==
                                            workspaceChannel.id
                                        ? (isWorkspaceSubscriptionActive
                                            ? CustomColors.textQuinaryColor
                                            : CustomColors.white)
                                        : (isWorkspaceSubscriptionActive
                                            ? CustomColors.textQuinaryColor
                                            : CustomColors
                                                .textPrimaryLightColor),
                                    fontFamily: Config.manropeMedium,
                                    fontSize: Dimens.space13.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (workspaceChannel.dndEnabled != null &&
                        workspaceChannel.dndEnabled!)
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space12.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: selectedChannel.id == workspaceChannel.id
                              ? Image.asset("assets/images/icon_dnd_white.png",
                                  height: Dimens.space20, width: Dimens.space20)
                              : Image.asset("assets/images/icon_dnd.png",
                                  height: Dimens.space20,
                                  width: Dimens.space20))
                    else if (isWorkspaceSubscriptionActive)
                      Container()
                    else
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space12.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Visibility(
                            visible:
                                workspaceChannel.unseenMessageCount != null &&
                                    workspaceChannel.unseenMessageCount != 0,
                            child: TextHolder(
                              width: Dimens.space24,
                              height: Dimens.space24,
                              text: workspaceChannel.unseenMessageCount !=
                                          null &&
                                      workspaceChannel.unseenMessageCount! > 99
                                  ? Utils.getString("99+")
                                  : workspaceChannel.unseenMessageCount == null
                                      ? "0"
                                      : workspaceChannel.unseenMessageCount
                                          .toString(),
                              corner: Dimens.space8,
                              textColor: CustomColors.white!,
                              containerColor: CustomColors.callDeclineColor!,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space11.sp,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
