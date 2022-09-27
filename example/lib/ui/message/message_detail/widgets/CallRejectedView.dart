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

class CallRejectedView extends StatelessWidget {
  const CallRejectedView({
    Key? key,
    required this.conversationEdge,
    required this.onCallTap,
  }) : super(key: key);

  final RecentConversationEdges conversationEdge;
  final Function(RecentConversationEdges) onCallTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
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
              Dimens.space14.w,
              Dimens.space10.h,
              Dimens.space14.w,
              Dimens.space10.h,
            ),
            decoration: BoxDecoration(
              color: CustomColors.errorBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space15.r),
                topRight: Radius.circular(Dimens.space15.r),
                bottomLeft: Radius.circular(Dimens.space15.r),
                bottomRight: Radius.circular(Dimens.space15.r),
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
                        iconUrl: CustomIcon.icon_call_busy,
                        iconColor: CustomColors.redButtonColor,
                        iconSize: Dimens.space21,
                        boxDecorationColor:
                            CustomColors.redButtonColor?.withOpacity(0.12),
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space0,
                        imageUrl: "",
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space10.w,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                  maxWidth: ScreenUtil().screenWidth * 0.6),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("callRejected"),
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
                                  maxWidth: ScreenUtil().screenWidth * 0.6),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.printCallTimeDuration(
                                        conversationEdge
                                            .recentConversationNodes!),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
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
                Container(
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space8.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space0.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  alignment: Alignment.center,
                  child: RoundedButtonWidget(
                    width: Dimens.space178.w,
                    height: Dimens.space34.w,
                    corner: Dimens.space10,
                    buttonBackgroundColor: CustomColors.redButtonColor!,
                    buttonTextColor: CustomColors.white!,
                    buttonText: Utils.getString("redial"),
                    buttonBorderColor: CustomColors.redButtonColor!,
                    buttonFontFamily: Config.manropeSemiBold,
                    buttonFontSize: Dimens.space14,
                    onPressed: (RecentConversationEdges conversationEdge) {
                      onCallTap(conversationEdge);
                    },
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
