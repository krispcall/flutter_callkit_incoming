import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class OutgoingCallNoAnswerView extends StatelessWidget {
  const OutgoingCallNoAnswerView({
    Key? key,
    this.conversationEdge,
  }) : super(key: key);

  final RecentConversationEdges? conversationEdge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space6.h,
        Dimens.space0.w,
        Dimens.space6.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(
              Dimens.space0,
              Dimens.space8.h,
              Dimens.space0,
              Dimens.space8.h,
            ),
            padding: EdgeInsets.fromLTRB(
              Dimens.space14.w,
              Dimens.space12.h,
              Dimens.space14.w,
              Dimens.space12.h,
            ),
            decoration: BoxDecoration(
              color: CustomColors.bottomAppBarColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space15.r),
                topRight: Radius.circular(Dimens.space15.r),
                bottomLeft: Radius.circular(Dimens.space15.r),
                bottomRight: Radius.circular(Dimens.space15.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundedAssetSvgHolder(
                  containerWidth: Dimens.space40,
                  containerHeight: Dimens.space40,
                  imageWidth: Dimens.space24,
                  imageHeight: Dimens.space24,
                  outerCorner: Dimens.space300,
                  innerCorner: Dimens.space0,
                  iconUrl: CustomIcon.icon_gallery,
                  iconColor: CustomColors.mainColor!,
                  iconSize: Dimens.space0,
                  boxDecorationColor: CustomColors.mainDividerColor!,
                  assetUrl: "assets/images/noAnswer.svg",
                  onTap: () async {},
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
                          Dimens.space4.h,
                          Dimens.space0.w,
                          Dimens.space4.h,
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil().screenWidth * 0.6,
                          ),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("noAnswer"),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal,
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
                            maxWidth: ScreenUtil().screenWidth * 0.6,
                          ),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.callTimeDurationAndTime(
                                    conversationEdge!.recentConversationNodes!),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
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
          ),
        ],
      ),
    );
  }
}
