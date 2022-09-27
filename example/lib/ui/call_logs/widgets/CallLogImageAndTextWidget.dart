import "package:easy_localization/easy_localization.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
import "package:mvp/ui/call_logs/widgets/CallMessageVoiceMailWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/DateTimeTextWidget.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";

class CallLogImageAndTextWidget extends StatelessWidget {
  const CallLogImageAndTextWidget({
    Key? key,
    required this.callLog,
    required this.onPressed,
    required this.memberId,
    this.type,
  }) : super(key: key);

  final RecentConversationEdges? callLog;
  final Function onPressed;
  final CallType? type;
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    if (callLog != null) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: callLog!.check!
                ? CustomColors.mainBackgroundColor
                : Colors.transparent,
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h,
                Dimens.space20.w, Dimens.space10.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: Dimens.space48.w,
                height: Dimens.space48.w,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space48,
                  height: Dimens.space48,
                  containerAlignment: Alignment.bottomCenter,
                  iconUrl: CustomIcon.icon_profile,
                  iconColor: CustomColors.callInactiveColor,
                  iconSize: Dimens.space40,
                  boxDecorationColor: CustomColors.mainDividerColor,
                  imageUrl: callLog!.recentConversationNodes!.clientInfo != null
                      ? callLog!
                          .recentConversationNodes!.clientInfo!.profilePicture
                      : "",
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: Row(
                              children: [
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: RichText(
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color:
                                                  CustomColors.textPrimaryColor,
                                              fontFamily: callLog!
                                                          .recentConversationNodes!
                                                          .clientUnseenMsgCount ==
                                                      0
                                                  ? Config.manropeSemiBold
                                                  : Config.manropeExtraBold,
                                              fontSize: Dimens.space15.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                        text: Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : callLog!.recentConversationNodes!
                                                        .clientInfo !=
                                                    null
                                                ? (callLog!
                                                        .recentConversationNodes!
                                                        .clientInfo!
                                                        .name ??
                                                    callLog!
                                                        .recentConversationNodes!
                                                        .clientInfo!
                                                        .number)
                                                : callLog!
                                                    .recentConversationNodes!
                                                    .clientNumber,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space6.w,
                                    Dimens.space0.h,
                                    Dimens.space6.w,
                                    Dimens.space0.h,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder<String>(
                                    future: Utils.getFlagUrl(callLog!
                                        .recentConversationNodes!
                                        .clientNumber!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return RoundedNetworkImageHolder(
                                          width: Dimens.space14,
                                          height: Dimens.space14,
                                          boxFit: BoxFit.contain,
                                          containerAlignment:
                                              Alignment.bottomCenter,
                                          iconUrl: CustomIcon.icon_gallery,
                                          iconColor: CustomColors.grey,
                                          iconSize: Dimens.space14,
                                          boxDecorationColor:
                                              CustomColors.mainBackgroundColor,
                                          outerCorner: Dimens.space0,
                                          innerCorner: Dimens.space0,
                                          imageUrl:
                                              PSApp.config!.countryLogoUrl! +
                                                  snapshot.data!,
                                        );
                                      }
                                      return const CupertinoActivityIndicator();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                    child: Offstage(
                                      offstage: callLog!
                                                      .recentConversationNodes!
                                                      .contactPinned !=
                                                  null &&
                                              callLog!.recentConversationNodes!
                                                  .contactPinned!
                                          ? false
                                          : true,
                                      child: RoundedNetworkImageHolder(
                                        width: Dimens.space18,
                                        height: Dimens.space18,
                                        iconUrl: CustomIcon.icon_pin,
                                        iconColor: CustomColors.warningColor,
                                        iconSize: Dimens.space12,
                                        outerCorner: Dimens.space0,
                                        innerCorner: Dimens.space0,
                                        boxDecorationColor:
                                            CustomColors.transparent,
                                        imageUrl: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: DateTimeTextWidget(
                                      timestamp: callLog!
                                          .recentConversationNodes!.createdAt!,
                                      date: callLog!
                                          .recentConversationNodes!.createdAt!,
                                      format: DateFormat(
                                          "yyyy-MM-ddThh:mm:ss.SSSSSS"),
                                      dateFontColor: callLog!
                                                  .recentConversationNodes!
                                                  .clientUnseenMsgCount! ==
                                              0
                                          ? CustomColors.textQuinaryColor!
                                          : CustomColors.textTertiaryColor!,
                                      dateFontFamily: Config.manropeSemiBold,
                                      dateFontSize: Dimens.space13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: CallMessageVoiceMailWidget(
                                  callLog: callLog,
                                  type: type,
                                  agent: callLog?.recentConversationNodes
                                              ?.agentInfo?.agentId ==
                                          null
                                      ? ""
                                      : callLog?.recentConversationNodes
                                                  ?.agentInfo?.agentId ==
                                              memberId
                                          ? "You"
                                          : callLog?.recentConversationNodes
                                                  ?.agentInfo?.firstname ??
                                              ""),
                            ),
                          ),
                          Offstage(
                            offstage:
                                !(callLog!.recentConversationNodes!
                                            .clientInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!
                                            .clientInfo!.dndInfo !=
                                        null &&
                                    callLog!.recentConversationNodes!
                                            .clientInfo!.dndInfo!.dndEnabled !=
                                        null &&
                                    callLog!.recentConversationNodes!
                                        .clientInfo!.dndInfo!.dndEnabled!),
                            child: Container(
                              width: Dimens.space20.w,
                              height: Dimens.space16.w,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space8.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.centerRight,
                              child: Icon(CustomIcon.icon_client_dnd,
                                  size: Dimens.space16,
                                  color: CustomColors.textQuinaryColor),
                            ),
                          ),
                          if (callLog!.recentConversationNodes!
                                  .clientUnseenMsgCount ==
                              0)
                            Container()
                          else
                            Container(
                              width: Dimens.space10.w,
                              height: Dimens.space10.w,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space8.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: CustomColors.textPrimaryErrorColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            onPressed();
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
