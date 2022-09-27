import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class InComingCallMissedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final Function(RecentConversationEdges) onCallTap;

  const InComingCallMissedView({
    required this.conversationEdge,
    required this.onCallTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space16.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      padding: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
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
              Dimens.space14.w,
              Dimens.space10.h,
              Dimens.space14.w,
              Dimens.space10.h,
            ),
            decoration: BoxDecoration(
              color: CustomColors.bottomAppBarColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space15.r),
                topRight: Radius.circular(Dimens.space15.r),
                bottomRight: Radius.circular(Dimens.space15.r),
                bottomLeft: Radius.circular(Dimens.space15.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
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
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space40,
                        height: Dimens.space40,
                        iconUrl: CustomIcon.icon_call_missed,
                        iconColor: Colors.white,
                        iconSize: Dimens.space21,
                        boxDecorationColor: CustomColors.redButtonColor,
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space0,
                        imageUrl: "",
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space10.w,
                        Dimens.space0.w,
                        Dimens.space0.w,
                        Dimens.space0.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.w,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.6,
                              ),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("missedCall"),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.w,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.6,
                              ),
                              child: conversationEdge
                                          .recentConversationNodes?.content !=
                                      null
                                  ? Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : Utils.callTimeDurationAndTime(
                                              conversationEdge
                                                  .recentConversationNodes!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              fontFamily: Config.heeboRegular,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontSize: Dimens.space13.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                    )
                                  : Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : Utils.callTimeDurationAndTime(
                                              conversationEdge
                                                  .recentConversationNodes!),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            fontFamily: Config.heeboRegular,
                                            fontSize: Dimens.space13.sp,
                                            color:
                                                CustomColors.textTertiaryColor,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (Utils.check48Hours(
                    conversationEdge.recentConversationNodes!.createdAt!))
                  Container(
                    width: Dimens.space178.w,
                    height: Dimens.space34.w,
                    margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space10.h,
                      Dimens.space0.w,
                      Dimens.space2.h,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      Dimens.space0.h,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().screenWidth * 0.5,
                      ),
                      child: RoundedButtonWidget(
                        width: Dimens.space178.w,
                        height: Dimens.space38.w,
                        corner: Dimens.space10,
                        buttonBackgroundColor: CustomColors.loadingCircleColor!,
                        buttonTextColor: CustomColors.white!,
                        buttonText: Utils.getString("callBack"),
                        buttonBorderColor: CustomColors.loadingCircleColor!,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonFontSize: Dimens.space14,
                        onPressed: () {
                          onCallTap(conversationEdge);
                        },
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
}
