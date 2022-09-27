import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class OutGoingMessageView extends StatefulWidget {
  final RecentConversationEdges? prevConversationEdge;
  final RecentConversationEdges? conversationEdge;
  final String? boxDecorationType;
  final LoginWorkspaceProvider? loginWorkspaceProvider;
  final String? searchQuery;
  final bool? isSearching;

  const OutGoingMessageView({
    Key? key,
    this.prevConversationEdge,
    this.conversationEdge,
    this.boxDecorationType,
    this.loginWorkspaceProvider,
    this.searchQuery,
    this.isSearching,
  }) : super(key: key);

  @override
  _OutGoingMessageViewState createState() => _OutGoingMessageViewState();
}

class _OutGoingMessageViewState extends State<OutGoingMessageView> {
  bool timeStamp = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space4.h,
        Dimens.space0.w,
        Dimens.space4.h,
      ),
      padding: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              getAgentInfo(),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                  Dimens.space0.w,
                  Dimens.space4.h,
                  Dimens.space0.w,
                  Dimens.space4.h,
                ),
                padding: EdgeInsets.fromLTRB(
                  Dimens.space1.w,
                  Dimens.space1.h,
                  Dimens.space1.w,
                  Dimens.space1.h,
                ),
                decoration: BoxDecoration(
                  color: widget.isSearching! &&
                          widget.conversationEdge!.recentConversationNodes!
                              .content!.body!
                              .toLowerCase()
                              .contains(widget.searchQuery!.toLowerCase())
                      ? CustomColors.callAcceptColor
                      : CustomColors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space15.r),
                    topRight: Radius.circular(Dimens.space15.r),
                    bottomRight: Radius.circular(Dimens.space15.r),
                    bottomLeft: Radius.circular(Dimens.space15.r),
                  ),
                ),
                child: Container(
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
                    color: CustomColors.mainColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space15.r),
                      topRight: Radius.circular(Dimens.space15.r),
                      bottomLeft: Radius.circular(Dimens.space15.r),
                      bottomRight: Radius.circular(Dimens.space15.r),
                    ),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      timeStamp = !timeStamp;
                      Utils.cPrint(widget.prevConversationEdge!
                          .recentConversationNodes!.conversationType!);
                      Utils.cPrint(widget.prevConversationEdge!
                          .recentConversationNodes!.conversationStatus!);
                      Utils.cPrint(widget.prevConversationEdge!
                          .recentConversationNodes!.content!.body!);
                      Utils.cPrint(widget.prevConversationEdge!
                          .recentConversationNodes!.direction!);
                      Utils.cPrint(widget.prevConversationEdge!
                          .recentConversationNodes!.agentInfo!.agentId!);

                      Utils.cPrint(widget.conversationEdge!
                          .recentConversationNodes!.conversationType!);
                      Utils.cPrint(widget.conversationEdge!
                          .recentConversationNodes!.conversationStatus!);
                      Utils.cPrint(widget.conversationEdge!
                          .recentConversationNodes!.content!.body!);
                      Utils.cPrint(widget.conversationEdge!
                          .recentConversationNodes!.agentInfo!.agentId!);

                      setState(() {});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          margin: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: Dimens.space200.w,
                          ),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : widget.conversationEdge!
                                    .recentConversationNodes!.content!.body!,
                            maxLines: 100,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.white,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space16.sp,
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
              Offstage(
                offstage: timeStamp,
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space0.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil().screenWidth * 0.2),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.convertCallTime(
                                    widget.conversationEdge!
                                        .recentConversationNodes!.createdAt!
                                        .split("+")[0],
                                    "yyyy-MM-ddThh:mm:ss.SSSSSS",
                                    "hh:mm a"),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: CustomColors.callAcceptColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getAgentInfo() {
    if (widget.prevConversationEdge != null) {
      if (widget.prevConversationEdge?.recentConversationNodes
              ?.conversationType ==
          widget.conversationEdge?.recentConversationNodes?.conversationType) {
        if (widget.prevConversationEdge?.recentConversationNodes?.direction ==
            CallStateIndex.Outgoing.value) {
          if (widget.conversationEdge?.recentConversationNodes?.agentInfo !=
                  null &&
              widget.prevConversationEdge?.recentConversationNodes?.agentInfo !=
                  null &&
              widget.prevConversationEdge?.recentConversationNodes?.agentInfo
                      ?.agentId !=
                  widget.conversationEdge?.recentConversationNodes?.agentInfo
                      ?.agentId) {
            return Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space10.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : widget.conversationEdge!.recentConversationNodes!
                                .agentInfo !=
                            null
                        ? widget.conversationEdge!.recentConversationNodes!
                            .agentInfo!.firstname!
                        : "",
                textAlign: TextAlign.right,
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
            );
          } else {
            return Container();
          }
        } else {
          return Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
                Dimens.space10.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : widget.conversationEdge!.recentConversationNodes!
                              .agentInfo !=
                          null
                      ? widget.conversationEdge!.recentConversationNodes!
                          .agentInfo!.firstname!
                      : "",
              textAlign: TextAlign.right,
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
          );
        }
      } else {
        return Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
              Dimens.space10.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : widget.conversationEdge!.recentConversationNodes!.agentInfo !=
                        null
                    ? widget.conversationEdge!.recentConversationNodes!
                            .agentInfo!.firstname ??
                        ""
                    : "",
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space12.sp,
                  fontWeight: FontWeight.normal,
                  color: CustomColors.textPrimaryColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        );
      }
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space10.w, Dimens.space0.h),
        child: Text(
          Config.checkOverFlow
              ? Const.OVERFLOW
              : widget.conversationEdge!.recentConversationNodes!.agentInfo !=
                      null
                  ? widget.conversationEdge!.recentConversationNodes!.agentInfo!
                      .firstname!
                  : "",
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontFamily: Config.heeboRegular,
                fontSize: Dimens.space12.sp,
                fontWeight: FontWeight.normal,
                color: CustomColors.textPrimaryColor,
                fontStyle: FontStyle.italic,
              ),
        ),
      );
    }
  }
}
