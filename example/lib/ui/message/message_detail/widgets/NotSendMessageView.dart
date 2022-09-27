import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class NotSendMessageView extends StatefulWidget {
  final RecentConversationEdges? conversationEdge;
  final String? boxDecorationType;
  final Function? onReSendTap;
  final String? searchQuery;
  final bool? isSearching;

  const NotSendMessageView({
    Key? key,
    this.conversationEdge,
    this.onReSendTap,
    this.boxDecorationType,
    this.searchQuery,
    this.isSearching,
  }) : super(key: key);

  @override
  _NotSendMessageViewState createState() => _NotSendMessageViewState();
}

class _NotSendMessageViewState extends State<NotSendMessageView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      Dimens.space0.h,
                    ),
                    margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space11.w,
                      Dimens.space0.h,
                    ),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space36,
                      height: Dimens.space36,
                      iconUrl: Icons.refresh_outlined,
                      iconColor: CustomColors.textPrimaryErrorColor,
                      iconSize: Dimens.space20,
                      boxDecorationColor: CustomColors.bottomAppBarColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      imageUrl: "",
                      onTap: () {
                        widget.onReSendTap!(widget.conversationEdge
                            ?.recentConversationNodes?.content?.body);
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
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
                        color: CustomColors.redButtonColor?.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimens.space15.r),
                          topRight: Radius.circular(Dimens.space15.r),
                          bottomLeft: Radius.circular(Dimens.space15.r),
                          bottomRight: Radius.circular(Dimens.space15.r),
                        ),
                      ),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
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
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: Dimens.space20.w,
                      color: CustomColors.textPrimaryErrorColor,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space3.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: ScreenUtil().screenWidth * 0.3),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("failedToSend"),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontFamily: Config.heeboMedium,
                                    fontSize: Dimens.space12.sp,
                                    color: CustomColors.textPrimaryErrorColor,
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
        ],
      ),
    );
  }
}
