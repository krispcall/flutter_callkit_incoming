import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class OutGoingCallView extends StatelessWidget {
  const OutGoingCallView({
    Key? key,
    this.conversationEdge,
    this.loginWorkspaceProvider,
  }) : super(key: key);

  final RecentConversationEdges? conversationEdge;
  final LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (conversationEdge?.recentConversationNodes?.agentInfo != null)
          Container(
            margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Dimens.space16.h,
              Dimens.space10.w,
              Dimens.space0.h,
            ),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : conversationEdge?.recentConversationNodes?.agentInfo != null
                      ? (loginWorkspaceProvider!
                              .getAndCompareIsAgentLoggedInMember(
                                  conversationEdge!
                                      .recentConversationNodes!.agentInfo)
                          ? Utils.getString("youCalled")
                          : ("${conversationEdge?.recentConversationNodes?.agentInfo?.firstname}${Utils.getString("called")}"))
                      : "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space12.sp,
                    fontWeight: FontWeight.normal,
                    color: CustomColors.textPrimaryColor,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          )
        else
          Container(),
        Container(
          margin: EdgeInsets.fromLTRB(
            Dimens.space0.w,
            conversationEdge?.recentConversationNodes?.agentInfo != null
                ? Dimens.space4.h
                : Dimens.space16.h,
            Dimens.space0.w,
            Dimens.space0.h,
          ),
          padding: EdgeInsets.fromLTRB(
            Dimens.space0.w,
            Dimens.space0.h,
            Dimens.space0.w,
            Dimens.space0.h,
          ),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                    bottomLeft: Radius.circular(Dimens.space15.r),
                    bottomRight: Radius.circular(Dimens.space15.r),
                  ),
                ),
                child: Row(
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
                        iconUrl: CustomIcon.icon_call_outgoing,
                        iconColor: CustomColors.callAcceptColor,
                        iconSize: Dimens.space21,
                        boxDecorationColor: CustomColors.mainDividerColor,
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
                                maxWidth: ScreenUtil().screenWidth * 0.6,
                              ),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("outgoingCall"),
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
                                maxWidth: ScreenUtil().screenWidth * 0.6,
                              ),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.callTimeDurationAndTime(
                                        conversationEdge!
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
        ),
      ],
    );
  }
}
