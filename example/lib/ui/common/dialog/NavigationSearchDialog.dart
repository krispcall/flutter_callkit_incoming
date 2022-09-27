import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/ui/call_logs/CallLogListItemView.dart";
import "package:mvp/ui/call_logs/ext/type_extension.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/indicator/CustomLinearProgressIndicator.dart";
import "package:mvp/ui/common/shimmer/CallLogShimmer.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:provider/provider.dart";

class NavigationSearchDialog extends StatefulWidget {
  const NavigationSearchDialog({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
  }) : super(key: key);

  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;

  @override
  NavigationSearchDialogState createState() => NavigationSearchDialogState();
}

class NavigationSearchDialogState extends State<NavigationSearchDialog>
    with SingleTickerProviderStateMixin {
  String query = "";
  AnimationController? animationController;

  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController? controllerSearch = TextEditingController();
  final _debouncer = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    callLogProvider = CallLogProvider(callLogRepository: callLogRepository);
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controllerSearch!.text.isNotEmpty) {
          callLogProvider!.doSearchGetCallLogsAndPinnedConversationLogsApiCall(
              "search", controllerSearch!.text);
        } else {
          callLogProvider!
              .doSearchGetCallLogsAndPinnedConversationLogsApiCall("all", "");
        }
      }
    });

    controllerSearch!.addListener(() {
      _debouncer.run(() {
        if (controllerSearch!.text.isNotEmpty) {
          callLogProvider!.doSearchGetCallLogsAndPinnedConversationLogsApiCall(
              "search", controllerSearch!.text);
        } else {
          callLogProvider!
              .doSearchGetCallLogsAndPinnedConversationLogsApiCall("all", "");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CallLogProvider>(
          lazy: false,
          create: (BuildContext context) {
            callLogProvider =
                CallLogProvider(callLogRepository: callLogRepository);
            callLogProvider!.doEmptyCallLogsOnChannelChanged();
            callLogProvider!
                .doSearchGetCallLogsAndPinnedConversationLogsApiCall("all", "");
            return callLogProvider!;
          },
        ),
      ],
      child: Consumer<CallLogProvider>(
        builder:
            (BuildContext context, CallLogProvider? provider, Widget? child) {
          return Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space22.h,
                Dimens.space0.w, Dimens.space0.h),
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: ScreenUtil().screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space16.r),
                topRight: Radius.circular(Dimens.space16.r),
              ),
              color: CustomColors.white,
            ),
            child: callLogProvider!.callLogs!.data == null
                ? Column(
                    children: [
                      const CallLogSearchShimmer(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            return const CallLogShimmer();
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space0.h,
                            Dimens.space16.w,
                            Dimens.space10.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        height: Dimens.space52.h,
                        child: TextField(
                          controller: controllerSearch,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.textSenaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space16.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            isDense: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.callInactiveColor!,
                                width: Dimens.space1.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space10.r),
                              ),
                            ),
                            filled: true,
                            fillColor: CustomColors.baseLightColor,
                            prefixIconConstraints: BoxConstraints(
                              minWidth: Dimens.space40.w,
                              maxWidth: Dimens.space40.w,
                              maxHeight: Dimens.space20.h,
                              minHeight: Dimens.space20.h,
                            ),
                            prefixIcon: Container(
                              alignment: Alignment.center,
                              width: Dimens.space20.w,
                              height: Dimens.space20.w,
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space15.w,
                                  Dimens.space0.h,
                                  Dimens.space10.w,
                                  Dimens.space0.h),
                              child: Icon(
                                CustomIcon.icon_search,
                                size: Dimens.space16.w,
                                color: CustomColors.textTertiaryColor,
                              ),
                            ),
                            hintText: Utils.getString("searchCallLog"),
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimens.space16.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (submittedQuery) async {
                            DeBouncer(milliseconds: 500).run(() async {
                              callLogProvider!
                                  .doSearchGetCallLogsAndPinnedConversationLogsApiCall(
                                      "search", controllerSearch!.text);
                            });
                          },
                        ),
                      ),
                      if (callLogProvider!.callLogs!.data!.isNotEmpty)
                        Expanded(
                          child: Container(
                            color: CustomColors.white,
                            alignment: Alignment.center,
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                RefreshIndicator(
                                  color: CustomColors.mainColor,
                                  backgroundColor: CustomColors.white,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount:
                                        callLogProvider!.callLogs!.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final int count = callLogProvider!
                                          .callLogs!.data!.length;
                                      animationController!.forward();
                                      return CallLogVerticalListItem(
                                        memberId:
                                            callLogProvider!.getMemberId(),
                                        containSlideable: false,
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        callLog: callLogProvider!
                                            .callLogs!.data![index],
                                        index: index,
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                            context,
                                            RoutePaths.messageDetail,
                                            arguments:
                                                MessageDetailIntentHolder(
                                              clientName: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientInfo !=
                                                      null
                                                  ? callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientInfo!
                                                      .name
                                                  : callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientNumber,
                                              clientPhoneNumber:
                                                  callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientNumber,
                                              clientProfilePicture: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientInfo !=
                                                      null
                                                  ? callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientInfo!
                                                      .profilePicture
                                                  : "",
                                              countryId: callLogProvider!
                                                  .callLogs!
                                                  .data![index]
                                                  .recentConversationNodes!
                                                  .clientCountry,
                                              isBlocked: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientInfo !=
                                                      null
                                                  ? callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientInfo!
                                                      .blocked
                                                  : false,
                                              lastChatted: callLogProvider!
                                                  .callLogs!
                                                  .data![index]
                                                  .recentConversationNodes!
                                                  .createdAt,
                                              channelId: callLogProvider!
                                                  .getDefaultChannel()
                                                  .id,
                                              channelName: callLogProvider!
                                                  .getDefaultChannel()
                                                  .name,
                                              channelNumber: callLogProvider!
                                                  .getDefaultChannel()
                                                  .number,
                                              clientId: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientInfo !=
                                                      null
                                                  ? callLogProvider!
                                                      .callLogs!
                                                      .data![index]
                                                      .recentConversationNodes!
                                                      .clientInfo!
                                                      .id
                                                  : null,
                                              // dndMissed: callLogProvider
                                              //             .callLogs
                                              //             .data[index]
                                              //             .recentConversationNodes
                                              //             .personalizedInfo !=
                                              //         null
                                              //     ? callLogProvider
                                              //         .callLogs
                                              //         .data[index]
                                              //         .recentConversationNodes
                                              //         .personalizedInfo
                                              //         .dndMissed
                                              //     : false,
                                              isContact: callLogProvider!
                                                          .callLogs!
                                                          .data![index]
                                                          .recentConversationNodes!
                                                          .clientInfo !=
                                                      null
                                                  ? true
                                                  : false,
                                              onIncomingTap: () {
                                                widget.onIncomingTap!();
                                              },
                                              onOutgoingTap: () {
                                                widget.onOutgoingTap!();
                                              },
                                              makeCallWithSid: (channelNumber,
                                                  channelName,
                                                  channelSid,
                                                  outgoingNumber,
                                                  workspaceSid,
                                                  memberId,
                                                  voiceToken,
                                                  outgoingName,
                                                  outgoingId,
                                                  outgoingProfilePicture) {
                                                widget.makeCallWithSid(
                                                  channelNumber!,
                                                  channelName!,
                                                  channelSid!,
                                                  outgoingNumber!,
                                                  workspaceSid!,
                                                  memberId!,
                                                  voiceToken!,
                                                  outgoingName!,
                                                  outgoingId ?? "",
                                                  outgoingProfilePicture!,
                                                );
                                              },
                                              onContactBlocked: (bool value) {},
                                            ),
                                          );
                                        },
                                        onCallTap:
                                            (clientName, clientNumber) {},
                                        onPinTap:
                                            (contactNumber, value) async {},
                                        type: CallType.Missed,
                                        slidAbleController: null,
                                      );
                                    },
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                  ),
                                  onRefresh: () {
                                    controllerSearch!.clear();
                                    return callLogProvider!
                                        .doSearchGetCallLogsAndPinnedConversationLogsApiCall(
                                            "all", "");
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: CustomLinearProgressIndicator(
                                    callLogProvider!.callLogs!.status!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Center(
                            child: noSearchResult(context),
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
