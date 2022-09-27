import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";

// Incoming List Handler
class IncomingMessageView extends StatefulWidget {
  final RecentConversationMemberEdge conversationEdge;
  final String query;
  final bool isSearching;

  const IncomingMessageView({
    Key? key,
    required this.conversationEdge,
    required this.query,
    required this.isSearching,
  }) : super(key: key);

  @override
  _IncomingMessageViewState createState() => _IncomingMessageViewState();
}

class _IncomingMessageViewState extends State<IncomingMessageView> {
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
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: GestureDetector(
                    onLongPress: () {
                      timeStamp = !timeStamp;
                      setState(() {});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                          constraints: BoxConstraints(
                            maxWidth: Dimens.space200.w,
                          ),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : widget
                                        .conversationEdge
                                        .recentConversationMemberNodes
                                        ?.message ??
                                    "",
                            maxLines: 100,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textPrimaryColor,
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
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space0.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.convertCallTime(
                            widget.conversationEdge
                                .recentConversationMemberNodes!.createdOn!
                                .split("+")[0],
                            "yyyy-MM-ddThh:mm:ss.SSSSSS",
                            "hh:mm a"),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
        ],
      ),
    );
  }
}
