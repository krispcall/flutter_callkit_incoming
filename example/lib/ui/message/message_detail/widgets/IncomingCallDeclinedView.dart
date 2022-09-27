import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class IncomingCallDeclinedView extends StatefulWidget {
  final RecentConversationEdges? conversationEdge;
  final LoginWorkspaceProvider? loginWorkspaceProvider;
  final Function(RecentConversationEdges)? callback;

  const IncomingCallDeclinedView({
    Key? key,
    this.conversationEdge,
    this.callback,
    this.loginWorkspaceProvider,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IncomingCallDeclinedViewState();
}

class _IncomingCallDeclinedViewState extends State<IncomingCallDeclinedView> {
  bool timeStampShow = true;
  String completeTime = "0";
  bool isPlayDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.conversationEdge?.advancedPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.conversationEdge?.recentConversationNodes?.agentInfo != null)
          Container(
            margin: EdgeInsets.fromLTRB(
              Dimens.space10.w,
              Dimens.space16.h,
              Dimens.space0.w,
              Dimens.space0.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : widget.conversationEdge?.recentConversationNodes
                              ?.agentInfo !=
                          null
                      ? (widget.loginWorkspaceProvider!
                              .getAndCompareIsAgentLoggedInMember(widget
                                  .conversationEdge!
                                  .recentConversationNodes!
                                  .agentInfo)
                          ? Utils.getString("declinedByYou")
                          : ("${Utils.getString("declinedBy")} ${widget.conversationEdge?.recentConversationNodes?.agentInfo?.firstname}"))
                      : "",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space12.sp,
                  fontWeight: FontWeight.normal,
                  color: CustomColors.textPrimaryColor,
                  fontStyle: FontStyle.italic),
            ),
          )
        else
          Container(),
        GestureDetector(
          onLongPress: () {
            setState(() {
              timeStampShow = !timeStampShow;
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              widget.conversationEdge?.recentConversationNodes?.agentInfo !=
                      null
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
            alignment: Alignment.centerLeft,
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
                              iconUrl: CustomIcon.icon_call_cancelled,
                              iconColor: CustomColors.textPrimaryLightColor,
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
                                        maxWidth:
                                            ScreenUtil().screenWidth * 0.6),
                                    child: Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : Utils.getString("callDeclined"),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontFamily: Config.manropeBold,
                                            fontSize: Dimens.space14.sp,
                                            fontWeight: FontWeight.w600,
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
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            ScreenUtil().screenWidth * 0.6),
                                    child: Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : Utils.callTimeDurationAndTime(widget
                                              .conversationEdge!
                                              .recentConversationNodes!),
                                      // "${Utils.convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], "yyyy-MM-ddThh:mm:ss.SSSSSS", "hh:mm a")}",
                                      // "${conversationEdge.recentConversationNodes.content.duration} - ${Utils.convertCallTime(conversationEdge.recentConversationNodes.content.callTime, "EEE, dd MMM yyyy hh:mm:ss +0000", "hh:mm a")}",
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
                      if (Utils.check48Hours(widget.conversationEdge!
                          .recentConversationNodes!.createdAt!))
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
                              buttonBackgroundColor:
                                  CustomColors.loadingCircleColor!,
                              buttonTextColor: CustomColors.white!,
                              buttonText: Utils.getString("callBack"),
                              buttonBorderColor:
                                  CustomColors.loadingCircleColor!,
                              buttonFontFamily: Config.manropeSemiBold,
                              buttonFontSize: Dimens.space14,
                              onPressed: () {
                                widget.callback!(widget.conversationEdge!);
                              },
                            ),
                          ),
                        ),
                    ],
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
