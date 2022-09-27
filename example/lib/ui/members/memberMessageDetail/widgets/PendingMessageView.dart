import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";

class PendingMessageView extends StatelessWidget {
  final RecentConversationMemberEdge conversationEdge;
  final String boxDecorationType;
  final String query;
  final bool isSearching;

  const PendingMessageView({
    Key? key,
    required this.conversationEdge,
    required this.boxDecorationType,
    required this.query,
    required this.isSearching,
  }) : super(key: key);

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
              color: isSearching &&
                      conversationEdge.recentConversationMemberNodes!.message!
                          .toLowerCase()
                          .contains(query.toLowerCase())
                  ? CustomColors.callAcceptColor
                  : CustomColors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space15.r),
                topRight: Radius.circular(Dimens.space15.r),
                bottomRight: Radius.circular(Dimens.space15.r),
                bottomLeft: Radius.circular(Dimens.space15.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    color: CustomColors.mainColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space15.r),
                      topRight: Radius.circular(Dimens.space15.r),
                      bottomRight: Radius.circular(Dimens.space15.r),
                      bottomLeft: Radius.circular(Dimens.space15.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        constraints: BoxConstraints(
                          maxWidth: Dimens.space200.w,
                        ),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : conversationEdge
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
