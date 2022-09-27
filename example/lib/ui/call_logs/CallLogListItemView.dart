import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
import "package:mvp/ui/call_logs/widgets/CallLogImageAndTextWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class CallLogVerticalListItem extends StatelessWidget {
  const CallLogVerticalListItem(
      {Key? key,
      required this.callLog,
      required this.index,
      required this.animationController,
      required this.animation,
      required this.onCallTap,
      required this.onPressed,
      required this.slidAbleController,
      required this.onPinTap,
      required this.memberId,
      this.containSlideable = true,
      required this.type})
      : super(key: key);

  final RecentConversationEdges? callLog;
  final int? index;
  final bool? containSlideable;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function(String?, String?)? onCallTap;
  final Function? onPressed;
  final SlidableController? slidAbleController;
  final Function(String, bool)? onPinTap;
  final CallType? type;
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    if (callLog!.recentConversationNodes == null) {
      return Divider(
        color: CustomColors.mainDividerColor,
        height: Dimens.space1.h,
        thickness: Dimens.space1.h,
      );
    } else {
      return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation!.value), 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Slidable(
                      actionPane: const SlidableDrawerActionPane(),
                      actionExtentRatio: 0.18,
                      fastThreshold: 1,
                      controller: slidAbleController,
                      actions: const [],
                      secondaryActions: containSlideable!
                          ? <Widget>[
                              TextButton(
                                onPressed: () {
                                  onPinTap!(
                                      callLog!
                                          .recentConversationNodes!.clientNumber!,
                                      callLog!.recentConversationNodes!
                                          .contactPinned!);
                                },
                                style: TextButton.styleFrom(
                                  alignment: Alignment.center,
                                  backgroundColor: CustomColors.warningColor,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0,
                                      Dimens.space0,
                                      Dimens.space0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.space0.r),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundedNetworkImageHolder(
                                      width: Dimens.space20,
                                      height: Dimens.space20,
                                      iconUrl: CustomIcon.icon_pin,
                                      iconColor: CustomColors.white!,
                                      iconSize: Dimens.space20,
                                      outerCorner: Dimens.space10,
                                      innerCorner: Dimens.space10,
                                      boxDecorationColor:
                                          CustomColors.transparent!,
                                      imageUrl: "",
                                      onTap: () {
                                        onPinTap!(
                                            callLog!.recentConversationNodes!
                                                .clientNumber!,
                                            callLog!.recentConversationNodes!
                                                .contactPinned!);
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        Dimens.space4.w,
                                        Dimens.space4.h,
                                        Dimens.space4.w,
                                        Dimens.space4.h,
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : callLog!.recentConversationNodes!
                                                            .contactPinned !=
                                                        null &&
                                                    callLog!
                                                        .recentConversationNodes!
                                                        .contactPinned!
                                                ? Utils.getString("unPin")
                                                : Utils.getString("pin"),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: CustomColors.white,
                                              fontFamily:
                                                  Config.manropeSemiBold,
                                              fontSize: Dimens.space12.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  onCallTap!(
                                    callLog!.recentConversationNodes!
                                                .clientInfo !=
                                            null
                                        ? callLog!.recentConversationNodes!
                                            .clientInfo!.name
                                        : callLog!.recentConversationNodes!
                                            .clientNumber,
                                    callLog!
                                        .recentConversationNodes!.clientNumber,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      CustomColors.loadingCircleColor,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.space0.r),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundedNetworkImageHolder(
                                      width: Dimens.space20,
                                      height: Dimens.space20,
                                      iconUrl: CustomIcon.icon_call,
                                      iconColor: CustomColors.white!,
                                      iconSize: Dimens.space20,
                                      outerCorner: Dimens.space10,
                                      innerCorner: Dimens.space10,
                                      boxDecorationColor:
                                          CustomColors.transparent!,
                                      imageUrl: "",
                                      onTap: () {
                                        onCallTap!(
                                          callLog!.recentConversationNodes!
                                                      .clientInfo !=
                                                  null
                                              ? callLog!.recentConversationNodes!
                                                  .clientInfo!.name
                                              : callLog!.recentConversationNodes!
                                                  .clientNumber,
                                          callLog!.recentConversationNodes!
                                              .clientNumber,
                                        );
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        Dimens.space4.w,
                                        Dimens.space4.h,
                                        Dimens.space4.w,
                                        Dimens.space4.h,
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : Utils.getString("call"),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: CustomColors.white,
                                              fontFamily:
                                                  Config.manropeSemiBold,
                                              fontSize: Dimens.space12.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : <Widget>[],
                      child: CallLogImageAndTextWidget(
                        callLog: callLog!,
                        onPressed: () {
                          onPressed!();
                        },
                        type: type!,
                        memberId: memberId!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
