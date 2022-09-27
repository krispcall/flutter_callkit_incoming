import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class CallMessageVoiceMailWidget extends StatelessWidget {
  final RecentConversationEdges? callLog;
  final CallType? type;
  final String? agent;

  const CallMessageVoiceMailWidget({
    Key? key,
    this.callLog,
    this.type,
    this.agent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (callLog!.recentConversationNodes!.direction ==
        CallStateIndex.Incoming.value) {
      if (callLog!.recentConversationNodes!.conversationType ==
          CallStateIndex.Message.value) {
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : callLog!.recentConversationNodes!.content!.body!,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: CustomColors.textPrimaryLightColor,
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                ),
          ),
        );
      } else {
        if (callLog!.recentConversationNodes!.conversationStatus ==
                CallStateIndex.COMPLETED.value &&
            callLog!.recentConversationNodes!.content != null &&
            callLog!.recentConversationNodes!.content!.body != null) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : (callLog!.recentConversationNodes!.clientInfo != null &&
                                callLog!.recentConversationNodes!.clientInfo!
                                        .name !=
                                    null)
                            ? "${callLog!.recentConversationNodes!.clientInfo!.name} ${Utils.getString("calledYou")}"
                            : "${callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("calledYou")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.content != null &&
            callLog!.recentConversationNodes!.content!.body != null) {
          ///DONE
          return Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.voicemail,
                    size: Dimens.space14.w,
                    color: CustomColors.warningColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : callLog!.recentConversationNodes!.clientInfo !=
                                      null &&
                                  callLog!.recentConversationNodes!.clientInfo!
                                          .name !=
                                      null
                              ? callLog!
                                      .recentConversationNodes!.clientInfo!.name! +
                                  Utils.getString("sentYouAVoiceMail")
                              : callLog!.recentConversationNodes!.clientNumber! +
                                  Utils.getString("sentYouAVoiceMail"),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.heeboRegular,
                            fontSize: Dimens.space14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.NOANSWER.value) {
          ///DONE
          if (callLog!.recentConversationNodes!.content != null &&
              callLog!.recentConversationNodes!.content!.body != null) {
            ///DONE
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.voicemail,
                      size: Dimens.space14.w,
                      color: CustomColors.warningColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : callLog!.recentConversationNodes!.clientInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!.clientInfo!
                                            .name !=
                                        null
                                ? callLog!.recentConversationNodes!.clientInfo!
                                        .name! +
                                    Utils.getString("sentYouAVoiceMail")
                                : callLog!.recentConversationNodes!.clientNumber! +
                                    Utils.getString("sentYouAVoiceMail"),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            ///DONE
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space16,
                    height: Dimens.space16,
                    iconUrl: CustomIcon.icon_call_missed,
                    iconColor: CustomColors.redButtonColor!,
                    boxDecorationColor: CustomColors.transparent!,
                    iconSize: Dimens.space16,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("missedCall"),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: CustomColors.redButtonColor,
                            fontSize: Dimens.space14.sp,
                            fontFamily: Config.heeboRegular,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.CANCELED.value) {
          ///DONE
          if (callLog!.recentConversationNodes!.content != null &&
              callLog!.recentConversationNodes!.content!.body != null) {
            ///DONE
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.voicemail,
                      size: Dimens.space14.w,
                      color: CustomColors.warningColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : callLog!.recentConversationNodes!.clientInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!.clientInfo!
                                            .name !=
                                        null
                                ? callLog!.recentConversationNodes!.clientInfo!
                                        .name! +
                                    Utils.getString("sentYouAVoiceMail")
                                : callLog!.recentConversationNodes!.clientNumber! +
                                    Utils.getString("sentYouAVoiceMail"),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            ///DONE
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space16,
                    height: Dimens.space16,
                    iconUrl: CustomIcon.icon_call_missed,
                    iconColor: CustomColors.redButtonColor!,
                    boxDecorationColor: CustomColors.transparent!,
                    iconSize: Dimens.space16,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("missedCall"),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: CustomColors.redButtonColor,
                            fontSize: Dimens.space14.sp,
                            fontFamily: Config.heeboRegular,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.COMPLETED.value) {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : (callLog!.recentConversationNodes!.clientInfo != null &&
                                callLog!.recentConversationNodes!.clientInfo!
                                        .name !=
                                    null)
                            ? "${callLog!.recentConversationNodes!.clientInfo!.name} ${Utils.getString("calledYou")}"
                            : "${callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("calledYou")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.REJECTED.value) {
          ///Done
          if (callLog!.recentConversationNodes!.content != null &&
              callLog!.recentConversationNodes!.content!.body != null) {
            ///DONE
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.voicemail,
                      size: Dimens.space14.w,
                      color: CustomColors.warningColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : callLog!.recentConversationNodes!.clientInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!.clientInfo!
                                            .name !=
                                        null
                                ? callLog!.recentConversationNodes!.clientInfo!
                                        .name! +
                                    Utils.getString("sentYouAVoiceMail")
                                : callLog!.recentConversationNodes!.clientNumber! +
                                    Utils.getString("sentYouAVoiceMail"),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            ///DONE
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space20,
                    height: Dimens.space18,
                    iconUrl: CustomIcon.icon_call_cancelled,
                    iconColor: CustomColors.textPrimaryLightColor!,
                    boxDecorationColor: CustomColors.transparent!,
                    iconSize: Dimens.space15,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space3.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      " ${callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("declinedCall")}",
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontSize: Dimens.space14.sp,
                            fontFamily: Config.heeboRegular,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.BUSY.value) {
          ///Done
          if (callLog!.recentConversationNodes!.content != null &&
              callLog!.recentConversationNodes!.content!.body != null) {
            ///DONE
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.voicemail,
                      size: Dimens.space14.w,
                      color: CustomColors.warningColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : callLog!.recentConversationNodes!.clientInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!.clientInfo!
                                            .name !=
                                        null
                                ? callLog!.recentConversationNodes!.clientInfo!
                                        .name! +
                                    Utils.getString("sentYouAVoiceMail")
                                : callLog!.recentConversationNodes!.clientNumber! +
                                    Utils.getString("sentYouAVoiceMail"),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            ///DONE
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space20,
                    height: Dimens.space18,
                    iconUrl: CustomIcon.icon_call_cancelled,
                    iconColor: CustomColors.textPrimaryLightColor!,
                    boxDecorationColor: CustomColors.transparent!,
                    iconSize: Dimens.space15,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space3.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      "${agent == "" ? "Agent" : agent} ${Utils.getString("declinedCall")}",
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontSize: Dimens.space14.sp,
                            fontFamily: Config.heeboRegular,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.PENDING.value) {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("ringingDesc")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.RINGING.value) {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("ringingDesc")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.INPROGRESS.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.OnHOLD.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.TRANSFERRING.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : (callLog!.recentConversationNodes!.clientInfo != null &&
                                callLog!.recentConversationNodes!.clientInfo!
                                        .name !=
                                    null)
                            ? "${callLog!.recentConversationNodes!.clientInfo!.name} ${Utils.getString("calledYou")}"
                            : "${callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("calledYou")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        }
      }
    } else {
      if (callLog!.recentConversationNodes!.conversationType ==
          CallStateIndex.Message.value) {
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : callLog!.recentConversationNodes!.content!.body!,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: CustomColors.textPrimaryLightColor,
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                ),
          ),
        );
      } else {
        if (callLog!.recentConversationNodes!.conversationStatus ==
                CallStateIndex.COMPLETED.value &&
            callLog!.recentConversationNodes!.content != null &&
            callLog!.recentConversationNodes!.content!.body != null) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${agent == "" ? "Undefine" : agent} called ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.content != null &&
            callLog!.recentConversationNodes!.content!.body != null) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${agent == "" ? "Undefine" : agent} called ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.PENDING.value) {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("ringingDesc")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.RINGING.value) {
          ///Done
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("ringingDesc")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.INPROGRESS.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.OnHOLD.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.TRANSFERRING.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    " ${Utils.getString("inProgress")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.COMPLETED.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${agent == "" ? "Undefine" : agent} called ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.ATTEMPTED.value) {
          ///DONE
          ///TODO NO longer triggered
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${Utils.getString("youCalled")} ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.FAILED.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space18,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_call_failed,
                  iconColor: CustomColors.redButtonColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space18,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${Utils.getString("callTo")} ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("failed")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.NOANSWER.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space18,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_call_busy,
                  iconColor: CustomColors.textPrimaryLightColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space18,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("didNotAnswer")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.BUSY.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space18,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_call_busy,
                  iconColor: CustomColors.textPrimaryLightColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space18,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("didNotAnswer")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else if (callLog!.recentConversationNodes!.conversationStatus ==
            CallStateIndex.CANCELED.value) {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space18,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_call_cancelled,
                  iconColor: CustomColors.textPrimaryLightColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space18,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${Utils.getString("callTo")} ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber} ${Utils.getString("cancelled")}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        } else {
          ///DONE
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space20,
                  height: Dimens.space18,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor!,
                  boxDecorationColor: CustomColors.transparent!,
                  iconSize: Dimens.space15,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space3.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${agent == "" ? "Undefine" : agent} called ${(callLog!.recentConversationNodes!.clientInfo != null && callLog!.recentConversationNodes!.clientInfo!.name != null) ? callLog!.recentConversationNodes!.clientInfo!.name : callLog!.recentConversationNodes!.clientNumber}",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          );
        }
      }
    }
  }
}
