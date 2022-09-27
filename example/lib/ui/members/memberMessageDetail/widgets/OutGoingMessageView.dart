import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/members/memberMessageDetail/widgets/NotSendMessageView.dart";
import "package:mvp/ui/members/memberMessageDetail/widgets/PendingMessageView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";

// Outgoing List Handler
class OutBoundListHandlerView extends StatelessWidget {
  const OutBoundListHandlerView({
    Key? key,
    required this.conversationEdge,
    required this.onResendTap,
    this.boxDecorationType,
    required this.query,
    required this.isSearching,
  }) : super(key: key);

  final String query;
  final RecentConversationMemberEdge conversationEdge;
  final Function onResendTap;
  final String? boxDecorationType;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (conversationEdge.recentConversationMemberNodes?.type == "Message") {
          if (conversationEdge.recentConversationMemberNodes?.status ==
                  "DELIVERED" ||
              conversationEdge.recentConversationMemberNodes?.status ==
                  "Sent" ||
              conversationEdge.recentConversationMemberNodes?.status ==
                  "Seen") {
            return OutGoingMessageView(
              conversationEdge: conversationEdge,
              boxDecorationType: boxDecorationType,
              query: query,
              isSearching: isSearching,
            );
          } else if (conversationEdge.recentConversationMemberNodes?.status ==
              "PENDING") {
            return PendingMessageView(
              conversationEdge: conversationEdge,
              boxDecorationType: boxDecorationType!,
              query: query,
              isSearching: isSearching,
            );
          } else {
            return NotSendMessageView(
              conversationEdge: conversationEdge,
              onReSendTap: onResendTap,
              boxDecorationType: boxDecorationType,
              query: query,
              isSearching: isSearching,
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class OutGoingMessageView extends StatefulWidget {
  final RecentConversationMemberEdge conversationEdge;
  final String? boxDecorationType;
  final String query;
  final bool isSearching;

  const OutGoingMessageView({
    Key? key,
    required this.conversationEdge,
    required this.boxDecorationType,
    required this.query,
    required this.isSearching,
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
                  color: widget.isSearching &&
                          widget.conversationEdge.recentConversationMemberNodes!
                              .message!
                              .toLowerCase()
                              .contains(widget.query.toLowerCase())
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
                      bottomRight: Radius.circular(Dimens.space15.r),
                      bottomLeft: Radius.circular(Dimens.space15.r),
                    ),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      timeStamp = !timeStamp;
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
                                : widget.conversationEdge
                                    .recentConversationMemberNodes!.message!,
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
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.convertCallTime(
                                  widget.conversationEdge
                                      .recentConversationMemberNodes!.createdOn!
                                      .split("+")[0],
                                  "yyyy-MM-ddThh:mm:ss.SSSSSS",
                                  "hh:mm a"),
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
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: CustomColors.callAcceptColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
