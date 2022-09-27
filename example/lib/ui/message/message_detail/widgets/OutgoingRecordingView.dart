import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

//Call Voice mail
class OutgoingRecordingView extends StatefulWidget {
  final RecentConversationEdges? conversationEdge;
  final LoginWorkspaceProvider? loginWorkspaceProvider;
  final VoidCallback? callbackRecording;
  final String? title;

  const OutgoingRecordingView({
    Key? key,
    this.conversationEdge,
    this.callbackRecording,
    this.title,
    this.loginWorkspaceProvider,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OutgoingRecordingViewState();
}

class _OutgoingRecordingViewState extends State<OutgoingRecordingView> {
  bool timeStampShow = true;
  String completeTime = "0";
  bool isPlayDone = false;

  @override
  void initState() {
    super.initState();
    widget.conversationEdge!.advancedPlayer = AudioPlayer();
    widget.conversationEdge!.advancedPlayer!.setSourceUrl(
        widget.conversationEdge!.recentConversationNodes!.content!.body!);
    widget.conversationEdge!.advancedPlayer!.onDurationChanged.listen((event) {
      setState(() {
        widget.conversationEdge!.seekDataTotal = event.inSeconds.toString();
      });
      if (int.parse(widget.conversationEdge!.seekDataTotal!) < 1) {
        setState(() {
          try {
            widget.conversationEdge!.seekDataTotal = widget
                .conversationEdge!.recentConversationNodes!.content!.duration;
          } catch (e) {}
        });
      }
    });
  }

  @override
  void dispose() {
    widget.conversationEdge!.advancedPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.conversationEdge!.recentConversationNodes!.agentInfo != null)
          Container(
            margin: EdgeInsets.fromLTRB(
              Dimens.space10.w,
              Dimens.space16.h,
              Dimens.space10.w,
              Dimens.space0.h,
            ),
            alignment: Alignment.centerRight,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : widget.conversationEdge!.recentConversationNodes!
                              .agentInfo !=
                          null
                      ? (widget.loginWorkspaceProvider!
                              .getAndCompareIsAgentLoggedInMember(widget
                                  .conversationEdge!
                                  .recentConversationNodes!
                                  .agentInfo)
                          ? Utils.getString("youCalled")
                          : ("${widget.conversationEdge!.recentConversationNodes!.agentInfo!.firstname} ${Utils.getString("called")}"))
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
            constraints:
                BoxConstraints(maxWidth: (ScreenUtil().screenWidth * 0.70).w),
            margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              widget.conversationEdge!.recentConversationNodes!.agentInfo !=
                      null
                  ? Dimens.space4.h
                  : Dimens.space16.h,
              Dimens.space0.w,
              Dimens.space0.h,
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
              Dimens.space16.w,
              Dimens.space10.h,
              Dimens.space16.w,
              Dimens.space10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space18.r),
                topRight: Radius.circular(Dimens.space18.r),
                bottomLeft: Radius.circular(Dimens.space18.r),
                bottomRight: Radius.circular(Dimens.space18.r),
              ),
              color: CustomColors.bottomAppBarColor,
            ),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: (ScreenUtil().screenWidth * 0.70).w),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space40,
                          height: Dimens.space40,
                          iconUrl: widget.conversationEdge!
                                      .recentConversationNodes!.direction!
                                      .toLowerCase() ==
                                  CallStateIndex.Outgoing.value.toLowerCase()
                              ? CustomIcon.icon_call_outgoing
                              : CustomIcon.icon_call_incoming,
                          iconColor: CustomColors.callAcceptColor,
                          iconSize: Dimens.space21,
                          boxDecorationColor: CustomColors.mainDividerColor,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space0,
                          imageUrl: "",
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: Dimens.space8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.conversationEdge!.recentConversationNodes!
                                          .direction!
                                          .toLowerCase() ==
                                      CallStateIndex.Outgoing.value
                                          .toLowerCase()
                                  ? Utils.getString("outgoingCall")
                                  : Utils.getString("incomingCall"),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.callTimeDurationAndTime(widget
                                        .conversationEdge!
                                        .recentConversationNodes),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
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
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space2.w,
                    Dimens.space10.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : widget.title!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textTertiaryColor,
                          fontFamily: Config.heeboMedium,
                          fontSize: Dimens.space12.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space2.h,
                    Dimens.space0.w,
                    Dimens.space6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space9.r),
                      topRight: Radius.circular(Dimens.space9.r),
                      bottomLeft: Radius.circular(Dimens.space9.r),
                      bottomRight: Radius.circular(Dimens.space9.r),
                    ),
                    color: CustomColors.mainDividerColor,
                  ),
                  child: Row(
                    children: [
                      RoundedNetworkImageHolder(
                        width: Dimens.space40,
                        height: Dimens.space40,
                        iconUrl: widget.conversationEdge!.isPlay!
                            ? CustomIcon.icon_hold
                            : CustomIcon.icon_play,
                        iconColor: widget.conversationEdge!.isPlay!
                            ? CustomColors.textQuaternaryColor
                            : CustomColors.textQuaternaryColor,
                        iconSize: widget.conversationEdge!.isPlay!
                            ? Dimens.space21
                            : Dimens.space21,
                        boxDecorationColor: CustomColors.mainDividerColor,
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space0,
                        imageUrl: "",
                        onTap: () async {
                          final voiceUrl = widget.conversationEdge!
                              .recentConversationNodes!.content!.body!;
                          if (widget.conversationEdge!.isPlay!) {
                            setState(() {
                              widget.conversationEdge!.isPlay = false;
                            });
                            await widget.conversationEdge!.advancedPlayer!
                                .pause();
                          } else {
                            widget.conversationEdge!.advancedPlayer ??=
                                AudioPlayer();
                            widget.conversationEdge!.advancedPlayer!
                                .setSourceUrl(widget.conversationEdge!
                                    .recentConversationNodes!.content!.body!);
                            setState(() {});
                            await widget.conversationEdge!.advancedPlayer!
                                .play(UrlSource(voiceUrl));
                            widget.conversationEdge!.advancedPlayer!
                                .onDurationChanged
                                .listen((event) {
                              setState(() {
                                widget.conversationEdge!.seekDataTotal =
                                    event.inSeconds.toString();
                              });

                              if (int.parse(
                                      widget.conversationEdge!.seekDataTotal!) <
                                  1) {
                                setState(() {
                                  try {
                                    widget.conversationEdge!.seekDataTotal =
                                        widget
                                            .conversationEdge!
                                            .recentConversationNodes!
                                            .content!
                                            .duration;
                                  } catch (e) {}
                                });
                              }
                            });

                            widget.conversationEdge!.advancedPlayer!
                                .onPositionChanged
                                .listen((event) {
                              setState(() {
                                widget.conversationEdge!.seekData =
                                    event.inSeconds.toString();
                                if (!isPlayDone) {
                                  completeTime = event.inSeconds.toString();
                                }
                                if (isPlayDone) {
                                  widget.conversationEdge!.seekDataTotal =
                                      completeTime;
                                }
                              });
                            });

                            setState(() {
                              widget.conversationEdge!.isPlay = true;
                              widget.conversationEdge!.advancedPlayer!
                                  .onPlayerComplete
                                  .listen((event) {
                                setState(() {
                                  isPlayDone = true;
                                  widget.conversationEdge!.isPlay = false;
                                  widget.conversationEdge!.seekData = "0";
                                });
                              });
                            });
                            widget.callbackRecording!();
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space10.h,
                          Dimens.space0.w,
                          Dimens.space10.h,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space10.w,
                          Dimens.space0.h,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: Dimens.space6.h),
                              constraints: BoxConstraints(
                                  maxWidth: ScreenUtil().screenWidth * 0.28),
                              child:LinearProgressIndicator(
                                minHeight: Dimens.space10.h,
                                value:
                                widget.conversationEdge!.seekData != "0" &&
                                    widget.conversationEdge!
                                        .seekDataTotal !=
                                        "0"
                                    ? (double.parse(widget
                                    .conversationEdge!.seekData!) /
                                    (double.parse(widget
                                        .conversationEdge!
                                        .seekDataTotal!)))
                                    : widget.conversationEdge!.isPlay!
                                    ? 0.9
                                    : 0,
                                // percent:double.parse(widget.conversationEdge.seekData)/60,
                                backgroundColor: CustomColors.callInactiveColor!
                                    .withOpacity(0.6),
                                color: CustomColors.mainColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                Dimens.space10.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.printDurationTotalRemaning(
                                        Duration(
                                            seconds: int.parse(widget
                                                .conversationEdge!.seekData!)),
                                        Duration(
                                            seconds: int.parse(widget
                                                .conversationEdge!
                                                .seekDataTotal!))),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
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
          ),
        ),
      ],
    );
  }
}
