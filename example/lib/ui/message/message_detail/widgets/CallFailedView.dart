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

class CallFailedView extends StatelessWidget {
  const CallFailedView(
      {Key? key, required this.conversationEdge, required this.makeCallWithSid})
      : super(key: key);

  final RecentConversationEdges conversationEdge;
  final Function(RecentConversationEdges) makeCallWithSid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0,
        Dimens.space6.h,
        Dimens.space0,
        Dimens.space6.h,
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
              Dimens.space12.h,
              Dimens.space14.w,
              Dimens.space12.h,
            ),
            decoration: BoxDecoration(
              color: CustomColors.lightRedColor,
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
                    // Container(
                    //   width: Dimens.space40.w,
                    //   height: Dimens.space40.w,
                    //   decoration: BoxDecoration(
                    //     color: CustomColors.redIconContainerColor,
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(Dimens.space20.w)),
                    //   ),
                    //   alignment: Alignment.center,
                    //   child: SvgPicture.asset(
                    //     "assets/images/call_failed.svg",
                    //     fit: BoxFit.cover,
                    //     clipBehavior: Clip.antiAlias,
                    //   ),
                    // ),
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
                      boxDecorationColor: CustomColors.redButtonColor!,
                      assetUrl: "assets/images/call_failed.svg",
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
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space2.h,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * 0.6,
                              ),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("callFailed"),
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
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space2.h,
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
                                        conversationEdge
                                            .recentConversationNodes!),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  child: Container(
                    width: Dimens.space178.w,
                    margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space10.h,
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
                      onPressed: () async {
                        makeCallWithSid(conversationEdge);
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
